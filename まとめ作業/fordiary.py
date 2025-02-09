import os  # OS関連の操作（ファイルやディレクトリ操作）をするためのモジュールをインポート
import re  # 正規表現（文字列のパターンマッチング）を扱うモジュールをインポート

# 現在のディレクトリにあるすべてのファイル・フォルダを取得して、ループで処理する
for filename in os.listdir("."):
    # ファイル名が ".txt" で終わる場合にのみ処理を実行（他の拡張子のファイルはスキップ）
    if filename.endswith(".txt"):

        # 正規表現を使ってファイル名の先頭から「YYYY/MM/DD」または「YYYY:MM:DD」の形式を探す
        match = re.match(r"(\d{4})[/:](\d{2})[/:](\d{2})", filename)

        # `match` に一致する結果がある場合のみリネーム処理を実行
        if match:
            # `match.group(1)`, `match.group(2)`, `match.group(3)` には以下のようなデータが入る
            # - match.group(1) → 年 (YYYY)
            # - match.group(2) → 月 (MM)
            # - match.group(3) → 日 (DD)
            # 例: "2025/02/09今日はいい天気だった.txt" → match.group(1) = "2025", match.group(2) = "02", match.group(3) = "09"

            # 新しいファイル名を作成（YYYY-MM-DD.txt の形式に変更）
            new_name = f"{match.group(1)}-{match.group(2)}-{match.group(3)}.txt"

            # ファイルをリネーム（元のファイル名 → 新しいファイル名）
            os.rename(filename, new_name)

            # リネームのログを出力（どのファイルがどの名前になったかを表示）
            print(f"Renamed: {filename} → {new_name}")
