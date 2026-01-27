# LLM Assistant Guide

## Overview

Flip The Script (fts) - macOS terminal setup with Agnoster-style Starship prompt, modern CLI tools (eza, bat, fzf, zoxide), and fast Node version management (FNM recommended, NVM supported).

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
- **FNM over NVM**: 10-50x faster Node version switching (< 50ms vs 1+ min). NVM still supported with async auto-switching for backward compatibility.
- **Auto-detection**: Automatically uses FNM if installed, falls back to NVM
- **Symlinks**: All configs linked from repo for version control
- **Idempotent install**: Safe to re-run, backs up existing files

## Common Issues

| Issue | Fix |
|-------|-----|
| Broken icons/boxes | Install Nerd Font: `brew install --cask font-meslo-lg-nerd-font` |
| `node: command not found` | No Node version manager. Run `brew install fnm` then `exec zsh` |
| Slow directory changes (1+ min) | You're using NVM. Switch to FNM: see `docs/FNM_MIGRATION.md` |
| `nvm: command not found` | Expected with lazy-loading. Run `load_nvm` or switch to FNM |
| Slow startup | Check: `time zsh -i -c exit` - should be < 500ms |
| Plugins not working | Check `~/.zsh/` directory exists with plugin repos |

## File Details

**install.sh**: Checks Homebrew → installs packages → installs Nerd Font → clones ZSH plugins → backs up existing configs → creates symlinks → creates `~/.zshrc.local`

**zsh/zshrc load order**:
1. Starship init
2. ZSH plugins (autosuggestions, syntax-highlighting)
3. Modern tools (fzf, zoxide)
4. Aliases
5. Node version manager (auto-detects FNM or NVM)
   - FNM: Native `--use-on-cd` (instant switching)
   - NVM: Lazy-loading with async auto-switch (non-blocking)
6. Additional PATH entries
7. Source `~/.zshrc.local`

**starship/starship.toml**: Format string uses powerline arrows with colors: Yellow (table flip) → Blue (#4A90E2, username) → Emerald (#50C878, directory) → Hot Pink (#FF69B4, git)

## Quick Commands

```bash
exec zsh                 # Reload shell
time zsh -i -c exit      # Check startup time (should be < 500ms)
fnm list                 # List installed Node versions (FNM)
fnm install 20           # Install Node 20 (FNM)
load_nvm                 # Force-load NVM (if using NVM)
nvm list                 # List installed Node versions (NVM)
```

## Node Version Management

**Auto-detection**: The config automatically detects which version manager you have installed:

1. **FNM (recommended)**: If `fnm` command exists
   - Uses native `fnm env --use-on-cd` for instant switching
   - No blocking, no delays when changing directories
   - Install: `brew install fnm`

2. **NVM (fallback)**: If `~/.nvm` directory exists
   - Lazy-loads on first `node`/`npm`/`nvm` command
   - Async auto-switching on directory change (non-blocking)
   - Projects auto-install Node versions from `.nvmrc`

**Migration**: If you're experiencing slow directory changes with NVM (1+ minutes), see `docs/FNM_MIGRATION.md` for how to switch to FNM.

**Both installed**: FNM takes priority. Remove FNM from PATH to use NVM instead.

## Customization

- **Add alias**: Edit `zsh/zshrc` (or `~/.zshrc.local` for machine-specific)
- **Change colors**: Edit hex codes in `starship/starship.toml`
- **Add tool**: Add to `PACKAGES` array in `install.sh`, init in `zsh/zshrc`
- **Add plugin**: Clone to `~/.zsh/`, source in `zsh/zshrc`
