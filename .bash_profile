
# Quick demo of how functions and aliases might look in a bash profile
alias c='clear'
alias d='cd'
alias b='cd ..'
alias l='ls -la'

# Terminal must reload its sources in order to implement newly added aliases/functions
alias lbp='source ~/.bash_profile'

# MacOS specific
alias showhiddenfiles='defaults write com.apple.finder AppleShowAllFiles -bool TRUE'
alias hidehiddenfiles='defaults write com.apple.finder AppleShowAllFiles -bool FALSE'
alias cofeedbl='caffeinate -u -t 1632'


function rstrt() {
	sudo shutdown -r ${now:+10}
}

function shutdown() {
	sudo shutdown -h now
}

function seepublicip() {
	curl ipecho.net/plain; echo
}

function eb() {
	open ~/.bash_profile
}

#Git aliases & fns
alias g='git'

alias ga='git add'
alias gaa='git add -u'
alias gs='git status'
alias gb='git branch'
alias gd='git diff'
alias gdd='git diff develop'
alias gpruneq='git gc --prune=now'
alias gr='git reset'
alias gc='git commit'
alias grc='git revert'
alias gl='git log'
alias s='git stash'
alias sdr='git stash drop'
alias sp='git stash pop'
alias sl='git stash list'
alias amend='git commit --amend -m'
alias pull='git pull'
alias push='git push'
alias gurl='git remote -v'
alias gss='git stash show -p'

function gpp() {
	git gc --prune=now
	git pull
}

function grau() {
	git remote add origin "$1"
}

function gc() {
	git commit -m
}

function gca() {
	git add -u
	git commit -m "$1"
}

function gcpa() {
	git add .
	git commit -m "$1"
	git push
}

function gcp() {
	git add -u
	git commit -m "$1"
	git push
}

function gqp() {
	git add -u
	git commit -m 'quick push'
	git push
}

function gch() {
	git checkout ${1:-develop} 
}

function resetToRemote() {
	git fetch origin
	git reset --hard origin/$1
}

function gbc() {
	git branch "$1"
	git checkout "$1"
}

function undoLastCommit() {
	git reset --soft HEAD~1
}

function gdf() {
	git diff $1 ${3:develop} -- $2
}

function grsu() {
	git remote set-url origin $1
}

# Pass the desired filedname
function filerevert() {
	git checkout origin/master $1
}
