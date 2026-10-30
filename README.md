# Xiaomi 13 (fuxi) — TWRP device tree

| | |
|---|---|
| PRODUCT | `twrp_fuxi` |
| DEVICE | `fuxi` |
| SoC | SM8550 (kalama) / Adreno 740 |
| MODEL | 2211133C |
| Android | 16 / API 36 |
| 存储 | 动态分区 + Virtual A/B，userdata 为 FBE（metadata 加密） |
| 基线 | `twrp-16.0` |

支持：ADB / Sideload / 解密 / 触摸 / 显示 / Fastbootd / MTP / OTG / 振动 /
备份恢复（含 `/data`）/ slot 切换。

## 编译

### 1. 删除 NXP keymint（必须）

`repo sync` 会拉取 `hardware/nxp/keymint`，它与本树的 keymint 版本冲突，
Soong 分析阶段直接失败：

```
error: module "libjc_keymint3.nxp" depends on multiple versions of the same aidl_interface:
       android.hardware.security.keymint-V3-ndk-source,
       android.hardware.security.keymint-V4-ndk-source
```

```bash
rm -rf hardware/nxp/keymint
```

> `repo sync` 会拉回来，每次同步后需再删一次。

### 2. 编译

```bash
cp -r device/xiaomi/fuxi  <AOSP>/device/xiaomi/fuxi

source build/envsetup.sh
export ALLOW_MISSING_DEPENDENCIES=true
export BUILD_BROKEN_DUP_RULES=true
export BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES=true
lunch twrp_fuxi-eng
make recoveryimage -j$(nproc)
```

产物 `out/target/product/fuxi/recovery.img`。

## 目录

```
device/xiaomi/fuxi/
├── BoardConfig.mk          板级配置
├── device.mk               product 配置
├── twrp_fuxi.mk            TWRP 产品定义
├── AndroidProducts.mk / Android.bp / system.prop
├── recovery/root/          ramdisk 内容，构建时直接装入
│   ├── init.recovery.*.rc  服务启动编排
│   ├── prop.default / file_contexts
│   ├── system/             bins / libs / etc
│   └── vendor/             HAL / 内核模块 / 固件
└── prebuilt/
    ├── recovery_libs/      recovery 二进制依赖的库
    ├── crypto/             TEE / keymint / gatekeeper 素材
    ├── fuxi/               厂商 vendor 快照（仅用 vendor/bin/lsof）
    └── kernel_empty        内核占位
```

## 致谢

基于 [TWRP-Test/platform_manifest_twrp_aosp](https://github.com/TWRP-Test/platform_manifest_twrp_aosp)
`twrp-16.0` 分支。
