#!/bin/bash
timedatectl set-ntp true
parted -s /dev/sda mklabel msdos mkpart primary 2MiB 100% set 1 boot on
mkfs.ext4 /dev/sda1
mount /dev/sda1 /mnt
pacstrap /mnt base linux linux-firmware networkmanager sudo grub base-devel nano wget openssh
genfstab -U /mnt >> /mnt/etc/fstab
cat << EOF > /mnt/configure.sh
ln -sf /usr/share/zoneinfo/Asia/Omsk /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "arch" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
systemctl enable NetworkManager
systemctl enable sshd
useradd -s /bin/bash -mG wheel user
passwd user
wget https://aur.archlinux.org/cgit/aur.git/snapshot/yay.tar.gz
tar -xzf yay.tar.gz
cd yay
su -c "makepkg -si" user
cd ..
rm -rf yay
echo "[multilib]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
pacman -Syu lib32-gcc-libs
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
EOF
chmod 755 /mnt/configure.sh
arch-chroot /mnt /configure.sh
rm -rf /mnt/configure.sh
umount -R /mnt
reboot
