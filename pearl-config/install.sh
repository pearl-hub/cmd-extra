
function post_install(){

    for file in $PEARL_PKGDIR/cmds/*/*
    do
        filename="$(basename $file)"
        link_to "$file" "$CMD_VARDIR/bin/$filename"
    done

    info "cmd package is required for cmd-extra:"
    info "> pearl install cmd"
}

function post_update(){
    post_install
}

function pre_remove(){
    for file in $PEARL_PKGDIR/cmds/*/*
    do
        filename="$(basename $file)"
        unlink_from "$file" "$CMD_VARDIR/bin/$filename"
    done
}
