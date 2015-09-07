#!/bin/csh
#PBS -N Xylblast
#PBS -m bea
#PBS -M juren@email.arizona.edu
#PBS -W group_list=fungi
#PBS -q standard
#PBS -l select=1:ncpus=12:mem=23Gb
#PBS -l cput=288:0:0
#PBS -l walltime=48:0:0

module load blast

cd /home/u25/juren/

time blastn -db /genome/nt -query Xylariaceae_ITSonly_9sept2014.fasta -out Xylariaceae_ITSonly_9sept2014.bln -evalue 1e-3 -num_threads 12 -show_gis -outfmt 10
