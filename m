Return-path: <linux-media-owner@vger.kernel.org>
Received: from pfepa.post.tele.dk ([195.41.46.235]:49836 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbZFRS3J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jun 2009 14:29:09 -0400
Received: from dreijer.dk (0x50c60c4b.virnxx10.dynamic.dsl.tele.dk [80.198.12.75])
	by pfepa.post.tele.dk (Postfix) with SMTP id 9A022A5002F
	for <linux-media@vger.kernel.org>; Thu, 18 Jun 2009 20:29:06 +0200 (CEST)
Message-ID: <20090618202906.87205ck4qrfiz98g@dreijer.dk>
Date: Thu, 18 Jun 2009 20:29:06 +0200
From: Teis Dreijer <teis@dreijer.dk>
To: linux-media@vger.kernel.org
Subject: "Please send an email with this" 330e device (Pinnacle hybrid pro
 stick)
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=_59s0hkpsyjk0"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This message is in MIME format.

--=_59s0hkpsyjk0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

If this information is not sufficient, feel free to contact me.

amd64 Debian Lenny with 2.6.30-1 from unstable. v4l-dvb is installed  
from mercurial just minutes ago ( hg clone  
http://www.linuxtv.org/hg/v4l-dvb )

Best regards

lsusb
Bus 001 Device 009: ID eb1a:2881 eMPIA Technology, Inc.

dmesg
[ 4024.854572] Linux video capture interface: v2.00
[ 4024.916749] usbcore: registered new interface driver em28xx
[ 4024.916759] em28xx driver loaded
[ 4024.977498] Em28xx: Initialized (Em28xx dvb Extension) extension
[ 4035.197266] usb 1-4.1: new high speed USB device using ehci_hcd and  
address 9
[ 4035.291608] usb 1-4.1: New USB device found, idVendor=eb1a, idProduct=2881
[ 4035.291619] usb 1-4.1: New USB device strings: Mfr=0, Product=1,  
SerialNumber=0
[ 4035.291626] usb 1-4.1: Product: USB 2881 Video
[ 4035.291808] usb 1-4.1: configuration #1 chosen from 1 choice
[ 4035.292101] em28xx: New device USB 2881 Video @ 480 Mbps  
(eb1a:2881, interface 0, class 0)
[ 4035.292112] em28xx #0: Identified as Unknown EM2750/28xx video  
grabber (card=1)
[ 4035.292219] em28xx #0: chip ID is em2882/em2883
[ 4035.374974] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 81 28 58 12  
5c 00 6a 20 6a 00
[ 4035.375004] em28xx #0: i2c eeprom 10: 00 00 04 57 64 57 00 00 60 f4  
00 00 02 02 00 00
[ 4035.375029] em28xx #0: i2c eeprom 20: 56 00 01 00 00 00 02 00 b8 00  
00 00 5b 1e 00 00
[ 4035.375054] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 10 02  
00 00 00 00 00 00
[ 4035.375078] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00  
00 00 00 00 00 00
[ 4035.375102] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00  
00 00 00 00 00 00
[ 4035.375126] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00  
20 03 55 00 53 00
[ 4035.375150] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 38 00  
31 00 20 00 56 00
[ 4035.375173] em28xx #0: i2c eeprom 80: 69 00 64 00 65 00 6f 00 00 00  
00 00 00 00 00 00
[ 4035.375197] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00  
00 00 00 00 00 00
[ 4035.375221] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00  
00 00 00 00 00 00
[ 4035.375245] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00  
00 00 00 00 00 00
[ 4035.375268] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00  
00 00 00 00 00 00
[ 4035.375292] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00  
00 00 00 00 00 00
[ 4035.375316] em28xx #0: i2c eeprom e0: 5a 00 55 aa 79 55 54 03 00 17  
98 01 00 00 00 00
[ 4035.375339] em28xx #0: i2c eeprom f0: 0c 00 00 01 00 00 00 00 00 00  
00 00 00 00 00 00
[ 4035.375366] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0xb8846b20
[ 4035.375371] em28xx #0: EEPROM info:
[ 4035.375375] em28xx #0:	AC97 audio (5 sample rates)
[ 4035.375379] em28xx #0:	USB Remote wakeup capable
[ 4035.375383] em28xx #0:	500mA max power
[ 4035.375389] em28xx #0:	Table at 0x04, strings=0x206a, 0x006a, 0x0000
[ 4035.407347] em28xx #0: found i2c device @ 0xa0 [eeprom]
[ 4035.411848] em28xx #0: found i2c device @ 0xb8 [tvp5150a]
[ 4035.413718] em28xx #0: found i2c device @ 0xc2 [tuner (analog)]
[ 4035.424951] em28xx #0: Your board has no unique USB ID and thus  
need a hint to be detected.
[ 4035.424961] em28xx #0: You may try to use card=<n> insmod option to  
workaround that.
[ 4035.424967] em28xx #0: Please send an email with this log to:
[ 4035.424971] em28xx #0: 	V4L Mailing List <linux-media@vger.kernel.org>
[ 4035.424977] em28xx #0: Board eeprom hash is 0xb8846b20
[ 4035.424982] em28xx #0: Board i2c devicelist hash is 0x27e10080
[ 4035.424987] em28xx #0: Here is a list of valid choices for the  
card=<n> insmod option:
[ 4035.424993] em28xx #0:     card=0 -> Unknown EM2800 video grabber
[ 4035.424999] em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
[ 4035.425025] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
[ 4035.425030] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
[ 4035.425035] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
[ 4035.425041] em28xx #0:     card=5 -> MSI VOX USB 2.0
[ 4035.425046] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
[ 4035.425051] em28xx #0:     card=7 -> Leadtek Winfast USB II
[ 4035.425056] em28xx #0:     card=8 -> Kworld USB2800
[ 4035.425062] em28xx #0:     card=9 -> Pinnacle Dazzle DVC  
90/100/101/107 / Kaiser Baas Video to DVD maker
[ 4035.425068] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
[ 4035.425074] em28xx #0:     card=11 -> Terratec Hybrid XS
[ 4035.425079] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
[ 4035.425084] em28xx #0:     card=13 -> Terratec Prodigy XS
[ 4035.425090] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview  
Prolink PlayTV USB 2.0
[ 4035.425096] em28xx #0:     card=15 -> V-Gear PocketTV
[ 4035.425101] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
[ 4035.425107] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[ 4035.425112] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[ 4035.425118] em28xx #0:     card=19 -> PointNix Intra-Oral Camera
[ 4035.425123] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
[ 4035.425129] em28xx #0:     card=21 -> eMPIA Technology, Inc.  
GrabBeeX+ Video Encoder
[ 4035.425135] em28xx #0:     card=22 -> Unknown EM2750/EM2751 webcam grabber
[ 4035.425141] em28xx #0:     card=23 -> Huaqi DLCW-130
[ 4035.425146] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
[ 4035.425151] em28xx #0:     card=25 -> Gadmei UTV310
[ 4035.425156] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
[ 4035.425162] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips  
FM1216ME)
[ 4035.425168] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
[ 4035.425174] em28xx #0:     card=29 -> <NULL>
[ 4035.425178] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
[ 4035.425184] em28xx #0:     card=31 -> Usbgear VD204v9
[ 4035.425189] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
[ 4035.425194] em28xx #0:     card=33 -> <NULL>
[ 4035.425199] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
[ 4035.425205] em28xx #0:     card=35 -> Typhoon DVD Maker
[ 4035.425210] em28xx #0:     card=36 -> NetGMBH Cam
[ 4035.425215] em28xx #0:     card=37 -> Gadmei UTV330
[ 4035.425220] em28xx #0:     card=38 -> Yakumo MovieMixer
[ 4035.425225] em28xx #0:     card=39 -> KWorld PVRTV 300U
[ 4035.425230] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
[ 4035.425236] em28xx #0:     card=41 -> Kworld 350 U DVB-T
[ 4035.425242] em28xx #0:     card=42 -> Kworld 355 U DVB-T
[ 4035.425247] em28xx #0:     card=43 -> Terratec Cinergy T XS
[ 4035.425252] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[ 4035.425258] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
[ 4035.425264] em28xx #0:     card=46 -> Compro, VideoMate U3
[ 4035.425269] em28xx #0:     card=47 -> KWorld DVB-T 305U
[ 4035.425274] em28xx #0:     card=48 -> KWorld DVB-T 310U
[ 4035.425279] em28xx #0:     card=49 -> MSI DigiVox A/D
[ 4035.425285] em28xx #0:     card=50 -> MSI DigiVox A/D II
[ 4035.425290] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
[ 4035.425295] em28xx #0:     card=52 -> DNT DA2 Hybrid
[ 4035.425300] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
[ 4035.425306] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
[ 4035.425311] em28xx #0:     card=55 -> Terratec Hybrid XS (em2882)
[ 4035.425317] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (2)
[ 4035.425323] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[ 4035.425328] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
[ 4035.425334] em28xx #0:     card=59 -> <NULL>
[ 4035.425338] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
[ 4035.425344] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[ 4035.425349] em28xx #0:     card=62 -> Gadmei TVR200
[ 4035.425355] em28xx #0:     card=63 -> Kaiomy TVnPC U2
[ 4035.425360] em28xx #0:     card=64 -> Easy Cap Capture DC-60
[ 4035.425365] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
[ 4035.425445] em28xx #0: Config register raw data: 0x58
[ 4035.426191] em28xx #0: AC97 vendor ID = 0x01da01da
[ 4035.426562] em28xx #0: AC97 features = 0x01da
[ 4035.426567] em28xx #0: Unknown AC97 audio processor detected!
[ 4035.459833] em28xx #0: v4l2 driver version 0.1.2
[ 4035.496184] em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0


--=_59s0hkpsyjk0
Content-Type: text/plain;
 charset=UTF-8;
 name="em28xx-log"
Content-Disposition: attachment;
 filename="em28xx-log"
Content-Transfer-Encoding: 7bit

[ 4024.854572] Linux video capture interface: v2.00
[ 4024.916749] usbcore: registered new interface driver em28xx
[ 4024.916759] em28xx driver loaded
[ 4024.977498] Em28xx: Initialized (Em28xx dvb Extension) extension
[ 4035.197266] usb 1-4.1: new high speed USB device using ehci_hcd and address 9
[ 4035.291608] usb 1-4.1: New USB device found, idVendor=eb1a, idProduct=2881
[ 4035.291619] usb 1-4.1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[ 4035.291626] usb 1-4.1: Product: USB 2881 Video
[ 4035.291808] usb 1-4.1: configuration #1 chosen from 1 choice
[ 4035.292101] em28xx: New device USB 2881 Video @ 480 Mbps (eb1a:2881, interface 0, class 0)
[ 4035.292112] em28xx #0: Identified as Unknown EM2750/28xx video grabber (card=1)
[ 4035.292219] em28xx #0: chip ID is em2882/em2883
[ 4035.374974] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 81 28 58 12 5c 00 6a 20 6a 00
[ 4035.375004] em28xx #0: i2c eeprom 10: 00 00 04 57 64 57 00 00 60 f4 00 00 02 02 00 00
[ 4035.375029] em28xx #0: i2c eeprom 20: 56 00 01 00 00 00 02 00 b8 00 00 00 5b 1e 00 00
[ 4035.375054] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 10 02 00 00 00 00 00 00
[ 4035.375078] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 4035.375102] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 4035.375126] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 20 03 55 00 53 00
[ 4035.375150] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 38 00 31 00 20 00 56 00
[ 4035.375173] em28xx #0: i2c eeprom 80: 69 00 64 00 65 00 6f 00 00 00 00 00 00 00 00 00
[ 4035.375197] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 4035.375221] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 4035.375245] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 4035.375268] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 4035.375292] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 4035.375316] em28xx #0: i2c eeprom e0: 5a 00 55 aa 79 55 54 03 00 17 98 01 00 00 00 00
[ 4035.375339] em28xx #0: i2c eeprom f0: 0c 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00
[ 4035.375366] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0xb8846b20
[ 4035.375371] em28xx #0: EEPROM info:
[ 4035.375375] em28xx #0:	AC97 audio (5 sample rates)
[ 4035.375379] em28xx #0:	USB Remote wakeup capable
[ 4035.375383] em28xx #0:	500mA max power
[ 4035.375389] em28xx #0:	Table at 0x04, strings=0x206a, 0x006a, 0x0000
[ 4035.407347] em28xx #0: found i2c device @ 0xa0 [eeprom]
[ 4035.411848] em28xx #0: found i2c device @ 0xb8 [tvp5150a]
[ 4035.413718] em28xx #0: found i2c device @ 0xc2 [tuner (analog)]
[ 4035.424951] em28xx #0: Your board has no unique USB ID and thus need a hint to be detected.
[ 4035.424961] em28xx #0: You may try to use card=<n> insmod option to workaround that.
[ 4035.424967] em28xx #0: Please send an email with this log to:
[ 4035.424971] em28xx #0: 	V4L Mailing List <linux-media@vger.kernel.org>
[ 4035.424977] em28xx #0: Board eeprom hash is 0xb8846b20
[ 4035.424982] em28xx #0: Board i2c devicelist hash is 0x27e10080
[ 4035.424987] em28xx #0: Here is a list of valid choices for the card=<n> insmod option:
[ 4035.424993] em28xx #0:     card=0 -> Unknown EM2800 video grabber
[ 4035.424999] em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
[ 4035.425025] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
[ 4035.425030] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
[ 4035.425035] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
[ 4035.425041] em28xx #0:     card=5 -> MSI VOX USB 2.0
[ 4035.425046] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
[ 4035.425051] em28xx #0:     card=7 -> Leadtek Winfast USB II
[ 4035.425056] em28xx #0:     card=8 -> Kworld USB2800
[ 4035.425062] em28xx #0:     card=9 -> Pinnacle Dazzle DVC 90/100/101/107 / Kaiser Baas Video to DVD maker
[ 4035.425068] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
[ 4035.425074] em28xx #0:     card=11 -> Terratec Hybrid XS
[ 4035.425079] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
[ 4035.425084] em28xx #0:     card=13 -> Terratec Prodigy XS
[ 4035.425090] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview Prolink PlayTV USB 2.0
[ 4035.425096] em28xx #0:     card=15 -> V-Gear PocketTV
[ 4035.425101] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
[ 4035.425107] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[ 4035.425112] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[ 4035.425118] em28xx #0:     card=19 -> PointNix Intra-Oral Camera
[ 4035.425123] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
[ 4035.425129] em28xx #0:     card=21 -> eMPIA Technology, Inc. GrabBeeX+ Video Encoder
[ 4035.425135] em28xx #0:     card=22 -> Unknown EM2750/EM2751 webcam grabber
[ 4035.425141] em28xx #0:     card=23 -> Huaqi DLCW-130
[ 4035.425146] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
[ 4035.425151] em28xx #0:     card=25 -> Gadmei UTV310
[ 4035.425156] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
[ 4035.425162] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips FM1216ME)
[ 4035.425168] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
[ 4035.425174] em28xx #0:     card=29 -> <NULL>
[ 4035.425178] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
[ 4035.425184] em28xx #0:     card=31 -> Usbgear VD204v9
[ 4035.425189] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
[ 4035.425194] em28xx #0:     card=33 -> <NULL>
[ 4035.425199] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
[ 4035.425205] em28xx #0:     card=35 -> Typhoon DVD Maker
[ 4035.425210] em28xx #0:     card=36 -> NetGMBH Cam
[ 4035.425215] em28xx #0:     card=37 -> Gadmei UTV330
[ 4035.425220] em28xx #0:     card=38 -> Yakumo MovieMixer
[ 4035.425225] em28xx #0:     card=39 -> KWorld PVRTV 300U
[ 4035.425230] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
[ 4035.425236] em28xx #0:     card=41 -> Kworld 350 U DVB-T
[ 4035.425242] em28xx #0:     card=42 -> Kworld 355 U DVB-T
[ 4035.425247] em28xx #0:     card=43 -> Terratec Cinergy T XS
[ 4035.425252] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[ 4035.425258] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
[ 4035.425264] em28xx #0:     card=46 -> Compro, VideoMate U3
[ 4035.425269] em28xx #0:     card=47 -> KWorld DVB-T 305U
[ 4035.425274] em28xx #0:     card=48 -> KWorld DVB-T 310U
[ 4035.425279] em28xx #0:     card=49 -> MSI DigiVox A/D
[ 4035.425285] em28xx #0:     card=50 -> MSI DigiVox A/D II
[ 4035.425290] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
[ 4035.425295] em28xx #0:     card=52 -> DNT DA2 Hybrid
[ 4035.425300] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
[ 4035.425306] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
[ 4035.425311] em28xx #0:     card=55 -> Terratec Hybrid XS (em2882)
[ 4035.425317] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (2)
[ 4035.425323] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[ 4035.425328] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
[ 4035.425334] em28xx #0:     card=59 -> <NULL>
[ 4035.425338] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
[ 4035.425344] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[ 4035.425349] em28xx #0:     card=62 -> Gadmei TVR200
[ 4035.425355] em28xx #0:     card=63 -> Kaiomy TVnPC U2
[ 4035.425360] em28xx #0:     card=64 -> Easy Cap Capture DC-60
[ 4035.425365] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
[ 4035.425445] em28xx #0: Config register raw data: 0x58
[ 4035.426191] em28xx #0: AC97 vendor ID = 0x01da01da
[ 4035.426562] em28xx #0: AC97 features = 0x01da
[ 4035.426567] em28xx #0: Unknown AC97 audio processor detected!
[ 4035.459833] em28xx #0: v4l2 driver version 0.1.2
[ 4035.496184] em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0

--=_59s0hkpsyjk0--

