tag=$1

i="none"

#############################################
# exp. model=llama3, A100 * 4EA
#############################################

# task-aware

# inclora
# bash scripts/run_llama.sh 1 llama3 inclora 1e-4 True 0.0 ${tag};\
# bash scripts/run_llama.sh 2 llama3 inclora 1e-4 True 0.0 ${tag};\
# bash scripts/run_llama.sh 3 llama3 inclora 1e-4 True 0.0 ${tag};\

# o-inclora
bash scripts/run_llama.sh 1 llama3 olora 1e-4 True 0.0 ${tag};\
bash scripts/run_llama.sh 2 llama3 olora 1e-4 True 0.0 ${tag};\
bash scripts/run_llama.sh 3 llama3 olora 1e-4 True 0.0 ${tag};\

# task-agnostic

# lora
# bash scripts/run_llama.sh 1 llama3 lora 1e-4 False 0.0 ${tag};\
# bash scripts/run_llama.sh 2 llama3 lora 1e-4 False 0.0 ${tag};\
# bash scripts/run_llama.sh 3 llama3 lora 1e-4 False 0.0 ${tag};\

# l2
# bash scripts/run_llama.sh 1 llama3 l2 1e-4 False 0.0 ${tag};\
# bash scripts/run_llama.sh 2 llama3 l2 1e-4 False 0.0 ${tag};\
# bash scripts/run_llama.sh 3 llama3 l2 1e-4 False 0.0 ${tag};\

# srb
bash scripts/run_llama.sh 1 llama3 srb 1e-3 False ${i} ${tag}${i};\
bash scripts/run_llama.sh 2 llama3 srb 1e-3 False ${i} ${tag}${i};\
bash scripts/run_llama.sh 3 llama3 srb 1e-3 False ${i} ${tag}${i};\

#############################################
# exp. model=llama3-chat, A100 * 4EA
#############################################

# task-aware

# inclora
# bash scripts/run_llama.sh 1 llama3_chat inclora 1e-4 True 0.0 ${tag};\
# bash scripts/run_llama.sh 2 llama3_chat inclora 1e-4 True 0.0 ${tag};\
# bash scripts/run_llama.sh 3 llama3_chat inclora 1e-4 True 0.0 ${tag};\

# o-inclora
# bash scripts/run_llama.sh 1 llama3_chat olora 1e-4 True 0.0 ${tag};\
# bash scripts/run_llama.sh 2 llama3_chat olora 1e-4 True 0.0 ${tag};\
# bash scripts/run_llama.sh 3 llama3_chat olora 1e-4 True 0.0 ${tag};\

# task-agnostic

# lora
# bash scripts/run_llama.sh 1 llama3_chat lora 1e-4 False 0.0 ${tag};\
# bash scripts/run_llama.sh 2 llama3_chat lora 1e-4 False 0.0 ${tag};\
# bash scripts/run_llama.sh 3 llama3_chat lora 1e-4 False 0.0 ${tag};\

# l2
# bash scripts/run_llama.sh 1 llama3_chat l2 1e-4 False 0.0 ${tag};\
# bash scripts/run_llama.sh 2 llama3_chat l2 1e-4 False 0.0 ${tag};\
# bash scripts/run_llama.sh 3 llama3_chat l2 1e-4 False 0.0 ${tag};\

# srb
bash scripts/run_llama.sh 1 llama3_chat srb 1e-3 False ${i} ${tag}${i};\
bash scripts/run_llama.sh 2 llama3_chat srb 1e-3 False ${i} ${tag}${i};\
bash scripts/run_llama.sh 3 llama3_chat srb 1e-3 False ${i} ${tag}${i};\
