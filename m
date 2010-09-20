Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54249 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213Ab0ITNQC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Sep 2010 09:16:02 -0400
Received: by bwz11 with SMTP id 11so4204970bwz.19
        for <linux-media@vger.kernel.org>; Mon, 20 Sep 2010 06:15:59 -0700 (PDT)
Received: by bwz11 with SMTP id 11so4204932bwz.19
        for <linux-media@vger.kernel.org>; Mon, 20 Sep 2010 06:15:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C8FF30B.2080900@redhat.com>
References: <AANLkTinSB_ChWLnR=hQ6jAuRtgeLm0dze6f4mTy5buNt@mail.gmail.com>
	<4C8FF30B.2080900@redhat.com>
Date: Mon, 20 Sep 2010 15:15:56 +0200
Message-ID: <AANLkTinxtii3nA1=16RJsi6OM1AyFAbH5rEpD6jw6dR6@mail.gmail.com>
Subject: Re: Videomed Videosmart VX-3001
From: =?ISO-8859-2?Q?Pawe=B3_Ku=BCniar?= <pawel@kuzniar.com.pl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

> This patch should reduce the bus speed to 25 kHz, hopefully giving us more information
> about your device.
>
Here are logs with patched driver:

[115345.416343] usbcore: registered new interface driver em28xx
[115345.416350] em28xx driver loaded
[115397.552829] usb 1-3: new high speed USB device using ehci_hcd and address 21
[115397.704422] em28xx: New device @ 480 Mbps (eb1a:2861, interface 0, class 0)
[115397.704488] em28xx #0: chip ID is em2860
[115397.874880] em28xx #0: i2c eeprom 00: 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00
[115397.874894] em28xx #0: i2c eeprom 10: 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00
[115397.874905] em28xx #0: i2c eeprom 20: 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00
[115397.874917] em28xx #0: i2c eeprom 30: 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00
[115397.874928] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00
[115397.874940] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00
[115397.874951] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00
[115397.874962] em28xx #0: i2c eeprom 70: 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00
[115397.874974] em28xx #0: i2c eeprom 80: 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00
[115397.874985] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00
[115397.874996] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00
[115397.875008] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00
[115397.875019] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00
[115397.875031] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00
[115397.875042] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00
[115397.875053] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00
[115397.875065] em28xx #0: EEPROM ID= 0x00000000, EEPROM hash = 0x00000000
[115397.875067] em28xx #0: EEPROM info:
[115397.875069] em28xx #0:	No audio on board.
[115397.875071] em28xx #0:	500mA max power
[115397.875074] em28xx #0:	Table at 0x00, strings=0x0000, 0x0000, 0x0000
[115397.893261] Unknown Micron Sensor 0x0000
[115397.893269] em28xx #0: Identified as Unknown EM2750/28xx video
grabber (card=1)
[115397.893622] em28xx #0: found i2c device @ 0x0 [???]
[115397.893996] em28xx #0: found i2c device @ 0x2 [???]
[115397.894371] em28xx #0: found i2c device @ 0x4 [???]
[115397.894745] em28xx #0: found i2c device @ 0x6 [???]
[115397.895120] em28xx #0: found i2c device @ 0x8 [???]
[115397.895494] em28xx #0: found i2c device @ 0xa [???]
[115397.895870] em28xx #0: found i2c device @ 0xc [???]
[115397.896245] em28xx #0: found i2c device @ 0xe [???]
[115397.896619] em28xx #0: found i2c device @ 0x10 [???]
[115397.896995] em28xx #0: found i2c device @ 0x12 [???]
[115397.897369] em28xx #0: found i2c device @ 0x14 [???]
[115397.897749] em28xx #0: found i2c device @ 0x16 [???]
[115397.898121] em28xx #0: found i2c device @ 0x18 [???]
[115397.898498] em28xx #0: found i2c device @ 0x1a [???]
[115397.898870] em28xx #0: found i2c device @ 0x1c [???]
[115397.899243] em28xx #0: found i2c device @ 0x1e [???]
[115397.899622] em28xx #0: found i2c device @ 0x20 [???]
[115397.899996] em28xx #0: found i2c device @ 0x22 [???]
[115397.900485] em28xx #0: found i2c device @ 0x24 [???]
[115397.900859] em28xx #0: found i2c device @ 0x26 [???]
[115397.901244] em28xx #0: found i2c device @ 0x28 [???]
[115397.901619] em28xx #0: found i2c device @ 0x2a [???]
[115397.901994] em28xx #0: found i2c device @ 0x2c [???]
[115397.902368] em28xx #0: found i2c device @ 0x2e [???]
[115397.902735] em28xx #0: found i2c device @ 0x30 [???]
[115397.903116] em28xx #0: found i2c device @ 0x32 [???]
[115397.903488] em28xx #0: found i2c device @ 0x34 [???]
[115397.903867] em28xx #0: found i2c device @ 0x36 [???]
[115397.904245] em28xx #0: found i2c device @ 0x38 [???]
[115397.904619] em28xx #0: found i2c device @ 0x3a [???]
[115397.904987] em28xx #0: found i2c device @ 0x3c [???]
[115397.905370] em28xx #0: found i2c device @ 0x3e [???]
[115397.905748] em28xx #0: found i2c device @ 0x40 [???]
[115397.906116] em28xx #0: found i2c device @ 0x42 [???]
[115397.906488] em28xx #0: found i2c device @ 0x44 [???]
[115397.906870] em28xx #0: found i2c device @ 0x46 [???]
[115397.907245] em28xx #0: found i2c device @ 0x48 [???]
[115397.907612] em28xx #0: found i2c device @ 0x4a [saa7113h]
[115397.907995] em28xx #0: found i2c device @ 0x4c [???]
[115397.908369] em28xx #0: found i2c device @ 0x4e [???]
[115397.908745] em28xx #0: found i2c device @ 0x50 [???]
[115397.909111] em28xx #0: found i2c device @ 0x52 [???]
[115397.909495] em28xx #0: found i2c device @ 0x54 [???]
[115397.909864] em28xx #0: found i2c device @ 0x56 [???]
[115397.910237] em28xx #0: found i2c device @ 0x58 [???]
[115397.910614] em28xx #0: found i2c device @ 0x5a [???]
[115397.910981] em28xx #0: found i2c device @ 0x5c [???]
[115397.911369] em28xx #0: found i2c device @ 0x5e [???]
[115397.911744] em28xx #0: found i2c device @ 0x60 [remote IR sensor]
[115397.912115] em28xx #0: found i2c device @ 0x62 [???]
[115397.912494] em28xx #0: found i2c device @ 0x64 [???]
[115397.912861] em28xx #0: found i2c device @ 0x66 [???]
[115397.913245] em28xx #0: found i2c device @ 0x68 [???]
[115397.913617] em28xx #0: found i2c device @ 0x6a [???]
[115397.913994] em28xx #0: found i2c device @ 0x6c [???]
[115397.914366] em28xx #0: found i2c device @ 0x6e [???]
[115397.914745] em28xx #0: found i2c device @ 0x70 [???]
[115397.915118] em28xx #0: found i2c device @ 0x72 [???]
[115397.915494] em28xx #0: found i2c device @ 0x74 [???]
[115397.915862] em28xx #0: found i2c device @ 0x76 [???]
[115397.916242] em28xx #0: found i2c device @ 0x78 [???]
[115397.916618] em28xx #0: found i2c device @ 0x7a [???]
[115397.916993] em28xx #0: found i2c device @ 0x7c [???]
[115397.917370] em28xx #0: found i2c device @ 0x7e [???]
[115397.917742] em28xx #0: found i2c device @ 0x80 [msp34xx]
[115397.918119] em28xx #0: found i2c device @ 0x82 [???]
[115397.918487] em28xx #0: found i2c device @ 0x84 [???]
[115397.918868] em28xx #0: found i2c device @ 0x86 [tda9887]
[115397.919245] em28xx #0: found i2c device @ 0x88 [msp34xx]
[115397.919620] em28xx #0: found i2c device @ 0x8a [???]
[115397.919988] em28xx #0: found i2c device @ 0x8c [???]
[115397.920359] em28xx #0: found i2c device @ 0x8e [remote IR sensor]
[115397.920730] em28xx #0: found i2c device @ 0x90 [???]
[115397.921109] em28xx #0: found i2c device @ 0x92 [???]
[115397.921486] em28xx #0: found i2c device @ 0x94 [???]
[115397.921862] em28xx #0: found i2c device @ 0x96 [???]
[115397.922243] em28xx #0: found i2c device @ 0x98 [???]
[115397.922613] em28xx #0: found i2c device @ 0x9a [???]
[115397.922991] em28xx #0: found i2c device @ 0x9c [???]
[115397.923362] em28xx #0: found i2c device @ 0x9e [???]
[115397.923744] em28xx #0: found i2c device @ 0xa0 [eeprom]
[115397.924112] em28xx #0: found i2c device @ 0xa2 [???]
[115397.924493] em28xx #0: found i2c device @ 0xa4 [???]
[115397.924861] em28xx #0: found i2c device @ 0xa6 [???]
[115397.925242] em28xx #0: found i2c device @ 0xa8 [???]
[115397.925620] em28xx #0: found i2c device @ 0xaa [???]
[115397.925994] em28xx #0: found i2c device @ 0xac [???]
[115397.926369] em28xx #0: found i2c device @ 0xae [???]
[115397.926743] em28xx #0: found i2c device @ 0xb0 [tda9874]
[115397.927119] em28xx #0: found i2c device @ 0xb2 [???]
[115397.927495] em28xx #0: found i2c device @ 0xb4 [???]
[115397.927869] em28xx #0: found i2c device @ 0xb6 [???]
[115397.928237] em28xx #0: found i2c device @ 0xb8 [tvp5150a]
[115397.928619] em28xx #0: found i2c device @ 0xba [webcam sensor or tvp5150a]
[115397.928993] em28xx #0: found i2c device @ 0xbc [???]
[115397.929370] em28xx #0: found i2c device @ 0xbe [???]
[115397.929745] em28xx #0: found i2c device @ 0xc0 [tuner (analog)]
[115397.930115] em28xx #0: found i2c device @ 0xc2 [tuner (analog)]
[115397.930486] em28xx #0: found i2c device @ 0xc4 [tuner (analog)]
[115397.930859] em28xx #0: found i2c device @ 0xc6 [tuner (analog)]
[115397.931238] em28xx #0: found i2c device @ 0xc8 [???]
[115397.931615] em28xx #0: found i2c device @ 0xca [???]
[115397.931995] em28xx #0: found i2c device @ 0xcc [???]
[115397.932361] em28xx #0: found i2c device @ 0xce [???]
[115397.932740] em28xx #0: found i2c device @ 0xd0 [???]
[115397.933120] em28xx #0: found i2c device @ 0xd2 [???]
[115397.933486] em28xx #0: found i2c device @ 0xd4 [???]
[115397.933862] em28xx #0: found i2c device @ 0xd6 [???]
[115397.934245] em28xx #0: found i2c device @ 0xd8 [???]
[115397.934614] em28xx #0: found i2c device @ 0xda [???]
[115397.934995] em28xx #0: found i2c device @ 0xdc [???]
[115397.935361] em28xx #0: found i2c device @ 0xde [???]
[115397.935743] em28xx #0: found i2c device @ 0xe0 [???]
[115397.936119] em28xx #0: found i2c device @ 0xe2 [???]
[115397.936493] em28xx #0: found i2c device @ 0xe4 [???]
[115397.936869] em28xx #0: found i2c device @ 0xe6 [???]
[115397.937244] em28xx #0: found i2c device @ 0xe8 [???]
[115397.937619] em28xx #0: found i2c device @ 0xea [???]
[115397.937992] em28xx #0: found i2c device @ 0xec [???]
[115397.938369] em28xx #0: found i2c device @ 0xee [???]
[115397.938744] em28xx #0: found i2c device @ 0xf0 [???]
[115397.939117] em28xx #0: found i2c device @ 0xf2 [???]
[115397.939488] em28xx #0: found i2c device @ 0xf4 [???]
[115397.939869] em28xx #0: found i2c device @ 0xf6 [???]
[115397.940228] em28xx #0: found i2c device @ 0xf8 [???]
[115397.940615] em28xx #0: found i2c device @ 0xfa [???]
[115397.940986] em28xx #0: found i2c device @ 0xfc [???]
[115397.941365] em28xx #0: found i2c device @ 0xfe [???]
[115397.941370] em28xx #0: Your board has no unique USB ID and thus
need a hint to be detected.
[115397.941374] em28xx #0: You may try to use card=<n> insmod option
to workaround that.
[115397.941378] em28xx #0: Please send an email with this log to:
[115397.941381] em28xx #0: 	V4L Mailing List <linux-media@vger.kernel.org>
[115397.941384] em28xx #0: Board eeprom hash is 0x00000000
[115397.941388] em28xx #0: Board i2c devicelist hash is 0x7d2e7f80
[115397.941391] em28xx #0: Here is a list of valid choices for the
card=<n> insmod option:
[115397.941395] em28xx #0:     card=0 -> Unknown EM2800 video grabber
[115397.941399] em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
[115397.941402] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
[115397.941406] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
[115397.941409] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
[115397.941413] em28xx #0:     card=5 -> MSI VOX USB 2.0
[115397.941417] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
[115397.941420] em28xx #0:     card=7 -> Leadtek Winfast USB II
[115397.941424] em28xx #0:     card=8 -> Kworld USB2800
[115397.941427] em28xx #0:     card=9 -> Pinnacle Dazzle DVC
90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2
[115397.941432] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
[115397.941436] em28xx #0:     card=11 -> Terratec Hybrid XS
[115397.941439] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
[115397.941443] em28xx #0:     card=13 -> Terratec Prodigy XS
[115397.941447] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview
Prolink PlayTV USB 2.0
[115397.941451] em28xx #0:     card=15 -> V-Gear PocketTV
[115397.941454] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
[115397.941458] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[115397.941462] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[115397.941465] em28xx #0:     card=19 -> EM2860/SAA711X Reference Design
[115397.941469] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
[115397.941473] em28xx #0:     card=21 -> eMPIA Technology, Inc.
GrabBeeX+ Video Encoder
[115397.941477] em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam grabber
[115397.941481] em28xx #0:     card=23 -> Huaqi DLCW-130
[115397.941484] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
[115397.941488] em28xx #0:     card=25 -> Gadmei UTV310
[115397.941491] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
[115397.941495] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips FM1216ME)
[115397.941499] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
[115397.941503] em28xx #0:     card=29 -> EM2860/TVP5150 Reference Design
[115397.941506] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
[115397.941510] em28xx #0:     card=31 -> Usbgear VD204v9
[115397.941513] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
[115397.941517] em28xx #0:     card=33 -> (null)
[115397.941520] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
[115397.941524] em28xx #0:     card=35 -> Typhoon DVD Maker
[115397.941527] em28xx #0:     card=36 -> NetGMBH Cam
[115397.941531] em28xx #0:     card=37 -> Gadmei UTV330
[115397.941534] em28xx #0:     card=38 -> Yakumo MovieMixer
[115397.941538] em28xx #0:     card=39 -> KWorld PVRTV 300U
[115397.941541] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
[115397.941545] em28xx #0:     card=41 -> Kworld 350 U DVB-T
[115397.941548] em28xx #0:     card=42 -> Kworld 355 U DVB-T
[115397.941552] em28xx #0:     card=43 -> Terratec Cinergy T XS
[115397.941555] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[115397.941559] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
[115397.941562] em28xx #0:     card=46 -> Compro, VideoMate U3
[115397.941566] em28xx #0:     card=47 -> KWorld DVB-T 305U
[115397.941570] em28xx #0:     card=48 -> KWorld DVB-T 310U
[115397.941573] em28xx #0:     card=49 -> MSI DigiVox A/D
[115397.941577] em28xx #0:     card=50 -> MSI DigiVox A/D II
[115397.941580] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
[115397.941584] em28xx #0:     card=52 -> DNT DA2 Hybrid
[115397.941587] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
[115397.941596] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
[115397.941598] em28xx #0:     card=55 -> Terratec Hybrid XS (em2882)
[115397.941601] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (2)
[115397.941603] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[115397.941605] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
[115397.941607] em28xx #0:     card=59 -> (null)
[115397.941609] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
[115397.941611] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[115397.941613] em28xx #0:     card=62 -> Gadmei TVR200
[115397.941615] em28xx #0:     card=63 -> Kaiomy TVnPC U2
[115397.941617] em28xx #0:     card=64 -> Easy Cap Capture DC-60
[115397.941619] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
[115397.941621] em28xx #0:     card=66 -> Empire dual TV
[115397.941623] em28xx #0:     card=67 -> Terratec Grabby
[115397.941625] em28xx #0:     card=68 -> Terratec AV350
[115397.941627] em28xx #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[115397.941629] em28xx #0:     card=70 -> Evga inDtube
[115397.941631] em28xx #0:     card=71 -> Silvercrest Webcam 1.3mpix
[115397.941633] em28xx #0:     card=72 -> Gadmei UTV330+
[115397.941635] em28xx #0:     card=73 -> Reddo DVB-C USB TV Box
[115397.941638] em28xx #0:     card=74 -> Actionmaster/LinXcel/Digitus VC211A
[115397.941640] em28xx #0:     card=75 -> Dikom DK300
[115397.941740] em28xx #0: Config register raw data: 0x10
[115397.980130] em28xx #0: AC97 vendor ID = 0x64246424
[115398.000243] em28xx #0: AC97 features = 0x6424
[115398.000246] em28xx #0: Unknown AC97 audio processor detected!
[115398.680487] em28xx #0: v4l2 driver version 0.1.2
[115400.222694] em28xx #0: V4L2 video device registered as video0
[115400.222697] em28xx #0: V4L2 VBI device registered as vbi0
[115400.222759] em28xx audio device (eb1a:2861): interface 1, class 1
[115400.222801] em28xx audio device (eb1a:2861): interface 2, class 1
[115400.314789] 21:2:1: endpoint lacks sample rate attribute bit, cannot set.
[115400.314872] 21:2:2: endpoint lacks sample rate attribute bit, cannot set.
[115400.314998] 21:2:3: endpoint lacks sample rate attribute bit, cannot set.
[115400.315136] 21:2:4: endpoint lacks sample rate attribute bit, cannot set.
[115400.315259] 21:2:5: endpoint lacks sample rate attribute bit, cannot set.
[115400.319116] usbcore: registered new interface driver snd-usb-audio
[115400.473926] 21:2:2: endpoint lacks sample rate attribute bit, cannot set.
[115400.475911] 21:2:2: endpoint lacks sample rate attribute bit, cannot set.



lsub

Bus 001 Device 021: ID eb1a:2861 eMPIA Technology, Inc.
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0xeb1a eMPIA Technology, Inc.
  idProduct          0x2861
  bcdDevice            1.00
  iManufacturer           0
  iProduct                0
  iSerial                 0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          555
    bNumInterfaces          3
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0
      bInterfaceProtocol    255
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0001  1x 1 bytes
        bInterval              11
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0000  1x 0 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0000  1x 0 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       1
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0
      bInterfaceProtocol    255
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0001  1x 1 bytes
        bInterval              11
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0000  1x 0 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0000  1x 0 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       2
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0
      bInterfaceProtocol    255
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0001  1x 1 bytes
        bInterval              11
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0ad4  2x 724 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0000  1x 0 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       3
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0
      bInterfaceProtocol    255
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0001  1x 1 bytes
        bInterval              11
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0c00  2x 1024 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0000  1x 0 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       4
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0
      bInterfaceProtocol    255
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0001  1x 1 bytes
        bInterval              11
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x1300  3x 768 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0000  1x 0 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       5
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0
      bInterfaceProtocol    255
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0001  1x 1 bytes
        bInterval              11
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x135c  3x 860 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0000  1x 0 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       6
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0
      bInterfaceProtocol    255
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0001  1x 1 bytes
        bInterval              11
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x13c4  3x 964 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0000  1x 0 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       7
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0
      bInterfaceProtocol    255
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0001  1x 1 bytes
        bInterval              11
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x1400  3x 1024 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0000  1x 0 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass         1 Audio
      bInterfaceSubClass      1 Control Device
      bInterfaceProtocol      0
      iInterface              0
      AudioControl Interface Descriptor:
        bLength                 9
        bDescriptorType        36
        bDescriptorSubtype      1 (HEADER)
        bcdADC               1.00
        wTotalLength           39
        bInCollection           1
        baInterfaceNr( 0)       2
      AudioControl Interface Descriptor:
        bLength                12
        bDescriptorType        36
        bDescriptorSubtype      2 (INPUT_TERMINAL)
        bTerminalID             1
        wTerminalType      0x0603 Line Connector
        bAssocTerminal          0
        bNrChannels             2
        wChannelConfig     0x0003
          Left Front (L)
          Right Front (R)
        iChannelNames           0
        iTerminal               0
      AudioControl Interface Descriptor:
        bLength                 9
        bDescriptorType        36
        bDescriptorSubtype      6 (FEATURE_UNIT)
        bUnitID                 2
        bSourceID               1
        bControlSize            1
        bmaControls( 0)      0x03
          Mute
          Volume
        bmaControls( 1)      0x00
        iFeature                0
      AudioControl Interface Descriptor:
        bLength                 9
        bDescriptorType        36
        bDescriptorSubtype      3 (OUTPUT_TERMINAL)
        bTerminalID             3
        wTerminalType      0x0101 USB Streaming
        bAssocTerminal          0
        bSourceID               2
        iTerminal               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         1 Audio
      bInterfaceSubClass      2 Streaming
      bInterfaceProtocol      0
      iInterface              0
      AudioStreaming Interface Descriptor:
        bLength                 7
        bDescriptorType        36
        bDescriptorSubtype      1 (AS_GENERAL)
        bTerminalLink           3
        bDelay                  1 frames
        wFormatTag              1 PCM
      AudioStreaming Interface Descriptor:
        bLength                11
        bDescriptorType        36
        bDescriptorSubtype      2 (FORMAT_TYPE)
        bFormatType             1 (FORMAT_TYPE_I)
        bNrChannels             2
        bSubframeSize           2
        bBitResolution         16
        bSamFreqType            1 Discrete
        tSamFreq[ 0]            0
      Endpoint Descriptor:
        bLength                 9
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0000  1x 0 bytes
        bInterval               4
        bRefresh                0
        bSynchAddress           0
        AudioControl Endpoint Descriptor:
          bLength                 7
          bDescriptorType        37
          bDescriptorSubtype      1 (EP_GENERAL)
          bmAttributes         0x00
          bLockDelayUnits         0 Undefined
          wLockDelay              0 Undefined
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       1
      bNumEndpoints           1
      bInterfaceClass         1 Audio
      bInterfaceSubClass      2 Streaming
      bInterfaceProtocol      0
      iInterface              0
      AudioStreaming Interface Descriptor:
        bLength                 7
        bDescriptorType        36
        bDescriptorSubtype      1 (AS_GENERAL)
        bTerminalLink           3
        bDelay                  1 frames
        wFormatTag              1 PCM
      AudioStreaming Interface Descriptor:
        bLength                11
        bDescriptorType        36
        bDescriptorSubtype      2 (FORMAT_TYPE)
        bFormatType             1 (FORMAT_TYPE_I)
        bNrChannels             2
        bSubframeSize           2
        bBitResolution         16
        bSamFreqType            1 Discrete
        tSamFreq[ 0]        48000
      Endpoint Descriptor:
        bLength                 9
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x00c4  1x 196 bytes
        bInterval               4
        bRefresh                0
        bSynchAddress           0
        AudioControl Endpoint Descriptor:
          bLength                 7
          bDescriptorType        37
          bDescriptorSubtype      1 (EP_GENERAL)
          bmAttributes         0x00
          bLockDelayUnits         0 Undefined
          wLockDelay              0 Undefined
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       2
      bNumEndpoints           1
      bInterfaceClass         1 Audio
      bInterfaceSubClass      2 Streaming
      bInterfaceProtocol      0
      iInterface              0
      AudioStreaming Interface Descriptor:
        bLength                 7
        bDescriptorType        36
        bDescriptorSubtype      1 (AS_GENERAL)
        bTerminalLink           3
        bDelay                  1 frames
        wFormatTag              1 PCM
      AudioStreaming Interface Descriptor:
        bLength                11
        bDescriptorType        36
        bDescriptorSubtype      2 (FORMAT_TYPE)
        bFormatType             1 (FORMAT_TYPE_I)
        bNrChannels             2
        bSubframeSize           2
        bBitResolution         16
        bSamFreqType            1 Discrete
        tSamFreq[ 0]        44100
      Endpoint Descriptor:
        bLength                 9
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x00b4  1x 180 bytes
        bInterval               4
        bRefresh                0
        bSynchAddress           0
        AudioControl Endpoint Descriptor:
          bLength                 7
          bDescriptorType        37
          bDescriptorSubtype      1 (EP_GENERAL)
          bmAttributes         0x00
          bLockDelayUnits         0 Undefined
          wLockDelay              0 Undefined
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       3
      bNumEndpoints           1
      bInterfaceClass         1 Audio
      bInterfaceSubClass      2 Streaming
      bInterfaceProtocol      0
      iInterface              0
      AudioStreaming Interface Descriptor:
        bLength                 7
        bDescriptorType        36
        bDescriptorSubtype      1 (AS_GENERAL)
        bTerminalLink           3
        bDelay                  1 frames
        wFormatTag              1 PCM
      AudioStreaming Interface Descriptor:
        bLength                11
        bDescriptorType        36
        bDescriptorSubtype      2 (FORMAT_TYPE)
        bFormatType             1 (FORMAT_TYPE_I)
        bNrChannels             2
        bSubframeSize           2
        bBitResolution         16
        bSamFreqType            1 Discrete
        tSamFreq[ 0]        32000
      Endpoint Descriptor:
        bLength                 9
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0084  1x 132 bytes
        bInterval               4
        bRefresh                0
        bSynchAddress           0
        AudioControl Endpoint Descriptor:
          bLength                 7
          bDescriptorType        37
          bDescriptorSubtype      1 (EP_GENERAL)
          bmAttributes         0x00
          bLockDelayUnits         0 Undefined
          wLockDelay              0 Undefined
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       4
      bNumEndpoints           1
      bInterfaceClass         1 Audio
      bInterfaceSubClass      2 Streaming
      bInterfaceProtocol      0
      iInterface              0
      AudioStreaming Interface Descriptor:
        bLength                 7
        bDescriptorType        36
        bDescriptorSubtype      1 (AS_GENERAL)
        bTerminalLink           3
        bDelay                  1 frames
        wFormatTag              1 PCM
      AudioStreaming Interface Descriptor:
        bLength                11
        bDescriptorType        36
        bDescriptorSubtype      2 (FORMAT_TYPE)
        bFormatType             1 (FORMAT_TYPE_I)
        bNrChannels             2
        bSubframeSize           2
        bBitResolution         16
        bSamFreqType            1 Discrete
        tSamFreq[ 0]        16000
      Endpoint Descriptor:
        bLength                 9
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0044  1x 68 bytes
        bInterval               4
        bRefresh                0
        bSynchAddress           0
        AudioControl Endpoint Descriptor:
          bLength                 7
          bDescriptorType        37
          bDescriptorSubtype      1 (EP_GENERAL)
          bmAttributes         0x00
          bLockDelayUnits         0 Undefined
          wLockDelay              0 Undefined
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       5
      bNumEndpoints           1
      bInterfaceClass         1 Audio
      bInterfaceSubClass      2 Streaming
      bInterfaceProtocol      0
      iInterface              0
      AudioStreaming Interface Descriptor:
        bLength                 7
        bDescriptorType        36
        bDescriptorSubtype      1 (AS_GENERAL)
        bTerminalLink           3
        bDelay                  1 frames
        wFormatTag              1 PCM
      AudioStreaming Interface Descriptor:
        bLength                11
        bDescriptorType        36
        bDescriptorSubtype      2 (FORMAT_TYPE)
        bFormatType             1 (FORMAT_TYPE_I)
        bNrChannels             2
        bSubframeSize           2
        bBitResolution         16
        bSamFreqType            1 Discrete
        tSamFreq[ 0]         8000
      Endpoint Descriptor:
        bLength                 9
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0024  1x 36 bytes
        bInterval               4
        bRefresh                0
        bSynchAddress           0
        AudioControl Endpoint Descriptor:
          bLength                 7
          bDescriptorType        37
          bDescriptorSubtype      1 (EP_GENERAL)
          bmAttributes         0x00
          bLockDelayUnits         0 Undefined
          wLockDelay              0 Undefined
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)


------------------
pozdrawiam
Pawe³ Ku¼niar
