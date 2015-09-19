## Script to calculate phylogenetic diversity of a group 
## to a larger set of taxa
## Naupaka Zimmerman naupaka@gmail.com
## October 26, 2014

library("caper")
library("ggplot2")

# Read in files
tree <- read.tree("RAxML_bestTree.result")
meta.file <- read.delim("xylariaceae.group.txt", header = FALSE)

# Add column names to metadata df
names(meta.file) <- c("TipName", "category")

# Subset out just endophyte species from metadata file
meta.file.endophytes <- subset(meta.file, category == "endophyte")

# Extract known taxa without two outgroup species
meta.file.known.noroot <- subset(meta.file, category == "known" & TipName != "Eutylata" & TipName != "Diatdisc")

# create clade matrix for later use in calculating diversity of tree subsets
clmat <- clade.matrix(tree)

# phylogenetic diversity of full dataset
all.data.pd <- pd.calc(clmat)

# subset out just endos and just not endos
just.endos.pd <- pd.calc(clmat, tip.subset = as.character(meta.file.endophytes$TipName))
no.endos.pd <- pd.calc(clmat, tip.subset = as.character(meta.file.known.noroot$TipName))

# count how many there are in each of these two categories (endos vs no endos)
length.noroot <- length(as.character(meta.file.known.noroot$TipName))
length.endos <- length(as.character(meta.file.endophytes$TipName))

# get vector of endophyte names
endos.notsampled <- as.character(meta.file.endophytes$TipName)

# Calculate PD of tree with N tips, where N is the total number of 
# non-endophytic (reference) species, but including all endophytes
# and a randomly drawn subset of the reference taxa to sum to N
# Then store the PD of each of 1000 trees made in this way to a vector
# the distribution of which can then be compared to the tree made entirely
# of reference taxa (which has the same N as the sampled trees)

output.pd.vector <- NA
for(i in 1:1000){
    # generate vector of indices to samples
    random.subsample <- sample(1:length.noroot, 
                            size = length.noroot - length.endos,
                            replace = FALSE)
    
    # pull out names of sampled reference taxa
    known.sampled <- as.character(meta.file.known.noroot$TipName)[random.subsample]
    
    # calculate PD of sampled reference taxa plus all endos
    pd.inner <- pd.calc(clmat, tip.subset = c(known.sampled, endos.notsampled), 
                        method = "TBL")[1]
    output.pd.vector[i] <- pd.inner
}

# historgram of output
output.pd.vector.df <- as.data.frame(output.pd.vector) # for ggplot

# Used later to calculate p value of only 
# reference taxa vs distribution of sampled mix
num.less.than.no.endos <- length(output.pd.vector[output.pd.vector < no.endos.pd])

# plot probability density curve for sampled distribution
my.density.plot <- ggplot(output.pd.vector.df, aes(output.pd.vector)) + 
    geom_density(fill = "black") +
    
    # Add vertical dashed line showing only reference taxa PD (non-sampled) 
    geom_vline(xintercept = no.endos.pd, linetype = "dashed") +
    annotate("text", 
             
             # Calculate and add p-value to vertical label text
             label = paste0("Diversity without endophytes = ",
                            round(no.endos.pd,2),
                            if(num.less.than.no.endos == 0){" (p < 0.001)"}
                            else if(num.less.than.no.endos > 0){
                                paste0(" (p = ",
                                round(length(num.less.than.no.endos)/1000,3),
                                ")")
                            }
                            ), 
             x = no.endos.pd + 0.1, 
             y = 0.5,
             angle = 270) + 
    ylab("Density") +
    xlab("Phylogenetic diversity") +
    ggtitle("Phylogenetic diversity increases with addition of endophytic species") + 
    theme_bw()

# Save figure
ggsave(plot = my.density.plot, filename = "PD_PDF.pdf", width = 8, height = 10)

