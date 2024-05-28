#!/bin/bash


your_array=()

# 找到当前目录下所有以 .md 结尾的文件名（不包括 .md 扩展名），并保存到数组中
while IFS= read -r -d '' file; 
  do
	filename=$(basename -- "$file")
	your_array+=("${filename%.*}")
  done < <(find . -maxdepth 1 -type f -name "*.md" -print0)
# sed -n "6p" nic_bond-hl.md 
# 输出数组内容

for file in "${your_array[@]}"; do
    aa=$(sed -n "1p" $file.md|awk '{$1=""; print $0}' | sed 's/^[ \t]*//')
    {  
	        echo "+++  
title = '${aa}'  
date = 2024-04-12T09:39:39Z  
draft = true  
+++"  
		    cat "$file.md";  
	    } > "$file-hl.md"
    sed -i '6d' $file-hl.md
done

ls -lha|awk '{print $9}'|grep -v hl|grep -v gitbooktohugo.sh |xargs  rm -rf 
