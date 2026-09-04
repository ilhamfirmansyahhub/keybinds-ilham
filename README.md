# Hyprland Keybinds — Ilham

Personal backup of the working `ilham` Hyprland keybind setup on CachyOS + Ryoku + Brain Shell.

This repository is intended to make a fresh OS installation easier: restore the keybind files once and keep your familiar shortcuts.

## Quick install

Designed for Arch Linux / CachyOS.

```bash
git clone https://github.com/ilhamfirmansyahhub/keybinds-ilham.git
cd keybinds-ilham
chmod +x install.sh
./install.sh
```

The installer:

- installs the common command-line dependencies with `pacman`;
- creates the required configuration directories;
- backs up existing keybind files with a timestamp;
- restores the Hyprland keybind modules;
- restores the Ryoku keybind remap (`SUPER + Space` → `SUPER + X`);
- restores Brain Shell keybinds and automatically adapts the Brain Shell path to the current `$HOME`.

Reload Hyprland after installation:

```bash
hyprctl reload
```

## Included files

```text
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
```

## Main shortcuts preserved

The backup includes the existing Windows-style window controls, window focus/move/resize shortcuts, app launch shortcuts, Ryoku launcher/tools, workspaces, scratchpads, media keys, brightness controls, touchpad controls, screenshot shortcuts, lid-switch handling, the resize submap, and Brain Shell bindings.

The exact shortcuts are kept in the Lua files rather than duplicated in this README, so the files remain the source of truth.

## Dependencies

Common packages used directly by the keybind commands:

- `ryoku`
- `kitty`
- `yazi`
- `playerctl`
- `libnotify`
- `hyprpicker`

The full desktop behavior also relies on the existing Ryoku/Brain Shell environment, including commands such as `ryoku-shell`, `ryoku-monitor`, `ryogami`, `qs`, `ryoku-workspace`, and the Brain Desktop configuration.

`packages.txt` contains the dependency notes.

## Important: Ryoku-generated files

`hyprland.lua` is included in the repository as a reference backup of the working setup. The installer intentionally does **not** overwrite a fresh Ryoku-generated `hyprland.lua`, because Ryoku may generate/update that loader for the installed version.

The keybind modules that are user-specific are restored directly, while the fresh Ryoku loader remains in control of the overall configuration.

## Brain Shell

The included Brain Shell keybind file was captured from the working setup. It references the Brain Desktop configuration under:

```text
~/.config/quickshell/brain-desktop
```

The installer rewrites the embedded path to the current user's `$HOME`, so it is not permanently tied to `/home/ilham`.

The Brain Desktop itself is **not** included in this repository and must be restored separately.

## Safety

The installer runs as a normal user and only uses `sudo` for installing packages. Existing configuration files are backed up before replacement. No passwords, tokens, or secrets should be stored in this repository.

## Author

[Ilham Firmansyah](https://github.com/ilhamfirmansyahhub)
