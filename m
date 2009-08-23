Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail00a.mail.t-online.hu ([84.2.40.5]:57088 "EHLO
	mail00a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756004AbZHWMs7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Aug 2009 08:48:59 -0400
Message-ID: <4A913AB8.5060604@freemail.hu>
Date: Sun, 23 Aug 2009 14:48:56 +0200
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: V4L Mailing List <linux-media@vger.kernel.org>
CC: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Subject: Pinnacle Hybrid Pro Stick (320e)?
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have a Pinnacle Hybrid Pro Stick (320e) (USB ID: eb1a:2881). I am running Linux kernel
2.6.31-rc7. When I plug my device I get the following messages in 'dmesg':

[  144.434151] usb 3-3: new high speed USB device using ehci_hcd and address 3
[  144.556371] usb 3-3: configuration #1 chosen from 1 choice
[  145.598079] Linux video capture interface: v2.00
[  145.740558] em28xx: New device USB 2881 Video @ 480 Mbps (eb1a:2881, interface 0, class 0)
[  145.742186] em28xx #0: chip ID is em2882/em2883
[  145.823056] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 81 28 58 12 5c 00 6a 20 6a 00
[  145.823078] em28xx #0: i2c eeprom 10: 00 00 04 57 64 57 00 00 60 f4 00 00 02 02 00 00
[  145.823096] em28xx #0: i2c eeprom 20: 56 00 01 00 00 00 02 00 b8 00 00 00 5b 1e 00 00
[  145.823113] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 10 02 00 00 00 00 00 00
[  145.823130] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  145.823147] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  145.823163] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 20 03 55 00 53 00
[  145.823180] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 38 00 31 00 20 00 56 00
[  145.823197] em28xx #0: i2c eeprom 80: 69 00 64 00 65 00 6f 00 00 00 00 00 00 00 00 00
[  145.823213] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  145.823230] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  145.823246] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  145.823263] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  145.823279] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  145.823296] em28xx #0: i2c eeprom e0: 5a 00 55 aa cb 73 57 03 00 17 d4 01 00 00 00 00
[  145.823312] em28xx #0: i2c eeprom f0: 02 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00
[  145.823331] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0xc49e2420
[  145.823334] em28xx #0: EEPROM info:
[  145.823336] em28xx #0:       AC97 audio (5 sample rates)
[  145.823340] em28xx #0:       USB Remote wakeup capable
[  145.823342] em28xx #0:       500mA max power
[  145.823346] em28xx #0:       Table at 0x04, strings=0x206a, 0x006a, 0x0000
[  145.828537] em28xx #0: Identified as Unknown EM2750/28xx video grabber (card=1)
[  145.860871] em28xx #0: found i2c device @ 0xa0 [eeprom]
[  145.865864] em28xx #0: found i2c device @ 0xb8 [tvp5150a]
[  145.868237] em28xx #0: found i2c device @ 0xc2 [tuner (analog)]
[  145.880344] em28xx #0: Your board has no unique USB ID and thus need a hint to be detected.
[  145.880352] em28xx #0: You may try to use card=<n> insmod option to workaround that.
[  145.880355] em28xx #0: Please send an email with this log to:
[  145.880358] em28xx #0:       V4L Mailing List <linux-media@vger.kernel.org>
[  145.880362] em28xx #0: Board eeprom hash is 0xc49e2420
[  145.880365] em28xx #0: Board i2c devicelist hash is 0x27e10080
[  145.880368] em28xx #0: Here is a list of valid choices for the card=<n> insmod option:
[  145.880372] em28xx #0:     card=0 -> Unknown EM2800 video grabber
[  145.880375] em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
[  145.880379] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
[  145.880382] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
[  145.880385] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
[  145.880389] em28xx #0:     card=5 -> MSI VOX USB 2.0
[  145.880392] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
[  145.880395] em28xx #0:     card=7 -> Leadtek Winfast USB II
[  145.880398] em28xx #0:     card=8 -> Kworld USB2800
[  145.880401] em28xx #0:     card=9 -> Pinnacle Dazzle DVC 90/100/101/107 / Kaiser Baas Video to DVD maker
[  145.880405] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
[  145.880409] em28xx #0:     card=11 -> Terratec Hybrid XS
[  145.880412] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
[  145.880415] em28xx #0:     card=13 -> Terratec Prodigy XS
[  145.880419] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview Prolink PlayTV USB 2.0
[  145.880422] em28xx #0:     card=15 -> V-Gear PocketTV
[  145.880426] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
[  145.880429] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[  145.880432] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[  145.880436] em28xx #0:     card=19 -> EM2860/SAA711X Reference Design
[  145.880439] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
[  145.880442] em28xx #0:     card=21 -> eMPIA Technology, Inc. GrabBeeX+ Video Encoder
[  145.880446] em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam grabber
[  145.880450] em28xx #0:     card=23 -> Huaqi DLCW-130
[  145.880453] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
[  145.880456] em28xx #0:     card=25 -> Gadmei UTV310
[  145.880459] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
[  145.880462] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips FM1216ME)
[  145.880466] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
[  145.880470] em28xx #0:     card=29 -> <NULL>
[  145.880472] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
[  145.880476] em28xx #0:     card=31 -> Usbgear VD204v9
[  145.880479] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
[  145.880482] em28xx #0:     card=33 -> <NULL>
[  145.880485] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
[  145.880488] em28xx #0:     card=35 -> Typhoon DVD Maker
[  145.880492] em28xx #0:     card=36 -> NetGMBH Cam
[  145.880495] em28xx #0:     card=37 -> Gadmei UTV330
[  145.880498] em28xx #0:     card=38 -> Yakumo MovieMixer
[  145.880501] em28xx #0:     card=39 -> KWorld PVRTV 300U
[  145.880504] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
[  145.880508] em28xx #0:     card=41 -> Kworld 350 U DVB-T
[  145.880511] em28xx #0:     card=42 -> Kworld 355 U DVB-T
[  145.880514] em28xx #0:     card=43 -> Terratec Cinergy T XS
[  145.880517] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[  145.880521] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
[  145.880524] em28xx #0:     card=46 -> Compro, VideoMate U3
[  145.880528] em28xx #0:     card=47 -> KWorld DVB-T 305U
[  145.880531] em28xx #0:     card=48 -> KWorld DVB-T 310U
[  145.880534] em28xx #0:     card=49 -> MSI DigiVox A/D
[  145.880537] em28xx #0:     card=50 -> MSI DigiVox A/D II
[  145.880540] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
[  145.880543] em28xx #0:     card=52 -> DNT DA2 Hybrid
[  145.880547] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
[  145.880550] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
[  145.880554] em28xx #0:     card=55 -> Terratec Hybrid XS (em2882)
[  145.880557] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (2)
[  145.880560] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[  145.880564] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
[  145.880567] em28xx #0:     card=59 -> <NULL>
[  145.880570] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
[  145.880573] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[  145.880577] em28xx #0:     card=62 -> Gadmei TVR200
[  145.880580] em28xx #0:     card=63 -> Kaiomy TVnPC U2
[  145.880583] em28xx #0:     card=64 -> Easy Cap Capture DC-60
[  145.880586] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
[  145.880590] em28xx #0:     card=66 -> Empire dual TV
[  145.880593] em28xx #0:     card=67 -> Terratec Grabby
[  145.880596] em28xx #0:     card=68 -> Terratec AV350
[  145.880599] em28xx #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[  145.880602] em28xx #0:     card=70 -> Evga inDtube
[  145.880605] em28xx #0:     card=71 -> Silvercrest Webcam 1.3mpix
[  145.880716] em28xx #0: Config register raw data: 0x58
[  145.890593] em28xx #0: AC97 vendor ID = 0x3eb03eb0
[  145.890963] em28xx #0: AC97 features = 0x3eb0
[  145.890966] em28xx #0: Unknown AC97 audio processor detected!
[  145.922320] em28xx #0: v4l2 driver version 0.1.2
[  145.973630] em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
[  146.027706] usbcore: registered new interface driver em28xx
[  146.027787] em28xx driver loaded
[  146.062766] usbcore: registered new interface driver snd-usb-audio

This device was working with 2.6.28 together with the out-of-tree
driver from mcentral.de ("hg clone http://mcentral.de/hg/~mrec/em28xx-new").

What has to be done in order this device can work with the newest Linux kernel?

Regards,

	Márton Németh

