import FWCore.ParameterSet.Config as cms

process = cms.Process("Forward")

process.load("FWCore.MessageService.MessageLogger_cfi")
process.load("Configuration.StandardSequences.FrontierConditions_GlobalTag_condDBv2_cff")
process.load('HeavyIonsAnalysis.Configuration.collisionEventSelection_cff')
process.load("Configuration.Geometry.GeometryECALHCAL_cff")
process.load("HeavyIonsAnalysis.VertexAnalysis.PAPileUpVertexFilter_cff") #no pileup


process.maxEvents = cms.untracked.PSet(
    input = cms.untracked.int32(1000)
)

process.MessageLogger.cerr.FwkReport.reportEvery = 100000

process.load("IORawData.HcalTBInputService.HcalTBSource_cfi")

process.TFileService = cms.Service("TFileService",
                                   fileName = cms.string("Tree286516noPU.root")
                                   )
#process.TFileService = cms.Service("TFileService",fileName=cms.string("ZDCRawToDiigi_QWM.root")) 

process.source = cms.Source('PoolSource', 
    fileNames = cms.untracked.vstring( 'file:digi282516.root' )
)

process.eventSelection = cms.Sequence(process.pileupVertexFilterCutGplus) #no pileup

process.analyzer = cms.EDAnalyzer('ForwardAnalyzer'
#                                , nZdcTs = cms.untracked.int32(10)
#                                , calZDCDigi = cms.untracked.bool(False)
                                , castor = cms.InputTag("castorDigis")
                                , centralitySrc = cms.InputTag("pACentrality")
#                                , cent_bin = cms.InputTag("centralityBin","HFtowers")
)

from Configuration.AlCa.GlobalTag import GlobalTag
process.GlobalTag.globaltag = '80X_dataRun2_Prompt_v16'
from HeavyIonsAnalysis.Configuration.collisionEventSelection_cff import *

process.p = cms.Path(process.analyzer)

