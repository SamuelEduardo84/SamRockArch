#!/usr/bin/env bash

# Set keyboard layout to ABNT2
loadkeys br-abnt2

# Set NTP
timedatectl set-ntp true

# Partitioning

parted -a optimal -s /dev/sda mkpart primary fat32 0 500MiB set 1 boot on
mkfs.vfat -F 32 /dev/sda1
parted -a optimal -s /dev/sda mkpart primary swap 500MiB 16.5GiB set 2 swap on
mkswap -f /dev/sda2
parted -a optimal -s /dev/sda mkpart primary btrfs 16.5GiB 66.5GiB set 3 on
mkfs.btrfs /dev/sda3
parted -a optimal -s /dev/sda mkpart primary btrfs 66.5GiB 100% set 4 on
mkfs.btrfs /dev/sda4

# Mounting
mount /dev/sda3 /mnt
mkdir /mnt/{boot,home}
mount /dev/sda1 /mnt/boot
mount /dev/sda4 /mnt/home
swapon /dev/sda2

# Install base packages
pacstrap /mnt base linux linux-firmware vim git sudo  bash-completion zsh

# Generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Copy the scripts to new installation
mkdir /mnt/root/SamRockArch
cp -rv * /mnt/root/SamRockArch

# Change Root
arch-chroot /mnt