#!/bin/bash
#
# KillWatermark 解除安裝腳本
#

# 顏色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

WORKFLOW_NAME="移除浮水印"
WORKFLOW_PATH="$HOME/Library/Services/${WORKFLOW_NAME}.workflow"

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║    KillWatermark 解除安裝程式          ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

# 確認解除安裝
read -p "確定要解除安裝「移除浮水印」快速動作嗎？(y/N) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
	echo -e "${YELLOW}已取消解除安裝${NC}"
	exit 0
fi

# 移除工作流程
if [ -d "$WORKFLOW_PATH" ]; then
	rm -rf "$WORKFLOW_PATH"
	echo -e "${GREEN}✓${NC} 已移除快速動作: ${WORKFLOW_NAME}"
else
	echo -e "${YELLOW}○${NC} 快速動作不存在，無需移除"
fi

# 更新服務註冊
/System/Library/CoreServices/pbs -update
echo -e "${GREEN}✓${NC} 已更新服務註冊"

echo ""
echo -e "${GREEN}解除安裝完成！${NC}"
echo ""
echo -e "${YELLOW}注意：${NC}Python 套件 (Pillow, numpy) 未被移除。"
echo -e "如需移除，請執行："
echo -e "  ${BLUE}pip3 uninstall Pillow numpy${NC}"
echo ""
