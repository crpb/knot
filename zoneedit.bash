#
## Copyright © 2024 Christopher Bock <christopher@bocki.com>
## SPDX-License-Identifier: MIT
##
_knot_zones() {
    _knot_zones="${_knot_zones:=$(knotc -x zone-status|awk -F'[][]' '{print$2}'|sed 's/.$//')}"
    local cur
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    case $COMP_CWORD in
        1)
            COMPREPLY=($(compgen -W "${_knot_zones}" -- ${cur}))
            compopt +o nospace
            ;;
    esac
    return 0
}
complete -F _knot_zones zoneedit
zoneedit() {
    if ! ((${#1})); then
        knotc zone-status
    else
        ZONEPATH=/var/lib/knot/zones
        ZONENAME="$1"
        if [ -f "${ZONEPATH}/${ZONENAME}" ]; then
            ZONE="$(knotc -x zone-status |awk -F'[][]' '$2=="'${ZONENAME}'." {print$2}')"
            echo -n "Freeze Zone ${ZONE}... "
            knotc -b zone-freeze "${ZONE}"
            echo -n "Flush Zone ${ZONE}... "
            knotc -b zone-flush "${ZONE}"
            echo "Opening File ${ZONE}... "
            editor "${ZONEPATH}/${ZONE%.}"
            echo -n "Reload Zone ${ZONE}... "
            knotc -b zone-reload "${ZONE}"
            echo -n "Thaw Zone ${ZONE}... "
            knotc zone-thaw "${ZONE}"
        fi
    fi
}


