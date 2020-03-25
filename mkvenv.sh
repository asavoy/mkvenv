function mkvenv() {
  if [[ -z "$1" ]]; then
    echo "usage: mkvenv [--force] [--path VENV_PATH] [PYTHON_VERSION]"
    return 1
  fi
  
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
  
  hash pyenv 2>/dev/null || { echo "pyenv not found"; return 1; }
  hash virtualenv 2>/dev/null || { echo "virtualenv not found"; return 1; }
  hash direnv 2>/dev/null || { echo "direnv not found"; return 1; }

  if [[ -f .python-version ]]; then
    local existing="$(cat .python-version)"
    if [[ -z "$force" && "$existing" != "$version" ]]; then
      echo "$version does not match .python-version ($existing)"
      return 1
    fi
  fi
  pyenv local "$version" || return 1

  if [[ -d "$venvdir" ]]; then
    if [[ -z "$force" ]]; then
      echo "$venvdir already exists!"
      return 1
    elif [[ -n "$venvdir" && "$venvdir" != "/" ]]; then
      rm -r "$venvdir"
    fi
  fi

  virtualenv --python "$(pyenv which python)" "$venvdir" || return 1

  sed -i '' '/^source ".*bin\/activate"$/d' .envrc \
    && echo "source \"$venvdir/bin/activate\"" >> .envrc

  sed -i '' '/^unset PS1$/d' .envrc \
    && echo "unset PS1" >> .envrc

  direnv allow
}

