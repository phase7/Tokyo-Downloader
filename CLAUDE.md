# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Tokyo Downloader is a Python web scraper that fetches anime episode/OVA/movie/special download links from Tokyo Insider. It's a single-file CLI application that uses multi-threading to process links efficiently and outputs them to `links.txt` for use with download managers like IDM, wget, or yt-dlp.

**Package Manager**: [uv](https://docs.astral.sh/uv/) - Fast, modern Python package manager
**Python Version**: 3.14 (latest stable)
**Testing**: pytest with 21 function-based tests + snapshot testing (syrupy)
**CLI Entry Point**: `tokyo-downloader` command via console script
**Build Tool**: Comprehensive Makefile with 38 shortcuts

## Documentation

For detailed guides, see the `docs/` directory:
- **[Makefile Guide](./docs/makefile-guide.md)** - ⭐ **Start here** - Comprehensive command reference
- **[Local Development Setup](./docs/local-development.md)** - Complete setup guide with troubleshooting
- **[Running Tests](./docs/running-tests.md)** - Testing guide with snapshot testing
- **[Documentation Index](./docs/README.md)** - Full documentation overview

Quick reference commands are below, but **use `make help` for the full list of 38 commands**.

## Development Commands

**💡 Pro Tip:** This project includes a comprehensive Makefile. Use `make help` to see all 38 available commands!

### Quick Reference (Makefile)

```bash
# Setup
make install              # Install all dependencies
make install-prod         # Production dependencies only

# Running
make run                  # Run application (interactive)
make run-bleach          # Run with example URL
make dev                  # Development mode

# Testing
make test                 # Run all tests
make test-verbose         # Verbose output
make test-update-snapshots # Update test snapshots
make coverage             # Coverage report
make coverage-html        # HTML coverage report

# Quality
make check                # Run all checks (test + lint + format)
make lint                 # Run linter
make format               # Format code
make clean                # Clean generated files

# Dependencies
make update               # Update all dependencies
make add PACKAGE=name     # Add dependency
make add-dev PACKAGE=name # Add dev dependency

# Info
make help                 # Show all commands
make version              # Show version info
make info                 # Show project info
```

### Direct Commands (without Make)

```bash
# Quick Run (No Installation) - Run directly from GitHub
uvx --from git+https://github.com/phase7/Tokyo-Downloader tokyo-downloader  # Latest
uvx --from git+https://github.com/phase7/Tokyo-Downloader@v1.0.0 tokyo-downloader  # Specific version

# Setup
curl -LsSf https://astral.sh/uv/install.sh | sh  # Install uv
uv sync                                           # Install dependencies

# Running (after cloning)
uv run tokyo-downloader                          # Run application
uv run tokyo-downloader --url "..."             # With URL
uv run python main.py                            # Direct execution

# Testing
uv run pytest                                    # Run tests
uv run pytest -v                                 # Verbose
uv run pytest --snapshot-update                  # Update snapshots
uv run pytest --cov=main                         # Coverage
```

**Note:** Makefile commands are shorter and more memorable. Use `make help` for the complete list.

## Architecture

### Single-File Design
All logic is contained in `main.py` (~220 lines). The application flow:
1. **URL Parsing** (`okay()`) - Scrapes main anime page using BeautifulSoup + lxml
2. **Link Extraction** - Uses XPath to find episode/OVA/movie/special links
3. **Multi-threaded Processing** (`fetch_download()`) - ThreadPoolExecutor with 5 workers
4. **Per-Link Scraping** (`process_link()`) - Each worker fetches individual episode pages
5. **Sorting & Selection** - Picks best download link based on user criteria
6. **Output** (`save_links_to_file()`) - Writes to `links.txt`

### Threading Model
- **Thread-safe queue**: `dlinks_queue` (global) collects results from workers
- **Executor pattern**: `ThreadPoolExecutor(max_workers=5)` processes links in parallel
- **No locks needed**: Queue handles synchronization automatically
- **Result sorting**: After threads complete, results are sorted by episode number using `sort_key()`

### Web Scraping Strategy
- **Two-stage scraping**:
  1. Main page: Extract all episode/OVA/movie/special links
  2. Individual pages: Fetch download links from each episode page
- **XPath selectors**:
  - Main page: `.download-link` class elements
  - Episode pages: `.c_h2` or `.c_h2b` div elements containing download options
- **User-Agent spoofing**: Required to avoid blocking (HEADERS global)

### Content Type Handling
The application distinguishes four content types via URL path structure:
- `episode` - Regular episodes
- `ova` - OVAs
- `special` - Special episodes
- `movie` - Movies

Type detection: `link.split('/')[-2]` extracts type from URL path.

### Sorting Options
User selects download preference via `inquirer` prompt:
- **Biggest Size**: Sorts by file size (converts GB/MB to float)
- **Most Downloaded**: Sorts by download count
- **Latest**: Sorts by upload date (MM/DD/YY format)

Sorting happens per-episode page using XPath extraction of metadata from `.//b/text()` elements.

### Custom Filename Feature
Optional custom naming template (activated via prompt):
- Available placeholders: `{anime_name}`, `{type}`, `{episode_number}`, `{size}`, `{uploader}`, `{upload_date}`
- Default format: `<name> - <type><number> [uploader]`
- Episode number is zero-padded based on total episode count
- Filenames appended to links in `links.txt` using pipe delimiter: `URL|filename.mkv`

## Key Implementation Details

### XPath Queries
- Main page videos: `//*[contains(concat( " ", @class, " " ), concat( " ", "download-link", " " ))]`
- Episode type filter: `e for e in allVideos if key in e.xpath('.//em/text()')`
- Download divs: `//div[contains(@class, "c_h2") or contains(@class, "c_h2b")]`

### Episode Range Input
User provides ranges like `1-5` or `0` (skip). The `append_links()` function uses negative indexing (`i * -1`) to access elements, suggesting the episode list may be in reverse order.

### Output Format
`links.txt` contains either:
- Simple format: One URL per line
- Custom name format: `URL|custom_filename.ext` per line

The download-scripts folder contains bash scripts (`wget-download.sh`, `yt-dlp-download.sh`) that parse the pipe-delimited format for custom filenames.

## Dependencies

### Production
- **requests**: HTTP requests
- **beautifulsoup4**: HTML parsing
- **lxml**: XPath query support (faster than BeautifulSoup alone)
- **typer**: CLI argument parsing with prompts (requires >=0.17.0 for Python 3.14 compatibility)
- **inquirer**: Interactive menu selection

### Development
- **pytest**: Testing framework
- **pytest-mock**: Mocking support for tests
- **responses**: HTTP request mocking library
- **syrupy**: Snapshot testing library (no fixture maintenance)

## Project Structure

```
Tokyo-Downloader/
├── docs/                   # Developer documentation
│   ├── README.md          # Documentation index
│   ├── makefile-guide.md  # Makefile command reference
│   ├── local-development.md
│   └── running-tests.md
├── tests/                  # Test suite
│   ├── __snapshots__/     # Syrupy snapshots (commit these!)
│   │   └── test_main.ambr # All snapshots in one file
│   ├── conftest.py        # pytest configuration
│   └── test_main.py       # 21 function-based tests (354 lines)
├── download-scripts/       # wget/yt-dlp helper scripts
├── Makefile               # 38 development shortcuts
├── main.py                # Main application (~220 lines)
├── pyproject.toml         # Project config & dependencies
├── uv.lock                # Dependency lock file (commit this)
├── .python-version        # Python 3.14
├── .gitignore            # Includes .venv, pytest cache, etc.
├── CLAUDE.md             # This file
└── README.md             # User documentation
```

## Testing

### Test Coverage
- **21 function-based tests** in `tests/test_main.py` (354 lines)
- **Snapshot testing** with syrupy (10 snapshot tests)
- Tests cover: imports, size conversion, date parsing, sorting, file output, edge cases
- Snapshots in `tests/__snapshots__/test_main.ambr`
- All tests passing in <0.1s

### Test Types

**Traditional Tests (11):**
- Import verification
- Size conversion (MB, GB, invalid)
- Date parsing (valid, invalid)
- Sort key (numeric, non-numeric)
- File operations (plain, custom names, empty)

**Snapshot Tests (10):**
- Size conversion edge cases
- Date conversion variations
- Sort key behavior
- File output formats
- Complete sorting workflows
- Size/date comparison sorting

### Running Tests (Makefile)
```bash
# Run all tests
make test

# Verbose output
make test-verbose

# Update snapshots (after intentional changes)
make test-update-snapshots

# Coverage report
make coverage

# HTML coverage report
make coverage-html

# Fast mode (fail fast)
make test-fast
```

### Running Tests (Direct)
```bash
# Run all tests
uv run pytest

# With coverage
uv run pytest --cov=main --cov-report=html

# Update snapshots
uv run pytest --snapshot-update

# Specific test
uv run pytest tests/test_main.py::test_convert_size_mb
```

### Snapshot Testing
Snapshots are automatically generated and stored in `tests/__snapshots__/test_main.ambr`.

**Workflow:**
1. Make code changes
2. Run `make test` (tests may fail if output changed)
3. Review changes: `make git-diff-snapshots`
4. If intentional: `make test-update-snapshots`
5. Commit snapshots: `git add tests/__snapshots__/`

**Benefits:**
- No need to maintain HTML fixture files
- Visual diffs in git
- Catches unexpected output changes
- Human-readable .ambr format

See [Running Tests](./docs/running-tests.md) for detailed testing documentation.

## Common Development Patterns

### Adding New Dependencies
```bash
# Production dependency
uv add package-name

# Development dependency
uv add --dev package-name

# Update dependencies
uv lock --upgrade && uv sync
```

### Adding New Sorting Options
Modify the sorting logic in `process_link()` around line 62-70. Extract new metadata from `div.xpath('.//b/text()')` array and add sorting key.

### Modifying Thread Count
Change `ThreadPoolExecutor(max_workers=5)` in `fetch_download()` around line 111. Higher values increase speed but may trigger rate limiting.

### Adjusting XPath Selectors
If Tokyo Insider changes their HTML structure, update XPath queries in:
- `okay()` for main page link extraction
- `process_link()` for download link extraction

The current selectors target class names that may change without notice.

### Adding New Tests
1. Write function-based test in `tests/test_main.py`
2. Use snapshot fixture if testing output: `def test_name(snapshot):`
3. Run `make test` to verify
4. Update snapshots if needed: `make test-update-snapshots`
5. See [Running Tests](./docs/running-tests.md) for examples

### Using Snapshot Testing
```python
def test_my_function_output(snapshot):
    """Test function output with snapshot."""
    result = my_function("input")
    assert result == snapshot  # First run creates snapshot
```

Run `make test-update-snapshots` after intentional changes.

## Makefile Usage

This project includes a comprehensive Makefile with **38 commands** for common development tasks.

### Why Use the Makefile?
- **Shorter commands**: `make test` vs `uv run pytest`
- **Consistent**: Same commands across all environments
- **Self-documenting**: `make help` shows all commands
- **Chained workflows**: Complex operations simplified

### Most Common Commands
```bash
make help          # Show all commands
make install       # Setup project
make test          # Run tests
make run           # Run application
make clean         # Clean generated files
make check         # Run all checks (test + lint + format)
```

### Full Command Categories
- **Setup**: install, install-prod
- **Testing**: test, test-verbose, test-update-snapshots, test-fast, test-watch, quick-test
- **Coverage**: coverage, coverage-html, coverage-xml
- **Quality**: lint, lint-fix, format, format-check, check
- **Running**: run, run-bleach, dev
- **Dependencies**: update, update-check, add, add-dev
- **Cleaning**: clean, clean-all
- **Build**: build, publish-test, publish
- **Documentation**: docs, docs-coverage
- **Git**: git-status, git-diff-snapshots
- **Info**: info, version, shell
- **CI/CD**: ci, ci-coverage

### Example Workflows

**Daily development:**
```bash
make install       # Start of day
make test-watch   # During development
make check        # Before commit
```

**Adding a feature:**
```bash
make test                    # Verify current state
# ... make changes ...
make test                    # Test changes
make test-update-snapshots  # Update snapshots if needed
make check                   # Final verification
```

**Debugging:**
```bash
make quick-test   # Fast import check
make shell        # Interactive Python shell
make info         # Project information
```

See [Makefile Guide](./docs/makefile-guide.md) for comprehensive documentation.

## Important Notes

### Python 3.14 Compatibility
- **typer** requires version >=0.17.0 for Python 3.14 support
- The `Parameter.make_metavar()` signature changed in Python 3.14
- Always use flexible version constraints (>=) for CLI libraries

### CLI Entry Point
The `main()` function wraps `typer.run(cli_main)` to work as a console script entry point. The actual CLI logic is in `cli_main()`.

### File Operations
- Output goes to `links.txt` in current directory
- Custom filenames use pipe delimiter: `URL|filename.ext`
- `download-scripts/` contains bash scripts that parse this format

### uv vs pip
- This project uses `uv`, not `pip`
- `pyproject.toml` replaces `requirements.txt`
- `uv.lock` ensures reproducible builds (always commit it)
- Dev dependencies in `[dependency-groups]` section

## Troubleshooting

Common issues and solutions:

| Issue | Solution |
|-------|----------|
| Import errors | Use `uv run` or activate `.venv` |
| Tests not found | Ensure files start with `test_` |
| Python 3.14 not found | Run `uv sync` (auto-installs) |
| Typer compatibility error | Ensure typer>=0.17.0 in pyproject.toml |
| CLI command not working | Rebuild: `uv sync` |

For detailed troubleshooting, see [Local Development Setup](./docs/local-development.md#troubleshooting).
