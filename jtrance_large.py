import os
import subprocess
from dotenv import load_dotenv

# 環境変数読み込み
load_dotenv()

# 環境変数から設定取得
WORK_DIR = os.path.join(os.getenv("WORK_DIR"), "whisper_large_workspace")
MODEL_PATH = os.getenv("WHISPER_MODEL_PATH")
WHISPER_CLI = os.getenv("WHISPER_CLI_PATH")  # .envに追加が必要
AUDIO_FILE = "audio.wav"


def validate_paths():
    """必須パスの検証"""
    required = {
        "Whisper CLI": WHISPER_CLI,
        "モデルファイル": MODEL_PATH,
        "作業ディレクトリ": WORK_DIR
    }
    for name, path in required.items():
        if not path or not os.path.exists(path):
            raise FileNotFoundError(f"{name}が見つかりません: {path}")


def transcribe_audio():
    try:
        validate_paths()

        command = [
            WHISPER_CLI,
            "-m", MODEL_PATH,
            "-f", os.path.join(WORK_DIR, AUDIO_FILE),
            "-l", "ja",
            "-otxt"
        ]

        result = subprocess.run(
            command,
            capture_output=True,
            text=True,
            cwd=WORK_DIR,
            encoding='utf-8'
        )

        if result.returncode != 0:
            print(f"エラー発生:\n{result.stderr}")
            return False

        print("書き起こし完了")
        return True

    except Exception as e:
        print(f"致命的なエラー: {str(e)}")
        return False


if __name__ == "__main__":
    transcribe_audio()
