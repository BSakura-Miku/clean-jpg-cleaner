#!/opt/homebrew/bin/bash
###
 # @Author: bsakura
 # @Date: 2025-07-06 16:41:35
 # @LastEditors: bsakura
 # @LastEditTime: 2025-07-06 17:31:39
 # @FilePath: /undefined/Users/bsakura/Desktop/clean_jpg.sh
 # @Description: 删除同名jpeg文件
 # 
 # Copyright (c) 2025 by bsakura, All Rights Reserved. 
### 

# ========== 用户交互部分 ==========
read -e -p "📂 输入要扫描的目录（默认当前目录）: " INPUT_DIR
TARGET_DIR="${INPUT_DIR:-.}"

if [[ ! -d "$TARGET_DIR" ]]; then
    echo "❌ 路径无效：$TARGET_DIR"
    exit 1
fi

echo "⚙️ 请选择删除方式："
echo "1. 🗑️ 移动到废纸篓（推荐）"
echo "2. ❌ 永久删除（不可恢复）"
read -p "请输入选项 [1/2]（默认 1）: " DELETE_MODE
DELETE_MODE="${DELETE_MODE:-1}"

echo "💡 是否启用 dry-run（仅预览，不执行删除）？"
read -p "启用 dry-run 模式？[y/N]: " DRY_RUN_CONFIRM
DRY_RUN=false
[[ "$DRY_RUN_CONFIRM" =~ ^[Yy]$ ]] && DRY_RUN=true

LOG_FILE="./clean_jpg_deleted_$(date +"%Y%m%d_%H%M%S").log"
touch "$LOG_FILE"

# 并发删除进程数
MAX_PARALLEL=4

# ========== 文件收集与预处理 ==========
declare -A file_map
mapfile -d '' all_files < <(find "$TARGET_DIR" -type f -print0)

# 构建文件映射
for file in "${all_files[@]}"; do
    base="${file%.*}"
    ext="${file##*.}"
    ext_lc=$(echo "$ext" | tr '[:upper:]' '[:lower:]')
    file_map["$base"]+="${ext_lc} "
done

# 找出待删除的 .jpg/.jpeg 文件
to_delete=()
for base in "${!file_map[@]}"; do
    exts="${file_map[$base]}"
    if [[ "$exts" =~ (jpg|jpeg) ]] && [[ ! "$exts" =~ ^(jpg|jpeg)[[:space:]]*$ ]]; then
        for ext in $exts; do
            if [[ "$ext" == "jpg" || "$ext" == "jpeg" ]]; then
                file="${base}.${ext}"
                to_delete+=("$file")
            fi
        done
    fi
done

# ========== 输出预览 ==========
if [[ ${#to_delete[@]} -eq 0 ]]; then
    echo "✅ 没有符合条件的 JPG 文件。"
    exit 0
fi

echo "⚠️ 以下 ${#to_delete[@]} 个文件将被处理："
for file in "${to_delete[@]}"; do
    echo "🗂️ $file"
done

# dry-run 模式下提前退出
if $DRY_RUN; then
    echo "🚫 dry-run 模式开启，仅预览，无文件被删除。"
    exit 0
fi

# ========== 确认删除 ==========
echo ""
read -p "❓确认删除这些文件？[y/N]: " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "🚫 操作已取消。"
    exit 0
fi

# ========== 删除函数 ==========
delete_file() {
    f="$1"
    if [[ "$DELETE_MODE" == "2" ]]; then
        rm "$f"
    else
        osascript -e 'tell application "Finder" to delete POSIX file "'"$f"'"'
    fi
    echo "$f" >> "$LOG_FILE"
}

export -f delete_file
export DELETE_MODE LOG_FILE

# ========== 并发执行删除 ==========
printf "%s\n" "${to_delete[@]}" | xargs -P "$MAX_PARALLEL" -I{} bash -c 'delete_file "$@"' _ {}

# ========== 完成 ==========
echo "✅ 删除完成，共 ${#to_delete[@]} 个文件。日志保存在：$LOG_FILE"