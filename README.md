# Project-OS

> **Notion(執行) × Obsidian(知識) × Google Drive(成果)** 三方專案管理架構，
> 用終端機一鍵在新機器上建立起來。
> A lightweight three-system project-management setup you can bootstrap from the terminal.

一個專案，活在三個地方、各司其職、互相連結：
**Notion** 管進度與任務、**Obsidian** 存知識與筆記、**Drive** 放最終成果。

---

## ✨ 這個包含什麼 / what's inside
```
project-os/
├── install.sh                 # 一鍵安裝器（互動選單）
├── config.example.env         # 設定範例（複製成 .env 填值）
├── obsidian/
│   ├── scaffold.sh            # 建 vault 資料夾結構 + 系統文件 + 範例專案
│   ├── new-project.sh         # 每次開新案用：生成專案儀表板
│   └── templates/             # 儀表板模板 + 新人手冊 + 生命週期 SOP
├── notion/
│   ├── setup_notion.py        # 建 執行Projects/Tasks/Outputs 三 DB（純 stdlib）
│   └── README.md
├── drive/
│   ├── setup_drive.sh         # 用 rclone 建標準資料夾樹
│   └── README.md
└── docs/architecture.md       # 架構說明
```

> 🔒 **不含任何機密**：本倉庫只有架構與模板，**沒有**任何 token、API 金鑰、
> 個人專案內容或工作區 ID。所有環境值都走你自己的 `.env`（已被 `.gitignore` 排除）。

---

## 🚀 快速開始 / quickstart

```bash
git clone <this-repo-url> project-os
cd project-os

# 1) 設定 / configure
cp config.example.env .env
$EDITOR .env            # 填 VAULT_PATH、NOTION_TOKEN、NOTION_PARENT_PAGE_ID…

# 2) 安裝 / install（互動選單，可選 1/2/3/4）
bash install.sh
```

也可以分開跑 / or run each part:
```bash
bash obsidian/scaffold.sh        # 只建 Obsidian（無需憑證）
python3 notion/setup_notion.py   # 建 Notion 三 DB（需 token）
bash drive/setup_drive.sh        # 建 Drive 樹（需 rclone）
```

---

## 🔧 前置需求 / prerequisites
| 部分 | 需求 |
|:--|:--|
| Obsidian | 無（只是建資料夾與 .md）。裝 Obsidian app 後開啟該 vault 即可。 |
| Notion | `python3`、一個 [Notion integration token](https://www.notion.so/my-integrations)、一個已分享給該 integration 的父頁面。 |
| Drive | [`rclone`](https://rclone.org) 並設定好一個 Google Drive remote。 |

---

## 🔗 連結三方 / wire the three together
裝好之後，每開一個新專案：

```bash
# 在 .env 已設好 VAULT_PATH / VAULT_NAME 的前提下
bash obsidian/new-project.sh "專案-客戶-主題"
```
腳本會建立 Obsidian 儀表板並印出三件套後續步驟：
1. **Notion**：在 `執行Projects` 建同名卡，`Obsidian 筆記` 欄填
   `obsidian://open?vault=<VAULT_NAME>&file=40_進行中專案_Active_Projects/專案-客戶-主題/專案儀表板`
2. **Drive**：建 `專案-客戶-主題/(01_規劃文檔|02_成果輸出|03_原始素材)`
3. 回儀表板把 Notion / Drive 連結貼進開頭。

完整流程見 `docs/architecture.md` 與安裝後 vault 內的系統文件。

---

## 📦 命名規則 / naming
三邊一律：`專案-[客戶/主題]-[描述]`。命名一致是三方互連的前提。

## ⚠️ 已知限制 / known limits
- Notion API 無法建立 `status` 型欄位 → 腳本以 `select` 代替（可 UI 轉換）。
- 專案頁視圖的「current page」自我篩選需在 Notion UI 手動設定。

## 📄 授權 / license
MIT — 見 [LICENSE](LICENSE)。
