#!/bin/sh

#usar doas ou sudo
echo "Do you want to use (doas) or (sudo)?"
read doas
echo "usando ${doas} ..."

#habilitar repos arch
echo "Do you want the script to enable Arch linux repos in pacman.conf?(yes/no)"
read repo
case $repo in
	[yes]* ) $doas pacman -S artix-archlinux-support && $doas pacman-key --populate archlinux &&
$doas echo "
[lib32]
Include = /etc/pacman.d/mirrorlist
[community]
Include = /etc/pacman.d/mirrorlist-arch" >> /etc/pacman.conf;;
	[no]* ) echo "ok, im not doing that" && sleep 2s;
esac

#criar pasta de wallpapers
mkdir ~/media/img/wall/

#install some packages
${doas} pacman -Syu --needed git xorg-server xorg-xrandr xorg-xinit libx11 libxinerama ttf-hack bspwm polybar doas ranger sxhkd vim zsh xwallpaper pipewire pipewire-pulse pipewire-media-session xclip scrot

#git clone other packages
git clone https://aur.archlinux.org/picom-ibhagwan-git.git /tmp/picom.git &
git clone https://aur.archlinux.org/libxft-bgra.git /tmp/libxf-bgra.git
cd /tmp/picom.git
makepkg -si --needed
cd /tmp/libxft-bgra.git 
makepkg -si --needed
#git clone the dot files
git clone https://github.com/vaderus/artix-configs ~/artix-configs
cp -r ~/artix-configs/.sources ~/.sources
cp -r ~/artix-configs/desktop/.config ~/.config
cp -r ~/artix-configs/desktop/.scripts ~/.scripts
cp -r ~/artix-configs/desktop/.themes ~/.themes
cp -r ~/artix-configs/desktop/wall ~/media/img/wall/
cp -r ~/artix-configs/desktop/.xinitrc ~/.xinitrc
mv ~/.config/.vimrc ~/.vimrc
mv ~/.config/.zshrc ~/.zshrc

${doas} make clean install -C ~/.sources/st
${doas} make clean install -C ~/.sources/dmenu

clear
echo "All done! do you want to start xorg now?'(yes/no)'"
read yn
case $yn in
	[yes]* ) startx;;
	[no]* ) exit;
esac
