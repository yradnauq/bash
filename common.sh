#!/bin/bash
#
# Common Bash Functions
#

convert_csh_to_sh() {
	# Convert test checks:
	# () to []
	# == to =
	# && to -a
	# || to -o
	COMMAND=""
	echo "Converting $1 to bourne syntax"
#	COMMAND=`echo "$1" | tr '()' '[]' | sed -e 's/\=\=/\=/g' -e 's/&&/-a/g' -e 's/||/-o/'g`
	COMMAND=`echo "$1" | tr '()' ' ' | sed -e 's/\=\=/\=/g' -e 's/&&/-a/g' -e 's/||/-o/'g`
	echo "${COMMAND}"
}

