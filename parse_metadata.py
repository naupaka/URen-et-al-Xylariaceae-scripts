import re
print 2 + 2
in_file = open("Blast_accession98pct.meta2.txt")
out_file = open("out.csv", "a")
features = []

for line in in_file:
    if re.search(r"^\t", line):
        feature_type = re.search(r"^\t(\S.*?)\t", line)
        this_feature = feature_type.group(1)
        if this_feature not in features:
            features.append(this_feature)

in_file.close()

out_file.write('"SEQ_ID", "REF_TITLE", "' + '", "'.join(features) + '"\n')

in_file = open("Blast_accession98pct.meta2.txt")
out_line = ["", ""]
count = 0

for line in in_file:
    out_line.extend([""] * len(features))
    if re.search(r"^(\S*)\n", line):
        if count == 0:
            count += 1
            item = re.search(r"^(\S*)\n", line)
            out_line[0] = item.group(1)
        elif count != 0:
            count += 1
            out_file.write('","'.join(out_line) + '"\n')
            out_line = []
            item = re.search(r"^(\S*)\n", line)
            out_line[0] = item.group(1)
    elif re.search(r"^\sREF\sTITLE:\s(.*)\n", line):
        item = re.search(r"^\sREF\sTITLE:\s(.*)\n", line)
        out_line[1] = item.group(1)
    elif re.search(r"^\t(\S*?)\t(.*)\n", line):
        item = re.search(r"^\t(\S*?)\t(.*)\n", line)
        out_line[features.index(item.group(1)) + 2] = item.group(2)
    else:
        print "Error: " + line + "\n"

in_file.close()
out_file.close()

print features
print out_line
re.search(r"^(\S)\n", line)

print features
# len(features)
# len(out_line)
