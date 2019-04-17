
function post_install(){
    pearl emerge ${PEARL_PKGREPONAME}/cmd

    cmd include "$PEARL_PKGDIR/cmds"

    return 0
}

function post_update(){
    post_install
}

function pre_remove(){
    cmd exclude "$PEARL_PKGDIR/cmds"

    return 0
}
