# Migrating from NVM to FNM

## Why Switch?

**FNM (Fast Node Manager)** is a Rust-based Node version manager that's 10-50x faster than NVM:

| Operation | NVM | FNM |
|-----------|-----|-----|
| Directory change with .nvmrc | 1-60+ seconds | < 50ms |
| Shell startup | 300-500ms | < 10ms |
| Switching versions | Slow | Instant |

If you experience hangs when changing directories (like `cd ~/project` taking 1+ minutes), FNM solves this.

## Before You Start

Check what you have installed:

```bash
# Check for NVM
ls -la ~/.nvm

# Check for FNM
fnm --version

# List your current Node versions (NVM)
nvm list
```

## Migration Steps

### 1. Install FNM

```bash
brew install fnm
```

### 2. Migrate Your Node Versions

FNM and NVM store Node versions separately. You have two options:

**Option A: Let FNM auto-install (recommended)**
- FNM will automatically install Node versions when it encounters `.nvmrc` files
- Just navigate to your projects and FNM handles it

**Option B: Manually install specific versions**

```bash
# List versions you have in NVM
nvm list

# Install them in FNM
fnm install 20.11.0
fnm install 18.19.0
fnm install 16.20.0

# Set a default version
fnm default 20.11.0
```

### 3. Update Your Shell Config

**If you installed via Flip The Script:**
- The zshrc automatically detects FNM and uses it
- Just reload your shell: `exec zsh`

**If you have custom NVM config:**

Remove your old NVM config and add:

```bash
# Add to ~/.zshrc
eval "$(fnm env --use-on-cd)"
```

### 4. Test It Works

```bash
# Reload shell
exec zsh

# Check Node is available
node --version

# Navigate to a project with .nvmrc
cd ~/your-project

# Should auto-switch instantly (check version changes)
node --version
```

### 5. (Optional) Remove NVM

After confirming FNM works for all your projects:

```bash
# Backup NVM directory (just in case)
mv ~/.nvm ~/.nvm.backup

# Remove NVM from shell config
# (already handled by Flip The Script's auto-detection)

# Later, if everything works:
rm -rf ~/.nvm.backup
```

## Command Equivalents

| Task | NVM | FNM |
|------|-----|-----|
| List installed versions | `nvm list` | `fnm list` |
| Install a version | `nvm install 20` | `fnm install 20` |
| Use a version | `nvm use 20` | `fnm use 20` |
| Set default version | `nvm alias default 20` | `fnm default 20` |
| List available versions | `nvm list-remote` | `fnm list-remote` |
| Current version | `nvm current` | `fnm current` |

## Troubleshooting

### "command not found: node" after switching

**Cause:** FNM not initialized in your shell

**Fix:**
```bash
# Check if FNM is in your PATH
which fnm

# If not found, add to ~/.zshrc:
eval "$(fnm env --use-on-cd)"

# Reload
exec zsh
```

### Slow directory changes persist

**Cause:** Still using NVM instead of FNM

**Fix:**
```bash
# Check which version manager is active
type node

# Should say "node is ~/.local/share/fnm/..."
# If it says "node is a shell function" -> still using NVM

# Make sure FNM is installed
brew install fnm

# Reload shell
exec zsh
```

### Global npm packages not found

**Cause:** Each version manager has separate global package storage

**Fix:**
```bash
# Re-install global packages with FNM
npm list -g --depth=0  # See what you had

# Install what you need
npm install -g pnpm yarn typescript
```

### Project still uses wrong Node version

**Cause:** No `.nvmrc` file in project, or FNM not configured for auto-switching

**Fix:**
```bash
# Add .nvmrc to your project
echo "20.11.0" > .nvmrc

# Make sure auto-switching is enabled (should be by default)
fnm env --use-on-cd
```

## Keeping Both NVM and FNM

You can keep both installed. Flip The Script automatically uses FNM if available, otherwise falls back to NVM.

This is useful if:
- You're testing FNM before fully committing
- Different projects require different version managers
- You have legacy scripts that rely on NVM

To switch between them:

```bash
# Use FNM (default if installed)
eval "$(fnm env --use-on-cd)"

# Use NVM (remove FNM from PATH temporarily)
export PATH=$(echo $PATH | tr ':' '\n' | grep -v fnm | tr '\n' ':')
source "$NVM_DIR/nvm.sh"
```

## Performance Comparison

Before (NVM):
```bash
$ time (cd ~/code/yurts/platform-fe && pwd)
/Users/matt/code/yurts/platform-fe
1.08s user 0.32s system 89% cpu 1.567 total
```

After (FNM):
```bash
$ time (cd ~/code/yurts/platform-fe && pwd)
/Users/matt/code/yurts/platform-fe
0.01s user 0.01s system 45% cpu 0.045 total
```

**35x faster!**

## Resources

- [FNM GitHub](https://github.com/Schniz/fnm)
- [FNM Documentation](https://github.com/Schniz/fnm/blob/master/docs/commands.md)
- [Why FNM is faster](https://github.com/Schniz/fnm#features)
