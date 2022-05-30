# RNA-pipe

Easy upstream RNA-seq analysis for beginners

- The project should be used in Linux environment. A cluster (server) using PBS system is recommended.

**How to use RNA-pipe:**

1. Install **conda**in your cluster.
2. Run ```conda create -f rna-pipe.yml ```
3. Change the file name in `rna-pipe.pbs` to make sure it download the right file for you.
   1. Download the project, make folder `$PROJECT_FOLDER/script`  and put `countit.py` and `rna-pipe.pbs` in the` $PROJECT_FOLDER/script`folder. Then make a folder `$PROJECT_FOLDER/script/logs` for the outputs of PBS system.
4. Run`qsub rna-pipe.pbs` and wait for the outcome. (If your server do not use PBS, run `bash rna-pipe.pbs` instead)