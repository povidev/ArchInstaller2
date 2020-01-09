#!/bin/bash
export DISK="sda"
export TIMEZONE="Asia/Omsk"
export ADDITIONALPKG="jenkins htop"
export ADDITIONALUNITS="jenkins sshd"
export ADDITIONALYAYPKG="lineageos-devel megatools"
export SYSTEMLOCALE="en_US"
export HOSTNAME="arch"
timedatectl set-ntp true
parted /dev/${DISK} mklabel msdos mkpart primary 2MiB 100% set 1 boot on
mkfs.ext4 /dev/${DISK}1
mount /dev/${DISK}1 /mnt
pacstrap /mnt base linux linux-firmware networkmanager sudo grub base-devel nano wget openssh ${ADDITIONALPKG}
genfstab -U /mnt >> /mnt/etc/fstab
cat << EOF > /mnt/configure.sh
ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime
hwclock --systohc
echo "${SYSTEMLOCALE}.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=${SYSTEMLOCALE}.UTF-8" >> /etc/locale.conf
echo "${HOSTNAME}" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
systemctl enable NetworkManager ${ADDITIONALUNITS}
useradd -mG wheel user
passwd user
cd /home/user
sudo -u user wget https://aur.archlinux.org/cgit/aur.git/snapshot/yay.tar.gz
sudo -u user tar -xzf yay.tar.gz
cd yay
sudo -u user makepkg -si
cd ..
rm -rf yay*
echo "[multilib]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
pacman -Syu lib32-gcc-libs
sudo -u user yay -Syu ${ADDITIONALYAYPKG}
grub-install /dev/${DISK}
grub-mkconfig -o /boot/grub/grub.cfg
EOF
chmod 755 /mnt/configure.sh
arch-chroot /mnt /configure.sh
rm -rf /mnt/configure.sh
umount -R /mnt
reboot
