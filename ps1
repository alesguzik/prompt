#!/bin/zsh

autoload colors
colors
for COLOR in RED GREEN YELLOW BLUE MAGENTA CYAN BLACK WHITE; do
    eval $COLOR='%{$fg_no_bold[${(L)COLOR}]%}'
    eval BOLD_$COLOR='%{$fg_bold[${(L)COLOR}]%}'
done
eval RESET='%{$reset_color%}'


function git-staged {
  [ "$(git diff --shortstat 2> /dev/null | tail -n1)" != "" ] && echo "${BOLD_BLUE}+"
}

function git-unstaged {
  [ "$(git diff --shortstat 2> /dev/null | tail -n1)" != "" ] && echo "${BOLD_BLUE}!"
}

function git-vcs {
echo "${CYAN}[ ${WHITE}$(git rev-parse --abbrev-ref HEAD)$(git-unstaged)$(git-staged) ${CYAN}]"
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
