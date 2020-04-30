#rm(list = ls())

#IBM CASE EXAMPLE#

# global warming values

GWP="Myhre2013"

#FARM PARAMETERS 
Area =10    #Area in ha  
crop = "vinewine"    # crop name
Nind = 1200    #Number of individuals per ha 
Nyear =15    #Crop life cycle in years   
pruning="YES" # pruning yes or not
pruning_farm_values="YES"
PrunP_start=NA
pruning_weight="YES" 
Pruntha=c(0,0,0,0,0.5,0.55,0.55,0.55,0.56,0.56,0.57,0.58,0.59,0.6,0.6)  #Tonnes per ha and year of pruned residues, if known -  (vector) 
pruning_perc="NO"
PrunPer=c(0,0,0,0,0,20,25,30,30,30,35,40,40,40,40)  #Percentage of tree crown removed per year, if known  (vector, %)
yieldyear= c(0,0,50,50,60,70,70,80,80,80,70,70,60,60,55)   #tonees per ha   (vector)
PERBAD=10
PNdie= 3 #Percentage of trees that die in the period, if known (number, %) 
gaping="YES"    #Are the trees that die replaced by new ones? (boolean, yes or not)

#RESIDUES

# Pruning

burn_prun= "YES" #Are the pruning residues or part of them burnt? -(boolean, yes or not)
PERburn_prun = 50     # Percetage of pruning resides that are burnt over the total pruning values - (number, %)
soil_chip_prun = "NO"  # Are the chips from pruning residues spread out on the ground?  (boolean, yes, not)
PERchipsoil_prun = 0 # Percetage of pruning resides that are left on the ground over the total pruning values (number, %)
com_chip_prun="YES" # Are the pruning residues chipped and composted?  (boolean, yes, not)
PERchipcom_prun = 50 # Percetage of pruning resides that are left on the ground over the total pruning values (number, %)
prun_away = "NO"     # Are the pruning residues taken away from farm boundary?  (boolean, yes, not)
PERprun_away=0   # Percetage of pruning resides that are taken away from farm boundary (number, %)    

#Trees that die during the period
burn_dead = "YES"      # Are the wood residues from dead trees burnt? -"" (boolean, yes, not)
PERburn_dead = 50      # Percetage of wood residues from dead trees that are burnt over the total pruning values (number, %)
soil_chip_dead = "NO"   #Are the wood residues from dead trees spread out on the ground? (boolean, yes, not)
PERchipsoil_dead= 0   # Percetage of wood residues from dead trees that are left on the ground over the total pruning values   (number, %)
dead_away = "YES"     # Are the pruning residues taken away from farm boundary?  (boolean, yes, not)
PERdead_away= 50      # Percetage of pruning resides that are taken away from farm boundary (number, %)    

# Trees end cycle 
burn_tree="YES" # Are the removed trees burnt? (boolean, yes, not)
PERburn_tree= 90 # Percetage of removed trees that are burnt (number, %)
soil_chip_tree="YES" #Are the removed trees residues spread out on the ground? (boolean, yes, not)
PERchipsoil_tree=10 #Percetage of removed trees residues that are left on the ground over the total pruning values  (number, %)
tree_away = "NO"     # Are the removed trees residues taken away from farm boundary?  (boolean, yes, not)
PERtree_away= 0      # Percetage of removed trees resides that are taken away from farm boundary (number, %)    


# LITTER (either left it on the ground or burnt)
soil_litter="YES"   #   Is the litter left on the ground? (boolean, yes, not)  
PERsoil_litter=50  # Percentage of total litter left on the ground  (number, %)
burn_litter="NO" #is the litter  burnt? (boolean, yes, not)
PERburn_litter=0
com_litter="YES"  # Is the litter composted? (boolean, yes, not)
PERcom_litter=50  # Percentage of total litter composted  (number, %)
open_compost="YES"
enclosed_comp="NO"
litter_away="NO"

# Unsuitable fluits
soil_fruit="YES"     # Are the fruits left on the ground?  (boolean, yes, not)
PERsoil_fruit =50    # Percentage of total litter left on the ground  (number, %)
comp_fruit = "YES"   # Is the unsuitable yield composted? (boolean, yes, not)
PERcomp_fruit=50     # Percentage of total unsuitable yield composted   (number, %)
open_compost="NO"
enclosed_comp="YES"
treed_away = "NO"
PERtree_away=0        # Percetage of unsuitable fruits that are taken away from farm boundary (number, %)    


# Fruit pulp 
depulp="NO"      # Is the fruit depulped? (boolean, yes or no)
soil_pulp="NO"   # Is the pulp left on the ground? (boolean, yes, not)
PERsoil_pulp=0   # Percentage of total pulp left on the ground  -""  (number, %)
comp_pulp="NO"   # Is the litter composted? (boolean, yes, not)
PERcomp_pulp=0   # Percentage of total pulp composted   (number, %)
open_compost="NO"
enclosed_comp="NO"
pulp_away="NO"  # Is the pulp taken away from farm boundary?  (boolean, yes, not)
PERpulp_away= 0  # Percetage of pulp fruits that are taken away from farm boundary - ""(number, %)    

#Fruit seeds
soil_seed="NO"   # Is the pulp left on the ground? (boolean, yes, not)
PERsoil_seed=0   # Percentage of total pulp left on the ground  -""  (number, %)
comp_seed="NO"   # Is the litter composted? (boolean, yes, not)
PERcomp_seed=0   # Percentage of total pulp composted   (number, %)
open_compost="NO"
enclosed_comp="NO"
seed_away="NO"  # Is the pulp taken away from farm boundary?  (boolean, yes, not)
PERseed_away= 0  # 

