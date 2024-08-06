#! /bin/bash
esearch -db gds -query $1 | esummary | xtract -pattern DocumentSummary -element TargetObject |
while read -r line; do
    esearch -db sra -query $line"[ACCN]" | esummary | xtract -pattern DocumentSummary -element Run@acc
done
