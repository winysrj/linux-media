Return-path: <mchehab@gaivota>
Received: from cp-out12.libero.it ([212.52.84.112]:33064 "EHLO
	cp-out12.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab0KFT4f (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Nov 2010 15:56:35 -0400
Received: from [192.168.1.3] (151.71.231.66) by cp-out12.libero.it (8.5.119) (authenticated as alfunzi@libero.it)
        id 4C45797808CDEB22 for linux-media@vger.kernel.org; Sat, 6 Nov 2010 20:51:13 +0100
Subject: ID eb1a:2870 eMPIA Technology, Inc. Pinnacle PCTV Stick
From: funzi <alfunzi@libero.it>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 06 Nov 2010 20:51:05 +0100
Message-ID: <1289073065.18486.3.camel@funzi-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

[   19.186452] em28xx: New device USB 2870 Device @ 480 Mbps (eb1a:2870,
interface 0, class 0)
[   19.187809] em28xx #0: chip ID is em2870
[   19.285935] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 70 28 c0 12
81 00 6a 22 00 00
[   19.285950] em28xx #0: i2c eeprom 10: 00 00 04 57 02 0d 00 00 00 00
00 00 00 00 00 00
[   19.285962] em28xx #0: i2c eeprom 20: 44 00 00 00 f0 10 02 00 00 00
00 00 5b 00 00 00
[   19.285974] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01
00 00 50 d1 19 49
[   19.285985] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   19.285997] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   19.286008] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00
22 03 55 00 53 00
[   19.286020] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 37 00
30 00 20 00 44 00
[   19.286031] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00
00 00 00 00 00 00
[   19.286043] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   19.286054] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   19.286066] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   19.286077] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   19.286089] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   19.286100] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   19.286111] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   19.286127] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash =
0x47f0a3c0
[   19.286129] em28xx #0: EEPROM info:
[   19.286131] em28xx #0:	No audio on board.
[   19.286134] em28xx #0:	500mA max power
[   19.286137] em28xx #0:linux-media@vger.kernel.org	Table at 0x04,
strings=0x226a, 0x0000, 0x0000
[   19.287806] em28xx #0: Identified as Unknown EM2750/28xx video
grabber (card=1)
[   19.417291] em28xx #0: found i2c device @ 0xa0 [eeprom]
[   19.432537] em28xx #0: found i2c device @ 0xc0 [tuner (analog)]
[   19.450687] em28xx #0: Your board has no unique USB ID and thus need
a hint to be detected.
[   19.450749] em28xx #0: You may try to use card=<n> insmod option to
workaround that.
[   19.450804] em28xx #0: Please send an email with this log to:
[   19.450856] em28xx #0: 	V4L Mailing List
<linux-media@vger.kernel.org>
[   19.450909] em28xx #0: Board eeprom hash is 0x47f0a3c0
[   19.450961] em28xx #0: Board i2c devicelist hash is 0x4b800080
[   19.451013] em28xx #0: Here is a list of valid choices for the
card=<n> insmod option:
[   19.451068] em28xx #0:     card=0 -> Unknown EM2800 video grabber
[   19.451121] em28xx #0:     card=1 -> Unknown EM2750/28xx video
grabber
[   19.451174] em28xx #0:     card=2 -> Terratec Cinergy 250
USBlinux-media@vger.kernel.org
[   19.451227] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
[   19.451279] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
[   19.451331] em28xx #0:     card=5 -> MSI VOX USB 2.0
[   19.451382] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
[   19.451435] em28xx #0:     card=7 -> Leadtek Winfast USB II
[   19.451487] em28xx #0:     card=8 -> Kworld USB2800
[   19.451540] em28xx #0:     card=9 -> Pinnacle Dazzle DVC
90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2
[   19.451599] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
[   19.451651] em28xx #0:     card=11 -> Terratec Hybrid XS
[   19.451703] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
[   19.451755] em28xx #0:     card=13 -> Terratec Prodigy XS
[   19.451816] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview
Prolink PlayTV USB 2.0
[   19.451888] em28xx #0:     card=15 -> V-Gear PocketTV[   19.186452]
em28xx: New device USB 2870 Device @ 480 Mbps (eb1a:2870, interface
0,linux-media@vger.kernel.org class 0)
[   19.187809] em28xx #0: chip ID is em2870
[   19.285935] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 70 28 c0 12
81 00 6a 22 00 00
[   19.285950] em28xx #0: i2c eeprom 10: 00 00 04 57 02 0d 00 00 00 00
00 00 00 00 00 00
[   19.285962] em28xx #0: i2c eeprom 20: 44 00 00 00 f0 10 02 00 00 00
00 00 5b 00 00 00
[   19.285974] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01
00 00 50 d1 19 49
[   19.285985] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   19.285997] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   19.286008] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00
22 03 55 00 53 00
[   19.286020] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 37
00linux-media@vger.kernel.org 30 00 20 00 44 00
[   19.286031] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00
00 00 00 00 00 00
[   19.286043] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   19.286054] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   19.286066] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   19.286077] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   19.286089] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   19.286100] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   19.286111] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   19.286127] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash =
0x47f0a3c0
[   19.286129] em28xx #0: EEPROM info:
[   19.286131] em28xx #0:	No audio on board.
[   19.286134] em28xx #0:	500mA max power
[   19.286137] em28xx #0:	Table at 0x04, strings=0x226a, 0x0000, 0x0000
[   19.287806] em28xx #0: Identified as Unknown EM2750/28xx video
grabber (card=1)
[   19.417291] em28xx #0: found i2c device @ 0xa0 [eeprom]
[   19.432537] em28xx #0: found i2c device @ 0xc0 [tuner (analog)]
[   19.450687] em28xx #0: Your board has no unique USB ID and thus need
a hint to be detected.
[   19.450749] em28xx #0: You may try to use card=<n> insmod option to
workaround that.
[   19.450804] em28xx #0: Please send an email with this log to:
[   19.450856] em28xx #0: 	V4L Mailing List
<linux-media@vger.kernel.org>linux-media@vger.kernel.org
[   19.450909] em28xx #0: Board eeprom hash is 0x47f0a3c0
[   19.450961] em28xx #0: Board i2c devicelist hash is 0x4b800080
[   19.451013] em28xx #0: Here is a list of valid choices for the
card=<n> insmod option:
[   19.451068] em28xx #0:     card=0 -> Unknown EM2800 video grabber
[   19.451121] em28xx #0:     card=1 -> Unknown EM2750/28xx video
grabber
[   19.451174] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
[   19.451227] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
[   19.451279] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
[   19.451331] em28xx #0:     card=5 -> MSI VOX USB 2.0
[   19.451382] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
[   19.451435] em28xx #0:     card=7 -> Leadtek Winfast USB II
[   19.451487] em28xx #0:     card=8 -> Kworld USB2800
[   19.451540] em28xx #0:     card=9 -> Pinnacle Dazzle DVC
90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2
[   19.451599] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
[   19.451651] em28xx #0:     card=11 -> Terratec Hybrid XS
[   19.451703] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
[   19.451755] em28xx #0:     card=13 -> Terratec Prodigy XS
[   19.451816] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview
Prolink PlayTV USB 2.0
[   19.451888] em28xx #0:     card=15 -> V-Gear PocketTV
[   19.451949] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
[   19.452048] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[   19.452111] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[   19.452172] em28xx #0:     card=19 -> EM2860/SAA711X Reference Design
[   19.452234] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
[   19.452295] em28xx #0:     card=21 -> eMPIA Technology, Inc. GrabBeeX
+ Video Encoder
[   19.452367] em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam
grabber
[   19.452429] em28xx #0:     card=23 -> Huaqi DLCW-130
[   19.452489] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
[   19.452551] em28xx #0:     card=25 -> Gadmei UTV310
[   19.452611] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
[   19.452672] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips
FM1216ME)
[   19.452735] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
[   19.452797] em28xx #0:     card=29 -> <NULL>
[   19.452855] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
[   19.452916] em28xx #0:     card=31 -> Usbgear VD204v9
[   19.452976] em28xx #0:     card=32 -> Supercomp USB 2.0 TV[
19.186452] em28xx: New device USB 2870 Device @ 480 Mbps (eb1a:2870,
interface 0, class 0)
[   19.187809] em28xx #0: chip ID is em2870
[   19.285935] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 70 28 c0 12
81 00 6a 22 00 00
[   19.285950] em28xx #0: i2c eeprom 10: 00 00 04 57 02 0d 00 00 00 00
00 00 00 00 00 00
[   19.285962] em28xx #0: i2c eeprom 20: 44 00 00 00 f0 10 02 00 00 00
00 00 5b 00 00 00
[   19.285974] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01
00 00 50 d1 19 49
[   19.285985] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   19.285997] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   19.286008] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00
22 03 55 00 53 00
[   19.286020] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 37 00
30 00 20 00 44 00
[   19.286031] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00
00 00 00 00 00 00
[   19.286043] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   19.286054] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   19.286066] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   19.286077] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   19.286089] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   19.286100] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   19.286111] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   19.286127] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash =
0x47f0a3c0
[   19.286129] em28xx #0: EEPROM info:
[   19.286131] em28xx #0:	No audio on board.
[   19.286134] em28xx #0:	500mA max power
[   19.286137] em28xx #0:	Table at 0x04, strings=0x226a, 0x0000, 0x0000
[   19.287806] em28xx #0: Identified as Unknown EM2750/28xx video
grabber (card=1)
[   19.417291] em28xx #0: found i2c device @ 0xa0 [eeprom]
[   19.432537] em28xx #0: found i2c device @ 0xc0 [tuner (analog)]
[   19.450687] em28xx #0: Your board has no unique USB ID and thus need
a hint to be detected.
[   19.450749] em28xx #0: You may try to use card=<n> insmod option to
workaround that.
[   19.450804] em28xx #0: Please send an email with this log to:
[   19.450856] em28xx #0: 	V4L Mailing List
<linux-media@vger.kernel.org>
[   19.450909] em28xx #0: Board eeprom hash is 0x47f0a3c0
[   19.450961] em28xx #0: Board i2c devicelist hash is 0x4b800080
[   19.451013] em28xx #0: Here is a list of valid choices for the
card=<n> insmod option:
[   19.451068] em28xx #0:     card=0 -> Unknown EM2800 video grabber
[   19.451121] em28xx #0:     card=1 -> Unknown EM2750/28xx video
grabber
[   19.451174] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
[   19.451227] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
[   19.451279] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
[   19.451331] em28xx #0:     card=5 -> MSI VOX USB 2.0
[   19.451382] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
[   19.451435] em28xx #0:     card=7 -> Leadtek Winfast USB II
[   19.451487] em28xx #0:     card=8 -> Kworld USB2800
[   19.451540] em28xx #0:     card=9 -> Pinnacle Dazzle DVC
90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2
[   19.451599] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
[   19.451651] em28xx #0:     card=11 -> Terratec Hybrid XS
[   19.451703] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
[   19.451755] em28xx #0:     card=13 -> Terratec Prodigy XS
[   19.451816] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview
Prolink PlayTV USB 2.0
[   19.451888] em28xx #0:     card=15 -> V-Gear PocketTV
[   19.451949] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
[   19.452048] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[   19.452111] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[   19.452172] em28xx #0:     card=19 -> EM2860/SAA711X Reference Design
[   19.452234] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
[   19.452295] em28xx #0:     card=21 -> eMPIA Technology, Inc. GrabBeeX
+ Video Encoder
[   19.452367] em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam
grabber
[   19.452429] em28xx #0:     card=23 -> Huaqi DLCW-130
[   19.452489] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
[   19.452551] em28xx #0:     card=25 -> Gadmei UTV310
[   19.452611] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
[   19.452672] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips
FM1216ME)
[   19.452735] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
[   19.452797] em28xx #0:     card=29 -> <NULL>
[   19.452855] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
[   19.452916] em28xx #0:     card=31 -> Usbgear VD204v9
[   19.452976] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
[   19.453037] em28xx #0:     card=33 -> <NULL>
[   19.453096] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
[   19.453158] em28xx #0:     card=35 -> Typhoon DVD Maker
[   19.453218] em28xx #0:     card=36 -> NetGMBH Cam
[   19.453277] em28xx #0:     card=37 -> Gadmei UTV330
[   19.453337] em28xx #0:     card=38 -> Yakumo MovieMixer
[   19.453397] em28xx #0:     card=39 -> KWorld PVRTV 300U
[   19.453458] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
[   19.453519] em28xx #0:     card=41 -> Kworld 350 U DVB-T
[   19.453580] em28xx #0:     card=42 -> Kworld 355 U DVB-T
[   19.453641] em28xx #0:     card=43 -> Terratec Cinergy T XS
[   19.453702] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[   19.453763] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
[   19.453824] em28xx #0:     card=46 -> Compro, VideoMate U3
[   19.453884] em28xx #0:     card=47 -> KWorld DVB-T 305U
[   19.453945] em28xx #0:     card=48 -> KWorld DVB-T 310U
[   19.454005] em28xx #0:     card=49 -> MSI DigiVox A/D
[   19.454064] em28xx #0:     card=50 -> MSI DigiVox A/D II
[   19.454125] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
[   19.454186] em28xx #0:     card=52 -> DNT DA2 Hybrid
[   19.454246] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
[   19.454307] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
[   19.454367] em28xx #0:     card=55 -> Terratec Hybrid XS (em2882)
[   19.454429] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (330e)
[   19.454490] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[   19.454551] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
[   19.454614] em28xx #0:     card=59 -> <NULL>
[   19.454672] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
[   19.454733] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[   19.454795] em28xx #0:     card=62 -> Gadmei TVR200
[   19.454854] em28xx #0:     card=63 -> Kaiomy TVnPC U2
[   19.454915] em28xx #0:     card=64 -> Easy Cap Capture DC-60
[   19.454976] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
[   19.455036] em28xx #0:     card=66 -> Empire dual TV
[   19.455095] em28xx #0:     card=67 -> Terratec Grabby
[   19.455155] em28xx #0:     card=68 -> Terratec AV350
[   19.455215] em28xx #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[   19.455276] em28xx #0:     card=70 -> Evga inDtube
[   19.455336] em28xx #0:     card=71 -> Silvercrest Webcam 1.3mpix
[   19.455398] em28xx #0:     card=72 -> Gadmei UTV330+
[   19.455458] em28xx #0:     card=73 -> Reddo DVB-C USB TV Box
[   19.455524] em28xx #0:     card=74 -> Actionmaster/LinXcel/Digitus
VC211A
[   19.455586] em28xx #0:     card=75 -> Dikom DK300
[   19.455995] em28xx #0: v4l2 driver version 0.1.2
[   19.471722] em28xx #0: V4L2 video device registered as video1
[   19.471766] usbcore: registered new interface driver em28xx

[   19.453037] em28xx #0:     card=33 -> <NULL>
[   19.453096] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
[   19.453158] em28xx #0:     card=35 -> Typhoon DVD Maker
[   19.453218] em28xx #0:     card=36 -> NetGMBH Cam
[   19.453277] em28xx #0:     card=37 -> Gadmei UTV330
[   19.453337] em28xx #0:     card=38 -> Yakumo MovieMixer
[   19.453397] em28xx #0:     card=39 -> KWorld PVRTV 300U
[   19.453458] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
[   19.453519] em28xx #0:     card=41 -> Kworld 350 U DVB-T
[   19.453580] em28xx #0:     card=42 -> Kworld 355 U DVB-T
[   19.453641] em28xx #0:     card=43 -> Terratec Cinergy T XS
[   19.453702] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[   19.453763] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
[   19.453824] em28xx #0:     card=46 -> Compro, VideoMate U3
[   19.453884] em28xx #0:     card=47 -> KWorld DVB-T 305U
[   19.453945] em28xx #0:     card=48 -> KWorld DVB-T 310U
[   19.454005] em28xx #0:     card=49 -> MSI DigiVox A/D
[   19.454064] em28xx #0:     card=50 -> MSI DigiVox A/D II
[   19.454125] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
[   19.454186] em28xx #0:     card=52 -> DNT DA2 Hybrid
[   19.454246] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
[   19.454307] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
[   19.454367] em28xx #0:     card=55 -> Terratec Hybrid XS (em2882)
[   19.454429] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (330e)
[   19.454490] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[   19.454551] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
[   19.454614] em28xx #0:     card=59 -> <NULL>
[   19.454672] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
[   19.454733] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[   19.454795] em28xx #0:     card=62 -> Gadmei TVR200
[   19.454854] em28xx #0:     card=63 -> Kaiomy TVnPC U2
[   19.454915] em28xx #0:     card=64 -> Easy Cap Capture DC-60
[   19.454976] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
[   19.455036] em28xx #0:     card=66 -> Empire dual TV
[   19.455095] em28xx #0:     card=67 -> Terratec Grabby
[   19.455155] em28xx #0:     card=68 -> Terratec AV350
[   19.455215] em28xx #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[   19.455276] em28xx #0:     card=70 -> Evga inDtube
[   19.455336] em28xx #0:     card=71 -> Silvercrest Webcam 1.3mpix
[   19.455398] em28xx #0:     card=72 -> Gadmei UTV330+
[   19.455458] em28xx #0:     card=73 -> Reddo DVB-C USB TV Box
[   19.455524] em28xx #0:     card=74 -> Actionmaster/LinXcel/Digitus
VC211A
[   19.455586] em28xx #0:     card=75 -> Dikom DK300
[   19.455995] em28xx #0: v4l2 driver version 0.1.2
[   19.471722] em28xx #0: V4L2 video device registered as video1
[   19.471766] usbcore: registered new interface driver em28xx

[   19.451949] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
[   19.452048] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[   19.452111] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[   19.452172] em28xx #0:     card=19 -> EM2860/SAA711X Reference Design
[   19.452234] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
[   19.452295] em28xx #0:     card=21 -> eMPIA Technology, Inc. GrabBeeX
+ Video Encoder
[   19.452367] em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam
grabber
[   19.452429] em28xx #0:     card=23 -> Huaqi DLCW-130
[   19.452489] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
[   19.452551] em28xx #0:     card=25 -> Gadmei UTV310
[   19.452611] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
[   19.452672] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips
FM1216ME)[   19.186452] em28xx: New device USB 2870 Device @ 480 Mbps
(eb1a:2870, interface 0, class 0)
[   19.187809] em28xx #0: chip ID is em2870
[   19.285935] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 70 28 c0 12
81 00 6a 22 00 00
[   19.285950] em28xx #0: i2c eeprom 10: 00 00 04 57 02 0d 00 00 00 00
00 00 00 00 00 00
[   19.285962] em28xx #0: i2c eeprom 20: 44 00 00 00 f0 10 02 00 00 00
00 00 5b 00 00 00
[   19.285974] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01
00 00 50 d1 19 49
[   19.285985] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   19.285997] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   19.286008] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00
22 03 55 00 53 00
[   19.286020] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 37 00
30 00 20 00 44 00
[   19.286031] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00
00 00 00 00 00 00
[   19.286043] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   19.286054] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   19.286066] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   19.286077] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   19.286089] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   19.286100] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   19.286111] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   19.286127] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash =
0x47f0a3c0
[   19.286129] em28xx #0: EEPROM info:
[   19.286131] em28xx #0:	No audio on board.
[   19.286134] em28xx #0:	500mA max power
[   19.286137] em28xx #0:	Table at 0x04, strings=0x226a, 0x0000, 0x0000
[   19.287806] em28xx #0: Identified as Unknown EM2750/28xx video
grabber (card=1)
[   19.417291] em28xx #0: found i2c device @ 0xa0 [eeprom]
[   19.432537] em28xx #0: found i2c device @ 0xc0 [tuner (analog)]
[   19.450687] em28xx #0: Your board has no unique USB ID and thus need
a hint to be detected.
[   19.450749] em28xx #0: You may try to use card=<n> insmod option to
workaround that.
[   19.450804] em28xx #0: Please send an email with this log to:
[   19.450856] em28xx #0: 	V4L Mailing List
<linux-media@vger.kernel.org>
[   19.450909] em28xx #0: Board eeprom hash is 0x47f0a3c0
[   19.450961] em28xx #0: Board i2c devicelist hash is 0x4b800080
[   19.451013] em28xx #0: Here is a list of valid choices for the
card=<n> insmod option:
[   19.451068] em28xx #0:     card=0 -> Unknown EM2800 video grabber
[   19.451121] em28xx #0:     card=1 -> Unknown EM2750/28xx video
grabber
[   19.451174] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
[   19.451227] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
[   19.451279] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
[   19.451331] em28xx #0:     card=5 -> MSI VOX USB 2.0
[   19.451382] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
[   19.451435] em28xx #0:     card=7 -> Leadtek Winfast USB II
[   19.451487] em28xx #0:     card=8 -> Kworld USB2800
[   19.451540] em28xx #0:     card=9 -> Pinnacle Dazzle DVC
90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2
[   19.451599] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
[   19.451651] em28xx #0:     card=11 -> Terratec Hybrid XS
[   19.451703] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
[   19.451755] em28xx #0:     card=13 -> Terratec Prodigy XS
[   19.451816] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview
Prolink PlayTV USB 2.0
[   19.451888] em28xx #0:     card=15 -> V-Gear PocketTV
[   19.451949] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
[   19.452048] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[   19.452111] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[   19.452172] em28xx #0:     card=19 -> EM2860/SAA711X Reference Design
[   19.452234] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
[   19.452295] em28xx #0:     card=21 -> eMPIA Technology, Inc. GrabBeeX
+ Video Encoder
[   19.452367] em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam
grabber
[   19.452429] em28xx #0:     card=23 -> Huaqi DLCW-130
[   19.452489] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
[   19.452551] em28xx #0:     card=25 -> Gadmei UTV310
[   19.452611] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
[   19.452672] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips
FM1216ME)
[   19.452735] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
[   19.452797] em28xx #0:     card=29 -> <NULL>
[   19.452855] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
[   19.452916] em28xx #0:     card=31 -> Usbgear VD204v9
[   19.452976] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
[   19.453037] em28xx #0:     card=33 -> <NULL>
[   19.453096] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
[   19.453158] em28xx #0:     card=35 -> Typhoon DVD Maker
[   19.453218] em28xx #0:     card=36 -> NetGMBH Cam
[   19.453277] em28xx #0:     card=37 -> Gadmei UTV330
[   19.453337] em28xx #0:     card=38 -> Yakumo MovieMixer
[   19.453397] em28xx #0:     card=39 -> KWorld PVRTV 300U
[   19.453458] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
[   19.453519] em28xx #0:     card=41 -> Kworld 350 U DVB-T
[   19.453580] em28xx #0:     card=42 -> Kworld 355 U DVB-T
[   19.453641] em28xx #0:     card=43 -> Terratec Cinergy T XS
[   19.453702] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[   19.453763] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
[   19.453824] em28xx #0:     card=46 -> Compro, VideoMate U3
[   19.453884] em28xx #0:     card=47 -> KWorld DVB-T 305U
[   19.453945] em28xx #0:     card=48 -> KWorld DVB-T 310U
[   19.454005] em28xx #0:     card=49 -> MSI DigiVox A/D
[   19.454064] em28xx #0:     card=50 -> MSI DigiVox A/D II
[   19.454125] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
[   19.454186] em28xx #0:     card=52 -> DNT DA2 Hybrid
[   19.454246] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
[   19.454307] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
[   19.454367] em28xx #0:     card=55 -> Terratec Hybrid XS (em2882)
[   19.454429] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (330e)
[   19.454490] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[   19.454551] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
[   19.454614] em28xx #0:     card=59 -> <NULL>
[   19.454672] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
[   19.454733] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[   19.454795] em28xx #0:     card=62 -> Gadmei TVR200
[   19.454854] em28xx #0:     card=63 -> Kaiomy TVnPC U2
[   19.454915] em28xx #0:     card=64 -> Easy Cap Capture DC-60
[   19.454976] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
[   19.455036] em28xx #0:     card=66 -> Empire dual TV
[   19.455095] em28xx #0:     card=67 -> Terratec Grabby
[   19.455155] em28xx #0:     card=68 -> Terratec AV350
[   19.455215] em28xx #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[   19.455276] em28xx #0:     card=70 -> Evga inDtube
[   19.455336] em28xx #0:     card=71 -> Silvercrest Webcam 1.3mpix
[   19.455398] em28xx #0:     card=72 -> Gadmei UTV330+
[   19.455458] em28xx #0:     card=73 -> Reddo DVB-C USB TV Box
[   19.455524] em28xx #0:     card=74 -> Actionmaster/LinXcel/Digitus
VC211A
[   19.455586] em28xx #0:     card=75 -> Dikom DK300
[   19.455995] em28xx #0: v4l2 driver version 0.1.2
[   19.471722] em28xx #0: V4L2 video device registered as video1
[   19.471766] usbcore: registered new interface driver em28xx

[   19.452735] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
[   19.452797] em28xx #0:     card=29 -> <NULL>
[   19.452855] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
[   19.452916] em28xx #0:     card=31 -> Usbgear VD204v9
[   19.452976] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
[   19.453037] em28xx #0:     card=33 -> <NULL>
[   19.453096] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
[   19.453158] em28xx #0:     card=35 -> Typhoon DVD Maker[   19.186452]
em28xx: New device USB 2870 Device @ 480 Mbps (eb1a:2870, interface 0,
class 0)
[   19.187809] em28xx #0: chip ID is em2870
[   19.285935] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 70 28 c0 12
81 00 6a 22 00 00
[   19.285950] em28xx #0: i2c eeprom 10: 00 00 04 57 02 0d 00 00 00 00
00 00 00 00 00 00
[   19.285962] em28xx #0: i2c eeprom 20: 44 00 00 00 f0 10 02 00 00 00
00 00 5b 00 00 00
[   19.285974] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01
00 00 50 d1 19 49
[   19.285985] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   19.285997] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   19.286008] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00
22 03 55 00 53 00
[   19.286020] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 37 00
30 00 20 00 44 00
[   19.286031] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00
00 00 00 00 00 00
[   19.286043] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   19.286054] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   19.286066] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   19.286077] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   19.286089] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   19.286100] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   19.286111] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   19.286127] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash =
0x47f0a3c0
[   19.286129] em28xx #0: EEPROM info:
[   19.286131] em28xx #0:	No audio on board.
[   19.286134] em28xx #0:	500mA max power
[   19.286137] em28xx #0:	Table at 0x04, strings=0x226a, 0x0000, 0x0000
[   19.287806] em28xx #0: Identified as Unknown EM2750/28xx video
grabber (card=1)
[   19.417291] em28xx #0: found i2c device @ 0xa0 [eeprom]
[   19.432537] em28xx #0: found i2c device @ 0xc0 [tuner (analog)]
[   19.450687] em28xx #0: Your board has no unique USB ID and thus need
a hint to be detected.
[   19.450749] em28xx #0: You may try to use card=<n> insmod option to
workaround that.
[   19.450804] em28xx #0: Please send an email with this log to:
[   19.450856] em28xx #0: 	V4L Mailing List
<linux-media@vger.kernel.org>
[   19.450909] em28xx #0: Board eeprom hash is 0x47f0a3c0
[   19.450961] em28xx #0: Board i2c devicelist hash is 0x4b800080
[   19.451013] em28xx #0: Here is a list of valid choices for the
card=<n> insmod option:
[   19.451068] em28xx #0:     card=0 -> Unknown EM2800 video grabber
[   19.451121] em28xx #0:     card=1 -> Unknown EM2750/28xx video
grabber
[   19.451174] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
[   19.451227] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
[   19.451279] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
[   19.451331] em28xx #0:     card=5 -> MSI VOX USB 2.0
[   19.451382] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
[   19.451435] em28xx #0:     card=7 -> Leadtek Winfast USB II
[   19.451487] em28xx #0:     card=8 -> Kworld USB2800
[   19.451540] em28xx #0:     card=9 -> Pinnacle Dazzle DVC
90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2
[   19.451599] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
[   19.451651] em28xx #0:     card=11 -> Terratec Hybrid XS
[   19.451703] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
[   19.451755] em28xx #0:     card=13 -> Terratec Prodigy XS
[   19.451816] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview
Prolink PlayTV USB 2.0
[   19.451888] em28xx #0:     card=15 -> V-Gear PocketTV
[   19.451949] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
[   19.452048] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[   19.452111] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[   19.452172] em28xx #0:     card=19 -> EM2860/SAA711X Reference Design
[   19.452234] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
[   19.452295] em28xx #0:     card=21 -> eMPIA Technology, Inc. GrabBeeX
+ Video Encoder
[   19.452367] em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam
grabber
[   19.452429] em28xx #0:     card=23 -> Huaqi DLCW-130
[   19.452489] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
[   19.452551] em28xx #0:     card=25 -> Gadmei UTV310
[   19.452611] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
[   19.452672] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips
FM1216ME)
[   19.452735] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
[   19.452797] em28xx #0:     card=29 -> <NULL>
[   19.452855] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
[   19.452916] em28xx #0:     card=31 -> Usbgear VD204v9
[   19.452976] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
[   19.453037] em28xx #0:     card=33 -> <NULL>
[   19.453096] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
[   19.453158] em28xx #0:     card=35 -> Typhoon DVD Maker
[   19.453218] em28xx #0:     card=36 -> NetGMBH Cam
[   19.453277] em28xx #0:     card=37 -> Gadmei UTV330
[   19.453337] em28xx #0:     card=38 -> Yakumo MovieMixer
[   19.453397] em28xx #0:     card=39 -> KWorld PVRTV 300U
[   19.453458] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
[   19.453519] em28xx #0:     card=41 -> Kworld 350 U DVB-T
[   19.453580] em28xx #0:     card=42 -> Kworld 355 U DVB-T
[   19.453641] em28xx #0:     card=43 -> Terratec Cinergy T XS
[   19.453702] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[   19.453763] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
[   19.453824] em28xx #0:     card=46 -> Compro, VideoMate U3
[   19.453884] em28xx #0:     card=47 -> KWorld DVB-T 305U
[   19.453945] em28xx #0:     card=48 -> KWorld DVB-T 310U
[   19.454005] em28xx #0:     card=49 -> MSI DigiVox A/D
[   19.454064] em28xx #0:     card=50 -> MSI DigiVox A/D II
[   19.454125] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
[   19.454186] em28xx #0:     card=52 -> DNT DA2 Hybrid
[   19.454246] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
[   19.454307] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
[   19.454367] em28xx #0:     card=55 -> Terratec Hybrid XS (em2882)
[   19.454429] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (330e)
[   19.454490] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[   19.454551] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
[   19.454614] em28xx #0:     card=59 -> <NULL>
[   19.454672] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
[   19.454733] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[   19.454795] em28xx #0:     card=62 -> Gadmei TVR200
[   19.454854] em28xx #0:     card=63 -> Kaiomy TVnPC U2
[   19.454915] em28xx #0:     card=64 -> Easy Cap Capture DC-60
[   19.454976] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
[   19.455036] em28xx #0:     card=66 -> Empire dual TV
[   19.455095] em28xx #0:     card=67 -> Terratec Grabby
[   19.455155] em28xx #0:     card=68 -> Terratec AV350
[   19.455215] em28xx #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[   19.455276] em28xx #0:     card=70 -> Evga inDtube
[   19.455336] em28xx #0:     card=71 -> Silvercrest Webcam 1.3mpix
[   19.455398] em28xx #0:     card=72 -> Gadmei UTV330+
[   19.455458] em28xx #0:     card=73 -> Reddo DVB-C USB TV Box
[   19.455524] em28xx #0:     card=74 -> Actionmaster/LinXcel/Digitus
VC211A
[   19.455586] em28xx #0:     card=75 -> Dikom DK300
[   19.455995] em28xx #0: v4l2 driver version 0.1.2
[   19.471722] em28xx #0: V4L2 video device registered as video1
[   19.471766] usbcore: registered new interface driver em28xx

[   19.453218] em28xx #0:     card=36 -> NetGMBH Cam
[   19.453277] em28xx #0:     card=37 -> Gadmei UTV330
[   19.453337] em28xx #0:     card=38 -> Yakumo MovieMixer
[   19.453397] em28xx #0:     card=39 -> KWorld PVRTV 300U
[   19.453458] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
[   19.453519] em28xx #0:     card=41 -> Kworld 350 U DVB-T
[   19.453580] em28xx #0:     card=42 -> Kworld 355 U DVB-T
[   19.453641] em28xx #0:     card=43 -> Terratec Cinergy T XS
[   19.453702] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[   19.453763] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
[   19.453824] em28xx #0:     card=46 -> Compro, VideoMate U3
[   19.453884] em28xx #0:     card=47 -> KWorld DVB-T 305U
[   19.453945] em28xx #0:     card=48 -> KWorld DVB-T 310U
[   19.454005] em28xx #0:     card=49 -> MSI DigiVox A/D
[   19.454064] em28xx #0:     card=50 -> MSI DigiVox A/D II
[   19.454125] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
[   19.454186] em28xx #0:     card=52 -> DNT DA2 Hybrid
[   19.454246] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
[   19.454307] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
[   19.454367] em28xx #0:     card=55 -> Terratec Hybrid XS (em2882)
[   19.454429] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (330e)
[   19.454490] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[   19.454551] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
[   19.454614] em28xx #0:     card=59 -> <NULL>
[   19.454672] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
[   19.454733] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[   19.454795] em28xx #0:     card=62 -> Gadmei TVR200
[   19.454854] em28xx #0:     card=63 -> Kaiomy TVnPC U2
[   19.454915] em28xx #0:     card=64 -> Easy Cap Capture DC-60
[   19.454976] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
[   19.455036] em28xx #0:     card=66 -> Empire dual TV
[   19.455095] em28xx #0:     card=67 -> Terratec Grabby
[   19.455155] em28xx #0:     card=68 -> Terratec AV350
[   19.455215] em28xx #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[   19.455276] em28xx #0:     card=70 -> Evga inDtube
[   19.455336] em28xx #0:     card=71 -> Silvercrest Webcam 1.3mpix
[   19.455398] em28xx #0:     card=72 -> Gadmei UTV330+
[   19.455458] em28xx #0:     card=73 -> Reddo DVB-C USB TV Box
[   19.455524] em28xx #0:     card=74 -> Actionmaster/LinXcel/Digitus
VC211A
[   19.455586] em28xx #0:     card=75 -> Dikom DK300
[   19.455995] em28xx #0: v4l2 driver version 0.1.2
[   19.471722] em28xx #0: V4L2 video device registered as video1
[   19.471766] usbcore: registered new interface driver em28xx


