#!/bin/sh
read -p "How do you want to provide root acess? (sudo/doas): " doas

read -p "Do you want me to git clone the dot files? (Y/n): " clone
case $clone in
	y)
		git clone https://github.com/vaderus/void-configs ~/void-configs;
		cp -r ~/void-configs/desktop/.config ~/.config;
		cp -r ~/void-configs/desktop/.scripts ~/.scripts;
		$doas cp -r ~/void-configs/desktop/.themes /usr/share/.themes;
		mkdir -p ~/media/img/
		cp -r ~/void-configs/desktop/wall ~/media/img/wall/;
		cp -r ~/void-configs/desktop/.xinitrc ~/.xinitrc;
		cp ~/.config/.vimrc ~/.vimrc;
		cp ~/.config/.zshrc ~/.zshrc;;
	n)
		echo "ok, im not doing that...";;
	*)
		git clone https://github.com/vaderus/void-configs ~/void-configs;
		cp -r ~/void-configs/.sources ~/.sources;
		cp -r ~/void-configs/desktop/.config ~/.config;
		cp -r ~/void-configs/desktop/.scripts ~/.scripts;
		$doas cp -r ~/void-configs/desktop/.themes /usr/share/.themes;
		mkdir -p ~/media/img/
		cp -r ~/void-configs/desktop/wall ~/media/img/wall/;
		cp -r ~/void-configs/desktop/.xinitrc ~/.xinitrc;
		cp ~/.config/.vimrc ~/.vimrc;
		cp ~/.config/.zshrc ~/.zshrc;;
esac	

read -p "Do you want me to install the desktop packages now? [xorg,bspwm,etc] (Y/n): " packages
case $packages in
	y)
		clear;
		echo "installing packages ...";
		sleep 3;
		$doas xbps-install -Syu git xorg-minimal xinit font-hack-ttf libXinerama-devel libX11-devel libXft-devel harfbuzz-devel bspwm sxhkd polybar vim base-devel xrandr setxkbmap xwallpaper xset zsh dbus elogind pipewire;;
	n)
		clear;
		echo "ok, im not going to install any packages";;
	*)
		clear;
		echo "installing packages ...";
		sleep 3;
		$doas xbps-install -Syu git xorg-minimal xinit font-hack-ttf libXinerama-devel libX11-devel libXft-devel harfbuzz-devel bspwm sxhkd polybar vim base-devel xrandr setxkbmap xwallpaper xset zsh dbus elogind pipewire;;
esac

read -p "do you want me to compile dmenu and st? (Y/n): " compile
case $compile in
	y)
		read -p "Where do you want me to clone it? (e.g /home/user/.sources): " sourcesdir;
		mkdir -p $sourcesdir
		git clone https://github.com/lukesmithxyz/st $sourcesdir/st;
		git clone https://git.suckless.org/dmenu $sourcesdir/dmenu;
		cp ~/void-configs/desktop/st-config.h $sourcesdir/st/config.h;
		cp ~/void-configs/desktop/dmenu-config.h $sourcesdir/dmenu/config.h;
		$doas make clean install -C $sourcesdir/st;
		$doas make clean install -C $sourcesdir/dmenu;;
	n)
		echo "ok, im not doing it";
		sleep 3;;
	*)	
		read -p "Where do you want me to clone it? (e.g ~/.sources) :" sourcesdir;
		mkdir -p $sourcesdir
		git clone https://github.com/lukesmithxyz/st $sourcesdir/st;
		git clone https://git.suckless.org/dmenu $sourcesdir/dmenu;
		cp ~/void-configs/desktop/st-config.h $sourcesdir/st/config.h;
		cp ~/void-configs/desktop/dmenu-config.h $sourcesdir/dmenu/config.h;
		$doas make clean install -C $sourcesdir/st;
		$doas make clean install -C $sourcesdir/dmenu;;
esac

read -p "do you want me to start elogind and dbus? [runit] (Y/n)" services
case $services in
	y)
		$doas ln -s /etc/sv/elogind /var/service/;
		$doas sv up elogind;
		$doas ln -s /etc/sv/dbus /var/service/;
		$doas sv up dbus;;
	n)
		echo "ok im not doing it";
		sleep 3;;
	*)
		$doas ln -s /etc/sv/elogind /var/service/;
		$doas sv up elogind;
		$doas ln -s /etc/sv/dbus /var/service/;
		$doas sv up dbus;;
esac

read -p "do you want to change your shell to zsh? (Y/n): " zsh
case $zsh in
	y)
		chsh -s /bin/zsh;;
	n)
		echo "ok im not chaging the shell";;
esac

read -p "everythig is done, do you want to start xorg now? (Y/n): " xorg
case $xorg in
	y)
		cd;
		startx;;
	n)
		echo "ok im no doing it";;
	*)
		cd;
		startx;;	
esac
