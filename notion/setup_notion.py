#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Project-OS · Notion 架構建立器 / Notion schema bootstrapper
建立三個資料庫：執行Projects、Tasks總項目、Outputs成果歸檔，並接好關聯與 formula。
Creates 3 databases (Projects / Tasks / Outputs) with relations and the
"待補成果" formula. Pure standard library — no pip install required.

用法 / usage:
    cp ../config.example.env ../.env   # 填入 NOTION_TOKEN / NOTION_PARENT_PAGE_ID
    python3 setup_notion.py

需求 / requirements:
  1) 到 https://www.notion.so/my-integrations 建立 internal integration，取得 token。
  2) 開啟一個 Notion 頁面，右上 ··· → Connections → 加入你的 integration，
     並把該頁的 32 碼 ID 填到 NOTION_PARENT_PAGE_ID。

⚠️ Notion API 已知限制：無法以 API 建立「status」型欄位，故 Status 以 select 建立；
   你可日後在 UI 將其轉成 status 型（不影響 formula）。
"""
import json
import os
import sys
import urllib.request
import urllib.error

API = "https://api.notion.com/v1"
VERSION = "2022-06-28"


def load_env():
    # 從 ../.env 載入（簡單解析）/ load ../.env
    here = os.path.dirname(os.path.abspath(__file__))
    envf = os.path.join(here, "..", ".env")
    if os.path.exists(envf):
        with open(envf, encoding="utf-8") as f:
            for line in f:
                line = line.strip()
                if not line or line.startswith("#") or "=" not in line:
                    continue
                k, v = line.split("=", 1)
                os.environ.setdefault(k.strip(), v.strip().strip('"').strip("'"))
    token = os.environ.get("NOTION_TOKEN", "")
    parent = os.environ.get("NOTION_PARENT_PAGE_ID", "")
    if not token or token.startswith("secret_xxxx"):
        sys.exit("✗ 請在 .env 設定真實 NOTION_TOKEN / set a real NOTION_TOKEN")
    if not parent or parent.startswith("xxxx"):
        sys.exit("✗ 請在 .env 設定 NOTION_PARENT_PAGE_ID / set NOTION_PARENT_PAGE_ID")
    return token, parent.replace("-", "")


def api(token, method, path, payload=None):
    url = f"{API}{path}"
    data = json.dumps(payload).encode("utf-8") if payload is not None else None
    req = urllib.request.Request(url, data=data, method=method)
    req.add_header("Authorization", f"Bearer {token}")
    req.add_header("Notion-Version", VERSION)
    req.add_header("Content-Type", "application/json")
    try:
        with urllib.request.urlopen(req) as resp:
            return json.loads(resp.read().decode("utf-8"))
    except urllib.error.HTTPError as e:
        body = e.read().decode("utf-8", "replace")
        sys.exit(f"✗ Notion API {e.code} on {method} {path}\n{body}")


def title_prop(name):
    return {name: {"title": {}}}


def create_db(token, parent, title, properties):
    payload = {
        "parent": {"type": "page_id", "page_id": parent},
        "title": [{"type": "text", "text": {"content": title}}],
        "properties": properties,
    }
    res = api(token, "POST", "/databases", payload)
    print(f"  ✓ 建立資料庫 / created DB: {title}  (id={res['id']})")
    return res["id"]


def add_props(token, db_id, properties):
    api(token, "PATCH", f"/databases/{db_id}", {"properties": properties})


def main():
    token, parent = load_env()
    print("=== Notion 架構建立 / bootstrapping schema ===")

    sel = lambda opts: {"select": {"options": [{"name": o} for o in opts]}}
    msel = lambda opts: {"multi_select": {"options": [{"name": o} for o in opts]}}

    # --- 1) Outputs 成果歸檔（先建，供 Tasks 關聯）---
    outputs_id = create_db(token, parent, "Outputs 成果歸檔", {
        **title_prop("Name"),
        "連結": {"url": {}},
        "類型": sel(["文件", "簡報", "圖檔", "程式", "報告", "其他"]),
        "日期": {"date": {}},
    })

    # --- 2) 執行Projects（先不含 self-relation / Tasks 關聯）---
    projects_id = create_db(token, parent, "執行Projects", {
        **title_prop("Project name"),
        # ⚠️ status 型無法 API 建立，先用 select；可日後 UI 轉 status
        "Status": sel(["Backlog待執行", "Planning規劃中", "In Progress執行中",
                        "Paused暫停", "Done完成", "Canceled放棄"]),
        "Priority": sel(["Low", "Medium", "High"]),
        "Summary": {"rich_text": {}},
        "一句話目標": {"rich_text": {}},
        "Obsidian 筆記": {"url": {}},
        "Drive 成果": {"url": {}},
        "Owner": {"people": {}},
        "Tag": sel(["Enterprise", "Personal", "Gov", "R&D"]),
        "Dates": {"date": {}},
    })

    # --- 3) Tasks總項目（含關聯到 Projects 與 Outputs）---
    tasks_id = create_db(token, parent, "Tasks總項目", {
        **title_prop("Task name"),
        "Status": sel(["Not started", "In progress", "Done", "Blocked"]),
        "Priority": sel(["Low", "Medium", "High"]),
        "Due": {"date": {}},
        "領域": msel(["工作", "家務", "財務", "學習", "健康", "自媒體", "人際", "其他"]),
        "成果連結": {"url": {}},
        "執行者類型": sel(["自己", "Agent", "外包", "協作"]),
        "指派 Subagent": sel(["builder", "researcher", "validator", "editor", "pm-lead", "其他"]),
        "驗收標準": {"rich_text": {}},
        "驗收結果": sel(["通過", "部分通過", "退回", "待驗收"]),
        "預估耗時（分鐘）": {"number": {"format": "number"}},
        "實際耗時（分鐘）": {"number": {"format": "number"}},
        "Blocked 原因": {"rich_text": {}},
        "所屬專案": {"relation": {"database_id": projects_id, "type": "dual_property",
                                "dual_property": {}}},
        "成果歸檔": {"relation": {"database_id": outputs_id, "type": "dual_property",
                                "dual_property": {}}},
    })

    # --- 4) 補上 Projects 的 self-relation（父/子專案）+ 待補成果 formula ---
    add_props(token, projects_id, {
        "父專案": {"relation": {"database_id": projects_id, "type": "dual_property",
                              "dual_property": {}}},
    })
    # Tasks 的 待補成果 formula（Status 為 select，"Done" 命中）
    add_props(token, tasks_id, {
        "待補成果": {"formula": {"expression":
            'if(and(prop("Status") == "Done", and(empty(prop("成果連結")), '
            'empty(prop("成果歸檔")))), "⚠️ 待補成果", "")'}},
    })

    print("\n✓ 完成 / done. 三個資料庫已建立並接好關聯。")
    print("  下一步 / next:")
    print("   - 把每個 Notion 專案卡的『Obsidian 筆記』填成 obsidian://open?vault=...&file=...")
    print("   - 如需 status 型 Status：在 Notion UI 把 Select 欄轉成 Status（formula 不受影響）")
    print("   - 父/子專案、所屬專案的『current page』自我篩選需在 UI 視圖手動設定")


if __name__ == "__main__":
    main()
