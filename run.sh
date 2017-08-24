#!/bin/bash
set -euxo pipefail

MEDLINE_DIR=$1
TMP_TXT_DIR=tmp.medlineTxt

SRC_DIR=word2vec/src
BIN_DIR=word2vec/bin
TEXT_DATA=medline.corpus
VECTOR_DATA=medline.vectors

rm -fr word2vec
git clone https://github.com/jakelever/word2vec.git

cd $SRC_DIR
make
cd -

rm -fr $TMP_TXT_DIR
mkdir $TMP_TXT_DIR
python PubMed2Txt.py -i $MEDLINE_DIR -o $TMP_TXT_DIR

cat $TMP_TXT_DIR/*.txt > $TEXT_DATA
rm -fr $TMP_TXT_DIR

time $BIN_DIR/word2vec -train $TEXT_DATA -output $VECTOR_DATA -cbow 0 -size 200 -window 5 -negative 0 -hs 1 -sample 1e-3 -threads 12 -binary 1

rm -fr $TEXT_DATA

