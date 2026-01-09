# KillWatermark - Gemini Nano Banana Pro 浮水印移除工具

在 MacOS 中使用「快速動作」一鍵移除 Gemini Nano Banana Pro 生成圖片上的浮水印。

## ✨ 功能特色

- 🖱️ **右鍵快速動作** - 直接在 Finder 中右鍵選擇圖片即可移除浮水印
- 🎯 **自動偵測** - 智慧偵測浮水印位置（支援 48x48 和 96x96 尺寸）
- 🔄 **批次處理** - 可同時選擇多張圖片一次處理
- 💾 **保留原檔** - 處理後的圖片會加上 `_no_watermark` 後綴

## 📦 系統需求

- macOS 10.14 (Mojave) 或更新版本
- Python 3.8+
- Pillow 和 NumPy 套件

## 🚀 快速安裝

### 方法一：使用安裝腳本（推薦）

```bash
cd /path/to/KillWatermark
chmod +x install.sh
./install.sh
```

### 方法二：手動安裝

詳見 [INSTALL.md](INSTALL.md)

## 📖 使用方式

### 透過快速動作（推薦）

1. 在 Finder 中選擇一張或多張圖片
2. 右鍵點選 → **快速動作** → **移除浮水印**
3. 處理完成後，新檔案會出現在同一目錄

### 透過命令列

```bash
# 處理單張圖片（自動產生新檔案）
python3 remove_watermark.py input.png

# 指定輸出路徑
python3 remove_watermark.py input.png output.png
```

## 🔧 解除安裝

```bash
chmod +x uninstall.sh
./uninstall.sh
```

## 📁 檔案結構

```
KillWatermark/
├── README.md              # 說明文件
├── INSTALL.md             # 安裝指南
├── install.sh             # 安裝腳本
├── uninstall.sh           # 解除安裝腳本
├── remove_watermark.py    # 主程式
└── ref/
    └── remove_watermark.js  # 參考實作
```

## ⚠️ 注意事項

- 本工具僅供個人學習研究使用
- 請遵守相關服務的使用條款
- 處理後的圖片會保存為 PNG 或 JPEG 格式

## 🐛 問題排除

### 快速動作沒有出現

1. 確認已執行安裝腳本
2. 重新啟動 Finder（`killall Finder`）
3. 檢查「系統設定」→「隱私權與安全性」→「延伸功能」→「Finder」

### Python 找不到

確保已安裝 Python 3：

```bash
# 使用 Homebrew 安裝
brew install python3

# 或從官網下載
# https://www.python.org/downloads/
```

### 套件未安裝

```bash
pip3 install Pillow numpy
```

## 📄 授權

MIT License
