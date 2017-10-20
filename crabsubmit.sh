#!/bin/bash

minBiasSet=PAMinimumBias2 ####change the minbias dataset you want

source /cvmfs/cms.cern.ch/crab3/crab.sh
#python ./makeFileList.py --query="run dataset=/$minBiasSet/PARun2016C-PromptReco-v1/AOD" --limit=0 > filelist.txt


while IFS='' read -r line || [[ -n "$line" ]]; do
  runNumber=$line
  echo "from CRABClient.UserUtilities import config" > crabsubmitcfg.py
  echo "config = config()" >> crabsubmitcfg.py
  echo "config.General.requestName = 'pPb2016_PromptReco_MinBias2_${runNumber}_withCent_regfC_PUrejected_partial'" >> crabsubmitcfg.py
  echo "config.General.transferLogs = True" >> crabsubmitcfg.py
  echo "config.General.transferOutputs = True" >> crabsubmitcfg.py
  echo "config.section_('JobType')" >> crabsubmitcfg.py
  echo "config.JobType.outputFiles = ['pPb2016_PromptReco_MinBias2_$runNumber.root']" >> crabsubmitcfg.py
  echo "config.JobType.pyCfgParams = ['noprint']" >> crabsubmitcfg.py
  echo "config.JobType.pluginName = 'Analysis'" >> crabsubmitcfg.py
  echo "config.JobType.psetName = 'RunForwardAnalyzer_pPb2016shell.py'" >> crabsubmitcfg.py
  echo "config.Data.inputDataset = '/$minBiasSet/PARun2016C-PromptReco-v1/AOD'" >> crabsubmitcfg.py
  echo "config.Data.splitting = 'LumiBased'" >> crabsubmitcfg.py
  echo "config.Data.unitsPerJob = 20" >> crabsubmitcfg.py
  echo "config.Data.publication = False" >> crabsubmitcfg.py
#  echo "lumi_mask='Cert_262548-263757_PromptReco_HICollisions15_JSON.txt'" >> crabsubmitcfg.py
  echo "config.Data.outLFNDirBase = '/store/user/cferraio'" >> crabsubmitcfg.py
  echo "config.Data.runRange = '$runNumber'" >> crabsubmitcfg.py
  echo "config.Site.storageSite = 'T2_US_Vanderbilt'" >> crabsubmitcfg.py
  
  echo "import FWCore.ParameterSet.Config as cms" > RunForwardAnalyzer_pPb2016shell.py
  echo "process = cms.Process(\"Forward\")" >> RunForwardAnalyzer_pPb2016shell.py
  echo "process.load(\"FWCore.MessageService.MessageLogger_cfi\")" >> RunForwardAnalyzer_pPb2016shell.py
  echo "process.maxEvents = cms.untracked.PSet(input = cms.untracked.int32(1000)) " >> RunForwardAnalyzer_pPb2016shell.py
  echo "process.MessageLogger.cerr.FwkReport.reportEvery = 1000" >> RunForwardAnalyzer_pPb2016shell.py  
  echo "process.load(\"Configuration.StandardSequences.FrontierConditions_GlobalTag_condDBv2_cff\")" >> RunForwardAnalyzer_pPb2016shell.py
  echo "process.load('HeavyIonsAnalysis.Configuration.collisionEventSelection_cff')" >> RunForwardAnalyzer_pPb2016shell.py
  echo "process.load(\"IORawData.HcalTBInputService.HcalTBSource_cfi\")" >> RunForwardAnalyzer_pPb2016shell.py
  echo "process.load(\"Configuration.Geometry.GeometryECALHCAL_cff\")" >> RunForwardAnalyzer_pPb2016shell.py
  echo "process.load(\"HeavyIonsAnalysis.VertexAnalysis.PAPileUpVertexFilter_cff\")" >> RunForwardAnalyzer_pPb2016shell.py
  echo "process.maxEvents = cms.untracked.PSet( input = cms.untracked.int32(-1) )" >> RunForwardAnalyzer_pPb2016shell.py
  echo "process.source = cms.Source(\"PoolSource\",fileNames = cms.untracked.vstring())" >> RunForwardAnalyzer_pPb2016shell.py
  echo "from Configuration.AlCa.GlobalTag import GlobalTag" >> RunForwardAnalyzer_pPb2016shell.py
  echo "from HeavyIonsAnalysis.Configuration.collisionEventSelection_cff import *" >> RunForwardAnalyzer_pPb2016shell.py 
  echo "process.GlobalTag.globaltag = '80X_dataRun2_Express_v15'" >> RunForwardAnalyzer_pPb2016shell.py
  echo "process.TFileService = cms.Service(\"TFileService\",fileName=cms.string('pPb2016_PromptReco_MinBias2_$runNumber.root'))" >> RunForwardAnalyzer_pPb2016shell.py
  echo "process.eventSelection = cms.Sequence(process.pileupVertexFilterCutGplus)" >> RunForwardAnalyzer_pPb2016shell.py
  echo "process.analyzer = cms.EDAnalyzer('ForwardAnalyzer', castor = cms.InputTag(\"castorDigis\"), centralitySrc = cms.InputTag(\"pACentrality\"))" >> RunForwardAnalyzer_pPb2016shell.py
  echo "process.p = cms.Path(process.analyzer)" >> RunForwardAnalyzer_pPb2016shell.py
  
  
  crab submit -c crabsubmitcfg.py #uncomment to actually submit jobs. test with this commented first.
  echo "Submitted run number $runNumber from $minBiasSet dataset to crab"
  
done < "filelist.txt"


#clean up
#rm crabsubmitcfg.py
rm crabsubmitcfg.pyc
#rm RunForwardAnalyzer_pPb2016shell.py
rm RunForwardAnalyzer_pPb2016shell.pyc