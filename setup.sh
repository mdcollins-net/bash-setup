#!/bin/bash

banner="
___  ____ ____ _  _        ____ ____ ___ _  _ ___
|__] |__| [__  |__|   __   [__  |___  |  |  | |__]
|__] |  | ___] |  |        ___] |___  |  |__| |

"
bold=$(tput bold)
normal=$(tput sgr0)

packages="curl dos2unix fasd linuxbrew-wrapper python3.8 golang-go"
node_packages="@aweary/alder git-commander fkill-cli"
python_packages="speedtest-cli"


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
  echo -e "\n${bold}Installing node.js ... ${normal}\n"
  curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
  sudo apt-get install -y nodejs

  echo -e "\nInstalling ${bold}yarn${normal} ... \n"
  curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
  sudo apt-get update && sudo apt-get install yarn

  echo -e "\nInstalling / Updating ${bold}npm${normal} ... \n"
  npm install -g npm

  echo -e "\n${bold}Finished installing node.js ... ${normal}\n"
}

install_node_package () {
  echo -e "\nInstalling Node.js package: ${bold}${1}${normal} ... \n"
  sudo npm install -g "${1}"
}

install_node_packages () {
  echo -e "\n${bold}Installing Node.js packages ... ${normal}\n"
  for p in ${node_packages}; do
    install_node_package "${p}"
  done
  echo -e "\n${bold}Finished Node.js installing packages. ${normal}\n"
}

install_python_package () {
  echo -e "\nInstalling Python package: ${bold}${1}${normal} ... \n"
  python -m pip install "${1}"
}

install_python_packages () {
  echo -e "\n${bold}Installing Python packages ... ${normal}\n"
  for p in ${python_packages}; do
    install_python_package "${p}"
  done
  echo -e "\n${bold}Finished Python installing packages. ${normal}\n"
}


print_banner
install_packages
install_node
install_node_packages
install_python_packages





