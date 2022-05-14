import os
import sys


def main():
    COUNTDIR = sys.argv[1]
    counts_list = []
    for i in os.listdir(COUNTDIR):
        if i[-4:] == '.csv':
            counts_list.append(i)
        
    def combine_count(count_list):
        mydict = {}
        for file in count_list:
            for line in open(file, "r"):
                if line.startswith('E'):
                    key, value = line.strip().split('\t')
                    if key in mydict:
                        mydict[key] = mydict[key] + '\t' + value
                    else:
                        mydict[key] = value
        sorted_mydict = sorted(mydict)
        out = open('count_out.csv','w')
        out.write("Gene_Name")
        for i in count_list:
            out.write('\t' + i)
        out.write('\n')
        for k in sorted_mydict:
            out.write(k+'\t'+mydict[k]+'\n')
    combine_count(counts_list)
    
    
if __name__ == '__main__':
    main()