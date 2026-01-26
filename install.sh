#!/usr/bin/env bash

set -e

FTS_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/fts_backup_$(date +%Y%m%d_%H%M%S)"

echo "==> Installing Flip The Script from $FTS_DIR"

# Install Homebrew packages
echo "==> Installing Homebrew packages"
if ! command -v brew &> /dev/null; then
  echo "    Homebrew not found. Install from https://brew.sh first"
  exit 1
fi

PACKAGES=(starship fzf zoxide eza bat)
for pkg in "${PACKAGES[@]}"; do
  if brew list "$pkg" &> /dev/null; then
    echo "    ✓ $pkg already installed"
  else
    echo "    Installing $pkg..."
    brew install "$pkg"
  fi
done

# Check for Nerd Font (required for icons)
echo "==> Checking for Nerd Font"
NERD_FONT_INSTALLED=false
NERD_FONT_CASK="font-meslo-lg-nerd-font"

# Check if any Nerd Font is installed via Homebrew
if brew list --cask 2>/dev/null | grep -q "nerd-font"; then
  NERD_FONT_INSTALLED=true
  echo "    ✓ Nerd Font already installed"
fi

# Also check system fonts directory
if [[ "$NERD_FONT_INSTALLED" == "false" ]]; then
  if ls ~/Library/Fonts/*[Nn]erd* /Library/Fonts/*[Nn]erd* 2>/dev/null | grep -q .; then
    NERD_FONT_INSTALLED=true
    echo "    ✓ Nerd Font found in system fonts"
  fi
fi

if [[ "$NERD_FONT_INSTALLED" == "false" ]]; then
  echo "    ⚠ No Nerd Font detected (required for terminal icons)"
  read -p "    Install $NERD_FONT_CASK? [y/N] " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "    Installing $NERD_FONT_CASK..."
    brew install --cask "$NERD_FONT_CASK"
    echo ""
    echo "    ✓ Font installed! Configure your terminal to use 'MesloLGS Nerd Font'"
  else
    echo "    Skipped. Install a Nerd Font later for icons to display correctly:"
    echo "      brew install --cask font-meslo-lg-nerd-font"
  fi
fi

# Install zsh plugins
echo "==> Installing zsh plugins"
ZSH_PLUGINS_DIR="$HOME/.zsh"
mkdir -p "$ZSH_PLUGINS_DIR"

if [[ ! -d "$ZSH_PLUGINS_DIR/zsh-autosuggestions" ]]; then
  echo "    Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_PLUGINS_DIR/zsh-autosuggestions"
else
  echo "    ✓ zsh-autosuggestions already installed"
fi

if [[ ! -d "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting" ]]; then
  echo "    Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting"
else
  echo "    ✓ zsh-syntax-highlighting already installed"
fi

# Backup existing files that aren't symlinks
backup_if_exists() {
  local file=$1
  if [[ -e "$file" && ! -L "$file" ]]; then
    echo "    Backing up existing $file"
    mkdir -p "$BACKUP_DIR"
    mv "$file" "$BACKUP_DIR/"
  fi
}

# Create symlink
link_file() {
  local src=$1
  local dest=$2
  backup_if_exists "$dest"
  ln -sf "$src" "$dest"
  echo "    Linked $dest -> $src"
}

# Link zsh configs
echo "==> Linking zsh configs"
link_file "$FTS_DIR/zsh/zshrc" "$HOME/.zshrc"
link_file "$FTS_DIR/zsh/zshenv" "$HOME/.zshenv"

# Link starship config
echo "==> Linking starship config"
mkdir -p "$HOME/.config"
link_file "$FTS_DIR/starship/starship.toml" "$HOME/.config/starship.toml"

# Create .zshrc.local if it doesn't exist
if [[ ! -f "$HOME/.zshrc.local" ]]; then
  echo "==> Creating ~/.zshrc.local for machine-specific config"
  cat > "$HOME/.zshrc.local" << 'LOCALEOF'
# Machine-specific zsh config (gitignored)
# Add your secrets, work-specific PATH, aliases, etc. here

# Example:
# export WORK_VPN_TOKEN="..."
# export PATH="/opt/work/bin:$PATH"
LOCALEOF
  echo "    Created ~/.zshrc.local"
else
  echo "==> ~/.zshrc.local already exists, skipping"
fi

# Setup fts CLI
echo "==> Setting up fts CLI"
chmod +x "$FTS_DIR/bin/fts"
if ! grep -q "$FTS_DIR/bin" "$HOME/.zshrc.local" 2>/dev/null; then
  echo "export PATH=\"$FTS_DIR/bin:\$PATH\"" >> "$HOME/.zshrc.local"
  echo "    Added to PATH"
fi

# Enable learning hints
echo "==> Enable learning hints?"
echo "    This shows occasional tips about shortcuts as you work (e.g., 'Use gs instead of git status')"
read -p "    Enable hints? [y/N] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  touch "$HOME/.fts_hints"
  echo "    ✓ Learning hints enabled! Run 'fts hint' anytime"
else
  echo "    Hints disabled. Enable later with: fts hints"
fi

echo ""
echo "==> Done! Restart your shell or run: exec zsh"
if [[ -d "$BACKUP_DIR" ]]; then
  echo "    Old configs backed up to: $BACKUP_DIR"
fi
echo ""
echo "    Next steps:"
echo "    - Set your terminal font to a Nerd Font for icons"
echo "    - Run 'fts check' to verify everything works"
echo "    - Run 'fts hint' to see productivity tips"
echo "    - Run 'fts aliases' to browse available shortcuts"
