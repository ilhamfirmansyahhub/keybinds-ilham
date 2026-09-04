# Hyprland Keybinds — Ilham

A reusable backup of Ilham's Hyprland keyboard shortcuts, with two installation modes.

## What this repository is for

This repository exists so that the familiar keybind layout can be restored after reinstalling an OS or moving to another Linux distribution.

It is **not a complete Hyprland desktop setup**. It contains the keybind configuration and the helper files needed to reproduce the shortcut behavior. Your bar, launcher, wallpaper system, display configuration, themes, and other desktop components are separate.

There are two modes because the original setup depends on Ryoku, while a future Fedora/Arch/other Hyprland installation may not.

### Mode 1 — Ilham / Ryoku

Use this when you want the shortcuts to behave like the current `ilham` setup with **CachyOS + Hyprland + Ryoku + Brain Shell**.

```bash
git clone https://github.com/ilhamfirmansyahhub/keybinds-ilham.git
cd keybinds-ilham
chmod +x install.sh
./install.sh
hyprctl reload
```

This restores the original Ryoku-oriented keybind modules and Brain Shell bindings. It expects the Ryoku/Brain Shell environment to already be installed and working.

### Mode 2 — Generic Hyprland

Use this when moving to another distro or when the new Hyprland setup does **not** use Ryoku/Brain Shell. This is the recommended mode for Fedora, vanilla Arch, or another independent Hyprland setup.

```bash
git clone https://github.com/ilhamfirmansyahhub/keybinds-ilham.git
cd keybinds-ilham
chmod +x install.sh
./install.sh --generic
```

Generic mode keeps the portable Windows-style/core shortcut layout and replaces Ryoku-specific commands with generic application commands.

## What happens during installation

Both installers back up existing files before replacing them.

The original mode restores the user-specific Hyprland modules and Brain Shell keybind file. It deliberately does **not** replace a fresh Ryoku-generated `hyprland.lua`, because that file is part of Ryoku's loader/configuration system.

The generic mode installs:

```text
~/.config/hypr/keybinds-ilham-generic.conf
~/.local/bin/ilham-hypr-app
```

When a normal `~/.config/hypr/hyprland.conf` exists, the installer adds a `source = ...` line automatically. Custom Lua-based or otherwise non-standard Hyprland loaders may require that source line to be added through their own loader.

## Generic mode: what stays the same

The intention is to preserve the **feel and muscle memory** of the Ilham layout rather than to reproduce every Ryoku feature.

Portable shortcuts include window close/fullscreen/floating, window focus, move and resize, resize mode with arrows or `hjkl`, application launching, launcher, lock, workspace navigation and movement, mouse window controls, media controls, brightness, color picker, clipboard, window switching, and screenshots.

Ryoku/Brain Shell features that have no reliable generic equivalent are replaced where practical or intentionally omitted.

## Dependencies

### Original / Ryoku mode

The original keybinds directly call or depend on commands such as:

- `ryoku`
- `kitty`
- `yazi`
- `playerctl`
- `libnotify`
- `hyprpicker`
- `ryoku-shell`
- `ryoku-monitor`
- `ryogami`
- `ryoku-workspace`
- `qs`
- Brain Desktop / Brain Shell

See `packages.txt` for the reference dependency notes.

### Generic mode

Generic mode intentionally does not assume a single package manager. The installer can therefore be used on distributions such as Arch, CachyOS, Fedora, and others without forcing Arch-specific package commands.

The generic helper searches for commonly installed programs at runtime. For example, it can use `kitty`, `foot`, `alacritty`, `wezterm`, or another available terminal; `dolphin`, `thunar`, or `nautilus` for files; and `rofi`, `wofi`, `fuzzel`, or `tofi` for launching.

Optional features use tools such as:

- `playerctl` — media controls
- `brightnessctl` — brightness controls
- `hyprlock` — lock screen
- `hyprpicker` — color picker
- `wl-clipboard` — Wayland clipboard integration
- `cliphist` — clipboard history
- `hyprshot`, `grimblast`, or `grim + slurp` — screenshots

See `generic/packages.txt` for the reference list.

## Important portability limitation

The keybind syntax itself is designed for Hyprland, but **commands behind keybinds are still environment-dependent**.

For example, a keybind can remain `SUPER + E` on every distro, while the program launched by that keybind may differ depending on what is installed.

Therefore:

- On a fresh Hyprland installation, generic mode is the safest choice.
- On the current CachyOS + Ryoku setup, original mode gives the closest reproduction.
- On a custom Hyprland Lua setup, generic mode may need one manual integration step.
- No installer can guarantee that every optional application mentioned in the backup exists on every distribution.

## Special notes about the original backup

The repository also contains a copy of the original `hyprland.lua` for reference. It should be treated as a **reference snapshot**, not as a universal file to overwrite on every machine.

The original setup also contains Brain Shell bindings that point to the Brain Desktop environment. The installer adjusts the home-directory path for the current user, but the Brain Desktop itself is not bundled here.

## Included files

```text
generic/
├── keybinds-ilham.conf
├── ilham-hypr-app
└── packages.txt

hypr/
├── hyprland.lua
├── user.lua
├── rebinds.lua
└── modules/
    ├── binds.lua
    ├── resize.lua
    ├── record.lua
    ├── ryoshot.lua
    └── lid.lua

Brain_Shell/
└── Brain_ShellKeybinds.lua

packages.txt
install.sh
README.md
```

## Recommended workflow after an OS reinstall

### Reusing the original Ryoku environment

```bash
git clone https://github.com/ilhamfirmansyahhub/keybinds-ilham.git
cd keybinds-ilham
./install.sh
hyprctl reload
```

### Moving to another distro / generic Hyprland

```bash
git clone https://github.com/ilhamfirmansyahhub/keybinds-ilham.git
cd keybinds-ilham
./install.sh --generic
hyprctl reload
```

Then install whichever optional applications you want so the corresponding shortcuts have something to launch.

## Updating the backup in the future

When the working Ilham setup changes, update the repository from the current machine rather than editing the backup by hand. Keep this README current whenever a dependency or integration assumption changes.

## Safety

The installers run as a normal user and only use `sudo` where package installation requires it. Existing configuration files are backed up before replacement.

Do not commit passwords, access tokens, SSH private keys, personal secrets, or other sensitive files to this repository.

## Author

[Ilham Firmansyah](https://github.com/ilhamfirmansyahhub)
