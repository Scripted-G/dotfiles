# My Sway Configuration

My personal Sway window manager configuration for Fedora/Arch Linux.

## Contents

- `config` - Main Sway configuration file
- `config.d/` - Modular configuration snippets
  - `60-bindings-brightness.conf` - Brightness control keys
  - `60-bindings-media.conf` - Media player controls
  - `60-bindings-screenshot.conf` - Screenshot keybindings
  - `60-bindings-volume.conf` - Volume control keys
  - `90-swayidle.conf` - Idle/sleep settings (currently disabled)

## Required Packages

### Fedora
```bash
sudo dnf install sway waybar pipewire pipewire-pulse wireplumber brightnessctl playerctl libnotify
```

### Arch Linux
```bash
sudo pacman -S sway waybar pipewire pipewire-pulse wireplumber brightnessctl playerctl libnotify pamixer mako
```

## Notes

- Volume bindings on Fedora use `/usr/libexec/sway/volume-helper` 
- For Arch, the volume config needs to be modified to use `pamixer` instead
- Screenshots use `grimshot` (included with Sway)

## Installation

1. Clone this repo
2. Install required packages (see above)
3. Symlink or copy configs to `~/.config/sway/`
4. Reload Sway with `Mod+Shift+C`
