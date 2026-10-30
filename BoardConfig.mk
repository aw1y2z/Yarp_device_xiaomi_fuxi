#
# Copyright (C) 2026 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Building with minimal manifest
ALLOW_MISSING_DEPENDENCIES := true

# Rules
BUILD_BROKEN_DUP_RULES := true
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true

# Architecture
# ref: refs/fuxi-ofrp/BoardConfig.mk
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic
TARGET_2ND_ARCH_VARIANT := $(TARGET_ARCH_VARIANT)
TARGET_2ND_CPU_VARIANT := $(TARGET_CPU_VARIANT)

# Bootloader
# ref: refs/fuxi-ofrp/BoardConfig.mk
PRODUCT_PLATFORM := kalama
TARGET_BOOTLOADER_BOARD_NAME := $(PRODUCT_PLATFORM)
TARGET_NO_BOOTLOADER := true

# Platform
# ref: refs/fuxi-ofrp/BoardConfig.mk
TARGET_BOARD_PLATFORM := xiaomi_sm8550
TARGET_BOARD_PLATFORM_GPU := qcom-adreno740
QCOM_BOARD_PLATFORMS += xiaomi_sm8550

# Kernel
# ref: refs/fuxi-ofrp/BoardConfig.mk
# fuxi 用 ramdisk-only：BOARD_EXCLUDE_KERNEL_FROM_RECOVERY_IMAGE := true 已置位，
# 因此内核不随 recovery.img 打包，指向 kernel_empty 占位即可。
BOARD_KERNEL_IMAGE_NAME       := Image
BOARD_BOOT_HEADER_VERSION     := 4
BOARD_KERNEL_PAGESIZE         := 4096
TARGET_KERNEL_CLANG_COMPILE   := true
TARGET_PREBUILT_KERNEL        := $(DEVICE_PATH)/prebuilt/kernel_empty
BOARD_MKBOOTIMG_ARGS          += --header_version $(BOARD_BOOT_HEADER_VERSION)
BOARD_MKBOOTIMG_ARGS          += --pagesize $(BOARD_KERNEL_PAGESIZE)

# Ramdisk use lz4
BOARD_RAMDISK_USE_LZ4 := true

# A/B
BOARD_EXCLUDE_KERNEL_FROM_RECOVERY_IMAGE := true

AB_OTA_UPDATER := true
AB_OTA_PARTITIONS += \
    boot \
    init_boot \
    vendor_boot \
    dtbo \
    vbmeta \
    vbmeta_system \
    odm \
    product \
    system \
    system_ext \
    system_dlkm \
    vendor \
    vendor_dlkm

# Verified Boot
BOARD_AVB_ENABLE := true

# Partitions
BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED := true

# Workaround for error copying vendor files to recovery ramdisk
# ref: refs/fuxi-ofrp/BoardConfig.mk
TARGET_COPY_OUT_VENDOR := vendor
TARGET_COPY_OUT_ODM := odm
BOARD_USES_VENDOR_DLKMIMAGE := true
TARGET_COPY_OUT_VENDOR_DLKM := vendor_dlkm

BOARD_RECOVERYIMAGE_PARTITION_SIZE := 104857600

# Dynamic Partition
# ref: refs/fuxi-ofrp/BoardConfig.mk —— fuxi 的 super 分区为 9653190656，
# 动态分区列表不含 system_dlkm（sm8850 有），且文件系统为 erofs。
BOARD_SUPER_PARTITION_SIZE := 9653190656
BOARD_SUPER_PARTITION_GROUPS := qti_dynamic_partitions
BOARD_QTI_DYNAMIC_PARTITIONS_SIZE := 9648996352
BOARD_QTI_DYNAMIC_PARTITIONS_PARTITION_LIST := system system_ext product vendor vendor_dlkm odm
BOARD_PARTITION_LIST := $(call to-upper, $(BOARD_QTI_DYNAMIC_PARTITIONS_PARTITION_LIST))
$(foreach p, $(BOARD_PARTITION_LIST), $(eval BOARD_$(p)IMAGE_FILE_SYSTEM_TYPE := erofs))
$(foreach p, $(BOARD_PARTITION_LIST), $(eval TARGET_COPY_OUT_$(p) := $(call to-lower, $(p))))

# File systems
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true

# Extras
TARGET_SYSTEM_PROP += $(DEVICE_PATH)/system.prop

# Recovery
# ref: refs/fuxi-ofrp/BoardConfig.mk —— fuxi 的 fstab 在 recovery/root/system/etc/ 下，
# 与 sm8850 模板放仓库根目录不同，路径必须改，否则构建时找不到 fstab。
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/recovery/root/system/etc/recovery.fstab

# Crypto
TW_INCLUDE_CRYPTO := true
# fuxi 的 vendor manifest 里 android.hardware.keymaster 条目没有 version/interface 字段，
# TWRP 的 KmVerFromManifest 解析不到版本（keymaster_ver 为空），解密会被跳过。
# 打开强制开关，改用 keymaster_ver 属性；下面在 init rc 里把它设为 4.x。
TW_FORCE_KEYMASTER_VER := true
TW_INCLUDE_CRYPTO_FBE := true
TW_INCLUDE_FBE_METADATA_DECRYPT := true
BOARD_USES_METADATA_PARTITION := true
TW_INCLUDE_OMAPI := true
TW_USE_FSCRYPT_POLICY := 2
# ref: refs/fuxi-ofrp/BoardConfig.mk —— 真实 Android 版本为 16。
# 注意：sm8850 模板写的 99.87.36 是故意伪造的高版本号，跨平台套用会让
# OTA 断言与属性判断失真，这里改用真实值。
PLATFORM_VERSION := 16
PLATFORM_VERSION_LAST_STABLE := $(PLATFORM_VERSION)
PLATFORM_SECURITY_PATCH := 2099-12-31
VENDOR_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)
BOOT_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)

# Tool
# ref: refs/fuxi-ofrp/BoardConfig.mk
# fuxi 不用 TW_INCLUDE_ZSTD（模板有，fuxi 无）。
TW_INCLUDE_7ZA := true
TW_INCLUDE_REPACKTOOLS := true
TW_INCLUDE_RESETPROP := true
TW_INCLUDE_LIBRESETPROP := true
TW_ENABLE_ALL_PARTITION_TOOLS := true

# Debug
TARGET_USES_LOGD := true
TWRP_INCLUDE_LOGCAT := true
TARGET_RECOVERY_DEVICE_MODULES += debuggerd
RECOVERY_BINARY_SOURCE_FILES += $(TARGET_OUT_EXECUTABLES)/debuggerd
TARGET_RECOVERY_DEVICE_MODULES += strace
RECOVERY_BINARY_SOURCE_FILES += $(TARGET_OUT_EXECUTABLES)/strace
# ref: refs/fuxi-ofrp/prebuilt/Android.mk —— 模块名是 miui_prebuilt，不是 prebuilt。
TARGET_RECOVERY_DEVICE_MODULES += miui_prebuilt


# Fastbootd
TW_INCLUDE_FASTBOOTD := true

# Other TWRP Configurations
TW_THEME := portrait_hdpi
TW_FRAMERATE := 120
RECOVERY_SDCARD_ON_DATA := true
TARGET_RECOVERY_QCOM_RTC_FIX := true
TW_EXCLUDE_DEFAULT_USB_INIT := true
TW_INCLUDE_NTFS_3G := true
# ref: refs/fuxi-ofrp/BoardConfig.mk —— fuxi 用 toolbox，不用 dmctl（模板有 dmctl）。
TW_USE_TOOLBOX := true
TARGET_USES_MKE2FS := true
TW_INPUT_BLACKLIST := "hbtp_vm"
# recovery 必须能读写 /data 做备份/恢复（TWRP 的核心功能），而 AOSP 的
# neverallow 明确禁止 recovery 访问 vold_data_file / vold_metadata_file /
# keystore_data_file 等类型。这些 neverallow 针对的是正常系统运行时的
# recovery，不适用于 TWRP 这种交互式恢复环境（recovery 本身已具备 root
# 与全盘擦写能力，SELinux 在此处的边界价值有限）。
# 因此显式忽略 neverallow，改用 allow 规则精确授予最小必要权限。
SELINUX_IGNORE_NEVERALLOWS := true

TW_BRIGHTNESS_PATH := "/sys/class/backlight/panel0-backlight/brightness"
TW_MAX_BRIGHTNESS := 4095
TW_EXTRA_LANGUAGES := true
TW_DEFAULT_BRIGHTNESS := 819
TW_EXCLUDE_APEX := true
TW_STATUS_ICONS_ALIGN := center
TW_SUPPORT_INPUT_AIDL_HAPTICS := true
TW_SUPPORT_INPUT_AIDL_HAPTICS_FIX_OFF := true
TW_USE_SERIALNO_PROPERTY_FOR_DEVICE_ID := true
# ref: refs/fuxi-ofrp/BoardConfig.mk
# 触摸 IC 为 fts（三星），不是 sm8850 的 synaptics/nt38773。
# 待实机确认：prebuilt 下同时存在 goodix_fod.ko / fpc1555.ko，不可全加载。
TW_LOAD_VENDOR_MODULES := "adsp_loader_dlkm.ko fts_touch_spi.ko qti_battery_charger.ko"
TW_LOAD_VENDOR_MODULES_EXCLUDE_GKI := true
# ref: refs/fuxi-ofrp/BoardConfig.mk —— 热区编号与 sm8850 的 zone25 不同
TW_CUSTOM_CPU_TEMP_PATH := "/sys/class/thermal/thermal_zone35/temp"
TW_BACKUP_EXCLUSIONS := /data/fonts,/data/adb/ap,/data/adb/ksu

# ---------------------------------------------------------------------------
# fuxi 专属项（全部来自 refs/fuxi-ofrp，sm8850 模板没有这些）
# ---------------------------------------------------------------------------
# ref: refs/fuxi-ofrp/BoardConfig.mk
TW_INCLUDE_LPDUMP := true
TW_INCLUDE_LPTOOLS := true
TW_ENABLE_FS_COMPRESSION := false
TW_NO_EXFAT_FUSE := true
TW_INCLUDE_FUSE_EXFAT := true
TW_INCLUDE_FUSE_NTFS := true
TW_DEFAULT_LANGUAGE := zh_CN
TW_HAS_EDL_MODE := true
TW_SUPPORT_INPUT_AIDL_HAPTICS_FQNAME := "IVibrator/vibratorfeature"
TW_BATTERY_SYSFS_WAIT_SECONDS := 6
TW_DEVICE_VERSION := FUXI-YARP


# 屏幕超时与电源键息屏/亮屏（默认 120 秒）。
# 注意：这里不能定义 TW_NO_SCREEN_TIMEOUT。该宏会让
# twrp_screen_backend::has_screen_off() 直接返回 false，并使
# checkForTimeout()/blank() 整体被编译掉，结果是既没有超时息屏，
# 电源键也完全无响应。默认超时值与 12/24 小时制在 data.cpp 中设置。
