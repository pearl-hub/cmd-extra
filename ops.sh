# This module contains all utility functions for
# sys admin activities

function pscmd() {
    ps aux
}

function pssortcmd() {
    local sortcolumn=$1

    local ps_out=$(pscmd)
    echo "$ps_out" | head -n 1
    echo "$ps_out" | sort -nr -k $sortcolumn
}

function psmemmost() {
    # $1: number of process to view (default 10).
    local num=$1
    [[ -z "$num" ]] && num="10"

    local ps_out=$(pssortcmd 4)
    echo "$ps_out" | head -n 1
    echo "$ps_out" | tail -n +2 | head -n $num
}

function pscpumost() {
    # $1: number of process to view (default 10).
    local num=$1
    [[ -z "$num" ]] && num="10"

    local ps_out=$(pssortcmd 3)
    echo "$ps_out" | head -n 1
    echo "$ps_out" | tail -n +2 | head -n $num
}

function pscpugt() {
    # $1: percentage of cpu. Default 90%

    local perc=$1
    [ "$perc" == "" ] && perc="90"

    local ps_out=$(pssortcmd 3)
    echo "$ps_out" | head -n 1
    echo "$ps_out" | tail -n +2 | awk -v "q=$perc" '($3>=q){print $0}'
}

function psmemgt() {
    # $1: percentage of memory. Default 90%

    local perc=$1
    [ "$perc" == "" ] && perc="90"

    local ps_out=$(pssortcmd 4)
    echo "$ps_out" | head -n 1
    echo "$ps_out" | tail -n +2 | awk -v "q=$perc" '($4>=q){print $0}'
}

function pssleepy() {
    # Shows all process that are:
    # -   D    uninterruptible sleep (usually IO)
    # -   S    interruptible sleep (waiting for an event to complete)
    local ps_out=$(pscmd)
    echo "$ps_out" | head -n 1
    echo "$ps_out" | awk '($8~/.*[DS].*/){print $0}'
}

function pszombies(){
    local ps_out=$(pscmd)
    echo "$ps_out" | head -n 1
    echo "$ps_out" | awk '($8~/.*Z.*/){print $0}'
}

function psrunning(){
    local ps_out=$(pscmd)
    echo "$ps_out" | head -n 1
    echo "$ps_out" | awk '($8~/.*R.*/){print $0}'
}

function psofuser(){
    # $1: name of the user
    ps -U $1 -u $1 u
}

function psfrompid(){
    # $1: PID of the process
    ps -p $1 -o comm=
}

function pstopid(){
    # $1: name of the process
    ps -C $1 -o pid=
}

function repeat(){
    # $@ the command to be repeated
    while true
    do
        $@
    done
}

function isopen() {
    lsof | grep $(readlink -f "$1")
}

function notabs() {
    # Replace tabs by 4 spaces & remove trailing spaces
    local files=$@
    for f in $files
    do
        sed -i -e 's/[	 ]*$//g' "$f"
        sed -i -e 's/	/    /g' "$f"
    done
}

function tailim() {
    tail $@ | perl -pe 's/(ERROR)/\e[1;31m$1\e[0m/gi;s/(INFO)/\e[1;32m$1\e[0m/gi;s/(DEBUG)/\e[1;32m$1\e[0m/gi;s/(WARN)/\e[1;33m$1\e[0m/gi'
}

function whicharch() {
    getconf LONG_BIT
}

#######################################
# Search for files that match for a given date pattern.
#
# Example:
#     >> logat "2 hours ago" myservice.log.*
#     myservice.log.2017-03-28-10.gz
#
# To change the log pattern:
#     >> LOG_PATTERN="%Y-%m-%d-%H%M%S" logat "yesterday" *
#     myservice.log.2017-03-27-103112.gz
#     myapp.log.2017-03-27-103320.gz
#
# Globals:
#   LOG_PATTERN (RW):    The pattern for the date in the filename (default: "%Y-%m-%d-%H")
# Arguments:
#   when ($1):           The relative date and time (more info `man date`)
#   logfiles ($2-):      The file list
# Returns:
#   None
# Output:
#   The file list matching the pattern
#######################################
function logat(){
    local log_pattern=${LOG_PATTERN:-"%Y-%m-%d-%H"}
    local when=$1
    local pattern=$(date --date="$when" +$log_pattern)
    shift
    local logfiles=$@

    for logfile in ${logfiles}
    do
        [[ ${logfile} =~ .*${pattern}.* ]] && echo "${logfile}"
    done
}

#######################################
# Search for files that match for the "now" date.
#
# Example:
#     >> logatnow myservice.log.*
#     myservice.log.2017-03-28-12.gz
#
# To change the log pattern:
#     >> LOG_PATTERN="%Y-%m-%d-%H%M%S" logatnow *
#     myservice.log.2017-03-27-103112.gz
#     myapp.log.2017-03-27-103320.gz
#
# Globals:
#   LOG_PATTERN (RW):    The pattern for the date in the filename (default: "%Y-%m-%d-%H")
# Arguments:
#   logfiles ($@):       The file list
# Returns:
#   None
# Output:
#   The file list matching the pattern
#######################################
function logatnow(){
    logat now $@
}
