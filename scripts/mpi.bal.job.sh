#!/bin/bash
#
#PBS -l nodes=1:r601:ppn=24
#PBS -l walltime=2:00:00
#PBS -N radix.mpi.bal
#PBS -m bea
#PBS -e out/mpi_bal.err
#PBS -o out/mpi_bal.out

module load gnu/openmpi

cd $PBS_O_WORKDIR

NUM_EXECS=5
G=(2 4 8)
SIZES=(256 4096 65536 1048576 16777216)
THREADS=(4 8 16)

for g in ${G[@]}; do
	
	for size in ${SIZES[@]}; do

		for threads in ${THREADS[@]}; do

			mkdir -p results/mpi
			output=results/mpi.bal/${g}_s${size}_t${threads}
			rm -rf $output && touch $output

			for try in `seq 1 $NUM_EXECS`; do
				echo "running try $try, g=$g, size=$size, threads=$threads"
				mpirun -n $threads -machinefile $PBS_NODEFILE bin/radix.bal.mpi $size $g >> $output
			done
		done
	done
done