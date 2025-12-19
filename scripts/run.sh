#!/bin/bash
set -x

export OMP_NUM_THREADS=15

order=$1
model=$2

method=$3
lr=$4
inc=$5

hparam=$6
alpha=$7
beta=$8
gamma=$9

# tag=$7
tag=a${alpha}b${beta}c${gamma}_defaultoptim_warmup1000

declare -A datasets
datasets[1]="dbpedia amazon sst2 agnews"
datasets[2]="dbpedia amazon agnews sst2"
datasets[3]="sst2 amazon agnews dbpedia"

datasets[4]="mnli cb wic copa qqp boolq rte imdb yelp amazon sst2 dbpedia agnews multirc yahoo"
datasets[5]="multirc boolq wic mnli cb copa qqp rte imdb sst2 dbpedia agnews yelp amazon yahoo"
datasets[6]="yelp amazon mnli cb copa qqp rte imdb sst2 dbpedia agnews yahoo multirc boolq wic"

datasets[7]="task1572_samsum_summary task363_sst2_polarity_classification task1290_xsum_summarization task181_outcome_extraction task002_quoref_answer_generation task1510_evalution_relation_extraction task639_multi_woz_user_utterance_generation task1729_personachat_generate_next task073_commonsenseqa_answer_generation task1590_diplomacy_text_generation task748_glucose_reverse_cause_event_detection task511_reddit_tifu_long_text_summarization task591_sciq_answer_generation task1687_sentiment140_classification task875_emotion_classification"
datasets[8]='task748_glucose_reverse_cause_event_detection task073_commonsenseqa_answer_generation task1590_diplomacy_text_generation task639_multi_woz_user_utterance_generation task1572_samsum_summary task1687_sentiment140_classification task591_sciq_answer_generation task363_sst2_polarity_classification task1510_evalution_relation_extraction task1729_personachat_generate_next task181_outcome_extraction task511_reddit_tifu_long_text_summarization task002_quoref_answer_generation task1290_xsum_summarization task875_emotion_classification'
# task748_glucose_reverse_cause_event_detection
# task073_commonsenseqa_answer_generation
# task1590_diplomacy_text_generation
# task639_multi_woz_user_utterance_generation
# task1572_samsum_summary

# task1687_sentiment140_classification
# task591_sciq_answer_generation
# task363_sst2_polarity_classification
# task1510_evalution_relation_extraction
# task1729_personachat_generate_next

# task181_outcome_extraction
# task511_reddit_tifu_long_text_summarization
# task002_quoref_answer_generation
# task1290_xsum_summarization
# task875_emotion_classification

n_tasks=$(echo -n ${datasets[$order]} | wc -w)

IFS=' ' read -ra current_datasets <<< "${datasets[$order]}"

for i in $(seq 0 $(($n_tasks - 1))); do
   if [ $i -eq 0 ]; then
      model_path="inital_model/${model}"
      output_dir="logs_and_outputs/${model}_${method}_order${order}_${tag}/outputs/1-${current_datasets[0]}"
      task_config="configs/order${order}_configs/${current_datasets[0]}" 
      run_name="order${order}_round1"
      prev_scheduler_path="none"
   else
      prev_index=$((i-1))
      next_index=$((i+1))

      model_path="logs_and_outputs/${model}_${method}_order${order}_${tag}/outputs/${i}-${current_datasets[$prev_index]}/adapter"
      output_dir="logs_and_outputs/${model}_${method}_order${order}_${tag}/outputs/${next_index}-${current_datasets[$i]}"
      task_config="configs/order${order}_configs/${current_datasets[$i]}"
      run_name="order${order}_round${next_index}"
      prev_scheduler_path="logs_and_outputs/${model}_${method}_order${order}_${tag}/outputs/${i}-${current_datasets[$prev_index]}"
   fi
   
   CUDA_VISIBLE_DEVICES=0,1 torchrun --nnodes 1 --nproc_per_node 2 src/run_uie_lora.py \
      --do_train --do_predict --predict_with_generate \
      --model_name_or_path $model_path \
      --data_dir CL_Benchmark \
      --task_config_dir $task_config \
      --instruction_file configs/instruction_config.json \
      --instruction_strategy single \
      --output_dir $output_dir \
      --per_device_train_batch_size 8 \
      --per_device_eval_batch_size 128 \
      --gradient_accumulation_steps 8 \
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
      --warmup_steps 1000 \
      --logging_strategy steps \
      --logging_steps 10 \
      --evaluation_strategy no \
      --save_strategy no \
      --save_steps 1500 \
      --method $method --inc $inc \
      --prev_scheduler_path $prev_scheduler_path
      # --a $alpha \
      # --b $beta \
      # --c $gamma
      # --b $hparam 
      # > diversity_${order}_${i}_${tag}.log

   sleep 5
done

# last_res=logs_and_outputs/${model}_${method}_order${order}_${tag}/outputs/${next_index}-${current_datasets[$i]}
# python ~/dmail.py --subject "[301] PIKA ${model}_${method}_order${order}_${tag}" \
#    --body "$(cat ${last_res}/predict_results.json)"

base_output_dir="logs_and_outputs/${model}_${method}_order${order}_${tag}/outputs"
order_txt=$(echo "${datasets[$order]}" | sed 's/ /,/g')
printf "%s" "${order_txt}" > ${base_output_dir}/task_order.txt

python score.py ${model}_${method}_order${order}_${tag} ${model}_${method}_order${order}_${tag}

python ~/Workspace/dmail.py --subject "[301] PIKA ${method}_${model}_${order}_${tag}" \
   --body "$(cat results/${model}_${method}_order${order}_${tag}.txt)"
