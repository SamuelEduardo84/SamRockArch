#!/usr/bin/env bash

# Asking username and hostname
read -p "Set your username: " USERNAME
read -p "Set your Full Name: " FULLNAME
read -p "Set your Password: " PASSWORD
read -p "Set the machine hostname: " HOSTNAME

# Set keyboard layout to ABNT2
loadkeys br-abnt2

# Setting time zone and hardware clock
ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
hwclock --systohc

# Setting system language and locale
sed -i '177s/.//' /etc/locale.gen
locale-gen

cat << EOF > /etc/locale.conf
LANG=en_US.UTF-8
EOF

cat << EOF > /etc/vconsole.conf
KEYMAP=br-abnt2
EOF

# Network basic config
cat << EOF > /etc/hostname
$HOSTNAME
EOF

cat << EOF > /etc/hosts
127.0.0.1       localhost
127.0.1.1       $HOSTNAME
EOF

# Creating user
useradd -m -s "/bin/bash" -u 1000 -U -G "wheel" -C "$FULLNAME" $USERNAME
echo "$PASSWORD" | passwd "$USERNAME" --stdin
sed -i 's/#%wheel/%wheel/' /etc/sudoers