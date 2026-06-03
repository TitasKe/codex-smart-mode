#!/usr/bin/env bash
set -euo pipefail

BIN_DIR="${HOME}/.local/bin"
ZSH_ENV="${HOME}/.zshenv"

echo "Uninstalling codex-smart-mode..."
rm -f "$BIN_DIR/codex-smart" "$BIN_DIR/csmart" "$BIN_DIR/codex-smart-uninstall"

if [[ -f "$ZSH_ENV" ]]; then
  python3 - "$ZSH_ENV" <<'PY'
from pathlib import Path
import sys

p = Path(sys.argv[1])
text = p.read_text()
blocks = [
    ("# >>> codex-smart-mode /smart >>>", "# <<< codex-smart-mode /smart <<<"),
    ("# >>> codex-smart-mode /effort >>>", "# <<< codex-smart-mode /effort <<<"),
]

for start, end in blocks:
    while start in text and end in text:
        a = text.index(start)
        b = text.index(end, a) + len(end)
        if a > 0 and text[a - 1] == "\n":
            a -= 1
        text = text[:a] + text[b:]

p.write_text(text)
PY
fi

echo "Removed codex-smart, csmart, codex-smart-uninstall, and the managed /smart and /effort zsh blocks."
