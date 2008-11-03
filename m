Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA3FcHZv024871
	for <video4linux-list@redhat.com>; Mon, 3 Nov 2008 10:38:17 -0500
Received: from qw-out-2122.google.com (qw-out-2122.google.com [74.125.92.27])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA3Fc7Rl027626
	for <video4linux-list@redhat.com>; Mon, 3 Nov 2008 10:38:07 -0500
Received: by qw-out-2122.google.com with SMTP id 3so952724qwe.39
	for <video4linux-list@redhat.com>; Mon, 03 Nov 2008 07:38:07 -0800 (PST)
Message-ID: <c931de3d0811030738x60d68ac8la0e05d66f055991c@mail.gmail.com>
Date: Mon, 3 Nov 2008 13:38:07 -0200
From: "=?ISO-8859-1?Q?M=E1rcio_Pedroso?=" <sarrafocapoeira@gmail.com>
To: "hermann pitton" <hermann-pitton@arcor.de>
In-Reply-To: <1225588269.2642.21.camel@pc10.localdom.local>
MIME-Version: 1.0
References: <c931de3d0810291317h742a2f28i9e44400f80abf624@mail.gmail.com>
	<1225588269.2642.21.camel@pc10.localdom.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Cc: video4linux-list@redhat.com
Subject: =?iso-8859-1?q?Re=3A_card_n=BA_for_AOP_V8001_philips?=
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

my dmesg

demesg | grep saa

[    9.942399] saa7130/34: v4l2 driver version 0.2.14 loaded
[    9.942623] saa7130[0]: found at 0000:00:13.0, rev: 1, irq: 18, latency:
32, mmio: 0xec800000
[    9.942683] saa7134: <rant>
[    9.942684] saa7134:  Congratulations!  Your TV card vendor saved a few
[    9.942686] saa7134:  cents for a eeprom, thus your pci board has no
[    9.942688] saa7134:  subsystem ID and I can't identify it automatically
[    9.942690] saa7134: </rant>
[    9.942691] saa7134: I feel better now.  Ok, here are the good news:
[    9.942692] saa7134: You can use the card=3D<nr> insmod option to specif=
y
[    9.942694] saa7134: which board do you have.  The list:
[    9.943038] saa7134:   card=3D0 -> UNKNOWN/GENERIC
[    9.943117] saa7134:   card=3D1 -> Proteus Pro [philips reference design=
]
1131:2001 1131:2001
[    9.944026] saa7134:   card=3D2 -> LifeView FlyVIDEO3000
5168:0138 4e42:0138
[    9.944174] saa7134:   card=3D3 -> LifeView/Typhoon FlyVIDEO2000
5168:0138 4e42:0138
[    9.944322] saa7134:   card=3D4 -> EMPRESS
1131:6752
[    9.944439] saa7134:   card=3D5 -> SKNet Monster TV
1131:4e85
[    9.944554] saa7134:   card=3D6 -> Tevion MD 9717
[    9.944633] saa7134:   card=3D7 -> KNC One TV-Station RDS / Typhoon TV T=
une
1131:fe01 1894:fe01
[    9.944780] saa7134:   card=3D8 -> Terratec Cinergy 400 TV
153b:1142
[    9.944896] saa7134:   card=3D9 -> Medion 5044
[    9.944977] saa7134:   card=3D10 -> Kworld/KuroutoShikou SAA7130-TVPCI

[    9.945055] saa7134:   card=3D11 -> Terratec Cinergy 600
TV                  153b:1143
[    9.945172] saa7134:   card=3D12 -> Medion
7134                              16be:0003
[    9.945288] saa7134:   card=3D13 -> Typhoon TV+Radio 90031

[    9.945367] saa7134:   card=3D14 -> ELSA EX-VISION
300TV                     1048:226b
[    9.945485] saa7134:   card=3D15 -> ELSA EX-VISION
500TV                     1048:226a
[    9.945600] saa7134:   card=3D16 -> ASUS TV-FM
7134                          1043:4842 1043:4830 1043:4840
[    9.945780] saa7134:   card=3D17 -> AOPEN VA1000
POWER                       1131:7133
[    9.945897] saa7134:   card=3D18 -> BMK MPEX No Tuner

[    9.945975] saa7134:   card=3D19 -> Compro VideoMate
TV                      185b:c100
[    9.946093] saa7134:   card=3D20 -> Matrox
CronosPlus                        102b:48d0
[    9.946208] saa7134:   card=3D21 -> 10MOONS PCI TV CAPTURE
CARD              1131:2001
[    9.946324] saa7134:   card=3D22 -> AverMedia M156 / Medion
2819             1461:a70b
[    9.946442] saa7134:   card=3D23 -> BMK MPEX Tuner

[    9.946521] saa7134:   card=3D24 -> KNC One TV-Station
DVR                   1894:a006
[    9.946636] saa7134:   card=3D25 -> ASUS TV-FM
7133                          1043:4843
[    9.946754] saa7134:   card=3D26 -> Pinnacle PCTV Stereo
(saa7134)           11bd:002b
[    9.946870] saa7134:   card=3D27 -> Manli MuchTV M-TV002

[    9.946948] saa7134:   card=3D28 -> Manli MuchTV M-TV001

[    9.947027] saa7134:   card=3D29 -> Nagase Sangyo TransGear
3000TV           1461:050c
[    9.947142] saa7134:   card=3D30 -> Elitegroup ECS TVP3XP FM1216 Tuner
Card( 1019:4cb4
[    9.947259] saa7134:   card=3D31 -> Elitegroup ECS TVP3XP FM1236 Tuner
Card  1019:4cb5
[    9.947375] saa7134:   card=3D32 -> AVACS SmartTV

[    9.947453] saa7134:   card=3D33 -> AVerMedia DVD
EZMaker                    1461:10ff
[    9.947568] saa7134:   card=3D34 -> Noval Prime TV 7133

[    9.947647] saa7134:   card=3D35 -> AverMedia AverTV Studio
305              1461:2115
[    9.947762] saa7134:   card=3D36 -> UPMOST PURPLE
TV                         12ab:0800
[    9.947878] saa7134:   card=3D37 -> Items MuchTV Plus / IT-005

[    9.947959] saa7134:   card=3D38 -> Terratec Cinergy 200
TV                  153b:1152
[    9.948093] saa7134:   card=3D39 -> LifeView FlyTV Platinum
Mini             5168:0212 4e42:0212
[    9.948240] saa7134:   card=3D40 -> Compro VideoMate TV
PVR/FM               185b:c100
[    9.948359] saa7134:   card=3D41 -> Compro VideoMate TV
Gold+                185b:c100
[    9.948475] saa7134:   card=3D42 -> Sabrent SBT-TVFM (saa7130)

[    9.948553] saa7134:   card=3D43 -> :Zolid Xpert TV7134

[    9.948632] saa7134:   card=3D44 -> Empire PCI TV-Radio LE

[    9.948710] saa7134:   card=3D45 -> Avermedia AVerTV Studio
307              1461:9715
[    9.948826] saa7134:   card=3D46 -> AVerMedia Cardbus TV/Radio
(E500)        1461:d6ee
[    9.948941] saa7134:   card=3D47 -> Terratec Cinergy 400
mobile              153b:1162
[    9.949062] saa7134:   card=3D48 -> Terratec Cinergy 600 TV
MK3              153b:1158
[    9.949179] saa7134:   card=3D49 -> Compro VideoMate Gold+
Pal               185b:c200
[    9.949295] saa7134:   card=3D50 -> Pinnacle PCTV 300i DVB-T +
PAL           11bd:002d
[    9.949411] saa7134:   card=3D51 -> ProVideo
PV952                           1540:9524
[    9.949529] saa7134:   card=3D52 -> AverMedia
AverTV/305                     1461:2108
[    9.949644] saa7134:   card=3D53 -> ASUS TV-FM
7135                          1043:4845
[    9.949760] saa7134:   card=3D54 -> LifeView FlyTV Platinum FM /
Gold        5168:0214 5168:5214 1489:0214 5168:0304
[    9.949975] saa7134:   card=3D55 -> LifeView FlyDVB-T DUO / MSI
TV@nywhereD 5168:0306 4e42:0306
[    9.950122] saa7134:   card=3D56 -> Avermedia AVerTV
307                     1461:a70a
[    9.950238] saa7134:   card=3D57 -> Avermedia AVerTV GO 007
FM               1461:f31f
[    9.950357] saa7134:   card=3D58 -> ADS Tech Instant TV
(saa7135)            1421:0350 1421:0351 1421:0370 1421:1370
[    9.950569] saa7134:   card=3D59 -> Kworld/Tevion V-Stream Xpert TV PVR7=
134

[    9.950648] saa7134:   card=3D60 -> LifeView/Typhoon/Genius FlyDVB-T Duo
Car 5168:0502 4e42:0502 1489:0502
[    9.950830] saa7134:   card=3D61 -> Philips TOUGH DVB-T reference
design     1131:2004
[    9.950945] saa7134:   card=3D62 -> Compro VideoMate TV Gold+II

[    9.951024] saa7134:   card=3D63 -> Kworld Xpert TV PVR7134

[    9.951103] saa7134:   card=3D64 -> FlyTV mini Asus
Digimatrix               1043:0210
[    9.951219] saa7134:   card=3D65 -> V-Stream Studio TV Terminator

[    9.951297] saa7134:   card=3D66 -> Yuan TUN-900 (saa7135)

[    9.951376] saa7134:   card=3D67 -> Beholder BeholdTV 409
FM                 0000:4091
[    9.951491] saa7134:   card=3D68 -> GoTView 7135
PCI                         5456:7135
[    9.951606] saa7134:   card=3D69 -> Philips EUROPA V3 reference
design       1131:2004
[    9.951725] saa7134:   card=3D70 -> Compro Videomate
DVB-T300                185b:c900
[    9.951841] saa7134:   card=3D71 -> Compro Videomate
DVB-T200                185b:c901
[    9.951956] saa7134:   card=3D72 -> RTD Embedded Technologies
VFG7350        1435:7350
[    9.952078] saa7134:   card=3D73 -> RTD Embedded Technologies
VFG7330        1435:7330
[    9.952197] saa7134:   card=3D74 -> LifeView FlyTV Platinum
Mini2            14c0:1212
[    9.952312] saa7134:   card=3D75 -> AVerMedia AVerTVHD MCE
A180              1461:1044
[    9.952428] saa7134:   card=3D76 -> SKNet MonsterTV
Mobile                   1131:4ee9
[    9.952545] saa7134:   card=3D77 -> Pinnacle PCTV 40i/50i/110i
(saa7133)     11bd:002e
[    9.952661] saa7134:   card=3D78 -> ASUSTeK P7131
Dual                       1043:4862 1043:4857
[    9.952809] saa7134:   card=3D79 -> Sedna/MuchTV PC TV Cardbus TV/Radio
(ITO
[    9.952887] saa7134:   card=3D80 -> ASUS Digimatrix
TV                       1043:0210
[    9.953002] saa7134:   card=3D81 -> Philips Tiger reference
design           1131:2018
[    9.953121] saa7134:   card=3D82 -> MSI TV@Anywhereplus
      1462:6231 1462:8624
[    9.953270] saa7134:   card=3D83 -> Terratec Cinergy 250 PCI
TV              153b:1160
[    9.953386] saa7134:   card=3D84 -> LifeView FlyDVB
Trio                     5168:0319
[    9.953503] saa7134:   card=3D85 -> AverTV DVB-T
777                         1461:2c05 1461:2c05
[    9.953651] saa7134:   card=3D86 -> LifeView FlyDVB-T / Genius VideoWond=
er
D 5168:0301 1489:0301
[    9.953799] saa7134:   card=3D87 -> ADS Instant TV Duo Cardbus
PTV331        0331:1421
[    9.953916] saa7134:   card=3D88 -> Tevion/KWorld DVB-T
220RF                17de:7201
[    9.954033] saa7134:   card=3D89 -> ELSA EX-VISION
700TV                     1048:226c
[    9.954149] saa7134:   card=3D90 -> Kworld
ATSC110/115                       17de:7350 17de:7352
[    9.954299] saa7134:   card=3D91 -> AVerMedia A169
B                         1461:7360
[    9.954418] saa7134:   card=3D92 -> AVerMedia A169
B1                        1461:6360
[    9.954533] saa7134:   card=3D93 -> Medion 7134 Bridge
#2                    16be:0005
[    9.954649] saa7134:   card=3D94 -> LifeView FlyDVB-T Hybrid Cardbus/MSI
TV  5168:3306 5168:3502 5168:3307 4e42:3502
[    9.954863] saa7134:   card=3D95 -> LifeView FlyVIDEO3000
(NTSC)             5169:0138
[    9.954978] saa7134:   card=3D96 -> Medion Md8800
Quadro                     16be:0007 16be:0008 16be:000d
[    9.955158] saa7134:   card=3D97 -> LifeView FlyDVB-S /Acorp
TV134DS         5168:0300 4e42:0300
[    9.955308] saa7134:   card=3D98 -> Proteus Pro
2309                         0919:2003
[    9.955423] saa7134:   card=3D99 -> AVerMedia TV Hybrid
A16AR                1461:2c00
[    9.955538] saa7134:   card=3D100 -> Asus Europa2
OEM                         1043:4860
[    9.955657] saa7134:   card=3D101 -> Pinnacle PCTV
310i                       11bd:002f
[    9.956529] saa7134:   card=3D102 -> Avermedia AVerTV Studio
507              1461:9715
[    9.956645] saa7134:   card=3D103 -> Compro Videomate
DVB-T200A
[    9.956724] saa7134:   card=3D104 -> Hauppauge WinTV-HVR1110
DVB-T/Hybrid     0070:6700 0070:6701 0070:6702 0070:6703 0070:6704 0070:670=
5
[    9.956999] saa7134:   card=3D105 -> Terratec Cinergy HT
PCMCIA               153b:1172
[    9.957115] saa7134:   card=3D106 -> Encore
ENLTV                             1131:2342 1131:2341 3016:2344
[    9.957295] saa7134:   card=3D107 -> Encore
ENLTV-FM                          1131:230f
[    9.957410] saa7134:   card=3D108 -> Terratec Cinergy HT
PCI                  153b:1175
[    9.957526] saa7134:   card=3D109 -> Philips Tiger - S Reference
design
[    9.957604] saa7134:   card=3D110 -> Avermedia
M102                           1461:f31e
[    9.957720] saa7134:   card=3D111 -> ASUS P7131
4871                          1043:4871
[    9.957836] saa7134:   card=3D112 -> ASUSTeK P7131
Hybrid                     1043:4876
[    9.957951] saa7134:   card=3D113 -> Elitegroup ECS TVP3XP FM1246 Tuner
Card  1019:4cb6
[    9.958068] saa7134:   card=3D114 -> KWorld DVB-T
210                         17de:7250
[    9.958184] saa7134:   card=3D115 -> Sabrent PCMCIA
TV-PCB05                  0919:2003
[    9.958299] saa7134:   card=3D116 -> 10MOONS TM300 TV
Card                    1131:2304
[    9.958416] saa7134:   card=3D117 -> Avermedia Super
007                      1461:f01d
[    9.958531] saa7134:   card=3D118 -> Beholder BeholdTV
401                    0000:4016
[    9.958647] saa7134:   card=3D119 -> Beholder BeholdTV
403                    0000:4036
[    9.958764] saa7134:   card=3D120 -> Beholder BeholdTV 403
FM                 0000:4037
[    9.958880] saa7134:   card=3D121 -> Beholder BeholdTV
405                    0000:4050
[    9.958996] saa7134:   card=3D122 -> Beholder BeholdTV 405
FM                 0000:4051
[    9.959113] saa7134:   card=3D123 -> Beholder BeholdTV
407                    0000:4070
[    9.959229] saa7134:   card=3D124 -> Beholder BeholdTV 407
FM                 0000:4071
[    9.959344] saa7134:   card=3D125 -> Beholder BeholdTV
409                    0000:4090
[    9.959463] saa7134:   card=3D126 -> Beholder BeholdTV 505
FM/RDS             0000:5051 0000:505b 5ace:5050
[    9.959643] saa7134:   card=3D127 -> Beholder BeholdTV 507 FM/RDS /
BeholdTV  0000:5071 0000:507b 5ace:5070 5ace:5090
[    9.959855] saa7134:   card=3D128 -> Beholder BeholdTV Columbus
TVFM          0000:5201
[    9.959972] saa7134:   card=3D129 -> Beholder BeholdTV 607 / BeholdTV
609     5ace:6070 5ace:6071 5ace:6072 5ace:6073 5ace:6090 5ace:6091
5ace:6092 5ace:6093
[    9.960817] saa7134:   card=3D130 -> Beholder BeholdTV M6 / BeholdTV M6
Extra 5ace:6190 5ace:6193 5ace:6191
[    9.960997] saa7134:   card=3D131 -> Twinhan Hybrid DTV-DVB 3056
PCI          1822:0022
[    9.961113] saa7134:   card=3D132 -> Genius TVGO
AM11MCE
[    9.961192] saa7134:   card=3D133 -> NXP Snake DVB-S reference
design
[    9.961270] saa7134:   card=3D134 -> Medion/Creatix CTX953
Hybrid             16be:0010
[    9.961386] saa7134:   card=3D135 -> MSI TV@nywhere A/D
v1.1                  1462:8625
[    9.961502] saa7134:   card=3D136 -> AVerMedia Cardbus TV/Radio
(E506R)       1461:f436
[    9.961620] saa7134:   card=3D137 -> AVerMedia Hybrid TV/Radio
(A16D)         1461:f936
[    9.961736] saa7134:   card=3D138 -> Avermedia
M115                           1461:a836
[    9.961851] saa7134:   card=3D139 -> Compro VideoMate
T750                    185b:c900
[    9.961968] saa7134:   card=3D140 -> Avermedia DVB-S Pro
A700                 1461:a7a1
[    9.962084] saa7134:   card=3D141 -> Avermedia DVB-S Hybrid+FM
A700           1461:a7a2
[    9.962199] saa7134:   card=3D142 -> Beholder BeholdTV
H6                     5ace:6290
[    9.962319] saa7130[0]: subsystem: 1131:0000, board: UNKNOWN/GENERIC
[card=3D0,autodetected]
[    9.962387] saa7130[0]: board init: gpio is c0f3fff
[   10.221370] saa7130[0]: Huh, no eeprom present (err=3D-5)?
[   10.221474] saa7130[0]: registered device video0 [v4l2]
[   10.221542] saa7130[0]: registered device vbi0

i'm try the recompile the kernel for last version stable..


2008/11/1 hermann pitton <hermann-pitton@arcor.de>

> Hi Marcio,
>
> Am Mittwoch, den 29.10.2008, 18:17 -0200 schrieb M=E1rcio Pedroso:
> > I am struggling to find the number of cards referring to this card any
> tips
> >
> > 00:13.0 Multimedia controller: Philips Semiconductors SAA7130 Video
> > Broadcast Decoder (rev 01)
> >
> > chipset saa7130hl
>
> we have lots of saa7130 cards, which are clones of previously known
> ones, but they also often have no eeprom with specific PCI subvendor and
> subdevice IDs stored there and can't be identified.
>
> The absolute minimum is to provide relevant "dmesg" output on loading
> the driver and setting the tuner type.
>
> See also here.
>
> http://linuxtv.org/v4lwiki/index.php/Development:_How_to_add_support_for_=
a_device
>
> Just saa7130 and AOP V8001 Philips means nothing so far.
>
> Cheers,
> Hermann
>
>
>


--=20
linux user n=BA 432194

Eu sou livre e voc=EA?
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
