#!/bin/bash

echo "cleaning BAMs"
samtools view -bq 1 rep1.bam > rep1_clean.bam
samtools view -bq 1 rep2.bam > rep2_clean.bam
samtools view -bq 1 control.bam > control_clean.bam


#samtools view -bq 0 rep1.bam > rep1_bad.bam
#samtools view -bq 0 rep2.bam > rep2_bad.bam
#samtools view -bq 0 control.bam > control_bad.bam


echo "Computing Stats on raw mappings" 
samtools flagstat rep1.bam > rep1_results.txt
samtools flagstat rep2.bam > rep2_results.txt
samtools flagstat control.bam > control_results.txt

