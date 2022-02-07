#!/bin/sh
if [ "$ANALYZE" = "true" ] ; then
	cppcheck --error-exitcode=1 -j2 -DRANGECHECK -ISource Source toolsrc 2> stderr.txt
	RET=$?
	if [ -s stderr.txt ]
	then
		cat stderr.txt
	fi
	exit $RET
else
	set -e
	export VERBOSE=1
	rm -rf CMakeCache.txt CMakeFiles/
	mkdir build && cd build
	cmake -G "Unix Makefiles" "$CROSSRULE" .. -DENABLE_WERROR=ON
	make
	make install/strip DESTDIR=/tmp/whatever
	make package
fi
