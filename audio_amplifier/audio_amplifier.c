/*
 * Copyright (C) 2015-2016 The CyanogenMod Project
 *           (C) 2017-2018 The LineageOS Project
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


#include <time.h>
#include <system/audio.h>
#include <platform.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <ctype.h>
#include <dlfcn.h>
#include <sys/ioctl.h>
#include <tinyalsa/asoundlib.h>

#define LOG_TAG "nx508j-tfa98xx"
#include <log/log.h>

#include <hardware/audio_amplifier.h>

typedef struct tfa9890_device {
    amplifier_device_t amp_dev;
    void *lib_ptr;
    struct mixer *mixer;
    int (*init)(void);
    int (*setSamplerate)(int);
    int (*manual_calibrate)(void);
    int (*eq_set)(int);
    int (*sepakeron)(void);
    int (*sepakeroff)(void);
} tfa9890_device_t;

static tfa9890_device_t *tfa9890_dev = NULL;

#define SAMPLE_RATE 48000

#define SND_CARD        0
#define AMP_MIXER_CTL   "Smart PA Init Switch"
#define AMP_MIXER_CTL_I2S "PORT2 Sync Domain"

static struct mixer *mixer_new(void)
{
    struct mixer *card_mixer;

    if ((card_mixer = mixer_open(SND_CARD)) == NULL) {
        ALOGE("failed to open mixer");
        return NULL;
    }

    return card_mixer;
}

static int amp_clocks_on(struct mixer *mixer)
{
    struct mixer_ctl *ctl;

    if ((ctl = mixer_get_ctl_by_name(mixer, AMP_MIXER_CTL)) != NULL) {
        if (mixer_ctl_set_enum_by_string(ctl, "On") < 0) {
            ALOGE("%s: Could not set enum %s", __func__, AMP_MIXER_CTL);
            return -EBUSY;
        }
        if ((ctl = mixer_get_ctl_by_name(mixer, AMP_MIXER_CTL_I2S)) != NULL)
        {
            if (mixer_ctl_set_enum_by_string(ctl, "aif2") < 0) {
                ALOGE("%s: Could not set enum %s", __func__, AMP_MIXER_CTL_I2S);
                return -EBUSY;
            }
        }
        ALOGV("%s: clocks: ON", __func__);
        return 0;
    }
    return -EBUSY;
}

static int amp_clocks_off(struct mixer *mixer)
{
    struct mixer_ctl *ctl;

    ctl = mixer_get_ctl_by_name(mixer, AMP_MIXER_CTL);
    if (ctl == NULL) {
        ALOGE("%s: Could not find %s", __func__, AMP_MIXER_CTL);
        return -ENODEV;
    } else {
        mixer_ctl_set_value(ctl, 0, 0);
        mixer_ctl_set_enum_by_string(ctl, "Off");
    }

    ALOGV("clocks: OFF");
    return 0;
}

static int is_speaker(uint32_t snd_device) {
    int speaker = 0;

    switch (snd_device) {
        case SND_DEVICE_OUT_SPEAKER:
        case SND_DEVICE_OUT_SPEAKER_REVERSE:
        case SND_DEVICE_OUT_SPEAKER_AND_HEADPHONES:
        case SND_DEVICE_OUT_VOICE_SPEAKER:
        case SND_DEVICE_OUT_SPEAKER_AND_HDMI:
        case SND_DEVICE_OUT_SPEAKER_AND_USB_HEADSET:
        case SND_DEVICE_OUT_SPEAKER_AND_ANC_HEADSET:
            speaker = 1;
            break;
    }

    return speaker;
}

static int is_voice_speaker(uint32_t snd_device) {
    return snd_device == SND_DEVICE_OUT_VOICE_SPEAKER;
}

static int amp_enable_output_devices(amplifier_device_t *device, uint32_t devices, bool enable) {
    tfa9890_device_t *tfa9890 = (tfa9890_device_t*) device;

    if (is_speaker(devices)) {
        amp_clocks_on(tfa9890->mixer);
        if (enable) {
            tfa9890->sepakeron();
            if (is_voice_speaker(devices)) {
                tfa9890->eq_set(1);
            } else {
                tfa9890->eq_set(0);
            }
        } else {
            tfa9890->sepakeroff();
        }
        amp_clocks_off(tfa9890->mixer);
    }
    return 0;
}

static int amp_dev_close(hw_device_t *device) {
    tfa9890_device_t *tfa9890 = (tfa9890_device_t*) device;

    if (tfa9890) {
        dlclose(tfa9890->lib_ptr);
        free(tfa9890);
    }

    return 0;
}

static int amp_init(tfa9890_device_t *tfa9890) {
    if (amp_clocks_on(tfa9890->mixer) < 0) {
        return -ENODEV;
    }
    usleep(20000);
    tfa9890->setSamplerate(SAMPLE_RATE);
    tfa9890->init();
    ALOGI("Init successful: %s", __func__);
    amp_clocks_off(tfa9890->mixer);
    return 0;
}

static int amp_module_open(const hw_module_t *module,
        __attribute__((unused)) const char *name, hw_device_t **device)
{
    if (tfa9890_dev) {
        ALOGE("%s:%d: Unable to open second instance of TFA9890 amplifier\n",
                __func__, __LINE__);
        return -EBUSY;
    }

    tfa9890_dev = calloc(1, sizeof(tfa9890_device_t));
    if (!tfa9890_dev) {
        ALOGE("%s:%d: Unable to allocate memory for amplifier device\n",
                __func__, __LINE__);
        return -ENOMEM;
    }

    tfa9890_dev->amp_dev.common.tag = HARDWARE_DEVICE_TAG;
    tfa9890_dev->amp_dev.common.module = (hw_module_t *) module;
    tfa9890_dev->amp_dev.common.version = HARDWARE_DEVICE_API_VERSION(1, 0);
    tfa9890_dev->amp_dev.common.close = amp_dev_close;

    tfa9890_dev->amp_dev.enable_output_devices = &amp_enable_output_devices;

    tfa9890_dev->lib_ptr = dlopen("libtfa9890_interface.so", RTLD_NOW);
    if (!tfa9890_dev->lib_ptr) {
        ALOGE("%s:%d: Unable to open libtfa9890_interface: %s",
                __func__, __LINE__, dlerror());
        free(tfa9890_dev);
        return -ENODEV;
    }

    tfa9890_dev->mixer = mixer_new();
    *(void **)&tfa9890_dev->init = dlsym(tfa9890_dev->lib_ptr, "tfa9890_init");
    *(void **)&tfa9890_dev->eq_set = dlsym(tfa9890_dev->lib_ptr, "tfa9890_EQset");
    *(void **)&tfa9890_dev->sepakeron = dlsym(tfa9890_dev->lib_ptr, "tfa9890_SpeakerOn");
    *(void **)&tfa9890_dev->sepakeroff = dlsym(tfa9890_dev->lib_ptr, "tfa9890_SpeakerOff");
    *(void **)&tfa9890_dev->setSamplerate = dlsym(tfa9890_dev->lib_ptr, "tfa9890_setSamplerate");

    if (!tfa9890_dev->init || !tfa9890_dev->eq_set || !tfa9890_dev->sepakeron || 
        !tfa9890_dev->setSamplerate || !tfa9890_dev->sepakeroff || !tfa9890_dev->mixer) {
        ALOGE("%s:%d: Unable to find required symbols", __func__, __LINE__);
        dlclose(tfa9890_dev->lib_ptr);
        free(tfa9890_dev);
        return -ENODEV;
    }

    if (amp_init(tfa9890_dev)) {
        dlclose(tfa9890_dev->lib_ptr);
        free(tfa9890_dev);
        return -ENODEV;
    }

    *device = (hw_device_t *) tfa9890_dev;

    return 0;
}

static struct hw_module_methods_t hal_module_methods = {
    .open = amp_module_open,
};

amplifier_module_t HAL_MODULE_INFO_SYM = {
    .common = {
        .tag = HARDWARE_MODULE_TAG,
        .module_api_version = AMPLIFIER_MODULE_API_VERSION_0_1,
        .hal_api_version = HARDWARE_HAL_API_VERSION,
        .id = AMPLIFIER_HARDWARE_MODULE_ID,
        .name = "NX508J amplifier HAL",
        .author = "The CyanogenMod Open Source Project",
        .methods = &hal_module_methods,
    },
};
