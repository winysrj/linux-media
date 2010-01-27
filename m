Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f215.google.com ([209.85.220.215]:50573 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187Ab0A0VA5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2010 16:00:57 -0500
Received: by mail-fx0-f215.google.com with SMTP id 7so3145785fxm.28
        for <linux-media@vger.kernel.org>; Wed, 27 Jan 2010 13:00:56 -0800 (PST)
Message-ID: <4B60A983.7040405@gmail.com>
Date: Wed, 27 Jan 2010 22:00:51 +0100
From: Sebastian Spiess <sebastian.spiess@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: dmesg output with Pinnacle PCTV USB Stick
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi there,
below is my dmesh output for my Pinnacle PCTV Hybrid Pro

hope it helps

[ 8899.390876] em28xx: New device USB 2870 Device @ 480 Mbps (eb1a:2870,
interface 0, class 0)
[ 8899.391162] em28xx #0: chip ID is em2870
[ 8899.474026] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 70 28 c0 12
81 00 6a 22 00 00
[ 8899.474096] em28xx #0: i2c eeprom 10: 00 00 04 57 02 0d 00 00 00 00
00 00 00 00 00 00
[ 8899.474162] em28xx #0: i2c eeprom 20: 44 00 00 00 f0 10 02 00 00 00
00 00 5b 00 00 00
[ 8899.474227] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01
00 00 6d e0 a3 49
[ 8899.474311] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 8899.474376] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 8899.474441] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00
22 03 55 00 53 00
[ 8899.474506] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 37 00
30 00 20 00 44 00
[ 8899.474571] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00
00 00 00 00 00 00
[ 8899.474640] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 8899.474706] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 8899.474789] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 8899.474854] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 8899.474919] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 8899.474984] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 8899.475048] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 8899.475117] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0xf0ff19c0
[ 8899.475141] em28xx #0: EEPROM info:
[ 8899.475146] em28xx #0:	No audio on board.
[ 8899.475151] em28xx #0:	500mA max power
[ 8899.475175] em28xx #0:	Table at 0x04, strings=0x226a, 0x0000, 0x0000
[ 8899.491654] em28xx #0: Identified as Unknown EM2750/28xx video
grabber (card=1)
[ 8899.527409] em28xx #0: found i2c device @ 0xa0 [eeprom]
[ 8899.535029] em28xx #0: found i2c device @ 0xc0 [tuner (analog)]
[ 8899.550027] em28xx #0: Your board has no unique USB ID and thus need
a hint to be detected.
[ 8899.550054] em28xx #0: You may try to use card=<n> insmod option to
workaround that.
[ 8899.550061] em28xx #0: Please send an email with this log to:
[ 8899.550085] em28xx #0: 	V4L Mailing List <linux-media@vger.kernel.org>
[ 8899.550091] em28xx #0: Board eeprom hash is 0xf0ff19c0
[ 8899.550115] em28xx #0: Board i2c devicelist hash is 0x4b800080
[ 8899.550121] em28xx #0: Here is a list of valid choices for the
card=<n> insmod option:
[ 8899.550128] em28xx #0:     card=0 -> Unknown EM2800 video grabber
[ 8899.550153] em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
[ 8899.550160] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
[ 8899.550188] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
[ 8899.550212] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
[ 8899.550219] em28xx #0:     card=5 -> MSI VOX USB 2.0
[ 8899.550242] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
[ 8899.550249] em28xx #0:     card=7 -> Leadtek Winfast USB II
[ 8899.550255] em28xx #0:     card=8 -> Kworld USB2800
[ 8899.550280] em28xx #0:     card=9 -> Pinnacle Dazzle DVC
90/100/101/107 / Kaiser Baas Video to DVD maker
[ 8899.550287] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
[ 8899.550312] em28xx #0:     card=11 -> Terratec Hybrid XS
[ 8899.550318] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
[ 8899.550342] em28xx #0:     card=13 -> Terratec Prodigy XS
[ 8899.550349] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview
Prolink PlayTV USB 2.0
[ 8899.550374] em28xx #0:     card=15 -> V-Gear PocketTV
[ 8899.550380] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
[ 8899.550405] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[ 8899.550411] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[ 8899.550436] em28xx #0:     card=19 -> EM2860/SAA711X Reference Design
[ 8899.550443] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
[ 8899.550468] em28xx #0:     card=21 -> eMPIA Technology, Inc.
GrabBeeX+ Video Encoder
[ 8899.550475] em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam grabber
[ 8899.550499] em28xx #0:     card=23 -> Huaqi DLCW-130
[ 8899.550505] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
[ 8899.550530] em28xx #0:     card=25 -> Gadmei UTV310
[ 8899.550536] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
[ 8899.550543] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips
FM1216ME)
[ 8899.550568] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
[ 8899.550574] em28xx #0:     card=29 -> <NULL>
[ 8899.550599] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
[ 8899.550605] em28xx #0:     card=31 -> Usbgear VD204v9
[ 8899.550629] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
[ 8899.550635] em28xx #0:     card=33 -> <NULL>
[ 8899.550659] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
[ 8899.550665] em28xx #0:     card=35 -> Typhoon DVD Maker
[ 8899.550689] em28xx #0:     card=36 -> NetGMBH Cam
[ 8899.550695] em28xx #0:     card=37 -> Gadmei UTV330
[ 8899.550701] em28xx #0:     card=38 -> Yakumo MovieMixer
[ 8899.550726] em28xx #0:     card=39 -> KWorld PVRTV 300U
[ 8899.550732] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
[ 8899.550756] em28xx #0:     card=41 -> Kworld 350 U DVB-T
[ 8899.550763] em28xx #0:     card=42 -> Kworld 355 U DVB-T
[ 8899.550787] em28xx #0:     card=43 -> Terratec Cinergy T XS
[ 8899.550793] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[ 8899.550818] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
[ 8899.550850] em28xx #0:     card=46 -> Compro, VideoMate U3
[ 8899.550857] em28xx #0:     card=47 -> KWorld DVB-T 305U
[ 8899.550881] em28xx #0:     card=48 -> KWorld DVB-T 310U
[ 8899.550887] em28xx #0:     card=49 -> MSI DigiVox A/D
[ 8899.550894] em28xx #0:     card=50 -> MSI DigiVox A/D II
[ 8899.550918] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
[ 8899.550924] em28xx #0:     card=52 -> DNT DA2 Hybrid
[ 8899.550948] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
[ 8899.550955] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
[ 8899.550979] em28xx #0:     card=55 -> Terratec Hybrid XS (em2882)
[ 8899.550986] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (2)
[ 8899.551011] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[ 8899.551017] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
[ 8899.551042] em28xx #0:     card=59 -> <NULL>
[ 8899.551048] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
[ 8899.551072] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[ 8899.551079] em28xx #0:     card=62 -> Gadmei TVR200
[ 8899.551103] em28xx #0:     card=63 -> Kaiomy TVnPC U2
[ 8899.551109] em28xx #0:     card=64 -> Easy Cap Capture DC-60
[ 8899.551115] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
[ 8899.551139] em28xx #0:     card=66 -> Empire dual TV
[ 8899.551145] em28xx #0:     card=67 -> Terratec Grabby
[ 8899.551169] em28xx #0:     card=68 -> Terratec AV350
[ 8899.551176] em28xx #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[ 8899.551200] em28xx #0:     card=70 -> Evga inDtube
[ 8899.551206] em28xx #0:     card=71 -> Silvercrest Webcam 1.3mpix
[ 8899.551235] em28xx #0: v4l2 driver version 0.1.2
[ 8899.588275] em28xx #0: V4L2 device registered as /dev/video1 and
/dev/vbi0
[ 9193.427765] em28xx #0: disconnecting em28xx #0 video
[ 9193.427791] em28xx #0: V4L2 device /dev/vbi0 deregistered
[ 9193.428093] em28xx #0: V4L2 device /dev/video1 deregistered
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAktgqXYACgkQMuBzgG5z7F8L0gCgoTGZtJt5JNrwH4yJKj167vnN
z+UAniRu8ke2Rj5fgDW19fNkBO4czV77
=8nwn
-----END PGP SIGNATURE-----
