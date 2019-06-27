# mkvenv

Bash function for creating Python virtualenvs.

## Why

- It's easy to start a Python project with a specific Python version
- It's tidy to keep your dependencies local and isolated to your project repo
- It's less hassle to activate the Python virtualenv by just `cd`'ing into the project repo

## Usage

```bash
mkdir ~/Projects/my-python-project

cd ~/Projects/my-python-project

mkvenv 3.7.1
# Running virtualenv with interpreter /Users/alvin/.pyenv/versions/3.7.1/bin/python
# Using base prefix '/Users/alvin/.pyenv/versions/3.7.1'
# New python executable in /Users/alvin/Projects/my-python-project/.venv/bin/python
# Installing setuptools, pip, wheel...
# done.
# direnv: loading .envrc
# direnv: export +VIRTUAL_ENV ~PATH

which python
# /Users/alvin/Projects/my-python-project/.venv/bin/python

python --version
# Python 3.7.1
```

## Dependencies

- direnv
- pyenv
- virtualenv

## Setup

1. Install dependencies

2. Clone this repo

3. Add `source /path/to/mkvenv.sh` to `.profile`

4. Add `.venv` to your global `.gitignore`
