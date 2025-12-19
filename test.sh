tag=$1

i="none"

## We don't know task-boundary

# lora
# bash scripts/run.sh 6 t5-large lora 1e-3 False 0.0 ${tag};
# bash scripts/run.sh 7 t5-large lora 1e-3 False 0.0 ${tag};

# l2
# bash scripts/run.sh 6 t5-large l2 1e-3 False 0.0 ${tag};
# bash scripts/run.sh 7 t5-large l2 1e-3 False 0.0 ${tag};

# ------

## We know task-boundary

# inclora
# bash scripts/run.sh 6 t5-large inclora 1e-3 True 0.0 ${tag};
# bash scripts/run.sh 7 t5-large inclora 1e-3 True 0.0 ${tag};

# olora
# bash scripts/run.sh 6 t5-large olora 1e-3 True 0.0 ${tag};\
# bash scripts/run.sh 7 t5-large olora 1e-3 True 0.0 ${tag};

# ------

## Propsed

# srb
# bash scripts/run.sh 6 t5-large srb 1e-3 False ${i} ${tag}${i};
bash scripts/run.sh 7 t5-large srb 0.0003 False ${i} ${tag}${i} > var.log