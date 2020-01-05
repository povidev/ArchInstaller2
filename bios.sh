#!/bin/bash
timedatectl set-ntp true
parted -s /dev/sda mklabel msdos mkpart primary 2MiB 100% set 1 boot on
mkfs.ext4 /dev/sda1
mount /dev/sda1 /mnt
pacstrap /mnt base linux linux-firmware networkmanager sudo grub
genfstab -U /mnt >> /mnt/etc/fstab
cat << EOF > /mnt/configure.sh
ln -sf /usr/share/zoneinfo/Asia/Omsk /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "arch" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
systemctl enable NetworkManager
useradd -s /bin/bash -mG wheel user
passwd user
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
EOF
chmod 755 /mnt/configure.sh
arch-chroot /mnt /configure.sh
rm -rf /mnt/configure.sh
umount -R /mnt
reboot
