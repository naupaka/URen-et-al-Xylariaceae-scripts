# Script to plot circles of various colors corresponding with the occurrance of
# various strains of fungi and where they are found
# Written October 9, 2014 by Naupaka Zimmerman naupaka@gmail.com

library("plotrix")

DEBUG <- FALSE
data.in <- read.csv("Xylariaceae_Endo_Metadata_forTree_copy.csv")

# set up variables for later reuse and to facilitate code readibility
number.rows <- nrow(data.in)
number.columns <- ncol(data.in)
arnold.columns = seq(from = 5, to = number.columns, by = 2)

# set up empty plot and add column labels to top
plot(0,0, 
    xlim = c(-5, number.columns - 2), 
    ylim = c(-2, 2 * (number.rows) + 25), 
    type="n", 
    xaxt = "n", yaxt = "n", 
    bty = "n", 
    ylab = "", xlab = "")
text(x = c(0,2), y = rep(2 * (number.rows) + 1, 2), 
    labels = names(data.in[,c(3,4)]), srt = 90, adj = 0, cex = 0.5)
text(x = arnold.columns - 1, 
    y = rep(2 * (number.rows) + 1, 
    length(arnold.columns)), labels = names(data.in[,arnold.columns + 1]), 
    srt = 90, adj = 0, cex = 0.5)

for(row in 1:number.rows){
    
    # print OTU (isolate) row labels
    text(x = -3, y = 2 * (number.rows - row), 
         labels = data.in$Isolate.Rep[row], cex = 0.5)
   
    # print out counts of sequences in each OTU (row)
    text(x = 0, y = 2 * (number.rows - row), 
         labels = data.in$Total.Arnold.isolates[row], cex = 0.5)
    text(x = 2, y = 2 * (number.rows - row), 
         labels = data.in$Total.Blast.Hits[row], cex = 0.5)
    
    # plot either fully filled circles if only Arnold collection
    # or GenBank has isolates, and half-circles if both are present
    for(column in arnold.columns){
        if(data.in[row, column] > 0 & data.in[row, column + 1] > 0){
            if(DEBUG) print(c(row, column, "blue and red"))
            floating.pie(xpos = column - 1, ypos = 2 * (number.rows - row), 
                         x = c(1,1), startpos = pi/2, 
                         col = c("blue", "red"), radius = 0.35)
        }
        else if(data.in[row, column] > 0 & data.in[row, column + 1] == 0){
            if(DEBUG) print(c(row, column, "only blue"))
            points(x = column - 1, y = 2 * (number.rows - row), 
                   pch = 21, cex = 1.4, bg = "blue")
            
            # floating.pie(xpos = column - 3, ypos = 2 * (number.rows - row), 
            #   x = c(1,1), startpos = pi/2, 
            #   col = c("blue", "white"), radius = 0.35)
        }
        else if(data.in[row, column] == 0 & data.in[row, column + 1] > 0){
            if(DEBUG) print(c(row, column, "only red"))
            points(x = column - 1, y = 2 * (number.rows - row), 
                   pch = 21, cex = 1.4, bg = "red")
            
            # floating.pie(xpos = column - 3, ypos = 2 * (number.rows - row), 
            #   x = c(1,1), startpos = pi/2, 
            #   col = c("white", "red"), radius = 0.35)
        }
        else if(data.in[row, column] == 0 & data.in[row, column + 1] == 0){
            if(DEBUG) print(c(row, column, "white"))
            # add empty white circles when no isolates for either
            # points(x = column - 1, y = 2 * (number.rows - row), 
            #   pch = 1, cex = 1.4) 
            
            # floating.pie(xpos = column - 3, ypos = 2 * (number.rows - row), 
            #   x = c(1), startpos = pi/2, 
            #   col = c("white"), radius = 0.25)
        }
    }
}

