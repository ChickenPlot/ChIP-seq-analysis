#!/bin/bash
mkdir macs2_rep1 
mkdir macs2_rep2 
mkdir macs2_mergedPeaks

echo "calling peaks on rep1"
cd macs2_rep1
macs2 callpeak -t ../rep1_clean.bam -c ../control_clean.bam -g hs -q 0.01 -B --SPMR -n rep1

echo "calling peaks on rep2"
cd ../macs2_rep2
macs2 callpeak -t ../rep2_clean.bam -c ../control_clean.bam -g hs -q 0.01 -B --SPMR -n rep2

#merged 
echo "merging and calling peaks"
cd ../macs2_mergedPeaks
macs2 callpeak -t ../rep2_clean.bam ../rep1_clean.bam -c ../control_clean.bam -g hs -q 0.01 -B --SPMR -n Merged

echo "done"