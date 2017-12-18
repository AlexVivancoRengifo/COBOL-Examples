000001 IDENTIFICATION DIVISION.
000002 PROGRAM-ID. "HOTEL".
000003 ENVIRONMENT DIVISION.
000004 CONFIGURATION SECTION.
000005 SPECIAL-NAMES.
000006 INPUT-OUTPUT SECTION.
000007 FILE-CONTROL.
000008 DATA DIVISION.
000009 BASED-STORAGE SECTION.
000010 FILE SECTION.
000011 WORKING-STORAGE SECTION.
000012 01 POWER--HPOWOBJS-HOTEL IS GLOBAL IS EXTERNAL.
000013   02 POWER--HPOWOBJ--HOTEL.
000013     03 HOTEL PIC S9(9) COMP-5.
000013     03 POW-P001 REDEFINES  HOTEL USAGE POINTER.
000013   02 POWER--HPOWOBJ--IMAGE1.
000013     03 IMAGE1 PIC S9(9) COMP-5.
000013     03 POW-P002 REDEFINES  IMAGE1 USAGE POINTER.
000013   02 POWER--HPOWOBJ--PUSH1.
000013     03 PUSH1 PIC S9(9) COMP-5.
000013     03 POW-P003 REDEFINES  PUSH1 USAGE POINTER.
000013   02 POWER--HPOWOBJ--PUSH2.
000013     03 PUSH2 PIC S9(9) COMP-5.
000013     03 POW-P004 REDEFINES  PUSH2 USAGE POINTER.
000013   02 POWER--HPOWOBJ--LABEL2.
000013     03 LABEL2 PIC S9(9) COMP-5.
000013     03 POW-P005 REDEFINES  LABEL2 USAGE POINTER.
000013   02 POWER--HPOWOBJ--LABEL3.
000013     03 LABEL3 PIC S9(9) COMP-5.
000013     03 POW-P006 REDEFINES  LABEL3 USAGE POINTER.
000014 01  REDEFINES POWER--HPOWOBJS-HOTEL.
000015   02  POWER--HPOWOBJS PICTURE IS X(4) OCCURS 6 TIMES.
000016 01  POWER-HPOWOBJIDX PIC S9(9) COMP-5.
000017******************************************************************
000018*        SHEET(ITEM) ===>    HOTEL
000019*        EVENT       ===>    WORKING
000020*                                1993.11.24 TOWA.SYSTEM.INC(NAKAI)
000021*                        UPDATE for ENGLISH 1994.10.24 K.IIZUKA
000022******************************************************************
000023*
000024 01  EX-AREA IS  GLOBAL  IS  EXTERNAL.
000025     03  RSV-INFORMATION.
000026         05  EX-RSVDATE      PIC X(10).
000027         05  EX-RSVNUM       PIC X(09).
000028         05  EX-RSVROOM      PIC X(04).
000029         05  EX-RSVTYPE      PIC X(02).
000030         05  EX-RSVNAME      PIC X(20).
000031         05  EX-RSVTEL       PIC X(12).
000032         05  EX-RSVSTAY      PIC X(02).
000033         05  EX-RSVTHIS      PIC X(09).
000034*
000035     03  MESSAGE-AREA.
000036         05  MSG-ERR         PIC X(80).
000037*
000038     03  SWITCH-AREA.
000039         05  RSV-SW          PIC X(02).
000040         05  SEL-SW          PIC 9(01).
000041*
000042     03  INDEX-AREA.
000043         05  DEL-IDX         PIC S9(04)  COMP-5.
000044         05  TBL-IDX         PIC S9(04)  COMP-5.
000045*
000046     03  ROOM-INFORMATION-LIST.
000047         05  TYPE-INFORMATION    OCCURS  7   TIMES.
000048             07  ROOM-TYPE-CODE  PIC X(02).
000049             07  ROOM-TYPE-NAME  PIC X(16).
000050             07  ROOM-TOTAL-NUM  PIC 9(04).
000051             07  ROOM-RSV-NUM    PIC 9(04).
000052*
000053     03  RSV-DATE-LIST.
000054         05  RSV-DATE    PIC X(10)   OCCURS  100 TIMES.
000055*
000056     03  RSV-NUM-LIST.
000057         05  RSV-NUM     PIC X(09)   OCCURS  100 TIMES
000058                                     INDEXED BY  RSVNO-IDX.
000059*
000060     03  RSV-ROOM-LIST.
000061         05  RSV-ROOM    PIC X(04)   OCCURS  100 TIMES
000062                                     INDEXED BY  RSV-IDX.
000063*
000064     03  ROOM-LIST.
000065         04  ROOM-TYPE-LIST.
000066             05  GUEST-ROOM-TYPE-TABLE   OCCURS  6   TIMES.
000067                 07  GUEST-ROOM          OCCURS  20  TIMES.
000068                     09  GUEST-ROOM-NUM  PIC X(04).
000069                     09  GUEST-ROOM-TYPE PIC X(02).
000070         04  ROOM-NUM-LIST   REDEFINES   ROOM-TYPE-LIST.
000071             05  ROOM-TABLE  OCCURS  120 INDEXED BY  ROOM-IDX.
000072                 07  ROOM-NUM        PIC X(04).
000073                 07  ROOM-TYPE       PIC X(02).  
000074*
000075     03  NAME-LIST.
000076         05  GUEST-NAME  PIC X(20)   OCCURS  100 TIMES
000077                                 INDEXED BY  NAME-IDX.
000078*
000079     03  TEL-LIST.
000080         05  TEL-NUM         PIC X(12)   OCCURS  100 TIMES
000081                                         INDEXED BY  TEL-IDX.
000082*
000083     03  STAY-LIST.
000084         05  STAY-NUM    PIC X(02)   OCCURS  100 TIMES
000085                                     INDEXED BY  CNT-IDX.
000086*
000087 CONSTANT SECTION.
000088******************************************************************
000089*        SHEET(ITEM)     :   HOTEL
000090*        EVENT           :   CONSTANT
000091******************************************************************
000092 01  CONST-ROOM-INFORMATION  IS  GLOBAL.
000093     03  ROOM-INFORMATION-DEF.
000094         05  FILLER  PIC X(02)   VALUE   "S1".
000095         05  FILLER  PIC X(16)   VALUE   "S1: SINGLE".
000096         05  FILLER  PIC 9(04)   VALUE   20.
000097         05  FILLER  PIC 9(04)   VALUE   11.
000098         05  FILLER  PIC X(02)   VALUE   "S2".
000099         05  FILLER  PIC X(16)   VALUE   "S2: SINGLE".
000100         05  FILLER  PIC 9(04)   VALUE   20.
000101         05  FILLER  PIC 9(04)   VALUE   4.
000102         05  FILLER  PIC X(02)   VALUE   "W".
000103         05  FILLER  PIC X(16)   VALUE   "W: DOUBLE".
000104         05  FILLER  PIC 9(04)   VALUE   20.
000105         05  FILLER  PIC 9(04)   VALUE   4.
000106         05  FILLER  PIC X(02)   VALUE   "T1".
000107         05  FILLER  PIC X(16)   VALUE   "T1: TWIN".
000108         05  FILLER  PIC 9(04)   VALUE   10.
000109         05  FILLER  PIC 9(04)   VALUE   0.
000110         05  FILLER  PIC X(02)   VALUE   "T2".
000111         05  FILLER  PIC X(16)   VALUE   "T2: TWIN".
000112         05  FILLER  PIC 9(04)   VALUE   10.
000113         05  FILLER  PIC 9(04)   VALUE   0.
000114         05  FILLER  PIC X(02)   VALUE   "SU".
000115         05  FILLER  PIC X(16)   VALUE   "SU: SUIT".
000116         05  FILLER  PIC 9(04)   VALUE   10.
000117         05  FILLER  PIC 9(04)   VALUE   2.
000118         05  FILLER  PIC X(02)   VALUE   "KE".
000119         05  FILLER  PIC X(16)   VALUE   "*** TOTAL ***".
000120         05  FILLER  PIC 9(04)   VALUE   100.
000121         05  FILLER  PIC 9(04)   VALUE   21.
000122*
000123 01  CONST-RSV-DATE  IS  GLOBAL.
000124     02  RSV-DATE-DEF.
000125         03  FILLER      PIC X(10)   VALUE   IS  "1995/09/24".
000126         03  FILLER      PIC X(10)   VALUE   IS  "1995/09/24".
000127         03  FILLER      PIC X(10)   VALUE   IS  "1995/09/24".
000128         03  FILLER      PIC X(10)   VALUE   IS  "1995/09/24".
000129         03  FILLER      PIC X(10)   VALUE   IS  "1995/09/24".
000130         03  FILLER      PIC X(10)   VALUE   IS  "1995/09/24".
000131         03  FILLER      PIC X(10)   VALUE   IS  "1995/09/24".
000132         03  FILLER      PIC X(10)   VALUE   IS  "1995/09/24".
000133         03  FILLER      PIC X(10)   VALUE   IS  "1995/09/24".
000134         03  FILLER      PIC X(10)   VALUE   IS  "1995/09/24".
000135         03  FILLER      PIC X(10)   VALUE   IS  "1995/09/24".
000136         03  FILLER      PIC X(10)   VALUE   IS  "1995/09/24".
000137         03  FILLER      PIC X(10)   VALUE   IS  "1995/09/24".
000138         03  FILLER      PIC X(10)   VALUE   IS  "1995/09/24".
000139         03  FILLER      PIC X(10)   VALUE   IS  "1995/09/24".
000140         03  FILLER      PIC X(10)   VALUE   IS  "1995/09/24".
000141         03  FILLER      PIC X(10)   VALUE   IS  "1995/09/24".
000142         03  FILLER      PIC X(10)   VALUE   IS  "1995/09/24".
000143         03  FILLER      PIC X(10)   VALUE   IS  "1995/09/24".
000144         03  FILLER      PIC X(10)   VALUE   IS  "1995/09/24".
000145         03  FILLER      PIC X(10)   VALUE   IS  "1995/09/24".
000146
000147
000148 01  CONST-RSV-NUM       IS  GLOBAL.
000149     02  RSV-NUM-DEF.
000150         03  FILLER      PIC X(09)   VALUE   IS  "1111-0001".
000151         03  FILLER      PIC X(09)   VALUE   IS  "1111-0002".
000152         03  FILLER      PIC X(09)   VALUE   IS  "1111-0003".
000153         03  FILLER      PIC X(09)   VALUE   IS  "1111-0004".
000154         03  FILLER      PIC X(09)   VALUE   IS  "1111-0005".
000155         03  FILLER      PIC X(09)   VALUE   IS  "1111-0006".
000156         03  FILLER      PIC X(09)   VALUE   IS  "1111-0007".
000157         03  FILLER      PIC X(09)   VALUE   IS  "1111-0008".
000158         03  FILLER      PIC X(09)   VALUE   IS  "1111-0009".
000159         03  FILLER      PIC X(09)   VALUE   IS  "1111-0010".
000160         03  FILLER      PIC X(09)   VALUE   IS  "1111-0011".
000161         03  FILLER      PIC X(09)   VALUE   IS  "1111-0012".
000162         03  FILLER      PIC X(09)   VALUE   IS  "1111-0013".
000163         03  FILLER      PIC X(09)   VALUE   IS  "1111-0014".
000164         03  FILLER      PIC X(09)   VALUE   IS  "1111-0015".
000165         03  FILLER      PIC X(09)   VALUE   IS  "1111-0016".
000166         03  FILLER      PIC X(09)   VALUE   IS  "1111-0017".
000167         03  FILLER      PIC X(09)   VALUE   IS  "1111-0018".
000168         03  FILLER      PIC X(09)   VALUE   IS  "1111-0019".
000169         03  FILLER      PIC X(09)   VALUE   IS  "1111-0020".
000170         03  FILLER      PIC X(09)   VALUE   IS  "1111-0021".
000171         
000172 01  CONST-RSV-ROOM  IS  GLOBAL.
000173     02  RSV-ROOM-DEF.
000174         03  FILLER      PIC X(04)   VALUE   IS  "0201".
000175         03  FILLER      PIC X(04)   VALUE   IS  "0202".
000176         03  FILLER      PIC X(04)   VALUE   IS  "0203".
000177         03  FILLER      PIC X(04)   VALUE   IS  "0204".
000178         03  FILLER      PIC X(04)   VALUE   IS  "0215".
000179         03  FILLER      PIC X(04)   VALUE   IS  "0300".
000180         03  FILLER      PIC X(04)   VALUE   IS  "0251".
000181         03  FILLER      PIC X(04)   VALUE   IS  "0252".
000182         03  FILLER      PIC X(04)   VALUE   IS  "0221".
000183         03  FILLER      PIC X(04)   VALUE   IS  "0222".
000184         03  FILLER      PIC X(04)   VALUE   IS  "0211".
000185         03  FILLER      PIC X(04)   VALUE   IS  "0212".
000186         03  FILLER      PIC X(04)   VALUE   IS  "0213".
000187         03  FILLER      PIC X(04)   VALUE   IS  "0214".
000188         03  FILLER      PIC X(04)   VALUE   IS  "0206".
000189         03  FILLER      PIC X(04)   VALUE   IS  "0299".
000190         03  FILLER      PIC X(04)   VALUE   IS  "0252".
000191         03  FILLER      PIC X(04)   VALUE   IS  "0254".
000192         03  FILLER      PIC X(04)   VALUE   IS  "0223".
000193         03  FILLER      PIC X(04)   VALUE   IS  "0224".
000194         03  FILLER      PIC X(04)   VALUE   IS  "0207".
000195*
000196 01  CONST-NAME  IS  GLOBAL.
000197     02  NAME-DEF.
000198         03  FILLER  PIC X(20)   VALUE   IS  "EMI.WAKUI".
000199         03  FILLER  PIC X(20)   VALUE   IS  "AKINA.NAKAMORI".
000200         03  FILLER  PIC X(20)   VALUE   IS  "NOBUNAGA.ODA".
000201         03  FILLER  PIC X(20)   VALUE   IS  "IEYASU.TOKUGAWA".
000202         03  FILLER  PIC X(20)   VALUE   IS  "HIDEYOSHI.TOYOTOMI".
000203         03  FILLER  PIC X(20)   VALUE   IS  "SHOTOKU.TAISHI".
000204         03  FILLER  PIC X(20)   VALUE   IS  "HIROBUMI.ITOH".
000205         03  FILLER  PIC X(20)   VALUE   IS  "SOHSEKI.NATSUME".
000206         03  FILLER  PIC X(20)   VALUE   IS  "SHIGENOBU.OHKUMA".
000207         03  FILLER  PIC X(20)   VALUE   IS  "TAKESHI.KITANO".
000208         03  FILLER  PIC X(20)   VALUE   IS  "EMI.WAKUI".
000209         03  FILLER  PIC X(20)   VALUE   IS  "AKINA.NAKAMORI".
000210         03  FILLER  PIC X(20)   VALUE   IS  "NOBUNAGA.ODA".
000211         03  FILLER  PIC X(20)   VALUE   IS  "IEYASU.TOKUGAWA".
000212         03  FILLER  PIC X(20)   VALUE   IS  "HIDEYOSHI.TOYOTOMI".
000213         03  FILLER  PIC X(20)   VALUE   IS  "SHOTOKU.TAISHI".
000214         03  FILLER  PIC X(20)   VALUE   IS  "HIROBUMI.ITOH".
000215         03  FILLER  PIC X(20)   VALUE   IS  "SOHSEKI.NATSUME".
000216         03  FILLER  PIC X(20)   VALUE   IS  "SHIGENOBU.OHKUMA".
000217         03  FILLER  PIC X(20)   VALUE   IS  "TAKESHI.KITANO".
000218*
000219 01  CONST-TEL   IS  GLOBAL.
000220     02  TEL-DEF.
000221         03  FILLER      PIC X(12)   VALUE   IS  "03-1234-1234".
000222         03  FILLER      PIC X(12)   VALUE   IS  "052-111-2222".
000223         03  FILLER      PIC X(12)   VALUE   IS  "0562-22-3333".
000224         03  FILLER      PIC X(12)   VALUE   IS  "0567-33-4455".
000225         03  FILLER      PIC X(12)   VALUE   IS  "052-987-6543".
000226         03  FILLER      PIC X(12)   VALUE   IS  "052-212-3456".
000227         03  FILLER      PIC X(12)   VALUE   IS  "052-555-7777".
000228         03  FILLER      PIC X(12)   VALUE   IS  "03-5512-3456".
000229         03  FILLER      PIC X(12)   VALUE   IS  "03-5641-6125".
000230         03  FILLER      PIC X(12)   VALUE   IS  "052-454-4568".
000231         03  FILLER      PIC X(12)   VALUE   IS  "03-1234-1234".
000232         03  FILLER      PIC X(12)   VALUE   IS  "052-111-2222".
000233         03  FILLER      PIC X(12)   VALUE   IS  "0562-22-3333".
000234         03  FILLER      PIC X(12)   VALUE   IS  "0567-33-4455".
000235         03  FILLER      PIC X(12)   VALUE   IS  "052-987-6543".
000236         03  FILLER      PIC X(12)   VALUE   IS  "052-212-3456".
000237         03  FILLER      PIC X(12)   VALUE   IS  "052-555-7777".
000238         03  FILLER      PIC X(12)   VALUE   IS  "03-5512-3456".
000239         03  FILLER      PIC X(12)   VALUE   IS  "03-5641-6125".
000240         03  FILLER      PIC X(12)   VALUE   IS  "052-454-4568".
000241         03  FILLER      PIC X(12)   VALUE   IS  "052-454-4568".
000242*
000243 01  CONST-STAY  IS  GLOBAL.
000244     02  STAY-DEF.
000245         03  FILLER      PIC X(02)   VALUE   IS  "01".
000246         03  FILLER      PIC X(02)   VALUE   IS  "02".
000247         03  FILLER      PIC X(02)   VALUE   IS  "03".
000248         03  FILLER      PIC X(02)   VALUE   IS  "02".
000249         03  FILLER      PIC X(02)   VALUE   IS  "02".
000250         03  FILLER      PIC X(02)   VALUE   IS  "01".
000251         03  FILLER      PIC X(02)   VALUE   IS  "06".
000252         03  FILLER      PIC X(02)   VALUE   IS  "08".
000253         03  FILLER      PIC X(02)   VALUE   IS  "10".
000254         03  FILLER      PIC X(02)   VALUE   IS  "02".
000255         03  FILLER      PIC X(02)   VALUE   IS  "01".
000256         03  FILLER      PIC X(02)   VALUE   IS  "02".
000257         03  FILLER      PIC X(02)   VALUE   IS  "03".
000258         03  FILLER      PIC X(02)   VALUE   IS  "02".
000259         03  FILLER      PIC X(02)   VALUE   IS  "02".
000260         03  FILLER      PIC X(02)   VALUE   IS  "01".
000261         03  FILLER      PIC X(02)   VALUE   IS  "06".
000262         03  FILLER      PIC X(02)   VALUE   IS  "08".
000263         03  FILLER      PIC X(02)   VALUE   IS  "10".
000264         03  FILLER      PIC X(02)   VALUE   IS  "02".
000265         03  FILLER      PIC X(02)   VALUE   IS  "02".
000266*
000267****     MASTER TABLE
000268*
000269 01  CONST-ROOM  IS  GLOBAL.
000270     02  ROOM-DEF.
000271         03  FILLER      PIC X(06)   VALUE   IS  "0201S1".
000272         03  FILLER      PIC X(06)   VALUE   IS  "0202S1".
000273         03  FILLER      PIC X(06)   VALUE   IS  "0203S1".
000274         03  FILLER      PIC X(06)   VALUE   IS  "0204S1".
000275         03  FILLER      PIC X(06)   VALUE   IS  "0205S1".
000276         03  FILLER      PIC X(06)   VALUE   IS  "0206S1".
000277         03  FILLER      PIC X(06)   VALUE   IS  "0207S1".
000278         03  FILLER      PIC X(06)   VALUE   IS  "0208S1".
000279         03  FILLER      PIC X(06)   VALUE   IS  "0209S1".
000280         03  FILLER      PIC X(06)   VALUE   IS  "0210S1".
000281         03  FILLER      PIC X(06)   VALUE   IS  "0211S1".
000282         03  FILLER      PIC X(06)   VALUE   IS  "0212S1".
000283         03  FILLER      PIC X(06)   VALUE   IS  "0213S1".
000284         03  FILLER      PIC X(06)   VALUE   IS  "0214S1".
000285         03  FILLER      PIC X(06)   VALUE   IS  "0215S1".
000286         03  FILLER      PIC X(06)   VALUE   IS  "0216S1".
000287         03  FILLER      PIC X(06)   VALUE   IS  "0217S1".
000288         03  FILLER      PIC X(06)   VALUE   IS  "0218S1".
000289         03  FILLER      PIC X(06)   VALUE   IS  "0219S1".
000290         03  FILLER      PIC X(06)   VALUE   IS  "0220S1".
000291* 
000292         03  FILLER      PIC X(06)   VALUE   IS  "0221S2".
000293         03  FILLER      PIC X(06)   VALUE   IS  "0222S2".
000294         03  FILLER      PIC X(06)   VALUE   IS  "0223S2".
000295         03  FILLER      PIC X(06)   VALUE   IS  "0224S2".
000296         03  FILLER      PIC X(06)   VALUE   IS  "0225S2".
000297         03  FILLER      PIC X(06)   VALUE   IS  "0226S2".
000298         03  FILLER      PIC X(06)   VALUE   IS  "0227S2".
000299         03  FILLER      PIC X(06)   VALUE   IS  "0228S2".
000300         03  FILLER      PIC X(06)   VALUE   IS  "0229S2".
000301         03  FILLER      PIC X(06)   VALUE   IS  "0230S2".
000302         03  FILLER      PIC X(06)   VALUE   IS  "0231S2".
000303         03  FILLER      PIC X(06)   VALUE   IS  "0232S2".
000304         03  FILLER      PIC X(06)   VALUE   IS  "0233S2".
000305         03  FILLER      PIC X(06)   VALUE   IS  "0234S2".
000306         03  FILLER      PIC X(06)   VALUE   IS  "0235S2".
000307         03  FILLER      PIC X(06)   VALUE   IS  "0236S2".
000308         03  FILLER      PIC X(06)   VALUE   IS  "0237S2".
000309         03  FILLER      PIC X(06)   VALUE   IS  "0238S2".
000310         03  FILLER      PIC X(06)   VALUE   IS  "0239S2".
000311         03  FILLER      PIC X(06)   VALUE   IS  "0240S2".
000312* 
000313         03  FILLER      PIC X(06)   VALUE   IS  "0241W".
000314         03  FILLER      PIC X(06)   VALUE   IS  "0242W".
000315         03  FILLER      PIC X(06)   VALUE   IS  "0243W".
000316         03  FILLER      PIC X(06)   VALUE   IS  "0244W".
000317         03  FILLER      PIC X(06)   VALUE   IS  "0245W".
000318         03  FILLER      PIC X(06)   VALUE   IS  "0246W".
000319         03  FILLER      PIC X(06)   VALUE   IS  "0247W".
000320         03  FILLER      PIC X(06)   VALUE   IS  "0248W".
000321         03  FILLER      PIC X(06)   VALUE   IS  "0249W".
000322         03  FILLER      PIC X(06)   VALUE   IS  "0250W".
000323         03  FILLER      PIC X(06)   VALUE   IS  "0251W".
000324         03  FILLER      PIC X(06)   VALUE   IS  "0252W".
000325         03  FILLER      PIC X(06)   VALUE   IS  "0253W".
000326         03  FILLER      PIC X(06)   VALUE   IS  "0254W".
000327         03  FILLER      PIC X(06)   VALUE   IS  "0255W".
000328         03  FILLER      PIC X(06)   VALUE   IS  "0256W".
000329         03  FILLER      PIC X(06)   VALUE   IS  "0257W".
000330         03  FILLER      PIC X(06)   VALUE   IS  "0258W".
000331         03  FILLER      PIC X(06)   VALUE   IS  "0259W".
000332         03  FILLER      PIC X(06)   VALUE   IS  "0260W".
000333*
000334         03  FILLER      PIC X(06)   VALUE   IS  "0261T1".
000335         03  FILLER      PIC X(06)   VALUE   IS  "0262T1".
000336         03  FILLER      PIC X(06)   VALUE   IS  "0263T1".
000337         03  FILLER      PIC X(06)   VALUE   IS  "0264T1".
000338         03  FILLER      PIC X(06)   VALUE   IS  "0265T1".
000339         03  FILLER      PIC X(06)   VALUE   IS  "0266T1".
000340         03  FILLER      PIC X(06)   VALUE   IS  "0267T1".
000341         03  FILLER      PIC X(06)   VALUE   IS  "0268T1".
000342         03  FILLER      PIC X(06)   VALUE   IS  "0269T1".
000343         03  FILLER      PIC X(06)   VALUE   IS  "0270T1".
000344         03  FILLER      PIC X(06)   VALUE   IS  "0271T1".
000345         03  FILLER      PIC X(06)   VALUE   IS  "0272T1".
000346         03  FILLER      PIC X(06)   VALUE   IS  "0273T1".
000347         03  FILLER      PIC X(06)   VALUE   IS  "0274T1".
000348         03  FILLER      PIC X(06)   VALUE   IS  "0275T1".
000349         03  FILLER      PIC X(06)   VALUE   IS  "0276T1".
000350         03  FILLER      PIC X(06)   VALUE   IS  "0277T1".
000351         03  FILLER      PIC X(06)   VALUE   IS  "0278T1".
000352         03  FILLER      PIC X(06)   VALUE   IS  "0279T1".
000353         03  FILLER      PIC X(06)   VALUE   IS  "0280T1".
000354*
000355         03  FILLER      PIC X(06)   VALUE   IS  "0281T2".
000356         03  FILLER      PIC X(06)   VALUE   IS  "0282T2".
000357         03  FILLER      PIC X(06)   VALUE   IS  "0283T2".
000358         03  FILLER      PIC X(06)   VALUE   IS  "0284T2".
000359         03  FILLER      PIC X(06)   VALUE   IS  "0285T2".
000360         03  FILLER      PIC X(06)   VALUE   IS  "0286T2".
000361         03  FILLER      PIC X(06)   VALUE   IS  "0287T2".
000362         03  FILLER      PIC X(06)   VALUE   IS  "0288T2".
000363         03  FILLER      PIC X(06)   VALUE   IS  "0289T2".
000364         03  FILLER      PIC X(06)   VALUE   IS  "0290T2".
000365         03  FILLER      PIC X(60)   VALUE   IS  SPACE.
000366*
000367         03  FILLER      PIC X(06)   VALUE   IS  "0291SU".
000368         03  FILLER      PIC X(06)   VALUE   IS  "0292SU".
000369         03  FILLER      PIC X(06)   VALUE   IS  "0293SU".
000370         03  FILLER      PIC X(06)   VALUE   IS  "0294SU".
000371         03  FILLER      PIC X(06)   VALUE   IS  "0295SU".
000372         03  FILLER      PIC X(06)   VALUE   IS  "0296SU".
000373         03  FILLER      PIC X(06)   VALUE   IS  "0297SU".
000374         03  FILLER      PIC X(06)   VALUE   IS  "0298SU".
000375         03  FILLER      PIC X(06)   VALUE   IS  "0299SU".
000376         03  FILLER      PIC X(06)   VALUE   IS  "0300SU".
000377         03  FILLER      PIC X(06)   VALUE   IS  "0301SU".
000378         03  FILLER      PIC X(06)   VALUE   IS  "0302SU".
000379         03  FILLER      PIC X(06)   VALUE   IS  "0303SU".
000380         03  FILLER      PIC X(06)   VALUE   IS  "0304SU".
000381         03  FILLER      PIC X(06)   VALUE   IS  "0305SU".
000382         03  FILLER      PIC X(06)   VALUE   IS  "0306SU".
000383         03  FILLER      PIC X(06)   VALUE   IS  "0307SU".
000384         03  FILLER      PIC X(06)   VALUE   IS  "0308SU".
000385         03  FILLER      PIC X(06)   VALUE   IS  "0309SU".
000386         03  FILLER      PIC X(06)   VALUE   IS  "0310SU".
000387*
000388 LINKAGE SECTION.
000389 01  POWER--HPOWOBJ IS GLOBAL PICTURE IS  X(4).
000390 01  POWER--ID      IS GLOBAL PICTURE IS S9(9)
000391                    USAGE IS COMPUTATIONAL-5.
000392 01  POWER--NOTIFY  IS GLOBAL PICTURE IS S9(9)
000393                    USAGE IS COMPUTATIONAL-5.
000394 01  POWER--MESSAGE IS GLOBAL PICTURE IS S9(9)
000395                    USAGE IS COMPUTATIONAL-5.
000396 PROCEDURE DIVISION
000397     USING POWER--HPOWOBJ POWER--ID POWER--MESSAGE POWER--NOTIFY.
000398     EVALUATE POWER--MESSAGE
000399     WHEN 1025
000400         EVALUATE POWER--HPOWOBJ
000401         WHEN POWER--HPOWOBJ--PUSH1
000402             EVALUATE POWER--NOTIFY
000403             WHEN 1 
000404                CALL "PUSH1-CLICK"
000405             END-EVALUATE
000406         WHEN POWER--HPOWOBJ--PUSH2
000407             EVALUATE POWER--NOTIFY
000408             WHEN 1 
000409                CALL "PUSH2-CLICK"
000410             END-EVALUATE
000411         END-EVALUATE
000412     WHEN 1024
000413         MOVE POWER--HPOWOBJ TO POWER--HPOWOBJS (POWER--ID + 1)
000414     WHEN 1036
000415         CALL "HOTEL-OPENED"
000416     WHEN 1038
000417         CALL "HOTEL-START"
000418     END-EVALUATE
000419     EXIT PROGRAM.
000420 IDENTIFICATION DIVISION.
000421 PROGRAM-ID. "HOTEL-OPENED".
000422 ENVIRONMENT DIVISION.
000423 DATA        DIVISION.
000424 PROCEDURE   DIVISION.
000425 MAIN                    SECTION.
000426*
000427***  INIT DATA ***
000428*
000429     MOVE    ROOM-INFORMATION-DEF    TO  ROOM-INFORMATION-LIST.
000430     MOVE    RSV-DATE-DEF            TO  RSV-DATE-LIST.
000431     MOVE    RSV-NUM-DEF             TO  RSV-NUM-LIST.
000432     MOVE    RSV-ROOM-DEF            TO  RSV-ROOM-LIST.
000433     MOVE    NAME-DEF                TO  NAME-LIST.
000434     MOVE    TEL-DEF                 TO  TEL-LIST.
000435     MOVE    STAY-DEF                TO  STAY-LIST.
000436     MOVE    ROOM-DEF                TO  ROOM-LIST.
000437*
000438 MAIN-EX.
000439     EXIT    PROGRAM.
000440 END PROGRAM "HOTEL-OPENED".
000441 IDENTIFICATION DIVISION.
000442 PROGRAM-ID. "HOTEL-START".
000443 PROCEDURE DIVISION.
000444     EXIT PROGRAM.
000445 END PROGRAM "HOTEL-START".
000446 IDENTIFICATION DIVISION.
000447 PROGRAM-ID. "PUSH1-CLICK".
000448 ENVIRONMENT DIVISION.
000449 DATA        DIVISION.
000449 WORKING-STORAGE SECTION.
000449 77 POW-0001 PIC X(14) .
000450 PROCEDURE   DIVISION.
000451******************************************************************
000452 MAIN                    SECTION.
000453******************************************************************
000454*
000455      MOVE  "DEMO001"  TO POW-0001.
000455      CALL "XPOWCSOPENSHEET"  USING BY VALUE HOTEL BY REFERENCE POW-0001 .
000456*
000457 MAIN-EX.
000458     EXIT    PROGRAM.
000459 END PROGRAM "PUSH1-CLICK".
000460 IDENTIFICATION DIVISION.
000461 PROGRAM-ID. "PUSH2-CLICK".
000462 ENVIRONMENT DIVISION.
000463 DATA        DIVISION.
000463 WORKING-STORAGE SECTION.
000463 77 POW-0001 PIC X(14) .
000464 PROCEDURE   DIVISION.
000465******************************************************************
000466 MAIN                    SECTION.
000467******************************************************************
000468*
000469      MOVE  "HOTEL"  TO POW-0001.
000469      CALL "XPOWCSCLOSESHEET"  USING BY VALUE HOTEL BY REFERENCE POW-0001 .
000470*
000471 MAIN-EX.
000472     EXIT    PROGRAM.
000473 END PROGRAM "PUSH2-CLICK".
000474 END PROGRAM "HOTEL".
