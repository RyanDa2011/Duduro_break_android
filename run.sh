#!/system/bin/sh

# 检查是否在 Android 环境运行
if [ ! -d "/storage/emulated/0" ]; then
    echo "错误：此脚本只能在 Android 设备上运行！"
    exit 1
fi

# 检查必要文件是否存在
if [ ! -f "rewards.sh" ] || [ ! -f "xxtea.sh" ]; then
    echo "错误：请确保当前目录包含 rewards.sh 和 xxtea.sh 脚本！"
    exit 1
fi

# 第一步：执行 rewards.sh
echo "🔄 正在执行 rewards.sh..."
./rewards.sh
if [ $? -ne 0 ]; then
    echo "❌ rewards.sh 执行失败！"
    exit 1
fi

# 第二步：执行 xxtea.sh
echo "🔄 正在执行 xxtea.sh..."
./xxtea.sh
if [ $? -ne 0 ]; then
    echo "❌ xxtea.sh 执行失败！"
    exit 1
fi

# 第三步：原有文件复制操作
echo "🔄 开始文件复制流程..."

# 检查文件是否存在
if [ ! -f "GlobalConfigServer.luac" ] || [ ! -f "GlobalConfigServer.lua" ]; then
    echo "错误：请确保当前目录包含 GlobalConfigServer.luac 和 GlobalConfigServer.lua！"
    exit 1
fi

# 询问用户选择
echo "请选择版本："
echo "1. 手机版（com.kimoo.duduro）"
echo "2. 手表版（com.kimoo.kpet）"
echo -n "输入 1 或 2："
read choice 

case $choice in
    1)
        echo "正在复制到手机版目录..."
        target_dir="/storage/emulated/0/Android/data/com.kimoo.duduro/files/assertdata/HOT_UPDATE_3.3.6/src/app/"
        source_file="GlobalConfigServer.luac"
        ;;
    2)
        echo "正在复制到手表版目录..."
        target_dir="/storage/emulated/0/Android/data/com.kimoo.kpet/files/assertdata/HOT_UPDATE_3.1.5/src/app/"
        source_file="GlobalConfigServer.lua"
        ;;
    *)
        echo "无效选择！请输入 1 或 2。"
        exit 1
        ;;
esac

# 检查目标目录是否存在
if [ ! -d "$target_dir" ]; then
    echo "错误：目标目录不存在，请确保游戏已安装！"
    exit 1
fi

# 复制并替换文件
echo "正在复制文件 $source_file 到 $target_dir..."
cp -f "$source_file" "$target_dir"

if [ $? -eq 0 ]; then
    echo "✅ 所有操作完成！文件已成功替换！"
else
    echo "❌ 文件替换失败，请检查权限！"
    exit 1
fi