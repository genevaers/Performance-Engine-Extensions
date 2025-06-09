//RUNDCOL JOB (ACCT),'Run HSM Dcollect',                          
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
//JSTEP010 EXEC PGM=IDCAMS                 
//SYSPRINT DD SYSOUT=*                     
//DCOUT    DD DSN=&HLQ..&MLQ..D2025156,  
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