#!/bin/sh

# pergunta se quer user doas ou sudo
read -p "How do you want to provide root acess? (sudo/doas): " doas
clear

#pergunta se quer clonar os dot files
read -p "Do you want me to git clone the dot files? (Y/n): " clone
case $clone in
	y) #caso a resposta for sim faça isso:
		git clone https://github.com/vaderus/void-configs ~/void-configs; #clona void-configs
		cp -r ~/void-configs/desktop/.config ~/.config; #move o .config
		cp -r ~/void-configs/desktop/.scripts ~/.scripts; #move o .scripts
		$doas cp -r ~/void-configs/desktop/.themes /usr/share/.themes; #move o .themes
		mkdir -p ~/media/img/ #cria a pasta de wallpaper
		cp -r ~/void-configs/desktop/wall ~/media/img/wall/; #move a pasta de wallpaper
		cp -r ~/void-configs/desktop/.xinitrc ~/.xinitrc; #move o .xinitrc
		cp ~/.config/.vimrc ~/.vimrc; #move o vimrc
		cp ~/.config/.zshrc ~/.zshrc; #move o zshrc
		clear;;
	n) #se a resposta for não echo isso:
		echo "ok, im not doing that...";
		clear;;
	*) #se a resposta for outra coisa faça o mesmo que sim
		git clone https://github.com/vaderus/void-configs ~/void-configs;
		cp -r ~/void-configs/.sources ~/.sources;
		cp -r ~/void-configs/desktop/.config ~/.config;
		cp -r ~/void-configs/desktop/.scripts ~/.scripts;
		$doas cp -r ~/void-configs/desktop/.themes /usr/share/.themes;
		mkdir -p ~/media/img/
		cp -r ~/void-configs/desktop/wall ~/media/img/wall/;
		cp -r ~/void-configs/desktop/.xinitrc ~/.xinitrc;
		cp ~/.config/.vimrc ~/.vimrc;
		cp ~/.config/.zshrc ~/.zshrc;
		clear;;
esac	

read -p "Do you want me to install the desktop packages now? [xorg,bspwm,etc] (Y/n): " packages #pergunta se quer instalar o desktop
case $packages in
	y) #se sim instale isso:
		echo "installing packages ...";
		sleep 3;
		$doas xbps-install -Syu git xorg-minimal xinit font-hack-ttf libXinerama-devel libX11-devel libXft-devel harfbuzz-devel bspwm sxhkd polybar vim base-devel xrandr setxkbmap xwallpaper xset zsh dbus elogind pipewire;
		clear
	n) #se não echo isso:
		echo "ok, im not going to install any packages";
		sleep 3;
		clear;;
	*) #se responder outra coisa faça o mesmo que sim
		echo "installing packages ...";
		sleep 3;
		$doas xbps-install -Syu git xorg-minimal xinit font-hack-ttf libXinerama-devel libX11-devel libXft-devel harfbuzz-devel bspwm sxhkd polybar vim base-devel xrandr setxkbmap xwallpaper xset zsh dbus elogind pipewire;
		clear;;
esac

read -p "do you want me to compile dmenu and st? (Y/n): " compile #pergunta se quer instalar dmenu e st
case $compile in
	y) #se sim faz iso:
		read -p "Where do you want me to clone it? (e.g /home/user/.sources): " sourcesdir; #pergunta onde clonar as sources
		mkdir -p $sourcesdir #cria a pasta de sources
		git clone https://github.com/lukesmithxyz/st $sourcesdir/st; #clone o st do luke
		git clone https://git.suckless.org/dmenu $sourcesdir/dmenu; #clona o dmenu do sucklesss
		cp ~/void-configs/desktop/st-config.h $sourcesdir/st/config.h; #move o config.h para st
		cp ~/void-configs/desktop/dmenu-config.h $sourcesdir/dmenu/config.h; #move o config.h para dmenu
		$doas make clean install -C $sourcesdir/st; #instala sst
		$doas make clean install -C $sourcesdir/dmenu; #instala dmenu
		clear;;
	n) #se não echo isso:
		echo "ok, im not doing it";
		sleep 3;
		clear;;
	*) #se responder outra coisa faça o mesmo que sim	
		read -p "Where do you want me to clone it? (e.g /home/user/.sources): " sourcesdir; #pergunta onde clonar as sources
		mkdir -p $sourcesdir #cria a pasta de sources
		git clone https://github.com/lukesmithxyz/st $sourcesdir/st; #clone o st do luke
		git clone https://git.suckless.org/dmenu $sourcesdir/dmenu; #clona o dmenu do sucklesss
		cp ~/void-configs/desktop/st-config.h $sourcesdir/st/config.h; #move o config.h para st
		cp ~/void-configs/desktop/dmenu-config.h $sourcesdir/dmenu/config.h; #move o config.h para dmenu
		$doas make clean install -C $sourcesdir/st; #instala sst
		$doas make clean install -C $sourcesdir/dmenu; #instala dmenu
		clear;;
esac

read -p "do you want me to start elogind and dbus? [runit] (Y/n)" services #pergunta se que iniciar o dbus e elogind (para pipewire)
case $services in
	y) #se sim faça:
		if [ -e "/var/service/elogind" ] #se o link já existe apenas inicie o service
		then
			doas sv up elogind;
		else #se não existe, cria o link e inicia o service
			doas ln -s /etc/sv/elogind /var/service/;
			doas sv up elogind;
		fi

		if [ -e "/var/service/dbus" ] #se o link já existe apenas inicie o service
		then
			doas sv up dbus;
		else #se não existe, cria o link e inicia o service
			doas ln -s /etc/sv/dbus /var/service/;
			doas sv up dbus;
		fi;;
	n) #se não echo isso:
		echo "ok im not doing it";
		sleep 3;;
	*) #se responder outra coisa faça o mesmo que sim
		if [ -e "/var/service/elogind" ]
		then
			doas sv up elogind;
		else
			doas ln -s /etc/sv/elogind /var/service/;
			doas sv up elogind;
		fi
		if [ -e "/var/service/dbus" ]
		then
			doas sv up dbus;
		else
			doas ln -s /etc/sv/dbus /var/service/;
			doas sv up dbus;
		fi;;
esac

#muda o shell
clear
read -p "do you want to change your shell to zsh? (Y/n): " zsh
case $zsh in
	y)
		chsh -s /bin/zsh;;
	n)
		echo "ok im not chaging the shell";;
esac

#pergunta se quer iniciar o xorg
clear
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
