#!/usr/bin/env bash
# ==============================================================================
# install.sh — verlinkt den dev-Launcher nach ~/.local/bin (oder $1)
#
#   ./install.sh                 -> Symlink ~/.local/bin/dev
#   ./install.sh /usr/local/bin  -> Symlink /usr/local/bin/dev
# ==============================================================================
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/dev"
DEST_DIR="${1:-$HOME/.local/bin}"
DEST="$DEST_DIR/dev"

[ -f "$SRC" ] || { echo "install: dev-Skript nicht gefunden: $SRC" >&2; exit 1; }

mkdir -p "$DEST_DIR"
ln -sf "$SRC" "$DEST"
chmod +x "$SRC"

echo "Symlink angelegt: $DEST -> $SRC"
case ":$PATH:" in
  *":$DEST_DIR:"*) echo "OK: $DEST_DIR liegt im PATH." ;;
  *) echo "Hinweis: $DEST_DIR ist nicht im PATH — füge es z.B. in ~/.zshrc hinzu:"
     echo "         export PATH=\"$DEST_DIR:\$PATH\"" ;;
esac
