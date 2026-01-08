# Local Development Setup

This guide will help you set up your local development environment for Tokyo Downloader.

## Prerequisites

### 1. Install uv

Tokyo Downloader uses [uv](https://docs.astral.sh/uv/) for fast, reliable dependency management.

**macOS/Linux:**
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

**Homebrew:**
```bash
brew install uv
```

**Windows:**
```powershell
powershell -ExecutionPolicy BypassUser -c "irm https://astral.sh/uv/install.ps1 | iex"
```

### 2. Verify Installation

```bash
uv --version
```

You should see output like: `uv 0.5.x` or higher.

## Setting Up the Project

### 1. Clone the Repository

```bash
git clone https://github.com/phase7/Tokyo-Downloader.git
cd Tokyo-Downloader
```

### 2. Install Dependencies

uv will automatically:
- Install Python 3.14 if not present
- Create a virtual environment in `.venv`
- Install all production and development dependencies

```bash
uv sync
```

This command installs:
- **Production dependencies**: requests, beautifulsoup4, lxml, typer, inquirer
- **Development dependencies**: pytest, pytest-mock, responses

### 3. Verify Installation

Check that the CLI command works:

```bash
uv run tokyo-downloader --help
```

You should see:
```
Usage: tokyo-downloader [OPTIONS]

╭─ Options ────────────────────────────────────────────────╮
│ --url         TEXT  [default: ...]                      │
│ --help              Show this message and exit.          │
╰──────────────────────────────────────────────────────────╯
```

## Project Structure

```
Tokyo-Downloader/
├── .venv/                  # Virtual environment (auto-created)
├── docs/                   # Documentation
├── download-scripts/       # Post-processing scripts (wget, yt-dlp)
├── tests/                  # Test suite
│   ├── fixtures/          # Test HTML fixtures
│   ├── conftest.py        # Pytest configuration
│   └── test_main.py       # Test cases
├── main.py                # Main application code
├── pyproject.toml         # Project configuration
├── uv.lock                # Dependency lock file
├── .python-version        # Python version (3.14)
└── README.md              # User documentation
```

## Running the Application

### Option 1: One-time Execution with uvx (from Git)

Run directly from GitHub without cloning:

```bash
# Run latest version from main branch
uvx --from git+https://github.com/phase7/Tokyo-Downloader tokyo-downloader

# Run from specific branch
uvx --from git+https://github.com/phase7/Tokyo-Downloader@main tokyo-downloader

# Run specific version/tag
uvx --from git+https://github.com/phase7/Tokyo-Downloader@v1.0.0 tokyo-downloader

# Run specific commit
uvx --from git+https://github.com/phase7/Tokyo-Downloader@b10b346 tokyo-downloader
```

**Or from PyPI (after publishing):**
```bash
uvx tokyo-downloader
```

### Option 2: Local Development (Interactive Mode)

After cloning and installing:

```bash
uv run tokyo-downloader
```

This will prompt you for:
1. Anime URL from Tokyo Insider
2. Episode/OVA/Movie/Special ranges
3. Sorting preference (Biggest Size, Most Downloaded, Latest)
4. Optional custom filename template

### Option 3: With URL Argument

```bash
uv run tokyo-downloader --url "https://www.tokyoinsider.com/anime/B/Bleach_(TV)"
```

### Option 4: Activate Virtual Environment

If you prefer traditional workflow:

```bash
# Activate virtual environment
source .venv/bin/activate  # macOS/Linux
.venv\Scripts\activate     # Windows

# Run directly
tokyo-downloader

# Deactivate when done
deactivate
```

## Development Workflow

### Adding New Dependencies

**Production dependency:**
```bash
uv add package-name
```

**Development dependency:**
```bash
uv add --dev package-name
```

**Example:**
```bash
# Add a new web scraping library
uv add scrapy

# Add a testing tool
uv add --dev pytest-cov
```

### Updating Dependencies

**Update all dependencies:**
```bash
uv lock --upgrade
uv sync
```

**Update specific package:**
```bash
uv lock --upgrade-package requests
uv sync
```

### Removing Dependencies

```bash
uv remove package-name
```

## Code Style and Quality

### Running Tests

See [Running Tests](./running-tests.md) for detailed testing documentation.

Quick reference:
```bash
# Run all tests
uv run pytest

# Run with coverage
uv run pytest --cov=main --cov-report=html
```

### Code Formatting (Optional)

Add formatting tools if needed:
```bash
uv add --dev black ruff
```

Format code:
```bash
uv run black main.py
uv run ruff check main.py
```

## Understanding the Codebase

### Key Components

1. **Web Scraping (`okay()` function)**
   - Fetches main anime page from Tokyo Insider
   - Extracts episode/OVA/movie/special links using XPath
   - Handles user input for episode ranges

2. **Multi-threading (`fetch_download()` function)**
   - Uses ThreadPoolExecutor with 5 workers
   - Processes episode pages in parallel
   - Thread-safe queue collects results

3. **Link Processing (`process_link()` function)**
   - Fetches individual episode pages
   - Extracts download metadata (size, downloads, date)
   - Selects best link based on user preference

4. **Output (`save_links_to_file()` function)**
   - Writes download links to `links.txt`
   - Supports pipe-delimited custom filenames

### Important Files

- **`main.py`** - Single-file application (~220 lines)
- **`pyproject.toml`** - Dependency and project configuration
- **`uv.lock`** - Locked dependency versions (commit this!)
- **`.python-version`** - Python version specification

## Troubleshooting

### Issue: "Command not found: uv"

**Solution:** Add uv to your PATH:
```bash
# macOS/Linux
export PATH="$HOME/.local/bin:$PATH"

# Add to ~/.bashrc or ~/.zshrc for persistence
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
```

### Issue: Python 3.14 not found

**Solution:** uv will automatically install it:
```bash
uv sync
```

If issues persist, install manually:
```bash
uv python install 3.14
```

### Issue: Tests failing

**Solution:** Ensure dev dependencies are installed:
```bash
uv sync --all-groups
```

### Issue: Import errors

**Solution:** Make sure you're using uv run or have activated the virtual environment:
```bash
# Option 1: Use uv run
uv run python main.py

# Option 2: Activate venv first
source .venv/bin/activate
python main.py
```

### Issue: Git conflicts with uv.lock

**Solution:**
```bash
# Pull latest changes
git pull

# Regenerate lock file
uv lock
```

## IDE Integration

### PyCharm

1. Configure Python interpreter:
   - Settings → Project → Python Interpreter
   - Click gear icon → Add Interpreter → Existing
   - Select `.venv/bin/python` (or `.venv\Scripts\python.exe` on Windows)

2. Mark directories:
   - Right-click `tests` → Mark Directory as → Test Sources Root

### VS Code

Create `.vscode/settings.json`:
```json
{
  "python.defaultInterpreterPath": "${workspaceFolder}/.venv/bin/python",
  "python.testing.pytestEnabled": true,
  "python.testing.pytestArgs": ["tests"]
}
```

## Next Steps

- Read [Running Tests](./running-tests.md) for testing guidelines
- Check [CLAUDE.md](../CLAUDE.md) for architecture details
- See [README.md](../README.md) for user documentation

## Additional Resources

- [uv Documentation](https://docs.astral.sh/uv/)
- [pytest Documentation](https://docs.pytest.org/)
- [Python 3.14 Release Notes](https://docs.python.org/3.14/whatsnew/3.14.html)
