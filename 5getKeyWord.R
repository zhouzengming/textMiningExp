# init
rm(list = ls());gc();
setwd("/media/zzm/3AAD22D845A051D1/textmining")
# load data
data=read.csv("./ans/tfidf.csv")
data=data[-1]
library(tidytext)
library(dplyr)
library(htmlwidgets)
library(webshot2)
# webshot::install_phantomjs()
top5=top_n(group_by(data,name),5,tf_idf)
top5tfidf=arrange(top5,desc(tf_idf),.by_group = TRUE)
write.csv(top5tfidf,"./ans/top5tfidf.csv")
library(wordcloud2)
# 保存词云为PNG格式
tmp <- tempfile(fileext = ".html")  # 创建临时HTML文件
ungroup(top5tfidf)%>%count(word)%>%top_n(200)%>%wordcloud2(size=2,fontFamily="微软雅黑",color="random-light",backgroundColor="grey") %>%
  saveWidget(tmp, selfcontained = TRUE)  # 保存词云为HTML文件
webshot2::webshot(tmp, "./ans/wordCloud.png",delay = 10)  # 将HTML文件转换为PNG格式

# 删除临时文件
file.remove(tmp)
