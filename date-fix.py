# このコードは、ファイル名に含まれる日付を正規化するためのものです。
import os
import re
import platform

current_os = platform.system()

for filename in os.listdir('.'):
    # 対象拡張子を追加（必要に応じて自由に変更可能）
    if filename.endswith(('.txt', '.band', '.m4a', '.mp3')):
        # 多様な日付形式に対応する正規表現
        match = re.match(
            r'^(\d{4})[年月./:-](\d{1,2})[月./:-](\d{1,2})[日]?.*?\.(txt|band|m4a|mp3)$',
            filename
        )

        if match:
            # 年月日部分を数値のみに変換
            year = match.group(1)
            month = f"{int(match.group(2)):02d}"  # 2桁ゼロ埋め
            day = f"{int(match.group(3)):02d}"     # 2桁ゼロ埋め
            extension = match.group(4)

            # 区切り文字設定（Macは常に'-'）
            separator = '-'

            # 新しいファイル名生成
            new_name = f"{year}{separator}{month}{separator}{day}.{extension}"

            print(f"Original: {filename}")
            print(f"New Name: {new_name}")
            print("------")

            try:
                os.rename(filename, new_name)
            except Exception as e:
                print(f"Error: {str(e)}")
                print("Skipping...")
