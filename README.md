# My Dotfiles
My personal Linux configuration files for Sway window manager and associated tools.
## Contents
### Sway Configuration
- `sway/config` - Main Sway window manager configuration
- `sway/config.d/` - Modular Sway configuration snippets
  - `60-bindings-brightness.conf` - Brightness control keys
  - `60-bindings-media.conf` - Media player controls
  - `60-bindings-screenshot.conf` - Screenshot keybindings
  - `60-bindings-volume.conf` - Volume control keys
  - `90-swayidle.conf` - Idle/sleep settings (currently disabled)
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
- `user-installed-packages.txt` - List of explicitly installed DNF packages (317 packages)
- `flatpak-packages.txt` - List of installed Flatpak applications (Spotify, Discord)
## Required Packages
### Fedora
```bash
sudo dnf install sway waybar rofi alacritty pipewire pipewire-pulse wireplumber \
    brightnessctl playerctl libnotify btop fastfetch swaylock starship
```
### Arch Linux
```bash
sudo pacman -S sway waybar rofi alacritty pipewire pipewire-pulse wireplumber \
    brightnessctl playerctl libnotify btop fastfetch swaylock pamixer mako starship
```
## Notes
- Volume bindings on Fedora use `/usr/libexec/sway/volume-helper`
- For Arch, the volume config needs to be modified to use `pamixer` instead
- Screenshots use `grimshot` (included with Sway)
- Package lists are from Fedora 43 and provided as reference
## Installation
1. Clone this repository
```bash
git clone git@github.com:Scripted-G/dotfiles.git
cd dotfiles
```
2. Install required packages (see above for your distro)
3. Backup existing configs (optional but recommended)
```bash
mkdir -p ~/config-backup
cp -r ~/.config/sway ~/config-backup/
cp ~/.bashrc ~/config-backup/
cp ~/.bash_profile ~/config-backup/
```
4. Copy configs to home directory
```bash
cp -r alacritty waybar rofi fastfetch swaylock ~/.config/
cp -r sway/* ~/.config/sway/
cp .bashrc .bash_profile ~/
cp starship.toml ~/.config/
```
5. Reload Sway
```
Mod+Shift+C
```
## Package Restoration
To install the same packages on a new system:
### Fedora
```bash
# Review and edit the package list first
cat user-installed-packages.txt
# Install packages (review first, some may not be needed)
sudo dnf install $(cat user-installed-packages.txt)
```
### Flatpaks
```bash
cat flatpak-packages.txt | xargs -I {} flatpak install flathub {}
```
Note: Package list is provided as reference. Not all packages may be necessary for a minimal install.
