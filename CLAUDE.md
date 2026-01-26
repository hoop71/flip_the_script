# LLM Assistant Guide

## Overview

Flip The Script (fts) - macOS terminal setup with Agnoster-style Starship prompt, modern CLI tools (eza, bat, fzf, zoxide), and lazy-loaded NVM for fast shell startup.

**Stack**: ZSH + Starship + Homebrew. No Oh-My-Zsh.

## Structure

```
install.sh              # Idempotent installer
zsh/zshrc              # Main config (plugins, aliases, PATH, NVM lazy-loading)
zsh/zshenv             # Minimal env vars only
starship/starship.toml # Prompt config (Agnoster colors/symbols)
~/.zshrc.local         # Machine-specific (gitignored, created by installer)
```

## Key Design Decisions

- **Starship over Agnoster**: Faster startup (~10ms vs 300ms with Oh-My-Zsh)
- **NVM lazy-loading**: Wrapper functions delay load until needed, auto-switches on `.nvmrc`
- **Symlinks**: All configs linked from repo for version control
- **Idempotent install**: Safe to re-run, backs up existing files

## Common Issues

| Issue | Fix |
|-------|-----|
| Broken icons/boxes | Install Nerd Font: `brew install --cask font-meslo-lg-nerd-font` |
| `nvm: command not found` | Expected - NVM lazy-loads. Run `load_nvm` to force load |
| Slow startup | Check: `time zsh -i -c exit` - should be < 500ms |
| Plugins not working | Check `~/.zsh/` directory exists with plugin repos |

## File Details

**install.sh**: Checks Homebrew → installs packages → installs Nerd Font → clones ZSH plugins → backs up existing configs → creates symlinks → creates `~/.zshrc.local`

**zsh/zshrc load order**:
1. Starship init
2. ZSH plugins (autosuggestions, syntax-highlighting)
3. Modern tools (fzf, zoxide)
4. Aliases
5. NVM lazy-loading (lines 58-128)
6. Additional PATH entries
7. Source `~/.zshrc.local`

**starship/starship.toml**: Format string uses powerline arrows with colors: Yellow (table flip) → Blue (#4A90E2, username) → Emerald (#50C878, directory) → Hot Pink (#FF69B4, git)

## Quick Commands

```bash
exec zsh                 # Reload shell
time zsh -i -c exit      # Check startup time
load_nvm                 # Force-load NVM
```

## Customization

- **Add alias**: Edit `zsh/zshrc` (or `~/.zshrc.local` for machine-specific)
- **Change colors**: Edit hex codes in `starship/starship.toml`
- **Add tool**: Add to `PACKAGES` array in `install.sh`, init in `zsh/zshrc`
- **Add plugin**: Clone to `~/.zsh/`, source in `zsh/zshrc`
