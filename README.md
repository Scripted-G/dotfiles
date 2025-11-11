# My Dotfiles
My personal Linux configuration files for Sway window manager on Arch Linux.

## Contents

### Sway Configuration
- `sway/config` - Main Sway window manager configuration
- `sway/config.d/` - Modular Sway configuration snippets
  - `60-bindings-media.conf` - Media player controls
  - `60-bindings-screenshot.conf` - Screenshot keybindings (grimshot)
  - `60-bindings-volume.conf` - Volume control keys (pamixer)
  - `90-swayidle.conf` - Idle/sleep settings

### Application Configs
- `alacritty/` - Terminal emulator configuration
- `waybar/` - Status bar configuration
- `rofi/` - Application launcher configuration
- `fastfetch/` - System information tool configuration
- `swaylock/` - Screen locker configuration

### Shell Configuration
- `.bashrc` - Bash shell configuration
- `.bash_profile` - Bash login shell configuration
- `starship.toml` - Starship prompt configuration

### Package Lists
- `user-installed-packages.txt` - List of explicitly installed packages (107 packages)

## Quick Setup

### Prerequisites
Arch Linux with archinstall (recommended with btrfs + snapper)

### Installation

1. Clone this repository
```bash
git clone git@github.com:Scripted-G/dotfiles.git
cd dotfiles
```

2. Install all packages from the list
```bash
sudo pacman -S --needed $(cat user-installed-packages.txt)
```

3. Install AUR helper (paru) if not already installed
```bash
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
cd ..
rm -rf paru
```

4. Copy configs to home directory
```bash
cp -r alacritty waybar rofi fastfetch swaylock ~/.config/
cp -r sway/* ~/.config/sway/
cp .bashrc .bash_profile ~/
cp starship.toml ~/.config/
cp .gitconfig ~/
```

5. Create wallpaper directory and add your wallpaper
```bash
mkdir -p ~/Pictures/wallpapers
# Copy your wallpaper to ~/Pictures/wallpapers/arch-linux-4k-wallpapers.png
# Or update the wallpaper path in sway/config and swaylock/config
```

6. Reload Sway
```
Mod+Shift+C
```

## Important Notes

### SDDM Clock Fix
The maldives SDDM theme has the clock hardcoded to 24-hour format. To fix it for 12-hour AM/PM format:
```bash
sudo nano /usr/lib/qt/qml/SddmComponents/Clock.qml
```

Find line 43 and change:
```qml
text : Qt.formatTime(container.dateTime, "hh:mm")
```

To:
```qml
text : Qt.formatTime(container.dateTime, "hh:mm AP")
```

Save and restart SDDM:
```bash
sudo systemctl restart sddm
```

**Note:** This change may be overwritten on SDDM package updates.

### SDDM Background
To change SDDM background, edit `/usr/share/sddm/themes/maldives/theme.conf.user`:
```
[General]
background=your-wallpaper.png
```

And copy your wallpaper to `/usr/share/sddm/themes/maldives/`

### Display Server
Using `DisplayServer=x11` in SDDM config for better multi-monitor support with Sway.

## Hardware
- AMD Ryzen 9 9900X
- AMD Radeon RX 9070 XT  
- Dual monitors: 2560x1440@120Hz on DP-1 and DP-2
