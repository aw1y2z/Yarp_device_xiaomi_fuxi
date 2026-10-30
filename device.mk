#
# Copyright (C) 2026 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Configure base.mk
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)

# Configure core_64_bit_only.mk
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)

# Configure Virtual A/B
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota.mk)

# Configure virtual_ab compression.mk
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/compression.mk)

# Configure emulated_storage.mk
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# Configure twrp common.mk
$(call inherit-product, vendor/twrp/config/common.mk)

# bootctrl for sm8550 (ref: refs/fuxi-ofrp/device.mk)
PRODUCT_PACKAGES += \
    bootctrl.xiaomi_sm8550.recovery \
    android.hardware.boot@1.2-impl-qti.recovery

# TWRP 的 fscrypt_mount_metadata_encrypted 走 HIDL keymaster4 路径，
# 而 fuxi 只装了 AIDL keymint。补上 HIDL 4.0 服务，由 libqtikeymaster4.so
# 提供后端（vendor 里已有该库）。
PRODUCT_PACKAGES += \
    android.hardware.keymaster@4.0-service

# API
# ref: refs/fuxi-ofrp/device.mk —— fuxi 出厂为 Android 12（API 31）。
# 注意：sm8850 模板用的是 202504 / 36，那是跨代取值，不能照搬。
PRODUCT_SHIPPING_API_LEVEL := 31
PRODUCT_TARGET_VNDK_VERSION := 36

# Build
PRODUCT_CHECK_PREBUILT_MAX_PAGE_SIZE := false

# Dynamic partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# Enable Fuse Passthrough
PRODUCT_PROPERTY_OVERRIDES += persist.sys.fuse.passthrough.enable=true

# Required modules
# 注：上游模板的 miui_prebuilt（整体 cp -rf prebuilt/<device>/vendor 到 ramdisk）
# 已移除。现在 vendor/ 内容直接放在 recovery/root/vendor/ 下，由 AOSP 构建系统
# 自动装入 ramdisk，不再依赖 depmod 后处理。prebuilt/Android.mk 只保留 lsof。

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(DEVICE_PATH)