n=1

while [ $n -le 24 ]; do
gfal-copy gsiftp://gridftp.accre.vanderbilt.edu/lio/lfs/cms/store/user/cferraio/PAMinimumBias2/crab_pPb2016_PromptReco_MinBias2_285832_withCent_regfC_PUrejected/171018_192345/0000/pPb2016_PromptReco_MinBias2_285832_${n}.root /afs/cern.ch/work/c/cferraio/private/crab_pPb2016_PromptReco_MinBias2_285832_withCent_regfC_PUrejected/
(( n++ ))
done

#while [ $n -le 34 ]; do
#gfal-copy gsiftp://gridftp.accre.vanderbilt.edu/lio/lfs/cms/store/user/cferraio/PAMinimumBias2/crab_pPb2016_PromptReco_MinBias2_286178_withCent_regfC_PUrejected/171018_192356/0000/pPb2016_PromptReco_MinBias2_286178_${n}.root /afs/cern.ch/work/c/cferraio/private/crab_pPb2016_PromptReco_MinBias2_286178_withCent_regfC_PUrejected/
#(( n++ ))
#done