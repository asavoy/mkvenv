function mkvenv() {
  if [[ -z "$1" ]]; then
    echo "usage: mkvenv <python-version>"
    return 1
  fi

  local version="$1"
  local venvdir=".venv"

  hash pyenv 2>/dev/null || { echo "pyenv not found"; return 1 }
  hash virtualenv 2>/dev/null || { echo "virtualenv not found"; return 1 }
  hash direnv 2>/dev/null || { echo "direnv not found"; return 1 }

  if [[ -f .python-version && $(cat .python-version) != $version ]]; then
    echo "$version does not match .python-version"
    return 1
  fi
  if [[ -d $venvdir ]]; then
    echo "$venvdir already exists!"
    return 1
  fi

  pyenv local "$version" \
    && virtualenv --python $(pyenv which python) "$venvdir" \
    && echo "source \"$venvdir/bin/activate\"" >> .envrc \
    && direnv allow
}

