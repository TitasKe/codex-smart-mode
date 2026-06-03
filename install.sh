#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
BIN_DIR="${HOME}/.local/bin"

echo "Installing codex-smart-mode..."
mkdir -p "$BIN_DIR"

install -m 755 "$SCRIPT_DIR/codex-smart" "$BIN_DIR/codex-smart"
install -m 755 "$SCRIPT_DIR/uninstall.sh" "$BIN_DIR/codex-smart-uninstall"
ln -sf "$BIN_DIR/codex-smart" "$BIN_DIR/csmart"

echo "Installed:"
echo "  $BIN_DIR/codex-smart"
echo "  $BIN_DIR/csmart"
echo "  $BIN_DIR/codex-smart-uninstall"

ZSH_ENV="$HOME/.zshenv"
SMART_FUNCTION_START="# >>> codex-smart-mode /smart >>>"
EFFORT_FUNCTION_START="# >>> codex-smart-mode /effort >>>"

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

if [[ -f "$ZSH_ENV" ]] && grep -q "$EFFORT_FUNCTION_START" "$ZSH_ENV"; then
  echo "zsh /effort function already exists in $ZSH_ENV"
else
  cat >> "$ZSH_ENV" <<'EOF'

# >>> codex-smart-mode /effort >>>
function /effort() {
  "$HOME/.local/bin/csmart" effort "$@"
}
# <<< codex-smart-mode /effort <<<
EOF
  echo "Added zsh /effort function to $ZSH_ENV"
fi

case ":$PATH:" in
  *":$BIN_DIR:"*)
    ;;
  *)
    for SHELL_RC in "$HOME/.zshrc" "$HOME/.bashrc"; do
      if [[ -f "$SHELL_RC" ]] && grep -q 'HOME/.local/bin' "$SHELL_RC"; then
        continue
      fi
      printf '\nexport PATH="$HOME/.local/bin:$PATH"\n' >> "$SHELL_RC"
      echo "Added $BIN_DIR to PATH in $SHELL_RC"
    done
    ;;
esac

echo
echo "Try:"
echo "  /smart --dry-run \"fix the failing tests\""
echo "  /smart \"implement the requested change\""
echo "  /effort ultracode"
echo "  /effort status"
echo "  /smart doctor"
echo "  csmart --dry-run \"fix the failing tests\""
echo "  csmart \"implement the requested change\""
echo "  csmart exec \"summarize this repo\""
