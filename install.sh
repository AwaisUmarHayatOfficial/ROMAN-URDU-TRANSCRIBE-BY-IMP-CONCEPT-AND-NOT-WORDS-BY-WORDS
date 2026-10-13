#!/usr/bin/env bash
# One-click setup: system packages + venv + libraries, phir Run.sh launch.
set -e
cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

echo "==> [1/3] System packages (python3-venv, pip, ffmpeg)"
NEED=""
python3 -m venv --help >/dev/null 2>&1 || NEED="$NEED python3-venv"
command -v pip3 >/dev/null 2>&1 || NEED="$NEED python3-pip"
command -v ffmpeg >/dev/null 2>&1 || NEED="$NEED ffmpeg"
if [ -n "$NEED" ]; then
    echo "    Installing:$NEED"
    sudo apt update
    sudo apt install -y $NEED
else
    echo "    Sab pehle se installed hain."
fi

echo "==> [2/3] Virtual environment"
if [ ! -f "venv/bin/activate" ]; then
    rm -rf venv
    python3 -m venv venv
    echo "    venv ban gaya."
else
    echo "    venv pehle se maujood hai."
fi
source venv/bin/activate

echo "==> [3/3] Python libraries"
STAMP="venv/.requirements_installed"
if [ ! -f "$STAMP" ] || [ requirements.txt -nt "$STAMP" ]; then
    pip install --upgrade pip -q
    pip install -r requirements.txt
    touch "$STAMP"
else
    echo "    Libraries pehle se installed hain."
fi

mkdir -p logs
echo
echo "==> Setup complete. Run.sh shuru ho raha hai..."
echo
exec bash ./Run.sh "$@"
