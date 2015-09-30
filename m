Return-path: <linux-media-owner@vger.kernel.org>
Received: from vega.shootfor.net ([37.221.192.211]:45116 "EHLO
	vega.shootfor.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932885AbbI3Sa7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Sep 2015 14:30:59 -0400
Received: from localhost (localhost [127.0.0.1])
	by vega.shootfor.net (Postfix) with ESMTP id AD9E73012DF
	for <linux-media@vger.kernel.org>; Wed, 30 Sep 2015 20:22:50 +0200 (CEST)
Received: from vega.shootfor.net ([127.0.0.1])
	by localhost (vega.shootfor.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UcR9sl2Y0dfg for <linux-media@vger.kernel.org>;
	Wed, 30 Sep 2015 20:22:44 +0200 (CEST)
Received: from [IPv6:2003:58:a70c:c100:ec54:8220:6a0b:a62c] (p20030058A70CC100EC5482206A0BA62C.dip0.t-ipconnect.de [IPv6:2003:58:a70c:c100:ec54:8220:6a0b:a62c])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by vega.shootfor.net (Postfix) with ESMTPSA id B7446300E1D
	for <linux-media@vger.kernel.org>; Wed, 30 Sep 2015 20:22:43 +0200 (CEST)
From: Mathias Kohrt <mkohrt@shootfor.net>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: MSI Movie VOX Mini Plus ... not working
Message-Id: <CBA2A69C-17F5-4D83-9D10-56A77B94A738@shootfor.net>
Date: Wed, 30 Sep 2015 20:22:42 +0200
To: V4L Mailing List <linux-media@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[    4.392391] em2860 #0: found i2c device @ 0xa0 on bus 0 [eeprom]
[    4.395446] em2860 #0: found i2c device @ 0xb8 on bus 0 [tvp5150a]
[    4.403657] em2860 #0: Your board has no unique USB ID and thus need a hint to be detected.
[    4.403674] em2860 #0: You may try to use card=<n> insmod option to workaround that.
[    4.403682] em2860 #0: Please send an email with this log to:
[    4.403690] em2860 #0: 	V4L Mailing List <linux-media@vger.kernel.org>
[    4.403697] em2860 #0: Board eeprom hash is 0x00000000
[    4.403705] em2860 #0: Board i2c devicelist hash is 0x27800080
[    4.403712] em2860 #0: Here is a list of valid choices for the card=<n> insmod option:
[    4.403720] em2860 #0:     card=0 -> Unknown EM2800 video grabber
[    4.403729] em2860 #0:     card=1 -> Unknown EM2750/28xx video grabber
[    4.403737] em2860 #0:     card=2 -> Terratec Cinergy 250 USB
[    4.403745] em2860 #0:     card=3 -> Pinnacle PCTV USB 2
[    4.403752] em2860 #0:     card=4 -> Hauppauge WinTV USB 2
[    4.403760] em2860 #0:     card=5 -> MSI VOX USB 2.0
[    4.403768] em2860 #0:     card=6 -> Terratec Cinergy 200 USB
[    4.403776] em2860 #0:     card=7 -> Leadtek Winfast USB II
[    4.403784] em2860 #0:     card=8 -> Kworld USB2800
[    4.403793] em2860 #0:     card=9 -> Pinnacle Dazzle DVC 90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2 / Plextor ConvertX PX-AV100U
[    4.403802] em2860 #0:     card=10 -> Hauppauge WinTV HVR 900
[    4.403810] em2860 #0:     card=11 -> Terratec Hybrid XS
[    4.403818] em2860 #0:     card=12 -> Kworld PVR TV 2800 RF
[    4.403826] em2860 #0:     card=13 -> Terratec Prodigy XS
[    4.403835] em2860 #0:     card=14 -> SIIG AVTuner-PVR / Pixelview Prolink PlayTV USB 2.0
[    4.403843] em2860 #0:     card=15 -> V-Gear PocketTV
[    4.403852] em2860 #0:     card=16 -> Hauppauge WinTV HVR 950
[    4.403860] em2860 #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[    4.403868] em2860 #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[    4.403876] em2860 #0:     card=19 -> EM2860/SAA711X Reference Design
[    4.403885] em2860 #0:     card=20 -> AMD ATI TV Wonder HD 600
[    4.403893] em2860 #0:     card=21 -> eMPIA Technology, Inc. GrabBeeX+ Video Encoder
[    4.403901] em2860 #0:     card=22 -> EM2710/EM2750/EM2751 webcam grabber
[    4.403909] em2860 #0:     card=23 -> Huaqi DLCW-130
[    4.403917] em2860 #0:     card=24 -> D-Link DUB-T210 TV Tuner
[    4.403926] em2860 #0:     card=25 -> Gadmei UTV310
[    4.403934] em2860 #0:     card=26 -> Hercules Smart TV USB 2.0
[    4.403942] em2860 #0:     card=27 -> Pinnacle PCTV USB 2 (Philips FM1216ME)
[    4.403950] em2860 #0:     card=28 -> Leadtek Winfast USB II Deluxe
[    4.403958] em2860 #0:     card=29 -> EM2860/TVP5150 Reference Design
[    4.403967] em2860 #0:     card=30 -> Videology 20K14XUSB USB2.0
[    4.403974] em2860 #0:     card=31 -> Usbgear VD204v9
[    4.403983] em2860 #0:     card=32 -> Supercomp USB 2.0 TV
[    4.403991] em2860 #0:     card=33 -> Elgato Video Capture
[    4.403999] em2860 #0:     card=34 -> Terratec Cinergy A Hybrid XS
[    4.404007] em2860 #0:     card=35 -> Typhoon DVD Maker
[    4.404016] em2860 #0:     card=36 -> NetGMBH Cam
[    4.404024] em2860 #0:     card=37 -> Gadmei UTV330
[    4.404032] em2860 #0:     card=38 -> Yakumo MovieMixer
[    4.404040] em2860 #0:     card=39 -> KWorld PVRTV 300U
[    4.404048] em2860 #0:     card=40 -> Plextor ConvertX PX-TV100U
[    4.404056] em2860 #0:     card=41 -> Kworld 350 U DVB-T
[    4.404064] em2860 #0:     card=42 -> Kworld 355 U DVB-T
[    4.404072] em2860 #0:     card=43 -> Terratec Cinergy T XS
[    4.404080] em2860 #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[    4.404088] em2860 #0:     card=45 -> Pinnacle PCTV DVB-T
[    4.404096] em2860 #0:     card=46 -> Compro, VideoMate U3
[    4.404104] em2860 #0:     card=47 -> KWorld DVB-T 305U
[    4.404112] em2860 #0:     card=48 -> KWorld DVB-T 310U
[    4.404120] em2860 #0:     card=49 -> MSI DigiVox A/D
[    4.404128] em2860 #0:     card=50 -> MSI DigiVox A/D II
[    4.404136] em2860 #0:     card=51 -> Terratec Hybrid XS Secam
[    4.404144] em2860 #0:     card=52 -> DNT DA2 Hybrid
[    4.404152] em2860 #0:     card=53 -> Pinnacle Hybrid Pro
[    4.404160] em2860 #0:     card=54 -> Kworld VS-DVB-T 323UR
[    4.404168] em2860 #0:     card=55 -> Terratec Cinnergy Hybrid T USB XS (em2882)
[    4.404176] em2860 #0:     card=56 -> Pinnacle Hybrid Pro (330e)
[    4.404184] em2860 #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[    4.404193] em2860 #0:     card=58 -> Compro VideoMate ForYou/Stereo
[    4.404201] em2860 #0:     card=59 -> Pinnacle PCTV HD Mini
[    4.404209] em2860 #0:     card=60 -> Hauppauge WinTV HVR 850
[    4.404217] em2860 #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[    4.404225] em2860 #0:     card=62 -> Gadmei TVR200
[    4.404233] em2860 #0:     card=63 -> Kaiomy TVnPC U2
[    4.404241] em2860 #0:     card=64 -> Easy Cap Capture DC-60
[    4.404249] em2860 #0:     card=65 -> IO-DATA GV-MVP/SZ
[    4.404257] em2860 #0:     card=66 -> Empire dual TV
[    4.404265] em2860 #0:     card=67 -> Terratec Grabby
[    4.404273] em2860 #0:     card=68 -> Terratec AV350
[    4.404281] em2860 #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[    4.404289] em2860 #0:     card=70 -> Evga inDtube
[    4.404298] em2860 #0:     card=71 -> Silvercrest Webcam 1.3mpix
[    4.404306] em2860 #0:     card=72 -> Gadmei UTV330+
[    4.404314] em2860 #0:     card=73 -> Reddo DVB-C USB TV Box
[    4.404322] em2860 #0:     card=74 -> Actionmaster/LinXcel/Digitus VC211A
[    4.404330] em2860 #0:     card=75 -> Dikom DK300
[    4.404338] em2860 #0:     card=76 -> KWorld PlusTV 340U or UB435-Q (ATSC)
[    4.404346] em2860 #0:     card=77 -> EM2874 Leadership ISDBT
[    4.404354] em2860 #0:     card=78 -> PCTV nanoStick T2 290e
[    4.404362] em2860 #0:     card=79 -> Terratec Cinergy H5
[    4.404371] em2860 #0:     card=80 -> PCTV DVB-S2 Stick (460e)
[    4.404379] em2860 #0:     card=81 -> Hauppauge WinTV HVR 930C
[    4.404387] em2860 #0:     card=82 -> Terratec Cinergy HTC Stick
[    4.404395] em2860 #0:     card=83 -> Honestech Vidbox NW03
[    4.404403] em2860 #0:     card=84 -> MaxMedia UB425-TC
[    4.404411] em2860 #0:     card=85 -> PCTV QuatroStick (510e)
[    4.404419] em2860 #0:     card=86 -> PCTV QuatroStick nano (520e)
[    4.404427] em2860 #0:     card=87 -> Terratec Cinergy HTC USB XS
[    4.404435] em2860 #0:     card=88 -> C3 Tech Digital Duo HDTV/SDTV USB
[    4.404443] em2860 #0:     card=89 -> Delock 61959
[    4.404452] em2860 #0:     card=90 -> KWorld USB ATSC TV Stick UB435-Q V2
[    4.404461] em2860 #0:     card=91 -> SpeedLink Vicious And Devine Laplace webcam
[    4.404469] em2860 #0:     card=92 -> PCTV DVB-S2 Stick (461e)
[    4.404477] em2860 #0:     card=93 -> KWorld USB ATSC TV Stick UB435-Q V3
[    4.404486] em2860 #0:     card=94 -> PCTV tripleStick (292e)
[    4.404494] em2860 #0:     card=95 -> Leadtek VC100
[    4.404502] em2860 #0:     card=96 -> Terratec Cinergy T2 Stick HD
[    4.404510] em2860 #0:     card=97 -> Elgato EyeTV Hybrid 2008 INT
[    4.404518] em2860 #0: Board not discovered
[    4.404526] em2860 #0: Identified as Unknown EM2750/28xx video grabber (card=1)
[    4.404535] em2860 #0: Your board has no unique USB ID and thus need a hint to be detected.
[    4.404543] em2860 #0: You may try to use card=<n> insmod option to workaround that.
[    4.404549] em2860 #0: Please send an email with this log to:
[    4.404556] em2860 #0: 	V4L Mailing List <linux-media@vger.kernel.org>
[    4.404564] em2860 #0: Board eeprom hash is 0x00000000
[    4.404571] em2860 #0: Board i2c devicelist hash is 0x27800080
[    4.404578] em2860 #0: Here is a list of valid choices for the card=<n> insmod option:
[    4.404586] em2860 #0:     card=0 -> Unknown EM2800 video grabber
[    4.404594] em2860 #0:     card=1 -> Unknown EM2750/28xx video grabber
[    4.404602] em2860 #0:     card=2 -> Terratec Cinergy 250 USB
[    4.404609] em2860 #0:     card=3 -> Pinnacle PCTV USB 2
[    4.404617] em2860 #0:     card=4 -> Hauppauge WinTV USB 2
[    4.404624] em2860 #0:     card=5 -> MSI VOX USB 2.0
[    4.404632] em2860 #0:     card=6 -> Terratec Cinergy 200 USB
[    4.404640] em2860 #0:     card=7 -> Leadtek Winfast USB II
[    4.404647] em2860 #0:     card=8 -> Kworld USB2800
[    4.404656] em2860 #0:     card=9 -> Pinnacle Dazzle DVC 90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2 / Plextor ConvertX PX-AV100U
[    4.404665] em2860 #0:     card=10 -> Hauppauge WinTV HVR 900
[    4.404673] em2860 #0:     card=11 -> Terratec Hybrid XS
[    4.404680] em2860 #0:     card=12 -> Kworld PVR TV 2800 RF
[    4.404688] em2860 #0:     card=13 -> Terratec Prodigy XS
[    4.404696] em2860 #0:     card=14 -> SIIG AVTuner-PVR / Pixelview Prolink PlayTV USB 2.0
[    4.404704] em2860 #0:     card=15 -> V-Gear PocketTV
[    4.404712] em2860 #0:     card=16 -> Hauppauge WinTV HVR 950
[    4.404720] em2860 #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[    4.404728] em2860 #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[    4.404736] em2860 #0:     card=19 -> EM2860/SAA711X Reference Design
[    4.404744] em2860 #0:     card=20 -> AMD ATI TV Wonder HD 600
[    4.404752] em2860 #0:     card=21 -> eMPIA Technology, Inc. GrabBeeX+ Video Encoder
[    4.404761] em2860 #0:     card=22 -> EM2710/EM2750/EM2751 webcam grabber
[    4.404768] em2860 #0:     card=23 -> Huaqi DLCW-130
[    4.404776] em2860 #0:     card=24 -> D-Link DUB-T210 TV Tuner
[    4.404784] em2860 #0:     card=25 -> Gadmei UTV310
[    4.404792] em2860 #0:     card=26 -> Hercules Smart TV USB 2.0
[    4.404800] em2860 #0:     card=27 -> Pinnacle PCTV USB 2 (Philips FM1216ME)
[    4.404808] em2860 #0:     card=28 -> Leadtek Winfast USB II Deluxe
[    4.404816] em2860 #0:     card=29 -> EM2860/TVP5150 Reference Design
[    4.404824] em2860 #0:     card=30 -> Videology 20K14XUSB USB2.0
[    4.404832] em2860 #0:     card=31 -> Usbgear VD204v9
[    4.404840] em2860 #0:     card=32 -> Supercomp USB 2.0 TV
[    4.404847] em2860 #0:     card=33 -> Elgato Video Capture
[    4.404855] em2860 #0:     card=34 -> Terratec Cinergy A Hybrid XS
[    4.404863] em2860 #0:     card=35 -> Typhoon DVD Maker
[    4.404871] em2860 #0:     card=36 -> NetGMBH Cam
[    4.404878] em2860 #0:     card=37 -> Gadmei UTV330
[    4.404886] em2860 #0:     card=38 -> Yakumo MovieMixer
[    4.404894] em2860 #0:     card=39 -> KWorld PVRTV 300U
[    4.404902] em2860 #0:     card=40 -> Plextor ConvertX PX-TV100U
[    4.404910] em2860 #0:     card=41 -> Kworld 350 U DVB-T
[    4.404917] em2860 #0:     card=42 -> Kworld 355 U DVB-T
[    4.404925] em2860 #0:     card=43 -> Terratec Cinergy T XS
[    4.404933] em2860 #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[    4.404941] em2860 #0:     card=45 -> Pinnacle PCTV DVB-T
[    4.404949] em2860 #0:     card=46 -> Compro, VideoMate U3
[    4.404957] em2860 #0:     card=47 -> KWorld DVB-T 305U
[    4.404965] em2860 #0:     card=48 -> KWorld DVB-T 310U
[    4.404972] em2860 #0:     card=49 -> MSI DigiVox A/D
[    4.404980] em2860 #0:     card=50 -> MSI DigiVox A/D II
[    4.404988] em2860 #0:     card=51 -> Terratec Hybrid XS Secam
[    4.404996] em2860 #0:     card=52 -> DNT DA2 Hybrid
[    4.405003] em2860 #0:     card=53 -> Pinnacle Hybrid Pro
[    4.405011] em2860 #0:     card=54 -> Kworld VS-DVB-T 323UR
[    4.405019] em2860 #0:     card=55 -> Terratec Cinnergy Hybrid T USB XS (em2882)
[    4.405027] em2860 #0:     card=56 -> Pinnacle Hybrid Pro (330e)
[    4.405035] em2860 #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[    4.405043] em2860 #0:     card=58 -> Compro VideoMate ForYou/Stereo
[    4.405051] em2860 #0:     card=59 -> Pinnacle PCTV HD Mini
[    4.405059] em2860 #0:     card=60 -> Hauppauge WinTV HVR 850
[    4.405066] em2860 #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[    4.405074] em2860 #0:     card=62 -> Gadmei TVR200
[    4.405083] em2860 #0:     card=63 -> Kaiomy TVnPC U2
[    4.405090] em2860 #0:     card=64 -> Easy Cap Capture DC-60
[    4.405098] em2860 #0:     card=65 -> IO-DATA GV-MVP/SZ
[    4.405106] em2860 #0:     card=66 -> Empire dual TV
[    4.405113] em2860 #0:     card=67 -> Terratec Grabby
[    4.405121] em2860 #0:     card=68 -> Terratec AV350
[    4.405129] em2860 #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[    4.405137] em2860 #0:     card=70 -> Evga inDtube
[    4.405145] em2860 #0:     card=71 -> Silvercrest Webcam 1.3mpix
[    4.405152] em2860 #0:     card=72 -> Gadmei UTV330+
[    4.405160] em2860 #0:     card=73 -> Reddo DVB-C USB TV Box
[    4.405168] em2860 #0:     card=74 -> Actionmaster/LinXcel/Digitus VC211A
[    4.405176] em2860 #0:     card=75 -> Dikom DK300
[    4.405184] em2860 #0:     card=76 -> KWorld PlusTV 340U or UB435-Q (ATSC)
[    4.405192] em2860 #0:     card=77 -> EM2874 Leadership ISDBT
[    4.405199] em2860 #0:     card=78 -> PCTV nanoStick T2 290e
[    4.405207] em2860 #0:     card=79 -> Terratec Cinergy H5
[    4.405215] em2860 #0:     card=80 -> PCTV DVB-S2 Stick (460e)
[    4.405223] em2860 #0:     card=81 -> Hauppauge WinTV HVR 930C
[    4.405231] em2860 #0:     card=82 -> Terratec Cinergy HTC Stick
[    4.405239] em2860 #0:     card=83 -> Honestech Vidbox NW03
[    4.405246] em2860 #0:     card=84 -> MaxMedia UB425-TC
[    4.405254] em2860 #0:     card=85 -> PCTV QuatroStick (510e)
[    4.405262] em2860 #0:     card=86 -> PCTV QuatroStick nano (520e)
[    4.405270] em2860 #0:     card=87 -> Terratec Cinergy HTC USB XS
[    4.405278] em2860 #0:     card=88 -> C3 Tech Digital Duo HDTV/SDTV USB
[    4.405286] em2860 #0:     card=89 -> Delock 61959
[    4.405294] em2860 #0:     card=90 -> KWorld USB ATSC TV Stick UB435-Q V2
[    4.405302] em2860 #0:     card=91 -> SpeedLink Vicious And Devine Laplace webcam
[    4.405310] em2860 #0:     card=92 -> PCTV DVB-S2 Stick (461e)
[    4.405318] em2860 #0:     card=93 -> KWorld USB ATSC TV Stick UB435-Q V3
[    4.405326] em2860 #0:     card=94 -> PCTV tripleStick (292e)
[    4.405334] em2860 #0:     card=95 -> Leadtek VC100
[    4.405342] em2860 #0:     card=96 -> Terratec Cinergy T2 Stick HD
[    4.405350] em2860 #0:     card=97 -> Elgato EyeTV Hybrid 2008 INT
[    4.405361] em2860 #0: analog set to isoc mode.
[    4.405647] em28xx audio device (eb1a:2861): interface 1, class 1
[    4.405714] em28xx audio device (eb1a:2861): interface 2, class 1
[    4.405870] usbcore: registered new interface driver em28xx
[    4.488556] usbcore: registered new interface driver snd-usb-audio