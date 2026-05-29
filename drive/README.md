# Google Drive 設定 / Drive setup

用 [rclone](https://rclone.org) 建立標準資料夾樹。

## 前置 / prerequisites
```bash
# 安裝 rclone
brew install rclone                       # macOS
# curl https://rclone.org/install.sh | sudo bash   # Linux

# 設定一個 Google Drive remote（type = drive）
rclone config
```
把 remote 名稱填到 `.env` 的 `RCLONE_REMOTE`，根資料夾名稱填 `DRIVE_ROOT`。

## 執行 / run
```bash
bash setup_drive.sh
```

## 標準結構 / structure
```
<DRIVE_ROOT>/
├── 00_進行中/                  ← 執行中的專案
│   └── 專案-XXX/
│       ├── 01_規劃文檔
│       ├── 02_成果輸出         ★ 任務產出統一放這
│       └── 03_原始素材
└── 專案-XXX/                   ← 結案後移到根
```

> 不用 rclone 也行：可手動在 Drive 網頁建同樣結構，重點是**三件套 + 進行中/結案分流**。
