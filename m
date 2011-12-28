Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41854 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830Ab1L1NqU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Dec 2011 08:46:20 -0500
Received: by iaeh11 with SMTP id h11so22067882iae.19
        for <linux-media@vger.kernel.org>; Wed, 28 Dec 2011 05:46:19 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 28 Dec 2011 23:46:19 +1000
Message-ID: <CAHM3zx6+BnH5HcuoMWfBsYdHpvW6HipqiYv+LmV8qHYGRASy1w@mail.gmail.com>
Subject: Pinnacle PCTV USB DVBT (addition)
From: Sebastian <sebastian.spiess@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks to Patrick for helping to clarify.

Below the bar code of the packing it reads: 230100085 PCTV USB Stick 70E AUS
So he/we assumed it is a 70E type.


---------- Forwarded message ----------
From: Sebastian <sebastian.spiess@gmail.com>
Date: 28 December 2011 22:36
Subject: Pinnacle PCTV USB DVBT
To: linux-media@vger.kernel.org


as requested in the dmesg output I'm forwarding the output to
linux-media@vger.kernel.org

As requested in the Launchpad bug report #905609 I've tested it with
the most recent upstream kernel - 3.2.0-030200rc7-generic

I hope it helps!

Cheers,

Sebastian

[  173.671232] usb 2-1.2: new high-speed USB device number 3 using ehci_hcd
[  173.901831] em28xx: New device USB 2870 Device @ 480 Mbps
(eb1a:2870, interface 0, class 0)
[  173.901894] em28xx #0: chip ID is em2870
[  173.901963] IR NEC protocol handler initialized
[  173.908931] IR RC5(x) protocol handler initialized
[  173.914153] IR RC6 protocol handler initialized
[  173.920571] IR JVC protocol handler initialized
[  173.928739] IR Sony protocol handler initialized
[  173.938028] IR MCE Keyboard/mouse protocol handler initialized
[  173.946522] lirc_dev: IR Remote Control driver registered, major 249
[  173.947836] IR LIRC bridge handler initialized
[  173.983057] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 70 28 c0 12
81 00 6a 22 00 00
[  173.983075] em28xx #0: i2c eeprom 10: 00 00 04 57 02 0d 00 00 00 00
00 00 00 00 00 00
[  173.983091] em28xx #0: i2c eeprom 20: 44 00 00 00 f0 10 02 00 00 00
00 00 5b 00 00 00
[  173.983106] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01
00 00 6d e0 a3 49
[  173.983121] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  173.983136] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  173.983150] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00
22 03 55 00 53 00
[  173.983165] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 37 00
30 00 20 00 44 00
[  173.983180] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00
00 00 00 00 00 00
[  173.983195] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  173.983210] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  173.983224] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  173.983239] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  173.983254] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  173.983268] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  173.983283] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  173.983300] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0xf0ff19c0
[  173.983303] em28xx #0: EEPROM info:
[  173.983306] em28xx #0:       No audio on board.
[  173.983308] em28xx #0:       500mA max power
[  173.983312] em28xx #0:       Table at 0x04, strings=0x226a, 0x0000, 0x0000
[  174.061817] em28xx #0: found i2c device @ 0xa0 [eeprom]
[  174.067809] em28xx #0: found i2c device @ 0xc0 [tuner (analog)]
[  174.079443] em28xx #0: Your board has no unique USB ID and thus
need a hint to be detected.
[  174.079449] em28xx #0: You may try to use card=<n> insmod option to
workaround that.
[  174.079452] em28xx #0: Please send an email with this log to:
[  174.079455] em28xx #0:       V4L Mailing List <linux-media@vger.kernel.org>
[  174.079458] em28xx #0: Board eeprom hash is 0xf0ff19c0
[  174.079461] em28xx #0: Board i2c devicelist hash is 0x4b800080
[  174.079464] em28xx #0: Here is a list of valid choices for the
card=<n> insmod option:
[  174.079468] em28xx #0:     card=0 -> Unknown EM2800 video grabber
[  174.079472] em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
[  174.079476] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
[  174.079479] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
[  174.079482] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
[  174.079486] em28xx #0:     card=5 -> MSI VOX USB 2.0
[  174.079489] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
[  174.079492] em28xx #0:     card=7 -> Leadtek Winfast USB II
[  174.079496] em28xx #0:     card=8 -> Kworld USB2800
[  174.079499] em28xx #0:     card=9 -> Pinnacle Dazzle DVC
90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2
[  174.079504] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
[  174.079507] em28xx #0:     card=11 -> Terratec Hybrid XS
[  174.079510] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
[  174.079513] em28xx #0:     card=13 -> Terratec Prodigy XS
[  174.079517] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview
Prolink PlayTV USB 2.0
[  174.079520] em28xx #0:     card=15 -> V-Gear PocketTV
[  174.079524] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
[  174.079527] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[  174.079530] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[  174.079534] em28xx #0:     card=19 -> EM2860/SAA711X Reference Design
[  174.079537] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
[  174.079540] em28xx #0:     card=21 -> eMPIA Technology, Inc.
GrabBeeX+ Video Encoder
[  174.079544] em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam grabber
[  174.079548] em28xx #0:     card=23 -> Huaqi DLCW-130
[  174.079551] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
[  174.079554] em28xx #0:     card=25 -> Gadmei UTV310
[  174.079557] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
[  174.079561] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips FM1216ME)
[  174.079564] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
[  174.079568] em28xx #0:     card=29 -> EM2860/TVP5150 Reference Design
[  174.079571] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
[  174.079575] em28xx #0:     card=31 -> Usbgear VD204v9
[  174.079578] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
[  174.079581] em28xx #0:     card=33 -> Elgato Video Capture
[  174.079584] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
[  174.079587] em28xx #0:     card=35 -> Typhoon DVD Maker
[  174.079590] em28xx #0:     card=36 -> NetGMBH Cam
[  174.079594] em28xx #0:     card=37 -> Gadmei UTV330
[  174.079597] em28xx #0:     card=38 -> Yakumo MovieMixer
[  174.079600] em28xx #0:     card=39 -> KWorld PVRTV 300U
[  174.079603] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
[  174.079606] em28xx #0:     card=41 -> Kworld 350 U DVB-T
[  174.079609] em28xx #0:     card=42 -> Kworld 355 U DVB-T
[  174.079612] em28xx #0:     card=43 -> Terratec Cinergy T XS
[  174.079615] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[  174.079619] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
[  174.079622] em28xx #0:     card=46 -> Compro, VideoMate U3
[  174.079625] em28xx #0:     card=47 -> KWorld DVB-T 305U
[  174.079628] em28xx #0:     card=48 -> KWorld DVB-T 310U
[  174.079631] em28xx #0:     card=49 -> MSI DigiVox A/D
[  174.079634] em28xx #0:     card=50 -> MSI DigiVox A/D II
[  174.079638] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
[  174.079641] em28xx #0:     card=52 -> DNT DA2 Hybrid
[  174.079644] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
[  174.079647] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
[  174.079651] em28xx #0:     card=55 -> Terratec Cinnergy Hybrid T
USB XS (em2882)
[  174.079654] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (330e)
[  174.079658] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[  174.079661] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
[  174.079664] em28xx #0:     card=59 -> (null)
[  174.079667] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
[  174.079670] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[  174.079674] em28xx #0:     card=62 -> Gadmei TVR200
[  174.079677] em28xx #0:     card=63 -> Kaiomy TVnPC U2
[  174.079680] em28xx #0:     card=64 -> Easy Cap Capture DC-60
[  174.079683] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
[  174.079686] em28xx #0:     card=66 -> Empire dual TV
[  174.079689] em28xx #0:     card=67 -> Terratec Grabby
[  174.079692] em28xx #0:     card=68 -> Terratec AV350
[  174.079695] em28xx #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[  174.079698] em28xx #0:     card=70 -> Evga inDtube
[  174.079702] em28xx #0:     card=71 -> Silvercrest Webcam 1.3mpix
[  174.079705] em28xx #0:     card=72 -> Gadmei UTV330+
[  174.079708] em28xx #0:     card=73 -> Reddo DVB-C USB TV Box
[  174.079711] em28xx #0:     card=74 -> Actionmaster/LinXcel/Digitus VC211A
[  174.079715] em28xx #0:     card=75 -> Dikom DK300
[  174.079718] em28xx #0:     card=76 -> KWorld PlusTV 340U or UB435-Q (ATSC)
[  174.079721] em28xx #0:     card=77 -> EM2874 Leadership ISDBT
[  174.079725] em28xx #0:     card=78 -> PCTV nanoStick T2 290e
[  174.079728] em28xx #0:     card=79 -> Terratec Cinergy H5
[  174.079731] em28xx #0:     card=80 -> PCTV DVB-S2 Stick (460e)
[  174.079734] em28xx #0: Board not discovered
[  174.079737] em28xx #0: Identified as Unknown EM2750/28xx video
grabber (card=1)
[  174.079740] em28xx #0: Your board has no unique USB ID and thus
need a hint to be detected.
[  174.079744] em28xx #0: You may try to use card=<n> insmod option to
workaround that.
[  174.079747] em28xx #0: Please send an email with this log to:
[  174.079749] em28xx #0:       V4L Mailing List <linux-media@vger.kernel.org>
[  174.079753] em28xx #0: Board eeprom hash is 0xf0ff19c0
[  174.079755] em28xx #0: Board i2c devicelist hash is 0x4b800080
[  174.079758] em28xx #0: Here is a list of valid choices for the
card=<n> insmod option:
[  174.079762] em28xx #0:     card=0 -> Unknown EM2800 video grabber
[  174.079765] em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
[  174.079769] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
[  174.079772] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
[  174.079775] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
[  174.079778] em28xx #0:     card=5 -> MSI VOX USB 2.0
[  174.079781] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
[  174.079784] em28xx #0:     card=7 -> Leadtek Winfast USB II
[  174.079787] em28xx #0:     card=8 -> Kworld USB2800
[  174.079790] em28xx #0:     card=9 -> Pinnacle Dazzle DVC
90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2
[  174.079795] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
[  174.079798] em28xx #0:     card=11 -> Terratec Hybrid XS
[  174.079801] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
[  174.079804] em28xx #0:     card=13 -> Terratec Prodigy XS
[  174.079807] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview
Prolink PlayTV USB 2.0
[  174.079811] em28xx #0:     card=15 -> V-Gear PocketTV
[  174.079814] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
[  174.079817] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[  174.079820] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[  174.079824] em28xx #0:     card=19 -> EM2860/SAA711X Reference Design
[  174.079827] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
[  174.079830] em28xx #0:     card=21 -> eMPIA Technology, Inc.
GrabBeeX+ Video Encoder
[  174.079834] em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam grabber
[  174.079837] em28xx #0:     card=23 -> Huaqi DLCW-130
[  174.079840] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
[  174.079843] em28xx #0:     card=25 -> Gadmei UTV310
[  174.079846] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
[  174.079849] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips FM1216ME)
[  174.079853] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
[  174.079856] em28xx #0:     card=29 -> EM2860/TVP5150 Reference Design
[  174.079859] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
[  174.079863] em28xx #0:     card=31 -> Usbgear VD204v9
[  174.079866] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
[  174.079869] em28xx #0:     card=33 -> Elgato Video Capture
[  174.079872] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
[  174.079875] em28xx #0:     card=35 -> Typhoon DVD Maker
[  174.079878] em28xx #0:     card=36 -> NetGMBH Cam
[  174.079881] em28xx #0:     card=37 -> Gadmei UTV330
[  174.079884] em28xx #0:     card=38 -> Yakumo MovieMixer
[  174.079887] em28xx #0:     card=39 -> KWorld PVRTV 300U
[  174.079890] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
[  174.079893] em28xx #0:     card=41 -> Kworld 350 U DVB-T
[  174.079896] em28xx #0:     card=42 -> Kworld 355 U DVB-T
[  174.079899] em28xx #0:     card=43 -> Terratec Cinergy T XS
[  174.079902] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[  174.079906] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
[  174.079909] em28xx #0:     card=46 -> Compro, VideoMate U3
[  174.079912] em28xx #0:     card=47 -> KWorld DVB-T 305U
[  174.079915] em28xx #0:     card=48 -> KWorld DVB-T 310U
[  174.079918] em28xx #0:     card=49 -> MSI DigiVox A/D
[  174.079921] em28xx #0:     card=50 -> MSI DigiVox A/D II
[  174.079924] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
[  174.079927] em28xx #0:     card=52 -> DNT DA2 Hybrid
[  174.079930] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
[  174.079933] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
[  174.079936] em28xx #0:     card=55 -> Terratec Cinnergy Hybrid T
USB XS (em2882)
[  174.079940] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (330e)
[  174.079943] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[  174.079946] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
[  174.079949] em28xx #0:     card=59 -> (null)
[  174.079952] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
[  174.079956] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[  174.079959] em28xx #0:     card=62 -> Gadmei TVR200
[  174.079962] em28xx #0:     card=63 -> Kaiomy TVnPC U2
[  174.079965] em28xx #0:     card=64 -> Easy Cap Capture DC-60
[  174.079968] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
[  174.079971] em28xx #0:     card=66 -> Empire dual TV
[  174.079974] em28xx #0:     card=67 -> Terratec Grabby
[  174.079977] em28xx #0:     card=68 -> Terratec AV350
[  174.079980] em28xx #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[  174.079983] em28xx #0:     card=70 -> Evga inDtube
[  174.079986] em28xx #0:     card=71 -> Silvercrest Webcam 1.3mpix
[  174.079989] em28xx #0:     ca[  173.671232] usb 2-1.2: new
high-speed USB device number 3 using ehci_hcd
[  173.901831] em28xx: New device USB 2870 Device @ 480 Mbps
(eb1a:2870, interface 0, class 0)
[  173.901894] em28xx #0: chip ID is em2870
[  173.901963] IR NEC protocol handler initialized
[  173.908931] IR RC5(x) protocol handler initialized
[  173.914153] IR RC6 protocol handler initialized
[  173.920571] IR JVC protocol handler initialized
[  173.928739] IR Sony protocol handler initialized
[  173.938028] IR MCE Keyboard/mouse protocol handler initialized
[  173.946522] lirc_dev: IR Remote Control driver registered, major 249
[  173.947836] IR LIRC bridge handler initialized
[  173.983057] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 70 28 c0 12
81 00 6a 22 00 00
[  173.983075] em28xx #0: i2c eeprom 10: 00 00 04 57 02 0d 00 00 00 00
00 00 00 00 00 00
[  173.983091] em28xx #0: i2c eeprom 20: 44 00 00 00 f0 10 02 00 00 00
00 00 5b 00 00 00
[  173.983106] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01
00 00 6d e0 a3 49
[  173.983121] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  173.983136] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  173.983150] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00
22 03 55 00 53 00
[  173.983165] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 37 00
30 00 20 00 44 00
[  173.983180] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00
00 00 00 00 00 00
[  173.983195] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  173.983210] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  173.983224] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  173.983239] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  173.983254] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  173.983268] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  173.983283] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  173.983300] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0xf0ff19c0
[  173.983303] em28xx #0: EEPROM info:
[  173.983306] em28xx #0:       No audio on board.
[  173.983308] em28xx #0:       500mA max power
[  173.983312] em28xx #0:       Table at 0x04, strings=0x226a, 0x0000, 0x0000
[  174.061817] em28xx #0: found i2c device @ 0xa0 [eeprom]
[  174.067809] em28xx #0: found i2c device @ 0xc0 [tuner (analog)]
[  174.079443] em28xx #0: Your board has no unique USB ID and thus
need a hint to be detected.
[  174.079449] em28xx #0: You may try to use card=<n> insmod option to
workaround that.
[  174.079452] em28xx #0: Please send an email with this log to:
[  174.079455] em28xx #0:       V4L Mailing List <linux-media@vger.kernel.org>
[  174.079458] em28xx #0: Board eeprom hash is 0xf0ff19c0
[  174.079461] em28xx #0: Board i2c devicelist hash is 0x4b800080
[  174.079464] em28xx #0: Here is a list of valid choices for the
card=<n> insmod option:
[  174.079468] em28xx #0:     card=0 -> Unknown EM2800 video grabber
[  174.079472] em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
[  174.079476] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
[  174.079479] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
[  174.079482] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
[  174.079486] em28xx #0:     card=5 -> MSI VOX USB 2.0
[  174.079489] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
[  174.079492] em28xx #0:     card=7 -> Leadtek Winfast USB II
[  174.079496] em28xx #0:     card=8 -> Kworld USB2800
[  174.079499] em28xx #0:     card=9 -> Pinnacle Dazzle DVC
90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2
[  174.079504] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
[  174.079507] em28xx #0:     card=11 -> Terratec Hybrid XS
[  174.079510] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
[  174.079513] em28xx #0:     card=13 -> Terratec Prodigy XS
[  174.079517] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview
Prolink PlayTV USB 2.0
[  174.079520] em28xx #0:     card=15 -> V-Gear PocketTV
[  174.079524] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
[  174.079527] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[  174.079530] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[  174.079534] em28xx #0:     card=19 -> EM2860/SAA711X Reference Design
[  174.079537] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
[  174.079540] em28xx #0:     card=21 -> eMPIA Technology, Inc.
GrabBeeX+ Video Encoder
[  174.079544] em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam grabber
[  174.079548] em28xx #0:     card=23 -> Huaqi DLCW-130
[  174.079551] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
[  174.079554] em28xx #0:     card=25 -> Gadmei UTV310
[  174.079557] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
[  174.079561] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips FM1216ME)
[  174.079564] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
[  174.079568] em28xx #0:     card=29 -> EM2860/TVP5150 Reference Design
[  174.079571] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
[  174.079575] em28xx #0:     card=31 -> Usbgear VD204v9
[  174.079578] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
[  174.079581] em28xx #0:     card=33 -> Elgato Video Capture
[  174.079584] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
[  174.079587] em28xx #0:     card=35 -> Typhoon DVD Maker
[  174.079590] em28xx #0:     card=36 -> NetGMBH Cam
[  174.079594] em28xx #0:     card=37 -> Gadmei UTV330
[  174.079597] em28xx #0:     card=38 -> Yakumo MovieMixer
[  174.079600] em28xx #0:     card=39 -> KWorld PVRTV 300U
[  174.079603] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
[  174.079606] em28xx #0:     card=41 -> Kworld 350 U DVB-T
[  174.079609] em28xx #0:     card=42 -> Kworld 355 U DVB-T
[  174.079612] em28xx #0:     card=43 -> Terratec Cinergy T XS
[  174.079615] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[  174.079619] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
[  174.079622] em28xx #0:     card=46 -> Compro, VideoMate U3
[  174.079625] em28xx #0:     card=47 -> KWorld DVB-T 305U
[  174.079628] em28xx #0:     card=48 -> KWorld DVB-T 310U
[  174.079631] em28xx #0:     card=49 -> MSI DigiVox A/D
[  174.079634] em28xx #0:     card=50 -> MSI DigiVox A/D II
[  174.079638] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
[  174.079641] em28xx #0:     card=52 -> DNT DA2 Hybrid
[  174.079644] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
[  174.079647] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
[  174.079651] em28xx #0:     card=55 -> Terratec Cinnergy Hybrid T
USB XS (em2882)
[  174.079654] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (330e)
[  174.079658] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[  174.079661] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
[  174.079664] em28xx #0:     card=59 -> (null)
[  174.079667] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
[  174.079670] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[  174.079674] em28xx #0:     card=62 -> Gadmei TVR200
[  174.079677] em28xx #0:     card=63 -> Kaiomy TVnPC U2
[  174.079680] em28xx #0:     card=64 -> Easy Cap Capture DC-60
[  174.079683] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
[  174.079686] em28xx #0:     card=66 -> Empire dual TV
[  174.079689] em28xx #0:     card=67 -> Terratec Grabby
[  174.079692] em28xx #0:     card=68 -> Terratec AV350
[  174.079695] em28xx #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[  174.079698] em28xx #0:     card=70 -> Evga inDtube
[  174.079702] em28xx #0:     card=71 -> Silvercrest Webcam 1.3mpix
[  174.079705] em28xx #0:     card=72 -> Gadmei UTV330+
[  174.079708] em28xx #0:     card=73 -> Reddo DVB-C USB TV Box
[  174.079711] em28xx #0:     card=74 -> Actionmaster/LinXcel/Digitus VC211A
[  174.079715] em28xx #0:     card=75 -> Dikom DK300
[  174.079718] em28xx #0:     card=76 -> KWorld PlusTV 340U or UB435-Q (ATSC)
[  174.079721] em28xx #0:     card=77 -> EM2874 Leadership ISDBT
[  174.079725] em28xx #0:     card=78 -> PCTV nanoStick T2 290e
[  174.079728] em28xx #0:     card=79 -> Terratec Cinergy H5
[  174.079731] em28xx #0:     card=80 -> PCTV DVB-S2 Stick (460e)
[  174.079734] em28xx #0: Board not discovered
[  174.079737] em28xx #0: Identified as Unknown EM2750/28xx video
grabber (card=1)
[  174.079740] em28xx #0: Your board has no unique USB ID and thus
need a hint to be detected.
[  174.079744] em28xx #0: You may try to use card=<n> insmod option to
workaround that.
[  174.079747] em28xx #0: Please send an email with this log to:
[  174.079749] em28xx #0:       V4L Mailing List <linux-media@vger.kernel.org>
[  174.079753] em28xx #0: Board eeprom hash is 0xf0ff19c0
[  174.079755] em28xx #0: Board i2c devicelist hash is 0x4b800080
[  174.079758] em28xx #0: Here is a list of valid choices for the
card=<n> insmod option:
[  174.079762] em28xx #0:     card=0 -> Unknown EM2800 video grabber
[  174.079765] em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
[  174.079769] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
[  174.079772] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
[  174.079775] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
[  174.079778] em28xx #0:     card=5 -> MSI VOX USB 2.0
[  174.079781] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
[  174.079784] em28xx #0:     card=7 -> Leadtek Winfast USB II
[  174.079787] em28xx #0:     card=8 -> Kworld USB2800
[  174.079790] em28xx #0:     card=9 -> Pinnacle Dazzle DVC
90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2
[  174.079795] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
[  174.079798] em28xx #0:     card=11 -> Terratec Hybrid XS
[  174.079801] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
[  174.079804] em28xx #0:     card=13 -> Terratec Prodigy XS
[  174.079807] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview
Prolink PlayTV USB 2.0
[  174.079811] em28xx #0:     card=15 -> V-Gear PocketTV
[  174.079814] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
[  174.079817] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[  174.079820] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[  174.079824] em28xx #0:     card=19 -> EM2860/SAA711X Reference Design
[  174.079827] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
[  174.079830] em28xx #0:     card=21 -> eMPIA Technology, Inc.
GrabBeeX+ Video Encoder
[  174.079834] em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam grabber
[  174.079837] em28xx #0:     card=23 -> Huaqi DLCW-130
[  174.079840] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
[  174.079843] em28xx #0:     card=25 -> Gadmei UTV310
[  174.079846] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
[  174.079849] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips FM1216ME)
[  174.079853] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
[  174.079856] em28xx #0:     card=29 -> EM2860/TVP5150 Reference Design
[  174.079859] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
[  174.079863] em28xx #0:     card=31 -> Usbgear VD204v9
[  174.079866] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
[  174.079869] em28xx #0:     card=33 -> Elgato Video Capture
[  174.079872] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
[  174.079875] em28xx #0:     card=35 -> Typhoon DVD Maker
[  174.079878] em28xx #0:     card=36 -> NetGMBH Cam
[  174.079881] em28xx #0:     card=37 -> Gadmei UTV330
[  174.079884] em28xx #0:     card=38 -> Yakumo MovieMixer
[  174.079887] em28xx #0:     card=39 -> KWorld PVRTV 300U
[  174.079890] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
[  174.079893] em28xx #0:     card=41 -> Kworld 350 U DVB-T
[  174.079896] em28xx #0:     card=42 -> Kworld 355 U DVB-T
[  174.079899] em28xx #0:     card=43 -> Terratec Cinergy T XS
[  174.079902] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[  174.079906] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
[  174.079909] em28xx #0:     card=46 -> Compro, VideoMate U3
[  174.079912] em28xx #0:     card=47 -> KWorld DVB-T 305U
[  174.079915] em28xx #0:     card=48 -> KWorld DVB-T 310U
[  174.079918] em28xx #0:     card=49 -> MSI DigiVox A/D
[  174.079921] em28xx #0:     card=50 -> MSI DigiVox A/D II
[  174.079924] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
[  174.079927] em28xx #0:     card=52 -> DNT DA2 Hybrid
[  174.079930] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
[  174.079933] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
[  174.079936] em28xx #0:     card=55 -> Terratec Cinnergy Hybrid T
USB XS (em2882)
[  174.079940] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (330e)
[  174.079943] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[  174.079946] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
[  174.079949] em28xx #0:     card=59 -> (null)
[  174.079952] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
[  174.079956] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[  174.079959] em28xx #0:     card=62 -> Gadmei TVR200
[  174.079962] em28xx #0:     card=63 -> Kaiomy TVnPC U2
[  174.079965] em28xx #0:     card=64 -> Easy Cap Capture DC-60
[  174.079968] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
[  174.079971] em28xx #0:     card=66 -> Empire dual TV
[  174.079974] em28xx #0:     card=67 -> Terratec Grabby
[  174.079977] em28xx #0:     card=68 -> Terratec AV350
[  174.079980] em28xx #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[  174.079983] em28xx #0:     card=70 -> Evga inDtube
[  174.079986] em28xx #0:     card=71 -> Silvercrest Webcam 1.3mpix
[  174.079989] em28xx #0:     card=72 -> Gadmei UTV330+
[  174.079992] em28xx #0:     card=73 -> Reddo DVB-C USB TV Box
[  174.079995] em28xx #0:     card=74 -> Actionmaster/LinXcel/Digitus VC211A
[  174.079999] em28xx #0:     card=75 -> Dikom DK300
[  174.080002] em28xx #0:     card=76 -> KWorld PlusTV 340U or UB435-Q (ATSC)
[  174.080005] em28xx #0:     card=77 -> EM2874 Leadership ISDBT
[  174.080008] em28xx #0:     card=78 -> PCTV nanoStick T2 290e
[  174.080011] em28xx #0:     card=79 -> Terratec Cinergy H5
[  174.080014] em28xx #0:     card=80 -> PCTV DVB-S2 Stick (460e)
[  174.080019] em28xx #0: v4l2 driver version 0.1.3
[  174.085010] em28xx #0: V4L2 video device registered as video1
[  174.085051] usbcore: registered new interface driver em28xx
[  174.085056] em28xx driver loaded
ubuntu@ubuntu:~$ uname -a
Linux ubuntu 3.2.0-030200rc7-generic #201112240135 SMP Sat Dec 24
06:43:51 UTC 2011 i686 i686 i386 GNU/Linuxrd=72 -> Gadmei UTV330+
[  174.079992] em28xx #0:     card=73 -> Reddo DVB-C USB TV Box
[  174.079995] em28xx #0:     card=74 -> Actionmaster/LinXcel/Digitus VC211A
[  174.079999] em28xx #0:     card=75 -> Dikom DK300
[  174.080002] em28xx #0:     card=76 -> KWorld PlusTV 340U or UB435-Q (ATSC)
[  174.080005] em28xx #0:     card=77 -> EM2874 Leadership ISDBT
[  174.080008] em28xx #0:     card=78 -> PCTV nanoStick T2 290e
[  174.080011] em28xx #0:     card=79 -> Terratec Cinergy H5
[  174.080014] em28xx #0:     card=80 -> PCTV DVB-S2 Stick (460e)
[  174.080019] em28xx #0: v4l2 driver version 0.1.3
[  174.085010] em28xx #0: V4L2 video device registered as video1
[  174.085051] usbcore: registered new interface driver em28xx
[  174.085056] em28xx driver loaded
ubuntu@ubuntu:~$ uname -a
Linux ubuntu 3.2.0-030200rc7-generic #201112240135 SMP Sat Dec 24
06:43:51 UTC 2011 i686 i686 i386 GNU/Linuxrd=72 -> Gadmei UTV330+
[  174.079992] em28xx #0:     card=73 -> Reddo DVB-C USB TV Box
[  174.079995] em28xx #0:     card=74 -> Actionmaster/LinXcel/Digitus VC211A
[  174.079999] em28xx #0:     card=75 -> Dikom DK300
[  174.080002] em28xx #0:     card=76 -> KWorld PlusTV 340U or UB435-Q (ATSC)
[  174.080005] em28xx #0:     card=77 -> EM2874 Leadership ISDBT
[  174.080008] em28xx #0:     card=78 -> PCTV nanoStick T2 290e
[  174.080011] em28xx #0:     card=79 -> Terratec Cinergy H5
[  174.080014] em28xx #0:     card=80 -> PCTV DVB-S2 Stick (460e)
[  174.080019] em28xx #0: v4l2 driver version 0.1.3
[  174.085010] em28xx #0: V4L2 video device registered as video1
[  174.085051] usbcore: registered new interface driver em28xx
[  174.085056] em28xx driver loaded
ubuntu@ubuntu:~$ uname -a
Linux ubuntu 3.2.0-030200rc7-generic #201112240135 SMP Sat Dec 24
06:43:51 UTC 2011 i686 i686 i386 GNU/Linux


---------- Forwarded message ----------
From: Joseph Salisbury <joseph.salisbury@canonical.com>
Date: 20 December 2011 01:24
Subject: [Bug 905609] Re: Pinnacle PCTV USB DVBT adapter doesn't work
To: sebastian.spiess@gmail.com


Would it be possible for you to test the latest upstream kernel?  It
will allow additional upstream developers to examine the issue. Refer to
https://wiki.ubuntu.com/KernelMainlineBuilds . If possible, please test
the latest v3.2-rcN kernel (Not a kernel in the daily directory).  Once
you've tested the upstream kernel, please remove the 'needs-upstream-
testing' tag(Only that one tag, please leave the other tags). This can
be done by clicking on the yellow pencil icon next to the tag located at
the bottom of the bug description and deleting the 'needs-upstream-
testing' text.

If this bug is fixed by the mainline kernel, please add the following
tag 'kernel-fixed-upstream-KERNEL-VERSION'.  For example, if kernel
version 3.2-rc1 fixed and issue, the tag would be: 'kernel-fixed-
upstream-v3.2-rc1'.

If the mainline kernel does not fix this bug, please add the tag:
'kernel-bug-exists-upstream'.

If you are unable to test the mainline kernel, for example it will not
boot, please add the tag: 'kernel-unable-to-test-upstream'.  If you
believe this bug does not require upstream testing, please add the tag:
'kernel-upstream-testing-not-needed'.

Once testing of the upstream kernel is complete, please mark this bug as
"Confirmed".


Thanks in advance.


** Changed in: linux (Ubuntu)
  Importance: Undecided => Medium

** Tags added: needs-upstream-testing

--
You received this bug notification because you are subscribed to the bug
report.
https://bugs.launchpad.net/bugs/905609

Title:
 Pinnacle PCTV USB DVBT adapter doesn't work

To manage notifications about this bug go to:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/905609/+subscriptions
