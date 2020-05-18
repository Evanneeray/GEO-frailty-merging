rm(list=ls())

BiocManager::install('affy')
library(affy)
BiocManager::install('oligo')
library(oligo)
BiocManager::install('GEOquery')
library(GEOquery)
library(tidyverse)
library(readxl)

#list of all the GSEs we decided to include that use Affymetrix platform
GSE_affy <- read_excel('~/Research-R-drive/CardiacSurgeryRes/mw299/GEO_datasets/Frailty/GEO summary table.xlsx') %>% 
  filter(str_detect(`Platform type`,'Affymetrix')) %>% 
  pull(GSE)

#downloading GSEs and un-taring them
for (gse in GSE_affy){
  getGEOSuppFiles(gse)
  untar(paste0(gse,'/',gse,'_RAW.tar'), exdir = paste0(gse,'GSM_files'))
}

#Un-zipping individual GSM files to get CEL files
files_A <- list.files('GSE117525GSM_files')
dir.create('./GSE117525_CEL_files')
for (file in files_A){
  gunzip(paste0('./GSE117525GSM_files/', file), destname = paste0('./GSE117525_CEL_files/', str_sub(file, 1, -4)),overwrite = FALSE,remove =FALSE)
}

files_B <- list.files('GSE123993GSM_files')
dir.create('./GSE123993_CEL_files')
for (file in files_B){
  gunzip(paste0('./GSE123993GSM_files/', file), destname = paste0('./GSE123993_CEL_files/', str_sub(file, 1, -4)),overwrite = FALSE,remove =FALSE)
}

#extracting the raw data from GSM CEL files with 'oligo' package
celFiles_A <- list.celfiles('./GSE117525_CEL_files', full.names=TRUE)
rawData_A <- read.celfiles(celFiles_A)

celFiles_B <- list.celfiles('./GSE123993_CEL_files', full.names=TRUE)
rawData_B <- read.celfiles(celFiles_B)

#using 'affy' package for Background correcting and Calculating Expression
eset_A <- rma(rawData_A, normalize=FALSE)
write.exprs(eset_A, file = 'GSE117525_data.txt')

eset_B <- rma(rawData_B, normalise=FALSE)
write.exprs(eset_B, file = 'GSE123993_data.txt')


