# Release Notes 模板

> 发布新版本（GitHub → Releases → Create a new release）时，把下面的模板复制进
> "Describe this release" 里，套改即可。

---

## 版本模板（复制这段）

```markdown
## FLAG_SECURE Test v{版本号}

{一句话概述，例如：修复 XX，新增 YY}

### ✨ 新增 (Added)
- 

### 🐛 修复 (Fixed)
- 

### 🔧 变更 (Changed)
- 

### 🗑️ 移除 (Removed)
- 

### 📦 下载
- 直接下载：`FLAG_SECURE_test.apk`（见下方 Assets）

**适用系统**：Android 7.0 ~ 15+
**校验（SHA-256）**：`{填 apk 的 sha256}`
```

---

## 示例：v1.0（首个版本）

```markdown
## FLAG_SECURE Test v1.0

首个公开版本。

### ✨ 新增 (Added)
- 默认以 FLAG_SECURE 安全窗口启动
- 一键切换 安全 / 非安全 窗口
- 支持 Android 7.0 ~ 15+（minSdk 24 / targetSdk 34）

### 📦 下载
- 直接下载：`FLAG_SECURE_test.apk`（Assets）

**固定签名（v2 + v3）**，校验（SHA-256）：
`xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`
```

---

## 示例：v1.1（补丁版）

```markdown
## FLAG_SECURE Test v1.1

### 🐛 修复 (Fixed)
- 修复在部分 ColorOS 机型上切换按钮状态不同步的问题

### 🔧 变更 (Changed)
- 界面文案微调

### 📦 下载
- 直接下载：`FLAG_SECURE_test.apk`（Assets）
```

---

## 小提示

- **tag 命名**：用 `v1.0`、`v1.1` 这种带 `v` 前缀的标签。
- **每次发布都附 APK**：点 **Attach binaries** 上传 `dist/FLAG_SECURE_test.apk`。
- **附校验值**：在电脑上执行（macOS/Linux）
  ```bash
  sha256sum dist/FLAG_SECURE_test.apk
  ```
  Windows PowerShell：
  ```powershell
  Get-FileHash .\FLAG_SECURE_test.apk -Algorithm SHA256
  ```
  把结果填进 Release 说明，方便用户校验。
- **同步 CHANGELOG.md**：发布后把该版本内容补进 `CHANGELOG.md`。
- **勾选 "Set as the latest release"**：让新版本成为默认展示版。
