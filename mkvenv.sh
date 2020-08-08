function mkvenv() {
  if [[ -z "$1" ]]; then
    echo "usage: mkvenv [--force] [--path VENV_PATH] [PYTHON_VERSION]"
    return 1
  fi
  
  local cyan='\033[0;36m'
  local red='\033[0;31m'
  local nocolor='\033[0m'
  local grey='\033[0;90m'

  local force=""
  local venvdir=".venv"
  local version=""
  if [[ -f .python-version ]]; then
    version="$(cat .python-version)"
  fi

  while [[ -n "$1" ]]; do case $1 in
    -p | --path )
      shift; venvdir=$1
      ;;
    -f | --force )
      force=1
      ;;
    *)
      version="$1"
      ;;
  esac; shift; done
  
  hash pyenv 2>/dev/null || { echo -e "${red}pyenv not found; try 'brew install pyenv'${nocolor}"; return 1; }
  hash virtualenv 2>/dev/null || { echo -e "${red}virtualenv not found; try 'pip install virtualenv'${nocolor}"; return 1; }
  hash direnv 2>/dev/null || { echo -e "${red}direnv not found; try 'brew install direnv'${nocolor}"; return 1; }

  if [[ -f .python-version ]]; then
    local existing="$(cat .python-version)"
    if [[ -z "$force" && "$existing" != "$version" ]]; then
      echo -e "${red}${version} does not match .python-version (${existing})${nocolor}"
      return 1
    fi
  fi
  pyenv local "$version" || return 1

  if [[ -d "$venvdir" ]]; then
    if [[ -z "$force" ]]; then
      echo -e "${red}${venvdir} already exists! use -f to overwrite it${nocolor}"
      return 1
    elif [[ -n "$venvdir" && "$venvdir" != "/" && "$venvdir" != "" ]]; then
      rm -r "$venvdir"
    fi
  fi

  printf "$grey"
  virtualenv --python "$(pyenv which python)" "$venvdir" || return 1
  printf "$nocolor"

  touch .envrc
  sed -i '' '/^source ".*bin\/activate"$/d' .envrc \
    && echo "source \"$venvdir/bin/activate\"" >> .envrc
  sed -i '' '/^unset PS1$/d' .envrc \
    && echo "unset PS1" >> .envrc

  direnv allow

  echo -e "${cyan}Created Python virtual environment in $(cd "$venvdir" 2> /dev/null ; pwd) ${nocolor}"
}

