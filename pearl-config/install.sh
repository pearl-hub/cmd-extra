
function post_install(){
    # If `cmd` not installed fallback to the default CMD_VARDIR
    local cmd_vardir=${CMD_VARDIR:-$PEARL_HOME/var/$PEARL_PKGREPONAME/cmd}
    mkdir -p $cmd_vardir/bin

    for file in $PEARL_PKGDIR/cmds/*/*
    do
        filename="$(basename $file)"
        link_to "$file" "$cmd_vardir/bin/$filename"
    done

    info "cmd package is required for cmd-extra:"
    info "> pearl install cmd"
}

function post_update(){
    post_install
}

function pre_remove(){
    # If `cmd` not installed fallback to the default CMD_VARDIR
    local cmd_vardir=${CMD_VARDIR:-$PEARL_HOME/var/$PEARL_PKGREPONAME/cmd}

    for file in $PEARL_PKGDIR/cmds/*/*
    do
        filename="$(basename $file)"
        unlink_from "$file" "$cmd_vardir/bin/$filename"
    done
}
