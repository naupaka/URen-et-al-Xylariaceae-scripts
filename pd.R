setwd("/Users/janau/Desktop/Xylariaceae_NEW/")
tree <- read.tree("RAxML_bestTree.result")
meta.file <- read.delim("xylariaceae.group.txt", header = FALSE)
names(meta.file) <- c("TipName", "category")
meta.file.endophytes <- subset(meta.file, category == "endophyte")
meta.file.known.noroot <- subset(meta.file, category == "known" & TipName != "Eutylata" & TipName != "Diatdisc")

clmat <- clade.matrix(tree)
pd.calc(clmat)
pd.calc(clmat, tip.subset = as.character(meta.file.endophytes$TipName))
pd.calc(clmat, tip.subset = as.character(meta.file.known.noroot$TipName))
length.noroot <- length(as.character(meta.file.known.noroot$TipName))
length.endos <- length(as.character(meta.file.endophytes$TipName))
endos.notsampled <- as.character(meta.file.endophytes$TipName)

# All without root or endos
# pd.calc(clmat, tip.subset = as.character(meta.file.known.noroot$TipName))

# Distribution of above (subsetted) with all endos
output.pd.vector <- NA
for(i in 1:1000){
  random.subsample <- sample(1:length.noroot, 
                             size = length.noroot - length.endos,
                             replace = FALSE)
  known.sampled <- as.character(meta.file.known.noroot$TipName)[random.subsample]
  pd.inner <- pd.calc(clmat, tip.subset = c(known.sampled, endos.notsampled), 
                      method = "TBL")[1]
  output.pd.vector[i] <- pd.inner
}

# historgram of output
hist(output.pd.vector)
mean(output.pd.vector)


min(output.pd.vector)

