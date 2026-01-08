# Makefile Guide

This project includes a comprehensive Makefile with shortcuts for common development tasks. The Makefile simplifies complex commands and provides a consistent interface for development workflows.

## Quick Start

```bash
# Show all available commands
make help

# Install dependencies
make install

# Run tests
make test

# Run the application
make run
```

## Why Use Make?

- **Simplicity**: Short, memorable commands instead of long `uv run` invocations
- **Consistency**: Same commands work across different environments
- **Documentation**: Self-documenting with `make help`
- **Automation**: Chain multiple commands together
- **Cross-platform**: Works on macOS, Linux, and Windows (with WSL/Git Bash)

## All Available Commands

### 📦 Installation & Setup

| Command | Description |
|---------|-------------|
| `make install` | Install all dependencies (production + development) |
| `make install-prod` | Install only production dependencies |

**Example:**
```bash
# Fresh project setup
git clone <repo-url>
cd Tokyo-Downloader
make install
```

### 🧪 Testing

| Command | Description |
|---------|-------------|
| `make test` | Run all tests |
| `make test-verbose` | Run tests with verbose output |
| `make test-watch` | Run tests in watch mode (auto-rerun on changes)* |
| `make test-update-snapshots` | Update test snapshots |
| `make test-fast` | Run tests in fast mode (fail fast) |
| `make quick-test` | Quick smoke test (imports only) |

*Requires `pytest-watch`: `make add-dev PACKAGE=pytest-watch`

**Examples:**
```bash
# Run tests after making changes
make test

# Update snapshots after intentional output changes
make test-update-snapshots

# Quick check that nothing is broken
make quick-test
```

### 📊 Code Coverage

| Command | Description |
|---------|-------------|
| `make coverage` | Run tests with terminal coverage report |
| `make coverage-html` | Generate HTML coverage report |
| `make coverage-xml` | Generate XML coverage report (for CI) |
| `make docs-coverage` | Generate both docs and coverage |

**Examples:**
```bash
# Check coverage
make coverage

# Generate visual coverage report
make coverage-html
# Opens htmlcov/index.html

# CI/CD coverage
make coverage-xml
```

**Example Output:**
```
Running tests with coverage...
---------- coverage: platform darwin, python 3.14.2 -----------
Name      Stmts   Miss  Cover   Missing
---------------------------------------
main.py     120     45    62%   45-67, 89-102
---------------------------------------
TOTAL       120     45    62%
```

### ✨ Code Quality

| Command | Description |
|---------|-------------|
| `make lint` | Run linter (ruff) |
| `make lint-fix` | Run linter with auto-fix |
| `make format` | Format code with black |
| `make format-check` | Check formatting without changes |
| `make check` | Run all checks (tests + lint + format) |

**Setup (optional):**
```bash
# Add linting and formatting tools
make add-dev PACKAGE=ruff
make add-dev PACKAGE=black
```

**Examples:**
```bash
# Check code quality
make lint

# Auto-fix linting issues
make lint-fix

# Format code
make format

# Run everything before committing
make check
```

### 🚀 Running the Application

| Command | Description |
|---------|-------------|
| `make run` | Run in interactive mode (prompts for URL) |
| `make run-bleach` | Run with Bleach example URL |
| `make dev` | Alias for `make run` |

**Examples:**
```bash
# Interactive mode
make run

# Quick test with example
make run-bleach

# Development mode (same as run)
make dev
```

### 📦 Dependency Management

| Command | Description |
|---------|-------------|
| `make update` | Update all dependencies |
| `make update-check` | Check for outdated dependencies |
| `make add PACKAGE=<name>` | Add production dependency |
| `make add-dev PACKAGE=<name>` | Add development dependency |

**Examples:**
```bash
# Add a new library
make add PACKAGE=requests

# Add a development tool
make add-dev PACKAGE=pytest-cov

# Update all dependencies
make update

# Check what would be updated
make update-check
```

### 🧹 Cleaning

| Command | Description |
|---------|-------------|
| `make clean` | Remove generated files and caches |
| `make clean-all` | Remove everything including .venv |

**Examples:**
```bash
# Clean build artifacts and cache
make clean

# Full reset (removes virtual environment)
make clean-all
make install  # Reinstall
```

**What gets cleaned:**
- `__pycache__/` directories
- `*.pyc`, `*.pyo`, `*.pyd` files
- `.pytest_cache/`
- `htmlcov/` (coverage reports)
- `.coverage` files
- `dist/`, `build/`, `*.egg-info/`
- `links.txt` (generated output)

### 🏗️ Build & Distribution

| Command | Description |
|---------|-------------|
| `make build` | Build distribution packages |
| `make publish-test` | Publish to TestPyPI |
| `make publish` | Publish to PyPI (with confirmation) |

**Examples:**
```bash
# Build wheel and source distribution
make build
# Creates dist/ with .whl and .tar.gz

# Test publishing workflow
make publish-test

# Publish to PyPI (production)
make publish
```

### 📚 Documentation

| Command | Description |
|---------|-------------|
| `make docs` | Open documentation in browser |
| `make docs-coverage` | Generate docs and coverage report |

**Examples:**
```bash
# Open docs
make docs

# Generate comprehensive reports
make docs-coverage
```

### 🔧 Git Helpers

| Command | Description |
|---------|-------------|
| `make git-status` | Show git status (short format) |
| `make git-diff-snapshots` | Show diff of snapshot files |

**Examples:**
```bash
# Quick status check
make git-status

# Review snapshot changes after updating
make git-diff-snapshots
```

### ℹ️ Information

| Command | Description |
|---------|-------------|
| `make info` | Show project information |
| `make version` | Show version information |
| `make shell` | Open Python shell with project context |

**Examples:**
```bash
# Project overview
make info

# Version details
make version

# Interactive Python shell
make shell
```

### 🤖 CI/CD Helpers

| Command | Description |
|---------|-------------|
| `make ci` | Run full CI pipeline (install + test + lint) |
| `make ci-coverage` | Run CI with coverage |

**Examples:**
```bash
# Simulate CI locally
make ci

# CI with coverage report
make ci-coverage
```

**Use in GitHub Actions:**
```yaml
- name: Run CI
  run: make ci-coverage
```

## Common Workflows

### Daily Development

```bash
# Start of day
make install        # Update dependencies

# Development cycle
make test-watch    # Auto-run tests
# ... make changes ...
make test          # Final test
make check         # Before commit

# End of day
make git-status    # Check changes
```

### Adding a Feature

```bash
# 1. Create branch
git checkout -b feature/my-feature

# 2. Make changes
vim main.py

# 3. Update tests
vim tests/test_main.py
make test

# 4. Update snapshots if needed
make test-update-snapshots
make git-diff-snapshots

# 5. Quality checks
make check

# 6. Commit
git add .
git commit -m "feat: add feature"
```

### Fixing Failing Tests

```bash
# Run tests to see failures
make test-verbose

# Make changes
vim main.py

# Quick check
make quick-test

# Full test
make test

# Update snapshots if output changed intentionally
make test-update-snapshots
```

### Preparing for Release

```bash
# 1. Run full checks
make clean
make install
make ci

# 2. Update version in pyproject.toml
vim pyproject.toml

# 3. Build
make build

# 4. Test publish
make publish-test

# 5. Publish
make publish
```

### Debugging

```bash
# Check what's installed
make info

# Test imports
make quick-test

# Interactive shell
make shell
>>> import main
>>> main.convert_size("100 MB")
100.0
```

## Advanced Usage

### Chaining Commands

```bash
# Clean, install, and test
make clean && make install && make test

# Full quality check
make clean && make ci && make coverage-html
```

### Custom Shortcuts

Add your own shortcuts to the Makefile:

```makefile
.PHONY: my-workflow
my-workflow: clean install test coverage-html ## My custom workflow
	@echo "$(GREEN)✓ Workflow complete$(NC)"
```

Then use:
```bash
make my-workflow
```

### Using Make Variables

```bash
# Add specific package
make add PACKAGE=httpx

# Add dev package
make add-dev PACKAGE=mypy
```

## Troubleshooting

### Command Not Found: make

**macOS:**
```bash
# Install Xcode Command Line Tools
xcode-select --install
```

**Linux:**
```bash
# Debian/Ubuntu
sudo apt-get install build-essential

# Fedora/RHEL
sudo dnf install make
```

**Windows:**
- Use WSL (Windows Subsystem for Linux)
- Or use Git Bash (comes with Git for Windows)

### Colors Not Showing

If ANSI colors don't work in your terminal:
```bash
# Remove color codes manually
make help | sed 's/\x1b\[[0-9;]*m//g'
```

Or edit the Makefile and remove color variables.

### Make Command Fails

```bash
# Check if Makefile exists
ls -la Makefile

# Verify syntax (no error = OK)
make -n test

# Run with debugging
make -d test
```

## Tips & Tricks

### Tab Completion

Add to your `.bashrc` or `.zshrc`:
```bash
# Bash
complete -W "$(make -qp | awk -F':' '/^[a-zA-Z0-9][^$#\/\t=]*:([^=]|$)/ {split($1,A,/ /);for(i in A)print A[i]}' | sort -u)" make

# Zsh (built-in)
# Just works!
```

Then:
```bash
make te<TAB>  # Completes to make test
```

### Makefile Help Format

The help system uses this format:
```makefile
target: ## Description here
	@commands
```

The `##` after the target name makes it appear in `make help`.

### Silent Execution

Prefix with `@` to suppress command echo:
```makefile
@echo "Hello"     # Shows: Hello
echo "Hello"      # Shows: echo "Hello" \n Hello
```

### Check if Command Exists

```makefile
@if command -v ruff >/dev/null 2>&1; then \
	ruff check .; \
else \
	echo "ruff not found"; \
fi
```

## Comparison with Direct Commands

| Makefile | Direct Command |
|----------|----------------|
| `make test` | `uv run pytest` |
| `make test-verbose` | `uv run pytest -v` |
| `make test-update-snapshots` | `uv run pytest --snapshot-update` |
| `make coverage` | `uv run pytest --cov=main --cov-report=term-missing` |
| `make run` | `uv run tokyo-downloader` |
| `make install` | `uv sync` |
| `make clean` | `find . -name __pycache__ -exec rm -rf {} + && ...` |

**Benefits:** Shorter, easier to remember, consistent across projects.

## Best Practices

1. **Always use `make help`** - Don't memorize everything
2. **Run `make check`** - Before committing
3. **Use `make ci`** - To simulate CI locally
4. **Review snapshots** - Use `make git-diff-snapshots` after updating
5. **Keep Makefile updated** - Add project-specific shortcuts
6. **Document new targets** - Use `##` comments for help text

## Next Steps

- Check [Local Development Setup](./local-development.md) for environment setup
- Read [Running Tests](./running-tests.md) for detailed testing guide
- See [README](../README.md) for user documentation

## Resources

- [GNU Make Manual](https://www.gnu.org/software/make/manual/)
- [Makefile Tutorial](https://makefiletutorial.com/)
- [Self-Documenting Makefiles](https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html)
