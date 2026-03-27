#!/bin/bash
# Adapted from https://github.com/facebookresearch/MIXER/blob/master/prepareData.sh

# URLS=(
#     "https://s3.amazonaws.com/research.metamind.io/wikitext/wikitext-103-v1.zip"
# )
# FILES=(
#     "wikitext-103-v1.zip"
# )

# for ((i=0;i<${#URLS[@]};++i)); do
#     file=${FILES[i]}
#     if [ -f $file ]; then
#         echo "$file already exists, skipping download"
#     else
#         url=${URLS[i]}
#         wget "$url"
#         if [ -f $file ]; then
#             echo "$url successfully downloaded."
#         else
#             echo "$url not successfully downloaded."
#             exit -1
#         fi
#         if [ ${file: -4} == ".tgz" ]; then
#             tar zxvf $file
#         elif [ ${file: -4} == ".tar" ]; then
#             tar xvf $file
#         elif [ ${file: -4} == ".zip" ]; then
#             unzip $file
#         fi
#     fi
# done
# cd ..

#!/bin/bash
set -e

OUT_DIR="examples/language_model/wikitext-103"
mkdir -p "$OUT_DIR"

python - <<'PY'
from pathlib import Path
import sys

try:
    from datasets import load_dataset
except ImportError:
    sys.exit("Please install datasets first: pip install datasets")

out_dir = Path("examples/language_model/wikitext-103")
out_dir.mkdir(parents=True, exist_ok=True)

# 这里必须用 v1，不要用 raw-v1
ds = load_dataset("Salesforce/wikitext", "wikitext-103-v1")

mapping = {
    "train": "wiki.train.tokens",
    "validation": "wiki.valid.tokens",
    "test": "wiki.test.tokens",
}

for split, fname in mapping.items():
    out_path = out_dir / fname
    with open(out_path, "w", encoding="utf-8") as f:
        for text in ds[split]["text"]:
            f.write(text + "\n")
    print(f"Wrote {out_path}")
PY

echo "Done. Files created in $OUT_DIR"
ls -lh "$OUT_DIR"