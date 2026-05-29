#!/usr/bin/env bash
# 在 Google Drive 建立 Project-OS 標準資料夾樹（用 rclone）
# Create the Project-OS folder tree in Google Drive (via rclone).
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ -z "${RCLONE_REMOTE:-}" ]]; then
  ENVF="$HERE/../.env"; [[ -f "$ENVF" ]] && { set -a; source "$ENVF"; set +a; }
fi
RCLONE_REMOTE="${RCLONE_REMOTE:-gdrive}"
DRIVE_ROOT="${DRIVE_ROOT:-ProjectsRoot}"

# --- 檢查 rclone / check rclone ---
if ! command -v rclone >/dev/null 2>&1; then
  cat <<'EOF'
✗ 找不到 rclone / rclone not installed.
  安裝 / install:
    macOS:  brew install rclone
    Linux:  curl https://rclone.org/install.sh | sudo bash
  然後設定 Google Drive remote / then configure a Drive remote:
    rclone config        # 新增一個 type=drive 的 remote，名稱填到 .env 的 RCLONE_REMOTE
EOF
  exit 1
fi

# --- 確認 remote 存在 / verify remote ---
if ! rclone listremotes | grep -q "^${RCLONE_REMOTE}:$"; then
  echo "✗ 找不到 rclone remote '${RCLONE_REMOTE}:'。請先執行 rclone config 建立，或修改 .env。"
  exit 1
fi

echo "=== 在 ${RCLONE_REMOTE}: 建立資料夾樹 / creating folders ==="
# 標準結構：進行中 + 一個範例專案三件套
dirs=(
  "${DRIVE_ROOT}"
  "${DRIVE_ROOT}/00_進行中"
  "${DRIVE_ROOT}/00_進行中/專案-範例-Example"
  "${DRIVE_ROOT}/00_進行中/專案-範例-Example/01_規劃文檔"
  "${DRIVE_ROOT}/00_進行中/專案-範例-Example/02_成果輸出"
  "${DRIVE_ROOT}/00_進行中/專案-範例-Example/03_原始素材"
)
for d in "${dirs[@]}"; do
  rclone mkdir "${RCLONE_REMOTE}:${d}"
  echo "  ✓ ${d}"
done

cat <<EOF

✓ Drive 結構完成 / done.
新專案用 / for a new project:
  for sub in 01_規劃文檔 02_成果輸出 03_原始素材; do
    rclone mkdir "${RCLONE_REMOTE}:${DRIVE_ROOT}/00_進行中/專案-客戶-主題/\$sub"
  done
結案時把資料夾移到根 / on closure move to root:
  rclone moveto "${RCLONE_REMOTE}:${DRIVE_ROOT}/00_進行中/專案-客戶-主題" \\
                "${RCLONE_REMOTE}:${DRIVE_ROOT}/專案-客戶-主題"
EOF
