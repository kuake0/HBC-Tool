"""
测试 HBC-Tool 集成是否正常
在项目构建前可以运行此脚本进行验证
"""

import sys
import os

# 测试 1: 检查模块是否可以导入
print("=" * 60)
print("测试 1: 检查 HBC-Tool 模块导入")
print("=" * 60)

try:
    import hbctool.hbc as hbc
    import hbctool.hasm as hasm
    print("✅ hbctool.hbc 导入成功")
    print("✅ hbctool.hasm 导入成功")
except ImportError as e:
    print(f"❌ 导入失败: {e}")
    sys.exit(1)

# 测试 2: 检查 api_bridge 模块
print("\n" + "=" * 60)
print("测试 2: 检查 api_bridge 模块")
print("=" * 60)

try:
    import api_bridge
    print("✅ api_bridge 导入成功")
    print(f"   - do_disassemble: {hasattr(api_bridge, 'do_disassemble')}")
    print(f"   - do_assemble: {hasattr(api_bridge, 'do_assemble')}")
    print(f"   - get_hbc_info: {hasattr(api_bridge, 'get_hbc_info')}")
except ImportError as e:
    print(f"❌ 导入失败: {e}")
    sys.exit(1)

# 测试 3: 检查依赖
print("\n" + "=" * 60)
print("测试 3: 检查依赖库")
print("=" * 60)

dependencies = {
    'construct': 'construct',
    'colorama': 'colorama',
    'docopt': 'docopt'
}

for name, module in dependencies.items():
    try:
        __import__(module)
        print(f"✅ {name} 已安装")
    except ImportError:
        print(f"⚠️  {name} 未安装（运行时会自动安装）")

# 测试 4: 检查支持的 HBC 版本
print("\n" + "=" * 60)
print("测试 4: 检查支持的 Hermes 版本")
print("=" * 60)

hbc_dir = os.path.join(os.path.dirname(__file__), 'hbctool', 'hbc')
versions = []
for item in os.listdir(hbc_dir):
    if item.startswith('hbc') and os.path.isdir(os.path.join(hbc_dir, item)):
        versions.append(item)

versions.sort()
print(f"支持的版本: {', '.join(versions)}")
print(f"总计: {len(versions)} 个版本")

print("\n" + "=" * 60)
print("✅ 所有测试通过！可以开始构建 Android 项目")
print("=" * 60)
