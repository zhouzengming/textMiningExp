# init
rm(list = ls());gc();
setwd("/media/zzm/3AAD22D845A051D1/textmining")
library(rvest)
library(stringr)
urlbase="http://lxy.hzau.edu.cn/szll/"
page="jsml.htm"
url=paste(urlbase,page,sep="")
html=read_html(url)
tlist=html_nodes(html,"td a")     # 教师元素列表
teachers=html_text(tlist)         # 教师名称列表
tinfo=html_attrs(tlist)           # 教师信息列表
# 对于每个教师
# tname=""
# tdetail=""
# datas=data.frame(tname,tdetail)
datas=NA
for(i in 1:length(teachers)){
  print(i)
  # 构造url
  if(!is.na(str_extract(tinfo[[i]][2],"^http"))){
    # 新版教师页面
    url=paste("",tinfo[[i]][2],sep="")
  }else{
    # 旧版教师页面
    url=paste(urlbase,tinfo[[i]][2],sep="")
  }
  print(url)
  # 获取教师页面
  html=read_html(url)
  # 获取教师信息
  tdetails=read_html(url)%>%html_nodes('p')%>%html_text()
  tdetail=""
  for(j in 1:length(tdetails)){
    tdetail=paste(tdetail,gsub('[\r|\n]','',tdetails[j]),sep="")
  }
  tdetail=gsub('\xc2\xa0','\x20',tdetail)
  tdetail=gsub('\\s{2,}','',tdetail)
  # tdetail=gsub('\xc2\xa0','',tdetail)
  # 姓名
  tname=teachers[i]
  # 保存教师信息
  # print(tdetail)
  newdata=data.frame(tname,url,tdetail)
  if(all(is.na(datas))){
    datas=newdata
  }else{
    datas=rbind(datas,newdata)
  }
}
write.csv(datas,file="./ans1.csv")
