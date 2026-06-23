function mkvenv() {
  local cyan='\033[0;36m'
  local red='\033[0;31m'
  local nocolor='\033[0m'
  local grey='\033[0;90m'

  if [[ -z "$1" || "$1" == "--help" || "$1" == "-h" ]]; then
    echo -e "${cyan}mkvenv: Conveniently setup & use Python virtual environments${nocolor}"
    echo -e ""
    echo -e "Usage: mkvenv PYTHON_VERSION [--app|--lib] [--force] [--path VENV_PATH]"
    echo -e ""
    echo -e "  --app       passed to 'uv init' to create a packaged application (uv's default)"
    echo -e "  --lib       passed to 'uv init' to create a library"
    echo -e "  --force     (re)build even if the virtual environment already exists"
    echo -e "  --path      choose a different path for the virtual environment (default: .venv)"
    echo -e ""
    echo -e "Available Python versions:"
    uv python list
    return 1
  fi

  local force=""
  local venvdir=".venv"
  local version=""
  local init_kind=""

  while [[ -n "$1" ]]; do case $1 in
    -p | --path )
      shift; venvdir=$1
      ;;
    -f | --force )
      force=1
      ;;
    --app | --lib )
      init_kind="$1"
      ;;
    *)
      version="$1"
      ;;
  esac; shift; done

  hash uv 2>/dev/null || { echo -e "${red}uv not found; try 'brew install uv'${nocolor}"; return 1; }
  hash direnv 2>/dev/null || { echo -e "${red}direnv not found; try 'brew install direnv'${nocolor}"; return 1; }

  if [[ -d "$venvdir" ]]; then
    if [[ -z "$force" ]]; then
      echo -e "${red}${venvdir} already exists! use -f to overwrite it${nocolor}"
      return 1
    elif [[ -n "$venvdir" && "$venvdir" != "/" && "$venvdir" != "" ]]; then
      rm -r "$venvdir"
    fi
  fi

  printf "$grey"
  if [[ ! -f pyproject.toml ]]; then
    uv init --python "$version" $init_kind || { printf "$nocolor"; return 1; }
  fi
  uv venv --python "$version" "$venvdir" || { printf "$nocolor"; return 1; }
  printf "$nocolor"

  touch .env

  touch .envrc
  sed -i '' '/^source ".*bin\/activate"$/d' .envrc \
    && echo "source \"$venvdir/bin/activate\"" >> .envrc
  sed -i '' '/^unset PS1$/d' .envrc \
    && echo "unset PS1" >> .envrc
  sed -i '' '/^dotenv$/d' .envrc \
    && echo "dotenv" >> .envrc

  direnv allow

  echo -e "${cyan}Created Python virtual environment in $(cd "$venvdir" 2> /dev/null ; pwd) ${nocolor}"
}
