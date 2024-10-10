#
### Copyright © 2024 Christopher Bock <christopher@bocki.com>
### SPDX-License-Identifier: MIT
###
#

# Get tsig-keys for use with nsupdate / oneline(-y)
# Also helps if you imported old bind keys and didn't create the
# commented(#) oneline key entries.

knot-tsig-oneline() {
if ! ((${#1})); then
  knotc conf-read key.id
else
  ID="$1"
  ALGO=$(knotc conf-read "key[$ID].algorithm"|awk '{print$3}');
  SECRET=$(knotc conf-read "key[$ID].secret"|awk '{print$3}') ;
  printf '# %s:%s:%s\n' "$ALGO" "$ID" "$SECRET";
fi
}

knot-tsig-nsupdate() {
if ! ((${#1})); then
  knotc conf-read key.id
else
  ID="$1"
  ALGO=$(knotc conf-read "key[$ID].algorithm"|awk '{print$3}');
  SECRET=$(knotc conf-read "key[$ID].secret"|awk '{print$3}') ;
  printf 'key "%s" {\n\talgorithm %s;\n\tsecret "%s";\n};\n' "$ID" "$ALGO" "$SECRET";
fi
}

_knot_keys() {
    _knot_keys="${_knot_keys:=$(knotc conf-read key.id|awk '{print$3}')}"
    local cur
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    case $COMP_CWORD in
        1)
            COMPREPLY=($(compgen -W "${_knot_keys}" -- ${cur}))
            compopt +o nospace
            ;;
    esac
    return 0
}
complete -F _knot_keys knot-tsig-nsupdate knot-tsig-oneline

