# init
rm(list = ls());gc();
setwd("/media/zzm/3AAD22D845A051D1/textmining")
data=read.csv("./ans/otpdpr.csv")
data=data[-1]
outdata=NA
# for(i in 1:length(data$id)){
#   print(i)
#   # 保留多个汉字
#   if(!grepl("^[\u4e00-\u9fa5]{2,}$",data$word[i])){
#     next
#   }
#   id=data$id[i]
#   name=data$name[i]
#   word=data$word[i]
#   tmp=data.frame(id,name,word)
#   if(all(is.na(outdata))){
#     outdata=tmp
#   }else{
#     outdata=rbind(outdata,tmp)
#   }
# }
outdata=data %>% filter(grepl("^[\u4e00-\u9fa5]{2,}$",word))
write.csv(outdata,"./ans/withoutSinleWord.csv")
