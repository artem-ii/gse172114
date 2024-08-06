#! /bin/bash

cat "${1:-/dev/stdin}" |
while IFS= read -r line; do
	echo "reading" $line
	prefetch $line
	cd $line
	fasterq-dump $line.sra
	rm $line.sra
	cd ..
done

