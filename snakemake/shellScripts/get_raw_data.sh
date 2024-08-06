#! /bin/bash

read -p "Enter GSE accession: " GSE
./srr_from_gse.sh $GSE > srr.txt
cat srr.txt | parallel --pipe -N 1 ./download_fastq.sh
move_fastq_files.sh
