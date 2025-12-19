#!/bin/bash
set -x

export OMP_NUM_THREADS=15

order=$1
model=$2

method=$3
lr=$4
inc=$5

hparam=$6

tag=$7

declare -A datasets
datasets[1]="dbpedia amazon sst-2 agnews"
datasets[2]="dbpedia amazon agnews sst-2"
datasets[3]="sst-2 amazon agnews dbpedia"
datasets[4]="mnli cb wic copa qqp rte amazon sst-2 dbpedia agnews"
datasets[5]="wic mnli cb copa qqp rte sst-2 dbpedia agnews amazon"
datasets[6]="amazon mnli cb copa qqp rte sst-2 dbpedia agnews wic"

n_tasks=$(echo -n ${datasets[$order]} | wc -w)

IFS=' ' read -ra current_datasets <<< "${datasets[$order]}"

for i in $(seq 0 $(($n_tasks - 1))); do
   if [ $i -eq 0 ]; then
      model_path="initial_model/${model}"
      output_dir="output/${model}/${method}/order_${order}/outputs/1-${current_datasets[0]}"
      task_config="configs_llm/order${order}_configs/${current_datasets[0]}"
      run_name="order${order}_round1"
      prev_scheduler_path="none"
   else
      prev_index=$((i-1))
      next_index=$((i+1))

      model_path="output/${model}/${method}/order_${order}/outputs/${i}-${current_datasets[$prev_index]}/adapter"
      output_dir="output/${model}/${method}/order_${order}/outputs/${next_index}-${current_datasets[$i]}"
      task_config="configs_llm/order${order}_configs/${current_datasets[$i]}"
      run_name="order${order}_round${next_index}"
      prev_scheduler_path="output/${model}/${method}/order_${order}/outputs/${i}-${current_datasets[$prev_index]}"
   fi
   
   CUDA_VISIBLE_DEVICES=0,1,2,3 torchrun --nnodes 1 --nproc_per_node 4 src/run_uie_lora.py \
      --do_train --do_predict --predict_with_generate \
      --model_name_or_path $model_path \
      --data_dir CL_Benchmark \
      --task_config_dir $task_config \
      --instruction_file configs_llm/instruction_config_llm.json \
      --instruction_strategy single \
      --output_dir $output_dir \
      --per_device_train_batch_size 4 \
      --per_device_eval_batch_size 16 \
      --gradient_accumulation_steps 4 \
      --learning_rate $lr \
      --num_train_epochs 1 \
      --run_name $run_name \
      --max_source_length 512 \
      --max_target_length 50 \
      --generation_max_length 50 \
      --add_task_name True \
      --add_dataset_name True \
      --overwrite_output_dir \
      --overwrite_cache \
      --lr_scheduler_type constant \
      --warmup_steps 0 \
      --logging_strategy steps \
      --logging_steps 10 \
      --evaluation_strategy no \
      --save_strategy no \
      --save_steps 1500 \
      --method $method --inc $inc \
      --prev_scheduler_path $prev_scheduler_path
      # --c $hparam

   sleep 5
done

last_res=output/${model}/${method}/order_${order}/outputs/${next_index}-${current_datasets[$i]}
python ~/dmail.py --subject "[a1] PIKA ${method}_${model}_${order}_${tag}" \
   --body "$(cat ${last_res}/predict_results.json)"

mv output/${model}/${method}/order_${order}/outputs output/${model}/${method}/order_${order}/outputs_${tag}