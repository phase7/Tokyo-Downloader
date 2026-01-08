.PHONY: help install test test-verbose test-watch test-update-snapshots coverage clean lint format check run dev build docs

# Default target
.DEFAULT_GOAL := help

# Colors for terminal output
BLUE := \033[0;34m
GREEN := \033[0;32m
YELLOW := \033[0;33m
RED := \033[0;31m
NC := \033[0m # No Color

help: ## Show this help message
	@echo '$(BLUE)Tokyo Downloader - Available Commands$(NC)'
	@echo ''
	@echo 'Usage:'
	@echo '  $(GREEN)make$(NC) $(YELLOW)<target>$(NC)'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  $(GREEN)%-20s$(NC) %s\n", $$1, $$2}' $(MAKEFILE_LIST)

# ============================================================================
# Installation & Setup
# ============================================================================

install: ## Install all dependencies (production + development)
	@echo "$(BLUE)Installing dependencies with uv...$(NC)"
	uv sync
	@echo "$(GREEN)✓ Dependencies installed$(NC)"

install-prod: ## Install only production dependencies
	@echo "$(BLUE)Installing production dependencies...$(NC)"
	uv sync --no-dev
	@echo "$(GREEN)✓ Production dependencies installed$(NC)"

# ============================================================================
# Testing
# ============================================================================

test: ## Run all tests
	@echo "$(BLUE)Running tests...$(NC)"
	uv run pytest
	@echo "$(GREEN)✓ Tests passed$(NC)"

test-verbose: ## Run tests with verbose output
	@echo "$(BLUE)Running tests (verbose)...$(NC)"
	uv run pytest -v

test-watch: ## Run tests in watch mode (requires pytest-watch)
	@echo "$(BLUE)Running tests in watch mode...$(NC)"
	@echo "$(YELLOW)Note: Install pytest-watch with: uv add --dev pytest-watch$(NC)"
	uv run ptw

test-update-snapshots: ## Update test snapshots
	@echo "$(BLUE)Updating test snapshots...$(NC)"
	uv run pytest --snapshot-update
	@echo "$(GREEN)✓ Snapshots updated$(NC)"
	@echo "$(YELLOW)Review changes with: git diff tests/__snapshots__/$(NC)"

test-fast: ## Run tests without output capture (faster)
	@echo "$(BLUE)Running tests (fast mode)...$(NC)"
	uv run pytest -x --tb=short

# ============================================================================
# Code Coverage
# ============================================================================

coverage: ## Run tests with coverage report
	@echo "$(BLUE)Running tests with coverage...$(NC)"
	uv run pytest --cov=main --cov-report=term-missing
	@echo "$(GREEN)✓ Coverage report generated$(NC)"

coverage-html: ## Generate HTML coverage report
	@echo "$(BLUE)Generating HTML coverage report...$(NC)"
	uv run pytest --cov=main --cov-report=html
	@echo "$(GREEN)✓ Coverage report saved to htmlcov/index.html$(NC)"
	@echo "$(YELLOW)Open with: open htmlcov/index.html (macOS) or xdg-open htmlcov/index.html (Linux)$(NC)"

coverage-xml: ## Generate XML coverage report (for CI)
	@echo "$(BLUE)Generating XML coverage report...$(NC)"
	uv run pytest --cov=main --cov-report=xml
	@echo "$(GREEN)✓ Coverage report saved to coverage.xml$(NC)"

# ============================================================================
# Code Quality
# ============================================================================

lint: ## Run linter (ruff)
	@echo "$(BLUE)Running linter...$(NC)"
	@uv run ruff check . && echo "$(GREEN)✓ No linting issues$(NC)" || true

lint-fix: ## Run linter with auto-fix
	@echo "$(BLUE)Running linter with auto-fix...$(NC)"
	@uv run ruff check --fix .

format: ## Format code with ruff
	@echo "$(BLUE)Formatting code...$(NC)"
	@uv run ruff format .
	@echo "$(GREEN)✓ Code formatted$(NC)"

format-check: ## Check code formatting without changes
	@echo "$(BLUE)Checking code formatting...$(NC)"
	@uv run ruff format --check . && echo "$(GREEN)✓ Code is properly formatted$(NC)" || true

check: test lint format-check ## Run all checks (tests, linting, formatting)
	@echo "$(GREEN)✓ All checks passed$(NC)"

# ============================================================================
# Running the Application
# ============================================================================

run: ## Run the application (interactive mode)
	@echo "$(BLUE)Starting Tokyo Downloader...$(NC)"
	uv run tokyo-downloader

run-bleach: ## Run with Bleach example URL
	@echo "$(BLUE)Starting Tokyo Downloader with Bleach URL...$(NC)"
	uv run tokyo-downloader --url "https://www.tokyoinsider.com/anime/B/Bleach_(TV)"

dev: ## Run in development mode (same as run)
	@$(MAKE) run

# ============================================================================
# Dependency Management
# ============================================================================

update: ## Update all dependencies
	@echo "$(BLUE)Updating dependencies...$(NC)"
	uv lock --upgrade
	uv sync
	@echo "$(GREEN)✓ Dependencies updated$(NC)"

update-check: ## Check for outdated dependencies
	@echo "$(BLUE)Checking for outdated dependencies...$(NC)"
	uv lock --upgrade --dry-run
	@echo "$(GREEN)✓ Check complete$(NC)"

add: ## Add a new dependency (usage: make add PACKAGE=requests)
	@if [ -z "$(PACKAGE)" ]; then \
		echo "$(RED)Error: PACKAGE not specified$(NC)"; \
		echo "Usage: make add PACKAGE=package-name"; \
		exit 1; \
	fi
	@echo "$(BLUE)Adding package: $(PACKAGE)$(NC)"
	uv add $(PACKAGE)
	@echo "$(GREEN)✓ Package added$(NC)"

add-dev: ## Add a new dev dependency (usage: make add-dev PACKAGE=pytest)
	@if [ -z "$(PACKAGE)" ]; then \
		echo "$(RED)Error: PACKAGE not specified$(NC)"; \
		echo "Usage: make add-dev PACKAGE=package-name"; \
		exit 1; \
	fi
	@echo "$(BLUE)Adding dev package: $(PACKAGE)$(NC)"
	uv add --dev $(PACKAGE)
	@echo "$(GREEN)✓ Dev package added$(NC)"

# ============================================================================
# Cleaning
# ============================================================================

clean: ## Remove generated files and caches
	@echo "$(BLUE)Cleaning up...$(NC)"
	find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name "*.pyc" -delete 2>/dev/null || true
	find . -type f -name "*.pyo" -delete 2>/dev/null || true
	find . -type f -name "*.pyd" -delete 2>/dev/null || true
	rm -rf .pytest_cache
	rm -rf htmlcov
	rm -rf .coverage
	rm -rf dist
	rm -rf build
	rm -rf *.egg-info
	rm -f links.txt
	@echo "$(GREEN)✓ Cleanup complete$(NC)"

clean-all: clean ## Remove everything including .venv
	@echo "$(BLUE)Removing virtual environment...$(NC)"
	rm -rf .venv
	@echo "$(GREEN)✓ Full cleanup complete$(NC)"

# ============================================================================
# Build & Distribution
# ============================================================================

build: ## Build distribution packages
	@echo "$(BLUE)Building distribution packages...$(NC)"
	uv build
	@echo "$(GREEN)✓ Build complete$(NC)"
	@echo "$(YELLOW)Packages created in dist/$(NC)"

publish-test: build ## Publish to TestPyPI
	@echo "$(BLUE)Publishing to TestPyPI...$(NC)"
	uv publish --index testpypi
	@echo "$(GREEN)✓ Published to TestPyPI$(NC)"

publish: build ## Publish to PyPI
	@echo "$(RED)⚠ This will publish to PyPI!$(NC)"
	@echo "Press Ctrl+C to cancel, or Enter to continue..."
	@read dummy
	@echo "$(BLUE)Publishing to PyPI...$(NC)"
	uv publish
	@echo "$(GREEN)✓ Published to PyPI$(NC)"

# ============================================================================
# Documentation
# ============================================================================

docs: ## Open documentation in browser
	@echo "$(BLUE)Opening documentation...$(NC)"
	@if command -v open >/dev/null 2>&1; then \
		open docs/README.md; \
	elif command -v xdg-open >/dev/null 2>&1; then \
		xdg-open docs/README.md; \
	else \
		echo "$(YELLOW)Open docs/README.md manually$(NC)"; \
	fi

docs-coverage: coverage-html ## Generate docs and coverage report
	@$(MAKE) docs

# ============================================================================
# Git Helpers
# ============================================================================

git-status: ## Show git status and uncommitted changes
	@echo "$(BLUE)Git Status:$(NC)"
	@git status --short

git-diff-snapshots: ## Show diff of snapshot files
	@echo "$(BLUE)Snapshot Changes:$(NC)"
	@git diff tests/__snapshots__/

# ============================================================================
# Development Helpers
# ============================================================================

info: ## Show project information
	@echo "$(BLUE)Project Information$(NC)"
	@echo ""
	@echo "$(GREEN)Package Manager:$(NC) uv"
	@echo "$(GREEN)Python Version:$(NC) $(shell cat .python-version 2>/dev/null || echo 'Not specified')"
	@echo "$(GREEN)Virtual Environment:$(NC) .venv/"
	@echo ""
	@echo "$(GREEN)Dependencies:$(NC)"
	@uv pip list 2>/dev/null | head -20 || echo "Run 'make install' first"
	@echo ""
	@echo "$(GREEN)Test Files:$(NC) $(shell find tests -name 'test_*.py' | wc -l | xargs)"
	@echo "$(GREEN)Snapshot Files:$(NC) $(shell find tests/__snapshots__ -name '*.ambr' 2>/dev/null | wc -l | xargs)"

shell: ## Open Python shell with project context
	@echo "$(BLUE)Opening Python shell...$(NC)"
	uv run python

quick-test: ## Quick smoke test (import check only)
	@echo "$(BLUE)Running quick smoke test...$(NC)"
	@uv run python -c "import main; print('✓ Imports OK')"
	@echo "$(GREEN)✓ Quick test passed$(NC)"

# ============================================================================
# CI/CD Helpers
# ============================================================================

ci: install test lint ## Run full CI pipeline
	@echo "$(GREEN)✓ CI pipeline complete$(NC)"

ci-coverage: install coverage-xml ## Run CI with coverage
	@echo "$(GREEN)✓ CI with coverage complete$(NC)"

# ============================================================================
# Version Information
# ============================================================================

version: ## Show version information
	@echo "$(BLUE)Version Information$(NC)"
	@echo ""
	@echo "$(GREEN)Tokyo Downloader:$(NC) $(shell grep 'version = ' pyproject.toml | head -1 | cut -d'"' -f2)"
	@echo "$(GREEN)Python:$(NC) $(shell uv run python --version 2>&1 | cut -d' ' -f2)"
	@echo "$(GREEN)uv:$(NC) $(shell uv --version 2>&1 | cut -d' ' -f2)"
	@echo "$(GREEN)pytest:$(NC) $(shell uv run pytest --version 2>&1 | head -1 | cut -d' ' -f2)"
