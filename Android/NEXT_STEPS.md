# 下一步开发指南

## 🎯 当前状态

✅ **已完成**：
- Android 项目基础框架
- Chaquopy Python 集成配置
- Material Design 3 UI 界面
- 文件选择和权限管理
- Python 桥接模块 (api_bridge.py)
- 完整的反汇编/汇编工作流
- HBC-Tool 源码集成（172 个 Python 文件）
- 真实 .bundle 文件测试成功
- 日志优化（简化输出，隐藏 ResourceWarning）
- 日志复制功能（一键复制 + 手动选择）
- 删除输入/输出文件功能
- 状态持久化（重启后恢复文件）
- **文件导出功能（ZIP 压缩输出目录）**
- **文件导入功能（解压 ZIP 到输出目录）**

⚠️ **待优化**：
1. 添加进度指示器（大文件导出）
2. 添加语法高亮（HASM 代码）
3. 添加版本自动检测
4. 添加崩溃报告

---

## 📋 立即执行的步骤

### 步骤 1: 集成 HBC-Tool 源码

在项目根目录执行：

```powershell
# Windows PowerShell
cd app\src\main\python
git clone https://github.com/Kirlif/HBC-Tool.git temp_hbc
xcopy temp_hbc\hbctool hbctool /E /I
rmdir /S /Q temp_hbc
```

或者手动下载：
1. 访问 https://github.com/Kirlif/HBC-Tool/archive/refs/heads/main.zip
2. 解压 ZIP
3. 将 `hbctool` 文件夹复制到 `app/src/main/python/`

### 步骤 2: 在 Android Studio 中打开项目

```
文件 -> 打开 -> 选择 E:\AI\HBCTool 文件夹
```

等待 Gradle 同步完成（首次可能需要 10-15 分钟）

### 步骤 3: 第一次构建

#### 选项 A: 使用 Android Studio
- 点击工具栏的绿色 ▶️ 按钮
- 选择"Run 'app'"

#### 选项 B: 使用命令行
```powershell
cd E:\AI\HBCTool
.\gradlew.bat assembleDebug

# 或使用快捷脚本
.\build.bat
```

**注意**：首次构建时 Chaquopy 会：
- 下载 Python 3.8 运行时（约 20MB）
- 下载 pip 依赖（click, construct, colorama）
- 编译 Native Library

总计约需 5-10 分钟

### 步骤 4: 安装到设备

#### 真机测试：
1. 打开手机的开发者选项
2. 启用 USB 调试
3. 连接电脑
4. Android Studio 会自动识别设备

#### 模拟器测试（不推荐）：
- 需要添加 x86 架构支持
- 性能较差

### 步骤 5: 准备测试文件

获取一个 React Native 应用的 `.bundle` 文件：

```bash
# 如果你有 RN 项目
npx react-native bundle \
  --platform android \
  --dev false \
  --entry-file index.js \
  --bundle-output index.android.bundle
```

或者从已安装的 RN 应用中提取：
```bash
# 使用 adb
adb pull /data/app/com.example.app/base.apk
# 解压 APK，在 assets/ 目录查找 index.android.bundle
```

---

## 🔧 可能遇到的问题

### 问题 1: Gradle 同步失败

**错误信息**：`Could not resolve com.chaquo.python:gradle:15.0.1`

**解决方案**：
```kotlin
// 在 settings.gradle.kts 中确认 Maven 仓库
repositories {
    maven { url = uri("https://chaquo.com/maven") }
}
```

### 问题 2: Python 模块导入失败

**错误信息**：`ModuleNotFoundError: No module named 'hbctool'`

**检查清单**：
- [ ] `app/src/main/python/hbctool/__init__.py` 存在
- [ ] `hbctool` 文件夹与 `api_bridge.py` 在同一目录
- [ ] 执行 `./gradlew clean build` 重新构建

### 问题 3: 文件读取权限被拒绝

**原因**：Android 11+ 的存储限制

**当前实现**：App 会自动将文件复制到私有目录，无需担心

### 问题 4: APK 签名问题

**错误信息**：`Installation failed: INSTALL_PARSE_FAILED_NO_CERTIFICATES`

**解决方案**：
```bash
# 生成调试签名
keytool -genkey -v -keystore debug.keystore -alias androiddebugkey -keyalg RSA -keysize 2048 -validity 10000
```

---

## 🎨 进阶优化建议

### 1. 添加语法高亮

将日志输出的 HASM 代码用语法高亮显示：

**依赖**：
```kotlin
implementation("io.github.rosemoe.sora-editor:editor:0.23.0")
```

### 2. 文件导入/导出功能

✅ **已实现** - 用户可以导出/导入反汇编或汇编的输出文件：

#### **导出功能**：
- 使用 SAF (Storage Access Framework) 让用户选择保存位置
- 自动生成带时间戳的文件名：`hbctool_output_yyyyMMdd_HHmmss.zip`
- 递归打包整个输出目录
- 成功/失败提示

**使用方法**：
1. 完成反汇编或汇编操作后，"导出 ZIP"按钮会自动启用
2. 点击"导出 ZIP"
3. 在弹出的文件选择器中选择保存位置
4. 等待导出完成

#### **导入功能**：
- 选择之前导出的 ZIP 文件
- 自动解压到新的输出目录
- 显示解压文件数量
- 导入后自动启用删除和导出按钮

**使用方法**：
1. 点击"导入 ZIP"按钮
2. 选择之前导出的 `.zip` 文件
3. 自动解压到 `output/imported_[timestamp]` 目录
4. 可以重新导出或删除

**代码位置**：
- [MainActivity.kt](app/src/main/java/com/hbctool/android/MainActivity.kt#L598) - `exportOutputFiles()` 方法
- [MainActivity.kt](app/src/main/java/com/hbctool/android/MainActivity.kt#L618) - `exportToUri()` 方法
- [MainActivity.kt](app/src/main/java/com/hbctool/android/MainActivity.kt#L643) - `importZipFile()` 方法
- [MainActivity.kt](app/src/main/java/com/hbctool/android/MainActivity.kt#L650) - `importFromUri()` 方法

### 3. 添加版本检测

在 `api_bridge.py` 中自动检测 Hermes 版本：

```python
def detect_hermes_version(header: bytes) -> str:
    """根据文件头魔数判断 Hermes 版本"""
    magic_map = {
        b'\xC6\x1F\xBC\x03': 'v84',
        b'\xFF\x48\x42\x43': 'v59-v83',
        # 添加更多版本映射
    }
    return magic_map.get(header[:4], 'unknown')
```

### 4. 添加崩溃报告

集成 Firebase Crashlytics：

```kotlin
// app/build.gradle.kts
plugins {
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
}

dependencies {
    implementation(platform("com.google.firebase:firebase-bom:32.7.0"))
    implementation("com.google.firebase:firebase-crashlytics-ktx")
}
```

---

## 📚 学习资源

### Chaquopy 文档
- 官方文档: https://chaquo.com/chaquopy/doc/current/
- Python API: https://chaquo.com/chaquopy/doc/current/android.html

### HBC-Tool 文档
- GitHub: https://github.com/Kirlif/HBC-Tool
- Hermes 格式: https://github.com/facebook/hermes/blob/main/doc/BytecodeFormat.md

### Android 开发
- Material Design 3: https://m3.material.io/
- Scoped Storage: https://developer.android.com/training/data-storage

---

## ✅ 验收标准

你的第一个里程碑应该是：

1. **构建成功**：无错误编译出 APK
2. **Python 启动**：日志显示 "✓ Python 引擎已启动"
3. **文件加载**：能够选择并加载 .bundle 文件
4. **基础反汇编**：即使是测试模式，也能输出文件信息

一旦这 4 点都通过，就可以开始真正集成 HBC-Tool 的完整逻辑了。

---

**祝你开发顺利！如有问题随时查看日志或提 Issue。** 🚀
