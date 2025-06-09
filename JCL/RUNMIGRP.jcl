//RUNMIGRP JOB (ACCT),'Mig Report',                          
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
//* Licensed under the Apache License, Version 2.0 (the "License");  
//* you may not use this file except in compliance with the License. 
//* You may obtain a copy of the License at                          
//*                                                                   
//*     http://www.apache.org/licenses/LICENSE-2.0                    
//*                                                                   
//* Unless required by applicable law or agreed to in writing, software
//* distributed under the License is distributed on an "AS IS" BASIS,
//* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express     
//* or implied.                                                      
//* See the License for the specific language governing permissions  
//* and limitations under the License.                               
//*                                                                   
//*********************************************************************
//*   COMPILE AND LINK MIGRATION DATASET REPORT
//*********************************************************************
//*
//         EXPORT SYMLIST=*
//*
//*        SET HLQ=<YOUR-TSO-PREFIX>
//         SET MLQ=GVBDEMO
//*
//*********************************************************************
//*  PROCESS DCOLLECT DATASET FOR MIGRATED FILES                       
//*********************************************************************
//*                                                                    
//GVBMRCC EXEC PGM=GVBMIGRP,                                           
//            PARM='HLQ=GEBT.,DATE=20221101,UPSI=11000010'             
//*                                                                    
//STEPLIB  DD DISP=SHR,DSN=&LVL1..RTC&RTC..GVBLOAD                     
//*
//DDINPUT  DD DISP=SHR,DSN=GEBT.DCOLLECT.D2025156                      
//*                                                                    
//DDPRINT  DD SYSOUT=*                                                 
//*                                                                    
//DDDELETE DD DISP=(,CATLG,KEEP),DSN=&HLQ..&MLQ..D2025156.SYSTSIN.STAR,       
//            SPACE=(TRK,(10,10)),                                     
//            UNIT=SYSDA                                               
//*                                                                    
//SYSOUT   DD SYSOUT=*                                                 
//*
//SYSUDUMP DD SYSOUT=*
//DDPRIN   DD SYSOUT=*                                                 
//DDDRUCK  DD SYSOUT=*                                                 