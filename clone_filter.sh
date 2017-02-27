#!/bin/sh

#$ -S /bin/sh

#$ -q workq


#récupération des input
f1=$1	# fichier fastq 1
f2=$2	# fichier fastq 2
outdir=$3
stacks_dir=$4	# dossier d'executable stacks


type=`echo $f1 | awk '{if(match($1,".gz") > 0 ){print "gzfastq"}else{print "fastq"}}'`

echo "CMD:		module load compiler/gcc-4.9.1 ; $stacks_dir/clone_filter -1 $f1 -2 $f2 -o $outdir -i $type -y fastq" 
module load compiler/gcc-4.9.1 ; $stacks_dir/clone_filter -1 $f1 -2 $f2 -o $outdir -i $type -y fastq

ls $outdir

if [[ "$type" != "gzfastq" && ! -h $f1 ]]
then
	gzip $f1 $f2
fi

base=`basename $f1 | sed 's/_1.fq/ /' | awk '{print $1}'`

mv $outdir/${base}_1.1.fq $outdir/${base}_cloneF_1.fq
mv $outdir/${base}_2.2.fq $outdir/${base}_cloneF_2.fq

gzip $outdir/${base}_cloneF*
