#!/bin/sh

while IFS='' read -r line || [ -n "$line" ]; do
#runNumber=$line
runNumber=285832
echo hi
command='gfal-ls  'srm://se1.accre.vanderbilt.edu:6288/srm/v2/server?SFN=/lio/lfs/cms/store/user/cferraio/PAMinimumBias2/crab_pPb2016_PromptReco_MinBias2_${runNumber}/''
#  $command
echo hi2
$command > commandholder.txt
nextfolder=`cat commandholder.txt`
echo hi3
nextcommand='gfal-ls  'srm://se1.accre.vanderbilt.edu:6288/srm/v2/server?SFN=/lio/lfs/cms/store/user/cferraio/PAMinimumBias2/crab_pPb2016_PromptReco_MinBias2_${runNumber}/${nextfolder}/0000''
$nextcommand > rootfileholder.txt
echo ${nextcommand}
totallines=`wc -l < rootfileholder.txt`
rootlines=`expr $totallines - 1`

echo "There are ${rootlines} files for run number ${runNumber}"

prefix="/lio/lfs/cms"
xrootd=${nextfolder#$prefix}

#if [ 1 -eq 0 ]; then
n=1
while [ $n -le $rootlines ]; do
echo "File ${n} started copying"

#command='gfal-cp -b -D srmv2 'srm://se1.accre.vanderbilt.edu:6288/srm/v2/server?SFN=${nextfolder}/0000/PbPb2015_PromptReco_MinBias2_${runNumber}_${n}.root'' #save="/afs/cern.ch/work/c/cferraio/public/2015ZDCTreeHolder/PbPb2015_PromptReco_MinBias2_${runNumber}_${n}.root"

#next="$command $save"
#$next

#command="gfal-cp -b -D srmv2 'srm://se1.accre.vanderbilt.edu:6288/srm/v2/server?SFN=${xrootd}/0000/PbPb2015_PromptReco_MinBias2_${runNumber}_${n}.root' /afs/cern.ch/work/c/cferraio/public/2015ZDCTreeHolder/PbPb2015_PromptReco_MinBias2_${runNumber}_${n}.root"
command="gfal-copy srm://se1.accre.vanderbilt.edu:6288/srm/v2/server?SFN=/lio/lfs/cms/store/user/cferraio/PAMinimumBias2/crab_pPb2016_PromptReco_MinBias2_${runNumber}/${nextfolder}/0000/pPb2016_PromptReco_MinBias2_${runNumber}_${n}.root /tmp/cferraio/" #/afs/cern.ch/work/c/cferraio/public/2015ZDCTreeHolder/"
echo $command
output=$($command)
while [ "$(echo $output | grep 'ERROR')" ]; do
   echo "Rerunning ${runNumber}_${n}"
   output=$($command)
done

echo $command >> rootcommands.txt
echo "File ${n} finished copying"
(( n++ ))
done
#fi

#if [ 1 -eq 0 ]; then
rm rootcommands.txt

echo "All files for ${runNumber} finished copying. Now merging."

#mv /afs/cern.ch/work/c/cferraio/public/2015ZDCTreeHolder/PbPb2015_PromptReco_MinBias2_${runNumber}_1.root /afs/cern.ch/work/c/cferraio/public/2015ZDCTreeHolder/PbPb2015_PromptReco_MinBias2_${runNumber}.root

#echo "First rootfile has been renamed. Merging beginning."
if [ 1 -eq 0 ]; then
haddlscommand=`ls -1x /tmp/cferraio/pPb2016C_PromptReco_MinBias2_${runNumber}_* | tr '\n' ' '`
haddmergecommand="hadd /tmp/cferraio/2015ZDCTreeHolder/pPb2016C_PromptReco_MinBias2_${runNumber}.root ${haddlscommand}"
$haddmergecommand


n=2
while [ $n -le $rootlines ]; do
hadd /afs/cern.ch/work/c/cferraio/public/2015ZDCTreeHolder/PbPb2015_PromptReco_MinBias2_${runNumber}_holder.root /afs/cern.ch/work/c/cferraio/public/2015ZDCTreeHolder/PbPb2015_PromptReco_MinBias2_${runNumber}_${n}.root /afs/cern.ch/work/c/cferraio/public/2015ZDCTreeHolder/PbPb2015_PromptReco_MinBias2_${runNumber}.root
mv /afs/cern.ch/work/c/cferraio/public/2015ZDCTreeHolder/PbPb2015_PromptReco_MinBias2_${runNumber}_holder.root /afs/cern.ch/work/c/cferraio/public/2015ZDCTreeHolder/PbPb2015_PromptReco_MinBias2_${runNumber}.root 
rm /afs/cern.ch/work/c/cferraio/public/2015ZDCTreeHolder/PbPb2015_PromptReco_MinBias2_${runNumber}_${n}.root
(( n++ ))
done


echo "Finished merging all root files for run ${runNumber}."

#if [ 1 -eq 0 ]; then
#n=2
#while [ $n -le $rootlines ]; do
#rm /afs/cern.ch/work/c/cferraio/public/2015ZDCTreeHolder/PbPb2015_PromptReco_MinBias2_${runNumber}_*
#(( n++ ))
#done
#fi
fi
echo "Deleted unmerged files for run ${runNumber}"

done < "filelist.txt"