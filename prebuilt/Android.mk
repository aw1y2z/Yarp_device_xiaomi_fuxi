# Prebuilt lsof (external/ has no lsof source; binary copied from reference TWRP ramdisk)
LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := lsof
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_SRC_FILES := fuxi/vendor/bin/lsof
LOCAL_MODULE_PATH := $(TARGET_RECOVERY_ROOT_OUT)/system/bin
LOCAL_MODULE_TAGS := optional
# 预编译二进制：跳过 ELF 依赖校验（其 soong 依赖模块未在本树声明）
LOCAL_CHECK_ELF_FILES := false
include $(BUILD_PREBUILT)
