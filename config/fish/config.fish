# PATH configuration
set -gx PATH ./bin $HOME/.local/bin $PATH

# Environment variables
set -gx EDITOR hx
set -gx SUDO_EDITOR $EDITOR

alias ls='eza -lh --group-directories-first --icons=auto'
alias lsa='ls -a'
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt -a'
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"
alias cat="bat"

# Git
alias gst='git status'

# Package management
alias yayf="yay -Slq | fzf --multi --preview 'yay -Sii {1}' --preview-window=down:75% | xargs -ro yay -S"

# Compression
alias decompress="tar -xzf"

# Functions
function compress
    tar -czf "$argv[1].tar.gz" "$argv[1]"
end

function open
    xdg-open $argv >/dev/null 2>&1
end

if type -q zoxide
    zoxide init fish | source
end

starship init fish | source
