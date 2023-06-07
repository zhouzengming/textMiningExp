# init
rm(list = ls());gc();
setwd("/media/zzm/3AAD22D845A051D1/textmining")
# read data
wd_count=read.csv('./ans/person_wd_count.csv')
library(topicmodels)
library(dplyr)
library(tidyr)
library(tidytext)
library(ggplot2)
# 转为dtm
person_dtm=wd_count %>% cast_dtm(name,word,n)
lda_ans=LDA(person_dtm,k=3,control=list(seed=2023))
# 标记学院 1-26,27-83,84-174
faculty=c("物理系","数学与统计学系","化学系")
data=read.csv('./ans/ans.csv')
for (i in 1:length(data$tname)) {
  if (i<27) {
    data$X[i]=faculty[1]
  }else if (i < 84) {
    data$X[i]=faculty[2]
  }else{
    data$X[i]=faculty[3]
  }
}
# 查看lda分类结果
lda_gamma=tidy(lda_ans,matrix="gamma")
# 添加学院
lda_gamma=dplyr::rename(lda_gamma, tname = document)
joined=inner_join(lda_gamma,data,by='tname')
# 绘制箱线图
print(joined %>% mutate(title=reorder(X,gamma*topic)) %>%
  ggplot(aes(factor(topic),gamma)) +
  geom_boxplot() +
  facet_wrap(~title))
ggsave(paste("./ans/","lda_boxplot.png",sep = ""),
       width = 5,
       height = 4,
       units = "in",
       dpi = 500)
# 分类结果
classification=joined %>% group_by(X,tname) %>%
  top_n(1,gamma) %>%
  ungroup()
classification=select(classification,-c(url,tdetail))
write.csv(classification,"./ans/lda_classfication.csv")
