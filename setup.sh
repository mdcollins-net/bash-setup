#!/bin/bash

#
#  To run from remote:
#
#  wget -O - http://bit.ly/mcbashsetup | bash
#
#  VIM Zenburn theme : http://bit.ly/mcbashvimzenburn
#


banner="
    ___  ____ ____ _  _        ____ ____ ___ _  _ ___
    |__] |__| [__  |__|   __   [__  |___  |  |  | |__]
    |__] |  | ___] |  |        ___] |___  |  |__| |

"

#
#  Variables used throught script: colors, datetime stamp etc.
#

BOLD=$(tput bold)
NORMAL=$(tput sgr0)
DTSTAMP=$(date +"%Y_%m_%d-%H_%M_%S")

TEMP_DIR=${HOME}/temp

URL_NODE_SETUP="https://deb.nodesource.com/setup_10.x"
URL_YARN_PUB_KEY="https://dl.yarnpkg.com/debian/pubkey.gpg"
URL_YARN_PKG="https://dl.yarnpkg.com/debian/"

URL_RUST_SETUP="https://sh.rustup.rs"

URL_VIM_THEME_ZENBURN="http://bit.ly/mcbashvimzenburn"
URL_VIM_PLUGIN_PLUG="http://bit.ly/mcbashvimplug"
URL_VIM_VIMRC="http://bit.ly/mcbashvimrc"

URL_PROFILE="http://bit.ly/mcbashprofile"

URL_ZSHRC="http://bit.ly/mcbashzshrc"
URL_ZPROFILE="http://bit.ly/mcbashzprofile"

#
#  Set lists of packages to install
#

# linux packages
packages="wget curl vim dos2unix ctags mc git autojump keychain exa"
packages="${packages} fasd fonts-powerline"
packages="${packages} linuxbrew-wrapper"
packages="${packages} python3.8 python3-pip golang-go oracle-java13-installer oracle-java13-set-default"

# Python packages
python_packages="powerline-shell speedtest-cli"

# Go lang packages
go_packages="github.com/justjanne/powerline-go"

# Node.js packages
node_packages="@aweary/alder git-commander fkill-cli"

# Rust packages
rust_packages="exa tre"

print_banner () {
  echo -e "${BOLD}${banner}${NORMAL}"
}

update_package_repos () {
  echo -e "\n${BOLD}Updating Package Repositories ... ${NORMAL}\n"

  sudo add-apt-repository -y ppa:linuxuprising/java
  sudo apt-get update
  echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
  echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections

  echo -e "\n${BOLD}Finished updating repositories ... ${NORMAL}\n"
}

install_package () {
  echo -e "\nInstalling package: ${BOLD}${1}${NORMAL} ... \n"
  sudo apt-get install -y "${1}"
}

install_packages () {

  echo -e "\n${BOLD}Installing packages ... \n"
  for p in ${packages}; do
    install_package "${p}"
  done
  echo -e "\n${BOLD}Finished installing packages. ${NORMAL}\n"
}

install_node () {
  echo -e "\n${BOLD}Installing Node.js ... ${NORMAL}\n"
  curl -sL "${URL_NODE_SETUP}" | sudo -E bash -
  sudo apt-get install -y nodejs

  echo -e "\nInstalling ${bold}yarn${normal} ... \n"
  curl -sL "${URL_YARN_PUB_KEY}" | sudo apt-key add -
  echo "deb ${URL_YARN_PKG} stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
  sudo apt-get install -y yarn

  echo -e "\nInstalling / Updating ${BOLD}npm${NORMAL} ... \n"
  sudo -H npm install -g npm

  echo -e "\n${BOLD}Finished installing Node.js. ${NORMAL}\n"
}

install_node_package () {
  echo -e "\nInstalling Node.js package: ${BOLD}${1}${NORMAL} ... \n"
  sudo npm install -g "${1}"
}

install_node_packages () {
  echo -e "\n${BOLD}Installing Node packages ... ${NORMAL}\n"
  for p in ${node_packages}; do
    install_node_package "${p}"
  done
  echo -e "\n${BOLD}Finished installing Node packages. ${NORMAL}\n"
}

install_python_package () {
  echo -e "\nInstalling Python package: ${BOLD}${1}${normal} ... \n"
  sudo -H pip3 install "${1}"
}

install_python_packages () {
  echo -e "\n${BOLD}Installing Python packages ... ${NORMAL}\n"  
  for p in ${python_packages}; do
    install_python_package "${p}"
  done
  echo -e "\n${bold}Finished installing Python packages. ${NORMAL}\n"
}

install_go_package () {
  echo -e "\nInstalling Go package: ${BOLD}${1}${NORMAL} ... \n"
  go get -u -v  "${1}"
}

install_go_packages () {
  echo -e "\n${BOLD}Installing Go packages ... ${NORMAL}\n"
  for p in ${go_packages}; do
    install_go_package "${p}"
  done
  echo -e "\n${BOLD}Finished installing Go packages. ${NORMAL}\n"
}

install_rust () {
  echo -e "\n${BOLD}Installing Rust ... ${NORMAL}\n"
  curl --proto '=https' --tlsv1.2 -sSf ${URL_RUST_SETUP} | bash -s -- -y
  source "~"/.cargo/env
  echo -e "\n${bold}Finished installing Rust. ${NORMAL}\n"
}

install_rust_package () {
  echo -e "\nInstalling Rust package: ${BOLD}${1}${NORMAL} ... \n"
  cargo install "${p}"
}

install_rust_packages () {
  echo -e "\n${BOLD}Installing Rust packages ... ${NORMAL}\n"
  for p in ${rust_packages}; do
    install_rust_package "${p}"
  done
  echo -e "\n${BOLD}Finished installing Rust packages. ${NORMAL}\n"
}

create_directories () {
  mkdir -p "${HOME}/temp"
  mkdir -p "${HOME}/bin"
  mkdir -p "${HOME}/sbin"
  mkdir -p "${HOME}/etc"
  mkdir -p "${HOME}/java"
  mkdir -p "${HOME}/backup/{ssh,profile}"
  mkdir -p "${HOME}/repos"
  mkdir -p "${HOME}/projects/{personal,work}"
  mkdir -p "${HOME}/projects/personal/{java,linux,node,python,uml}"
  sudo mkdir -p /opt/java
}

make_backups () {
  files=".bashrc .gitconfig .profile .viminfo .vimrc .zshrc .zprofile"
  for f in ${files}; do
    source=${f}
    if [ -f "$source" ]; then
      # Remove first character ('.') of file name for target backup copy
      cp -a "${HOME}/${source}" "${HOME}/backup/profile/${source:1}-${DTSTAMP}"
    fi
  done
}

vim_setup_color_themes () {
  echo -e "Downloading VIM themes ... \n"
  # VIM Theme : Zenburn
  wget -O "${HOME}/.vim/colors/zenburn.vim" ${URL_VIM_THEME_ZENBURN}
  dos2unix "${HOME}/.vim/colors/zenburn.vim"
  echo -e "Finished downloading VIM themes.\n"
}

vim_setup_plugins () {
  echo -e "Downloading VIM plugins ... \n"
  # VIM Plugin : Plug
  wget -O "${HOME}/.vim/autoload/plug.vim" ${URL_VIM_PLUGIN_PLUG}
  dos2unix "${HOME}/.vim/autoload/plug.vim"
  echo -e "Finished downloading VIM plugins.\n"
}

vim_setup () {
  echo -e "\n${BOLD}Setting up VIM ... ${NORMAL}\n"

  if [ -f "${HOME}/.vimrc" ]; then
    rm "${HOME}/.vimrc"
  fi

  rm -rf "${HOME}/.vim"

  mkdir -p "${HOME}/.vim/colors"
  mkdir -p "${HOME}/.vim/pack/vendor/start"
  mkdir -p "${HOME}/.vim/autoload"
  mkdir -p "${HOME}/.vim/plugged"

  vim_setup_color_themes
  vim_setup_plugins

  echo -e "Downloading vimrc ... \n"
  wget -O "${TEMP_DIR}/vimrc" ${URL_VIM_VIMRC}
  dos2unix "${TEMP_DIR}/vimrc"
  cp "${TEMP_DIR}/vimrc" "${HOME}/.vimrc"

  echo -e "\n${BOLD}Finished setting up VIM.${NORMAL}\n"
}

profile_setup () {
  echo -e "\n${BOLD}Setting up BASH profile ... ${NORMAL}\n"

  wget -O "${TEMP_DIR}/profile" ${URL_PROFILE}
  dos2unix "${TEMP_DIR}/profile"
  cp "${TEMP_DIR}/profile" "${HOME}/.profile"

  echo -e "\n${BOLD}Finished setting up BASH profile.${NORMAL}\n"
}

zsh_setup () {

  echo -e "Installing ZSH ... \n"
  sudo apt install -y zsh

  echo -e "Installing Oh My ZSH ... \n"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

  echo -e "Installing ZSH plugin: zsh-syntax-highlighting ... \n"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

  echo -e "Installing ZSH plugin: zsh-autosuggestions ... \n"
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

  echo -e "Installing ZSH plugin: zsh-autosuggestions ... \n"
  git clone https://github.com/supercrabtree/k ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/k

  echo -e "Downloading zshrc ... \n"
  wget -O "${TEMP_DIR}/zshrc" ${URL_ZSHRC}
  dos2unix "${TEMP_DIR}/zshrc"
  cp "${TEMP_DIR}/zshrc" "${HOME}/.zshrc"

  echo -e "Downloading zprofile ... \n"
  wget -O "${TEMP_DIR}/zprofile" ${URL_ZPROFILE}
  dos2unix "${TEMP_DIR}/zprofile"
  cp "${TEMP_DIR}/zprofile" "${HOME}/.zprofile"

}

print_banner

install_packages
install_python_packages
install_go_packages

install_node
install_node_packages

install_rust
install_rust_packages

create_directories
make_backups
vim_setup
profile_setup
zsh_setup

