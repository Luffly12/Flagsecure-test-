# FLAG_SECURE Test

![Platform](https://img.shields.io/badge/Platform-Android-3DDC84.svg)
![minSdk](https://img.shields.io/badge/minSdk-24-blue.svg)
![Size](https://img.shields.io/badge/size-~12KB-lightgrey.svg)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Release](https://img.shields.io/badge/release-v1.0-orange.svg)](../../releases)

一个**极简的 Android 测试应用**，用来验证系统级「解锁截屏」是否生效——例如配合 LSPosed 的 **Enable Screenshot / DisableFlagSecure**、Magisk 的 SurfaceFlinger 补丁等模块使用。

装上它、打开、截个图，**黑不黑**，一眼就知道你的模块到底有没有工作。

> English: [README.en.md](README.en.md)

---

## 为什么需要它

Android 允许 App 通过窗口标志 `FLAG_SECURE` 禁止被截图/录屏（银行 App、支付码页、隐私界面等常见）。

当你用 **Enable Screenshot / DisableFlagSecure** 这类模块去"解锁截屏"时，需要一个**可靠、干净、专门为此设计**的靶子来验证效果——但市面上的测试包要么是 2017 年的老古董（装不上新系统），要么夹杂无关权限。

本应用就是为此而生：**体积仅约 12 KB，无任何权限、无网络、无隐私收集**，只做一件事——提供一个可切换的 `FLAG_SECURE` 窗口。

## 截图

| 安全窗口（SECURE） | 普通窗口（NON-SECURE） |
|---|---|
| ![secure](screenshots/secure.jpg) | ![nonsecure](screenshots/nonsecure.jpg) |

> 安全模式下"能拍到文字"，即说明解锁模块已生效。

## 特性

- 默认以 **安全窗口（SECURE）** 启动：设置了 `FLAG_SECURE`
- 一键切换 **安全 / 非安全** 窗口，方便 A/B 对比
- `minSdk 24` / `targetSdk 34`，**可在 Android 7.0 ~ 15+ 上安装运行**
- 无权限、无广告、无网络、无后台
- 全部源码公开，约一个 Activity

## 背景：什么是 FLAG_SECURE

`WindowManager.LayoutParams.FLAG_SECURE` 是 Android 提供的窗口标志。一旦设置，系统会：

- 禁止对**该窗口**截图 / 录屏（截出来是黑图）；
- 禁止在**最近任务**中显示该窗口的缩略图。

它广泛用于保护敏感界面。本应用通过 `getWindow().setFlags(FLAG_SECURE, FLAG_SECURE)` 主动开启，用来当作测试靶子。

## 界面与用法

1. **安装** APK（见 [Releases](../../releases)）。
2. **打开**应用，默认显示 **「当前模式：安全窗口（SECURE）」**。
3. 用**系统截图**（电源键 + 音量下）截本页：
   - **截图全黑** → `FLAG_SECURE` 正在生效（系统在保护它）；
   - **能拍到屏幕上的文字** → 保护**已被解除**（说明你的解锁模块生效了 ✅）。
4. 点 **「切换 安全 / 非安全」** 按钮，切换后各截一次做对比。

### 结果对照表

| 当前模式 | 未装解锁模块（预期） | 装了生效的解锁模块（预期） |
|---|---|---|
| 安全窗口 SECURE | 全黑 | 能拍到文字 |
| 普通窗口 NON-SECURE | 能拍到文字 | 能拍到文字 |

> 若"安全模式"下也能拍到文字，即证明解锁模块已生效。

## 构建

不依赖 Gradle，使用 Android SDK 的 `aapt2` / `d8`(或 R8) / `zipalign` / `apksigner` 直接构建，脚本见 [`build.sh`](build.sh)。

需要：

- JDK 17+（运行 `d8`/`apksigner`）
- Android SDK：`build-tools`（提供 `aapt2`、`d8`/R8、`zipalign`、`apksigner`）
- 一份 `android.jar`（对应某个 platform，如 android-34）

修改 `build.sh` 顶部的路径后执行：

```bash
bash build.sh
```

输出为已签名的 `out/FlagSecureTest.apk`。

## 目录结构

```
.
├── src/
│   ├── AndroidManifest.xml
│   ├── res/values/strings.xml
│   └── java/fun/test/flagsecure/MainActivity.java
├── build.sh
├── screenshots/                # 展示截图
├── dist/FLAG_SECURE_test.apk   # 预编译好的可安装包
├── CHANGELOG.md
├── README.en.md
└── LICENSE
```

## 常见问题

**Q：截图全黑，是不是 App 坏了？**
A：不是。这就是 `FLAG_SECURE` 的正常表现——正是我们要复现的效果。

**Q：安全模式截图也能拍到，说明什么？**
A：说明设备上已有一个"解锁截屏"的模块（LSPosed 的 Enable Screenshot、Magisk 补丁等）正在全局生效。

**Q：为什么不直接拿银行 App 测？**
A：可以，但银行/支付 App 往往还叠加了 Root 检测、硬件级保护等其他机制，结果不好判断。用本应用可以**排除干扰**，只看 `FLAG_SECURE` 本身。

**Q：我的目标 App 用解锁模块后还是黑的？**
A：那说明它用的**不是普通 `FLAG_SECURE`**，而是更强的硬件级/DRM 保护（安全视频管线、自绘安全层等），这类保护常规模块无法绕过。

## 免责声明

本应用仅供**技术学习、开发调试、模块验证**等合法用途。请勿用于绕过他人应用的正当安全措施、侵犯隐私或任何违法用途。使用风险自负。

## 许可证

[MIT](LICENSE)
