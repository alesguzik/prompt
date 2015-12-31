#!/bin/zsh

autoload colors
colors
for COLOR in RED GREEN YELLOW BLUE MAGENTA CYAN BLACK WHITE; do
    eval $COLOR='%{$fg_no_bold[${(L)COLOR}]%}'
    eval BOLD_$COLOR='%{$fg_bold[${(L)COLOR}]%}'
done
eval RESET='%{$reset_color%}'


function git-staged {
  staged=''
  if git rev-parse --quiet --verify HEAD &> /dev/null ; then
    git diff-index --cached --quiet --ignore-submodules=dirty HEAD 2> /dev/null
    (( $? && $? != 128 )) && staged=1
  else
    # empty repository (no commits yet)
    # 4b825dc642cb6eb9a060e54bf8d69288fbee4904 is the git empty tree.
    git diff-index --cached --quiet --ignore-submodules=dirty 4b825dc642cb6eb9a060e54bf8d69288fbee4904 2>/dev/null
    (( $? && $? != 128 )) && staged=1
  fi
  [ -n "$staged" ] && echo "${BOLD_BLUE}+"
}

function git-unstaged {
  git diff --no-ext-diff --ignore-submodules=dirty --quiet --exit-code || echo "${BOLD_BLUE}!"
}

function git-vcs {
  echo "${CYAN}[ ${WHITE}$(git rev-parse --abbrev-ref HEAD)$(git-staged)$(git-unstaged) ${CYAN}]"
}

function vcs {
  if git rev-parse --is-inside-work-tree > /dev/null 2> /dev/null ; then
    [ "$(git rev-parse --show-toplevel)" != "$HOME" ] && git-vcs
  fi
}

function parent-dir {
  DIR="$(dirname "${PWD/$HOME/~}")"
  case "$DIR" in
    "." ) echo ;;
    "/" ) echo "$BOLD_CYAN/" ;;
    * ) echo "$CYAN$DIR/" ;;
  esac
}

function base-dir {
  DIR="$(basename "${PWD/$HOME/~}")"
  case "$DIR" in
    "/" ) echo ;;
    * ) echo "$BOLD_CYAN$DIR" ;;
  esac
}

function current-dir {
  echo "$(parent-dir)$(base-dir)"
}

#: $#⊞⊠⊙§¢¥€∞®∑ϴΦΩΞΨαγλμπ○◧◯◉●►▻▷▸▹▩▧▨▦▶xo
function prompt-char {
  case "$(whoami)" in
		"me"   ) echo "$BOLD_WHITE○" ;;
    "root" ) echo "$BOLD_RED#"   ;;
    *      ) echo "$BOLD_GREEN§" ;;
  esac
}

echo "$(date +%H:%M) $(current-dir)$(vcs) $(prompt-char) $RESET"
