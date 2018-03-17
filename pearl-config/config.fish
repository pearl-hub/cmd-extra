switch $CMD_PATH
case "*$PEARL_PKGDIR/cmds*"
    echo > /dev/null
case '*'
    set -x CMD_PATH "$PEARL_PKGDIR/cmds:$CMD_PATH"
end

# vim: ft=sh
