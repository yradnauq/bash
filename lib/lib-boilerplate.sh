#
# Common Bourne/Bash Functions for Unix/Linux Operating Systems
#
# lib-boilerplate.sh
#
# These are the bare minimum functions to use in most/all other scripts
#
# Reference libfunctions.sh for a larger list of functions that can be used
# or sourced in other scripts
#
# Copied useful lines from a boilerplate template here:
# https://betterdev.blog/minimal-safe-bash-script-template/
# https://gist.github.com/m-radzikowski/53e0b39e9a59a1518990e76c2bff8038
#

###########################################################################
#         Initialize shell environment
###########################################################################
# Exit immediately if a command exits with a non-zero exit status
# Use this if needed but normally leave it commented out
#set -e

# Treat unset variables as an error when substituting
#set -u

set -Eeuo pipefail

# Use safe umask for the files we create
umask 027



###########################################################################
#         Global variables
###########################################################################
scriptpath="`dirname $0`"
scriptname="`basename $0`"
scriptnameshort="`basename $0 | cut -d. -f1`"



###########################################################################
#         Functions
###########################################################################
# Screen output functions
_blank()                { echo "" ; }
_rule40()               { echo '----------------------------------------' ; }
_dblrule40()    { echo '========================================' ; }
_rule80()               { echo '--------------------------------------------------------------------------------' ; }
_dblrule80()    { echo '================================================================================' ; }


# _die "<text>"
#   Prints a message to standard error, and exits the script in error
_die() {
        echo "ERROR: $*" >&2
        exit 1
}


# _err "<text>"
_err() { echo "ERROR: $*" >&2 ; }


# _warn "<text>"
_warn() { echo "WARNING: $*" >&2 ; }


# _msg "<text>"
_msg() { echo >&2 -e "${1-}" ; }


# Create backup of a file
_backup_file() {
        infile="$1"
        date=`date +'%Y-%m-%d-%H%M'`
        if [ -f "${infile}" ]; then
                cp -p "${infile}" "${infile}".${date}
        else
                echo "${infile} not found"
        fi
}


_usage() {
#Usage: $(basename "${BASH_SOURCE[0]}") [-h] [-v] [-f] -p param_value arg1 [arg2...]
        cat <<__EOF__
Usage: $0 [-h] [-v] [-f] -p param_value arg1 [arg2...]
Script description here.
Available options:
-h, --help      Print this help and exit
-v, --verbose   Print script debug info
-f, --flag      Some flag description
-p, --param     Some param description
__EOF__
        exit 0
}


_cleanup() {
        #trap - SIGINT SIGTERM ERR EXIT
        # script cleanup here
        ;
}


# May not be compatible with bourne shell
#_setup_colors() {
#       if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
#               NOFORMAT='\033[0m' RED='\033[0;31m' GREEN='\033[0;32m' ORANGE='\033[0;33m' BLUE='\033[0;34m' PURPLE='\033[0;35m' CYAN='\033[0;36m' YELLOW='\033[1;33m'
#       else
#               NOFORMAT='' RED='' GREEN='' ORANGE='' BLUE='' PURPLE='' CYAN='' YELLOW=''
#       fi
#}



###########################################################################
#         Traps
###########################################################################
# Actual "trap" command must come after any cleanup function that is called
# i.e. must define the function before using it in a "trap" command

# trap signal definitions (Prefix "SIG" is optional, therefore "INT" is the same as "SIGINT")
# EXIT - Executed on exit from the shell (normal script exit)
# ERR  - Executed whenever a simple command has a non-zero exit status
# HUP  - Hangup
# INT  - Interrupt
# TERM - Terminated

#trap CleanUp INT
#trap _cleanup SIGINT SIGTERM ERR EXIT
trap _cleanup SIGINT SIGTERM EXIT



###########################################################################
#         Input options and/or getopts
###########################################################################

## Uncomment and change parameters as necessary
## Remember to put a colon ":" after each letter parameter that requires an argument
#while getopts "a:rt" opt; do
#       case $opt in
#               a) echo "-a was used, parameter: $OPTARG" >&2 ;;
#               r) MODE="report" ;;
#               t) TESTING="Yes" ;;
#               \?) _die "Invalid option: -$OPTARG" ;;
#               :) _die "Option -$OPTARG requires an argument" ;;
#       esac
#done



###########################################################################
#         MAIN SCRIPT
###########################################################################

