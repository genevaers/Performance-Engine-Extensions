********************************************************************#VB
*
* (C) COPYRIGHT IBM CORPORATION 2021.
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
        TITLE 'GVBDTGEN - GENERATE TEST DATA'
***********************************************************************
*                                                                     *
*  MODULE DESCRIPTION     : TEST PURPOSES ONLY                        *
*                                                                     *
***********************************************************************
*
***********************************************************************
*                                                                     *
*           MODULE RETURN CODES AND REGISTER DOCUMENTATION            *
*                                                                     *
***********************************************************************
*                                                                     *
*  RETURN CODES:                                                      *
*                                                                     *
*          0   - SUCCESSFUL                                           *
*          4   - WARNING                                              *
*          8   - ERROR                                                *
*         12   - SEVERE ERROR                                         *
*         16   - CATASTROPHIC FAILURE                                 *
*                                                                     *
***********************************************************************
*
                        EJECT
         IHASAVER DSECT=YES,SAVER=YES,SAVF4SA=YES,SAVF5SA=YES,TITLE=NO
*
***********************************************************************
*                                                                     *
*        "GVBDTGEN"   W O R K   A R E A                               *
*                                                                     *
***********************************************************************
*
WORKAREA DSECT
WKSAVE1  DS    18F
WKSAVE2  DS    18F
WKSUBPA1 DS    A
WKSUBPA2 DS    A
WKSUBPA3 DS    A
WKSUBPA4 DS    A
WKSUBPL1 DS    F
WKSUBPL2 DS    F
WKSUBPL3 DS    F
WKSUBPL4 DS    F
WKMAXORD DS    F
WKDYMULT DS    H
         DS    H
WKCURORD DS    F
WKTEMPSV DS    D
WKPARM   DS    CL100
WKREENT  DS    XL128              RE-ENTRANT  PARAMETER  LIST
CUSTREC  DS    CL80
ORDTREC  DS    CL47
WKPART   DS    CL01
ITMTREC  DS    CL36
PRDTREC  DS    CL23
         DS    CL01
DSCTREC  DS    CL40
ADDRREC  DS    CL103
         DS    0F
WKORDER# DS    F
WKORDIT# DS    F
WKCUSTM# DS    F
WKPRODT# DS    F
WKSTORE# DS    F
WKCNAMA  DS    A
WKCNAMN  DS    F
WKCNAML  DS    F
WKCNA1A  DS    A
WKDATCR  DS    A                  rotating pointer became customer
WKDATBR  DS    A                  rotating pointer date of birth
WKROBINP DS    A                  rotating order item DCB part. list
WKROBIND DS    4A                 rotating DCB list order item file
WKYEARP  DS    A                  pointer of year
WKMONP   DS    A                  pointer of mon
WKDAYP   DS    A                  pointer of day
WKPRODP  DS    A                  pointer of product
WKADDRP  DS    A                  pointer to street name
WKADR1P  DS    A                  pointer to house number
WKADR2P  DS    A                  pointer to apartment number
WKADR3P  DS    A                  pointer to city, state zip
WKITMQP  DS    A                  pointer to quantity of order items
WKORDNUM DS    F                  current order number
WKORDIN  DS    H                  current order item number
WKCSTSEQ DS    C
WKSOD    DS    C
WKPLISTA DS    A
WKPLISTL DS    F
WKORDDAT DS    CL8
WKDDDJ   DS    PL4
WKPRICE  DS    PL6
WKDISC   DS    PL6
WKQTYP   DS    PL2
WKPL6    DS    PL6
WKDBL1   DS    D
WKDBL2   DS    D
WKDBL3   DS    D
WKTEMP   DS    CL80
WKTEM2   DS    CL80
CSTDCB   DS    (CSTFILEL)C        Customer     "DCB"
CNADCB   DS    (CNAFILEL)C        Custname     "DCB"
ORDDCB   DS    (ORDFILEL)C        Order        "DCB"
ITMDCB   DS    (ITMFILEL)C        Order Item   "DCB" ORDITM01
ITMDCB2  DS    (ITMFILEL)C        Order Item   "DCB" ORDITM02
ITMDCB3  DS    (ITMFILEL)C        Order Item   "DCB" ORDITM03
PRDDCB   DS    (PRDFILEL)C        Product      "DCB"
DSCDCB   DS    (DSCFILEL)C        Product Desc "DCB"
ADRDCB   DS    (ADRFILEL)C        Address      "DCB"
STRDCB   DS    (STRFILEL)C        Store Address"DCB"
OUTDCB   DS    XL(outfilel)    Reentrant DCB and DCBE areas
*
*
WKTOKNRC DS    A                  NAME/TOKEN  SERVICES RETURN CODE
WKTOKNAM DS    XL16               TOKEN NAME
WKTOKN   DS    XL16               TOKEN
REENTWK  DS    XL128              RE-ENTRANT PARAMETER   LIST
WKPRINT  DS    CL131
WORKLEN  EQU   (*-WORKAREA)
*
* DC    CL10'0000006789',PL6'1250',PL6'52',CL30'sun glasses'
PRDDATA  DSECT                    product data
PRDID    DS    CL10
PRDCDE   DS    CL3
PRDPRICE DS    PL6
PRDDISC  DS    PL6
PRDDESC  DS    CL30
PRDDATAL EQU   (*-PRDDATA)
*
FIRSTNM  DSECT                    first/middle name table and gender
FIRSTGEN DS    CL1
FIRSTNAM DS    CL20
FIRSTNML EQU   (*-FIRSTNM)
*
SECNAM   DSECT                    last name table
SECNAME  DS    CL20
SECNAML  EQU   (*-SECNAM)
*
MIDNAM   DSECT                    last middle table
MIDNAME  DS    CL20
MIDNAML  EQU   (*-MIDNAM)
*
DOBTAB   DSECT                    date of birth table
DOBDATE  DS    CL8
DOBTABL  EQU   (*-DOBTAB)
*
DOCTAB   DSECT                    date became customer table
DOCDATE  DS    CL8
DOCTABL  EQU   (*-DOCTAB)
*
CUSTMER  DSECT
CUSTID   DS    CL10
CUSTGEN  DS    CL1
CUSTDOB  DS    CL8
CUSTWHEN DS    CL8
CUSTPHON DS    CL10
CUSTCCDE DS    CL1
CUSTEMAI DS    CL40
CUSTMERL EQU   (*-CUSTMER)
*
CUADR    DSECT
CUADRID  DS    CL10
CUADRAI  DS    CL10
CUADRL1  DS    CL20
CUADRL2  DS    CL20
CUADRL3  DS    CL20
CUADRST  DS    CL2
CUADRZP  DS    CL5
CUADRDS  DS    CL8
CUADRDE  DS    CL8
CUADRL   EQU   (*-CUADR)
*
CNAME    DSECT
CNAMCID  DS    CL10
CNAMID   DS    CL10
CNAM1ST  DS    CL20
CNAMMID  DS    CL20
CNAMLST  DS    CL20
CNAMSEF  DS    CL8
CNAMEEF  DS    CL8
CNAMGEN  DS    CL1     not in this output record gender
CNAMSAME DS    CL1     not in this output record X(start seq), Y(cont)
CNAMDOB  DS    CL8     not in this output record date of birth
CNAMSEFO DS    CL8     not in this output record original start date
CNAMODUP DS    XL4     not in this output record offset when dup sort
CNAMOPAR DS    XL4     not in this output record offset parent record
CNAMPARO DS    XL4     not in this output record parent record offset
CNAMST   DS    CL2     not in this output record
CNAMEL   EQU   (*-CNAME)
*
ORDER    DSECT
ORDID    DS    CL10
ORDCID   DS    CL10
ORDSTOR  DS    CL3
ORDDATE  DS    CL8
ORDAMT   DS    PL6
ORDREB   DS    PL6
ORDDATJ  DS    PL4
ORDERL   EQU   (*-ORDER)
*
ORDI     DSECT
ORDIID   DS    CL10
ORDINUM  DS    H
ORDIPRD  DS    CL10
ORDIQTY  DS    H
ORDIPRC  DS    PL6
ORDIDSC  DS    PL6
ORDIL    EQU   (*-ORDI)
*
PRDI     DSECT
PRDIID   DS    CL10
PRDPIDM  DS    CL10
PRDTCDE  DS    CL3
PRDIL    EQU   (*-PRDI)
*
DSCI     DSECT
DSCPID   DS    CL10
DSCPDSC  DS    CL30
DSCIL    EQU   (*-DSCI)
*
***********************************************************************
*                                                                     *
*        REGISTER EQUATES:                                            *
*                                                                     *
***********************************************************************
*
         YREGS
*
GVBDTGEN CSECT
         j     code
GVBDTGEN RMODE 24
GVBDTGEN AMODE 31
         SYSSTATE ARCHLVL=2,amode64=NO
static   loctr
code     loctr
         stm   R14,R12,12(r13)      save callers registers GVBMR95

         llgtr r0,r0              CLEAN
         llgtr r1,r1
         llgtr r2,r2
         llgtr r3,r3
         llgtr r4,r4
         llgtr r5,r5
         llgtr r6,r6
         llgtr r7,r7
         llgtr r8,r8
         llgtr r9,r9
         llgtr r10,r10
         llgtr r11,r11
         llgtr r12,r12
         llgtr r13,r13
         llgtr r14,r14
         llgtr r15,r15
*
         larl  R12,gvbdtgen       SET   PROGRAM   BASE REGISTERS
         using (gvbdtgen,code),r12
*
         lr    r9,r1              LOAD  PARAMETER LIST ADDRESS

         l     R0,=A(WORKLEN+8)   LOAD   WORK AREA SIZE
         STORAGE OBTAIN,LENGTH=(0),LOC=(24)   GET WORKAREA
*
         MVC   0(8,r1),=CL8'GVBDTGEN'
         lr    r8,r1
         la    r8,8(,r8)          move pointer past
*
         LR    R0,R8
         L     R1,=A(WORKLEN)
         XR    R14,R14
         XR    R15,R15
         MVCL  R0,R14
*
         USING WORKAREA,R8
         ST    R13,WKSAVE1+4      previous save area
         LA    R0,WKSAVE1
         ST    R0,8(,R13)         next save area
         LR    R13,R0             now current save area
         xc    WKREENT,WKREENT
         lay   R1,SPACES
         mvc   WKPARM,0(R1)
*
MAINLINE ds    0h
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
         LA    R0,WKPARM
         J     A00010
*
MVCPARM  MVC   WKPARM(0),0(R1)    EXECUTED <<< <<< <<< <<<
*
A00010   EQU   *
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
         J     RETURN8
A000109  EQU   *
*
         MVI   WKPART,C' '        Default partitioning
         MVC   WKDYMULT,=H'1'             daily multiplier
         MVC   WKMAXORD,=F'999999999'     max order (theoretical), as
*                                         it depends on the data tables
         L     R1,WKSUBPA1
         L     R2,WKSUBPL1
         CLC   0(9,R1),=CL9'PARTITION'
         JNE   A0011
         JAS   R14,SUBPART
A0011    EQU   *
         CLC   0(6,R1),=CL6'ORDERS'
         JNE   A0012
         JAS   R14,SUBORDS
A0012    EQU   *
         CLC   0(6,R1),=CL6'DYMULT'
         JNE   A00120
         JAS   R14,SUBMULT
A00120   EQU   *
*
         L     R1,WKSUBPA2
         L     R2,WKSUBPL2
         CLC   0(9,R1),=CL9'PARTITION'
         JNE   A0013
         JAS   R14,SUBPART
A0013    EQU   *
         CLC   0(6,R1),=CL6'ORDERS'
         JNE   A0014
         JAS   R14,SUBORDS
A0014    EQU   *
         CLC   0(6,R1),=CL6'DYMULT'
         JNE   A00140
         JAS   R14,SUBMULT
A00140   EQU   *
*
         L     R1,WKSUBPA3
         L     R2,WKSUBPL3
         CLC   0(9,R1),=CL9'PARTITION'
         JNE   A0015
         JAS   R14,SUBPART
A0015    EQU   *
         CLC   0(6,R1),=CL6'ORDERS'
         JNE   A0016
         JAS   R14,SUBORDS
A0016    EQU   *
         CLC   0(6,R1),=CL6'DYMULT'
         JNE   A00160
         JAS   R14,SUBMULT
A00160   EQU   *
*
         LAY   R14,CSTFILE        CUSTOMER FILE
         MVC   CSTDCB(CSTFILEL),0(R14)
         LAY   R0,CSTDCB+CSTEOFF
         ST    R0,CSTDCB+DCBDCBE-IHADCB
*
         LAY   R14,STATOPEN
         MVC   WKREENT(STATOPENL),0(R14)
         OPEN  (CSTDCB,OUTPUT),MODE=31,MF=(E,WKREENT)
         TM    CSTDCB+48,X'10'    SUCCESSFUL  OPEN ???
         JO    A0044                                  N
         wto 'open customer file failed'
         J     RETURN8
*
A0044    EQU   *
         LAY   R14,CNAFILE       CUSTOMER NAME FILE
         MVC   CNADCB(CNAFILEL),0(R14)
         LAY   R0,CNADCB+CNAEOFF
         ST    R0,CNADCB+DCBDCBE-IHADCB
*
         LAY   R14,STATOPEN
         MVC   WKREENT(STATOPENL),0(R14)
         OPEN  (CNADCB,OUTPUT),MODE=31,MF=(E,WKREENT)
         TM    CNADCB+48,X'10'    SUCCESSFUL  OPEN ???
         JO    A0045                                  N
         wto 'open customer name file failed'
         J     RETURN8
*
A0045    EQU   *
         LAY   R14,ORDFILE       ORDER FILE
         MVC   ORDDCB(ORDFILEL),0(R14)
         LAY   R0,ORDDCB+ORDEOFF
         ST    R0,ORDDCB+DCBDCBE-IHADCB
*
         LAY   R14,STATOPEN
         MVC   WKREENT(STATOPENL),0(R14)
         OPEN  (ORDDCB,OUTPUT),MODE=31,MF=(E,WKREENT)
         TM    ORDDCB+48,X'10'    SUCCESSFUL  OPEN ???
         JO    A00450                                 N
         wto 'open order name failed'
         J     RETURN8
*
A00450   EQU   *
         LAY   R14,ITMFILE       ORDER ITEM FILE1
         MVC   ITMDCB(ITMFILEL),0(R14)
         LAY   R0,ITMDCB+ITMEOFF
         ST    R0,ITMDCB+DCBDCBE-IHADCB
*
         LAY   R14,STATOPEN
         MVC   WKREENT(STATOPENL),0(R14)
         OPEN  (ITMDCB,OUTPUT),MODE=31,MF=(E,WKREENT)
         TM    ORDDCB+48,X'10'   SUCCESSFUL  OPEN ???
         JO    A00451A                                N
         wto 'open order item 01 file failed'
         J     RETURN8
*
A00451A  EQU   *
         CLI   WKPART,C' '       Partition Order Items ?
         JE    A00451
         LAY   R14,ITMFILE       ORDER ITEM FILE2
         MVC   ITMDCB2(ITMFILEL),0(R14)
         LAY   R0,ITMDCB2+ITMEOFF
         ST    R0,ITMDCB2+DCBDCBE-IHADCB
         MVC   ITMDCB2+DCBDDNAM-IHADCB+6(2),=CL2'02'
*
         LAY   R14,STATOPEN
         MVC   WKREENT(STATOPENL),0(R14)
         OPEN  (ITMDCB2,OUTPUT),MODE=31,MF=(E,WKREENT)
         TM    ORDDCB+48,X'10'   SUCCESSFUL  OPEN ???
         JO    A00451B                                N
         wto 'open order item 02 file failed'
         J     RETURN8
*
A00451B  EQU   *
         LAY   R14,ITMFILE       ORDER ITEM FILE3
         MVC   ITMDCB3(ITMFILEL),0(R14)
         LAY   R0,ITMDCB3+ITMEOFF
         ST    R0,ITMDCB3+DCBDCBE-IHADCB
         MVC   ITMDCB3+DCBDDNAM-IHADCB+6(2),=CL2'03'
*
         LAY   R14,STATOPEN
         MVC   WKREENT(STATOPENL),0(R14)
         OPEN  (ITMDCB3,OUTPUT),MODE=31,MF=(E,WKREENT)
         TM    ORDDCB+48,X'10'   SUCCESSFUL  OPEN ???
         JO    A00451                                 N
         wto 'open order item 03 file failed'
         J     RETURN8
*
A00451   EQU   *
         LAY   R14,PRDFILE       PRODUCT FILE
         MVC   PRDDCB(PRDFILEL),0(R14)
         LAY   R0,PRDDCB+PRDEOFF
         ST    R0,PRDDCB+DCBDCBE-IHADCB
*
         LAY   R14,STATOPEN
         MVC   WKREENT(STATOPENL),0(R14)
         OPEN  (PRDDCB,OUTPUT),MODE=31,MF=(E,WKREENT)
         TM    PRDDCB+48,X'10'   SUCCESSFUL  OPEN ???
         JO    A00452                                 N
         wto 'open product file failed'
         J     RETURN8
*
A00452   EQU   *
         LAY   R14,DSCFILE       PRODUCT DESCRIPTION FILE
         MVC   DSCDCB(DSCFILEL),0(R14)
         LAY   R0,DSCDCB+DSCEOFF
         ST    R0,DSCDCB+DCBDCBE-IHADCB
*
         LAY   R14,STATOPEN
         MVC   WKREENT(STATOPENL),0(R14)
         OPEN  (DSCDCB,OUTPUT),MODE=31,MF=(E,WKREENT)
         TM    DSCDCB+48,X'10'    SUCCESSFUL  OPEN ???
         JO    A00454                                 N
         wto 'open product description file failed'
         J     RETURN8
*
A00454   EQU   *
         LAY   R14,ADRFILE       CUSTOMER ADDRESS FILE
         MVC   ADRDCB(ADRFILEL),0(R14)
         LAY   R0,ADRDCB+ADREOFF
         ST    R0,ADRDCB+DCBDCBE-IHADCB
*
         LAY   R14,STATOPEN
         MVC   WKREENT(STATOPENL),0(R14)
         OPEN  (ADRDCB,OUTPUT),MODE=31,MF=(E,WKREENT)
         TM    ADRDCB+48,X'10'    SUCCESSFUL  OPEN ???
         JO    A00455                                 N
         wto 'open customer address file failed'
         J     RETURN8
*
A00455   EQU   *
         LAY   R14,STRFILE       CUSTOMER ADDRESS FILE
         MVC   STRDCB(STRFILEL),0(R14)
         LAY   R0,STRDCB+STREOFF
         ST    R0,STRDCB+DCBDCBE-IHADCB
*
         LAY   R14,STATOPEN
         MVC   WKREENT(STATOPENL),0(R14)
         OPEN  (STRDCB,OUTPUT),MODE=31,MF=(E,WKREENT)
         TM    STRDCB+48,X'10'    SUCCESSFUL  OPEN ???
         JO    A0046                                  N
         wto 'open store address file failed'
         J     RETURN8
*
A0046    EQU   *
*      open message file
         LAY   R14,outfile               COPY MODEL   DCB
d1       using ihadcb,outdcb
         MVC   outdcb(outfilel),0(R14)
         lay   R0,outdcb                 SET  DCBE ADDRESS IN  DCB
         aghi  R0,outfile0
         sty   R0,d1.DCBDCBE
*
         LAY   R2,OUTDCB
         LAY   R14,STATOPEN
         MVC   WKREENT(8),0(R14)
         OPEN  ((R2),(OUTPUT)),MODE=31,MF=(E,WKREENT)
*
*      echo input exec parms
         LAY   R14,SPACES
         MVC   WKPRINT,0(R14)
         MVC   WKPRINT(35),=CL35'GVBDTGEN Being executed with parm: '
         MVC   WKPRINT+35(L'WKPARM),WKPARM
         LA    R2,OUTDCB
         LA    R0,WKPRINT
         PUT   (R2),(R0)
*
         L     R0,=A(FIRSTNL/FIRSTNML)
         MH    R0,=Y(SECNAL/SECNAML)
         MH    R0,=Y(MIDNAL/MIDNAML)
         ST    R0,WKCNAMN
         MH    R0,=Y(CNAMEL)
         AH    R0,=H'4'           AND END OF AREA
         ST    R0,WKCNAML
*
         STORAGE OBTAIN,LENGTH=(0),LOC=(ANY)
         LR    R4,R1
         ST    R4,WKCNAMA
         USING CNAME,R4
*
* build table of customer names using combinations
*
         LAY   R5,FIRSTN
         LAY   R0,DOCTA
         ST    R0,WKDATCR
         LAY   R0,DOBTA
         ST    R0,WKDATBR
         USING FIRSTNM,R5
         L     R11,=A(FIRSTNL/FIRSTNML)
*
A0050    EQU   *
         LAY   R6,SECNA
         USING SECNAM,R6
         L     R9,=A(SECNAL/SECNAML)
*
A0060    EQU   *
         LAY   R3,MIDNA
         USING MIDNAM,R3
         L     R2,=A(MIDNAL/MIDNAML)
*
A0070    EQU   *
         XC    0(96,R4),0(R4)
*
         MVC   CNAM1ST,FIRSTNAM
         MVC   CNAMMID,MIDNAME
         MVC   CNAMLST,SECNAME
*
         MVC   CNAMGEN,FIRSTGEN
         L     R1,WKDATBR
         MVC   CNAMDOB,0(R1)
         LA    R1,DOBTABL(,R1)
         CLI   0(R1),X'FF'
         JNE   A0071
         LAY   R1,DOBTA
A0071    EQU   *
         ST    R1,WKDATBR
*
         L     R1,WKDATCR
         MVC   CNAMSEF,0(R1)
         MVC   CNAMSEFO,0(R1)
         LA    R1,DOCTABL(,R1)
         CLI   0(R1),X'FF'
         JNE   A0072
         LAY   R1,DOCTA
A0072    EQU   *
         ST    R1,WKDATCR
*
         MVC   CNAMEEF,DOCEEF
*
         LA    R4,CNAMEL(,R4)
*
         LA    R3,MIDNAML(,R3)
         BRCT  R2,A0070
*
         LA    R6,SECNAML(,R6)
         BRCT  R9,A0060
*
         LA    R5,FIRSTNML(,R5)
         BRCT  R11,A0050
*
* find inferred name changes by sorting by first, middle names DOB
*
         MVC   WKTEMP,=CL80' '
         MVC   WKTEM2,=CL80' '
A0100    EQU   *
         L     R4,WKCNAMA
         L     R2,WKCNAMN
         BCTR  R2,0
         XR    R0,R0
A0110    EQU   *
         MVC   WKTEMP+00(20),CNAM1ST
         MVC   WKTEMP+20(20),CNAMMID
         MVC   WKTEMP+40(08),CNAMDOB
         MVC   WKTEMP+48(08),CNAMSEF
         MVC   WKTEM2+00(20),CNAM1ST+CNAMEL
         MVC   WKTEM2+20(20),CNAMMID+CNAMEL
         MVC   WKTEM2+40(08),CNAMDOB+CNAMEL
         MVC   WKTEM2+48(08),CNAMSEF+CNAMEL
         CLC   WKTEMP,WKTEM2
         JNH   A0120
         XC    CNAMEL(CNAMEL,R4),0(R4)
         XC    0(CNAMEL,R4),CNAMEL(R4)
         XC    CNAMEL(CNAMEL,R4),0(R4)
         LA    R0,1
A0120    EQU   *
         LA    R4,CNAMEL(,R4)
         BRCT  R2,A0110
         LTR   R0,R0
         JZ    A0124
         J     A0100
A0124    EQU   *
*
* mark inferred name changes now sorted by first, middle names DOB
*
         MVC   WKTEMP,=CL80' '
         MVC   WKTEM2,=CL80' '
         L     R4,WKCNAMA
         L     R2,WKCNAMN
         BCTR  R2,0
A0130    EQU   *
         CLI   CNAMGEN,C'F'
         JNE   A0132
         MVC   WKTEMP+00(20),CNAM1ST
         MVC   WKTEMP+20(20),CNAMMID
         MVC   WKTEMP+40(08),CNAMDOB
         MVC   WKTEM2+00(20),CNAM1ST+CNAMEL
         MVC   WKTEM2+20(20),CNAMMID+CNAMEL
         MVC   WKTEM2+40(08),CNAMDOB+CNAMEL
*
         CLC   WKTEMP,WKTEM2
         JNE   A0132
         CLI   CNAMSAME,C'Y'
         JE    A0133
         MVI   CNAMSAME,C'X'
A0133    EQU   *
         MVI   CNAMSAME+CNAMEL,C'Y'
*
*         CLI   CNAMSAME,C'Y'
*         JE    A0133A
*         MVI   CNAMMID+19,C'X'
*A0133A   EQU   *
*         MVI   CNAMMID+19+CNAMEL,C'Y'
A0132    EQU   *
*
         LR    R0,R4
         S     R0,WKCNAMA
         ST    R0,CNAMODUP
*
         LA    R4,CNAMEL(,R4)
         BRCT  R2,A0130
*
* alter effective start end date for same customer identities
*
         L     R4,WKCNAMA
         L     R2,WKCNAMN
         BCTR  R2,0
A0134    EQU   *
         CLI   CNAMSAME,C'X'
         JNE   A0135
         CLI   CNAMSAME+CNAMEL,C'Y'
         JNE   A0135
         LR    R0,R4                     offset of parent
         S     R0,WKCNAMA
         ST    R0,CNAMPARO               parent record offset in table
         J     A0137
*
A0135    EQU   *
         CLI   CNAMSAME,C'Y'
         JNE   A0136
         CLI   CNAMSAME+CNAMEL,C'Y'
         JNE   A0136
*
A0137    EQU   *
         ST    R0,CNAMOPAR+CNAMEL        set offset of parent in table
         MVC   CNAMSEFO+CNAMEL,CNAMSEFO  set original start next entry
*
         CLC   CNAMSEF+CNAMEL+6(2),=CL2'01' is it first of month ?
         JNE   A01370                       no
         JAS   R14,PREVDATE                 yes: more complex calc
         J     A01372
A01370   EQU   *
         MVC   CNAMEEF(6),CNAMSEF+CNAMEL modify this end date: yyyymm
         PACK  WKDBL1,CNAMSEF+CNAMEL+6(2)  adjust to the day before
         SP    WKDBL1,=PL4'1'              the next effective start
         OI    WKDBL1+L'WKDBL1-1,X'0F'     date.
         UNPK  CNAMEEF+6(2),WKDBL1
A01372   EQU   *
*                                        next effective start date
A0136    EQU   *
         LA    R4,CNAMEL(,R4)
         BRCT  R2,A0134
*
* copy original sort cust name table
*
         L     R0,WKCNAML
*
         STORAGE OBTAIN,LENGTH=(0),LOC=(ANY)
*
         ST    R1,WKCNA1A
         L     R0,WKCNAMA
         L     R1,WKCNAML
         L     R14,WKCNA1A
         LR    R15,R1
         MVCL  R14,R0
*
* sort original start date, first, middle names and CNAMDOB, CNAMODUP
*
         MVC   WKTEMP,=CL80' '
         MVC   WKTEM2,=CL80' '
A0138    EQU   *
         L     R4,WKCNAMA
         L     R2,WKCNAMN
         BCTR  R2,0
         XR    R0,R0
A0139    EQU   *
         MVC   WKTEMP+00(08),CNAMSEFO
         MVC   WKTEMP+08(20),CNAM1ST
         MVC   WKTEMP+28(01),CNAMMID         altered mid for display
         MVC   WKTEMP+48(08),CNAMDOB
         MVC   WKTEMP+56(04),CNAMODUP
         MVC   WKTEM2+00(08),CNAMSEFO+CNAMEL
         MVC   WKTEM2+08(20),CNAM1ST+CNAMEL
         MVC   WKTEM2+28(01),CNAMMID+CNAMEL  altered mid for display
         MVC   WKTEM2+48(08),CNAMDOB+CNAMEL
         MVC   WKTEM2+56(04),CNAMODUP+CNAMEL
         CLC   WKTEMP,WKTEM2
         JNH   A0139A
         XC    CNAMEL(CNAMEL,R4),0(R4)
         XC    0(CNAMEL,R4),CNAMEL(R4)
         XC    CNAMEL(CNAMEL,R4),0(R4)
         LA    R0,1
A0139A   EQU   *
         LA    R4,CNAMEL(,R4)
         BRCT  R2,A0139
         LTR   R0,R0
         JZ    A0139C
         J     A0138
A0139C   EQU   *
*
* assign identity to unique customers
*
         L     R4,WKCNAMA
         L     R2,WKCNAMN
         XR    R5,R5                   customer id  number
A014000  EQU   *
         CLI   CNAMSAME,C'Y'           is it a repeat identity
         JE    A014100
         AGHI  R5,1
         CVD   R5,WKDBL1
         MVC   WKDBL2,NUMMASK
         ED    WKDBL2,WKDBL1+4
         MVC   CNAMID(4),=CL4'0000'
         MVC   CNAMID+4(6),WKDBL2+2
A014100  EQU   *
         LA    R4,CNAMEL(,R4)
         BRCT  R2,A014000
         MVC   0(4,R4),=XL4'FFFFFFFF'
*
* write customer name file assigning custname id, and address file
*
         LAY   R0,ADDRTAB
         ST    R0,WKADDRP         pointer to street name
         LAY   R0,ADR1TAB
         ST    R0,WKADR1P         pointer to house number
         LAY   R0,ADR2TAB
         ST    R0,WKADR2P         pointer to apartment number
         LAY   R0,ADR3TAB
         ST    R0,WKADR3P         pointer to city, state ziip
*
         LA    R7,ADDRREC
         USING CUADR,R7
*
         L     R4,WKCNAMA
         L     R2,WKCNAMN
         XR    R3,R3                   customer name id  number
A0140    EQU   *
         AGHI  R3,1
         CVD   R3,WKDBL1
         MVC   WKDBL2,NUMMASK
         ED    WKDBL2,WKDBL1+4
         MVC   CNAMCID(4),=CL4'0000'
         MVC   CNAMCID+4(6),WKDBL2+2
*
         CLI   CNAMSAME,C'Y'
         JNE   A0143
         L     R1,CNAMOPAR
         L     R6,WKCNAMA
         L     R5,WKCNAMN
A0141    EQU   *
         C     R1,CNAMPARO-CNAME(R6)   go looking for parent record
         JNE   A0142                   containing customer ID
         MVC   CNAMID,CNAMID-CNAME(R6)
         J     A0143
A0142    EQU   *
         LA    R6,CNAMEL(,R6)
         BRCT  R5,A0141
A0143    EQU   *
*
         MVC   CUADRID,CNAMID
         MVC   CUADRAI,CNAMCID
         L     R1,WKADR1P
         MVC   CUADRL1+0(5),0(R1)
         L     R1,WKADDRP
         MVC   CUADRL1+5(15),0(R1)
         L     R1,WKADR2P
         MVC   CUADRL2,0(R1)
         L     R1,WKADR3P
         MVC   CUADRL3,0(R1)
         MVC   CNAMST,20(R1)           save state to use for store ID
         MVC   CUADRST,20(R1)
         MVC   CUADRZP,22(R1)
         MVC   CUADRDS,CNAMSEF
         MVC   CUADRDE,CNAMEEF
         PUT   ADRDCB,(R7)
*
         L     R1,WKADR2P              street name,house number and
         AHI   R1,ADR2LEN              city combination are unique
         CLI   0(R1),X'FF'             so cycle apartment number
         JNE   A0150                   anyway
         LAY   R1,ADR2TAB
A0150    EQU   *
         ST    R1,WKADR2P
*
         L     R1,WKADR3P              go through all the cities
         AHI   R1,ADR3LEN
         CLI   0(R1),X'FF'
         JNE   A0153
         LAY   R1,ADR3TAB
         ST    R1,WKADR3P
*
         L     R1,WKADDRP              then all the street names
         AHI   R1,ADDRLEN
         CLI   0(R1),X'FF'
         JNE   A0151
         LAY   R1,ADDRTAB
         ST    R1,WKADDRP
*
         L     R1,WKADR1P              then all the house/apt numbers
         AHI   R1,ADR1LEN
         CLI   0(R1),X'FF'
         JNE   A0152
         LAY   R1,ADR1TAB
         ST    R1,WKADR1P
         J     A0159
*
A0152    EQU   *
         ST    R1,WKADR1P
         J     A0159
A0151    EQU   *
         ST    R1,WKADDRP
         J     A0159
A0153    EQU   *
         ST    R1,WKADR3P
A0159    EQU   *
*
         PUT   CNADCB,(R4)
         LA    R4,CNAMEL(,R4)
         BRCT  R2,A0140
         DROP  R7 CUADR
*
* write customer file
*
         L     R4,WKCNAMA
         L     R2,WKCNAMN
         XR    R3,R3
         LA    R5,CUSTREC
         USING CUSTMER,R5
A0240    EQU   *
         AGHI  R3,1
         MVC   CUSTREC,=CL78' '
         MVC   CUSTID,CNAMID
         MVC   CUSTGEN,CNAMGEN
         MVC   CUSTDOB,CNAMDOB
         MVC   CUSTWHEN,CNAMSEF        effective date -- only first
         LR    R0,R4                   record written, for multiple
         AR    R0,R3                   occurrences of same identity
         S     R0,WKCNAMA
         AGHI  R0,3
         MH    R0,CUSTDOB+4
         SLL   R0,8
         CVD   R0,WKDBL1
         MVC   WKDBL2,NUMMASK
         ED    WKDBL2,WKDBL1+4
         MVC   CUSTPHON+3(7),WKDBL2+1
         MVI   CUSTCCDE,C'P'
         MVC   CUSTEMAI(7),CUSTPHON+3
*
         CLC   CNAMST,=CL2'TX'         select area code and isp
         JNE   A024101
         MVC   CUSTPHON(3),=CL3'214'
         MVC   CUSTEMAI+7(13),=CL13'@SPECTRUM.NET'
         J     A024103
A024101  EQU   *
         CLC   CNAMST,=CL2'AZ'
         JNE   A024102
         MVC   CUSTPHON(3),=CL3'602'
         MVC   CUSTEMAI+7(9),=CL9'@FUSE.NET'
         J     A024103
A024102  EQU   *
         CLC   CNAMST,=CL2'WA'
         JNE   A024103
         MVC   CUSTPHON(3),=CL3'206'
         MVC   CUSTEMAI+7(14),=CL14'@WAVECABLE.NET'
A024103  EQU   *
*
         CLI   CNAMSAME,C'Y'           is it a repeat identity
         JE    A0242                   then don't write it
         ASI   WKCUSTM#,1
         PUT   CSTDCB,(R5)
A0242    EQU   *
         LA    R4,CNAMEL(,R4)
         BRCT  R2,A0240
*
* write order file and order items -- the customer file isn't
*       necessarily same as custname file because of name changes.
*
         XC    WKORDER#,WKORDER#       Order item counter
         XC    WKORDIT#,WKORDIT#       Order item counter
         XC    WKCURORD,WKCURORD       Order counter
*
         LA    R7,ORDTREC
         USING ORDER,R7
         LA    R10,ITMTREC
         USING ORDI,R10
         L     R3,=A(YEARTABL/YEARITML)
         MVC   WKYEARP,=A(YEARTAB)
         MVC   WKPRODP,=A(PRDTAB)
         MVC   WKITMQP,=A(IQTYTAB)
         XC    WKORDNUM,WKORDNUM
A0340    EQU   *                       For all years
         ZAP   WKDDDJ,P0001
         L     R9,=A(MONTABL/MONITML)
         MVC   WKMONP,=A(MONTAB)
A0350    EQU   *                       For all months this year
         L     R1,WKMONP
         LH    R5,2(,R1)               NUMBER OF DAYS THIS MONTH
         CLC   0(2,R1),=CL2'02'        POSSIBILITY OF LEAP YEAR
         JNE   A0351
         L     R1,WKYEARP
         CLI   4(R1),C'Y'              YES, LEAP YEAR
         JNE   A0351
         LA    R5,1(,R5)                 Feb 29th
A0351    EQU   *
         MVC   WKDAYP,=A(DAYTAB)
A0360    EQU   *                       For all days this month
         L     R1,WKYEARP
         MVC   WKORDDAT(4),0(R1)         year
         L     R1,WKMONP
         MVC   WKORDDAT+4(2),0(R1)       month
         L     R1,WKDAYP
         MVC   WKORDDAT+6(2),0(R1)       date
         LH    R6,2(,R1)               NUMBER OF ORDERS THIS DAY
         MH    R6,WKDYMULT             times!!
         L     R4,WKCNAMA              CUSTOMER TABLE
         LH    R0,4(,R1)               What customer do we want to
         LTR   R0,R0                     start with ?
         JZ    A0361
         BCTR  R0,0
A0361    EQU   *
         MH    R0,=Y(CNAMEL)           start with this customer...
         AR    R4,R0
         MVI   WKSOD,C'Y'              Start of day
*
A0370    EQU   *                       For all orders this day
         CLC   WKORDDAT,CNAMSEFO         Are they a customer yet ?
         JL    A03719
*
         CLI   CNAMSAME,C'Y'             Continuation of sequence of
         JE    A03719                    same customer identity
*
         ASI   WKORDER#,1
*
         LH    R0,QTYBIN                 Quantity of same order item
         CVD   R0,WKDBL1
         ZAP   WKQTYP,WKDBL1
*
         L     R2,WKPRODP
         USING PRDDATA,R2
         ASI   WKORDNUM,1                increment order number
         XC    WKORDIN,WKORDIN           reset to order item number
         MVC   WKPRICE,=PL6'0'           total price
         MVC   WKDISC,=PL6'0'            total discount
*
         MVC   ORDTREC,=XL47'00'
         L     R0,WKORDNUM
         CVD   R0,WKDBL1
         MVC   WKDBL2(L'NUMMSK10),NUMMSK10
         ED    WKDBL2(L'NUMMSK10),WKDBL1+3
         MVC   ORDID,WKDBL2
         MVC   ORDCID,CNAMID
*
         CLC   CNAMST,=CL2'TX'
         JNE   A037101
         MVC   ORDSTOR,=CL3'001'
         J     A037103
A037101  EQU   *
         CLC   CNAMST,=CL2'AZ'
         JNE   A037102
         MVC   ORDSTOR,=CL3'002'
         J     A037103
A037102  EQU   *
         CLC   CNAMST,=CL2'WA'
         JNE   A037103
         MVC   ORDSTOR,=CL3'003'
A037103  EQU   *
*
         MVC   ORDDATE,WKORDDAT          today's date
*
         L     R1,WKITMQP
         LH    R11,0(,R1)
A0380    EQU   *                         For all items in order
         ASI   WKORDIT#,1
*
         LH    R0,WKORDIN                yes: increment order item num
         AHI   R0,1                           as it's multiple items
         STH   R0,WKORDIN                       in same order
         MVC   WKPL6,PRDPRICE                calculate total order
         MP    WKPL6,WKQTYP                    price
         AP    WKPRICE,WKPL6                   * quantity
         MVC   WKPL6,PRDDISC                 calculate total order
         MP    WKPL6,WKQTYP                    discount
         AP    WKDISC,WKPL6                    * quantity
*
         MVC   ORDIID,ORDID
         MVC   ORDINUM,WKORDIN
         MVC   ORDIPRD,PRDID
         MVC   ORDIQTY,QTYBIN
         MVC   ORDIPRC,PRDPRICE
         MVC   ORDIDSC,PRDDISC
*
         CLI   WKPART,C'S'    Partition Order Items by State ordered ?
         JNE   A037104A
         CLC   CNAMST,=CL2'TX'
         JNE   A037101A
         PUT   ITMDCB,(R10)
         J     A037103A
A037101A EQU   *
         CLC   CNAMST,=CL2'AZ'
         JNE   A037102A
         PUT   ITMDCB2,(R10)
         J     A037103A
A037102A EQU   *
         CLC   CNAMST,=CL2'WA'
         JNE   A037103A
         PUT   ITMDCB3,(R10)
A037103A EQU   *
         J     A037106
*
A037104A EQU   *
         CLI   WKPART,C'P'    Partition Order Items by Product code ?
         JNE   A037104B
         CLC   PRDCDE,=CL3'001'
         JNE   A037101B
         PUT   ITMDCB,(R10)
         J     A037103B
A037101B EQU   *
         CLC   PRDCDE,=CL3'002'
         JNE   A037102B
         PUT   ITMDCB2,(R10)
         J     A037103B
A037102B EQU   *
         CLC   PRDCDE,=CL3'003'
         JNE   A037103B
         PUT   ITMDCB3,(R10)
A037103B EQU   *
         J     A037106
*
A037104B EQU   *
         CLI   WKPART,C'R'    Partition Order Items round robin ?
         JNE   A037104
         ST    R3,WKTEMPSV
         L     R3,WKROBINP    address of current DCB list item
         L     R3,0(,R3)      address of DCB
         PUT   (R3),(R10)
         L     R3,WKROBINP    address of current DCB list item
         LA    R3,4(,R3)
         CLC   0(4,R3),=A(-1)
         JNE   A037102C
         LA    R3,WKROBIND
A037102C EQU   *
         ST    R3,WKROBINP
         L     R3,WKTEMPSV
         J     A037106
*
A037104  EQU   *
         PUT   ITMDCB,(R10)
*
A037106  EQU   *
         LA    R2,PRDITML(,R2)
         CLI   0(R2),X'FF'
         JNE   A0374
         L     R2,=A(PRDTAB)
A0374    EQU   *
         ST    R2,WKPRODP
         BRCT  R11,A0380
*
         L     R1,WKITMQP
         LA    R1,2(,R1)
         CLI   0(R1),X'FF'
         JNE   A0373
         L     R1,=A(IQTYTAB)
A0373    EQU   *
         ST    R1,WKITMQP
         DROP  R2 PRDDATA
*
         MVC   ORDDATJ,WKDDDJ
         ASI   WKCURORD,1
*
         MVC   ORDAMT,WKPRICE
         MVC   ORDREB,WKDISC
         PUT   ORDDCB,(R7)
         CLC   WKCURORD,WKMAXORD         all order items and all
         JNL   A0375                     written up to the max
*
A03719   EQU   *
         LA    R4,CNAMEL(,R4)
         CLC   0(4,R4),=XL4'FFFFFFFF'
         JNE   A0372
         L     R4,WKCNAMA
A0372    EQU   *
*
         BRCT  R6,A0370                End... for all orders this day
*
         ASI   WKDAYP,DAYITML
         AP    WKDDDJ,P0001
         BRCT  R5,A0360                End.. for all days this month
*
         ASI   WKMONP,MONITML
         BRCT  R9,A0350                End.. for all months this year
*
         ASI   WKYEARP,YEARITML        End.. for all years
         BRCT  R3,A0340
A0375    EQU   *
         DROP  R4 CNAME
*
* write product and product description files
*
         L     R5,=A(PRDTABL/PRDITML)
         BCTR  R5,0
         LAY   R4,PRDTAB
         USING PRDDATA,R4
         LA    R6,PRDTREC
         USING PRDI,R6
         LA    R7,DSCTREC
         USING DSCI,R7
A0400    EQU   *
         MVC   PRDIID,PRDID
         MVC   PRDPIDM,=CL10'0000000088' purchade ID
         MVC   PRDTCDE,PRDCDE
*
         MVC   DSCPID,PRDID
         MVC   DSCPDSC,PRDDESC
*
         ASI   WKPRODT#,1
         PUT   PRDDCB,(R6)
         PUT   DSCDCB,(R7)
*
         LA    R4,PRDITML(,R4)
         BRCT  R5,A0400
*
         DROP  R4 PRDDATA
         DROP  R6 PRDI
         DROP  R7 DSCI
*
* write store address file
*
         L     R5,=A(STRLEN/STRLN)
         LAY   R4,STRADDR
A0420    EQU   *
         ASI   WKSTORE#,1
         PUT   STRDCB,(R4)
*
         LA    R4,STRLN(,R4)
         BRCT  R5,A0420
*
* close files
*
         LAY   R14,STATCLOS
         MVC   WKREENT(STATCLOSL),0(R14)
         CLOSE (CSTDCB),MODE=31,MF=(E,WKREENT)
*
         LAY   R14,STATCLOS
         MVC   WKREENT(STATCLOSL),0(R14)
         CLOSE (CNADCB),MODE=31,MF=(E,WKREENT)
*
         LAY   R14,STATCLOS
         MVC   WKREENT(STATCLOSL),0(R14)
         CLOSE (ORDDCB),MODE=31,MF=(E,WKREENT)
*
         LAY   R14,STATCLOS
         MVC   WKREENT(STATCLOSL),0(R14)
         CLOSE (ITMDCB),MODE=31,MF=(E,WKREENT)
*
         CLI   WKPART,C' '       Partition Order Items ?
         JE    A0440
*
         LAY   R14,STATCLOS
         MVC   WKREENT(STATCLOSL),0(R14)
         CLOSE (ITMDCB2),MODE=31,MF=(E,WKREENT)
*
         LAY   R14,STATCLOS
         MVC   WKREENT(STATCLOSL),0(R14)
         CLOSE (ITMDCB2),MODE=31,MF=(E,WKREENT)
*
A0440    EQU   *
         LAY   R14,STATCLOS
         MVC   WKREENT(STATCLOSL),0(R14)
         CLOSE (PRDDCB),MODE=31,MF=(E,WKREENT)
*
         LAY   R14,STATCLOS
         MVC   WKREENT(STATCLOSL),0(R14)
         CLOSE (DSCDCB),MODE=31,MF=(E,WKREENT)
*
         LAY   R14,STATCLOS
         MVC   WKREENT(STATCLOSL),0(R14)
         CLOSE (ADRDCB),MODE=31,MF=(E,WKREENT)
*
         LAY   R14,STATCLOS
         MVC   WKREENT(STATCLOSL),0(R14)
         CLOSE (STRDCB),MODE=31,MF=(E,WKREENT)
*
         LAY   R14,SPACES
         MVC   WKPRINT,0(R14)
         MVC   WKPRINT(15),=CL15'Orders        :'
         llgt  r2,wkorder#
         cvdg  r2,wkdbl2
         mvc   WKPRINT+16(20),bytemsk
         ed    WKPRINT+16(20),wkdbl3
         LA    R2,OUTDCB
         LA    R0,WKPRINT
         PUT   (R2),(R0)
         MVC   WKPRINT(15),=CL15'Items         :'
         llgt  r2,wkordit#
         cvdg  r2,wkdbl2
         mvc   WKPRINT+16(20),bytemsk
         ed    WKPRINT+16(20),wkdbl3
         LA    R2,OUTDCB
         LA    R0,WKPRINT
         PUT   (R2),(R0)
         MVC   WKPRINT(15),=CL15'Customer names:'
         llgt  r2,wkcnamn
         cvdg  r2,wkdbl2
         mvc   WKPRINT+16(20),bytemsk
         ed    WKPRINT+16(20),wkdbl3
         LA    R2,OUTDCB
         LA    R0,WKPRINT
         PUT   (R2),(R0)
         MVC   WKPRINT(15),=CL15'Customer addr.:'
         llgt  r2,wkcnamn
         cvdg  r2,wkdbl2
         mvc   WKPRINT+16(20),bytemsk
         ed    WKPRINT+16(20),wkdbl3
         LA    R2,OUTDCB
         LA    R0,WKPRINT
         PUT   (R2),(R0)
         MVC   WKPRINT(15),=CL15'Customers     :'
         llgt  r2,WKCUSTM#
         cvdg  r2,wkdbl2
         mvc   WKPRINT+16(20),bytemsk
         ed    WKPRINT+16(20),wkdbl3
         LA    R2,OUTDCB
         LA    R0,WKPRINT
         PUT   (R2),(R0)
         MVC   WKPRINT(15),=CL15'Products      :'
         llgt  r2,WKPRODT#
         cvdg  r2,wkdbl2
         mvc   WKPRINT+16(20),bytemsk
         ed    WKPRINT+16(20),wkdbl3
         LA    R2,OUTDCB
         LA    R0,WKPRINT
         PUT   (R2),(R0)
         MVC   WKPRINT(15),=CL15'Products Desc.:'
         llgt  r2,WKPRODT#
         cvdg  r2,wkdbl2
         mvc   WKPRINT+16(20),bytemsk
         ed    WKPRINT+16(20),wkdbl3
         LA    R2,OUTDCB
         LA    R0,WKPRINT
         PUT   (R2),(R0)
         MVC   WKPRINT(15),=CL15'Stores        :'
         llgt  r2,WKSTORE#
         cvdg  r2,wkdbl2
         mvc   WKPRINT+16(20),bytemsk
         ed    WKPRINT+16(20),wkdbl3
         LA    R2,OUTDCB
         LA    R0,WKPRINT
         PUT   (R2),(R0)
*
CLOSEFL  EQU   *
         LA    R2,OUTDCB
         LAY   R14,STATCLOS
         MVC   WKREENT(8),0(R14)
         CLOSE ((R2)),MODE=31,MF=(E,WKREENT)
*
         XR    R15,R15
*
*
return   ds    0h
         L     R13,wksave1+4
         st    r15,16(r13)
         lm    r14,r12,12(r13)
         br    r14
*
return8  equ   *
         lhi   r15,8
         j     return
*
*
         USING CNAME,R4
PREVDATE DS    0H
         stm   R14,R12,12(r13)
         la    r0,wksave2
         st    r13,wksave2+4
         st    r0,8(,r13)
         lr    r13,r0
*
         CLC   CNAMSEF+CNAMEL+4(2),=CL2'01' is it January ?
         JNE   PREVD010
         PACK  WKDBL1,CNAMSEF+CNAMEL+0(4)  adjust to the year before
         SP    WKDBL1,=PL4'1'              the next effective start
         OI    WKDBL1+L'WKDBL1-1,X'0F'     date.
         UNPK  CNAMEEF+0(4),WKDBL1
         MVC   CNAMEEF+4(4),=CL4'1231'     December 31 previous year
         J     PREVD029
*
PREVD010 EQU   *
         MVC   CNAMEEF(4),CNAMSEF+CNAMEL   keep the same year
         PACK  WKDBL1,CNAMSEF+CNAMEL+4(2)  adjust to the mon before
         SP    WKDBL1,=PL4'1'              the next effective start
         OI    WKDBL1+L'WKDBL1-1,X'0F'     date.
         UNPK  CNAMEEF+4(2),WKDBL1
*
         CLC   CNAMEEF+4(2),=CL2'02'       is the month now february ?
         JNE   PREVD014
         LAY   R3,YEARTAB
         L     R11,=A(YEARTABL/YEARITML)
PREVD011 EQU   *
         CLC   0(4,R3),CNAMEEF             locate the year
         JNE   PREVD012
         CLI   4(R3),C'Y'                  leap year ?
         JNE   PREVD013
         MVC   CNAMEEF+6(2),=CL2'29'
         J     PREVD029
PREVD013 EQU   *
         MVC   CNAMEEF+6(2),=CL2'28'
         J     PREVD029
PREVD012 EQU   *
*
         LA    R3,YEARITML(,R3)
         BRCT  R11,PREVD011
         DC    H'0'                        should never happen
*
*
PREVD014 EQU   *
         LAY   R3,MONTAB
         L     R11,=A(MONTABL/MONITML)
PREVD015 EQU   *
*
         CLC   0(2,R3),CNAMEEF+4           locate the month
         JNE   PREVD016
         LH    R0,2(,R3)                   set the date
         CVD   R0,WKDBL1
         OI    WKDBL1+L'WKDBL1-1,X'0F'     date.
         UNPK  CNAMEEF+6(2),WKDBL1
         J     PREVD029
PREVD016 EQU   *
*
         LA    R3,MONITML(,R3)
         BRCT  R11,PREVD015
         DC    H'0'
*
PREVD029 EQU   *
*
         l     r13,wksave2+4
         lm    r14,r12,12(r13)
         br    r14
*
* PARTITION= sub parameter (R1 => subparameter, R2 = length)
*
SUBPART  DS    0H
         stm   R14,R12,12(r13)
         la    r0,wksave2
         st    r13,wksave2+4
         st    r0,8(,r13)
         lr    r13,r0
*
         CLC   0(15,R1),=CL15'PARTITION=STATE'
         JNE   A00012
         MVI   WKPART,C'S'      Partition order item file by state
         wto 'order item file partitioned by state'
         J     A00016
A00012   EQU   *
         CLC   0(17,R1),=CL17'PARTITION=PRODUCT'
         JNE   A00013
         MVI   WKPART,C'P'      Partition order item file by product
         wto 'order item file partitioned by product'
         J     A00016
A00013   EQU   *
         CLC   0(13,R1),=CL13'PARTITION=YES'
         JNE   A00014
         MVI   WKPART,C'R'      Partition order item file round robin
         LA    R0,WKROBIND
         ST    R0,WKROBINP
         LA    R0,ITMDCB
         ST    R0,WKROBIND+0
         LA    R0,ITMDCB2
         ST    R0,WKROBIND+4
         LA    R0,ITMDCB3
         ST    R0,WKROBIND+8
         MVC   WKROBIND+12,=A(-1) end of order item DCB list
         wto 'order item file partitioned round robin'
         J     A00016
A00014   EQU   *
         wto 'error in PARTITION sub parameter'
A00016   EQU   *
*
         l     r13,wksave2+4
         lm    r14,r12,12(r13)
         BR    R14
*
* ORDERS= sub parameter (R1 => subparameter, R2 = length)
*
SUBORDS  DS    0H
         stm   R14,R12,12(r13)
         la    r0,wksave2
         st    r13,wksave2+4
         st    r0,8(,r13)
         lr    r13,r0
*
         CLC   0(7,R1),=CL7'ORDERS='
         JNE   A00017
         CHI   R2,8                    Too little
         JL    A00017
         CHI   R2,17                   Too much
         JH    A00017
         LA    R4,7(,R1)
         LR    R3,R2
         AHI   R3,-7
A00019   EQU   *                       Check for numerics
         CLI   0(R4),C'0'
         JL    A00017
         CLI   0(R4),C'9'
         JH    A00017
         LA    R4,1(,R4)
         BRCT  R3,A00019
*
         LA    R1,7(,R1)               First digit of number
         AHI   R2,-8                   Number length - 1 =L2
         OY    R2,=Xl4'00000070'       Set L1 in pack's L1L2
         EXRL  R2,EXEPACK
         CVB   R0,WKDBL1
         ST    R0,WKMAXORD
*
         wto 'maximum number of orders specified'
         J     A00018
A00017   EQU   *
         wto 'error in ORDERS sub parameter'
A00018   EQU   *
*
         l     r13,wksave2+4
         lm    r14,r12,12(r13)
         BR    R14
*
* DYMULT= sub parameter (R1 => subparameter, R2 = length)
*
SUBMULT  DS    0H
         stm   R14,R12,12(r13)
         la    r0,wksave2
         st    r13,wksave2+4
         st    r0,8(,r13)
         lr    r13,r0
*
         CLC   0(7,R1),=CL7'DYMULT='
         JNE   A000170
         CHI   R2,8                    Too little
         JL    A000170
         CHI   R2,12                   Too much
         JH    A000170
         LA    R4,7(,R1)
         LR    R3,R2
         AHI   R3,-7
A000190  EQU   *                       Check for numerics
         CLI   0(R4),C'0'
         JL    A000170
         CLI   0(R4),C'9'
         JH    A000170
         LA    R4,1(,R4)
         BRCT  R3,A000190
*
         LA    R1,7(,R1)               First digit of number
         AHI   R2,-8                   Number length - 1 =L2
         OY    R2,=Xl4'00000070'       Set L1 in pack's L1L2
         EXRL  R2,EXEPACK
         CVB   R0,WKDBL1
         STH   R0,WKDYMULT
*
         wto 'daily multiplier specified'
         J     A000180
A000170  EQU   *
         wto 'error in DYMULT sub parameter'
A000180  EQU   *
*
         l     r13,wksave2+4
         lm    r14,r12,12(r13)
         BR    R14
*
EXEPACK  PACK  WKDBL1(0),0(0,R1)
*
static   loctr
*
NUMMASK  DC    XL08'F021202020202120'
NUMMSK10 DC    XL10'F0212121212121212120'
TRACEMSK DC    XL12'402020202020202020202120'
*
BYTEMSK  DC    XL20'402020206B2020206B2020206B2020206B202120'
*
DOCEEF   DC    CL8'99999999'           Date of customer end effective
*
QTYBIN   DC    H'1'                    One for now
*
P0001    DC    PL4'1'
*
         LTORG ,
*
TOKNLVL2 DC    A(2)                    NAME/TOKEN  AVAILABILITY  LEVEL
GENEVA   DC    CL8'GENEVA  '                TOKEN  NAME
TKNNAME  DC    CL8'GVBDTGEN'
TOKNPERS DC    F'0'
*
FIRSTN   DS    0H                 first/middle name table and gender
         DC    CL1'F'
         DC    CL20'JOSEPHINE'
         DC    CL1'F'
         DC    CL20'MARY'
         DC    CL1'M'
         DC    CL20'MIKE'
         DC    CL1'F'
         DC    CL20'NATALIA'
         DC    CL1'F'
         DC    CL20'CHRISTINE'
         DC    CL1'M'
         DC    CL20'STEVE'
         DC    CL1'M'
         DC    CL20'DIMITRI'
         DC    CL1'F'
         DC    CL20'RUTH'
         DC    CL1'M'
         DC    CL20'BRIAN'
         DC    CL1'M'
         DC    CL20'CHRIS'
         DC    CL1'M'
         DC    CL20'FERNADO'
         DC    CL1'M'
         DC    CL20'MANUEL'
         DC    CL1'F'
         DC    CL20'ELIZABETH'
         DC    CL1'F'
         DC    CL20'THERESA'
         DC    CL1'F'
         DC    CL20'VIRGINIA'
         DC    CL1'M'
         DC    CL20'HUGO'
         DC    CL1'F'
         DC    CL20'Ricole'
FIRSTNL  EQU   (*-FIRSTN)
*
SECNA    DS    0H                 last name table
         DC    CL20'OBRIEN'
         DC    CL20'ROGERS'
         DC    CL20'SMITH'
         DC    CL20'JONES'
         DC    CL20'PAGE'
         DC    CL20'ALBERTSON'
         DC    CL20'POPE'
         DC    CL20'SCOTT'
         DC    CL20'DIXON'
         DC    CL20'OREILLY'
         DC    CL20'HIRSHMAN'
         DC    CL20'JAMES'
         DC    CL20'TASKER'
         DC    CL20'CALVERT'
         DC    CL20'NORMAN'
         DC    CL20'VONDRAN'
         DC    CL20'DEWITT'
         DC    CL20'SAMUELS'
         DC    CL20'GOEBEL'
         DC    CL20'FREDRICKSON'
         DC    CL20'DOWNS'
         DC    CL20'KOLMOGOROV'
         DC    CL20'DOBBS'
         DC    CL20'DESPUOYS'
         DC    CL20'GARCIA'
         DC    CL20'JACOBSON'
         DC    CL20'CHAVEZ'
         DC    CL20'ALLEN'
SECNAL   EQU   (*-SECNA)
*
MIDNA    DS    0H                 last name table
         DC    CL20'A'
         DC    CL20'B'
         DC    CL20'C'
         DC    CL20'D'
         DC    CL20'E'
         DC    CL20'F'
         DC    CL20'G'
         DC    CL20'H'
         DC    CL20'J'
         DC    CL20'L'
         DC    CL20'M'
         DC    CL20'M'
         DC    CL20'N'
         DC    CL20'P'
         DC    CL20'R'
         DC    CL20'S'
         DC    CL20'T'
         DC    CL20'V'
         DC    CL20'W'
MIDNAL   EQU   (*-MIDNA)
*
DOCTA    DS    0H           date first became customer table: 19980521
         DC    CL8'19991231'  caters for leap years, etc.
         DC    CL8'20010428'
         DC    CL8'20110131'
         DC    CL8'20070331'
         DC    CL8'20081030'
         DC    CL8'19980521'
         DC    CL8'20121111'
         DC    CL8'20130105'
         DC    CL8'19990302'
         DC    CL8'20151223'
         DC    CL8'20170214'
         DC    CL8'20010630'
         DC    CL8'20020704'
         DC    CL8'19990930'
         DC    CL8'20030102'
         DC    CL8'20041011'
         DC    CL8'20040101' 20040301'      20060605'
         DC    CL8'20051130'
         DC    CL8'20001223'
         DC    CL8'20170108'
         DC    XL4'FFFFFFFF'
DOCTAL   EQU   (*-DOCTA)
*
DOBTA    DS    0H                 date of birth: first is 19461111
         DC    CL8'19600214'
         DC    CL8'19831231'
         DC    CL8'19570428'
         DC    CL8'19890131'
         DC    CL8'19720331'
         DC    CL8'19531030'
         DC    CL8'19940521'
         DC    CL8'19461111'
         DC    CL8'19640105'
         DC    CL8'19850301'
         DC    CL8'19771223'
         DC    CL8'19890214'
         DC    CL8'19710630'
         DC    CL8'19680704'
         DC    CL8'19690930'
         DC    CL8'19590102'
         DC    CL8'19641011'
         DC    CL8'19830601'
         DC    CL8'19851130'
         DC    CL8'19601223'
         DC    CL8'19790108'
         DC    XL4'FFFFFFFF'
DOBTAL   EQU   (*-DOBTA)
*
*
YEARTAB  DS    0H YEARS  LEAP
         DC    CL4'1998',CL1' '
         DC    CL4'1999',CL1' '
         DC    CL4'2000',CL1'Y'
         DC    CL4'2001',CL1' '
         DC    CL4'2002',CL1' '
         DC    CL4'2003',CL1' '
         DC    CL4'2004',CL1'Y'
         DC    CL4'2005',CL1' '
         DC    CL4'2006',CL1' '
         DC    CL4'2007',CL1' '
         DC    CL4'2008',CL1'Y'
         DC    CL4'2009',CL1' '
         DC    CL4'2010',CL1' '
         DC    CL4'2011',CL1' '
         DC    CL4'2012',CL1'Y'
         DC    CL4'2013',CL1' '
         DC    CL4'2014',CL1' '
         DC    CL4'2015',CL1' '
         DC    CL4'2016',CL1'Y'
         DC    CL4'2017',CL1' '
*EARTAB  DS    0H YEARS  LEAP
         DC    CL4'2018',CL1' '
         DC    CL4'2019',CL1' '
         DC    CL4'2020',CL1'Y'
         DC    CL4'2021',CL1' '
YEARTABL EQU   (*-YEARTAB)
YEARITML EQU   5
*
*
MONTAB   DS    0H  MON   DAYS
         DC    CL2'01',H'31'
         DC    CL2'02',H'28'
         DC    CL2'03',H'31'
         DC    CL2'04',H'30'
         DC    CL2'05',H'31'
         DC    CL2'06',H'30'
         DC    CL2'07',H'31'
         DC    CL2'08',H'31'
         DC    CL2'09',H'30'
         DC    CL2'10',H'31'
         DC    CL2'11',H'30'
         DC    CL2'12',H'31'
MONTABL  EQU   (*-MONTAB)
MONITML  EQU   4
*
*
DAYTAB   DS    0H  DAYS ORDERS STARTING-CUST
         DC    CL2'01',H'530',H'35'
         DC    CL2'02',H'370',H'1100'
         DC    CL2'03',H'499',H'4359'
         DC    CL2'04',H'522',H'2700'
         DC    CL2'05',H'942',H'3636'
         DC    CL2'06',H'896',H'5250'
         DC    CL2'07',H'721',H'6999'
         DC    CL2'08',H'407',H'7123'
         DC    CL2'09',H'635',H'821'
         DC    CL2'10',H'729',H'2232'
         DC    CL2'11',H'400',H'3729'
         DC    CL2'12',H'385',H'7450'
         DC    CL2'13',H'999',H'12'
         DC    CL2'14',H'835',H'6321'
         DC    CL2'15',H'675',H'1111'
         DC    CL2'16',H'801',h'1200'
         DC    CL2'17',H'799',H'2300'
         DC    CL2'18',H'699',H'3400'
         DC    CL2'19',H'735',H'4500'
         DC    CL2'20',H'959',H'5600'
         DC    CL2'21',H'847',H'6700'
         DC    CL2'22',H'594',H'800'
         DC    CL2'23',H'601',H'1900'
         DC    CL2'24',H'1115',H'7000'
         DC    CL2'25',H'986',H'1100'
         DC    CL2'26',H'895',H'5200'
         DC    CL2'27',H'1315',H'50'
         DC    CL2'28',H'1320',H'1060'
         DC    CL2'29',H'972',H'70'
         DC    CL2'30',H'729',H'4080'
         DC    CL2'31',H'1252',H'190'
DAYTABL  EQU   (*-DAYTAB)
DAYITML  EQU   6
*
*
PRDTAB   DS    0H   product id  code   price     discount  description
 DC    CL10'0000000008',CL3'001',PL6'75220',PL6'7152',CL30'laptop mk3'
 DC    CL10'0000000023',CL3'002',PL6'5000',PL6'552',CL30'USB hub'
 DC    CL10'0000000026',CL3'001',PL6'71250',PL6'7052',CL30'laptop mk4'
 DC    CL10'0000000042',CL3'003',PL6'1999',PL6'252',CL30'program in R'
 DC    CL10'0000000100',CL3'001',PL6'70150',PL6'7552',CL30'laptop mk2'
 DC    CL10'0000000153',CL3'002',PL6'41250',PL6'4052',CL30'VPN router'
 DC    CL10'0000000929',CL3'003',PL6'9250',PL6'99',CL30'program in ASM'
 DC    CL10'0000001013',CL3'002',PL6'9950',PL6'952',CL30'keyboardmouse'
 DC    CL10'0000001050',CL3'002',PL6'61250',PL6'6052',CL30'HDTV mk7'
 DC    CL10'0000001236',CL3'001',PL6'81250',PL6'8052',CL30'laptop mk5'
 DC    CL10'0000006789',CL3'003',PL6'1250',PL6'52',CL30'sun glasses'
 DC    CL10'0000012345',CL3'003',PL6'972',PL6'63',CL30'wallet'
 DC    CL10'0000057928',CL3'001',PL6'75204',PL6'7052',CL30'laptop lite'
 DC    CL10'0000071589',CL3'002',PL6'19250',PL6'1052',CL30'monitor mk5'
 DC    XL4'FFFFFFFF',XL51'00000000'
PRDTABL  EQU   (*-PRDTAB)
PRDITML  EQU   55
*
STORTAB  DS    0H
         DC    CL3'001'
         DC    CL3'002'
         DC    CL3'003'
STORTABL EQU   (*-STORTAB)
STORTLEN EQU   3
*
ADDRTAB  DS    0H
         DC    CL15'Brookriver Dr  '
         DC    CL15'Elmbrook Drive '
         DC    CL15'Oakbrook Blvd  '
         DC    CL15'Hawes Avenue   '
         DC    CL15'Prudential Dr  '
         DC    CL15'Swor Street    '
         DC    CL15'Empire Central '
         DC    CL15'Beaverbrook Dr '
         DC    CL15'Possum Avenue  '
         DC    CL15'Brookhollow Rd '
         DC    CL15'Hines Place    '
         DC    CL15'Shea Road      '
         DC    CL15'Parwick Street '
         DC    CL15'Anson Road     '
         DC    CL15'Lovedale Avenue'
         DC    CL15'Forest Park Rd '
         DC    CL15'Langston Court '
         DC    CL15'Halifax Street '
         DC    CL15'Norwood Road   '
         DC    CL15'Cash Road      '
         DC    CL15'Mercantile Row '
         DC    CL15'Cromwell Street'
         DC    CL15'Technology Dr  '
ADDRTABL EQU   (*-ADDRTAB)
         DC    XL4'FFFFFFFF'
ADDRLEN  EQU   15
*
ADR1TAB  DS    0H                      house number
         DC    CL5'8130'
         DC    CL5'337'
         DC    CL5'3811'
         DC    CL5'9916'
         DC    CL5'1250'
         DC    CL5'1240'
         DC    CL5'10'
         DC    CL5'103'
         DC    CL5'2340'
         DC    CL5'3130'
         DC    CL5'1040'
         DC    CL5'1120'
         DC    CL5'1099'
         DC    CL5'43'
         DC    CL5'702'
         DC    CL5'8302'
         DC    CL5'87'
         DC    CL5'623'
         DC    CL5'6060'
         DC    CL5'599'
         DC    CL5'8020'
         DC    CL5'5110'
         DC    CL5'431 '
ADR1TABL EQU   (*-ADR1TAB)
         DC    XL4'FFFFFFFF'
ADR1LEN  EQU   5
*
ADR2TAB  DS    0H                      apartment number or none
         DC    CL20'1010'
         DC    CL20'    '
         DC    CL20'    '
         DC    CL20'2021'
         DC    CL20'5353'
         DC    CL20'    '
         DC    CL20'    '
         DC    CL20'113 '
         DC    CL20'    '
         DC    CL20'    '
         DC    CL20'    '
         DC    CL20'123 '
         DC    CL20'    '
         DC    CL20'    '
         DC    CL20'79  '
         DC    CL20'    '
         DC    CL20'81  '
         DC    CL20'    '
         DC    CL20'    '
         DC    CL20'10  '
         DC    CL20'    '
         DC    CL20'119 '
         DC    CL20'    '
         DC    CL20'    '
ADR2TABL EQU   (*-ADR2TAB)
         DC    XL4'FFFFFFFF'
ADR2LEN  EQU   20
*
ADR3TAB  DS    0H                      city state zip
         DC    CL20'Dallas              ',Cl2'TX',CL5'75223'
         DC    CL20'Forth Worth         ',Cl2'TX',CL5'76102'
         DC    CL20'Addison             ',Cl2'TX',CL5'75254'
         DC    CL20'Carrolton           ',Cl2'TX',CL5'75006'
         DC    CL20'Manfield            ',Cl2'TX',CL5'76063'
         DC    CL20'Allen               ',Cl2'TX',CL5'75013'
         DC    CL20'McKinney            ',Cl2'TX',CL5'75070'
         DC    CL20'Frisco              ',Cl2'TX',CL5'75033'
         DC    CL20'Richardson          ',Cl2'TX',CL5'75080'
         DC    CL20'Issaquah            ',Cl2'WA',CL5'98027'
         DC    CL20'Bremerton           ',Cl2'WA',CL5'98312'
         DC    CL20'Silverdale          ',Cl2'WA',CL5'98383'
         DC    CL20'Seattle             ',Cl2'WA',CL5'98104'
         DC    CL20'Renton              ',Cl2'WA',CL5'98057'
         DC    CL20'North Bend          ',Cl2'WA',CL5'98045'
         DC    CL20'Port Orchard        ',Cl2'WA',CL5'98366'
         DC    CL20'Port Ludlow         ',Cl2'WA',CL5'98365'
         DC    CL20'Flagstaff           ',Cl2'AZ',CL5'86001'
         DC    CL20'Phoenix             ',Cl2'AZ',CL5'85009'
         DC    CL20'Scottsdale          ',Cl2'AZ',CL5'85251'
         DC    CL20'Winslow             ',Cl2'AZ',CL5'86047'
         DC    CL20'Chandler            ',Cl2'AZ',CL5'85286'
         DC    CL20'Coolidge            ',Cl2'AZ',CL5'85128'
         DC    CL20'Tuscon              ',Cl2'AZ',CL5'85713'
         DC    CL20'Glendale            ',Cl2'AZ',CL5'85301'
ADR3TABL EQU   (*-ADR3TAB)
         DC    XL4'FFFFFFFF'
ADR3LEN  EQU   27
*
IQTYTAB  DS    0H
         DC    H'1'
         DC    H'10'
         DC    H'2'
         DC    H'9'
         DC    H'3'
         DC    H'8'
         DC    H'4'
         DC    H'7'
         DC    H'5'
         DC    H'6'
         DC    XL2'FFFF'
*
STRADDR  DS    0H
    DC CL3'001',CL30'8010 LAKE FOREST DRIVE',CL20'DALLAS',CL7'TX75203'
    DC CL3'002',CL30'159 SYCAMORE STREET  ',CL20'PHOENIX',CL7'AZ45201'
    DC CL3'003',CL30'2289 PACIFIC HWY     ',CL20'SEATTLE',CL7'WA98104'
    DC CL3'004',CL30'1 LAKE PLAZA         ',CL20'BUFFALO',CL7'NY14201'
    DC CL3'005',CL30'100 MAIN STREET      ',CL20'TAMPA  ',CL7'FL33601'
STRLEN   EQU   (*-STRADDR)
STRLN    EQU   60
*
SPACES   DC    CL256' '
*
*
CSTFILE  DCB   DSORG=PS,DDNAME=CUSTOMER,MACRF=(PM),DCBE=CSTDCBE,       X
               RECFM=FB,LRECL=78
CSTEOFF  EQU   *-CSTFILE
CSTDCBE  DCBE  RMODE31=BUFF
CSTFILEL EQU   *-CSTFILE
*
CNAFILE  DCB   DSORG=PS,DDNAME=CUSTNAME,MACRF=(PM),DCBE=CSTDCBE,       X
               RECFM=FB,LRECL=96
CNAEOFF  EQU   *-CNAFILE
CNADCBE  DCBE  RMODE31=BUFF
CNAFILEL EQU   *-CNAFILE
*
ORDFILE  DCB   DSORG=PS,DDNAME=ORDER,MACRF=(PM),DCBE=CSTDCBE,          X
               RECFM=FB,LRECL=47
ORDEOFF  EQU   *-ORDFILE
ORDDCBE  DCBE  RMODE31=BUFF
ORDFILEL EQU   *-ORDFILE
*
ITMFILE  DCB   DSORG=PS,DDNAME=ORDITM01,MACRF=(PM),DCBE=CSTDCBE,       X
               RECFM=FB,LRECL=36
ITMEOFF  EQU   *-ITMFILE
ITMDCBE  DCBE  RMODE31=BUFF
ITMFILEL EQU   *-ITMFILE
*
PRDFILE  DCB   DSORG=PS,DDNAME=PRODUCT,MACRF=(PM),DCBE=CSTDCBE,        X
               RECFM=FB,LRECL=23
PRDEOFF  EQU   *-PRDFILE
PRDDCBE  DCBE  RMODE31=BUFF
PRDFILEL EQU   *-PRDFILE
*
DSCFILE  DCB   DSORG=PS,DDNAME=PRODDESC,MACRF=(PM),DCBE=CSTDCBE,       X
               RECFM=FB,LRECL=40
DSCEOFF  EQU   *-DSCFILE
DSCDCBE  DCBE  RMODE31=BUFF
DSCFILEL EQU   *-DSCFILE
*
ADRFILE  DCB   DSORG=PS,DDNAME=CUSTADDR,MACRF=(PM),DCBE=CSTDCBE,       X
               RECFM=FB,LRECL=103
ADREOFF  EQU   *-ADRFILE
ADRDCBE  DCBE  RMODE31=BUFF
ADRFILEL EQU   *-ADRFILE
*
STRFILE  DCB   DSORG=PS,DDNAME=STOREADR,MACRF=(PM),DCBE=CSTDCBE,       X
               RECFM=FB,LRECL=60
STREOFF  EQU   *-STRFILE
STRDCBE  DCBE  RMODE31=BUFF
STRFILEL EQU   *-STRFILE
*
outfile  DCB   DSORG=PS,DDNAME=SYSPRINT,MACRF=(PM),DCBE=outfdcbe,      x
               RECFM=FB,LRECL=131
outfile0 EQU   *-outfile
outfdcbe DCBE  RMODE31=BUFF
outfilel EQU   *-outfile
*
STATOPEN OPEN  (,OUTPUT),MODE=31,MF=L
STATOPENL EQU  *-STATOPEN
*
STATCLOS CLOSE (),MODE=31,MF=L
STATCLOSL EQU  *-STATCLOS
*
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
*
         END
