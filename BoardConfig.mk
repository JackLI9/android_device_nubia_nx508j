# Copyright (C) 2015 The CyanogenMod Project
# Copyright (C) 2017 The LineageOS Project
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

# Platform
TARGET_BOARD_PLATFORM := msm8994
TARGET_BOARD_PLATFORM_GPU := qcom-adreno430
TARGET_BOARD_SUFFIX := _64

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := MSM8994
TARGET_NO_BOOTLOADER := true
TARGET_NO_RADIOIMAGE := true

# This is a proprietary blob on 8992/8994
TARGET_PROVIDES_KEYMASTER := true
TARGET_KEYMASTER_WAIT_FOR_QSEE := true

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic

# Second architecture
TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv7-a-neon
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a53.a57

TARGET_USES_64_BIT_BINDER := true

# ANT+
BOARD_ANT_WIRELESS_DEVICE := "qualcomm-uart"

# Audio
DOLBY_ENABLE := true
USE_CUSTOM_AUDIO_POLICY := 1
DOLBY_UDC := true
DS1_DOLBY_DAP := true

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
TARGET_NEEDS_PLATFORM_TEXT_RELOCATIONS := true
USE_DEVICE_SPECIFIC_CAMERA := true

# Properties
TARGET_SYSTEM_PROP += $(DEVICE_PATH)/system.prop

# Charger
#BOARD_CHARGER_ENABLE_SUSPEND := true
BOARD_CHARGER_DISABLE_INIT_BLANK := true

# CM Hardware
BOARD_USES_CYANOGEN_HARDWARE := true
BOARD_HARDWARE_CLASS += \
    hardware/cyanogen/cmhw \
    $(DEVICE_PATH)/cmhw
TARGET_TAP_TO_WAKE_NODE := "/data/tp/easy_wakeup_gesture"

# DPM NSRM Feature
TARGET_LDPRELOAD := libNimsWrap.so
BOARD_USES_QCNE := true

#Enable HW based full disk encryption
TARGET_HW_DISK_ENCRYPTION := false

# Enable dexpreopt to speed boot time
ifeq ($(HOST_OS),linux)
  ifeq ($(call match-word-in-list,$(TARGET_BUILD_VARIANT),user),true)
    ifeq ($(WITH_DEXPREOPT),)
      WITH_DEXPREOPT := true
    endif
  endif
endif

# Fonts
EXTENDED_FONT_FOOTPRINT := true

# Filesystem
TARGET_ANDROID_FILESYSTEM_CONFIG_H := $(DEVICE_PATH)/android_filesystem_config.h

# GPS
TARGET_NO_RPC := true
USE_DEVICE_SPECIFIC_GPS := true
BOARD_VENDOR_QCOM_GPS_LOC_API_HARDWARE := $(TARGET_BOARD_PLATFORM)
BOARD_VENDOR_QCOM_LOC_PDK_FEATURE_SET := true

# Display
MAX_EGL_CACHE_KEY_SIZE := 12*1024
MAX_EGL_CACHE_SIZE := 2048*1024
MAX_VIRTUAL_DISPLAY_DIMENSION := 4096
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3
OVERRIDE_RS_DRIVER:= libRSDriver_adreno.so
TARGET_FORCE_HWC_FOR_VIRTUAL_DISPLAYS := true
TARGET_USES_ION := true
TARGET_USES_OVERLAY := true
TARGET_USES_C2D_COMPOSITION := true
USE_OPENGL_RENDERER := true

# Include path
TARGET_SPECIFIC_HEADER_PATH := $(DEVICE_PATH)/include

# Init
TARGET_INIT_VENDOR_LIB := libinit_nx508j
TARGET_PLATFORM_DEVICE_BASE := /devices/soc.0/

# IPA
USE_DEVICE_SPECIFIC_DATA_IPA_CFG_MGR := true

# Kernel
BOARD_KERNEL_CMDLINE := androidboot.hardware=qcom user_debug=31 msm_rtb.filter=0x37 ehci-hcd.park=3 lpm_levels.sleep_disabled=1 boot_cpus=0-3 #androidboot.selinux=permissive
BOARD_KERNEL_SEPARATED_DT := true
BOARD_KERNEL_BASE        := 0x00000000
BOARD_KERNEL_PAGESIZE    := 4096
BOARD_KERNEL_TAGS_OFFSET := 0x00000100
BOARD_RAMDISK_OFFSET := 0x02000000
BOARD_KERNEL_OFFSET = 0x00008000
TARGET_KERNEL_ARCH := arm64
TARGET_KERNEL_HEADER_ARCH := arm64
TARGET_KERNEL_CROSS_COMPILE_PREFIX := aarch64-linux-android-
BOARD_DTBTOOL_ARGS := -2
BOARD_KERNEL_IMAGE_NAME := Image
BOARD_MKBOOTIMG_ARGS := --ramdisk_offset $(BOARD_RAMDISK_OFFSET) --tags_offset $(BOARD_KERNEL_TAGS_OFFSET)
TARGET_KERNEL_SOURCE := kernel/nubia/msm8994
TARGET_KERNEL_CONFIG := msm8994-NX508J_defconfig
LZMA_RAMDISK_TARGETS := recovery,boot

# Cpusets
ENABLE_CPUSETS := true
ENABLE_SCHED_BOOST := true

# Lights
TARGET_PROVIDES_LIBLIGHT := true

# Media
TARGET_USES_MEDIA_EXTENSIONS := true

# Partitions
BOARD_BOOTIMAGE_PARTITION_SIZE     := 0x04000000
BOARD_CACHEIMAGE_PARTITION_SIZE    := 268435456
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 0x04000000
BOARD_SYSTEMIMAGE_PARTITION_SIZE   := 2684354560
BOARD_USERDATAIMAGE_PARTITION_SIZE := 11999358976
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
BOARD_FLASH_BLOCK_SIZE := 131072


#Peripheral manager is enabled on this target
#This flag means that peripheral manager is enabled
#is controlling the power on/off on certain peripherals.
TARGET_PER_MGR_ENABLED := true

# Power
TARGET_POWERHAL_SET_INTERACTIVE_EXT := $(DEVICE_PATH)/power/power_ext.c
TARGET_POWERHAL_VARIANT := qcom

# Qualcomm support
BOARD_USES_QCOM_HARDWARE := true

# Recovery
#RECOVERY_VARIANT := twrp
ifneq ($(RECOVERY_VARIANT),twrp)
  TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/rootdir/etc/fstab.qcom
else
  TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/twrp/twrp.fstab
  # TWRP_CN
  #TW_CUSTOM_THEME := $(DEVICE_PATH)/twrp/twres
  TW_THEME := portrait_hdpi
  BOARD_HAS_NO_REAL_SDCARD := true
  TW_USE_TOOLBOX := true
  TARGET_RECOVERY_QCOM_RTC_FIX := true
  TARGET_RECOVERY_PIXEL_FORMAT := "RGBX_8888"
  TW_BRIGHTNESS_PATH := /sys/class/leds/lcd-backlight/brightness
  TW_EXTRA_LANGUAGES := true
  TW_EXCLUDE_TWRPAPP := true
  BOARD_SUPPRESS_SECURE_ERASE := true
  TWRP_NEW_THEME := true
  TW_INCLUDE_FB2PNG := true
  TW_INCLUDE_CRYPTO := true
  RECOVERY_GRAPHICS_USE_LINELENGTH := true
  TW_TARGET_USES_QCOM_BSP := true
  # DEBUG (BOTH needed to enable logcat)
  TWRP_INCLUDE_LOGCAT := true
  TARGET_USES_LOGD := true
  TW_NEW_ION_HEAP := true
endif

# Added to indicate that protobuf-c is supported in this build
PROTOBUF_SUPPORTED := true

# SELinux
include device/qcom/sepolicy/sepolicy.mk
BOARD_SEPOLICY_DIRS += \
    $(DEVICE_PATH)/sepolicy

# Time services
BOARD_USES_QC_TIME_SERVICES := true

# WiFi
BOARD_HAS_QCOM_WLAN              := true
BOARD_HAS_QCOM_WLAN_SDK          := true
BOARD_HOSTAPD_DRIVER             := NL80211
BOARD_HOSTAPD_PRIVATE_LIB        := lib_driver_cmd_qcwcn
BOARD_WLAN_DEVICE                := qcwcn
BOARD_WPA_SUPPLICANT_DRIVER      := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_qcwcn

TARGET_USES_QCOM_WCNSS_QMI       := true
TARGET_USES_WCNSS_MAC_ADDR_REV   := true
WIFI_DRIVER_FW_PATH_STA          := "sta"
WIFI_DRIVER_FW_PATH_AP           := "ap"
WIFI_DRIVER_MODULE_PATH          := "/system/lib/modules/wlan.ko"
WIFI_DRIVER_MODULE_NAME          := "wlan"
WPA_SUPPLICANT_VERSION           := VER_0_8_X

CONFIG_EAP_PROXY := qmi
CONFIG_EAP_PROXY_AKA_PRIME := true
CONFIG_EAP_PROXY_MSM8994_TARGET := true

# inherit from the proprietary version
include vendor/nubia/nx508j/BoardConfigVendor.mk
