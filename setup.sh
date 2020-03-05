#!/bin/bash

#
# To run from remote:
#
# wget -q http://bit.ly/mcbashsetup -O -
#


banner="
___  ____ ____ _  _        ____ ____ ___ _  _ ___
|__] |__| [__  |__|   __   [__  |___  |  |  | |__]
|__] |  | ___] |  |        ___] |___  |  |__| |

"
bold=$(tput bold)
normal=$(tput sgr0)

packages="curl dos2unix fasd linuxbrew-wrapper python3.8 golang-go"
python_packages="speedtest-cli"
go_packages="github.com/justjanne/powerline-go"
node_packages="@aweary/alder git-commander fkill-cli"
rust_packages="exa tre"

print_banner () {
  echo -e "${bold}${banner}${normal}"
}

install_package () {
  echo -e "\nInstalling package: ${bold}${1}${normal} ... \n"
  sudo apt install -y "${1}"
}

install_packages () {
  echo -e "\n${bold}Updating Package Management System ... ${normal}\n"
  sudo apt update;
  echo -e "\n${bold}Installing packages ... \n"
  for p in ${packages}; do
    install_package "${p}"
  done
  echo -e "\n${bold}Finished installing packages. ${normal}\n"
}

install_node () {
  echo -e "\n${bold}Installing Node.js ... ${normal}\n"
  curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
  sudo apt-get install -y nodejs

  echo -e "\nInstalling ${bold}yarn${normal} ... \n"
  curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
  sudo apt-get update && sudo apt-get install yarn

  echo -e "\nInstalling / Updating ${bold}npm${normal} ... \n"
  sudo -H npm install -g npm

  echo -e "\n${bold}Finished installing Node.js ... ${normal}\n"
}

install_node_package () {
  echo -e "\nInstalling Node.js package: ${bold}${1}${normal} ... \n"
  sudo npm install -g "${1}"
}

install_node_packages () {
  echo -e "\n${bold}Installing Node packages ... ${normal}\n"
  for p in ${node_packages}; do
    install_node_package "${p}"
  done
  echo -e "\n${bold}Finished installing Node packages. ${normal}\n"
}

install_python_package () {
  echo -e "\nInstalling Python package: ${bold}${1}${normal} ... \n"
  sudo -H python -m pip install "${1}"
}

install_python_packages () {
  echo -e "\n${bold}Installing Python packages ... ${normal}\n"
  echo -e "\nInstalling / Updating ${bold}pip${normal} ... \n"
  sudo -H python -m pip install -U pip
  for p in ${python_packages}; do
    install_python_package "${p}"
  done
  echo -e "\n${bold}Finished installing Python packages. ${normal}\n"
}

install_go_package () {
  echo -e "\nInstalling Go package: ${bold}${1}${normal} ... \n"
  go get -u -v  "${1}"
}

install_go_packages () {
  echo -e "\n${bold}Installing Go packages ... ${normal}\n"
  for p in ${go_packages}; do
    install_go_package "${p}"
  done
  echo -e "\n${bold}Finished installing Go packages. ${normal}\n"
}


install_rust () {
  echo -e "\n${bold}Installing Rust ... ${normal}\n"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y
  source "~"/.cargo/env
  echo -e "\n${bold}Finished installing Rust ... ${normal}\n"
}

install_rust_package () {
  echo -e "\nInstalling Rust package: ${bold}${1}${normal} ... \n"
  cargo install "${p}"
}

install_rust_packages () {
  echo -e "\n${bold}Installing Rust packages ... ${normal}\n"
  for p in ${rust_packages}; do
    install_rust_package "${p}"
  done
  echo -e "\n${bold}Finished installing Rust packages. ${normal}\n"
}

create_directories () {
  cd ${HOME}
  mkdir -p backup/{ssh,profile}
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





