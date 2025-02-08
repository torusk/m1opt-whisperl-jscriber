#!/bin/bash

# 環境変数の読み込み（.envファイルから）
source .env || { echo ".envファイルが見つかりません"; exit 1; }

# 依存ツールのパスを環境変数化（.envに定義が必要）
FFMPEG_PATH="${FFMPEG_PATH:-/opt/homebrew/bin/ffmpeg}" # デフォルト値設定
PYTHON_SCRIPT="${WORK_DIR}/jtrance_large.py" # WORK_DIRベースでパス構築

# 関連ディレクトリの設定
WHISPER_DIR="${WORK_DIR}/whisper_large_workspace"
TEXT_DIR="${WORK_DIR}/text_large"

# ディレクトリ作成
mkdir -p "$TEXT_DIR" "$WHISPER_DIR" || { echo "ディレクトリ作成失敗"; exit 1; }
cd "$WORK_DIR" || { echo "作業ディレクトリ移動失敗"; exit 1; }

echo "=== 音声変換処理開始 ==="

# .bandファイルのリストを取得
band_files=("$WORK_DIR"/*.band)
if [ ${#band_files[@]} -eq 0 ]; then
    echo "処理可能な.bandファイルが見つかりません"
    exit 1
fi

# 対話形式ファイル選択
PS3="処理したいプロジェクトの番号を選択してください: "
select band_dir in "${band_files[@]}" "終了"; do
    # 終了オプション処理
    if [ "$REPLY" -eq $((${#band_files[@]}+1)) ]; then
        echo "処理を中止します"
        exit 0
    fi

    # 有効な選択か検証
    if [ -n "$band_dir" ] && [ "$band_dir" != "終了" ]; then
        echo "選択プロジェクト: $band_dir"
        break
    else
        echo "無効な選択です。再入力してください。"
    fi
done

# プロジェクト情報取得
project_name=$(basename "$band_dir" .band)
echo "プロジェクト名: $project_name"

# WAVファイル探索
input_wav=$(find "$band_dir/Media/Audio Files" -name "*.wav" | head -n 1)
if [ -z "$input_wav" ]; then
    echo "WAVファイルが見つかりません: $band_dir/Media/Audio Files"
    exit 1
fi

# 音声変換処理
echo "音声変換を開始します..."
$FFMPEG_PATH -i "$input_wav" \
             -ar 16000 \
             -ac 1 \
             -c:a pcm_s16le \
             "$WHISPER_DIR/audio.wav" || { echo "音声変換失敗"; exit 1; }

echo "音声変換完了: $WHISPER_DIR/audio.wav"

# Whisper処理実行
echo "=== Whisper処理開始 ==="
(cd "$WHISPER_DIR" && python3 "$PYTHON_SCRIPT") || { echo "Whisper処理失敗"; exit 1; }

# 結果処理
if [ -f "$WHISPER_DIR/audio.wav.txt" ]; then
    mv "$WHISPER_DIR/audio.wav.txt" "$TEXT_DIR/${project_name}.txt"
    echo "=== 全処理完了 ==="
    echo "生成ファイル: $TEXT_DIR/${project_name}.txt"
    rm -f "$WHISPER_DIR/audio.wav"
else
    echo "エラー: 書き起こし結果ファイルが存在しません"
    exit 1
fi