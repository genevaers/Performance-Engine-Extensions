//NRUNMRP  JOB (ACCT),'RUM MIG REPORT',                                    
//          NOTIFY=&SYSUID.,                                                    
//          REGION=0M,                                                          
//          CLASS=A,                                                            
//          MSGLEVEL=(1,1),                                                     
//          MSGCLASS=X                                                          
//********************************************************************    
//*                                                                       
//* (C) COPYRIGHT IBM CORPORATION 2025.                                   
//*    Copyright Contributors to the GenevaERS Project.                   
//*SPDX-License-Identifier: Apache-2.0                                    
//*                                                                       
//********************************************************************    
//*                                                                       
//*  Licensed under the Apache License, Version 2.0 (the "License");      
//*  you may not use this file except in compliance with the License.     
//*  You may obtain a copy of the License at                              
//*                                                                       
//*     http://www.apache.org/licenses/LICENSE-2.0                        
//*                                                                       
//*  Unless required by applicable law or agreed to in writing, software  
//*  distributed under the License is distributed on an "AS IS" BASIS,    
//*  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express         
//*  or implied.                                                          
//*  See the License for the specific language governing permissions      
//*  and limitations under the License.                                   
//*                                                                       
//*********************************************************************         
//*  ASSEMBLE AND LINK ASSEMBLER GVBMIGRP
//*********************************************************************         
//*                                                                             
//         EXPORT SYMLIST=*                                                     
//*                                                                             
//*        SET HLQ=<YOUR-TSO-PREFIX> 
//         SET MLQ=GVBDEMO                                                           
//*                                                                             
//JOBLIB   DD DISP=SHR,DSN=&HLQ..&MLQ..GVBLOAD                                  
//*
//**********************************************************************        
//*  CREATE DCOLLECT DATASET
//**********************************************************************        
//*
//JSTEP010 EXEC PGM=IDCAMS                 
//SYSPRINT DD SYSOUT=*                     
//DCOUT    DD DSN=GEBT.DCOLLECT.DATA,      
//            DISP=(NEW,CATLG),            
//            SPACE=(CYL,(1000,500),RLSE), 
//            DCB=(RECFM=VB,BLKSIZE=27998),
//            UNIT=SYSDA                   
//MCDS     DD DSN=HSM.MCDS,DISP=SHR        
//SYSIN    DD *                            
     DCOLLECT -                            
           OUTFILE(DCOUT) -                
           MIGRATEDATA                     
/*
//*
//*********************************************************************
//*  PROCESS DCOLLECT DATASET FOR MIGRATED FILES                       
//*********************************************************************
//* 
//* DCOLLECT REQUIRES:
//* 
//*     1) Read acccess to STGADMIN.IDC.DCOLLECT CL(FACILITY) in RACF.
//*     2) Read access for HSM.MCDS CL(DATASET) in RACF.
//*
//* The follow parameters are provided:
//* 
//*     HLQ for the datasets being examined
//*     DATE (last referenced) before which datasets are being examined
//*     UPSI   flags to indicate:
//* 
//*      01000000  Report file in CSV format
//*      10000000  IDCAMS delete statements should be generated
//* 
//GVBMREP EXEC PGM=EXAMPLED,                                           
//            PARM='HLQ=GEBT.,DATE=20250213,UPSI=10000010'             
//*                                                                    
//STEPLIB  DD DISP=SHR,DSN=&LVL1..RTC&RTC..EXITS.GVBLOAD                     
//*
//* DCOLLECT DATASET PRODUCED BY PREVIOUS STEP
//* 
//DDINPUT  DD DISP=SHR,DSN=GEBT.DCOLLECT.DATA                          
//*
//* REPORT FILE PRODUCED BY THIS STEP (CAN BE CSV)
//* 
//DDPRINT  DD SYSOUT=*
//*
//* IDCAMS DELETE CARDS IF REQUESTED
//* 
//DDDELETE DD DISP=(,CATLG,DELETE),DSN=GEBT.IDCAMS.SYSIN
//            SPACE=(CYL,(10,5,0)),
//            UNIT=SYSDA
//*
//SYSOUT   DD SYSOUT=*
//SYSUDUMP DD SYSOUT=*
//SYSPRINT DD SYSOUT=*                                                 
//DDPRINT  DD SYSOUT=*                                                 
//                                                                     
