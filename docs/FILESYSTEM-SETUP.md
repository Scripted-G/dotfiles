# Btrfs Filesystem Setup for Arch Installation

## Overview
This guide documents the exact btrfs filesystem structure with snapper for the Arch Linux installation.

## Partition Layout

**Drive:** nvme1n1 (Arch system drive)

| Partition | Size | Type | Mount Point | Filesystem |
|-----------|------|------|-------------|------------|
| nvme1n1p1 | ~1GB | EFI  | /boot       | vfat (FAT32) |
| nvme1n1p2 | Rest | Root | /           | btrfs |

## Btrfs Subvolume Structure

The btrfs partition (nvme1n1p2) should have these subvolumes:
```
@           -> mounted at /
@home       -> mounted at /home
@log        -> mounted at /var/log
@pkg        -> mounted at /var/cache/pacman/pkg
```

**Why these subvolumes:**
- `@` (root): Main system, separate from home for easier snapshots
- `@home`: User data, snapshotted separately from system
- `@log`: Logs excluded from root snapshots (changes frequently)
- `@pkg`: Pacman package cache (saves space, excluded from snapshots)

## Mount Options

**All btrfs mounts use these options:**
```
rw,relatime,compress=zstd:3,ssd,discard=async,space_cache=v2
```

**Option explanations:**
- `compress=zstd:3`: Transparent compression (level 3 balance of speed/size)
- `ssd`: SSD-specific optimizations
- `discard=async`: Async TRIM for better performance
- `space_cache=v2`: Improved free space tracking

## archinstall Configuration

When using archinstall:

1. **Disk Configuration:**
   - Select your target drive (e.g., nvme1n1)
   - Choose "btrfs" as filesystem
   - Enable "Use compression" (zstd)
   - Enable "Use subvolumes"

2. **Subvolume Configuration:**
   archinstall should automatically create:
   - `@` for root (/)
   - `@home` for /home
   - Additional subvolumes for /var/log, /var/cache/pacman/pkg

3. **If archinstall doesn't create all subvolumes automatically:**
   After basic installation, boot into the system and create manually:
```bash
   sudo btrfs subvolume create /var/log
   sudo btrfs subvolume create /var/cache/pacman/pkg
```
   Then update /etc/fstab with proper mount points.

## Expected fstab Content

Your `/etc/fstab` should look like this (UUIDs will differ):
```
# Root subvolume
UUID=<your-uuid>  /                      btrfs  rw,relatime,compress=zstd:3,ssd,discard=async,space_cache=v2,subvol=/@      0 0

# Home subvolume
UUID=<your-uuid>  /home                  btrfs  rw,relatime,compress=zstd:3,ssd,discard=async,space_cache=v2,subvol=/@home  0 0

# Pacman cache subvolume
UUID=<your-uuid>  /var/cache/pacman/pkg  btrfs  rw,relatime,compress=zstd:3,ssd,discard=async,space_cache=v2,subvol=/@pkg   0 0

# Log subvolume
UUID=<your-uuid>  /var/log               btrfs  rw,relatime,compress=zstd:3,ssd,discard=async,space_cache=v2,subvol=/@log   0 0

# Boot partition
UUID=<boot-uuid>  /boot                  vfat   rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=ascii,shortname=mixed,utf8,errors=remount-ro  0 2
```

## Snapper Configuration

After installation, snapper needs to be configured for automatic snapshots.

### Install Snapper
```bash
sudo pacman -S snapper
```

### Create Snapper Configs

**For root (/):**
```bash
sudo snapper -c root create-config /
```

**For home (/home):**
```bash
sudo snapper -c home create-config /home
```

### Configure Snapshot Retention

Both configs should have these settings (already set by create-config, but verify):
```
TIMELINE_CREATE=yes
TIMELINE_CLEANUP=yes
TIMELINE_LIMIT_HOURLY=10
TIMELINE_LIMIT_DAILY=10
TIMELINE_LIMIT_MONTHLY=10
TIMELINE_LIMIT_YEARLY=10
TIMELINE_LIMIT_WEEKLY=0
TIMELINE_LIMIT_QUARTERLY=0
NUMBER_LIMIT=50
NUMBER_LIMIT_IMPORTANT=10
```

**What this means:**
- Hourly snapshots: Keep last 10
- Daily snapshots: Keep last 10
- Monthly snapshots: Keep last 10
- Yearly snapshots: Keep last 10
- Total snapshot limit: 50 (with 10 important ones)

### Enable Snapper Timer
```bash
sudo systemctl enable --now snapper-timeline.timer
sudo systemctl enable --now snapper-cleanup.timer
```

### Verify Snapper is Working
```bash
# Check configs
sudo snapper list-configs

# Should show:
# Config | Subvolume
# root   | /
# home   | /home

# Check snapshots (may be empty initially)
sudo snapper -c root list
sudo snapper -c home list
```

## Verification Checklist

After installation and snapper setup:

- [ ] All btrfs subvolumes created (@, @home, @log, @pkg)
- [ ] /etc/fstab has all mount points with correct options
- [ ] Compression enabled (zstd:3)
- [ ] Snapper configs created for root and home
- [ ] Snapper timers enabled
- [ ] Test snapshot creation: `sudo snapper -c root create -d "Test"`
- [ ] Verify snapshot exists: `sudo snapper -c root list`

## Rollback Procedure (If Needed)

If you need to rollback to a snapshot:
```bash
# List snapshots
sudo snapper -c root list

# Boot from live USB
# Mount btrfs root
mount /dev/nvme1n1p2 /mnt

# List subvolumes
btrfs subvolume list /mnt

# Rename current @ to @.broken
mv /mnt/@ /mnt/@.broken

# Create new @ from snapshot (replace N with snapshot number)
btrfs subvolume snapshot /mnt/.snapshots/N/snapshot /mnt/@

# Reboot
```

## Notes

- Snapshots are stored in `/.snapshots/` (for root) and `/home/.snapshots/` (for home)
- Snapshots are read-only by default
- Hourly snapshots happen automatically via snapper-timeline.timer
- Old snapshots are cleaned up automatically via snapper-cleanup.timer
- @log and @pkg are NOT snapshotted (intentional - they change too frequently)
