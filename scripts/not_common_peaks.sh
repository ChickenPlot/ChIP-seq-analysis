#!/bin/bash
 
#intersect  
bedtools intersect -a macs2_rep1/rep1_summits_filtered_sorted.bed -b ENCODE_peaks_sorted.bed -v | cut -f1-5 > non_common_peaks/rep1_noncommon_peaks.bed
bedtools intersect -a macs2_rep2/rep2_summits_filtered_sorted.bed -b ENCODE_peaks_sorted.bed -v | cut -f1-5 > non_common_peaks/rep2_noncommon_peaks.bed
bedtools intersect -a macs2_mergedPeaks/merged_summits_filtered_sorted.bed -b ENCODE_peaks_sorted.bed -v | cut -f1-5 > non_common_peaks/merged_noncommon_peaks.bed

#bedtools intersect -a macs2_rep1/rep1_summits_filtered_sorted.bed -b macs2_rep2/rep2_summits_filtered_sorted.bed