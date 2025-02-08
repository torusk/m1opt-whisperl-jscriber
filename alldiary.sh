#!/bin/bash

# 環境変数の読み込み（.envファイルから）
source .env || { echo ".envファイルが見つかりません"; exit 1; }

# 依存ツールのパスを環境変数化（.envに定義が必要）
FFMPEG_PATH="${FFMPEG_PATH:-/opt/homebrew/bin/ffmpeg}" # デフォルト値設定
PYTHON_SCRIPT="${WORK_DIR}/jtrance_large.py" # WORK_DIRベースでパス構築

# 派生ディレクトリの設定
WHISPER_DIR="${WORK_DIR}/whisper_large_workspace"
TEXT_DIR="${WORK_DIR}/text_large"

# ディレクトリ作成
mkdir -p "$TEXT_DIR" "$WHISPER_DIR" || { echo "ディレクトリ作成失敗"; exit 1; }
cd "$WORK_DIR" || { echo "作業ディレクトリ移動失敗"; exit 1; }

echo "=== バッチ処理開始 ==="

# .bandファイルのリストを取得
band_files=("$WORK_DIR"/*.band)
if [ ${#band_files[@]} -eq 0 ]; then
    echo "処理可能な.bandファイルが見つかりません"
    exit 1
fi

# 全ファイルを順番に処理
for band_dir in "${band_files[@]}"; do
    echo "処理中のプロジェクト: $band_dir"
    
    # プロジェクト情報取得
    project_name=$(basename "$band_dir" .band)
    echo "プロジェクト名: $project_name"

    # WAVファイル探索
    input_wav=$(find "$band_dir/Media/Audio Files" -name "*.wav" | head -n 1)
    if [ -z "$input_wav" ]; then
        echo "WAVファイルが見つかりません: $band_dir/Media/Audio Files"
        continue
    fi

    # 音声変換処理
    echo "音声変換を開始します..."
    if ! $FFMPEG_PATH -i "$input_wav" \
                      -ar 16000 \
                      -ac 1 \
                      -c:a pcm_s16le \
                      "$WHISPER_DIR/audio.wav"; then
        echo "音声変換失敗: $input_wav"
        continue
    fi
    echo "音声変換完了: $WHISPER_DIR/audio.wav"

    # Whisper処理実行
    echo "=== Whisper処理開始 ==="
    if ! (cd "$WHISPER_DIR" && python3 "$PYTHON_SCRIPT"); then
        echo "Whisper処理失敗: $project_name"
        continue
    fi

    # 結果処理
    if [ -f "$WHISPER_DIR/audio.wav.txt" ]; then
        mv "$WHISPER_DIR/audio.wav.txt" "$TEXT_DIR/${project_name}.txt"
        rm -f "$WHISPER_DIR/audio.wav"
        echo "=== 処理完了: $project_name ==="
        echo "生成ファイル: $TEXT_DIR/${project_name}.txt"
    else
        echo "エラー: 書き起こし結果ファイルが存在しません: $project_name"
    fi
done

echo "=== 全バッチ処理終了 ==="

