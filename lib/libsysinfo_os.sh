#
# Common Bourne/Bash Functions for Unix/Linux Operating Systems
#
# libsysinfo_os.sh
#
# System info variables and functions
#
# Source these in other scripts with this syntax (without the "# "):
# . /home/admin/scripts/lib/FILENAME
#
#


# ParamOS="OSNAME OSRELEASE OSREVISION OSCLASS PSEUDONAME"

# Notes:
# OSNAME will be one of: AIX, SunOS, or Linux
# OSREV/OSREVISION = OS major.minor version (e.g. 7.8)
# OSREL/OSRELEASE  = OS major version (e.g. 7)
# OSCLASS should be server, workstation, client, or something similar
# DISTRO = Linux Distribution (e.g. Fedora, RHEL, CentOS)

_param_group_os_basic() {
        PS="ps -ef"
        OSNAME="`uname -s`"
        case ${OSNAME} in
                AIX)
                        OSRELEASE="`uname -v`"
                        OSREV="`uname -v`.`uname -r`"
                        OSREVISION="v${OSREV}"
                        OSCLASS="`chedition -l`"
                        DISTRO=""
                        #
                        # Alternate format for AIX release info
                        # "oslevel" generates "5.3.0.0"
                        # "oslevel -r" generates "5300-12"
                        ;;

                SunOS)
                        OSRELEASE="`uname -r | cut -d. -f1`"
                        OSREV="`uname -r`"
                        OSREVISION="v${OSREV}"
                        DISTRO=""
                        if [ "${OSNAME}" = "SunOS" -a ${OSRELEASE} -lt 5 -o "${OSREV}" = "5.6" ]; then
                                OLDSUN="Yes"
                                PS="ps -auxww"
                        else
                                OLDSUN="No"
                        fi
                        #
                        # Alternate format for SunOS release info
                        # `uname -s` `uname -r` `uname -p` `uname -v`
                        # Generates:
                        # SunOS 5.10 sparc Generic_150400-65
                        ;;

                Linux)
                        if [ -f /etc/fedora-release ]; then
                                DISTRO="Fedora"
                                FILE=/etc/fedora-release
                                OSRELEASE=`cat ${FILE} | sed s/.*release\ // | sed s/\ .*// | cut -d. -f1`
                                OSREV=`cat ${FILE} | sed s/.*release\ // | sed s/\ .*//`
                                OSREVISION="v${OSREV}"
                                PSEUDONAME=`cat ${FILE} | sed s/.*\(// | sed s/\)//`
                        elif [ -f /etc/centos-release ]; then
                                DISTRO="CentOS"
                                FILE=/etc/centos-release
                                DIST=`cat ${FILE} | sed s/\ release.*//`
                                OSRELEASE=`cat ${FILE} | sed s/.*release\ // | sed s/\ .*// | cut -d. -f1`
                                OSREV=`cat ${FILE} | sed s/.*release\ // | sed s/\ .*//`
                                OSREVISION="v${OSREV}"
                                OSCLASS="`cat ${FILE} | sed s/\ release.*// | awk '{print $NF}'`"
                                PSEUDONAME=`cat ${FILE} | sed s/.*\(// | sed s/\)//`
                        elif [ -f /etc/redhat-release ]; then
                                DISTRO="RedHat"
                                FILE=/etc/redhat-release
                                DIST=`cat ${FILE} | sed s/\ release.*//`
                                OSRELEASE=`cat ${FILE} | sed s/.*release\ // | sed s/\ .*// | cut -d. -f1`
                                OSREV=`cat ${FILE} | sed s/.*release\ // | sed s/\ .*//`
                                OSREVISION="v${OSREV}"
                                OSCLASS="`cat ${FILE} | sed s/\ release.*// | awk '{print $NF}'`"
                                PSEUDONAME=`cat ${FILE} | sed s/.*\(// | sed s/\)//`
                                RHVER=`cat ${FILE} | head -1 | awk '{print $1" "$2" "$3}'`
                                # RHEL 8 does not list the OS class/role in the release file
                                # but it can be obtained from the syspurpose command
                                if [ ${OSRELEASE} -ge 8 ]; then
                                        OSCLASS="`syspurpose show | grep 'role' | awk -F: '{print $2}' | sed -e 's/\"//g' -e 's/,//g' | awk '{print $NF}'`"
                                fi
                                if [ "${RHVER}" = "Red Hat Enterprise" ]; then
                                        DISTRO="RHEL"
                                elif [ "${RHVER}" = "Red Hat Enterprise" ]; then
                                        DISTRO="RedHat"
                                else
                                        DISTRO="RedHat"
                                fi
                        elif [ -f /etc/SuSE-release ]; then
                                DISTRO="SUSE"
                                FILE=/etc/SuSE-release
                                OSRELEASE=`cat ${FILE} | tr "\n" ' ' | sed s/.*=\ // | cut -d. -f1`
                                OSREV=`cat ${FILE} | tr "\n" ' ' | sed s/.*=\ //`
                                OSREVISION="v${OSREV}"
                                PSEUDONAME=`cat /etc/SuSE-release | tr "\n" ' '| sed s/VERSION.*//`
                        elif [ -f /etc/mandrake-release ] ; then
                                DISTRO="Mandrake"
                                FILE=/etc/mandrake-release
                                OSRELEASE=`cat ${FILE} | sed s/.*release\ // | sed s/\ .*// | cut -d. -f1`
                                OSREV=`cat ${FILE} | sed s/.*release\ // | sed s/\ .*//`
                                OSREVISION="v${OSREV}"
                                PSEUDONAME=`cat ${FILE} | sed s/.*\(// | sed s/\)//`
                        elif [ -f /etc/debian_version ] ; then
                                FILE=/etc/lsb-release
                                DISTRO=`cat ${FILE} | grep '^DISTRIB_ID' | awk -F= '{ print $2 }'`
                                DIST=`cat ${FILE} | grep '^DISTRIB_ID' | awk -F= '{ print $2 }'`
                                OSRELEASE=`cat ${FILE} | grep '^DISTRIB_RELEASE' | awk -F= '{ print $2 }' | cut -d. -f1`
                                OSREV=`cat ${FILE} | grep '^DISTRIB_RELEASE' | awk -F= '{ print $2 }'`
                                OSREVISION="v${OSREV}"
                                PSEUDONAME=`cat ${FILE} | grep '^DISTRIB_CODENAME' | awk -F= '{ print $2 }'`
                        else
                                OSRELEASE="`uname -r | cut -d. -f1`"
                                OSREV="`uname -r`"
                                OSREVISION="v${OSREV}"
                                DISTRO=""
                        fi
                        ;;

                *)
                        OSRELEASE="N/A"
                        OSREV="N/A"
                        OSREVISION="N/A"
                        DISTRO="N/A"
                        ;;
        esac
        REL="${OSRELEASE}"
        REV="${OSREVISION}"
}
