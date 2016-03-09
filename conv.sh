#!/bin/sh
#
# Test convert CSH to Bourne shell
#

# Source common functions
. ./common.sh

OS=`uname -s`
NODE=`hostname | cut -d. -f1`

test1='(1)'
test2="(\"$OS\" == \"Linux\")"
test3="((\"$OS\" == \"SunOS\") || (\"$NODE\" == \"colossus\"))"
test4="((\"$OS\" == \"SunOS\") && (\"$NODE\" == \"colossus\"))"

for N in 1 2 3 4; do
	return=""
	eval convert_csh_to_sh \"\$test$N\"
#	test ${COMMAND} && echo Pass || echo Fail
	echo "if [ ${COMMAND} ]; then"
	if [ ${COMMAND} ] ; then
		echo "Pass"
	else
		echo "Fail"
	fi
#	retval=$?
	echo ""
done

#convert_csh_to_sh "$test2"
#convert_csh_to_sh "$test3"

echo "Done"

