#
# Common Bourne/Bash Functions for Unix/Linux Operating Systems
#
# libfunctions.sh
#
# General variables and functions
#
# Source these in other scripts with this syntax (without the "# "):
# . /home/admin/scripts/lib/libfunctions.sh
#
#
# Current list of functions contained herein:
#    NOTE: get the update list with one of these commands:
#    grep '^_[a-zA-Z0-9_]' libfunctions.sh
#    grep '()' libfunctions.sh | grep -v '^#'
#
##################################################
#         New/Uncategorized functions
##################################################
# _bash()    { test -x "`which bash`" && BASH="Yes" || BASH= ; }
# _lstrip() {
# _rstrip() {
# _trim_string() {
# _trim_all() {
# _str_contains() {
# _str_start() {
# _str_ends() {
# _split() {
# _trim_quotes() {
# _parse_key_val_file() {
# _head() {
# _lines() {
# _count() {
# _create_empty_file() {
#
##################################################
#          Error and Status message functions
##################################################
# _error() { echo "[`date +'%Y-%m-%dT%H:%M:%S%z'`]: $@" >&2 ; }
# _die() {
# _err() { echo "ERROR: $*" >&2 ; }
# _warn() { echo "WARNING: $*" >&2 ; }
# _die_cat() {
#
##################################################
#         Screen output functions
##################################################
# _blank()        { echo "" ; }
# _rule40()       { echo '----------------------------------------' ; }
# _dblrule40()    { echo '========================================' ; }
# _rule80()       { echo '--------------------------------------------------------------------------------' ; }
# _dblrule80()    { echo '================================================================================' ; }
# _pause() {
#
##################################################
#         General functions
##################################################
# _grep() {
# _osinfo() {
# _uuemail() {
# _bdf() {
#
##################################################
#         String manipulation functions
##################################################
# _set_prompt() { PS1="`whoami`@`hostname | sed 's/\..*//'`>" ; }
# _length() {
# _convert_secs() {
# _convert_mins() {
# _convert_date() {
# _lowercase() {
# _to_lower() {
# _toggle_param() {
#
##################################################
#         File/dir manipulation functions
##################################################
# _create_lock() { touch ${lockfile} ; }
# _delete_lock() { rm -f ${lockfile} ; }
# _backup_file() {
# _rotate_file() {
# _rotate_log() {
# _rotate_numlog() {
# _set_vimrc() {
# _create_sed_join() {
#
##################################################
#         Functions to gather info
##################################################
# _isroot() {
#
##################################################
#         Functions to gather system info
##################################################
# _cpu_count() {
#
#
#
# Future ideas:
#       - File backup function
#       - List users locked out locally
#       - List file systems/VGs
#       - List NIS settings
#       - List QAS settings
#       - Performance Monitoring tools (i.e. iostat, vmstat, etc.)
#       -
#
# Pulled functions from these scripts:
#       /home/admin/scripts/AIX/vvg.sh (none)
#       /home/admin/scripts/audit/audit-report.sh (Menus)
#       /home/admin/scripts/info/info.sh (ConvertDate, test example[Bash], Output_Param)
#       /home/admin/scripts/mcafee/audit.sh (SSHTest)
#       /3rdparty/mcafee/bin/scan.sh (ConvertSecs, _CPUCount, SolUFS, AIXJFS, LinuxFS)
#       /home/admin/software/lynis/lynis-2.7.3/lynis/lynis (none)
#       /home/admin/software/lynis/lynis-2.7.3/lynis/include/functions (many)
#
# Check these scripts for functions:
#       /home/admin/scripts/nixtest/prod/bin/functions.sh (_Grep, _Create_Sed_Join, _ToggleParam, )
#       /home/admin/scripts/nixtest/prod/bin/nixtest_x.y.z.sh
#       /home/admin/scripts/ping/
#       /home/admin/scripts/scan/root_pw_stats.sh
#       /home/admin/scripts/security/audit-linux-sso.sh
#       /home/admin/scripts/shell/colors.sh
#       /home/admin/scripts/shell/.vimrc_brh
#       /home/admin/scripts/solaris/solaris_cpu_count.sh
#       /home/admin/scripts/solaris/epoch_date.sh
#       /home/admin/scripts/ssh/sshrsh.sh
#       /home/admin/scripts/syslog/audit_logs.sh
#       /home/admin/scripts/test/
#       /home/admin/scripts/tree/
#       /home/admin/scripts/vintela/vas_status.sh (example from Quest)
#       /home/admin/scripts/df.sh
#
#       /3rdparty/tools/get_OSrelease.sh
#       /3rdparty/tools/get_OSrelease.csh
#       /3rdparty/tools/.login_common
#       /3rdparty/tools/.cshrc_common
#
#
# Bourne shell built-in commands:
# . filename
# bg [%jobid ...]
# break [n]
# cd [arg]
# chdir [dir]
# continue [n]
# echo [args ...]
# eval [arg ...]
# exec [arg ...]
# exit [n]
# export [name ...]
# fg [%jobid ...]
# getopts
# hash [-r] [name ...]
# jobs [-p|-l] [%jobid ...]
# kill [-sig] %job ...
# login [arg ...]
# newgrp [arg]
# pwd
# read name ...
# readonly [name ...]
# return [n]
# set [arg ...]
# shift [n]
# stop pid ...
# suspend
# test
# times
# trap [arg n ...]
# type [name ...]
# ulimit limit
# umask [nnn]
# unset [name ...]
# wait [n]


# Environment variables
# HOME
# PATH
# CDPATH
# MAIL
# MAILCHECK
# MAILPATH
# PS1
# PS2
# IFS           Internal field separators, normally space, tab, and newline
# SHACCT
# SHELL


# Special variables
# $0    # script name
# $1 through $9 # Positional parameters
# $*    # all positional parameters
# $@    # all positional parameters with spaces
# $#    # Number of positional parameters (in decimal)
# $$    # Current PID of this shell
# $!    # PID of last background job invoked
# $?    # Error status (decimal value returned by last command)

# "$*"  # all positional parameters substituted and quoted, separated by quoted spaces  ("$1 $2 ...")
# "$@"  # all positional parameters with spaces substituted and quoted, separated by unquoted spaces ("$1" "$2" ...)


# Alternate variable formats
# ${var?value}          # Complain if undefined ( e.g. cat ${HOME?"Please define HOME"} )
# ${var-default}        # Use default if undefined ( e.g. ${HOME-/home/user} )
# ${var+value}          # Change if defined
# ${var=value}          # Redefine if undefined
#
# ${var:?word}          # Complain if undefined or null
# ${var:-word}          # Use new value if undefined or null
# ${var:+word}          # Opposite of above
# ${var:=word}          # Use new value if undefined or null, and redefine


# Undefining variables
# unset HOME            # Use unset instead of "HOME=" because that sets ${HOME} to an empty string instead


# Input/Output Redirection
# <word         Use file word as stdin
# >word         Use file word as stdout
# >>word        Append stdout to file "word"
# <>word        Open file word for read/write as stdin
# <<[-]word     Parameter and cmd substitution done on "word", then read shell input up to first line that matches "word"
# <&digit       Use the file associated with file descriptor <digit> as stdin
# <&-           stdin is closed
# >&-           stdout is closed


# Major differences between bourne and bash shells
#
# Bash has these constructs that are not available in bourne:
#
#
#
#
#
#
#
#
#
#


# Strip leading and trailing whitespace from a variable
# sed 's/^[ \t]*//;s/[ \t]*$//'


# Exit if this function library is run as a shell script
#exit
#[ $_ != $0 ] && echo "Script is sourced" || echo "Script is a subshell"




########################################
# Initialize shell environment
########################################
# Bash syntax only
#set -o errexit
#set -o pipefail
#set -o nounset
#
# Bourne syntax
#set -e
#set -u

# Use safe umask for the files we create
umask 027


# More tips from:
# https://kvz.io/blog/2013/11/21/bash-best-practices/
#
## Set magic variables for current file & dir
#__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
#__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
#__base="$(basename ${__file} .sh)"
#__root="$(cd "$(dirname "${__dir}")" && pwd)" # <-- change this as it depends on your app
#
#arg1="${1:-}"

# More tips from:
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
#set -euo pipefail
#IFS=$'\n\t'

# Google bash style guide:
# https://google.github.io/styleguide/shell.xml
#
# err() {
#  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $@" >&2
#}
#
#if ! do_something; then
#  err "Unable to do_something"
#  exit "${E_DID_NOTHING}"
#fi




#################################################################################
# Traps
#################################################################################
#trap CleanUp INT




###########################################################################
#                             Functions
###########################################################################
#
# Notes:
#       Make sure one-liner functions have a semicolon at the end of the last command
#
#       Include comments with each non-trivial function. Example:
#               Function description
#               Globals:
#                       BACKUP_DIR
#               Arguments:
#                       None
#               Returns:
#                       None
#
#
# Getopts example:
# while getopts "n:e:o:i:s" flag "$@"; do
#       case ${flag} in
#               n) exclude+=$OPTARG ;;
#               e) errx=$OPTARG ;;
#               o) outx=$OPTARG ;;
#               i) inx=$OPTARG ;;
#               s) split=false ; exclude+== ;;
#       esac
# done
#



##################################################
#         New/Uncategorized functions
##################################################

# Set variables based on the existence of a file
_bash()    { test -x "`which bash`" && BASH="Yes" || BASH= ; }


# New functions from:
# https://github.com/dylanaraps/pure-sh-bible

# Strip pattern from start of string
_lstrip() {
        # Usage: lstrip "string" "pattern"
        printf '%s\n' "${1##$2}"
}


# Strip pattern from end of string
_rstrip() {
        # Usage: rstrip "string" "pattern"
        printf '%s\n' "${1%%$2}"
}


# Trim leading and trailing white-space from a string
_trim_string() {
        # Usage: trim_string "   example   string    "

        # Remove all leading white-space.
        # '${1%%[![:space:]]*}': Strip everything but leading white-space.
        # '${1#${XXX}}': Remove the white-space from the start of the string.
        trim=${1#${1%%[![:space:]]*}}

        # Remove all trailing white-space.
        # '${trim##*[![:space:]]}': Strip everything but trailing white-space.
        # '${trim#${XXX}}': Remove the white-space from the end of the string.
        trim=${trim%${trim##*[![:space:]]}}

        printf '%s\n' "$trim"
}


# Trim all white-space from string and truncate spaces
# shellcheck disable=SC2086,SC2048
_trim_all() {
        # Usage: trim_all "   example   string    "

        # Disable globbing to make the word-splitting below safe.
        set -f

        # Set the argument list to the word-splitted string.
        # This removes all leading/trailing white-space and reduces
        # all instances of multiple spaces to a single ("  " -> " ").
        set -- $*

        # Print the argument list as a string.
        printf '%s\n' "$*"

        # Re-enable globbing.
        set +f
}


# Check if string contains a sub-string
_str_contains() {
        case $var in
                *sub_string1*)
                        # Do stuff
                ;;

                *sub_string2*)
                        # Do other stuff
                ;;

                *)
                        # Else
                ;;
        esac
}


# Check if string starts with sub-string
_str_start() {
        case $var in
                sub_string1*)
                        # Do stuff
                ;;

                sub_string2*)
                        # Do other stuff
                ;;

                *)
                        # Else
                ;;
        esac
}


# Check if string ends with sub-string
_str_ends() {
        case $var in
                *sub_string1)
                        # Do stuff
                ;;

                *sub_string2)
                        # Do other stuff
                ;;

                *)
                        # Else
                ;;
        esac
}


# Split string on a delimiter
_split() {
        # Disable globbing.
        # This ensures that the word-splitting is safe.
        set -f

        # Store the current value of 'IFS' so we
        # can restore it later.
        old_ifs=$IFS

        # Change the field separator to what we're
        # splitting on.
        IFS=$2

        # Create an argument list splitting at each
        # occurance of '$2'.
        #
        # This is safe to disable as it just warns against
        # word-splitting which is the behavior we expect.
        # shellcheck disable=2086
        set -- $1

        # Print each list value on its own line.
        printf '%s\n' "$@"

        # Restore the value of 'IFS'.
        IFS=$old_ifs

        # Re-enable globbing.
        set +f
}


# Trim quotes from a string
_trim_quotes() {
        # Usage: trim_quotes "string"

        # Disable globbing.
        # This makes the word-splitting below safe.
        set -f

        # Store the current value of 'IFS' so we
        # can restore it later.
        old_ifs=$IFS

        # Set 'IFS' to ["'].
        IFS=\"\'

        # Create an argument list, splitting the
        # string at ["'].
        #
        # Disable this shellcheck error as it only
        # warns about word-splitting which we expect.
        # shellcheck disable=2086
        set -- $1

        # Set 'IFS' to blank to remove spaces left
        # by the removal of ["'].
        IFS=

        # Print the quote-less string.
        printf '%s\n' "$*"

        # Restore the value of 'IFS'.
        IFS=$old_ifs

        # Re-enable globbing.
        set +f
}


# Parse a key=val file
# Setting 'IFS' tells 'read' where to split the string.
_parse_key_val_file() {
        while IFS='=' read -r key val; do
                # Skip over lines containing comments.
                # (Lines starting with '#').
                [ "${key##\#*}" ] || continue

                # '$key' stores the key.
                # '$val' stores the value.
                printf '%s: %s\n' "$key" "$val"

                # Alternatively replacing 'printf' with the following
                # populates variables called '$key' with the value of '$val'.
                #
                # NOTE: I would extend this with a check to ensure 'key' is
                #       a valid variable name.
                # export "$key=$val"
                #
                # Example with error handling:
                # export "$key=$val" 2>/dev/null ||
                #     printf 'warning %s is not a valid variable name\n' "$key"
        done < "file"
}


# Get the first N lines of a file
_head() {
        # Usage: head "n" "file"
        while IFS= read -r line; do
                printf '%s\n' "$line"
                # Bash-specific syntax
                #i=$((i+1))
                # Bourne syntax
                i=`expr $i + 1`
                [ "$i" = "$1" ] && return
        done < "$2"

        # 'read' used in a loop will skip over
        # the last line of a file if it does not contain
        # a newline and instead contains EOF.
        #
        # The final line iteration is skipped as 'read'
        # exits with '1' when it hits EOF. 'read' however,
        # still populates the variable.
        #
        # This ensures that the final line is always printed
        # if applicable.
        [ -n "$line" ] && printf %s "$line"
}


# Get number of lines in a file
_lines() {
        # Usage: lines "file"

        # '|| [ -n "$line" ]': This ensures that lines
        # ending with EOL instead of a newline are still
        # operated on in the loop.
        #
        # 'read' exits with '1' when it sees EOL and
        # without the added test, the line isn't sent
        # to the loop.
        while IFS= read -r line || [ -n "$line" ]; do
                lines=`expr $lines + 1`
                #lines=$((lines+1))
        done < "$1"

        printf '%s\n' "$lines"
}


# Count files or directories in directory
_count() {
        # Usage: count /path/to/dir/*
        #        count /path/to/dir/*/
        [ -e "$1" ] \
                && printf '%s\n' "$#" \
                || printf '%s\n' 0
}


# Create an empty file
_create_empty_file() {
        :>file
}





##################################################
#          Error and Status message functions
##################################################

# Fix for issues with built-in echo command when printing variables with special characters
# Put this at the beginning of scripts to override the shell built-in echo command
#echo() { printf %s\\n "$*" ; }


# Error message function (from Google style guide)
# Bash syntax
#_error() { echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $@" >&2 ; }


# Error message function (from Google style guide)
# Bourne syntax
_error() { echo "[`date +'%Y-%m-%dT%H:%M:%S%z'`]: $@" >&2 ; }


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


# _die_cat
#       Prints the text on standard input to standard error and exits with an error
#       Intended to be used like this:
#               die_cat <<-.
#                       Something bad just happened!
#               .
_die_cat() {
        cat >&2
        exit 1
}



##################################################
#         Screen output functions
##################################################
_blank()     { echo "" ; }
_rule40()    { echo '----------------------------------------' ; }
_dblrule40() { echo '========================================' ; }
_rule80()    { echo '--------------------------------------------------------------------------------' ; }
_dblrule80() { echo '================================================================================' ; }

# Pause for confirmation before continuing
_pause() {
        echo "${COLOR_BG_GREEN}Press Return to Continue${COLOR_RESET}"
        read ENT
}



##################################################
#         General functions
##################################################

# Smart grep function
# Input:     String + filename
# Output:    Results from grep
# Examples:  _grep PermitRootLogin /etc/ssh/sshd_config
#            var_ssh_permit_root="`_grep PermitRootLogin /etc/ssh/sshd_config`"
_grep() {
        if [ "$1" != "" -a "$2" != "" ]; then
                if [ "$3" = "ECHO" ]; then
                        echo "grep -i \"${1}\" \"${2}\" 2>/dev/null | grep -v '^#' | grep -i -w \"${1}\""
                else
                        if [ -f "${2}" ]; then
                                grep -i "${1}" "${2}" 2>/dev/null | grep -v '^#' | grep -i -w "${1}"
                        else
                                echo "FILENOTFOUND"
                        fi
                fi
        fi
}


# Get the OS type, version, and release
_osinfo() {
        if [ test -f /vmunix -a ! -f /bin/uname]; then
                OSname="SunOS"
                REL="`strings /vmunix | grep SunOS | grep Release | cut -d' ' -f3 | cut -d. -f1`"
                REV="`strings /vmunix | grep SunOS | grep Release | cut -d' ' -f3`"
        else
                OSname="`uname -s`"
                case ${OSname} in
                        AIX)
                                REL="`uname -v`"
                                REV="`uname -v`.`uname -r`"
                                DISTRO=""
                                ;;
                        HP-UX)
                                REL="`uname -r | cut -d. -f1`"
                                REV="`uname -r`"
                                DISTRO=""
                                ;;
                        Linux)
                                if [ -f /etc/fedora-release ]; then
                                        DISTRO="Fedora"
                                        FILE=/etc/fedora-release
                                        REL=`cat ${FILE} | sed s/.*release\ // | sed s/\ .*// | cut -d. -f1`
                                        REV=`cat ${FILE} | sed s/.*release\ // | sed s/\ .*//`
                                        PSEUDONAME=`cat ${FILE} | sed s/.*\(// | sed s/\)//`
                                elif [ -f /etc/centos-release ]; then
                                        DISTRO="CentOS"
                                        FILE=/etc/centos-release
                                        REL=`cat ${FILE} | sed s/.*release\ // | sed s/\ .*// | cut -d. -f1`
                                        REV=`cat ${FILE} | sed s/.*release\ // | sed s/\ .*//`
                                        PSEUDONAME=`cat ${FILE} | sed s/.*\(// | sed s/\)//`
                                elif [ -f /etc/redhat-release ]; then
                                        FILE=/etc/redhat-release
                                        REL=`cat ${FILE} | sed s/.*release\ // | sed s/\ .*// | cut -d. -f1`
                                        REV=`cat ${FILE} | sed s/.*release\ // | sed s/\ .*//`
                                        #PSEUDONAME=`cat ${FILE} | sed s/.*\(// | sed s/\)//`
                                        PSEUDONAME=`cat ${FILE} | sed 's/.*(//' | sed 's/)//'`
                                        RHVER=`cat ${FILE} | head -1 | awk '{print $1" "$2" "$3}'`
                                        if [ "${RHVER}" = "Red Hat Enterprise" ]; then
                                                DISTRO="RHEL"
                                        elif [ "${RHVER}" = "Red Hat Linux" ]; then
                                                DISTRO="RedHat"
                                        else
                                                DISTRO="RedHat"
                                        fi
                                elif [ -f /etc/SuSE-release ]; then
                                        DISTRO="SUSE"
                                        FILE=/etc/SuSE-release
                                        REL=`cat ${FILE} | tr "\n" ' ' | sed s/.*=\ // | cut -d. -f1`
                                        REV=`cat ${FILE} | tr "\n" ' ' | sed s/.*=\ //`
                                        PSEUDONAME=`cat ${FILE} | tr "\n" ' '| sed s/VERSION.*//`
                                elif [ -f /etc/mandrake-release ] ; then
                                        DISTRO="Mandriva"
                                        FILE=/etc/mandrake-release
                                        REL=`cat ${FILE} | sed s/.*release\ // | sed s/\ .*// | cut -d. -f1`
                                        REV=`cat ${FILE} | sed s/.*release\ // | sed s/\ .*//`
                                        PSEUDONAME=`cat ${FILE} | sed s/.*\(// | sed s/\)//`
                                elif [ -f /etc/debian_version ] ; then
                                        FILE=/etc/lsb-release
                                        DISTRO=`cat ${FILE} | grep '^DISTRIB_ID' | awk -F= '{ print $2 }'`
                                        REL=`cat ${FILE} | grep '^DISTRIB_RELEASE' | awk -F= '{ print $2 }' | cut -d. -f1`
                                        REV=`cat ${FILE} | grep '^DISTRIB_RELEASE' | awk -F= '{ print $2 }'`
                                        PSEUDONAME=`cat ${FILE} | grep '^DISTRIB_CODENAME' | awk -F= '{ print $2 }'`
                                else
                                        REL="`uname -r | cut -d. -f1`"
                                        REV="`uname -r`"
                                        DISTRO=""
                                fi
                                ;;
                        SunOS)
                                REL="`uname -r | cut -d. -f1`"
                                REV="`uname -r`"
                                DISTRO=""
                                ;;
                        *)
                                REL="`uname -r | cut -d. -f1`"
                                REV="`uname -r`"
                                DISTRO=""
                                ;;
                esac
        fi
        OSrelease=${REL}
        OSrevision=${REV}
}


# UUEncode and email a file
_uuemail() {
        FILE="$1"
        EMAIL="$2"
        if [ "${FILE}" = "" -o "${EMAIL}" = "" ]; then
                echo "uuemail syntax:"
                echo "uuemail <file> <email>"
                echo ""
                echo "Example: uuemail /tmp/test.txt brian.hendricks@lmco.com"
                echo ""
        else
                uuencode "${FILE}" "${FILE}" | mail -s "Sending CSV file from ${HOSTNAME}" "${EMAIL}"
        fi
}


# (BETA) A better df with more readable output
_bdf() {
        OS=`uname -s`
        # Default sort key is filesystem name
        case $1 in
                f|F) K=1 ;;
                s|S) K=2 ;;
                p|P) K=5 ;;
                *)   K=1 ;;
        esac
        case ${OS} in
                AIX)
                        U=Ig
                        C2=8
                        ;;
                Linux)
                        U=Ph
                        C2=8
                        ;;
                SunOS)   # SunOS/Solaris
                        U=k
                        C2=10
                        ;;
                *)       # Default
                        U=k
                        C2=10
                        ;;
        esac

        # Get the length of the longest filesystem name
        # Use that length to space out the first column in the output
        LENGTH=`df -${U} | grep "\/dev\/" | awk '{print $1}' | awk '{print length}' | sort -nr | head -1`

        # Print header
        printf "%-${LENGTH}s %${C2}s %${C2}s %${C2}s %6s  %-10s\n" \
                "Device" "Size" "Used" "Free" "%Used" "Mount Point"

        # Cycle through each file system and print output
        #for FS in `df -${U} | grep "\/dev\/" | grep -v "tmpfs" | awk '{print $1}' | sort`; do
        # Added sort by key (K) functionality
        for FS in `df -${U} | grep "\/dev\/" | grep -v "tmpfs" | sort -n -k${K} | awk '{print $1}'`; do
                LINE=`df -${U} ${FS} | tail -1`
                DEV=`echo ${LINE} | awk '{print $1}'`
                SIZE=`echo ${LINE} | awk '{print $2}'`
                USED=`echo ${LINE} | awk '{print $3}'`
                FREE=`echo ${LINE} | awk '{print $4}'`
                PCT=`echo ${LINE} | awk '{print $5}'`
                MOUNT=`echo ${LINE} | awk '{print $6}'`

                printf "%-${LENGTH}s %${C2}s %${C2}s %${C2}s %6s  %-10s\n" \
                        "${DEV}" "${SIZE}" "${USED}" "${FREE}" "${PCT}" "${MOUNT}"
        done
}



##################################################
#         String manipulation functions
##################################################

# Set shell prompt
_set_prompt() { PS1="`whoami`@`hostname | sed 's/\..*//'`>" ; }


# Determine longest string in a list
_length() {
        LIST="$1"
        if [ "${LIST}" != "" ]; then
                LENGTH=`cat "${LIST}" | awk '{print length, $0}' | sort -nr | head -1 | awk '{print $1}'`
        fi
}


# Convert seconds to hours:minutes:seconds
_convert_secs() {
        if [ "$1" != "" ]; then
                h=`expr $1 / 3600`
                m=`expr $1 % 3600 / 60`
                s=`expr $1 % 3600`
                convertedtime=`printf "%02d:%02d:%02d\n" ${h} ${m} ${s}`
        fi
}


# Convert minutes to hours:minutes
_convert_mins() {
        if [ "$1" != "" ]; then
                h=`expr $1 / 60`
                m=`expr $1 % 60`
                convertedtime=`printf "%02d:%02d\n" ${h} ${m}`
        fi
}


_convert_date() {
        # Converts dates in the format YYYY-month-DD (e.g. 2014-Aug-15)
        # into YYYY-MM-DD (e.g. 2014-08-15)
        #
        # Call this function using the format:
        # ConvertDate "${date_variable_to_convert}" "converted_date_variable"
        # note the "$" in the first parameter and none in the second.
        #
        DATEIN="$1"
        param=$2
        YEAR="`echo ${DATEIN} | awk -F- '{print $1}'`"
        MONTHSTR="`echo ${DATEIN} | awk -F- '{print $2}'`"
        DAY="`echo ${DATEIN} | awk -F- '{print $3}'`"
        case ${MONTHSTR} in
                jan|Jan) MONTH=01 ;;
                feb|Feb) MONTH=02 ;;
                mar|Mar) MONTH=03 ;;
                apr|Apr) MONTH=04 ;;
                may|May) MONTH=05 ;;
                jun|Jun) MONTH=06 ;;
                jul|Jul) MONTH=07 ;;
                aug|Aug) MONTH=08 ;;
                sep|Sep) MONTH=09 ;;
                oct|Oct) MONTH=10 ;;
                nov|Nov) MONTH=11 ;;
                dec|Dec) MONTH=12 ;;
                *) MONTH=${MONTHSTR} ;;
        esac
        DATEOUT="${YEAR}-${MONTH}-${DAY}"
        eval ${param}="'${DATEOUT}'"
}


# Convert a string to lowercase
#_lowercase()   { echo "$1" | sed "y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/" ; }
_lowercase() {
        if [ "$1" != "" ]; then
                # Can either use sed or tr
                # tr may not work on some OS types
                echo "$1" | sed "y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/"
                #echo "$1" | tr '[A-Z]' '[a-z]'
        fi
}


# Convert a string to lowercase
_to_lower() {
        str="$@"
        output=`echo "${str}" | tr '[A-Z]' '[a-z]'`
        echo "${output}"
}


# Toggle a variable parameter
# TESTING - unsure if this actually works correctly
_toggle_param() {
        if [ "$1" != "" ]; then
                varname="$1"
                param=\$"$1"
                value=`eval expr "${param}"`
                # Toggle the variable
                test ${value} = "0" && eval ${varname}="1"
                test ${value} = "1" && eval ${varname}="0"
                test ${value} = "No" && eval ${varname}="Yes"
                test ${value} = "Yes" && eval ${varname}="No"
                test ${value} = "False" && eval ${varname}="True"
                test ${value} = "True" && eval ${varname}="False"
        fi
}



##################################################
#         File/dir manipulation functions
##################################################

# Lockfiles
_create_lock() { touch ${lockfile} ; }
_delete_lock() { rm -f ${lockfile} ; }


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


# Rotate a file and compress it
_rotate_file() {
        infile="$1"
        if [ -f "${infile}" ]; then
                if [ -x /bin/gzip ]; then
                        /bin/gzip -c "${infile}" > "${infile}".OLD.gz
                else
                        cp -p "${infile}" "${infile}".OLD
                fi
                cat /dev/null > "${infile}"
        else
                echo "${infile} not found"
        fi
}


# Rotate a log file, keeping multiple files
_rotate_log() {
        LOG="$1"
        if [ "${LOG}" != "" ]; then
                if [ -f "${LOG}" ]; then
                        if [ -w "${LOG}" ]; then
                                # Test each old copy of ${LOG} and move if it exists
                                test -f "${LOG}".2 && mv "${LOG}".2 "${LOG}".3
                                test -f "${LOG}".1 && mv "${LOG}".1 "${LOG}".2
                                test -f "${LOG}".0 && mv "${LOG}".0 "${LOG}".1
                                # Copy the original and preserve timestamp
                                cp -p "${LOG}" "${LOG}".0
                                # Clear out the original file
                                cat /dev/null > "${LOG}"
                        else
                                echo "Input file ${LOG} is not writeable"
                        fi
                else
                        echo "Input file ${LOG} does not exist"
                fi
        fi
}


# Rotate a log file, keeping X number of old files
_rotate_numlog() {
        LOG="$1"
        # Number of old files to keep
        num=53
        if [ "${LOG}" != "" ]; then
                if [ -f "${LOG}" ]; then
                        if [ -w "${LOG}" ]; then
                                # Initialize counters
                                count=${num}
                                # Set old counter to counter before it's decremented
                                ocount=${count}
                                while [ ${ocount} -gt 0 ]; do
                                        # Decrement the counter
                                        count=`expr ${count} - 1`
                                        # Test each old copy of ${LOG}.${count} and move if it exists
                                        test -f "${LOG}".${count} && mv "${LOG}".${count} "${LOG}".${ocount}
                                        # Reinitialize old counter
                                        ocount=${count}
                                done
                                # Copy the original and preserve timestamp
                                cp -p "${LOG}" "${LOG}".0
                                # Clear out the original file
                                cat /dev/null > "${LOG}"
                        else
                                echo "Input file ${LOG} is not writeable"
                        fi
                else
                        echo "Input file ${LOG} does not exist"
                fi
        fi
}


# Configure .vimrc for a user
_set_vimrc() {
        cat <<EOT > ~/.vimrc
set shiftwidth=4 softtabstop=4
set incsearch ignorecase hlsearch
set paste
set pastetoggle=<F2>
if has("terminfo")
  let &t_Co=16
  let &t_AB="\<Esc>[%?%p1%{8}%<%t%p1%{40}%+%e%p1%{92}%+%;%dm"
  let &t_AF="\<Esc>[%?%p1%{8}%<%t%p1%{30}%+%e%p1%{82}%+%;%dm"
else
  let &t_Co=16
  let &t_Sf="\<Esc>[3%dm"
  let &t_Sb="\<Esc>[4%dm"
endif
syntax on
EOT
}


# Create external sed script
_create_sed_join() {
        cat <<EOF > join_lines.sed
:join
/\\$/{N
s/\\\n//
b join
}

EOF
        chmod 755 join_lines.sed
}



##################################################
#         Functions to gather info
##################################################

# Determine if the user is root
# Input:    none
# Returns:  0 if user is root
#           1 if user is NOT root
# Usage:    rtest=`_isroot`
_isroot() {
        OS=`uname -s`
        case ${OS} in
                AIX)   ID=/usr/bin/id ;;
                Linux) ID=/usr/bin/id ;;
                SunOS) ID=/usr/xpg4/bin/id ;;
                *) return 1 ;;
        esac
#       test `${ID} -u` -eq 0 && echo "root" || echo "Not root"
#       test `${ID} -u` -eq 0 && return 0 || return 1
#       test `${ID} -u` -eq 0 && echo 0 || echo 1
        if [ `${ID} -u` -eq 0 ]; then
                echo 0
        else
                echo 1
        fi
}


##################################################
#         Functions to gather system info
##################################################

# Get count of CPUs (cores) on the system
# Input:    none
# Output:   # of CPUs (cores * threads per core)
# Usage:    cpucount=`_cpu_count`
_cpu_count() {
        OS=`uname -s`
        case ${OS} in
                SunOS)
                        CPUNUM=`psrinfo | wc -l | awk '{print $1}'`
                        ;;
                Linux)
                        CPUSOCKETS=`cat /proc/cpuinfo | grep "^physical id" | sort -u | wc -l`
                        CPUCORESPERSOCKET=`cat /proc/cpuinfo | grep "^core id" | sort -u | wc -l`
                        CPUNUM=`expr ${CPUSOCKETS} \* ${CPUCORESPERSOCKET}`
                        ;;
                AIX)
                        CPUCORES=`prtconf 2>/dev/null | grep -i "Number Of Processors:" | awk '{ print $4 }'`
                        CPUTHREADS=`lsattr -El proc0 -a smt_threads | awk '{print $2}' | tr -d ' '`
                        CPUNUM=`expr ${CPUCORES} \* ${CPUTHREADS}`
                        ;;
        esac
        echo ${CPUNUM}
}


