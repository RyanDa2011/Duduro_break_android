#!/system/bin/sh
INPUT_FILE="GlobalConfigServer.lua"
OUTPUT_FILE="GlobalConfigServer.luac"
KEY="duduro666"

XXTEA_BIN="./xxtea"
[ -x "$XXTEA_BIN" ] || { echo "错误: 找不到 xxtea"; exit 1; }

# 一步生成带签名+加密数据的文件
"$XXTEA_BIN" "$INPUT_FILE" "$OUTPUT_FILE" "$KEY"

echo "处理完成，输出文件: $OUTPUT_FILE"