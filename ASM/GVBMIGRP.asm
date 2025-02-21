********************************************************************#VB
*
* (C) COPYRIGHT IBM CORPORATION 2025.
*     Copyright Contributors to the GenevaERS Project.
* SPDX-License-Identifier: Apache-2.0
*
**********************************************************************
*
*  Licensed under the Apache License, Version 2.0 (the "License");
*  you may not use this file except in compliance with the License.
*  You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
*  Unless required by applicable law or agreed to in writing, software
*  distributed under the License is distributed on an "AS IS" BASIS,
*  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
*  or implied.
*  See the License for the specific language governing permissions
*  and limitations under the License.
*
         TITLE    'GVBMIGRP: process output from HSM DCOLLECT'
***********************************************************************
*                                                                     *
*  MODULE DESCRIPTION     : PROCESSES DCOLLECT RECORDS LOOKING FOR    *
*                           MIGRATED MVS DATASETS AND REPORTS THEIR   *
*                           DETAILS INCLUDING LAST REFERENCED DATE.   *
*                                                                     *
*                           CREATES REPORT WHICH CAN BE CSV           *
*                           CREATES INPUT CARDS FOR IDCAMS DELETE     *         
*                                                                     *
***********************************************************************
         IHASAVER DSECT=YES,SAVER=YES,SAVF4SA=YES,SAVF5SA=YES,TITLE=NO
*
         SYSSTATE ARCHLVL=2,AMODE64=NO
*
         YREGS
*
         ARCUTILP
*
*        DYNAMIC AREA
*
DYNAREA  DSECT
*
SAVEAREA DC    18F'0'
SVA2     DS    18F
*
         DS    0F
OUTDCB   DS    XL(OUTFILEL)    REENTRANT DCB AND DCBE AREAS
         DS    0F
INDCB    DS    XL(INFILEL)     REENTRANT DCB AND DCBE AREAS
         DS    0F
DELDCB   DS    XL(DELFILEL)    REENTRANT DCB AND DCBE AREAS
*
         DS    0F
WKUPSI   DS    CL8
WKUBYTE  DS    XL1
PURGEFIL EQU   X'80'           INPUT CARDS FOR IDCAMS DELETE CREATED
PURGECSV EQU   X'40'           REPORT IS CSV FORMAT
*
WKPRINT  DS   0XL255           PRINT LINE-----------------------------
         DS    XL10
WKTYPE   DS    CL1
WKCSV01  DS    XL1
WKNAME   DS    XL44
WKCSV02  DS    X
WKGDS    DS    C
WKCSV03  DS    X
WKVSAM   DS   0CL4
WKDSORG  DS    CL2
WKDSORG2 DS    C
WKDSORG3 DS    C
WKCSV04  DS    X
WKRECFM  DS    C
WKRECFM2 DS    C
WKCSV05  DS    X
WKLRECL  DS    CL8
WKCSV06  DS    X
WKLBLKL  DS    CL8
WKCSV07  DS    X
WKLEVEL  DS    CL4
WKCSV08  DS    X
WKRDAT   DS    CL8
         DS    XL157           ---------------------------------------
WKDELLIN DS   0XL80            PURGE LINE-----------------------------
         DS    X
WKDELETE DS    CL6
         DS    X
WKDELNAM DS    XL44
         DS    X
WKPURGE  DS    CL5
         DS    XL22            ---------------------------------------
*
         DS   0D
WKREENT  DS    XL256           REENTRANT WORKAREA
DBLWORK  DS    D               DOUBLE WORK WORKAREA
WKDBLWK  DS    D               DOUBLE WORK WORKAREA
DBLWORK2 DS    D               DOUBLE WORK WORKAREA
         DS    D               DOUBLE WORK WORKAREA
*
WKRETC   DS    F
WKSELCT  DS    F
WKACTCT  DS    F
         DS    F
*
WKREFHLQ DS    CL9
         DS    XL3
WKREFDAT DS    XL4             DERIVED REF DATE IS YYYYDDD (PACKED)
WKFROMDT DS    CL8             INPUT FROM DATE IS YYYYMMDD (CHAR)
WORKDTEJ DS   0XL16
WORKTIMJ DS    XL8
WORKDATJ DS    XL4
         DS    XL4
WORKDTEG DS   0XL16
WORKTIMG DS    XL8
WORKDATG DS    XL4
         DS    XL4
*
WKPLISTA DS    A
WKPLISTL DS    F
WKSUBPA1 DS    A
WKSUBPA2 DS    A
WKSUBPA3 DS    A
WKSUBPA4 DS    A
WKSUBPL1 DS    F
WKSUBPL2 DS    F
WKSUBPL3 DS    F
WKSUBPL4 DS    F
*
CONV_MFL DS    0F
         STCKCONV MF=L
CONV_LEN EQU *-CONV_MFL
*
PLIST    CONVTOD MF=L                  GENERATE PARAMETER LIST STORAGE
         DS   0D
STCKAREA DS    XL8
WKPARM   DS    CL100
*
DRECORD  DS    XL27994
DYNLEN   EQU   *-DYNAREA                 DYNAMIC AREA LENGTH
*
GVBMIGRP RMODE 24
GVBMIGRP AMODE 31
*
GVBMIGRP CSECT
         J     START
GVBMIGRP GVBEYE GVBMIGRP
static   loctr                    define the static section
code     loctr                    and the code
START    DS    0H
*
*        ENTRY LINKAGE
*
         STM   R14,R12,12(R13)           PUSH CALLER REGISTERS
         LLGTR R12,R15                   ESTABLISH ...
         USING GVBMIGRP,R12              ... ADDRESSABILITY
*
         LR    R9,R1              LOAD  PARAMETER LIST ADDRESS
*
         STORAGE OBTAIN,          get some storage for workarea        +
               LENGTH=DYNLEN,                                          +
               COND=NO,           Unconditional                        +
               CHECKZERO=YES      ask system to tell us if it's cleared
*
         LR    R11,R1                    MOVE GETMAINED ADDRESS TO R11
         USING DYNAREA,11                ADDRESSABILITY TO DSECT
         ST    R13,SAVEAREA+4            SAVE CALLER SAVE AREA ADDRESS
         LA    R15,SAVEAREA              GET ADDRESS OF OWN SAVE AREA
         ST    R15,8(,R13)               STORE IN CALLER SAVE AREA
         LR    R13,R15                   GET ADDRESS OF OWN SAVE AREA
*
         LAY   R1,SPACES
         MVC   WKPARM,0(R1)
         ST    R9,WKPLISTA        SAVE PARAMETER LIST ADDRESS ADDR
         L     R9,0(,R9)          => PARM LIST
         LA    R9,0(,R9)
         LGH   R15,0(,R9)         == parm length
*
         LTR   R15,R15
         JZ    A000109
*
         ST    R15,WKPLISTL       store it
         BCTR  R15,0
         LA    R1,2(,R9)          == parm value
         EXRL  R15,MVCPARM
*
         LA    R9,WKPARM          first sub parameter
         ST    R9,WKSUBPA1
         L     R1,WKPLISTL
         LR    R15,R9
A000102  EQU   *
         CLI   0(R9),C','
         JE    A000103
         LA    R9,1(,R9)
         BRCT  R1,A000102
*
         LR    R0,R9              no comma found, we're done
         SR    R0,R15
         ST    R0,WKSUBPL1
         J     A000109
*
A000103  EQU   *
         LR    R0,R9
         SR    R0,R15
         ST    R0,WKSUBPL1
*
         LA    R9,1(,R9)          account for 1st comma
         BCTR  R1,0
*
         ST    R9,WKSUBPA2
         LR    R15,R9
*
A000104  EQU   *
         CLI   0(R9),C','         next comma ?
         JE    A000105
         LA    R9,1(,R9)
         BRCT  R1,A000104
*
         LR    R0,R9              no comma found, we're done
         SR    R0,R15
         ST    R0,WKSUBPL2
         J     A000109
*
A000105  EQU   *
         LR    R0,R9
         SR    R0,R15
         ST    R0,WKSUBPL2
*
         LA    R9,1(,R9)          account for 2nd comma
         BCTR  R1,0
*
         LTR   R1,R1
         JZ    A000109
*
         ST    R9,WKSUBPA3
         LR    R15,R9
*
A000106  EQU   *
         CLI   0(R9),C','         there shouldn't be any more commas
         JE    A000108
         LA    R9,1(,R9)
         BRCT  R1,A000106
*
         LR    R0,R9              no comma found, we're done
         SR    R0,R15
         ST    R0,WKSUBPL3
         J     A000109
*
A000108  EQU   *
         wto 'too many sub parameters or commas'
         MVC   WKRETC,=F'12'
         J     DONE
A000109  EQU   *
*
*
*      OPEN MESSAGE FILE
         LA    R14,OUTFILE               COPY MODEL   DCB
D1       USING IHADCB,OUTDCB
         MVC   OUTDCB(OUTFILEL),0(R14)
         LAY   R0,OUTDCB                 SET  DCBE ADDRESS IN  DCB
         AGHI  R0,OUTFILE0
         STY   R0,D1.DCBDCBE
*
         MVC   WKPRINT,SPACES
         MVC   WKPRINT(32),=CL32'MDTEST: BEING EXECUTED WITH DD: '
         MVC   WKPRINT+32(8),D1.DCBDDNAM
*
         LAY   R2,OUTDCB
         MVC   WKREENT(8),OPENPARM
         OPEN  ((R2),(OUTPUT)),MODE=31,MF=(E,WKREENT)
         TM    D1.DCBOFLGS,DCBOFOPN      SUCCESSFULLY OPENED  ??
         JO    MAIN_100                  YES - BYPASS ABEND
         WTO 'MDTEST: DDPRINT OPEN FAILED'
         MVC   WKRETC,=F'8'
         J     DONEDONE
*
*                                                                @I1015
MAIN_100 EQU   *
         MVC   WKREFHLQ,SPACES
         MVC   WKFROMDT,SPACES
         MVC   WKUPSI,SPACES
*
*
         ICM   R1,B'1111',WKSUBPA1
         JZ    A00160
         L     R2,WKSUBPL1
         CLC   0(5,R1),=CL5'DATE='
         JNE   A0011
         JAS   R14,SUBDATE
A0011    EQU   *
         CLC   0(4,R1),=CL4'HLQ='
         JNE   A0012
         JAS   R14,SUBHLQ
A0012    EQU   *
         CLC   0(5,R1),=CL5'UPSI='
         JNE   A00120
         JAS   R14,SUBUPSI
A00120   EQU   *
*
         ICM   R1,B'1111',WKSUBPA2
         JZ    A00160
         L     R2,WKSUBPL2
         CLC   0(5,R1),=CL9'DATE='
         JNE   A0013
         JAS   R14,SUBDATE
A0013    EQU   *
         CLC   0(4,R1),=CL6'HLQ='
         JNE   A0014
         JAS   R14,SUBHLQ
A0014    EQU   *
         CLC   0(5,R1),=CL5'UPSI='
         JNE   A00140
         JAS   R14,SUBUPSI
A00140   EQU   *
*
         ICM   R1,B'1111',WKSUBPA3
         JZ    A00160
         L     R2,WKSUBPL3
         CLC   0(5,R1),=CL9'DATE='
         JNE   A0015
         JAS   R14,SUBDATE
A0015    EQU   *
         CLC   0(4,R1),=CL6'HLQ='
         JNE   A0016
         JAS   R14,SUBHLQ
A0016    EQU   *
         CLC   0(5,R1),=CL5'UPSI='
         JNE   A00160
         JAS   R14,SUBUPSI
A00160   EQU   *
*
*      DEFAULTS
         CLC   WKFROMDT,SPACES
         JNE   A00162
         MVC   WKFROMDT,=CL8'20200101'
A00162   EQU   *
         CLC   WKUPSI,SPACES
         JNE   A00163
         MVC   WKUPSI,=CL8'00000000'
A00163   EQU   *
*
*
         TM    WKUBYTE,PURGECSV
         JO    A00170
         LA    R2,OUTDCB
         LA    R0,WKPRINT
         PUT   (R2),(R0)
*
         MVC   WKPRINT,SPACES
         MVC   WKPRINT(21),=CL21'MDTEST: HLQ=         '
         MVC   WKPRINT+12(8),WKREFHLQ
         LA    R2,OUTDCB
         LA    R0,WKPRINT
         PUT   (R2),(R0)
         MVC   WKPRINT,SPACES
         MVC   WKPRINT(22),=CL22'MDTEST: DATE=         '
         MVC   WKPRINT+13(8),WKFROMDT
         LA    R2,OUTDCB
         LA    R0,WKPRINT
         PUT   (R2),(R0)
         MVC   WKPRINT,SPACES
         MVC   WKPRINT(22),=CL22'MDTEST: UPSI=         '
         MVC   WKPRINT+13(8),WKUPSI
         LA    R2,OUTDCB
         LA    R0,WKPRINT
         PUT   (R2),(R0)
A00170   EQU   *
*
**       XR    R0,R0
**       IC    R0,WKUBYTE
**       DC H'0'
*
*        OBTAIN JULIAN DATE FROM VALUE
*
         XC    WORKDTEG,WORKDTEG
         PACK  DBLWORK(5),WKFROMDT(8)
         LG    R0,DBLWORK
         SLLG  R0,R0,4
*        DC H'0'
         STMH  R0,R0,WORKDATG
         LA    R3,WORKDTEG
         LA    R4,STCKAREA
         CONVTOD CONVVAL=(3),TODVAL=(4),TIMETYPE=BIN,DATETYPE=YYYYMMDD,+
               MF=(E,WKREENT)
         LTR   R15,R15
         JZ    A0010
         C     R15,=F'20'
         JNE   A0009
         WTO 'Invalid date value provided for input (invalid YYYYMMDD)'
         MVC   WKRETC,=F'20'
         J     DONE
A0009    EQU   *
         DC    H'0'
A0010    EQU   *
*
*
         STCKCONV STCKVAL=STCKAREA,CONVVAL=WORKDTEJ,TIMETYPE=BIN,      +
               DATETYPE=YYYYDDD,MF=(E,CONV_MFL)
*
         L     R0,WORKDATJ
         SLL   R0,4
         O     R0,=XL4'0000000F'
         ST    R0,WKREFDAT
*        DC H'0'
*
*
*
*      OPEN DCOLLECT INPUT FILE
         LA    R14,INFILE                COPY MODEL   DCB
D2       USING IHADCB,INDCB
         MVC   INDCB(INFILEL),0(R14)
         LAY   R0,INDCB                  SET  DCBE ADDRESS IN  DCB
         AGHI  R0,INFILE0
         STY   R0,D2.DCBDCBE
*
         LAY   R2,INDCB
         MVC   WKREENT(8),OPENPARM
         OPEN  ((R2),(INPUT)),MODE=31,MF=(E,WKREENT)
         TM    D2.DCBOFLGS,DCBOFOPN      SUCCESSFULLY OPENED  ??
         JO    A0098                     YES - BYPASS ABEND
         WTO 'MDTEST: DDINPUT OPEN FAILED'
         MVC   WKRETC,=F'8'
         J     A0191
*
*
*      OPEN IDCAMS DELETE FILE CREATED
A0098    EQU   *
         TM    WKUBYTE,PURGEFIL
         JNO   A0100
         MVC   WKDELLIN,SPACES
         MVC   WKDELETE,=CL6'DELETE'
         MVC   WKPURGE,=CL5'PURGE'
         LA    R14,DELFILE               COPY MODEL   DCB
D3       USING IHADCB,DELDCB
         MVC   DELDCB(DELFILEL),0(R14)
         LAY   R0,DELDCB                 SET  DCBE ADDRESS IN  DCB
         AGHI  R0,DELFILE0
         STY   R0,D3.DCBDCBE
*
         LAY   R2,DELDCB
         MVC   WKREENT(8),OPENPARM
         OPEN  ((R2),(OUTPUT)),MODE=31,MF=(E,WKREENT)
         TM    D3.DCBOFLGS,DCBOFOPN      SUCCESSFULLY OPENED  ??
         JO    A0100                     YES - BYPASS ABEND
         WTO 'MDTEST: DDDELETE OPEN FAILED'
         MVC   WKRETC,=F'8'
         J     DONE010
*
*
A0100    EQU   *
         MVC   WKPRINT,SPACES
*
         TM    WKUBYTE,PURGECSV
         JNO   A00172
         MVI   WKTYPE+1,C','             IF IT'S GOING TO BE CSV FILE
         MVI   WKCSV02,C','
         MVI   WKCSV03,C','
         MVI   WKCSV04,C','
         MVI   WKCSV05,C','
         MVI   WKCSV06,C','
         MVI   WKCSV07,C','
         MVI   WKCSV08,C','
         J     A00174
*
A00172   EQU   *
*      ECHO DDNAME
         LA    R2,OUTDCB
         LA    R0,WKPRINT
         PUT   (R2),(R0)
*
         MVC   WKTYPE-3(4),=C'TYPE'
         MVC   WKNAME(7),=C'DATASET'
         MVC   WKGDS-2(3),=C'GDG'
         MVC   WKVSAM(3),=C'ORG'
         MVC   WKRECFM(5),=C'RECFM'
         MVC   WKLRECL+3(5),=C'LRECL'
         MVC   WKLBLKL+3(5),=C'BLKSZ'
         MVC   WKLEVEL(3),=C'MIG'
         MVC   WKRDAT+1(5),=C'JDATE'
         LA    R2,OUTDCB
         LA    R0,WKPRINT
         PUT   (R2),(R0)
*
         MVC   WKPRINT,SPACES
         MVC   WKTYPE-3(4),=C'   ='
         MVC   WKNAME(44),=C'==========================================+
                =='
         MVC   WKGDS-2(3),=C'==='
         MVC   WKVSAM(3),=C'==='
         MVC   WKRECFM(5),=C'====='
         MVC   WKLRECL+3(5),=C'====='
         MVC   WKLBLKL+3(5),=C'====='
         MVC   WKLEVEL(4),=C'===='
         MVC   WKRDAT+1(7),=C'======='
         LA    R2,OUTDCB
         LA    R0,WKPRINT
         PUT   (R2),(R0)
*
         MVC   WKPRINT,SPACES
A00174   EQU   *
         XR    R7,R7
         XR    R8,R8
         LAY   R4,DRECORD+4
         USING DCUOUTH,R4
A0110    EQU   *                       --LOOP FOR ALL RECORDS
         GET   INDCB,DRECORD
         CLC   DCURCTYP,=CL2'M '         IF IT'S A MIG RECORD
         JNE   A0180
*        CLC   UMDSNAM(5),=CL5'GEBT.'
         CLC   UMDSNAM(5),WKREFHLQ       IF HLQ IS A MATCH THEN
         JNE   A0180
         LA    R8,1(,R8)
         LLGT  R0,UMLRFDT
         C     R0,WKREFDAT               IF BEFORE REF DATE THEN
         JNL   A0180
         MVC   WKNAME,UMDSNAM
         MVC   WKTYPE,DCURCTYP
         STG   R0,DBLWORK
         OI    DBLWORK+L'DBLWORK-1,X'0F'
         MVC   DBLWORK2,NUMMASK
         ED    DBLWORK2,DBLWORK+4
         MVC   WKRDAT,DBLWORK2    (8)
*
         MVC   WKVSAM,=CL4'    ' THIS DOES WKDSORG AND WKDSORG2 ALSO
         TM    UMDSORG,DCBDSGIS
         JNO   A011010
         MVC   WKDSORG,=CL2'IS'
A011010  EQU   *
         TM    UMDSORG,DCBDSGPS
         JNO   A011012
         MVC   WKDSORG,=CL2'PS'
A011012  EQU   *
         TM    UMDSORG,DCBDSGDA
         JNO   A011014
         MVC   WKDSORG,=CL2'DA'
A011014  EQU   *
         TM    UMDSORG,DCBDSGCX
         JNO   A011016
         MVC   WKDSORG,=CL2'CX'
A011016  EQU   *
         TM    UMDSORG,DCBDSGPO
         JNO   A011018
         MVC   WKDSORG,=CL2'PO'
A011018  EQU   *
         TM    UMDSORG,DCBDSGU
         JNO   A011019
         MVC   WKDSORG,=CL2'UM'
A011019  EQU   *
*
         MVC   WKLEVEL,=CL4'    '
         TM    UMFLAG1,X'80'
         JNO   A011020
         MVC   WKLEVEL,=CL4'MIG2'
         J     A011022
A011020  EQU   *
         TM    UMFLAG1,X'40'
         JNO   A011021
         MVC   WKLEVEL,=CL4'MIG1'
         J     A011022
A011021  EQU   *
         MVC   WKLEVEL,=CL4'----'
A011022  EQU   *
*
         MVI   WKRECFM,C' '
         MVI   WKRECFM2,C' '
         TM    UMRECRD,DCBRECU
         JNO   A011030
         MVI   WKRECFM,C'U'
         J     A011033
A011030  EQU   *
         TM    UMRECRD,DCBRECF
         JNO   A011031
         MVI   WKRECFM,C'F'
         J     A011032
A011031  EQU   *
         TM    UMRECRD,DCBRECV
         JNO   A011032
         MVI   WKRECFM,C'V'
A011032  EQU   *
         TM    UMRECRD,DCBRECBR
         JNO   A011033
         MVI   WKRECFM2,C'B'
A011033  EQU   *
*
         TM    UMFLAG2,UMPDSE
         JNO   A011034
         MVI   WKDSORG2,C'E'
A011034  EQU   *
*
         MVI   WKGDS,C' '
         TM    UMFLAG2,UMGDS
         JNO   A011035
         MVI   WKGDS,C'G'
A011035  EQU   *
*
         TM    UMRECOR,UMESDS
         JNO   A011040
         MVC   WKVSAM,=CL4'ESDS'
         J     A011043
A011040  EQU   *
         TM    UMRECOR,UMKSDS
         JNO   A011041
         MVC   WKVSAM,=CL4'KSDS'
         J     A011043
A011041  EQU   *
         TM    UMRECOR,UMLDS
         JNO   A011042
         MVC   WKVSAM,=CL4'LDS '
         J     A011043
A011042  EQU   *
         TM    UMRECOR,UMRRDS
         JNO   A011043
         MVC   WKVSAM,=CL4'RRDS'
A011043  EQU   *
*
         L     R0,UMLRECL
         CVD   R0,DBLWORK
         OI    DBLWORK+L'DBLWORK-1,X'0F'
         MVC   DBLWORK2,NUMMASK
         ED    DBLWORK2,DBLWORK+4
         MVC   WKLRECL,DBLWORK2    (8)
         LH    R0,UMBKLNG
         CVD   R0,DBLWORK
         OI    DBLWORK+L'DBLWORK-1,X'0F'
         MVC   DBLWORK2,NUMMASK
         ED    DBLWORK2,DBLWORK+4
         MVC   WKLBLKL,DBLWORK2    (8)
*
         LA    R2,OUTDCB
         LA    R0,WKPRINT
         PUT   (R2),(R0)
*
         TM    WKUBYTE,PURGEFIL
         JNO   A0170
         MVC   WKDELNAM,UMDSNAM
         LA    R2,DELDCB
         LA    R0,WKDELLIN
         PUT   (R2),(R0)
A0170    EQU   *
*
         LA    R7,1(,R7)          KEEP A COUNT
A0180    EQU   *
*        DC H'0'
         J     A0110                   --END OF READ LOOP
A0190    EQU   *
         ST    R7,WKSELCT
         ST    R8,WKACTCT
*
         TM    WKUBYTE,PURGEFIL
         JNO   DONE010
         TM    D3.DCBOFLGS,DCBOFOPN      SUCCESSFULLY OPENED  ??
         JNO   DONERET                   NO - BYPASS CLOSE
         LAY   R2,DELDCB
         MVC   WKREENT(8),OPENPARM
         CLOSE ((R2)),MODE=31,MF=(E,WKREENT)
*
DONE010  EQU   *
         LAY   R2,INDCB
         CLOSE ((R2)),MODE=31,MF=(E,WKREENT)
*
*
A0191    EQU   *
         TM    WKUBYTE,PURGECSV
         JO    A0192
         MVC   WKPRINT,SPACES
         LA    R2,OUTDCB
         LA    R0,WKPRINT
         PUT   (R2),(R0)
*
         MVC   WKPRINT(85),=CL85'MDTEST: SELECTED XXXXXXX OUT OF XXXXXX+
               X TYPE M RECORDS LAST REFRENCED BEFORE: XXXXXXXX'
         L     R7,WKSELCT
         CVD   R7,DBLWORK
         OI    DBLWORK+L'DBLWORK-1,X'0F'
         MVC   DBLWORK2,NUMMASK
         ED    DBLWORK2,DBLWORK+4
         MVC   WKPRINT+16(8),DBLWORK2 (61)
         L     R8,WKACTCT
         CVD   R8,DBLWORK
         OI    DBLWORK+L'DBLWORK-1,X'0F'
         MVC   DBLWORK2,NUMMASK
         ED    DBLWORK2,DBLWORK+4
         MVC   WKPRINT+31(8),DBLWORK2 (61)
         MVC   WKPRINT+78(8),WKFROMDT
         LA    R2,OUTDCB
         LA    R0,WKPRINT
         PUT   (R2),(R0)
*
*
         MVC   WKPRINT,SPACES
         MVC   WKPRINT(8),=CL8'MDTEST: '
         MVC   WKPRINT+8(09),=CL9'COMPLETED'
         LA    R2,OUTDCB
         LA    R0,WKPRINT
         PUT   (R2),(R0)
A0192    EQU   *
*        J     DONE
*
*        RETURN TO CALLER
*
DONE     EQU   *                         RETURN TO CALLER
         LAY   R2,OUTDCB
         MVC   WKREENT(8),OPENPARM
         CLOSE ((R2)),MODE=31,MF=(E,WKREENT)
*
DONEDONE EQU   *                         RETURN TO CALLER
         L     R13,SAVEAREA+4            CALLER'S SAVE AREA ADDRESS
         L     R15,WKRETC
         ST    R15,16(,R13)
         STORAGE RELEASE,ADDR=(R11),LENGTH=DYNLEN
*
DONERET  EQU   *
         LM    R14,R12,12(R13)           POP REGISTERS
         BR    R14                       RETURN TO CALLER
*
*
*
*              R1 => PARAMETER; R2=> LENGTH
SUBHLQ   DS    0H
         stm   R14,R12,12(r13)
         la    r0,sva2
         st    r13,sva2+4
         st    r0,8(,r13)
         lr    r13,r0
*
         CLC   0(4,R1),=CL4'HLQ='
         JNE   B00016
         AGHI  R2,-4
         BCTR  R2,0
         LA    R14,WKREFHLQ
         LA    R1,4(,R1)
         EX    R2,MVCR14R1
B00016   EQU   *
*
         l     r13,sva2+4
         lm    r14,r12,12(r13)
         BR    R14
*
*
*
*
*              R1 => PARAMETER; R2=> LENGTH
SUBDATE  DS    0H
         stm   R14,R12,12(r13)
         la    r0,sva2
         st    r13,sva2+4
         st    r0,8(,r13)
         lr    r13,r0
*
         CLC   0(5,R1),=CL5'DATE='
         JNE   C00016
         AGHI  R2,-5
         C     R2,=F'8'          MUST BE YYYYMMDD (LENGTH 8)
         JE    C00010
         WTO 'REFERENCE DATE MUST BE YYYYMMDD'
         J     C00016
C00010   EQU   *
         BCTR  R2,0
         LA    R14,WKFROMDT
         LA    R1,5(,R1)
         EX    R2,MVCR14R1
         LA    R15,8
         LA    R1,WKFROMDT
C00012   EQU   *
         CLI   0(R1),C'0'
         JL    C00014
         CLI   0(R1),C'9'
         JH    C00014
         LA    R1,1(,R1)
         BRCT  R15,C00012
         J     C00016
C00014   EQU   *
         XC    WKFROMDT,WKFROMDT
         WTO 'DATE MUST CONTAIN NUMBERS'
C00016   EQU   *
*
         l     r13,sva2+4
         lm    r14,r12,12(r13)
         BR    R14
*
*
*
*
*              R1 => PARAMETER; R2=> LENGTH
SUBUPSI  DS    0H
         stm   R14,R12,12(r13)
         la    r0,sva2
         st    r13,sva2+4
         st    r0,8(,r13)
         lr    r13,r0
*
         CLC   0(5,R1),=CL5'UPSI='
         JNE   U00016
         AGHI  R2,-5
         C     R2,=F'8'          UPSI MUST BE BBBBBBBB (LENGTH 8)
         JE    U00010
         WTO 'UPSI MUST BE BBBBBBBB (8 BITS)'
         J     U00016
U00010   EQU   *
         BCTR  R2,0
         LA    R14,WKUPSI
         LA    R1,5(,R1)
         EX    R2,MVCR14R1
         LA    R15,8
*        LA    R1,WKUPSI
         LA    R1,WKUPSI+7
         LA    R3,1
U00012   EQU   *
         CLI   0(R1),C'0'
         JL    U00014
         CLI   0(R1),C'1'
         JH    U00014
         CLI   0(R1),C'1'
         JNE   U00013
         EX    R3,VAROI
*        DC H'0'
U00013   EQU   *
         SLL   R3,1
*        LA    R1,1(,R1)
         BCTR  R1,0
         BRCT  R15,U00012
         J     U00016
*
U00014   EQU   *
         XC    WKUPSI,WKUPSI
         XC    WKUBYTE,WKUBYTE
         WTO 'UPSI MUST CONTAIN NUMBERS ZERO AND ONE'
U00016   EQU   *
*
         l     r13,sva2+4
         lm    r14,r12,12(r13)
         BR    R14
*
*        STATICS
*
static   loctr ,
*
         DS    0D
VAROI    OI    WKUBYTE,X'00'      * * * * E X E C U T E D * * * *
         DS    0D
MVCR14R1 MVC   0(0,R14),0(R1)     * * * * E X E C U T E D * * * *
         DS    0D
CLCR1R14 CLC   0(0,R1),0(R14)     * * * * E X E C U T E D * * * *
         DS    0D
MVCPARM  MVC   WKPARM(0),0(R1)    EXECUTED <<< <<< <<< <<<
*
*        CONSTANTS
*
H1       DC    H'1'
H4       DC    H'4'
H255     DC    H'255'
F04      DC    F'04'
F40      DC    F'40'
F4096    DC    F'4096'
*
*
         DS   0D
MODE31   EQU   X'8000'
         DS   0D
OPENPARM DC    XL8'8000000000000000'
*
OUTFILE  DCB   DSORG=PS,DDNAME=DDPRINT,MACRF=(PM),DCBE=OUTFDCBE,       X
               RECFM=FB,LRECL=131
OUTFILE0 EQU   *-OUTFILE
OUTFDCBE DCBE  RMODE31=BUFF
OUTFILEL EQU   *-OUTFILE
*
DELFILE  DCB   DSORG=PS,DDNAME=DDDELETE,MACRF=(PM),DCBE=DELFDCBE,      X
               RECFM=FB,LRECL=80
DELFILE0 EQU   *-DELFILE
DELFDCBE DCBE  RMODE31=BUFF
DELFILEL EQU   *-DELFILE
*
*
INFILE   DCB   DSORG=PS,DDNAME=DDINPUT,MACRF=(GM),DCBE=INFDCBE,        X
               RECFM=VB,LRECL=27994
INFILE0  EQU   *-INFILE
INFDCBE  DCBE  RMODE31=BUFF,EODAD=A0190
INFILEL  EQU   *-INFILE
*
*
SPACES   DC    CL256' '
*
         LTORG ,
*
NUMMSK   DC    XL12'402020202020202020202021'
NUMMASK  DC    XL08'4020202020202120'
PATTERN  DC X'202020202020202020202020202020 '
ZEROES   DC    80XL1'00'
*
         DS   0F
         DCBD  DSORG=PS
*
         IHADCBE
*
JFCBAR   DSECT
         IEFJFCBN LIST=YES
*
         CVT   DSECT=YES
*
         IHAPSA
*
         END
