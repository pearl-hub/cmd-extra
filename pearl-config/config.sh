if [[ $CMD_PATH != *"${PEARL_PKGDIR}/cmds"* ]]
then
    export CMD_PATH="$PEARL_PKGDIR/cmds:$CMD_PATH"
fi

# vim: ft=sh
