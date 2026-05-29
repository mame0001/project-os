#!/usr/bin/env bash
# 建立一個新專案的 Obsidian 儀表板（從模板填值）
# Create a new project's Obsidian dashboard from the template.
#
# 用法 / usage:
#   bash new-project.sh "專案-客戶-主題"
#   bash new-project.sh "專案-客戶-主題" --notion <url> --drive <url>
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ -z "${VAULT_PATH:-}" ]]; then
  ENVF="$HERE/../.env"; [[ -f "$ENVF" ]] && { set -a; source "$ENVF"; set +a; }
fi
VAULT_NAME="${VAULT_NAME:-MyVault}"

TEMPLATE="$HERE/templates/project-dashboard.template.md"

render(){
  # $1 dest file, env: PROJECT_NAME REL_PATH NOTION_URL DRIVE_URL VAULT_NAME
  sed -e "s|{{PROJECT_NAME}}|${PROJECT_NAME}|g" \
      -e "s|{{VAULT_NAME}}|${VAULT_NAME}|g" \
      -e "s|{{REL_PATH}}|${REL_PATH}|g" \
      -e "s|{{NOTION_URL}}|${NOTION_URL}|g" \
      -e "s|{{DRIVE_URL}}|${DRIVE_URL}|g" \
      -e "s|{{DATE}}|$(date +%F)|g" \
      "$TEMPLATE" > "$1"
}

# 由 scaffold 內部呼叫（已備好 env + 目錄）
if [[ "${1:-}" == "--from-scaffold" ]]; then
  DEST_DIR="$2"
  render "$DEST_DIR/專案儀表板.md"
  echo "  ✓ 範例專案儀表板 / example dashboard created"
  exit 0
fi

# 一般 CLI 用法
PROJECT_NAME="${1:?請給專案名稱，例如：專案-客戶-主題 / project name required}"
NOTION_URL="(待填 / TBD)"; DRIVE_URL="(待填 / TBD)"
shift || true
while [[ $# -gt 0 ]]; do
  case "$1" in
    --notion) NOTION_URL="$2"; shift 2;;
    --drive)  DRIVE_URL="$2"; shift 2;;
    *) echo "未知參數 / unknown arg: $1"; exit 1;;
  esac
done
: "${VAULT_PATH:?請在 .env 設定 VAULT_PATH}"

DEST_DIR="$VAULT_PATH/40_進行中專案_Active_Projects/$PROJECT_NAME"
mkdir -p "$DEST_DIR"
REL_PATH="40_進行中專案_Active_Projects/$PROJECT_NAME/專案儀表板"
export PROJECT_NAME VAULT_NAME REL_PATH NOTION_URL DRIVE_URL
render "$DEST_DIR/專案儀表板.md"

cat <<EOF
✓ 已建立 Obsidian 專案 / created: $DEST_DIR/專案儀表板.md
下一步 / next steps（三件套 / the triad）:
  1) Notion：在 執行Projects 建一張同名卡，把 Obsidian 筆記 欄填成：
     obsidian://open?vault=${VAULT_NAME}&file=${REL_PATH}
  2) Drive：建 ${PROJECT_NAME}/(01_規劃文檔|02_成果輸出|03_原始素材)
  3) 回到本儀表板，把 Notion / Drive 連結貼進開頭
EOF
