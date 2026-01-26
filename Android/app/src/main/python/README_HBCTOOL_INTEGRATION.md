# HBC-Tool 源码集成说明

## 目录结构

将 HBC-Tool 的 Python 源代码放置在此目录：

```
app/src/main/python/
├── api_bridge.py          # 已创建 - Android 调用的桥接模块
└── hbctool/               # ⚠️ 需要手动添加
    ├── __init__.py
    ├── hbc/
    │   ├── __init__.py
    │   ├── hbc.py         # HBC 字节码解析核心
    │   └── ...
    ├── disasm/
    │   ├── __init__.py
    │   └── ...
    ├── asm/
    │   ├── __init__.py
    │   └── ...
    └── ...
```

## 如何集成 HBC-Tool 源码

### 方法 1：从 GitHub 克隆（推荐）

```bash
# 在项目根目录执行
cd app/src/main/python/
git clone https://github.com/Kirlif/HBC-Tool.git temp_hbc
cp -r temp_hbc/hbctool ./
rm -rf temp_hbc
```

### 方法 2：手动下载

1. 访问 https://github.com/Kirlif/HBC-Tool
2. 下载源码 ZIP 包
3. 解压后，将 `hbctool` 文件夹复制到 `app/src/main/python/`

## 验证集成

完成后，目录应该包含：

- ✅ `api_bridge.py` (已存在)
- ✅ `hbctool/__init__.py`
- ✅ `hbctool/hbc/hbc.py`
- ✅ `hbctool/disasm/...`
- ✅ `hbctool/asm/...`

## 注意事项

1. **不要通过 pip 安装**：Chaquopy 的 `pip install hbctool` 可能版本滞后，直接使用源码可以自由修改。

2. **依赖已配置**：`app/build.gradle.kts` 中已经配置了核心依赖：
   - click
   - construct  
   - colorama

3. **命令行代码需要调整**：HBC-Tool 原本设计给命令行使用，可能需要修改部分代码：
   - 移除 `sys.argv` 相关逻辑
   - 将 `print()` 输出改为返回值
   - 移除 `click` 装饰器（或保留但不使用）

## 测试模式

当前 `api_bridge.py` 包含简化模式：

- 如果 `hbctool` 模块导入失败，会生成测试输出
- 显示文件魔数和基本信息
- 用于验证 Android 集成是否正常

完成源码集成后，真正的反汇编/汇编功能将自动启用。

## 下一步

1. 按照上述方法集成 HBC-Tool 源码
2. 在 Android Studio 中构建项目
3. 运行到真机/模拟器测试
4. 选择 `.bundle` 文件进行反汇编

---

**提示**：首次编译时，Chaquopy 会下载 Python 运行时和依赖库，可能需要几分钟，请耐心等待。
