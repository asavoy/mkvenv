# mkvenv

**Conveniently setup & use Python virtual environments.**

Use it because:

- you can work with different Python versions per project
- the Python environment is activated as soon as you `cd` into the project dir
- the virtual environment is kept tidily in the project dir, `node_modules`-style


## Usage

```bash
mkvenv [--force] [--path VENV_PATH] [PYTHON_VERSION]
```

- `--force` will (re)build even if the virtual environment already exists
- `--path` to choose a different path for the virtual environment
- `PYTHON_VERSION` to specify the Python version, else will look in the file `.python-version` 

For example, to create a Python virtual environment in `.venv/` of the current dir: 

```bash
$ mkvenv 3.8.1
```


## Dependencies

- macOS
- bash or zsh as your shell
- `brew install direnv`
- `brew install pyenv`


## Setup

1. Ensure you have these dependencies above

2. Clone this repo

3. Add `source /path/to/mkvenv.sh` to `.profile`

4. Add `.venv` to your global `.gitignore`

