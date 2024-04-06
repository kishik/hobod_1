#! /usr/bin/env bash

OUT_DIR="FoundResult"

yarn jar /opt/cloudera/parcels/CDH/lib/hadoop-mapreduce/hadoop-streaming.jar \
    -D mapreduce.job.reduces=4 \
    -D mapreduce.job.name="Own words" \
    -files mapper1.py,reducer1.py \
    -mapper "python3 mapper1.py" \
    -reducer "python3 reducer1.py" \
    -input "/data/wiki/en_articles" \
    -output ${OUT_DIR} > /dev/null

hdfs dfs -rm -r -skipTrash ${OUT_DIR}/_SUCCESS > /dev/null

OUT_DIR2="SortedResult"

yarn jar /opt/cloudera/parcels/CDH/lib/hadoop-mapreduce/hadoop-streaming.jar \
    -D mapreduce.job.reduces=1 \
    -D mapreduce.job.name="Sorting" \
    -D stream.num.map.output.key.fields=2 \
    -D mapreduce.job.output.key.comparator.class=org.apache.hadoop.mapreduce.lib.partition.KeyFieldBasedComparator \
    -D mapreduce.partition.keycomparator.options='-k1,1nr -k2' \
    -files mapper2.py,reducer2.py \
    -mapper "python3 mapper2.py" \
    -reducer "python3 reducer2.py" \
    -input ${OUT_DIR} \
    -output ${OUT_DIR2} > /dev/null

hdfs dfs -rm -r -skipTrash ${OUT_DIR} > /dev/null

touch sorted_result.txt
hdfs dfs -cat ${OUT_DIR2}/part-00000 > sorted_result.txt
head -n 10 sorted_result.txt
rm sorted_result.txt

hdfs dfs -rm -r -skipTrash ${OUT_DIR2} > /dev/null
