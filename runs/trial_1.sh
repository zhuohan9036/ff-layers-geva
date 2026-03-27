export CUDA_VISIBLE_DEVICES=3
max_sentences=100

python analysis/generate_outputs.py \
--data_file examples/language_model/wikitext-103/wiki.train.tokens \
--model_dir checkpoints/adaptive_lm_wiki103.v2/ \
--get_trigger_examples \
--max_sentences $max_sentences \
--top_k_trigger_examples 50  \
--extract_mode layer-raw \
--output_file top50_train_${max_sentences}sents.jsonl