#!/usr/bin/env bash
# 建立 Obsidian vault 的專案管理骨架（PARA 風） / scaffold the project-OS vault structure
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 載入設定（若由 install.sh 呼叫已 source；獨立執行則自己讀）
if [[ -z "${VAULT_PATH:-}" ]]; then
  ENVF="$HERE/../.env"
  [[ -f "$ENVF" ]] && { set -a; source "$ENVF"; set +a; }
fi
: "${VAULT_PATH:?請在 .env 設定 VAULT_PATH / set VAULT_PATH in .env}"

mkdir -p "$VAULT_PATH"

# --- 標準資料夾 / standard folders ---
folders=(
  "00_收件匣_Inbox"
  "10_永久筆記_Permanent"
  "10_永久筆記_Permanent/每日日誌_Daily_Log"
  "30_主題中心_Topic_Hubs"
  "40_進行中專案_Active_Projects"
  "41_等待進行專案_Pending_Projects"
  "60_資訊摘要_Feeds"
  "70_歸檔_Archive"
  "90_系統_System"
)
for f in "${folders[@]}"; do
  mkdir -p "$VAULT_PATH/$f"
  [[ -e "$VAULT_PATH/$f/.gitkeep" ]] || : > "$VAULT_PATH/$f/.gitkeep"
done

# --- 安裝系統文件 / install system docs ---
cp -f "$HERE/templates/onboarding-manual.md"     "$VAULT_PATH/90_系統_System/新人手冊_工作系統總覽.md"
cp -f "$HERE/templates/project-lifecycle-sop.md" "$VAULT_PATH/90_系統_System/專案生命週期說明書.md"

# --- 放一份儀表板模板供日後複製 / keep a dashboard template ---
cp -f "$HERE/templates/project-dashboard.template.md" "$VAULT_PATH/90_系統_System/專案儀表板.template.md"

# --- 建一個範例專案 / create one example project ---
EX="$VAULT_PATH/40_進行中專案_Active_Projects/專案-範例-Example"
if [[ ! -d "$EX" ]]; then
  mkdir -p "$EX"
  VAULT_NAME="${VAULT_NAME:-MyVault}" \
  PROJECT_NAME="專案-範例-Example" \
  REL_PATH="40_進行中專案_Active_Projects/專案-範例-Example/專案儀表板" \
  NOTION_URL="(建立 Notion 專案後貼上 / paste after creating Notion project)" \
  DRIVE_URL="(建立 Drive 資料夾後貼上 / paste after creating Drive folder)" \
    bash "$HERE/new-project.sh" --from-scaffold "$EX"
fi

echo "✓ Obsidian 骨架完成 / vault scaffold done at: $VAULT_PATH"
