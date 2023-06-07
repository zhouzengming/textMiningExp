# init
rm(list = ls());gc();
setwd("/media/zzm/3AAD22D845A051D1/textmining")
library(tidytext)
library(dplyr)
# read data
data=read.csv("./ans/withoutSinleWord.csv")
data=data[-1]
# 词频
wdcount=count(data,word,sort = TRUE)
# tf-idf
namewdcount=count(data,name,word,sort = TRUE)
tfidf_data=bind_tf_idf(namewdcount,word,name,n)
# 保存
write.csv(wdcount,"./ans/wdcount.csv")
write.csv(tfidf_data,"./ans/tfidf.csv")
