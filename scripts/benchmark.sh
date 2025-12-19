tag=$1

i="none"

#############################################
# exp. model=t5-large, 3090 * 4EA
#############################################

# We know task-boundary

# inclora
# bash scripts/run.sh 1 t5-large inclora 1e-3 True 0.0 ${tag};\
# bash scripts/run.sh 2 t5-large inclora 1e-3 True 0.0 ${tag};\
# bash scripts/run.sh 3 t5-large inclora 1e-3 True 0.0 ${tag};\
# bash scripts/run.sh 4 t5-large inclora 1e-3 True 0.0 ${tag};\
# bash scripts/run.sh 5 t5-large inclora 1e-3 True 0.0 ${tag};\
# bash scripts/run.sh 6 t5-large inclora 1e-3 True 0.0 ${tag};


# olora
# bash scripts/run.sh 1 t5-large olora 1e-5 True 0.0 ${tag};\
# bash scripts/run.sh 2 t5-large olora 1e-5 True 0.0 ${tag};\
# bash scripts/run.sh 3 t5-large olora 1e-5 True 0.0 ${tag};\
# bash scripts/run.sh 4 t5-large olora 1e-5 True 0.0 ${tag};\
# bash scripts/run.sh 5 t5-large olora 1e-5 True 0.0 ${tag};\
# bash scripts/run.sh 6 t5-large olora 1e-5 True 0.0 ${tag};\
# bash scripts/run.sh 7 t5-large olora 1e-5 True 0.0 ${tag};\
# bash scripts/run.sh 8 t5-large olora 1e-5 True 0.0 ${tag};

# We don't know task-boundary

# lora
# bash scripts/run.sh 1 t5-large lora 1e-3 False 0.0 ${tag};\
# bash scripts/run.sh 2 t5-large lora 1e-3 False 0.0 ${tag};\
# bash scripts/run.sh 3 t5-large lora 1e-3 False 0.0 ${tag};\
# bash scripts/run.sh 4 t5-large lora 1e-3 False 0.0 ${tag};\
# bash scripts/run.sh 5 t5-large lora 1e-3 False 0.0 ${tag};\
# bash scripts/run.sh 6 t5-large lora 1e-3 False 0.0 ${tag};
# bash scripts/run.sh 7 t5-large lora 1e-3 False 0.0 ${tag};
# bash scripts/run.sh 8 t5-large lora 1e-3 False 0.0 ${tag};

# l2
# bash scripts/run.sh 4 t5-large l2 1e-5 False 0.0 ${tag};\
# bash scripts/run.sh 5 t5-large l2 1e-5 False 0.0 ${tag};
# bash scripts/run.sh 6 t5-large l2 1e-5 False 0.0 ${tag};\
# bash scripts/run.sh 7 t5-large l2 1e-5 False 0.0 ${tag};
# bash scripts/run.sh 8 t5-large l2 1e-5 False 0.0 ${tag};


# srb
# bash scripts/run.sh 1 t5-large srb 1e-3 False ${i} ${tag}${i};\
# bash scripts/run.sh 2 t5-large srb 1e-3 False ${i} ${tag}${i};\
# bash scripts/run.sh 3 t5-large srb 1e-3 False ${i} ${tag}${i};\
# bash scripts/run.sh 4 t5-large srb 1e-3 False ${i} ${tag}${i};\
# bash scripts/run.sh 5 t5-large srb 1e-3 False ${i} ${tag}${i};\
# bash scripts/run.sh 6 t5-large srb 1e-3 False ${i} ${tag}${i};

bash scripts/run.sh 1 t5-large srb 1e-3 False ${i} 0.99 0.99 0.9;
bash scripts/run.sh 2 t5-large srb 1e-3 False ${i} 0.99 0.99 0.9;
bash scripts/run.sh 3 t5-large srb 1e-3 False ${i} 0.99 0.99 0.9;
bash scripts/run.sh 4 t5-large srb 1e-3 False ${i} 0.99 0.99 0.9;
bash scripts/run.sh 5 t5-large srb 1e-3 False ${i} 0.99 0.99 0.9;
bash scripts/run.sh 6 t5-large srb 1e-3 False ${i} 0.99 0.99 0.9;

# bash scripts/run.sh 1 t5-large srb 1e-3 False "none" lr1e-3bs14
