---
type: SOP
tags: [系統, SOP, 專案管理]
---

# 專案生命週期說明書（啟動 → 執行 → 結案）

> 從「專案啟動」到「結案歸檔」的完整 SOP，整合 Notion（控盤）＋ Google Drive（成果）＋ Obsidian（知識）。
> 新專案照這份走，三邊命名一致、成果不散落。

---

## 0. 總覽

| 系統 | 角色 | 位置 |
|:--|:--|:--|
| Notion `執行Projects` | 控盤：狀態、進度、關係 | Notion 工作區 |
| Notion `Tasks總項目` | 任務：待辦、驗收、成果連結 | Notion 工作區 |
| Google Drive | 成果：所有檔案產出 | 進行中放 `00_進行中/`，結案移到根 |
| Obsidian | 知識沉澱、規則固化 | 本 vault |

**命名鐵則**：三邊一律 `專案-[客戶/主題]-[描述]`。

```
啟動 Launch ──► 執行 Execution ──► 結案 Closure
 (三件套)        (派工+回填)        (驗收+歸檔+沉澱)
```

---

## 階段一：啟動 Launch — 標準三件套

### ① Notion 建案
- `執行Projects` 新增一筆：`Project name`=`專案-XXX`、`Status`、`Priority`、`一句話目標`。
- 填橋接欄位：`Obsidian 筆記`(obsidian:// URI)、`Drive 成果`(資料夾連結)。

### ② Drive 配對資料夾
- `00_進行中/專案-XXX/` 底下建三子夾：

| 子夾 | 用途 |
|:--|:--|
| `01_規劃文檔` | 需求、提案、設計稿 |
| `02_成果輸出` | **任務產出統一放這** |
| `03_原始素材` | logo、圖片、文案、原始資料 |

### ③ Obsidian 儀表板
- `40_進行中專案_Active_Projects/專案-XXX/專案儀表板.md`（可用 `new-project.sh` 自動生成）。

✅ **啟動完成檢查**：Notion 有頁、Drive 有三層夾、Obsidian 有儀表板、三邊連結互通、命名一致。

---

## 階段二：執行 Execution — 任務與回填

- 在 `Tasks總項目` 開任務，掛到所屬專案，寫清楚 `驗收標準`。
- 過程/草稿寫 Obsidian；完成後成果存 Drive `02_成果輸出`。
- Notion 任務 `Status=Done` + 回填 `成果連結`。
  - `待補成果` formula 會自動抓：Done 但沒填成果連結/歸檔 → 跳 `⚠️ 待補成果`。
- 里程碑更新專案頁「進度更新」段。

---

## 階段三：結案 Closure

1. **驗收**：對照 `驗收標準` 逐項確認，不足退回補做。
2. **Notion 結案**：`Status=Done`（或 `Canceled`）+ 補結案摘要。
3. **Drive 歸檔**：`專案-XXX/` 從 `00_進行中/` 移到根目錄，三子夾結構不動。
4. **Obsidian 沉澱**：可複用方法/踩坑寫成永久筆記，儀表板補反向連結。

✅ **結案完成檢查**：Status=Done、成果連結齊、Drive 已移根、知識已沉澱。

---

## 附錄：一頁檢查清單
**啟動**：☐ Notion 建案　☐ Drive 三層夾　☐ Obsidian 儀表板　☐ 連結互通　☐ 命名一致
**執行**：☐ 任務含驗收標準　☐ 成果進 02_成果輸出　☐ Notion 回填連結　☐ 進度更新
**結案**：☐ 逐項驗收　☐ Status=Done　☐ Drive 移到根　☐ 知識沉澱

---

*由 Project-OS 安裝包提供 / shipped with Project-OS.*
