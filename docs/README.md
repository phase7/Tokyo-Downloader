# Tokyo Downloader Documentation

Welcome to the Tokyo Downloader documentation! This directory contains comprehensive guides for developers working on the project.

## 📚 Documentation Index

### For Developers

- **[Makefile Guide](./makefile-guide.md)** - Comprehensive Makefile reference ⭐ **Start Here**
  - Quick command reference
  - Common workflows
  - Testing shortcuts
  - Dependency management
  - CI/CD helpers

- **[Local Development Setup](./local-development.md)** - Complete guide to setting up your development environment
  - Installing uv
  - Cloning and configuring the project
  - Running the application
  - IDE integration
  - Troubleshooting

- **[Running Tests](./running-tests.md)** - Everything about testing
  - Running tests with pytest
  - Snapshot testing with syrupy
  - Test coverage reporting
  - Writing new tests
  - Best practices and debugging

### For Users

- **[README.md](../README.md)** - User-facing documentation
  - Installation instructions
  - Usage examples
  - Downloading episodes with IDM, wget, or yt-dlp

### For AI Assistants

- **[CLAUDE.md](../CLAUDE.md)** - Technical architecture and development patterns
  - Code architecture overview
  - Threading model
  - Web scraping strategy
  - Common development patterns

## 🚀 Quick Links

### Getting Started
```bash
# Install uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# Clone and setup
git clone https://github.com/phase7/Tokyo-Downloader.git
cd Tokyo-Downloader
make install

# Run the application
make run

# Run tests
make test
```

**New to the project?** Start with the [Makefile Guide](./makefile-guide.md) for quick command reference!

### Common Commands

| Task | Makefile | Direct Command |
|------|----------|----------------|
| Show all commands | `make help` | N/A |
| Install dependencies | `make install` | `uv sync` |
| Run application | `make run` | `uv run tokyo-downloader` |
| Run without cloning | N/A | `uvx --from git+https://github.com/phase7/Tokyo-Downloader tokyo-downloader` |
| Run tests | `make test` | `uv run pytest` |
| Run tests (verbose) | `make test-verbose` | `uv run pytest -v` |
| Update snapshots | `make test-update-snapshots` | `uv run pytest --snapshot-update` |
| Test coverage | `make coverage` | `uv run pytest --cov=main` |
| Add dependency | `make add PACKAGE=name` | `uv add package-name` |
| Add dev dependency | `make add-dev PACKAGE=name` | `uv add --dev package-name` |
| Update dependencies | `make update` | `uv lock --upgrade && uv sync` |
| Clean project | `make clean` | (multiple commands) |
| Run all checks | `make check` | (test + lint + format) |

**💡 Tip:** Use `make help` to see all 38 available commands!

### Quick Run (No Installation)

Run directly from GitHub without cloning or installing:

```bash
# Latest version
uvx --from git+https://github.com/phase7/Tokyo-Downloader tokyo-downloader

# Specific version/tag
uvx --from git+https://github.com/phase7/Tokyo-Downloader@v1.0.0 tokyo-downloader

# Specific commit
uvx --from git+https://github.com/phase7/Tokyo-Downloader@b10b346 tokyo-downloader
```

## 🏗️ Project Structure

```
Tokyo-Downloader/
├── docs/                   # 📖 This directory
│   ├── README.md          # Documentation index
│   ├── local-development.md
│   └── running-tests.md
├── tests/                  # 🧪 Test suite
│   ├── fixtures/          # Test data
│   ├── conftest.py        # pytest configuration
│   └── test_main.py       # Test cases
├── download-scripts/       # 🔧 Helper scripts (wget, yt-dlp)
├── main.py                # 🐍 Main application
├── pyproject.toml         # 📦 Project configuration
├── uv.lock                # 🔒 Dependency lock file
├── .python-version        # 🐍 Python 3.14
├── CLAUDE.md              # 🤖 AI assistant guide
└── README.md              # 📘 User documentation
```

## 🛠️ Technology Stack

| Component | Technology | Purpose |
|-----------|-----------|---------|
| Package Manager | [uv](https://docs.astral.sh/uv/) | Fast, reliable dependency management |
| Python Version | 3.14 | Latest stable Python release |
| CLI Framework | [typer](https://typer.tiangolo.com/) | Command-line interface |
| Web Scraping | [BeautifulSoup4](https://www.crummy.com/software/BeautifulSoup/) + [lxml](https://lxml.de/) | HTML parsing and XPath queries |
| HTTP Client | [requests](https://requests.readthedocs.io/) | Web requests |
| User Input | [inquirer](https://github.com/magmax/python-inquirer) | Interactive prompts |
| Testing | [pytest](https://docs.pytest.org/) | Test framework |
| HTTP Mocking | [responses](https://github.com/getsentry/responses) | Mock HTTP requests in tests |

## 📖 Documentation Guide

### When to Read What

**New to the project?**
1. Start with [Local Development Setup](./local-development.md)
2. Read [CLAUDE.md](../CLAUDE.md) for architecture overview
3. Check [Running Tests](./running-tests.md) before making changes

**Adding a feature?**
1. Review [CLAUDE.md](../CLAUDE.md) for patterns
2. Check [Running Tests](./running-tests.md) for test examples
3. Update [README.md](../README.md) if user-facing

**Fixing a bug?**
1. Add a test case in [Running Tests](./running-tests.md)
2. Use debugging techniques from test docs
3. Verify fix with `uv run pytest`

**Setting up CI/CD?**
1. Review test configuration in [Running Tests](./running-tests.md)
2. Use GitHub Actions example provided
3. Ensure `uv.lock` is committed

## 🤝 Contributing

### Development Workflow

1. **Setup**
   ```bash
   git clone <repo-url>
   cd Tokyo-Downloader
   uv sync
   ```

2. **Create Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make Changes**
   - Write code
   - Add tests
   - Run tests: `uv run pytest`

4. **Commit**
   ```bash
   git add .
   git commit -m "Description of changes"
   ```

5. **Push and PR**
   ```bash
   git push origin feature/your-feature-name
   ```

### Testing Requirements

- All new features must have tests
- Existing tests must pass: `uv run pytest`
- Aim for >70% code coverage

### Code Style

This project uses:
- Clear, descriptive variable names
- Docstrings for non-obvious functions
- Type hints encouraged but not required

## 🐛 Troubleshooting

### Quick Fixes

| Problem | Solution |
|---------|----------|
| `uv: command not found` | Add to PATH: `export PATH="$HOME/.local/bin:$PATH"` |
| Import errors | Use `uv run` or activate venv first |
| Tests not found | Ensure files/functions start with `test_` |
| Python 3.14 not found | Run `uv sync` (auto-installs) |

See [Local Development Setup](./local-development.md#troubleshooting) for detailed solutions.

## 📊 Project Statistics

- **Lines of Code**: ~220 (single-file design)
- **Test Cases**: 11 smoke tests
- **Dependencies**: 5 production, 3 development
- **Python Version**: 3.14
- **Test Coverage**: ~60% (expanding)

## 🔗 External Resources

- [uv Documentation](https://docs.astral.sh/uv/)
- [pytest Documentation](https://docs.pytest.org/)
- [Python 3.14 Release Notes](https://docs.python.org/3.14/whatsnew/3.14.html)
- [Tokyo Insider](https://www.tokyoinsider.com/) (anime download source)

## 📝 Changelog

### Recent Updates

- **2024-01** - Migrated from pip to uv package manager
- **2024-01** - Added Python 3.14 support
- **2024-01** - Added pytest-based testing infrastructure
- **2024-01** - Created CLI entry point (`tokyo-downloader` command)
- **2024-01** - Added comprehensive documentation

## 💡 Tips

- Use `uv run` for one-off commands without activating venv
- Check `uv.lock` into git for reproducible builds
- Run tests before committing: `uv run pytest`
- Use `--help` flag: `uv run tokyo-downloader --help`
- Read fixture HTML in `tests/fixtures/` to understand structure

## 🎯 Next Steps

Recommended improvements:
- [ ] Add integration tests with HTTP mocking
- [ ] Set up GitHub Actions CI/CD
- [ ] Increase test coverage to >80%
- [ ] Add type hints throughout codebase
- [ ] Create pre-commit hooks
- [ ] Publish to PyPI for `uvx` support

## 📧 Support

- **Issues**: [GitHub Issues](https://github.com/phase7/Tokyo-Downloader/issues)
- **Discord**: x5oc (project maintainer)

---

*Last updated: January 2024*
