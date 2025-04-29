include make_common.mk

.PHONY: init install lint format test run clean clean-cache help

ENV ?= dev
FILE ?= src/main.py

init:  ## Initialize project with uv and project config
	@if [ ! -f pyproject.toml ]; then \
		if [ -z "$(PROJECT_NAME)" ]; then \
			read -p "Enter project name: " PROJECT_NAME; \
		fi; \
		$(call start_msg,Initializing project "$$PROJECT_NAME") \
		echo "Creating pyproject.toml with uv (project name: $$PROJECT_NAME)..."; \
		uv init --name "$$PROJECT_NAME" --yes; \
	else \
		$(call start_msg,Project already initialized) \
	fi

	@if ! grep -q "\[tool.ruff\]" pyproject.toml; then \
		echo "\n[tool.ruff]" >> pyproject.toml; \
		echo "# Additional ruff configuration can be added here if desired." >> pyproject.toml; \
	fi

	$(call success_msg,Initialization complete for "$$PROJECT_NAME")

install:  ## Install Python dependencies
	$(call start_msg,Installing dependencies)
	uv sync
	$(call success_msg,Dependencies installed)

lint:  ## Lint code using ruff
	$(call start_msg,Linting code)
	uv ruff check .
	$(call success_msg,Lint passed)

format:  ## Format code and organize imports using ruff
	$(call start_msg,Formatting code and imports)
	uv ruff format .
	uv ruff check . --select I --fix
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
	@awk '/^[a-zA-Z0-9\-\_]+:/ && !/^\t/ { \
		gsub(":", "", $$1); \
		printf "  \033[0;32m%-20s\033[0m %s\n", $$1, substr($$0, index($$0,$$2)) \
	}' $(MAKEFILE_LIST)

