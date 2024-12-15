#!/bin/bash

# remove blacklisted regions from macs2 summits files 
#bedtools sort -i ../GRCh38_unified_blacklist.bed >  ../GRCh38_unified_blacklist_sorted.bed
bedtools intersect -a macs2_rep1/rep1_summits.bed -b GRCh38_unified_blacklist_sorted.bed -v > macs2_rep1/rep1_summits_filtered.bed
bedtools intersect -a macs2_rep2/rep2_summits.bed -b GRCh38_unified_blacklist_sorted.bed -v > macs2_rep2/rep2_summits_filtered.bed
bedtools intersect -a macs2_mergedPeaks/Merged_summits.bed -b GRCh38_unified_blacklist_sorted.bed -v > macs2_mergedPeaks/merged_summits_filtered.bed


# remove from the narrowpeak file 
bedtools intersect -a macs2_rep1/rep1_peaks.narrowPeak -b GRCh38_unified_blacklist_sorted.bed -v > macs2_rep1/rep1_peaks_filtered.bed
bedtools intersect -a macs2_rep2/rep2_peaks.narrowPeak -b GRCh38_unified_blacklist_sorted.bed -v > macs2_rep2/rep2_peaks_filtered.bed
bedtools intersect -a macs2_mergedPeaks/Merged_peaks.narrowPeak -b GRCh38_unified_blacklist_sorted.bed -v > macs2_mergedPeaks/merged_peaks_filtered.bed


# sort to use with bedtools closest
bedtools sort -i macs2_rep2/rep2_summits_filtered.bed > macs2_rep2/rep2_summits_filtered_sorted.bed
bedtools sort -i macs2_rep1/rep1_summits_filtered.bed > macs2_rep1/rep1_summits_filtered_sorted.bed
bedtools sort -i macs2_mergedPeaks/merged_summits_filtered.bed > macs2_mergedPeaks/Merged_summits_filtered_sorted.bed
bedtools sort -i ENCODE_peaks.bed > ENCODE_peaks_sorted.bed

# COMMON PEAKS WITH SUMMITS
mkdir common
mkdir common/summits
mkdir common/overlaps

# rep1_rep2
bedtools closest -a macs2_rep1/rep1_summits_filtered.bed -b macs2_rep2/rep2_summits_filtered.bed -d -t first | awk '{ if ($11 < 100 && $11 >=0) { print } }' | cut -f1-5 > common/summits/rep1_rep2_common.bed
bedtools sort -i common/summits/rep1_rep2_common.bed > common/summits/rep1_rep2_common_sorted.bed
bedtools intersect -v -a common/summits/rep1_rep2_common_sorted.bed -b macs2_rep2/rep2_summits_filtered.bed > common/summits/rep1_rep2_not_common_sorted.bed


# rep1_encode
awk '{OFS="\t"; print $1, $2+$10, $2+$10+1,".",$9}' ENCODE_peaks_sorted.bed > ENCODE_summits.bed
bedtools sort -i ENCODE_summits.bed > ENCODE_summits_sorted.bed
bedtools closest -a macs2_rep1/rep1_summits_filtered.bed -b ENCODE_summits_sorted.bed -d -t first | awk '{ if ($11 < 100 && $11 >=0) { print } }' | cut -f1-5 > common/summits/rep1_vs_encode.bed
bedtools intersect -v -a macs2_rep1/rep1_summits_filtered.bed -b common/summits/rep1_vs_encode.bed > common/summits/rep1_vs_encode_not_common.bed



# rep2_encode
#awk '{OFS="\t"; print $1, $2+$10, $2+$10+1,".",$9}' ENCODE_peaks_sorted.bed > ENCODE_summits_sorted.bed
#bedtools sort -i encode/rep1_summits_encode.bed > encode/rep1_summits_encode_sorted.bed
bedtools closest -a macs2_rep2/rep2_summits_filtered.bed -b ENCODE_summits_sorted.bed -d -t first | awk '{ if ($11 < 100 && $11 >=0) { print } }' | cut -f1-5 > common/summits/rep2_vs_encode.bed
bedtools intersect -v -a macs2_rep2/rep2_summits_filtered.bed -b common/summits/rep2_vs_encode.bed > common/summits/rep2_vs_encode_not_common.bed



# rep intersect _ encode
bedtools closest -a common/summits/rep1_rep2_common_sorted.bed -b ENCODE_summits_sorted.bed -d -t first | awk '{ if ($11 < 100 && $11 >=0) { print } }' | cut -f1-5 > common/summits/intersect_vs_encode.bed
bedtools intersect -v -a common/summits/rep1_rep2_common_sorted.bed -b common/summits/intersect_vs_encode.bed > common/summits/intersect_vs_encode_not_common.bed


# merged_encode
bedtools closest -a macs2_mergedPeaks/Merged_summits_filtered_sorted.bed -b ENCODE_summits_sorted.bed -d -t first | awk '{ if ($11 < 100 && $11 >=0) { print } }' | cut -f1-5 > common/summits/merged_vs_encode.bed
bedtools intersect -v -a macs2_mergedPeaks/Merged_summits_filtered_sorted.bed -b common/summits/merged_vs_encode.bed > common/summits/merged_vs_encode_not_common.bed



# COMMON PEAKS WITH OVERLAPS

# rep1_rep2
bedtools intersect -f 0.3 -r -a macs2_rep1/rep1_peaks_filtered.bed -b macs2_rep2/rep2_peaks_filtered.bed > common/overlaps/rep1_rep2_common.bed
bedtools intersect -f 0.3 -r -v -a macs2_rep1/rep1_peaks_filtered.bed -b macs2_rep2/rep2_peaks_filtered.bed > common/overlaps/rep1_rep2_not_common.bed

#rep1_encode
bedtools intersect -f 0.3 -r -a macs2_rep1/rep1_peaks_filtered.bed -b ENCODE_peaks_sorted.bed > common/overlaps/rep1_vs_encode.bed
bedtools intersect -f 0.3 -r -v -a macs2_rep1/rep1_peaks_filtered.bed -b ENCODE_peaks_sorted.bed > common/overlaps/rep1_vs_encode_not_common.bed

#rep2_encode
bedtools intersect -f 0.3 -r -a macs2_rep2/rep2_peaks_filtered.bed -b ENCODE_peaks_sorted.bed > common/overlaps/rep2_vs_encode.bed
bedtools intersect -f 0.3 -r -v -a macs2_rep2/rep2_peaks_filtered.bed -b ENCODE_peaks_sorted.bed > common/overlaps/rep2_vs_encode_not_common.bed

#intersection vs  encode 
bedtools intersect -f 0.3 -r -a common/overlaps/rep1_rep2_common.bed -b ENCODE_peaks_sorted.bed > common/overlaps/intersect_common.bed
bedtools intersect -f 0.3 -r -v -a common/overlaps/intersect_common.bed -b ENCODE_peaks_sorted.bed > common/overlaps/intersect_not_common.bed

#merged vs  encode 
bedtools intersect -f 0.3 -r -a macs2_mergedPeaks/merged_peaks_filtered.bed -b ENCODE_peaks_sorted.bed > common/overlaps/merged_common.bed
bedtools intersect -f 0.3 -r -v -a macs2_mergedPeaks/merged_peaks_filtered.bed -b ENCODE_peaks_sorted.bed > common/overlaps/merged_not_common.bed



# JACCARD
bedtools sort -i common/overlaps/intersect_common.bed > common/overlaps/intersect_common_sorted.bed
bedtools sort -i common/overlaps/merged_common.bed > common/overlaps/merged_common_sorted.bed
#bedtools sort -i encode/final_encode.bed > encode/final_encode_sorted.bed

echo "jaccard intersection vs encode"
bedtools jaccard -a common/overlaps/intersect_common_sorted.bed -b ENCODE_peaks_sorted.bed #(jaccard index = 0.244657)

echo "jaccard merged vs encode"
bedtools jaccard -a common/overlaps/merged_common_sorted.bed -b ENCODE_peaks_sorted.bed #(jaccard index = 0.486849)

#######################################################

#bed for great
mkdir GREAT 
sort -k5 -nr common/summits/merged_vs_encode.bed > GREAT/merged_sorted_by_q.bed
head -n 5000 GREAT/merged_sorted_by_q.bed > GREAT/merged_sorted_by_q5000.bed
bedtools sort -i GREAT/merged_sorted_by_q5000.bed > GREAT/merged_resorted_by_q5000.bed
nawk '{$5="";print}' GREAT/merged_resorted_by_q5000.bed > GREAT/final_merged_for_great.bed


#narrowPeak for genome browser and
bedtools intersect -wa -a macs2_mergedPeaks/Merged_peaks.narrowPeak -b common/summits/merged_vs_encode.bed > GREAT/final_merged_for_genome_browser.narrowPeak