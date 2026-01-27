# Flip The Script `(╯°□°)╯︵ ┻━┻`

<p align="center">
  <img src="docs/public/filp_the_script_banner.png" alt="Flip The Script - Modern macOS Terminal Setup" width="800" />
</p>

<p align="center">
  <strong>Stop waiting on 5-second shell loads. Millisecond startup. Zero bloat. Pure speed.</strong>
</p>

A modern terminal setup featuring an Agnoster-inspired Starship prompt with powerline arrows, modern CLI tools, and a beautiful terminal experience.

## Features

### 🚀 Starship Prompt (Agnoster-Style)
- **Powerline aesthetics** with colored segments and arrow separators
- **Table flip emoticon** `(╯°□°)╯︵ ┻━┻` for maximum personality
- **Git status indicators** with Agnoster symbols:
  - `!` modified files
  - `+` staged files
  - `?` untracked files
  - `✘` deleted files
  - `⇡` ahead of remote
  - `⇣` behind remote
- **Color scheme**: Yellow table flip → Blue username → Emerald green directory → Hot pink git status
- **Language version badges** for Node.js, Python, Rust, Go

### 🛠 Modern CLI Tools
- **[eza](https://github.com/eza-community/eza)** - Modern `ls` replacement with icons and git integration
- **[bat](https://github.com/sharkdp/bat)** - `cat` with syntax highlighting
- **[fzf](https://github.com/junegunn/fzf)** - Fuzzy finder for history and files
- **[zoxide](https://github.com/ajeetdsouza/zoxide)** - Smarter `cd` command that learns your habits
- **[Starship](https://starship.rs)** - Blazing fast, customizable prompt

### 🎯 ZSH Enhancements
- **Fish-like autosuggestions** - Command suggestions as you type
- **Syntax highlighting** - Real-time command validation
- **Smart alias hints** - Learn shortcuts as you work (optional)
- **Curated alias library** - Git, Docker, Kubernetes shortcuts
- **Interactive CLI** - Manage your setup with `fts` command

## 📦 Installation

### Prerequisites
- macOS (or Linux with Homebrew)
- [Homebrew](https://brew.sh) installed
- ZSH as your shell

### Quick Install

```bash
# Clone the repo
git clone https://github.com/hoop71/flip_the_script.git ~/flip_the_script

# Run the install script
cd ~/flip_the_script
./install.sh

# Restart your shell
exec zsh
```

### What the install script does:

1. **Installs Homebrew packages**: starship, fzf, zoxide, eza, bat
2. **Detects Node version manager**: Offers to install FNM if neither FNM nor NVM is detected
3. **Installs Nerd Font** for icons and powerline symbols
4. **Clones ZSH plugins**: autosuggestions, syntax-highlighting
5. **Creates symlinks** for all config files:
   - `~/.zshrc` → `~/flip_the_script/zsh/zshrc`
   - `~/.zshenv` → `~/flip_the_script/zsh/zshenv`
   - `~/.config/starship.toml` → `~/flip_the_script/starship/starship.toml`
6. **Backs up** any existing configs to `~/fts_backup_[timestamp]`
7. **Creates** `~/.zshrc.local` for machine-specific configuration
8. **Adds `bin/` to PATH** for the `fts` CLI tool

## 🎨 Customization

### Starship Colors

The prompt uses these colors (defined in `starship/starship.toml`):
- Username: `#4A90E2` (Medium Blue)
- Directory: `#50C878` (Emerald Green)
- Git: `#FF69B4` (Hot Pink)

To change colors, edit the hex values in `starship/starship.toml`.

### Machine-Specific Config

Use `~/.zshrc.local` for machine-specific settings like:
- Work-specific paths
- API tokens or secrets
- Custom aliases for that machine
- SSH keys

This file is gitignored and won't be tracked.

## 📂 Structure

```
flip_the_script/
├── README.md               # You are here
├── CHANGELOG.md            # Version history
├── CONTRIBUTING.md         # Contribution guidelines
├── LICENSE                 # MIT License
├── CLAUDE.md               # LLM assistant guide
├── install.sh              # Automated setup script
├── bin/
│   └── fts                # Interactive CLI tool
├── starship/
│   └── starship.toml      # Starship prompt config (Agnoster theme)
└── zsh/
    ├── zshrc              # Main ZSH config
    ├── zshenv             # Environment variables
    ├── alias-hints.zsh    # Learning hints for aliases
    └── aliases-library.zsh # Optional aliases to enable
```

## 🔧 CLI Tool

The `fts` command provides interactive management:

```bash
fts check        # Verify setup and diagnose issues
fts aliases      # Browse available aliases
fts hint         # Get a random productivity tip
fts hints        # Toggle learning hints on/off
fts update       # Pull latest changes
fts benchmark    # Test shell startup speed
```

## 🔧 Included Aliases

### Git
- `new` - Create and checkout a new branch
- `ch` - Checkout branch
- `empty` - Create empty commit
- `gs`, `gd`, `ga`, `gc`, `gp`, `gl` - Git shortcuts (opt-in via aliases-library.zsh)

### Navigation
- `..` - Up one directory
- `...` - Up two directories
- `....` - Up three directories

### Modern CLI
- `ls` → `eza --icons`
- `ll` → `eza -l --icons --git` (detailed list with git status)
- `la` → `eza -la --icons --git` (includes hidden files)
- `lt` → `eza --tree --icons` (tree view)
- `cat` → `bat` (syntax highlighting)

### pnpm shortcuts
- `p` - pnpm
- `pi` - pnpm install
- `pb` - pnpm build
- `pd` - pnpm dev
- `pt` - pnpm test

**More aliases available**: See `zsh/aliases-library.zsh` for Docker, Kubernetes, and utility aliases you can enable.

## ⚡ Node Version Management

Flip The Script automatically detects and configures your Node version manager:

### FNM (Recommended)
**Fast Node Manager** - 10-50x faster than NVM with instant directory switching:

```bash
brew install fnm
exec zsh
```

- ✅ Instant auto-switching on directory change (< 50ms)
- ✅ No shell startup delay
- ✅ Built-in support for `.nvmrc` files

### NVM (Supported)
If you're using NVM, it's automatically detected with optimizations:

- Lazy-loaded to avoid startup performance hit
- Async auto-switching (non-blocking, won't hang your prompt)
- Works with all existing `.nvmrc` files

### Migrating from NVM to FNM
Experiencing 1+ minute hangs when changing directories? See [`docs/FNM_MIGRATION.md`](docs/FNM_MIGRATION.md) for a step-by-step migration guide.

## 🎯 Font Recommendations

For the best experience with powerline arrows and icons, use a Nerd Font:

- **MesloLGS NF** (recommended)
- **Fira Code Nerd Font**
- **JetBrains Mono Nerd Font**
- **Hack Nerd Font**

Download from [Nerd Fonts](https://www.nerdfonts.com/)

## 🤝 Contributing

Contributions welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## 📝 License

MIT License - See [LICENSE](LICENSE) for details.

## 📋 Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history.

## 🙏 Credits

- Inspired by [agnoster theme](https://github.com/agnoster/agnoster-zsh-theme)
- Built with [Starship](https://starship.rs)
- Uses modern CLI tools from the Rust ecosystem
