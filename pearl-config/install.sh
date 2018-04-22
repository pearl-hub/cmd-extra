
function post_install(){
    # If `cmd` not installed fallback to the default CMD_VARDIR
    local cmd_vardir=${CMD_VARDIR:-$PEARL_HOME/var/$PEARL_PKGREPONAME/cmd}
    mkdir -p $cmd_vardir/bin

    cd $PEARL_PKGDIR/cmds
    for alias in */*
    do
        filename="${alias//\//-}"
        link_to "$PEARL_PKGDIR/cmds/$alias" "$cmd_vardir/bin/$filename"
    done

    info "cmd package is required for cmd-extra:"
    info "> pearl install cmd"
}

function post_update(){
    pre_remove
    post_install
}

function pre_remove(){
    # If `cmd` not installed fallback to the default CMD_VARDIR
    local cmd_vardir=${CMD_VARDIR:-$PEARL_HOME/var/$PEARL_PKGREPONAME/cmd}

    cd $PEARL_PKGDIR/cmds
    for alias in */*
    do
        filename="${alias//\//-}"
        unlink_from "$PEARL_PKGDIR/cmds/$alias" "$cmd_vardir/bin/$filename"
    done
}
