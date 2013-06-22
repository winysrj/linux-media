Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail15.surf-town.net ([212.97.132.55]:37795 "EHLO
	mailgw21.surf-town.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751032Ab3FVVoc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Jun 2013 17:44:32 -0400
Received: from localhost (localhost [127.0.0.1])
	by mailgw21.surf-town.net (Postfix) with ESMTP id 6A162409A
	for <linux-media@vger.kernel.org>; Sat, 22 Jun 2013 23:34:54 +0200 (CEST)
Received: from mailgw21.surf-town.net ([127.0.0.1])
	by localhost (mailgw21.surf-town.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id ZXanAscT6uIX for <linux-media@vger.kernel.org>;
	Sat, 22 Jun 2013 23:34:51 +0200 (CEST)
Received: from [192.168.0.35] (37.250.127.239.bredband.tre.se [37.250.127.239])
	by mailgw21.surf-town.net (Postfix) with ESMTPSA id 79A244219
	for <linux-media@vger.kernel.org>; Sat, 22 Jun 2013 23:34:49 +0200 (CEST)
Message-ID: <51C6187D.40007@ubique.se>
Date: Sat, 22 Jun 2013 23:34:53 +0200
From: Martin Lindhe <martin@ubique.se>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: unrecognized usb dvb stick Pinnacle ID  eb1a:2870
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



uname -a
Linux tp 3.9.7 #1 SMP Sat Jun 22 14:50:39 CEST 2013 x86_64 GNU/Linux


[ 8032.414689] usb 3-1.2: new high-speed USB device number 6 using ehci-pci
[ 8032.510932] usb 3-1.2: New USB device found, idVendor=eb1a, 
idProduct=2870
[ 8032.510940] usb 3-1.2: New USB device strings: Mfr=0, Product=1, 
SerialNumber=0
[ 8032.510944] usb 3-1.2: Product: USB 2870 Device
[ 8032.523474] em28xx: New device  USB 2870 Device @ 480 Mbps 
(eb1a:2870, interface 0, class 0)
[ 8032.523477] em28xx: Video interface 0 found: isoc
[ 8032.523479] em28xx: DVB interface 0 found: isoc
[ 8032.523654] em28xx: chip ID is em2870
[ 8032.604270] em2870 #0: i2c eeprom 00: 1a eb 67 95 1a eb 70 28 c0 12 
81 00 6a 22 00 00
[ 8032.604277] em2870 #0: i2c eeprom 10: 00 00 04 57 02 0d 00 00 00 00 
00 00 00 00 00 00
[ 8032.604282] em2870 #0: i2c eeprom 20: 44 00 00 00 f0 10 02 00 00 00 
00 00 5b 00 00 00
[ 8032.604287] em2870 #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 
00 00 0a 71 9a 4a
[ 8032.604292] em2870 #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[ 8032.604297] em2870 #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[ 8032.604301] em2870 #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 
22 03 55 00 53 00
[ 8032.604306] em2870 #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 37 00 
30 00 20 00 44 00
[ 8032.604311] em2870 #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00 
00 00 00 00 00 00
[ 8032.604315] em2870 #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[ 8032.604320] em2870 #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[ 8032.604325] em2870 #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[ 8032.604329] em2870 #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[ 8032.604334] em2870 #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[ 8032.604339] em2870 #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[ 8032.604343] em2870 #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[ 8032.604349] em2870 #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0xdc9c20c3
[ 8032.604351] em2870 #0: EEPROM info:
[ 8032.604352] em2870 #0:   No audio on board.
[ 8032.604353] em2870 #0:   500mA max power
[ 8032.604354] em2870 #0:   Table at 0x04, strings=0x226a, 0x0000, 0x0000
[ 8032.660852] em2870 #0: found i2c device @ 0xa0 [eeprom]
[ 8032.672016] em2870 #0: found i2c device @ 0xc0 [tuner (analog)]
[ 8032.693663] em2870 #0: Your board has no unique USB ID and thus need 
a hint to be detected.
[ 8032.693669] em2870 #0: You may try to use card=<n> insmod option to 
workaround that.
[ 8032.693671] em2870 #0: Please send an email with this log to:
[ 8032.693674] em2870 #0:   V4L Mailing List <linux-media@vger.kernel.org>
[ 8032.693676] em2870 #0: Board eeprom hash is 0xdc9c20c3
[ 8032.693679] em2870 #0: Board i2c devicelist hash is 0x4b800080
[ 8032.693682] em2870 #0: Here is a list of valid choices for the 
card=<n> insmod option:
[ 8032.693685] em2870 #0:     card=0 -> Unknown EM2800 video grabber
[ 8032.693689] em2870 #0:     card=1 -> Unknown EM2750/28xx video grabber
[ 8032.693692] em2870 #0:     card=2 -> Terratec Cinergy 250 USB
[ 8032.693694] em2870 #0:     card=3 -> Pinnacle PCTV USB 2
[ 8032.693697] em2870 #0:     card=4 -> Hauppauge WinTV USB 2
[ 8032.693700] em2870 #0:     card=5 -> MSI VOX USB 2.0
[ 8032.693704] em2870 #0:     card=6 -> Terratec Cinergy 200 USB
[ 8032.693706] em2870 #0:     card=7 -> Leadtek Winfast USB II
[ 8032.693709] em2870 #0:     card=8 -> Kworld USB2800
[ 8032.693712] em2870 #0:     card=9 -> Pinnacle Dazzle DVC 
90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2 / 
Plextor ConvertX PX-AV100U
[ 8032.693716] em2870 #0:     card=10 -> Hauppauge WinTV HVR 900
[ 8032.693718] em2870 #0:     card=11 -> Terratec Hybrid XS
[ 8032.693721] em2870 #0:     card=12 -> Kworld PVR TV 2800 RF
[ 8032.693724] em2870 #0:     card=13 -> Terratec Prodigy XS
[ 8032.693727] em2870 #0:     card=14 -> SIIG AVTuner-PVR / Pixelview 
Prolink PlayTV USB 2.0
[ 8032.693730] em2870 #0:     card=15 -> V-Gear PocketTV
[ 8032.693733] em2870 #0:     card=16 -> Hauppauge WinTV HVR 950
[ 8032.693735] em2870 #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[ 8032.693738] em2870 #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[ 8032.693741] em2870 #0:     card=19 -> EM2860/SAA711X Reference Design
[ 8032.693744] em2870 #0:     card=20 -> AMD ATI TV Wonder HD 600
[ 8032.693747] em2870 #0:     card=21 -> eMPIA Technology, Inc. 
GrabBeeX+ Video Encoder
[ 8032.693750] em2870 #0:     card=22 -> EM2710/EM2750/EM2751 webcam grabber
[ 8032.693753] em2870 #0:     card=23 -> Huaqi DLCW-130
[ 8032.693755] em2870 #0:     card=24 -> D-Link DUB-T210 TV Tuner
[ 8032.693758] em2870 #0:     card=25 -> Gadmei UTV310
[ 8032.693761] em2870 #0:     card=26 -> Hercules Smart TV USB 2.0
[ 8032.693764] em2870 #0:     card=27 -> Pinnacle PCTV USB 2 (Philips 
FM1216ME)
[ 8032.693767] em2870 #0:     card=28 -> Leadtek Winfast USB II Deluxe
[ 8032.693770] em2870 #0:     card=29 -> EM2860/TVP5150 Reference Design
[ 8032.693772] em2870 #0:     card=30 -> Videology 20K14XUSB USB2.0
[ 8032.693775] em2870 #0:     card=31 -> Usbgear VD204v9
[ 8032.693778] em2870 #0:     card=32 -> Supercomp USB 2.0 TV
[ 8032.693781] em2870 #0:     card=33 -> Elgato Video Capture
[ 8032.693784] em2870 #0:     card=34 -> Terratec Cinergy A Hybrid XS
[ 8032.693786] em2870 #0:     card=35 -> Typhoon DVD Maker
[ 8032.693789] em2870 #0:     card=36 -> NetGMBH Cam
[ 8032.693792] em2870 #0:     card=37 -> Gadmei UTV330
[ 8032.693795] em2870 #0:     card=38 -> Yakumo MovieMixer
[ 8032.693798] em2870 #0:     card=39 -> KWorld PVRTV 300U
[ 8032.693800] em2870 #0:     card=40 -> Plextor ConvertX PX-TV100U
[ 8032.693803] em2870 #0:     card=41 -> Kworld 350 U DVB-T
[ 8032.693806] em2870 #0:     card=42 -> Kworld 355 U DVB-T
[ 8032.693809] em2870 #0:     card=43 -> Terratec Cinergy T XS
[ 8032.693812] em2870 #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[ 8032.693814] em2870 #0:     card=45 -> Pinnacle PCTV DVB-T
[ 8032.693817] em2870 #0:     card=46 -> Compro, VideoMate U3
[ 8032.693820] em2870 #0:     card=47 -> KWorld DVB-T 305U
[ 8032.693823] em2870 #0:     card=48 -> KWorld DVB-T 310U
[ 8032.693825] em2870 #0:     card=49 -> MSI DigiVox A/D
[ 8032.693828] em2870 #0:     card=50 -> MSI DigiVox A/D II
[ 8032.693831] em2870 #0:     card=51 -> Terratec Hybrid XS Secam
[ 8032.693834] em2870 #0:     card=52 -> DNT DA2 Hybrid
[ 8032.693837] em2870 #0:     card=53 -> Pinnacle Hybrid Pro
[ 8032.693839] em2870 #0:     card=54 -> Kworld VS-DVB-T 323UR
[ 8032.693842] em2870 #0:     card=55 -> Terratec Cinnergy Hybrid T USB 
XS (em2882)
[ 8032.693845] em2870 #0:     card=56 -> Pinnacle Hybrid Pro (330e)
[ 8032.693848] em2870 #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[ 8032.693851] em2870 #0:     card=58 -> Compro VideoMate ForYou/Stereo
[ 8032.693854] em2870 #0:     card=59 -> (null)
[ 8032.693856] em2870 #0:     card=60 -> Hauppauge WinTV HVR 850
[ 8032.693859] em2870 #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[ 8032.693862] em2870 #0:     card=62 -> Gadmei TVR200
[ 8032.693865] em2870 #0:     card=63 -> Kaiomy TVnPC U2
[ 8032.693867] em2870 #0:     card=64 -> Easy Cap Capture DC-60
[ 8032.693870] em2870 #0:     card=65 -> IO-DATA GV-MVP/SZ
[ 8032.693873] em2870 #0:     card=66 -> Empire dual TV
[ 8032.693876] em2870 #0:     card=67 -> Terratec Grabby
[ 8032.693878] em2870 #0:     card=68 -> Terratec AV350
[ 8032.693882] em2870 #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[ 8032.693884] em2870 #0:     card=70 -> Evga inDtube
[ 8032.693887] em2870 #0:     card=71 -> Silvercrest Webcam 1.3mpix
[ 8032.693890] em2870 #0:     card=72 -> Gadmei UTV330+
[ 8032.693893] em2870 #0:     card=73 -> Reddo DVB-C USB TV Box
[ 8032.693896] em2870 #0:     card=74 -> Actionmaster/LinXcel/Digitus VC211A
[ 8032.693898] em2870 #0:     card=75 -> Dikom DK300
[ 8032.693901] em2870 #0:     card=76 -> KWorld PlusTV 340U or UB435-Q 
(ATSC)
[ 8032.693904] em2870 #0:     card=77 -> EM2874 Leadership ISDBT
[ 8032.693907] em2870 #0:     card=78 -> PCTV nanoStick T2 290e
[ 8032.693910] em2870 #0:     card=79 -> Terratec Cinergy H5
[ 8032.693912] em2870 #0:     card=80 -> PCTV DVB-S2 Stick (460e)
[ 8032.693915] em2870 #0:     card=81 -> Hauppauge WinTV HVR 930C
[ 8032.693918] em2870 #0:     card=82 -> Terratec Cinergy HTC Stick
[ 8032.693921] em2870 #0:     card=83 -> Honestech Vidbox NW03
[ 8032.693923] em2870 #0:     card=84 -> MaxMedia UB425-TC
[ 8032.693926] em2870 #0:     card=85 -> PCTV QuatroStick (510e)
[ 8032.693929] em2870 #0:     card=86 -> PCTV QuatroStick nano (520e)
[ 8032.693932] em2870 #0:     card=87 -> Terratec Cinergy HTC USB XS
[ 8032.693934] em2870 #0: Board not discovered
[ 8032.693938] em2870 #0: Identified as Unknown EM2750/28xx video 
grabber (card=1)
[ 8032.693941] em2870 #0: Your board has no unique USB ID and thus need 
a hint to be detected.
[ 8032.693944] em2870 #0: You may try to use card=<n> insmod option to 
workaround that.
[ 8032.693946] em2870 #0: Please send an email with this log to:
[ 8032.693949] em2870 #0:   V4L Mailing List <linux-media@vger.kernel.org>
[ 8032.693951] em2870 #0: Board eeprom hash is 0xdc9c20c3
[ 8032.693954] em2870 #0: Board i2c devicelist hash is 0x4b800080
[ 8032.693956] em2870 #0: Here is a list of valid choices for the 
card=<n> insmod option:
[ 8032.693959] em2870 #0:     card=0 -> Unknown EM2800 video grabber
[ 8032.693962] em2870 #0:     card=1 -> Unknown EM2750/28xx video grabber
[ 8032.693965] em2870 #0:     card=2 -> Terratec Cinergy 250 USB
[ 8032.693968] em2870 #0:     card=3 -> Pinnacle PCTV USB 2
[ 8032.693970] em2870 #0:     card=4 -> Hauppauge WinTV USB 2
[ 8032.693973] em2870 #0:     card=5 -> MSI VOX USB 2.0
[ 8032.693976] em2870 #0:     card=6 -> Terratec Cinergy 200 USB
[ 8032.693978] em2870 #0:     card=7 -> Leadtek Winfast USB II
[ 8032.693981] em2870 #0:     card=8 -> Kworld USB2800
[ 8032.693984] em2870 #0:     card=9 -> Pinnacle Dazzle DVC 
90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2 / 
Plextor ConvertX PX-AV100U
[ 8032.693987] em2870 #0:     card=10 -> Hauppauge WinTV HVR 900
[ 8032.693990] em2870 #0:     card=11 -> Terratec Hybrid XS
[ 8032.693993] em2870 #0:     card=12 -> Kworld PVR TV 2800 RF
[ 8032.693995] em2870 #0:     card=13 -> Terratec Prodigy XS
[ 8032.693998] em2870 #0:     card=14 -> SIIG AVTuner-PVR / Pixelview 
Prolink PlayTV USB 2.0
[ 8032.694001] em2870 #0:     card=15 -> V-Gear PocketTV
[ 8032.694004] em2870 #0:     card=16 -> Hauppauge WinTV HVR 950
[ 8032.694006] em2870 #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[ 8032.694009] em2870 #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[ 8032.694012] em2870 #0:     card=19 -> EM2860/SAA711X Reference Design
[ 8032.694015] em2870 #0:     card=20 -> AMD ATI TV Wonder HD 600
[ 8032.694017] em2870 #0:     card=21 -> eMPIA Technology, Inc. 
GrabBeeX+ Video Encoder
[ 8032.694020] em2870 #0:     card=22 -> EM2710/EM2750/EM2751 webcam grabber
[ 8032.694023] em2870 #0:     card=23 -> Huaqi DLCW-130
[ 8032.694026] em2870 #0:     card=24 -> D-Link DUB-T210 TV Tuner
[ 8032.694028] em2870 #0:     card=25 -> Gadmei UTV310
[ 8032.694031] em2870 #0:     card=26 -> Hercules Smart TV USB 2.0
[ 8032.694034] em2870 #0:     card=27 -> Pinnacle PCTV USB 2 (Philips 
FM1216ME)
[ 8032.694037] em2870 #0:     card=28 -> Leadtek Winfast USB II Deluxe
[ 8032.694040] em2870 #0:     card=29 -> EM2860/TVP5150 Reference Design
[ 8032.694042] em2870 #0:     card=30 -> Videology 20K14XUSB USB2.0
[ 8032.694045] em2870 #0:     card=31 -> Usbgear VD204v9
[ 8032.694048] em2870 #0:     card=32 -> Supercomp USB 2.0 TV
[ 8032.694050] em2870 #0:     card=33 -> Elgato Video Capture
[ 8032.694053] em2870 #0:     card=34 -> Terratec Cinergy A Hybrid XS
[ 8032.694056] em2870 #0:     card=35 -> Typhoon DVD Maker
[ 8032.694058] em2870 #0:     card=36 -> NetGMBH Cam
[ 8032.694061] em2870 #0:     card=37 -> Gadmei UTV330
[ 8032.694064] em2870 #0:     card=38 -> Yakumo MovieMixer
[ 8032.694066] em2870 #0:     card=39 -> KWorld PVRTV 300U
[ 8032.694069] em2870 #0:     card=40 -> Plextor ConvertX PX-TV100U
[ 8032.694072] em2870 #0:     card=41 -> Kworld 350 U DVB-T
[ 8032.694074] em2870 #0:     card=42 -> Kworld 355 U DVB-T
[ 8032.694077] em2870 #0:     card=43 -> Terratec Cinergy T XS
[ 8032.694080] em2870 #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[ 8032.694083] em2870 #0:     card=45 -> Pinnacle PCTV DVB-T
[ 8032.694085] em2870 #0:     card=46 -> Compro, VideoMate U3
[ 8032.694088] em2870 #0:     card=47 -> KWorld DVB-T 305U
[ 8032.694091] em2870 #0:     card=48 -> KWorld DVB-T 310U
[ 8032.694093] em2870 #0:     card=49 -> MSI DigiVox A/D
[ 8032.694096] em2870 #0:     card=50 -> MSI DigiVox A/D II
[ 8032.694099] em2870 #0:     card=51 -> Terratec Hybrid XS Secam
[ 8032.694101] em2870 #0:     card=52 -> DNT DA2 Hybrid
[ 8032.694104] em2870 #0:     card=53 -> Pinnacle Hybrid Pro
[ 8032.694107] em2870 #0:     card=54 -> Kworld VS-DVB-T 323UR
[ 8032.694110] em2870 #0:     card=55 -> Terratec Cinnergy Hybrid T USB 
XS (em2882)
[ 8032.694112] em2870 #0:     card=56 -> Pinnacle Hybrid Pro (330e)
[ 8032.694115] em2870 #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[ 8032.694118] em2870 #0:     card=58 -> Compro VideoMate ForYou/Stereo
[ 8032.694121] em2870 #0:     card=59 -> (null)
[ 8032.694123] em2870 #0:     card=60 -> Hauppauge WinTV HVR 850
[ 8032.694126] em2870 #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[ 8032.694129] em2870 #0:     card=62 -> Gadmei TVR200
[ 8032.694131] em2870 #0:     card=63 -> Kaiomy TVnPC U2
[ 8032.694134] em2870 #0:     card=64 -> Easy Cap Capture DC-60
[ 8032.694137] em2870 #0:     card=65 -> IO-DATA GV-MVP/SZ
[ 8032.694139] em2870 #0:     card=66 -> Empire dual TV
[ 8032.694142] em2870 #0:     card=67 -> Terratec Grabby
[ 8032.694145] em2870 #0:     card=68 -> Terratec AV350
[ 8032.694147] em2870 #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[ 8032.694150] em2870 #0:     card=70 -> Evga inDtube
[ 8032.694153] em2870 #0:     card=71 -> Silvercrest Webcam 1.3mpix
[ 8032.694155] em2870 #0:     card=72 -> Gadmei UTV330+
[ 8032.694158] em2870 #0:     card=73 -> Reddo DVB-C USB TV Box
[ 8032.694161] em2870 #0:     card=74 -> Actionmaster/LinXcel/Digitus VC211A
[ 8032.694163] em2870 #0:     card=75 -> Dikom DK300
[ 8032.694166] em2870 #0:     card=76 -> KWorld PlusTV 340U or UB435-Q 
(ATSC)
[ 8032.694169] em2870 #0:     card=77 -> EM2874 Leadership ISDBT
[ 8032.694172] em2870 #0:     card=78 -> PCTV nanoStick T2 290e
[ 8032.694174] em2870 #0:     card=79 -> Terratec Cinergy H5
[ 8032.694177] em2870 #0:     card=80 -> PCTV DVB-S2 Stick (460e)
[ 8032.694180] em2870 #0:     card=81 -> Hauppauge WinTV HVR 930C
[ 8032.694183] em2870 #0:     card=82 -> Terratec Cinergy HTC Stick
[ 8032.694185] em2870 #0:     card=83 -> Honestech Vidbox NW03
[ 8032.694188] em2870 #0:     card=84 -> MaxMedia UB425-TC
[ 8032.694191] em2870 #0:     card=85 -> PCTV QuatroStick (510e)
[ 8032.694194] em2870 #0:     card=86 -> PCTV QuatroStick nano (520e)
[ 8032.694196] em2870 #0:     card=87 -> Terratec Cinergy HTC USB XS
[ 8032.694202] em2870 #0: v4l2 driver version 0.1.3
[ 8032.703744] em2870 #0: V4L2 video device registered as video1
[ 8032.703748] em2870 #0: analog set to isoc mode.
[ 8032.703750] em2870 #0: dvb set to isoc mode.
[ 8032.704856] usbcore: registered new interface driver em28xx

