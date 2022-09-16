#!/bin/bash

# Fetch information about which distro is running.
# distro=$(cat /etc/os-release | grep -i ID= | grep -P -o '(?<==).*$' | head -1)
distro=$(grep -i ID= < /etc/os-release | grep -P -o '(?<==).*$' | head -1)

# Install packages required for a quick setup.
if [[ "$distro" =~ ^(arch|endeavouros)$ ]]; then
     sudo pacman -Syu --needed --noconfirm < packages/arch
else
    echo "Distro \"$distro\" not supported."
    exit
fi

# Deploy configuration files.
# This will replace any existing files.
chmod +x .config/bspwm/bspwmrc
chmod -R +x .config/polybar/scripts/
rsync -r .config/* "$HOME/.config/"
rsync .xinitrc "$HOME/"
rsync .bashrc "$HOME/"
rsync .bash_profile "$HOME/"
rsync .gtkrc-2.0 "$HOME/"

# Deploy scripts to /usr/local/bin/.
chmod -R +x scripts/
sudo rsync scripts/* /usr/local/bin/

# Deploy and start custom services.
sudo rsync services/* /etc/systemd/system/
sudo systemctl enable --now disable-acpi-wakeup.service

# Refresh sxhkd keybinds.
pkill -USR1 -x sxhkd

# Add user to the video group.
# This is required for brightness controls.
sudo usermod -aG video "$(whoami)"

# Deploy fonts.
mkdir -p "$HOME/.local/share/fonts"
rsync -r fonts/* "$HOME/.local/share/fonts/"
fc-cache -f

# Directory casing is annoying and takes longer to write out, so
# we rename all the default directorie. Default names were
# updated through $HOME/.config/user-dirs.dirs earlier.
for dir in "Desktop" "Documents" "Downloads" "Music" "Pictures" "Public" "Templates" "Videos"
do
    if [ -d "$HOME/$dir" ]; then
        mv "$HOME/$dir" "$HOME/$(echo "$dir" | tr '[:upper:]' '[:lower:]')"
    fi
done

# Install pyenv and pyenv-virtualenv for python version management.
if [ ! -d "$HOME/.pyenv" ]; then
     git clone https://github.com/pyenv/pyenv.git ~/.pyenv
     git clone https://github.com/pyenv/pyenv-virtualenv.git "$(pyenv root)/plugins/pyenv-virtualenv"
fi

# Install fzf for an amazing general-purpose fuzzy finger.
if [ ! -d "$HOME/.fzf" ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    yes | ~/.fzf/install
fi

# Install packer for neovim package management.
if [ ! -d "$HOME/.local/share/nvim/site/pack/packer" ]; then
    git clone --depth 1 https://github.com/wbthomason/packer.nvim \
    ~/.local/share/nvim/site/pack/packer/start/packer.nvim
fi
