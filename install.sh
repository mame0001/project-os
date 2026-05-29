#!/usr/bin/env bash
# =============================================================
# Project-OS 一鍵安裝器 / one-shot installer
# Notion(執行) × Obsidian(知識) × Drive(成果) 三方專案管理架構
# =============================================================
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

c_green() { printf '\033[32m%s\033[0m\n' "$1"; }
c_yellow(){ printf '\033[33m%s\033[0m\n' "$1"; }
c_red()   { printf '\033[31m%s\033[0m\n' "$1"; }
c_bold()  { printf '\033[1m%s\033[0m\n' "$1"; }

# ---- 載入設定 / load config ----
if [[ ! -f .env ]]; then
  c_yellow "未找到 .env，從範例複製一份… / no .env found, copying from example"
  cp config.example.env .env
  c_red "請先編輯 .env 填入你的設定，再重新執行： \$EDITOR .env"
  c_red "Please edit .env with your own values, then re-run this script."
  exit 1
fi
set -a; source .env; set +a

c_bold "=== Project-OS 安裝器 / installer ==="
echo "VAULT_PATH = ${VAULT_PATH:-<unset>}"
echo "請選擇要安裝的部分 / choose what to install:"
echo "  1) Obsidian 結構與模板 / vault scaffold & templates  (無需憑證 / no creds)"
echo "  2) Notion 資料庫 / databases                          (需 NOTION_TOKEN)"
echo "  3) Google Drive 資料夾樹 / folder tree                (需 rclone)"
echo "  4) 全部 / all"
echo "  q) 離開 / quit"
read -rp "> " choice

run_obsidian(){ c_bold ">> Obsidian"; bash "$ROOT/obsidian/scaffold.sh"; }
run_notion(){   c_bold ">> Notion";   python3 "$ROOT/notion/setup_notion.py"; }
run_drive(){    c_bold ">> Drive";    bash "$ROOT/drive/setup_drive.sh"; }

case "$choice" in
  1) run_obsidian ;;
  2) run_notion ;;
  3) run_drive ;;
  4) run_obsidian; echo; run_notion; echo; run_drive ;;
  q|Q) exit 0 ;;
  *) c_red "未知選項 / unknown option"; exit 1 ;;
esac

c_green "完成 / done. 下一步請讀 README.md 的『連結三方』段落。"
