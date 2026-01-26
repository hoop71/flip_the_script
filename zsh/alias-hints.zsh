# Alias Hints - Learn shortcuts as you work
# Suggests aliases when you type the full command

# Only run if hints are enabled
HINTS_FILE="$HOME/.fts_hints"
[[ ! -f "$HINTS_FILE" ]] && return

# Show random hint on startup (50% chance)
if [[ $((RANDOM % 2)) -eq 0 ]]; then
  HINT_LIST=(
    "Use 'z <dirname>' instead of 'cd' - it learns your most-used directories"
    "Press Ctrl+R to fuzzy search your command history"
    "Type 'll' for a detailed file list with git status"
    "Use 'lt' to see a tree view of directories"
    "Try 'empty \"message\"' to create an empty git commit"
    "Use 'new branch-name' to create and checkout a git branch"
    "Press Ctrl+T to fuzzy find files in current directory"
    "Type '..' to go up one directory, '...' for two"
    "Run 'fts check' to verify your setup"
    "Run 'fts aliases' to see all available shortcuts"
  )
  local random_hint=${HINT_LIST[$RANDOM % ${#HINT_LIST[@]}]}
  echo -e "\033[0;36m💡\033[0m $random_hint"
fi

# Track last suggestion to avoid spam
typeset -g LAST_HINT_TIME=0
typeset -g HINT_COOLDOWN=300  # 5 minutes between hints

# Alias suggestion mappings
typeset -A ALIAS_HINTS
ALIAS_HINTS=(
  # Git
  'git status'           'gs'
  'git diff'             'gd'
  'git diff --cached'    'gdc'
  'git add'              'ga'
  'git commit'           'gc'
  'git commit -m'        'gcm'
  'git push'             'gp'
  'git pull'             'gpl'
  'git checkout'         'ch or gco'
  'git checkout -b'      'new'
  'git branch'           'gb'
  'git log'              'gl'
  'git stash'            'gst'

  # Docker
  'docker'               'd'
  'docker-compose'       'dc'
  'docker ps'            'dps'
  'docker images'        'di'
  'docker exec -it'      'dex'
  'docker logs'          'dlog'

  # Kubernetes
  'kubectl'              'k'
  'kubectl get pods'     'kgp'
  'kubectl get services' 'kgs'
  'kubectl logs'         'kl'

  # Navigation
  'cd ..'                '..'
  'cd ../..'             '...'
  'cd ../../..'          '....'
  'cd -'                 '-'

  # pnpm
  'pnpm'                 'p'
  'pnpm install'         'pi'
  'pnpm build'           'pb'
  'pnpm dev'             'pd'
  'pnpm test'            'pt'

  # Tools
  'lsof -i'              'ports'
  'history | grep'       'h'
)

# Check if enough time has passed since last hint
should_show_hint() {
  local now=$(date +%s)
  local elapsed=$((now - LAST_HINT_TIME))
  [[ $elapsed -gt $HINT_COOLDOWN ]]
}

# Show hint for command
suggest_alias() {
  local cmd="$1"
  local suggestion="${ALIAS_HINTS[$cmd]}"

  if [[ -n "$suggestion" ]] && should_show_hint; then
    echo -e "\033[0;36m💡 Tip:\033[0m You can use \033[1;32m$suggestion\033[0m instead of '$cmd'"
    LAST_HINT_TIME=$(date +%s)
  fi
}

# Hook into command execution
preexec_alias_hint() {
  local cmd="$1"

  # Check for exact matches
  for full_cmd in "${(@k)ALIAS_HINTS}"; do
    if [[ "$cmd" == "$full_cmd"* ]]; then
      suggest_alias "$full_cmd"
      break
    fi
  done
}

# Register the hook
autoload -U add-zsh-hook
add-zsh-hook preexec preexec_alias_hint
