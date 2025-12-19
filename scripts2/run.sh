#!/bin/bash
set -x

export OMP_NUM_THREADS=15

order=$1
model=$2

method=$3
lr=$4
num_train_epochs=$5

gpu=$6
tag=$7

declare -A datasets
datasets[1]="dbpedia amazon sst2 agnews"
datasets[2]="dbpedia amazon agnews sst2"
datasets[3]="sst2 amazon agnews dbpedia"

datasets[4]="mnli cb wic copa qqp boolq rte imdb yelp amazon sst2 dbpedia agnews multirc yahoo"
datasets[5]="multirc boolq wic mnli cb copa qqp rte imdb sst2 dbpedia agnews yelp amazon yahoo"
datasets[6]="yelp amazon mnli cb copa qqp rte imdb sst2 dbpedia agnews yahoo multirc boolq wic"

datasets[7]="task1572_samsum_summary task363_sst2_polarity_classification task1290_xsum_summarization task181_outcome_extraction task002_quoref_answer_generation task1510_evalution_relation_extraction task639_multi_woz_user_utterance_generation task1729_personachat_generate_next task073_commonsenseqa_answer_generation task1590_diplomacy_text_generation task748_glucose_reverse_cause_event_detection task511_reddit_tifu_long_text_summarization task591_sciq_answer_generation task1687_sentiment140_classification task875_emotion_classification"
datasets[8]="task748_glucose_reverse_cause_event_detection task073_commonsenseqa_answer_generation task1590_diplomacy_text_generation task639_multi_woz_user_utterance_generation task1572_samsum_summary task1687_sentiment140_classification task591_sciq_answer_generation task363_sst2_polarity_classification task1510_evalution_relation_extraction task1729_personachat_generate_next task181_outcome_extraction task511_reddit_tifu_long_text_summarization task002_quoref_answer_generation task1290_xsum_summarization task875_emotion_classification"

n_tasks=$(echo -n ${datasets[$order]} | wc -w)

IFS=' ' read -ra current_datasets <<< "${datasets[$order]}"

run_name="${model}_${method}_order${order}_${tag}"
base_output_dir="logs_and_outputs/${run_name}/outputs"
order_txt=${datasets[$order]// /,}
printf "%s" "${order_txt}" > ${base_output_dir}/task_order.txt

model_path="inital_model/${model}"
for i in $(seq 0 $(($n_tasks - 1))); do
   if [ $i -eq 0 ]; then
      output_dir="logs_and_outputs/${run_name}/outputs/1-${current_datasets[0]}"
      task_config="configs/order${order}_configs/${current_datasets[0]}" 

      CUDA_VISIBLE_DEVICES=$gpu python src2/run_t5.py \
        --do_train --do_predict --predict_with_generate \
        --model_name_or_path ${model_path} \
        --data_dir CL_Benchmark \
        --task_order $order_txt \
        --task_config_dir $task_config \
        --output_dir $output_dir \
        --per_device_train_batch_size 6 \
        --per_device_eval_batch_size 128 \
        --gradient_accumulation_steps 5 \
        --learning_rate ${lr} \
        --num_train_epochs ${num_train_epochs} \
        --run_name ${run_name} \
        --max_source_length 512 \
        --max_target_length 50 \
        --generation_max_length 50 \
        --add_task_name False \
        --add_dataset_name False \
        --overwrite_output_dir \
        --overwrite_cache \
        --lr_scheduler_type constant \
        --warmup_steps 0 \
        --logging_strategy steps \
        --logging_steps 10 \
        --metric_for_best_model eval_rougeL \
        --evaluation_strategy steps \
        --save_strategy steps \
        --save_total_limit 1 \
        --lora_r 4 \
        --lora_alpha 32 \
        --lora_dropout 0.0 \
        --load_best_model_at_end \
        --data_replay_freq -1 \
        --replay_after_n_epoch -1 \
        --kl_ratio 0.0 \
        --attn_temperature 1 \
        --mlp_hidden_dim 100 \
        --model_name $method \
        --threshold 0.995 \
        --transthreshold 0.995
   else
      prev_index=$((i-1))
      next_index=$((i+1))

      prev_output_dir="logs_and_outputs/${run_name}/outputs/${i}-${current_datasets[$prev_index]}"
      output_dir="logs_and_outputs/${run_name}/outputs/${next_index}-${current_datasets[$i]}"
      task_config="configs/order${order}_configs/${current_datasets[$i]}"

       CUDA_VISIBLE_DEVICES=$gpu python src2/run_t5.py \
        --do_train --do_predict --predict_with_generate \
        --model_name_or_path ${model_path} \
        --previous_lora_path ${prev_output_dir}/saved_weights \
        --load_checkpoint_from ${prev_output_dir}/saved_weights/trans_input.pt \
        --previous_prompt_key_path ${prev_output_dir}/saved_weights/prompts_keys_till_now.pt \
        --data_dir CL_Benchmark \
        --task_order $order_txt \
        --task_config_dir $task_config \
        --output_dir $output_dir \
        --per_device_train_batch_size 6 \
        --per_device_eval_batch_size 128 \
        --gradient_accumulation_steps 5 \
        --learning_rate ${lr} \
        --num_train_epochs ${num_train_epochs} \
        --run_name ${run_name} \
        --max_source_length 512 \
        --max_target_length 50 \
        --generation_max_length 50 \
        --add_task_name False \
        --add_dataset_name False \
        --overwrite_output_dir \
        --overwrite_cache \
        --lr_scheduler_type constant \
        --warmup_steps 0 \
        --logging_strategy steps \
        --logging_steps 10 \
        --metric_for_best_model eval_rougeL \
        --evaluation_strategy steps \
        --save_strategy steps \
        --save_total_limit 1 \
        --lora_r 4 \
        --lora_alpha 32 \
        --lora_dropout 0.0 \
        --load_best_model_at_end \
        --data_replay_freq -1 \
        --replay_after_n_epoch -1 \
        --kl_ratio 0.0 \
        --attn_temperature 1 \
        --mlp_hidden_dim 100 \
        --model_name $method \
        --threshold 0.995 \
        --transthreshold 0.995
   fi
    
    sleep 5
done

base_output_dir="logs_and_outputs/${model}_${method}_order${order}_${tag}_${tag}/outputs"
order_txt=$(echo "${datasets[$order]}" | sed 's/ /,/g')
printf "%s" "${order_txt}" > ${base_output_dir}/task_order.txt

python score.py ${model}_${method}_order${order}_${tag} ${model}_${method}_order${order}_${tag}

python ~/Workspace/dmail.py --subject "[301] PIKA ${method}_${model}_${order}_${tag}" \
   --body "$(cat results/${model}_${method}_order${order}_${tag}.txt)"
