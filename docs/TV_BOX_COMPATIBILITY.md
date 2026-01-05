# 电视盒子兼容性指南

## 问题概述

许多电视盒子设备（如小米电视、极米投影仪等）使用老旧的 Android System WebView，不支持现代 JavaScript 特性。

### 常见症状
- 应用卡在加载界面
- 白屏
- JavaScript 错误（Proxy 未定义等）

### 根本原因
这些设备的 WebView 版本太旧，不支持：
- `Proxy` (Vue 3 核心依赖)
- `async/await`
- `fetch` API
- `AbortController`
- `EventSource`

## 解决方案

### 方案 1: 电视盒子专用版本 (推荐)

我们提供了一个使用 **GeckoView** 的专用版本，完全独立于系统 WebView。

#### 位置
```
android-tv/
├── package.json
├── capacitor.config.json
├── android/
└── README.md
```

#### 构建
```bash
cd android-tv
npm install --ignore-scripts
cd android
$env:JAVA_HOME = 'C:\Program Files\Android\Android Studio\jbr'
.\gradlew.bat assembleDebug
```

#### 优点
- ✅ 不依赖系统 WebView
- ✅ 支持所有现代 JavaScript 特性
- ✅ 兼容几乎所有 Android 5.0+ 设备

#### 缺点
- ❌ APK 体积较大（约 100MB）
- ❌ 调试需要使用 Firefox 工具

### 方案 2: 升级系统 WebView

如果用户可以操作设备：

1. **小米电视/盒子**
   - 设置 → 应用 → 系统应用更新 → 更新 WebView

2. **通过 ADB 安装**
   ```bash
   adb install webview.apk
   ```
   
3. **第三方 WebView**
   - [Bromite WebView](https://www.nicemood.tech/nicemood_capacitor_geckoview)
   - [Mulch SystemWebView Overlay](https://nicemood.tech/nicemood-capacitor-geckoview)

### 方案 3: 手机投屏

避免直接在电视盒子上运行应用，改用：
- 手机镜像投屏
- Chromecast
- AirPlay

## 技术细节

### GeckoView 版本
使用 `@web-media/capacitor-geckoview` 2.0.0：
- GeckoView 106.0.20221019185550
- Capacitor 4.6.3

### App ID
| 版本 | App ID |
|------|--------|
| 标准版 | `com.ednovas.donguatv` |
| 电视盒子版 | `com.ednovas.donguatv.tv` |

### 架构支持
电视盒子版本支持：
- `arm64-v8a` (主流设备)

如需其他架构，需在 `android/app/build.gradle` 中配置 `ndk.abiFilters`。

## 故障排除

### 构建错误: JDK 版本不兼容
确保使用 JDK 17 或更高版本。

### 构建错误: Kotlin 依赖冲突
已在 `app/build.gradle` 中配置了强制版本解析。

### 运行时白屏
1. 检查网络连接
2. 查看 Firefox 远程调试日志
3. 确认服务器 `https://ednovas.video` 可访问

## 联系支持

如有问题，请联系开发者或在 GitHub 提交 Issue。
