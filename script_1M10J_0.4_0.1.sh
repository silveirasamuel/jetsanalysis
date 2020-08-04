#!/bin/bash
#SBATCH --job-name=CSJets_1M10J_0.4_0.1
#SBATCH --time=24:00:00
#SBATCH --ntasks=1
#SBATCH --array=1-10
#SBATCH --output=output_100K10J_0.4_0.1_%a.out
#SBATCH --error=errors_100K10J_0.4_0.1_%a.err

module add gnu8/8.3.0
module load gnu8/8.3.0
module load root-6.16.00-gcc-8.3.0-ih7ao2c

echo -e "\n## Job iniciado em $(date +'%d-%m-%Y as %T') ###################"

cd $SLURM_SUBMIT_DIR
echo -e "\n## Diretorio de submissao do job: $SLURM_SUBMIT_DIR \n"

srun ./CSAnalysis ggscbar 100000 0.4 0.1 $SLURM_ARRAY_TASK_ID $SLURM_ARRAY_TASK_MAX

cd OUTPUT/Histograms_Output/
mkdir -p 1000000_0.4_0.1_10
cd ../../

srun root.exe -q "analysisJetsInvariantMass.C(100000,0.4,0.1,$SLURM_ARRAY_TASK_ID,$SLURM_ARRAY_TASK_MAX)"
srun root.exe -q "analysisJetsQuarksPt.C(100000,0.4,0.1,$SLURM_ARRAY_TASK_ID,$SLURM_ARRAY_TASK_MAX)"
srun root.exe -q "analysisMatchesCharmJets.C(100000,0.4,0.1,$SLURM_ARRAY_TASK_ID,$SLURM_ARRAY_TASK_MAX)"

mkdir -p logs_1M_0.4_0.1_10
mv output_100K10J_0.4_0.1_$SLURM_ARRAY_TASK_ID.out logs_1M_0.4_0.1_10/
mv errors_100K10J_0.4_0.1_$SLURM_ARRAY_TASK_ID.err logs_1M_0.4_0.1_10/


echo -e "\n## Job finalizado em $(date +'%d-%m-%Y as %T') ###################"
           