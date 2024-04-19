#!/bin/bash

read -r -d '' _HELP <<EOM
This script modifies the Google Chrome shortcut on Ubuntu to enable video encoding flags for better video performance.
Please check the following URL for more information:
  https://github.com/felipecrs/dotfiles#enable_chrome_video_encoding
EOM

# ARG_OPTIONAL_BOOLEAN([force],[f],[Do not ask for confirmation])
# ARG_HELP([],[$_HELP\n])
# ARGBASH_SET_INDENT([  ])
# ARGBASH_GO()
# needed because of Argbash --> m4_ignore([
### START OF CODE GENERATED BY Argbash v2.8.1 one line above ###
# Argbash is a bash code generator used to get arguments parsing right.
# Argbash is FREE SOFTWARE, see https://argbash.io for more info

die() {
  local _ret="${2:-1}"
  test "${_PRINT_HELP:-no}" = yes && print_help >&2
  echo "$1" >&2
  exit "${_ret}"
}

begins_with_short_option() {
  local first_option all_short_options='fh'
  first_option="${1:0:1}"
  test "${all_short_options}" = "${all_short_options/${first_option}/}" && return 1 || return 0
}

# THE DEFAULTS INITIALIZATION - OPTIONALS
_arg_force="off"

print_help() {
  printf 'Usage: %s [-f|--(no-)force] [-h|--help]\n' "$0"
  printf '\t%s\n' "-f, --force, --no-force: Do not ask for confirmation (off by default)"
  printf '\t%s\n' "-h, --help: Prints help"
  printf '\n%s\n' "${_HELP}
"
}

parse_commandline() {
  while test $# -gt 0; do
    _key="$1"
    case "${_key}" in
    -f | --no-force | --force)
      _arg_force="on"
      test "${1:0:5}" = "--no-" && _arg_force="off"
      ;;
    -f*)
      _arg_force="on"
      _next="${_key##-f}"
      if test -n "${_next}" -a "${_next}" != "${_key}"; then
        { begins_with_short_option "${_next}" && shift && set -- "-f" "-${_next}" "$@"; } || die "The short option '${_key}' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
      fi
      ;;
    -h | --help)
      print_help
      exit 0
      ;;
    -h*)
      print_help
      exit 0
      ;;
    *)
      _PRINT_HELP=yes die "FATAL ERROR: Got an unexpected argument '$1'" 1
      ;;
    esac
    shift
  done
}

parse_commandline "$@"

# OTHER STUFF GENERATED BY Argbash

### END OF CODE GENERATED BY Argbash (sortof) ### ])
# [ <-- needed because of Argbash

set -euo pipefail

force=${_arg_force}

original_shortcut=/usr/share/applications/google-chrome.desktop
if [[ ! -f "${original_shortcut}" ]]; then
  echo "Could not find the file ${original_shortcut}. Are you sure that Google Chrome is installed?"
  exit 1
fi

new_shortcut="${HOME}/.local/share/applications/$(basename "${original_shortcut}")"

echo
echo "We will:"
echo "  - Create the file '${new_shortcut}'"
echo
if [[ "${force}" = off ]]; then
  read -p "Do you confirm? (Yy)" -n 1 -r
  echo
  if [[ ! ${REPLY} =~ ^[Yy]$ ]]; then
    exit 1
  fi
fi

## Create the shortcut
cp -f "${original_shortcut}" "${new_shortcut}"
line_match="Exec=/usr/bin/google-chrome-stable"
sed -i "s:${line_match}:${line_match} --enable-features=VaapiVideoEncoder,VaapiVideoDecoder,CanvasOopRasterization:g" "${new_shortcut}" # The //\//\\/ is used to escape forward slashes

echo
echo "All done."
echo "Please make sure you fully close Google Chrome before opening a new instance."
echo "Check that hardware ecoding and decoding is working at chrome://gpu/"
echo
echo "To uninstall, run:"
echo "  $ rm -f ${new_shortcut}"
echo

# ] <-- needed because of Argbash
