#!/bin/bash
set -euo pipefail

USAGE="$0 MEDLINE_DIR OUT_VECTOR\n  MEDLINE_DIR: Directory with MEDLINE XML files\n  OUT_VECTOR: Filename to save word2vec vector\n"
if [[ $# -ne 2 ]]; then
	echo -e $USAGE
	exit 1
elif [ ! -d $1 ]; then
	echo -e $USAGE
	echo "ERROR: MEDLINE_DIR must be a directory"
	exit 1
fi

MEDLINE_DIR=$1
OUT_VECTOR=$2
TMP_TXT_DIR=tmp.medline.parts

HERE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SRC_DIR=word2vec/src
BIN_DIR=word2vec/bin
TEXT_DATA=tmp.medline.txt
WORD2VEC_REPO=https://github.com/jakelever/word2vec.git

echo
echo "#####################"
echo "Cloning word2vec repo ($WORD2VEC_REPO)"
echo "#####################"
rm -fr word2vec
git clone $WORD2VEC_REPO

echo
echo "#####################"
echo "Building word2vec"
echo "#####################"
cd $SRC_DIR
make
cd -

echo
echo "#####################"
echo "Converting Pubmed XML files to raw text"
echo "#####################"
rm -fr $TMP_TXT_DIR
mkdir $TMP_TXT_DIR
time python $HERE/PubMed2Txt.py -i $MEDLINE_DIR -o $TMP_TXT_DIR

echo
echo "#####################"
echo "Combining all Pubmed text files into one"
echo "#####################"
cat $TMP_TXT_DIR/*.txt > $TEXT_DATA
rm -fr $TMP_TXT_DIR

echo
echo "#####################"
echo "Running word2vec"
echo "#####################"
time $BIN_DIR/word2vec -train $TEXT_DATA -output $OUT_VECTOR -cbow 0 -size 200 -window 5 -negative 0 -hs 1 -sample 1e-3 -threads 12 -binary 1

echo
echo "#####################"
echo "Cleanup"
echo "#####################"
rm -fr $TEXT_DATA
rm -fr word2vec

echo
echo "#####################"
echo "Complete. Vectors stored at $OUT_VECTOR"
echo "#####################"
