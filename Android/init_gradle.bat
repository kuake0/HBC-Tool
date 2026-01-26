@echo off
chcp 65001 >nul
echo ========================================
echo 初始化 Gradle Wrapper
echo ========================================
echo.

echo 提示: 如果 gradle-wrapper.jar 缺失，
echo 请在 Android Studio 中执行以下操作：
echo.
echo 1. File → Open → E:\AI\HBCTool
echo 2. 等待 Gradle 同步完成
echo 3. 或运行: gradle wrapper --gradle-version 8.2
echo.

where gradle >nul 2>&1
if %errorlevel% neq 0 (
    echo ⚠️  系统未安装 Gradle
    echo 建议: 在 Android Studio 中打开项目，它会自动下载 Gradle
    pause
    exit /b 0
)

echo [*] 检测到系统 Gradle，正在生成 Wrapper...
gradle wrapper --gradle-version 8.2

if %errorlevel% equ 0 (
    echo.
    echo ✅ Gradle Wrapper 已生成！
    echo.
    echo 现在可以运行:
    echo   .\gradlew.bat assembleDebug
    echo.
) else (
    echo.
    echo ❌ 生成失败
    echo.
    echo 解决方案:
    echo   在 Android Studio 中: File → Open → E:\AI\HBCTool
    echo   Android Studio 会自动配置 Gradle Wrapper
    echo.
)

pause
