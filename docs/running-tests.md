# Running Tests

Tokyo Downloader uses [pytest](https://docs.pytest.org/) for testing. This guide covers everything you need to know about running and writing tests.

## Quick Start

### Run All Tests

```bash
uv run pytest
```

### Run Tests with Verbose Output

```bash
uv run pytest -v
```

### Run Specific Test File

```bash
uv run pytest tests/test_main.py
```

### Run Specific Test Class

```bash
uv run pytest tests/test_main.py::TestUtilityFunctions
```

### Run Specific Test

```bash
uv run pytest tests/test_main.py::TestUtilityFunctions::test_convert_size_mb
```

## Test Coverage

### Current Coverage

The project currently has **11 smoke tests** covering core functionality:

- ✅ Import verification
- ✅ Size conversion (MB, GB)
- ✅ Date parsing
- ✅ Sorting logic
- ✅ File output (plain and custom names)

### Running Tests with Coverage

First, add pytest-cov:
```bash
uv add --dev pytest-cov
```

Then run:
```bash
# Basic coverage report
uv run pytest --cov=main

# HTML coverage report
uv run pytest --cov=main --cov-report=html

# Open in browser (macOS)
open htmlcov/index.html
```

Example output:
```
---------- coverage: platform darwin, python 3.14.2 -----------
Name      Stmts   Miss  Cover
-----------------------------
main.py     120     45    62%
-----------------------------
TOTAL       120     45    62%
```

## Test Structure

### Directory Layout

```
tests/
├── __init__.py            # Marks tests as a package
├── conftest.py            # Shared fixtures and configuration
├── fixtures/              # Test data
│   ├── __init__.py
│   ├── main_page.html     # Sample Tokyo Insider main page
│   └── episode_page.html  # Sample episode detail page
└── test_main.py           # Test cases
```

### Test Organization

Tests are organized into classes by functionality:

```python
class TestUtilityFunctions:
    """Test utility functions."""
    def test_convert_size_mb(self): ...
    def test_convert_size_gb(self): ...
    # ...

class TestFileOperations:
    """Test file operations."""
    def test_save_links_plain_format(self): ...
    def test_save_links_with_custom_names(self): ...
    # ...
```

## Available Fixtures

Fixtures are defined in `tests/conftest.py`:

### `fixtures_dir`
Path to the test fixtures directory.

```python
def test_example(fixtures_dir):
    html_file = fixtures_dir / "main_page.html"
    assert html_file.exists()
```

### `sample_main_page_html`
Sample Tokyo Insider main page HTML.

```python
def test_example(sample_main_page_html):
    assert '<div class="download-link">' in sample_main_page_html
```

### `sample_episode_page_html`
Sample episode detail page HTML.

```python
def test_example(sample_episode_page_html):
    assert 'class="c_h2"' in sample_episode_page_html
```

### `temp_output_file`
Temporary file path for testing file operations.

```python
def test_example(temp_output_file):
    # Write to temp file
    temp_output_file.write_text("test content")
    # File is automatically cleaned up after test
```

## Writing New Tests

### Basic Test Structure

```python
def test_function_name():
    """Test description."""
    # Arrange - Set up test data
    input_value = "100 MB"

    # Act - Call the function
    result = convert_size(input_value)

    # Assert - Check the result
    assert result == 100.0
```

### Using Fixtures

```python
def test_with_fixture(temp_output_file):
    """Test using a fixture."""
    # Use the fixture
    content = "line1\nline2"
    temp_output_file.write_text(content)

    # Verify
    assert temp_output_file.read_text() == content
```

### Testing Exceptions

```python
def test_invalid_input():
    """Test that invalid input raises an error."""
    with pytest.raises(ValueError):
        some_function("invalid")
```

### Parametrized Tests

Test multiple inputs efficiently:

```python
import pytest

@pytest.mark.parametrize("input,expected", [
    ("100 MB", 100.0),
    ("1 GB", 1024.0),
    ("1.5 GB", 1536.0),
])
def test_convert_size_multiple(input, expected):
    """Test multiple size conversions."""
    assert convert_size(input) == expected
```

## Mocking HTTP Requests

For tests that need to mock web requests, use the `responses` library:

```python
import responses

@responses.activate
def test_fetch_page():
    """Test fetching a web page."""
    # Mock HTTP response
    responses.add(
        responses.GET,
        "https://www.tokyoinsider.com/test",
        body="<html>test</html>",
        status=200
    )

    # Make request
    import requests
    resp = requests.get("https://www.tokyoinsider.com/test")

    # Verify
    assert resp.status_code == 200
    assert "test" in resp.text
```

## Test Configuration

Configuration is in `pyproject.toml`:

```toml
[tool.pytest.ini_options]
testpaths = ["tests"]              # Where to find tests
python_files = ["test_*.py"]       # Test file pattern
python_classes = ["Test*"]         # Test class pattern
python_functions = ["test_*"]      # Test function pattern
addopts = "-v --tb=short"          # Default options
```

### Common pytest Options

- `-v` - Verbose output (show each test)
- `-s` - Show print statements
- `-x` - Stop on first failure
- `-k "pattern"` - Run tests matching pattern
- `--tb=short` - Shorter traceback format
- `--tb=long` - Detailed traceback
- `--collect-only` - List tests without running

### Examples

```bash
# Stop on first failure
uv run pytest -x

# Show print statements
uv run pytest -s

# Run tests with "size" in name
uv run pytest -k size

# Run tests in parallel (requires pytest-xdist)
uv run pytest -n auto
```

## Continuous Integration

### GitHub Actions Example

Create `.github/workflows/test.yml`:

```yaml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v4

    - name: Install uv
      run: curl -LsSf https://astral.sh/uv/install.sh | sh

    - name: Install dependencies
      run: uv sync

    - name: Run tests
      run: uv run pytest -v

    - name: Run tests with coverage
      run: uv run pytest --cov=main --cov-report=xml

    - name: Upload coverage
      uses: codecov/codecov-action@v4
      with:
        file: ./coverage.xml
```

## Best Practices

### 1. Test Naming

- Use descriptive names: `test_convert_size_handles_gb_correctly`
- Prefix with `test_`
- Include what you're testing and expected behavior

### 2. Test Independence

- Each test should be independent
- Don't rely on test execution order
- Use fixtures for shared setup

### 3. Arrange-Act-Assert Pattern

```python
def test_example():
    # Arrange - Set up
    input_data = setup_test_data()

    # Act - Execute
    result = function_under_test(input_data)

    # Assert - Verify
    assert result == expected_value
```

### 4. Test One Thing

- Each test should verify one specific behavior
- Multiple assertions are OK if testing the same behavior

### 5. Use Fixtures for Common Setup

```python
@pytest.fixture
def sample_data():
    """Create sample data for tests."""
    return {"key": "value"}

def test_one(sample_data):
    assert sample_data["key"] == "value"

def test_two(sample_data):
    assert "key" in sample_data
```

## Debugging Tests

### Print Debugging

Use `-s` flag to see print statements:

```python
def test_debug():
    value = calculate_something()
    print(f"Debug: value={value}")  # Will show with -s flag
    assert value > 0
```

```bash
uv run pytest -s tests/test_main.py::test_debug
```

### Using pytest Breakpoints

```python
def test_with_breakpoint():
    value = calculate_something()
    pytest.set_trace()  # Drops into debugger
    assert value > 0
```

### Using Python Debugger

```python
def test_with_pdb():
    import pdb
    value = calculate_something()
    pdb.set_trace()  # Python debugger
    assert value > 0
```

## Common Issues

### Issue: Tests not discovered

**Cause:** File or function naming doesn't match pytest patterns.

**Solution:** Ensure:
- Test files start with `test_`
- Test functions start with `test_`
- Test classes start with `Test`

### Issue: Import errors

**Cause:** Python path not set correctly.

**Solution:** Run tests with `uv run`:
```bash
uv run pytest
```

### Issue: Fixture not found

**Cause:** Fixture not defined or in wrong file.

**Solution:**
- Check fixtures are in `conftest.py` or the test file
- Verify fixture name matches exactly

### Issue: Tests pass locally but fail in CI

**Cause:** Environment differences.

**Solution:**
- Check Python versions match
- Ensure all dependencies are in `pyproject.toml`
- Use `uv lock` to lock dependency versions

## Expanding Test Coverage

### Areas to Add Tests

Current smoke tests cover basic utilities. Consider adding:

1. **HTTP Mocking Tests**
   - Mock `requests.get()` calls
   - Test `okay()` function with sample HTML
   - Test `process_link()` with mocked responses

2. **Integration Tests**
   - Test full workflow end-to-end
   - Verify `links.txt` output format

3. **Edge Cases**
   - Empty episode lists
   - Invalid URLs
   - Network timeouts
   - Malformed HTML

4. **Custom Filename Feature**
   - Test template formatting
   - Test variable substitution
   - Test episode number padding

### Example: Adding HTTP Mock Test

```python
import responses

@responses.activate
def test_process_link_with_mock(sample_episode_page_html):
    """Test process_link with mocked HTTP response."""
    # Setup mock
    url = "https://www.tokyoinsider.com/anime/Test/episode/1"
    responses.add(
        responses.GET,
        url,
        body=sample_episode_page_html,
        status=200
    )

    # Test
    from main import process_link
    choice = "Biggest Size"
    name_template = "0"
    total_eps = {"episode": 2}

    # Call function (it will use mocked response)
    process_link(choice, url, name_template, total_eps)

    # Verify (check queue or output)
    # ...
```

## Next Steps

- Add more tests to increase coverage
- Set up CI/CD with GitHub Actions
- Add integration tests for full workflows
- Consider property-based testing with Hypothesis

## Resources

- [pytest Documentation](https://docs.pytest.org/)
- [pytest Fixtures](https://docs.pytest.org/en/stable/fixture.html)
- [responses Library](https://github.com/getsentry/responses)
- [Coverage.py](https://coverage.readthedocs.io/)
