# init
rm(list = ls());gc();
setwd("/media/zzm/3AAD22D845A051D1/textmining")
# read data
wd_count=read.csv('./ans/lda_classfication.csv')[-1]
library(ggplot2)
library(caret)
library(dplyr)


X=c("物理系","数学与统计学系","化学系")
fac=data.frame(X)
fac$fac=c(2,3,1)
wd_count=inner_join(wd_count,fac,by="X")
a=confusionMatrix(factor(wd_count$topic),
                factor(wd_count$fac))
b=a$table
color=colorRampPalette(c("white", "red"))(256)
library(pheatmap)
ans=pheatmap(b,
         cluster_rows = FALSE,cluster_cols = FALSE,scale='none',
         col=color,
         labels_row = c("实际化学系","实际物理系","实际数学系"),
         labels_col = c("预测化学系","预测物理系","预测数学系"),
         display_numbers=TRUE)
png("./ans/confusionMatrix.png", width = 7, height = 7,units = "in", res = 500)
print(ans)
dev.off()
