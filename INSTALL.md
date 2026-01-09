# 安裝指南

## 自動安裝

執行安裝腳本即可自動完成所有設定：

```bash
cd /path/to/KillWatermark
chmod +x install.sh
./install.sh
```

## 手動安裝

如果自動安裝失敗，請按照以下步驟手動安裝。

### 步驟 1：安裝 Python 依賴套件

```bash
pip3 install Pillow numpy
```

### 步驟 2：設定執行權限

```bash
chmod +x /path/to/KillWatermark/remove_watermark.py
```

### 步驟 3：建立快速動作

#### 方法 A：使用 Automator（圖形介面）

1. 開啟 **Automator**（在「應用程式」資料夾中）
2. 選擇「新增文件」→「快速動作」
3. 設定工作流程：
   - **工作流程接收目前的：** 影像檔案
   - **位於：** Finder.app
4. 從左側動作庫拖入「執行 Shell 工序指令」
5. 設定：
   - **Shell：** /bin/zsh
   - **傳遞輸入：** 作為引數
6. 輸入以下腳本（請修改路徑）：

```bash
export PATH="/usr/local/bin:/opt/homebrew/bin:$PATH"

for f in "$@"; do
    /usr/bin/python3 "/path/to/KillWatermark/remove_watermark.py" "$f"
done

osascript -e 'display notification "浮水印移除完成！" with title "KillWatermark"'
```

1. 儲存為「**移除浮水印**」

#### 方法 B：直接複製工作流程檔案

安裝腳本會自動建立工作流程檔案在：

```
~/Library/Services/移除浮水印.workflow
```

### 步驟 4：啟用快速動作

1. 開啟「**系統設定**」
2. 前往「**隱私權與安全性**」→「**延伸功能**」
3. 點選「**Finder**」
4. 確認「**移除浮水印**」已勾選

### 步驟 5：重新啟動 Finder

```bash
killall Finder
```

## 驗證安裝

1. 在 Finder 中找一張圖片
2. 右鍵點選 → 快速動作 → 移除浮水印
3. 檢查是否產生 `_no_watermark` 結尾的新檔案

## 常見問題

### Q: 快速動作選單中沒有看到「移除浮水印」

**A:** 請確認：

1. 工作流程檔案存在於 `~/Library/Services/`
2. 在「系統設定」→「延伸功能」→「Finder」中已啟用
3. 嘗試重新啟動 Finder：`killall Finder`

### Q: 執行時出現 Python 錯誤

**A:** 請確認：

1. Python 3 已正確安裝：`python3 --version`
2. 依賴套件已安裝：`pip3 list | grep -E "Pillow|numpy"`
3. 腳本路徑正確

### Q: 權限被拒絕

**A:** 首次執行可能需要授權：

1. 開啟「系統設定」→「隱私權與安全性」
2. 在「安全性」區塊點選「仍要允許」
3. 或在「自動化」中允許 Finder 控制

## 解除安裝

```bash
chmod +x uninstall.sh
./uninstall.sh
```

或手動刪除：

```bash
rm -rf ~/Library/Services/移除浮水印.workflow
```
