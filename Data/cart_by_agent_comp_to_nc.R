#Running this code produces a classification tree for the desired metric

#Load required libraries
library(rpart) #CART
library(rpart.plot) #plot CART
library(dplyr)
library(magrittr)
setwd("C:/Users/cknox/OneDrive/Documents/slr_sims_cornell/box_files_jan_exp_set")

#Load CSV of metrics data
df_filt <- read.csv(file = 'agent_damages_comp_to_nc.csv')
colnames(df_filt)


#make sure that the parameters are categorical variables!
df_filt$Adaptation.Coordination=as.factor(df_filt$Adaptation.Coordination)
df_filt$Sea.Level.Rise=as.factor(df_filt$Sea.Level.Rise)
df_filt$Agents..Perceived.Sea.Level.Rise.Projection=as.factor(df_filt$Agents..Perceived.Sea.Level.Rise.Projection)
df_filt$discount=as.factor(df_filt$discount)
df_filt$external.financing.percent=as.factor(df_filt$external.financing.percent)
df_filt$planning.horizon.delay=as.factor(df_filt$planning.horizon.delay)
df_filt$permitting.delay=as.factor(df_filt$permitting.delay)

df_filt$reduction.funding.access=as.factor(df_filt$reduction.funding.access)
df_filt$maintenance.fee=as.factor(df_filt$maintenance.fee)
df_filt$permitting.cost.proportion=as.factor(df_filt$permitting.cost.proportion)


#use below for Comparison with damages to NC- sub out for any agent type
df_filt$costs_bin <- ifelse(df_filt$MBTA.cumulative.damage.comp <= 0, "Low", "High")


colnames(df_filt)
df_class <- subset(df_filt, select = c("Adaptation.Coordination","Sea.Level.Rise","Agents..Perceived.Sea.Level.Rise.Projection","discount","external.financing.percent","planning.horizon.delay", "permitting.delay", "reduction.funding.access", "permitting.cost.proportion", "maintenance.fee", "costs_bin"))


fit_class <- rpart(costs_bin ~ .,
                   method="class", data=df_class,control=c(maxdepth = 6, minsplit = 2), cp=.000001)

#plot classification tree
rpart.plot(fit_class, type = 1, box.palette = "OrBu", branch.lty=3, shadow.col = "gray", nn =FALSE, extra = 101)


#see if we can get anova work to work
summary(fit_class)
