###### mrging all the files ######
files<-list.files('./fixed_data_sets')
for(file in files) {assign(file,read.csv(paste0('./fixed_data_sets/',file),sep=','))}
GSE123993_data.txt<-read.csv('./fixed_data_sets/GSE123993_data.txt',sep='\t')
GSE117525_data.txt<-read.csv('./fixed_data_sets/GSE117525_data.txt',sep='\t')
