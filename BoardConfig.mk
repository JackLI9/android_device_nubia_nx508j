# Copyright (C) 2015 The CyanogenMod Project
# Copyright (C) 2017-2021 The LineageOS Project
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
#

# config.mk
#
# Product-specific compile-time definitions.
#

DEVICE_PATH := device/nubia/nx508j

BOARD_VENDOR := nubia

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := MSM8994
TARGET_NO_BOOTLOADER := true
TARGET_NO_RADIOIMAGE := true

# Platform
TARGET_BOARD_PLATFORM := msm8994
TARGET_BOARD_PLATFORM_GPU := qcom-adreno430

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := cortex-a53

# Second architecture
TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a53

TARGET_USES_64_BIT_BINDER := true

# Kernel
BOARD_KERNEL_CMDLINE := androidboot.hardware=qcom user_debug=31 msm_rtb.filter=0x37 ehci-hcd.park=3 lpm_levels.sleep_disabled=1 boot_cpus=0-3  loop.max_part=7 androidboot.selinux=permissive
BOARD_KERNEL_SEPARATED_DT := true
BOARD_KERNEL_BASE        := 0x00000000
BOARD_KERNEL_PAGESIZE    := 4096
BOARD_KERNEL_TAGS_OFFSET := 0x00000100
BOARD_RAMDISK_OFFSET := 0x02000000
BOARD_KERNEL_IMAGE_NAME := Image
TARGET_KERNEL_ARCH := arm64
TARGET_KERNEL_HEADER_ARCH := arm64
BOARD_DTBTOOL_ARGS := -2
TARGET_KERNEL_SOURCE := kernel/nubia/msm8994
TARGET_KERNEL_CONFIG := msm8994-NX508J_defconfig
LZMA_RAMDISK_TARGETS := recovery,boot

# Audio
# DOLBY_ENABLE := true
# USE_CUSTOM_AUDIO_POLICY := 1
# USE_XML_AUDIO_POLICY_CONF := 1
# DOLBY_UDC := true
# DS1_DOLBY_DAP := true
AUDIO_FEATURE_ENABLED_ACDB_LICENSE := true
AUDIO_FEATURE_ENABLED_COMPRESS_CAPTURE := true
AUDIO_FEATURE_ENABLED_COMPRESS_VOIP := true
AUDIO_FEATURE_ENABLED_DS2_DOLBY_DAP := false
AUDIO_FEATURE_ENABLED_DTS_EAGLE := false
AUDIO_FEATURE_ENABLED_EXTENDED_COMPRESS_FORMAT := true
AUDIO_FEATURE_ENABLED_EXTN_FORMATS := true
AUDIO_FEATURE_ENABLED_FLAC_OFFLOAD := true
AUDIO_FEATURE_ENABLED_FLUENCE := true
AUDIO_FEATURE_ENABLED_HFP := true
AUDIO_FEATURE_ENABLED_INCALL_MUSIC := false
AUDIO_FEATURE_ENABLED_KPI_OPTIMIZE := true
AUDIO_FEATURE_ENABLED_MULTI_VOICE_SESSIONS := true
AUDIO_FEATURE_ENABLED_PCM_OFFLOAD := true
AUDIO_FEATURE_ENABLED_PCM_OFFLOAD_24 := true
AUDIO_FEATURE_ENABLED_PROXY_DEVICE := true

AUDIO_USE_LL_AS_PRIMARY_OUTPUT := true
BOARD_SUPPORTS_SOUND_TRIGGER := true
BOARD_USES_ALSA_AUDIO := true
USE_CUSTOM_AUDIO_POLICY := 1
USE_XML_AUDIO_POLICY_CONF := 1

# Sound
# Lollipop Audio HAL is incompatible with Android M (see http://review.cyanogenmod.org/#/c/121831/)
TARGET_TINY_ALSA_IGNORE_SILENCE_SIZE := true
# BOARD_USES_TINY_ALSA_AUDIO := true

# FM
#QCOM_FM_ENABLED := true
#AUDIO_FEATURE_ENABLED_FM := true
AUDIO_FEATURE_ENABLED_FM_POWER_OPT := true

# Bluetooth
BOARD_HAVE_BLUETOOTH := true
BOARD_HAVE_BLUETOOTH_QCOM := true
BOARD_HAS_QCA_BT_ROME := true
QCOM_BT_USE_BTNV := true
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(DEVICE_PATH)/bluetooth
BOARD_BLUETOOTH_BDROID_HCILP_INCLUDED := false

# Camera
TARGET_PROCESS_SDK_VERSION_OVERRIDE := \
    /system/bin/cameraserver=22 \
    /system/bin/mediaserver=22 \
    /system/vendor/bin/mm-qcamera-daemon=22

# ANT+
BOARD_ANT_WIRELESS_DEVICE := "vfs-prerelease"

# Properties
TARGET_SYSTEM_PROP += $(DEVICE_PATH)/system.prop

# Charger
BOARD_CHARGER_ENABLE_SUSPEND := true
BOARD_CHARGER_DISABLE_INIT_BLANK := true

#Enable HW based full disk encryption
TARGET_HW_DISK_ENCRYPTION := true

# Fonts
EXTENDED_FONT_FOOTPRINT := true

# Filesystem
TARGET_FS_CONFIG_GEN := $(DEVICE_PATH)/config.fs

# Display
TARGET_SCREEN_DENSITY := 480

# Graphics
BOARD_USES_ADRENO := true
USE_OPENGL_RENDERER := true
TARGET_USES_ION := true
TARGET_USES_C2D_COMPOSITION := true
TARGET_USES_GRALLOC1_ADAPTER := true
TARGET_FORCE_HWC_FOR_VIRTUAL_DISPLAYS := true
MAX_VIRTUAL_DISPLAY_DIMENSION := 2048
TARGET_USES_HWC2 := true
VSYNC_EVENT_PHASE_OFFSET_NS := 2000000
SF_VSYNC_EVENT_PHASE_OFFSET_NS := 6000000
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3

BOARD_EGL_CFG := $(DEVICE_PATH)/configs/egl.cfg

# Shader cache config options
# Maximum size of the  GLES Shaders that can be cached for reuse.
# Increase the size if shaders of size greater than 12KB are used.
MAX_EGL_CACHE_KEY_SIZE := 12*1024

# Maximum GLES shader cache size for each app to store the compiled shader
# binaries. Decrease the size if RAM or Flash Storage size is a limitation
# of the device.
MAX_EGL_CACHE_SIZE := 2048*1024
HAVE_ADRENO_SOURCE:= false
OVERRIDE_RS_DRIVER:= libRSDriver_adreno.so

# DRM
TARGET_ENABLE_MEDIADRM_64 := true

# HIDL
DEVICE_MANIFEST_FILE := $(DEVICE_PATH)/manifest.xml
DEVICE_MATRIX_FILE := $(DEVICE_PATH)/compatibility_matrix.xml
PRODUCT_ENFORCE_VINTF_MANIFEST_OVERRIDE := true

# Include path
TARGET_SPECIFIC_HEADER_PATH += $(DEVICE_PATH)/include

# Init
TARGET_INIT_VENDOR_LIB ?= //$(DEVICE_PATH):init_nx508j
TARGET_RECOVERY_DEVICE_MODULES ?= init_nx508j
TARGET_PLATFORM_DEVICE_BASE := /devices/soc.0/

# IPA
USE_DEVICE_SPECIFIC_DATA_IPA_CFG_MGR := true

# This is a proprietary blob on 8992/8994
TARGET_PROVIDES_KEYMASTER := true

# Cpusets
ENABLE_CPUSETS := true
ENABLE_SCHED_BOOST := true

# Lights
TARGET_PROVIDES_LIBLIGHT := true

# Partitions
BOARD_BOOTIMAGE_PARTITION_SIZE := 67108864
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := f2fs
BOARD_CACHEIMAGE_PARTITION_SIZE := 268435456
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 67108864
BOARD_ROOT_EXTRA_FOLDERS := firmware bt_firmware persist
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 2684354560
BOARD_USERDATAIMAGE_PARTITION_SIZE := 59047394304
BOARD_FLASH_BLOCK_SIZE := 262144
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
TARGET_USES_MKE2FS := true

#Peripheral manager is enabled on this target
#This flag means that peripheral manager is enabled
#is controlling the power on/off on certain peripherals.
TARGET_PER_MGR_ENABLED := true

# Power
TARGET_TAP_TO_WAKE_NODE := "/data/tp/easy_wakeup_gesture"

# QCOM hardware
BOARD_USES_QCOM_HARDWARE := true

# Recovery
RECOVERY_VARIANT := twrp
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/rootdir/etc/fstab.qcom
ifeq ($(RECOVERY_VARIANT),twrp)
  #TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/twrp/twrp.fstab
  # TWRP_CN
  #TW_CUSTOM_THEME := $(DEVICE_PATH)/twrp/twres
  TW_THEME := portrait_hdpi
  TARGET_SCREEN_WIDTH := 1080
  TARGET_SCREEN_HEIGHT := 1920
  BOARD_HAS_NO_REAL_SDCARD := true
  TARGET_RECOVERY_QCOM_RTC_FIX := true
  TW_EXTRA_LANGUAGES := true
  TW_DEFAULT_LANGUAGE := en
  TWRP_INCLUDE_LOGCAT := true
  TARGET_USES_LOGD := true
  TW_USE_TOOLBOX := true
  TW_EXCLUDE_TWRPAPP := true
  BOARD_SUPPRESS_SECURE_ERASE := true
  TWRP_NEW_THEME := true
  TW_INCLUDE_FB2PNG := true
  TW_INCLUDE_CRYPTO := true
  TW_BRIGHTNESS_PATH := /sys/class/leds/lcd-backlight/brightness
  TW_SCREEN_BLANK_ON_BOOT := true
endif

# SELinux
include device/qcom/sepolicy-legacy/sepolicy.mk
BOARD_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy

# Shims
TARGET_LD_SHIM_LIBS := \
    /system/vendor/lib64/libcne.so|libshim_dpmframework.so \
    /system/lib/hw/camera.msm8994.so|libshim_camera.so \
    /system/vendor/lib/libmmcamera2_stats_modules.so|libshim_cald.so \
    /system/vendor/lib/libmmcamera2_sensor_modules.so|libshim_atomic.so \
    /system/vendor/lib64/libril-qc-qmi-1.so|rild_socket.so

# WiFi
BOARD_HAS_QCOM_WLAN := true
BOARD_WLAN_DEVICE := qcwcn
BOARD_HOSTAPD_DRIVER := NL80211
BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
TARGET_USES_WCNSS_CTRL := true
TARGET_USES_QCOM_WCNSS_QMI := true
WIFI_DRIVER_FW_PATH_AP := "ap"
WIFI_DRIVER_FW_PATH_STA := "sta"
WIFI_HIDL_FEATURE_DISABLE_AP_MAC_RANDOMIZATION := true
WPA_SUPPLICANT_VERSION := VER_0_8_X

# Dexpreopt
ifeq ($(HOST_OS),linux)
  ifneq ($(TARGET_BUILD_VARIANT),eng)
    ifeq ($(WITH_DEXPREOPT),)
      WITH_DEXPREOPT := true
      WITH_DEXPREOPT_BOOT_IMG_AND_SYSTEM_SERVER_ONLY := true
    endif
  endif
endif

# inherit from the proprietary version
include vendor/nubia/nx508j/BoardConfigVendor.mk
