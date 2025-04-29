include make_common.mk

.PHONY: init install lint format test run clean clean-cache help

ENV ?= dev
FILE ?= src/main.py

init:  ## Initialize project with uv and project config
	@$(call start_msg,Initializing project)
	@if [ ! -f pyproject.toml ]; then \
		uv init --package ; \
		uv add ruff pytest; \
	else \
		echo "pyproject.toml already exists — skipping uv init"; \
	fi

	@if ! grep -q "\[tool.ruff\]" pyproject.toml; then \
		printf "\n[tool.ruff]" >> pyproject.toml; \
		echo "# Additional ruff configuration can be added here if desired." >> pyproject.toml; \
	fi

	@$(call success_msg,Initialization complete)

install:  ## Install Python dependencies
	$(call start_msg,Installing dependencies)
	uv sync
	$(call success_msg,Dependencies installed)

lint:  ## Lint code using ruff
	$(call start_msg,Linting code)
	ruff check
	$(call success_msg,Lint passed)

format:  ## Format code and organize imports using ruff
	$(call start_msg,Formatting code and imports)
	ruff format .
	ruff check . --select I --fix
	$(call success_msg,Formatting complete)

test:  ## Run tests
	$(call start_msg,Running tests)
	pytest
	$(call success_msg,Tests passed)

run:  ## Run the specified Python file (default src/main.py) with environment
	$(call start_msg,Running $(FILE) with ENV=$(ENV))
	ENV=$(ENV) uv run $(FILE)
	$(call success_msg,Run completed)

clean:  ## Clean build artifacts and uv cache
	$(call start_msg,Cleaning project and cache)
	rm -rf __pycache__ dist build *.egg-info
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete
	uv cache clean
	$(call success_msg,Cleanup complete)

clean-cache:  ## Clean only uv cache
	$(call start_msg,Cleaning uv cache only)
	uv cache clean
	$(call success_msg,Cleanup complete)

help:  ## Show this help message
	@echo -e "$(YELLOW)Available targets:$(NC)\n"
	@awk '/^[a-zA-Z0-9_-]+:/ && !/^\t/ { \
		gsub(":", "", $$1); \
		printf "  \033[0;32m%-20s\033[0m %s\n", $$1, substr($$0, index($$0,$$2)) \
	}' $(MAKEFILE_LIST)

