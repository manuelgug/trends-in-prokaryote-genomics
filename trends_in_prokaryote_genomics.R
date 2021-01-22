
install.packages(c("stringr,ggplot2,tidyr,tidyverse,data.table"))

library(stringr)
library(ggplot2)
library(tidyr)
library(tidyverse)
library(data.table)

#Data gathering----

#download data on all sequenced bacterial genomes from ncbi
dat<-fread("ftp://ftp.ncbi.nlm.nih.gov/genomes/GENOME_REPORTS/prokaryotes.txt", 
                    header =T, sep="\t", quote = "", 
                    stringsAsFactors = FALSE, colClasses=c(NA, rep("NULL", 12), NA, rep("NULL", 9)))

#Dada formatting----

dat<-as.data.frame(dat)

#leave only year
dat$year<-str_replace_all(dat[,2], "/.*", "")
dat<-dat[,-2]

#leave only genera 
dat$genera<-str_replace_all(dat[,1], " .*", "")
dat<-dat[,-1]
dat$genera<-str_replace_all(dat[,2], "\\[", "")
dat$genera<-str_replace_all(dat[,2], "\\]", "")

#remove families and orders 
dat<-dat[- grep("*ales$",dat$genera),]
dat<-dat[- grep("*aceae$",dat$genera),]

#create input for ggplot2
unique_genera<-unique(dat$genera) 
all_genera<-as.data.frame(c(NA))

#loop takes about 5 minutes to run on a 8GB RAM laptop
for (i in 1:length(unique_genera)) {
  kkk<-dat[grepl(unique_genera[i], (dat[,2])), ]
  df.i<-aggregate(data.frame(genomes = kkk$year), list(year = kkk$year), length)
  colnames(df.i)[2]<-c(unique_genera[i])
  all_genera<-merge(all_genera, df.i, all = TRUE)
}
all_genera<-all_genera[,-2]
dim(all_genera)

df <- all_genera %>%
  select(c(colnames(all_genera)[1:length(unique(dat$genera))])) %>%
  gather(key = "variable", value = "value", -year)

#convert NAs a 0
df[is.na(df)]<-0
#convert year column to numeric
df$year<-as.numeric(df$year)
#list unique years
anos<-unique(df$year)

#Function----
#First argument is a string with names of genera separated by "|". Regular expresions can be used
#Second argument is an integer to indicate color jumps for better visualization

genomic_trends<-function(GENEROS,color_jumps){
  #subset data
  df_sub<-df[grep(GENEROS,df$variable),]
  #plot
  ggplot(df_sub, aes(x = year, y = value)) + 
    geom_line(aes(colour = variable, group = variable), lwd=2)+
    labs(fill = "Genera", x = "Year", y = "Genomes uploaded to NCBI", color = "Genera")+
    theme(axis.text.x = element_text(angle = 45, vjust = 0.5))+
    scale_x_continuous("Year", labels = as.character(anos), breaks = anos)+
    scale_color_manual(values = c(colorRamps::primary.colors(length(unique(df_sub$variable)),color_jumps, T)))+
    guides(fill=guide_legend(ncol=2))
}


#Examples----

#important human pathogens
genomic_trends("Pseudomonas|Vibrio|Escherichia|Campylobacter|Salmonella|Brucella", 2)

#environmental bacteria
genomic_trends("Shewanella|Aeromonas|Halomonas|Streptomyces",5)

#uncultured prokaryotes vs Escherichia
genomic_trends("uncultured|Escherichia", 4)

#some archaea
genomic_trends("Methanosarcina|Ignicoccus|Pyrococcus|Sulfolobus", 2)

#halo-something prokaryotes
genomic_trends("Halo*", 4)
