#!/bin/sh
#
# Common Bourne/Bash Functions
#

hostname=`hostname | cut -d. -f1`    # Local hostname
date=`date +"%Y-%m-%d"`   # Date stamp YYYY-MM-DD
fiscalweek=`date +"%V"`           # Current Fiscal Week
osname=`uname -s`             # OS Type
os=`uname -s`             # OS Type
tmp=/tmp

# Define color variables
CYAN="[0;36m"
BLUE="[0;34m"
BROWN="[0;33m"
DARKGRAY="[0;30m"
GRAY="[0;37m"
GREEN="[1;32m"
LIGHTBLUE="[0;94m"
MAGENTA="[1;35m"
PURPLE="[0;35m"
RED="[1;31m"
YELLOW="[1;33m"
WHITE="[1;37m"

# With background
BG_BLUE="[0;44m"

# Semantic names
HEADER="${WHITE}"
NORMAL="[0;39m"
WARNING="[1;31m"          # Bad (red)
SECTION="[1;33m"          # Section (yellow)
NOTICE="[1;33m"           # Notice (yellow)
OK="[1;32m"               # Ok (green)
BAD="[1;31m"              # Bad (red)


########################################
# Functions
########################################
#
#
# Getopts example:
# while getopts "n:e:o:i:s" flag "$@"; do
#     case $flag in
#         n) exclude+=$OPTARG ;;
#         e) errx=$OPTARG ;;
#         o) outx=$OPTARG ;;
#         i) inx=$OPTARG ;;
#         s) split=false ; exclude+== ;;
#     esac
# done
#

blank_line() { echo "" ; }
single_rule() { echo '----------------------------------------------------------------------' ; }
double_rule() { echo '======================================================================' ; }
lower_case() { echo "$1" | sed "y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/" ; }


# Set shell prompt
set_prompt() {
	PS1="`whoami`@`hostname | sed 's/\..*//'`>"
}


isroot() {
	case ${os} in
		AIX)   ID=/usr/bin/id ;;
		Linux) ID=/usr/bin/id ;;
		SunOS) ID=/usr/xpg4/bin/id ;;
		*) exit 1 ;;
	esac
	test `${ID} -u` -eq 0 && echo "root" || echo "Not root"
}


DomainName() {
	if [ -f /etc/resolv.conf ]; then
		if [ "`grep domain /etc/resolv.conf`" != "" ]; then
			DOMAIN=`grep domain /etc/resolv.conf | awk '{print $2}'`
		elif [ "`grep search /etc/resolv.conf`" != "" ]; then
			DOMAIN=`grep search /etc/resolv.conf | awk '{print $2}'`
		else
			DOMAIN="UNKNOWN"
		fi
	fi
}


# Backup a file
backup_file() {
	file="$1"
	if [ "${file}" != "" ]; then
		if [ -f ${file} ]; then
			if [ ! -f ${file}.${date} ]; then
				cp -p ${file} ${file}.${date}
			else
				echo "${file}.${date} already exists!"
			fi
		fi
	fi
}


# Rotate a log file
rotate_log() {
	log="$1"
	if [ "${log}" != "" ]; then
		if [ -f ${log} ]; then
			if [ -w ${log} ]; then
				# Test each old copy of $log and move if it exists
				test -f ${log}.2 && mv ${log}.2 ${log}.3
				test -f ${log}.1 && mv ${log}.1 ${log}.2
				test -f ${log}.0 && mv ${log}.0 ${log}.1
				# Copy the original and preserve timestamp
				cp -p ${log} ${log}.0
				# Clear out the original file
				cat /dev/null > ${log}
			else
				echo "Input file ${log} is not writeable"
			fi
		else
			echo "Input file ${log} does not exist"
		fi
	else
		echo "No file specified"
		echo "Usage: rotate_log <file>"
	fi
}


# Ping a host
# Input: <hostname>
# Output: [alive|down]
ping_host() {
	me=`basename $0`
	# Ping count
	count=2
	if [ "$1" = "" ]; then
		echo "Usage: ${me} <host>"
	else
		host="$1"
		# Use specific ping syntax per OS type
		case $OS in
			AIX)
				ping ${host} 56 ${count} > /dev/null
				retval=$?
				;;
			Linux)
				ping -c ${count} ${host} > /dev/null
				retval=$?
				;;
			SunOS)
				ping -s ${host} 56 ${count} > /dev/null
				retval=$?
				;;
		esac
		if [ ${retval} -ne 0 ] ; then
			echo "down"
		else
			echo "alive"
		fi
	fi
}


# Check SSH/RSH access to a host
# Input: <hostname>
# Output: [ssh|rsh|none]
test_host_access() {
	me=`basename $0`
	rsh=/usr/sbin/rsh
	if [ "$1" = "" ]; then
		echo "Usage: test_host_access <host>"
	else
		host="$1"
		sshopts="-o BatchMode=yes"
		sshrv=`ssh -q ${sshopts} ${host} uname -s 2>&1`
		srv=$?
		if [ ${srv} -eq 0 ]; then
			echo "ssh"
		else
			rshrv=`${rsh} ${host} 'uname -s' 2>&1`
			rrv=$?
			if [ ${rrv} -eq 0 ]; then
				echo "rsh"
			else
				echo "none"
			fi
		fi
	fi
}


# Determine longest string in a list
length() {
	list="$1"
	if [ "${list}" != "" ]; then
		length=`cat ${list} | awk '{print length, $0}' | sort -nr | head -1 | awk '{print $1}'`
	fi
	echo "${length}"
}


# UUEncode and email a file
uuemail() {
	file="$1"
	email="$2"
	if [ "$file" = "" -o "$email" = "" ]; then
		echo "uuemail syntax:"
		echo "uuemail <file> <email>"
		echo ""
		echo "Example: uuemail /tmp/test.txt brian.hendricks@lmco.com"
		echo ""
	else
		uuencode ${file} ${file} | mail -s "Sending CSV file from ${hostname}" "${email}"
	fi
}


convert_csh_to_sh() {
  # Convert test checks:
  # () to []
  # == to =
  # && to -a
  # || to -o
  COMMAND=""
  echo "Converting $1 to bourne syntax"
#  COMMAND=`echo "$1" | tr '()' '[]' | sed -e 's/\=\=/\=/g' -e 's/&&/-a/g' -e 's/||/-o/'g`
  COMMAND=`echo "$1" | tr '()' ' ' | sed -e 's/\=\=/\=/g' -e 's/&&/-a/g' -e 's/||/-o/'g`
  echo "${COMMAND}"
}

