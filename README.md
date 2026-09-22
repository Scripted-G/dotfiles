## About

This repository contains the Arch Linux + Sway desktop environment I previously built and used as a daily driver.

The setup was designed around a few priorities: a clean tiling workflow for focused work, a consistent Tokyo Night visual theme, and a recoverable system built around BTRFS snapshots. I kept the configuration modular where it was useful and relatively minimal so I could understand and maintain the system instead of relying on large copied configuration sets.

The repository is preserved both as a personal reference and as an example of the Linux desktop, shell, system, and virtualization configuration work I completed while using Arch.

## Status

This setup is no longer my active daily-driver environment.

My current workstation runs **Ubuntu 26.04 LTS**, but these files document the Arch Linux + Sway configuration I previously used in daily operation. The repository is being kept as a historical reference and portfolio project rather than as an actively maintained Arch configuration.

Because Arch Linux and its packages continue to evolve, some configuration details or installation steps may require adjustment on newer systems.

## Hardware Used With This Setup

- **CPU:** AMD Ryzen 9 9900X
- **GPU:** NVIDIA GeForce RTX 5070 Ti
- **RAM:** 64 GB DDR5
- **Monitor:** ASUS ProArt PA278CGV — 27", 2560×1440, 120 Hz

The Arch + Sway environment documented in this repository was used with the following hardware:

## Overview
- **Window Manager**: Sway
- **Bar**: Waybar
- **Terminal**: Alacritty
- **Shell**: Bash + Starship
- **Launcher**: Rofi
- **Greeter**: greetd + nwg-hello
- **Lock Screen**: Swaylock
- **Theme**: Tokyo Night
- **Filesystem**: BTRFS with Snapper snapshots
- **Bootloader**: GRUB with grub-btrfs

## Repository Structure

    dotfiles/
    ├── assets/                  # Wallpaper
    ├── configs/
    │   ├── sway/               # Sway window manager config
    │   │   ├── config
    │   │   └── config.d/       # Modular config snippets
    │   ├── waybar/             # Status bar
    │   ├── alacritty/          # Terminal emulator
    │   ├── rofi/               # Application launcher
    │   ├── swaylock/           # Lock screen
    │   └── fastfetch/          # System info display
    ├── shell/                   # Shell configurations
    │   ├── .bashrc
    │   ├── .bash_profile
    │   ├── .gitconfig
    │   └── starship.toml
    ├── system/                  # System-level configs (reference only)
    │   ├── greetd/             # Login greeter
    │   ├── nwg-hello/          # Greeter theme
    │   ├── snapper/            # BTRFS snapshot configs
    │   ├── modprobe/           # Kernel module options
    │   └── grub-btrfs/         # GRUB snapshot boot entries
    └── packages/
        ├── official-packages.txt
        └── aur-packages.txt

## Installation

**Historical reference:** The following steps document how this Arch + Sway environment was installed and configured when it was in active use. They have not been maintained as current Arch Linux installation instructions and may require adjustment on newer systems.

### Prerequisites
- Arch Linux installed with Sway
- BTRFS filesystem (recommended)
- An AUR helper (paru recommended)

### 1. Clone Repository
```bash
git clone https://github.com/Scripted-G/dotfiles.git ~/dotfiles
```

### 2. Install Packages
Enable multilib repository first:
```bash
sudo nano /etc/pacman.conf
# Uncomment [multilib] and the Include line below it
sudo pacman -Sy
```

Install official packages:
```bash
sudo pacman -S --needed $(cat ~/dotfiles/packages/official-packages.txt)
```

Install AUR helper:
```bash
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/paru.git /tmp/paru
cd /tmp/paru
makepkg -si
```

Install AUR packages:
```bash
paru -S --needed $(cat ~/dotfiles/packages/aur-packages.txt)
```

### 3. Create Config Directory
```bash
mkdir -p ~/.config
```

### 4. Copy User Configs
```bash
cp -r ~/dotfiles/configs/{sway,waybar,alacritty,rofi,swaylock,fastfetch} ~/.config/
```

### 5. Copy Shell Configs
```bash
cp ~/dotfiles/shell/.bashrc ~/
cp ~/dotfiles/shell/.bash_profile ~/
cp ~/dotfiles/shell/starship.toml ~/.config/
```

### 6. Install Alacritty Themes
```bash
git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes
```

### 7. Setup Wallpaper
```bash
mkdir -p ~/Pictures/Wallpapers
cp ~/dotfiles/assets/arch-linux-4k-wallpapers.png ~/Pictures/Wallpapers/
sudo mkdir -p /usr/share/backgrounds
sudo cp ~/dotfiles/assets/arch-linux-4k-wallpapers.png /usr/share/backgrounds/
```

### 8. Reload Sway
```bash
swaymsg reload
```

## System Configuration (Reference)

### Greeter Setup (greetd + nwg-hello)
```bash
sudo cp ~/dotfiles/system/greetd/config.toml /etc/greetd/
sudo cp ~/dotfiles/system/nwg-hello/* /etc/nwg-hello/
```

```bash
sudo usermod -d /var/lib/greeter greeter
sudo mkdir -p /var/lib/greeter
sudo chown greeter:greeter /var/lib/greeter
sudo usermod -aG seat $USER
sudo systemctl enable greetd
```

### Snapper (BTRFS Snapshots)
```bash
sudo cp ~/dotfiles/system/snapper/root /etc/snapper/configs/
sudo cp ~/dotfiles/system/snapper/home /etc/snapper/configs/
sudo systemctl enable --now snapper-timeline.timer
sudo systemctl enable --now snapper-cleanup.timer
```

### grub-btrfs
```bash
sudo cp ~/dotfiles/system/grub-btrfs/config /etc/default/grub-btrfs/
sudo systemctl enable --now grub-btrfsd
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

**Note:** The config sets `GRUB_BTRFS_GBTRFS_SEARCH_DIRNAME="/grub"` because 
archinstall uses the "removable" EFI boot method which breaks default prefix 
detection.

### Xbox Controller (Bluetooth)
Driver and Bluetooth configuration:
```bash
paru -S xpadneo-dkms
sudo cp ~/dotfiles/system/modprobe/bluetooth.conf /etc/modprobe.d/
```
After installing the driver, also configure Steam to avoid input conflicts:
- "Enable Steam Input for Xbox controllers": OFF
- "Guide button focuses Steam": OFF

### UFW Firewall
```bash
sudo ufw enable
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow in on virbr0
sudo ufw allow out on virbr0
sudo ufw default allow routed
```

### Libvirt (Virtual Machines)
```bash
sudo systemctl enable --now libvirtd
sudo systemctl enable --now virtnetworkd
sudo usermod -aG libvirt,kvm $USER
```

## Keybindings

| Key | Action |
|-----|--------|
| `Mod+Return` | Open terminal |
| `Mod+d` | Application launcher (rofi) |
| `Mod+q` | Close window |
| `Mod+Shift+Return` | Lock screen |
| `Mod+Shift+e` | Exit sway |
| `Mod+Shift+r` | Reload sway config |
| `Mod+h/j/k/l` | Focus left/down/up/right |
| `Mod+Shift+h/j/k/l` | Move window |
| `Mod+1-0` | Switch to workspace 1-10 |
| `Mod+Shift+1-0` | Move window to workspace |
| `Mod+f` | Fullscreen |
| `Mod+Shift+space` | Toggle floating |
| `Print` | Screenshot (full screen) |
| `Shift+Print` | Screenshot (select area) |

## Known Quirks
1. **nwg-hello .snapshots warning**: Cosmetic warning caused by 
   `/home/.snapshots` snapper subvolume. Does not affect functionality.
2. **Greeter screen flicker**: Brief flicker on login screen is normal when 
   initializing dual monitors with rotation.

## License

This project is licensed under the MIT License. See `LICENSE` for details.
