# RNA-pipe

Easy upstream RNA-seq analysis for beginners

- The project should be used in Linux environment. 


**Prerequisites:**

- A server/computer with fastqc, samtools, sratoolkit, hisat2. If you are using a server, you can use `module avil` to see if these required software are available. If not, please install it first or just find alternate ones.


**How to use RNA-pipe:**

1. Install **[conda](https://anaconda.org/)** in your server.
2. Change the working dictionary to RNA-pipe, and run ```conda create -f rna-pipe.yml ```
3. Change the file name in `rna-pipe.sh` to make sure it download the right file for you.
   1. Change the value of `PIPEDIR` to your folder where you have RNA-pipe. 
   2. Change the value of `SRADIR` if your `prefetch` fuction download it to other folder. Use the default value is OK.
   3. Change the reference file place and filename in the step: **# bulid index** to the reference file you want. The default is used for the class.
4. Run `bash rna-pipe.sh` to get the results of count matrix.


This project is actually part of my work for the course *bioinformatics*. 

