# 🧹 clean-jpg-cleaner

一个适用于 **macOS** 的 Shell 脚本，用于清理与其他同名主文件重复的 `.jpg/.jpeg` 文件。支持交互操作、Dry-run 模拟、安全删除到废纸篓、日志记录、并发加速等功能。

---

## ✨ 功能特性

- 🔍 自动扫描同名但不同扩展名的主文件，定位冗余 `.jpg` 或 `.jpeg`
- 🗑️ 可选择移动至废纸篓或直接永久删除
- 🤖 Dry-run 模式：仅预览将删除的文件，确保安全
- 📝 删除操作自动写入日志文件（含时间戳）
- ⚡ 使用 `xargs` 实现并发删除，提升效率
- 📂 支持命令行参数或交互输入目录路径

---

## 🚀 使用方式

### 1. 获取脚本

```bash
git clone https://github.com/BSakura-Miku/clean-jpg-cleaner.git
cd clean-jpg-cleaner
chmod +x clean-jpg-cleaner.sh
```

### 2. 运行脚本（交互模式）

```bash
./clean-jpg-cleaner.sh
```

你将被提示：

- 输入待处理的目录路径（默认当前目录）
- 选择删除方式（废纸篓 / 永久删除）
- 是否启用 Dry-run 模式

### 3. 命令行参数方式（非交互）

```bash
./clean-jpg-cleaner.sh /路径/to/目录 --trash --dry-run
```

可选参数说明：

| 参数       | 说明                         |
|------------|------------------------------|
| `--trash`  | 删除时移动至废纸篓（默认）  |
| `--force`  | 永久删除（不可恢复）         |
| `--dry-run`| 模拟模式，仅显示将被删除的文件 |

---

## 📄 示例输出（dry-run 模式）

```
📂 扫描目录: /Volumes/DATA/Pictures

📦 发现同名主文件，目标 jpg 文件:
    - IMG_0012.jpg（主文件：IMG_0012.CR2）
    - IMG_0013.jpeg（主文件：IMG_0013.NEF）

🔍 dry-run 模式开启：以下文件将被删除但未执行实际操作。
📝 日志文件已保存至: clean_jpg_deleted_2025-07-06_173301.log
```

---

## 🗂️ 项目结构

```
clean-jpg-cleaner/
├── clean-jpg-cleaner.sh    # 主脚本
├── README.md               # 项目说明
├── LICENSE                 # 开源许可证（MIT）
└── .gitignore              # 忽略文件配置
```

---

## 📎 常见用途

- 清理照片备份目录中 `.jpg` + `.cr2` / `.nef` / `.arw` 并存的重复文件
- 避免 Lightroom/Photo Mechanic 导出的 jpeg 叠加
- 批量整理拍摄素材和输出结果

---

## 🧾 日志示例

所有删除的 `.jpg/.jpeg` 文件都将记录在日志文件中（含日期时间），便于审计与回溯。

```
clean_jpg_deleted_2025-07-06_173301.log
```

---

## 🧪 兼容环境

- ✅ macOS 10.14+
- ✅ 兼容 `zsh` / `bash`（推荐使用 bash 5.0+）
- 🔄 `osascript` 用于废纸篓操作

---

## 📄 License

[MIT](LICENSE) © 2025 [BSakura-Miku](https://github.com/BSakura-Miku)

---

## ⭐ Star 支持作者

如果你觉得本项目有用，请点一个 Star ⭐ 鼓励作者继续优化脚本！  
欢迎 issue / PR / 改进建议 ❤️
