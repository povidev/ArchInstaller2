# ArchInstaller2  
ArchInstaller but better

New features:  
More automated installation  
Yay AUR helper installation  
BIOS support

# WARNING
This installer will erase your existing partitions without prompting you about this.

## Installation  
1. pacman -Sy git  
2. git clone https://github.com/myst33d/ArchInstaller2  
3. cd ArchInstaller2  
4. chmod 755 *
5. ./efi.sh(or if you have BIOS - ./bios.sh)  
You will be prompted several times during the installation

## How to customize ArchInstaller2 scripts  
1. Fork this repo  
2. Edit scripts  
For example, you can format / partition with btrfs, you can change the internal HDD to external HDD or any other device - change /dev/sda to /dev/sdb(or sdc, sdd and so on), or you can make a dual-boot installer, or simply just change your timezone.
