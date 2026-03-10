#
# Common Bourne/Bash Functions for Unix/Linux Operating Systems
#
# libnetwork.sh
#
# Network variables and functions
#
# Source these in other scripts with this syntax (without the "# "):
# . /home/admin/scripts/lib/libnetwork.sh
#
#


## Variables
OS="`uname -s`"


## Functions

# Ping a host
# Input: <hostname>
# Output: [alive|down]
# Usage: pretval=`_ping_host hostname`
_ping_host() {
        ME=`basename $0`
        OS="`uname -s`"
        # Ping count
        COUNT=2
        if [ "$1" = "" ]; then
                echo "Usage: ${ME} <host>"
        else
                HOST="$1"
                # Use specific ping syntax per OS type
                case ${OS} in
                        AIX)
                                ping ${HOST} 56 ${COUNT} > /dev/null
                                RETVAL=$?
                                ;;
                        Linux)
                                ping -c ${COUNT} ${HOST} > /dev/null
                                RETVAL=$?
                                ;;
                        SunOS)
                                ping -s ${HOST} 56 ${COUNT} > /dev/null
                                RETVAL=$?
                                ;;
                esac
                if [ ${RETVAL} -ne 0 ] ; then
                        echo "down"
                else
                        echo "alive"
                fi
        fi
}


# Check SSH/RSH access to a host
# Input: <hostname>
# Output: [ssh|rsh|none]
_test_host_access() {
        ME=`basename $0`
        SSH="ssh"
        RSH="rsh"
        if [ "$1" = "" ]; then
                echo "Usage: ${ME} <host>"
        else
                SSHOPTS="-o BatchMode=yes"
                SSHrv=`${SSH} -q ${SSHOPTS} ${HOST} uname -s 2>&1`
                SRV=$?
                if [ ${SRV} -eq 0 ]; then
                        echo "ssh"
                else
                        RSHrv=`${RSH} ${HOST} 'uname -s' 2>&1`
                        RRV=$?
                        if [ ${RRV} -eq 0 ]; then
                                echo "rsh"
                        else
                                echo "none"
                        fi
                fi
        fi
}

