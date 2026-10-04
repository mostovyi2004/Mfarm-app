#!/usr/bin/env bash
# Скрипт налаштування хмарного середовища Claude Code (claude.ai/code).
# Вставте вміст цього файлу в поле «Setup script» середовища.
# Встановлює Dart SDK (stable). Flutter знадобиться пізніше, для етапу 1.17 і далі.
set -euo pipefail

DART_DIR=/opt/dart-sdk

if ! command -v unzip >/dev/null 2>&1; then
  (apt-get update -qq && apt-get install -y -qq unzip) || sudo apt-get install -y -qq unzip
fi

if [ ! -x "$DART_DIR/bin/dart" ]; then
  VERSION=$(curl -fsSL https://storage.googleapis.com/dart-archive/channels/stable/release/latest/VERSION \
    | grep -o '"version": *"[^"]*"' | cut -d'"' -f4)
  echo "Встановлюю Dart $VERSION"
  curl -fsSL -o /tmp/dart.zip \
    "https://storage.googleapis.com/dart-archive/channels/stable/release/$VERSION/sdk/dartsdk-linux-x64-release.zip"
  unzip -q /tmp/dart.zip -d /opt
  rm -f /tmp/dart.zip
fi

LINE='export PATH="/opt/dart-sdk/bin:$HOME/.pub-cache/bin:$PATH"'
grep -qxF "$LINE" "$HOME/.bashrc" 2>/dev/null || echo "$LINE" >> "$HOME/.bashrc"
if [ -w /etc/profile.d ]; then echo "$LINE" > /etc/profile.d/dart.sh; fi

"$DART_DIR/bin/dart" --version
