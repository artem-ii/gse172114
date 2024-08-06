#! /bin/bash
mkdir samples

for dir in ./SRR*; do
	cd $dir;
	for f in ./*.fastq; do
		mv $f ../samples/;
	done;
	cd ..;
done

rm -R ./SRR*
