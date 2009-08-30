Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail00a.mail.t-online.hu ([84.2.40.5]:56774 "EHLO
	mail00a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbZH3HS4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Aug 2009 03:18:56 -0400
Message-ID: <4A9A27DD.3020807@freemail.hu>
Date: Sun, 30 Aug 2009 09:18:53 +0200
From: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: hermann pitton <hermann-pitton@arcor.de>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: Pinnacle Hybrid Pro Stick (320e)?
References: <4A913AB8.5060604@freemail.hu>	 <1251032765.4905.19.camel@pc07.localdom.local>	 <4A9140A7.6020402@freemail.hu>	 <1251033530.4905.25.camel@pc07.localdom.local> <829197380908230629w62399f3cicd2dd9a9f2c6aeab@mail.gmail.com>
In-Reply-To: <829197380908230629w62399f3cicd2dd9a9f2c6aeab@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller wrote:
> I committed some changes to get this board working a few weeks ago.  I
> will check your dmesg output and see if the changes missed the merge
> window.  It's possible the changes didn't make it in time for 2.6.31,
> so I will have to check.

I tried the following software setup with Pinnacle Hybrid Pro Stick (320e)
(USB ID: eb1a:2881): Linux kernel 2.6.31-rc7 updated with the
http://linuxtv.org/hg/v4l-dvb repository at version 12564:6f58a5d8c7c6.

When I plug the device I still get the following message:

[  111.681186] usb 4-3: new high speed USB device using ehci_hcd and address 3
[  111.803542] usb 4-3: configuration #1 chosen from 1 choice
[  112.196629] Linux video capture interface: v2.00
[  112.376039] em28xx: New device USB 2881 Video @ 480 Mbps (eb1a:2881, interface 0, class 0)
[  112.377937] em28xx #0: chip ID is em2882/em2883
[  112.383927] usbcore: registered new interface driver snd-usb-audio
[  112.460285] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 81 28 58 12 5c 00 6a 20 6a 00
[  112.460308] em28xx #0: i2c eeprom 10: 00 00 04 57 64 57 00 00 60 f4 00 00 02 02 00 00
[  112.460326] em28xx #0: i2c eeprom 20: 56 00 01 00 00 00 02 00 b8 00 00 00 5b 1e 00 00
[  112.460343] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 10 02 00 00 00 00 00 00
[  112.460360] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  112.460377] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  112.460393] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 20 03 55 00 53 00
[  112.460410] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 38 00 31 00 20 00 56 00
[  112.460426] em28xx #0: i2c eeprom 80: 69 00 64 00 65 00 6f 00 00 00 00 00 00 00 00 00
[  112.460443] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  112.460460] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  112.460476] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  112.460493] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  112.460509] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  112.460526] em28xx #0: i2c eeprom e0: 5a 00 55 aa cb 73 57 03 00 17 d4 01 00 00 00 00
[  112.460543] em28xx #0: i2c eeprom f0: 02 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00
[  112.460561] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0xc49e2420
[  112.460564] em28xx #0: EEPROM info:
[  112.460567] em28xx #0:	AC97 audio (5 sample rates)
[  112.460570] em28xx #0:	USB Remote wakeup capable
[  112.460573] em28xx #0:	500mA max power
[  112.460577] em28xx #0:	Table at 0x04, strings=0x206a, 0x006a, 0x0000
[  112.466288] em28xx #0: Identified as Unknown EM2750/28xx video grabber (card=1)
[  112.499766] em28xx #0: found i2c device @ 0xa0 [eeprom]
[  112.505263] em28xx #0: found i2c device @ 0xb8 [tvp5150a]
[  112.507760] em28xx #0: found i2c device @ 0xc2 [tuner (analog)]
[  112.520001] em28xx #0: Your board has no unique USB ID and thus need a hint to be detected.
[  112.520239] em28xx #0: You may try to use card=<n> insmod option to workaround that.
[  112.520244] em28xx #0: Please send an email with this log to:
[  112.520247] em28xx #0: 	V4L Mailing List <linux-media@vger.kernel.org>
[  112.520251] em28xx #0: Board eeprom hash is 0xc49e2420
[  112.520254] em28xx #0: Board i2c devicelist hash is 0x27e10080
[  112.520257] em28xx #0: Here is a list of valid choices for the card=<n> insmod option:
[  112.520262] em28xx #0:     card=0 -> Unknown EM2800 video grabber
[  112.520266] em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
[  112.520269] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
[  112.520273] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
[  112.520276] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
[  112.520279] em28xx #0:     card=5 -> MSI VOX USB 2.0
[  112.520283] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
[  112.520286] em28xx #0:     card=7 -> Leadtek Winfast USB II
[  112.520290] em28xx #0:     card=8 -> Kworld USB2800
[  112.520293] em28xx #0:     card=9 -> Pinnacle Dazzle DVC 90/100/101/107 / Kaiser Baas Video to DVD maker
[  112.520297] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
[  112.520301] em28xx #0:     card=11 -> Terratec Hybrid XS
[  112.520304] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
[  112.520308] em28xx #0:     card=13 -> Terratec Prodigy XS
[  112.520311] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview Prolink PlayTV USB 2.0
[  112.520315] em28xx #0:     card=15 -> V-Gear PocketTV
[  112.520318] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
[  112.520322] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[  112.520325] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[  112.520329] em28xx #0:     card=19 -> EM2860/SAA711X Reference Design
[  112.520332] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
[  112.520336] em28xx #0:     card=21 -> eMPIA Technology, Inc. GrabBeeX+ Video Encoder
[  112.520340] em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam grabber
[  112.520343] em28xx #0:     card=23 -> Huaqi DLCW-130
[  112.520346] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
[  112.520350] em28xx #0:     card=25 -> Gadmei UTV310
[  112.520353] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
[  112.520356] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips FM1216ME)
[  112.520360] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
[  112.520364] em28xx #0:     card=29 -> <NULL>
[  112.520367] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
[  112.520370] em28xx #0:     card=31 -> Usbgear VD204v9
[  112.520374] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
[  112.520377] em28xx #0:     card=33 -> <NULL>
[  112.520380] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
[  112.520384] em28xx #0:     card=35 -> Typhoon DVD Maker
[  112.520387] em28xx #0:     card=36 -> NetGMBH Cam
[  112.520390] em28xx #0:     card=37 -> Gadmei UTV330
[  112.520393] em28xx #0:     card=38 -> Yakumo MovieMixer
[  112.520397] em28xx #0:     card=39 -> KWorld PVRTV 300U
[  112.520400] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
[  112.520403] em28xx #0:     card=41 -> Kworld 350 U DVB-T
[  112.520407] em28xx #0:     card=42 -> Kworld 355 U DVB-T
[  112.520410] em28xx #0:     card=43 -> Terratec Cinergy T XS
[  112.520413] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[  112.520417] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
[  112.520420] em28xx #0:     card=46 -> Compro, VideoMate U3
[  112.520424] em28xx #0:     card=47 -> KWorld DVB-T 305U
[  112.520427] em28xx #0:     card=48 -> KWorld DVB-T 310U
[  112.520430] em28xx #0:     card=49 -> MSI DigiVox A/D
[  112.520433] em28xx #0:     card=50 -> MSI DigiVox A/D II
[  112.520437] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
[  112.520440] em28xx #0:     card=52 -> DNT DA2 Hybrid
[  112.520444] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
[  112.520447] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
[  112.520450] em28xx #0:     card=55 -> Terratec Hybrid XS (em2882)
[  112.520454] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (2)
[  112.520457] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[  112.520461] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
[  112.520465] em28xx #0:     card=59 -> <NULL>
[  112.520468] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
[  112.520471] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[  112.520475] em28xx #0:     card=62 -> Gadmei TVR200
[  112.520478] em28xx #0:     card=63 -> Kaiomy TVnPC U2
[  112.520481] em28xx #0:     card=64 -> Easy Cap Capture DC-60
[  112.520485] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
[  112.520488] em28xx #0:     card=66 -> Empire dual TV
[  112.520491] em28xx #0:     card=67 -> Terratec Grabby
[  112.520495] em28xx #0:     card=68 -> Terratec AV350
[  112.520498] em28xx #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[  112.520501] em28xx #0:     card=70 -> Evga inDtube
[  112.520505] em28xx #0:     card=71 -> Silvercrest Webcam 1.3mpix
[  112.520760] em28xx #0: Config register raw data: 0x58
[  112.530630] em28xx #0: AC97 vendor ID = 0x7eb07eb0
[  112.531000] em28xx #0: AC97 features = 0x7eb0
[  112.531497] em28xx #0: Unknown AC97 audio processor detected!
[  112.554574] em28xx #0: v4l2 driver version 0.1.2
[  112.592340] em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
[  112.598179] usbcore: registered new interface driver em28xx
[  112.598234] em28xx driver loaded

What should be the next step to get this device working?

Regards,

	Márton Németh

