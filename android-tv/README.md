# E视界TV - 电视盒子版 (GeckoView 内核)

这是 E视界应用的电视盒子专用版本，使用 **Mozilla GeckoView** 替代系统 WebView，解决老旧电视盒子上 WebView 兼容性问题。

## 为什么需要这个版本？

许多电视盒子（特别是小米电视、极米投影仪等）使用的是老旧的 Android 系统 WebView，不支持现代 JavaScript 特性如：
- `Proxy` (Vue 3 核心依赖)
- `async/await`
- `fetch` API
- `AbortController`

这导致应用在这些设备上无法正常运行。

## 解决方案

本版本使用 [Mozilla GeckoView](https://mozilla.github.io/geckoview/) 替代系统 WebView：
- ✅ 自带完整的现代浏览器引擎
- ✅ 不依赖系统 WebView 版本
- ✅ 支持所有现代 JavaScript 特性
- ✅ 与 Firefox 保持同步更新

## 注意事项

1. **APK 体积较大**: 由于包含完整的 GeckoView 引擎，APK 大小约 100MB+
2. **CPU 架构**: 目前只包含 `arm64-v8a` 架构，适用于大多数现代电视盒子
3. **调试方式**: 使用 Firefox 远程调试工具（而非 Chrome DevTools）

## 构建

```bash
# 安装依赖
npm install --ignore-scripts

# 构建 Debug APK
$env:JAVA_HOME = 'C:\Program Files\Android\Android Studio\jbr'
cd android
.\gradlew.bat assembleDebug

# APK 输出位置
# android/app/build/outputs/apk/debug/app-debug.apk
```

## 技术栈

- Capacitor 4.6.3
- @web-media/capacitor-geckoview 2.0.0
- Android Gradle Plugin 8.5.0
- Gradle 8.7

## 🖥️ 支持的 CPU 架构

| 架构 | 说明 | 适用设备 |
|------|------|----------|
| `arm64-v8a` | ARM 64位 | 大多数现代电视盒子、手机 |
| `armeabi-v7a` | ARM 32位 | 老旧电视盒子、低端手机 |
| `x86_64` | Intel/AMD 64位 | 部分平板、模拟器 |
| `x86` | Intel/AMD 32位 | 老旧平板、模拟器 |

## 🤖 GitHub Actions 自动构建

电视盒子版会与标准版一起自动构建发布：

- **触发条件**：推送 `v*.*.*` 格式的 Tag
- **手动触发**：在 GitHub Actions 页面选择 `Android TV Build (GeckoView)` workflow
- **Release 产物**：
  - `E视界TV-...-geckoview-universal.apk` (全架构, ~350MB)
  - `E视界TV-...-geckoview-arm64-v8a.apk` (推荐, ~100MB)
  - `E视界TV-...-geckoview-armeabi-v7a.apk` (老旧设备, ~80MB)
  - `E视界TV-...-geckoview-x86_64.apk` (模拟器)
  - `E视界TV-...-geckoview-x86.apk` (老旧模拟器)

## 与主版本的区别

| 特性 | 主版本 | 电视盒子版 |
|------|--------|------------|
| WebView | 系统 WebView | GeckoView |
| APK 大小 | ~10MB | ~100MB |
| 兼容性 | 需要较新 WebView | 通用 |
| App ID | com.ednovas.donguatv | com.ednovas.donguatv.tv |

## 相关文件

- `package.json` - npm 依赖配置
- `capacitor.config.json` - Capacitor 配置
- `android/` - Android 项目目录

## 故障排除

### 构建失败：JDK 版本问题
确保使用 JDK 17 或更高版本（推荐使用 Android Studio 内置的 JBR）

### 构建失败：Kotlin 依赖冲突
已在 `app/build.gradle` 中配置了依赖解析策略

### 应用白屏
检查网络连接，确保能访问 `https://ednovas.video`
