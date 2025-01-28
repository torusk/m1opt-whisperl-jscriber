# m1opt-whisperl-jscriber

M1 Mac 向けに最適化された Whisper.cpp を使用した音声書き起こしツール。GarageBand（.band）プロジェクトから音声を抽出し、Whisper で日本語の文章をテキスト化。

## 特徴

- M1 Mac 向けにビルドされた Whisper.cpp を利用
- 高精度な大規模モデル対応
- 対話形式でプロジェクトを選択可能
- WAV 変換からテキスト出力まで自動化

## 事前準備

- **Homebrew** がインストールされていること
- **ffmpeg**: `brew install ffmpeg`
- **Whisper.cpp** の M1 向けビルド（[公式リポジトリ](https://github.com/ggerganov/whisper.cpp)参照）

## セットアップ

1. リポジトリをクローン:

```bash
git clone https://github.com/yourname/m1-whisper-large-transcriber.git
cd m1-whisper-large-transcriber
```

2. 環境変数の設定（.env ファイルを作成）:

```bash
WORK_DIR="/path/to/your/workspace"
WHISPER_MODEL_PATH="/path/to/ggml-large.bin"
WHISPER_CLI_PATH="/path/to/whisper.cpp/main"
FFMPEG_PATH="/opt/homebrew/bin/ffmpeg" # M1 デフォルトパス
```

3. 依存関係のインストール:

```bash
pip install python-dotenv
```

## 使用方法

1. GarageBand プロジェクト（.band ファイル）を WORK_DIR 直下に配置

2. スクリプト実行:

```bash
chmod +x daily_large.sh
./daily_large.sh
```

3. 対話形式でプロジェクトを選択

4. 生成されたテキストは `text_large/` ディレクトリに保存

## トラブルシューティング

### WAV ファイルが見つからない場合

GarageBand プロジェクト内にオーディオファイルが含まれていることを確認

### モデル読み込みエラー

.env の WHISPER_MODEL_PATH が正しいことを確認（ggml-large 推奨）

### 権限エラー

スクリプトと Whisper の実行ファイルに権限を付与:

```bash
chmod +x daily_large.sh /path/to/whisper.cpp/main
```

## ライセンス

MIT License
