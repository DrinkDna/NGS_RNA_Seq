# Load required libraries
library(DESeq2)
library(ggplot2)

# Step 1: Load Data
countData <- read.table("counts.txt", header = TRUE, row.names = 1)
colData <- read.csv("metadata.csv", header = TRUE, row.names = 1)
colData <- colData[!is.na(colData$Replicate),]  # Remove rows with NA in Replicate

# Step 2: Create DESeq2 Object
dds <- DESeqDataSetFromMatrix(countData = countData,
                              colData = colData,
                              design = ~ Condition)
dds <- DESeq(dds)  # Run the DESeq2 pipeline

