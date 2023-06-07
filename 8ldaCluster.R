# init
rm(list = ls());gc();
setwd("/media/zzm/3AAD22D845A051D1/textmining")
# read data
data=read.csv('./ans/ans.csv')
# 过滤党政管理教师
library(stringr)
library(dplyr)
library(tidyr)
library(tidytext)
data=filter(data,!grepl("党政管理",data$tdetail))
# reshape
text_df=tibble(id=data$X,name=data$tname,text=data$tdetail)
# 一元词频
otpdpr=unnest_tokens(text_df,word,text)
data=otpdpr
outdata=filter(data,grepl("^[\u4e00-\u9fa5]{1,}$",data$word))
sing_wdcount=count(outdata,word,sort = TRUE)
# 停用词表 （一元词频 > 165）
my_stopwords=filter(sing_wdcount, n>165)[-2]
# 去除停用词
`%!in%` <- Negate(`%in%`)
data=outdata %>% filter(word %!in% my_stopwords$word)
# 计数
wd_count=data %>% count(name,word,sort=TRUE)
# 转为dtm
person_dtm=wd_count %>% cast_dtm(name,word,n)
library(topicmodels)
lda_ans=LDA(person_dtm,k=3,control=list(seed=2023))
# 读取词概率
topic_term=tidy(lda_ans,matrix="beta")
# 主题下频率最高5词
top_terms=topic_term %>% group_by(topic) %>% 
  top_n(10,beta) %>%
  ungroup() %>%
  arrange(topic,-beta)
# 可视化
library(ggplot2)
print(top_terms %>% mutate(term = reorder(term, beta)) %>%
  ggplot(aes(term,beta,fill=factor(topic)))+
  geom_col(show.legend=FALSE)+
  facet_wrap(~topic,scales="free")+
  coord_flip())
ggsave(paste("./ans/","lda_cluster.png",sep = ""),
       width = 9,
       height = 4,
       units = "in",
       dpi = 500)
# save
write.csv(wd_count,"./ans/person_wd_count.csv")