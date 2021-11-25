# Copyright 2010 The Android Open Source Project
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

LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
	Audioclient.cpp \
	rild_socket.c

LOCAL_MODULE := rild_socket
LOCAL_MODULE_TAGS := optional
LOCAL_VENDOR_MODULE := true
LOCAL_SHARED_LIBRARIES := \
	libaudioclient
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
	dpm/strdup16to8.cpp \
	dpm/strdup8to16.cpp

LOCAL_MODULE := libshim_dpmframework
LOCAL_MODULE_TAGS := optional
LOCAL_VENDOR_MODULE := true
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)

LOCAL_SRC_FILES := atomic.cpp
LOCAL_MODULE := libshim_atomic
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_VENDOR_MODULE := true

include $(BUILD_SHARED_LIBRARY)

# libshim_cald
include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
    gui/SensorManager.cpp

LOCAL_C_INCLUDES := \
    $(LOCAL_PATH)/include \
    external/safe-iop/include \
    system/core/libutils

LOCAL_SHARED_LIBRARIES := \
    libcutils \
    libgui \
    libbinder \
    libsensor \
    libutils \
    liblog

LOCAL_MODULE := libshim_cald

LOCAL_VENDOR_MODULE := true
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := SHARED_LIBRARIES

include $(BUILD_SHARED_LIBRARY)

# libshim_camera
include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
    Fence.cpp

LOCAL_C_INCLUDES := \
    $(LOCAL_PATH)/include \
    external/safe-iop/include \
    system/core/libutils

LOCAL_SHARED_LIBRARIES := \
    libcutils \
    libhardware \
    liblog \
    libui \
    libsync \
    libutils

LOCAL_MODULE := libshim_camera

LOCAL_VENDOR_MODULE := true
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := SHARED_LIBRARIES

include $(BUILD_SHARED_LIBRARY)
