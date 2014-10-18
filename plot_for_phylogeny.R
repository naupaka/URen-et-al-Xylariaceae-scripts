# Script to plot circles of various colors corresponding with the occurrance of
# various strains of fungi and where they are found
# Written October 9, 2014 by Naupaka Zimmerman naupaka@gmail.com

library("plotrix")
library("ape")
library("phylobase")

DEBUG <- FALSE
setwd("/Users/naupaka/Dropbox/Working_files/Academia/Administration/Arnold Lab/Misc/Jana_phylogeny/")
data.in <- read.csv("METADATA_forTree_new.csv")
row.names(data.in) <- data.in$Isolate.Rep
tree.in <- read.tree("RAxML_bestTree.result.phy")
tree.in <- ladderize(tree.in, right = FALSE)
tip.order <- tree.in$tip.label[tree.in$edge[tree.in$edge[,2] < length(tree.in$tip.label) + 1,2]]
data.in <- data.in[rev(tip.order),]

# set up variables for later reuse and to facilitate code readibility
number.rows <- nrow(data.in)
number.columns <- ncol(data.in)
arnold.columns = seq(from = 7, to = number.columns, by = 2)

offset.value <- 6
pdf("Plot.pdf", width=15, height=50)

split.screen(c(1,2))

screen(2)
par(fig = c(0,1.1,0.0127,0.919),
    mar = c(0,0,0,0))

# set up empty plot and add column labels to top
plot(0,0, 
    xlim = c(-5, number.columns - 4), 
    ylim = c(-2, 2 * (number.rows) + 25), 
    type="n", 
    xaxt = "n", yaxt = "n", 
    bty = "n", 
    ylab = "", xlab = "")

rect(7 + offset.value - 4,-0.75,12 + offset.value, 
    2 * (number.rows) + 20, col = "snow2", border = NA)
rect(12 + offset.value - 4,-0.75,16 + offset.value, 
    2 * (number.rows) + 20, col = "honeydew2", border = NA)
rect(16 + offset.value - 4,-0.75,22 + offset.value, 
    2 * (number.rows) + 20, col = "lemonchiffon", border = NA)

text(x = c(3,4) + (offset.value - 2), y = rep(2 * (number.rows) + 1, 2), 
    labels = names(data.in[,c(5,6)]), srt = 90, adj = 0, cex = 0.5)
text(x = arnold.columns/2 + offset.value, 
    y = rep(2 * (number.rows) + 1, 
    length(arnold.columns)), labels = names(data.in[,arnold.columns + 1]), 
    srt = 90, adj = 0, cex = 0.5)

stored.tip.labels <- NA

for(row in 1:number.rows){
    
    stored.tip.labels[row] <- 
        if( is.na(data.in$X95.OTU[row]) ){
            paste(data.in$Isolate.Name[row])
        }
        else{
            paste(data.in$Isolate.Name[row], 
                data.in$X95.OTU[row], 
                data.in$X99.OTU[row], sep = " - ")
        }
    
    # print OTU (isolate) row labels
    # text(x = 1, y = 2 * (number.rows - row), 
    #    labels = paste(data.in$Isolate.Rep[row], 
    #                   data.in$X95.OTU[row], 
    #                   data.in$X99.OTU[row], sep = " - "), 
    #            cex = 0.5, pos=2)
   
    text(x = 3 + (offset.value - 2), y = 2 * (number.rows - row), 
         labels = data.in$Total.Arnold.isolates[row], cex = 0.5)
    text(x = 4 + (offset.value - 2), y = 2 * (number.rows - row), 
         labels = data.in$Total.Blast.Hits[row], cex = 0.5)

    # plot either fully filled circles if only Arnold collection
    # or GenBank has isolates, and half-circles if both are present
    for(column in arnold.columns){
        if(data.in[row, column] > 0 & data.in[row, column + 1] > 0){
            if(DEBUG) print(c(row, column, "black and red"))
            floating.pie(xpos = column/2 + offset.value, ypos = 2 * (number.rows - row), 
                         x = c(1,1), startpos = pi/2, 
                         col = c("black", "red"), radius = 0.37)
        }
        else if(data.in[row, column] > 0 & data.in[row, column + 1] == 0){
            if(DEBUG) print(c(row, column, "only black"))
            points(x = column/2 + offset.value, y = 2 * (number.rows - row), 
                   pch = 21, cex = 1.4, bg = "black")
        }
        else if(data.in[row, column] == 0 & data.in[row, column + 1] > 0){
            if(DEBUG) print(c(row, column, "only red"))
            points(x = column/2 + offset.value, y = 2 * (number.rows - row), 
                   pch = 21, cex = 1.4, bg = "red")
        }
        else if(data.in[row, column] == 0 & data.in[row, column + 1] == 0){
            if(DEBUG) print(c(row, column, "white"))
            # add empty white circles when no isolates for either
            points(x = column/2 + offset.value, y = 2 * (number.rows - row), 
                pch = 1, cex = 1.4, col = "light grey") 
        }
    }
}

screen(1)
par(fig = c(0.2,0.652,0.024,0.951))

plot(tree.in, use.edge.length = FALSE, show.tip.label = FALSE, no.margin = TRUE, x.lim = 450)

if(DEBUG) tiplabels()
tiplabels(rev(stored.tip.labels), 
          tree.in$edge[tree.in$edge[,2] < length(tree.in$tip.label) + 1,2], 
          cex = 0.5, frame = "none", adj = -0.05)

close.screen(all = TRUE)
dev.off()
