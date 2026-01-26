# Changelog

All notable changes to this project will be documented in this file.

Format based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), versioning follows [Semantic Versioning](https://semver.org/).

## [1.0.0] - 2026-01-25

Initial public release.

### Added
- Starship prompt with Agnoster theme (powerline arrows, git status, table flip)
- Modern CLI tools: eza, bat, fzf, zoxide
- ZSH plugins: autosuggestions, syntax-highlighting
- NVM lazy-loading with auto `.nvmrc` detection
- Automated install script with backup and Nerd Font installation
- Machine-specific config support (`~/.zshrc.local`)
- Comprehensive documentation (README, CLAUDE.md, CONTRIBUTING.md)
- MIT License

### Features
- Fast shell startup (<500ms with lazy NVM)
- Idempotent installer (safe to re-run)
- Symlinked configs for easy version control
- Git, pnpm, navigation aliases

[1.0.0]: https://github.com/hoop71/flip_the_script/releases/tag/v1.0.0
