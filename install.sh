#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/ilhamfirmansyahhub/keybinds-ilham.git"
SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

info()  { printf '\033[1;34m==>\033[0m %s\n' "$1"; }
warn() { printf '\033[1;33m[!]\033[0m %s\n' "$1"; }
ok()    { printf '\033[1;32m[✓]\033[0m %s\n' "$1"; }

if [[ "$(id -u)" -eq 0 ]]; then
    echo "Please run this installer as your normal user, not root."
    exit 1
fi

MODE="ilham"
case "${1:-}" in
    --generic|generic)
        MODE="generic"
        ;;
    --ilham|ilham|"")
        MODE="ilham"
        ;;
    --help|-h)
        cat <<EOF
Usage:
  ./install.sh            Install the original Ilham + Ryoku keybind setup
  ./install.sh --generic  Install portable keybinds for a normal Hyprland setup
EOF
        exit 0
        ;;
    *)
        echo "Unknown option: $1"
        echo "Use ./install.sh --help"
        exit 2
        ;;
esac

backup_file() {
    local file="$1"
    if [[ -f "$file" ]]; then
        local backup="${file}.backup.$(date +%Y%m%d-%H%M%S)"
        cp -a "$file" "$backup"
        warn "Backed up $(basename "$file") -> $(basename "$backup")"
    fi
}

if [[ "$MODE" == "ilham" ]]; then
    if ! command -v pacman >/dev/null 2>&1; then
        warn "pacman was not found. This mode is designed for Arch Linux / CachyOS."
    else
        info "Installing common Ryoku keybind dependencies"
        sudo pacman -S --needed ryoku kitty yazi playerctl libnotify hyprpicker
    fi

    info "Creating configuration directories"
    mkdir -p "$HOME/.config/hypr/modules" "$HOME/.config/Brain_Shell"

    backup_file "$HOME/.config/hypr/modules/binds.lua"
    backup_file "$HOME/.config/hypr/modules/resize.lua"
    backup_file "$HOME/.config/hypr/modules/record.lua"
    backup_file "$HOME/.config/hypr/modules/ryoshot.lua"
    backup_file "$HOME/.config/hypr/modules/lid.lua"
    backup_file "$HOME/.config/hypr/rebinds.lua"
    backup_file "$HOME/.config/hypr/user.lua"
    backup_file "$HOME/.config/Brain_Shell/Brain_ShellKeybinds.lua"

    info "Installing Ilham / Ryoku Hyprland keybind modules"
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
    ok "Ilham keybind backup restored"
    printf 'Reload Hyprland with: hyprctl reload\n'
    printf '\nThis mode expects the Ryoku + Brain Shell environment.\n'
else
    info "Installing portable generic Hyprland keybinds"
    mkdir -p "$HOME/.config/hypr" "$HOME/.local/bin"

    backup_file "$HOME/.config/hypr/keybinds-ilham-generic.conf"
    backup_file "$HOME/.local/bin/ilham-hypr-app"

    cp -f "$SCRIPT_DIR/generic/keybinds-ilham.conf" "$HOME/.config/hypr/keybinds-ilham-generic.conf"
    cp -f "$SCRIPT_DIR/generic/ilham-hypr-app" "$HOME/.local/bin/ilham-hypr-app"
    chmod +x "$HOME/.local/bin/ilham-hypr-app"

    if [[ -f "$HOME/.config/hypr/hyprland.conf" ]]; then
        SOURCE_LINE='source = ~/.config/hypr/keybinds-ilham-generic.conf'
        if ! grep -Fqx "$SOURCE_LINE" "$HOME/.config/hypr/hyprland.conf"; then
            backup_file "$HOME/.config/hypr/hyprland.conf"
            printf '\n# Ilham generic keybinds\n%s\n' "$SOURCE_LINE" >> "$HOME/.config/hypr/hyprland.conf"
            ok "Added generic keybinds to hyprland.conf"
        else
            ok "Generic keybinds are already sourced"
        fi
    else
        warn "~/.config/hypr/hyprland.conf was not found."
        printf 'Add this line to your main Hyprland config:\n\n'
        printf 'source = ~/.config/hypr/keybinds-ilham-generic.conf\n\n'
    fi

    printf '\n'
    ok "Generic Hyprland keybinds installed"
    printf 'Reload Hyprland with: hyprctl reload\n'
    printf '\nGeneric mode does not require Ryoku or Brain Shell.\n'
    printf 'It uses locally available terminals, launchers, file managers, browsers and tools when possible.\n'
fi

printf '\nRepository: %s\n' "$REPO_URL"
