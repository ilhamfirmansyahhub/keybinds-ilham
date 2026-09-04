# Hyprland Keybinds — Ilham

A reusable backup of Ilham's Hyprland keyboard shortcuts, with two installation modes:

- **Ilham / Ryoku mode** — restores the original CachyOS + Ryoku + Brain Shell setup.
- **Generic Hyprland mode** — keeps the Windows-style/core shortcuts while removing the dependency on Ryoku and Brain Shell. It is intended for moving between Arch, CachyOS, Fedora, and other distributions that run a normal Hyprland configuration.

## Quick install — Ilham / Ryoku

For the original setup:

```bash
git clone https://github.com/ilhamfirmansyahhub/keybinds-ilham.git
cd keybinds-ilham
chmod +x install.sh
./install.sh
hyprctl reload
```

This mode restores the original Lua keybind modules, Ryoku key remap, and Brain Shell bindings. It expects a working Ryoku/Brain Shell environment.

## Quick install — Generic Hyprland

For another distro or a Hyprland setup without Ryoku:

```bash
git clone https://github.com/ilhamfirmansyahhub/keybinds-ilham.git
cd keybinds-ilham
chmod +x install.sh
./install.sh --generic
```

The generic installer:

1. Installs a portable keybind file at `~/.config/hypr/keybinds-ilham-generic.conf`.
2. Installs `~/.local/bin/ilham-hypr-app`, which automatically detects commonly available terminals, launchers, file managers, browsers and desktop tools.
3. Backs up files before replacing them.
4. Automatically adds the generic `source = ...` line when a standard `~/.config/hypr/hyprland.conf` exists.
5. Does **not** require Ryoku or Brain Shell.

If your Hyprland setup does not use `hyprland.conf` (for example, a custom Lua/config loader), add this line through the loader used by your setup:

```text
source = ~/.config/hypr/keybinds-ilham-generic.conf
```

Then run:

```bash
hyprctl reload
```

## What generic mode preserves

Generic mode keeps the portable/core parts of the Ilham layout: Windows-style window controls, fullscreen/floating, focus and window movement, resize mode with arrows/hjkl, application shortcuts, launcher, lock, clipboard, window switching, workspace shortcuts, mouse move/resize, media keys, volume, brightness, color picker, and screenshots.

Functions that depended directly on Ryoku or Brain Shell are intentionally replaced with portable equivalents or omitted when there is no reliable cross-desktop equivalent.

## Dependencies

### Original mode

The original backup uses commands such as:

- `ryoku`
- `kitty`
- `yazi`
- `playerctl`
- `libnotify`
- `hyprpicker`
- Ryoku components such as `ryoku-shell`, `ryoku-monitor`, `ryogami`, `ryoku-workspace`, and `qs`
- Brain Desktop for the Brain Shell IPC bindings

See `packages.txt` for the Arch/CachyOS dependency notes.

### Generic mode

The generic installer does not assume one package manager. Install the tools you want from your distribution. The reference list is in `generic/packages.txt`.

At minimum, the generic keybind file can work with a terminal, a launcher, a file manager/browser, and Hyprland itself. Optional features use tools such as `playerctl`, `brightnessctl`, `hyprlock`, `hyprpicker`, `wl-clipboard`, `cliphist`, and a screenshot utility.

## Included files

```text
generic/
├── keybinds-ilham.conf
├── ilham-hypr-app
a└── packages.txt

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

`hyprland.lua` is retained as a reference backup of the original Ryoku loader. The original installer does not overwrite a fresh Ryoku-generated loader.

## Portability notes

The repository stores configuration, not a complete desktop environment. Generic mode is the portable choice when you move to another distribution or another Hyprland setup. Application commands are selected at runtime so the same shortcuts can survive different application choices.

The generic mode assumes a conventional Hyprland `hyprland.conf` when automatic sourcing is possible. Custom loaders may require one manual `source = ...` integration step.

## Safety

Both modes back up existing files before replacement. The repository should contain configuration only; do not add passwords, tokens, private keys, or other secrets.

## Author

[Ilham Firmansyah](https://github.com/ilhamfirmansyahhub)
