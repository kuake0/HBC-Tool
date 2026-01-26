#!/bin/bash

echo "========================================"
echo "HBC-Tool Android 快速构建脚本"
echo "========================================"
echo ""

echo "[1/4] 检查环境..."
if [ ! -f "gradlew" ]; then
    echo "❌ 错误: 请在项目根目录运行此脚本"
    exit 1
fi
echo "✅ 环境检查通过"

echo ""
echo "[2/4] 清理旧构建..."
./gradlew clean || echo "⚠️  清理失败，继续构建..."

echo ""
echo "[3/4] 开始构建 (首次可能需要 10-15 分钟)..."
echo "提示: Chaquopy 会下载 Python 3.8 和依赖库"
echo ""

./gradlew assembleDebug
if [ $? -ne 0 ]; then
    echo ""
    echo "❌ 构建失败！"
    echo "请检查错误信息或在 Android Studio 中查看详细日志"
    exit 1
fi

echo ""
echo "[4/4] 构建完成！"
echo ""
echo "========================================"
echo "✅ APK 已生成"
echo "========================================"
echo ""
echo "位置: app/build/outputs/apk/debug/app-debug.apk"
echo ""
echo "下一步:"
echo "  1. 安装到设备: adb install app/build/outputs/apk/debug/app-debug.apk"
echo "  2. 或在 Android Studio 中点击 Run 按钮"
echo ""
