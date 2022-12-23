#!/usr/bin/env bash

function display_logo() {
  printf "\033c"
  cat << END
             /////////////
         /////////////////////
      ///////*767////////////////
    //////7676767676*//////////////
   /////76767//7676767//////////////
  /////767676///*76767///////////////
 ///////767676///76767.///7676*///////
/////////767676//76767///767676////////
//////////76767676767////76767/////////
///////////76767676//////7676//////////
////////////,7676,///////767///////////
/////////////*7676///////76////////////
///////////////7676////////////////////
 ///////////////7676///767////////////
  //////////////////////'////////////
   //////.7676767676767676767,//////
    /////767676767676767676767/////
      ///////////////////////////
         /////////////////////
             /////////////

END
  sleep 1
}

function display_help() {
  echo -e "\nUSAGE:\n"
  echo -e "\tcurl -s https://raw.githubusercontent.com/chris-m-powell/ansible/master/deploy.sh | sudo bash -s -- [<options>]"
  echo -e "\nOPTIONS:\n"
  echo -e "\t-u               \tName of local user"
  echo -e "\t-k               \tComma-delimited list of tags (defaults to 'all')"
  echo -e "\t-h               \tDisplays usage options"
  echo -e "\nSUPPORTED TAGS:\n"
  echo -e "\tall              \tApply all custom configurations"
  echo -e "\talacritty        \tFast, cross-platform, OpenGL terminal emulator"
  echo -e "\tbitwarden_cli    \tFull-featured CLI to access and manage Bitwarden vault"
  echo -e "\tbpytop           \tSystem activity monitoring tool"
  echo -e "\tdircolors        \tColor setup for ls"
  echo -e "\tgtk              \tApply GTK preferences"
  echo -e "\thimalaya         \tCLI for email management"
  echo -e "\tmpd              \tAudio playback daemon with client-server architecture"
  echo -e "\tncmpcpp          \tNcurses client for MPD"
  echo -e "\tneofetch         \tFast, highly customizable system info script"
  echo -e "\tneovim           \tRefactor of Vim, focused on extensibility and usability"
  echo -e "\tprotonvpn-bridge \tClient to seamlessly decrypt/encrypt incoming/outgoing ProtonMail"
  echo -e "\tprotonvpn-cli    \tOfficial Proton VPN CLI"
  echo -e "\tqutebrowser      \tKeyboard-driven, vim-like browser based on PyQt5"
  echo -e "\tranger           \tTerminal-based, visual file manager inspired by Vim"
  echo -e "\tsignal-desktop   \tPrivate messaging from your desktop"
  echo -e "\tzathura          \tLightweight document viewer"
  exit 1
}

function detect_os() {
  declare -g OS_ID
  OS_ID=$(awk -F '=' '$1=="ID" { print $2 }' /etc/os-release | tr -d '"')
  readonly OS_ID
  if [[ "${OS_ID}" =~ ^(pop)$ ]]
  then
    display_logo
    return 0
  else
    return 1
  fi
}

function os_check() {
  alert -t info -m "checking system compatibility..."
  if ! detect_os; then
    alert -t failure -m "the host operating system is not supported, exiting."
    exit
  fi
  alert -t info -m "the host operating system, ${OS_ID^}, is compatible."
}

function detect_missing_deb_pkg() {
  if [[ $(dpkg-query -W -f='${Status}' "$1" 2>/dev/null | grep -o "ok installed" | wc -l) -eq 0 ]]
  then
    return 0
  else
    return 1
  fi
}

function detect_missing_deb_pkgs() {
  local a b
  a=("$@")
  for i in "${a[@]}"; do
    if detect_missing_deb_pkg "$i"; then b+=("$i"); fi;
  done
  echo "${b[*]}"
}

function install_dependencies() {
  declare -a DEB_DEPENDENCIES=( "podman" )
  alert -t info -m "checking for missing dependencies..."
  missing_deb_pkgs=$(detect_missing_deb_pkgs "${DEB_DEPENDENCIES[@]}")
  if [[ "${missing_deb_pkgs}" ]]; then
    alert -t warning -m "missing dependencies detected."
    alert -t info -m "attempting to install ${missing_deb_pkgs} ..."
    install_missing_pkgs apt "${missing_deb_pkgs[@]}"
  fi
}

function install_missing_pkgs() {
  local cmd
  sed -i "/#\$nrconf{restart} = 'i';/s/.*/\$nrconf{restart} = 'a';/" /etc/needrestart/needrestart.conf
  apt update
  cmd="apt install -y ${missing_deb_pkgs}"
  echo ""
  if ! ${cmd}; then
    alert -t failure -m "unable to install missing dependencies, exiting now."
    exit
  fi
  alert -t info -m "missing dependencies have been installed."
}

function priv_check() {
  if [[ "${EUID}" -ne 0 ]]; then
    alert -t failure -m "this script must be run with root privileges, exiting now."
    exit
  fi
}

function deploy() {
  podman pull ghcr.io/chris-m-powell/ansible-controller:latest
  podman run -it ansible-controller:latest
}

function parse_opts() {
  declare -g LOCAL_USER TAGS
  while getopts "u:t:" opt; do
    case ${opt} in
      u) LOCAL_USER=${OPTARG} ;;
      t) TAGS=${OPTARG} ;;
      *) display_help ;;
    esac
  done
  [[ "${LOCAL_USER}" ]] || LOCAL_USER="${SUDO_USER}"
}

function msg() {
  local OPTIND color emphasis message format reset
  reset='\e[0m'
  declare -Ar col=(
                    ['red']='31'
                    ['green']='32'
                    ['yellow']='33'
                    ['purple']='35'
                    ['cyan']='36'
                  )
  declare -Ar emph=(
                     ['bold']='1'
                     ['underline']='4'
                     ['blink']='5'
                   )
  while getopts "c:e:m:" opt; do
    case ${opt} in
      c) color=${col[${OPTARG}]} ;;
      e) emphasis=${emph[${OPTARG}]} ;;
      m) message=${OPTARG} ;;
      *) exit ;;
    esac
  done
  if [[ "${emphasis}" ]]; then
    format='\e['${color}';'${emphasis}'m'
  else
    format='\e['${color}'m'
  fi
  [[ "${message}" ]] && printf "%b%b%b\n" "${format}" "${message}" "${reset}"
}

function alert() {
  local alert message OPTIND
  while getopts "t:m:" opt; do
    case ${opt} in
      t)
        case "${OPTARG}" in
          success) alert=$(msg -m "${OPTARG^^}" -c green -e blink) ;;
          failure) alert=$(msg -m "${OPTARG^^}" -c red -e blink) ;;
          warning) alert=$(msg -m "${OPTARG^^}" -c yellow) ;;
          info) alert=$(msg -m "${OPTARG^^}" -c cyan) ;;
          *) exit 1 ;;
        esac
        ;;
      m) message=${OPTARG} ;;
      *) exit ;;
    esac
  done
  sleep 1
  printf "[%b]: %b\n" "${alert}" "${message}"
}

function main() {
  priv_check
  parse_opts "${@}"
  os_check
  install_dependencies
  deploy
}

main "${@}"
