Return-path: <mchehab@localhost>
Received: from hosting.nplay.pl ([84.201.208.50]:53589 "EHLO
	server.hosting.nplay.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830Ab1GMN7C (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2011 09:59:02 -0400
Received: from nat.nplay.net.pl ([86.63.142.200] helo=[10.1.1.124])
	by server.hosting.nplay.pl with esmtpsa (TLSv1:CAMELLIA256-SHA:256)
	(Exim 4.69)
	(envelope-from <siedar@pronet.lublin.pl>)
	id 1Qgz5e-000LHo-9C
	for linux-media@vger.kernel.org; Wed, 13 Jul 2011 15:02:58 +0200
Message-ID: <4E1D988B.2080004@pronet.lublin.pl>
Date: Wed, 13 Jul 2011 15:07:23 +0200
From: Dariusz Siedlecki <siedar@pronet.lublin.pl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: USB DVR BOX - name AXD USB04V2A-T
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Ubuntu 11.04


siedar@haven:~$ uname -a
Linux haven 2.6.38-10-generic #46-Ubuntu SMP Tue Jun 28 15:05:41 UTC 
2011 i686 i686 i386 GNU/Linux

This card have 4xVideo, 2xaudio, 25cl/s H.264

Is not recognized by system.

Darek

[12033.092138] usb 1-3: new high speed USB device using ehci_hcd and 
address 6
[12033.273017] IR NEC protocol handler initialized
[12033.276725] IR RC5(x) protocol handler initialized
[12033.287991] Linux video capture interface: v2.00
[12033.294909] IR RC6 protocol handler initialized
[12033.299655] IR JVC protocol handler initialized
[12033.304295] IR Sony protocol handler initialized
[12033.307742] em28xx: New device USB CAP Device @ 480 Mbps (eb1a:2861, 
interface 0, class 0)
[12033.308732] em28xx #0: chip ID is em2860
[12033.312154] lirc_dev: IR Remote Control driver registered, major 249
[12033.314257] IR LIRC bridge handler initialized
[12033.442096] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 61 28 d0 00 
20 03 6a 20 00 00
[12033.442129] em28xx #0: i2c eeprom 10: 00 00 04 57 06 02 00 00 00 00 
00 00 00 00 00 00
[12033.442159] em28xx #0: i2c eeprom 20: 02 00 01 00 f0 10 01 00 88 00 
00 00 5b 00 00 00
[12033.442189] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 10 01 
00 00 00 00 00 00
[12033.442218] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[12033.442248] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[12033.442277] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 
20 03 55 00 53 00
[12033.442306] em28xx #0: i2c eeprom 70: 42 00 20 00 43 00 41 00 50 00 
20 00 44 00 65 00
[12033.442335] em28xx #0: i2c eeprom 80: 76 00 69 00 63 00 65 00 00 00 
00 00 00 00 00 00
[12033.442365] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[12033.442394] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[12033.442423] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[12033.442452] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[12033.442481] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[12033.442510] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[12033.442539] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[12033.442572] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0xf4675b8a
[12033.442577] em28xx #0: EEPROM info:
[12033.442582] em28xx #0:    AC97 audio (5 sample rates)
[12033.442586] em28xx #0:    500mA max power
[12033.442592] em28xx #0:    Table at 0x04, strings=0x206a, 0x0000, 0x0000
[12033.478597] em28xx #0: found i2c device @ 0x88 [msp34xx]
[12033.483080] em28xx #0: found i2c device @ 0xa0 [eeprom]
[12033.483467] em28xx #0: found i2c device @ 0xa2 [???]
[12033.500971] em28xx #0: Your board has no unique USB ID and thus need 
a hint to be detected.
[12033.500980] em28xx #0: You may try to use card=<n> insmod option to 
workaround that.
[12033.500986] em28xx #0: Please send an email with this log to:
[12033.500990] em28xx #0:     V4L Mailing List <linux-media@vger.kernel.org>
[12033.500996] em28xx #0: Board eeprom hash is 0xf4675b8a
[12033.501002] em28xx #0: Board i2c devicelist hash is 0x2fd10080
[12033.501007] em28xx #0: Here is a list of valid choices for the 
card=<n> insmod option:
[12033.501014] em28xx #0:     card=0 -> Unknown EM2800 video grabber
[12033.501020] em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
[12033.501026] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
[12033.501032] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
[12033.501038] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
[12033.501044] em28xx #0:     card=5 -> MSI VOX USB 2.0
[12033.501049] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
[12033.501055] em28xx #0:     card=7 -> Leadtek Winfast USB II
[12033.501060] em28xx #0:     card=8 -> Kworld USB2800
[12033.501066] em28xx #0:     card=9 -> Pinnacle Dazzle DVC 
90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2
[12033.501073] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
[12033.501079] em28xx #0:     card=11 -> Terratec Hybrid XS
[12033.501085] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
[12033.501091] em28xx #0:     card=13 -> Terratec Prodigy XS
[12033.501097] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview 
Prolink PlayTV USB 2.0
[12033.501103] em28xx #0:     card=15 -> V-Gear PocketTV
[12033.501109] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
[12033.501115] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[12033.501121] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[12033.501127] em28xx #0:     card=19 -> EM2860/SAA711X Reference Design
[12033.501133] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
[12033.501139] em28xx #0:     card=21 -> eMPIA Technology, Inc. 
GrabBeeX+ Video Encoder
[12033.501145] em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam grabber
[12033.501151] em28xx #0:     card=23 -> Huaqi DLCW-130
[12033.501157] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
[12033.501163] em28xx #0:     card=25 -> Gadmei UTV310
[12033.501168] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
[12033.501174] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips 
FM1216ME)
[12033.501180] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
[12033.501186] em28xx #0:     card=29 -> EM2860/TVP5150 Reference Design
[12033.501192] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
[12033.501198] em28xx #0:     card=31 -> Usbgear VD204v9
[12033.501204] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
[12033.501210] em28xx #0:     card=33 -> Elgato Video Capture
[12033.501216] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
[12033.501222] em28xx #0:     card=35 -> Typhoon DVD Maker
[12033.501228] em28xx #0:     card=36 -> NetGMBH Cam
[12033.501233] em28xx #0:     card=37 -> Gadmei UTV330
[12033.501239] em28xx #0:     card=38 -> Yakumo MovieMixer
[12033.501244] em28xx #0:     card=39 -> KWorld PVRTV 300U
[12033.501250] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
[12033.501256] em28xx #0:     card=41 -> Kworld 350 U DVB-T
[12033.501262] em28xx #0:     card=42 -> Kworld 355 U DVB-T
[12033.501268] em28xx #0:     card=43 -> Terratec Cinergy T XS
[12033.501274] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[12033.501280] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
[12033.501286] em28xx #0:     card=46 -> Compro, VideoMate U3
[12033.501292] em28xx #0:     card=47 -> KWorld DVB-T 305U
[12033.501297] em28xx #0:     card=48 -> KWorld DVB-T 310U
[12033.501303] em28xx #0:     card=49 -> MSI DigiVox A/D
[12033.501308] em28xx #0:     card=50 -> MSI DigiVox A/D II
[12033.501314] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
[12033.501320] em28xx #0:     card=52 -> DNT DA2 Hybrid
[12033.501325] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
[12033.501331] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
[12033.501337] em28xx #0:     card=55 -> Terratec Cinnergy Hybrid T USB 
XS (em2882)
[12033.501344] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (2)
[12033.501349] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[12033.501356] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
[12033.501362] em28xx #0:     card=59 -> (null)
[12033.501367] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
[12033.501373] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[12033.501379] em28xx #0:     card=62 -> Gadmei TVR200
[12033.501384] em28xx #0:     card=63 -> Kaiomy TVnPC U2
[12033.501390] em28xx #0:     card=64 -> Easy Cap Capture DC-60
[12033.501396] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
[12033.501401] em28xx #0:     card=66 -> Empire dual TV
[12033.501407] em28xx #0:     card=67 -> Terratec Grabby
[12033.501413] em28xx #0:     card=68 -> Terratec AV350
[12033.501418] em28xx #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[12033.501424] em28xx #0:     card=70 -> Evga inDtube
[12033.501430] em28xx #0:     card=71 -> Silvercrest Webcam 1.3mpix
[12033.501435] em28xx #0:     card=72 -> Gadmei UTV330+
[12033.501441] em28xx #0:     card=73 -> Reddo DVB-C USB TV Box
[12033.501447] em28xx #0:     card=74 -> Actionmaster/LinXcel/Digitus VC211A
[12033.501453] em28xx #0:     card=75 -> Dikom DK300
[12033.501459] em28xx #0:     card=76 -> KWorld PlusTV 340U or UB435-Q 
(ATSC)
[12033.501465] em28xx #0:     card=77 -> EM2874 Leadership ISDBT
[12033.501470] em28xx #0: Board not discovered
[12033.501476] em28xx #0: Identified as Unknown EM2750/28xx video 
grabber (card=1)
[12033.501482] em28xx #0: Your board has no unique USB ID and thus need 
a hint to be detected.
[12033.501487] em28xx #0: You may try to use card=<n> insmod option to 
workaround that.
[12033.501492] em28xx #0: Please send an email with this log to:
[12033.501497] em28xx #0:     V4L Mailing List <linux-media@vger.kernel.org>
[12033.501503] em28xx #0: Board eeprom hash is 0xf4675b8a
[12033.501508] em28xx #0: Board i2c devicelist hash is 0x2fd10080
[12033.501513] em28xx #0: Here is a list of valid choices for the 
card=<n> insmod option:
[12033.501519] em28xx #0:     card=0 -> Unknown EM2800 video grabber
[12033.501525] em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
[12033.501530] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
[12033.501536] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
[12033.501541] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
[12033.501547] em28xx #0:     card=5 -> MSI VOX USB 2.0
[12033.501552] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
[12033.501557] em28xx #0:     card=7 -> Leadtek Winfast USB II
[12033.501563] em28xx #0:     card=8 -> Kworld USB2800
[12033.501569] em28xx #0:     card=9 -> Pinnacle Dazzle DVC 
90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2
[12033.501576] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
[12033.501582] em28xx #0:     card=11 -> Terratec Hybrid XS
[12033.501587] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
[12033.501593] em28xx #0:     card=13 -> Terratec Prodigy XS
[12033.501598] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview 
Prolink PlayTV USB 2.0
[12033.501605] em28xx #0:     card=15 -> V-Gear PocketTV
[12033.501610] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
[12033.501616] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[12033.501622] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[12033.501628] em28xx #0:     card=19 -> EM2860/SAA711X Reference Design
[12033.501633] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
[12033.501639] em28xx #0:     card=21 -> eMPIA Technology, Inc. 
GrabBeeX+ Video Encoder
[12033.501645] em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam grabber
[12033.501651] em28xx #0:     card=23 -> Huaqi DLCW-130
[12033.501656] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
[12033.501662] em28xx #0:     card=25 -> Gadmei UTV310
[12033.501667] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
[12033.501673] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips 
FM1216ME)
[12033.501679] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
[12033.501684] em28xx #0:     card=29 -> EM2860/TVP5150 Reference Design
[12033.501690] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
[12033.501696] em28xx #0:     card=31 -> Usbgear VD204v9
[12033.501701] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
[12033.501706] em28xx #0:     card=33 -> Elgato Video Capture
[12033.501712] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
[12033.501718] em28xx #0:     card=35 -> Typhoon DVD Maker
[12033.501723] em28xx #0:     card=36 -> NetGMBH Cam
[12033.501728] em28xx #0:     card=37 -> Gadmei UTV330
[12033.501733] em28xx #0:     card=38 -> Yakumo MovieMixer
[12033.501739] em28xx #0:     card=39 -> KWorld PVRTV 300U
[12033.501744] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
[12033.501750] em28xx #0:     card=41 -> Kworld 350 U DVB-T
[12033.501755] em28xx #0:     card=42 -> Kworld 355 U DVB-T
[12033.501761] em28xx #0:     card=43 -> Terratec Cinergy T XS
[12033.501766] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[12033.501772] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
[12033.501777] em28xx #0:     card=46 -> Compro, VideoMate U3
[12033.501783] em28xx #0:     card=47 -> KWorld DVB-T 305U
[12033.501788] em28xx #0:     card=48 -> KWorld DVB-T 310U
[12033.501794] em28xx #0:     card=49 -> MSI DigiVox A/D
[12033.501799] em28xx #0:     card=50 -> MSI DigiVox A/D II
[12033.501804] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
[12033.501810] em28xx #0:     card=52 -> DNT DA2 Hybrid
[12033.501815] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
[12033.501821] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
[12033.501826] em28xx #0:     card=55 -> Terratec Cinnergy Hybrid T USB 
XS (em2882)
[12033.501832] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (2)
[12033.501838] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[12033.501844] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
[12033.501849] em28xx #0:     card=59 -> (null)
[12033.501854] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
[12033.501860] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[12033.501865] em28xx #0:     card=62 -> Gadmei TVR200
[12033.501871] em28xx #0:     card=63 -> Kaiomy TVnPC U2
[12033.501876] em28xx #0:     card=64 -> Easy Cap Capture DC-60
[12033.501882] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
[12033.501887] em28xx #0:     card=66 -> Empire dual TV
[12033.501892] em28xx #0:     card=67 -> Terratec Grabby
[12033.501898] em28xx #0:     card=68 -> Terratec AV350
[12033.501903] em28xx #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[12033.501909] em28xx #0:     card=70 -> Evga inDtube
[12033.501914] em28xx #0:     card=71 -> Silvercrest Webcam 1.3mpix
[12033.501920] em28xx #0:     card=72 -> Gadmei UTV330+
[12033.501925] em28xx #0:     card=73 -> Reddo DVB-C USB TV Box
[12033.501931] em28xx #0:     card=74 -> Actionmaster/LinXcel/Digitus VC211A
[12033.501937] em28xx #0:     card=75 -> Dikom DK300
[12033.501942] em28xx #0:     card=76 -> KWorld PlusTV 340U or UB435-Q 
(ATSC)
[12033.501948] em28xx #0:     card=77 -> EM2874 Leadership ISDBT
[12033.502094] em28xx #0: Config register raw data: 0xd0
[12033.524347] em28xx #0: AC97 vendor ID = 0xff92ff92
[12033.536346] em28xx #0: AC97 features = 0xff92
[12033.536352] em28xx #0: Unknown AC97 audio processor detected!
[12033.948122] em28xx #0: v4l2 driver version 0.1.2
[12034.876352] em28xx #0: V4L2 video device registered as video0
[12034.876359] em28xx #0: V4L2 VBI device registered as vbi0
[12034.876395] em28xx video device (eb1a:2861): interface 1, class 255 
found.
[12034.876403] em28xx This is an anciliary interface not used by the driver
[12034.876458] usbcore: registered new interface driver em28xx
[12034.876464] em28xx driver loaded
[12034.887149] em28xx-audio.c: probing for em28x1 non standard usbaudio
[12034.887153] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
[12034.888580] Em28xx: Initialized (Em28xx Audio Extension) extension

