Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m66BYC7h022196
	for <video4linux-list@redhat.com>; Sun, 6 Jul 2008 07:34:12 -0400
Received: from mail-in-03.arcor-online.net (mail-in-03.arcor-online.net
	[151.189.21.43])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m66BXvMI005795
	for <video4linux-list@redhat.com>; Sun, 6 Jul 2008 07:33:57 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: D <therealisttruest@gmail.com>
In-Reply-To: <48701944.2040200@gmail.com>
References: <486FF148.2060506@gmail.com>
	<1215298086.3237.19.camel@pc10.localdom.local>
	<48700079.6000209@gmail.com> <48701944.2040200@gmail.com>
Content-Type: text/plain
Date: Sun, 06 Jul 2008 13:30:39 +0200
Message-Id: <1215343839.2852.14.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
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

Hi,

Am Samstag, den 05.07.2008, 17:00 -0800 schrieb D:
> Not sure why this didn't post the first time, but message is below.. again-
> 
> Thank you for the reply. Sorry I forgot dmesg. At this point it's not 
> totally valid I don't think, as I made my changes as card  =145 and had 
> it loading automatically, but undoing that to a point and doing dmesg we 
> have below, which is not autodetected. I've also tried other card 
> numbers, but had not success, as a matter of fact all other card 
> numbers. My current results only give me garbled video.

"garbled video" can mean lots of different things.
Black and white only would be simplest, since indicating some wrong
vmux.

>  I'm not sure 
> about sound and I'm not worried about it either at this point. Also, 
> here is a link to a picture of the card if it helps(it looks similar to 
> the one I tried to mirror my changes on this list) 
> http://www.szrare.com/en/Product8.asp?BigClassName=Video%20capture%20card

That is of course like nothing still.

> > Please let me know if you need any more info from me at all. If I've 
> > forgotten anything else also let me know. I'm pretty much at a dead 
> > end at the moment....
> >
> > [44494.079594] saa7130/34: v4l2 driver version 0.2.14 loaded
> > [44494.079653] saa7130[0]: found at 0000:04:08.0, rev: 1, irq: 21, 
> > latency: 64, mmio: 0xfebffc00
> > [44494.079662] saa7134: <rant>
> > [44494.079663] saa7134:  Congratulations!  Your TV card vendor saved a few
> > [44494.079664] saa7134:  cents for a eeprom, thus your pci board has no
> > [44494.079665] saa7134:  subsystem ID and I can't identify it 
> > automatically
> > [44494.079666] saa7134: </rant>
> > [44494.079667] saa7134: I feel better now.  Ok, here are the good news:
> > [44494.079668] saa7134: You can use the card=<nr> insmod option to specify
> > [44494.079669] saa7134: which board do you have.  The list:
> > [44494.079671] saa7134:   card=0 -> 
> > UNKNOWN/GENERIC                        
> > [44494.079674] saa7134:   card=1 -> Proteus Pro [philips reference 
> > design]   1131:2001 1131:2001
> > [44494.079678] saa7134:   card=2 -> LifeView 
> > FlyVIDEO3000                    5168:0138 4e42:0138
> > [44494.079681] saa7134:   card=3 -> LifeView/Typhoon 
> > FlyVIDEO2000            5168:0138 4e42:0138
> > [44494.079684] saa7134:   card=4 -> 
> > EMPRESS                                  1131:6752
> > [44494.079687] saa7134:   card=5 -> SKNet Monster 
> > TV                         1131:4e85
> > [44494.079689] saa7134:   card=6 -> Tevion MD 
> > 9717                         
> > [44494.079692] saa7134:   card=7 -> KNC One TV-Station RDS / Typhoon 
> > TV Tune 1131:fe01 1894:fe01
> > [44494.079695] saa7134:   card=8 -> Terratec Cinergy 400 
> > TV                  153b:1142
> > [44494.079697] saa7134:   card=9 -> Medion 
> > 5044                            
> > [44494.079701] saa7134:   card=10 -> Kworld/KuroutoShikou 
> > SAA7130-TVPCI     
> > [44494.079704] saa7134:   card=11 -> Terratec Cinergy 600 
> > TV                  153b:1143
> > [44494.079706] saa7134:   card=12 -> Medion 
> > 7134                              16be:0003
> > [44494.079709] saa7134:   card=13 -> Typhoon TV+Radio 
> > 90031                 
> > [44494.079711] saa7134:   card=14 -> ELSA EX-VISION 
> > 300TV                     1048:226b
> > [44494.079715] saa7134:   card=15 -> ELSA EX-VISION 
> > 500TV                     1048:226a
> > [44494.079719] saa7134:   card=16 -> ASUS TV-FM 
> > 7134                          1043:4842 1043:4830 1043:4840
> > [44494.079725] saa7134:   card=17 -> AOPEN VA1000 
> > POWER                       1131:7133
> > [44494.079729] saa7134:   card=18 -> BMK MPEX No 
> > Tuner                      
> > [44494.079731] saa7134:   card=19 -> Compro VideoMate 
> > TV                      185b:c100
> > [44494.079735] saa7134:   card=20 -> Matrox 
> > CronosPlus                        102b:48d0
> > [44494.079739] saa7134:   card=21 -> 10MOONS PCI TV CAPTURE 
> > CARD              1131:2001
> > [44494.079742] saa7134:   card=22 -> AverMedia M156 / Medion 
> > 2819             1461:a70b
> > [44494.079746] saa7134:   card=23 -> BMK MPEX 
> > Tuner                         
> > [44494.079749] saa7134:   card=24 -> KNC One TV-Station 
> > DVR                   1894:a006
> > [44494.079753] saa7134:   card=25 -> ASUS TV-FM 
> > 7133                          1043:4843
> > [44494.079756] saa7134:   card=26 -> Pinnacle PCTV Stereo 
> > (saa7134)           11bd:002b
> > [44494.079760] saa7134:   card=27 -> Manli MuchTV 
> > M-TV002                   
> > [44494.079763] saa7134:   card=28 -> Manli MuchTV 
> > M-TV001                   
> > [44494.079765] saa7134:   card=29 -> Nagase Sangyo TransGear 
> > 3000TV           1461:050c
> > [44494.079769] saa7134:   card=30 -> Elitegroup ECS TVP3XP FM1216 
> > Tuner Card( 1019:4cb4
> > [44494.079773] saa7134:   card=31 -> Elitegroup ECS TVP3XP FM1236 
> > Tuner Card  1019:4cb5
> > [44494.079776] saa7134:   card=32 -> AVACS 
> > SmartTV                          
> > [44494.079780] saa7134:   card=33 -> AVerMedia DVD 
> > EZMaker                    1461:10ff
> > [44494.079783] saa7134:   card=34 -> Noval Prime TV 
> > 7133                    
> > [44494.079786] saa7134:   card=35 -> AverMedia AverTV Studio 
> > 305              1461:2115
> > [44494.079789] saa7134:   card=36 -> UPMOST PURPLE 
> > TV                         12ab:0800
> > [44494.079793] saa7134:   card=37 -> Items MuchTV Plus / 
> > IT-005             
> > [44494.079796] saa7134:   card=38 -> Terratec Cinergy 200 
> > TV                  153b:1152
> > [44494.079799] saa7134:   card=39 -> LifeView FlyTV Platinum 
> > Mini             5168:0212 4e42:0212 5169:1502
> > [44494.079804] saa7134:   card=40 -> Compro VideoMate TV 
> > PVR/FM               185b:c100
> > [44494.079807] saa7134:   card=41 -> Compro VideoMate TV 
> > Gold+                185b:c100
> > [44494.079811] saa7134:   card=42 -> Sabrent SBT-TVFM 
> > (saa7130)             
> > [44494.079814] saa7134:   card=43 -> :Zolid Xpert 
> > TV7134                    
> > [44494.079817] saa7134:   card=44 -> Empire PCI TV-Radio 
> > LE                 
> > [44494.079820] saa7134:   card=45 -> Avermedia AVerTV Studio 
> > 307              1461:9715
> > [44494.079824] saa7134:   card=46 -> AVerMedia Cardbus TV/Radio 
> > (E500)        1461:d6ee
> > [44494.079827] saa7134:   card=47 -> Terratec Cinergy 400 
> > mobile              153b:1162
> > [44494.079831] saa7134:   card=48 -> Terratec Cinergy 600 TV 
> > MK3              153b:1158
> > [44494.079834] saa7134:   card=49 -> Compro VideoMate Gold+ 
> > Pal               185b:c200
> > [44494.079838] saa7134:   card=50 -> Pinnacle PCTV 300i DVB-T + 
> > PAL           11bd:002d
> > [44494.079842] saa7134:   card=51 -> ProVideo 
> > PV952                           1540:9524
> > [44494.079846] saa7134:   card=52 -> AverMedia 
> > AverTV/305                     1461:2108
> > [44494.079849] saa7134:   card=53 -> ASUS TV-FM 
> > 7135                          1043:4845
> > [44494.079853] saa7134:   card=54 -> LifeView FlyTV Platinum FM / 
> > Gold        5168:0214 5168:5214 1489:0214 5168:0304
> > [44494.079859] saa7134:   card=55 -> LifeView FlyDVB-T DUO / MSI 
> > TV@nywhere D 5168:0306 4e42:0306
> > [44494.079862] saa7134:   card=56 -> Avermedia AVerTV 
> > 307                     1461:a70a
> > [44494.079866] saa7134:   card=57 -> Avermedia AVerTV GO 007 
> > FM               1461:f31f
> > [44494.079870] saa7134:   card=58 -> ADS Tech Instant TV 
> > (saa7135)            1421:0350 1421:0351 1421:0370 1421:1370
> > [44494.079876] saa7134:   card=59 -> Kworld/Tevion V-Stream Xpert TV 
> > PVR7134
> > [44494.079879] saa7134:   card=60 -> LifeView/Typhoon/Genius FlyDVB-T 
> > Duo Car 5168:0502 4e42:0502 1489:0502
> > [44494.079883] saa7134:   card=61 -> Philips TOUGH DVB-T reference 
> > design     1131:2004
> > [44494.079887] saa7134:   card=62 -> Compro VideoMate TV 
> > Gold+II            
> > [44494.079890] saa7134:   card=63 -> Kworld Xpert TV 
> > PVR7134                
> > [44494.079893] saa7134:   card=64 -> FlyTV mini Asus 
> > Digimatrix               1043:0210
> > [44494.079896] saa7134:   card=65 -> V-Stream Studio TV 
> > Terminator          
> > [44494.079899] saa7134:   card=66 -> Yuan TUN-900 
> > (saa7135)                 
> > [44494.079902] saa7134:   card=67 -> Beholder BeholdTV 409 
> > FM                 0000:4091
> > [44494.079905] saa7134:   card=68 -> GoTView 7135 
> > PCI                         5456:7135
> > [44494.079909] saa7134:   card=69 -> Philips EUROPA V3 reference 
> > design       1131:2004
> > [44494.079913] saa7134:   card=70 -> Compro Videomate 
> > DVB-T300                185b:c900
> > [44494.079917] saa7134:   card=71 -> Compro Videomate 
> > DVB-T200                185b:c901
> > [44494.079920] saa7134:   card=72 -> RTD Embedded Technologies 
> > VFG7350        1435:7350
> > [44494.079924] saa7134:   card=73 -> RTD Embedded Technologies 
> > VFG7330        1435:7330
> > [44494.079928] saa7134:   card=74 -> LifeView FlyTV Platinum 
> > Mini2            14c0:1212
> > [44494.079932] saa7134:   card=75 -> AVerMedia AVerTVHD MCE 
> > A180              1461:1044
> > [44494.079935] saa7134:   card=76 -> SKNet MonsterTV 
> > Mobile                   1131:4ee9
> > [44494.079939] saa7134:   card=77 -> Pinnacle PCTV 40i/50i/110i 
> > (saa7133)     11bd:002e
> > [44494.079942] saa7134:   card=78 -> ASUSTeK P7131 
> > Dual                       1043:4862 1043:4857
> > [44494.079946] saa7134:   card=79 -> Sedna/MuchTV PC TV Cardbus 
> > TV/Radio (ITO
> > [44494.079949] saa7134:   card=80 -> ASUS Digimatrix 
> > TV                       1043:0210
> > [44494.079953] saa7134:   card=81 -> Philips Tiger reference 
> > design           1131:2018
> > [44494.079956] saa7134:   card=82 -> MSI TV@Anywhere 
> > plus                     1462:6231 1462:8624
> > [44494.079960] saa7134:   card=83 -> Terratec Cinergy 250 PCI 
> > TV              153b:1160
> > [44494.079964] saa7134:   card=84 -> LifeView FlyDVB 
> > Trio                     5168:0319
> > [44494.079968] saa7134:   card=85 -> AverTV DVB-T 
> > 777                         1461:2c05 1461:2c05
> > [44494.079972] saa7134:   card=86 -> LifeView FlyDVB-T / Genius 
> > VideoWonder D 5168:0301 1489:0301
> > [44494.079976] saa7134:   card=87 -> ADS Instant TV Duo Cardbus 
> > PTV331        0331:1421
> > [44494.079980] saa7134:   card=88 -> Tevion/KWorld DVB-T 
> > 220RF                17de:7201
> > [44494.079984] saa7134:   card=89 -> ELSA EX-VISION 
> > 700TV                     1048:226c
> > [44494.079988] saa7134:   card=90 -> Kworld 
> > ATSC110/115                       17de:7350 17de:7352
> > [44494.079993] saa7134:   card=91 -> AVerMedia A169 
> > B                         1461:7360
> > [44494.079996] saa7134:   card=92 -> AVerMedia A169 
> > B1                        1461:6360
> > [44494.080000] saa7134:   card=93 -> Medion 7134 Bridge 
> > #2                    16be:0005
> > [44494.080003] saa7134:   card=94 -> LifeView FlyDVB-T Hybrid 
> > Cardbus/MSI TV  5168:3306 5168:3502 5168:3307 4e42:3502
> > [44494.080010] saa7134:   card=95 -> LifeView FlyVIDEO3000 
> > (NTSC)             5169:0138
> > [44494.080013] saa7134:   card=96 -> Medion Md8800 
> > Quadro                     16be:0007 16be:0008 16be:000d
> > [44494.080018] saa7134:   card=97 -> LifeView FlyDVB-S /Acorp 
> > TV134DS         5168:0300 4e42:0300
> > [44494.080022] saa7134:   card=98 -> Proteus Pro 
> > 2309                         0919:2003
> > [44494.080026] saa7134:   card=99 -> AVerMedia TV Hybrid 
> > A16AR                1461:2c00
> > [44494.080029] saa7134:   card=100 -> Asus Europa2 
> > OEM                         1043:4860
> > [44494.080033] saa7134:   card=101 -> Pinnacle PCTV 
> > 310i                       11bd:002f
> > [44494.080037] saa7134:   card=102 -> Avermedia AVerTV Studio 
> > 507              1461:9715
> > [44494.080041] saa7134:   card=103 -> Compro Videomate 
> > DVB-T200A             
> > [44494.080044] saa7134:   card=104 -> Hauppauge WinTV-HVR1110 
> > DVB-T/Hybrid     0070:6700 0070:6701 0070:6702 0070:6703 0070:6704 
> > 0070:6705
> > [44494.080051] saa7134:   card=105 -> Terratec Cinergy HT 
> > PCMCIA               153b:1172
> > [44494.080055] saa7134:   card=106 -> Encore 
> > ENLTV                             1131:2342 1131:2341 3016:2344
> > [44494.080059] saa7134:   card=107 -> Encore 
> > ENLTV-FM                          1131:230f
> > [44494.080063] saa7134:   card=108 -> Terratec Cinergy HT 
> > PCI                  153b:1175
> > [44494.080066] saa7134:   card=109 -> Philips Tiger - S Reference 
> > design     
> > [44494.080069] saa7134:   card=110 -> Avermedia 
> > M102                           1461:f31e
> > [44494.080073] saa7134:   card=111 -> ASUS P7131 
> > 4871                          1043:4871
> > [44494.080077] saa7134:   card=112 -> ASUSTeK P7131 
> > Hybrid                     1043:4876
> > [44494.080081] saa7134:   card=113 -> Elitegroup ECS TVP3XP FM1246 
> > Tuner Card  1019:4cb6
> > [44494.080085] saa7134:   card=114 -> KWorld DVB-T 
> > 210                         17de:7250
> > [44494.080089] saa7134:   card=115 -> Sabrent PCMCIA 
> > TV-PCB05                  0919:2003
> > [44494.080092] saa7134:   card=116 -> 10MOONS TM300 TV 
> > Card                    1131:2304
> > [44494.080096] saa7134:   card=117 -> Avermedia Super 
> > 007                      1461:f01d
> > [44494.080100] saa7134:   card=118 -> Beholder BeholdTV 
> > 401                    0000:4016
> > [44494.080103] saa7134:   card=119 -> Beholder BeholdTV 
> > 403                    0000:4036
> > [44494.080107] saa7134:   card=120 -> Beholder BeholdTV 403 
> > FM                 0000:4037
> > [44494.080111] saa7134:   card=121 -> Beholder BeholdTV 
> > 405                    0000:4050
> > [44494.080114] saa7134:   card=122 -> Beholder BeholdTV 405 
> > FM                 0000:4051
> > [44494.080118] saa7134:   card=123 -> Beholder BeholdTV 
> > 407                    0000:4070
> > [44494.080122] saa7134:   card=124 -> Beholder BeholdTV 407 
> > FM                 0000:4071
> > [44494.080125] saa7134:   card=125 -> Beholder BeholdTV 
> > 409                    0000:4090
> > [44494.080129] saa7134:   card=126 -> Beholder BeholdTV 505 
> > FM/RDS             0000:5051 0000:505b 5ace:5050
> > [44494.080134] saa7134:   card=127 -> Beholder BeholdTV 507 FM/RDS / 
> > BeholdTV  0000:5071 0000:507b 5ace:5070 5ace:5090
> > [44494.080139] saa7134:   card=128 -> Beholder BeholdTV Columbus 
> > TVFM          0000:5201
> > [44494.080143] saa7134:   card=129 -> Beholder BeholdTV 607 / BeholdTV 
> > 609     5ace:6070 5ace:6071 5ace:6072 5ace:6073 5ace:6090 5ace:6091 
> > 5ace:6092 5ace:6093
> > [44494.080152] saa7134:   card=130 -> Beholder BeholdTV 
> > M6                     5ace:6190
> > [44494.080156] saa7134:   card=131 -> Twinhan Hybrid DTV-DVB 3056 
> > PCI          1822:0022
> > [44494.080160] saa7134:   card=132 -> Genius TVGO 
> > AM11MCE                    
> > [44494.080163] saa7134:   card=133 -> NXP Snake DVB-S reference 
> > design       
> > [44494.080166] saa7134:   card=134 -> Medion/Creatix CTX953 
> > Hybrid             16be:0010
> > [44494.080169] saa7134:   card=135 -> MSI TV@nywhere A/D 
> > v1.1                  1462:8625
> > [44494.080173] saa7134:   card=136 -> AVerMedia Cardbus TV/Radio 
> > (E506R)       1461:f436
> > [44494.080177] saa7134:   card=137 -> AVerMedia Hybrid TV/Radio 
> > (A16D)         1461:f936
> > [44494.080181] saa7134:   card=138 -> Avermedia 
> > M115                           1461:a836
> > [44494.080184] saa7134:   card=139 -> Compro VideoMate 
> > T750                    185b:c900
> > [44494.080188] saa7134:   card=140 -> Avermedia DVB-S Pro 
> > A700                 1461:a7a1
> > [44494.080192] saa7134:   card=141 -> Avermedia DVB-S Hybrid+FM 
> > A700           1461:a7a2
> > [44494.080196] saa7134:   card=142 -> Beholder BeholdTV 
> > H6                     5ace:6290
> > [44494.080199] saa7134:   card=143 -> Beholder BeholdTV 
> > M63                    5ace:6191
> > [44494.080203] saa7134:   card=144 -> Beholder BeholdTV M6 
> > Extra               5ace:6193

We can skip the list of known devices here and later.

> > [44494.080206] saa7134:   card=145 -> AOPVision AOP-8008A 16CH/240fps 
> > Capture
> > [44494.080210] saa7130[0]: subsystem: 1131:0000, board: 
> > UNKNOWN/GENERIC [card=0,autodetected]
> > [44494.080220] saa7130[0]: board init: gpio is c013ef0
                                           ^^^^^^^^^^^^^^^

In such a case, this is the only indication if it might have been seen
already previously. 

If this is after a boot prior to mess around with other card entries or
trying something yourself on gpios, it looks like this device was not
seen yet then.


[big snip]
> > [44494.807913] saa7134:   card=145 -> AOPVision AOP-8008A 16CH/240fps 
> > Capture
> > [44494.807917] saa7130[7]: subsystem: 1131:0000, board: 
> > UNKNOWN/GENERIC [card=0,autodetected]
> > [44494.807930] saa7130[7]: board init: gpio is 10000
                   ^^^^^^^^^^              ^^^^^^^^^^^^^
Seems to be still unique here.

> > [44494.911267] saa7130[7]: Huh, no eeprom present (err=-5)?
> > [44494.911321] saa7130[7]: registered device video7 [v4l2]
> > [44494.911338] saa7130[7]: registered device vbi7
> >

Cheers,
Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
