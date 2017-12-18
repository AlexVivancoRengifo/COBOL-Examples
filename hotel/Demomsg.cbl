000001 IDENTIFICATION DIVISION.
000002 PROGRAM-ID. "DEMOMSG".
000003 ENVIRONMENT DIVISION.
000004 CONFIGURATION SECTION.
000005 SPECIAL-NAMES.
000006 INPUT-OUTPUT SECTION.
000007 FILE-CONTROL.
000008 DATA DIVISION.
000009 FILE SECTION.
000010 WORKING-STORAGE SECTION.
000011******************************************************************
000012*        SHEET(ITEM) ===>    DEMOMSG
000013*        EVENT       ===>    WORKING
000014*                                1993.11.24 TOWA.SYSTEM.INC(NAKAI)
000015******************************************************************
000016*
000017 01  EX-AREA IS  GLOBAL  IS  EXTERNAL.
000018     03  RSV-INFORMATION.
000019         05  EX-RSVDATE      PIC X(10).
000020         05  EX-RSVNUM       PIC X(09).
000021         05  EX-RSVROOM      PIC X(04).
000022         05  EX-RSVTYPE      PIC X(02).
000023         05  EX-RSVNAME      PIC X(20).
000024         05  EX-RSVTEL       PIC X(12).
000025         05  EX-RSVSTAY      PIC X(02).
000026         05  EX-RSVTHIS      PIC X(09).
000027*
000028     03  MESSAGE-AREA.
000029         05  MSG-ERR         PIC X(80).
000030*
000031     03  SWITCH-AREA.
000032         05  RSV-SW          PIC X(02).
000033         05  SEL-SW          PIC 9(01).
000034*
000035     03  INDEX-AREA.
000036         05  DEL-IDX         PIC S9(04)  COMP-5.
000037         05  TBL-IDX         PIC S9(04)  COMP-5.
000038*
000039     03  ROOM-INFORMATION-LIST.
000040         05  TYPE-INFORMATION    OCCURS  7   TIMES.
000041             07  ROOM-TYPE-CODE  PIC X(02).
000042             07  ROOM-TYPE-NAME  PIC X(16).
000043             07  ROOM-TOTAL-NUM  PIC 9(04).
000044             07  ROOM-RSV-NUM    PIC 9(04).
000045*
000046     03  RSV-DATE-LIST.
000047         05  RSV-DATE    PIC X(10)   OCCURS  100 TIMES.
000048*
000049     03  RSV-NUM-LIST.
000050         05  RSV-NUM     PIC X(09)   OCCURS  100 TIMES
000051                                     INDEXED BY  RSVNO-IDX.
000052*
000053     03  RSV-ROOM-LIST.
000054         05  RSV-ROOM    PIC X(04)   OCCURS  100 TIMES
000055                                     INDEXED BY  RSV-IDX.
000056*
000057     03  ROOM-LIST.
000058         04  ROOM-TYPE-LIST.
000059             05  GUEST-ROOM-TYPE-TABLE   OCCURS  6   TIMES.
000060                 07  GUEST-ROOM          OCCURS  20  TIMES.
000061                     09  GUEST-ROOM-NUM  PIC X(04).
000062                     09  GUEST-ROOM-TYPE PIC X(02).
000063         04  ROOM-NUM-LIST   REDEFINES   ROOM-TYPE-LIST.
000064             05  ROOM-TABLE  OCCURS  120 INDEXED BY  ROOM-IDX.
000065                 07  ROOM-NUM        PIC X(04).
000066                 07  ROOM-TYPE       PIC X(02).  
000067*
000068     03  NAME-LIST.
000069         05  GUEST-NAME  PIC X(20)   OCCURS  100 TIMES
000070                                 INDEXED BY  NAME-IDX.
000071*
000072     03  TEL-LIST.
000073         05  TEL-NUM         PIC X(12)   OCCURS  100 TIMES
000074                                         INDEXED BY  TEL-IDX.
000075*
000076     03  STAY-LIST.
000077         05  STAY-NUM    PIC X(02)   OCCURS  100 TIMES
000078                                     INDEXED BY  CNT-IDX.
000079*
000080 01 POWER--HPOWOBJS-DEMOMSG IS GLOBAL IS EXTERNAL.
000081   02 POWER--HPOWOBJ--DEMOMSG.
000081     03 DEMOMSG PIC S9(9) COMP-5.
000081     03 POW-P001 REDEFINES  DEMOMSG USAGE POINTER.
000081   02 POWER--HPOWOBJ--MSG.
000081     03 MSG PIC S9(9) COMP-5.
000081     03 POW-P002 REDEFINES  MSG USAGE POINTER.
000081   02 POWER--HPOWOBJ--PUSHOK.
000081     03 PUSHOK PIC S9(9) COMP-5.
000081     03 POW-P003 REDEFINES  PUSHOK USAGE POINTER.
000082 01  REDEFINES POWER--HPOWOBJS-DEMOMSG.
000083   02  POWER--HPOWOBJS PICTURE IS X(4) OCCURS 3 TIMES.
000084 LOCAL-STORAGE SECTION.
000085 LINKAGE SECTION.
000086 01  POWER--HPOWOBJ IS GLOBAL PICTURE IS  X(4).
000087 01  POWER--ID      IS GLOBAL PICTURE IS S9(4)
000088                    USAGE IS COMPUTATIONAL-5.
000089 01  POWER--NOTIFY  IS GLOBAL PICTURE IS S9(4)
000090                    USAGE IS COMPUTATIONAL-5.
000091 01  POWER--MESSAGE IS GLOBAL PICTURE IS S9(4)
000092                    USAGE IS COMPUTATIONAL-5.
000093 PROCEDURE DIVISION
000094     USING POWER--HPOWOBJ POWER--ID POWER--MESSAGE POWER--NOTIFY.
000095     EVALUATE POWER--MESSAGE
000096     WHEN 1025
000097         EVALUATE POWER--HPOWOBJ
000098         WHEN POWER--HPOWOBJ--PUSHOK
000099             EVALUATE POWER--NOTIFY
000100             WHEN 1 
000101                CALL "PUSHOK-CLICK"
000102             END-EVALUATE
000103         END-EVALUATE
000104     WHEN 1024
000105         MOVE POWER--HPOWOBJ TO POWER--HPOWOBJS (POWER--ID + 1)
000106     WHEN 1036
000107         CALL "DEMOMSG-OPENED"
000108     WHEN 1038
000109         CALL "DEMOMSG-START"
000110     END-EVALUATE
000111     EXIT PROGRAM.
000112 IDENTIFICATION DIVISION.
000113 PROGRAM-ID. "DEMOMSG-OPENED".
000114 ENVIRONMENT DIVISION.
000115 DATA        DIVISION.
000115 WORKING-STORAGE SECTION.
000115 77 POW-0001 PIC X(256) .
000116 PROCEDURE   DIVISION.
000117******************************************************************
000118 MAIN                SECTION.
000119******************************************************************
000120*
000121     MOVE  MSG-ERR  TO POW-0001.
000121     CALL  "_XPOWCWSETTEXT"  USING BY VALUE MSG  BY REFERENCE
000121      POW-0001 .
000122*
000123 MAIN-EX.
000124     EXIT    PROGRAM.
000125 END PROGRAM "DEMOMSG-OPENED".
000126 IDENTIFICATION DIVISION.
000127 PROGRAM-ID. "DEMOMSG-START".
000128 PROCEDURE DIVISION.
000129     EXIT PROGRAM.
000130 END PROGRAM "DEMOMSG-START".
000131 IDENTIFICATION DIVISION.
000132 PROGRAM-ID. "PUSHOK-CLICK".
000133 ENVIRONMENT DIVISION.
000134 DATA        DIVISION.
000134 WORKING-STORAGE SECTION.
000134 77 POW-0001 PIC X(14) .
000135 PROCEDURE   DIVISION.
000136******************************************************************
000137 MAIN                SECTION.
000138******************************************************************
000139*
000140     MOVE  "DEMOMSG"  TO POW-0001.
000140     CALL    "_XPOWCSCLOSESHEET"  USING BY VALUE DEMOMSG
000140      BY REFERENCE POW-0001 .
000141*
000142 MAIN-EX.
000143     EXIT    PROGRAM.
000144 END PROGRAM "PUSHOK-CLICK".
000145 END PROGRAM "DEMOMSG".
