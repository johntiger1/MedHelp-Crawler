#!/bin/bash

file=$1
outfile=$2

sed '/^\s*$/d' $file | sed -e 's/  */ /g' | sed -e 's/^ //g' | sed -e 's/ $//g' | sed '/^Hi,$/d' | sed '/^\C~$/d' > $outfile
