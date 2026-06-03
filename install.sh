#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
BIN_DIR="${HOME}/.local/bin"

echo "Installing codex-smart-mode..."
mkdir -p "$BIN_DIR"

install -m 755 "$SCRIPT_DIR/codex-smart" "$BIN_DIR/codex-smart"
ln -sf "$BIN_DIR/codex-smart" "$BIN_DIR/csmart"

echo "Installed:"
echo "  $BIN_DIR/codex-smart"
echo "  $BIN_DIR/csmart"

ZSH_ENV="$HOME/.zshenv"
SMART_FUNCTION_START="# >>> codex-smart-mode /smart >>>"

if [[ -f "$ZSH_ENV" ]] && grep -q "$SMART_FUNCTION_START" "$ZSH_ENV"; then
  echo "zsh /smart function already exists in $ZSH_ENV"
else
  cat >> "$ZSH_ENV" <<'EOF'

# >>> codex-smart-mode /smart >>>
function /smart() {
  "$HOME/.local/bin/csmart" "$@"
}
# <<< codex-smart-mode /smart <<<
EOF
  echo "Added zsh /smart function to $ZSH_ENV"
fi

case ":$PATH:" in
  *":$BIN_DIR:"*)
    ;;
  *)
    SHELL_RC="$HOME/.zshrc"
    if [[ -n "${BASH_VERSION:-}" ]]; then
      SHELL_RC="$HOME/.bashrc"
    fi
    printf '\nexport PATH="$HOME/.local/bin:$PATH"\n' >> "$SHELL_RC"
    echo "Added $BIN_DIR to PATH in $SHELL_RC"
    ;;
esac

echo
echo "Try:"
echo "  /smart --dry-run \"fix the failing tests\""
echo "  /smart \"implement the requested change\""
echo "  csmart --dry-run \"fix the failing tests\""
echo "  csmart \"implement the requested change\""
echo "  csmart exec \"summarize this repo\""
