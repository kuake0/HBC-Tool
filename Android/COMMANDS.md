# 🚀 快速命令参考

## Windows PowerShell 命令

### 查看 Gradle 版本
```powershell
.\gradlew.bat --version
```

### 清理项目
```powershell
.\gradlew.bat clean
```

### 构建 Debug APK
```powershell
.\gradlew.bat assembleDebug
```

### 构建 Release APK
```powershell
.\gradlew.bat assembleRelease
```

### 安装到设备
```powershell
.\gradlew.bat installDebug
```

### 查看所有任务
```powershell
.\gradlew.bat tasks
```

### 刷新依赖
```powershell
.\gradlew.bat build --refresh-dependencies
```

### 使用快捷脚本（推荐）
```powershell
.\build.bat
```

---

## Linux/Mac 命令

### 构建 Debug APK
```bash
./gradlew assembleDebug
```

### 使用快捷脚本
```bash
chmod +x build.sh
./build.sh
```

---

## Android Studio 方式（最简单）

1. **打开项目**: File → Open → `E:\AI\HBCTool`
2. **等待同步**: 底部状态栏显示 "Sync successful"
3. **运行**: 点击工具栏绿色 ▶️ 按钮

---

## 常见问题

### ❌ `./gradlew: 无法识别`

**错误**:
```
./gradlew : 无法将"./gradlew"项识别为 cmdlet
```

**解决**: Windows 使用 `.bat` 扩展名
```powershell
# ❌ 错误
./gradlew assembleDebug

# ✅ 正确
.\gradlew.bat assembleDebug
```

---

### ❌ `gradle-wrapper.jar 缺失`

**错误**:
```
Error: Could not find or load main class org.gradle.wrapper.GradleWrapperMain
```

**解决方案 1**: 在 Android Studio 中打开项目（推荐）
- Android Studio 会自动下载并配置 Gradle

**解决方案 2**: 手动生成（需安装 Gradle）
```powershell
gradle wrapper --gradle-version 8.2
```

---

### ❌ Java 版本不匹配

**错误**:
```
Unsupported Java version
```

**检查 Java 版本**:
```powershell
java -version
```

**要求**: JDK 17 或更高

**设置 JAVA_HOME** (如果已安装但未识别):
```powershell
# 临时设置
$env:JAVA_HOME = "C:\Program Files\Java\jdk-17"

# 永久设置（系统环境变量）
# 控制面板 → 系统 → 高级系统设置 → 环境变量
```

---

## 构建输出位置

### Debug APK
```
app\build\outputs\apk\debug\app-debug.apk
```

### Release APK
```
app\build\outputs\apk\release\app-release.apk
```

---

## 下一步

1. **首次构建**: 运行 `.\gradlew.bat assembleDebug`
2. **查看详细文档**: [README.md](README.md)
3. **快速启动**: [QUICKSTART.md](QUICKSTART.md)
