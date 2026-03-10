#!/bin/sh
#
# Admin tool
#

# Source common libraries
. /home/admin/scripts/lib/libfunctions.sh
. /home/admin/scripts/lib/libsysinfo.sh
. /home/admin/scripts/lib/libcolors.sh
. /home/admin/scripts/lib/libnetwork.sh



###########################################################################
#         Initialize shell environment
###########################################################################
# Exit immediately if a command exits with a non-zero exit status
# Use this if needed but normally leave it commented out
#set -e

# Treat unset variables as an error when substituting
set -u

#set -Eeuo pipefail

# Use safe umask for the files we create
umask 027



###########################################################################
#         Global variables
###########################################################################
scriptpath="`dirname $0`"
scriptname="`basename $0`"
scriptnameshort="`basename $0 | cut -d. -f1`"

#scriptname=`basename $0 .sh`

mydir=`dirname $0`
date=`date +"%Y-%m-%d"`
DATE=`date +"%Y-%m-%d"`
YEAR="`date +'%Y'`"
osname="`uname -s`"
OSNAME="`uname -s`"
hostname="`hostname | cut -d. -f1`"
HOSTNAME="`uname -n | cut -d. -f1 | tr '[:upper:]' '[:lower:]'`"
HOSTSHORT="`echo ${HOSTNAME} | cut -c1-3`"
TMP="/tmp"
TESTING="No"
GOT_SYSTEM_INFO="No"

# Define location for software list file
SWLIST="${TMP}/software_${HOSTNAME}.out"
> "${SWLIST}"


# Initializing other variables used later in the script
# like variables displayed in the Main Menu that are not
# populated until the system info is gathered
input="TBD"
REV="TBD"
MFG="TBD"
MODEL="TBD"
SERIAL="TBD"
CPUNUM="TBD"
RAM="TBD"
SWAP="TBD"
IPADDR="TBD"
INTERFACE="TBD"
NETSPEED="TBD"


# Fix the hostname on the xhost servers
if [ "${HOSTNAME}" = "sdc-xhost" ]; then
        HOSTNAME=`cat /etc/hosts | grep -v "^#" | grep "sdc-xhost0" | awk '{print $2}'`
elif [ "${HOSTNAME}" = "xhos01" ]; then
        HOSTNAME=`cat /etc/hosts | grep -v "^#" | grep "xhos01" | awk '{print $2}'`
fi

# Set a parameter if server is a Solaris container/zone
if [ "${HOSTNAME}" = "e7sge" -o "${HOSTNAME}" = "e5sbm" ]; then
        CONTAINER="Yes"
        VIRTUAL="Yes"
else
        CONTAINER="No"
        VIRTUAL="No"
fi

# Define where the local log file goes
#LOG=${mydir}/data/${YEAR}/inventory.${HOSTNAME}.${DATE}
#test ! -d /var/adm && mkdir -p /var/adm
#if [ -d /var/adm ]; then
#       LOCALLOG=/var/adm/inventory.${HOSTNAME}
#elif [ -d /var/log ]; then
#       LOCALLOG=/var/log/inventory.${HOSTNAME}
#fi


###########################################################################
#         Functions
###########################################################################

# Trap and cleanup on exit condition
_cleanup() {
        echo "Exit Cleanup"
#       test -f ${reporttemp} && rm -f ${reporttemp}
}


# Screen output functions specific for atool
# Status OKAY message
# _okay "<text>"
_okay() { echo "${COLOR_GREEN}OKAY: $*${COLOR_RESET}" >&2 ; }

# Warning message
# _warn "<text>"
_warn() { echo "${COLOR_YELLOW}WARNING: $*${COLOR_RESET}" >&2 ; }

# Error message
# _err "<text>"
_err() { echo "${COLOR_RED}ERROR: $*${COLOR_RESET}" >&2 ; }

# Critical message
# _crit "<text>"
_crit() { echo "${COLOR_RED}ERROR: $*${COLOR_RESET}" >&2 ; }



Linux_OS() {
        # Linux - Software List
        /bin/rpm -qa | sort -u > ${SWLIST}

        # Linux - Determine the grub config file
        if [ -f /boot/grub/grub.conf ]; then
                BIOSTYPE="BIOS"
                grubconf=/boot/grub/grub.conf
#               grep 'password' ${grubconf} | grep -v '^#' >/dev/null
#               if [ $? -eq 0 ]; then
#                       grubpass="Set"
#               fi
        elif [ -f /boot/grub2/grub.cfg ]; then
                BIOSTYPE="BIOS"
                grubconf=/boot/grub2/grub.cfg
#               grep 'password_pbkdf2' ${grubconf} | grep -v '^#' >/dev/null
#               if [ $? -eq 0 ]; then
#                       grubpass="Set"
#               fi
        elif [ -f /boot/efi/EFI/redhat/grub.cfg ]; then
                BIOSTYPE="UEFI"
                grubconf=/boot/efi/EFI/redhat/grub.cfg
#               grep 'password_pbkdf2' ${grubconf} | grep -v '^#' >/dev/null
#               if [ $? -eq 0 ]; then
#                       grubpass="Set"
#               fi
        fi
}


AIX_OS() {
        LSATTR=${TMP}/${HOSTNAME}.lsattr.${DATE}
        PRTCONF=${TMP}/${HOSTNAME}.prtconf.${DATE}

        lsattr -El sys0 > ${LSATTR}
        prtconf > ${PRTCONF} 2>&1

        # Software List
        lslpp -Lc | sort -u > ${SWLIST}
}


SunOS_OS() {
        PLATFORM=`uname -m`
        PRTDIAG=${TMP}/${HOSTNAME}.prtdiag.${DATE}
        PRTCONF=${TMP}/${HOSTNAME}.prtconf.${DATE}
        prtconf -p > ${PRTCONF}

        # Check for Solaris Zone as prtdiag won't run on containers
        if [ "${CONTAINER}" = "Yes" ]; then
                echo ""
#               rsh e7cont02 "/usr/platform/sun4v/sbin/prtdiag -v > /tmp/e7cont02.prtdiag.${DATE}"
#               rcp e7cont02:/tmp/e7cont02.prtdiag.${DATE} /tmp/${HOSTNAME}.prtdiag.${DATE}
        else
                /usr/platform/${PLATFORM}/sbin/prtdiag -v > ${PRTDIAG}
        fi

        # Software List
#       pkginfo -x | paste -d"\ t\ n" - - > ${SWLIST}
}


# Parent function to call other system info gathering functions
_gather_system_info() {
        if [ ${GOT_SYSTEM_INFO} != "Yes" ]; then
                _blank
                echo "Gathering system info, please be patient . . ."
                _blank

                # Call OS specific functions
                case ${OSNAME} in
                        AIX)
                                AIX_OS
                                ;;
                        Linux)
                                Linux_OS
                                ;;
                        SunOS)
                                SunOS_OS
                                ;;
                        *)
                                echo "Cannot determine OS information for ${HOSTNAME}"
                                ;;
                esac

                # Gather information
                _param_group_os_basic

                # ParamSystem="MFG MODEL SERIAL FIRMWARE BIOSTYPE BIOSPASS"
                _param_mfg
                _param_model
                _param_serial

                # ParamOS="OSNAME OSRELEASE OSREVISION OSCLASS PSEUDONAME"
                _param_group_os_basic

                # ParamCPU="CPUTYPE CPUSOCKETS CPUNUM CPUSPEED CPUTHREADS ARCH"
                _param_arch
                _param_group_cpu

                # ParamRAM="RAM SWAP PROCS"
                _param_ram
                _param_swap
                _param_procs

                # ParamNet="SITE IPADDR DEFROUTE INTERFACE NETSPEED"
                #_param_group_net
                # For networking keep defroute first, then defnet as they are used in the later network functions
                _param_defroute
                _param_defnet
                _param_ipaddr
                _param_interface
                # netspeed has to be after interface function
                _param_netspeed

                _param_uptime

                # Set the variable to prevent this subroutine from running again
                GOT_SYSTEM_INFO="Yes"
        else
                _blank
                echo "System info was already gathered"
                sleep 2
                _blank
        fi
}


# User list
_list_users() {
        case ${OSNAME} in
                AIX)
                        echo ""
                        ;;
                Linux)
                        #lslogins -s
                        for user in `grep -v '^+' /etc/passwd | cut -d: -f1`; do
                                uid=`grep "^${user}:" /etc/passwd | cut -d: -f3`
                                gid=`grep "^${user}:" /etc/passwd | cut -d: -f4`
                                gecos=`grep "^${user}:" /etc/passwd | cut -d: -f5`
                                printf "%-20s %10d %10d  %-30s\n" "${user}" "${uid}" "${gid}" "${gecos}"
                        done
                        ;;
                SunOS)
                        #logins -s
                        for user in `grep -v '^+' /etc/passwd | cut -d: -f1`; do
                                uid=`grep "^${user}:" /etc/passwd | cut -d: -f3`
                                gid=`grep "^${user}:" /etc/passwd | cut -d: -f4`
                                gecos=`grep "^${user}:" /etc/passwd | cut -d: -f5`
                                printf "%-20s %10d %10d  %-30s\n" "${user}" "${uid}" "${gid}" "${gecos}"
                        done
                        ;;
                *)
                        echo ""
                        ;;
        esac
        _pause
}


###########################################################################
#         Troubleshooting Functions
###########################################################################
##
## atool functions for troubleshooting stuff
##

# Parent function to call other troubleshooting functions
_automated_troubleshooting() {
        _blank
        echo "Running automated troubleshooting routines"
        # Need to get system info if it has not already been completed
        _gather_system_info
        _blank
        # Network checks
        _check_network_default_gateway
        # DNS checks
        _check_dns_servers_defined
        _check_dns_servers_reachable
        _check_dns_resolves_hostname
        _check_dns_resolves_ip
        sleep 2
        if [ "${TESTING}" != "Yes" ]; then
                echo "Press Enter key to return to main menu"
                read automated_return
        fi
}


# Check how many DNS servers are defined in /etc/resolv.conf
_check_dns_servers_defined() {
        _blank
        echo "Checking DNS servers defined"
        num_dns_servers=`grep '^nameserver' /etc/resolv.conf | wc -l | awk '{print $1}'`
        if [ ${num_dns_servers} -eq 0 ]; then
                _crit "System has ${num_dns_servers} defined"
        elif [ ${num_dns_servers} -eq 1 ]; then
                _warn "System has ${num_dns_servers} defined"
        elif [ ${num_dns_servers} -eq 2 ]; then
                _okay "System has ${num_dns_servers} defined"
        elif [ ${num_dns_servers} -eq 3 ]; then
                _okay "System has ${num_dns_servers} defined"
        elif [ ${num_dns_servers} -gt 3 ]; then
                _warn "System has more than ${num_dns_servers} defined"
        else
                _warn "Could not determine number of DNS servers defined"
        fi
        _blank
}

# Check if DNS servers defined are reachable
_check_dns_servers_reachable() {
        _blank
        echo "Checking DNS servers reachable"
        for dnsip in `grep '^nameserver' /etc/resolv.conf | awk '{print $2}'`; do
                pretval=`_ping_host "${dnsip}"`
                if [ "${pretval}" = "alive" ]; then
                        _okay "${dnsip} is pingable"
                else
                        _warn "${dnsip} is NOT pingable"
                fi
        done
        _blank
}

# Check if DNS resolves the hostname
_check_dns_resolves_hostname() {
        _blank
        echo "Checking DNS resolves hostname"
        for drlookup in ${HOSTNAME}; do
                nslookup ${drlookup} > /dev/null
                DRETVAL=$?
                if [ ${DRETVAL} -ne 0 ]; then
                        _warn "DNS lookup of ${drlookup} failed"
                else
                        _okay "DNS lookup of ${drlookup} succeeded"
                fi
        done
        _blank
}

# Check if DNS resolves the IP address
_check_dns_resolves_ip() {
        _blank
        echo "Checking DNS resolves hostname"
        for drlookup in ${IPADDR}; do
                nslookup ${drlookup} > /dev/null
                DRETVAL=$?
                if [ ${DRETVAL} -ne 0 ]; then
                        _warn "DNS lookup of ${drlookup} failed"
                else
                        _okay "DNS lookup of ${drlookup} succeeded"
                fi
        done
        _blank
}



# Check how many default gateways are defined
# grep '^DEFROUTE=yes' /etc/sysconfig/network-scripts/ifcfg*
# netstat -nr | awk '$3=="UG" {print}'
_check_network_default_gateway() {
        _blank
        echo "Checking network default gateways"
        case ${OSNAME} in
                Linux)
                        num_defroutes=`netstat -nr | awk '$4=="UG" {print}' | wc -l | awk '{print $1}'`
                        ;;
                SunOS)
                        num_defroutes=`netstat -nr | awk '$3=="UG" {print}' | wc -l | awk '{print $1}'`
                        ;;
        esac
        if [ ${num_defroutes} -eq 1 ]; then
                _okay "Number of default routes is ${num_defroutes}"
        else
                _crit "Number of default routes is ${num_defroutes}"
        fi
        _blank
}

# Check if there is network subnet overlap
_check_network_subnet_overlap() {
        _blank
}



# Check if NIS is enabled
_check_nis_enabled() {
        _blank
}

# Check if NIS is bound
_check_nis_bound() {
        _blank
}


###########################################################################
#         Menu Functions
###########################################################################

# Script main menu (MainMenu)
MainMenu() {
        input="TEMP"
        clear
        _blank
        echo '------------------------------'
        echo "     Admin Tool Main Menu     "
        echo '------------------------------'
        _blank
        echo "  Hostname:    ${HOSTNAME}"
        echo "  OS Version:  ${OSNAME} ${REV}"
        echo "  System Type: ${MFG} ${MODEL}"
        echo "  Serial:      ${SERIAL}"
        echo "  CPUs:        ${CPUNUM}"
        echo "  RAM:         ${RAM}  (SWAP: ${SWAP})"
        echo "  Network:     ${IPADDR} (${INTERFACE} - ${NETSPEED})"
#       echo "  Hostname:    ${period}"
#       echo "  Hostname:    ${period}"
        _blank
        echo "  1. Gather System Info"
        echo "  2. Account Management"
        echo "  3. Network Info"
        echo "  4. Firewall Info"
        echo "  8. Troubleshooting Routines"
        echo "  9. Automated Troubleshooting"
        _blank
        echo "  0. Exit ${scriptname}"
        _blank
        printf "Selection: "
        read input

        case ${input} in
                1)      _gather_system_info ;;
                2)      ainput=9
                        while [ "${ainput}" != "0" ]; do
                                AccountMenu
                        done
                        ;;
                3)
                        _blank
                        ;;
                4)
                        _blank
                        ;;
                5)
                        _blank
                        ;;
                8)      tinput=9
                        while [ "${tinput}" != "0" ]; do
                                TroubleshootingMenu
                        done
                        ;;
                9)
                        _automated_troubleshooting
                        ;;
                0)      _blank ;;
#               a|A) pinput=9
#                       PeriodSelectMenu
#                       ;;
                *) echo "Invalid selection" ;;
        esac
}


# Account Management Menu
AccountMenu() {
        clear
        _blank
        echo '-------------------------------'
        echo "    Account Management Menu    "
        echo '-------------------------------'
        echo ""
        echo "  1. List users"
        echo "  2. List users and expiration dates"
#       echo "  3. week-ago   (rolling week)"
#       echo "  4. this-month (current calendar month)"
#       echo "  5. this-year"
#       echo "  6. "
#       echo "  7. previous X days"
        echo "  0. Return to Main Menu"
        _blank
        printf "Selection: "
        read ainput

        case ${ainput} in
                1)      _list_users
                        ;;
                2)      _list_users_expiration
                        ;;
                3)      period="week-ago"
                        ;;
                4)      period="this-month"
                        ;;
                5)      period="this-year"
                        ;;
                0)      _blank ;;
                *)      echo "Invalid selection" ;;
        esac
}


# Troubleshooting Menu
TroubleshootingMenu() {
        clear
        _blank
        echo '-------------------------------'
        echo "    Troubleshooting Menu       "
        echo '-------------------------------'
        echo ""
        echo "  1. Network - Default Gateway"
        echo "  2. DNS Servers"
        echo "  3. DNS Resolution"
#       echo "  4. SELinux Mode"
#       echo "  5. QAS Config"
#       echo "  6. "
#       echo "  7. "
#       echo "  8. "
#       echo "  9. "
        echo "  0. Return to Main Menu"
        _blank
        printf "Selection: "
        read tinput

        case ${tinput} in
                1)      _check_network_default_gateway
                        echo "Enter to return to menu"
                        read tinputmenu
                        ;;
                2)      _check_dns_servers_defined
                        _check_dns_servers_reachable
                        echo "Enter to return to menu"
                        read tinputmenu
                        ;;
                3)      _check_dns_resolves_hostname
                        _check_dns_resolves_ip
                        echo "Enter to return to menu"
                        read tinputmenu
                        ;;
#               4)      period="this-month"
#                       ;;
#               5)      period="this-year"
#                       ;;
                0)      _blank ;;
                *)      echo "Invalid selection" ;;
        esac
}



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
#trap _cleanup SIGINT SIGTERM EXIT

# Cleanup on exit
trap _cleanup EXIT



###########################################################################
#         Input options and/or getopts
###########################################################################

## Uncomment and change parameters as necessary
## Remember to put a colon ":" after each letter parameter that requires an argument
while getopts "a:rt" opt; do
        case $opt in
                a) echo "-a was used, parameter: $OPTARG" >&2 ;;
                r) MODE="report" ;;
                t) TESTING="Yes" ;;
                \?) _die "Invalid option: -$OPTARG" ;;
                :) _die "Option -$OPTARG requires an argument" ;;
        esac
done

if [ "${TESTING}" = "Yes" ]; then
        _automated_troubleshooting
        exit 0
fi


###########################################################################
#         MAIN SCRIPT
###########################################################################
# Display the main menu
while [ "${input}" != "0" ]; do
        MainMenu
done


exit 0



rtest=`_isroot`
echo "rtest: ${GREEN}$rtest${RESET}"

if [ ${rtest} -eq 0 ]; then
        echo "Running as root"
else
        echo "Running as normal user"
fi

ttest="This is a TEST"
utest=`_to_lower "${ttest}"`
echo "${ttest}"
echo "${utest}"

