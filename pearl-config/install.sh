
function post_install(){
    pearl emerge ${PEARL_PKGREPONAME}/cmd

    # set CMD_VARDIR to make cmd command working
    export CMD_VARDIR="${PEARL_HOME}/var/${PEARL_PKGREPONAME}/cmd"

    cmd include "$PEARL_PKGDIR/cmds"

    return 0
}

function post_update(){
    post_install
}

function pre_remove(){
    # CMD_VARDIR should already be set at this point
    cmd exclude "$PEARL_PKGDIR/cmds"

    return 0
}
