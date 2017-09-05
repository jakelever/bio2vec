#!/bin/bash
set -euo pipefail

HERE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SRC_DIR=word2vec/src
BIN_DIR=word2vec/bin
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

