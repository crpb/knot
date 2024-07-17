# knot
Scripts and more for Knot DNS

## knot-backup
Backup the contents of `/etc/knot` and all zones.

## zoneedit.bash
Bash function for manually editing zones with your default editor.

### knot2nsupdate
For the first line of keys generated with `keymgr -t foo.bar.tld`.
```
awk -F: '/^# / {sub(/^# /,"",$1); printf "key %s {\n\talgorithm %s;\n\tsecret %s;\n};\n", $2, $1, $3}'
```
