


##IBM crop parameters

#LIST OF PARAMETRIZED CROPS

#IBM
#apple
#citrus
#cocoa
#coffee
#tea
#vinewine
#otherwood

#ABM
#miscanthus
#sugargane
#switchgrass



if (crop=="apple"){
  drymatterwood=0.8
  drymatterfruit=0.14
  drymatterleaf=0.6
  Cwood=0.47
  Nwood=0.015
  Cleaf=0.47
  Nleaf=0.25
  Croot=0.47
  Nroot=0.015
  Cfruit=0.47
  Nfruit=0.0038
  AGBcoefa = 0.683  
  AGBcoefb =  1.76  
  AGBWcoefa = 0.267
  AGBWcoefb =  2.025
  BGBcoefa = 0.46  
  BGBcoefb =  1.345 
  deciduous="YES"
  leaflife=1
  LEAFcoefa = 0.699  
  LEAFcoefb =  0.417  
  wRf=1
  nRf=1
  depulp="NO"
  Ppulp=1
  PartFruitYield="All"
}

if (crop=="citrus"){
  drymatterwood=0.82
  drymatterfruit=0.1
  drymatterleaf=0.6 
  Cwood=0.47
  Nwood=0.015
  Cleaf=0.47
  Nleaf=0.02
  Croot=0.47
  Nroot=0.015
  Cfruit=0.47
  Nfruit=0.0095
  AGBcoefa = 0.395 
  AGBcoefb =  2.120  
  AGBWcoefa = 0.125
  AGBWcoefb =  2.376
  BGBcoefa = 0.040  
  BGBcoefb =  2.525 
  deciduous="NO"
  leaflife=1
  LEAFcoefa = 1.297  
  LEAFcoefb =  0.535  
  wRf=1
  nRf=1
  depulp="NO"
  PartFruitYield="All"
}

if (crop=="cocoa"){
  drymatterwood=0.8
  drymatterfruit=0.1
  drymatterleaf=0.6 
  Cwood=0.47
  Nwood=0.4
  Cleaf=0.47
  Nleaf=0.47
  Croot=0.47
  Nroot=0.015
  Cfruit=0.47
  Nfruit=0.016
  AGBcoefa = 1.250
  AGBcoefb =  1.344  
  AGBWcoefa = 1.135
  AGBWcoefb =  1.307
  BGBcoefa = 0.589
  BGBcoefb =  1.113 
  deciduous="NO"
  leaflife=1
  LEAFcoefa = 0.165
  LEAFcoefb =  1.073 
  wRf=1
  nRf=1
  depulp="YES"
  Ppulp=0.4
  Pseed=0.6
  PartFruitYield="Seed"
}

if (crop=="coffee"){
  drymatterwood=0.8
  drymatterfruit=0.1
  drymatterleaf=0.6 
  Cwood=0.47
  Nwood=0.4
  Cleaf=0.47
  Nleaf=0.47
  Croot=0.47
  Nroot=0.015
  Cfruit=0.47
  Nfruit=0.016
  AGBcoefa = 3.999
  AGBcoefb =  0.568  
  AGBWcoefa = 3.3342
  AGBWcoefb =  0.7033
  BGBcoefa = 0.2284
  BGBcoefb =  1.58 
  deciduous="NO"
  leaflife=1
  LEAFcoefa = 0.223 
  LEAFcoefb =  0.940 
  wRf=1
  nRf=1
  depulp="YES"
  Ppulp=0.4
  Pseed=0.6
  PartFruitYield="Seed"
}

if (crop=="tea"){
  drymatterwood=0.8
  drymatterfruit=0.8
  drymatterleaf=0.6 
  Cwood=0.47
  Nwood=0.0041
  Cleaf=0.69
  Nleaf=0.028
  Croot=0.41
  Nroot=0.0052
  Cfruit=Cleaf
  Nfruit= Nleaf
  AGBcoefa = 1.526
  AGBcoefb =  0.557  
  AGBWcoefa = 1.215
  AGBWcoefb =  0.599
  BGBcoefa = 0.213
  BGBcoefb =  0.580 
  deciduous="NO"
  leaflife=3
  LEAFcoefa = 0.592 
  LEAFcoefb =  0.135 
  wRf=1
  nRf=1
  depulp="NO"
  PartFruitYield="None"
  
}
  
  if (crop=="vinewine"){
    drymatterwood=0.8
    drymatterfruit=0.1
    drymatterleaf=0.6 
    Cwood=0.5
    Nwood=0.16
    Cleaf=0.47
    Nleaf=0.27
    Croot=0.47
    Nroot=0.0015
    Cfruit=0.47
    Nfruit= 0.02
    AGBcoefa = 1.1583
    AGBcoefb =  0.4562 
    AGBWcoefa = 0.7162
    AGBWcoefb =  0.4494
    BGBcoefa = 0.4723
    BGBcoefb =  0.45
    deciduous="YES"
    leaflife=1
    LEAFcoefa = 0.5558
    LEAFcoefb =  0.5743 
    wRf=1
    nRf=1
    depulp="NO"
    Ppulp=NA
    Pseed=NA
    PartFruitYield="All"
  }

if (crop=="otherwood"){
  drymatterwood=0.8
  drymatterfruit=0.1
  drymatterleaf=0.6 
  Cwood=0.47
  Nwood=0.16
  Cleaf=0.47
  Nleaf=0.27
  Croot=0.47
  Nroot=0.0015
  Cfruit=0.47
  Nfruit= 0.02
  AGBcoefa = 1.50188
  AGBcoefb =  1.1342 
  AGBWcoefa = 1.132
  AGBWcoefb =  1.24328
  BGBcoefa = 0.33378
  BGBcoefb =  1.2655
  deciduous="NO"
  leaflife=3
  LEAFcoefa = 0.58846
  LEAFcoefb =  0.612383
  wRf=1
  nRf=1
  depulp="NO"
  Ppulp=NA
  Pseed=NA
  PartFruitYield="All"
}
