Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6611JwC004914
	for <video4linux-list@redhat.com>; Sat, 5 Jul 2008 21:01:19 -0400
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.169])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m661141B006638
	for <video4linux-list@redhat.com>; Sat, 5 Jul 2008 21:01:04 -0400
Received: by wf-out-1314.google.com with SMTP id 25so1602429wfc.6
	for <video4linux-list@redhat.com>; Sat, 05 Jul 2008 18:01:04 -0700 (PDT)
Message-ID: <48701944.2040200@gmail.com>
Date: Sat, 05 Jul 2008 17:00:52 -0800
From: D <therealisttruest@gmail.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <486FF148.2060506@gmail.com>
	<1215298086.3237.19.camel@pc10.localdom.local>
	<48700079.6000209@gmail.com>
In-Reply-To: <48700079.6000209@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: Help with Chinese card
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


Not sure why this didn't post the first time, but message is below.. again-

Thank you for the reply. Sorry I forgot dmesg. At this point it's not 
totally valid I don't think, as I made my changes as card  =145 and had 
it loading automatically, but undoing that to a point and doing dmesg we 
have below, which is not autodetected. I've also tried other card 
numbers, but had not success, as a matter of fact all other card 
numbers. My current results only give me garbled video. I'm not sure 
about sound and I'm not worried about it either at this point. Also, 
here is a link to a picture of the card if it helps(it looks similar to 
the one I tried to mirror my changes on this list) 
http://www.szrare.com/en/Product8.asp?BigClassName=Video%20capture%20card
> Please let me know if you need any more info from me at all. If I've 
> forgotten anything else also let me know. I'm pretty much at a dead 
> end at the moment....
>
> [44494.079594] saa7130/34: v4l2 driver version 0.2.14 loaded
> [44494.079653] saa7130[0]: found at 0000:04:08.0, rev: 1, irq: 21, 
> latency: 64, mmio: 0xfebffc00
> [44494.079662] saa7134: <rant>
> [44494.079663] saa7134:  Congratulations!  Your TV card vendor saved a few
> [44494.079664] saa7134:  cents for a eeprom, thus your pci board has no
> [44494.079665] saa7134:  subsystem ID and I can't identify it 
> automatically
> [44494.079666] saa7134: </rant>
> [44494.079667] saa7134: I feel better now.  Ok, here are the good news:
> [44494.079668] saa7134: You can use the card=<nr> insmod option to specify
> [44494.079669] saa7134: which board do you have.  The list:
> [44494.079671] saa7134:   card=0 -> 
> UNKNOWN/GENERIC                        
> [44494.079674] saa7134:   card=1 -> Proteus Pro [philips reference 
> design]   1131:2001 1131:2001
> [44494.079678] saa7134:   card=2 -> LifeView 
> FlyVIDEO3000                    5168:0138 4e42:0138
> [44494.079681] saa7134:   card=3 -> LifeView/Typhoon 
> FlyVIDEO2000            5168:0138 4e42:0138
> [44494.079684] saa7134:   card=4 -> 
> EMPRESS                                  1131:6752
> [44494.079687] saa7134:   card=5 -> SKNet Monster 
> TV                         1131:4e85
> [44494.079689] saa7134:   card=6 -> Tevion MD 
> 9717                         
> [44494.079692] saa7134:   card=7 -> KNC One TV-Station RDS / Typhoon 
> TV Tune 1131:fe01 1894:fe01
> [44494.079695] saa7134:   card=8 -> Terratec Cinergy 400 
> TV                  153b:1142
> [44494.079697] saa7134:   card=9 -> Medion 
> 5044                            
> [44494.079701] saa7134:   card=10 -> Kworld/KuroutoShikou 
> SAA7130-TVPCI     
> [44494.079704] saa7134:   card=11 -> Terratec Cinergy 600 
> TV                  153b:1143
> [44494.079706] saa7134:   card=12 -> Medion 
> 7134                              16be:0003
> [44494.079709] saa7134:   card=13 -> Typhoon TV+Radio 
> 90031                 
> [44494.079711] saa7134:   card=14 -> ELSA EX-VISION 
> 300TV                     1048:226b
> [44494.079715] saa7134:   card=15 -> ELSA EX-VISION 
> 500TV                     1048:226a
> [44494.079719] saa7134:   card=16 -> ASUS TV-FM 
> 7134                          1043:4842 1043:4830 1043:4840
> [44494.079725] saa7134:   card=17 -> AOPEN VA1000 
> POWER                       1131:7133
> [44494.079729] saa7134:   card=18 -> BMK MPEX No 
> Tuner                      
> [44494.079731] saa7134:   card=19 -> Compro VideoMate 
> TV                      185b:c100
> [44494.079735] saa7134:   card=20 -> Matrox 
> CronosPlus                        102b:48d0
> [44494.079739] saa7134:   card=21 -> 10MOONS PCI TV CAPTURE 
> CARD              1131:2001
> [44494.079742] saa7134:   card=22 -> AverMedia M156 / Medion 
> 2819             1461:a70b
> [44494.079746] saa7134:   card=23 -> BMK MPEX 
> Tuner                         
> [44494.079749] saa7134:   card=24 -> KNC One TV-Station 
> DVR                   1894:a006
> [44494.079753] saa7134:   card=25 -> ASUS TV-FM 
> 7133                          1043:4843
> [44494.079756] saa7134:   card=26 -> Pinnacle PCTV Stereo 
> (saa7134)           11bd:002b
> [44494.079760] saa7134:   card=27 -> Manli MuchTV 
> M-TV002                   
> [44494.079763] saa7134:   card=28 -> Manli MuchTV 
> M-TV001                   
> [44494.079765] saa7134:   card=29 -> Nagase Sangyo TransGear 
> 3000TV           1461:050c
> [44494.079769] saa7134:   card=30 -> Elitegroup ECS TVP3XP FM1216 
> Tuner Card( 1019:4cb4
> [44494.079773] saa7134:   card=31 -> Elitegroup ECS TVP3XP FM1236 
> Tuner Card  1019:4cb5
> [44494.079776] saa7134:   card=32 -> AVACS 
> SmartTV                          
> [44494.079780] saa7134:   card=33 -> AVerMedia DVD 
> EZMaker                    1461:10ff
> [44494.079783] saa7134:   card=34 -> Noval Prime TV 
> 7133                    
> [44494.079786] saa7134:   card=35 -> AverMedia AverTV Studio 
> 305              1461:2115
> [44494.079789] saa7134:   card=36 -> UPMOST PURPLE 
> TV                         12ab:0800
> [44494.079793] saa7134:   card=37 -> Items MuchTV Plus / 
> IT-005             
> [44494.079796] saa7134:   card=38 -> Terratec Cinergy 200 
> TV                  153b:1152
> [44494.079799] saa7134:   card=39 -> LifeView FlyTV Platinum 
> Mini             5168:0212 4e42:0212 5169:1502
> [44494.079804] saa7134:   card=40 -> Compro VideoMate TV 
> PVR/FM               185b:c100
> [44494.079807] saa7134:   card=41 -> Compro VideoMate TV 
> Gold+                185b:c100
> [44494.079811] saa7134:   card=42 -> Sabrent SBT-TVFM 
> (saa7130)             
> [44494.079814] saa7134:   card=43 -> :Zolid Xpert 
> TV7134                    
> [44494.079817] saa7134:   card=44 -> Empire PCI TV-Radio 
> LE                 
> [44494.079820] saa7134:   card=45 -> Avermedia AVerTV Studio 
> 307              1461:9715
> [44494.079824] saa7134:   card=46 -> AVerMedia Cardbus TV/Radio 
> (E500)        1461:d6ee
> [44494.079827] saa7134:   card=47 -> Terratec Cinergy 400 
> mobile              153b:1162
> [44494.079831] saa7134:   card=48 -> Terratec Cinergy 600 TV 
> MK3              153b:1158
> [44494.079834] saa7134:   card=49 -> Compro VideoMate Gold+ 
> Pal               185b:c200
> [44494.079838] saa7134:   card=50 -> Pinnacle PCTV 300i DVB-T + 
> PAL           11bd:002d
> [44494.079842] saa7134:   card=51 -> ProVideo 
> PV952                           1540:9524
> [44494.079846] saa7134:   card=52 -> AverMedia 
> AverTV/305                     1461:2108
> [44494.079849] saa7134:   card=53 -> ASUS TV-FM 
> 7135                          1043:4845
> [44494.079853] saa7134:   card=54 -> LifeView FlyTV Platinum FM / 
> Gold        5168:0214 5168:5214 1489:0214 5168:0304
> [44494.079859] saa7134:   card=55 -> LifeView FlyDVB-T DUO / MSI 
> TV@nywhere D 5168:0306 4e42:0306
> [44494.079862] saa7134:   card=56 -> Avermedia AVerTV 
> 307                     1461:a70a
> [44494.079866] saa7134:   card=57 -> Avermedia AVerTV GO 007 
> FM               1461:f31f
> [44494.079870] saa7134:   card=58 -> ADS Tech Instant TV 
> (saa7135)            1421:0350 1421:0351 1421:0370 1421:1370
> [44494.079876] saa7134:   card=59 -> Kworld/Tevion V-Stream Xpert TV 
> PVR7134
> [44494.079879] saa7134:   card=60 -> LifeView/Typhoon/Genius FlyDVB-T 
> Duo Car 5168:0502 4e42:0502 1489:0502
> [44494.079883] saa7134:   card=61 -> Philips TOUGH DVB-T reference 
> design     1131:2004
> [44494.079887] saa7134:   card=62 -> Compro VideoMate TV 
> Gold+II            
> [44494.079890] saa7134:   card=63 -> Kworld Xpert TV 
> PVR7134                
> [44494.079893] saa7134:   card=64 -> FlyTV mini Asus 
> Digimatrix               1043:0210
> [44494.079896] saa7134:   card=65 -> V-Stream Studio TV 
> Terminator          
> [44494.079899] saa7134:   card=66 -> Yuan TUN-900 
> (saa7135)                 
> [44494.079902] saa7134:   card=67 -> Beholder BeholdTV 409 
> FM                 0000:4091
> [44494.079905] saa7134:   card=68 -> GoTView 7135 
> PCI                         5456:7135
> [44494.079909] saa7134:   card=69 -> Philips EUROPA V3 reference 
> design       1131:2004
> [44494.079913] saa7134:   card=70 -> Compro Videomate 
> DVB-T300                185b:c900
> [44494.079917] saa7134:   card=71 -> Compro Videomate 
> DVB-T200                185b:c901
> [44494.079920] saa7134:   card=72 -> RTD Embedded Technologies 
> VFG7350        1435:7350
> [44494.079924] saa7134:   card=73 -> RTD Embedded Technologies 
> VFG7330        1435:7330
> [44494.079928] saa7134:   card=74 -> LifeView FlyTV Platinum 
> Mini2            14c0:1212
> [44494.079932] saa7134:   card=75 -> AVerMedia AVerTVHD MCE 
> A180              1461:1044
> [44494.079935] saa7134:   card=76 -> SKNet MonsterTV 
> Mobile                   1131:4ee9
> [44494.079939] saa7134:   card=77 -> Pinnacle PCTV 40i/50i/110i 
> (saa7133)     11bd:002e
> [44494.079942] saa7134:   card=78 -> ASUSTeK P7131 
> Dual                       1043:4862 1043:4857
> [44494.079946] saa7134:   card=79 -> Sedna/MuchTV PC TV Cardbus 
> TV/Radio (ITO
> [44494.079949] saa7134:   card=80 -> ASUS Digimatrix 
> TV                       1043:0210
> [44494.079953] saa7134:   card=81 -> Philips Tiger reference 
> design           1131:2018
> [44494.079956] saa7134:   card=82 -> MSI TV@Anywhere 
> plus                     1462:6231 1462:8624
> [44494.079960] saa7134:   card=83 -> Terratec Cinergy 250 PCI 
> TV              153b:1160
> [44494.079964] saa7134:   card=84 -> LifeView FlyDVB 
> Trio                     5168:0319
> [44494.079968] saa7134:   card=85 -> AverTV DVB-T 
> 777                         1461:2c05 1461:2c05
> [44494.079972] saa7134:   card=86 -> LifeView FlyDVB-T / Genius 
> VideoWonder D 5168:0301 1489:0301
> [44494.079976] saa7134:   card=87 -> ADS Instant TV Duo Cardbus 
> PTV331        0331:1421
> [44494.079980] saa7134:   card=88 -> Tevion/KWorld DVB-T 
> 220RF                17de:7201
> [44494.079984] saa7134:   card=89 -> ELSA EX-VISION 
> 700TV                     1048:226c
> [44494.079988] saa7134:   card=90 -> Kworld 
> ATSC110/115                       17de:7350 17de:7352
> [44494.079993] saa7134:   card=91 -> AVerMedia A169 
> B                         1461:7360
> [44494.079996] saa7134:   card=92 -> AVerMedia A169 
> B1                        1461:6360
> [44494.080000] saa7134:   card=93 -> Medion 7134 Bridge 
> #2                    16be:0005
> [44494.080003] saa7134:   card=94 -> LifeView FlyDVB-T Hybrid 
> Cardbus/MSI TV  5168:3306 5168:3502 5168:3307 4e42:3502
> [44494.080010] saa7134:   card=95 -> LifeView FlyVIDEO3000 
> (NTSC)             5169:0138
> [44494.080013] saa7134:   card=96 -> Medion Md8800 
> Quadro                     16be:0007 16be:0008 16be:000d
> [44494.080018] saa7134:   card=97 -> LifeView FlyDVB-S /Acorp 
> TV134DS         5168:0300 4e42:0300
> [44494.080022] saa7134:   card=98 -> Proteus Pro 
> 2309                         0919:2003
> [44494.080026] saa7134:   card=99 -> AVerMedia TV Hybrid 
> A16AR                1461:2c00
> [44494.080029] saa7134:   card=100 -> Asus Europa2 
> OEM                         1043:4860
> [44494.080033] saa7134:   card=101 -> Pinnacle PCTV 
> 310i                       11bd:002f
> [44494.080037] saa7134:   card=102 -> Avermedia AVerTV Studio 
> 507              1461:9715
> [44494.080041] saa7134:   card=103 -> Compro Videomate 
> DVB-T200A             
> [44494.080044] saa7134:   card=104 -> Hauppauge WinTV-HVR1110 
> DVB-T/Hybrid     0070:6700 0070:6701 0070:6702 0070:6703 0070:6704 
> 0070:6705
> [44494.080051] saa7134:   card=105 -> Terratec Cinergy HT 
> PCMCIA               153b:1172
> [44494.080055] saa7134:   card=106 -> Encore 
> ENLTV                             1131:2342 1131:2341 3016:2344
> [44494.080059] saa7134:   card=107 -> Encore 
> ENLTV-FM                          1131:230f
> [44494.080063] saa7134:   card=108 -> Terratec Cinergy HT 
> PCI                  153b:1175
> [44494.080066] saa7134:   card=109 -> Philips Tiger - S Reference 
> design     
> [44494.080069] saa7134:   card=110 -> Avermedia 
> M102                           1461:f31e
> [44494.080073] saa7134:   card=111 -> ASUS P7131 
> 4871                          1043:4871
> [44494.080077] saa7134:   card=112 -> ASUSTeK P7131 
> Hybrid                     1043:4876
> [44494.080081] saa7134:   card=113 -> Elitegroup ECS TVP3XP FM1246 
> Tuner Card  1019:4cb6
> [44494.080085] saa7134:   card=114 -> KWorld DVB-T 
> 210                         17de:7250
> [44494.080089] saa7134:   card=115 -> Sabrent PCMCIA 
> TV-PCB05                  0919:2003
> [44494.080092] saa7134:   card=116 -> 10MOONS TM300 TV 
> Card                    1131:2304
> [44494.080096] saa7134:   card=117 -> Avermedia Super 
> 007                      1461:f01d
> [44494.080100] saa7134:   card=118 -> Beholder BeholdTV 
> 401                    0000:4016
> [44494.080103] saa7134:   card=119 -> Beholder BeholdTV 
> 403                    0000:4036
> [44494.080107] saa7134:   card=120 -> Beholder BeholdTV 403 
> FM                 0000:4037
> [44494.080111] saa7134:   card=121 -> Beholder BeholdTV 
> 405                    0000:4050
> [44494.080114] saa7134:   card=122 -> Beholder BeholdTV 405 
> FM                 0000:4051
> [44494.080118] saa7134:   card=123 -> Beholder BeholdTV 
> 407                    0000:4070
> [44494.080122] saa7134:   card=124 -> Beholder BeholdTV 407 
> FM                 0000:4071
> [44494.080125] saa7134:   card=125 -> Beholder BeholdTV 
> 409                    0000:4090
> [44494.080129] saa7134:   card=126 -> Beholder BeholdTV 505 
> FM/RDS             0000:5051 0000:505b 5ace:5050
> [44494.080134] saa7134:   card=127 -> Beholder BeholdTV 507 FM/RDS / 
> BeholdTV  0000:5071 0000:507b 5ace:5070 5ace:5090
> [44494.080139] saa7134:   card=128 -> Beholder BeholdTV Columbus 
> TVFM          0000:5201
> [44494.080143] saa7134:   card=129 -> Beholder BeholdTV 607 / BeholdTV 
> 609     5ace:6070 5ace:6071 5ace:6072 5ace:6073 5ace:6090 5ace:6091 
> 5ace:6092 5ace:6093
> [44494.080152] saa7134:   card=130 -> Beholder BeholdTV 
> M6                     5ace:6190
> [44494.080156] saa7134:   card=131 -> Twinhan Hybrid DTV-DVB 3056 
> PCI          1822:0022
> [44494.080160] saa7134:   card=132 -> Genius TVGO 
> AM11MCE                    
> [44494.080163] saa7134:   card=133 -> NXP Snake DVB-S reference 
> design       
> [44494.080166] saa7134:   card=134 -> Medion/Creatix CTX953 
> Hybrid             16be:0010
> [44494.080169] saa7134:   card=135 -> MSI TV@nywhere A/D 
> v1.1                  1462:8625
> [44494.080173] saa7134:   card=136 -> AVerMedia Cardbus TV/Radio 
> (E506R)       1461:f436
> [44494.080177] saa7134:   card=137 -> AVerMedia Hybrid TV/Radio 
> (A16D)         1461:f936
> [44494.080181] saa7134:   card=138 -> Avermedia 
> M115                           1461:a836
> [44494.080184] saa7134:   card=139 -> Compro VideoMate 
> T750                    185b:c900
> [44494.080188] saa7134:   card=140 -> Avermedia DVB-S Pro 
> A700                 1461:a7a1
> [44494.080192] saa7134:   card=141 -> Avermedia DVB-S Hybrid+FM 
> A700           1461:a7a2
> [44494.080196] saa7134:   card=142 -> Beholder BeholdTV 
> H6                     5ace:6290
> [44494.080199] saa7134:   card=143 -> Beholder BeholdTV 
> M63                    5ace:6191
> [44494.080203] saa7134:   card=144 -> Beholder BeholdTV M6 
> Extra               5ace:6193
> [44494.080206] saa7134:   card=145 -> AOPVision AOP-8008A 16CH/240fps 
> Capture
> [44494.080210] saa7130[0]: subsystem: 1131:0000, board: 
> UNKNOWN/GENERIC [card=0,autodetected]
> [44494.080220] saa7130[0]: board init: gpio is c013ef0
> [44494.182688] saa7130[0]: Huh, no eeprom present (err=-5)?
> [44494.182750] saa7130[0]: registered device video0 [v4l2]
> [44494.182766] saa7130[0]: registered device vbi0
> [44494.182794] saa7130[1]: found at 0000:04:09.0, rev: 1, irq: 22, 
> latency: 64, mmio: 0xfebff800
> [44494.182802] saa7134: <rant>
> [44494.182803] saa7134:  Congratulations!  Your TV card vendor saved a few
> [44494.182804] saa7134:  cents for a eeprom, thus your pci board has no
> [44494.182805] saa7134:  subsystem ID and I can't identify it 
> automatically
> [44494.182806] saa7134: </rant>
> [44494.182807] saa7134: I feel better now.  Ok, here are the good news:
> [44494.182808] saa7134: You can use the card=<nr> insmod option to specify
> [44494.182809] saa7134: which board do you have.  The list:
> [44494.182811] saa7134:   card=0 -> 
> UNKNOWN/GENERIC                        
> [44494.182814] saa7134:   card=1 -> Proteus Pro [philips reference 
> design]   1131:2001 1131:2001
> [44494.182818] saa7134:   card=2 -> LifeView 
> FlyVIDEO3000                    5168:0138 4e42:0138
> [44494.182821] saa7134:   card=3 -> LifeView/Typhoon 
> FlyVIDEO2000            5168:0138 4e42:0138
> [44494.182824] saa7134:   card=4 -> 
> EMPRESS                                  1131:6752
> [44494.182827] saa7134:   card=5 -> SKNet Monster 
> TV                         1131:4e85
> [44494.182830] saa7134:   card=6 -> Tevion MD 
> 9717                         
> [44494.182832] saa7134:   card=7 -> KNC One TV-Station RDS / Typhoon 
> TV Tune 1131:fe01 1894:fe01
> [44494.182835] saa7134:   card=8 -> Terratec Cinergy 400 
> TV                  153b:1142
> [44494.182838] saa7134:   card=9 -> Medion 
> 5044                            
> [44494.182841] saa7134:   card=10 -> Kworld/KuroutoShikou 
> SAA7130-TVPCI     
> [44494.182843] saa7134:   card=11 -> Terratec Cinergy 600 
> TV                  153b:1143
> [44494.182846] saa7134:   card=12 -> Medion 
> 7134                              16be:0003
> [44494.182848] saa7134:   card=13 -> Typhoon TV+Radio 
> 90031                 
> [44494.182851] saa7134:   card=14 -> ELSA EX-VISION 
> 300TV                     1048:226b
> [44494.182853] saa7134:   card=15 -> ELSA EX-VISION 
> 500TV                     1048:226a
> [44494.182856] saa7134:   card=16 -> ASUS TV-FM 
> 7134                          1043:4842 1043:4830 1043:4840
> [44494.182860] saa7134:   card=17 -> AOPEN VA1000 
> POWER                       1131:7133
> [44494.182863] saa7134:   card=18 -> BMK MPEX No 
> Tuner                      
> [44494.182865] saa7134:   card=19 -> Compro VideoMate 
> TV                      185b:c100
> [44494.182868] saa7134:   card=20 -> Matrox 
> CronosPlus                        102b:48d0
> [44494.182871] saa7134:   card=21 -> 10MOONS PCI TV CAPTURE 
> CARD              1131:2001
> [44494.182874] saa7134:   card=22 -> AverMedia M156 / Medion 
> 2819             1461:a70b
> [44494.182876] saa7134:   card=23 -> BMK MPEX 
> Tuner                         
> [44494.182879] saa7134:   card=24 -> KNC One TV-Station 
> DVR                   1894:a006
> [44494.182881] saa7134:   card=25 -> ASUS TV-FM 
> 7133                          1043:4843
> [44494.182884] saa7134:   card=26 -> Pinnacle PCTV Stereo 
> (saa7134)           11bd:002b
> [44494.182887] saa7134:   card=27 -> Manli MuchTV 
> M-TV002                   
> [44494.182889] saa7134:   card=28 -> Manli MuchTV 
> M-TV001                   
> [44494.182892] saa7134:   card=29 -> Nagase Sangyo TransGear 
> 3000TV           1461:050c
> [44494.182894] saa7134:   card=30 -> Elitegroup ECS TVP3XP FM1216 
> Tuner Card( 1019:4cb4
> [44494.182897] saa7134:   card=31 -> Elitegroup ECS TVP3XP FM1236 
> Tuner Card  1019:4cb5
> [44494.182900] saa7134:   card=32 -> AVACS 
> SmartTV                          
> [44494.182902] saa7134:   card=33 -> AVerMedia DVD 
> EZMaker                    1461:10ff
> [44494.182905] saa7134:   card=34 -> Noval Prime TV 
> 7133                    
> [44494.182907] saa7134:   card=35 -> AverMedia AverTV Studio 
> 305              1461:2115
> [44494.182910] saa7134:   card=36 -> UPMOST PURPLE 
> TV                         12ab:0800
> [44494.182913] saa7134:   card=37 -> Items MuchTV Plus / 
> IT-005             
> [44494.182915] saa7134:   card=38 -> Terratec Cinergy 200 
> TV                  153b:1152
> [44494.182918] saa7134:   card=39 -> LifeView FlyTV Platinum 
> Mini             5168:0212 4e42:0212 5169:1502
> [44494.182921] saa7134:   card=40 -> Compro VideoMate TV 
> PVR/FM               185b:c100
> [44494.182924] saa7134:   card=41 -> Compro VideoMate TV 
> Gold+                185b:c100
> [44494.182927] saa7134:   card=42 -> Sabrent SBT-TVFM 
> (saa7130)             
> [44494.182929] saa7134:   card=43 -> :Zolid Xpert 
> TV7134                    
> [44494.182931] saa7134:   card=44 -> Empire PCI TV-Radio 
> LE                 
> [44494.182933] saa7134:   card=45 -> Avermedia AVerTV Studio 
> 307              1461:9715
> [44494.182936] saa7134:   card=46 -> AVerMedia Cardbus TV/Radio 
> (E500)        1461:d6ee
> [44494.182939] saa7134:   card=47 -> Terratec Cinergy 400 
> mobile              153b:1162
> [44494.182943] saa7134:   card=48 -> Terratec Cinergy 600 TV 
> MK3              153b:1158
> [44494.182947] saa7134:   card=49 -> Compro VideoMate Gold+ 
> Pal               185b:c200
> [44494.182950] saa7134:   card=50 -> Pinnacle PCTV 300i DVB-T + 
> PAL           11bd:002d
> [44494.182952] saa7134:   card=51 -> ProVideo 
> PV952                           1540:9524
> [44494.182955] saa7134:   card=52 -> AverMedia 
> AverTV/305                     1461:2108
> [44494.182958] saa7134:   card=53 -> ASUS TV-FM 
> 7135                          1043:4845
> [44494.182961] saa7134:   card=54 -> LifeView FlyTV Platinum FM / 
> Gold        5168:0214 5168:5214 1489:0214 5168:0304
> [44494.182965] saa7134:   card=55 -> LifeView FlyDVB-T DUO / MSI 
> TV@nywhere D 5168:0306 4e42:0306
> [44494.182970] saa7134:   card=56 -> Avermedia AVerTV 
> 307                     1461:a70a
> [44494.182972] saa7134:   card=57 -> Avermedia AVerTV GO 007 
> FM               1461:f31f
> [44494.182975] saa7134:   card=58 -> ADS Tech Instant TV 
> (saa7135)            1421:0350 1421:0351 1421:0370 1421:1370
> [44494.182979] saa7134:   card=59 -> Kworld/Tevion V-Stream Xpert TV 
> PVR7134
> [44494.182982] saa7134:   card=60 -> LifeView/Typhoon/Genius FlyDVB-T 
> Duo Car 5168:0502 4e42:0502 1489:0502
> [44494.182985] saa7134:   card=61 -> Philips TOUGH DVB-T reference 
> design     1131:2004
> [44494.182988] saa7134:   card=62 -> Compro VideoMate TV 
> Gold+II            
> [44494.182990] saa7134:   card=63 -> Kworld Xpert TV 
> PVR7134                
> [44494.182993] saa7134:   card=64 -> FlyTV mini Asus 
> Digimatrix               1043:0210
> [44494.182995] saa7134:   card=65 -> V-Stream Studio TV 
> Terminator          
> [44494.182998] saa7134:   card=66 -> Yuan TUN-900 
> (saa7135)                 
> [44494.183000] saa7134:   card=67 -> Beholder BeholdTV 409 
> FM                 0000:4091
> [44494.183003] saa7134:   card=68 -> GoTView 7135 
> PCI                         5456:7135
> [44494.183005] saa7134:   card=69 -> Philips EUROPA V3 reference 
> design       1131:2004
> [44494.183008] saa7134:   card=70 -> Compro Videomate 
> DVB-T300                185b:c900
> [44494.183011] saa7134:   card=71 -> Compro Videomate 
> DVB-T200                185b:c901
> [44494.183014] saa7134:   card=72 -> RTD Embedded Technologies 
> VFG7350        1435:7350
> [44494.183017] saa7134:   card=73 -> RTD Embedded Technologies 
> VFG7330        1435:7330
> [44494.183019] saa7134:   card=74 -> LifeView FlyTV Platinum 
> Mini2            14c0:1212
> [44494.183022] saa7134:   card=75 -> AVerMedia AVerTVHD MCE 
> A180              1461:1044
> [44494.183025] saa7134:   card=76 -> SKNet MonsterTV 
> Mobile                   1131:4ee9
> [44494.183028] saa7134:   card=77 -> Pinnacle PCTV 40i/50i/110i 
> (saa7133)     11bd:002e
> [44494.183030] saa7134:   card=78 -> ASUSTeK P7131 
> Dual                       1043:4862 1043:4857
> [44494.183033] saa7134:   card=79 -> Sedna/MuchTV PC TV Cardbus 
> TV/Radio (ITO
> [44494.183036] saa7134:   card=80 -> ASUS Digimatrix 
> TV                       1043:0210
> [44494.183039] saa7134:   card=81 -> Philips Tiger reference 
> design           1131:2018
> [44494.183041] saa7134:   card=82 -> MSI TV@Anywhere 
> plus                     1462:6231 1462:8624
> [44494.183045] saa7134:   card=83 -> Terratec Cinergy 250 PCI 
> TV              153b:1160
> [44494.183047] saa7134:   card=84 -> LifeView FlyDVB 
> Trio                     5168:0319
> [44494.183050] saa7134:   card=85 -> AverTV DVB-T 
> 777                         1461:2c05 1461:2c05
> [44494.183053] saa7134:   card=86 -> LifeView FlyDVB-T / Genius 
> VideoWonder D 5168:0301 1489:0301
> [44494.183057] saa7134:   card=87 -> ADS Instant TV Duo Cardbus 
> PTV331        0331:1421
> [44494.183059] saa7134:   card=88 -> Tevion/KWorld DVB-T 
> 220RF                17de:7201
> [44494.183062] saa7134:   card=89 -> ELSA EX-VISION 
> 700TV                     1048:226c
> [44494.183065] saa7134:   card=90 -> Kworld 
> ATSC110/115                       17de:7350 17de:7352
> [44494.183068] saa7134:   card=91 -> AVerMedia A169 
> B                         1461:7360
> [44494.183071] saa7134:   card=92 -> AVerMedia A169 
> B1                        1461:6360
> [44494.183074] saa7134:   card=93 -> Medion 7134 Bridge 
> #2                    16be:0005
> [44494.183076] saa7134:   card=94 -> LifeView FlyDVB-T Hybrid 
> Cardbus/MSI TV  5168:3306 5168:3502 5168:3307 4e42:3502
> [44494.183080] saa7134:   card=95 -> LifeView FlyVIDEO3000 
> (NTSC)             5169:0138
> [44494.183083] saa7134:   card=96 -> Medion Md8800 
> Quadro                     16be:0007 16be:0008 16be:000d
> [44494.183087] saa7134:   card=97 -> LifeView FlyDVB-S /Acorp 
> TV134DS         5168:0300 4e42:0300
> [44494.183090] saa7134:   card=98 -> Proteus Pro 
> 2309                         0919:2003
> [44494.183093] saa7134:   card=99 -> AVerMedia TV Hybrid 
> A16AR                1461:2c00
> [44494.183096] saa7134:   card=100 -> Asus Europa2 
> OEM                         1043:4860
> [44494.183098] saa7134:   card=101 -> Pinnacle PCTV 
> 310i                       11bd:002f
> [44494.183101] saa7134:   card=102 -> Avermedia AVerTV Studio 
> 507              1461:9715
> [44494.183104] saa7134:   card=103 -> Compro Videomate 
> DVB-T200A             
> [44494.183106] saa7134:   card=104 -> Hauppauge WinTV-HVR1110 
> DVB-T/Hybrid     0070:6700 0070:6701 0070:6702 0070:6703 0070:6704 
> 0070:6705
> [44494.183111] saa7134:   card=105 -> Terratec Cinergy HT 
> PCMCIA               153b:1172
> [44494.183114] saa7134:   card=106 -> Encore 
> ENLTV                             1131:2342 1131:2341 3016:2344
> [44494.183118] saa7134:   card=107 -> Encore 
> ENLTV-FM                          1131:230f
> [44494.183121] saa7134:   card=108 -> Terratec Cinergy HT 
> PCI                  153b:1175
> [44494.183123] saa7134:   card=109 -> Philips Tiger - S Reference 
> design     
> [44494.183126] saa7134:   card=110 -> Avermedia 
> M102                           1461:f31e
> [44494.183128] saa7134:   card=111 -> ASUS P7131 
> 4871                          1043:4871
> [44494.183131] saa7134:   card=112 -> ASUSTeK P7131 
> Hybrid                     1043:4876
> [44494.183134] saa7134:   card=113 -> Elitegroup ECS TVP3XP FM1246 
> Tuner Card  1019:4cb6
> [44494.183137] saa7134:   card=114 -> KWorld DVB-T 
> 210                         17de:7250
> [44494.183140] saa7134:   card=115 -> Sabrent PCMCIA 
> TV-PCB05                  0919:2003
> [44494.183142] saa7134:   card=116 -> 10MOONS TM300 TV 
> Card                    1131:2304
> [44494.183145] saa7134:   card=117 -> Avermedia Super 
> 007                      1461:f01d
> [44494.183148] saa7134:   card=118 -> Beholder BeholdTV 
> 401                    0000:4016
> [44494.183151] saa7134:   card=119 -> Beholder BeholdTV 
> 403                    0000:4036
> [44494.183153] saa7134:   card=120 -> Beholder BeholdTV 403 
> FM                 0000:4037
> [44494.183156] saa7134:   card=121 -> Beholder BeholdTV 
> 405                    0000:4050
> [44494.183159] saa7134:   card=122 -> Beholder BeholdTV 405 
> FM                 0000:4051
> [44494.183162] saa7134:   card=123 -> Beholder BeholdTV 
> 407                    0000:4070
> [44494.183164] saa7134:   card=124 -> Beholder BeholdTV 407 
> FM                 0000:4071
> [44494.183167] saa7134:   card=125 -> Beholder BeholdTV 
> 409                    0000:4090
> [44494.183170] saa7134:   card=126 -> Beholder BeholdTV 505 
> FM/RDS             0000:5051 0000:505b 5ace:5050
> [44494.183174] saa7134:   card=127 -> Beholder BeholdTV 507 FM/RDS / 
> BeholdTV  0000:5071 0000:507b 5ace:5070 5ace:5090
> [44494.183178] saa7134:   card=128 -> Beholder BeholdTV Columbus 
> TVFM          0000:5201
> [44494.183180] saa7134:   card=129 -> Beholder BeholdTV 607 / BeholdTV 
> 609     5ace:6070 5ace:6071 5ace:6072 5ace:6073 5ace:6090 5ace:6091 
> 5ace:6092 5ace:6093
> [44494.183186] saa7134:   card=130 -> Beholder BeholdTV 
> M6                     5ace:6190
> [44494.183189] saa7134:   card=131 -> Twinhan Hybrid DTV-DVB 3056 
> PCI          1822:0022
> [44494.183192] saa7134:   card=132 -> Genius TVGO 
> AM11MCE                    
> [44494.183194] saa7134:   card=133 -> NXP Snake DVB-S reference 
> design       
> [44494.183196] saa7134:   card=134 -> Medion/Creatix CTX953 
> Hybrid             16be:0010
> [44494.183199] saa7134:   card=135 -> MSI TV@nywhere A/D 
> v1.1                  1462:8625
> [44494.183202] saa7134:   card=136 -> AVerMedia Cardbus TV/Radio 
> (E506R)       1461:f436
> [44494.183205] saa7134:   card=137 -> AVerMedia Hybrid TV/Radio 
> (A16D)         1461:f936
> [44494.183207] saa7134:   card=138 -> Avermedia 
> M115                           1461:a836
> [44494.183211] saa7134:   card=139 -> Compro VideoMate 
> T750                    185b:c900
> [44494.183214] saa7134:   card=140 -> Avermedia DVB-S Pro 
> A700                 1461:a7a1
> [44494.183216] saa7134:   card=141 -> Avermedia DVB-S Hybrid+FM 
> A700           1461:a7a2
> [44494.183220] saa7134:   card=142 -> Beholder BeholdTV 
> H6                     5ace:6290
> [44494.183223] saa7134:   card=143 -> Beholder BeholdTV 
> M63                    5ace:6191
> [44494.183225] saa7134:   card=144 -> Beholder BeholdTV M6 
> Extra               5ace:6193
> [44494.183229] saa7134:   card=145 -> AOPVision AOP-8008A 16CH/240fps 
> Capture
> [44494.183232] saa7130[1]: subsystem: 1131:0000, board: 
> UNKNOWN/GENERIC [card=0,autodetected]
> [44494.183246] saa7130[1]: board init: gpio is 10000
> [44494.287616] saa7130[1]: Huh, no eeprom present (err=-5)?
> [44494.287672] saa7130[1]: registered device video1 [v4l2]
> [44494.287689] saa7130[1]: registered device vbi1
> [44494.287716] saa7130[2]: found at 0000:04:0a.0, rev: 1, irq: 20, 
> latency: 64, mmio: 0xfebff400
> [44494.287725] saa7134: <rant>
> [44494.287726] saa7134:  Congratulations!  Your TV card vendor saved a few
> [44494.287727] saa7134:  cents for a eeprom, thus your pci board has no
> [44494.287728] saa7134:  subsystem ID and I can't identify it 
> automatically
> [44494.287729] saa7134: </rant>
> [44494.287730] saa7134: I feel better now.  Ok, here are the good news:
> [44494.287731] saa7134: You can use the card=<nr> insmod option to specify
> [44494.287732] saa7134: which board do you have.  The list:
> [44494.287735] saa7134:   card=0 -> 
> UNKNOWN/GENERIC                        
> [44494.287738] saa7134:   card=1 -> Proteus Pro [philips reference 
> design]   1131:2001 1131:2001
> [44494.287743] saa7134:   card=2 -> LifeView 
> FlyVIDEO3000                    5168:0138 4e42:0138
> [44494.287746] saa7134:   card=3 -> LifeView/Typhoon 
> FlyVIDEO2000            5168:0138 4e42:0138
> [44494.287750] saa7134:   card=4 -> 
> EMPRESS                                  1131:6752
> [44494.287753] saa7134:   card=5 -> SKNet Monster 
> TV                         1131:4e85
> [44494.287756] saa7134:   card=6 -> Tevion MD 
> 9717                         
> [44494.287759] saa7134:   card=7 -> KNC One TV-Station RDS / Typhoon 
> TV Tune 1131:fe01 1894:fe01
> [44494.287762] saa7134:   card=8 -> Terratec Cinergy 400 
> TV                  153b:1142
> [44494.287766] saa7134:   card=9 -> Medion 
> 5044                            
> [44494.287768] saa7134:   card=10 -> Kworld/KuroutoShikou 
> SAA7130-TVPCI     
> [44494.287771] saa7134:   card=11 -> Terratec Cinergy 600 
> TV                  153b:1143
> [44494.287774] saa7134:   card=12 -> Medion 
> 7134                              16be:0003
> [44494.287777] saa7134:   card=13 -> Typhoon TV+Radio 
> 90031                 
> [44494.287780] saa7134:   card=14 -> ELSA EX-VISION 
> 300TV                     1048:226b
> [44494.287783] saa7134:   card=15 -> ELSA EX-VISION 
> 500TV                     1048:226a
> [44494.287785] saa7134:   card=16 -> ASUS TV-FM 
> 7134                          1043:4842 1043:4830 1043:4840
> [44494.287790] saa7134:   card=17 -> AOPEN VA1000 
> POWER                       1131:7133
> [44494.287793] saa7134:   card=18 -> BMK MPEX No 
> Tuner                      
> [44494.287796] saa7134:   card=19 -> Compro VideoMate 
> TV                      185b:c100
> [44494.287799] saa7134:   card=20 -> Matrox 
> CronosPlus                        102b:48d0
> [44494.287802] saa7134:   card=21 -> 10MOONS PCI TV CAPTURE 
> CARD              1131:2001
> [44494.287806] saa7134:   card=22 -> AverMedia M156 / Medion 
> 2819             1461:a70b
> [44494.287808] saa7134:   card=23 -> BMK MPEX 
> Tuner                         
> [44494.287811] saa7134:   card=24 -> KNC One TV-Station 
> DVR                   1894:a006
> [44494.287815] saa7134:   card=25 -> ASUS TV-FM 
> 7133                          1043:4843
> [44494.287818] saa7134:   card=26 -> Pinnacle PCTV Stereo 
> (saa7134)           11bd:002b
> [44494.287821] saa7134:   card=27 -> Manli MuchTV 
> M-TV002                   
> [44494.287823] saa7134:   card=28 -> Manli MuchTV 
> M-TV001                   
> [44494.287825] saa7134:   card=29 -> Nagase Sangyo TransGear 
> 3000TV           1461:050c
> [44494.287829] saa7134:   card=30 -> Elitegroup ECS TVP3XP FM1216 
> Tuner Card( 1019:4cb4
> [44494.287832] saa7134:   card=31 -> Elitegroup ECS TVP3XP FM1236 
> Tuner Card  1019:4cb5
> [44494.287836] saa7134:   card=32 -> AVACS 
> SmartTV                          
> [44494.287838] saa7134:   card=33 -> AVerMedia DVD 
> EZMaker                    1461:10ff
> [44494.287840] saa7134:   card=34 -> Noval Prime TV 
> 7133                    
> [44494.287844] saa7134:   card=35 -> AverMedia AverTV Studio 
> 305              1461:2115
> [44494.287847] saa7134:   card=36 -> UPMOST PURPLE 
> TV                         12ab:0800
> [44494.287849] saa7134:   card=37 -> Items MuchTV Plus / 
> IT-005             
> [44494.287852] saa7134:   card=38 -> Terratec Cinergy 200 
> TV                  153b:1152
> [44494.287855] saa7134:   card=39 -> LifeView FlyTV Platinum 
> Mini             5168:0212 4e42:0212 5169:1502
> [44494.287861] saa7134:   card=40 -> Compro VideoMate TV 
> PVR/FM               185b:c100
> [44494.287863] saa7134:   card=41 -> Compro VideoMate TV 
> Gold+                185b:c100
> [44494.287866] saa7134:   card=42 -> Sabrent SBT-TVFM 
> (saa7130)             
> [44494.287869] saa7134:   card=43 -> :Zolid Xpert 
> TV7134                    
> [44494.287872] saa7134:   card=44 -> Empire PCI TV-Radio 
> LE                 
> [44494.287874] saa7134:   card=45 -> Avermedia AVerTV Studio 
> 307              1461:9715
> [44494.287877] saa7134:   card=46 -> AVerMedia Cardbus TV/Radio 
> (E500)        1461:d6ee
> [44494.287880] saa7134:   card=47 -> Terratec Cinergy 400 
> mobile              153b:1162
> [44494.287884] saa7134:   card=48 -> Terratec Cinergy 600 TV 
> MK3              153b:1158
> [44494.287886] saa7134:   card=49 -> Compro VideoMate Gold+ 
> Pal               185b:c200
> [44494.287889] saa7134:   card=50 -> Pinnacle PCTV 300i DVB-T + 
> PAL           11bd:002d
> [44494.287893] saa7134:   card=51 -> ProVideo 
> PV952                           1540:9524
> [44494.287896] saa7134:   card=52 -> AverMedia 
> AverTV/305                     1461:2108
> [44494.287899] saa7134:   card=53 -> ASUS TV-FM 
> 7135                          1043:4845
> [44494.287902] saa7134:   card=54 -> LifeView FlyTV Platinum FM / 
> Gold        5168:0214 5168:5214 1489:0214 5168:0304
> [44494.287907] saa7134:   card=55 -> LifeView FlyDVB-T DUO / MSI 
> TV@nywhere D 5168:0306 4e42:0306
> [44494.287910] saa7134:   card=56 -> Avermedia AVerTV 
> 307                     1461:a70a
> [44494.287913] saa7134:   card=57 -> Avermedia AVerTV GO 007 
> FM               1461:f31f
> [44494.287917] saa7134:   card=58 -> ADS Tech Instant TV 
> (saa7135)            1421:0350 1421:0351 1421:0370 1421:1370
> [44494.287921] saa7134:   card=59 -> Kworld/Tevion V-Stream Xpert TV 
> PVR7134
> [44494.287924] saa7134:   card=60 -> LifeView/Typhoon/Genius FlyDVB-T 
> Duo Car 5168:0502 4e42:0502 1489:0502
> [44494.287928] saa7134:   card=61 -> Philips TOUGH DVB-T reference 
> design     1131:2004
> [44494.287932] saa7134:   card=62 -> Compro VideoMate TV 
> Gold+II            
> [44494.287934] saa7134:   card=63 -> Kworld Xpert TV 
> PVR7134                
> [44494.287936] saa7134:   card=64 -> FlyTV mini Asus 
> Digimatrix               1043:0210
> [44494.287940] saa7134:   card=65 -> V-Stream Studio TV 
> Terminator          
> [44494.287942] saa7134:   card=66 -> Yuan TUN-900 
> (saa7135)                 
> [44494.287944] saa7134:   card=67 -> Beholder BeholdTV 409 
> FM                 0000:4091
> [44494.287948] saa7134:   card=68 -> GoTView 7135 
> PCI                         5456:7135
> [44494.287951] saa7134:   card=69 -> Philips EUROPA V3 reference 
> design       1131:2004
> [44494.287955] saa7134:   card=70 -> Compro Videomate 
> DVB-T300                185b:c900
> [44494.287957] saa7134:   card=71 -> Compro Videomate 
> DVB-T200                185b:c901
> [44494.287960] saa7134:   card=72 -> RTD Embedded Technologies 
> VFG7350        1435:7350
> [44494.287964] saa7134:   card=73 -> RTD Embedded Technologies 
> VFG7330        1435:7330
> [44494.287967] saa7134:   card=74 -> LifeView FlyTV Platinum 
> Mini2            14c0:1212
> [44494.287970] saa7134:   card=75 -> AVerMedia AVerTVHD MCE 
> A180              1461:1044
> [44494.287974] saa7134:   card=76 -> SKNet MonsterTV 
> Mobile                   1131:4ee9
> [44494.287977] saa7134:   card=77 -> Pinnacle PCTV 40i/50i/110i 
> (saa7133)     11bd:002e
> [44494.287980] saa7134:   card=78 -> ASUSTeK P7131 
> Dual                       1043:4862 1043:4857
> [44494.287983] saa7134:   card=79 -> Sedna/MuchTV PC TV Cardbus 
> TV/Radio (ITO
> [44494.287986] saa7134:   card=80 -> ASUS Digimatrix 
> TV                       1043:0210
> [44494.287990] saa7134:   card=81 -> Philips Tiger reference 
> design           1131:2018
> [44494.287992] saa7134:   card=82 -> MSI TV@Anywhere 
> plus                     1462:6231 1462:8624
> [44494.287997] saa7134:   card=83 -> Terratec Cinergy 250 PCI 
> TV              153b:1160
> [44494.287999] saa7134:   card=84 -> LifeView FlyDVB 
> Trio                     5168:0319
> [44494.288002] saa7134:   card=85 -> AverTV DVB-T 
> 777                         1461:2c05 1461:2c05
> [44494.288006] saa7134:   card=86 -> LifeView FlyDVB-T / Genius 
> VideoWonder D 5168:0301 1489:0301
> [44494.288009] saa7134:   card=87 -> ADS Instant TV Duo Cardbus 
> PTV331        0331:1421
> [44494.288013] saa7134:   card=88 -> Tevion/KWorld DVB-T 
> 220RF                17de:7201
> [44494.288016] saa7134:   card=89 -> ELSA EX-VISION 
> 700TV                     1048:226c
> [44494.288019] saa7134:   card=90 -> Kworld 
> ATSC110/115                       17de:7350 17de:7352
> [44494.288022] saa7134:   card=91 -> AVerMedia A169 
> B                         1461:7360
> [44494.288026] saa7134:   card=92 -> AVerMedia A169 
> B1                        1461:6360
> [44494.288029] saa7134:   card=93 -> Medion 7134 Bridge 
> #2                    16be:0005
> [44494.288031] saa7134:   card=94 -> LifeView FlyDVB-T Hybrid 
> Cardbus/MSI TV  5168:3306 5168:3502 5168:3307 4e42:3502
> [44494.288037] saa7134:   card=95 -> LifeView FlyVIDEO3000 
> (NTSC)             5169:0138
> [44494.288039] saa7134:   card=96 -> Medion Md8800 
> Quadro                     16be:0007 16be:0008 16be:000d
> [44494.288044] saa7134:   card=97 -> LifeView FlyDVB-S /Acorp 
> TV134DS         5168:0300 4e42:0300
> [44494.288047] saa7134:   card=98 -> Proteus Pro 
> 2309                         0919:2003
> [44494.288051] saa7134:   card=99 -> AVerMedia TV Hybrid 
> A16AR                1461:2c00
> [44494.288054] saa7134:   card=100 -> Asus Europa2 
> OEM                         1043:4860
> [44494.288057] saa7134:   card=101 -> Pinnacle PCTV 
> 310i                       11bd:002f
> [44494.288060] saa7134:   card=102 -> Avermedia AVerTV Studio 
> 507              1461:9715
> [44494.288063] saa7134:   card=103 -> Compro Videomate 
> DVB-T200A             
> [44494.288066] saa7134:   card=104 -> Hauppauge WinTV-HVR1110 
> DVB-T/Hybrid     0070:6700 0070:6701 0070:6702 0070:6703 0070:6704 
> 0070:6705
> [44494.288071] saa7134:   card=105 -> Terratec Cinergy HT 
> PCMCIA               153b:1172
> [44494.288075] saa7134:   card=106 -> Encore 
> ENLTV                             1131:2342 1131:2341 3016:2344
> [44494.288079] saa7134:   card=107 -> Encore 
> ENLTV-FM                          1131:230f
> [44494.288083] saa7134:   card=108 -> Terratec Cinergy HT 
> PCI                  153b:1175
> [44494.288085] saa7134:   card=109 -> Philips Tiger - S Reference 
> design     
> [44494.288088] saa7134:   card=110 -> Avermedia 
> M102                           1461:f31e
> [44494.288091] saa7134:   card=111 -> ASUS P7131 
> 4871                          1043:4871
> [44494.288094] saa7134:   card=112 -> ASUSTeK P7131 
> Hybrid                     1043:4876
> [44494.288098] saa7134:   card=113 -> Elitegroup ECS TVP3XP FM1246 
> Tuner Card  1019:4cb6
> [44494.288101] saa7134:   card=114 -> KWorld DVB-T 
> 210                         17de:7250
> [44494.288104] saa7134:   card=115 -> Sabrent PCMCIA 
> TV-PCB05                  0919:2003
> [44494.288107] saa7134:   card=116 -> 10MOONS TM300 TV 
> Card                    1131:2304
> [44494.288110] saa7134:   card=117 -> Avermedia Super 
> 007                      1461:f01d
> [44494.288114] saa7134:   card=118 -> Beholder BeholdTV 
> 401                    0000:4016
> [44494.288116] saa7134:   card=119 -> Beholder BeholdTV 
> 403                    0000:4036
> [44494.288119] saa7134:   card=120 -> Beholder BeholdTV 403 
> FM                 0000:4037
> [44494.288123] saa7134:   card=121 -> Beholder BeholdTV 
> 405                    0000:4050
> [44494.288126] saa7134:   card=122 -> Beholder BeholdTV 405 
> FM                 0000:4051
> [44494.288129] saa7134:   card=123 -> Beholder BeholdTV 
> 407                    0000:4070
> [44494.288133] saa7134:   card=124 -> Beholder BeholdTV 407 
> FM                 0000:4071
> [44494.288135] saa7134:   card=125 -> Beholder BeholdTV 
> 409                    0000:4090
> [44494.288138] saa7134:   card=126 -> Beholder BeholdTV 505 
> FM/RDS             0000:5051 0000:505b 5ace:5050
> [44494.288143] saa7134:   card=127 -> Beholder BeholdTV 507 FM/RDS / 
> BeholdTV  0000:5071 0000:507b 5ace:5070 5ace:5090
> [44494.288147] saa7134:   card=128 -> Beholder BeholdTV Columbus 
> TVFM          0000:5201
> [44494.288150] saa7134:   card=129 -> Beholder BeholdTV 607 / BeholdTV 
> 609     5ace:6070 5ace:6071 5ace:6072 5ace:6073 5ace:6090 5ace:6091 
> 5ace:6092 5ace:6093
> [44494.288156] saa7134:   card=130 -> Beholder BeholdTV 
> M6                     5ace:6190
> [44494.288159] saa7134:   card=131 -> Twinhan Hybrid DTV-DVB 3056 
> PCI          1822:0022
> [44494.288162] saa7134:   card=132 -> Genius TVGO 
> AM11MCE                    
> [44494.288164] saa7134:   card=133 -> NXP Snake DVB-S reference 
> design       
> [44494.288167] saa7134:   card=134 -> Medion/Creatix CTX953 
> Hybrid             16be:0010
> [44494.288169] saa7134:   card=135 -> MSI TV@nywhere A/D 
> v1.1                  1462:8625
> [44494.288172] saa7134:   card=136 -> AVerMedia Cardbus TV/Radio 
> (E506R)       1461:f436
> [44494.288175] saa7134:   card=137 -> AVerMedia Hybrid TV/Radio 
> (A16D)         1461:f936
> [44494.288178] saa7134:   card=138 -> Avermedia 
> M115                           1461:a836
> [44494.288180] saa7134:   card=139 -> Compro VideoMate 
> T750                    185b:c900
> [44494.288183] saa7134:   card=140 -> Avermedia DVB-S Pro 
> A700                 1461:a7a1
> [44494.288186] saa7134:   card=141 -> Avermedia DVB-S Hybrid+FM 
> A700           1461:a7a2
> [44494.288189] saa7134:   card=142 -> Beholder BeholdTV 
> H6                     5ace:6290
> [44494.288191] saa7134:   card=143 -> Beholder BeholdTV 
> M63                    5ace:6191
> [44494.288194] saa7134:   card=144 -> Beholder BeholdTV M6 
> Extra               5ace:6193
> [44494.288197] saa7134:   card=145 -> AOPVision AOP-8008A 16CH/240fps 
> Capture
> [44494.288200] saa7130[2]: subsystem: 1131:0000, board: 
> UNKNOWN/GENERIC [card=0,autodetected]
> [44494.288214] saa7130[2]: board init: gpio is 10000
> [44494.391559] saa7130[2]: Huh, no eeprom present (err=-5)?
> [44494.391611] saa7130[2]: registered device video2 [v4l2]
> [44494.391627] saa7130[2]: registered device vbi2
> [44494.391655] saa7130[3]: found at 0000:04:0b.0, rev: 1, irq: 23, 
> latency: 64, mmio: 0xfebff000
> [44494.391663] saa7134: <rant>
> [44494.391664] saa7134:  Congratulations!  Your TV card vendor saved a few
> [44494.391665] saa7134:  cents for a eeprom, thus your pci board has no
> [44494.391666] saa7134:  subsystem ID and I can't identify it 
> automatically
> [44494.391667] saa7134: </rant>
> [44494.391668] saa7134: I feel better now.  Ok, here are the good news:
> [44494.391669] saa7134: You can use the card=<nr> insmod option to specify
> [44494.391670] saa7134: which board do you have.  The list:
> [44494.391672] saa7134:   card=0 -> 
> UNKNOWN/GENERIC                        
> [44494.391675] saa7134:   card=1 -> Proteus Pro [philips reference 
> design]   1131:2001 1131:2001
> [44494.391679] saa7134:   card=2 -> LifeView 
> FlyVIDEO3000                    5168:0138 4e42:0138
> [44494.391683] saa7134:   card=3 -> LifeView/Typhoon 
> FlyVIDEO2000            5168:0138 4e42:0138
> [44494.391686] saa7134:   card=4 -> 
> EMPRESS                                  1131:6752
> [44494.391689] saa7134:   card=5 -> SKNet Monster 
> TV                         1131:4e85
> [44494.391693] saa7134:   card=6 -> Tevion MD 
> 9717                         
> [44494.391695] saa7134:   card=7 -> KNC One TV-Station RDS / Typhoon 
> TV Tune 1131:fe01 1894:fe01
> [44494.391699] saa7134:   card=8 -> Terratec Cinergy 400 
> TV                  153b:1142
> [44494.391702] saa7134:   card=9 -> Medion 
> 5044                            
> [44494.391705] saa7134:   card=10 -> Kworld/KuroutoShikou 
> SAA7130-TVPCI     
> [44494.391708] saa7134:   card=11 -> Terratec Cinergy 600 
> TV                  153b:1143
> [44494.391710] saa7134:   card=12 -> Medion 
> 7134                              16be:0003
> [44494.391713] saa7134:   card=13 -> Typhoon TV+Radio 
> 90031                 
> [44494.391716] saa7134:   card=14 -> ELSA EX-VISION 
> 300TV                     1048:226b
> [44494.391719] saa7134:   card=15 -> ELSA EX-VISION 
> 500TV                     1048:226a
> [44494.391722] saa7134:   card=16 -> ASUS TV-FM 
> 7134                          1043:4842 1043:4830 1043:4840
> [44494.391727] saa7134:   card=17 -> AOPEN VA1000 
> POWER                       1131:7133
> [44494.391729] saa7134:   card=18 -> BMK MPEX No 
> Tuner                      
> [44494.391732] saa7134:   card=19 -> Compro VideoMate 
> TV                      185b:c100
> [44494.391736] saa7134:   card=20 -> Matrox 
> CronosPlus                        102b:48d0
> [44494.391739] saa7134:   card=21 -> 10MOONS PCI TV CAPTURE 
> CARD              1131:2001
> [44494.391742] saa7134:   card=22 -> AverMedia M156 / Medion 
> 2819             1461:a70b
> [44494.391745] saa7134:   card=23 -> BMK MPEX 
> Tuner                         
> [44494.391747] saa7134:   card=24 -> KNC One TV-Station 
> DVR                   1894:a006
> [44494.391751] saa7134:   card=25 -> ASUS TV-FM 
> 7133                          1043:4843
> [44494.391754] saa7134:   card=26 -> Pinnacle PCTV Stereo 
> (saa7134)           11bd:002b
> [44494.391757] saa7134:   card=27 -> Manli MuchTV 
> M-TV002                   
> [44494.391760] saa7134:   card=28 -> Manli MuchTV 
> M-TV001                   
> [44494.391762] saa7134:   card=29 -> Nagase Sangyo TransGear 
> 3000TV           1461:050c
> [44494.391765] saa7134:   card=30 -> Elitegroup ECS TVP3XP FM1216 
> Tuner Card( 1019:4cb4
> [44494.391768] saa7134:   card=31 -> Elitegroup ECS TVP3XP FM1236 
> Tuner Card  1019:4cb5
> [44494.391771] saa7134:   card=32 -> AVACS 
> SmartTV                          
> [44494.391774] saa7134:   card=33 -> AVerMedia DVD 
> EZMaker                    1461:10ff
> [44494.391776] saa7134:   card=34 -> Noval Prime TV 
> 7133                    
> [44494.391780] saa7134:   card=35 -> AverMedia AverTV Studio 
> 305              1461:2115
> [44494.391783] saa7134:   card=36 -> UPMOST PURPLE 
> TV                         12ab:0800
> [44494.391785] saa7134:   card=37 -> Items MuchTV Plus / 
> IT-005             
> [44494.391789] saa7134:   card=38 -> Terratec Cinergy 200 
> TV                  153b:1152
> [44494.391791] saa7134:   card=39 -> LifeView FlyTV Platinum 
> Mini             5168:0212 4e42:0212 5169:1502
> [44494.391797] saa7134:   card=40 -> Compro VideoMate TV 
> PVR/FM               185b:c100
> [44494.391800] saa7134:   card=41 -> Compro VideoMate TV 
> Gold+                185b:c100
> [44494.391802] saa7134:   card=42 -> Sabrent SBT-TVFM 
> (saa7130)             
> [44494.391805] saa7134:   card=43 -> :Zolid Xpert 
> TV7134                    
> [44494.391808] saa7134:   card=44 -> Empire PCI TV-Radio 
> LE                 
> [44494.391810] saa7134:   card=45 -> Avermedia AVerTV Studio 
> 307              1461:9715
> [44494.391814] saa7134:   card=46 -> AVerMedia Cardbus TV/Radio 
> (E500)        1461:d6ee
> [44494.391817] saa7134:   card=47 -> Terratec Cinergy 400 
> mobile              153b:1162
> [44494.391820] saa7134:   card=48 -> Terratec Cinergy 600 TV 
> MK3              153b:1158
> [44494.391823] saa7134:   card=49 -> Compro VideoMate Gold+ 
> Pal               185b:c200
> [44494.391826] saa7134:   card=50 -> Pinnacle PCTV 300i DVB-T + 
> PAL           11bd:002d
> [44494.391829] saa7134:   card=51 -> ProVideo 
> PV952                           1540:9524
> [44494.391832] saa7134:   card=52 -> AverMedia 
> AverTV/305                     1461:2108
> [44494.391835] saa7134:   card=53 -> ASUS TV-FM 
> 7135                          1043:4845
> [44494.391839] saa7134:   card=54 -> LifeView FlyTV Platinum FM / 
> Gold        5168:0214 5168:5214 1489:0214 5168:0304
> [44494.391843] saa7134:   card=55 -> LifeView FlyDVB-T DUO / MSI 
> TV@nywhere D 5168:0306 4e42:0306
> [44494.391848] saa7134:   card=56 -> Avermedia AVerTV 
> 307                     1461:a70a
> [44494.391851] saa7134:   card=57 -> Avermedia AVerTV GO 007 
> FM               1461:f31f
> [44494.391854] saa7134:   card=58 -> ADS Tech Instant TV 
> (saa7135)            1421:0350 1421:0351 1421:0370 1421:1370
> [44494.391858] saa7134:   card=59 -> Kworld/Tevion V-Stream Xpert TV 
> PVR7134
> [44494.391861] saa7134:   card=60 -> LifeView/Typhoon/Genius FlyDVB-T 
> Duo Car 5168:0502 4e42:0502 1489:0502
> [44494.391866] saa7134:   card=61 -> Philips TOUGH DVB-T reference 
> design     1131:2004
> [44494.391869] saa7134:   card=62 -> Compro VideoMate TV 
> Gold+II            
> [44494.391872] saa7134:   card=63 -> Kworld Xpert TV 
> PVR7134                
> [44494.391874] saa7134:   card=64 -> FlyTV mini Asus 
> Digimatrix               1043:0210
> [44494.391877] saa7134:   card=65 -> V-Stream Studio TV 
> Terminator          
> [44494.391881] saa7134:   card=66 -> Yuan TUN-900 
> (saa7135)                 
> [44494.391883] saa7134:   card=67 -> Beholder BeholdTV 409 
> FM                 0000:4091
> [44494.391886] saa7134:   card=68 -> GoTView 7135 
> PCI                         5456:7135
> [44494.391890] saa7134:   card=69 -> Philips EUROPA V3 reference 
> design       1131:2004
> [44494.391893] saa7134:   card=70 -> Compro Videomate 
> DVB-T300                185b:c900
> [44494.391896] saa7134:   card=71 -> Compro Videomate 
> DVB-T200                185b:c901
> [44494.391899] saa7134:   card=72 -> RTD Embedded Technologies 
> VFG7350        1435:7350
> [44494.391902] saa7134:   card=73 -> RTD Embedded Technologies 
> VFG7330        1435:7330
> [44494.391906] saa7134:   card=74 -> LifeView FlyTV Platinum 
> Mini2            14c0:1212
> [44494.391909] saa7134:   card=75 -> AVerMedia AVerTVHD MCE 
> A180              1461:1044
> [44494.391912] saa7134:   card=76 -> SKNet MonsterTV 
> Mobile                   1131:4ee9
> [44494.391915] saa7134:   card=77 -> Pinnacle PCTV 40i/50i/110i 
> (saa7133)     11bd:002e
> [44494.391918] saa7134:   card=78 -> ASUSTeK P7131 
> Dual                       1043:4862 1043:4857
> [44494.391922] saa7134:   card=79 -> Sedna/MuchTV PC TV Cardbus 
> TV/Radio (ITO
> [44494.391924] saa7134:   card=80 -> ASUS Digimatrix 
> TV                       1043:0210
> [44494.391928] saa7134:   card=81 -> Philips Tiger reference 
> design           1131:2018
> [44494.391931] saa7134:   card=82 -> MSI TV@Anywhere 
> plus                     1462:6231 1462:8624
> [44494.391935] saa7134:   card=83 -> Terratec Cinergy 250 PCI 
> TV              153b:1160
> [44494.391938] saa7134:   card=84 -> LifeView FlyDVB 
> Trio                     5168:0319
> [44494.391940] saa7134:   card=85 -> AverTV DVB-T 
> 777                         1461:2c05 1461:2c05
> [44494.391945] saa7134:   card=86 -> LifeView FlyDVB-T / Genius 
> VideoWonder D 5168:0301 1489:0301
> [44494.391948] saa7134:   card=87 -> ADS Instant TV Duo Cardbus 
> PTV331        0331:1421
> [44494.391951] saa7134:   card=88 -> Tevion/KWorld DVB-T 
> 220RF                17de:7201
> [44494.391954] saa7134:   card=89 -> ELSA EX-VISION 
> 700TV                     1048:226c
> [44494.391958] saa7134:   card=90 -> Kworld 
> ATSC110/115                       17de:7350 17de:7352
> [44494.391961] saa7134:   card=91 -> AVerMedia A169 
> B                         1461:7360
> [44494.391964] saa7134:   card=92 -> AVerMedia A169 
> B1                        1461:6360
> [44494.391967] saa7134:   card=93 -> Medion 7134 Bridge 
> #2                    16be:0005
> [44494.391970] saa7134:   card=94 -> LifeView FlyDVB-T Hybrid 
> Cardbus/MSI TV  5168:3306 5168:3502 5168:3307 4e42:3502
> [44494.391975] saa7134:   card=95 -> LifeView FlyVIDEO3000 
> (NTSC)             5169:0138
> [44494.391978] saa7134:   card=96 -> Medion Md8800 
> Quadro                     16be:0007 16be:0008 16be:000d
> [44494.391984] saa7134:   card=97 -> LifeView FlyDVB-S /Acorp 
> TV134DS         5168:0300 4e42:0300
> [44494.391987] saa7134:   card=98 -> Proteus Pro 
> 2309                         0919:2003
> [44494.391990] saa7134:   card=99 -> AVerMedia TV Hybrid 
> A16AR                1461:2c00
> [44494.391993] saa7134:   card=100 -> Asus Europa2 
> OEM                         1043:4860
> [44494.391996] saa7134:   card=101 -> Pinnacle PCTV 
> 310i                       11bd:002f
> [44494.392000] saa7134:   card=102 -> Avermedia AVerTV Studio 
> 507              1461:9715
> [44494.392002] saa7134:   card=103 -> Compro Videomate 
> DVB-T200A             
> [44494.392005] saa7134:   card=104 -> Hauppauge WinTV-HVR1110 
> DVB-T/Hybrid     0070:6700 0070:6701 0070:6702 0070:6703 0070:6704 
> 0070:6705
> [44494.392011] saa7134:   card=105 -> Terratec Cinergy HT 
> PCMCIA               153b:1172
> [44494.392014] saa7134:   card=106 -> Encore 
> ENLTV                             1131:2342 1131:2341 3016:2344
> [44494.392019] saa7134:   card=107 -> Encore 
> ENLTV-FM                          1131:230f
> [44494.392021] saa7134:   card=108 -> Terratec Cinergy HT 
> PCI                  153b:1175
> [44494.392025] saa7134:   card=109 -> Philips Tiger - S Reference 
> design     
> [44494.392027] saa7134:   card=110 -> Avermedia 
> M102                           1461:f31e
> [44494.392030] saa7134:   card=111 -> ASUS P7131 
> 4871                          1043:4871
> [44494.392034] saa7134:   card=112 -> ASUSTeK P7131 
> Hybrid                     1043:4876
> [44494.392037] saa7134:   card=113 -> Elitegroup ECS TVP3XP FM1246 
> Tuner Card  1019:4cb6
> [44494.392040] saa7134:   card=114 -> KWorld DVB-T 
> 210                         17de:7250
> [44494.392043] saa7134:   card=115 -> Sabrent PCMCIA 
> TV-PCB05                  0919:2003
> [44494.392046] saa7134:   card=116 -> 10MOONS TM300 TV 
> Card                    1131:2304
> [44494.392050] saa7134:   card=117 -> Avermedia Super 
> 007                      1461:f01d
> [44494.392052] saa7134:   card=118 -> Beholder BeholdTV 
> 401                    0000:4016
> [44494.392056] saa7134:   card=119 -> Beholder BeholdTV 
> 403                    0000:4036
> [44494.392059] saa7134:   card=120 -> Beholder BeholdTV 403 
> FM                 0000:4037
> [44494.392062] saa7134:   card=121 -> Beholder BeholdTV 
> 405                    0000:4050
> [44494.392065] saa7134:   card=122 -> Beholder BeholdTV 405 
> FM                 0000:4051
> [44494.392068] saa7134:   card=123 -> Beholder BeholdTV 
> 407                    0000:4070
> [44494.392071] saa7134:   card=124 -> Beholder BeholdTV 407 
> FM                 0000:4071
> [44494.392075] saa7134:   card=125 -> Beholder BeholdTV 
> 409                    0000:4090
> [44494.392077] saa7134:   card=126 -> Beholder BeholdTV 505 
> FM/RDS             0000:5051 0000:505b 5ace:5050
> [44494.392082] saa7134:   card=127 -> Beholder BeholdTV 507 FM/RDS / 
> BeholdTV  0000:5071 0000:507b 5ace:5070 5ace:5090
> [44494.392087] saa7134:   card=128 -> Beholder BeholdTV Columbus 
> TVFM          0000:5201
> [44494.392090] saa7134:   card=129 -> Beholder BeholdTV 607 / BeholdTV 
> 609     5ace:6070 5ace:6071 5ace:6072 5ace:6073 5ace:6090 5ace:6091 
> 5ace:6092 5ace:6093
> [44494.392097] saa7134:   card=130 -> Beholder BeholdTV 
> M6                     5ace:6190
> [44494.392100] saa7134:   card=131 -> Twinhan Hybrid DTV-DVB 3056 
> PCI          1822:0022
> [44494.392103] saa7134:   card=132 -> Genius TVGO 
> AM11MCE                    
> [44494.392106] saa7134:   card=133 -> NXP Snake DVB-S reference 
> design       
> [44494.392109] saa7134:   card=134 -> Medion/Creatix CTX953 
> Hybrid             16be:0010
> [44494.392111] saa7134:   card=135 -> MSI TV@nywhere A/D 
> v1.1                  1462:8625
> [44494.392115] saa7134:   card=136 -> AVerMedia Cardbus TV/Radio 
> (E506R)       1461:f436
> [44494.392118] saa7134:   card=137 -> AVerMedia Hybrid TV/Radio 
> (A16D)         1461:f936
> [44494.392122] saa7134:   card=138 -> Avermedia 
> M115                           1461:a836
> [44494.392126] saa7134:   card=139 -> Compro VideoMate 
> T750                    185b:c900
> [44494.392129] saa7134:   card=140 -> Avermedia DVB-S Pro 
> A700                 1461:a7a1
> [44494.392132] saa7134:   card=141 -> Avermedia DVB-S Hybrid+FM 
> A700           1461:a7a2
> [44494.392135] saa7134:   card=142 -> Beholder BeholdTV 
> H6                     5ace:6290
> [44494.392138] saa7134:   card=143 -> Beholder BeholdTV 
> M63                    5ace:6191
> [44494.392142] saa7134:   card=144 -> Beholder BeholdTV M6 
> Extra               5ace:6193
> [44494.392145] saa7134:   card=145 -> AOPVision AOP-8008A 16CH/240fps 
> Capture
> [44494.392147] saa7130[3]: subsystem: 1131:0000, board: 
> UNKNOWN/GENERIC [card=0,autodetected]
> [44494.392159] saa7130[3]: board init: gpio is 1ff0f
> [44494.495497] saa7130[3]: Huh, no eeprom present (err=-5)?
> [44494.495549] saa7130[3]: registered device video3 [v4l2]
> [44494.495566] saa7130[3]: registered device vbi3
> [44494.495593] saa7130[4]: found at 0000:04:0c.0, rev: 1, irq: 21, 
> latency: 64, mmio: 0xfebfec00
> [44494.495601] saa7134: <rant>
> [44494.495602] saa7134:  Congratulations!  Your TV card vendor saved a few
> [44494.495603] saa7134:  cents for a eeprom, thus your pci board has no
> [44494.495604] saa7134:  subsystem ID and I can't identify it 
> automatically
> [44494.495606] saa7134: </rant>
> [44494.495606] saa7134: I feel better now.  Ok, here are the good news:
> [44494.495608] saa7134: You can use the card=<nr> insmod option to specify
> [44494.495609] saa7134: which board do you have.  The list:
> [44494.495612] saa7134:   card=0 -> 
> UNKNOWN/GENERIC                        
> [44494.495614] saa7134:   card=1 -> Proteus Pro [philips reference 
> design]   1131:2001 1131:2001
> [44494.495619] saa7134:   card=2 -> LifeView 
> FlyVIDEO3000                    5168:0138 4e42:0138
> [44494.495622] saa7134:   card=3 -> LifeView/Typhoon 
> FlyVIDEO2000            5168:0138 4e42:0138
> [44494.495627] saa7134:   card=4 -> 
> EMPRESS                                  1131:6752
> [44494.495630] saa7134:   card=5 -> SKNet Monster 
> TV                         1131:4e85
> [44494.495633] saa7134:   card=6 -> Tevion MD 
> 9717                         
> [44494.495636] saa7134:   card=7 -> KNC One TV-Station RDS / Typhoon 
> TV Tune 1131:fe01 1894:fe01
> [44494.495640] saa7134:   card=8 -> Terratec Cinergy 400 
> TV                  153b:1142
> [44494.495643] saa7134:   card=9 -> Medion 
> 5044                            
> [44494.495645] saa7134:   card=10 -> Kworld/KuroutoShikou 
> SAA7130-TVPCI     
> [44494.495648] saa7134:   card=11 -> Terratec Cinergy 600 
> TV                  153b:1143
> [44494.495650] saa7134:   card=12 -> Medion 
> 7134                              16be:0003
> [44494.495653] saa7134:   card=13 -> Typhoon TV+Radio 
> 90031                 
> [44494.495656] saa7134:   card=14 -> ELSA EX-VISION 
> 300TV                     1048:226b
> [44494.495658] saa7134:   card=15 -> ELSA EX-VISION 
> 500TV                     1048:226a
> [44494.495661] saa7134:   card=16 -> ASUS TV-FM 
> 7134                          1043:4842 1043:4830 1043:4840
> [44494.495665] saa7134:   card=17 -> AOPEN VA1000 
> POWER                       1131:7133
> [44494.495668] saa7134:   card=18 -> BMK MPEX No 
> Tuner                      
> [44494.495670] saa7134:   card=19 -> Compro VideoMate 
> TV                      185b:c100
> [44494.495673] saa7134:   card=20 -> Matrox 
> CronosPlus                        102b:48d0
> [44494.495676] saa7134:   card=21 -> 10MOONS PCI TV CAPTURE 
> CARD              1131:2001
> [44494.495678] saa7134:   card=22 -> AverMedia M156 / Medion 
> 2819             1461:a70b
> [44494.495681] saa7134:   card=23 -> BMK MPEX 
> Tuner                         
> [44494.495683] saa7134:   card=24 -> KNC One TV-Station 
> DVR                   1894:a006
> [44494.495686] saa7134:   card=25 -> ASUS TV-FM 
> 7133                          1043:4843
> [44494.495689] saa7134:   card=26 -> Pinnacle PCTV Stereo 
> (saa7134)           11bd:002b
> [44494.495692] saa7134:   card=27 -> Manli MuchTV 
> M-TV002                   
> [44494.495694] saa7134:   card=28 -> Manli MuchTV 
> M-TV001                   
> [44494.495697] saa7134:   card=29 -> Nagase Sangyo TransGear 
> 3000TV           1461:050c
> [44494.495699] saa7134:   card=30 -> Elitegroup ECS TVP3XP FM1216 
> Tuner Card( 1019:4cb4
> [44494.495703] saa7134:   card=31 -> Elitegroup ECS TVP3XP FM1236 
> Tuner Card  1019:4cb5
> [44494.495706] saa7134:   card=32 -> AVACS 
> SmartTV                          
> [44494.495708] saa7134:   card=33 -> AVerMedia DVD 
> EZMaker                    1461:10ff
> [44494.495712] saa7134:   card=34 -> Noval Prime TV 
> 7133                    
> [44494.495714] saa7134:   card=35 -> AverMedia AverTV Studio 
> 305              1461:2115
> [44494.495717] saa7134:   card=36 -> UPMOST PURPLE 
> TV                         12ab:0800
> [44494.495720] saa7134:   card=37 -> Items MuchTV Plus / 
> IT-005             
> [44494.495723] saa7134:   card=38 -> Terratec Cinergy 200 
> TV                  153b:1152
> [44494.495726] saa7134:   card=39 -> LifeView FlyTV Platinum 
> Mini             5168:0212 4e42:0212 5169:1502
> [44494.495731] saa7134:   card=40 -> Compro VideoMate TV 
> PVR/FM               185b:c100
> [44494.495733] saa7134:   card=41 -> Compro VideoMate TV 
> Gold+                185b:c100
> [44494.495737] saa7134:   card=42 -> Sabrent SBT-TVFM 
> (saa7130)             
> [44494.495739] saa7134:   card=43 -> :Zolid Xpert 
> TV7134                    
> [44494.495741] saa7134:   card=44 -> Empire PCI TV-Radio 
> LE                 
> [44494.495744] saa7134:   card=45 -> Avermedia AVerTV Studio 
> 307              1461:9715
> [44494.495747] saa7134:   card=46 -> AVerMedia Cardbus TV/Radio 
> (E500)        1461:d6ee
> [44494.495750] saa7134:   card=47 -> Terratec Cinergy 400 
> mobile              153b:1162
> [44494.495754] saa7134:   card=48 -> Terratec Cinergy 600 TV 
> MK3              153b:1158
> [44494.495757] saa7134:   card=49 -> Compro VideoMate Gold+ 
> Pal               185b:c200
> [44494.495760] saa7134:   card=50 -> Pinnacle PCTV 300i DVB-T + 
> PAL           11bd:002d
> [44494.495763] saa7134:   card=51 -> ProVideo 
> PV952                           1540:9524
> [44494.495766] saa7134:   card=52 -> AverMedia 
> AverTV/305                     1461:2108
> [44494.495770] saa7134:   card=53 -> ASUS TV-FM 
> 7135                          1043:4845
> [44494.495773] saa7134:   card=54 -> LifeView FlyTV Platinum FM / 
> Gold        5168:0214 5168:5214 1489:0214 5168:0304
> [44494.495779] saa7134:   card=55 -> LifeView FlyDVB-T DUO / MSI 
> TV@nywhere D 5168:0306 4e42:0306
> [44494.495782] saa7134:   card=56 -> Avermedia AVerTV 
> 307                     1461:a70a
> [44494.495786] saa7134:   card=57 -> Avermedia AVerTV GO 007 
> FM               1461:f31f
> [44494.495789] saa7134:   card=58 -> ADS Tech Instant TV 
> (saa7135)            1421:0350 1421:0351 1421:0370 1421:1370
> [44494.495794] saa7134:   card=59 -> Kworld/Tevion V-Stream Xpert TV 
> PVR7134
> [44494.495796] saa7134:   card=60 -> LifeView/Typhoon/Genius FlyDVB-T 
> Duo Car 5168:0502 4e42:0502 1489:0502
> [44494.495801] saa7134:   card=61 -> Philips TOUGH DVB-T reference 
> design     1131:2004
> [44494.495804] saa7134:   card=62 -> Compro VideoMate TV 
> Gold+II            
> [44494.495806] saa7134:   card=63 -> Kworld Xpert TV 
> PVR7134                
> [44494.495809] saa7134:   card=64 -> FlyTV mini Asus 
> Digimatrix               1043:0210
> [44494.495812] saa7134:   card=65 -> V-Stream Studio TV 
> Terminator          
> [44494.495814] saa7134:   card=66 -> Yuan TUN-900 
> (saa7135)                 
> [44494.495818] saa7134:   card=67 -> Beholder BeholdTV 409 
> FM                 0000:4091
> [44494.495821] saa7134:   card=68 -> GoTView 7135 
> PCI                         5456:7135
> [44494.495823] saa7134:   card=69 -> Philips EUROPA V3 reference 
> design       1131:2004
> [44494.495827] saa7134:   card=70 -> Compro Videomate 
> DVB-T300                185b:c900
> [44494.495830] saa7134:   card=71 -> Compro Videomate 
> DVB-T200                185b:c901
> [44494.495834] saa7134:   card=72 -> RTD Embedded Technologies 
> VFG7350        1435:7350
> [44494.495837] saa7134:   card=73 -> RTD Embedded Technologies 
> VFG7330        1435:7330
> [44494.495840] saa7134:   card=74 -> LifeView FlyTV Platinum 
> Mini2            14c0:1212
> [44494.495844] saa7134:   card=75 -> AVerMedia AVerTVHD MCE 
> A180              1461:1044
> [44494.495848] saa7134:   card=76 -> SKNet MonsterTV 
> Mobile                   1131:4ee9
> [44494.495850] saa7134:   card=77 -> Pinnacle PCTV 40i/50i/110i 
> (saa7133)     11bd:002e
> [44494.495854] saa7134:   card=78 -> ASUSTeK P7131 
> Dual                       1043:4862 1043:4857
> [44494.495857] saa7134:   card=79 -> Sedna/MuchTV PC TV Cardbus 
> TV/Radio (ITO
> [44494.495859] saa7134:   card=80 -> ASUS Digimatrix 
> TV                       1043:0210
> [44494.495863] saa7134:   card=81 -> Philips Tiger reference 
> design           1131:2018
> [44494.495866] saa7134:   card=82 -> MSI TV@Anywhere 
> plus                     1462:6231 1462:8624
> [44494.495871] saa7134:   card=83 -> Terratec Cinergy 250 PCI 
> TV              153b:1160
> [44494.495873] saa7134:   card=84 -> LifeView FlyDVB 
> Trio                     5168:0319
> [44494.495876] saa7134:   card=85 -> AverTV DVB-T 
> 777                         1461:2c05 1461:2c05
> [44494.495880] saa7134:   card=86 -> LifeView FlyDVB-T / Genius 
> VideoWonder D 5168:0301 1489:0301
> [44494.495884] saa7134:   card=87 -> ADS Instant TV Duo Cardbus 
> PTV331        0331:1421
> [44494.495887] saa7134:   card=88 -> Tevion/KWorld DVB-T 
> 220RF                17de:7201
> [44494.495890] saa7134:   card=89 -> ELSA EX-VISION 
> 700TV                     1048:226c
> [44494.495894] saa7134:   card=90 -> Kworld 
> ATSC110/115                       17de:7350 17de:7352
> [44494.495897] saa7134:   card=91 -> AVerMedia A169 
> B                         1461:7360
> [44494.495900] saa7134:   card=92 -> AVerMedia A169 
> B1                        1461:6360
> [44494.495903] saa7134:   card=93 -> Medion 7134 Bridge 
> #2                    16be:0005
> [44494.495906] saa7134:   card=94 -> LifeView FlyDVB-T Hybrid 
> Cardbus/MSI TV  5168:3306 5168:3502 5168:3307 4e42:3502
> [44494.495912] saa7134:   card=95 -> LifeView FlyVIDEO3000 
> (NTSC)             5169:0138
> [44494.495915] saa7134:   card=96 -> Medion Md8800 
> Quadro                     16be:0007 16be:0008 16be:000d
> [44494.495920] saa7134:   card=97 -> LifeView FlyDVB-S /Acorp 
> TV134DS         5168:0300 4e42:0300
> [44494.495924] saa7134:   card=98 -> Proteus Pro 
> 2309                         0919:2003
> [44494.495926] saa7134:   card=99 -> AVerMedia TV Hybrid 
> A16AR                1461:2c00
> [44494.495930] saa7134:   card=100 -> Asus Europa2 
> OEM                         1043:4860
> [44494.495933] saa7134:   card=101 -> Pinnacle PCTV 
> 310i                       11bd:002f
> [44494.495937] saa7134:   card=102 -> Avermedia AVerTV Studio 
> 507              1461:9715
> [44494.495940] saa7134:   card=103 -> Compro Videomate 
> DVB-T200A             
> [44494.495942] saa7134:   card=104 -> Hauppauge WinTV-HVR1110 
> DVB-T/Hybrid     0070:6700 0070:6701 0070:6702 0070:6703 0070:6704 
> 0070:6705
> [44494.495948] saa7134:   card=105 -> Terratec Cinergy HT 
> PCMCIA               153b:1172
> [44494.495951] saa7134:   card=106 -> Encore 
> ENLTV                             1131:2342 1131:2341 3016:2344
> [44494.495956] saa7134:   card=107 -> Encore 
> ENLTV-FM                          1131:230f
> [44494.495958] saa7134:   card=108 -> Terratec Cinergy HT 
> PCI                  153b:1175
> [44494.495962] saa7134:   card=109 -> Philips Tiger - S Reference 
> design     
> [44494.495965] saa7134:   card=110 -> Avermedia 
> M102                           1461:f31e
> [44494.495967] saa7134:   card=111 -> ASUS P7131 
> 4871                          1043:4871
> [44494.495971] saa7134:   card=112 -> ASUSTeK P7131 
> Hybrid                     1043:4876
> [44494.495974] saa7134:   card=113 -> Elitegroup ECS TVP3XP FM1246 
> Tuner Card  1019:4cb6
> [44494.495977] saa7134:   card=114 -> KWorld DVB-T 
> 210                         17de:7250
> [44494.495981] saa7134:   card=115 -> Sabrent PCMCIA 
> TV-PCB05                  0919:2003
> [44494.495983] saa7134:   card=116 -> 10MOONS TM300 TV 
> Card                    1131:2304
> [44494.495987] saa7134:   card=117 -> Avermedia Super 
> 007                      1461:f01d
> [44494.495990] saa7134:   card=118 -> Beholder BeholdTV 
> 401                    0000:4016
> [44494.495993] saa7134:   card=119 -> Beholder BeholdTV 
> 403                    0000:4036
> [44494.495996] saa7134:   card=120 -> Beholder BeholdTV 403 
> FM                 0000:4037
> [44494.495999] saa7134:   card=121 -> Beholder BeholdTV 
> 405                    0000:4050
> [44494.496002] saa7134:   card=122 -> Beholder BeholdTV 405 
> FM                 0000:4051
> [44494.496006] saa7134:   card=123 -> Beholder BeholdTV 
> 407                    0000:4070
> [44494.496008] saa7134:   card=124 -> Beholder BeholdTV 407 
> FM                 0000:4071
> [44494.496011] saa7134:   card=125 -> Beholder BeholdTV 
> 409                    0000:4090
> [44494.496015] saa7134:   card=126 -> Beholder BeholdTV 505 
> FM/RDS             0000:5051 0000:505b 5ace:5050
> [44494.496019] saa7134:   card=127 -> Beholder BeholdTV 507 FM/RDS / 
> BeholdTV  0000:5071 0000:507b 5ace:5070 5ace:5090
> [44494.496024] saa7134:   card=128 -> Beholder BeholdTV Columbus 
> TVFM          0000:5201
> [44494.496026] saa7134:   card=129 -> Beholder BeholdTV 607 / BeholdTV 
> 609     5ace:6070 5ace:6071 5ace:6072 5ace:6073 5ace:6090 5ace:6091 
> 5ace:6092 5ace:6093
> [44494.496034] saa7134:   card=130 -> Beholder BeholdTV 
> M6                     5ace:6190
> [44494.496037] saa7134:   card=131 -> Twinhan Hybrid DTV-DVB 3056 
> PCI          1822:0022
> [44494.496040] saa7134:   card=132 -> Genius TVGO 
> AM11MCE                    
> [44494.496042] saa7134:   card=133 -> NXP Snake DVB-S reference 
> design       
> [44494.496046] saa7134:   card=134 -> Medion/Creatix CTX953 
> Hybrid             16be:0010
> [44494.496048] saa7134:   card=135 -> MSI TV@nywhere A/D 
> v1.1                  1462:8625
> [44494.496051] saa7134:   card=136 -> AVerMedia Cardbus TV/Radio 
> (E506R)       1461:f436
> [44494.496055] saa7134:   card=137 -> AVerMedia Hybrid TV/Radio 
> (A16D)         1461:f936
> [44494.496058] saa7134:   card=138 -> Avermedia 
> M115                           1461:a836
> [44494.496061] saa7134:   card=139 -> Compro VideoMate 
> T750                    185b:c900
> [44494.496064] saa7134:   card=140 -> Avermedia DVB-S Pro 
> A700                 1461:a7a1
> [44494.496067] saa7134:   card=141 -> Avermedia DVB-S Hybrid+FM 
> A700           1461:a7a2
> [44494.496071] saa7134:   card=142 -> Beholder BeholdTV 
> H6                     5ace:6290
> [44494.496074] saa7134:   card=143 -> Beholder BeholdTV 
> M63                    5ace:6191
> [44494.496077] saa7134:   card=144 -> Beholder BeholdTV M6 
> Extra               5ace:6193
> [44494.496080] saa7134:   card=145 -> AOPVision AOP-8008A 16CH/240fps 
> Capture
> [44494.496083] saa7130[4]: subsystem: 1131:0000, board: 
> UNKNOWN/GENERIC [card=0,autodetected]
> [44494.496098] saa7130[4]: board init: gpio is 10000
> [44494.599435] saa7130[4]: Huh, no eeprom present (err=-5)?
> [44494.599487] saa7130[4]: registered device video4 [v4l2]
> [44494.599503] saa7130[4]: registered device vbi4
> [44494.599530] saa7130[5]: found at 0000:04:0d.0, rev: 1, irq: 22, 
> latency: 64, mmio: 0xfebfe800
> [44494.599540] saa7134: <rant>
> [44494.599541] saa7134:  Congratulations!  Your TV card vendor saved a few
> [44494.599542] saa7134:  cents for a eeprom, thus your pci board has no
> [44494.599543] saa7134:  subsystem ID and I can't identify it 
> automatically
> [44494.599544] saa7134: </rant>
> [44494.599545] saa7134: I feel better now.  Ok, here are the good news:
> [44494.599546] saa7134: You can use the card=<nr> insmod option to specify
> [44494.599547] saa7134: which board do you have.  The list:
> [44494.599550] saa7134:   card=0 -> 
> UNKNOWN/GENERIC                        
> [44494.599553] saa7134:   card=1 -> Proteus Pro [philips reference 
> design]   1131:2001 1131:2001
> [44494.599558] saa7134:   card=2 -> LifeView 
> FlyVIDEO3000                    5168:0138 4e42:0138
> [44494.599561] saa7134:   card=3 -> LifeView/Typhoon 
> FlyVIDEO2000            5168:0138 4e42:0138
> [44494.599565] saa7134:   card=4 -> 
> EMPRESS                                  1131:6752
> [44494.599568] saa7134:   card=5 -> SKNet Monster 
> TV                         1131:4e85
> [44494.599570] saa7134:   card=6 -> Tevion MD 
> 9717                         
> [44494.599574] saa7134:   card=7 -> KNC One TV-Station RDS / Typhoon 
> TV Tune 1131:fe01 1894:fe01
> [44494.599577] saa7134:   card=8 -> Terratec Cinergy 400 
> TV                  153b:1142
> [44494.599581] saa7134:   card=9 -> Medion 
> 5044                            
> [44494.599583] saa7134:   card=10 -> Kworld/KuroutoShikou 
> SAA7130-TVPCI     
> [44494.599585] saa7134:   card=11 -> Terratec Cinergy 600 
> TV                  153b:1143
> [44494.599590] saa7134:   card=12 -> Medion 
> 7134                              16be:0003
> [44494.599592] saa7134:   card=13 -> Typhoon TV+Radio 
> 90031                 
> [44494.599595] saa7134:   card=14 -> ELSA EX-VISION 
> 300TV                     1048:226b
> [44494.599599] saa7134:   card=15 -> ELSA EX-VISION 
> 500TV                     1048:226a
> [44494.599601] saa7134:   card=16 -> ASUS TV-FM 
> 7134                          1043:4842 1043:4830 1043:4840
> [44494.599607] saa7134:   card=17 -> AOPEN VA1000 
> POWER                       1131:7133
> [44494.599609] saa7134:   card=18 -> BMK MPEX No 
> Tuner                      
> [44494.599612] saa7134:   card=19 -> Compro VideoMate 
> TV                      185b:c100
> [44494.599616] saa7134:   card=20 -> Matrox 
> CronosPlus                        102b:48d0
> [44494.599619] saa7134:   card=21 -> 10MOONS PCI TV CAPTURE 
> CARD              1131:2001
> [44494.599622] saa7134:   card=22 -> AverMedia M156 / Medion 
> 2819             1461:a70b
> [44494.599625] saa7134:   card=23 -> BMK MPEX 
> Tuner                         
> [44494.599627] saa7134:   card=24 -> KNC One TV-Station 
> DVR                   1894:a006
> [44494.599631] saa7134:   card=25 -> ASUS TV-FM 
> 7133                          1043:4843
> [44494.599634] saa7134:   card=26 -> Pinnacle PCTV Stereo 
> (saa7134)           11bd:002b
> [44494.599637] saa7134:   card=27 -> Manli MuchTV 
> M-TV002                   
> [44494.599640] saa7134:   card=28 -> Manli MuchTV 
> M-TV001                   
> [44494.599642] saa7134:   card=29 -> Nagase Sangyo TransGear 
> 3000TV           1461:050c
> [44494.599646] saa7134:   card=30 -> Elitegroup ECS TVP3XP FM1216 
> Tuner Card( 1019:4cb4
> [44494.599649] saa7134:   card=31 -> Elitegroup ECS TVP3XP FM1236 
> Tuner Card  1019:4cb5
> [44494.599653] saa7134:   card=32 -> AVACS 
> SmartTV                          
> [44494.599655] saa7134:   card=33 -> AVerMedia DVD 
> EZMaker                    1461:10ff
> [44494.599658] saa7134:   card=34 -> Noval Prime TV 
> 7133                    
> [44494.599661] saa7134:   card=35 -> AverMedia AverTV Studio 
> 305              1461:2115
> [44494.599664] saa7134:   card=36 -> UPMOST PURPLE 
> TV                         12ab:0800
> [44494.599667] saa7134:   card=37 -> Items MuchTV Plus / 
> IT-005             
> [44494.599670] saa7134:   card=38 -> Terratec Cinergy 200 
> TV                  153b:1152
> [44494.599673] saa7134:   card=39 -> LifeView FlyTV Platinum 
> Mini             5168:0212 4e42:0212 5169:1502
> [44494.599677] saa7134:   card=40 -> Compro VideoMate TV 
> PVR/FM               185b:c100
> [44494.599680] saa7134:   card=41 -> Compro VideoMate TV 
> Gold+                185b:c100
> [44494.599683] saa7134:   card=42 -> Sabrent SBT-TVFM 
> (saa7130)             
> [44494.599686] saa7134:   card=43 -> :Zolid Xpert 
> TV7134                    
> [44494.599688] saa7134:   card=44 -> Empire PCI TV-Radio 
> LE                 
> [44494.599691] saa7134:   card=45 -> Avermedia AVerTV Studio 
> 307              1461:9715
> [44494.599695] saa7134:   card=46 -> AVerMedia Cardbus TV/Radio 
> (E500)        1461:d6ee
> [44494.599697] saa7134:   card=47 -> Terratec Cinergy 400 
> mobile              153b:1162
> [44494.599701] saa7134:   card=48 -> Terratec Cinergy 600 TV 
> MK3              153b:1158
> [44494.599705] saa7134:   card=49 -> Compro VideoMate Gold+ 
> Pal               185b:c200
> [44494.599707] saa7134:   card=50 -> Pinnacle PCTV 300i DVB-T + 
> PAL           11bd:002d
> [44494.599711] saa7134:   card=51 -> ProVideo 
> PV952                           1540:9524
> [44494.599714] saa7134:   card=52 -> AverMedia 
> AverTV/305                     1461:2108
> [44494.599717] saa7134:   card=53 -> ASUS TV-FM 
> 7135                          1043:4845
> [44494.599721] saa7134:   card=54 -> LifeView FlyTV Platinum FM / 
> Gold        5168:0214 5168:5214 1489:0214 5168:0304
> [44494.599725] saa7134:   card=55 -> LifeView FlyDVB-T DUO / MSI 
> TV@nywhere D 5168:0306 4e42:0306
> [44494.599729] saa7134:   card=56 -> Avermedia AVerTV 
> 307                     1461:a70a
> [44494.599732] saa7134:   card=57 -> Avermedia AVerTV GO 007 
> FM               1461:f31f
> [44494.599736] saa7134:   card=58 -> ADS Tech Instant TV 
> (saa7135)            1421:0350 1421:0351 1421:0370 1421:1370
> [44494.599740] saa7134:   card=59 -> Kworld/Tevion V-Stream Xpert TV 
> PVR7134
> [44494.599743] saa7134:   card=60 -> LifeView/Typhoon/Genius FlyDVB-T 
> Duo Car 5168:0502 4e42:0502 1489:0502
> [44494.599747] saa7134:   card=61 -> Philips TOUGH DVB-T reference 
> design     1131:2004
> [44494.599751] saa7134:   card=62 -> Compro VideoMate TV 
> Gold+II            
> [44494.599753] saa7134:   card=63 -> Kworld Xpert TV 
> PVR7134                
> [44494.599756] saa7134:   card=64 -> FlyTV mini Asus 
> Digimatrix               1043:0210
> [44494.599760] saa7134:   card=65 -> V-Stream Studio TV 
> Terminator          
> [44494.599762] saa7134:   card=66 -> Yuan TUN-900 
> (saa7135)                 
> [44494.599764] saa7134:   card=67 -> Beholder BeholdTV 409 
> FM                 0000:4091
> [44494.599768] saa7134:   card=68 -> GoTView 7135 
> PCI                         5456:7135
> [44494.599771] saa7134:   card=69 -> Philips EUROPA V3 reference 
> design       1131:2004
> [44494.599775] saa7134:   card=70 -> Compro Videomate 
> DVB-T300                185b:c900
> [44494.599777] saa7134:   card=71 -> Compro Videomate 
> DVB-T200                185b:c901
> [44494.599780] saa7134:   card=72 -> RTD Embedded Technologies 
> VFG7350        1435:7350
> [44494.599784] saa7134:   card=73 -> RTD Embedded Technologies 
> VFG7330        1435:7330
> [44494.599787] saa7134:   card=74 -> LifeView FlyTV Platinum 
> Mini2            14c0:1212
> [44494.599790] saa7134:   card=75 -> AVerMedia AVerTVHD MCE 
> A180              1461:1044
> [44494.599793] saa7134:   card=76 -> SKNet MonsterTV 
> Mobile                   1131:4ee9
> [44494.599796] saa7134:   card=77 -> Pinnacle PCTV 40i/50i/110i 
> (saa7133)     11bd:002e
> [44494.599800] saa7134:   card=78 -> ASUSTeK P7131 
> Dual                       1043:4862 1043:4857
> [44494.599803] saa7134:   card=79 -> Sedna/MuchTV PC TV Cardbus 
> TV/Radio (ITO
> [44494.599806] saa7134:   card=80 -> ASUS Digimatrix 
> TV                       1043:0210
> [44494.599809] saa7134:   card=81 -> Philips Tiger reference 
> design           1131:2018
> [44494.599812] saa7134:   card=82 -> MSI TV@Anywhere 
> plus                     1462:6231 1462:8624
> [44494.599816] saa7134:   card=83 -> Terratec Cinergy 250 PCI 
> TV              153b:1160
> [44494.599819] saa7134:   card=84 -> LifeView FlyDVB 
> Trio                     5168:0319
> [44494.599823] saa7134:   card=85 -> AverTV DVB-T 
> 777                         1461:2c05 1461:2c05
> [44494.599826] saa7134:   card=86 -> LifeView FlyDVB-T / Genius 
> VideoWonder D 5168:0301 1489:0301
> [44494.599831] saa7134:   card=87 -> ADS Instant TV Duo Cardbus 
> PTV331        0331:1421
> [44494.599834] saa7134:   card=88 -> Tevion/KWorld DVB-T 
> 220RF                17de:7201
> [44494.599836] saa7134:   card=89 -> ELSA EX-VISION 
> 700TV                     1048:226c
> [44494.599840] saa7134:   card=90 -> Kworld 
> ATSC110/115                       17de:7350 17de:7352
> [44494.599843] saa7134:   card=91 -> AVerMedia A169 
> B                         1461:7360
> [44494.599847] saa7134:   card=92 -> AVerMedia A169 
> B1                        1461:6360
> [44494.599850] saa7134:   card=93 -> Medion 7134 Bridge 
> #2                    16be:0005
> [44494.599853] saa7134:   card=94 -> LifeView FlyDVB-T Hybrid 
> Cardbus/MSI TV  5168:3306 5168:3502 5168:3307 4e42:3502
> [44494.599858] saa7134:   card=95 -> LifeView FlyVIDEO3000 
> (NTSC)             5169:0138
> [44494.599861] saa7134:   card=96 -> Medion Md8800 
> Quadro                     16be:0007 16be:0008 16be:000d
> [44494.599866] saa7134:   card=97 -> LifeView FlyDVB-S /Acorp 
> TV134DS         5168:0300 4e42:0300
> [44494.599869] saa7134:   card=98 -> Proteus Pro 
> 2309                         0919:2003
> [44494.599873] saa7134:   card=99 -> AVerMedia TV Hybrid 
> A16AR                1461:2c00
> [44494.599876] saa7134:   card=100 -> Asus Europa2 
> OEM                         1043:4860
> [44494.599879] saa7134:   card=101 -> Pinnacle PCTV 
> 310i                       11bd:002f
> [44494.599882] saa7134:   card=102 -> Avermedia AVerTV Studio 
> 507              1461:9715
> [44494.599885] saa7134:   card=103 -> Compro Videomate 
> DVB-T200A             
> [44494.599888] saa7134:   card=104 -> Hauppauge WinTV-HVR1110 
> DVB-T/Hybrid     0070:6700 0070:6701 0070:6702 0070:6703 0070:6704 
> 0070:6705
> [44494.599893] saa7134:   card=105 -> Terratec Cinergy HT 
> PCMCIA               153b:1172
> [44494.599898] saa7134:   card=106 -> Encore 
> ENLTV                             1131:2342 1131:2341 3016:2344
> [44494.599901] saa7134:   card=107 -> Encore 
> ENLTV-FM                          1131:230f
> [44494.599905] saa7134:   card=108 -> Terratec Cinergy HT 
> PCI                  153b:1175
> [44494.599908] saa7134:   card=109 -> Philips Tiger - S Reference 
> design     
> [44494.599910] saa7134:   card=110 -> Avermedia 
> M102                           1461:f31e
> [44494.599914] saa7134:   card=111 -> ASUS P7131 
> 4871                          1043:4871
> [44494.599917] saa7134:   card=112 -> ASUSTeK P7131 
> Hybrid                     1043:4876
> [44494.599920] saa7134:   card=113 -> Elitegroup ECS TVP3XP FM1246 
> Tuner Card  1019:4cb6
> [44494.599923] saa7134:   card=114 -> KWorld DVB-T 
> 210                         17de:7250
> [44494.599926] saa7134:   card=115 -> Sabrent PCMCIA 
> TV-PCB05                  0919:2003
> [44494.599929] saa7134:   card=116 -> 10MOONS TM300 TV 
> Card                    1131:2304
> [44494.599932] saa7134:   card=117 -> Avermedia Super 
> 007                      1461:f01d
> [44494.599935] saa7134:   card=118 -> Beholder BeholdTV 
> 401                    0000:4016
> [44494.599939] saa7134:   card=119 -> Beholder BeholdTV 
> 403                    0000:4036
> [44494.599942] saa7134:   card=120 -> Beholder BeholdTV 403 
> FM                 0000:4037
> [44494.599945] saa7134:   card=121 -> Beholder BeholdTV 
> 405                    0000:4050
> [44494.599948] saa7134:   card=122 -> Beholder BeholdTV 405 
> FM                 0000:4051
> [44494.599951] saa7134:   card=123 -> Beholder BeholdTV 
> 407                    0000:4070
> [44494.599954] saa7134:   card=124 -> Beholder BeholdTV 407 
> FM                 0000:4071
> [44494.599957] saa7134:   card=125 -> Beholder BeholdTV 
> 409                    0000:4090
> [44494.599960] saa7134:   card=126 -> Beholder BeholdTV 505 
> FM/RDS             0000:5051 0000:505b 5ace:5050
> [44494.599965] saa7134:   card=127 -> Beholder BeholdTV 507 FM/RDS / 
> BeholdTV  0000:5071 0000:507b 5ace:5070 5ace:5090
> [44494.599969] saa7134:   card=128 -> Beholder BeholdTV Columbus 
> TVFM          0000:5201
> [44494.599973] saa7134:   card=129 -> Beholder BeholdTV 607 / BeholdTV 
> 609     5ace:6070 5ace:6071 5ace:6072 5ace:6073 5ace:6090 5ace:6091 
> 5ace:6092 5ace:6093
> [44494.599980] saa7134:   card=130 -> Beholder BeholdTV 
> M6                     5ace:6190
> [44494.599983] saa7134:   card=131 -> Twinhan Hybrid DTV-DVB 3056 
> PCI          1822:0022
> [44494.599986] saa7134:   card=132 -> Genius TVGO 
> AM11MCE                    
> [44494.599989] saa7134:   card=133 -> NXP Snake DVB-S reference 
> design       
> [44494.599991] saa7134:   card=134 -> Medion/Creatix CTX953 
> Hybrid             16be:0010
> [44494.599994] saa7134:   card=135 -> MSI TV@nywhere A/D 
> v1.1                  1462:8625
> [44494.599998] saa7134:   card=136 -> AVerMedia Cardbus TV/Radio 
> (E506R)       1461:f436
> [44494.600001] saa7134:   card=137 -> AVerMedia Hybrid TV/Radio 
> (A16D)         1461:f936
> [44494.600005] saa7134:   card=138 -> Avermedia 
> M115                           1461:a836
> [44494.600008] saa7134:   card=139 -> Compro VideoMate 
> T750                    185b:c900
> [44494.600011] saa7134:   card=140 -> Avermedia DVB-S Pro 
> A700                 1461:a7a1
> [44494.600015] saa7134:   card=141 -> Avermedia DVB-S Hybrid+FM 
> A700           1461:a7a2
> [44494.600017] saa7134:   card=142 -> Beholder BeholdTV 
> H6                     5ace:6290
> [44494.600020] saa7134:   card=143 -> Beholder BeholdTV 
> M63                    5ace:6191
> [44494.600024] saa7134:   card=144 -> Beholder BeholdTV M6 
> Extra               5ace:6193
> [44494.600027] saa7134:   card=145 -> AOPVision AOP-8008A 16CH/240fps 
> Capture
> [44494.600030] saa7130[5]: subsystem: 1131:0000, board: 
> UNKNOWN/GENERIC [card=0,autodetected]
> [44494.600045] saa7130[5]: board init: gpio is 10000
> [44494.703379] saa7130[5]: Huh, no eeprom present (err=-5)?
> [44494.703433] saa7130[5]: registered device video5 [v4l2]
> [44494.703450] saa7130[5]: registered device vbi5
> [44494.703478] saa7130[6]: found at 0000:04:0e.0, rev: 1, irq: 20, 
> latency: 64, mmio: 0xfebfe400
> [44494.703488] saa7134: <rant>
> [44494.703489] saa7134:  Congratulations!  Your TV card vendor saved a few
> [44494.703490] saa7134:  cents for a eeprom, thus your pci board has no
> [44494.703491] saa7134:  subsystem ID and I can't identify it 
> automatically
> [44494.703492] saa7134: </rant>
> [44494.703493] saa7134: I feel better now.  Ok, here are the good news:
> [44494.703494] saa7134: You can use the card=<nr> insmod option to specify
> [44494.703495] saa7134: which board do you have.  The list:
> [44494.703498] saa7134:   card=0 -> 
> UNKNOWN/GENERIC                        
> [44494.703501] saa7134:   card=1 -> Proteus Pro [philips reference 
> design]   1131:2001 1131:2001
> [44494.703505] saa7134:   card=2 -> LifeView 
> FlyVIDEO3000                    5168:0138 4e42:0138
> [44494.703509] saa7134:   card=3 -> LifeView/Typhoon 
> FlyVIDEO2000            5168:0138 4e42:0138
> [44494.703513] saa7134:   card=4 -> 
> EMPRESS                                  1131:6752
> [44494.703516] saa7134:   card=5 -> SKNet Monster 
> TV                         1131:4e85
> [44494.703519] saa7134:   card=6 -> Tevion MD 
> 9717                         
> [44494.703522] saa7134:   card=7 -> KNC One TV-Station RDS / Typhoon 
> TV Tune 1131:fe01 1894:fe01
> [44494.703525] saa7134:   card=8 -> Terratec Cinergy 400 
> TV                  153b:1142
> [44494.703529] saa7134:   card=9 -> Medion 
> 5044                            
> [44494.703531] saa7134:   card=10 -> Kworld/KuroutoShikou 
> SAA7130-TVPCI     
> [44494.703533] saa7134:   card=11 -> Terratec Cinergy 600 
> TV                  153b:1143
> [44494.703538] saa7134:   card=12 -> Medion 
> 7134                              16be:0003
> [44494.703540] saa7134:   card=13 -> Typhoon TV+Radio 
> 90031                 
> [44494.703543] saa7134:   card=14 -> ELSA EX-VISION 
> 300TV                     1048:226b
> [44494.703547] saa7134:   card=15 -> ELSA EX-VISION 
> 500TV                     1048:226a
> [44494.703549] saa7134:   card=16 -> ASUS TV-FM 
> 7134                          1043:4842 1043:4830 1043:4840
> [44494.703555] saa7134:   card=17 -> AOPEN VA1000 
> POWER                       1131:7133
> [44494.703557] saa7134:   card=18 -> BMK MPEX No 
> Tuner                      
> [44494.703560] saa7134:   card=19 -> Compro VideoMate 
> TV                      185b:c100
> [44494.703564] saa7134:   card=20 -> Matrox 
> CronosPlus                        102b:48d0
> [44494.703567] saa7134:   card=21 -> 10MOONS PCI TV CAPTURE 
> CARD              1131:2001
> [44494.703570] saa7134:   card=22 -> AverMedia M156 / Medion 
> 2819             1461:a70b
> [44494.703573] saa7134:   card=23 -> BMK MPEX 
> Tuner                         
> [44494.703576] saa7134:   card=24 -> KNC One TV-Station 
> DVR                   1894:a006
> [44494.703580] saa7134:   card=25 -> ASUS TV-FM 
> 7133                          1043:4843
> [44494.703582] saa7134:   card=26 -> Pinnacle PCTV Stereo 
> (saa7134)           11bd:002b
> [44494.703586] saa7134:   card=27 -> Manli MuchTV 
> M-TV002                   
> [44494.703588] saa7134:   card=28 -> Manli MuchTV 
> M-TV001                   
> [44494.703590] saa7134:   card=29 -> Nagase Sangyo TransGear 
> 3000TV           1461:050c
> [44494.703594] saa7134:   card=30 -> Elitegroup ECS TVP3XP FM1216 
> Tuner Card( 1019:4cb4
> [44494.703597] saa7134:   card=31 -> Elitegroup ECS TVP3XP FM1236 
> Tuner Card  1019:4cb5
> [44494.703601] saa7134:   card=32 -> AVACS 
> SmartTV                          
> [44494.703603] saa7134:   card=33 -> AVerMedia DVD 
> EZMaker                    1461:10ff
> [44494.703606] saa7134:   card=34 -> Noval Prime TV 
> 7133                    
> [44494.703609] saa7134:   card=35 -> AverMedia AverTV Studio 
> 305              1461:2115
> [44494.703612] saa7134:   card=36 -> UPMOST PURPLE 
> TV                         12ab:0800
> [44494.703615] saa7134:   card=37 -> Items MuchTV Plus / 
> IT-005             
> [44494.703618] saa7134:   card=38 -> Terratec Cinergy 200 
> TV                  153b:1152
> [44494.703621] saa7134:   card=39 -> LifeView FlyTV Platinum 
> Mini             5168:0212 4e42:0212 5169:1502
> [44494.703626] saa7134:   card=40 -> Compro VideoMate TV 
> PVR/FM               185b:c100
> [44494.703628] saa7134:   card=41 -> Compro VideoMate TV 
> Gold+                185b:c100
> [44494.703631] saa7134:   card=42 -> Sabrent SBT-TVFM 
> (saa7130)             
> [44494.703634] saa7134:   card=43 -> :Zolid Xpert 
> TV7134                    
> [44494.703637] saa7134:   card=44 -> Empire PCI TV-Radio 
> LE                 
> [44494.703639] saa7134:   card=45 -> Avermedia AVerTV Studio 
> 307              1461:9715
> [44494.703643] saa7134:   card=46 -> AVerMedia Cardbus TV/Radio 
> (E500)        1461:d6ee
> [44494.703646] saa7134:   card=47 -> Terratec Cinergy 400 
> mobile              153b:1162
> [44494.703649] saa7134:   card=48 -> Terratec Cinergy 600 TV 
> MK3              153b:1158
> [44494.703652] saa7134:   card=49 -> Compro VideoMate Gold+ 
> Pal               185b:c200
> [44494.703655] saa7134:   card=50 -> Pinnacle PCTV 300i DVB-T + 
> PAL           11bd:002d
> [44494.703659] saa7134:   card=51 -> ProVideo 
> PV952                           1540:9524
> [44494.703661] saa7134:   card=52 -> AverMedia 
> AverTV/305                     1461:2108
> [44494.703665] saa7134:   card=53 -> ASUS TV-FM 
> 7135                          1043:4845
> [44494.703669] saa7134:   card=54 -> LifeView FlyTV Platinum FM / 
> Gold        5168:0214 5168:5214 1489:0214 5168:0304
> [44494.703673] saa7134:   card=55 -> LifeView FlyDVB-T DUO / MSI 
> TV@nywhere D 5168:0306 4e42:0306
> [44494.703677] saa7134:   card=56 -> Avermedia AVerTV 
> 307                     1461:a70a
> [44494.703680] saa7134:   card=57 -> Avermedia AVerTV GO 007 
> FM               1461:f31f
> [44494.703684] saa7134:   card=58 -> ADS Tech Instant TV 
> (saa7135)            1421:0350 1421:0351 1421:0370 1421:1370
> [44494.703689] saa7134:   card=59 -> Kworld/Tevion V-Stream Xpert TV 
> PVR7134
> [44494.703691] saa7134:   card=60 -> LifeView/Typhoon/Genius FlyDVB-T 
> Duo Car 5168:0502 4e42:0502 1489:0502
> [44494.703695] saa7134:   card=61 -> Philips TOUGH DVB-T reference 
> design     1131:2004
> [44494.703698] saa7134:   card=62 -> Compro VideoMate TV 
> Gold+II            
> [44494.703701] saa7134:   card=63 -> Kworld Xpert TV 
> PVR7134                
> [44494.703703] saa7134:   card=64 -> FlyTV mini Asus 
> Digimatrix               1043:0210
> [44494.703707] saa7134:   card=65 -> V-Stream Studio TV 
> Terminator          
> [44494.703709] saa7134:   card=66 -> Yuan TUN-900 
> (saa7135)                 
> [44494.703711] saa7134:   card=67 -> Beholder BeholdTV 409 
> FM                 0000:4091
> [44494.703715] saa7134:   card=68 -> GoTView 7135 
> PCI                         5456:7135
> [44494.703718] saa7134:   card=69 -> Philips EUROPA V3 reference 
> design       1131:2004
> [44494.703722] saa7134:   card=70 -> Compro Videomate 
> DVB-T300                185b:c900
> [44494.703724] saa7134:   card=71 -> Compro Videomate 
> DVB-T200                185b:c901
> [44494.703727] saa7134:   card=72 -> RTD Embedded Technologies 
> VFG7350        1435:7350
> [44494.703731] saa7134:   card=73 -> RTD Embedded Technologies 
> VFG7330        1435:7330
> [44494.703734] saa7134:   card=74 -> LifeView FlyTV Platinum 
> Mini2            14c0:1212
> [44494.703737] saa7134:   card=75 -> AVerMedia AVerTVHD MCE 
> A180              1461:1044
> [44494.703740] saa7134:   card=76 -> SKNet MonsterTV 
> Mobile                   1131:4ee9
> [44494.703743] saa7134:   card=77 -> Pinnacle PCTV 40i/50i/110i 
> (saa7133)     11bd:002e
> [44494.703747] saa7134:   card=78 -> ASUSTeK P7131 
> Dual                       1043:4862 1043:4857
> [44494.703750] saa7134:   card=79 -> Sedna/MuchTV PC TV Cardbus 
> TV/Radio (ITO
> [44494.703753] saa7134:   card=80 -> ASUS Digimatrix 
> TV                       1043:0210
> [44494.703756] saa7134:   card=81 -> Philips Tiger reference 
> design           1131:2018
> [44494.703759] saa7134:   card=82 -> MSI TV@Anywhere 
> plus                     1462:6231 1462:8624
> [44494.703763] saa7134:   card=83 -> Terratec Cinergy 250 PCI 
> TV              153b:1160
> [44494.703766] saa7134:   card=84 -> LifeView FlyDVB 
> Trio                     5168:0319
> [44494.703769] saa7134:   card=85 -> AverTV DVB-T 
> 777                         1461:2c05 1461:2c05
> [44494.703773] saa7134:   card=86 -> LifeView FlyDVB-T / Genius 
> VideoWonder D 5168:0301 1489:0301
> [44494.703777] saa7134:   card=87 -> ADS Instant TV Duo Cardbus 
> PTV331        0331:1421
> [44494.703780] saa7134:   card=88 -> Tevion/KWorld DVB-T 
> 220RF                17de:7201
> [44494.703784] saa7134:   card=89 -> ELSA EX-VISION 
> 700TV                     1048:226c
> [44494.703787] saa7134:   card=90 -> Kworld 
> ATSC110/115                       17de:7350 17de:7352
> [44494.703790] saa7134:   card=91 -> AVerMedia A169 
> B                         1461:7360
> [44494.703794] saa7134:   card=92 -> AVerMedia A169 
> B1                        1461:6360
> [44494.703796] saa7134:   card=93 -> Medion 7134 Bridge 
> #2                    16be:0005
> [44494.703799] saa7134:   card=94 -> LifeView FlyDVB-T Hybrid 
> Cardbus/MSI TV  5168:3306 5168:3502 5168:3307 4e42:3502
> [44494.703804] saa7134:   card=95 -> LifeView FlyVIDEO3000 
> (NTSC)             5169:0138
> [44494.703807] saa7134:   card=96 -> Medion Md8800 
> Quadro                     16be:0007 16be:0008 16be:000d
> [44494.703812] saa7134:   card=97 -> LifeView FlyDVB-S /Acorp 
> TV134DS         5168:0300 4e42:0300
> [44494.703815] saa7134:   card=98 -> Proteus Pro 
> 2309                         0919:2003
> [44494.703819] saa7134:   card=99 -> AVerMedia TV Hybrid 
> A16AR                1461:2c00
> [44494.703822] saa7134:   card=100 -> Asus Europa2 
> OEM                         1043:4860
> [44494.703826] saa7134:   card=101 -> Pinnacle PCTV 
> 310i                       11bd:002f
> [44494.703829] saa7134:   card=102 -> Avermedia AVerTV Studio 
> 507              1461:9715
> [44494.703831] saa7134:   card=103 -> Compro Videomate 
> DVB-T200A             
> [44494.703835] saa7134:   card=104 -> Hauppauge WinTV-HVR1110 
> DVB-T/Hybrid     0070:6700 0070:6701 0070:6702 0070:6703 0070:6704 
> 0070:6705
> [44494.703840] saa7134:   card=105 -> Terratec Cinergy HT 
> PCMCIA               153b:1172
> [44494.703844] saa7134:   card=106 -> Encore 
> ENLTV                             1131:2342 1131:2341 3016:2344
> [44494.703848] saa7134:   card=107 -> Encore 
> ENLTV-FM                          1131:230f
> [44494.703851] saa7134:   card=108 -> Terratec Cinergy HT 
> PCI                  153b:1175
> [44494.703854] saa7134:   card=109 -> Philips Tiger - S Reference 
> design     
> [44494.703856] saa7134:   card=110 -> Avermedia 
> M102                           1461:f31e
> [44494.703860] saa7134:   card=111 -> ASUS P7131 
> 4871                          1043:4871
> [44494.703863] saa7134:   card=112 -> ASUSTeK P7131 
> Hybrid                     1043:4876
> [44494.703866] saa7134:   card=113 -> Elitegroup ECS TVP3XP FM1246 
> Tuner Card  1019:4cb6
> [44494.703869] saa7134:   card=114 -> KWorld DVB-T 
> 210                         17de:7250
> [44494.703872] saa7134:   card=115 -> Sabrent PCMCIA 
> TV-PCB05                  0919:2003
> [44494.703876] saa7134:   card=116 -> 10MOONS TM300 TV 
> Card                    1131:2304
> [44494.703879] saa7134:   card=117 -> Avermedia Super 
> 007                      1461:f01d
> [44494.703882] saa7134:   card=118 -> Beholder BeholdTV 
> 401                    0000:4016
> [44494.703885] saa7134:   card=119 -> Beholder BeholdTV 
> 403                    0000:4036
> [44494.703888] saa7134:   card=120 -> Beholder BeholdTV 403 
> FM                 0000:4037
> [44494.703892] saa7134:   card=121 -> Beholder BeholdTV 
> 405                    0000:4050
> [44494.703894] saa7134:   card=122 -> Beholder BeholdTV 405 
> FM                 0000:4051
> [44494.703898] saa7134:   card=123 -> Beholder BeholdTV 
> 407                    0000:4070
> [44494.703901] saa7134:   card=124 -> Beholder BeholdTV 407 
> FM                 0000:4071
> [44494.703904] saa7134:   card=125 -> Beholder BeholdTV 
> 409                    0000:4090
> [44494.703907] saa7134:   card=126 -> Beholder BeholdTV 505 
> FM/RDS             0000:5051 0000:505b 5ace:5050
> [44494.703912] saa7134:   card=127 -> Beholder BeholdTV 507 FM/RDS / 
> BeholdTV  0000:5071 0000:507b 5ace:5070 5ace:5090
> [44494.703916] saa7134:   card=128 -> Beholder BeholdTV Columbus 
> TVFM          0000:5201
> [44494.703920] saa7134:   card=129 -> Beholder BeholdTV 607 / BeholdTV 
> 609     5ace:6070 5ace:6071 5ace:6072 5ace:6073 5ace:6090 5ace:6091 
> 5ace:6092 5ace:6093
> [44494.703927] saa7134:   card=130 -> Beholder BeholdTV 
> M6                     5ace:6190
> [44494.703930] saa7134:   card=131 -> Twinhan Hybrid DTV-DVB 3056 
> PCI          1822:0022
> [44494.703933] saa7134:   card=132 -> Genius TVGO 
> AM11MCE                    
> [44494.703936] saa7134:   card=133 -> NXP Snake DVB-S reference 
> design       
> [44494.703938] saa7134:   card=134 -> Medion/Creatix CTX953 
> Hybrid             16be:0010
> [44494.703941] saa7134:   card=135 -> MSI TV@nywhere A/D 
> v1.1                  1462:8625
> [44494.703945] saa7134:   card=136 -> AVerMedia Cardbus TV/Radio 
> (E506R)       1461:f436
> [44494.703948] saa7134:   card=137 -> AVerMedia Hybrid TV/Radio 
> (A16D)         1461:f936
> [44494.703952] saa7134:   card=138 -> Avermedia 
> M115                           1461:a836
> [44494.703954] saa7134:   card=139 -> Compro VideoMate 
> T750                    185b:c900
> [44494.703957] saa7134:   card=140 -> Avermedia DVB-S Pro 
> A700                 1461:a7a1
> [44494.703961] saa7134:   card=141 -> Avermedia DVB-S Hybrid+FM 
> A700           1461:a7a2
> [44494.703964] saa7134:   card=142 -> Beholder BeholdTV 
> H6                     5ace:6290
> [44494.703967] saa7134:   card=143 -> Beholder BeholdTV 
> M63                    5ace:6191
> [44494.703972] saa7134:   card=144 -> Beholder BeholdTV M6 
> Extra               5ace:6193
> [44494.703974] saa7134:   card=145 -> AOPVision AOP-8008A 16CH/240fps 
> Capture
> [44494.703977] saa7130[6]: subsystem: 1131:0000, board: 
> UNKNOWN/GENERIC [card=0,autodetected]
> [44494.703992] saa7130[6]: board init: gpio is 10000
> [44494.807321] saa7130[6]: Huh, no eeprom present (err=-5)?
> [44494.807373] saa7130[6]: registered device video6 [v4l2]
> [44494.807390] saa7130[6]: registered device vbi6
> [44494.807417] saa7130[7]: found at 0000:04:0f.0, rev: 1, irq: 23, 
> latency: 64, mmio: 0xfebfe000
> [44494.807425] saa7134: <rant>
> [44494.807426] saa7134:  Congratulations!  Your TV card vendor saved a few
> [44494.807427] saa7134:  cents for a eeprom, thus your pci board has no
> [44494.807428] saa7134:  subsystem ID and I can't identify it 
> automatically
> [44494.807430] saa7134: </rant>
> [44494.807430] saa7134: I feel better now.  Ok, here are the good news:
> [44494.807431] saa7134: You can use the card=<nr> insmod option to specify
> [44494.807432] saa7134: which board do you have.  The list:
> [44494.807436] saa7134:   card=0 -> 
> UNKNOWN/GENERIC                        
> [44494.807438] saa7134:   card=1 -> Proteus Pro [philips reference 
> design]   1131:2001 1131:2001
> [44494.807443] saa7134:   card=2 -> LifeView 
> FlyVIDEO3000                    5168:0138 4e42:0138
> [44494.807447] saa7134:   card=3 -> LifeView/Typhoon 
> FlyVIDEO2000            5168:0138 4e42:0138
> [44494.807451] saa7134:   card=4 -> 
> EMPRESS                                  1131:6752
> [44494.807454] saa7134:   card=5 -> SKNet Monster 
> TV                         1131:4e85
> [44494.807456] saa7134:   card=6 -> Tevion MD 
> 9717                         
> [44494.807460] saa7134:   card=7 -> KNC One TV-Station RDS / Typhoon 
> TV Tune 1131:fe01 1894:fe01
> [44494.807463] saa7134:   card=8 -> Terratec Cinergy 400 
> TV                  153b:1142
> [44494.807467] saa7134:   card=9 -> Medion 
> 5044                            
> [44494.807469] saa7134:   card=10 -> Kworld/KuroutoShikou 
> SAA7130-TVPCI     
> [44494.807471] saa7134:   card=11 -> Terratec Cinergy 600 
> TV                  153b:1143
> [44494.807475] saa7134:   card=12 -> Medion 
> 7134                              16be:0003
> [44494.807478] saa7134:   card=13 -> Typhoon TV+Radio 
> 90031                 
> [44494.807480] saa7134:   card=14 -> ELSA EX-VISION 
> 300TV                     1048:226b
> [44494.807484] saa7134:   card=15 -> ELSA EX-VISION 
> 500TV                     1048:226a
> [44494.807487] saa7134:   card=16 -> ASUS TV-FM 
> 7134                          1043:4842 1043:4830 1043:4840
> [44494.807493] saa7134:   card=17 -> AOPEN VA1000 
> POWER                       1131:7133
> [44494.807495] saa7134:   card=18 -> BMK MPEX No 
> Tuner                      
> [44494.807498] saa7134:   card=19 -> Compro VideoMate 
> TV                      185b:c100
> [44494.807502] saa7134:   card=20 -> Matrox 
> CronosPlus                        102b:48d0
> [44494.807505] saa7134:   card=21 -> 10MOONS PCI TV CAPTURE 
> CARD              1131:2001
> [44494.807508] saa7134:   card=22 -> AverMedia M156 / Medion 
> 2819             1461:a70b
> [44494.807511] saa7134:   card=23 -> BMK MPEX 
> Tuner                         
> [44494.807513] saa7134:   card=24 -> KNC One TV-Station 
> DVR                   1894:a006
> [44494.807517] saa7134:   card=25 -> ASUS TV-FM 
> 7133                          1043:4843
> [44494.807520] saa7134:   card=26 -> Pinnacle PCTV Stereo 
> (saa7134)           11bd:002b
> [44494.807524] saa7134:   card=27 -> Manli MuchTV 
> M-TV002                   
> [44494.807526] saa7134:   card=28 -> Manli MuchTV 
> M-TV001                   
> [44494.807528] saa7134:   card=29 -> Nagase Sangyo TransGear 
> 3000TV           1461:050c
> [44494.807532] saa7134:   card=30 -> Elitegroup ECS TVP3XP FM1216 
> Tuner Card( 1019:4cb4
> [44494.807535] saa7134:   card=31 -> Elitegroup ECS TVP3XP FM1236 
> Tuner Card  1019:4cb5
> [44494.807538] saa7134:   card=32 -> AVACS 
> SmartTV                          
> [44494.807541] saa7134:   card=33 -> AVerMedia DVD 
> EZMaker                    1461:10ff
> [44494.807543] saa7134:   card=34 -> Noval Prime TV 
> 7133                    
> [44494.807547] saa7134:   card=35 -> AverMedia AverTV Studio 
> 305              1461:2115
> [44494.807550] saa7134:   card=36 -> UPMOST PURPLE 
> TV                         12ab:0800
> [44494.807552] saa7134:   card=37 -> Items MuchTV Plus / 
> IT-005             
> [44494.807556] saa7134:   card=38 -> Terratec Cinergy 200 
> TV                  153b:1152
> [44494.807559] saa7134:   card=39 -> LifeView FlyTV Platinum 
> Mini             5168:0212 4e42:0212 5169:1502
> [44494.807564] saa7134:   card=40 -> Compro VideoMate TV 
> PVR/FM               185b:c100
> [44494.807567] saa7134:   card=41 -> Compro VideoMate TV 
> Gold+                185b:c100
> [44494.807570] saa7134:   card=42 -> Sabrent SBT-TVFM 
> (saa7130)             
> [44494.807573] saa7134:   card=43 -> :Zolid Xpert 
> TV7134                    
> [44494.807575] saa7134:   card=44 -> Empire PCI TV-Radio 
> LE                 
> [44494.807578] saa7134:   card=45 -> Avermedia AVerTV Studio 
> 307              1461:9715
> [44494.807581] saa7134:   card=46 -> AVerMedia Cardbus TV/Radio 
> (E500)        1461:d6ee
> [44494.807584] saa7134:   card=47 -> Terratec Cinergy 400 
> mobile              153b:1162
> [44494.807587] saa7134:   card=48 -> Terratec Cinergy 600 TV 
> MK3              153b:1158
> [44494.807590] saa7134:   card=49 -> Compro VideoMate Gold+ 
> Pal               185b:c200
> [44494.807593] saa7134:   card=50 -> Pinnacle PCTV 300i DVB-T + 
> PAL           11bd:002d
> [44494.807597] saa7134:   card=51 -> ProVideo 
> PV952                           1540:9524
> [44494.807599] saa7134:   card=52 -> AverMedia 
> AverTV/305                     1461:2108
> [44494.807603] saa7134:   card=53 -> ASUS TV-FM 
> 7135                          1043:4845
> [44494.807607] saa7134:   card=54 -> LifeView FlyTV Platinum FM / 
> Gold        5168:0214 5168:5214 1489:0214 5168:0304
> [44494.807611] saa7134:   card=55 -> LifeView FlyDVB-T DUO / MSI 
> TV@nywhere D 5168:0306 4e42:0306
> [44494.807615] saa7134:   card=56 -> Avermedia AVerTV 
> 307                     1461:a70a
> [44494.807618] saa7134:   card=57 -> Avermedia AVerTV GO 007 
> FM               1461:f31f
> [44494.807622] saa7134:   card=58 -> ADS Tech Instant TV 
> (saa7135)            1421:0350 1421:0351 1421:0370 1421:1370
> [44494.807626] saa7134:   card=59 -> Kworld/Tevion V-Stream Xpert TV 
> PVR7134
> [44494.807629] saa7134:   card=60 -> LifeView/Typhoon/Genius FlyDVB-T 
> Duo Car 5168:0502 4e42:0502 1489:0502
> [44494.807633] saa7134:   card=61 -> Philips TOUGH DVB-T reference 
> design     1131:2004
> [44494.807637] saa7134:   card=62 -> Compro VideoMate TV 
> Gold+II            
> [44494.807639] saa7134:   card=63 -> Kworld Xpert TV 
> PVR7134                
> [44494.807642] saa7134:   card=64 -> FlyTV mini Asus 
> Digimatrix               1043:0210
> [44494.807646] saa7134:   card=65 -> V-Stream Studio TV 
> Terminator          
> [44494.807648] saa7134:   card=66 -> Yuan TUN-900 
> (saa7135)                 
> [44494.807650] saa7134:   card=67 -> Beholder BeholdTV 409 
> FM                 0000:4091
> [44494.807654] saa7134:   card=68 -> GoTView 7135 
> PCI                         5456:7135
> [44494.807657] saa7134:   card=69 -> Philips EUROPA V3 reference 
> design       1131:2004
> [44494.807660] saa7134:   card=70 -> Compro Videomate 
> DVB-T300                185b:c900
> [44494.807663] saa7134:   card=71 -> Compro Videomate 
> DVB-T200                185b:c901
> [44494.807666] saa7134:   card=72 -> RTD Embedded Technologies 
> VFG7350        1435:7350
> [44494.807670] saa7134:   card=73 -> RTD Embedded Technologies 
> VFG7330        1435:7330
> [44494.807673] saa7134:   card=74 -> LifeView FlyTV Platinum 
> Mini2            14c0:1212
> [44494.807676] saa7134:   card=75 -> AVerMedia AVerTVHD MCE 
> A180              1461:1044
> [44494.807679] saa7134:   card=76 -> SKNet MonsterTV 
> Mobile                   1131:4ee9
> [44494.807682] saa7134:   card=77 -> Pinnacle PCTV 40i/50i/110i 
> (saa7133)     11bd:002e
> [44494.807686] saa7134:   card=78 -> ASUSTeK P7131 
> Dual                       1043:4862 1043:4857
> [44494.807689] saa7134:   card=79 -> Sedna/MuchTV PC TV Cardbus 
> TV/Radio (ITO
> [44494.807692] saa7134:   card=80 -> ASUS Digimatrix 
> TV                       1043:0210
> [44494.807695] saa7134:   card=81 -> Philips Tiger reference 
> design           1131:2018
> [44494.807698] saa7134:   card=82 -> MSI TV@Anywhere 
> plus                     1462:6231 1462:8624
> [44494.807702] saa7134:   card=83 -> Terratec Cinergy 250 PCI 
> TV              153b:1160
> [44494.807705] saa7134:   card=84 -> LifeView FlyDVB 
> Trio                     5168:0319
> [44494.807709] saa7134:   card=85 -> AverTV DVB-T 
> 777                         1461:2c05 1461:2c05
> [44494.807712] saa7134:   card=86 -> LifeView FlyDVB-T / Genius 
> VideoWonder D 5168:0301 1489:0301
> [44494.807716] saa7134:   card=87 -> ADS Instant TV Duo Cardbus 
> PTV331        0331:1421
> [44494.807719] saa7134:   card=88 -> Tevion/KWorld DVB-T 
> 220RF                17de:7201
> [44494.807722] saa7134:   card=89 -> ELSA EX-VISION 
> 700TV                     1048:226c
> [44494.807725] saa7134:   card=90 -> Kworld 
> ATSC110/115                       17de:7350 17de:7352
> [44494.807729] saa7134:   card=91 -> AVerMedia A169 
> B                         1461:7360
> [44494.807733] saa7134:   card=92 -> AVerMedia A169 
> B1                        1461:6360
> [44494.807736] saa7134:   card=93 -> Medion 7134 Bridge 
> #2                    16be:0005
> [44494.807738] saa7134:   card=94 -> LifeView FlyDVB-T Hybrid 
> Cardbus/MSI TV  5168:3306 5168:3502 5168:3307 4e42:3502
> [44494.807744] saa7134:   card=95 -> LifeView FlyVIDEO3000 
> (NTSC)             5169:0138
> [44494.807746] saa7134:   card=96 -> Medion Md8800 
> Quadro                     16be:0007 16be:0008 16be:000d
> [44494.807751] saa7134:   card=97 -> LifeView FlyDVB-S /Acorp 
> TV134DS         5168:0300 4e42:0300
> [44494.807754] saa7134:   card=98 -> Proteus Pro 
> 2309                         0919:2003
> [44494.807758] saa7134:   card=99 -> AVerMedia TV Hybrid 
> A16AR                1461:2c00
> [44494.807761] saa7134:   card=100 -> Asus Europa2 
> OEM                         1043:4860
> [44494.807765] saa7134:   card=101 -> Pinnacle PCTV 
> 310i                       11bd:002f
> [44494.807768] saa7134:   card=102 -> Avermedia AVerTV Studio 
> 507              1461:9715
> [44494.807771] saa7134:   card=103 -> Compro Videomate 
> DVB-T200A             
> [44494.807774] saa7134:   card=104 -> Hauppauge WinTV-HVR1110 
> DVB-T/Hybrid     0070:6700 0070:6701 0070:6702 0070:6703 0070:6704 
> 0070:6705
> [44494.807780] saa7134:   card=105 -> Terratec Cinergy HT 
> PCMCIA               153b:1172
> [44494.807783] saa7134:   card=106 -> Encore 
> ENLTV                             1131:2342 1131:2341 3016:2344
> [44494.807788] saa7134:   card=107 -> Encore 
> ENLTV-FM                          1131:230f
> [44494.807790] saa7134:   card=108 -> Terratec Cinergy HT 
> PCI                  153b:1175
> [44494.807794] saa7134:   card=109 -> Philips Tiger - S Reference 
> design     
> [44494.807796] saa7134:   card=110 -> Avermedia 
> M102                           1461:f31e
> [44494.807799] saa7134:   card=111 -> ASUS P7131 
> 4871                          1043:4871
> [44494.807803] saa7134:   card=112 -> ASUSTeK P7131 
> Hybrid                     1043:4876
> [44494.807806] saa7134:   card=113 -> Elitegroup ECS TVP3XP FM1246 
> Tuner Card  1019:4cb6
> [44494.807809] saa7134:   card=114 -> KWorld DVB-T 
> 210                         17de:7250
> [44494.807812] saa7134:   card=115 -> Sabrent PCMCIA 
> TV-PCB05                  0919:2003
> [44494.807815] saa7134:   card=116 -> 10MOONS TM300 TV 
> Card                    1131:2304
> [44494.807819] saa7134:   card=117 -> Avermedia Super 
> 007                      1461:f01d
> [44494.807822] saa7134:   card=118 -> Beholder BeholdTV 
> 401                    0000:4016
> [44494.807825] saa7134:   card=119 -> Beholder BeholdTV 
> 403                    0000:4036
> [44494.807828] saa7134:   card=120 -> Beholder BeholdTV 403 
> FM                 0000:4037
> [44494.807831] saa7134:   card=121 -> Beholder BeholdTV 
> 405                    0000:4050
> [44494.807834] saa7134:   card=122 -> Beholder BeholdTV 405 
> FM                 0000:4051
> [44494.807837] saa7134:   card=123 -> Beholder BeholdTV 
> 407                    0000:4070
> [44494.807840] saa7134:   card=124 -> Beholder BeholdTV 407 
> FM                 0000:4071
> [44494.807844] saa7134:   card=125 -> Beholder BeholdTV 
> 409                    0000:4090
> [44494.807846] saa7134:   card=126 -> Beholder BeholdTV 505 
> FM/RDS             0000:5051 0000:505b 5ace:5050
> [44494.807852] saa7134:   card=127 -> Beholder BeholdTV 507 FM/RDS / 
> BeholdTV  0000:5071 0000:507b 5ace:5070 5ace:5090
> [44494.807856] saa7134:   card=128 -> Beholder BeholdTV Columbus 
> TVFM          0000:5201
> [44494.807860] saa7134:   card=129 -> Beholder BeholdTV 607 / BeholdTV 
> 609     5ace:6070 5ace:6071 5ace:6072 5ace:6073 5ace:6090 5ace:6091 
> 5ace:6092 5ace:6093
> [44494.807867] saa7134:   card=130 -> Beholder BeholdTV 
> M6                     5ace:6190
> [44494.807870] saa7134:   card=131 -> Twinhan Hybrid DTV-DVB 3056 
> PCI          1822:0022
> [44494.807873] saa7134:   card=132 -> Genius TVGO 
> AM11MCE                    
> [44494.807876] saa7134:   card=133 -> NXP Snake DVB-S reference 
> design       
> [44494.807878] saa7134:   card=134 -> Medion/Creatix CTX953 
> Hybrid             16be:0010
> [44494.807881] saa7134:   card=135 -> MSI TV@nywhere A/D 
> v1.1                  1462:8625
> [44494.807885] saa7134:   card=136 -> AVerMedia Cardbus TV/Radio 
> (E506R)       1461:f436
> [44494.807888] saa7134:   card=137 -> AVerMedia Hybrid TV/Radio 
> (A16D)         1461:f936
> [44494.807892] saa7134:   card=138 -> Avermedia 
> M115                           1461:a836
> [44494.807895] saa7134:   card=139 -> Compro VideoMate 
> T750                    185b:c900
> [44494.807898] saa7134:   card=140 -> Avermedia DVB-S Pro 
> A700                 1461:a7a1
> [44494.807902] saa7134:   card=141 -> Avermedia DVB-S Hybrid+FM 
> A700           1461:a7a2
> [44494.807904] saa7134:   card=142 -> Beholder BeholdTV 
> H6                     5ace:6290
> [44494.807908] saa7134:   card=143 -> Beholder BeholdTV 
> M63                    5ace:6191
> [44494.807910] saa7134:   card=144 -> Beholder BeholdTV M6 
> Extra               5ace:6193
> [44494.807913] saa7134:   card=145 -> AOPVision AOP-8008A 16CH/240fps 
> Capture
> [44494.807917] saa7130[7]: subsystem: 1131:0000, board: 
> UNKNOWN/GENERIC [card=0,autodetected]
> [44494.807930] saa7130[7]: board init: gpio is 10000
> [44494.911267] saa7130[7]: Huh, no eeprom present (err=-5)?
> [44494.911321] saa7130[7]: registered device video7 [v4l2]
> [44494.911338] saa7130[7]: registered device vbi7
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
