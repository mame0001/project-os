# Notion 設定 / Notion setup

建立 `執行Projects`、`Tasks總項目`、`Outputs 成果歸檔` 三個資料庫，並接好關聯與 `待補成果` formula。

## 前置 / prerequisites
1. **建立 integration**：到 <https://www.notion.so/my-integrations> → New integration → 取得 `secret_...` token。
2. **準備父頁面**：在 Notion 開一個頁面當容器，右上 `···` → **Connections** → 加入你的 integration。
3. 複製該頁網址末段的 32 碼當作 `NOTION_PARENT_PAGE_ID`。
4. 把 token 與 page id 填入專案根目錄的 `.env`（由 `config.example.env` 複製）。

## 執行 / run
```bash
python3 setup_notion.py
```
純標準函式庫，無需 `pip install`。

## 已知限制 / known limits
- **Status 欄位**：Notion API 無法建立 `status` 型，腳本以 `select` 建立同名欄位。
  你可在 UI 把它轉成 status 型，`待補成果` formula 仍正常運作。
- **視圖自我篩選**：專案頁要顯示「本專案任務／子專案」需在 UI 視圖加
  `current page` 關聯篩選（API 無此語法）。

## 欄位總表 / schema
- **執行Projects**：Project name(title) · Status · Priority · Summary · 一句話目標 ·
  Obsidian 筆記(url) · Drive 成果(url) · Owner(people) · Tag · Dates(date) · 父專案(self relation)
- **Tasks總項目**：Task name(title) · Status · Priority · Due · 領域(multi) · 成果連結(url) ·
  執行者類型 · 指派 Subagent · 驗收標準 · 驗收結果 · 預估/實際耗時(number) · Blocked 原因 ·
  所屬專案(→Projects) · 成果歸檔(→Outputs) · 待補成果(formula)
- **Outputs 成果歸檔**：Name(title) · 連結(url) · 類型 · 日期(date)
