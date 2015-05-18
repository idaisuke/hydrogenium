LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/$(TARGET_ARCH_ABI)/include/sqlcipher

LOCAL_MODULE := sqlcipher
LOCAL_SRC_FILES := $(TARGET_ARCH_ABI)/lib/libsqlcipher.a
include $(PREBUILT_STATIC_LIBRARY)
