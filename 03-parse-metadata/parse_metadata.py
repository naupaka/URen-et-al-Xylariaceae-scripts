#!/usr/bin/python

###################################################################
# Script to parse GenBank metadata into csv format, accounting for
# missing or incomplete data
# Written October 1, 2014 by Naupaka Zimmerman, naupaka@gmail.com
# Call with:
# print 'python parse_metadata.py <inputfile> <outputfile>'
###################################################################

import sys
import re

# Set to True to print some additional debug information
DEBUG = False

# Read in parameters
if len(sys.argv) == 3:
    print 'Input file is: ', sys.argv[1]
    print 'Output file is: ', sys.argv[2]
    inputfile, outputfile = sys.argv[1], sys.argv[2]
else:
    print 'Two parameters needed, you provided ' + len(sys.argv)
    print 'python parse_metadata.py <inputfile> <outputfile>'
    sys.exit()

# open input file, with output file in append mode
in_file = open(inputfile)
out_file = open(outputfile, "a")
features = []

# find non-redundant list of feature types over the whole file
for line in in_file:
    if re.search(r"^\t", line):
        feature_type = re.search(r"^\t(\S.*?)\t", line)
        this_feature = feature_type.group(1)
        if this_feature not in features:
            features.append(this_feature)

in_file.close()

if DEBUG:
    print features[0]

# Write column headers
out_file.write('"SEQ_ID","REF_TITLE","' + '","'.join(features) + '"\n')

# reopen input file to capture data
in_file = open(inputfile)

# Create empty line to store results (length based on num of features + 2)
out_line = ['', '']
out_line.extend([''] * len(features))

# set count to avoid writing on 1st line before content is parsed
count = 0

if DEBUG:
    print out_line

# Iterate over lines, adding to existing columns if features are present
# Add newline when reaching a new sequence ID
for line in in_file:
    if re.search(r"^(\S*)\n", line):
        if count == 0:
            count += 1
            item = re.search(r"^(\S*)\n", line)
            out_line[0] = item.group(1)
        elif count != 0:
            count += 1
            out_file.write('"' + '","'.join(out_line) + '"\n')
            out_line = ["", ""]
            out_line.extend([""] * len(features))
            item = re.search(r"^(\S*)\n", line)
            out_line[0] = item.group(1)
    elif re.search(r"^\sREF\sTITLE:\s(.*)\n", line):
        item = re.search(r"^\sREF\sTITLE:\s(.*)\n", line)
        out_line[1] = item.group(1)
    elif re.search(r"^\t(\S*?)\t(.*)\n", line):
        item = re.search(r"^\t(\S*?)\t(.*)\n", line)
        out_line[features.index(item.group(1)) + 2] = item.group(2)
    elif re.search(r"^\sFeatures:\n", line):
        continue
    else:
        print "Error: " + line + "\n"

in_file.close()
out_file.close()
