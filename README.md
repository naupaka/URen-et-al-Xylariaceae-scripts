## Scripts and data for a manuscript entitled:
## "Contribution of North American endophytic and endolichenic fungi to the phylogeny, ecology, and taxonomy of Xylariaceae (Sordariomycetes, Ascomycota)"

### Authors: Jana M. U'Ren, Jolanta Miadlikowska, Naupaka Zimmerman, Francois Lutzoni, A. Elizabeth Arnold

#### September 18, 2015


## 01-blast-sequences

Using the University of Arizona's HPC, this script was used to BLAST a fasta file containing ITS rDNA sequences for newly cultured isolates from our continental surveys, as well as reference taxa, against NCBI’s nr database using an e-value cutoff of 1 x e-3. 
Output was formatted in csv, opened in Excel, and filtered manually to remove self hits, accessions from U’Ren et al. (2010; 2012), and hits with percent identity <99%. If the same accession was a hit for multiple taxa, the hit with the highest bit score was 
selected and the duplicate removed. A small fraction of BLASTn hits representing sequences from uncultured isolates (i.e., clones or next-generation sequences) also were excluded (n = 24; 1.9% of filtered hits). A tab-delimited text file was saved with the list
of GI for unknown fungi from out surveys and reference taxa.  

## 02-pull-isolate-metadata

The script `get_isolate_info.pl` (written by Jason Stajich) was used to obtain all associated metadata for each GI from NCBI.  

**Input files** are text files (e.g., `Endo_Blast99hits.txt` and `Reftaxa_Blast99hits.txt`). 

**Output files** are GenBank formatted text files.  

## 03-parse-metadata

The script `parse_metadata.py` (written by Naupaka Zimmerman) parses GenBank formatted text files containing metadata into `csv` format.  
Example **input file** is `Blast_accession98pct.meta2.txt` (contains the TITLE information).

**Output files** (e.g., `out.csv`) were opened in Excel and for each GI, the available metadata were searched to find the geographic origin, host lineage (e.g., Angiosperm), and substrate information (e.g., surface sterilized leaf).  

Information was then summarized in Excel (see Supplemental Tables 7-8) under columns "Geographic region", "Host type", and "Substrate".  

* Categories for "Geographic region" included (1) U.S./Canada; (2) Mexico/South and Central America/Caribbean; (3) Europe/Russia; (4) Asia; and (5) “other” (e.g., Hawaii, Australia, New Zealand, Papua New Guinea, Africa, the Middle East, and Antarctica, grouped as “other” due to a paucity of metadata from those sites). Isolates from the Hawaiian Islands were included in “other” rather than U.S./Canada due to their geographical isolation from the continental U.S. 

* Categories for host breadth included (1) angiosperm; (2) “gymnosperm” (i.e., Pinophyta and Ginkgo biloba); (3) spore-bearing vascular plant (i.e., lycophytes and ferns); (4) bryophyte (i.e., mosses and liverworts) and (5) lichen. 

* Substrate categories included (1) living plant leaves or non-woody stems (LP); (2) dead plant leaves in canopy (DP); (3) fallen plant leaves in leaf litter (FP); (4) wood or bark; (5) roots; (6) seeds; (7) soil; (8) insect-associated; and (9) fallen fruits/inflorescences (Fig. 2).

In the cases of missing metadata, information was gathered (when possible) from manuscripts in which the sequences were published. Information on geographic distribution, host, and substrate for reference taxa also was collected from published species descriptions and online resources (Supplemental Table 9). 

For each terminal taxon in the tree, the final number of isolates found under each category were saved in a csv file (e.g., `METADATA_forTree.csv`).  In this file the first column contains the terminal taxon name as it is in the tree file (i.e., isolate rep), the second column is the taxon name as it should appear in the figure.  Columns with Arnold are totals for isolates collected in surveys of 5 North American sites.  All other columns are for previously published taxa.  

`METADATA_forTree.csv` does not contain sporocarp information gleaned from the literature or online resources.  


## 04-make-phylogeny

The script `plot_for_phylogeny.R` (written by Naupaka Zimmerman) was takes two **input** files: one including the **metadata in csv format** (e.g., `METADATA_forTree.csv`) to plot the metadata alongside on a **tree file** with support values in phylip format (e.g., `RAxML_bipartitions.result.phy`).

The **output** is a pdf file.  For the purposes of this manuscript, the output PDF was opened in Adobe Illustrator CC 2014 and manually edited for publication. Mistakes were corrected manually. Information based on sporocarps was added to the figure manually in Illustrator.


## 05-phylo-diversity

The script `pd.R` (written by Naupaka Zimmerman) was used to assess whether newly collected isolates significantly increased the phylogenetic diversity of the Xylariaceae. 

**Input files** included a tree file (i.e., topology generated from ML analysis of the 5 + 4 + 3 + 2 + 1 supermatrix; `RAxML_bestTree.result`) and a group file (`xylariaceae.group.txt`). The group file assigned terminal taxon to either "known" or "endophyte" categories.  Taxa used as the outgroup (Diatdisc and Eutylata) were excluded within the script (lines 22-23).  

PD was calculated 1,000 times for subsets of 286 taxa (77 newly collected OTU plus a random selection of 209 previously named Xylariaceae taxa), which is equal to the total number of previously named Xylariaceae taxa in the tree. 
The observed PD of all previously named Xylariaceae taxa was compared to this distribution to generate a distribution-independent p-value (Supplemental Fig. 2). 

Phylogenetic diversity was calculated as the sum of all the edge lengths in the subtree given by the tip subset.

The script **outputs** a PDF containing the probability density graph of phylogenetic diversity and p-values. 

