# init
rm(list = ls());gc();
setwd("/media/zzm/3AAD22D845A051D1/textmining")
# read data
data=read.csv('./ans/ans.csv')
# dataframe
library(dplyr)
library(tidytext)
text_df=tibble(id=data$X,name=data$tname,text=data$tdetail)
otpdpr=unnest_tokens(text_df,word,text)
write.csv(otpdpr,"./ans/otpdpr.csv")
