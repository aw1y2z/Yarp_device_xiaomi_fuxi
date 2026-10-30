# recovery 二进制 NEEDED 的 soong 库，soong 默认不装进 ramdisk；用 prebuilt 补齐
LOCAL_PATH := $(call my-dir)

define add-rec-lib
include $(CLEAR_VARS)
LOCAL_MODULE := $(1)
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_SRC_FILES := $(1).so
LOCAL_MODULE_PATH := $(TARGET_RECOVERY_ROOT_OUT)/system/lib64
LOCAL_MODULE_TAGS := optional
LOCAL_CHECK_ELF_FILES := false
LOCAL_MODULE_SUFFIX := .so
include $(BUILD_PREBUILT)
endef

$(foreach l,libtwrpminui android.security.authorization-ndk android.security.maintenance-ndk libf2fs_sparseblock libgatekeeper_aidl,$(eval $(call add-rec-lib,$(l))))
