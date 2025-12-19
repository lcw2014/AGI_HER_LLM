tag=$1

i="none"

#############################################
# exp. model=t5-large, 3090 * 4EA
#############################################

# We know task-boundary

# SAPT
bash scripts2/run.sh 1 t5-large sapt 3e-4 1 0 lr3e-4
bash scripts2/run.sh 2 t5-large sapt 3e-4 1 1 lr3e-4
bash scripts2/run.sh 3 t5-large sapt 3e-4 1 2 lr3e-4
bash scripts2/run.sh 4 t5-large sapt 1e-4 1 0 lr1e-4
bash scripts2/run.sh 5 t5-large sapt 1e-4 1 1 lr1e-4
bash scripts2/run.sh 6 t5-large sapt 1e-4 1 2 lr1e-4

# 모든 백그라운드 작업이 끝날 때까지 대기
wait

# Gainlora
# bash scripts2/run.sh 7 t5-large gainlora_inflora 1 3e-4 1 lr3e-4;
