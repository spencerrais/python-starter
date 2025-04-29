# Python Starter Template

This Starter Template is simply designed to satisfy my needs for a simple Python project.

It can be used with:
```bash
gh repo create YOUR_NEW_PROJECT_NAME --public --template spencerrais/python-starter
```

It contains:
- dependency and environment management via [uv](https://github.com/astral-sh/uv)
- code formatting and linting via [ruff](https://github.com/astral-sh/ruff) which emulates `black`, `isort`, and `flake8`
- Continuous Integration with automated releases using [release-please](https://github.com/google/release-please) and Github Actions which will lint and test.
- abstracted build tools using Makefile (`make init`, `make install`, `make run`, `make test`)


## Managing Dependencies

Add a dependency:
```bash
uv add <package-name>
```

Remove a dependency:
```bash
uv remove <package-name>
```

After modifying dependencies, sync your environment using:
```bash
make install
```

## Running the Project
The default entrypoint is `src/main.py`, run with:
```bash
make run
```

The default environment variable is `ENV=dev`.

Use a different file or value for `ENV` with:
```bash
ENV=prod make run
FILE=src/another_script.py make run
ENV=prod FILE=src/another_script.py make run
```

## Linting
Lint with
```bash
make lint
```

## Formatting
In case you don't utilize a format on save, a format can be run with:
```bash
make format
```
This uses the ruff default formatting (black drop-in replacement) and the default import sorting.

## Testing
Run tests using pytest using:
```bash
make test
```

## Cleaning
Delete build artifacts and clear `uv` cache:
```bash
make clean
```
or just clean the `uv` cache with:
```bash
make clean-cache
```
