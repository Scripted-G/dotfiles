# Arch Linux + Sway Dotfiles

Personal configuration files for my Arch Linux setup with Sway window manager.

## Hardware

- **CPU**: AMD Ryzen 9 9900X
- **GPU**: AMD Radeon RX 9070 XT
- **RAM**: 32GB DDR5
- **Monitors**: Dual 27" 1440p @ 120Hz
  - DP-1: Landscape (primary)
  - DP-2: Portrait (right side)

## Overview

- **Window Manager**: Sway
- **Bar**: Waybar
- **Terminal**: Alacritty
- **Shell**: Bash + Starship prompt
- **Launcher**: Rofi
- **Greeter**: greetd + nwg-hello
- **Lock Screen**: swaylock
- **Theme**: Tokyo Night
- **Filesystem**: BTRFS with Snapper snapshots
- **Bootloader**: GRUB with grub-btrfs

## Repository Structure

```
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
├── packages/
│   ├── official-packages.txt
│   └── aur-packages.txt
└── docs/                    # Additional documentation
```

## Installation

### Prerequisites

- Arch Linux installed with Sway
- BTRFS filesystem (recommended)
- An AUR helper (paru recommended)

### 1. Clone Repository

```bash
git clone https://github.com/Scripted-G/dotfiles.git ~/dotfiles
```

### 2. Install Packages

Enable multilib repository first (for Steam and 32-bit packages):

```bash
sudo nano /etc/pacman.conf
# Uncomment [multilib] and the Include line below it
sudo pacman -Sy
```

Install official packages:

```bash
sudo pacman -S --needed $(cat ~/dotfiles/packages/official-packages.txt)
```

Install AUR helper (if not installed):

```bash
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/paru.git /tmp/paru
cd /tmp/paru && makepkg -si
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
cp -r ~/dotfiles/configs/sway ~/.config/
cp -r ~/dotfiles/configs/waybar ~/.config/
cp -r ~/dotfiles/configs/alacritty ~/.config/
cp -r ~/dotfiles/configs/rofi ~/.config/
cp -r ~/dotfiles/configs/swaylock ~/.config/
cp -r ~/dotfiles/configs/fastfetch ~/.config/
```

### 5. Copy Shell Configs

```bash
cp ~/dotfiles/shell/.bashrc ~/
cp ~/dotfiles/shell/.bash_profile ~/
cp ~/dotfiles/shell/.gitconfig ~/
cp ~/dotfiles/shell/starship.toml ~/.config/
```

### 6. Install Alacritty Themes

The Alacritty config imports the Tokyo Night theme from the official theme repository:

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

The wallpaper is copied to both locations because:
- `~/Pictures/Wallpapers/` - Used by sway and swaylock (user session)
- `/usr/share/backgrounds/` - Used by nwg-hello greeter (runs as greeter user)

### 8. Reload Sway

```bash
swaymsg reload
```

## System Configuration (Reference)

The `system/` directory contains system-level configurations that require root access. These are provided as reference - copy and modify as needed.

### Greeter Setup (greetd + nwg-hello)

```bash
sudo cp ~/dotfiles/system/greetd/config.toml /etc/greetd/
sudo cp ~/dotfiles/system/nwg-hello/* /etc/nwg-hello/
```

The greeter user needs a home directory for shader cache:

```bash
sudo usermod -d /var/lib/greeter greeter
sudo mkdir -p /var/lib/greeter
sudo chown greeter:greeter /var/lib/greeter
```

Add your user to the seat group:

```bash
sudo usermod -aG seat $USER
```

Enable greetd:

```bash
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

For bootable snapshots in GRUB menu:

```bash
sudo cp ~/dotfiles/system/grub-btrfs/config /etc/default/grub-btrfs/
sudo systemctl enable --now grub-btrfsd
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

**Note**: The config sets `GRUB_BTRFS_GBTRFS_SEARCH_DIRNAME="/grub"` because archinstall uses the "removable" EFI boot method which breaks the default prefix detection.

### Xbox Controller (Bluetooth)

Install xpadneo for better Xbox controller support:

```bash
paru -S xpadneo-dkms
```

Disable ERTM to prevent connection issues:

```bash
sudo cp ~/dotfiles/system/modprobe/bluetooth.conf /etc/modprobe.d/
```

Reboot for changes to take effect.

**Steam Settings** (if using Steam):
- "Enable Steam Input for Xbox controllers": OFF
- "Guide button focuses Steam": OFF

### UFW Firewall

```bash
sudo ufw enable
sudo ufw default deny incoming
sudo ufw default allow outgoing
```

If using libvirt/VMs, add these rules for VM networking:

```bash
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

## Monitor Configuration

Dual monitor setup with portrait rotation on the right:

```
output DP-1 scale 1 position 0 0 mode 2560x1440@120Hz
output DP-2 scale 1 position 2560 -275 mode 2560x1440@120Hz transform 90
```

Workspaces alternate between monitors (odd on DP-1, even on DP-2).

## Known Quirks

1. **nwg-hello .snapshots warning**: Cosmetic warning caused by `/home/.snapshots` snapper subvolume. Does not affect functionality.

2. **Greeter screen flicker**: Brief flicker on login screen is normal when initializing dual monitors with rotation.

## License

These are my personal dotfiles. Feel free to use and modify for your own setup.
