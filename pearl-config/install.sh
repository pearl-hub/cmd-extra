
function post_install(){
    info "cmd package is required for cmd-extra:"
    info "> pearl install cmd"
}

function post_update(){
    post_install
}

function pre_remove(){
    :
}
