# Copyright (C) 2014 The Android Open Source Project
# Copyright (C) 2015 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Inherit proprietary blobs
$(call inherit-product, vendor/nubia/nx508j/nx508j-vendor.mk)

DEVICE_PATH := device/nubia/nx508j

# Overlay
DEVICE_PACKAGE_OVERLAYS += \
    $(DEVICE_PATH)/overlay

# copy customized media_profiles and media_codecs xmls for 8994
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/configs/media_profiles.xml:system/etc/media_profiles.xml \
    $(DEVICE_PATH)/configs/media_codecs.xml:system/etc/media_codecs.xml \
    $(DEVICE_PATH)/configs/media_codecs_performance.xml:system/etc/media_codecs_performance.xml

PRODUCT_COPY_FILES += \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:system/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_telephony.xml:system/etc/media_codecs_google_telephony.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video.xml:system/etc/media_codecs_google_video.xml

# Audio configuration file
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/audio/aanc_tuning_mixer.txt:system/etc/aanc_tuning_mixer.txt \
    $(DEVICE_PATH)/audio/audio_policy.conf:system/etc/audio_policy.conf \
    $(DEVICE_PATH)/audio/audio_output_policy.conf:system/vendor/etc/audio_output_policy.conf \
    $(DEVICE_PATH)/audio/audio_effects.conf:system/vendor/etc/audio_effects.conf \
    $(DEVICE_PATH)/configs/mixer_paths.xml:system/etc/mixer_paths.xml \
    $(DEVICE_PATH)/configs/mixer_paths_i2s.xml:system/etc/mixer_paths_i2s.xml \
    $(DEVICE_PATH)/audio/sound_trigger_mixer_paths.xml:system/etc/sound_trigger_mixer_paths.xml \
    $(DEVICE_PATH)/audio/sound_trigger_platform_info.xml:system/etc/sound_trigger_platform_info.xml \
    $(DEVICE_PATH)/audio/audio_platform_info.xml:system/etc/audio_platform_info.xml \
    $(DEVICE_PATH)/audio/audio_platform_info_i2s.xml:system/etc/audio_platform_info_i2s.xml \
    $(DEVICE_PATH)/audio/listen_platform_info.xml:system/etc/listen_platform_info.xml

#PRODUCT_COPY_FILES += \
#    $(DEVICE_PATH)/audio/audio_policy_configuration.xml:system/etc/audio_policy_configuration.xml \
#    frameworks/av/services/audiopolicy/config/a2dp_audio_policy_configuration.xml:/system/etc/a2dp_audio_policy_configuration.xml \
#    frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:/system/etc/audio_policy_volumes.xml \
#    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:/system/etc/default_volume_tables.xml \
#    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:/system/etc/r_submix_audio_policy_configuration.xml \
#    frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:/system/etc/usb_audio_policy_configuration.xml

# Misc. libs
PRODUCT_PACKAGES += \
    libstlport \
    libboringssl-compat

# Camera
PRODUCT_PACKAGES += \
    Snap \
    libshim_camera \
    libshim_mmcamera2

PRODUCT_COPY_FILES += \
    external/ant-wireless/antradio-library/com.dsi.ant.antradio_library.xml:system/etc/permissions/com.dsi.ant.antradio_library.xml \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:system/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:system/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.camera.full.xml:system/etc/permissions/android.hardware.camera.full.xml\
    frameworks/native/data/etc/android.hardware.camera.raw.xml:system/etc/permissions/android.hardware.camera.raw.xml\
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:system/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.hardware.telephony.cdma.xml:system/etc/permissions/android.hardware.telephony.cdma.xml \
    frameworks/native/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml \
    frameworks/native/data/etc/handheld_core_hardware.xml:system/etc/permissions/handheld_core_hardware.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:system/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:system/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:system/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.audio.low_latency.xml:system/etc/permissions/android.hardware.audio.low_latency.xml

# vulkan
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.vulkan.level-0.xml:system/etc/permissions/android.hardware.vulkan.level.xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_0_3.xml:system/etc/permissions/android.hardware.vulkan.version.xml \
    frameworks/native/data/etc/android.hardware.vr.high_performance.xml:system/etc/permissions/android.hardware.vr.high_performance.xml

# MSM IRQ Balancer configuration file
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/configs/msm_irqbalance.conf:system/vendor/etc/msm_irqbalance.conf \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:system/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:system/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:system/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:system/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.barometer.xml:system/etc/permissions/android.hardware.sensor.barometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:system/etc/permissions/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:system/etc/permissions/android.hardware.sensor.stepdetector.xml \
    frameworks/native/data/etc/android.hardware.sensor.ambient_temperature.xml:system/etc/permissions/android.hardware.sensor.ambient_temperature.xml \
    frameworks/native/data/etc/android.hardware.sensor.relative_humidity.xml:system/etc/permissions/android.hardware.sensor.relative_humidity.xml

# gps/location secuity configuration file
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/configs/sec_config:system/etc/sec_config

#FEATURE_OPENGLES_EXTENSION_PACK support string config file
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:system/etc/permissions/android.hardware.opengles.aep.xml

# Qualcomm
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/configs/data/dsi_config.xml:system/etc/data/dsi_config.xml \
    $(DEVICE_PATH)/configs/data/netmgr_config.xml:system/etc/data/netmgr_config.xml \
    $(DEVICE_PATH)/configs/data/qmi_config.xml:system/etc/data/qmi_config.xml

# Dolby
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/configs/dolby/ds1-default.xml:system/vendor/etc/dolby/ds1-default.xml

# Keylayout
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/keylayout/gpio-keys.kl:system/usr/keylayout/gpio-keys.kl \
    $(DEVICE_PATH)/keylayout/qpnp_pon.kl:system/usr/keylayout/qpnp_pon.kl

# Haters gonna hate..
PRODUCT_CHARACTERISTICS := nosdcard

#ANT+ stack
PRODUCT_PACKAGES += \
    AntHalService \
    com.dsi.ant.antradio_library \
    libantradio

# Audio
PRODUCT_PACKAGES += \
    audiod \
    audio.a2dp.default \
    audio.usb.default \
    audio.r_submix.default \
    audio_policy.default \
    tinymix \
    tinypcminfo \
    tinycap \

#PRODUCT_BOOT_JARS += \
    qcmediaplayer \
    tcmiface \
    extendedmediaextractor \
    dolby_ds

# Qualcomm dependencies
PRODUCT_PACKAGES += \
    libtinyalsa \
    libtinycompress \
    libtinyxml \
    libaudioroute \
    libaudioutils \
    libaudio-resampler \
    libqcomvisualizer \
    libqcomvoiceprocessing \
    libqcompostprocbundle

PRODUCT_PACKAGES += \
    com.android.nfc_extras \
    nfc_nci.bcm2079x.default \
    NfcNci \
    Tag

# Bson
PRODUCT_PACKAGES += \
    libbson \
    libsecureui \
    libmdtp

# Connectivity Engine support
PRODUCT_PACKAGES += \
    cneapiclient \
    com.quicinc.cne \
    libcnefeatureconfig \
    services-ext
    
# Curl
PRODUCT_PACKAGES += \
    libcurl \
    curl

# Filesystem management tools
PRODUCT_PACKAGES += \
    e2fsck \
    make_ext4fs \
    setup_fs

# For android_filesystem_config.h
PRODUCT_PACKAGES += \
    fs_config_files

# Encryption
PRODUCT_PACKAGES += \
    libcryptfs_hw

# GPS
PRODUCT_PACKAGES += \
    libgps.utils \
    gps.msm8994 \
    flp.conf \
    gps.conf \
    izat.conf \
    lowi.conf \
    quipc.conf \
    sap.conf \
    xtwifi.conf

# Graphics
PRODUCT_PACKAGES += \
    copybit.msm8994 \
    gralloc.msm8994 \
    hwcomposer.msm8994 \
    liboverlay \
    libqdutils \
    libqdMetaData \
    memtrack.msm8994

# Doze mode
PRODUCT_PACKAGES += \
    NubiaDoze

# Init scripts
PRODUCT_PACKAGES += \
    init.target.rc \
    init.qcom.bt.sh \
    init.qcom.early_boot.sh \
    init.qcom.post_boot.sh \
    init.qcom.rc \
    init.qcom.sh \
    init.class_main.sh \
    vold.fstab \
    init.qcom.usb.rc \
    init.qcom.usb.sh \
    ueventd.qcom.rc \
    fstab.qcom \
    init.recovery.qcom.rc \
    tp_node.sh \
    atmel_ts.sh \
    init.qcom.uicc.sh \
    init.project.rc \
    init.recovery.vold_decrypt.rc \
    init.nx508j.power.sh \
    init.environ.rc \
    usf_post_boot.sh \
    usf_settings.sh \
    init.qcom.power.rc

# IPv6
PRODUCT_PACKAGES += \
    ebtables \
    ethertypes \
    libebtc

# Keystore
PRODUCT_PACKAGES += \
    keystore.default

# Lights
PRODUCT_PACKAGES += \
    lights.msm8994

# LiveDisplay native
PRODUCT_PACKAGES += \
    libjni_livedisplay

# Media
PRODUCT_PACKAGES += \
    libmm-omxcore \
    libc2dcolorconvert \
    libdashplayer \
    libextmedia_jni \
    libOmxAacEnc \
    libOmxAmrEnc \
    libOmxCore \
    libOmxEvrcEnc \
    libOmxQcelp13Enc \
    libOmxSwVencMpeg4 \
    libOmxSwVencHevc \
    libOmxVdec \
    libOmxVdecHevc \
    libOmxVenc \
    libOmxVidcCommon \
    libstagefrighthw \
    libstagefright_soft_flacdec

# Power
PRODUCT_PACKAGES += \
    power.msm8994

# RIL
PRODUCT_PACKAGES += \
    librmnetctl \
    libxml2 \
    libshim_ims \
    libshim_ril

# VR
PRODUCT_PACKAGES += \
    vr.msm8994

# USB
PRODUCT_PACKAGES += \
    com.android.future.usb.accessory

# Wifi
PRODUCT_PACKAGES += \
    ipacm \
    ipacm-diag \
    IPACM_cfg.xml \
    hostapd \
    libwpa_client \
    wpa_supplicant \
    wpa_supplicant.conf

PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/wifi/hostapd.accept:system/etc/hostapd/hostapd.accept \
    $(DEVICE_PATH)/wifi/hostapd.conf:system/etc/hostapd/hostapd_default.conf \
    $(DEVICE_PATH)/wifi/hostapd.deny:system/etc/hostapd/hostapd.deny \
    $(DEVICE_PATH)/wifi/p2p_supplicant_overlay.conf:system/etc/wifi/p2p_supplicant_overlay.conf \
    $(DEVICE_PATH)/wifi/wpa_supplicant_overlay.conf:system/etc/wifi/wpa_supplicant_overlay.conf

PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/wifi/WCNSS_cfg.dat:system/etc/wifi/WCNSS_cfg.dat \
    $(DEVICE_PATH)/wifi/WCNSS_qcom_cfg.ini:system/etc/wifi/WCNSS_qcom_cfg.ini \
    $(DEVICE_PATH)/wifi/WCNSS_qcom_wlan_nv.bin:system/etc/wifi/WCNSS_qcom_wlan_nv.bin

