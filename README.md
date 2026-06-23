# mkvenv

**Conveniently setup & use Python virtual environments.**

Use it because:

- you can work with different Python versions per project
- the Python environment is activated as soon as you `cd` into the project dir
- the virtual environment is kept tidily in the project dir, `node_modules`-style


## Usage

```bash
mkvenv PYTHON_VERSION [--app|--lib] [--force] [--path VENV_PATH]
```

- `PYTHON_VERSION` to specify the Python version (uv will download it if needed)
- `--app`, `--lib` are passed through to `uv init` to choose the project kind
  (application or library; `--app` is uv's default)
- `--force` will (re)build even if the virtual environment already exists
- `--path` to choose a different path for the virtual environment (default: `.venv`)

For example, to create a Python virtual environment in `.venv/` of the current dir:

```bash
$ mkvenv 3.12
```

It will:

- `uv init --python PYTHON_VERSION` to initialise the project
- `uv venv --python PYTHON_VERSION` to create the virtual environment
- create an empty `.env` file
- write a `.envrc` so [direnv](https://direnv.net) activates the venv and loads
  `.env` (via `dotenv`) whenever you `cd` into the project


## Dependencies

- macOS
- bash or zsh as your shell
- `brew install direnv`
- `brew install uv`


## Setup

1. Ensure you have these dependencies above

2. Clone this repo

3. Add `source /path/to/mkvenv.sh` to `.profile`

4. Add `.venv` to your global `.gitignore`
