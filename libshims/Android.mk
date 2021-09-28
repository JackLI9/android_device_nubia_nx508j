LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
    Fence.cpp \
    GraphicBuffer.cpp

LOCAL_SHARED_LIBRARIES := \
    libbinder \
    libui \
    libgui \
    libutils \
    libcutils

LOCAL_MODULE := libshim_camera
LOCAL_MODULE_TAGS := optional

include $(BUILD_SHARED_LIBRARY)


include $(CLEAR_VARS)

LOCAL_SRC_FILES := SensorManager.cpp

LOCAL_SHARED_LIBRARIES := \
    libbinder \
    libui \
    libgui \
    libutils \
    libcutils

LOCAL_MODULE := libshim_mmcamera2
LOCAL_MODULE_TAGS := optional

include $(BUILD_SHARED_LIBRARY)


include $(CLEAR_VARS)

LOCAL_SRC_FILES := MediaBuffer.cpp

LOCAL_SHARED_LIBRARIES := \
    libbinder \
    libui \
    libgui \
    libutils \
    libcutils \
    libstagefright_foundation

LOCAL_MODULE := libshim_ims
LOCAL_MODULE_TAGS := optional

include $(BUILD_SHARED_LIBRARY)

