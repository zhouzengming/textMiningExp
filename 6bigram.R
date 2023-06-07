# init
rm(list = ls());gc();
setwd("/media/zzm/3AAD22D845A051D1/textmining")
# read data
data=read.csv('./ans/ans.csv')
library(tidytext)
library(dplyr)
library(htmlwidgets)
library(webshot2)
# bi-gram
text_df=tibble(id=data$X,name=data$tname,text=data$tdetail)
otpdpr=unnest_tokens(text_df,word,text,token="ngrams",n=2)
write.csv(otpdpr,"./ans/bi_otpdpr.csv")
# 仅保留两边均为汉字的
data=otpdpr
outdata=filter(data,grepl("^[\u4e00-\u9fa5]{2,} [\u4e00-\u9fa5]{2,}$",data$word))
write.csv(outdata,"./ans/bi_withoutMiniless.csv")
# 词频
bi_wdcount=count(outdata,word,sort = TRUE)
write.csv(bi_wdcount,"./ans/bi_wdcount.csv")
# tf-idf
bi_namewdcount=count(outdata,name,word,sort = TRUE)
bi_tfidf_data=bind_tf_idf(bi_namewdcount,word,name,n)
write.csv(bi_tfidf_data,"./ans/bi_tfidf.csv")
# top5 tf-idf
bi_top5=top_n(group_by(bi_tfidf_data,name),5,tf_idf)
bi_top5tfidf=arrange(bi_top5,desc(tf_idf),.by_group = TRUE)
write.csv(bi_top5tfidf,"./ans/bi_top5tfidf.csv")
library(wordcloud2)
tmp <- tempfile(fileext = ".html")  # 创建临时HTML文件
ungroup(bi_top5tfidf)%>%count(word)%>%top_n(200)%>%wordcloud2(size=2,fontFamily="微软雅黑",color="random-light",backgroundColor="grey") %>%
  saveWidget(tmp, selfcontained = TRUE)  # 保存词云为HTML文件
webshot2::webshot(tmp, "./ans/bi_wordCloud.png",delay = 10)  # 将HTML文件转换为PNG格式
# 删除临时文件
file.remove(tmp)


