
# Define variables
gtf="/media/shubham/NV2/RNAseq_Project/Data/Reference/genome/GRCh38.gtf"
align_out="/media/shubham/NV2/RNAseq_Project/Analysis/Alignment"
counts="/media/shubham/NV2/RNAseq_Project/Analysis/Counts1"

# Step 3: Generating Strand-Specific Counts
for gene_tab in "$align_out/BAM/"*_ReadsPerGene.out.tab; do
    sample_name=$(basename "$gene_tab" | cut -d_ -f1)
    awk '{print $1, $3}' "$gene_tab" > "$counts/${sample_name}_1ststrand_star.txt"
done


# Step 4: Counting with HTSeq
#for bam_file in "$align_out/BAM/"*_Aligned.sortedByCoord.out.bam; do
#    sample_name=$(basename "$bam_file" | cut -d_ -f1)
#    htseq-count -f bam -r pos -s yes "$bam_file" "$gtf" > "$counts/${sample_name}_1ststrand_htseq.txt"
#done

#htseq-count -f bam -r pos -s yes $align_out/"BAM/SRR14366637_Aligned.sortedByCoord.out.bam" "$gtf" > "$counts/SRR14366637_1ststrand_htseq.txt"

#htseq-count -f bam -r pos -s yes "$align_out/BAM/SRR14366637_Aligned.sortedByCoord.out.bam" "$gtf"

# Step 5: Counting with featureCounts
#featureCounts -T 8 \
#    -a "$gtf" \
#    -o "$counts/counts_featureCounts.txt" \
#    -s 1 \
#    -p  \
#    "$align_out/BAM/"*_Aligned.sortedByCoord.out.bam

