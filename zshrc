# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
#export PATH=$PATH:/opt/puppetlabs/bin:/usr/local/bin/okta-kube-token:/sharad/go/bin
export GOPATH=/sharad/go
#export GOROO=/usr/local/Cellar/go/1.12.5
export PATH=$PATH:/opt/puppetlabs/bin:/usr/local/bin/okta-kube-token:/sharad/go/bin:/User/sguar/go/bin
export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh
export SPLUNK_HOME=/Applications/Splunk/
alias orca="docker pull repo.splunk.com/splunk/products/orca:latest; \
            docker run --rm -it --name orca -e USER=$USER \
            -v /var/run/docker.sock:/var/run/docker.sock \
            -v $HOME/.orca:/root/.orca \
            -v $HOME/.ssh:/root/.ssh \
            -v $HOME/.docker:/root/.docker \
            -v \$(pwd -P):/orca-home repo.splunk.com/splunk/products/orca"
alias ll="ls -ltr"
alias gadd="git add -p"
alias fixroute="sudo route delete default && sudo route add default -interface gpd0"
# Path to your oh-my-zsh installation.
export ZSH="/Users/sguar/.oh-my-zsh"

export GOPATH=/sharad/go
ZSH_THEME="spaceship"
# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Disable colors in ls.
# DISABLE_LS_COLORS="true"

# Disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Enable command auto-correction.
ENABLE_CORRECTION="true"

# Display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Disable marking untracked files under VCS as dirty.
# This makes repository status check for large repositories  much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Change the command execution timestamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
export NVM_LAZY_LOAD=true
plugins=(
  brew
  docker
  fast-syntax-highlighting
  git
  kubectl
  npm
  yarn
  zsh-autosuggestions
  zsh-better-npm-completion
  zsh-nvm
)
# Setup for NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# Setup for Yarn
export PATH="$PATH:`yarn global bin`"

# Configure autoload of nvm version based on presence of .nvmrc file
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"
  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")
    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

# modify the prompt to contain git branch name if applicable
git_prompt_info() {
  current_branch=$(git current-branch 2> /dev/null)
  if [[ -n $current_branch ]]; then
    if [[ $(git diff --shortstat 2> /dev/null | tail -n1) != "" ]];
    then
      echo " @ %{$fg_bold[red]%}%{$current_branch✷ %}%{$reset_color%}%{$fg[blue]%}%{$reset_color%}"
    # elif [[ ! $(git diff-index --cached --quiet HEAD --ignore-submodules --) ]];
    elif [[ $(git diff --cached --exit-code) ]];
    then
      echo " @ %{$fg_bold[yellow]%}%{$current_branch ⦿%}%{$reset_color%}%{$fg[blue]%}%{$reset_color%}"
    else
      echo " @ %{$fg_bold[green]%}%{$current_branch ✔%}%{$reset_color%}%{$fg[blue]%}%{$reset_color%}"
    fi
  fi
}
setopt promptsubst

export PS1='${SSH_CONNECTION+"%{$fg_bold[green]%}%n@%m:"}%{$(echo " 🧀 : ")%}%{$fg_bold[blue]%}%c%{$reset_color%}$(git_prompt_info) ➝  '

# load our own completion functions
fpath=(~/.zsh/completion $fpath)

# completion
autoload -U compinit
compinit

# load custom executable functions
for function in ~/.zsh/functions/*; do
  source $function
done

# makes color constants available
autoload -U colors
colors

# enable colored output from ls, etc
export CLICOLOR=1

# history settings
setopt hist_ignore_all_dups inc_append_history
HISTFILE=~/.zhistory
HISTSIZE=4096
SAVEHIST=4096

# awesome cd movements from zshkit
setopt autocd autopushd pushdminus pushdsilent pushdtohome cdablevars
DIRSTACKSIZE=5

# Enable extended globbing
setopt extendedglob

# Allow [ or ] whereever you want
unsetopt nomatch

# vi mode
bindkey -v
bindkey "^F" vi-cmd-mode
bindkey jj vi-cmd-mode

# handy keybindings
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^R" history-incremental-search-backward
bindkey "^P" history-search-backward
bindkey "^Y" accept-and-hold
bindkey "^N" insert-last-word
bindkey -s "^T" "^[Isudo ^[A" # "t" for "toughguy"

# aliases
[[ -f ~/.aliases ]] && source ~/.aliases

# extra files in ~/.zsh/configs/pre , ~/.zsh/configs , and ~/.zsh/configs/post
# these are loaded first, second, and third, respectively.
_load_settings() {
  _dir="$1"
  if [ -d "$_dir" ]; then
    if [ -d "$_dir/pre" ]; then
      for config in "$_dir"/pre/**/*(N-.); do
        . $config
      done
    fi

    for config in "$_dir"/**/*(N-.); do
      case "$config" in
        "$_dir"/pre/*)
          :
          ;;
        "$_dir"/post/*)
          :
          ;;
        *)
          if [ -f $config ]; then
            . $config
          fi
          ;;
      esac
    done

    if [ -d "$_dir/post" ]; then
      for config in "$_dir"/post/**/*(N-.); do
        . $config
      done
    fi
  fi
}
_load_settings "$HOME/.zsh/configs"

stty -ixon

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PATH="$HOME/.bin:$PATH"
eval "$(rbenv init - --no-rehash)"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Brazil
export PATH=$BRAZIL_CLI_BIN:$PATH
export PATH=$HOME/.toolbox/bin:$PATH
export PATH="/usr/local/opt/python/libexec/bin:$PATH"

  # Set Spaceship ZSH as a prompt
  autoload -U promptinit; promptinit
  prompt spaceship
