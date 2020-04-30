#Perennials GHGs 2.1 - basic R console
#autor: Alicia Ledo, alicialedo@gmail.com
#date: 23 April 2020

#bugs corrected in v.2#####
#decomposition was double accounting, now is ok. splitting into years is an arficial to have the sum values
#trees dying during the period was not ok

#thanks to Tobias and Annete for reporting bugs

##############################

#CONTENTS $ IBM inputs: in separate .R file, with details
#Need to first run in this order
    #1) "IBM case example inputs.R" with some dummy inputs (but realistic-ish)
    #2) "IBM crop parameters" the parametrization of every crop



############################
# Perennial-GHG model
############################


## Selecting the suitable submodel -Depending on the crop, the Individual Based Sub-Model (IBM) or the Area Based Sub-Model (ABM) will be used.

if (crop == "apple"){submodel="IBM"}
if (crop == "citrus"){submodel="IBM"}
if (crop == "cocoa"){submodel="IBM"}
if (crop == "coffee"){submodel="IBM"}
if (crop == "tea"){submodel="IBM"}
if (crop == "vinewine"){submodel="IBM"}
if (crop == "otherwood"){submodel="IBM"}

if (crop == "miscanthus"){submodel="ABM"}
if (crop == "sugarcane"){submodel="ABM"}
if (crop == "switchgrass"){submodel="ABM"}


###############################
#1. INTERNAL PARAMETERS
###############################

#1.0 CLIMATE CHANGE PARMETERS
#Select GWP values:"IPCC2001" or "Myhre2013" - Detail in the manuscript
if(GWP=="IPCC2001"){(GWPCH4<-25) & (GWPN2O<-298)} else if (GWP=="Myhre2013"){(GWPCH4<-34) & (GWPN2O<-298)}


#1.2 MODEL INTERNAL PARAMETERS for the IBM - *By defaul* values
if(submodel=="IBM"){
  #pruning values
  PrunP=10
  PrunP_start=5 #year of starting
  
  #percentage of discarded fruit
  Perbad=15
  
  #Decomposition parameters (left in the ground, decomposition in the soil)
  k_chip=0.3 
  k_litter=0.65
  k_fruit=0.65  
  k_root=0.51
}


##FOR A INTEGRATED VERSION, CROP PARAMETERS SHOULD BE HERE-SEPARATE FILE NOW



if(submodel=="IBM"){
  
##Store data and results
#Biomass
  indbio<-matrix(0, ncol=10, nrow=Nyear)
  colnames(indbio)<-c("year","AGB","woodyAGB","pruning","actualWAGB","BGB","leaves","fruit","fruitPulp","seed")
  indbio[,1]<-c(1:Nyear)
  indbio<-as.data.frame(indbio)
#Carbon
  indC<-matrix(0, ncol=10, nrow=Nyear)
  colnames(indC)<-c("year","AGB","woodyAGB","pruning","actualWAGB","BGB","leaves","fruit","fruitPulp","seed")
  indC[,1]<-c(1:Nyear)
  indC<-as.data.frame(indC)
#Nitrogen
  indN<-matrix(0, ncol=10, nrow=Nyear)
  colnames(indN)<-c("year","AGB","woodyAGB","pruning","actualWAGB","BGB","leaves","fruit","fruitPulp","seed")
  indN[,1]<-c(1:Nyear)
  indN<-as.data.frame(indN)
  
  
  
#Functions
############
  
#AGB model as a function of age  (kg per individual per year, cummulative)
  AGBmodel<-function(Nyear){AGBcoefa*wRf*nRf*Nyear^(AGBcoefb)}
  indbio[,2]<-AGBmodel(1:Nyear)
  indC[,2]<-AGBmodel(1:Nyear)#*CVAL  ## will be rewritten later, section 3.6
  indN[,2]<-AGBmodel(1:Nyear)#*NVAL ##  will be rewritten later, section 3.6
  
#AGB model of woody parts: branches and trunk  (kg per individual per year, cummulative)
  AGBWmodel<-function(Nyear){AGBWcoefa*wRf*nRf*Nyear^(AGBWcoefb)}
  indbio[,3]<-AGBWmodel(1:Nyear)
  indC[,3]<-AGBWmodel(1:Nyear)*Cwood
  indN[,3]<-AGBWmodel(1:Nyear)*Nwood
  
  
  
#Pruning  - (kg per individual per year, cummulative)
  
  if (pruning=="YES"){       
    
    if (pruning_farm_values=="YES"){ #check pruning values are not be greater than woodyAGB   
      if(pruning_weight=="YES"){
        Pruntree_year<-(Pruntha*1000/Nind)*drymatterwood   #kg per tree biomass
        check<-indbio[,3]-Pruntree_year
        if(sum(check<0)>=1){print("ERROR. Pruning values too high")}
        else {print("valid pruning values")}
      }
    }  ###PROGRAM SHOULD STOP HERE IF CONDITION DO NOT MET##
    
  
  if (pruning_weight=="YES"){   
      Pruntree_year<-(Pruntha*1000/Nind)*drymatterwood   #kg per tree biomass   
      #cummulative values
      Pruntree<-Pruntree_year
      sumv= Pruntree[1]
      for (i in 1:Nyear){
        sumv= Pruntree[i]+sumv
        Pruntree[i]<-sumv
      }
      indbio[,4]<-Pruntree
      indC[,4]<-Pruntree*Cwood
      indN[,4]<-Pruntree*Nwood
    } 
    
    if(pruning_perc=="YES"){
      Pruntree_year<-(PrunPer/100)*indbio[,3]   
      #cummulative values
      Pruntree<-Pruntree_year
      sumv= Pruntree[1]
      for (i in 1:Nyear){
        sumv= Pruntree[i]+sumv
        Pruntree[i]<-sumv
      }
      indbio[,4]<-Pruntree
      indC[,4]<-Pruntree*Cwood
      indN[,4]<-Pruntree*Nwood
    }
    
    
    
    if (pruning_farm_values=="NO") { 
      Pruntree_year<-c(indbio[,3]*(PrunP/100))
      Pruntree_year<-Pruntree_year[-Nyear] #last year values
      Pruntree_year<-c(0,Pruntree_year)
      Pruntree_year[0:(PrunP_start-1)]<-0
      
      #cummulative values
      Pruntree<-Pruntree_year
      sumv= Pruntree[1]
      #for (i in 1:Nyear){
      for (i in PrunP_start:Nyear){
        sumv= Pruntree[i]+sumv
        Pruntree[i]<-sumv
      }
      
      indbio[,4]<-Pruntree
      indC[,4]<-Pruntree*Cwood
      indN[,4]<-Pruntree*Nwood
    }
    
  }
  
  
# Actual woody AGB  (wood - pruning) -kg per individual per year

  
  if (pruning_farm_values=="YES"){
    
    indbio[,5]<-indbio[,3]-Pruntree_year
    indC[,5]<-indC[,3]-Pruntree_year*Cwood
    indN[,5]<-indN[,3]-Pruntree_year*Nwood
  } else {
    indbio[,5]<-indbio[,3]-Prunest_year
    indC[,5]<-indC[,3]-Prunest_year*Cwood
    indN[,5]<-indN[,3]-Prunest_year*Nwood
  }
  
  

# BGB model as a function of age  (kg per tree per year, cummulative)
# it is independent to account for grafting and cases where the AGB is replaced but roots no  
  BGBmodel<-function(Nyear){(BGBcoefa*wRf*nRf*Nyear^(BGBcoefb))}
  BGBaux<-BGBmodel(1:Nyear)
  
  # fine root - scientific values
  fineroot<-((2.73*BGBaux^(-0.841))/100)*BGBaux   
  indbio[,6]<-BGBmodel(1:Nyear)
  indC[,6]<-BGBmodel(1:Nyear)*Croot  
  indN[,6]<-BGBmodel(1:Nyear)*Nroot 
  
  
  

#Leaves model as a function of woody AGB   (kg per tree per year, cummulative)
  
  if (deciduous=="YES"){
    LEAFmodel<-function(agb){LEAFcoefa*agb^(LEAFcoefb)}
    leaves_year<-c(LEAFmodel(indbio[,5]))
    #cummulative values
    leaves<-leaves_year
    sum= leaves[1]
    for (i in 1:Nyear){
      sum= leaves[i]+sum
      leaves[i]<-sum
    }
    indbio[,7]<-leaves
    indC[,7]<-leaves*Cleaf
    indN[,7]<-leaves*Nleaf
  }else{
    
    
    #perennial species
    LEAFmodel<-function(agb){LEAFcoefa*agb^(LEAFcoefb)}
    leaves_year<-c(LEAFmodel(indbio[,5]))
    #cummulative values
    leaves<-leaves_year
    for (i in leaflife:Nyear){
      leaves[i]<-leaves_year[i]+leaves_year[i]/3
    }
    indbio[,7]<-leaves
    indC[,7]<-leaves*Cleaf
    indN[,7]<-leaves*Nleaf
  }
  
  
#now C and N in AGB can be calculated - simbolic, AGB we don´t use it
indC[,2]<-indC[,3]+indC[,7]
indN[,2]<-indN[,3]+indN[,7]
  

# Yield   - (kg per tree per year, cummulative)

yieldbio_year<- (yieldyear*1000/Nind)*drymatterfruit  ## all yield is fruit
#this transforms to individual values and dry biomass

#cummulative values
yieldbio<-yieldbio_year
sum= yieldbio_year[1]
for (i in 2:Nyear){
  sum= yieldbio_year[i]+sum
  yieldbio[i]<-sum
}


###FRUIT VALUES - this will be neccesary to have the values of CO2 per kg yield

if (PartFruitYield=="All"){
  indbio[,8]<-yieldbio*(1+(Perbad/100))  #removes the percentage that is not good  
  indC[,8]<-yieldbio*(1+(Perbad/100))*Cfruit
  indN[,8]<-yieldbio*(1+(Perbad/100))*Nfruit
}


if (PartFruitYield=="None"){ } #nothing, we have no information about fuits in this case

if (PartFruitYield=="Seed"){
  
  indbio[,10]<-yieldbio*(1+(Perbad/100))     
  indC[,10]<-yieldbio*(1+(Perbad/100))*Cfruit
  indN[,10]<-yieldbio*(1+(Perbad/100))*Nfruit
  
  indbio[,8]<-yieldbio*(1+(Perbad/100))/Pseed     
  indC[,8]<-yieldbio*(1+(Perbad/100))*Cfruit/Pseed
  indN[,8]<-yieldbio*(1+(Perbad/100))*Nfruit/Pseed
  
  indbio[,9]<-indbio[,8]-indbio[,10] 
  indC[,9]<-indC[,8]-indC[,10]
  indN[,9]<-indN[,8]-indN[,10]
  
}

if (PartFruitYield=="Pulp"){
  
  indbio[,9]<-yieldbio*(1+(Perbad/100))    
  indC[,9]<-yieldbio*(1+(Perbad/100))*Cfruit
  indN[,9]<-yieldbio*(1+(Perbad/100))*Nfruit
  
  indbio[,8]<-yieldbio*(1+(Perbad/100))/Ppulp    
  indC[,8]<-yieldbio*(1+(Perbad/100))*Cfruit/Ppulp
  indN[,8]<-yieldbio*(1+(Perbad/100))*Nfruit/Ppulp
  
  indbio[,10]<-indbio[,8]-indbio[,9] 
  indC[,10]<-indC[,8]-indC[,9]
  indN[,10]<-indN[,8]-indN[,9]
  
  
}



########################################
#Annual values
########################################

indbio_annual<-indbio
for (i in 2:Nyear){
  indbio_annual[i,2]<-indbio[i,2]-indbio[i-1,2]
  indbio_annual[i,3]<-indbio[i,3]-indbio[i-1,3]
  indbio_annual[i,4]<-indbio[i,4]-indbio[i-1,4]
  indbio_annual[i,5]<-indbio[i,5]-indbio[i-1,5]
  indbio_annual[i,6]<-indbio[i,6]-indbio[i-1,6]
  indbio_annual[i,7]<-indbio[i,7]-indbio[i-1,7]
  indbio_annual[i,8]<-indbio[i,8]-indbio[i-1,8]      
}


indC_annual<-indC
for (i in 2:Nyear){
  indC_annual[i,2]<-indC[i,2]-indC[i-1,2]
  indC_annual[i,3]<-indC[i,3]-indC[i-1,3]
  indC_annual[i,4]<-indC[i,4]-indC[i-1,4]
  indC_annual[i,5]<-indC[i,5]-indC[i-1,5]
  indC_annual[i,6]<-indC[i,6]-indC[i-1,6]
  indC_annual[i,7]<-indC[i,7]-indC[i-1,7]
  indC_annual[i,8]<-indC[i,8]-indC[i-1,8]      
}


indN_annual<-indN
for (i in 2:Nyear){
  indN_annual[i,2]<-indN[i,2]-indN[i-1,2]
  indN_annual[i,3]<-indN[i,3]-indN[i-1,3]
  indN_annual[i,4]<-indN[i,4]-indN[i-1,4]
  indN_annual[i,5]<-indN[i,5]-indN[i-1,5]
  indN_annual[i,6]<-indN[i,6]-indN[i-1,6]
  indN_annual[i,7]<-indN[i,7]-indN[i-1,7]
  indN_annual[i,8]<-indN[i,8]-indN[i-1,8]      
}





######################################################################################
##GHGs calculation  - Kg per tree annual values - warning- no cummulative anymore  
######################################################################################

#Store values - per individual tree values
CO2<-matrix(0, ncol=18, nrow=Nyear)
colnames(CO2)<-c("year","woodaerial","leaves","roots","prun_burn","prun_chipsoil",
                 "prun_comp","litter_burn","litter_soil","litter_comp","fruit_soil","fruit_comp",
                 "pulporseed_soil","pulporseed_comp","EPtree_burn", "EPtree_chip","aux_dead_burn","aux_dead_chip")
CO2[,1]<-c(1:Nyear)
CO2<-as.data.frame(CO2)

N2O<-matrix(0, ncol=18, nrow=Nyear)
colnames(N2O)<-c("year","woodaerial","leaves","roots","prun_burn","prun_chipsoil",
                 "prun_comp","litter_burn","litter_soil","litter_comp","fruit_soil","fruit_comp",
                 "pulporseed_soil","pulporseed_comp","EPtree_burn", "EPtree_chip","aux_dead_burn","aux_dead_chip")
N2O[,1]<-c(1:Nyear)
N2O<-as.data.frame(N2O)

CH4<-matrix(0, ncol=18, nrow=Nyear)
colnames(CH4)<-c("year","woodaerial","leaves","roots","prun_burn","prun_chipsoil",
                 "prun_comp","litter_burn","litter_soil","litter_comp","fruit_soil","fruit_comp",
                 "pulporseed_soil","pulporseed_comp","EPtree_burn", "EPtree_chip","aux_dead_burn","aux_dead_chip")
CH4[,1]<-c(1:Nyear)
CH4<-as.data.frame(CH4)

CO2eq<-matrix(0, ncol=18, nrow=Nyear)
colnames(CO2eq)<-c("year","woodaerial","leaves","roots","prun_burn","prun_chipsoil",
                   "prun_comp","litter_burn","litter_soil","litter_comp","fruit_soil","fruit_comp",
                   "pulporseed_soil","pulporseed_comp","EPtree_burn", "EPtree_chip","aux_dead_burn","aux_dead_chip")
CO2eq[,1]<-c(1:Nyear)
CO2eq<-as.data.frame(CO2eq)



#Plant balance,CO2 accumulation by the plant - via respiration - in Kg per tree per year

if (deciduous=="YES"){
  CO2[,2]<-indC_annual[,5]*44/12*(-1)   #CO2 accumulation in actualAGB annual accumulation
  CO2[,3]<-0                            #CO2 accumulation in leaves- none, deciduos                                                       
  CO2[,4]<-indC_annual[,6]*44/12*(-1)   #CO2 accumulation in roots annual accumulation
} else {  
  CO2[,2]<-indC_annual[,5]*44/12*(-1)    
  CO2[,3]<-indC_annual[,7]*1/3*44/12*(-1)  
  CO2[,4]<-indC_annual[,6]*44/12*(-1)  
}

# Fine root decomposition
#############################
root_remain<-matrix(0, ncol=Nyear+1, nrow=Nyear)
colnames(root_remain)<-c("year",names<-1:Nyear)  
root_remain[,1]<-c(1:Nyear)
root_remain<-as.data.frame(root_remain)
rootaux<-c(1:Nyear) #needs this auxiliar vector

#remaining mass each year
for (j in 1:Nyear){
  for (i in 1:Nyear){
    rootaux[i]<-fineroot[j]*(exp(-1*(k_root)*i))  
    root_j<-c(rep(0,(j-1)),rootaux)
    root_j<-root_j[1:Nyear]
    root_remain[,1+j]<- root_j
  }
}
#annual values
fineroot_remain_annual_CUM<-rowSums(root_remain[2:(Nyear+1)])  
fineroot_remain_annual<-fineroot_remain_annual_CUM
#####################BUG CORRECCTED, THE CHIPPING WAS CUMULATIVE, NOT ANNUAL VALUES
for (i in 2:Nyear){fineroot_remain_annual[i]<-fineroot_remain_annual_CUM[i]-fineroot_remain_annual_CUM[i-1]}

CO2[,4]<-(indC_annual[,6]+(fineroot_remain_annual*Croot))*44/12*(-1) 
#here, it adds the value of the roots that decompose to the remaining roots!!! 


# Residuals from prunning, in Kg per tree per year
####################################################

#check that the 100% of information about residues is here
if ((PERburn_prun+PERchipsoil_prun+PERprun_away+PERchipcom_prun)!=100)
{print("ERROR. Percentage of residues does not equal to 100%")} else {print("inputs pruning residues ok")} 
###PROGRAM SHOULD STOP HERE##

# Residues pruning are burnt
if (burn_prun=="YES"){
  CO2[,5]<- (indbio_annual[,4]*(PERburn_prun/100)*1.509)-(indbio_annual[,4]*(PERburn_prun/100)*Cwood*44/12) #resta lo que hay, para tener solo lo que emite
  #si sale aun negativo, es porque almacena mas que emite- normal, parte sale como metano
  N2O[,5]<- indbio_annual[,4]*(PERburn_prun/100)*0.00038   #NO2 in Kg
  CH4[,5]<- indbio_annual[,4]*(PERburn_prun/100)*0.00568 #methane in Kg    
}

#the residues pruning are chipped  and spread
if (soil_chip_prun=="YES"){
  
  #matrix with each year decomposition
  chip_remain<-matrix(0, ncol=Nyear+1, nrow=Nyear)
  colnames(chip_remain)<-c("year",names<-1:Nyear)  
  chip_remain[,1]<-c(1:Nyear)
  chip_remain<-as.data.frame(chip_remain)
  chipaux<-c(1:Nyear) #needs this auxiliar vector
  
  #remaining mass each year
  for (j in 1:Nyear){
    for (i in 1:Nyear){
      chipaux[i]<-indbio_annual[j,4]*(exp(-1*(k_chip)*i))
      chip_j<-c(rep(0,(j-1)),chipaux)
      chip_j<-chip_j[1:Nyear]
      chip_remain[,1+j]<- chip_j
    }
  }   
  #annual values - decomposition is neutral, the biomass still in the system is capture, negative
  chip_remain_annual_CUMULATIVE<-rowSums(chip_remain[2:(Nyear+1)])  #remaining biomass
  #####################BUG CORRECCTED, THE CHIPPING WAS CUMULATIVE, NOT ANNUAL VALUES
    for (i in 2:Nyear){chip_remain_annual[i]<-chip_remain_annual_CUMULATIVE[i]-chip_remain_annual_CUMULATIVE[i-1]}
  
  CO2[,6]<-chip_remain_annual*Cwood*(PERchipsoil_prun/100)*(-44/12) 
}#else{chip_remain_annual=c(rep(0,Nyear))}


# the residues pruning are chipped and taken
if (prun_away=="YES"){
  #nothing, they are carbon neutral at farm scale
}


# the residues pruning are chipped and composted
if (com_chip_prun=="YES"){
  
  if (open_compost=="YES"){
    CO2[,7]<- ((indbio_annual[,4]*Cwood*(1-(60/100))*-44/12)+
                 (indbio_annual[,4]*drymatterwood*0.25)+(indbio_annual[,4]*drymatterwood*7.965))*(PERchipcom_prun/100) 
    N2O[,7]<- (indbio_annual[,4]*drymatterwood*0.001)*(PERchipcom_prun/100)
    CH4[,7]<- (indbio_annual[,4]*drymatterwood*0.0035)*(PERchipcom_prun/100)
  } 
  
  if(enclosed_comp=="YES") {
    CO2[,7]<- ((indbio_annual[,4]*Cwood*(1-(60/100))*-44/12)
               +(indbio_annual[,4]*drymatterwood*0.3)+(indbio_annual[,4]*drymatterwood*7.965))*(PERchipcom_prun/100)
    N2O[,7]<- (indbio_annual[,4]*drymatterwood*0.00659)*(PERchipcom_prun/100)
    CH4[,7]<- (indbio_annual[,4]*drymatterwood*0.0009)*(PERchipcom_prun/100)
    
  }
  
}



#Litter, in Kg per tree per year

#check - 100% of information about litter is here
if ((PERsoil_litter+PERburn_litter+PERcom_litter)!=100){print("ERROR. Percentage of litter does not equal to 100%")}else{print("litter inputs ok")}
###PROGRAM SHOULD STOP HERE##

#the litter is burnt
if (burn_litter=="YES"){
  CO2[,8]<- (indbio_annual[,7]*(PERburn_litter/100)*1.515)-
    (indbio_annual[,7]*(PERburn_litter/100)*Cleaf*44/12) #CO2 in kg per tree
  N2O[,8]<- indbio_annual[,7]*(PERburn_litter/100)*0.00007 #NO2 in Kg
  CH4[,8]<- indbio_annual[,7]*(PERburn_litter/100)*0.027 #methane in Kg    
} 


# the litter is left on the ground
if (soil_litter=="YES"){
  #matrix with each year decomposition
  litter_remain<-matrix(0, ncol=Nyear+1, nrow=Nyear)
  colnames(litter_remain)<-c("year",names<-1:Nyear) 
  litter_remain[,1]<-c(1:Nyear)
  litter_remain<-as.data.frame(litter_remain)
  litteraux<-c(1:Nyear) #needs this auxiliar vector
  
  #remaining mass each year
  for (j in 1:Nyear){
    for (i in 1:Nyear){
      litteraux[i]<-indbio_annual[j,7]*(exp(-1*(k_litter)*i))
      lit_j<-c(rep(0,(j-1)),litteraux)
      lit_j<-lit_j[1:Nyear]
      litter_remain[,1+j]<- lit_j   
    }
  }   
  
  #annual values
  litter_remain_annual_CUMULATIVE<-rowSums(litter_remain[2:(Nyear+1)])  #remaining biomass  
  #####################BUG CORRECCTED, VALUES WERE CUMULATIVE- SPLITTING IS AN ARTEFACT
  litter_remain_annual<-litter_remain_annual_CUMULATIVE
  for (i in 2:Nyear){litter_remain_annual[i]<-litter_remain_annual_CUMULATIVE[i]-litter_remain_annual_CUMULATIVE[i-1]}
  
  CO2[,9]<-litter_remain_annual*Cleaf*(PERsoil_litter/100*(-44/12))  
}

#litter composted
if (com_litter=="YES"){
  
  if (open_compost=="YES"){
    CO2[,10]<- ((indbio_annual[,7]*Cleaf*(1-(60/100))*-44/12)+
                  (indbio_annual[,7]*drymatterleaf*0.25)+(indbio_annual[,7]*drymatterleaf*7.965))*PERcom_litter/100 
    N2O[,10]<- indbio_annual[,7]*drymatterleaf*PERcom_litter/100*0.001
    CH4[,10]<- indbio_annual[,7]*drymatterleaf*PERcom_litter/100*0.0035
  }
  
  if(enclosed_comp=="YES") {
    CO2[,10]<- ((indbio_annual[,7]*Cleaf*(1-(60/100))*-44/12)+
                  (indbio_annual[,7]*drymatterleaf*0.3)+(indbio_annual[,7]*drymatterleaf*7.965))*PERcom_litter/100 
    N2O[,10]<- indbio_annual[,7]*PERcom_litter/100*drymatterleaf*0.00659
    CH4[,10]<- indbio_annual[,7]*PERcom_litter/100*drymatterleaf*0.0009
    
  }
}




# fruits left on the ground- in Kg per tree per year
if (soil_fruit=="YES"){
  
  fruit_remain<-matrix(0, ncol=Nyear+1, nrow=Nyear)
  colnames(fruit_remain)<-c("year",names<-1:Nyear) 
  fruit_remain[,1]<-c(1:Nyear)
  fruit_remain<-as.data.frame(fruit_remain)
  fruitaux<-c(1:Nyear) 
  
  for (j in 1:Nyear){
    for (i in 1:Nyear){
      fruitaux[i]<-(indbio_annual[j,8]*(Perbad/100))*(exp(-1*(k_fruit)*i))
      fruit_j<-c(rep(0,(j-1)),fruitaux)
      fruit_j<-fruit_j[1:Nyear]
      fruit_remain[,1+j]<- fruit_j   
    }
  }   
  #annual values
  fruit_remain_annual_CUM<-rowSums(fruit_remain[2:(Nyear+1)]) 
  #####################BUG CORRECCTED, THE CHIPPING WAS CUMULATIVE, NOT ANNUAL VALUES
  fruit_remain_annual<-fruit_remain_annual_CUM
  for (i in 2:Nyear){fruit_remain_annual[i]<-fruit_remain_annual_CUM[i]-fruit_remain_annual_CUM[i-1]}
  CO2[,11]<-fruit_remain_annual*Cfruit*(PERsoil_fruit/100*(-44/12)) 
}




if (comp_fruit=="YES"){
  
  if (open_compost=="YES"){
    CO2[,12]<- ((indbio_annual[,8]*(Perbad/100)*Cfruit*(1-(60/100))*-44/12)+
                  (indbio_annual[,8]*(Perbad/100)*drymatterfruit*0.25)+
                  (indbio_annual[,8]*(Perbad/100)*drymatterfruit*7.965))*PERcomp_fruit/100 
    N2O[,12]<- indbio_annual[,8]*(Perbad/100)*PERcomp_fruit/100*drymatterfruit*0.001
    CH4[,12]<- indbio_annual[,8]*(Perbad/100)*PERcomp_fruit/100*drymatterfruit*0.0035
  }  else 
    
    if(enclosed_comp=="YES") {
      CO2[,12]<- ((indbio_annual[,8]*(Perbad/100)*Cfruit*(1-(60/100))*-44/12)+
                    (indbio_annual[,8]*(Perbad/100)*drymatterfruit*0.3)+
                    (indbio_annual[,8]*(Perbad/100)*drymatterfruit*7.965))*PERcomp_fruit/100
      N2O[,12]<- indbio_annual[,8]*(Perbad/100)*PERcomp_fruit/100*drymatterfruit*0.00659
      CH4[,12]<- indbio_annual[,8]*(Perbad/100)*PERcomp_fruit/100*drymatterfruit*0.0009
      
    }
  
}



# Pulp or Seeds - ONLY ONE PART OF THE FRUIT IS USED
if(PartFruitYield!="All")  {
  if ((PERsoil_pulp+PERpulp_away+PERcomp_pulp)!=100){print("ERROR. Percentage of pulp residues does not equal to 100%")}else {print("pulp values ok")}
###PROGRAM SHOULD STOP HERE##
}


  if (soil_pulp=="YES"){
  pulp_remain<-matrix(0, ncol=Nyear+1, nrow=Nyear)
  colnames(pulp_remain)<-c("year",names<-1:Nyear)  
  pulp_remain[,1]<-c(1:Nyear)
  pulp_remain<-as.data.frame(pulp_remain)
  pulpaux<-c(1:Nyear) 
  
  for (j in 1:Nyear){
    for (i in 1:Nyear){
      pulpaux[i]<-indbio_annual[j,9]*(1-(Perbad/100))*Ppulp*(exp(-1*(k_fruit)*i))
      pulp_j<-c(rep(0,(j-1)),pulpaux)
      pulp_j<-pulp_j[1:Nyear]
      pulp_remain[,1+j]<- pulp_j   
    }
  }   
    pulp_remain_annual_CUM<-rowSums(pulp_remain[2:(Nyear+1)]) 
  #####################BUG CORRECCTED, THE CHIPPING WAS CUMULATIVE, NOT ANNUAL VALUES
  pulp_remain_annual<-pulp_remain_annual_CUM
  for (i in 2:Nyear){pulp_remain_annual[i]<-pulp_remain_annual_CUM[i]-pulp_remain_annual_CUM[i-1]}
  CO2[,13]<-pulp_remain_annual*Cfruit*(PERsoil_pulp/100*(-44/12))
  }else{pulp_remain_annual=c(rep(0,Nyear))}


if (comp_pulp=="YES"){      
  if (open_compost=="YES"){
    CO2[,14]<- ((indbio_annual[,9]*(1-(Perbad/100))*Cfruit*(1-(60/100))*-44/12)+
                  (indbio_annual[,9]*(1-(Perbad/100))*drymatterfruit*0.25)+
                  (indbio_annual[,9]*(1-(Perbad/100))*drymatterfruit*7.965))*PERcomp_pulp/100 
    N2O[,14]<- indbio_annual[,9]*(1-(Perbad/100))*PERcomp_pulp/100*drymatterfruit*0.001
    CH4[,14]<- indbio_annual[,9]*(1-(Perbad/100))*PERcomp_pulp/100*drymatterfruit*0.0035
  }  else 
    
    if(enclosed_comp=="YES") {
      CO2[,14]<- (indbio_annual[,9]*(1-(Perbad/100))*Cfruit*(1-(60/100))*-44/12)+
        (indbio_annual[,9]*(1-(Perbad/100))*drymatterfruit*0.3)+
        (indbio_annual[,9]*(1-(Perbad/100))*drymatterfruit*7.965) 
      N2O[,14]<- indbio_annual[,9]*(1-(Perbad/100))*PERcomp_pulp/100*drymatterfruit*0.00659
      CH4[,14]<- indbio_annual[,9]*(1-(Perbad/100))*PERcomp_pulp/100*drymatterfruit*0.0009
      
    }
}


#Seeds
  
if(PartFruitYield!="All")  {

  if ((PERsoil_seed+PERseed_away+PERcomp_seed)!=100)
  {print("ERROR. Percentage of seed residues does not equal to 100%")} else{print("seed residues input ok")}
  ###PROGRAM SHOULD STOP HERE##
}
  
  if (soil_seed=="YES"){
    seed_remain<-matrix(0, ncol=Nyear+1, nrow=Nyear)
    colnames(seed_remain)<-c("year",names<-1:Nyear)  
    seed_remain[,1]<-c(1:Nyear)
    seed_remain<-as.data.frame(seed_remain)
    seedaux<-c(1:Nyear) 
    
    for (j in 1:Nyear){
      for (i in 1:Nyear){
        seedaux[i]<-indbio_annual[j,10]*(1-(Perbad/100))*Pseed*(exp(-1*(k_fruit)*i))
        seed_j<-c(rep(0,(j-1)),seedaux)
        seed_j<-seed_j[1:Nyear]
        seed_remain[,1+j]<- seed_j   
      }
    }   
  
    seed_remain_annual_CUM<-rowSums(seed_remain[2:(Nyear+1)])
    #####################BUG CORRECCTED, THE CHIPPING WAS CUMULATIVE, NOT ANNUAL VALUES
    seed_remain_annual<-pulp_remain_annual_CUM
    for (i in 2:Nyear){seed_remain_annual[i]<-pulp_remain_annual_CUM[i]-pulp_remain_annual_CUM[i-1]}
    CO2[,13]<-seed_remain_annual*Cfruit*(PERsoil_seed/100*(-44/12))  
  }
  
  
  if (comp_seed=="YES"){      
    if (open_compost=="YES"){
      CO2[,14]<- ((indbio_annual[,10]*(1-(Perbad/100))*Cfruit*(1-(60/100))*-44/12)+
                    (indbio_annual[,10]*(1-(Perbad/100))*drymatterfruit*0.25)+
                    (indbio_annual[,10]*(1-(Perbad/100))*drymatterfruit*7.965))*PERcomp_seed/100 
      N2O[,14]<- indbio_annual[,10]*(1-(Perbad/100))*PERcomp_seed/100*drymatterfruit*0.001
      CH4[,14]<- indbio_annual[,10]*(1-(Perbad/100))*PERcomp_seed/100*drymatterfruit*0.0035
    }  else 
      
      if(enclosed_comp=="YES") {
        CO2[,14]<- (indbio_annual[,10]*(1-(Perbad/100))*Cfruit*(1-(60/100))*-44/12)+
          (indbio_annual[,10]*(1-(Perbad/100))*drymatterfruit*0.3)+
          (indbio_annual[,10]*(1-(Perbad/100))*drymatterfruit*7.965) 
        N2O[,14]<- indbio_annual[,10]*(1-(Perbad/100))*PERcomp_seed/100*drymatterfruit*0.00659
        CH4[,14]<- indbio_annual[,10]*(1-(Perbad/100))*PERcomp_seed/100*drymatterfruit*0.0009
        
      }
  }





#End - Residuals from the tree, in Kg per tree per year
###################################################

#check that the 100% of information about residues is here
if ((PERburn_tree+PERchipsoil_tree+PERtree_away)!=100)
{print("ERROR. Percentage of dead trees does not equal to 100%")} else {print("input trees end cycle ok")} 
###PROGRAM SHOULD STOP HERE##

#the residues are burnt
if (burn_tree=="YES"){
  CO2[Nyear,2]<- 0
  CO2[Nyear,15]<- (indbio[Nyear,5]*(PERburn_tree/100)*1.509)-
    (indbio[Nyear,5]*(PERburn_tree/100)*Cwood*44/12) #CO2 in kg per tree
  N2O[Nyear,15]<- indbio[Nyear,5]*(PERburn_tree/100)*0.00038   #NO2 in Kg
  CH4[Nyear,15]<- indbio[Nyear,5]*(PERburn_tree/100)*0.00568 #methane in Kg    
}

# the residues are chipped  
if (soil_chip_tree=="YES"){
  CO2[Nyear,2]<- 0
  CO2[Nyear,16]<-(indbio[Nyear,5]*(exp(-1*(k_chip)*1)))*Cwood*(PERchipsoil_tree/100*(-44/12))   #-only one year!!
}

#the residues are chipped and taken
if (tree_away=="YES"){
  #nothing, they are carbon neutral
}      





#auxiliar dead trees# warning, this is not for a single tree, this is an auxiliar field that will be need

#check that the 100% of information about residues is here
if ((PERburn_dead+PERchipsoil_dead+PERdead_away)!=100)
{print("ERROR. Percentage of dead trees does not equal to 100%")} else{print("input % dead trees ok")}
###PROGRAM SHOULD STOP HERE##


#the residues are burnt
if (burn_dead=="YES"){
  CO2[,17]<- (indbio[,5]*(PNdie/100)*(PERburn_dead/100)*1.509)-
    (indbio[,5]*(PNdie/100)*(PERburn_dead/100)*Cwood*44/12) #CO2 in kg per tree
  N2O[,17]<- indbio[,5]*(PNdie/100)*(PERburn_dead/100)*0.00038   #NO2 in Kg
  CH4[,17]<- indbio[,5]*(PNdie/100)*(PERburn_dead/100)*0.00568 #methane in Kg    
}

#the residues are chipped
if (soil_chip_dead=="YES"){
  
  #matrix with each year decomposition
  dead_remain<-matrix(0, ncol=Nyear+1, nrow=Nyear)
  colnames(dead_remain)<-c("year",names<-1:Nyear)  #change colum names!
  dead_remain[,1]<-c(1:Nyear)
  dead_remain<-as.data.frame(dead_remain)
  deadaux<-c(1:Nyear) #needs this auxiliar vector
  
  #remaining mass each year
  for (j in 1:Nyear){
    for (i in 1:Nyear){
      deadaux[i]<-indbio[j,5]*(PNdie/100)*(exp(-1*(k_chip)*i))  ###
      dead_j<-c(rep(0,(j-1)),deadaux)
      dead_j<-dead_j[1:Nyear]
      dead_remain[,1+j]<- dead_j   
    }
  }   
  #annual values
  dead_remain_annual_CUM<-rowSums(dead_remain[2:(Nyear+1)])  #remaining biomass
  ####################BUG CORRECCTED, THE CHIPPING WAS CUMULATIVE, NOT ANNUAL VALUES
  dead_remain_annual<-dead_remain_annual_CUM
  for (i in 2:Nyear){dead_remain_annual[i]<-dead_remain_annual_CUM[i]-dead_remain_annual_CUM[i-1]}
  CO2[,18]<-dead_remain_annual*Cwood*(PERchipsoil_dead/100*(-44/12))   #CO2 in kg per tree
}




#######################################
#SUMMARY VALUES 
#######################################

# CO2 eq per living tree and year 
###########################
CO2eq<-CO2+ (CH4*GWPCH4)+(N2O*GWPN2O)
CO2eq[,1]<-c(1:Nyear)
CO2eqtree<- CO2eq[,-(17:18)]   
#sum(CO2eqtree)-120 #-8.30531 VALUS OF CO2eq PER LIVING TREE
#sum(CO2eq)-120=-8.311226



#FARM VALUES  - Kg CO2 total
#############################################################

# Annual values of GHGs per year and plant organ
#############################################################

#CO2 Kg per year
farmCO2_annual<- CO2*Ntree*Area 
farmCO2_annual[,1]<-c(1:Nyear)  
#N2O Kg per year
farmN2O_annual<- N2O*Ntree*Area 
farmN2O_annual[,1]<-c(1:Nyear)   
#CH4 Kg per year
farmCH4_annual<- CH4*Ntree*Area
farmCH4_annual[,1]<-c(1:Nyear)     
#CO2eq Kg per year
farmCO2eq_annual<- CO2eq*Ntree*Area 
farmCO2eq_annual[,1]<-c(1:Nyear)     



# Total values of GHGs per plant organ or residue
#############################################################
farmCO2_perpart<- colSums(farmCO2_annual[1:Nyear,])   
farmCO2_perpart=farmCO2_perpart[-1]#-115233.8  
farmN2O_perpart<- colSums(farmN2O_annual[1:Nyear,]) 
farmN2O_perpart=farmN2O_perpart[-1]
farmCH4_perpart<- colSums(farmCH4_annual[1:Nyear,]) 
farmCH4_perpart=farmCH4_perpart[-1]
farmCO2eq_perpart<- colSums(farmCO2eq_annual[1:Nyear,])   
farmCO2eq_perpart=farmCO2eq_perpart[-1]


# Total GHGs 
#############################################################

#summary results per gas:
farmGHG<-cbind( sum(farmCO2_perpart),sum(farmN2O_perpart),sum(farmCH4_perpart),sum(farmCO2eq_perpart))
colnames(farmGHG)<-c("CO2","N2O","CH4","CO2eq")
farmGHG

#summary results per gas:
farmGHG_TONNES<-farmGHG/1000


#Tonnes CO2eq per  product 
##########################################
farm_TOTALyield<-sum(yieldyear)*Ntree*Area #in tonnes ha
GHGperKg<-farmGHG/(farm_TOTALyield*1000)
GHGperTON<-farmGHG_TONNES/farm_TOTALyield
  

#Tonnes CO2eq per  ha
##########################################
TONGHGperha<-farmGHG_TONNES/Area
kgGHGperha<-farmGHG/Area




} # THIS IS THE EN OF THE IBM

