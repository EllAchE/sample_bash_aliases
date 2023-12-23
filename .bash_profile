PS1='\w$ '
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export PATH="$PATH:/Users/loganharless/.nvm/versions/node/v17.4.0/bin/node"
alias gbd='git branch -d $1'
alias gma='git merge --abort'
alias cgs='clear && git status'

function nbranch() {
	git reflog show --pretty=format:'%gs ~ %gd' --date=relative | grep 'checkout' | grep -oE '[^ ]+ ~ .*' | awk -F~ '!seen[$1]++' | head -n 40
}

function clearnm() {
        find . -type d -name node_modules -exec rm -rf {} +
}
function cleardist() {
        find . -type d -name dist -exec rm -rf {} +
}

alias gr='git restore'
alias tf='terraform'

##### CUSTOMIZATION #####
#export PS1="\[\e[1;4;37m\]\h\[\e[0m\]\[\e[1;35m\] \W\[\e[0m\]\[\e[1;33m\]\$(git_branch) \[\e[0m\]: [\u] $ "
export CLICOLOR=1;
export LSCOLORS="gxfxcxdxbxegedabagacad"

alias gcp='git cherry-pick'
alias gmm='git merge main'
alias pp='pnpm'
alias bb='cd ../../'
alias bbb='cd ../../../'
alias bbbb='cd ../../../../'
alias bbbbb='cd ../../../../../'
alias pir='pnpm install --recursive'
alias pn='pnpm'
alias pnr='pnpm run'
alias pns='pnpm run start'
alias py='python'

#Personal Functions & aliases
alias js='jupyter notebook'
alias j='git checkout -'
alias y='git status'
alias rs='redis-server'
alias c='clear'
alias b='cd ..'
alias l='ls -la'
alias d='docker'
alias lbp='source ~/.bash_profile'
alias cofeedbl='caffeinate -u -t 1632'
alias ns='pnpm start'
alias grv='git remote -v'
alias fb='firebase'
alias nrd='pnpm run dev'
alias nrb='pnpm run build'
alias dib='docker image build .'
alias v='vim'
alias naf='npm audit fix'

function qpr() {
    title=$(git log -1 --pretty=%B)
    gh pr create -t "$title" -b "" -l quick
}

function mergeAllBranchs() {
	# Checkout the main branch
	git checkout main > /dev/null 2>&1

	# Pull the latest changes from main
	git pull > /dev/null 2>&1

	# For each branch
	for branch in $(git branch | grep -v 'main'); do
    	# Checkout the branch
    	git checkout "$branch" > /dev/null 2>&1

    	# Merge main into the branch
    	git merge main --no-commit 

    	# Check if the branch is still merging
     	if [ -f .git/MERGE_HEAD ]; then
        	# If the branch is merging, abort and continue
			git merge --abort > /dev/null 2>&1
     	fi
	done

	# Checkout main again at the end
	git checkout main > /dev/null 2>&1
}

# This function doesn't work, haven't fixed it yet
function deleteMergedBranchs() {
	# Checkout the main branch
	git checkout main > /dev/null 2>&1

	# Pull the latest changes from main
	git pull > /dev/null 2>&1

	# For each branch
	for branch in $(git branch | grep -v 'main'); do
    	# Checkout the branch
    	git checkout "$branch" > /dev/null 2>&1

    	# Merge main into the branch
    	git merge main > /dev/null 2>&1

    	# Check if the branch is still merging
     	if [ -f .git/MERGE_HEAD ]; then
        	# If the branch is merging, abort and continue
			git merge --abort > /dev/null 2>&1
			echo "$branch did not merge cleanly" 
     	else
        # Check if the branch is identical to main
			git checkout main > /dev/null 2>&1
        	if [ "$(git rev-parse HEAD)" = "$(git rev-parse main)" ]; then
            	# If the branch is identical to main, delete it
            	git branch -d ${branch}
        	fi
     	fi
	done

	# Checkout main again at the end
	git checkout main > /dev/null 2>&1
}

function cleardistandnodemodules() {
	find . -type d -name dist -exec rm -rf {} \;
	find . -type d -name node_modules -exec rm -rf {} \;
	find . -name "pnpm-lock.yaml" -delete;
}

function atb() {
	echo $1 >> ./.bash_profile
}

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
	vim ~/.bash_profile
}

function grsu() {
	git remote set-url origin $1
}

function grao() {
	git remote add origin $1
}

function face() {
	echo " O O "
	echo "  v  "
	echo " --- "
}

#Bluetooth utils
alias bluon='blueutil -p 1'
alias bluoff='blueutil -p 0'

#Git aliases & fns
alias g='git'

alias ga='git add'
alias gs='git status'
alias gb='git branch'
alias gpruneq='git gc --prune=now'
alias gr='git reset'
alias grc='git revert'
alias gl='git log'
alias s='git stash'
alias sdr='git stash drop'
alias sp='git stash pop'
alias sl='git stash list'
alias amend='git commit --amend -m'
alias pull='git pull'
alias p='git push -u origin HEAD'
alias gurl='git remote -v'
alias gss='git stash show -p'
alias gwt='git worktree'

function gpp() {
	git gc --prune=now
	git pull
}

function grau() {
	git remote add origin "$1"
}

function gc() {
	git commit -m "$1"
}

function gca() {
	git add -u
	git commit -m "$1"
}

function qp() {
	git add -u
	git commit -m "$1"
	git push
}

function gch() {
	git checkout ${1:-main} 
}

function m() {
	git checkout main
	git pull
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

function gd() {
	local branch="${1:-main}"
	echo branch
	git diff "$branch"
}

alias gdm='git diff main'
alias gre='shuf -n 1 ~/gre | cowsay'

# Startup Scripts
shuf -n 1 ~/gre | cowsay

function smcmd {
if [ -z $1 ];
  then
    echo "You need to provide a cmd";
  else
    git submodule foreach $1
fi
}

function chkoutSameBranchAllSubmodules {
if [ -z $1 ];
  then
    echo "You need to provide a branch";
  else
    git submodule foreach git checkout $1 || echo "failed on branch"
fi
}


function chksm {
  if [ -z $1 ]; then
    echo "You need to provide a branch";
  else
    declare -a submodules=()
    
    # Populate the submodules array
    while IFS= read -r submodule; do
      submodules+=("$submodule")
    done < <(git submodule | awk '{print $2}')
    
    # Now, iterate through the submodules and checkout the branch
    for submodule in "${submodules[@]}"; do
      git -C "$submodule" checkout $1 || echo "Failed to checkout $1 in $submodule"
    done
  fi

}

function pushsm {
    git submodule foreach git push
}

function ctsm {
if [ -z $1 ];
  then
    echo "You need to provide a commit message";
  else
    git submodule foreach 'git add -A . || :'
    git submodule foreach "git commit -am bulk-commit || :"
fi
}

function ctsme {
if [ -z $1 ];
  then
    echo "You need to provide a commit message";
  else
    git submodule foreach git add -A .
    git submodule foreach git commit -am "$1"
fi
}

function pruneRemote  {
# List all remote branches
remote_branches=$(git ls-remote --heads origin | awk '{print $2}' | sed 's|refs/heads/||')

# Loop over all local branches
for local_branch in $(git branch | sed 's/\*//'); do
    # Check if the local branch exists in the array of remote branches
    if [[ !  "${remote_branches}" =~ "${local_branch}" ]]; then
        # Delete the local branch if it doesn't exist on the remote
        git branch -d ${local_branch}
    fi
done
}


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
