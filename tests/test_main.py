"""Function-based tests for Tokyo Downloader using pytest and syrupy."""
import pytest
from datetime import datetime
from pathlib import Path
from main import convert_size, convert_date, sort_key, save_links_to_file


# ============================================================================
# Import Tests
# ============================================================================

def test_imports():
    """Test that all main.py imports work."""
    import main
    assert hasattr(main, 'convert_size')
    assert hasattr(main, 'convert_date')
    assert hasattr(main, 'sort_key')
    assert hasattr(main, 'save_links_to_file')


# ============================================================================
# Size Conversion Tests
# ============================================================================

def test_convert_size_mb():
    """Test MB size conversion."""
    assert convert_size("100 MB") == 100.0
    assert convert_size("150.5 MB") == 150.5
    assert convert_size("1,000 MB") == 1000.0


def test_convert_size_gb():
    """Test GB to MB conversion."""
    assert convert_size("1 GB") == 1024.0
    assert convert_size("1.5 GB") == 1536.0
    assert convert_size("2.5 GB") == 2560.0


def test_convert_size_invalid():
    """Test invalid size returns 0."""
    assert convert_size("invalid") == 0
    assert convert_size("") == 0
    assert convert_size("KB") == 0


def test_convert_size_snapshot(snapshot):
    """Test size conversion with snapshot."""
    test_cases = [
        "100 MB",
        "1.5 GB",
        "2,500 MB",
        "3.14 GB",
        "invalid",
        "",
    ]

    results = {size: convert_size(size) for size in test_cases}
    assert results == snapshot


# ============================================================================
# Date Conversion Tests
# ============================================================================

def test_convert_date_valid():
    """Test valid date parsing."""
    result = convert_date("12/31/23")
    assert isinstance(result, datetime)
    assert result.year == 2023
    assert result.month == 12
    assert result.day == 31


def test_convert_date_invalid():
    """Test invalid date returns datetime.min."""
    result = convert_date("invalid")
    assert result == datetime.min

    result = convert_date("99/99/99")
    assert result == datetime.min


def test_convert_date_snapshot(snapshot):
    """Test date conversion with snapshot."""
    test_cases = [
        "01/01/20",
        "12/31/23",
        "06/15/22",
        "invalid",
        "99/99/99",
        "",
    ]

    results = {
        date: convert_date(date).isoformat() if convert_date(date) != datetime.min
        else "datetime.min"
        for date in test_cases
    }
    assert results == snapshot


# ============================================================================
# Sort Key Tests
# ============================================================================

def test_sort_key_numeric():
    """Test sort_key with numeric episode numbers."""
    assert sort_key(["url", "5", None]) == 5
    assert sort_key(["url", "10", None]) == 10
    assert sort_key(["url", "1", None]) == 1


def test_sort_key_non_numeric():
    """Test sort_key with non-numeric values."""
    result = sort_key(["url", "special", None])
    assert result == float('inf')

    result = sort_key(["url", "abc", None])
    assert result == float('inf')


def test_sort_key_snapshot(snapshot):
    """Test sort_key with snapshot."""
    test_cases = [
        ["url", "1", None],
        ["url", "5", None],
        ["url", "10", None],
        ["url", "100", None],
        ["url", "special", None],
        ["url", "ova", None],
        ["url", "abc", None],
    ]

    results = [
        {
            "input": item[1],
            "output": sort_key(item) if sort_key(item) != float('inf') else "inf"
        }
        for item in test_cases
    ]
    assert results == snapshot


# ============================================================================
# File Operations Tests
# ============================================================================

def test_save_links_plain_format(tmp_path):
    """Test saving links in plain format (no custom filenames)."""
    output_file = tmp_path / "test_links.txt"
    links = [
        ["http://example.com/file1.mkv", "1", None],
        ["http://example.com/file2.mkv", "2", None],
    ]

    save_links_to_file(links, str(output_file))

    # Verify file was created
    assert output_file.exists()

    # Verify content
    content = output_file.read_text()
    assert "http://example.com/file1.mkv" in content
    assert "http://example.com/file2.mkv" in content
    assert "|" not in content  # No pipe delimiter for plain format


def test_save_links_with_custom_names(tmp_path):
    """Test saving links with custom filenames (pipe-delimited format)."""
    output_file = tmp_path / "test_links.txt"
    links = [
        ["http://example.com/file1.mkv", "1", "anime-episode01.mkv"],
        ["http://example.com/file2.mkv", "2", "anime-episode02.mkv"],
    ]

    save_links_to_file(links, str(output_file))

    # Verify file was created
    assert output_file.exists()

    # Verify pipe-delimited format
    content = output_file.read_text()
    assert "http://example.com/file1.mkv|anime-episode01.mkv" in content
    assert "http://example.com/file2.mkv|anime-episode02.mkv" in content


def test_save_links_empty_list(tmp_path):
    """Test saving empty list creates empty file."""
    output_file = tmp_path / "test_links.txt"
    links = []

    save_links_to_file(links, str(output_file))

    # Verify file was created
    assert output_file.exists()

    # Verify content is empty
    content = output_file.read_text()
    assert content == ""


def test_save_links_snapshot(tmp_path, snapshot):
    """Test file output with snapshot."""
    output_file = tmp_path / "test_links.txt"

    # Test with various link formats
    links = [
        ["http://example.com/episode1.mkv", "1", None],
        ["http://example.com/episode2.mkv", "2", "Custom Name 02.mkv"],
        ["http://example.com/ova.mkv", "1", "OVA Special.mkv"],
        ["http://example.com/movie.mkv", "1", None],
    ]

    save_links_to_file(links, str(output_file))

    # Read and verify with snapshot
    content = output_file.read_text()
    assert content == snapshot


# ============================================================================
# Integration Tests with Snapshots
# ============================================================================

def test_sorting_workflow_snapshot(snapshot):
    """Test complete sorting workflow with different data types."""
    test_data = [
        ["url1", "5", None],
        ["url2", "1", None],
        ["url3", "10", None],
        ["url4", "special", None],
        ["url5", "2", None],
    ]

    # Sort using the sort_key function
    sorted_data = sorted(test_data, key=sort_key)

    # Convert to serializable format
    result = [
        {"url": item[0], "episode": item[1], "sort_key": sort_key(item)}
        for item in sorted_data
    ]

    # Handle infinity for snapshot
    for item in result:
        if item["sort_key"] == float('inf'):
            item["sort_key"] = "inf"

    assert result == snapshot


def test_size_comparison_snapshot(snapshot):
    """Test size comparison for sorting."""
    sizes = [
        "350.50 MB",
        "1.5 GB",
        "450.75 MB",
        "2 GB",
        "100 MB",
    ]

    results = [
        {"original": size, "converted_mb": convert_size(size)}
        for size in sizes
    ]

    # Sort by converted size
    results_sorted = sorted(results, key=lambda x: x["converted_mb"])

    assert results_sorted == snapshot


def test_date_comparison_snapshot(snapshot):
    """Test date comparison for sorting."""
    dates = [
        "12/25/23",
        "01/01/20",
        "06/15/22",
        "12/31/23",
        "03/10/21",
    ]

    results = [
        {
            "original": date,
            "parsed": convert_date(date).isoformat()
        }
        for date in dates
    ]

    # Sort by parsed date
    results_sorted = sorted(results, key=lambda x: x["parsed"])

    assert results_sorted == snapshot


# ============================================================================
# Edge Cases
# ============================================================================

def test_convert_size_edge_cases_snapshot(snapshot):
    """Test edge cases for size conversion."""
    edge_cases = [
        "0 MB",
        "0 GB",
        "0.5 MB",
        "1000000 MB",  # Very large
        "   100 MB   ",  # Whitespace
        "100MB",  # No space
        "100 mb",  # Lowercase
        "100 Mb",  # Mixed case
        "1,234.56 MB",  # Comma in number
    ]

    results = {case: convert_size(case) for case in edge_cases}
    assert results == snapshot


def test_sort_key_edge_cases_snapshot(snapshot):
    """Test edge cases for sort_key."""
    edge_cases = [
        ["url", "0", None],  # Zero
        ["url", "00001", None],  # Leading zeros
        ["url", "-1", None],  # Negative (should fail, become inf)
        ["url", "1.5", None],  # Decimal (should fail, become inf)
        ["url", "", None],  # Empty string
    ]

    results = [
        {
            "input": item[1],
            "output": sort_key(item) if sort_key(item) != float('inf') else "inf"
        }
        for item in edge_cases
    ]
    assert results == snapshot


def test_file_output_mixed_formats_snapshot(tmp_path, snapshot):
    """Test mixed format file output."""
    output_file = tmp_path / "mixed.txt"

    links = [
        ["http://example.com/ep001.mkv", "1", None],
        ["http://example.com/ep002.mkv", "2", "Episode 02.mkv"],
        ["http://example.com/ep003.mkv", "3", None],
        ["http://example.com/ep004.mkv", "4", "Episode 04 [HD].mkv"],
        ["http://example.com/special01.mkv", "special", "Special Episode.mkv"],
    ]

    save_links_to_file(links, str(output_file))
    content = output_file.read_text()

    assert content == snapshot
