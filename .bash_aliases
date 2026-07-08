#===============================================================================
# NAVIGATION
#===============================================================================
alias c='clear'
alias e='exit'
alias b='cd ..'
alias bb='cd ../../'
alias bbb='cd ../../../'
alias bbbb='cd ../../../../'
alias bbbbb='cd ../../../../../'
alias l='ls -la'
alias dc='cd ~/Desktop/code'
alias dsrc='cd ~/Desktop/da/dsrc'

#===============================================================================
# FILE & EDITOR
#===============================================================================
alias v='vim'
alias lbp='source ~/.bash_profile'
alias chx='chmod +x'

#===============================================================================
# NODE.JS / PNPM
#===============================================================================
alias n='node'
alias pp='pnpm'
alias pb='cd ~/Desktop/da/dsrc/node && pnpm bld'
alias pw='cd ~/Desktop/da/dsrc/node/da && pnpm watch'
alias br='bun run'

function seedadeps() {
    pnpm list --filter . --depth=4 | grep "@durable-alpha"
}

function seewsdeps() {
    pnpm list --filter . --depth=Infinity --only-projects
}

#===============================================================================
# PROJECT CLEANUP
#===============================================================================
function clearnm() {
    find . -type d -name node_modules -exec rm -rf {} +
}

function cleardist() {
    find . -type d -name dist -exec rm -rf {} +
}

function cleardistandnodemodules() {
    find . -type d -name dist -exec rm -rf {} \;
    find . -type d -name node_modules -exec rm -rf {} \;
    find . -type d -name ".turbo" -exec rm -rf {} \;
    find . -name "bun.lock" -delete
    find . -name "tsconfig.tsbuildinfo" -delete
}

function rmtsbuildinfo() {
    find . -name "tsconfig.tsbuildinfo" -delete
}

#===============================================================================
# REDIS
#===============================================================================
alias rs='redis-server'
alias rc='redis-cli'

function rdsd() {
    redis-cli DEL $1
}

function rdsiid() {
    redis-cli DEL "cancelled:$1"
}

function rdsac() {
    redis-cli DEL "attempts:$1"
}

#===============================================================================
# RABBITMQ
#===============================================================================
alias drp='da rmq purge'
alias parf='da rmq purge -a && redis-cli flushall'

function lmq() {
    CONF_ENV_FILE="/opt/homebrew/etc/rabbitmq/rabbitmq-env.conf" /opt/homebrew/opt/rabbitmq/sbin/rabbitmq-server
}

#===============================================================================
# PYTHON / JUPYTER
#===============================================================================
alias py='python'
alias jn='jupyter notebook'

#===============================================================================
# TERRAFORM
#===============================================================================
alias tf='terraform'

#===============================================================================
# FIREBASE
#===============================================================================
alias fb='firebase'

#===============================================================================
# DOCKER
#===============================================================================
alias dbchrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --remote-debugging-port=9222"
alias ccffi='docker run --rm lwthiker/curl-impersonate:0.5-chrome curl_chrome110 $1'

function nfyl() {
    docker run -v /var/cache/ntfy:/var/cache/ntfy -v /etc/ntfy:/etc/ntfy -p 8080:80 -it binwiederhier/ntfy serve --cache-file /var/cache/ntfy/cache.db
}

#===============================================================================
# HAMMERSPOON
#===============================================================================
alias hsr='hs -c "hs.reload()" && echo "Hammerspoon reloaded"'

#===============================================================================
# TERMINAL MULTIPLEXER
#===============================================================================
function tsl() {
    if ! command -v tmux >/dev/null 2>&1; then
        printf 'tsl: tmux is not installed or not on PATH\n' >&2
        return 127
    fi

    if [ "$#" -eq 0 ]; then
        tmux new-session
        return
    fi

    tmux new-session -s "$1"
}

#===============================================================================
# SYSTEM UTILITIES
#===============================================================================
alias us='unset $1'
alias fvr=forever
alias cofeedbl='caffeinate -u -t 1632'

function glm() {
    if [ "$#" -ne 1 ]; then
        printf 'Usage: glm <url>\n' >&2
        return 2
    fi

    local url path owner repo pullNumber
    url=$1
    path=${url#https://github.com/}
    path=${path#http://github.com/}
    path=${path%%[\?#]*}
    path=${path%/}

    set -- $(printf '%s\n' "$path" | awk -F/ 'NF == 4 && $3 == "pull" && $1 != "" && $2 != "" && $4 ~ /^[0-9]+$/ { print $1, $2, $4 }')

    if [ "$#" -ne 3 ]; then
        printf 'glm: expected a GitHub pull request URL like https://github.com/owner/repo/pull/123\n' >&2
        return 2
    fi

    owner=$1
    repo=$2
    pullNumber=$3

    if ! command -v gh >/dev/null 2>&1; then
        printf 'glm: gh CLI is required\n' >&2
        return 127
    fi

    gh api \
        --method PUT \
        "repos/$owner/$repo/pulls/$pullNumber/merge" \
        -f merge_method=merge
}

function seepublicip() {
    curl ipecho.net/plain; echo
}

function rstrt() {
    sudo shutdown -r ${now:+10}
}

function shutdownnow() {
    sudo shutdown -h now
}

function face() {
    echo " O O "
    echo "  v  "
    echo " --- "
}

#===============================================================================
# DISPLAY MANAGEMENT (displayplacer)
#===============================================================================
du() {
    local list parsed internal_id internal_res external_id external_res
    list="$(displayplacer list)" || return 1

    parsed=$(awk 'BEGIN{RS=""; FS="\n"; OFS="|"}
        /Persistent screen id:/ {
            id=""; type=""; res=""
            for (i=1; i<=NF; i++) {
                if ($i ~ /^Persistent screen id:/) { sub(/^Persistent screen id: /, "", $i); id=$i }
                else if ($i ~ /^Type:/)            { sub(/^Type: /, "", $i); type=$i }
                else if ($i ~ /^Resolution:/)      { sub(/^Resolution: /, "", $i); res=$i }
            }
            print id, type, res
        }' <<< "$list")

    while IFS='|' read -r id type res; do
        if [[ "$type" == *"MacBook built in"* ]]; then
            internal_id="$id"; internal_res="$res"
        elif [[ -z "$external_id" ]]; then
            external_id="$id"; external_res="$res"
        fi
    done <<< "$parsed"

    if [[ -z "$external_id" || -z "$internal_id" ]]; then
        echo "du: need one internal + one external display (got internal=${internal_id:-none}, external=${external_id:-none})" >&2
        return 1
    fi

    local ext_w="${external_res%x*}" ext_h="${external_res#*x}" int_w="${internal_res%x*}"
    local offset=$(( (ext_w - int_w) / 2 ))
    (( offset < 0 )) && offset=0

    displayplacer \
        "id:${external_id} res:${external_res} scaling:off origin:(0,-${ext_h}) degree:0" \
        "id:${internal_id} res:${internal_res} scaling:on origin:(${offset},0) degree:0"
}

dl() {
      displayplacer \
          "id:5ABF407C-4FEF-44DD-A85D-98D3832521FD res:1920x1080 hz:60 color_depth:8 enabled:true
  scaling:off origin:(0,0) degree:0" \
          "id:37D8832A-2D66-02CA-B9F7-8F30A301B230 res:1680x1050 hz:60 color_depth:8 enabled:true
  scaling:on origin:(1920,0) degree:0"
  }

  dr() {
    displayplacer \
      "id:37D8832A-2D66-02CA-B9F7-8F30A301B230 res:1680x1050 hz:60 color_depth:8 enabled:true scaling:on
  origin:(0,0) degree:0" \
      "id:5ABF407C-4FEF-44DD-A85D-98D3832521FD res:1920x1080 hz:60 color_depth:8 enabled:true
  scaling:off origin:(1680,0) degree:0"
  }


function eb() {
    local files=(
      "$HOME/.bash_secrets"
      "$HOME/.bash_shell"
      "$HOME/.bash_aliases"
      "$HOME/.bash_git"
      "$HOME/.bash_github"
      "$HOME/.bash_gcloud"
      "$HOME/.bash_da"
      "$HOME/.llm_clis"
    )

    echo "Select a file to open in vim:"
    local i
    for i in "${!files[@]}"; do
      printf "%2d) %s\n" "$((i + 1))" "${files[$i]}"
    done
    printf " %2d) Quit\n" "$(( ${#files[@]} + 1 ))"

    local choice target
    while true; do
      read -rp "Enter choice [1-$(( ${#files[@]} + 1 ))]: " choice

      if [[ "$choice" =~ ^[0-9]+$ ]]; then
        if (( choice >= 1 && choice <= ${#files[@]} )); then
          target="${files[$((choice - 1))]}"
          vim "$target"
          return 0
        elif (( choice == ${#files[@]} + 1 )); then
          echo "Canceled."
          return 0
        fi
      fi

      echo "Invalid choice. Try again."
    done
  }

  clip() {
    cat "$@" | pbcopy
  }

  cmux_merge_panes() {
    local target
    target="$(cmux current-window | grep -o 'window:[0-9][0-9]*' | head -1)"
    cmux list-workspaces | grep -o 'workspace:[0-9][0-9]*' | xargs -I{} cmux move-workspace-to-window --workspace {} --window "$target"
  }
  alias cmux-merge-panes='cmux_merge_panes'
