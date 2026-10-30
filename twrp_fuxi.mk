#
# Copyright (C) 2026 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/xiaomi/fuxi

# Inherit from device.mk configuration
$(call inherit-product, $(DEVICE_PATH)/device.mk)

# Release name
PRODUCT_RELEASE_NAME := fuxi

## Device identifier
PRODUCT_DEVICE := fuxi
PRODUCT_NAME := twrp_fuxi
PRODUCT_BRAND := Xiaomi
PRODUCT_MODEL := 2211133C
PRODUCT_MANUFACTURER := Xiaomi

# Assert
TARGET_OTA_ASSERT_DEVICE := fuxi

# Theme
# ref: refs/fuxi-ofrp/twrp_fuxi.mk
TW_STATUS_ICONS_ALIGN := center
TW_Y_OFFSET := 99
TW_H_OFFSET := -99
# Android 16 module_sdk system-server classpath 声明 (recovery 构建需要)
PRODUCT_APEX_SYSTEM_SERVER_JARS += com.android.crashrecovery:service-crashrecovery

# 移除本树/external 与参考 rec 均未提供的工具声明（保持与官方 TWRP 一致）
PRODUCT_PACKAGES -= vim htop powertop openvpn mount.exfat

# 禁用 recovery 构建中不必要的 VINTF 内核检查（recovery 无 boot 内核）
PRODUCT_OTA_ENFORCE_VINTF_KERNEL_REQUIREMENTS := false

