import os
import re
from datetime import datetime

# 実行するディレクトリ（現在のディレクトリ）
directory = os.getcwd()

# ファイル名のパターン（例: "2月5日(水)あれこれメモ.band"）
pattern = re.compile(r"(\d{1,2})月(\d{1,2})日")

for filename in os.listdir(directory):
    match = pattern.search(filename)
    if match:
        month, day = match.groups()  # 月と日を取得
        year = "2021"  # 追加する年
        new_name = f"{year}-{int(month):02d}-{int(day):02d}.band"  # 例: "2025-02-05.band"
        old_path = os.path.join(directory, filename)
        new_path = os.path.join(directory, new_name)

        # ファイル名を変更
        os.rename(old_path, new_path)
        print(f"Renamed: {filename} -> {new_name}")
