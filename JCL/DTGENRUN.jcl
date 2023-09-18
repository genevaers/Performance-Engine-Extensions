//DTGENRUN JOB (ACCT),'GENEVAERS RUN DTGEN',
//          NOTIFY=&SYSUID.,
//          REGION=0M,
//          CLASS=A,
//          MSGLEVEL=(1,1),
//          MSGCLASS=X
//********************************************************************    
//*                                                                       
//* (C) COPYRIGHT IBM CORPORATION 2021.                                   
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
//*
//*     RUN GVBDTGEN TEST GENERATOR TO CREATE DATA FILES FOR GENEVAERS
//*     GVBDEMO.
//*
//* BEFORE SUBMITTING THIS JOB, PLEASE:
//*
//*     1)  UPDATE THE JOB STATEMENT ABOVE TO CONFORM TO YOUR
//*         INSTALLATION'S STANDARDS.
//*
//*     2)  SET THE VALUE OF "HLQ" ABOVE TO YOUR TSO PREFIX.
//*         THIS IS NORMALLY THE SAME AS YOUR TSO ID,
//*         UNLESS YOU HAVE CHANGED IT WITH THE TSO PROFILE PREFIX
//*         COMMAND.
//*
//*         THIS VALUE WILL DETERMINE THE HIGH-LEVEL QUALIFIER
//*         OF THE NAMES OF THE DEMO DATA SETS.
//*
//*     3)  THE "MLQ" DEFAULT VALUE IS GVBDEMO AND DOES NOT NEED TO BE
//*         CHANGED.
//*
//*     4)  SET THE VALUE OF "ORDERMAX" ABOVE TO THE MAXIMUM
//*         NUMBER OF ORDER RECORDS TO BE GENERATED INTO YOUR
//*         DEMO ORDER DATA SET.
//*
//*         THIS WILL DETERMINE THE TOTAL AMOUNT OF DISK SPACE
//*         REQUIRED BY ALL THE DEMO DATA SETS.
//*
//*         HERE ARE SOME EXAMPLES:
//*
//*              150000  -  39 MB
//*             4000000  - 850 MB
//*
//* IF THIS JOB EXECUTION RESULTS IN A B37 ABEND, INCREASE THE
//* SPACE ALLOCATIONS IN THE DD STATEMENTS BELOW.
//*
//*
//         EXPORT SYMLIST=*
//*
//*        SET HLQ=<YOUR-TSO-PREFIX>
//         SET MLQ=GVBDEMO
//         SET ORDERMAX=5000000
//*
//*********************************************************************
//*
//JOBLIB   DD DISP=SHR,DSN=&HLQ..&MLQ..BTCHLOAD
//*
//*********************************************************************
//* DELETE THE FILE(S) CREATED IN NEXT STEP
//*********************************************************************
//*
//DELFILES EXEC PGM=IDCAMS
//*
//SYSPRINT DD SYSOUT=*
//*
//SYSIN    DD *,SYMBOLS=EXECSYS

 DELETE  &HLQ..&MLQ..CUSTOMER  PURGE
 DELETE  &HLQ..&MLQ..CUSTNAME  PURGE
 DELETE  &HLQ..&MLQ..ORDER     PURGE
 DELETE  &HLQ..&MLQ..ORDITM01  PURGE
 DELETE  &HLQ..&MLQ..ORDITM02  PURGE
 DELETE  &HLQ..&MLQ..ORDITM03  PURGE
 DELETE  &HLQ..&MLQ..PRODUCT   PURGE
 DELETE  &HLQ..&MLQ..PRODDESC  PURGE
 DELETE  &HLQ..&MLQ..CUSTADDR  PURGE
 DELETE  &HLQ..&MLQ..STOREADR  PURGE

 IF MAXCC LE 8 THEN         /* IF OPERATION FAILED,     */    -
     SET MAXCC = 0          /* PROCEED AS NORMAL ANYWAY */

//*
//*
//*********************************************************************
//* GENERATE DEMO DATA SETS
//*********************************************************************
//*
//DTGEN EXEC PGM=GVBDTGEN,
// PARM=('PARTITION=STATE,ORDERS=&ORDERMAX,DYMULT=2'),
// REGION=0M
//*
//CUSTOMER DD DSN=&HLQ..&MLQ..CUSTOMER,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,
//            SPACE=(TRK,(25,10),RLSE),
//            DCB=(DSORG=PS,RECFM=FB,LRECL=80)
//*
//CUSTNAME DD DSN=&HLQ..&MLQ..CUSTNAME,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,
//            SPACE=(TRK,(25,10),RLSE),
//            DCB=(DSORG=PS,RECFM=FB,LRECL=80)
//*
//ORDER    DD DSN=&HLQ..&MLQ..ORDER,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,
//            SPACE=(TRK,(5000,500),RLSE),
//            DCB=(DSORG=PS,RECFM=FB,LRECL=80)
//*
//ORDITM01 DD DSN=&HLQ..&MLQ..ORDITM01,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,
//            SPACE=(TRK,(9000,500),RLSE),
//            DCB=(DSORG=PS,RECFM=FB,LRECL=80)
//*
//ORDITM02 DD DSN=&HLQ..&MLQ..ORDITM02,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,
//            SPACE=(TRK,(9000,500),RLSE),
//            DCB=(DSORG=PS,RECFM=FB,LRECL=80)
//*
//ORDITM03 DD DSN=&HLQ..&MLQ..ORDITM03,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,
//            SPACE=(TRK,(9000,500),RLSE),
//            DCB=(DSORG=PS,RECFM=FB,LRECL=80)
//*
//PRODUCT  DD DSN=&HLQ..&MLQ..PRODUCT,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,
//            SPACE=(TRK,(50,5),RLSE),
//            DCB=(DSORG=PS,RECFM=FB,LRECL=80)
//*
//PRODDESC DD DSN=&HLQ..&MLQ..PRODDESC,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,
//            SPACE=(TRK,(50,5),RLSE),
//            DCB=(DSORG=PS,RECFM=FB,LRECL=80)
//*
//CUSTADDR DD DSN=&HLQ..&MLQ..CUSTADDR,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,
//            SPACE=(TRK,(50,5),RLSE),
//            DCB=(DSORG=PS,RECFM=FB,LRECL=103)
//*
//STOREADR DD DSN=&HLQ..&MLQ..STOREADR,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,
//            SPACE=(TRK,(50,5),RLSE),
//            DCB=(DSORG=PS,RECFM=FB,LRECL=103)
//*
//SYSOUT   DD SYSOUT=*
//SYSPRINT DD SYSOUT=*
//*
