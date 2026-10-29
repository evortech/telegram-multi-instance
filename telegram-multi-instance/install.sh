#!/usr/bin/env bash
# Installs official Telegram Desktop (no sudo) + the tgm command.
# Usage: ./install.sh            install / update
#        ./install.sh --uninstall remove program (keeps your accounts)
set -eu
OPT="$HOME/.local/opt"; BIN="$HOME/.local/bin"; HERE="$(cd "$(dirname "$0")" && pwd)"

if [ "${1:-}" = "--uninstall" ]; then
  rm -rf "$OPT/Telegram" "$BIN/tgm"
  echo "Removed. Your accounts are still in ~/telegram-instances (delete manually if wanted)."; exit 0
fi

if snap list telegram-desktop >/dev/null 2>&1; then
  echo "NOTE: Snap Telegram detected. It is sandboxed and can't be used for multi-instance;"
  echo "      this script installs the official binary alongside it."
fi

mkdir -p "$OPT" "$BIN"
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
echo "Downloading Telegram Desktop from telegram.org ..."
curl -fL --retry 5 --retry-delay 2 -o "$tmp/tsetup.tar.xz" https://telegram.org/dl/desktop/linux
rm -rf "$OPT/Telegram"
tar -xf "$tmp/tsetup.tar.xz" -C "$OPT"
install -m 755 "$HERE/bin/tgm" "$BIN/tgm"

echo; echo "Done. Binary: $OPT/Telegram/Telegram"
case ":$PATH:" in *":$BIN:"*) ;; *) echo "Add to PATH:  echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.bashrc && source ~/.bashrc";; esac
echo "Try:  tgm start 1 2 3"
