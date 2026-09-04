#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/ilhamfirmansyahhub/keybinds-ilham.git"
SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

info()  { printf '\033[1;34m==>\033[0m %s\n' "$1"; }
warn()  { printf '\033[1;33m[!]\033[0m %s\n' "$1"; }
ok()    { printf '\033[1;32m[✓]\033[0m %s\n' "$1"; }

if [[ "$(id -u)" -eq 0 ]]; then
    echo "Please run this installer as your normal user, not root."
    exit 1
fi

if ! command -v pacman >/dev/null 2>&1; then
    warn "pacman was not found. This installer is designed for Arch Linux / CachyOS."
else
    info "Installing common keybind dependencies"
    sudo pacman -S --needed ryoku kitty yazi playerctl libnotify hyprpicker
fi

backup_file() {
    local file="$1"
    if [[ -f "$file" ]]; then
        local backup="${file}.backup.$(date +%Y%m%d-%H%M%S)"
        cp -a "$file" "$backup"
        warn "Backed up $(basename "$file") -> $(basename "$backup")"
    fi
}

info "Creating configuration directories"
mkdir -p "$HOME/.config/hypr/modules" "$HOME/.config/Brain_Shell"

# These are user-owned keybind pieces and safe to restore.
backup_file "$HOME/.config/hypr/modules/binds.lua"
backup_file "$HOME/.config/hypr/modules/resize.lua"
backup_file "$HOME/.config/hypr/modules/record.lua"
backup_file "$HOME/.config/hypr/modules/ryoshot.lua"
backup_file "$HOME/.config/hypr/modules/lid.lua"
backup_file "$HOME/.config/hypr/rebinds.lua"
backup_file "$HOME/.config/hypr/user.lua"
backup_file "$HOME/.config/Brain_Shell/Brain_ShellKeybinds.lua"

info "Installing Hyprland keybind modules"
cp -f "$SCRIPT_DIR/hypr/modules/binds.lua" "$HOME/.config/hypr/modules/binds.lua"
cp -f "$SCRIPT_DIR/hypr/modules/resize.lua" "$HOME/.config/hypr/modules/resize.lua"
cp -f "$SCRIPT_DIR/hypr/modules/record.lua" "$HOME/.config/hypr/modules/record.lua"
cp -f "$SCRIPT_DIR/hypr/modules/ryoshot.lua" "$HOME/.config/hypr/modules/ryoshot.lua"
cp -f "$SCRIPT_DIR/hypr/modules/lid.lua" "$HOME/.config/hypr/modules/lid.lua"
cp -f "$SCRIPT_DIR/hypr/rebinds.lua" "$HOME/.config/hypr/rebinds.lua"
cp -f "$SCRIPT_DIR/hypr/user.lua" "$HOME/.config/hypr/user.lua"

info "Installing Brain Shell keybinds"
sed "s#^local shell = .*#local shell = \"$HOME/.config/quickshell/brain-desktop\"#" \
    "$SCRIPT_DIR/Brain_Shell/Brain_ShellKeybinds.lua" \
    > "$HOME/.config/Brain_Shell/Brain_ShellKeybinds.lua"

printf '\n'
ok "Keybind backup restored"
printf 'Restart/reload Hyprland after installation.\n'
printf '\nImportant:\n'
printf '%s\n' "- This repository preserves your keybind files; it does not replace Ryoku's generated hyprland.lua."
printf '%s\n' "- Brain Shell keybinds require your Brain Desktop configuration."
printf '%s\n' "- Ryoku commands (ryoku-shell, ryoku-monitor, ryogami, etc.) require a working Ryoku installation."
printf '%s\n' "- Repository: %s\n" "$REPO_URL"
