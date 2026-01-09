#!/bin/bash
#
# KillWatermark 安裝腳本
# 為 macOS 建立「移除浮水印」快速動作
#

set -e

# 顏色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 取得腳本所在目錄的絕對路徑
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKFLOW_NAME="移除 Nano Banana Pro 浮水印"
SERVICES_DIR="$HOME/Library/Services"
WORKFLOW_PATH="$SERVICES_DIR/${WORKFLOW_NAME}.workflow"

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║      KillWatermark 安裝程式            ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

# 檢查 Python 3
echo -e "${YELLOW}[1/5]${NC} 檢查 Python 3..."
if command -v python3 &>/dev/null; then
	PYTHON_PATH=$(which python3)
	PYTHON_VERSION=$(python3 --version 2>&1)
	echo -e "  ${GREEN}✓${NC} 找到 $PYTHON_VERSION"
	echo -e "  ${GREEN}✓${NC} 路徑: $PYTHON_PATH"
else
	echo -e "  ${RED}✗${NC} 未找到 Python 3"
	echo -e "  請先安裝 Python 3："
	echo -e "    brew install python3"
	echo -e "  或從 https://www.python.org/downloads/ 下載"
	exit 1
fi

# 檢查並安裝依賴套件
echo ""
echo -e "${YELLOW}[2/5]${NC} 檢查 Python 依賴套件..."

install_package() {
	local package=$1
	if python3 -c "import $package" 2>/dev/null; then
		echo -e "  ${GREEN}✓${NC} $package 已安裝"
	else
		echo -e "  ${YELLOW}○${NC} 正在安裝 $package..."
		pip3 install $package --quiet
		echo -e "  ${GREEN}✓${NC} $package 安裝完成"
	fi
}

install_package "PIL"
install_package "numpy"

# 設定主程式執行權限
echo ""
echo -e "${YELLOW}[3/5]${NC} 設定執行權限..."
chmod +x "$SCRIPT_DIR/remove_watermark.py"
echo -e "  ${GREEN}✓${NC} 已設定 remove_watermark.py 執行權限"

# 建立 Services 目錄
echo ""
echo -e "${YELLOW}[4/5]${NC} 建立快速動作..."
mkdir -p "$SERVICES_DIR"

# 移除舊的工作流程（如果存在）
if [ -d "$WORKFLOW_PATH" ]; then
	rm -rf "$WORKFLOW_PATH"
	echo -e "  ${YELLOW}○${NC} 已移除舊版本"
fi

# 建立工作流程目錄結構
mkdir -p "$WORKFLOW_PATH/Contents"

# 建立 Info.plist
cat >"$WORKFLOW_PATH/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>NSServices</key>
    <array>
        <dict>
            <key>NSMenuItem</key>
            <dict>
                <key>default</key>
                <string>移除浮水印</string>
            </dict>
            <key>NSMessage</key>
            <string>runWorkflowAsService</string>
            <key>NSRequiredContext</key>
            <dict>
                <key>NSApplicationIdentifier</key>
                <string>com.apple.finder</string>
            </dict>
            <key>NSSendFileTypes</key>
            <array>
                <string>public.image</string>
            </array>
        </dict>
    </array>
</dict>
</plist>
PLIST

# 建立 document.wflow
cat >"$WORKFLOW_PATH/Contents/document.wflow" <<WFLOW
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>AMApplicationBuild</key>
    <string>523</string>
    <key>AMApplicationVersion</key>
    <string>2.10</string>
    <key>AMDocumentVersion</key>
    <string>2</string>
    <key>actions</key>
    <array>
        <dict>
            <key>action</key>
            <dict>
                <key>AMAccepts</key>
                <dict>
                    <key>Container</key>
                    <string>List</string>
                    <key>Optional</key>
                    <true/>
                    <key>Types</key>
                    <array>
                        <string>com.apple.cocoa.string</string>
                    </array>
                </dict>
                <key>AMActionVersion</key>
                <string>2.0.3</string>
                <key>AMApplication</key>
                <array>
                    <string>Automator</string>
                </array>
                <key>AMCategory</key>
                <string>AMCategoryUtilities</string>
                <key>AMIconName</key>
                <string>Run Shell Script</string>
                <key>AMName</key>
                <string>執行 Shell 工序指令</string>
                <key>AMParameterProperties</key>
                <dict>
                    <key>COMMAND_STRING</key>
                    <dict/>
                    <key>CheckedForUserDefaultShell</key>
                    <dict/>
                    <key>inputMethod</key>
                    <dict/>
                    <key>shell</key>
                    <dict/>
                    <key>source</key>
                    <dict/>
                </dict>
                <key>AMProvides</key>
                <dict>
                    <key>Container</key>
                    <string>List</string>
                    <key>Types</key>
                    <array>
                        <string>com.apple.cocoa.string</string>
                    </array>
                </dict>
                <key>AMRequiredResources</key>
                <array/>
                <key>ActionBundlePath</key>
                <string>/System/Library/Automator/Run Shell Script.action</string>
                <key>ActionName</key>
                <string>執行 Shell 工序指令</string>
                <key>ActionParameters</key>
                <dict>
                    <key>COMMAND_STRING</key>
                    <string>#!/bin/zsh

# 設定 PATH 以確保找得到 python3
export PATH="/usr/local/bin:/opt/homebrew/bin:/usr/bin:\$PATH"

# 腳本路徑
SCRIPT_PATH="${SCRIPT_DIR}/remove_watermark.py"

# 計數器
SUCCESS=0
FAIL=0

# 處理每個輸入檔案
for f in "\$@"; do
    if /usr/bin/python3 "\$SCRIPT_PATH" "\$f" 2>/dev/null; then
        ((SUCCESS++))
    else
        ((FAIL++))
    fi
done

# 顯示通知
if [ \$FAIL -eq 0 ]; then
    osascript -e "display notification \"成功處理 \$SUCCESS 張圖片\" with title \"KillWatermark\" sound name \"Glass\""
else
    osascript -e "display notification \"成功: \$SUCCESS, 失敗: \$FAIL\" with title \"KillWatermark\" sound name \"Basso\""
fi
</string>
                    <key>CheckedForUserDefaultShell</key>
                    <true/>
                    <key>inputMethod</key>
                    <integer>1</integer>
                    <key>shell</key>
                    <string>/bin/zsh</string>
                    <key>source</key>
                    <string></string>
                </dict>
                <key>BundleIdentifier</key>
                <string>com.apple.RunShellScript</string>
                <key>CFBundleVersion</key>
                <string>2.0.3</string>
                <key>CanShowSelectedItemsWhenRun</key>
                <false/>
                <key>CanShowWhenRun</key>
                <true/>
                <key>Category</key>
                <array>
                    <string>AMCategoryUtilities</string>
                </array>
                <key>Class Name</key>
                <string>RunShellScriptAction</string>
                <key>InputUUID</key>
                <string>$(uuidgen)</string>
                <key>Keywords</key>
                <array>
                    <string>Shell</string>
                    <string>工序指令</string>
                    <string>指令</string>
                    <string>執行</string>
                    <string>Unix</string>
                </array>
                <key>OutputUUID</key>
                <string>$(uuidgen)</string>
                <key>UUID</key>
                <string>$(uuidgen)</string>
                <key>UnlocalizedApplications</key>
                <array>
                    <string>Automator</string>
                </array>
                <key>arguments</key>
                <dict>
                    <key>0</key>
                    <dict>
                        <key>default value</key>
                        <integer>0</integer>
                        <key>name</key>
                        <string>inputMethod</string>
                        <key>required</key>
                        <string>0</string>
                        <key>type</key>
                        <string>0</string>
                        <key>uuid</key>
                        <string>0</string>
                    </dict>
                    <key>1</key>
                    <dict>
                        <key>default value</key>
                        <string></string>
                        <key>name</key>
                        <string>source</string>
                        <key>required</key>
                        <string>0</string>
                        <key>type</key>
                        <string>0</string>
                        <key>uuid</key>
                        <string>1</string>
                    </dict>
                    <key>2</key>
                    <dict>
                        <key>default value</key>
                        <false/>
                        <key>name</key>
                        <string>CheckedForUserDefaultShell</string>
                        <key>required</key>
                        <string>0</string>
                        <key>type</key>
                        <string>0</string>
                        <key>uuid</key>
                        <string>2</string>
                    </dict>
                    <key>3</key>
                    <dict>
                        <key>default value</key>
                        <string></string>
                        <key>name</key>
                        <string>COMMAND_STRING</string>
                        <key>required</key>
                        <string>0</string>
                        <key>type</key>
                        <string>0</string>
                        <key>uuid</key>
                        <string>3</string>
                    </dict>
                    <key>4</key>
                    <dict>
                        <key>default value</key>
                        <string>/bin/sh</string>
                        <key>name</key>
                        <string>shell</string>
                        <key>required</key>
                        <string>0</string>
                        <key>type</key>
                        <string>0</string>
                        <key>uuid</key>
                        <string>4</string>
                    </dict>
                </dict>
                <key>isViewVisible</key>
                <integer>1</integer>
                <key>location</key>
                <string>529.000000:253.000000</string>
                <key>nibPath</key>
                <string>/System/Library/Automator/Run Shell Script.action/Contents/Resources/Base.lproj/main.nib</string>
            </dict>
            <key>isViewVisible</key>
            <integer>1</integer>
        </dict>
    </array>
    <key>connectors</key>
    <dict/>
    <key>workflowMetaData</key>
    <dict>
        <key>workflowTypeIdentifier</key>
        <string>com.apple.Automator.servicesMenu</string>
    </dict>
</dict>
</plist>
WFLOW

echo -e "  ${GREEN}✓${NC} 已建立快速動作: ${WORKFLOW_NAME}"

# 重新註冊服務
echo ""
echo -e "${YELLOW}[5/5]${NC} 註冊快速動作..."
/System/Library/CoreServices/pbs -update
echo -e "  ${GREEN}✓${NC} 已更新服務註冊"

# 完成訊息
echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║           安裝完成！                   ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "使用方式："
echo -e "  1. 在 Finder 中選擇圖片"
echo -e "  2. 右鍵 → ${BLUE}快速動作${NC} → ${BLUE}移除浮水印${NC}"
echo ""
echo -e "${YELLOW}提示：${NC}"
echo -e "  • 如果快速動作未出現，請重新啟動 Finder："
echo -e "    ${BLUE}killall Finder${NC}"
echo -e "  • 或登出再登入"
echo ""
echo -e "  • 工作流程位置："
echo -e "    ${BLUE}$WORKFLOW_PATH${NC}"
echo ""
