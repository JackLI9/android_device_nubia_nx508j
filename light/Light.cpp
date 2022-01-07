/*
 * Copyright (C) 2018 The LineageOS Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#define LOG_TAG "LightService"

#include "Light.h"

#include <android-base/logging.h>

#define PM_PWM_LUT_LOOP			0x01
#define PM_PWM_LUT_RAMP_UP		0x02
#define PM_PWM_LUT_REVERSE		0x04
#define PM_PWM_LUT_PAUSE_HI_EN		0x08
#define PM_PWM_LUT_PAUSE_LO_EN		0x10

#define PM_PWM_LUT_NO_TABLE		0x20
#define PM_PWM_LUT_USE_RAW_VALUE	0x40

#define BREATH_LED_BRIGHTNESS_NOTIFICATION	"0,5,10,15,20,26,31,36,41,46,51,56,61,66,71,77,82,87,92,97,102,107,112,117,122,128,133,138,143,148,153,158,163,168,173,179,184,189,194,199,204,209,214,219,224,230,235,240,245,250,255"
//#define BREATH_LED_BRIGHTNESS_BUTTONS		"0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60"
#define BREATH_LED_BRIGHTNESS_BATTERY		"0,50"
#define BREATH_LED_BRIGHTNESS_CHARGING		"20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60"
#define BREATH_LED_BRIGHTNESS_BUTTONS		"0,15,25,35,55"

#define BREATH_SOURCE_NOTIFICATION	0x01
#define BREATH_SOURCE_BATTERY		0x02
#define BREATH_SOURCE_BUTTONS		0x04
#define BREATH_SOURCE_ATTENTION		0x08
#define BREATH_SOURCE_NONE		0xFF

// Battery
#define BATTERY_CAPACITY "/sys/class/power_supply/battery/capacity"
#define BATTERY_CHARGING_STATUS "/sys/class/power_supply/battery/status"

static int active_states = 0;

static int last_state = BREATH_SOURCE_NONE;

static int initialized = 0;

namespace {
using android::hardware::light::V2_0::LightState;

static constexpr int DEFAULT_MAX_BRIGHTNESS = 255;

static uint32_t rgbToBrightness(const LightState& state) {
    uint32_t color = state.color & 0x00ffffff;
    return ((77 * ((color >> 16) & 0xff)) + (150 * ((color >> 8) & 0xff)) +
            (29 * (color & 0xff))) >> 8;
}

static int readStr(std::string path, char *buffer, size_t size)
{

    std::ifstream file(path);

    if (!file.is_open()) {
        LOG(ERROR) << "Failed to read: " << path.c_str() << std::endl;
        return -1;
    }

    file.read(buffer, size);
    file.close();
    return 1;
}

static int getBatteryStatus(void)
{
    int err, capacity;
    char capacity_buff[6];
    char status_buff[16];

    err = readStr(BATTERY_CHARGING_STATUS, status_buff, sizeof(status_buff));
    if (err < 0) {
        LOG(ERROR) << "Failed to read battery status: " << err << std::endl;
        return BATTERY_UNKNOWN;
    }

    err = readStr(BATTERY_CAPACITY, capacity_buff, sizeof(capacity_buff));
    if (err < 0) {
        LOG(ERROR) << "Failed to read battery capacity: " << err << std::endl;
        return BATTERY_UNKNOWN;
    }

    capacity = atoi(capacity_buff);

    if (strncmp(status_buff, "Charging", 8) == 0) {
        if (capacity < 90) { // see batteryService.java:978
            return BATTERY_CHARGING;
        } else {
            return BATTERY_FULL;
        }
    } else {
        if (capacity <= 15) {
            return BATTERY_LOW;
        } else {
            return BATTERY_FREE;
        }
    }
}  // getBatteryStatus
}  // anonymous namespace

namespace android {
namespace hardware {
namespace light {
namespace V2_0 {
namespace implementation {

Light::Light(std::pair<std::ofstream, uint32_t>&& lcd_backlight,
             std::ofstream&& button_backlight,
             std::ofstream&& red_led,
             std::ofstream&& red_duty_pcts,
             std::ofstream&& red_start_idx,
             std::ofstream&& red_pause_lo,
             std::ofstream&& red_pause_hi,
             std::ofstream&& red_ramp_step_ms,
             std::ofstream&& red_blink,
             std::ofstream&& red_lut_flags,
             std::ofstream&& red_outn)
    : mLcdBacklight(std::move(lcd_backlight)),
      mButtonBacklight(std::move(button_backlight)),
      mRedLed(std::move(red_led)),
      mRedDutyPcts(std::move(red_duty_pcts)),
      mRedStartIdx(std::move(red_start_idx)),
      mRedPauseLo(std::move(red_pause_lo)),
      mRedPauseHi(std::move(red_pause_hi)),
      mRedRampStepMs(std::move(red_ramp_step_ms)),
      mRedBlink(std::move(red_blink)),
      mRedLutFlags(std::move(red_lut_flags)),
      mRedOutn(std::move(red_outn)) {
    auto attnFn(std::bind(&Light::setAttentionLight, this, std::placeholders::_1));
    auto backlightFn(std::bind(&Light::setLcdBacklight, this, std::placeholders::_1));
    auto batteryFn(std::bind(&Light::setBatteryLight, this, std::placeholders::_1));
    auto buttonsFn(std::bind(&Light::setButtonsBacklight, this, std::placeholders::_1));
    auto notifFn(std::bind(&Light::setNotificationLight, this, std::placeholders::_1));
    mLights.emplace(std::make_pair(Type::ATTENTION, attnFn));
    mLights.emplace(std::make_pair(Type::BACKLIGHT, backlightFn));
    mLights.emplace(std::make_pair(Type::BATTERY, batteryFn));
    mLights.emplace(std::make_pair(Type::BUTTONS, buttonsFn));
    mLights.emplace(std::make_pair(Type::NOTIFICATIONS, notifFn));
}

// Methods from ::android::hardware::light::V2_0::ILight follow.
Return<Status> Light::setLight(Type type, const LightState& state) {
    auto it = mLights.find(type);

    if (it == mLights.end()) {
        return Status::LIGHT_NOT_SUPPORTED;
    }

    it->second(state);

    return Status::SUCCESS;
}

Return<void> Light::getSupportedTypes(getSupportedTypes_cb _hidl_cb) {
    std::vector<Type> types;

    for (auto const& light : mLights) {
        types.push_back(light.first);
    }

    _hidl_cb(types);

    return Void();
}

void Light::setLcdBacklight(const LightState& state) {
    std::lock_guard<std::mutex> lock(mLock);

    uint32_t brightness = rgbToBrightness(state);

    // If max panel brightness is not the default (255),
    // apply linear scaling across the accepted range.
    if (mLcdBacklight.second != DEFAULT_MAX_BRIGHTNESS) {
        int old_brightness = brightness;
        brightness = brightness * mLcdBacklight.second / DEFAULT_MAX_BRIGHTNESS;
        LOG(VERBOSE) << "Scaling brightness " << old_brightness << " => " << brightness;
    }

    mLcdBacklight.first << brightness << std::endl;
}

void Light::setAttentionLight(const LightState& state) {
    std::lock_guard<std::mutex> lock(mLock);
    setSpeakerLightLocked(BREATH_SOURCE_ATTENTION, state);
}

void Light::setButtonsBacklight(const LightState& state) {
    std::lock_guard<std::mutex> lock(mLock);
    int brightness = rgbToBrightness(state);
    setSpeakerLightLocked(BREATH_SOURCE_BUTTONS, state);
    mButtonBacklight << (int)(brightness ? 6 : 2) << std::endl;
}

void Light::setBatteryLight(const LightState& state) {
    std::lock_guard<std::mutex> lock(mLock);
    setSpeakerLightLocked(BREATH_SOURCE_BATTERY, state);
}

void Light::setNotificationLight(const LightState& state) {
    std::lock_guard<std::mutex> lock(mLock);
    setSpeakerLightLocked(BREATH_SOURCE_NOTIFICATION, state);
}

void Light::setSpeakerLightLocked(int event_source, const LightState& state) {
    int brightness, blink, onMs, offMs;
    int lut_flags = 0;
    int battery_status = BATTERY_UNKNOWN;
    std::string light_template;
    std::string RampStepMs;

    brightness = rgbToBrightness(state);

    if (brightness > 0) {
        active_states |= event_source;
    } else {
        active_states &= ~event_source;
        if (active_states == 0) {
            LOG(VERBOSE) << "Disabling buttons backlight" << std::endl;
            mRedLutFlags << (int)PM_PWM_LUT_NO_TABLE << std::endl; // smoothly turn led off
            last_state = BREATH_SOURCE_NONE;
            return;
        }
    }

    if (last_state < event_source) {
        return;
    }

    switch (state.flashMode) {
        case Flash::TIMED:
            onMs = state.flashOnMs;
            offMs = state.flashOffMs;
            break;
        case Flash::NONE:
        default:
            onMs = 0;
            offMs = 0;
            break;
    }
    blink = (onMs > 0) && (offMs > 0);

    if (active_states & BREATH_SOURCE_NOTIFICATION) {
        light_template = BREATH_LED_BRIGHTNESS_NOTIFICATION;
        lut_flags = PM_PWM_LUT_RAMP_UP;
        if (blink) {
            RampStepMs = "20";
            lut_flags |= PM_PWM_LUT_LOOP|PM_PWM_LUT_REVERSE|PM_PWM_LUT_PAUSE_HI_EN|PM_PWM_LUT_PAUSE_LO_EN;
        }
        last_state = BREATH_SOURCE_NOTIFICATION;
    } else if (active_states & BREATH_SOURCE_ATTENTION) {
        light_template = BREATH_LED_BRIGHTNESS_NOTIFICATION;
        lut_flags = PM_PWM_LUT_RAMP_UP;
        if (blink) {
            RampStepMs = "20";
            lut_flags |= PM_PWM_LUT_LOOP|PM_PWM_LUT_REVERSE|PM_PWM_LUT_PAUSE_HI_EN|PM_PWM_LUT_PAUSE_LO_EN;
        }
        last_state = BREATH_SOURCE_ATTENTION;
    } else if (active_states & BREATH_SOURCE_BATTERY) {
        battery_status = getBatteryStatus();
        if (battery_status == BATTERY_LOW) {
            // battery low
            RampStepMs = "50";
            light_template = BREATH_LED_BRIGHTNESS_BATTERY;
            lut_flags = PM_PWM_LUT_LOOP|PM_PWM_LUT_RAMP_UP|PM_PWM_LUT_REVERSE|PM_PWM_LUT_PAUSE_HI_EN|PM_PWM_LUT_PAUSE_LO_EN;
            onMs = 300;
            offMs = 1500;
        } else if (battery_status == BATTERY_CHARGING) {
            // battery chagring
            RampStepMs = "0";
            light_template = BREATH_LED_BRIGHTNESS_CHARGING;
            lut_flags = PM_PWM_LUT_LOOP|PM_PWM_LUT_RAMP_UP|PM_PWM_LUT_REVERSE|PM_PWM_LUT_PAUSE_HI_EN|PM_PWM_LUT_PAUSE_LO_EN;
            onMs = 500;
            offMs = 500;
        } else if (battery_status == BATTERY_FULL) {
            // battery full
            light_template = "0";
            RampStepMs = "0";
            lut_flags = PM_PWM_LUT_NO_TABLE;
            onMs = 0;
            offMs = 0;
        }
        last_state = BREATH_SOURCE_BATTERY;
    } else if (active_states & BREATH_SOURCE_BUTTONS) {
        if (last_state == BREATH_SOURCE_BUTTONS) {
            return;
        }
        light_template = BREATH_LED_BRIGHTNESS_BUTTONS;
        lut_flags = PM_PWM_LUT_RAMP_UP;
        last_state = BREATH_SOURCE_BUTTONS;
    } else {
        last_state = BREATH_SOURCE_NONE;
        LOG(VERBOSE) << "Unknown state" << std::endl;
        return;
    }

    if (!initialized) {
        initialized = 1;
        mRedLutFlags << "8" << std::endl;
        mButtonBacklight << "0" << std::endl;
        mRedLed << "255" << std::endl;
    }

    mRedDutyPcts << light_template << std::endl;
    mRedRampStepMs << RampStepMs << std::endl;
    if (offMs > 0)
        mRedPauseLo << std::to_string(offMs) << std::endl;
    if (onMs > 0)
        mRedPauseHi << std::to_string(onMs) << std::endl;
    mRedLutFlags << std::to_string(lut_flags) << std::endl;

}  //Light::setSpeakerLightLocked
}  // namespace implementation
}  // namespace V2_0
}  // namespace light
}  // namespace hardware
}  // namespace android
