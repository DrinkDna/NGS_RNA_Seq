
#	Make Necessary Directory Structure 

#step1: Pre-Quality Check
fastqc -o Data/QC_Reports/ Data/FASTQ/*.fastq



#step2: Pre-Quality Check
multiqc Data/QC_Reports/ -o Data/QC_Reports/multiqc_report/


#step3: Quality Trimming 

for file in Data/FASTQ/*_1.fastq.gz; do
  # Extract base name (e.g., SRR14366637 from SRR14366637_1.fastq.gz)
  base=$(basename "$file" _1.fastq.gz)
  
  # Run Trimmomatic for this pair
  java -jar trimmomatic-0.39.jar PE \
  -threads 4 \
  Data/FASTQ/${base}_1.fastq.gz Data/FASTQ/${base}_2.fastq.gz \
  Data/Clean/${base}_1_paired.fastq.gz Data/Clean/${base}_1_unpaired.fastq.gz \
  Data/Clean/${base}_2_paired.fastq.gz Data/Clean/${base}_2_unpaired.fastq.gz \
  ILLUMINACLIP:Trimmomatic-0.39//adapters/TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:20 MINLEN:36
done



#step4: Post-Quality Check
fastqc -o Data/QC_Reports_PostTrim/ Data/Clean/*_paired.fastq.gz


#step5: Post-Quality Check
multiqc Data/QC_Reports_PostTrim/ -o Data/QC_Reports_PostTrim/multiqc_report/



#step6: Indexing and Alignment 

#!/usr/bin/bash

# Define variables
STAR_Index="/home/shubham/RNAseq_Project/Data/Reference/genome/STAR_Index"
fasta="/home/shubham/RNAseq_Project/Data/Reference/genome/GRCh38.fa"
gtf="/home/shubham/RNAseq_Project/Data/Reference/genome/GRCh38.gtf"
fastq="/home/shubham/RNAseq_Project/Data/Clean"
align_out="/home/shubham/RNAseq_Project/Analysis/Alignment"


# Create necessary directories
#mkdir -p "$STAR_Index"
mkdir -p "$align_out/BAM"
mkdir -p "$align_out/STAR_Logs"


# Step I: Generating Genome Indexes (if not already generated)
#STAR --runMode genomeGenerate \
#     --runThreadN 12 \
#     --genomeDir "$STAR_Index" \
#     --genomeFastaFiles "$fasta" \
#     --sjdbGTFfile "$gtf" \
#     --readFilesCommand zcat \
#     --sjdbOverhang 149


# Step II: Mapping Reads to the Genome
for fastq1 in "$fastq"/*_1_paired.fastq.gz; do
    fastq2="${fastq1/_1_paired/_2_paired}"
    if [[ -f "$fastq2" ]]; then
        sample_name=$(basename "$fastq1" | cut -d_ -f1) # Extract sample name
        STAR --runThreadN 12 \
             --genomeDir "$STAR_Index" \
             --readFilesIn "$fastq1" "$fastq2" \
             --readFilesCommand zcat \
             --outFileNamePrefix "$align_out/BAM/${sample_name}_" \
             --outSAMtype BAM SortedByCoordinate \
             --outReadsUnmapped Fastx \
             --quantMode GeneCounts \
             --outStd Log > "$align_out/STAR_Logs/${sample_name}_alignment.log" 2>&1
    else
        echo "Error: Missing paired file for $fastq1"
    fi
done

#step7: Extract Strand-Specific Counts from files

gtf="/home/shubham/NV2/RNAseq_Project/Data/Reference/genome/GRCh38.gtf"
align_out="/home/shubham/NV2/RNAseq_Project/Analysis/Alignment"
counts="/home/shubham/NV2/RNAseq_Project/Analysis/Counts"

#Generating Strand-Specific Counts
for gene_tab in "$align_out/BAM/"*_ReadsPerGene.out.tab; do
    sample_name=$(basename "$gene_tab" | cut -d_ -f1)
    awk '{print $1, $3}' "$gene_tab" > "$counts/${sample_name}_1ststrand_star.txt"
done


#step8: Merge Counts from all files to get counts.csv data

	#R-script is provided 


#Step9: Create Metadata for your study 

SampleID,CellLine,Condition,Replicate
SRR14366637,MCF-7,DMSO_MCF7,1
SRR14366638,MCF-7,DMSO_MCF7,2
SRR14366639,MCF-7,DMSO_MCF7,3
SRR14366640,MCF-7,DATS_MCF7,1
SRR14366641,MCF-7,DATS_MCF7,2
SRR14366642,MCF-7,DATS_MCF7,3
SRR14366643,MDA-MB-231,DMSO_MDAMB231,1
SRR14366644,MDA-MB-231,DMSO_MDAMB231,2
SRR14366645,MDA-MB-231,DMSO_MDAMB231,3
SRR14366646,MDA-MB-231,DATS_MDAMB231,1
SRR14366647,MDA-MB-231,DATS_MDAMB231,2
SRR14366648,MDA-MB-231,DATS_MDAMB231,3

#step10: DEG Analysis with DESeq2 R Package 

	#R script is provided 

#Plots and Analysis 







