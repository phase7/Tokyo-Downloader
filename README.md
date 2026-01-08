Since im rarely on github you can contact me on discord if anything needed. Username: x5oc

# Tokyo Downloader
## 📌 Overview

Tokyo Downloader is a Python-based tool that fetches download links for anime Episodes/OVAs/Movies/Specials from **Tokyo Insider**. The extracted links are saved in a text file for easy bulk downloading using any download manager such as **Internet Download Manager (IDM)**, **wget**, and **yt-dlp**.

## 🚀 Features

- Fetches Episode/OVA/Movies/Special episode download links automatically.
- Allows users to select a range of episodes.
- Supports sorting options:
  - **Biggest Size**: Selects the largest file.
  - **Most Downloaded**: Picks the most downloaded file.
  - **Latest**: Chooses the most recent file.
- Uses **multi-threading** for faster processing.
- Saves links as a linebreak separated list in `links.txt` for use with download managers (e.g. IDM).
- Available as both an **executable file** and an **open-source Python script**.

## 📥 Installation

### Prerequisites

This project uses [uv](https://docs.astral.sh/uv/) for fast, reliable dependency management. Install it first:

```sh
# macOS/Linux
curl -LsSf https://astral.sh/uv/install.sh | sh

# Or with Homebrew
brew install uv

# Windows
powershell -ExecutionPolicy BypassUser -c "irm https://astral.sh/uv/install.ps1 | iex"
```

### Option 1: Run with uv (Recommended)

Clone and run directly:

```sh
git clone https://github.com/phase7/Tokyo-Downloader.git
cd Tokyo-Downloader
uv run tokyo-downloader
```

### Option 2: One-time execution with uvx (from Git)

Run directly from GitHub without cloning or installing:

```sh
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

```sh
uvx tokyo-downloader
```

### Option 3: Traditional development setup

```sh
git clone https://github.com/phase7/Tokyo-Downloader.git
cd Tokyo-Downloader
uv venv
source .venv/bin/activate  # Linux/Mac
# .venv\Scripts\activate   # Windows
uv sync
tokyo-downloader
```

### Option 4: Download the Executable for Windows (No Installation Needed)

- Download the `.exe` version from [here](https://github.com/phase7/Tokyo-Downloader/releases).
- Run the executable file.
- Follow the on-screen prompts.

## 🔧 Usage

Run the script with:

```sh
# Interactive mode (prompts for URL)
tokyo-downloader

# Or with URL argument
tokyo-downloader --url "https://www.tokyoinsider.com/anime/B/Bleach_(TV)"
```

### Steps:

1. Enter the anime URL (e.g., *Solo Leveling* page on Tokyo Insider).
2. Select the range of episodes/OVAs/movies/specials (0 For none) to download. It is required to input a range (ie. `1-1`) if not `0`.
3. Choose sorting criteria (**Biggest Size**, **Most Downloaded**, **Latest**).
4. The script fetches and saves links in `links.txt`.

### Example Output:

```sh
Url [https://www.tokyoinsider.com/anime/B/Bleach_(TV)]:
>>> extracting links from main page...
Anime name:
> Bleach <
406 Episodes found - select a range to download (0: None) [1-406]: 1-2
3 OVAs found - select a range to download (0: None) [1-3]: 1-3
6 Specials found - select a range to download (0: None) [1-6]: 0
4 Movies found - select a range to download (0: None) [1-4]: 1-1
[?] Select the download type:
   Biggest Size
 > Most Downloaded
   Latest

>>> fetching...
>>> ['ova: 10', '14.10 MB', '473', 'bleachfanclarkey', '02/11/12', 'Success']
>>> ['ova: 2', '200.02 MB', '382', 'sifsif', '09/13/11', 'Success']
>>> ['ova: 1', '198.00 MB', '318', 'sifsif', '09/20/11', 'Success']
>>> ['movie: 1', '598.49 MB', '806', 'andrai', '11/15/10', 'Success']
>>> ['episode: 2', '175.39 MB', '4409', 'Anonymous', '05/03/10', 'Faild no valid link']
>>> ['episode: 1', '130.82 MB', '11457', 'Anonymous', '05/03/10', 'Success']
✅ Links successfully saved to links.txt
```

## 📂 Downloading Episodes from Links

### IDM

1. Open **Internet Download Manager (IDM)**.
2. Click **Tasks** (top-left menu) > **Import** > **From text file**.
3. Select `links.txt` and start downloading episodes in bulk!

### wget and yt-dlp

While in the same folder as the `links.txt`, run the command for your preferred tool:

```sh
wget --read-timeout 60 -i links.txt
```

```sh
yt-dlp -a links.txt
```

If you chose to use custom names for the files, use one of the scripts in `download-scripts` instead.

It is suggested to move the `links.txt` into the folder you want the videos to be downloaded to before running the command.

## 📜 License

This script is for **educational purposes only**. Use responsibly and follow copyright laws.

## 📚 Documentation

For developers:
- **[Local Development Setup](./docs/local-development.md)** - Set up your development environment
- **[Running Tests](./docs/running-tests.md)** - Complete testing guide
- **[Documentation Index](./docs/README.md)** - Full documentation overview

## 🤝 Contributions

Feel free to report issues or suggest improvements! See our [developer documentation](./docs/) for setup instructions.

