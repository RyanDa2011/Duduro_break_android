#!/system/bin/sh

# 硬编码文件路径（与脚本同目录）
FILE="GlobalConfigServer.lua"
BACKUP="$FILE.bak"

# 检查文件是否存在
if [ ! -f "$FILE" ]; then
  echo "错误: 未找到 $FILE 文件"
  exit 1
fi

# 查找起始行号（GlobalConfigServer.LEVEL = {）
find_start_line() {
  grep -n "GlobalConfigServer.LEVEL = {" "$FILE" | cut -d: -f1
}

# 主逻辑
modify_rewards() {
  # 获取起始行号
  start_line=$(find_start_line)+1
  if [ -z "$start_line" ]; then
    echo "错误: 找不到LEVEL配置起始行"
    exit 1
  fi

  # 用户输入等级
  while true; do
    echo -n "请输入要修改的等级 (当前等级+1): "
    read level
    if [ "$level" -gt 0 ] 2>/dev/null; then
      break
    fi
    echo "请输入有效的数字"
  done

  # 计算目标行号
  target_line=$((start_line + level))
  prev_line=$((target_line - 1))

  # 检查行号有效性
  total_lines=$(wc -l < "$FILE")
  if [ "$target_line" -gt "$total_lines" ]; then
    echo "错误: 文件没有等级 $level 的配置"
    exit 1
  fi

  # 生成配置内容
  prev_content="    [$((level-1))]={level=$((level-1)),expmax=0,reward={[1]={[1]=0,[2]=70,},},},"
  target_content="    [$level]={level=$level,expmax=0,reward={[1]={[1]=0,[2]=9999,},[2]={[1]=112,[2]=9999,},[3]={[1]=4004,[2]=1,},[4]={[1]=4000,[2]=1,},[5]={[1]=4001,[2]=1,},[6]={[1]=4002,[2]=1,},[7]={[1]=4003,[2]=1,},[8]={[1]=4004,[2]=1,},[9]={[1]=4005,[2]=1,},[10]={[1]=4006,[2]=1,},[11]={[1]=4007,[2]=1,},[12]={[1]=4008,[2]=1,},[13]={[1]=7002,[2]=1,},[14]={[1]=7004,[2]=1,},[15]={[1]=7006,[2]=1,},[16]={[1]=7007,[2]=1,},[17]={[1]=124,[2]=2000,},[18]={[1]=9011,[2]=5000,},[19]={[1]=20015,[2]=1,},[20]={[1]=20016,[2]=1,},[21]={[1]=20017,[2]=1,},[22]={[1]=20018,[2]=1,},[23]={[1]=20019,[2]=1,},[24]={[1]=20020,[2]=1,},[25]={[1]=20021,[2]=1,},},},"

  # 创建备份
  cp "$FILE" "$BACKUP" || {
    echo "错误: 无法创建备份文件"
    exit 1
  }

  # 修改文件内容
  awk -v prev_line="$prev_line" \
      -v target_line="$target_line" \
      -v prev_content="$prev_content" \
      -v target_content="$target_content" \
      '{
        if (NR == prev_line) print prev_content;
        else if (NR == target_line) print target_content;
        else print $0;
      }' "$BACKUP" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"

  echo "修改成功:"
  echo "- 等级 $((level-1)) (行号: $prev_line) - 简化的奖励配置"
  echo "- 等级 $level (行号: $target_line) - 完整的奖励配置"
  echo "原始文件已备份为: $BACKUP"
}

# 执行主函数
modify_rewards