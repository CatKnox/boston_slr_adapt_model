#Load required libraries
library(rpart) #CART
library(rpart.plot) #plot CART
library(dplyr)
library(magrittr)

#Set path (this should be changed for your local machine)

setwd("C:/Users/cknox/OneDrive/Documents/slr_sims_cornell/box_files_jan_exp_set")

#Load CSV of metrics data
#do this for each of the following files with cut-offs in order of 90 91 89 10 11 9:
  #high_low_gini.csv(0.843258,0.845179,0.839783,0.602588,0.606413,0.598483)
  #high_high_gini.csv (0.824411,0.827079,0.819482,0.655592,0.656538,0.652950)
  #low_high_gini.csv (0.882877,0.885705,0.88073,0.697948, 0.700654,0.697505)
  #low_low_gini.csv (0.859527,0.862259, 0.858007, 0.645063, 0.647219, 0.643323)
  #nc_gini.csv (0.865141, 0.866528, 0.863464, 0.684500, 0.688423, 0.679074)
  #ra_gini.csv (0.894734,0.895428,0.893595,0.745895,0.749076,0.7311003848572436)
  #vc_gini.csv (0.869672, 0.871006, 0.868543, 0.703024, 0.707206, 0.698416)
  #low_low_adapt_coord.csv (0.855326, 0.857017,0.854698,0.626094,0.629114,0.624726)
  #low_high_adapt_coord.csv (0.862212, 0.862837,0.861372,0.669742, 0.672957, 0.663726)
  #high_low_adapt_coord.csv (0.804239, 0.807085,0.794211,0.574688,0.579940,0.568295)
  #high_high_adapt_coord.csv (0.796802,0.801372, 0.792712,0.626106, 0.628114, 0.622525)
  #ra_adapt_coord.csv(0.894735,0.895428, 0.893595, 0.745895, 0.749076, 0.731100)
  #nc_adapt_coord.csv (0.865141,0.866528,0.863464,0.684450,0.688423,0.6790739)
  #vc_adapt_coord.csv (0.869672, 0.871006,0.868543,0.7030236,0.707206,0.698416)
  )
df_filt <- read.csv(file = 'vc_adapt_coord.csv')
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


#use below for gini
df_filt$costs_bin <- ifelse(df_filt$gini <= 0.7030236, "Low", "High")

colnames(df_filt)
df_class <- subset(df_filt, select = c("Adaptation.Coordination","Sea.Level.Rise", "discount", "Agents..Perceived.Sea.Level.Rise.Projection","external.financing.percent","planning.horizon.delay", "permitting.delay", "reduction.funding.access", "permitting.cost.proportion", "maintenance.fee", "costs_bin"))



fit_class <- rpart(costs_bin ~ .,
                   method="class", data=df_class,control=c(maxdepth = 6, minsplit = 2), cp=.000001)

#plot classification tree
rpart.plot(fit_class, type = 1, box.palette = "OrBu", branch.lty=3, shadow.col = "gray", nn =FALSE, extra = 101)


#see if we can get anova work to work
summary(fit_class)

