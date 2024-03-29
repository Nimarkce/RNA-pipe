#!/bin/sh
#an example for Intel MPI job
#DO NOT RUN THIS SCRIPT DIRECTLY
#PLEASE RUN THIS SCRIPT WITH qsub:qusub intelmpi_job.pbs
#PBS -N RNA-pipe
#PBS -o log.pipe
#PBS -e err.pipe
#PBS -q batch
#PBS -l nodes=1:ppn=10
#PBS -l walltime=12:00:00

## before run rna-pipe, use conda install -f rna-pipe.yml first

conda deactivate 
source activate rna-pipe
PIPEDIR=~/rnapipe # change it to your RNA-pipe folder. The parent folder of script.
SRADIR=~/ncbi/public/sra # The default one is "~/ncbi/public/sra/"
SCDIR=$PIPEDIR/scripts
DATADIR=$PIPEDIR/data
REFDIR=$PIPEDIR/ref
FQDIR=$PIPEDIR/data/fq
QCedDIR=$PIPEDIR/data/fp
FPDIR=$QCedDIRs
MAPDIR=$DATADIR/mapped
COUNTDIR=$DATADIR/count

cd $PIPEDIR
mkdir data ref 
cd data
mkdir sra fp fq mapped count fastqc-fred fastqc

# build index 
cd $REFDIR
module load hisat2
# change the reference gene files to what you need
wget ftp://ftp.ensembl.org/pub/current_fasta/homo_sapiens/dna_index/Homo_sapiens.GRCh38.dna.toplevel.fa.gz 
wget ftp://ftp.ensembl.org/pub/release-106/gtf/homo_sapiens/Homo_sapiens.GRCh38.106.gtf.gz
gunzip Homo_sapiens.GRCh38.106.gtf.gz
gunzip Homo_sapiens.GRCh38.dna.toplevel.fa.gz 
hisat2-build -p 10 Homo_sapiens.GRCh38.dna.toplevel.fa hg38 > build_index.log


# fetch .sra files
cd $DATADIR
module load sratoolkit 
for item in 86 87 88 89 90 91 92 93
do 
prefetch SRR84676$item & 
done
wait


# convert to fastq
mv $SRADIR $DATADIR
cd $DATADIR/sra
for i in $(ls *.sra)
do
 fastq-dump $i & 
done
wait
mv ${DATADIR}/sra/*.fastq $FQDIR


# fastqc - quality control.
cd $FQDIR
module load fastqc
fastqc -t 6 -o ../fastqc *.fastq


# fastp - filter bad reads.
cd $FQDIR
for i in $(ls *.fastq)
do
 i=${i/.fastq/}
 fastp -i ${i}.fastq -o $QCedDIR/${i}.fastp.fq -R $i -h ${i}.fastp.html -j ${i}.fastp.json 
done


# fastqc2 - quality control - after fastp
cd $FPDIR
module load fastqc
fastqc -t 6 -o ../fastqc-fped *.fq


## use hisat2 to map to ref genome
cd $FPDIR
module load hisat2
for i in $(ls *.fq)
do 
 hisat2 -x $REFDIR/hg38 -U $i -S $MAPDIR/${i}.sam -p 10   
done 


## convert sam to bam, and sort it 
cd $MAPDIR
module load samtools
for i in $(ls *.sam)
do 
 i=${i/.sam}
 samtools view -bS ${i}.sam > ${i}.bam #sam to bam
 samtools sort ${i}.bam -o sorted_${i}.bam -@ 10 
 samtools flagstat sorted_${i}.bam -@ 10 > ${i}.stat 
done



## add index for sorted sam file
cd $MAPDIR
module load samtools
for i in $(ls sorted_*.bam)
do 
 samtools index $i & 
done
wait


# use HTseq to count gene matrix.
cd $MAPDIR
for i in $(ls sorted*.bam)
do {
htseq-count -f bam -c $COUNTDIR/${i}.csv $MAPDIR/${i} $REFDIR/Homo_sapiens.GRCh38.106.gtf
} & 
done
wait


# use python to get count-matrix
cd $COUNTDIR
python $SCDIR/countit.py $COUNTDIR