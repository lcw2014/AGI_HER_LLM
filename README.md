# task-agnostic continual adaptation for large language models

## Comparison of Methods
<img src="fig/main.png" width="" style="background-color:white;"/>

## Method
<img src="fig/algorithm.png" width="" style="background-color:white;"/>


## Experiments

### Task Series

- standard CL benchmark: 1,2,3
- long CL benchmark: 4,5,6

### Models

- inital_model/t5_large
- inital_model/llama3

## Run Code
```bash
conda create -n tta-text python=3.10.12 
pip3 install -r requirements.txt
conda env create -f requirements2.yaml
```

```bash
# for T5
bash scripts/benchmark.sh <tag-name>

# for LLaMA
bash scripts/benchmark_llm.sh <tag-name>
```
