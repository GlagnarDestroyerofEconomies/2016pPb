import FWCore.ParameterSet.Config as cms
process = cms.Process("Forward")
process.load("FWCore.MessageService.MessageLogger_cfi")
process.MessageLogger.cerr.FwkReport.reportEvery = 1000
process.load("Configuration.StandardSequences.FrontierConditions_GlobalTag_condDBv2_cff")
process.load('HeavyIonsAnalysis.Configuration.collisionEventSelection_cff')
process.load("IORawData.HcalTBInputService.HcalTBSource_cfi")
process.maxEvents = cms.untracked.PSet( input = cms.untracked.int32(-1) )
process.source = cms.Source("PoolSource",fileNames = cms.untracked.vstring())
from Configuration.AlCa.GlobalTag import GlobalTag
from HeavyIonsAnalysis.Configuration.collisionEventSelection_cff import *
process.GlobalTag.globaltag = '80X_dataRun2_Express_v15'
process.TFileService = cms.Service("TFileService",fileName=cms.string('pPb2016_PromptReco_MinBias2_285832.root'))
process.analyzer = cms.EDAnalyzer('ForwardAnalyzer', castor = cms.InputTag("castorDigis"), centralitySrc = cms.InputTag("pACentrality"))
process.p = cms.Path(process.analyzer)
