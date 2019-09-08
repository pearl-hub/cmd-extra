DEPENDS=("${PEARL_PKGREPONAME}/cmd")
function post_install(){
    # set CMD_VARDIR to make cmd command working
    export CMD_VARDIR="${PEARL_HOME}/var/${PEARL_PKGREPONAME}/cmd"

    cmd include "$PEARL_PKGDIR/cmds"

    return 0
}

function post_update(){
    post_install
}

function pre_remove(){
    # CMD_VARDIR should already be set at this point.
    # cmd might not be installed anymore, check if exists first
    command -v cmd &> /dev/null && cmd exclude "$PEARL_PKGDIR/cmds"

    return 0
}
