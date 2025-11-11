# Arch Linux Fresh Install Checklist

## Pre-Install
- [ ] Backup important files from current system
- [ ] Note down WiFi password if needed
- [ ] Have USB with Arch ISO ready

## Installation (archinstall)
- [ ] Use archinstall script
- [ ] Select btrfs filesystem
- [ ] Enable snapper for automatic snapshots
- [ ] Set username (can be anything, configs use $HOME)
- [ ] Install Sway desktop profile
- [ ] Enable NetworkManager

## Post-Install: System Configuration

### 1. Install Packages
```bash
cd ~
git clone git@github.com:Scripted-G/dotfiles.git
cd dotfiles
sudo pacman -S --needed $(cat user-installed-packages.txt)
```

### 2. Install AUR Helper (paru)
```bash
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
cd ..
rm -rf paru
```

### 3. Apply Dotfiles
```bash
cd ~/dotfiles
cp -r alacritty waybar rofi fastfetch swaylock ~/.config/
cp -r sway/* ~/.config/sway/
cp .bashrc .bash_profile ~/
cp starship.toml ~/.config/
cp .gitconfig ~/
```

### 4. Setup Wallpapers
```bash
mkdir -p ~/Pictures/wallpapers
# Copy your wallpaper file to ~/Pictures/wallpapers/arch-linux-4k-wallpapers.png
```

### 5. SDDM Configuration

#### Fix Clock to 12-Hour Format
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
Save and exit.

#### Set SDDM Theme and Background
```bash
# Copy wallpaper to SDDM theme directory
sudo cp ~/Pictures/wallpapers/arch-linux-4k-wallpapers.png /usr/share/sddm/themes/maldives/

# Create theme config
sudo nano /usr/share/sddm/themes/maldives/theme.conf.user
```
Add this content:
```
[General]
background=arch-linux-4k-wallpapers.png
```

#### Set SDDM to use maldives theme
Check if `/etc/sddm.conf` or `/etc/sddm.conf.d/` has theme settings. If not, create:
```bash
sudo mkdir -p /etc/sddm.conf.d/
sudo nano /etc/sddm.conf.d/theme.conf
```
Add:
```
[Theme]
Current=maldives
```

### 6. Setup Git SSH Keys
```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub
# Add this key to GitHub: Settings > SSH and GPG keys > New SSH key
```

### 7. Qt Theme Configuration (Dark Mode)
Already configured via qt5ct and qt6ct packages. Verify in applications.

### 8. Firewall (UFW)
```bash
sudo systemctl enable --now ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable
```

### 9. Enable Proton VPN Autostart
Already configured in sway/config:
```
exec protonvpn-app
```

### 10. Reload Sway
Press `Mod+Shift+C` to reload Sway config

### 11. Restart SDDM
```bash
sudo systemctl restart sddm
```
Check that clock shows 12-hour format and background is correct.

## Verification Checklist
- [ ] Dual monitors working (DP-1 and DP-2 at 2560x1440@120Hz)
- [ ] Waybar showing on both monitors
- [ ] Screenshots working (grimshot)
- [ ] Volume controls working (pamixer)
- [ ] SDDM shows 12-hour clock
- [ ] SDDM shows correct background
- [ ] Proton VPN autostart working
- [ ] Starship prompt shows Arch icon
- [ ] Git SSH works for GitHub
- [ ] Dark theme applied system-wide

## Notes
- SDDM clock fix may be overwritten on sddm package updates - re-apply if needed
- Snapper snapshots configured for hourly backups of / and /home
- Using DisplayServer=x11 in SDDM for better multi-monitor support

## Hardware Reference
- CPU: AMD Ryzen 9 9900X
- GPU: AMD Radeon RX 9070 XT
- Monitors: Dual 2560x1440@120Hz (DP-1, DP-2)
