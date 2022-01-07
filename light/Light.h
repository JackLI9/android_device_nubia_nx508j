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

#ifndef ANDROID_HARDWARE_LIGHT_V2_0_LIGHT_H
#define ANDROID_HARDWARE_LIGHT_V2_0_LIGHT_H

#include <android/hardware/light/2.0/ILight.h>
#include <hidl/Status.h>

#include <fstream>
#include <mutex>
#include <unordered_map>

/**
 * battery defs
 */

enum battery_status {
    BATTERY_UNKNOWN = 0,
    BATTERY_LOW,
    BATTERY_FREE,
    BATTERY_CHARGING,
    BATTERY_FULL,
};

namespace android {
namespace hardware {
namespace light {
namespace V2_0 {
namespace implementation {

struct Light : public ILight {
    Light(std::pair<std::ofstream, uint32_t>&& lcd_backlight,
          std::ofstream&& button_backlight,
          std::ofstream&& red_led,
          std::ofstream&& red_duty_pcts,
          std::ofstream&& red_start_idx,
          std::ofstream&& red_pause_lo,
          std::ofstream&& red_pause_hi,
          std::ofstream&& red_ramp_step_ms,
          std::ofstream&& red_blink,
          std::ofstream&& red_lut_flags,
          std::ofstream&& red_outn);

    // Methods from ::android::hardware::light::V2_0::ILight follow.
    Return<Status> setLight(Type type, const LightState& state) override;
    Return<void> getSupportedTypes(getSupportedTypes_cb _hidl_cb) override;

  private:
    void setAttentionLight(const LightState& state);
    void setBatteryLight(const LightState& state);
    void setButtonsBacklight(const LightState& state);
    void setLcdBacklight(const LightState& state);
    void setNotificationLight(const LightState& state);
    void setSpeakerBatteryLightLocked();
    void setSpeakerLightLocked(int event_source, const LightState& state);

    std::pair<std::ofstream, uint32_t> mLcdBacklight;
    std::ofstream mButtonBacklight;
    std::ofstream mRedLed;
    std::ofstream mRedDutyPcts;
    std::ofstream mRedStartIdx;
    std::ofstream mRedPauseLo;
    std::ofstream mRedPauseHi;
    std::ofstream mRedRampStepMs;
    std::ofstream mRedBlink;
    std::ofstream mRedLutFlags;
    std::ofstream mRedOutn;

    std::unordered_map<Type, std::function<void(const LightState&)>> mLights;
    std::mutex mLock;
};

}  // namespace implementation
}  // namespace V2_0
}  // namespace light
}  // namespace hardware
}  // namespace android

#endif  // ANDROID_HARDWARE_LIGHT_V2_0_LIGHT_H
