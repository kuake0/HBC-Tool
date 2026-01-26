# HBC-Tool Android

基于 [Kirlif/HBC-Tool](https://github.com/Kirlif/HBC-Tool) 的 Android 移动端应用，用于反汇编和汇编 Hermes 字节码文件。

## ✨ 特性

- 📱 **原生 Android 应用**：Material Design 3 界面
- 🐍 **内置 Python 引擎**：通过 Chaquopy 运行完整的 HBC-Tool
- 🔄 **双向支持**：反汇编 `.bundle` → `.hasm` 和汇编 `.hasm` → `.bundle`
- 📂 **文件管理**：兼容 Android 10+ 的 Scoped Storage
- 📊 **实时日志**：查看详细的处理过程
- 🚀 **ARM 优化**：支持 `armeabi-v7a` 和 `arm64-v8a` 架构

## 🛠️ 技术栈

| 组件 | 技术 |
|------|------|
| 语言 | Kotlin + Python 3.8 |
| UI框架 | Material Components 3 |
| Python集成 | Chaquopy 15.0.1 |
| 构建工具 | Gradle 8.2 |
| 最低Android版本 | Android 7.0 (API 24) |
| 目标Android版本 | Android 14 (API 34) |

## 📦 项目结构

```
HBC-Tool-Android/
├── app/
│   ├── build.gradle.kts              # App 模块构建配置（含 Chaquopy）
│   ├── src/main/
│   │   ├── java/com/hbctool/android/
│   │   │   └── MainActivity.kt       # 主界面逻辑
│   │   ├── python/
│   │   │   ├── api_bridge.py         # Python 桥接模块
│   │   │   └── hbctool/              # ⚠️ HBC-Tool 源码（需手动添加）
│   │   ├── res/                      # UI 资源文件
│   │   └── AndroidManifest.xml       # 应用清单
├── build.gradle.kts                  # 项目构建配置
└── settings.gradle.kts               # Gradle 设置
```

## 🚀 快速开始

### 1️⃣ 环境要求

- **Android Studio**: Hedgehog (2023.1.1) 或更高
- **JDK**: 17 或更高
- **网络**: 首次构建需下载 Python 运行时和依赖（约 50MB）

### 2️⃣ 集成 HBC-Tool 源码

**关键步骤**：将 HBC-Tool 的 Python 源码放入项目

#### 方法 A：使用 Git（推荐）

```bash
cd app/src/main/python/
git clone https://github.com/Kirlif/HBC-Tool.git temp
cp -r temp/hbctool ./
rm -rf temp
```

#### 方法 B：手动下载

1. 从 [Kirlif/HBC-Tool](https://github.com/Kirlif/HBC-Tool) 下载源码 ZIP
2. 解压后，复制 `hbctool` 文件夹到 `app/src/main/python/`

**验证**：确保存在以下文件
```
app/src/main/python/
├── api_bridge.py         ✅
└── hbctool/
    ├── __init__.py       ✅
    ├── hbc/              ✅
    ├── disasm/           ✅
    └── asm/              ✅
```

### 3️⃣ 构建和运行

```powershell
# 方式 1: 命令行 (Windows)
.\gradlew.bat assembleDebug

# 方式 2: 命令行 (Linux/Mac)
./gradlew assembleDebug

# 方式 3: Android Studio
# 点击工具栏的 "Run" 按钮
```

**首次构建时间**：约 5-10 分钟（Chaquopy 下载 Python 环境）

### 4️⃣ 安装和测试

1. 将 `.apk` 安装到 Android 设备
2. 点击"选择 Bundle 文件"按钮
3. 选择 React Native 应用的 `index.android.bundle`
4. 点击"反汇编"查看 HASM 代码

## 📱 使用说明

### 反汇编 Bundle 文件

1. 打开 App
2. 点击"选择 Bundle 文件"
3. 从文件管理器选择 `.bundle` 文件
4. 点击"反汇编"
5. 在日志窗口查看输出路径

### 汇编 HASM 文件

1. 选择已修改的 `.hasm` 文件
2. 点击"汇编"
3. 生成新的 `.bundle` 文件

### 导出结果

- 点击右上角的"导出"图标
- 文件会保存到 `Downloads/HBC-Tool/` 目录

## ⚙️ 配置说明

### Chaquopy 依赖

在 [app/build.gradle.kts](app/build.gradle.kts) 中配置：

```kotlin
python {
    version = "3.8"
    pip {
        install("click==8.1.7")
        install("construct==2.10.68")
        install("colorama==0.4.6")
    }
}
```

### 支持的架构

```kotlin
ndk {
    abiFilters += listOf("armeabi-v7a", "arm64-v8a")
}
```

如需支持 x86 模拟器，添加：
```kotlin
abiFilters += listOf("x86", "x86_64")
```

## 🔧 常见问题

### Q1: 编译失败 "Python not found"

**原因**：Chaquopy 未能下载 Python 运行时

**解决方案**：
```powershell
# Windows 清理并重新构建
.\gradlew.bat clean
.\gradlew.bat build --refresh-dependencies

# Linux/Mac
./gradlew clean
./gradlew build --refresh-dependencies
```

### Q2: 运行时报错 "No module named 'hbctool'"

**原因**：未正确集成 HBC-Tool 源码

**解决方案**：
- 确认 `app/src/main/python/hbctool/` 目录存在
- 检查 `hbctool/__init__.py` 文件是否存在

### Q3: 文件选择后无法读取

**原因**：Android 11+ 的 Scoped Storage 限制

**解决方案**：
- App 已自动处理：文件会先复制到 App 私有目录
- 无需额外权限配置

### Q4: APK 体积过大

**原因**：包含完整的 Python 运行时

**优化方案**：
```kotlin
// 仅保留 ARM64（放弃老旧设备）
ndk {
    abiFilters.clear()
    abiFilters += "arm64-v8a"
}
```

预计减小约 30% 体积

## 📊 性能指标

| 指标 | 数值 |
|------|------|
| APK 大小 | 约 40MB（双架构） |
| 冷启动时间 | < 2秒 |
| Python 初始化 | < 500ms |
| 反汇编 1MB Bundle | < 3秒 |

## 🤝 贡献指南

欢迎提交 Issue 和 Pull Request！

### 开发流程

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

## 📄 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件

**依赖项目**：
- [Kirlif/HBC-Tool](https://github.com/Kirlif/HBC-Tool) - MIT License
- [Chaquopy](https://chaquo.com/chaquopy/) - Commercial License

## 🙏 致谢

- **Kirlif** - 感谢开源 [HBC-Tool](https://github.com/Kirlif/HBC-Tool)
- **Chaquo** - 提供强大的 [Chaquopy](https://chaquo.com/) Python 集成方案
- **React Native 社区** - Hermes 字节码格式文档

## 📞 联系方式

- 问题反馈：[GitHub Issues](https://github.com/yourusername/HBC-Tool-Android/issues)
- 讨论交流：[GitHub Discussions](https://github.com/yourusername/HBC-Tool-Android/discussions)

---

**⭐ 如果这个项目对你有帮助，请给个 Star！**
