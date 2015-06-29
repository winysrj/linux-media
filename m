Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:33629 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbbF2AQE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Jun 2015 20:16:04 -0400
Received: by wgck11 with SMTP id k11so128047216wgc.0
        for <linux-media@vger.kernel.org>; Sun, 28 Jun 2015 17:16:02 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 29 Jun 2015 03:16:01 +0300
Message-ID: <CAOE4rSzg1+pF9C8fd7LsPOnvSUL=GYM-PDreALcB3PxnBOAbxA@mail.gmail.com>
Subject: Gigabyte GT-P8000 (Analog TV + DVB-T)
From: =?UTF-8?B?RMSBdmlzIE1vc8SBbnM=?= <davispuh@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary=047d7bea43d6add95505199cfef6
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--047d7bea43d6add95505199cfef6
Content-Type: text/plain; charset=UTF-8

Hello!

I've this Gigabyte GT-P8000
(http://www.gigabyte.com/products/product-page.aspx?pid=2757) TV tuner
card and I want to get it to work on Linux. Currently seems no one
have managed to do it and there's barely any info about it
(http://www.linuxtv.org/wiki/index.php/Gigabyte_GT-P8000).

On Arch Linux 4.0.6 from kernel log:

saa7130/34: v4l2 driver version 0, 2, 17 loaded
saa7133[0]: found at 0000:09:06.0, rev: 209, irq: 20, latency: 32,
mmio: 0xfddff000
saa7134: <rant>
 saa7134:  Congratulations!  Your TV card vendor saved a few
 saa7134:  cents for a eeprom, thus your pci board has no
 saa7134:  subsystem ID and I can't identify it automatically
 saa7134: </rant>
 saa7134: I feel better now.  Ok, here are the good news:
 saa7134: You can use the card=<nr> insmod option to specify
 saa7134: which board do you have.  The list:
saa7134:   card=0 -> UNKNOWN/GENERIC
saa7134:   card=1 -> Proteus Pro [philips reference design]
1131:2001 1131:2001
saa7134:   card=2 -> LifeView FlyVIDEO3000
5168:0138 4e42:0138
saa7134:   card=3 -> LifeView/Typhoon FlyVIDEO2000
5168:0138 4e42:0138
saa7134:   card=4 -> EMPRESS                                  1131:6752
saa7134:   card=5 -> SKNet Monster TV                         1131:4e85
saa7134:   card=6 -> Tevion MD 9717
saa7134:   card=7 -> KNC One TV-Station RDS / Typhoon TV Tune
1131:fe01 1894:fe01
saa7134:   card=8 -> Terratec Cinergy 400 TV                  153b:1142
saa7134:   card=9 -> Medion 5044
saa7134:   card=10 -> Kworld/KuroutoShikou SAA7130-TVPCI
saa7134:   card=11 -> Terratec Cinergy 600 TV                  153b:1143
saa7134:   card=12 -> Medion 7134
16be:0003 16be:5000
saa7134:   card=13 -> Typhoon TV+Radio 90031
saa7134:   card=14 -> ELSA EX-VISION 300TV                     1048:226b
saa7134:   card=15 -> ELSA EX-VISION 500TV                     1048:226a
saa7134:   card=16 -> ASUS TV-FM 7134
1043:4842 1043:4830 1043:4840
saa7134:   card=17 -> AOPEN VA1000 POWER                       1131:7133
saa7134:   card=18 -> BMK MPEX No Tuner
saa7134:   card=19 -> Compro VideoMate TV                      185b:c100
saa7134:   card=20 -> Matrox CronosPlus                        102b:48d0
saa7134:   card=21 -> 10MOONS PCI TV CAPTURE CARD              1131:2001
saa7134:   card=22 -> AverMedia M156 / Medion 2819             1461:a70b
saa7134:   card=23 -> BMK MPEX Tuner
saa7134:   card=24 -> KNC One TV-Station DVR                   1894:a006
saa7134:   card=25 -> ASUS TV-FM 7133                          1043:4843
saa7134:   card=26 -> Pinnacle PCTV Stereo (saa7134)           11bd:002b
saa7134:   card=27 -> Manli MuchTV M-TV002
saa7134:   card=28 -> Manli MuchTV M-TV001
saa7134:   card=29 -> Nagase Sangyo TransGear 3000TV           1461:050c
saa7134:   card=30 -> Elitegroup ECS TVP3XP FM1216 Tuner Card( 1019:4cb4
saa7134:   card=31 -> Elitegroup ECS TVP3XP FM1236 Tuner Card  1019:4cb5
saa7134:   card=32 -> AVACS SmartTV
saa7134:   card=33 -> AVerMedia DVD EZMaker                    1461:10ff
saa7134:   card=34 -> Noval Prime TV 7133
saa7134:   card=35 -> AverMedia AverTV Studio 305              1461:2115
saa7134:   card=36 -> UPMOST PURPLE TV                         12ab:0800
saa7134:   card=37 -> Items MuchTV Plus / IT-005
saa7134:   card=38 -> Terratec Cinergy 200 TV                  153b:1152
saa7134:   card=39 -> LifeView FlyTV Platinum Mini
5168:0212 4e42:0212 5169:1502
saa7134:   card=40 -> Compro VideoMate TV PVR/FM               185b:c100
saa7134:   card=41 -> Compro VideoMate TV Gold+                185b:c100
saa7134:   card=42 -> Sabrent SBT-TVFM (saa7130)
saa7134:   card=43 -> :Zolid Xpert TV7134
saa7134:   card=44 -> Empire PCI TV-Radio LE
saa7134:   card=45 -> Avermedia AVerTV Studio 307              1461:9715
saa7134:   card=46 -> AVerMedia Cardbus TV/Radio (E500)        1461:d6ee
saa7134:   card=47 -> Terratec Cinergy 400 mobile              153b:1162
saa7134:   card=48 -> Terratec Cinergy 600 TV MK3              153b:1158
saa7134:   card=49 -> Compro VideoMate Gold+ Pal               185b:c200
saa7134:   card=50 -> Pinnacle PCTV 300i DVB-T + PAL           11bd:002d
saa7134:   card=51 -> ProVideo PV952                           1540:9524
saa7134:   card=52 -> AverMedia AverTV/305                     1461:2108
saa7134:   card=53 -> ASUS TV-FM 7135                          1043:4845
saa7134:   card=54 -> LifeView FlyTV Platinum FM / Gold
5168:0214 5168:5214 1489:0214
saa7134:   card=55 -> LifeView FlyDVB-T DUO / MSI TV@nywhere D
5168:0306 4e42:0306
saa7134:   card=56 -> Avermedia AVerTV 307                     1461:a70a
saa7134:   card=57 -> Avermedia AVerTV GO 007 FM               1461:f31f
saa7134:   card=58 -> ADS Tech Instant TV (saa7135)
1421:0350 1421:0351 1421:0370
saa7134:   card=59 -> Kworld/Tevion V-Stream Xpert TV PVR7134
saa7134:   card=60 -> LifeView/Typhoon/Genius FlyDVB-T Duo Car
5168:0502 4e42:0502 1489:0502
saa7134:   card=61 -> Philips TOUGH DVB-T reference design     1131:2004
saa7134:   card=62 -> Compro VideoMate TV Gold+II
saa7134:   card=63 -> Kworld Xpert TV PVR7134
saa7134:   card=64 -> FlyTV mini Asus Digimatrix               1043:0210
saa7134:   card=65 -> V-Stream Studio TV Terminator
saa7134:   card=66 -> Yuan TUN-900 (saa7135)
saa7134:   card=67 -> Beholder BeholdTV 409 FM                 0000:4091
saa7134:   card=68 -> GoTView 7135 PCI                         5456:7135
saa7134:   card=69 -> Philips EUROPA V3 reference design       1131:2004
saa7134:   card=70 -> Compro Videomate DVB-T300                185b:c900
saa7134:   card=71 -> Compro Videomate DVB-T200                185b:c901
saa7134:   card=72 -> RTD Embedded Technologies VFG7350        1435:7350
saa7134:   card=73 -> RTD Embedded Technologies VFG7330        1435:7330
saa7134:   card=74 -> LifeView FlyTV Platinum Mini2            14c0:1212
saa7134:   card=75 -> AVerMedia AVerTVHD MCE A180              1461:1044
saa7134:   card=76 -> SKNet MonsterTV Mobile                   1131:4ee9
saa7134:   card=77 -> Pinnacle PCTV 40i/50i/110i (saa7133)     11bd:002e
saa7134:   card=78 -> ASUSTeK P7131 Dual                       1043:4862
saa7134:   card=79 -> Sedna/MuchTV PC TV Cardbus TV/Radio (ITO
saa7134:   card=80 -> ASUS Digimatrix TV                       1043:0210
saa7134:   card=81 -> Philips Tiger reference design           1131:2018
saa7134:   card=82 -> MSI TV@Anywhere plus
1462:6231 1462:8624
saa7134:   card=83 -> Terratec Cinergy 250 PCI TV              153b:1160
saa7134:   card=84 -> LifeView FlyDVB Trio                     5168:0319
saa7134:   card=85 -> AverTV DVB-T 777
1461:2c05 1461:2c05
saa7134:   card=86 -> LifeView FlyDVB-T / Genius VideoWonder D
5168:0301 1489:0301
saa7134:   card=87 -> ADS Instant TV Duo Cardbus PTV331        0331:1421
saa7134:   card=88 -> Tevion/KWorld DVB-T 220RF                17de:7201
saa7134:   card=89 -> ELSA EX-VISION 700TV                     1048:226c
saa7134:   card=90 -> Kworld ATSC110/115
17de:7350 17de:7352
saa7134:   card=91 -> AVerMedia A169 B                         1461:7360
saa7134:   card=92 -> AVerMedia A169 B1                        1461:6360
saa7134:   card=93 -> Medion 7134 Bridge #2                    16be:0005
saa7134:   card=94 -> LifeView FlyDVB-T Hybrid Cardbus/MSI TV
5168:3306 5168:3502 5168:3307
saa7134:   card=95 -> LifeView FlyVIDEO3000 (NTSC)             5169:0138
saa7134:   card=96 -> Medion Md8800 Quadro
16be:0007 16be:0008 16be:000d
saa7134:   card=97 -> LifeView FlyDVB-S /Acorp TV134DS
5168:0300 4e42:0300
saa7134:   card=98 -> Proteus Pro 2309                         0919:2003
saa7134:   card=99 -> AVerMedia TV Hybrid A16AR                1461:2c00
saa7134:   card=100 -> Asus Europa2 OEM                         1043:4860
saa7134:   card=101 -> Pinnacle PCTV 310i                       11bd:002f
saa7134:   card=102 -> Avermedia AVerTV Studio 507              1461:9715
saa7134:   card=103 -> Compro Videomate DVB-T200A
saa7134:   card=104 -> Hauppauge WinTV-HVR1110 DVB-T/Hybrid
0070:6700 0070:6701 0070:6702
saa7134:   card=105 -> Terratec Cinergy HT PCMCIA               153b:1172
saa7134:   card=106 -> Encore ENLTV
1131:2342 1131:2341 3016:2344
saa7134:   card=107 -> Encore ENLTV-FM                          1131:230f
saa7134:   card=108 -> Terratec Cinergy HT PCI                  153b:1175
saa7134:   card=109 -> Philips Tiger - S Reference design
saa7134:   card=110 -> Avermedia M102                           1461:f31e
saa7134:   card=111 -> ASUS P7131 4871                          1043:4871
saa7134:   card=112 -> ASUSTeK P7131 Hybrid                     1043:4876
saa7134:   card=113 -> Elitegroup ECS TVP3XP FM1246 Tuner Card  1019:4cb6
saa7134:   card=114 -> KWorld DVB-T 210                         17de:7250
saa7134:   card=115 -> Sabrent PCMCIA TV-PCB05                  0919:2003
saa7134:   card=116 -> 10MOONS TM300 TV Card                    1131:2304
saa7134:   card=117 -> Avermedia Super 007                      1461:f01d
saa7134:   card=118 -> Beholder BeholdTV 401                    0000:4016
saa7134:   card=119 -> Beholder BeholdTV 403                    0000:4036
saa7134:   card=120 -> Beholder BeholdTV 403 FM                 0000:4037
saa7134:   card=121 -> Beholder BeholdTV 405                    0000:4050
saa7134:   card=122 -> Beholder BeholdTV 405 FM                 0000:4051
saa7134:   card=123 -> Beholder BeholdTV 407                    0000:4070
saa7134:   card=124 -> Beholder BeholdTV 407 FM                 0000:4071
saa7134:   card=125 -> Beholder BeholdTV 409                    0000:4090
saa7134:   card=126 -> Beholder BeholdTV 505 FM                 5ace:5050
saa7134:   card=127 -> Beholder BeholdTV 507 FM / BeholdTV 509
5ace:5070 5ace:5090
saa7134:   card=128 -> Beholder BeholdTV Columbus TV/FM         0000:5201
saa7134:   card=129 -> Beholder BeholdTV 607 FM                 5ace:6070
saa7134:   card=130 -> Beholder BeholdTV M6                     5ace:6190
saa7134:   card=131 -> Twinhan Hybrid DTV-DVB 3056 PCI          1822:0022
saa7134:   card=132 -> Genius TVGO AM11MCE
saa7134:   card=133 -> NXP Snake DVB-S reference design
saa7134:   card=134 -> Medion/Creatix CTX953 Hybrid             16be:0010
saa7134:   card=135 -> MSI TV@nywhere A/D v1.1                  1462:8625
saa7134:   card=136 -> AVerMedia Cardbus TV/Radio (E506R)       1461:f436
saa7134:   card=137 -> AVerMedia Hybrid TV/Radio (A16D)         1461:f936
saa7134:   card=138 -> Avermedia M115                           1461:a836
saa7134:   card=139 -> Compro VideoMate T750                    185b:c900
saa7134:   card=140 -> Avermedia DVB-S Pro A700                 1461:a7a1
saa7134:   card=141 -> Avermedia DVB-S Hybrid+FM A700           1461:a7a2
saa7134:   card=142 -> Beholder BeholdTV H6                     5ace:6290
saa7134:   card=143 -> Beholder BeholdTV M63                    5ace:6191
saa7134:   card=144 -> Beholder BeholdTV M6 Extra               5ace:6193
saa7134:   card=145 -> AVerMedia MiniPCI DVB-T Hybrid M103
1461:f636 1461:f736
saa7134:   card=146 -> ASUSTeK P7131 Analog
saa7134:   card=147 -> Asus Tiger 3in1                          1043:4878
saa7134:   card=148 -> Encore ENLTV-FM v5.3                     1a7f:2008
saa7134:   card=149 -> Avermedia PCI pure analog (M135A)        1461:f11d
saa7134:   card=150 -> Zogis Real Angel 220
saa7134:   card=151 -> ADS Tech Instant HDTV                    1421:0380
saa7134:   card=152 -> Asus Tiger Rev:1.00                      1043:4857
saa7134:   card=153 -> Kworld Plus TV Analog Lite PCI           17de:7128
saa7134:   card=154 -> Avermedia AVerTV GO 007 FM Plus          1461:f31d
saa7134:   card=155 -> Hauppauge WinTV-HVR1150 ATSC/QAM-Hybrid
0070:6706 0070:6708
saa7134:   card=156 -> Hauppauge WinTV-HVR1120 DVB-T/Hybrid
0070:6707 0070:6709 0070:670a
saa7134:   card=157 -> Avermedia AVerTV Studio 507UA            1461:a11b
saa7134:   card=158 -> AVerMedia Cardbus TV/Radio (E501R)       1461:b7e9
saa7134:   card=159 -> Beholder BeholdTV 505 RDS                0000:505b
saa7134:   card=160 -> Beholder BeholdTV 507 RDS                0000:5071
saa7134:   card=161 -> Beholder BeholdTV 507 RDS                0000:507b
saa7134:   card=162 -> Beholder BeholdTV 607 FM                 5ace:6071
saa7134:   card=163 -> Beholder BeholdTV 609 FM                 5ace:6090
saa7134:   card=164 -> Beholder BeholdTV 609 FM                 5ace:6091
saa7134:   card=165 -> Beholder BeholdTV 607 RDS                5ace:6072
saa7134:   card=166 -> Beholder BeholdTV 607 RDS                5ace:6073
saa7134:   card=167 -> Beholder BeholdTV 609 RDS                5ace:6092
saa7134:   card=168 -> Beholder BeholdTV 609 RDS                5ace:6093
saa7134:   card=169 -> Compro VideoMate S350/S300               185b:c900
saa7134:   card=170 -> AverMedia AverTV Studio 505              1461:a115
saa7134:   card=171 -> Beholder BeholdTV X7                     5ace:7595
saa7134:   card=172 -> RoverMedia TV Link Pro FM                19d1:0138
saa7134:   card=173 -> Zolid Hybrid TV Tuner PCI                1131:2004
saa7134:   card=174 -> Asus Europa Hybrid OEM                   1043:4847
saa7134:   card=175 -> Leadtek Winfast DTV1000S                 107d:6655
saa7134:   card=176 -> Beholder BeholdTV 505 RDS                0000:5051
saa7134:   card=177 -> Hawell HW-404M7
saa7134:   card=178 -> Beholder BeholdTV H7                     5ace:7190
saa7134:   card=179 -> Beholder BeholdTV A7                     5ace:7090
saa7134:   card=180 -> Avermedia PCI M733A
1461:4155 1461:4255
saa7134:   card=181 -> TechoTrend TT-budget T-3000              13c2:2804
saa7134:   card=182 -> Kworld PCI SBTVD/ISDB-T Full-Seg Hybrid  17de:b136
saa7134:   card=183 -> Compro VideoMate Vista M1F               185b:c900
saa7134:   card=184 -> Encore ENLTV-FM 3                        1a7f:2108
saa7134:   card=185 -> MagicPro ProHDTV Pro2 DMB-TH/Hybrid      17de:d136
saa7134:   card=186 -> Beholder BeholdTV 501                    5ace:5010
saa7134:   card=187 -> Beholder BeholdTV 503 FM                 5ace:5030
saa7134:   card=188 -> Sensoray 811/911
6000:0811 6000:0911
saa7134:   card=189 -> Kworld PC150-U                           17de:a134
saa7134:   card=190 -> Asus My Cinema PS3-100                   1043:48cd
saa7134:   card=191 -> Hawell HW-9004V1
saa7134:   card=192 -> AverMedia AverTV Satellite Hybrid+FM A70 1461:2055
saa7134:   card=193 -> WIS Voyager or compatible                1905:7007
saa7133[0]: subsystem: 1458:9004, board: UNKNOWN/GENERIC [card=0,autodetected]
saa7133[0]: board init: gpio is 40000
saa7133[0]: i2c eeprom 00: 58 14 04 90 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7133[0]: i2c eeprom 10: ff ff ff ff ff 20 ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 20: 01 40 01 02 02 01 01 03 08 ff 00 b3 ff ff ff ff
saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 40: 50 35 00 c0 96 10 05 32 d5 15 0e 00 ff ff ff ff
saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: registered device video0 [v4l2]
saa7133[0]: registered device vbi0
saa7134 ALSA driver for DMA sound loaded
saa7133[0]/alsa: saa7133[0] at 0xfddff000 irq 20 registered as card -1


from lspci

09:06.0 Multimedia controller [0480]: Philips Semiconductors
SAA7131/SAA7133/SAA7135 Video Broadcast Decoder [1131:7133] (rev d1)
       Subsystem: Gigabyte Technology Co., Ltd GT-P8000 DVB-T/Analog
TV/FM tuner [1458:9004]
       Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
       Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
       Latency: 32 (21000ns min, 8000ns max)
       Interrupt: pin A routed to IRQ 20
       Region 0: Memory at fddff000 (32-bit, non-prefetchable) [size=2K]
       Capabilities: [40] Power Management version 2
               Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
               Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
       Kernel driver in use: saa7134
       Kernel modules: saa7134


There aren't this Gigabyte card in provided list, but I've attached
oem17.inf (and registry.reg) from Windows driver
and there it's VEN_1131&DEV_7133 so I assume it's similar to this?

saa7134:   card=17 -> AOPEN VA1000 POWER                       1131:7133

so I'm using
options saa7134 card=17 i2c_scan=1

and then from log
saa7130/34: v4l2 driver version 0, 2, 17 loaded
saa7133[0]: found at 0000:09:06.0, rev: 209, irq: 20, latency: 32,
mmio: 0xfddff000
saa7133[0]: subsystem: 1458:9004, board: AOPEN VA1000 POWER
[card=17,insmod option]
saa7133[0]: board init: gpio is 40000
saa7133[0]: i2c eeprom 00: 58 14 04 90 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7133[0]: i2c eeprom 10: ff ff ff ff ff 20 ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 20: 01 40 01 02 02 01 01 03 08 ff 00 b3 ff ff ff ff
saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 40: 50 35 00 c0 96 10 05 32 d5 15 0e 00 ff ff ff ff
saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c scan: found device @ 0x96  [???]
saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]
tuner 12-004b: Tuner -1 found with type(s) Radio TV.
tuner-simple 12-004b: creating new instance
tuner-simple 12-004b: type set to 2 (Philips NTSC (FI1236,FM1236 and
compatibles))
saa7133[0]: registered device video0 [v4l2]
saa7133[0]: registered device vbi0
saa7134 ALSA driver for DMA sound loaded
saa7133[0]/alsa: saa7133[0] at 0xfddff000 irq 20 registered as card -1
retire_capture_urb: 44 callbacks suppressed


and v4l2-ctl

AOPEN VA1000 POWER (PCI:0000:09:06.0):
       /dev/video0
       /dev/vbi0

VIDIOC_QUERYCAP: ok
Driver Info (not using libv4l2):
       Driver name   : saa7134
       Card type     : AOPEN VA1000 POWER
       Bus info      : PCI:0000:09:06.0
       Driver version: 4.0.6
       Capabilities  : 0x85250015
               Video Capture
               Video Overlay
               VBI Capture
               Tuner
               Radio
               Read/Write
               Streaming
               Extended Pix Format
               Device Capabilities
       Device Caps   : 0x05210005
               Video Capture
               Video Overlay
               Tuner
               Read/Write
               Streaming
               Extended Pix Format
Priority: 2
Frequency for tuner 0: 15328 (958.000000 MHz)
Tuner 0:
       Name                 : Television
       Capabilities         : 62.5 kHz multi-standard stereo lang1
lang2 freq-bands
       Frequency range      : 44.000 MHz - 958.000 MHz
       Signal strength/AFC  : 100%/0
       Current audio mode   : mono
       Available subchannels: mono
Video input : 1 (Composite1: ok)
Video Standard = 0x0000b000
       NTSC-M/M-JP/M-KR
Format Video Capture:
       Width/Height  : 640/480
       Pixel Format  : 'YV12'
       Field         : Interlaced
       Bytes per Line: 960
       Size Image    : 460800
       Colorspace    : Broadcast NTSC/PAL (SMPTE170M/ITU601)
       Flags         :
Format Video Overlay:
       Left/Top    : 0/0
       Width/Height: 720/576
       Field       : Interlaced
       Chroma Key  : 0x00000000
       Global Alpha: 0x00
       Clip Count  : 0
       Clip Bitmap : No
Framebuffer Format:
       Capability    : Clipping List
       Flags         :
       Width         : 4352
       Height        : 1440
       Pixel Format  : 'BGR4'
       Bytes per Line: 17408
       Size image    : 25067520
       Colorspace    : Broadcast NTSC/PAL (SMPTE170M/ITU601)
Crop Capability Video Capture:
       Bounds      : Left 0, Top 44, Width 720, Height 480
       Default     : Left 0, Top 46, Width 720, Height 480
       Pixel Aspect: 11/10
Crop: Left 0, Top 46, Width 720, Height 480
Streaming Parameters Video Capture:
       Frames per second: 29.970 (30000/1001)
       Read buffers     : 2


I got Analog TV Composite working with MPlayer, but quality is very poor

$ mplayer tv:// -tv
driver=v4l2:input=1:device=/dev/video0:alsa:adevice=sysdefault.CARD=SAA7134:immediatemode=0
Playing tv://.
TV file format detected.
Selected driver: v4l2
name: Video 4 Linux 2 input
author: Martin Olschewski <olschewski@zpr.uni-koeln.de>
comment: first try, more to come ;-)
Selected device: AOPEN VA1000 POWER
Tuner cap: STEREO LANG1 LANG2
Tuner rxs: MONO
Capabilities:  video capture  video overlay  VBI capture device  tuner
 read/write  streaming
supported norms: 0 = NTSC; 1 = NTSC-M; 2 = NTSC-M-JP; 3 = NTSC-M-KR; 4
= PAL; 5 = PAL-BG; 6 = PAL-H; 7 = PAL-I; 8 = PAL-DK; 9
= PAL-M; 10 = PAL-N; 11 = PAL-Nc; 12 = PAL-60; 13 = SECAM; 14 =
SECAM-B; 15 = SECAM-G; 16 = SECAM-H; 17 = SECAM-DK; 18 = SECAM-
L; 19 = SECAM-Lc;
inputs: 0 = S-Video; 1 = Composite1; 2 = Television;
Current input: 1
Current format: YUV420
v4l2: current audio mode is : MONO
==========================================================================
Opening video decoder: [raw] RAW Uncompressed Video
Movie-Aspect is undefined - no prescaling applied.
VO: [vdpau] 640x480 => 640x480 Planar YV12
Selected video codec: [rawyv12] vfm: raw (RAW YV12)
==========================================================================
==========================================================================
Opening audio decoder: [pcm] Uncompressed PCM audio decoder
AUDIO: 44100 Hz, 1 ch, s16le, 705.6 kbit/100.00% (ratio: 88200->88200)
Selected audio codec: [pcm] afm: pcm (Uncompressed PCM)
==========================================================================
[AO OSS] audio_setup: Can't open audio device /dev/dsp: No such file
or directory
AO: [alsa] 44100Hz 1ch s16le (2 bytes per sample)
Starting playback...
A:   8.5 V:   8.5 A-V:  0.000 ct:  0.250 213/213  0%  3%  6.1% 0 0
v4l2: 226 frames successfully processed, 0 frames dropped.


and it works with avconv too

$ avconv -f video4linux2 -channel 1 -i /dev/video0 -f alsa
-sample_rate 8000 -i "sysdefault:CARD=SAA7134" composite.mkv
[video4linux2 @ 0x80f9c0] Estimating duration from bitrate, this may
be inaccurate
Input #0, video4linux2, from '/dev/video0':
 Duration: N/A, start: 15153.923056, bitrate: 92160 kb/s
   Stream #0.0: Video: rawvideo, yuv420p, 640x480, 92160 kb/s, 25 fps, 1000k tbn
[alsa @ 0x8112e0] capture with some ALSA plugins, especially dsnoop, may hang.
[alsa @ 0x8112e0] Estimating duration from bitrate, this may be
inaccurate
Guessed Channel Layout for  Input Stream #1.0 : stereo
Input #1, alsa, from 'sysdefault:CARD=SAA7134':
 Duration: N/A, start: 15153.936232, bitrate: N/A
   Stream #1.0: Audio: pcm_s16le, 8000 Hz, 2 channels, s16, 256 kb/s
[libx264 @ 0x870080] MB rate (1200000000) > level limit (2073600)
[libx264 @ 0x870080] using cpu capabilities: MMX2 SSE2Fast SSSE3
SSE4.2 AVX XOP FMA4 LZCNT
[libx264 @ 0x870080] profile High, level 5.2
[libx264 @ 0x870080] 264 - core 144 r2533 c8a773e - H.264/MPEG-4 AVC
codec - Copyleft 2003-2015 - http://www.videolan.org/x264.
html - options: cabac=1 ref=3 deblock=1:0:0 analyse=0x3:0x113 me=hex
subme=7 psy=1 psy_rd=1.00:0.00 mixed_ref=1 me_range=16 chr
oma_me=1 trellis=1 8x8dct=1 cqm=0 deadzone=21,11 fast_pskip=1
chroma_qp_offset=-2 threads=9 lookahead_threads=1 sliced_threads=
0 nr=0 decimate=1 interlaced=0 bluray_compat=0 constrained_intra=0
bframes=3 b_pyramid=2 b_adapt=1 b_bias=0 direct=1 weightb=1
open_gop=0 weightp=2 keyint=250 keyint_min=25 scenecut=40
intra_refresh=0 rc_lookahead=40 rc=crf mbtree=1 crf=23.0 qcomp=0.60 q
pmin=0 qpmax=69 qpstep=4 ip_ratio=1.40 aq=1:1.00
Output #0, matroska, to 'composite.mkv':
 Metadata:
   encoder         : Lavf56.1.0
   Stream #0.0: Video: libx264, yuv420p, 640x480, q=-1--1, 1k tbn, 1000k tbc
   Metadata:
     encoder         : Lavc56.1.0 libx264
   Stream #0.1: Audio: libvorbis, 8000 Hz, stereo, fltp
   Metadata:
     encoder         : Lavc56.1.0 libvorbis
Stream mapping:
 Stream #0:0 -> #0:0 (rawvideo (native) -> h264 (libx264))
 Stream #1:0 -> #0:1 (pcm_s16le (native) -> vorbis (libvorbis))


But there's no /dev/dvb and seems no Radio either, also VLC doesn't
work even for composite.

How to proceed? What would be next steps? Also any advice would be
great as this is first time I'm trying to use TV tuner on Linux.

Thanks! :)

--047d7bea43d6add95505199cfef6
Content-Type: application/octet-stream; name="oem17.inf"
Content-Disposition: attachment; filename="oem17.inf"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ibh2q9xy0

OyoqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqDQo7DQo7IENvcHlyaWdodCAyMDAwIC0gMjAwOCwgTlhQIFNl
bWljb25kdWN0b3JzIEdlcm1hbnkgR21iSA0KOw0KOyAgIEFsbCByaWdodHMgYXJlIHJlc2VydmVk
LiBSZXByb2R1Y3Rpb24gaW4gd2hvbGUgb3IgaW4gcGFydCBpcyBwcm9oaWJpdGVkDQo7ICAgd2l0
aG91dCB0aGUgd3JpdHRlbiBjb25zZW50IG9mIHRoZSBjb3B5cmlnaHQgb3duZXIuDQo7IA0KOyAg
IE5YUCByZXNlcnZlcyB0aGUgcmlnaHQgdG8gbWFrZSBjaGFuZ2VzIHdpdGhvdXQgbm90aWNlIGF0
IGFueSB0aW1lLg0KOyAgIE5YUCBtYWtlcyBubyB3YXJyYW50eSwgZXhwcmVzc2VkLCBpbXBsaWVk
IG9yIHN0YXR1dG9yeSwgaW5jbHVkaW5nIGJ1dA0KOyAgIG5vdCBsaW1pdGVkIHRvIGFueSBpbXBs
aWVkIHdhcnJhbnR5IG9mIG1lcmNoYW50YWJpbGl0eSBvciBmaXRuZXNzIGZvciBhbnkNCjsgICBw
YXJ0aWN1bGFyIHB1cnBvc2UsIG9yIHRoYXQgdGhlIHVzZSB3aWxsIG5vdCBpbmZyaW5nZSBhbnkg
dGhpcmQgcGFydHkNCjsgICBwYXRlbnQsIGNvcHlyaWdodCBvciB0cmFkZW1hcmsuIE5YUCBtdXN0
IG5vdCBiZSBsaWFibGUgZm9yIGFueSBsb3NzDQo7ICAgb3IgZGFtYWdlIGFyaXNpbmcgZnJvbSBp
dHMgdXNlLg0KOw0KOyoqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqDQoNCjsqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
Kg0KOw0KOyBTQUE3MTN4IEJhc2VkIC0gQkRBIFRWIENhcHR1cmUgRHJpdmVyDQo7DQo7IFN1cHBv
cnRlZCBQbGF0Zm9ybTogMzIgYml0LCA2NCBiaXQgKGV4Y2VwdCBJbnRlbCBJdGFuaXVtICJJQTY0
IikNCjsgU3VwcG9ydGVkIE9TOiAgICAgICBXaW5kb3dzIFhQIGFuZCBXaW5kb3dzIFZpc3RhDQo7
ICAgICAgICAgICAgICAgICAgICAgKFdpbmRvd3MgMjAwMCBjYW5ub3QgaGFuZGxlICJOVHg4NiIg
bGFibGVzKQ0KOw0KOyBOb3RlOg0KOyAgUE5QIElEJ3MgZm9yIGNhcmRzIHdpdGhvdXQgYSBCb290
LUVFUFJPTSB3aWxsIHNob3cgdXAgYXM6DQo7ICAgLSAiU1VCU1lTXzAwMDAxMTMxIg0KOyAgUE5Q
IElEJ3MgZm9yIGNhcmRzIHdpdGggYSBCb290LUVFUFJPTSB0aGF0IGlzIG5vdCBwcm9ncmFtbWVk
IHNob3cgdXAgYXM6DQo7ICAgLSAiU1VCU1lTX0ZGRkZGRkZGIg0KOw0KOyBEZXNjcmlwdGlvbjoN
CjsgIEZvciByZWxlYXNlcyB1c2UgYXQgbGVhc3QgNC1QYXJ0LVBOUC1JRCdzLiBCZXR0ZXIgYWRk
IHRoZSByZXZpc2lvbiB0b28uDQo7CSBGb3IgSW50ZWwgIkl0YW5pdW0iIDY0IGJpdCBiYXNlZCBz
eXN0ZW1zIHBsZWFzZSB1c2UgdGhlICJpYTY0IiBJTkYgb3IgYWRkDQo7ICAiTlRJQTY0IiBzZWN0
aW9ucyB0byB0aGlzIElORiBmaWxlLg0KOw0KOyAgQWxsIHN0cmluZ3MgaW4gdGhpcyBJTkYgZmls
ZSB1c2luZyBjYXBpdGFsIGxldHRlcnMgYW5kIGZvcm1hdCAiLi4uX05BTUUiLg0KOw0KOyAgVGhl
IElORiBmaWxlIG1hcHBlcyBldmVyeSByZWZlcmVuY2UgYm9hcmQgdG8gb25lIG9mIHRocmVlIHNl
Y3Rpb25zLg0KOyAgLSBSZWZlcmVuY2VCb2FyZFNBQTcxMzANCjsgIC0gUmVmZXJlbmNlQm9hcmRT
QUE3MTMzIC8vIFNBQTcxMzEsIFNBQTcxMzMsIFNBQTcxMzUgaGF2ZSB0aGUgc2FtZSBQTlAgaWQN
CjsgIC0gUmVmZXJlbmNlQm9hcmRTQUE3MTM0DQo7ICBUaGVzZSBzZWN0aW9ucyBleGlzdCBmb3Ig
MzIgYml0IChOVHg4NikgYW5kIDY0IGJpdCAoTlRBTUQ2NCkuDQo7ICBUaGUgIlByb3RldXMiIGNh
cmQgaXMgYW4gZXhjZXB0aW9uLiBJdCB1c2VzIHNlY3Rpb24gIlJlZmVyZW5jZUJvYXJkUFJPVEVV
UyIuDQo7ICBUaGlzIGRlc2lnbiBzaG93cyBob3cgdG8gdXNlIHRoZSByZWdpc3RyeSBpZiBubyBv
bi1ib2FyZCBFRVBST00gaXMgcHJlc2VudA0KOyAgb3Igbm90IHByb2dyYW1tZWQgY29ycmVjdGx5
Lg0KOw0KOyAgRWFjaCBib2FyZCBpcyBhc3NpZ25lZCB0byBvbmUgc2VjdGlvbiBlLmcuICJSZWZl
cmVuY2VCb2FyZFNBQTcxMzAuTlR4ODYiLg0KOyAgRWFjaCBzZWN0aW9uIGhhcyB0aHJlZSBlbnRy
aWVzIGUuZy4gIlJlZmVyZW5jZUJvYXJkU0FBNzEzMC5OVHg4NiIsDQo7ICAgIlJlZmVyZW5jZUJv
YXJkU0FBNzEzMC5OVHg4Ni5Db0luc3RhbGxlcnMiIGFuZCAiLi4uNzEzMC5OVHg4Ni5TZXJ2aWNl
cyIuDQo7ICBJbnNpZGUgdGhlICJSZWZlcmVuY2VCb2FyZFNBQTcxMzAuTlR4ODYiIHNlY3Rpb24g
ZW50cnksIHRoZSBib2FyZCBzcGVjaWZpYw0KOyAgcmVnaXN0cnkgc2V0dGluZ3Mgc2VjdGlvbiBp
cyBjYWxsZWQgZS5nLiAiUmVmZXJlbmNlQm9hcmRTQUE3MTMwLkFkZFJlZyIuDQo7DQo7ICBJbiBv
cmRlciB0byBnZXQgeW91ciBib2FyZHMgc3VwcG9ydGVkIGJ5IHRoaXMgSU5GLCB0YWtlIGEgbG9v
ayB0byBhbGwgDQo7ICBzZWN0aW9ucyB3aXRoIHRpdGxlIGZyYW1lcyB1c2luZyAoKikuDQo7DQo7
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioNCg0KW1ZlcnNpb25dDQpzaWduYXR1cmUgICAgICAgICAgID0g
IiRDSElDQUdPJCIgO0FsbCBXaW5kb3dzIE9TDQpDbGFzcyAgICAgICAgICAgICAgID0gTUVESUEN
CkNsYXNzR1VJRCAgICAgICAgICAgPSB7NGQzNmU5NmMtZTMyNS0xMWNlLWJmYzEtMDgwMDJiZTEw
MzE4fQ0KUHJvdmlkZXIgICAgICAgICAgICA9ICVQUk9WSURFUl9OQU1FJQ0KQ2F0YWxvZ0ZpbGUu
TlRBTUQ2NCA9IDN4SHlicjY0LmNhdA0KQ2F0YWxvZ0ZpbGUuTlR4ODYgICA9IDN4SHlicmlkLmNh
dA0KDQo7LS0tLS0tLS0tLS0tLS0tLS0tLS0tbW0vZGQveXl5eSx2ZXJzaW9uLS0tLS0tLS0tLS0t
LS0tLS0tLS0NCkRyaXZlclZlciAgICAgICAgICAgPSAwOC8wMS8yMDA5LDEuNC4wLjMNCjsgICAg
ICAgICAgICAgICAgICAgLT4gUmVsZWFzZQ0KOy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQoNCg0KDQpbTWFudWZhY3R1cmVyXQ0KJVBS
T1ZJREVSX05BTUUlICA9IFN1cHBvcnRlZEJvYXJkcywgTlR4ODYsIE5UQU1ENjQNCg0KOy0tLT4g
MzIgQklUIFNVUFBPUlQgPC0tLQ0KW1N1cHBvcnRlZEJvYXJkcy5OVHg4Nl0NCjsqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqDQo7KCop
ICEhISBHZW5lcmljIElEJ3MsIHVzZWQgZm9yIHRlc3RpbmcgcHVycG9zZXMgb25seSAhISEgICAg
Kg0KOyAgICAhISEgTXVzdCBiZSByZW1vdmVkIGZvciBvZmZpY2lhbCBkcml2ZXIgdmVyc2lvbnMg
ISEhICAgICoNCjsqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqDQo7JVJFRkVSRU5DRV9CT0FSRF9TQUE3MTMwX05BTUUlID0gUmVmZXJl
bmNlQm9hcmRTQUE3MTMwLk5UeDg2LFBDSVxWRU5fMTEzMSZERVZfNzEzMA0KOyVSRUZFUkVOQ0Vf
Qk9BUkRfU0FBNzEzM19OQU1FJSA9IFJlZmVyZW5jZUJvYXJkU0FBNzEzMy5OVHg4NixQQ0lcVkVO
XzExMzEmREVWXzcxMzMNCjslUkVGRVJFTkNFX0JPQVJEX1NBQTcxMzRfTkFNRSUgPSBSZWZlcmVu
Y2VCb2FyZFNBQTcxMzQuTlR4ODYsUENJXFZFTl8xMTMxJkRFVl83MTM0DQoNCg0KOyoqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioNCjso
KikgICAgICAgICAgICAgICAgIDQtUGFydC1QTlAgQm9hcmQgSUQncyAgICAgICAgICAgICAgICAg
ICAqDQo7KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKg0KOyoqKioqKioqIE1lcmN1ciwgVGlnZXIsLi4uICoqKg0KOyVSRUZFUkVOQ0Vf
Qk9BUkRfU0FBNzEzMF9OQU1FJSA9IFJlZmVyZW5jZUJvYXJkU0FBNzEzMC5OVHg4NixQQ0lcVkVO
XzExMzEmREVWXzcxMzAmU1VCU1lTXzIwMTgxMTMxDQo7JVJFRkVSRU5DRV9CT0FSRF9TQUE3MTMz
X05BTUUlID0gUmVmZXJlbmNlQm9hcmRTQUE3MTMzLk5UeDg2LFBDSVxWRU5fMTEzMSZERVZfNzEz
MyZTVUJTWVNfMjAxODExMzENCjslUkVGRVJFTkNFX0JPQVJEX1NBQTcxMzRfTkFNRSUgPSBSZWZl
cmVuY2VCb2FyZFNBQTcxMzQuTlR4ODYsUENJXFZFTl8xMTMxJkRFVl83MTM0JlNVQlNZU18yMDE4
MTEzMQ0KDQolUkVGRVJFTkNFX0JPQVJEX1NBQTcxMzNfTkFNRSUgPSBSZWZlcmVuY2VCb2FyZFNB
QTcxMzMuTlR4ODYsUENJXFZFTl8xMTMxJkRFVl83MTMzJlNVQlNZU185MDA4MTQ1OA0KJVJFRkVS
RU5DRV9CT0FSRF9TQUE3MTMzX05BTUUlID0gUmVmZXJlbmNlQm9hcmRTQUE3MTMzLk5UeDg2LFBD
SVxWRU5fMTEzMSZERVZfNzEzMyZTVUJTWVNfOTAwNTE0NTgNCiVSRUZFUkVOQ0VfQk9BUkRfU0FB
NzEzM19OQU1FJSA9IFJlZmVyZW5jZUJvYXJkU0FBNzEzMy5OVHg4NixQQ0lcVkVOXzExMzEmREVW
XzcxMzMmU1VCU1lTXzkwMDQxNDU4DQoNCjsqKioqKioqKiBFdXJvcGEgKDEtMyksIFNuYWtlLCBU
b3VnaCwgU21hcnQsIENsZXZlciAqKioNCjslUkVGRVJFTkNFX0JPQVJEX1NBQTcxMzBfTkFNRSUg
PSBSZWZlcmVuY2VCb2FyZFNBQTcxMzAuTlR4ODYsUENJXFZFTl8xMTMxJkRFVl83MTMwJlNVQlNZ
U18yMDA0MTEzMQ0KOyVSRUZFUkVOQ0VfQk9BUkRfU0FBNzEzM19OQU1FJSA9IFJlZmVyZW5jZUJv
YXJkU0FBNzEzMy5OVHg4NixQQ0lcVkVOXzExMzEmREVWXzcxMzMmU1VCU1lTXzIwMDQxMTMxDQo7
JVJFRkVSRU5DRV9CT0FSRF9TQUE3MTM0X05BTUUlID0gUmVmZXJlbmNlQm9hcmRTQUE3MTM0Lk5U
eDg2LFBDSVxWRU5fMTEzMSZERVZfNzEzNCZTVUJTWVNfMjAwNDExMzENCg0KOyoqKioqKioqIEV1
cm9wYSAoNC54KSAqKioNCjslUkVGRVJFTkNFX0JPQVJEX1NBQTcxMzNfTkFNRSUgPSBSZWZlcmVu
Y2VCb2FyZFNBQTcxMzMuTlR4ODYsUENJXFZFTl8xMTMxJkRFVl83MTMzJlNVQlNZU18yMDA2MTEz
MQ0KDQo7KioqKioqKiogUHJvdGV1cyAqKioNCjslUkVGRVJFTkNFX0JPQVJEX1NBQTcxMzBfTkFN
RSUgPSBSZWZlcmVuY2VCb2FyZFBST1RFVVMuTlR4ODYsUENJXFZFTl8xMTMxJkRFVl83MTMwJlNV
QlNZU18yMDAxMTEzMQ0KOyVSRUZFUkVOQ0VfQk9BUkRfU0FBNzEzM19OQU1FJSA9IFJlZmVyZW5j
ZUJvYXJkUFJPVEVVUy5OVHg4NixQQ0lcVkVOXzExMzEmREVWXzcxMzMmU1VCU1lTXzIwMDExMTMx
DQo7JVJFRkVSRU5DRV9CT0FSRF9TQUE3MTM0X05BTUUlID0gUmVmZXJlbmNlQm9hcmRQUk9URVVT
Lk5UeDg2LFBDSVxWRU5fMTEzMSZERVZfNzEzNCZTVUJTWVNfMjAwMTExMzENCg0KDQo7LS0tPiA2
NCBCSVQgU1VQUE9SVCA8LS0tDQpbU3VwcG9ydGVkQm9hcmRzLk5UQU1ENjRdDQo7KioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKg0KOygq
KSAhISEgR2VuZXJpYyBJRCdzLCB1c2VkIGZvciB0ZXN0aW5nIHB1cnBvc2VzIG9ubHkgISEhICAg
ICoNCjsqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqDQo7JVJFRkVSRU5DRV9CT0FSRF9TQUE3MTMwX05BTUUlID0gUmVmZXJlbmNlQm9h
cmRTQUE3MTMwLk5UQU1ENjQsUENJXFZFTl8xMTMxJkRFVl83MTMwDQo7JVJFRkVSRU5DRV9CT0FS
RF9TQUE3MTMzX05BTUUlID0gUmVmZXJlbmNlQm9hcmRTQUE3MTMzLk5UQU1ENjQsUENJXFZFTl8x
MTMxJkRFVl83MTMzDQo7JVJFRkVSRU5DRV9CT0FSRF9TQUE3MTM0X05BTUUlID0gUmVmZXJlbmNl
Qm9hcmRTQUE3MTM0Lk5UQU1ENjQsUENJXFZFTl8xMTMxJkRFVl83MTM0DQoNCg0KOyoqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioNCjso
KikgICAgICAgICAgICAgICAgIDQtUGFydC1QTlAgQm9hcmQgSUQncyAgICAgICAgICAgICAgICAg
ICAqDQo7KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKg0KOyoqKioqKioqIE1lcmN1ciwgVGlnZXIsLi4uICoqKg0KOyVSRUZFUkVOQ0Vf
Qk9BUkRfU0FBNzEzMF9OQU1FJSA9IFJlZmVyZW5jZUJvYXJkU0FBNzEzMC5OVEFNRDY0LFBDSVxW
RU5fMTEzMSZERVZfNzEzMCZTVUJTWVNfMjAxODExMzENCg0KJVJFRkVSRU5DRV9CT0FSRF9TQUE3
MTMzX05BTUUlID0gUmVmZXJlbmNlQm9hcmRTQUE3MTMzLk5UQU1ENjQsUENJXFZFTl8xMTMxJkRF
Vl83MTMzJlNVQlNZU185MDA4MTQ1OA0KJVJFRkVSRU5DRV9CT0FSRF9TQUE3MTMzX05BTUUlID0g
UmVmZXJlbmNlQm9hcmRTQUE3MTMzLk5UQU1ENjQsUENJXFZFTl8xMTMxJkRFVl83MTMzJlNVQlNZ
U185MDA1MTQ1OA0KJVJFRkVSRU5DRV9CT0FSRF9TQUE3MTMzX05BTUUlID0gUmVmZXJlbmNlQm9h
cmRTQUE3MTMzLk5UQU1ENjQsUENJXFZFTl8xMTMxJkRFVl83MTMzJlNVQlNZU185MDA0MTQ1OA0K
DQo7JVJFRkVSRU5DRV9CT0FSRF9TQUE3MTM0X05BTUUlID0gUmVmZXJlbmNlQm9hcmRTQUE3MTM0
Lk5UQU1ENjQsUENJXFZFTl8xMTMxJkRFVl83MTM0JlNVQlNZU18yMDE4MTEzMQ0KDQo7KioqKioq
KiogRXVyb3BhICgxLTMpLCBTbmFrZSwgVG91Z2gsIFNtYXJ0LCBDbGV2ZXIgKioqDQo7JVJFRkVS
RU5DRV9CT0FSRF9TQUE3MTMwX05BTUUlID0gUmVmZXJlbmNlQm9hcmRTQUE3MTMwLk5UQU1ENjQs
UENJXFZFTl8xMTMxJkRFVl83MTMwJlNVQlNZU18yMDA0MTEzMQ0KOyVSRUZFUkVOQ0VfQk9BUkRf
U0FBNzEzM19OQU1FJSA9IFJlZmVyZW5jZUJvYXJkU0FBNzEzMy5OVEFNRDY0LFBDSVxWRU5fMTEz
MSZERVZfNzEzMyZTVUJTWVNfMjAwNDExMzENCjslUkVGRVJFTkNFX0JPQVJEX1NBQTcxMzRfTkFN
RSUgPSBSZWZlcmVuY2VCb2FyZFNBQTcxMzQuTlRBTUQ2NCxQQ0lcVkVOXzExMzEmREVWXzcxMzQm
U1VCU1lTXzIwMDQxMTMxDQoNCjsqKioqKioqKiBFdXJvcGEgKDQueCkgKioqDQo7JVJFRkVSRU5D
RV9CT0FSRF9TQUE3MTMzX05BTUUlID0gUmVmZXJlbmNlQm9hcmRTQUE3MTMzLk5UQU1ENjQsUENJ
XFZFTl8xMTMxJkRFVl83MTMzJlNVQlNZU18yMDA2MTEzMQ0KDQo7KioqKioqKiogUHJvdGV1cyAq
KioNCjslUkVGRVJFTkNFX0JPQVJEX1NBQTcxMzBfTkFNRSUgPSBSZWZlcmVuY2VCb2FyZFBST1RF
VVMuTlRBTUQ2NCxQQ0lcVkVOXzExMzEmREVWXzcxMzAmU1VCU1lTXzIwMDExMTMxDQo7JVJFRkVS
RU5DRV9CT0FSRF9TQUE3MTMzX05BTUUlID0gUmVmZXJlbmNlQm9hcmRQUk9URVVTLk5UQU1ENjQs
UENJXFZFTl8xMTMxJkRFVl83MTMzJlNVQlNZU18yMDAxMTEzMQ0KOyVSRUZFUkVOQ0VfQk9BUkRf
U0FBNzEzNF9OQU1FJSA9IFJlZmVyZW5jZUJvYXJkUFJPVEVVUy5OVEFNRDY0LFBDSVxWRU5fMTEz
MSZERVZfNzEzNCZTVUJTWVNfMjAwMTExMzENCg0KDQo7PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT0NCjsNCjsgICAgIEZpbGVzIGFuZCBmb2xkZXIgZGVmaW5pdGlvbnMNCjsN
Cjs9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQ0KW1NvdXJjZURpc2tzTmFt
ZXNdDQoxID0gJUlOU1RBTExBVElPTl9ESVNLX05BTUUlLCwNCg0KW1NvdXJjZURpc2tzRmlsZXNd
DQozeEh5YnJpZC5zeXMgICAgICAgICAgID0gMQ0KM3hIeWJyNjQuc3lzICAgICAgICAgICA9IDEN
Ck5YUE1WMzIuZGxsICAgICAgICAgICAgPSAxDQpOWFBNVjY0LmRsbCAgICAgICAgICAgID0gMQ0K
MzRDb0luc3RhbGxlci5kbGwgICAgICA9IDENCg0KW0Rlc3RpbmF0aW9uRGlyc10NClNlY3Rpb25Y
MzIuQ29weURsbC5OVHg4NiAgICAgID0gMTENClNlY3Rpb25YNjQuQ29weURsbC5OVEFNRDY0ICAg
ID0gMTENClNlY3Rpb25YMzIuQ29weURyaXZlci5OVHg4NiAgID0gMTAsc3lzdGVtMzJcZHJpdmVy
cw0KU2VjdGlvblg2NC5Db3B5RHJpdmVyLk5UQU1ENjQgPSAxMCxzeXN0ZW0zMlxkcml2ZXJzDQoN
CltTZWN0aW9uWDMyLkNvcHlEbGwuTlR4ODZdDQpOWFBNVjMyLmRsbA0KMzRDb0luc3RhbGxlci5k
bGwNCg0KW1NlY3Rpb25YNjQuQ29weURsbC5OVEFNRDY0XQ0KTlhQTVY2NC5kbGwNCg0KW1NlY3Rp
b25YMzIuQ29weURyaXZlci5OVHg4Nl0NCjN4SHlicmlkLnN5cw0KDQpbU2VjdGlvblg2NC5Db3B5
RHJpdmVyLk5UQU1ENjRdDQozeEh5YnI2NC5zeXMNCg0KDQo7PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT0NCjsNCjsgICAgICAgSW5pdGlhbGl6YXRpb24gRW50cmllcw0KOw0K
Oz09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09DQoNCjsqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqDQo7KCopICAgICBTQUE3MTMwIFJlZmVy
ZW5jZSBCb2FyZHMgLSAzMiBCaXQgICAgDQo7KioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKg0KW1JlZmVyZW5jZUJvYXJkU0FBNzEzMC5OVHg4Ni5Db0luc3RhbGxl
cnNdDQpDb3B5RmlsZXMgICAgID0gU2VjdGlvblgzMi5Db3B5RGxsLk5UeDg2DQpBZGRSZWcgICAg
ICAgID0gU2VjdGlvblgzMi5EbGxBZGRSZWcuTlR4ODYNCg0KW1JlZmVyZW5jZUJvYXJkU0FBNzEz
MC5OVHg4Nl0NCkluY2x1ZGUgICAgICAgPSBrcy5pbmYsIHdkbWF1ZGlvLmluZiwga3NjYXB0dXIu
aW5mLCBiZGEuaW5mDQpOZWVkcyAgICAgICAgID0gS1MuUmVnaXN0cmF0aW9uLCBXRE1BVURJTy5S
ZWdpc3RyYXRpb24uTlQsIEtTQ0FQVFVSLlJlZ2lzdHJhdGlvbi5OVCwgQkRBLkluc3RhbGxhdGlv
bi5OVA0KQ29weUZpbGVzICAgICA9IFNlY3Rpb25YMzIuQ29weURyaXZlci5OVHg4NiwgU2VjdGlv
blgzMi5Db3B5RGxsLk5UeDg2DQpEZWxSZWcgICAgICAgID0gU2VjdGlvblgzMi5EZWxSZWcuTlR4
ODYNCkFkZFJlZyAgICAgICAgPSBTZWN0aW9uWDMyLkFkZFJlZy5OVHg4NiwgUmVmZXJlbmNlQm9h
cmRTQUE3MTMwLkFkZFJlZw0KUmVnaXN0ZXJEbGxzICA9IFNlY3Rpb25YMzIuUmVnaXN0ZXIuTlR4
ODYNCg0KW1JlZmVyZW5jZUJvYXJkU0FBNzEzMC5OVHg4Ni5TZXJ2aWNlc10NCkFkZFNlcnZpY2Ug
ICAgPSAlU0VSVklDRV9OQU1FX1gzMiUsIDB4MDAwMDAwMDIsIFNlY3Rpb25YMzIuU2VydmljZUlu
c3RhbGwuTlR4ODYNCg0KDQo7KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKg0KOygqKSAgICAgU0FBNzEzMCBSZWZlcmVuY2UgQm9hcmRzIC0gNjQgQml0DQo7Kioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKg0KW1JlZmVyZW5jZUJv
YXJkU0FBNzEzMC5OVEFNRDY0LkNvSW5zdGFsbGVyc10NCkNvcHlGaWxlcyAgICAgPSBTZWN0aW9u
WDY0LkNvcHlEbGwuTlRBTUQ2NA0KQWRkUmVnICAgICAgICA9IFNlY3Rpb25YNjQuRGxsQWRkUmVn
Lk5UQU1ENjQNCg0KW1JlZmVyZW5jZUJvYXJkU0FBNzEzMC5OVEFNRDY0XQ0KSW5jbHVkZSAgICAg
ICA9IGtzLmluZiwgd2RtYXVkaW8uaW5mLCBrc2NhcHR1ci5pbmYsIGJkYS5pbmYNCk5lZWRzICAg
ICAgICAgPSBLUy5SZWdpc3RyYXRpb24sIFdETUFVRElPLlJlZ2lzdHJhdGlvbi5OVCwgS1NDQVBU
VVIuUmVnaXN0cmF0aW9uLk5ULCBCREEuSW5zdGFsbGF0aW9uLk5UDQpDb3B5RmlsZXMgICAgID0g
U2VjdGlvblg2NC5Db3B5RHJpdmVyLk5UQU1ENjQsIFNlY3Rpb25YNjQuQ29weURsbC5OVEFNRDY0
DQpEZWxSZWcgICAgICAgID0gU2VjdGlvblgzMi5EZWxSZWcuTlRBTUQ2NA0KQWRkUmVnICAgICAg
ICA9IFNlY3Rpb25YNjQuQWRkUmVnLk5UQU1ENjQsIFJlZmVyZW5jZUJvYXJkU0FBNzEzMC5BZGRS
ZWcNClJlZ2lzdGVyRGxscyAgPSBTZWN0aW9uWDY0LlJlZ2lzdGVyLk5UQU1ENjQNCg0KW1JlZmVy
ZW5jZUJvYXJkU0FBNzEzMC5OVEFNRDY0LlNlcnZpY2VzXQ0KQWRkU2VydmljZSAgICA9ICVTRVJW
SUNFX05BTUVfWDY0JSwgMHgwMDAwMDAwMiwgU2VjdGlvblg2NC5TZXJ2aWNlSW5zdGFsbC5OVEFN
RDY0DQoNCg0KOyoqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioN
CjsoKikgICAgIFNBQTcxMzMgUmVmZXJlbmNlIEJvYXJkcyAtIDMyIEJpdA0KOyoqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioNCltSZWZlcmVuY2VCb2FyZFNBQTcx
MzMuTlR4ODYuQ29JbnN0YWxsZXJzXQ0KQ29weUZpbGVzICAgICA9IFNlY3Rpb25YMzIuQ29weURs
bC5OVHg4Ng0KQWRkUmVnICAgICAgICA9IFNlY3Rpb25YMzIuRGxsQWRkUmVnLk5UeDg2DQoNCltS
ZWZlcmVuY2VCb2FyZFNBQTcxMzMuTlR4ODZdDQpJbmNsdWRlICAgICAgID0ga3MuaW5mLCB3ZG1h
dWRpby5pbmYsIGtzY2FwdHVyLmluZiwgYmRhLmluZg0KTmVlZHMgICAgICAgICA9IEtTLlJlZ2lz
dHJhdGlvbiwgV0RNQVVESU8uUmVnaXN0cmF0aW9uLk5ULCBLU0NBUFRVUi5SZWdpc3RyYXRpb24u
TlQsIEJEQS5JbnN0YWxsYXRpb24uTlQNCkNvcHlGaWxlcyAgICAgPSBTZWN0aW9uWDMyLkNvcHlE
cml2ZXIuTlR4ODYsIFNlY3Rpb25YMzIuQ29weURsbC5OVHg4Ng0KRGVsUmVnICAgICAgICA9IFNl
Y3Rpb25YMzIuRGVsUmVnLk5UeDg2DQpBZGRSZWcgICAgICAgID0gU2VjdGlvblgzMi5BZGRSZWcu
TlR4ODYsIFJlZmVyZW5jZUJvYXJkU0FBNzEzMy5BZGRSZWcNClJlZ2lzdGVyRGxscyAgPSBTZWN0
aW9uWDMyLlJlZ2lzdGVyLk5UeDg2DQoNCltSZWZlcmVuY2VCb2FyZFNBQTcxMzMuTlR4ODYuU2Vy
dmljZXNdDQpBZGRTZXJ2aWNlICAgID0gJVNFUlZJQ0VfTkFNRV9YMzIlLCAweDAwMDAwMDAyLCBT
ZWN0aW9uWDMyLlNlcnZpY2VJbnN0YWxsLk5UeDg2DQoNCg0KOyoqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioNCjsoKikgICAgIFNBQTcxMzMgUmVmZXJlbmNlIEJv
YXJkcyAtIDY0IEJpdA0KOyoqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioNCltSZWZlcmVuY2VCb2FyZFNBQTcxMzMuTlRBTUQ2NC5Db0luc3RhbGxlcnNdDQpDb3B5
RmlsZXMgICAgID0gU2VjdGlvblg2NC5Db3B5RGxsLk5UQU1ENjQNCkFkZFJlZyAgICAgICAgPSBT
ZWN0aW9uWDY0LkRsbEFkZFJlZy5OVEFNRDY0DQoNCltSZWZlcmVuY2VCb2FyZFNBQTcxMzMuTlRB
TUQ2NF0NCkluY2x1ZGUgICAgICAgPSBrcy5pbmYsIHdkbWF1ZGlvLmluZiwga3NjYXB0dXIuaW5m
LCBiZGEuaW5mDQpOZWVkcyAgICAgICAgID0gS1MuUmVnaXN0cmF0aW9uLCBXRE1BVURJTy5SZWdp
c3RyYXRpb24uTlQsIEtTQ0FQVFVSLlJlZ2lzdHJhdGlvbi5OVCwgQkRBLkluc3RhbGxhdGlvbi5O
VA0KQ29weUZpbGVzICAgICA9IFNlY3Rpb25YNjQuQ29weURyaXZlci5OVEFNRDY0LCBTZWN0aW9u
WDY0LkNvcHlEbGwuTlRBTUQ2NA0KRGVsUmVnICAgICAgICA9IFNlY3Rpb25YMzIuRGVsUmVnLk5U
QU1ENjQNCkFkZFJlZyAgICAgICAgPSBTZWN0aW9uWDY0LkFkZFJlZy5OVEFNRDY0LCBSZWZlcmVu
Y2VCb2FyZFNBQTcxMzMuQWRkUmVnDQpSZWdpc3RlckRsbHMgID0gU2VjdGlvblg2NC5SZWdpc3Rl
ci5OVEFNRDY0DQoNCltSZWZlcmVuY2VCb2FyZFNBQTcxMzMuTlRBTUQ2NC5TZXJ2aWNlc10NCkFk
ZFNlcnZpY2UgICAgPSAlU0VSVklDRV9OQU1FX1g2NCUsIDB4MDAwMDAwMDIsIFNlY3Rpb25YNjQu
U2VydmljZUluc3RhbGwuTlRBTUQ2NA0KDQoNCjsqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqDQo7KCopICAgICBTQUE3MTM0IFJlZmVyZW5jZSBCb2FyZHMgLSAz
MiBCaXQNCjsqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqDQpb
UmVmZXJlbmNlQm9hcmRTQUE3MTM0Lk5UeDg2LkNvSW5zdGFsbGVyc10NCkNvcHlGaWxlcyAgICAg
PSBTZWN0aW9uWDMyLkNvcHlEbGwuTlR4ODYNCkFkZFJlZyAgICAgICAgPSBTZWN0aW9uWDMyLkRs
bEFkZFJlZy5OVHg4Ng0KDQpbUmVmZXJlbmNlQm9hcmRTQUE3MTM0Lk5UeDg2XQ0KSW5jbHVkZSAg
ICAgICA9IGtzLmluZiwgd2RtYXVkaW8uaW5mLCBrc2NhcHR1ci5pbmYsIGJkYS5pbmYNCk5lZWRz
ICAgICAgICAgPSBLUy5SZWdpc3RyYXRpb24sIFdETUFVRElPLlJlZ2lzdHJhdGlvbi5OVCwgS1ND
QVBUVVIuUmVnaXN0cmF0aW9uLk5ULCBCREEuSW5zdGFsbGF0aW9uLk5UDQpDb3B5RmlsZXMgICAg
ID0gU2VjdGlvblgzMi5Db3B5RHJpdmVyLk5UeDg2LCBTZWN0aW9uWDMyLkNvcHlEbGwuTlR4ODYN
CkRlbFJlZyAgICAgICAgPSBTZWN0aW9uWDMyLkRlbFJlZy5OVHg4Ng0KQWRkUmVnICAgICAgICA9
IFNlY3Rpb25YMzIuQWRkUmVnLk5UeDg2LCBSZWZlcmVuY2VCb2FyZFNBQTcxMzQuQWRkUmVnDQpS
ZWdpc3RlckRsbHMgID0gU2VjdGlvblgzMi5SZWdpc3Rlci5OVHg4Ng0KDQpbUmVmZXJlbmNlQm9h
cmRTQUE3MTM0Lk5UeDg2LlNlcnZpY2VzXQ0KQWRkU2VydmljZSAgICA9ICVTRVJWSUNFX05BTUVf
WDMyJSwgMHgwMDAwMDAwMiwgU2VjdGlvblgzMi5TZXJ2aWNlSW5zdGFsbC5OVHg4Ng0KDQoNCjsq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqDQo7KCopICAgICBT
QUE3MTM0IFJlZmVyZW5jZSBCb2FyZHMgLSA2NCBCaXQNCjsqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqDQpbUmVmZXJlbmNlQm9hcmRTQUE3MTM0Lk5UQU1ENjQu
Q29JbnN0YWxsZXJzXQ0KQ29weUZpbGVzICAgICA9IFNlY3Rpb25YNjQuQ29weURsbC5OVEFNRDY0
DQpBZGRSZWcgICAgICAgID0gU2VjdGlvblg2NC5EbGxBZGRSZWcuTlRBTUQ2NA0KDQpbUmVmZXJl
bmNlQm9hcmRTQUE3MTM0Lk5UQU1ENjRdDQpJbmNsdWRlICAgICAgID0ga3MuaW5mLCB3ZG1hdWRp
by5pbmYsIGtzY2FwdHVyLmluZiwgYmRhLmluZg0KTmVlZHMgICAgICAgICA9IEtTLlJlZ2lzdHJh
dGlvbiwgV0RNQVVESU8uUmVnaXN0cmF0aW9uLk5ULCBLU0NBUFRVUi5SZWdpc3RyYXRpb24uTlQs
IEJEQS5JbnN0YWxsYXRpb24uTlQNCkNvcHlGaWxlcyAgICAgPSBTZWN0aW9uWDY0LkNvcHlEcml2
ZXIuTlRBTUQ2NCwgU2VjdGlvblg2NC5Db3B5RGxsLk5UQU1ENjQNCkRlbFJlZyAgICAgICAgPSBT
ZWN0aW9uWDMyLkRlbFJlZy5OVEFNRDY0DQpBZGRSZWcgICAgICAgID0gU2VjdGlvblg2NC5BZGRS
ZWcuTlRBTUQ2NCwgUmVmZXJlbmNlQm9hcmRTQUE3MTM0LkFkZFJlZw0KUmVnaXN0ZXJEbGxzICA9
IFNlY3Rpb25YNjQuUmVnaXN0ZXIuTlRBTUQ2NA0KDQpbUmVmZXJlbmNlQm9hcmRTQUE3MTM0Lk5U
QU1ENjQuU2VydmljZXNdDQpBZGRTZXJ2aWNlICAgID0gJVNFUlZJQ0VfTkFNRV9YNjQlLCAweDAw
MDAwMDAyLCBTZWN0aW9uWDY0LlNlcnZpY2VJbnN0YWxsLk5UQU1ENjQNCg0KDQo7KioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioNCjsoKikgICAgICJQcm90ZXVz
IiBSZWZlcmVuY2UgQm9hcmQgLSAzMiBCaXQNCjsqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKg0KW1JlZmVyZW5jZUJvYXJkUFJPVEVVUy5OVHg4Ni5Db0luc3Rh
bGxlcnNdDQpDb3B5RmlsZXMgICAgID0gU2VjdGlvblgzMi5Db3B5RGxsLk5UeDg2DQpBZGRSZWcg
ICAgICAgID0gU2VjdGlvblgzMi5EbGxBZGRSZWcuTlR4ODYNCg0KW1JlZmVyZW5jZUJvYXJkUFJP
VEVVUy5OVHg4Nl0NCkluY2x1ZGUgICAgICAgPSBrcy5pbmYsIHdkbWF1ZGlvLmluZiwga3NjYXB0
dXIuaW5mLCBiZGEuaW5mDQpOZWVkcyAgICAgICAgID0gS1MuUmVnaXN0cmF0aW9uLCBXRE1BVURJ
Ty5SZWdpc3RyYXRpb24uTlQsIEtTQ0FQVFVSLlJlZ2lzdHJhdGlvbi5OVCwgQkRBLkluc3RhbGxh
dGlvbi5OVA0KQ29weUZpbGVzICAgICA9IFNlY3Rpb25YMzIuQ29weURyaXZlci5OVHg4NiwgU2Vj
dGlvblgzMi5Db3B5RGxsLk5UeDg2DQpEZWxSZWcgICAgICAgID0gU2VjdGlvblgzMi5EZWxSZWcu
TlR4ODYNCkFkZFJlZyAgICAgICAgPSBTZWN0aW9uWDMyLkFkZFJlZy5OVHg4NiwgUmVmZXJlbmNl
Qm9hcmRQUk9URVVTLkFkZFJlZw0KUmVnaXN0ZXJEbGxzICA9IFNlY3Rpb25YMzIuUmVnaXN0ZXIu
TlR4ODYNCg0KW1JlZmVyZW5jZUJvYXJkUFJPVEVVUy5OVHg4Ni5TZXJ2aWNlc10NCkFkZFNlcnZp
Y2UgICAgPSAlU0VSVklDRV9OQU1FX1gzMiUsIDB4MDAwMDAwMDIsIFNlY3Rpb25YMzIuU2Vydmlj
ZUluc3RhbGwuTlR4ODYNCg0KDQo7KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioNCjsoKikgICAgICJQcm90ZXVzIiBSZWZlcmVuY2UgQm9hcmQgLSA2NCBCaXQN
CjsqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKg0KW1JlZmVy
ZW5jZUJvYXJkUFJPVEVVUy5OVEFNRDY0LkNvSW5zdGFsbGVyc10NCkNvcHlGaWxlcyAgICAgPSBT
ZWN0aW9uWDY0LkNvcHlEbGwuTlRBTUQ2NA0KQWRkUmVnICAgICAgICA9IFNlY3Rpb25YNjQuRGxs
QWRkUmVnLk5UQU1ENjQNCg0KW1JlZmVyZW5jZUJvYXJkUFJPVEVVUy5OVEFNRDY0XQ0KSW5jbHVk
ZSAgICAgICA9IGtzLmluZiwgd2RtYXVkaW8uaW5mLCBrc2NhcHR1ci5pbmYsIGJkYS5pbmYNCk5l
ZWRzICAgICAgICAgPSBLUy5SZWdpc3RyYXRpb24sIFdETUFVRElPLlJlZ2lzdHJhdGlvbi5OVCwg
S1NDQVBUVVIuUmVnaXN0cmF0aW9uLk5ULCBCREEuSW5zdGFsbGF0aW9uLk5UDQpDb3B5RmlsZXMg
ICAgID0gU2VjdGlvblg2NC5Db3B5RHJpdmVyLk5UQU1ENjQsIFNlY3Rpb25YNjQuQ29weURsbC5O
VEFNRDY0DQpEZWxSZWcgICAgICAgID0gU2VjdGlvblgzMi5EZWxSZWcuTlRBTUQ2NA0KQWRkUmVn
ICAgICAgICA9IFNlY3Rpb25YNjQuQWRkUmVnLk5UQU1ENjQsIFJlZmVyZW5jZUJvYXJkUFJPVEVV
Uy5BZGRSZWcNClJlZ2lzdGVyRGxscyAgPSBTZWN0aW9uWDY0LlJlZ2lzdGVyLk5UQU1ENjQNCg0K
W1JlZmVyZW5jZUJvYXJkUFJPVEVVUy5OVEFNRDY0LlNlcnZpY2VzXQ0KQWRkU2VydmljZSAgICA9
ICVTRVJWSUNFX05BTUVfWDY0JSwgMHgwMDAwMDAwMiwgU2VjdGlvblg2NC5TZXJ2aWNlSW5zdGFs
bC5OVEFNRDY0DQoNCg0KOz09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PQ0KOw0KOyBHZW5lcmFsIFNlY3Rpb24sIHVzZWQgYnkgYWxsIHJlZmVyZW5jZSBkZXNp
Z25zIA0KOw0KOz09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PQ0KDQpbU2VjdGlvblgzMi5TZXJ2aWNlSW5zdGFsbC5OVHg4Nl0NCkRpc3BsYXlOYW1lICAgPSAl
RElTUExBWV9OQU1FJQ0KRGVzY3JpcHRpb24gICA9ICVTRVJWSUNFX0RFU0NSSVBUSU9OX05BTUUl
DQpTZXJ2aWNlVHlwZSAgID0gJVNFUlZJQ0VfS0VSTkVMX0RSSVZFUiUNClN0YXJ0VHlwZSAgICAg
PSAlU0VSVklDRV9ERU1BTkRfU1RBUlQlDQpFcnJvckNvbnRyb2wgID0gJVNFUlZJQ0VfRVJST1Jf
SUdOT1JFJQ0KU2VydmljZUJpbmFyeSA9ICUxMiVcM3hIeWJyaWQuc3lzICAgICAgOy8vc2hvdWxk
IGJlICUxMiVcJURSSVZFUl9OQU1FX1gzMiUsIGJ1dCB0aGVyZSBpcyBhIGJ1ZyBpbiB0aGUgSU5G
IGNoayB0b29sDQoNCg0KW1NlY3Rpb25YNjQuU2VydmljZUluc3RhbGwuTlRBTUQ2NF0NCkRpc3Bs
YXlOYW1lICAgPSAlRElTUExBWV9OQU1FJQ0KRGVzY3JpcHRpb24gICA9ICVTRVJWSUNFX0RFU0NS
SVBUSU9OX05BTUUlDQpTZXJ2aWNlVHlwZSAgID0gJVNFUlZJQ0VfS0VSTkVMX0RSSVZFUiUNClN0
YXJ0VHlwZSAgICAgPSAlU0VSVklDRV9ERU1BTkRfU1RBUlQlDQpFcnJvckNvbnRyb2wgID0gJVNF
UlZJQ0VfRVJST1JfSUdOT1JFJQ0KU2VydmljZUJpbmFyeSA9ICUxMiVcM3hIeWJyNjQuc3lzICAg
ICAgOy8vc2hvdWxkIGJlICUxMiVcJURSSVZFUl9OQU1FX1g2NCUsIGJ1dCB0aGVyZSBpcyBhIGJ1
ZyBpbiB0aGUgSU5GIGNoayB0b29sDQoNCg0KDQo7PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT0NCjsNCjsgICAgICAgICAgIFJlZ2lzdHJ5IEVudHJpZXMNCjsNCjs9PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQ0KOyBbU3RhcnROYW1lPWRyaXZlci1vYmpl
Y3QtbmFtZV0NCjsgW0FkZFJlZz1hZGQtcmVnaXN0cnktc2VjdGlvblssIGFkZC1yZWdpc3RyeS1z
ZWN0aW9uXSAuLi5dDQo7IFtEZWxSZWc9ZGVsLXJlZ2lzdHJ5LXNlY3Rpb25bLCBkZWwtcmVnaXN0
cnktc2VjdGlvbl0gLi4uXQ0KOyBbQml0UmVnPWJpdC1yZWdpc3RyeS1zZWN0aW9uWyxiaXQtcmVn
aXN0cnktc2VjdGlvbl0gLi4uXQ0KOyBbTG9hZE9yZGVyR3JvdXA9bG9hZC1vcmRlci1ncm91cC1u
YW1lXQ0KOyBbRGVwZW5kZW5jaWVzPWRlcGVuZC1vbi1pdGVtLW5hbWVbLGRlcGVuZC1vbi1pdGVt
LW5hbWVdLi4uXQ0KDQo7PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0NCjsg
ICAgIEdlbmVyYWwgRExMIFJlZ2lzdHJ5IEVudHJpZXMNCjs9PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PQ0KW1NlY3Rpb25YMzIuRGxsQWRkUmVnLk5UeDg2XQ0KSEtSLCxDb0lu
c3RhbGxlcnMzMiwweDAwMDEwMDAwLCIzNENvSW5zdGFsbGVyLmRsbCwgQ29JbnN0YWxsZXJFbnRy
eSINCg0KW1NlY3Rpb25YNjQuRGxsQWRkUmVnLk5UQU1ENjRdDQo7OzsgLy8gbm90aGluZyB0byBk
bywgZm9yIHg2NCB3ZSBkbyBub3QgdXNlIGEgY28taW5zdGFsbGVyIGRsbA0KDQpbU2VjdGlvblgz
Mi5SZWdpc3Rlci5OVHg4Nl0NCjExLCxOWFBNVjMyLmRsbCwxIDsvL0ZMR19SRUdTVlJfRExMUkVH
SVNURVINCg0KW1NlY3Rpb25YNjQuUmVnaXN0ZXIuTlRBTUQ2NF0NCjExLCxOWFBNVjY0LmRsbCwx
IDsvL0ZMR19SRUdTVlJfRExMUkVHSVNURVINCg0KDQo7PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT0NCjsgICBHZW5lcmFsIERyaXZlciBSZWdpc3RyeSBFbnRyaWVzDQo7PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0NCltTZWN0aW9uWDMyLkRlbFJlZy5O
VHg4Nl0NCjsgKioqIFNhbXBsZSBvZiBob3cgdG8gY2xlYW4gdXAgdGhlIHJlZ2lzdHJ5IGJlZm9y
ZSB3cml0aW5nIG5ldyBrZXlzDQo7ICAgICB3aGVuIHRoZSBkcml2ZXIgaXMgYmVpbmcgdXBkYXRl
ZCAqKioNCjs7O0hLTE0sU1lTVEVNXEN1cnJlbnRDb250cm9sU2V0XFNlcnZpY2VzXCVfX1NFUlZJ
Q0VfTkFNRV9fJSAgOy8vIFNhbXBsZSBsaW5lISEhIE5FVkVSIHVzZSBpdCEhIQ0KSEtSLCAiUGFy
YW1ldGVycyIgICAgICA7IEZ1bGwgcmVnaXN0cnkga2V5IHdpdGggYWxsIHN1YmtleXMvZGF0YSB3
aWxsIGJlIGRlbGV0ZWQNCkhLUiwgIkkyQyBEZXZpY2VzIiAgICAgOyBGdWxsIHJlZ2lzdHJ5IGtl
eSB3aXRoIGFsbCBzdWJrZXlzL2RhdGEgd2lsbCBiZSBkZWxldGVkDQpIS1IsICJWaWRlb0RlY29k
ZXIiICAgIDsgRnVsbCByZWdpc3RyeSBrZXkgd2l0aCBhbGwgc3Via2V5cy9kYXRhIHdpbGwgYmUg
ZGVsZXRlZA0KSEtSLCAiQXVkaW9EZWNvZGVyIiAgICA7IEZ1bGwgcmVnaXN0cnkga2V5IHdpdGgg
YWxsIHN1YmtleXMvZGF0YSB3aWxsIGJlIGRlbGV0ZWQNCg0KDQpbU2VjdGlvblgzMi5BZGRSZWcu
TlR4ODZdDQpIS1IsLERldkxvYWRlciwsKk5US0VSTg0KSEtSLCxOVE1QRHJpdmVyLCwzeEh5YnJp
ZC5zeXMNCg0KOyAtLS0gUmVnaXN0cnkgRW50cmllcyBGb3IgQXVkaW8gQ2FwdHVyZSAtLS0NCkhL
UiwsRHJpdmVyLCwzeEh5YnJpZC5zeXMNCkhLUiwsQXNzb2NpYXRlZEZpbHRlcnMsLCJ3ZG1hdWQs
c3dtaWRpLHJlZGJvb2siDQoNCkhLUixEcml2ZXJzLFN1YkNsYXNzZXMsLCJ3YXZlLG1peGVyIg0K
SEtSLERyaXZlcnNcd2F2ZVx3ZG1hdWQuZHJ2LERyaXZlciwsd2RtYXVkLmRydg0KSEtSLERyaXZl
cnNcbWl4ZXJcd2RtYXVkLmRydixEcml2ZXIsLHdkbWF1ZC5kcnYNCkhLUixEcml2ZXJzXHdhdmVc
d2RtYXVkLmRydixEZXNjcmlwdGlvbiwsJUFVRElPX0RFVklDRV9OQU1FJQ0KSEtSLERyaXZlcnNc
bWl4ZXJcd2RtYXVkLmRydixEZXNjcmlwdGlvbiwsJUFVRElPX0RFVklDRV9OQU1FJQ0KDQo7IGFk
ZCBhdWRpbyBpbnB1dCBhbmQgb3V0cHV0IHBpbm5hbWVzDQpIS0xNLFNZU1RFTVxDdXJyZW50Q29u
dHJvbFNldFxDb250cm9sXE1lZGlhQ2F0ZWdvcmllc1wlQVZTVFJFQU1fQU5MR19BVURJT19JTl9Q
SU4lLCJOYW1lIiwsIkFuYWxvZyBBdWRpb2lucHV0Ig0KSEtMTSxTWVNURU1cQ3VycmVudENvbnRy
b2xTZXRcQ29udHJvbFxNZWRpYUNhdGVnb3JpZXNcJUFWU1RSRUFNX0FOTEdfQVVESU9fT1VUX1BJ
TiUsIk5hbWUiLCwiQXVkaW8iDQpIS0xNLFNZU1RFTVxDdXJyZW50Q29udHJvbFNldFxDb250cm9s
XE1lZGlhQ2F0ZWdvcmllc1wlQVZTVFJFQU1fQU5MR19WSURFT19JVFVfUElOJSwiTmFtZSIsLCJB
bmFsb2cgSVRVIFZpZGVvIg0KSEtMTSxTWVNURU1cQ3VycmVudENvbnRyb2xTZXRcQ29udHJvbFxN
ZWRpYUNhdGVnb3JpZXNcJUFWU1RSRUFNX0FOTEdfQVVESU9fSTJTX1BJTiUsIk5hbWUiLCwiSTJT
IEF1ZGlvIg0KSEtMTSxTWVNURU1cQ3VycmVudENvbnRyb2xTZXRcQ29udHJvbFxNZWRpYUNhdGVn
b3JpZXNcJUFWU1RSRUFNX0FOTEdfQVVESU9fQ0FQX1BJTiUsIk5hbWUiLCwifkF1ZGlvIg0KSEtM
TSxTWVNURU1cQ3VycmVudENvbnRyb2xTZXRcQ29udHJvbFxNZWRpYUNhdGVnb3JpZXNcJUFWU1RS
RUFNX0FOTEdfVklERU9fQ0FQX1BJTiUsIk5hbWUiLCwifkNhcHR1cmUiDQpIS0xNLFNZU1RFTVxD
dXJyZW50Q29udHJvbFNldFxDb250cm9sXE1lZGlhQ2F0ZWdvcmllc1wlQVZTVFJFQU1fQU5MR19W
SURFT19QUkVfUElOJSwiTmFtZSIsLCJ+UHJldmlldyINCkhLTE0sU1lTVEVNXEN1cnJlbnRDb250
cm9sU2V0XENvbnRyb2xcTWVkaWFDYXRlZ29yaWVzXCVBVlNUUkVBTV9NUEVHX0FFU19QSU4lLCJO
YW1lIiwsIk1QRUcgQXVkaW8gRVMiDQpIS0xNLFNZU1RFTVxDdXJyZW50Q29udHJvbFNldFxDb250
cm9sXE1lZGlhQ2F0ZWdvcmllc1wlQVZTVFJFQU1fTVBFR19WRVNfUElOJSwiTmFtZSIsLCJNUEVH
IFZpZGVvIEVTIg0KSEtMTSxTWVNURU1cQ3VycmVudENvbnRyb2xTZXRcQ29udHJvbFxNZWRpYUNh
dGVnb3JpZXNcJUFWU1RSRUFNX01QRUdfUFNfUElOJSwiTmFtZSIsLCAiTVBFRzIgUHJvZ3JhbSIN
Cg0KDQpbU2VjdGlvblgzMi5EZWxSZWcuTlRBTUQ2NF0NCjsgKioqIFNhbXBsZSBvZiBob3cgdG8g
Y2xlYW4gdXAgdGhlIHJlZ2lzdHJ5IGJlZm9yZSB3cml0aW5nIG5ldyBrZXlzDQo7ICAgICB3aGVu
IHRoZSBkcml2ZXIgaXMgYmVpbmcgdXBkYXRlZCAqKioNCjs7O0hLTE0sU1lTVEVNXEN1cnJlbnRD
b250cm9sU2V0XFNlcnZpY2VzXCVTRVJWSUNFX05BTUVfWDMyJSAgOy8vIFNhbXBsZSBsaW5lISEh
IE5FVkVSIHVzZSBpdCEhIQ0KSEtSLCAiUGFyYW1ldGVycyIgICAgICA7IEZ1bGwgcmVnaXN0cnkg
a2V5IHdpdGggYWxsIHN1YmtleXMvZGF0YSB3aWxsIGJlIGRlbGV0ZWQNCkhLUiwgIkkyQyBEZXZp
Y2VzIiAgICAgOyBGdWxsIHJlZ2lzdHJ5IGtleSB3aXRoIGFsbCBzdWJrZXlzL2RhdGEgd2lsbCBi
ZSBkZWxldGVkDQpIS1IsICJWaWRlb0RlY29kZXIiICAgIDsgRnVsbCByZWdpc3RyeSBrZXkgd2l0
aCBhbGwgc3Via2V5cy9kYXRhIHdpbGwgYmUgZGVsZXRlZA0KSEtSLCAiQXVkaW9EZWNvZGVyIiAg
ICA7IEZ1bGwgcmVnaXN0cnkga2V5IHdpdGggYWxsIHN1YmtleXMvZGF0YSB3aWxsIGJlIGRlbGV0
ZWQNCg0KDQpbU2VjdGlvblg2NC5BZGRSZWcuTlRBTUQ2NF0NCkhLUiwsRGV2TG9hZGVyLCwqTlRL
RVJODQpIS1IsLE5UTVBEcml2ZXIsLDN4SHlicjY0LnN5cw0KDQo7IC0tLSBSZWdpc3RyeSBFbnRy
aWVzIEZvciBBdWRpbyBDYXB0dXJlIC0tLQ0KSEtSLCxEcml2ZXIsLDN4SHlicjY0LnN5cw0KSEtS
LCxBc3NvY2lhdGVkRmlsdGVycywsIndkbWF1ZCxzd21pZGkscmVkYm9vayINCg0KSEtSLERyaXZl
cnMsU3ViQ2xhc3NlcywsIndhdmUsbWl4ZXIiDQpIS1IsRHJpdmVyc1x3YXZlXHdkbWF1ZC5kcnYs
RHJpdmVyLCx3ZG1hdWQuZHJ2DQpIS1IsRHJpdmVyc1xtaXhlclx3ZG1hdWQuZHJ2LERyaXZlciws
d2RtYXVkLmRydg0KSEtSLERyaXZlcnNcd2F2ZVx3ZG1hdWQuZHJ2LERlc2NyaXB0aW9uLCwlQVVE
SU9fREVWSUNFX05BTUUlDQpIS1IsRHJpdmVyc1xtaXhlclx3ZG1hdWQuZHJ2LERlc2NyaXB0aW9u
LCwlQVVESU9fREVWSUNFX05BTUUlDQoNCjsgYWRkIGF1ZGlvIGlucHV0IGFuZCBvdXRwdXQgcGlu
bmFtZXMNCkhLTE0sU1lTVEVNXEN1cnJlbnRDb250cm9sU2V0XENvbnRyb2xcTWVkaWFDYXRlZ29y
aWVzXCVBVlNUUkVBTV9BTkxHX0FVRElPX0lOX1BJTiUsIk5hbWUiLCwiQW5hbG9nIEF1ZGlvaW5w
dXQiDQpIS0xNLFNZU1RFTVxDdXJyZW50Q29udHJvbFNldFxDb250cm9sXE1lZGlhQ2F0ZWdvcmll
c1wlQVZTVFJFQU1fQU5MR19BVURJT19PVVRfUElOJSwiTmFtZSIsLCJBdWRpbyINCkhLTE0sU1lT
VEVNXEN1cnJlbnRDb250cm9sU2V0XENvbnRyb2xcTWVkaWFDYXRlZ29yaWVzXCVBVlNUUkVBTV9B
TkxHX1ZJREVPX0lUVV9QSU4lLCJOYW1lIiwsIkFuYWxvZyBJVFUgVmlkZW8iDQpIS0xNLFNZU1RF
TVxDdXJyZW50Q29udHJvbFNldFxDb250cm9sXE1lZGlhQ2F0ZWdvcmllc1wlQVZTVFJFQU1fQU5M
R19BVURJT19JMlNfUElOJSwiTmFtZSIsLCJJMlMgQXVkaW8iDQpIS0xNLFNZU1RFTVxDdXJyZW50
Q29udHJvbFNldFxDb250cm9sXE1lZGlhQ2F0ZWdvcmllc1wlQVZTVFJFQU1fQU5MR19BVURJT19D
QVBfUElOJSwiTmFtZSIsLCJ+QXVkaW8iDQpIS0xNLFNZU1RFTVxDdXJyZW50Q29udHJvbFNldFxD
b250cm9sXE1lZGlhQ2F0ZWdvcmllc1wlQVZTVFJFQU1fQU5MR19WSURFT19DQVBfUElOJSwiTmFt
ZSIsLCJ+Q2FwdHVyZSINCkhLTE0sU1lTVEVNXEN1cnJlbnRDb250cm9sU2V0XENvbnRyb2xcTWVk
aWFDYXRlZ29yaWVzXCVBVlNUUkVBTV9BTkxHX1ZJREVPX1BSRV9QSU4lLCJOYW1lIiwsIn5QcmV2
aWV3Ig0KSEtMTSxTWVNURU1cQ3VycmVudENvbnRyb2xTZXRcQ29udHJvbFxNZWRpYUNhdGVnb3Jp
ZXNcJUFWU1RSRUFNX01QRUdfQUVTX1BJTiUsIk5hbWUiLCwiTVBFRyBBdWRpbyBFUyINCkhLTE0s
U1lTVEVNXEN1cnJlbnRDb250cm9sU2V0XENvbnRyb2xcTWVkaWFDYXRlZ29yaWVzXCVBVlNUUkVB
TV9NUEVHX1ZFU19QSU4lLCJOYW1lIiwsIk1QRUcgVmlkZW8gRVMiDQpIS0xNLFNZU1RFTVxDdXJy
ZW50Q29udHJvbFNldFxDb250cm9sXE1lZGlhQ2F0ZWdvcmllc1wlQVZTVFJFQU1fTVBFR19QU19Q
SU4lLCJOYW1lIiwsICJNUEVHMiBQcm9ncmFtIg0KDQoNCjs9PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09DQo7ICAgQm9hcmQgLSBTcGVjaWZpYyBSZWdpc3RyeSBFbnRyaWVz
DQo7PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQ0KDQo7KioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKg0KOygqKSAgICAgICBTQUE3MTMw
IFJlZmVyZW5jZSBCb2FyZHMNCjsqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqDQpbUmVmZXJlbmNlQm9hcmRTQUE3MTMwLkFkZFJlZ10NCg0KOyBQcmVmaXggd2ls
bCBiZSBkaXNwbGF5ZWQgaW4gZnJvbnQgb2YgdGhlIGRldmljZSBuYW1lIG9uIGV2ZXJ5IGZpbHRl
cg0KSEtSLCAiUGFyYW1ldGVycyIsIlByZWZpeCIsLCVDVVNUT01JWkVEX0ZJTFRFUl9QUkVGSVhf
TkFNRSUNCg0KOyBSZWR1Y2VzIHNlY29uZCBwYWlyIG9mIHZpZGVvL2F1ZGlvIGlucHV0cw0KSEtS
LCAiUGFyYW1ldGVycyIsIlNtYWxsWEJhciIsMHgwMDAxMDAwMSwweDAxDQoNCg0KOyoqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioNCjsoKikgICAgICAgU0FBNzEz
MyBSZWZlcmVuY2UgQm9hcmRzDQo7KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKg0KW1JlZmVyZW5jZUJvYXJkU0FBNzEzMy5BZGRSZWddDQoNCjsgUHJlZml4IHdp
bGwgYmUgZGlzcGxheWVkIGluIGZyb250IG9mIHRoZSBkZXZpY2UgbmFtZSBvbiBldmVyeSBmaWx0
ZXINCkhLUiwgIlBhcmFtZXRlcnMiLCJQcmVmaXgiLCwlQ1VTVE9NSVpFRF9GSUxURVJfUFJFRklY
X05BTUUlDQoNCjsgUmVkdWNlcyBzZWNvbmQgcGFpciBvZiB2aWRlby9hdWRpbyBpbnB1dHMNCkhL
UiwgIlBhcmFtZXRlcnMiLCJTbWFsbFhCYXIiLDB4MDAwMTAwMDEsMHgwMQ0KDQoNCjsqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqDQo7KCopICAgICAgIFNBQTcx
MzQgUmVmZXJlbmNlIEJvYXJkcw0KOyoqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioNCltSZWZlcmVuY2VCb2FyZFNBQTcxMzQuQWRkUmVnXQ0KDQo7IFByZWZpeCB3
aWxsIGJlIGRpc3BsYXllZCBpbiBmcm9udCBvZiB0aGUgZGV2aWNlIG5hbWUgb24gZXZlcnkgZmls
dGVyDQpIS1IsICJQYXJhbWV0ZXJzIiwiUHJlZml4IiwsJUNVU1RPTUlaRURfRklMVEVSX1BSRUZJ
WF9OQU1FJQ0KDQo7IFJlZHVjZXMgc2Vjb25kIHBhaXIgb2YgdmlkZW8vYXVkaW8gaW5wdXRzDQpI
S1IsICJQYXJhbWV0ZXJzIiwiU21hbGxYQmFyIiwweDAwMDEwMDAxLDB4MDENCg0KDQo7KioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKg0KOygqKSAgICAgICBQUk9U
RVVTIFJlZmVyZW5jZSBCb2FyZA0KOyoqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioNCltSZWZlcmVuY2VCb2FyZFBST1RFVVMuQWRkUmVnXQ0KOyBQcmVmaXggd2ls
bCBiZSBkaXNwbGF5ZWQgaW4gZnJvbnQgb2YgdGhlIGRldmljZSBuYW1lIG9uIGV2ZXJ5IGZpbHRl
cg0KSEtSLCAiUGFyYW1ldGVycyIsIlByZWZpeCIsLCVDVVNUT01JWkVEX0ZJTFRFUl9QUkVGSVhf
TkFNRSUNCg0KOyBTbWFsbFhCYXI9MDogWEJhciBpbnB1dHMgPT4gVHVuZXIsIENvbXBvc2l0ZTEs
IFMtVmlkZW8xLCBDb21wb3NpdGUyLCBTLVZpZGVvMg0KOyBTbWFsbFhCYXI9MTogWEJhciBpbnB1
dHMgPT4gVHVuZXIsIENvbXBvc2l0ZTEsIFMtVmlkZW8xDQpIS1IsICJQYXJhbWV0ZXJzIiwgIlNt
YWxsWEJhciIsMHgwMDAxMDAwMSwxDQoNCkhLUiwgIkkyQyBEZXZpY2VzIiwgIkZvcmNlIFJlZ2lz
dHJ5IFNldHRpbmdzIiwweDAwMDEwMDAxLDB4MDENCkhLUiwgIlZpZGVvRGVjb2RlciIsICJUdW5l
ciBDaGFubmVsIiwweDAwMDEwMDAxLDB4MDENCkhLUiwgIlZpZGVvRGVjb2RlciIsICJDVkJTIENo
YW5uZWwiLDB4MDAwMTAwMDEsMHgwMA0KSEtSLCAiVmlkZW9EZWNvZGVyIiwgIlNWSFMgQ2hhbm5l
bCIsMHgwMDAxMDAwMSwweDA2DQo7SEtSLCAiVmlkZW9EZWNvZGVyIiwgIkZNIFJhZGlvIENoYW5u
ZWwiLDB4MDAwMTAwMDEsMHgwMA0KDQpIS1IsICJBdWRpb0RlY29kZXIiLCAiVHVuZXIgQ2hhbm5l
bCIsMHgwMDAxMDAwMSwweDAxDQpIS1IsICJBdWRpb0RlY29kZXIiLCAiQ1ZCUyBDaGFubmVsIiww
eDAwMDEwMDAxLDB4MDINCkhLUiwgIkF1ZGlvRGVjb2RlciIsICJTVkhTIENoYW5uZWwiLDB4MDAw
MTAwMDEsMHgwMg0KO0hLUiwgIkF1ZGlvRGVjb2RlciIsICJGTSBSYWRpbyBDaGFubmVsIiwweDAw
MDEwMDAxLDB4MDINCjtIS1IsICJBdWRpb0RlY29kZXIiLCAiWFRBTCIsMHgwMDAxMDAwMSwweDAg
ICAgICAgICAgICAgICAgO0RlZmF1bHQgPSAzMk1Ieg0KDQpIS1IsICJJMkMgRGV2aWNlcyIsICJO
dW1iZXIgb2YgSTJDIERldmljZXMiLDB4MDAwMTAwMDEsMHgwMQ0KSEtSLCAiSTJDIERldmljZXMi
LCAiRGV2aWNlIDAsIERhdGExIiwweDAwMDEwMDAxLDB4MDMgIDsgVHVuZXIgSUQNCkhLUiwgIkky
QyBEZXZpY2VzIiwgIkRldmljZSAwLCBEYXRhMiIsMHgwMDAxMDAwMSwweEMwICA7IFR1bmVyIHNs
YXZlIGFkZHIuDQpIS1IsICJJMkMgRGV2aWNlcyIsICJEZXZpY2UgMCwgRGF0YTMiLDB4MDAwMTAw
MDEsMHg4NiAgOyBUdW5lciBJRiBQTEwgc2xhdmUgYWRkci4NCjtIS1IsICJJMkMgRGV2aWNlcyIs
ICJEZXZpY2UgMCwgRGF0YTQiLDB4MDAwMTAwMDEsMHgwICAgOyBEZW1vZCBzbGF2ZSBhZGRyLg0K
O0hLUiwgIkkyQyBEZXZpY2VzIiwgIkRldmljZSAwLCBEYXRhNSIsMHgwMDAxMDAwMSwweDAgICA7
IFNpemUgb2YgYWRkLiBkYXRhDQo7SEtSLCAiSTJDIERldmljZXMiLCAiRGV2aWNlIDAsIERhdGE2
IiwweDAwMDEwMDAxLDB4MCAgIDsgQWRkLiBkYXRhICMxDQo7SEtSLCAiSTJDIERldmljZXMiLCAi
RGV2aWNlIDAsIERhdGE3IiwweDAwMDEwMDAxLDB4MCAgIDsgQWRkLiBkYXRhICMyDQo7SEtSLCAi
STJDIERldmljZXMiLCAiRGV2aWNlIDAsIERhdGE4IiwweDAwMDEwMDAxLDB4MCAgIDsgQWRkLiBk
YXRhICMzDQoNCg0KOz09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09DQo7DQo7
ICAgICAgICAgICBTdHJpbmdzIERlZmluZXMNCjsNCjs9PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PQ0KDQpbU3RyaW5nc10NCjstLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tDQo7IENhcHR1cmUgRmlsdGVyIFBpbiBOYW1lIEdVSURzDQo7LS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLQ0KQVZTVFJFQU1fQU5MR19BVURJT19JTl9QSU4gICA9ICJ7N0JCMjg0Qjkt
NzE0RC00OTNkLUExMDEtQjFCMDI4RTc4MkJEfSINCkFWU1RSRUFNX0FOTEdfQVVESU9fT1VUX1BJ
TiAgPSAiezU1ODJFNjU3LUU1OTYtNDJiNS05REIzLTU0MUIyN0EyMzU1Rn0iDQpBVlNUUkVBTV9B
TkxHX1ZJREVPX0lUVV9QSU4gID0gIns4MjYzMUEyRS00MDNDLTQ1ODEtQTRCMC1FQzE3M0QwMDQ0
MTB9Ig0KQVZTVFJFQU1fQU5MR19BVURJT19JMlNfUElOICA9ICJ7QzJFNDYzNTgtRjAzMi00ZDg4
LUI4MDItMDZCNTlEMTYyNzMwfSINCkFWU1RSRUFNX0FOTEdfVklERU9fQ0FQX1BJTiAgPSAiezE2
RkZCRDBBLUY3NzAtNDY5Mi1BMkZGLUREMzk0REZFOTU2NH0iDQpBVlNUUkVBTV9BTkxHX1ZJREVP
X1BSRV9QSU4gID0gIntBMTlGNjEyMS05Q0Y3LTQwODEtODA1My0yNTY2NjhGQ0JFMUZ9Ig0KQVZT
VFJFQU1fQU5MR19BVURJT19DQVBfUElOICA9ICJ7QkE5RTI3QjEtQ0Y0NC00OTBlLThFQUItNUY2
NjJFNUZGRTc0fSINCkFWU1RSRUFNX01QRUdfQUVTX1BJTiAgICAgICAgPSAiezlERUM4NEI5LUJD
RUYtNGFhYy05OTdFLTQzRUREMEEyRDZDN30iDQpBVlNUUkVBTV9NUEVHX1ZFU19QSU4gICAgICAg
ID0gInsxODFDRjg3RS03NzQxLTQ3YmEtODYyOS0yMjM0N0UwM0M2NEN9Ig0KQVZTVFJFQU1fTVBF
R19QU19QSU4gICAgICAgICA9ICJ7RERBODdCODMtNjVEQi00YWVjLTgyRDAtNzlGQkU2N0QyQkI2
fSINCg0KDQo7LS0tLS0tLS0tLS0tLS0tLS0tLS0NCjsgU3lzdGVtIERlZmluZXMNCjstLS0tLS0t
LS0tLS0tLS0tLS0tLQ0KU0VSVklDRV9CT09UX1NUQVJUICAgICAgID0gMHgwDQpTRVJWSUNFX1NZ
U1RFTV9TVEFSVCAgICAgPSAweDENClNFUlZJQ0VfQVVUT19TVEFSVCAgICAgICA9IDB4Mg0KU0VS
VklDRV9ERU1BTkRfU1RBUlQgICAgID0gMHgzDQpTRVJWSUNFX0RJU0FCTEVEICAgICAgICAgPSAw
eDQNCg0KU0VSVklDRV9LRVJORUxfRFJJVkVSICAgID0gMHgxDQpTRVJWSUNFX0VSUk9SX0lHTk9S
RSAgICAgPSAweDANClNFUlZJQ0VfRVJST1JfTk9STUFMICAgICA9IDB4MQ0KU0VSVklDRV9FUlJP
Ul9TRVZFUkUgICAgID0gMHgyDQpTRVJWSUNFX0VSUk9SX0NSSVRJQ0FMICAgPSAweDMNCkZMR19S
RUdTVlJfRExMUkVHSVNURVIgICA9IDB4MDAwMDAwMDENCg0KDQoNCjsqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKg0KOyAgICAgICAgICAg
ICAgICAgICAgICAhISEgQVRURU5USU9OICEhIQ0KOyBDdXN0b21lciBTdHJpbmdzOg0KOyAgIFRo
ZSBmb2xsb3dpbmcgc3RyaW5ncyBNVVNUIGJlIGNoYW5nZWQsIGlmIHRoZSBkcml2ZXIgaGFzDQo7
ICAgYmVlbiBjdXN0b21pemVkLCB0byBub3QgaW50ZXJmZXJlIHdpdGggdGhlIG9yaWdpbmFsIG9u
ZS4NCjsNCjsqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioNCg0KOy0tLSBEcml2ZXIgbmFtZXMgZm9yIDMyLzY0IGJpdCBPUyAtLS0NCkRS
SVZFUl9OQU1FX1gzMiAgICAgICAgICAgICAgID0gIjN4SHlicmlkLnN5cyINCkRSSVZFUl9OQU1F
X1g2NCAgICAgICAgICAgICAgID0gIjN4SHlicjY0LnN5cyINCg0KOy0tLSBDYXRhbG9nIGZpbGUg
KHNpZ25hdHVyZSkgbmFtZXMgZm9yIDMyLzY0IGJpdCBPUyAtLS0NClNJR05BVFVSRV9OQU1FX1gz
MiAgICAgICAgICAgID0gIjN4SHlicmlkLmNhdCINClNJR05BVFVSRV9OQU1FX1g2NCAgICAgICAg
ICAgID0gIjN4SHlicjY0LmNhdCINCg0KOy0tLSBDb2luc3RhbGxlciBETEwgbmFtZSBmb3IgMzIv
NjQgYml0IE9TIC0tLQ0KQ09JTlNUQUxMRVJfTkFNRV9YMzIgICAgICAgICAgPSAiMzRDb0luc3Rh
bGxlci5kbGwiDQpDT0lOU1RBTExFUl9OQU1FX1g2NCAgICAgICAgICA9ICIzeENvSW5zdFg2NC5k
bGwiDQoNCjstLS0gU2VydmljZSBuYW1lcyBsaW5rZWQgdG8gdGhlIGRyaXZlciBiaW5hcnkgLS0t
DQpTRVJWSUNFX05BTUVfWDMyICAgICAgICAgICAgICA9ICIzeEh5YnJpZCINClNFUlZJQ0VfTkFN
RV9YNjQgICAgICAgICAgICAgID0gIjN4SHlicjY0Ig0KU0VSVklDRV9ERVNDUklQVElPTl9OQU1F
ICAgICAgPSAiUGhpbGlwcyBTQUE3MTN4IEJEQSBDYXB0dXJlIERyaXZlciINCg0KOy0tLSBOYW1l
IGRpc3BsYXllZCBpbiB0aGUgZGV2aWNlIG1hbmFnZXIgLS0tDQpESVNQTEFZX05BTUUgICAgICAg
ICAgICAgICAgICA9ICJQaGlsaXBzIFNBQTcxM3ggUENJIENhcmQiDQoNCjstLS0gR2VuZXJhbCBu
YW1lcyAtLS0NClBST1ZJREVSX05BTUUgICAgICAgICAgICAgICAgID0gIlBoaWxpcHMgU2VtaWNv
bmR1Y3RvcnMiDQpJTlNUQUxMQVRJT05fRElTS19OQU1FICAgICAgICA9ICJQaGlsaXBzIFNBQTcx
M3ggRHJpdmVyIEluc3RhbGxhdGlvbiBEaXNrIg0KDQoNCjsqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKg0KOw0KOygqKSBHZW5lcmljIFN0
cmluZ3M6DQo7ICAgICBCb2FyZCBEZXNjcmlwdGlvbiAoLT4gRGlzcGxheWVkIHdpdGhpbiBlLmcu
IEdyYXBoZWRpdCkNCjsNCjsqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKg0KDQpBVURJT19ERVZJQ0VfTkFNRSAgICAgICAgICAgICA9ICJQ
aGlsaXBzIFNBQTcxM3ggQXVkaW8gQ2FwdHVyZSBEZXZpY2UiDQpDVVNUT01JWkVEX0ZJTFRFUl9Q
UkVGSVhfTkFNRSA9ICI3MTN4Ig0KDQpSRUZFUkVOQ0VfQk9BUkRfU0FBNzEzMF9OQU1FICA9ICJQ
aGlsaXBzIFNBQTcxMzAsIEh5YnJpZCBDYXB0dXJlIERldmljZSINClJFRkVSRU5DRV9CT0FSRF9T
QUE3MTMzX05BTUUgID0gIkdJR0FCWVRFLCBQLXNlcmllcyBBbmFsb2cgVFYgQ2FyZCB2ZXIgMS40
LjAuMyINClJFRkVSRU5DRV9CT0FSRF9TQUE3MTM0X05BTUUgID0gIlBoaWxpcHMgU0FBNzEzNCwg
SHlicmlkIENhcHR1cmUgRGV2aWNlIg0K
--047d7bea43d6add95505199cfef6
Content-Type: text/x-ms-regedit; charset=UTF-16LE; name="registry.reg"
Content-Disposition: attachment; filename="registry.reg"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ibh2sgcw1

//5XAGkAbgBkAG8AdwBzACAAUgBlAGcAaQBzAHQAcgB5ACAARQBkAGkAdABvAHIAIABWAGUAcgBz
AGkAbwBuACAANQAuADAAMAANAAoADQAKAFsASABLAEUAWQBfAEwATwBDAEEATABfAE0AQQBDAEgA
SQBOAEUAXABTAFkAUwBUAEUATQBcAEMAdQByAHIAZQBuAHQAQwBvAG4AdAByAG8AbABTAGUAdABc
AEUAbgB1AG0AXABQAEMASQBcAFYARQBOAF8AMQAxADMAMQAmAEQARQBWAF8ANwAxADMAMwAmAFMA
VQBCAFMAWQBTAF8AOQAwADAANAAxADQANQA4ACYAUgBFAFYAXwBEADEAXQANAAoADQAKAFsASABL
AEUAWQBfAEwATwBDAEEATABfAE0AQQBDAEgASQBOAEUAXABTAFkAUwBUAEUATQBcAEMAdQByAHIA
ZQBuAHQAQwBvAG4AdAByAG8AbABTAGUAdABcAEUAbgB1AG0AXABQAEMASQBcAFYARQBOAF8AMQAx
ADMAMQAmAEQARQBWAF8ANwAxADMAMwAmAFMAVQBCAFMAWQBTAF8AOQAwADAANAAxADQANQA4ACYA
UgBFAFYAXwBEADEAXAA0ACYAMwA0ADAAYwBlADYAZgBlACYAMAAmADMAMABBADQAXQANAAoAIgBE
AGUAdgBpAGMAZQBEAGUAcwBjACIAPQAiAEAAbwBlAG0AMQA3AC4AaQBuAGYALAAlAHIAZQBmAGUA
cgBlAG4AYwBlAF8AYgBvAGEAcgBkAF8AcwBhAGEANwAxADMAMwBfAG4AYQBtAGUAJQA7AEcASQBH
AEEAQgBZAFQARQAsACAAUAAtAHMAZQByAGkAZQBzACAAQQBuAGEAbABvAGcAIABUAFYAIABDAGEA
cgBkACAAdgBlAHIAIAAxAC4ANAAuADAALgAzACIADQAKACIATABvAGMAYQB0AGkAbwBuAEkAbgBm
AG8AcgBtAGEAdABpAG8AbgAiAD0AIgBAAFMAeQBzAHQAZQBtADMAMgBcAFwAZAByAGkAdgBlAHIA
cwBcAFwAcABjAGkALgBzAHkAcwAsACMANgA1ADUAMwA2ADsAUABDAEkAIABiAHUAcwAgACUAMQAs
ACAAZABlAHYAaQBjAGUAIAAlADIALAAgAGYAdQBuAGMAdABpAG8AbgAgACUAMwA7ACgAOQAsADYA
LAAwACkAIgANAAoAIgBDAGEAcABhAGIAaQBsAGkAdABpAGUAcwAiAD0AZAB3AG8AcgBkADoAMAAw
ADAAMAAwADAAMAAwAA0ACgAiAEMAbwBuAHQAYQBpAG4AZQByAEkARAAiAD0AIgB7ADAAMAAwADAA
MAAwADAAMAAtADAAMAAwADAALQAwADAAMAAwAC0AZgBmAGYAZgAtAGYAZgBmAGYAZgBmAGYAZgBm
AGYAZgBmAH0AIgANAAoAIgBIAGEAcgBkAHcAYQByAGUASQBEACIAPQBoAGUAeAAoADcAKQA6ADUA
MAAsADAAMAAsADQAMwAsADAAMAAsADQAOQAsADAAMAAsADUAYwAsADAAMAAsADUANgAsADAAMAAs
ADQANQAsADAAMAAsADQAZQAsADAAMAAsADUAZgAsADAAMAAsADMAMQAsADAAMAAsADMAMQAsAFwA
DQAKACAAIAAwADAALAAzADMALAAwADAALAAzADEALAAwADAALAAyADYALAAwADAALAA0ADQALAAw
ADAALAA0ADUALAAwADAALAA1ADYALAAwADAALAA1AGYALAAwADAALAAzADcALAAwADAALAAzADEA
LAAwADAALAAzADMALAAwADAALAAzADMALAAwADAALAAyADYALAAwADAALABcAA0ACgAgACAANQAz
ACwAMAAwACwANQA1ACwAMAAwACwANAAyACwAMAAwACwANQAzACwAMAAwACwANQA5ACwAMAAwACwA
NQAzACwAMAAwACwANQBmACwAMAAwACwAMwA5ACwAMAAwACwAMwAwACwAMAAwACwAMwAwACwAMAAw
ACwAMwA0ACwAMAAwACwAMwAxACwAMAAwACwAMwA0ACwAXAANAAoAIAAgADAAMAAsADMANQAsADAA
MAAsADMAOAAsADAAMAAsADIANgAsADAAMAAsADUAMgAsADAAMAAsADQANQAsADAAMAAsADUANgAs
ADAAMAAsADUAZgAsADAAMAAsADQANAAsADAAMAAsADMAMQAsADAAMAAsADAAMAAsADAAMAAsADUA
MAAsADAAMAAsADQAMwAsADAAMAAsAFwADQAKACAAIAA0ADkALAAwADAALAA1AGMALAAwADAALAA1
ADYALAAwADAALAA0ADUALAAwADAALAA0AGUALAAwADAALAA1AGYALAAwADAALAAzADEALAAwADAA
LAAzADEALAAwADAALAAzADMALAAwADAALAAzADEALAAwADAALAAyADYALAAwADAALAA0ADQALAAw
ADAALAA0ADUALABcAA0ACgAgACAAMAAwACwANQA2ACwAMAAwACwANQBmACwAMAAwACwAMwA3ACwA
MAAwACwAMwAxACwAMAAwACwAMwAzACwAMAAwACwAMwAzACwAMAAwACwAMgA2ACwAMAAwACwANQAz
ACwAMAAwACwANQA1ACwAMAAwACwANAAyACwAMAAwACwANQAzACwAMAAwACwANQA5ACwAMAAwACwA
XAANAAoAIAAgADUAMwAsADAAMAAsADUAZgAsADAAMAAsADMAOQAsADAAMAAsADMAMAAsADAAMAAs
ADMAMAAsADAAMAAsADMANAAsADAAMAAsADMAMQAsADAAMAAsADMANAAsADAAMAAsADMANQAsADAA
MAAsADMAOAAsADAAMAAsADAAMAAsADAAMAAsADUAMAAsADAAMAAsADQAMwAsAFwADQAKACAAIAAw
ADAALAA0ADkALAAwADAALAA1AGMALAAwADAALAA1ADYALAAwADAALAA0ADUALAAwADAALAA0AGUA
LAAwADAALAA1AGYALAAwADAALAAzADEALAAwADAALAAzADEALAAwADAALAAzADMALAAwADAALAAz
ADEALAAwADAALAAyADYALAAwADAALAA0ADQALAAwADAALABcAA0ACgAgACAANAA1ACwAMAAwACwA
NQA2ACwAMAAwACwANQBmACwAMAAwACwAMwA3ACwAMAAwACwAMwAxACwAMAAwACwAMwAzACwAMAAw
ACwAMwAzACwAMAAwACwAMgA2ACwAMAAwACwANAAzACwAMAAwACwANAAzACwAMAAwACwANQBmACwA
MAAwACwAMwAwACwAMAAwACwAMwA0ACwAXAANAAoAIAAgADAAMAAsADMAOAAsADAAMAAsADMAMAAs
ADAAMAAsADMAMAAsADAAMAAsADMAMAAsADAAMAAsADAAMAAsADAAMAAsADUAMAAsADAAMAAsADQA
MwAsADAAMAAsADQAOQAsADAAMAAsADUAYwAsADAAMAAsADUANgAsADAAMAAsADQANQAsADAAMAAs
ADQAZQAsADAAMAAsAFwADQAKACAAIAA1AGYALAAwADAALAAzADEALAAwADAALAAzADEALAAwADAA
LAAzADMALAAwADAALAAzADEALAAwADAALAAyADYALAAwADAALAA0ADQALAAwADAALAA0ADUALAAw
ADAALAA1ADYALAAwADAALAA1AGYALAAwADAALAAzADcALAAwADAALAAzADEALAAwADAALAAzADMA
LABcAA0ACgAgACAAMAAwACwAMwAzACwAMAAwACwAMgA2ACwAMAAwACwANAAzACwAMAAwACwANAAz
ACwAMAAwACwANQBmACwAMAAwACwAMwAwACwAMAAwACwAMwA0ACwAMAAwACwAMwA4ACwAMAAwACwA
MwAwACwAMAAwACwAMAAwACwAMAAwACwAMAAwACwAMAAwAA0ACgAiAEMAbwBtAHAAYQB0AGkAYgBs
AGUASQBEAHMAIgA9AGgAZQB4ACgANwApADoANQAwACwAMAAwACwANAAzACwAMAAwACwANAA5ACwA
MAAwACwANQBjACwAMAAwACwANQA2ACwAMAAwACwANAA1ACwAMAAwACwANABlACwAMAAwACwANQBm
ACwAMAAwACwAMwAxACwAMAAwACwAXAANAAoAIAAgADMAMQAsADAAMAAsADMAMwAsADAAMAAsADMA
MQAsADAAMAAsADIANgAsADAAMAAsADQANAAsADAAMAAsADQANQAsADAAMAAsADUANgAsADAAMAAs
ADUAZgAsADAAMAAsADMANwAsADAAMAAsADMAMQAsADAAMAAsADMAMwAsADAAMAAsADMAMwAsADAA
MAAsADIANgAsAFwADQAKACAAIAAwADAALAA1ADIALAAwADAALAA0ADUALAAwADAALAA1ADYALAAw
ADAALAA1AGYALAAwADAALAA0ADQALAAwADAALAAzADEALAAwADAALAAwADAALAAwADAALAA1ADAA
LAAwADAALAA0ADMALAAwADAALAA0ADkALAAwADAALAA1AGMALAAwADAALAA1ADYALAAwADAALABc
AA0ACgAgACAANAA1ACwAMAAwACwANABlACwAMAAwACwANQBmACwAMAAwACwAMwAxACwAMAAwACwA
MwAxACwAMAAwACwAMwAzACwAMAAwACwAMwAxACwAMAAwACwAMgA2ACwAMAAwACwANAA0ACwAMAAw
ACwANAA1ACwAMAAwACwANQA2ACwAMAAwACwANQBmACwAMAAwACwAMwA3ACwAXAANAAoAIAAgADAA
MAAsADMAMQAsADAAMAAsADMAMwAsADAAMAAsADMAMwAsADAAMAAsADAAMAAsADAAMAAsADUAMAAs
ADAAMAAsADQAMwAsADAAMAAsADQAOQAsADAAMAAsADUAYwAsADAAMAAsADUANgAsADAAMAAsADQA
NQAsADAAMAAsADQAZQAsADAAMAAsADUAZgAsADAAMAAsAFwADQAKACAAIAAzADEALAAwADAALAAz
ADEALAAwADAALAAzADMALAAwADAALAAzADEALAAwADAALAAyADYALAAwADAALAA0ADMALAAwADAA
LAA0ADMALAAwADAALAA1AGYALAAwADAALAAzADAALAAwADAALAAzADQALAAwADAALAAzADgALAAw
ADAALAAzADAALAAwADAALAAzADAALABcAA0ACgAgACAAMAAwACwAMwAwACwAMAAwACwAMAAwACwA
MAAwACwANQAwACwAMAAwACwANAAzACwAMAAwACwANAA5ACwAMAAwACwANQBjACwAMAAwACwANQA2
ACwAMAAwACwANAA1ACwAMAAwACwANABlACwAMAAwACwANQBmACwAMAAwACwAMwAxACwAMAAwACwA
MwAxACwAMAAwACwAXAANAAoAIAAgADMAMwAsADAAMAAsADMAMQAsADAAMAAsADIANgAsADAAMAAs
ADQAMwAsADAAMAAsADQAMwAsADAAMAAsADUAZgAsADAAMAAsADMAMAAsADAAMAAsADMANAAsADAA
MAAsADMAOAAsADAAMAAsADMAMAAsADAAMAAsADAAMAAsADAAMAAsADUAMAAsADAAMAAsADQAMwAs
AFwADQAKACAAIAAwADAALAA0ADkALAAwADAALAA1AGMALAAwADAALAA1ADYALAAwADAALAA0ADUA
LAAwADAALAA0AGUALAAwADAALAA1AGYALAAwADAALAAzADEALAAwADAALAAzADEALAAwADAALAAz
ADMALAAwADAALAAzADEALAAwADAALAAwADAALAAwADAALAA1ADAALAAwADAALABcAA0ACgAgACAA
NAAzACwAMAAwACwANAA5ACwAMAAwACwANQBjACwAMAAwACwANAAzACwAMAAwACwANAAzACwAMAAw
ACwANQBmACwAMAAwACwAMwAwACwAMAAwACwAMwA0ACwAMAAwACwAMwA4ACwAMAAwACwAMwAwACwA
MAAwACwAMwAwACwAMAAwACwAMwAwACwAMAAwACwAMAAwACwAXAANAAoAIAAgADAAMAAsADUAMAAs
ADAAMAAsADQAMwAsADAAMAAsADQAOQAsADAAMAAsADUAYwAsADAAMAAsADQAMwAsADAAMAAsADQA
MwAsADAAMAAsADUAZgAsADAAMAAsADMAMAAsADAAMAAsADMANAAsADAAMAAsADMAOAAsADAAMAAs
ADMAMAAsADAAMAAsADAAMAAsADAAMAAsAFwADQAKACAAIAAwADAALAAwADAADQAKACIAQwBvAG4A
ZgBpAGcARgBsAGEAZwBzACIAPQBkAHcAbwByAGQAOgAwADAAMAAwADAAMAAwADAADQAKACIAQwBs
AGEAcwBzAEcAVQBJAEQAIgA9ACIAewA0AGQAMwA2AGUAOQA2AGMALQBlADMAMgA1AC0AMQAxAGMA
ZQAtAGIAZgBjADEALQAwADgAMAAwADIAYgBlADEAMAAzADEAOAB9ACIADQAKACIARAByAGkAdgBl
AHIAIgA9ACIAewA0AGQAMwA2AGUAOQA2AGMALQBlADMAMgA1AC0AMQAxAGMAZQAtAGIAZgBjADEA
LQAwADgAMAAwADIAYgBlADEAMAAzADEAOAB9AFwAXAAwADAAMAA5ACIADQAKACIATQBmAGcAIgA9
ACIAQABvAGUAbQAxADcALgBpAG4AZgAsACUAcAByAG8AdgBpAGQAZQByAF8AbgBhAG0AZQAlADsA
UABoAGkAbABpAHAAcwAgAFMAZQBtAGkAYwBvAG4AZAB1AGMAdABvAHIAcwAiAA0ACgAiAFMAZQBy
AHYAaQBjAGUAIgA9ACIAMwB4AEgAeQBiAHIANgA0ACIADQAKAA0ACgBbAEgASwBFAFkAXwBMAE8A
QwBBAEwAXwBNAEEAQwBIAEkATgBFAFwAUwBZAFMAVABFAE0AXABDAHUAcgByAGUAbgB0AEMAbwBu
AHQAcgBvAGwAUwBlAHQAXABFAG4AdQBtAFwAUABDAEkAXABWAEUATgBfADEAMQAzADEAJgBEAEUA
VgBfADcAMQAzADMAJgBTAFUAQgBTAFkAUwBfADkAMAAwADQAMQA0ADUAOAAmAFIARQBWAF8ARAAx
AFwANAAmADMANAAwAGMAZQA2AGYAZQAmADAAJgAzADAAQQA0AFwARABlAHYAaQBjAGUAIABQAGEA
cgBhAG0AZQB0AGUAcgBzAF0ADQAKAA0ACgBbAEgASwBFAFkAXwBMAE8AQwBBAEwAXwBNAEEAQwBI
AEkATgBFAFwAUwBZAFMAVABFAE0AXABDAHUAcgByAGUAbgB0AEMAbwBuAHQAcgBvAGwAUwBlAHQA
XABFAG4AdQBtAFwAUABDAEkAXABWAEUATgBfADEAMQAzADEAJgBEAEUAVgBfADcAMQAzADMAJgBT
AFUAQgBTAFkAUwBfADkAMAAwADQAMQA0ADUAOAAmAFIARQBWAF8ARAAxAFwANAAmADMANAAwAGMA
ZQA2AGYAZQAmADAAJgAzADAAQQA0AFwARABlAHYAaQBjAGUAIABQAGEAcgBhAG0AZQB0AGUAcgBz
AFwASQBuAHQAZQByAHIAdQBwAHQAIABNAGEAbgBhAGcAZQBtAGUAbgB0AF0ADQAKAA0ACgBbAEgA
SwBFAFkAXwBMAE8AQwBBAEwAXwBNAEEAQwBIAEkATgBFAFwAUwBZAFMAVABFAE0AXABDAHUAcgBy
AGUAbgB0AEMAbwBuAHQAcgBvAGwAUwBlAHQAXABFAG4AdQBtAFwAUABDAEkAXABWAEUATgBfADEA
MQAzADEAJgBEAEUAVgBfADcAMQAzADMAJgBTAFUAQgBTAFkAUwBfADkAMAAwADQAMQA0ADUAOAAm
AFIARQBWAF8ARAAxAFwANAAmADMANAAwAGMAZQA2AGYAZQAmADAAJgAzADAAQQA0AFwARABlAHYA
aQBjAGUAIABQAGEAcgBhAG0AZQB0AGUAcgBzAFwASQBuAHQAZQByAHIAdQBwAHQAIABNAGEAbgBh
AGcAZQBtAGUAbgB0AFwAQQBmAGYAaQBuAGkAdAB5ACAAUABvAGwAaQBjAHkAXQANAAoADQAKAFsA
SABLAEUAWQBfAEwATwBDAEEATABfAE0AQQBDAEgASQBOAEUAXABTAFkAUwBUAEUATQBcAEMAdQBy
AHIAZQBuAHQAQwBvAG4AdAByAG8AbABTAGUAdABcAEUAbgB1AG0AXABQAEMASQBcAFYARQBOAF8A
MQAxADMAMQAmAEQARQBWAF8ANwAxADMAMwAmAFMAVQBCAFMAWQBTAF8AOQAwADAANAAxADQANQA4
ACYAUgBFAFYAXwBEADEAXAA0ACYAMwA0ADAAYwBlADYAZgBlACYAMAAmADMAMABBADQAXABEAGUA
dgBpAGMAZQAgAFAAYQByAGEAbQBlAHQAZQByAHMAXABJAG4AdABlAHIAcgB1AHAAdAAgAE0AYQBu
AGEAZwBlAG0AZQBuAHQAXABBAGYAZgBpAG4AaQB0AHkAIABQAG8AbABpAGMAeQAgAC0AIABUAGUA
bQBwAG8AcgBhAGwAXQANAAoAIgBUAGEAcgBnAGUAdABHAHIAbwB1AHAAIgA9AGQAdwBvAHIAZAA6
ADAAMAAwADAAMAAwADAAMAANAAoAIgBUAGEAcgBnAGUAdABTAGUAdAAiAD0AaABlAHgAKABiACkA
OgAzAGYALAAwADAALAAwADAALAAwADAALAAwADAALAAwADAALAAwADAALAAwADAADQAKAA0ACgBb
AEgASwBFAFkAXwBMAE8AQwBBAEwAXwBNAEEAQwBIAEkATgBFAFwAUwBZAFMAVABFAE0AXABDAHUA
cgByAGUAbgB0AEMAbwBuAHQAcgBvAGwAUwBlAHQAXABFAG4AdQBtAFwAUABDAEkAXABWAEUATgBf
ADEAMQAzADEAJgBEAEUAVgBfADcAMQAzADMAJgBTAFUAQgBTAFkAUwBfADkAMAAwADQAMQA0ADUA
OAAmAFIARQBWAF8ARAAxAFwANAAmADMANAAwAGMAZQA2AGYAZQAmADAAJgAzADAAQQA0AFwARABl
AHYAaQBjAGUAIABQAGEAcgBhAG0AZQB0AGUAcgBzAFwASQBuAHQAZQByAHIAdQBwAHQAIABNAGEA
bgBhAGcAZQBtAGUAbgB0AFwAUgBvAHUAdABpAG4AZwAgAEkAbgBmAG8AXQANAAoAIgBGAGwAYQBn
AHMAIgA9AGgAZQB4ACgANAApADoAMAAyAA0ACgAiAFMAdABhAHQAaQBjAFYAZQBjAHQAbwByACIA
PQBkAHcAbwByAGQAOgAwADAAMAAwADAAMAAxADQADQAKAA0ACgBbAEgASwBFAFkAXwBMAE8AQwBB
AEwAXwBNAEEAQwBIAEkATgBFAFwAUwBZAFMAVABFAE0AXABDAHUAcgByAGUAbgB0AEMAbwBuAHQA
cgBvAGwAUwBlAHQAXABFAG4AdQBtAFwAUABDAEkAXABWAEUATgBfADEAMQAzADEAJgBEAEUAVgBf
ADcAMQAzADMAJgBTAFUAQgBTAFkAUwBfADkAMAAwADQAMQA0ADUAOAAmAFIARQBWAF8ARAAxAFwA
NAAmADMANAAwAGMAZQA2AGYAZQAmADAAJgAzADAAQQA0AFwATABvAGcAQwBvAG4AZgBdAA0ACgAi
AEIAYQBzAGkAYwBDAG8AbgBmAGkAZwBWAGUAYwB0AG8AcgAiAD0AaABlAHgAKABhACkAOgBhADgA
LAAwADAALAAwADAALAAwADAALAAwADUALAAwADAALAAwADAALAAwADAALAAwADkALAAwADAALAAw
ADAALAAwADAALAAwADYALAAwADAALAAwADAALAAwADAALAAwADAALABcAA0ACgAgACAAMAAwACwA
MAAwACwAMAAwACwAMAAwACwAMAAwACwAMAAwACwAMAAwACwAMAAwACwAMAAwACwAMAAwACwAMAAw
ACwAMAAxACwAMAAwACwAMAAwACwAMAAwACwAMAAxACwAMAAwACwAMAAxACwAMAAwACwAMAA0ACwA
MAAwACwAMAAwACwAMAAwACwAMAAxACwAMAAzACwAXAANAAoAIAAgADAAMQAsADAAMAAsADgAMAAs
ADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAAOAAsADAAMAAsADAAMAAsADAAMQAsADAAMAAsADAA
MAAsADAAMAAsADAAMAAsAGYAMAAsAGQAZgAsAGYAZAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAs
AGYAZgAsAGYANwAsAGQAZgAsAFwADQAKACAAIABmAGQALAAwADAALAAwADAALAAwADAALAAwADAA
LAAwADgALAAwADMALAAwADEALAAwADAALAA4ADAALAAwADAALAAwADAALAAwADAALAAwADAALAAw
ADgALAAwADAALAAwADAALAAwADAALAAwADgALAAwADAALAAwADAALAAwADAALAAwADAALAAwADAA
LAAwADAALABcAA0ACgAgACAAMAAwACwAMAAwACwAMAAwACwAMAAwACwAZgBmACwAZgBmACwAZgBm
ACwAZgBmACwAMAAwACwAMAAwACwAMAAwACwAMAAwACwAMAAwACwAOAAxACwAMAAxACwAMAAwACwA
MAAwACwAMAAwACwAMAAwACwAMAAwACwAMAAxACwAMAAwACwAMAAwACwAMAAwACwAMAAwACwAXAAN
AAoAIAAgADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAA
MAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAs
ADAAMAAsADAAMAAsADAAMgAsADAAMwAsADAAMAAsADAAMAAsADAAMAAsAFwADQAKACAAIAAwADAA
LAAwADAALAAwADAALAAwADAALAAwADAALAAwADAALABmAGYALABmAGYALABmAGYALABmAGYALAAw
ADAALAAwADAALAAwADAALAAwADAALAAwADAALAAwADAALAAwADAALAAwADAALAAwADAALAAwADAA
LAAwADAALAAwADAALAAwADAALAAwADAALAAwADAALABcAA0ACgAgACAAMAAwAA0ACgAiAEIAbwBv
AHQAQwBvAG4AZgBpAGcAIgA9AGgAZQB4ACgAOAApADoAMAAxACwAMAAwACwAMAAwACwAMAAwACwA
MAA1ACwAMAAwACwAMAAwACwAMAAwACwAMAA5ACwAMAAwACwAMAAwACwAMAAwACwAMAAxACwAMAAw
ACwAMAAxACwAMAAwACwAMAAyACwAMAAwACwAMAAwACwAXAANAAoAIAAgADAAMAAsADAAMwAsADAA
MQAsADgAMAAsADAAMAAsADAAMAAsAGYAMAAsAGQAZgAsAGYAZAAsADAAMAAsADAAMAAsADAAMAAs
ADAAMAAsADAAMAAsADAAOAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAA
MgAsADAAMwAsADAAMAAsADAAMAAsAFwADQAKACAAIAAwADMALAAwADAALAAwADAALAAwADAALAAw
ADMALAAwADAALAAwADAALAAwADAALABmAGYALABmAGYALABmAGYALABmAGYALAAwADAALAAwADAA
LAAwADAALAAwADAADQAKAA0ACgBbAEgASwBFAFkAXwBMAE8AQwBBAEwAXwBNAEEAQwBIAEkATgBF
AFwAUwBZAFMAVABFAE0AXABDAHUAcgByAGUAbgB0AEMAbwBuAHQAcgBvAGwAUwBlAHQAXABFAG4A
dQBtAFwAUABDAEkAXABWAEUATgBfADEAMQAzADEAJgBEAEUAVgBfADcAMQAzADMAJgBTAFUAQgBT
AFkAUwBfADkAMAAwADQAMQA0ADUAOAAmAFIARQBWAF8ARAAxAFwANAAmADMANAAwAGMAZQA2AGYA
ZQAmADAAJgAzADAAQQA0AFwAUAByAG8AcABlAHIAdABpAGUAcwBdAA0ACgANAAoAWwBIAEsARQBZ
AF8ATABPAEMAQQBMAF8ATQBBAEMASABJAE4ARQBcAFMAWQBTAFQARQBNAFwAQwB1AHIAcgBlAG4A
dABDAG8AbgB0AHIAbwBsAFMAZQB0AFwARQBuAHUAbQBcAFAAQwBJAFwAVgBFAE4AXwAxADEAMwAx
ACYARABFAFYAXwA3ADEAMwAzACYAUwBVAEIAUwBZAFMAXwA5ADAAMAA0ADEANAA1ADgAJgBSAEUA
VgBfAEQAMQBcADQAJgAzADQAMABjAGUANgBmAGUAJgAwACYAMwAwAEEANABcAFAAcgBvAHAAZQBy
AHQAaQBlAHMAXAB7ADMANAA2ADQAZgA3AGEANAAtADIANAA0ADQALQA0ADAAYgAxAC0AOQA4ADAA
YQAtAGUAMAA5ADAAMwBjAGIANgBkADkAMQAyAH0AXQANAAoADQAKAFsASABLAEUAWQBfAEwATwBD
AEEATABfAE0AQQBDAEgASQBOAEUAXABTAFkAUwBUAEUATQBcAEMAdQByAHIAZQBuAHQAQwBvAG4A
dAByAG8AbABTAGUAdABcAEUAbgB1AG0AXABQAEMASQBcAFYARQBOAF8AMQAxADMAMQAmAEQARQBW
AF8ANwAxADMAMwAmAFMAVQBCAFMAWQBTAF8AOQAwADAANAAxADQANQA4ACYAUgBFAFYAXwBEADEA
XAA0ACYAMwA0ADAAYwBlADYAZgBlACYAMAAmADMAMABBADQAXABQAHIAbwBwAGUAcgB0AGkAZQBz
AFwAewAzADQANgA0AGYANwBhADQALQAyADQANAA0AC0ANAAwAGIAMQAtADkAOAAwAGEALQBlADAA
OQAwADMAYwBiADYAZAA5ADEAMgB9AFwAMAAwADAAQQBdAA0ACgBAAD0AaABlAHgAKABmAGYAZgBm
ADAAMAAwADcAKQA6ADAAMwAsADAAMAAsADAAMAAsADAAMAANAAoADQAKAFsASABLAEUAWQBfAEwA
TwBDAEEATABfAE0AQQBDAEgASQBOAEUAXABTAFkAUwBUAEUATQBcAEMAdQByAHIAZQBuAHQAQwBv
AG4AdAByAG8AbABTAGUAdABcAEUAbgB1AG0AXABQAEMASQBcAFYARQBOAF8AMQAxADMAMQAmAEQA
RQBWAF8ANwAxADMAMwAmAFMAVQBCAFMAWQBTAF8AOQAwADAANAAxADQANQA4ACYAUgBFAFYAXwBE
ADEAXAA0ACYAMwA0ADAAYwBlADYAZgBlACYAMAAmADMAMABBADQAXABQAHIAbwBwAGUAcgB0AGkA
ZQBzAFwAewAzAGEAYgAyADIAZQAzADEALQA4ADIANgA0AC0ANABiADQAZQAtADkAYQBmADUALQBh
ADgAZAAyAGQAOABlADMAMwBlADYAMgB9AF0ADQAKAA0ACgBbAEgASwBFAFkAXwBMAE8AQwBBAEwA
XwBNAEEAQwBIAEkATgBFAFwAUwBZAFMAVABFAE0AXABDAHUAcgByAGUAbgB0AEMAbwBuAHQAcgBv
AGwAUwBlAHQAXABFAG4AdQBtAFwAUABDAEkAXABWAEUATgBfADEAMQAzADEAJgBEAEUAVgBfADcA
MQAzADMAJgBTAFUAQgBTAFkAUwBfADkAMAAwADQAMQA0ADUAOAAmAFIARQBWAF8ARAAxAFwANAAm
ADMANAAwAGMAZQA2AGYAZQAmADAAJgAzADAAQQA0AFwAUAByAG8AcABlAHIAdABpAGUAcwBcAHsA
MwBhAGIAMgAyAGUAMwAxAC0AOAAyADYANAAtADQAYgA0AGUALQA5AGEAZgA1AC0AYQA4AGQAMgBk
ADgAZQAzADMAZQA2ADIAfQBcADAAMAAwADEAXQANAAoAQAA9AGgAZQB4ACgAZgBmAGYAZgAwADAA
MAA3ACkAOgAwADAALAAwADAALAAwADAALAAwADAADQAKAA0ACgBbAEgASwBFAFkAXwBMAE8AQwBB
AEwAXwBNAEEAQwBIAEkATgBFAFwAUwBZAFMAVABFAE0AXABDAHUAcgByAGUAbgB0AEMAbwBuAHQA
cgBvAGwAUwBlAHQAXABFAG4AdQBtAFwAUABDAEkAXABWAEUATgBfADEAMQAzADEAJgBEAEUAVgBf
ADcAMQAzADMAJgBTAFUAQgBTAFkAUwBfADkAMAAwADQAMQA0ADUAOAAmAFIARQBWAF8ARAAxAFwA
NAAmADMANAAwAGMAZQA2AGYAZQAmADAAJgAzADAAQQA0AFwAUAByAG8AcABlAHIAdABpAGUAcwBc
AHsAMwBhAGIAMgAyAGUAMwAxAC0AOAAyADYANAAtADQAYgA0AGUALQA5AGEAZgA1AC0AYQA4AGQA
MgBkADgAZQAzADMAZQA2ADIAfQBcADAAMAAwADIAXQANAAoAQAA9AGgAZQB4ACgAZgBmAGYAZgAw
ADAAMAA3ACkAOgAwADAALAAwADAALAAwADAALAAwADAADQAKAA0ACgBbAEgASwBFAFkAXwBMAE8A
QwBBAEwAXwBNAEEAQwBIAEkATgBFAFwAUwBZAFMAVABFAE0AXABDAHUAcgByAGUAbgB0AEMAbwBu
AHQAcgBvAGwAUwBlAHQAXABFAG4AdQBtAFwAUABDAEkAXABWAEUATgBfADEAMQAzADEAJgBEAEUA
VgBfADcAMQAzADMAJgBTAFUAQgBTAFkAUwBfADkAMAAwADQAMQA0ADUAOAAmAFIARQBWAF8ARAAx
AFwANAAmADMANAAwAGMAZQA2AGYAZQAmADAAJgAzADAAQQA0AFwAUAByAG8AcABlAHIAdABpAGUA
cwBcAHsAMwBhAGIAMgAyAGUAMwAxAC0AOAAyADYANAAtADQAYgA0AGUALQA5AGEAZgA1AC0AYQA4
AGQAMgBkADgAZQAzADMAZQA2ADIAfQBcADAAMAAwADMAXQANAAoAQAA9AGgAZQB4ACgAZgBmAGYA
ZgAwADAAMAA3ACkAOgAwADQALAAwADAALAAwADAALAAwADAADQAKAA0ACgBbAEgASwBFAFkAXwBM
AE8AQwBBAEwAXwBNAEEAQwBIAEkATgBFAFwAUwBZAFMAVABFAE0AXABDAHUAcgByAGUAbgB0AEMA
bwBuAHQAcgBvAGwAUwBlAHQAXABFAG4AdQBtAFwAUABDAEkAXABWAEUATgBfADEAMQAzADEAJgBE
AEUAVgBfADcAMQAzADMAJgBTAFUAQgBTAFkAUwBfADkAMAAwADQAMQA0ADUAOAAmAFIARQBWAF8A
RAAxAFwANAAmADMANAAwAGMAZQA2AGYAZQAmADAAJgAzADAAQQA0AFwAUAByAG8AcABlAHIAdABp
AGUAcwBcAHsAMwBhAGIAMgAyAGUAMwAxAC0AOAAyADYANAAtADQAYgA0AGUALQA5AGEAZgA1AC0A
YQA4AGQAMgBkADgAZQAzADMAZQA2ADIAfQBcADAAMAAwADQAXQANAAoAQAA9AGgAZQB4ACgAZgBm
AGYAZgAwADAAMAA3ACkAOgA4ADAALAAwADAALAAwADAALAAwADAADQAKAA0ACgBbAEgASwBFAFkA
XwBMAE8AQwBBAEwAXwBNAEEAQwBIAEkATgBFAFwAUwBZAFMAVABFAE0AXABDAHUAcgByAGUAbgB0
AEMAbwBuAHQAcgBvAGwAUwBlAHQAXABFAG4AdQBtAFwAUABDAEkAXABWAEUATgBfADEAMQAzADEA
JgBEAEUAVgBfADcAMQAzADMAJgBTAFUAQgBTAFkAUwBfADkAMAAwADQAMQA0ADUAOAAmAFIARQBW
AF8ARAAxAFwANAAmADMANAAwAGMAZQA2AGYAZQAmADAAJgAzADAAQQA0AFwAUAByAG8AcABlAHIA
dABpAGUAcwBcAHsAMwBhAGIAMgAyAGUAMwAxAC0AOAAyADYANAAtADQAYgA0AGUALQA5AGEAZgA1
AC0AYQA4AGQAMgBkADgAZQAzADMAZQA2ADIAfQBcADAAMAAwADUAXQANAAoAQAA9AGgAZQB4ACgA
ZgBmAGYAZgAwADAAMAA3ACkAOgAwADAALAAwADAALAAwADAALAAwADAADQAKAA0ACgBbAEgASwBF
AFkAXwBMAE8AQwBBAEwAXwBNAEEAQwBIAEkATgBFAFwAUwBZAFMAVABFAE0AXABDAHUAcgByAGUA
bgB0AEMAbwBuAHQAcgBvAGwAUwBlAHQAXABFAG4AdQBtAFwAUABDAEkAXABWAEUATgBfADEAMQAz
ADEAJgBEAEUAVgBfADcAMQAzADMAJgBTAFUAQgBTAFkAUwBfADkAMAAwADQAMQA0ADUAOAAmAFIA
RQBWAF8ARAAxAFwANAAmADMANAAwAGMAZQA2AGYAZQAmADAAJgAzADAAQQA0AFwAUAByAG8AcABl
AHIAdABpAGUAcwBcAHsAMwBhAGIAMgAyAGUAMwAxAC0AOAAyADYANAAtADQAYgA0AGUALQA5AGEA
ZgA1AC0AYQA4AGQAMgBkADgAZQAzADMAZQA2ADIAfQBcADAAMAAwAEUAXQANAAoAQAA9AGgAZQB4
ACgAZgBmAGYAZgAwADAAMAA3ACkAOgAwADEALAAwADAALAAwADAALAAwADAADQAKAA0ACgBbAEgA
SwBFAFkAXwBMAE8AQwBBAEwAXwBNAEEAQwBIAEkATgBFAFwAUwBZAFMAVABFAE0AXABDAHUAcgBy
AGUAbgB0AEMAbwBuAHQAcgBvAGwAUwBlAHQAXABFAG4AdQBtAFwAUABDAEkAXABWAEUATgBfADEA
MQAzADEAJgBEAEUAVgBfADcAMQAzADMAJgBTAFUAQgBTAFkAUwBfADkAMAAwADQAMQA0ADUAOAAm
AFIARQBWAF8ARAAxAFwANAAmADMANAAwAGMAZQA2AGYAZQAmADAAJgAzADAAQQA0AFwAUAByAG8A
cABlAHIAdABpAGUAcwBcAHsAMwBhAGIAMgAyAGUAMwAxAC0AOAAyADYANAAtADQAYgA0AGUALQA5
AGEAZgA1AC0AYQA4AGQAMgBkADgAZQAzADMAZQA2ADIAfQBcADAAMAAxADAAXQANAAoAQAA9AGgA
ZQB4ACgAZgBmAGYAZgAwADAAMAA3ACkAOgAwADAALAAwADEALAAwADAALAAwADAADQAKAA0ACgBb
AEgASwBFAFkAXwBMAE8AQwBBAEwAXwBNAEEAQwBIAEkATgBFAFwAUwBZAFMAVABFAE0AXABDAHUA
cgByAGUAbgB0AEMAbwBuAHQAcgBvAGwAUwBlAHQAXABFAG4AdQBtAFwAUABDAEkAXABWAEUATgBf
ADEAMQAzADEAJgBEAEUAVgBfADcAMQAzADMAJgBTAFUAQgBTAFkAUwBfADkAMAAwADQAMQA0ADUA
OAAmAFIARQBWAF8ARAAxAFwANAAmADMANAAwAGMAZQA2AGYAZQAmADAAJgAzADAAQQA0AFwAUABy
AG8AcABlAHIAdABpAGUAcwBcAHsAMwBhAGIAMgAyAGUAMwAxAC0AOAAyADYANAAtADQAYgA0AGUA
LQA5AGEAZgA1AC0AYQA4AGQAMgBkADgAZQAzADMAZQA2ADIAfQBcADAAMAAxADkAXQANAAoAQAA9
AGgAZQB4ACgAZgBmAGYAZgAwADAAMQAxACkAOgBmAGYADQAKAA0ACgBbAEgASwBFAFkAXwBMAE8A
QwBBAEwAXwBNAEEAQwBIAEkATgBFAFwAUwBZAFMAVABFAE0AXABDAHUAcgByAGUAbgB0AEMAbwBu
AHQAcgBvAGwAUwBlAHQAXABFAG4AdQBtAFwAUABDAEkAXABWAEUATgBfADEAMQAzADEAJgBEAEUA
VgBfADcAMQAzADMAJgBTAFUAQgBTAFkAUwBfADkAMAAwADQAMQA0ADUAOAAmAFIARQBWAF8ARAAx
AFwANAAmADMANAAwAGMAZQA2AGYAZQAmADAAJgAzADAAQQA0AFwAUAByAG8AcABlAHIAdABpAGUA
cwBcAHsANQA0ADAAYgA5ADQANwBlAC0AOABiADQAMAAtADQANQBiAGMALQBhADgAYQAyAC0ANgBh
ADAAYgA4ADkANABjAGIAZABhADIAfQBdAA0ACgANAAoAWwBIAEsARQBZAF8ATABPAEMAQQBMAF8A
TQBBAEMASABJAE4ARQBcAFMAWQBTAFQARQBNAFwAQwB1AHIAcgBlAG4AdABDAG8AbgB0AHIAbwBs
AFMAZQB0AFwARQBuAHUAbQBcAFAAQwBJAFwAVgBFAE4AXwAxADEAMwAxACYARABFAFYAXwA3ADEA
MwAzACYAUwBVAEIAUwBZAFMAXwA5ADAAMAA0ADEANAA1ADgAJgBSAEUAVgBfAEQAMQBcADQAJgAz
ADQAMABjAGUANgBmAGUAJgAwACYAMwAwAEEANABcAFAAcgBvAHAAZQByAHQAaQBlAHMAXAB7ADUA
NAAwAGIAOQA0ADcAZQAtADgAYgA0ADAALQA0ADUAYgBjAC0AYQA4AGEAMgAtADYAYQAwAGIAOAA5
ADQAYwBiAGQAYQAyAH0AXAAwADAAMAA0AF0ADQAKAEAAPQBoAGUAeAAoAGYAZgBmAGYAMAAwADEA
OQApADoANAAwACwAMAAwACwANQAzACwAMAAwACwANwA5ACwAMAAwACwANwAzACwAMAAwACwANwA0
ACwAMAAwACwANgA1ACwAMAAwACwANgBkACwAMAAwACwAMwAzACwAMAAwACwAMwAyACwAMAAwACwA
NQBjACwAMAAwACwANgA0ACwAXAANAAoAIAAgADAAMAAsADcAMgAsADAAMAAsADYAOQAsADAAMAAs
ADcANgAsADAAMAAsADYANQAsADAAMAAsADcAMgAsADAAMAAsADcAMwAsADAAMAAsADUAYwAsADAA
MAAsADcAMAAsADAAMAAsADYAMwAsADAAMAAsADYAOQAsADAAMAAsADIAZQAsADAAMAAsADcAMwAs
ADAAMAAsAFwADQAKACAAIAA3ADkALAAwADAALAA3ADMALAAwADAALAAyAGMALAAwADAALAAyADMA
LAAwADAALAAzADEALAAwADAALAAzADEALAAwADAALAAzADUALAAwADAALAAzADIALAAwADAALAAz
AGIALAAwADAALAA0AGQALAAwADAALAA3ADUALAAwADAALAA2AGMALAAwADAALAA3ADQALABcAA0A
CgAgACAAMAAwACwANgA5ACwAMAAwACwANgBkACwAMAAwACwANgA1ACwAMAAwACwANgA0ACwAMAAw
ACwANgA5ACwAMAAwACwANgAxACwAMAAwACwAMgAwACwAMAAwACwANAAzACwAMAAwACwANgBmACwA
MAAwACwANgBlACwAMAAwACwANwA0ACwAMAAwACwANwAyACwAMAAwACwAXAANAAoAIAAgADYAZgAs
ADAAMAAsADYAYwAsADAAMAAsADYAYwAsADAAMAAsADYANQAsADAAMAAsADcAMgAsADAAMAAsADAA
MAAsADAAMAANAAoADQAKAFsASABLAEUAWQBfAEwATwBDAEEATABfAE0AQQBDAEgASQBOAEUAXABT
AFkAUwBUAEUATQBcAEMAdQByAHIAZQBuAHQAQwBvAG4AdAByAG8AbABTAGUAdABcAEUAbgB1AG0A
XABQAEMASQBcAFYARQBOAF8AMQAxADMAMQAmAEQARQBWAF8ANwAxADMAMwAmAFMAVQBCAFMAWQBT
AF8AOQAwADAANAAxADQANQA4ACYAUgBFAFYAXwBEADEAXAA0ACYAMwA0ADAAYwBlADYAZgBlACYA
MAAmADMAMABBADQAXABQAHIAbwBwAGUAcgB0AGkAZQBzAFwAewA1ADQAMABiADkANAA3AGUALQA4
AGIANAAwAC0ANAA1AGIAYwAtAGEAOABhADIALQA2AGEAMABiADgAOQA0AGMAYgBkAGEAMgB9AFwA
MAAwADAANwBdAA0ACgANAAoAWwBIAEsARQBZAF8ATABPAEMAQQBMAF8ATQBBAEMASABJAE4ARQBc
AFMAWQBTAFQARQBNAFwAQwB1AHIAcgBlAG4AdABDAG8AbgB0AHIAbwBsAFMAZQB0AFwARQBuAHUA
bQBcAFAAQwBJAFwAVgBFAE4AXwAxADEAMwAxACYARABFAFYAXwA3ADEAMwAzACYAUwBVAEIAUwBZ
AFMAXwA5ADAAMAA0ADEANAA1ADgAJgBSAEUAVgBfAEQAMQBcADQAJgAzADQAMABjAGUANgBmAGUA
JgAwACYAMwAwAEEANABcAFAAcgBvAHAAZQByAHQAaQBlAHMAXAB7ADgAMAA0ADkANwAxADAAMAAt
ADgAYwA3ADMALQA0ADgAYgA5AC0AYQBhAGQAOQAtAGMAZQAzADgANwBlADEAOQBjADUANgBlAH0A
XQANAAoADQAKAFsASABLAEUAWQBfAEwATwBDAEEATABfAE0AQQBDAEgASQBOAEUAXABTAFkAUwBU
AEUATQBcAEMAdQByAHIAZQBuAHQAQwBvAG4AdAByAG8AbABTAGUAdABcAEUAbgB1AG0AXABQAEMA
SQBcAFYARQBOAF8AMQAxADMAMQAmAEQARQBWAF8ANwAxADMAMwAmAFMAVQBCAFMAWQBTAF8AOQAw
ADAANAAxADQANQA4ACYAUgBFAFYAXwBEADEAXAA0ACYAMwA0ADAAYwBlADYAZgBlACYAMAAmADMA
MABBADQAXABQAHIAbwBwAGUAcgB0AGkAZQBzAFwAewA4ADAANAA5ADcAMQAwADAALQA4AGMANwAz
AC0ANAA4AGIAOQAtAGEAYQBkADkALQBjAGUAMwA4ADcAZQAxADkAYwA1ADYAZQB9AFwAMAAwADAA
NgBdAA0ACgBAAD0AaABlAHgAKABmAGYAZgBmADAAMAAwADcAKQA6ADAAMAAsADAAMAAsADAAMAAs
ADAAMAANAAoADQAKAFsASABLAEUAWQBfAEwATwBDAEEATABfAE0AQQBDAEgASQBOAEUAXABTAFkA
UwBUAEUATQBcAEMAdQByAHIAZQBuAHQAQwBvAG4AdAByAG8AbABTAGUAdABcAEUAbgB1AG0AXABQ
AEMASQBcAFYARQBOAF8AMQAxADMAMQAmAEQARQBWAF8ANwAxADMAMwAmAFMAVQBCAFMAWQBTAF8A
OQAwADAANAAxADQANQA4ACYAUgBFAFYAXwBEADEAXAA0ACYAMwA0ADAAYwBlADYAZgBlACYAMAAm
ADMAMABBADQAXABQAHIAbwBwAGUAcgB0AGkAZQBzAFwAewA4ADMAZABhADYAMwAyADYALQA5ADcA
YQA2AC0ANAAwADgAOAAtADkANAA1ADMALQBhADEAOQAyADMAZgA1ADcAMwBiADIAOQB9AF0ADQAK
AA0ACgBbAEgASwBFAFkAXwBMAE8AQwBBAEwAXwBNAEEAQwBIAEkATgBFAFwAUwBZAFMAVABFAE0A
XABDAHUAcgByAGUAbgB0AEMAbwBuAHQAcgBvAGwAUwBlAHQAXABFAG4AdQBtAFwAUABDAEkAXABW
AEUATgBfADEAMQAzADEAJgBEAEUAVgBfADcAMQAzADMAJgBTAFUAQgBTAFkAUwBfADkAMAAwADQA
MQA0ADUAOAAmAFIARQBWAF8ARAAxAFwANAAmADMANAAwAGMAZQA2AGYAZQAmADAAJgAzADAAQQA0
AFwAUAByAG8AcABlAHIAdABpAGUAcwBcAHsAOAAzAGQAYQA2ADMAMgA2AC0AOQA3AGEANgAtADQA
MAA4ADgALQA5ADQANQAzAC0AYQAxADkAMgAzAGYANQA3ADMAYgAyADkAfQBcADAAMAAwADMAXQAN
AAoAQAA9AGgAZQB4ACgAZgBmAGYAZgAwADAAMQAyACkAOgA2AGYALAAwADAALAA2ADUALAAwADAA
LAA2AGQALAAwADAALAAzADEALAAwADAALAAzADcALAAwADAALAAyAGUALAAwADAALAA2ADkALAAw
ADAALAA2AGUALAAwADAALAA2ADYALAAwADAALAAzAGEALAAwADAALAAzADkALABcAA0ACgAgACAA
MAAwACwAMwAwACwAMAAwACwAMwA1ACwAMAAwACwAMwA4ACwAMAAwACwAMwA3ACwAMAAwACwANgA0
ACwAMAAwACwAMwAxACwAMAAwACwAMwAxACwAMAAwACwAMwA1ACwAMAAwACwAMwAxACwAMAAwACwA
MwAxACwAMAAwACwANgA2ACwAMAAwACwAMwAzACwAMAAwACwAXAANAAoAIAAgADMANAAsADAAMAAs
ADYANAAsADAAMAAsADMANgAsADAAMAAsADMAYQAsADAAMAAsADUAMgAsADAAMAAsADYANQAsADAA
MAAsADYANgAsADAAMAAsADYANQAsADAAMAAsADcAMgAsADAAMAAsADYANQAsADAAMAAsADYAZQAs
ADAAMAAsADYAMwAsADAAMAAsADYANQAsAFwADQAKACAAIAAwADAALAA0ADIALAAwADAALAA2AGYA
LAAwADAALAA2ADEALAAwADAALAA3ADIALAAwADAALAA2ADQALAAwADAALAA1ADMALAAwADAALAA0
ADEALAAwADAALAA0ADEALAAwADAALAAzADcALAAwADAALAAzADEALAAwADAALAAzADMALAAwADAA
LAAzADMALAAwADAALABcAA0ACgAgACAAMgBlACwAMAAwACwANABlACwAMAAwACwANQA0ACwAMAAw
ACwANAAxACwAMAAwACwANABkACwAMAAwACwANAA0ACwAMAAwACwAMwA2ACwAMAAwACwAMwA0ACwA
MAAwACwAMwBhACwAMAAwACwAMwAxACwAMAAwACwAMgBlACwAMAAwACwAMwA0ACwAMAAwACwAMgBl
ACwAXAANAAoAIAAgADAAMAAsADMAMAAsADAAMAAsADIAZQAsADAAMAAsADMAMwAsADAAMAAsADMA
YQAsADAAMAAsADcAMAAsADAAMAAsADYAMwAsADAAMAAsADYAOQAsADAAMAAsADUAYwAsADAAMAAs
ADcANgAsADAAMAAsADYANQAsADAAMAAsADYAZQAsADAAMAAsADUAZgAsADAAMAAsAFwADQAKACAA
IAAzADEALAAwADAALAAzADEALAAwADAALAAzADMALAAwADAALAAzADEALAAwADAALAAyADYALAAw
ADAALAA2ADQALAAwADAALAA2ADUALAAwADAALAA3ADYALAAwADAALAA1AGYALAAwADAALAAzADcA
LAAwADAALAAzADEALAAwADAALAAzADMALAAwADAALAAzADMALABcAA0ACgAgACAAMAAwACwAMgA2
ACwAMAAwACwANwAzACwAMAAwACwANwA1ACwAMAAwACwANgAyACwAMAAwACwANwAzACwAMAAwACwA
NwA5ACwAMAAwACwANwAzACwAMAAwACwANQBmACwAMAAwACwAMwA5ACwAMAAwACwAMwAwACwAMAAw
ACwAMwAwACwAMAAwACwAMwA0ACwAMAAwACwAXAANAAoAIAAgADMAMQAsADAAMAAsADMANAAsADAA
MAAsADMANQAsADAAMAAsADMAOAAsADAAMAAsADAAMAAsADAAMAANAAoADQAKAFsASABLAEUAWQBf
AEwATwBDAEEATABfAE0AQQBDAEgASQBOAEUAXABTAFkAUwBUAEUATQBcAEMAdQByAHIAZQBuAHQA
QwBvAG4AdAByAG8AbABTAGUAdABcAEUAbgB1AG0AXABQAEMASQBcAFYARQBOAF8AMQAxADMAMQAm
AEQARQBWAF8ANwAxADMAMwAmAFMAVQBCAFMAWQBTAF8AOQAwADAANAAxADQANQA4ACYAUgBFAFYA
XwBEADEAXAA0ACYAMwA0ADAAYwBlADYAZgBlACYAMAAmADMAMABBADQAXABQAHIAbwBwAGUAcgB0
AGkAZQBzAFwAewA4ADMAZABhADYAMwAyADYALQA5ADcAYQA2AC0ANAAwADgAOAAtADkANAA1ADMA
LQBhADEAOQAyADMAZgA1ADcAMwBiADIAOQB9AFwAMAAwADAANQBdAA0ACgANAAoAWwBIAEsARQBZ
AF8ATABPAEMAQQBMAF8ATQBBAEMASABJAE4ARQBcAFMAWQBTAFQARQBNAFwAQwB1AHIAcgBlAG4A
dABDAG8AbgB0AHIAbwBsAFMAZQB0AFwARQBuAHUAbQBcAFAAQwBJAFwAVgBFAE4AXwAxADEAMwAx
ACYARABFAFYAXwA3ADEAMwAzACYAUwBVAEIAUwBZAFMAXwA5ADAAMAA0ADEANAA1ADgAJgBSAEUA
VgBfAEQAMQBcADQAJgAzADQAMABjAGUANgBmAGUAJgAwACYAMwAwAEEANABcAFAAcgBvAHAAZQBy
AHQAaQBlAHMAXAB7ADgAMwBkAGEANgAzADIANgAtADkANwBhADYALQA0ADAAOAA4AC0AOQA0ADUA
MwAtAGEAMQA5ADIAMwBmADUANwAzAGIAMgA5AH0AXAAwADAAMAA3AF0ADQAKAA0ACgBbAEgASwBF
AFkAXwBMAE8AQwBBAEwAXwBNAEEAQwBIAEkATgBFAFwAUwBZAFMAVABFAE0AXABDAHUAcgByAGUA
bgB0AEMAbwBuAHQAcgBvAGwAUwBlAHQAXABFAG4AdQBtAFwAUABDAEkAXABWAEUATgBfADEAMQAz
ADEAJgBEAEUAVgBfADcAMQAzADMAJgBTAFUAQgBTAFkAUwBfADkAMAAwADQAMQA0ADUAOAAmAFIA
RQBWAF8ARAAxAFwANAAmADMANAAwAGMAZQA2AGYAZQAmADAAJgAzADAAQQA0AFwAUAByAG8AcABl
AHIAdABpAGUAcwBcAHsAOAAzAGQAYQA2ADMAMgA2AC0AOQA3AGEANgAtADQAMAA4ADgALQA5ADQA
NQAzAC0AYQAxADkAMgAzAGYANQA3ADMAYgAyADkAfQBcADAAMAAwADgAXQANAAoADQAKAFsASABL
AEUAWQBfAEwATwBDAEEATABfAE0AQQBDAEgASQBOAEUAXABTAFkAUwBUAEUATQBcAEMAdQByAHIA
ZQBuAHQAQwBvAG4AdAByAG8AbABTAGUAdABcAEUAbgB1AG0AXABQAEMASQBcAFYARQBOAF8AMQAx
ADMAMQAmAEQARQBWAF8ANwAxADMAMwAmAFMAVQBCAFMAWQBTAF8AOQAwADAANAAxADQANQA4ACYA
UgBFAFYAXwBEADEAXAA0ACYAMwA0ADAAYwBlADYAZgBlACYAMAAmADMAMABBADQAXABQAHIAbwBw
AGUAcgB0AGkAZQBzAFwAewA4ADMAZABhADYAMwAyADYALQA5ADcAYQA2AC0ANAAwADgAOAAtADkA
NAA1ADMALQBhADEAOQAyADMAZgA1ADcAMwBiADIAOQB9AFwAMAAwADAAOQBdAA0ACgANAAoAWwBI
AEsARQBZAF8ATABPAEMAQQBMAF8ATQBBAEMASABJAE4ARQBcAFMAWQBTAFQARQBNAFwAQwB1AHIA
cgBlAG4AdABDAG8AbgB0AHIAbwBsAFMAZQB0AFwARQBuAHUAbQBcAFAAQwBJAFwAVgBFAE4AXwAx
ADEAMwAxACYARABFAFYAXwA3ADEAMwAzACYAUwBVAEIAUwBZAFMAXwA5ADAAMAA0ADEANAA1ADgA
JgBSAEUAVgBfAEQAMQBcADQAJgAzADQAMABjAGUANgBmAGUAJgAwACYAMwAwAEEANABcAFAAcgBv
AHAAZQByAHQAaQBlAHMAXAB7ADgAMwBkAGEANgAzADIANgAtADkANwBhADYALQA0ADAAOAA4AC0A
OQA0ADUAMwAtAGEAMQA5ADIAMwBmADUANwAzAGIAMgA5AH0AXAAwADAAMABBAF0ADQAKAEAAPQBo
AGUAeAAoAGYAZgBmAGYAMAAwADEAMgApADoANQAwACwAMAAwACwANAAzACwAMAAwACwANAA5ACwA
MAAwACwANQBjACwAMAAwACwANQA2ACwAMAAwACwANAA1ACwAMAAwACwANABlACwAMAAwACwANQBm
ACwAMAAwACwAMwAxACwAMAAwACwAMwAwACwAMAAwACwAMwAwACwAXAANAAoAIAAgADAAMAAsADMA
MgAsADAAMAAsADIANgAsADAAMAAsADQANAAsADAAMAAsADQANQAsADAAMAAsADUANgAsADAAMAAs
ADUAZgAsADAAMAAsADMANAAsADAAMAAsADMAMwAsADAAMAAsADMAOAAsADAAMAAsADMANAAsADAA
MAAsADIANgAsADAAMAAsADUAMwAsADAAMAAsAFwADQAKACAAIAA1ADUALAAwADAALAA0ADIALAAw
ADAALAA1ADMALAAwADAALAA1ADkALAAwADAALAA1ADMALAAwADAALAA1AGYALAAwADAALAAzADAA
LAAwADAALAAzADAALAAwADAALAAzADAALAAwADAALAAzADAALAAwADAALAAzADAALAAwADAALAAz
ADAALAAwADAALAAzADAALABcAA0ACgAgACAAMAAwACwAMwAwACwAMAAwACwAMgA2ACwAMAAwACwA
NQAyACwAMAAwACwANAA1ACwAMAAwACwANQA2ACwAMAAwACwANQBmACwAMAAwACwAMwA0ACwAMAAw
ACwAMwAwACwAMAAwACwANQBjACwAMAAwACwAMwAzACwAMAAwACwAMgA2ACwAMAAwACwAMwAxACwA
MAAwACwAXAANAAoAIAAgADMAOAAsADAAMAAsADYANAAsADAAMAAsADMANAAsADAAMAAsADMANQAs
ADAAMAAsADYAMQAsADAAMAAsADYAMQAsADAAMAAsADMANgAsADAAMAAsADIANgAsADAAMAAsADMA
MAAsADAAMAAsADIANgAsADAAMAAsADQAMQAsADAAMAAsADMANAAsADAAMAAsADAAMAAsAFwADQAK
ACAAIAAwADAADQAKAA0ACgBbAEgASwBFAFkAXwBMAE8AQwBBAEwAXwBNAEEAQwBIAEkATgBFAFwA
UwBZAFMAVABFAE0AXABDAHUAcgByAGUAbgB0AEMAbwBuAHQAcgBvAGwAUwBlAHQAXABFAG4AdQBt
AFwAUABDAEkAXABWAEUATgBfADEAMQAzADEAJgBEAEUAVgBfADcAMQAzADMAJgBTAFUAQgBTAFkA
UwBfADkAMAAwADQAMQA0ADUAOAAmAFIARQBWAF8ARAAxAFwANAAmADMANAAwAGMAZQA2AGYAZQAm
ADAAJgAzADAAQQA0AFwAUAByAG8AcABlAHIAdABpAGUAcwBcAHsAOAAzAGQAYQA2ADMAMgA2AC0A
OQA3AGEANgAtADQAMAA4ADgALQA5ADQANQAzAC0AYQAxADkAMgAzAGYANQA3ADMAYgAyADkAfQBc
ADAAMAA2ADQAXQANAAoAQAA9AGgAZQB4ACgAZgBmAGYAZgAwADAAMQAwACkAOgBkADAALABhAGIA
LABkAGYALABjAGQALABjADQALABlAGYALABjAGYALAAwADEADQAKAA0ACgBbAEgASwBFAFkAXwBM
AE8AQwBBAEwAXwBNAEEAQwBIAEkATgBFAFwAUwBZAFMAVABFAE0AXABDAHUAcgByAGUAbgB0AEMA
bwBuAHQAcgBvAGwAUwBlAHQAXABFAG4AdQBtAFwAUABDAEkAXABWAEUATgBfADEAMQAzADEAJgBE
AEUAVgBfADcAMQAzADMAJgBTAFUAQgBTAFkAUwBfADkAMAAwADQAMQA0ADUAOAAmAFIARQBWAF8A
RAAxAFwANAAmADMANAAwAGMAZQA2AGYAZQAmADAAJgAzADAAQQA0AFwAUAByAG8AcABlAHIAdABp
AGUAcwBcAHsAOAAzAGQAYQA2ADMAMgA2AC0AOQA3AGEANgAtADQAMAA4ADgALQA5ADQANQAzAC0A
YQAxADkAMgAzAGYANQA3ADMAYgAyADkAfQBcADAAMAA2ADUAXQANAAoAQAA9AGgAZQB4ACgAZgBm
AGYAZgAwADAAMQAwACkAOgBmAGQALABmAGUALAA0ADgALAAzADYALAA2AGIALABlAGQALABjAGYA
LAAwADEADQAKAA0ACgBbAEgASwBFAFkAXwBMAE8AQwBBAEwAXwBNAEEAQwBIAEkATgBFAFwAUwBZ
AFMAVABFAE0AXABDAHUAcgByAGUAbgB0AEMAbwBuAHQAcgBvAGwAUwBlAHQAXABFAG4AdQBtAFwA
UABDAEkAXABWAEUATgBfADEAMQAzADEAJgBEAEUAVgBfADcAMQAzADMAJgBTAFUAQgBTAFkAUwBf
ADkAMAAwADQAMQA0ADUAOAAmAFIARQBWAF8ARAAxAFwANAAmADMANAAwAGMAZQA2AGYAZQAmADAA
JgAzADAAQQA0AFwAUAByAG8AcABlAHIAdABpAGUAcwBcAHsAOAAzAGQAYQA2ADMAMgA2AC0AOQA3
AGEANgAtADQAMAA4ADgALQA5ADQANQAzAC0AYQAxADkAMgAzAGYANQA3ADMAYgAyADkAfQBcADAA
MAA2ADYAXQANAAoAQAA9AGgAZQB4ACgAZgBmAGYAZgAwADAAMQAwACkAOgA0ADIALABlADkALAAy
AGQALABjADQALABkAGYALABhAGQALABkADAALAAwADEADQAKAA0ACgBbAEgASwBFAFkAXwBMAE8A
QwBBAEwAXwBNAEEAQwBIAEkATgBFAFwAUwBZAFMAVABFAE0AXABDAHUAcgByAGUAbgB0AEMAbwBu
AHQAcgBvAGwAUwBlAHQAXABFAG4AdQBtAFwAUABDAEkAXABWAEUATgBfADEAMQAzADEAJgBEAEUA
VgBfADcAMQAzADMAJgBTAFUAQgBTAFkAUwBfADkAMAAwADQAMQA0ADUAOAAmAFIARQBWAF8ARAAx
AFwANAAmADMANAAwAGMAZQA2AGYAZQAmADAAJgAzADAAQQA0AFwAUAByAG8AcABlAHIAdABpAGUA
cwBcAHsAYQA0ADUAYwAyADUANABlAC0AZABmADEAYwAtADQAZQBmAGQALQA4ADAAMgAwAC0ANgA3
AGQAMQA0ADYAYQA4ADUAMABlADAAfQBdAA0ACgANAAoAWwBIAEsARQBZAF8ATABPAEMAQQBMAF8A
TQBBAEMASABJAE4ARQBcAFMAWQBTAFQARQBNAFwAQwB1AHIAcgBlAG4AdABDAG8AbgB0AHIAbwBs
AFMAZQB0AFwARQBuAHUAbQBcAFAAQwBJAFwAVgBFAE4AXwAxADEAMwAxACYARABFAFYAXwA3ADEA
MwAzACYAUwBVAEIAUwBZAFMAXwA5ADAAMAA0ADEANAA1ADgAJgBSAEUAVgBfAEQAMQBcADQAJgAz
ADQAMABjAGUANgBmAGUAJgAwACYAMwAwAEEANABcAFAAcgBvAHAAZQByAHQAaQBlAHMAXAB7AGEA
NAA1AGMAMgA1ADQAZQAtAGQAZgAxAGMALQA0AGUAZgBkAC0AOAAwADIAMAAtADYANwBkADEANAA2
AGEAOAA1ADAAZQAwAH0AXAAwADAAMgA1AF0ADQAKAEAAPQBoAGUAeAAoAGYAZgBmAGYAMgAwADEA
MgApADoANQAwACwAMAAwACwANAAzACwAMAAwACwANAA5ACwAMAAwACwANQAyACwAMAAwACwANABm
ACwAMAAwACwANABmACwAMAAwACwANQA0ACwAMAAwACwAMgA4ACwAMAAwACwAMwAwACwAMAAwACwA
MgA5ACwAMAAwACwAMgAzACwAXAANAAoAIAAgADAAMAAsADUAMAAsADAAMAAsADQAMwAsADAAMAAs
ADQAOQAsADAAMAAsADIAOAAsADAAMAAsADMAMQAsADAAMAAsADMANAAsADAAMAAsADMAMAAsADAA
MAAsADMANAAsADAAMAAsADIAOQAsADAAMAAsADIAMwAsADAAMAAsADUAMAAsADAAMAAsADQAMwAs
ADAAMAAsAFwADQAKACAAIAA0ADkALAAwADAALAAyADgALAAwADAALAAzADAALAAwADAALAAzADYA
LAAwADAALAAzADAALAAwADAALAAzADAALAAwADAALAAyADkALAAwADAALAAwADAALAAwADAALAA0
ADEALAAwADAALAA0ADMALAAwADAALAA1ADAALAAwADAALAA0ADkALAAwADAALAAyADgALABcAA0A
CgAgACAAMAAwACwANQBmACwAMAAwACwANQAzACwAMAAwACwANAAyACwAMAAwACwANQBmACwAMAAw
ACwAMgA5ACwAMAAwACwAMgAzACwAMAAwACwANAAxACwAMAAwACwANAAzACwAMAAwACwANQAwACwA
MAAwACwANAA5ACwAMAAwACwAMgA4ACwAMAAwACwANQAwACwAMAAwACwAXAANAAoAIAAgADQAMwAs
ADAAMAAsADQAOQAsADAAMAAsADMAMAAsADAAMAAsADIAOQAsADAAMAAsADIAMwAsADAAMAAsADQA
MQAsADAAMAAsADQAMwAsADAAMAAsADUAMAAsADAAMAAsADQAOQAsADAAMAAsADIAOAAsADAAMAAs
ADUAMAAsADAAMAAsADMAMgAsADAAMAAsADUAMAAsAFwADQAKACAAIAAwADAALAA1AGYALAAwADAA
LAAyADkALAAwADAALAAyADMALAAwADAALAA1ADAALAAwADAALAA0ADMALAAwADAALAA0ADkALAAw
ADAALAAyADgALAAwADAALAAzADAALAAwADAALAAzADYALAAwADAALAAzADAALAAwADAALAAzADAA
LAAwADAALAAyADkALAAwADAALABcAA0ACgAgACAAMAAwACwAMAAwACwAMAAwACwAMAAwAA0ACgAN
AAoAWwBIAEsARQBZAF8ATABPAEMAQQBMAF8ATQBBAEMASABJAE4ARQBcAFMAWQBTAFQARQBNAFwA
QwB1AHIAcgBlAG4AdABDAG8AbgB0AHIAbwBsAFMAZQB0AFwARQBuAHUAbQBcAFAAQwBJAFwAVgBF
AE4AXwAxADEAMwAxACYARABFAFYAXwA3ADEAMwAzACYAUwBVAEIAUwBZAFMAXwA5ADAAMAA0ADEA
NAA1ADgAJgBSAEUAVgBfAEQAMQBcADQAJgAzADQAMABjAGUANgBmAGUAJgAwACYAMwAwAEEANABc
AFAAcgBvAHAAZQByAHQAaQBlAHMAXAB7AGEAOABiADgANgA1AGQAZAAtADIAZQAzAGQALQA0ADAA
OQA0AC0AYQBkADkANwAtAGUANQA5ADMAYQA3ADAAYwA3ADUAZAA2AH0AXQANAAoADQAKAFsASABL
AEUAWQBfAEwATwBDAEEATABfAE0AQQBDAEgASQBOAEUAXABTAFkAUwBUAEUATQBcAEMAdQByAHIA
ZQBuAHQAQwBvAG4AdAByAG8AbABTAGUAdABcAEUAbgB1AG0AXABQAEMASQBcAFYARQBOAF8AMQAx
ADMAMQAmAEQARQBWAF8ANwAxADMAMwAmAFMAVQBCAFMAWQBTAF8AOQAwADAANAAxADQANQA4ACYA
UgBFAFYAXwBEADEAXAA0ACYAMwA0ADAAYwBlADYAZgBlACYAMAAmADMAMABBADQAXABQAHIAbwBw
AGUAcgB0AGkAZQBzAFwAewBhADgAYgA4ADYANQBkAGQALQAyAGUAMwBkAC0ANAAwADkANAAtAGEA
ZAA5ADcALQBlADUAOQAzAGEANwAwAGMANwA1AGQANgB9AFwAMAAwADAAMgBdAA0ACgBAAD0AaABl
AHgAKABmAGYAZgBmADAAMAAxADAAKQA6ADAAMAAsADQAMAAsADMAYQAsADAAMwAsADMAYgAsADEA
MgAsAGMAYQAsADAAMQANAAoADQAKAFsASABLAEUAWQBfAEwATwBDAEEATABfAE0AQQBDAEgASQBO
AEUAXABTAFkAUwBUAEUATQBcAEMAdQByAHIAZQBuAHQAQwBvAG4AdAByAG8AbABTAGUAdABcAEUA
bgB1AG0AXABQAEMASQBcAFYARQBOAF8AMQAxADMAMQAmAEQARQBWAF8ANwAxADMAMwAmAFMAVQBC
AFMAWQBTAF8AOQAwADAANAAxADQANQA4ACYAUgBFAFYAXwBEADEAXAA0ACYAMwA0ADAAYwBlADYA
ZgBlACYAMAAmADMAMABBADQAXABQAHIAbwBwAGUAcgB0AGkAZQBzAFwAewBhADgAYgA4ADYANQBk
AGQALQAyAGUAMwBkAC0ANAAwADkANAAtAGEAZAA5ADcALQBlADUAOQAzAGEANwAwAGMANwA1AGQA
NgB9AFwAMAAwADAAMwBdAA0ACgBAAD0AaABlAHgAKABmAGYAZgBmADAAMAAxADIAKQA6ADMAMQAs
ADAAMAAsADIAZQAsADAAMAAsADMANAAsADAAMAAsADIAZQAsADAAMAAsADMAMAAsADAAMAAsADIA
ZQAsADAAMAAsADMAMwAsADAAMAAsADAAMAAsADAAMAANAAoADQAKAFsASABLAEUAWQBfAEwATwBD
AEEATABfAE0AQQBDAEgASQBOAEUAXABTAFkAUwBUAEUATQBcAEMAdQByAHIAZQBuAHQAQwBvAG4A
dAByAG8AbABTAGUAdABcAEUAbgB1AG0AXABQAEMASQBcAFYARQBOAF8AMQAxADMAMQAmAEQARQBW
AF8ANwAxADMAMwAmAFMAVQBCAFMAWQBTAF8AOQAwADAANAAxADQANQA4ACYAUgBFAFYAXwBEADEA
XAA0ACYAMwA0ADAAYwBlADYAZgBlACYAMAAmADMAMABBADQAXABQAHIAbwBwAGUAcgB0AGkAZQBz
AFwAewBhADgAYgA4ADYANQBkAGQALQAyAGUAMwBkAC0ANAAwADkANAAtAGEAZAA5ADcALQBlADUA
OQAzAGEANwAwAGMANwA1AGQANgB9AFwAMAAwADAANABdAA0ACgBAAD0AaABlAHgAKABmAGYAZgBm
ADAAMAAxADIAKQA6ADQANwAsADAAMAAsADQAOQAsADAAMAAsADQANwAsADAAMAAsADQAMQAsADAA
MAAsADQAMgAsADAAMAAsADUAOQAsADAAMAAsADUANAAsADAAMAAsADQANQAsADAAMAAsADIAYwAs
ADAAMAAsADIAMAAsADAAMAAsADUAMAAsAFwADQAKACAAIAAwADAALAAyAGQALAAwADAALAA3ADMA
LAAwADAALAA2ADUALAAwADAALAA3ADIALAAwADAALAA2ADkALAAwADAALAA2ADUALAAwADAALAA3
ADMALAAwADAALAAyADAALAAwADAALAA0ADEALAAwADAALAA2AGUALAAwADAALAA2ADEALAAwADAA
LAA2AGMALAAwADAALABcAA0ACgAgACAANgBmACwAMAAwACwANgA3ACwAMAAwACwAMgAwACwAMAAw
ACwANQA0ACwAMAAwACwANQA2ACwAMAAwACwAMgAwACwAMAAwACwANAAzACwAMAAwACwANgAxACwA
MAAwACwANwAyACwAMAAwACwANgA0ACwAMAAwACwAMgAwACwAMAAwACwANwA2ACwAMAAwACwANgA1
ACwAXAANAAoAIAAgADAAMAAsADcAMgAsADAAMAAsADIAMAAsADAAMAAsADMAMQAsADAAMAAsADIA
ZQAsADAAMAAsADMANAAsADAAMAAsADIAZQAsADAAMAAsADMAMAAsADAAMAAsADIAZQAsADAAMAAs
ADMAMwAsADAAMAAsADAAMAAsADAAMAANAAoADQAKAFsASABLAEUAWQBfAEwATwBDAEEATABfAE0A
QQBDAEgASQBOAEUAXABTAFkAUwBUAEUATQBcAEMAdQByAHIAZQBuAHQAQwBvAG4AdAByAG8AbABT
AGUAdABcAEUAbgB1AG0AXABQAEMASQBcAFYARQBOAF8AMQAxADMAMQAmAEQARQBWAF8ANwAxADMA
MwAmAFMAVQBCAFMAWQBTAF8AOQAwADAANAAxADQANQA4ACYAUgBFAFYAXwBEADEAXAA0ACYAMwA0
ADAAYwBlADYAZgBlACYAMAAmADMAMABBADQAXABQAHIAbwBwAGUAcgB0AGkAZQBzAFwAewBhADgA
YgA4ADYANQBkAGQALQAyAGUAMwBkAC0ANAAwADkANAAtAGEAZAA5ADcALQBlADUAOQAzAGEANwAw
AGMANwA1AGQANgB9AFwAMAAwADAANQBdAA0ACgBAAD0AaABlAHgAKABmAGYAZgBmADAAMAAxADIA
KQA6ADYAZgAsADAAMAAsADYANQAsADAAMAAsADYAZAAsADAAMAAsADMAMQAsADAAMAAsADMANwAs
ADAAMAAsADIAZQAsADAAMAAsADYAOQAsADAAMAAsADYAZQAsADAAMAAsADYANgAsADAAMAAsADAA
MAAsADAAMAANAAoADQAKAFsASABLAEUAWQBfAEwATwBDAEEATABfAE0AQQBDAEgASQBOAEUAXABT
AFkAUwBUAEUATQBcAEMAdQByAHIAZQBuAHQAQwBvAG4AdAByAG8AbABTAGUAdABcAEUAbgB1AG0A
XABQAEMASQBcAFYARQBOAF8AMQAxADMAMQAmAEQARQBWAF8ANwAxADMAMwAmAFMAVQBCAFMAWQBT
AF8AOQAwADAANAAxADQANQA4ACYAUgBFAFYAXwBEADEAXAA0ACYAMwA0ADAAYwBlADYAZgBlACYA
MAAmADMAMABBADQAXABQAHIAbwBwAGUAcgB0AGkAZQBzAFwAewBhADgAYgA4ADYANQBkAGQALQAy
AGUAMwBkAC0ANAAwADkANAAtAGEAZAA5ADcALQBlADUAOQAzAGEANwAwAGMANwA1AGQANgB9AFwA
MAAwADAANgBdAA0ACgBAAD0AaABlAHgAKABmAGYAZgBmADAAMAAxADIAKQA6ADUAMgAsADAAMAAs
ADYANQAsADAAMAAsADYANgAsADAAMAAsADYANQAsADAAMAAsADcAMgAsADAAMAAsADYANQAsADAA
MAAsADYAZQAsADAAMAAsADYAMwAsADAAMAAsADYANQAsADAAMAAsADQAMgAsADAAMAAsADYAZgAs
AFwADQAKACAAIAAwADAALAA2ADEALAAwADAALAA3ADIALAAwADAALAA2ADQALAAwADAALAA1ADMA
LAAwADAALAA0ADEALAAwADAALAA0ADEALAAwADAALAAzADcALAAwADAALAAzADEALAAwADAALAAz
ADMALAAwADAALAAzADMALAAwADAALAAyAGUALAAwADAALAA0AGUALAAwADAALABcAA0ACgAgACAA
NQA0ACwAMAAwACwANAAxACwAMAAwACwANABkACwAMAAwACwANAA0ACwAMAAwACwAMwA2ACwAMAAw
ACwAMwA0ACwAMAAwACwAMAAwACwAMAAwAA0ACgANAAoAWwBIAEsARQBZAF8ATABPAEMAQQBMAF8A
TQBBAEMASABJAE4ARQBcAFMAWQBTAFQARQBNAFwAQwB1AHIAcgBlAG4AdABDAG8AbgB0AHIAbwBs
AFMAZQB0AFwARQBuAHUAbQBcAFAAQwBJAFwAVgBFAE4AXwAxADEAMwAxACYARABFAFYAXwA3ADEA
MwAzACYAUwBVAEIAUwBZAFMAXwA5ADAAMAA0ADEANAA1ADgAJgBSAEUAVgBfAEQAMQBcADQAJgAz
ADQAMABjAGUANgBmAGUAJgAwACYAMwAwAEEANABcAFAAcgBvAHAAZQByAHQAaQBlAHMAXAB7AGEA
OABiADgANgA1AGQAZAAtADIAZQAzAGQALQA0ADAAOQA0AC0AYQBkADkANwAtAGUANQA5ADMAYQA3
ADAAYwA3ADUAZAA2AH0AXAAwADAAMAA4AF0ADQAKAEAAPQBoAGUAeAAoAGYAZgBmAGYAMAAwADEA
MgApADoANwAwACwAMAAwACwANgAzACwAMAAwACwANgA5ACwAMAAwACwANQBjACwAMAAwACwANwA2
ACwAMAAwACwANgA1ACwAMAAwACwANgBlACwAMAAwACwANQBmACwAMAAwACwAMwAxACwAMAAwACwA
MwAxACwAMAAwACwAMwAzACwAXAANAAoAIAAgADAAMAAsADMAMQAsADAAMAAsADIANgAsADAAMAAs
ADYANAAsADAAMAAsADYANQAsADAAMAAsADcANgAsADAAMAAsADUAZgAsADAAMAAsADMANwAsADAA
MAAsADMAMQAsADAAMAAsADMAMwAsADAAMAAsADMAMwAsADAAMAAsADIANgAsADAAMAAsADcAMwAs
ADAAMAAsAFwADQAKACAAIAA3ADUALAAwADAALAA2ADIALAAwADAALAA3ADMALAAwADAALAA3ADkA
LAAwADAALAA3ADMALAAwADAALAA1AGYALAAwADAALAAzADkALAAwADAALAAzADAALAAwADAALAAz
ADAALAAwADAALAAzADQALAAwADAALAAzADEALAAwADAALAAzADQALAAwADAALAAzADUALABcAA0A
CgAgACAAMAAwACwAMwA4ACwAMAAwACwAMAAwACwAMAAwAA0ACgANAAoAWwBIAEsARQBZAF8ATABP
AEMAQQBMAF8ATQBBAEMASABJAE4ARQBcAFMAWQBTAFQARQBNAFwAQwB1AHIAcgBlAG4AdABDAG8A
bgB0AHIAbwBsAFMAZQB0AFwARQBuAHUAbQBcAFAAQwBJAFwAVgBFAE4AXwAxADEAMwAxACYARABF
AFYAXwA3ADEAMwAzACYAUwBVAEIAUwBZAFMAXwA5ADAAMAA0ADEANAA1ADgAJgBSAEUAVgBfAEQA
MQBcADQAJgAzADQAMABjAGUANgBmAGUAJgAwACYAMwAwAEEANABcAFAAcgBvAHAAZQByAHQAaQBl
AHMAXAB7AGEAOABiADgANgA1AGQAZAAtADIAZQAzAGQALQA0ADAAOQA0AC0AYQBkADkANwAtAGUA
NQA5ADMAYQA3ADAAYwA3ADUAZAA2AH0AXAAwADAAMAA5AF0ADQAKAEAAPQBoAGUAeAAoAGYAZgBm
AGYAMAAwADEAMgApADoANQAwACwAMAAwACwANgA4ACwAMAAwACwANgA5ACwAMAAwACwANgBjACwA
MAAwACwANgA5ACwAMAAwACwANwAwACwAMAAwACwANwAzACwAMAAwACwAMgAwACwAMAAwACwANQAz
ACwAMAAwACwANgA1ACwAMAAwACwANgBkACwAXAANAAoAIAAgADAAMAAsADYAOQAsADAAMAAsADYA
MwAsADAAMAAsADYAZgAsADAAMAAsADYAZQAsADAAMAAsADYANAAsADAAMAAsADcANQAsADAAMAAs
ADYAMwAsADAAMAAsADcANAAsADAAMAAsADYAZgAsADAAMAAsADcAMgAsADAAMAAsADcAMwAsADAA
MAAsADAAMAAsADAAMAANAAoADQAKAFsASABLAEUAWQBfAEwATwBDAEEATABfAE0AQQBDAEgASQBO
AEUAXABTAFkAUwBUAEUATQBcAEMAdQByAHIAZQBuAHQAQwBvAG4AdAByAG8AbABTAGUAdABcAEUA
bgB1AG0AXABQAEMASQBcAFYARQBOAF8AMQAxADMAMQAmAEQARQBWAF8ANwAxADMAMwAmAFMAVQBC
AFMAWQBTAF8AOQAwADAANAAxADQANQA4ACYAUgBFAFYAXwBEADEAXAA0ACYAMwA0ADAAYwBlADYA
ZgBlACYAMAAmADMAMABBADQAXABQAHIAbwBwAGUAcgB0AGkAZQBzAFwAewBhADgAYgA4ADYANQBk
AGQALQAyAGUAMwBkAC0ANAAwADkANAAtAGEAZAA5ADcALQBlADUAOQAzAGEANwAwAGMANwA1AGQA
NgB9AFwAMAAwADAARQBdAA0ACgBAAD0AaABlAHgAKABmAGYAZgBmADAAMAAwADcAKQA6ADAAMQAs
ADAAMAAsAGYAZgAsADAAMAANAAoADQAKAFsASABLAEUAWQBfAEwATwBDAEEATABfAE0AQQBDAEgA
SQBOAEUAXABTAFkAUwBUAEUATQBcAEMAdQByAHIAZQBuAHQAQwBvAG4AdAByAG8AbABTAGUAdABc
AEUAbgB1AG0AXABQAEMASQBcAFYARQBOAF8AMQAxADMAMQAmAEQARQBWAF8ANwAxADMAMwAmAFMA
VQBCAFMAWQBTAF8AOQAwADAANAAxADQANQA4ACYAUgBFAFYAXwBEADEAXAA0ACYAMwA0ADAAYwBl
ADYAZgBlACYAMAAmADMAMABBADQAXABQAHIAbwBwAGUAcgB0AGkAZQBzAFwAewBhADgAYgA4ADYA
NQBkAGQALQAyAGUAMwBkAC0ANAAwADkANAAtAGEAZAA5ADcALQBlADUAOQAzAGEANwAwAGMANwA1
AGQANgB9AFwAMAAwADEAMABdAA0ACgBAAD0AaABlAHgAKABmAGYAZgBmADIAMAAxADIAKQA6ADYA
YgAsADAAMAAsADcAMwAsADAAMAAsADIAZQAsADAAMAAsADYAOQAsADAAMAAsADYAZQAsADAAMAAs
ADYANgAsADAAMAAsADAAMAAsADAAMAAsADcANwAsADAAMAAsADYANAAsADAAMAAsADYAZAAsADAA
MAAsADYAMQAsAFwADQAKACAAIAAwADAALAA3ADUALAAwADAALAA2ADQALAAwADAALAA2ADkALAAw
ADAALAA2AGYALAAwADAALAAyAGUALAAwADAALAA2ADkALAAwADAALAA2AGUALAAwADAALAA2ADYA
LAAwADAALAAwADAALAAwADAALAA2AGIALAAwADAALAA3ADMALAAwADAALAA2ADMALAAwADAALABc
AA0ACgAgACAANgAxACwAMAAwACwANwAwACwAMAAwACwANwA0ACwAMAAwACwANwA1ACwAMAAwACwA
NwAyACwAMAAwACwAMgBlACwAMAAwACwANgA5ACwAMAAwACwANgBlACwAMAAwACwANgA2ACwAMAAw
ACwAMAAwACwAMAAwACwANgAyACwAMAAwACwANgA0ACwAMAAwACwANgAxACwAXAANAAoAIAAgADAA
MAAsADIAZQAsADAAMAAsADYAOQAsADAAMAAsADYAZQAsADAAMAAsADYANgAsADAAMAAsADAAMAAs
ADAAMAAsADAAMAAsADAAMAANAAoADQAKAFsASABLAEUAWQBfAEwATwBDAEEATABfAE0AQQBDAEgA
SQBOAEUAXABTAFkAUwBUAEUATQBcAEMAdQByAHIAZQBuAHQAQwBvAG4AdAByAG8AbABTAGUAdABc
AEUAbgB1AG0AXABQAEMASQBcAFYARQBOAF8AMQAxADMAMQAmAEQARQBWAF8ANwAxADMAMwAmAFMA
VQBCAFMAWQBTAF8AOQAwADAANAAxADQANQA4ACYAUgBFAFYAXwBEADEAXAA0ACYAMwA0ADAAYwBl
ADYAZgBlACYAMAAmADMAMABBADQAXABQAHIAbwBwAGUAcgB0AGkAZQBzAFwAewBmADAAZQAyADAA
ZgAwADkALQBkADkANwBhAC0ANAA5AGEAOQAtADgAMAA0ADYALQBiAGIANgBlADIAMgBlADYAYgBi
ADIAZQB9AF0ADQAKAA0ACgBbAEgASwBFAFkAXwBMAE8AQwBBAEwAXwBNAEEAQwBIAEkATgBFAFwA
UwBZAFMAVABFAE0AXABDAHUAcgByAGUAbgB0AEMAbwBuAHQAcgBvAGwAUwBlAHQAXABFAG4AdQBt
AFwAUABDAEkAXABWAEUATgBfADEAMQAzADEAJgBEAEUAVgBfADcAMQAzADMAJgBTAFUAQgBTAFkA
UwBfADkAMAAwADQAMQA0ADUAOAAmAFIARQBWAF8ARAAxAFwANAAmADMANAAwAGMAZQA2AGYAZQAm
ADAAJgAzADAAQQA0AFwAUAByAG8AcABlAHIAdABpAGUAcwBcAHsAZgAwAGUAMgAwAGYAMAA5AC0A
ZAA5ADcAYQAtADQAOQBhADkALQA4ADAANAA2AC0AYgBiADYAZQAyADIAZQA2AGIAYgAyAGUAfQBc
ADAAMAAwADIAXQANAAoAQAA9AGgAZQB4ACgAZgBmAGYAZgAxADAAMAAzACkAOgAwADEALAAwADAA
LAAwADAALAAwADAALAAwADAALAAwADAALAAwADAALAAwADAALAAwADAALAAwADAALAAwADAALAAw
ADAALAAwADAALAAwADAALAAwADAALAAwADAALAAwADAALAAwADAALAAwADAALAAwADAALAAwADAA
LABcAA0ACgAgACAAMAAwACwAMAAwACwAMAAwACwAMAAwACwAMAAwACwAMAAwACwAMAAwACwAMAAw
ACwAMAAwACwAMAAwACwAMAAwACwAMAAwACwAMAAwACwAMAAwACwAMAAwACwAMAAwACwAMAAwACwA
MAAwACwAMAAwACwAMAAwACwAMAAwACwAMAAwACwAMAAwACwAMAAwACwAMAAwACwAXAANAAoAIAAg
ADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAA
MAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAs
ADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAsAFwADQAKACAAIAAwADAALAAwADAA
LAAwADAALAAwADAALAAwADAALAAwADAALAAwADAALAAwADAALAAwADAALAAwADAALAAwADAALAAw
ADAALAAwADAALAAwADAALAAwADAALAAwADAALAAwADAALAAwADAALAAwADAALAAwADAALAAwADAA
LAAwADAALAAwADAALAAwADAALAAwADAALABcAA0ACgAgACAAMAAwACwAMAAwACwAMAAwACwAMAAw
ACwAYgAyACwAMAAwACwAMAAwACwAMAAwACwAMABiACwAMAAwACwAMAAwACwAMAAwACwAMAAyACwA
MAAwACwAMAAwACwAMAAwACwAMAAwACwAMAAwACwAMAAwACwAMAAwACwAMAAwACwAMAAwACwAMAAw
ACwAMAAwACwAMwBmACwAXAANAAoAIAAgADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAA
MAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAs
ADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAA
MAAsAFwADQAKACAAIAAwADAALAAwADAALAAwADAALAAwADAALAAwADAALAAwADAALAAxADQALAAw
ADAALAAwADAALAAwADAALAAwADAALAAwADAALAAwADAALAAwADAALAAwADAALAAwADAALAAwADAA
LAAwADAALAAwADAALAAwADAALAAwADAALAAwADAADQAKAA0ACgBbAEgASwBFAFkAXwBMAE8AQwBB
AEwAXwBNAEEAQwBIAEkATgBFAFwAUwBZAFMAVABFAE0AXABDAHUAcgByAGUAbgB0AEMAbwBuAHQA
cgBvAGwAUwBlAHQAXABFAG4AdQBtAFwAUABDAEkAXABWAEUATgBfADEAMQAzADEAJgBEAEUAVgBf
ADcAMQAzADMAJgBTAFUAQgBTAFkAUwBfADkAMAAwADQAMQA0ADUAOAAmAFIARQBWAF8ARAAxAFwA
NAAmADMANAAwAGMAZQA2AGYAZQAmADAAJgAzADAAQQA0AFwAQwBvAG4AdAByAG8AbABdAA0ACgAi
AEYAaQBsAHQAZQByAGUAZABDAG8AbgBmAGkAZwBWAGUAYwB0AG8AcgAiAD0AaABlAHgAKABhACkA
OgBhADgALAAwADAALAAwADAALAAwADAALAAwADUALAAwADAALAAwADAALAAwADAALAAwADkALAAw
ADAALAAwADAALAAwADAALAAwADYALAAwADAALAAwADAALAAwADAALABcAA0ACgAgACAAMAAwACwA
MAAwACwAMAAwACwAMAAwACwAMAAwACwAMAAwACwAMAAwACwAMAAwACwAMAAwACwAMAAwACwAMAAw
ACwAMAAwACwAMAAxACwAMAAwACwAMAAwACwAMAAwACwAMAAxACwAMAAwACwAMAAxACwAMAAwACwA
MAA0ACwAMAAwACwAMAAwACwAMAAwACwAMAAxACwAXAANAAoAIAAgADAAMwAsADAAMQAsADAAMAAs
ADgAMAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAAOAAsADAAMAAsADAAMAAsADAAMQAsADAA
MAAsADAAMAAsADAAMAAsADAAMAAsAGYAMAAsAGQAZgAsAGYAZAAsADAAMAAsADAAMAAsADAAMAAs
ADAAMAAsAGYAZgAsAGYANwAsAFwADQAKACAAIABkAGYALABmAGQALAAwADAALAAwADAALAAwADAA
LAAwADAALAAwADgALAAwADMALAAwADEALAAwADAALAA4ADAALAAwADAALAAwADAALAAwADAALAAw
ADAALAAwADgALAAwADAALAAwADAALAAwADAALAAwADgALAAwADAALAAwADAALAAwADAALAAwADAA
LAAwADAALABcAA0ACgAgACAAMAAwACwAMAAwACwAMAAwACwAMAAwACwAMAAwACwAZgBmACwAZgBm
ACwAZgBmACwAZgBmACwAMAAwACwAMAAwACwAMAAwACwAMAAwACwAMAAwACwAOAAxACwAMAAxACwA
MAAwACwAMAAwACwAMAAwACwAMAAwACwAMAAwACwAMAAxACwAMAAwACwAMAAwACwAMAAwACwAXAAN
AAoAIAAgADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAA
MAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAs
ADAAMAAsADAAMAAsADAAMAAsADAAMgAsADAAMwAsADAAMAAsADAAMAAsAFwADQAKACAAIAAwADAA
LAAwADAALAAwADAALAAwADAALAAwADAALAAwADAALAAwADAALABmAGYALABmAGYALABmAGYALABm
AGYALAAwADAALAAwADAALAAwADAALAAwADAALAAwADAALAAwADAALAAwADAALAAwADAALAAwADAA
LAAwADAALAAwADAALAAwADAALAAwADAALAAwADAALABcAA0ACgAgACAAMAAwACwAMAAwAA0ACgAi
AEEAbABsAG8AYwBDAG8AbgBmAGkAZwAiAD0AaABlAHgAKAA4ACkAOgAwADEALAAwADAALAAwADAA
LAAwADAALAAwADUALAAwADAALAAwADAALAAwADAALAAwADkALAAwADAALAAwADAALAAwADAALAAw
ADEALAAwADAALAAwADEALAAwADAALAAwADMALAAwADAALAAwADAALABcAA0ACgAgACAAMAAwACwA
MAAzACwAMAAxACwAOAAwACwAMAAwACwAMAAwACwAZgAwACwAZABmACwAZgBkACwAMAAwACwAMAAw
ACwAMAAwACwAMAAwACwAMAAwACwAMAA4ACwAMAAwACwAMAAwACwAMAAwACwAMAAwACwAMAAwACwA
MAAwACwAOAAxACwAMAAxACwAMAAwACwAMAAwACwAXAANAAoAIAAgADAAMQAsADAAMAAsADAAMAAs
ADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAAMAAsADAA
MAAsADAAMAAsADAAMAAsADAAMAAsADAAMgAsADAAMwAsADAAMAAsADAAMAAsADEANAAsADAAMAAs
ADAAMAAsADAAMAAsADEANAAsAFwADQAKACAAIAAwADAALAAwADAALAAwADAALABmAGYALABmAGYA
LABmAGYALABmAGYALAAwADAALAAwADAALAAwADAALAAwADAADQAKAA0ACgA=
--047d7bea43d6add95505199cfef6--
