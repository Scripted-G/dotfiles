# Arch Linux Fresh Install - Complete Setup Guide

## Pre-Install
- [ ] Backup important files from current system
- [ ] Note down WiFi password if needed
- [ ] Have USB with Arch ISO ready
- [ ] Copy wallpaper file if not in repo

## Installation (archinstall)
- [ ] Use archinstall script
- [ ] Select btrfs filesystem
- [ ] Enable snapper for automatic snapshots (hourly for / and /home)
- [ ] Set username (configs use $HOME so any username works)
- [ ] Install Sway desktop profile
- [ ] Enable NetworkManager
- [ ] Enable bluetooth if needed

## Post-Install: Core System Setup

### 1. Clone Dotfiles Repository
```bash
cd ~
git clone git@github.com:Scripted-G/dotfiles.git
cd dotfiles
```

### 2. Install All Official Packages
```bash
sudo pacman -S --needed $(cat packages/official-packages.txt)
```

**Key packages include:**
- **Desktop:** sway, waybar, rofi, alacritty, swaylock, dunst
- **Audio:** pipewire, pipewire-pulse, wireplumber, pamixer
- **Utils:** grimshot (screenshots), imv (image viewer), btop, fastfetch, starship
- **Themes:** arc-gtk-theme, papirus-icon-theme, qt5ct, qt6ct
- **File Manager:** thunar, thunar-archive-plugin, thunar-volman, gvfs, tumbler
- **Fonts:** ttf-jetbrains-mono-nerd, noto-fonts, noto-fonts-emoji
- **Python:** python, python-pip, python-virtualenv, ipython
- **Media Codecs:** gst-libav, gst-plugins-bad, gst-plugins-ugly
- **Archives:** zip, unzip, p7zip (via 7zip package)
- **Filesystems:** exfatprogs, dosfstools, ntfs-3g
- **PDF Viewer:** qpdfview

### 3. Install AUR Helper (paru)
```bash
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
cd ..
rm -rf paru
```

### 4. Install AUR Packages
```bash
paru -S $(cat packages/aur-packages.txt)
```

**AUR Package Notes:**
- **xpadneo-dkms:** Xbox controller driver (Bluetooth)
- **mu-editor:** Requires python-pip and python-virtualenv
- **sway-systemd:** Systemd integration for Sway
- **wdisplays:** GUI display configuration tool

### 5. Apply Dotfiles
```bash
cd ~/dotfiles

# Copy configs
cp -r configs/alacritty configs/waybar configs/rofi configs/fastfetch configs/swaylock ~/.config/
cp -r configs/sway ~/.config/
cp -r configs/qt5ct configs/qt6ct configs/gtk-3.0 ~/.config/
cp shell/.bashrc shell/.bash_profile ~/
cp shell/starship.toml ~/.config/
cp .gitconfig ~/

# Setup wallpaper
mkdir -p ~/Pictures/wallpapers
cp assets/arch-linux-4k-wallpapers.png ~/Pictures/wallpapers/
```

### 6. Setup Git SSH Keys
```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub
```
Add this key to GitHub: Settings > SSH and GPG keys > New SSH key

### 7. Enable Required Services
```bash
# System services
sudo systemctl enable --now NetworkManager
sudo systemctl enable --now bluetooth
sudo systemctl enable --now sddm

# Firewall (UFW)
sudo systemctl enable --now ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable
```

## Application-Specific Configuration

### PyCharm Community Edition
After installing, fix the script launcher error:
```bash
sudo nano /usr/share/applications/pycharm.desktop
```

Change the Exec line to:
```
Exec=/usr/share/pycharm/bin/pycharm %f
```

### VS Code Settings Sync
Keyring is configured via bash_profile environment variables:
- `QT_QPA_PLATFORMTHEME=qt6ct`
- `GNOME_KEYRING_CONTROL=/run/user/$(id -u)/keyring`

These are already in the dotfiles bash_profile.

### Xbox Controller (Bluetooth)
The xpadneo-dkms driver is installed. Controller can only pair to ONE system at a time.

To switch between systems:
```bash
bluetoothctl remove <MAC_ADDRESS>
```
Then re-pair on the other system.

## SDDM Configuration

### Set SDDM Theme to Maldives
Check if theme is already set. If not:
```bash
sudo mkdir -p /etc/sddm.conf.d/
sudo nano /etc/sddm.conf.d/theme.conf
```

Add:
```
[Theme]
Current=maldives
```

### Fix Clock to 12-Hour Format
**CRITICAL:** This must be done after every SDDM update.
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

### Set SDDM Background
```bash
# Copy wallpaper to SDDM theme directory
sudo cp ~/Pictures/wallpapers/arch-linux-4k-wallpapers.png /usr/share/sddm/themes/maldives/

# Create theme config
sudo nano /usr/share/sddm/themes/maldives/theme.conf.user
```

Add:
```
[General]
background=arch-linux-4k-wallpapers.png
```

### Restart SDDM
```bash
sudo systemctl restart sddm
```

## Theme Configuration

**Qt Applications (Qt5/Qt6):**
- Style: Fusion
- Color scheme: darker.conf
- Already configured via qt5ct/qt6ct configs in dotfiles

**GTK Applications:**
- GTK Theme: Arc-Dark
- Icon Theme: Papirus-Dark
- Already configured via gtk-3.0/settings.ini in dotfiles

**Environment Variables:**
Set in .bash_profile (already in dotfiles):
```bash
export QT_QPA_PLATFORMTHEME=qt6ct
export GNOME_KEYRING_CONTROL=/run/user/$(id -u)/keyring
```

## Final Steps

### Reload Sway
Log in and press `Mod+Shift+C` to reload Sway configuration

### Install Proton VPN
Already in AUR packages, autostart configured in sway/config:
```
exec protonvpn-app
```

### Verify Snapper
```bash
sudo snapper list-configs
# Should show: root (/) and home (/home)

sudo snapper list
# Should show snapshots
```

## Verification Checklist
- [ ] Dual monitors working (DP-1 and DP-2 at 2560x1440@120Hz)
- [ ] Waybar showing on both monitors with correct workspace assignments
- [ ] Screenshots working (Print key - grimshot)
- [ ] Volume controls working (XF86Audio keys - pamixer)
- [ ] SDDM shows 12-hour clock with AM/PM
- [ ] SDDM shows correct background wallpaper
- [ ] Swaylock shows correct wallpaper
- [ ] Desktop wallpaper correct
- [ ] Proton VPN autostart working
- [ ] Starship prompt shows Arch icon (󰣇)
- [ ] Git SSH works for GitHub
- [ ] Dark theme applied (Qt Fusion + Arc-Dark GTK)
- [ ] Papirus-Dark icons showing
- [ ] PyCharm launches without script launcher error
- [ ] VS Code Settings Sync working (keyring configured)
- [ ] Thunar file manager opens files correctly (gvfs working)
- [ ] PDF files open in qpdfview
- [ ] Images open in imv
- [ ] Snapper taking hourly snapshots
- [ ] UFW firewall enabled and running
- [ ] Xbox controller pairs via Bluetooth (if applicable)

## Package Count Reference
- **Official repos:** ~107 explicitly installed packages
- **AUR:** 14 packages (brave, chrome, vscode, spotify, mu-editor, etc.)

## Important Notes
- **SDDM clock fix** will be overwritten on sddm package updates - re-apply after updates
- **Snapper** configured for hourly snapshots of / and /home
- **DisplayServer=x11** in SDDM for better multi-monitor support with Sway
- **Xbox controller** can only pair to one system at a time (Arch OR Fedora, not both)
- **Python packages** for mu-editor: python-pip and python-virtualenv required

## Hardware Reference
- **CPU:** AMD Ryzen 9 9900X
- **GPU:** AMD Radeon RX 9070 XT
- **Monitors:** Dual 2560x1440@120Hz (DP-1, DP-2)
- **Controller:** Xbox Wireless Controller (Bluetooth via xpadneo)

## Troubleshooting

### If SDDM shows 24-hour clock:
Re-apply the Clock.qml fix (see SDDM Configuration section)

### If wallpapers not showing:
Verify file exists at `~/Pictures/wallpapers/arch-linux-4k-wallpapers.png`

### If VS Code Settings Sync not working:
Check that bash_profile environment variables are set (relog to apply)

### If Thunar can't open files:
Ensure gvfs and tumbler packages are installed

### If screenshots not working:
Verify grimshot is installed (comes with sway package)
