# init
rm(list = ls());gc();
setwd("/media/zzm/3AAD22D845A051D1/textmining")
# read data
data=read.csv('./ans/ans.csv')
# dataframe
library(dplyr)
library(tidytext)
library(tidyr)
library(igraph)
library(ggraph)
# reshape
text_df=tibble(id=data$X,name=data$tname,text=data$tdetail)
# 一元词频
otpdpr=unnest_tokens(text_df,word,text)
data=otpdpr
outdata=filter(data,grepl("^[\u4e00-\u9fa5]{1,}$",data$word))
sing_wdcount=count(outdata,word,sort = TRUE)
# 停用词表 （一元词频 > 170）
my_stopwords=filter(sing_wdcount, n>170)[-2]
# 二元词表
otpdpr=unnest_tokens(text_df,word,text,token="ngrams",n=2)
# 仅保留两边均为汉字的
data=otpdpr
outdata=filter(data,grepl("^[\u4e00-\u9fa5]{1,} [\u4e00-\u9fa5]{1,}$",data$word))
bi_wdcount=separate(outdata,word,c("word1","word2"),sep = " ")
# 去除停用词
`%!in%` <- Negate(`%in%`)
bi_wdcount=bi_wdcount %>% filter(word1 %!in% my_stopwords$word) %>% filter(word2 %!in% my_stopwords$word)
# 循环三个老师
iterteachers=c(1,136,137)
for (i in iterteachers) {
  tdata=bi_wdcount %>% filter(id == i) %>% count(word1,word2) %>% filter(n > 1)
  tname=bi_wdcount %>% filter(id == i)
  tname=tname$name[1]
  set.seed(2023)
  a=grid::arrow(type="closed",length=unit(0.15,"inches"))
  graphdata=graph_from_data_frame(tdata)
  ggraph(graphdata,layout="fr")+
    geom_edge_link(aes(edge_alpha=n),show.legend=FALSE,arrow=a,end_cap=circle(.07,'inches'))+
    geom_node_point(color="lightblue",size=5)+
    geom_node_text(aes(label=name),vjust=1,hjust=1)+
    ggtitle(tname)+
    theme_void()
  ggsave(paste("./ans/",tname,".png",sep = ""),
         width = 6,
         height = 5,
         units = "in",
         dpi = 500)
}


