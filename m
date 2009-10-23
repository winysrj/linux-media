Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.surf-town.net ([212.97.132.190]:47094 "EHLO
	mailout1.surf-town.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbZJWOgs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Oct 2009 10:36:48 -0400
Received: from localhost (mailout1 [127.0.0.1])
	by mailout1.surf-town.net (Postfix) with ESMTP id 7A3F7F001502
	for <linux-media@vger.kernel.org>; Fri, 23 Oct 2009 16:12:50 +0200 (CEST)
Received: from squirrel-webmail.surftown.com (unknown [212.97.133.1])
	by mailout1.surf-town.net (Postfix) with ESMTP id 755E2F00130B
	for <linux-media@vger.kernel.org>; Fri, 23 Oct 2009 16:12:39 +0200 (CEST)
Message-ID: <56601b784c3fd9cde05d75ad15ca98a9.squirrel@squirrel-webmail.surftown.com>
Date: Fri, 23 Oct 2009 16:12:39 +0200 (CEST)
Subject: Pinnacle PCTV DVB-T support.
From: mark@spanberg.se
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

I found my old Pinnacle PCTV DVB-T card and thought I might put it to use.
Since I have used it on linux before (about two years ago) with the em28xx
driver I didn't think it would be any problems.

However I can't seem to get it to work.

I'm using Ubuntu Karmic and a "uname -a" yields:
Linux kitchen 2.6.31-14-generic #48-Ubuntu SMP Fri Oct 16 14:04:26 UTC
2009 i686 GNU/Linux

"lsusb -d eb1a:2870" says:
Bus 001 Device 004: ID eb1a:2870 eMPIA Technology, Inc. Pinnacle PCTV Stick

Ok.. Got the latest sources of v4l-dvb compiled and installed.

"modprobe em28xx" followed by "dmesg" says:
[31801.169920] em28xx: New device USB 2870 Device @ 480 Mbps (eb1a:2870,
interface 0, class 0)
[31801.170035] em28xx #0: chip ID is em2870
[31801.251418] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 70 28 c0 12 81
00 6a 22 00 00
[31801.251438] em28xx #0: i2c eeprom 10: 00 00 04 57 02 0d 00 00 00 00 00
00 00 00 00 00
[31801.251455] em28xx #0: i2c eeprom 20: 44 00 00 00 f0 10 02 00 00 00 00
00 5b 00 00 00
[31801.251472] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 00
00 4d 44 e8 48
[31801.251489] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00
[31801.251506] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00
[31801.251524] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 22
03 55 00 53 00
[31801.251541] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 37 00 30
00 20 00 44 00
[31801.251558] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00 00
00 00 00 00 00
[31801.251575] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00
[31801.251592] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00
[31801.251609] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00
[31801.251626] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00
[31801.251643] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00
[31801.251660] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00
[31801.251677] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00
[31801.251696] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0xf76752c1
[31801.251700] em28xx #0: EEPROM info:
[31801.251702] em28xx #0:	No audio on board.
[31801.251705] em28xx #0:	500mA max power
[31801.251709] em28xx #0:	Table at 0x04, strings=0x226a, 0x0000, 0x0000
[31801.257536] em28xx #0: Identified as Unknown EM2750/28xx video grabber
(card=1)
[31801.263537] em28xx #0: found i2c device @ 0x1e [???]
[31801.289788] em28xx #0: found i2c device @ 0xa0 [eeprom]
[31801.295789] em28xx #0: found i2c device @ 0xc0 [tuner (analog)]
[31801.307537] em28xx #0: Your board has no unique USB ID and thus need a
hint to be detected.
[31801.307542] em28xx #0: You may try to use card=<n> insmod option to
workaround that.
[31801.307546] em28xx #0: Please send an email with this log to:
[31801.307549] em28xx #0: 	V4L Mailing List <linux-media@vger.kernel.org>
[31801.307553] em28xx #0: Board eeprom hash is 0xf76752c1
[31801.307556] em28xx #0: Board i2c devicelist hash is 0x482e008f
[31801.307559] em28xx #0: Here is a list of valid choices for the card=<n>
insmod option:
[31801.307563] em28xx #0:     card=0 -> Unknown EM2800 video grabber
[31801.307567] em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
[31801.307571] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
[31801.307575] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
[31801.307578] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
[31801.307582] em28xx #0:     card=5 -> MSI VOX USB 2.0
[31801.307585] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
[31801.307589] em28xx #0:     card=7 -> Leadtek Winfast USB II
[31801.307592] em28xx #0:     card=8 -> Kworld USB2800
[31801.307596] em28xx #0:     card=9 -> Pinnacle Dazzle DVC 90/100/101/107
/ Kaiser Baas Video to DVD maker / Kworld DVD Maker 2
[31801.307600] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
[31801.307604] em28xx #0:     card=11 -> Terratec Hybrid XS
[31801.307608] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
[31801.307612] em28xx #0:     card=13 -> Terratec Prodigy XS
[31801.307615] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview
Prolink PlayTV USB 2.0
[31801.307620] em28xx #0:     card=15 -> V-Gear PocketTV
[31801.307623] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
[31801.307627] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[31801.307631] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[31801.307634] em28xx #0:     card=19 -> EM2860/SAA711X Reference Design
[31801.307638] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
[31801.307642] em28xx #0:     card=21 -> eMPIA Technology, Inc. GrabBeeX+
Video Encoder
[31801.307646] em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam grabber
[31801.307650] em28xx #0:     card=23 -> Huaqi DLCW-130
[31801.307654] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
[31801.307657] em28xx #0:     card=25 -> Gadmei UTV310
[31801.307661] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
[31801.307665] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips
FM1216ME)
[31801.307669] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
[31801.307673] em28xx #0:     card=29 -> <NULL>
[31801.307676] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
[31801.307680] em28xx #0:     card=31 -> Usbgear VD204v9
[31801.307683] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
[31801.307687] em28xx #0:     card=33 -> <NULL>
[31801.307690] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
[31801.307694] em28xx #0:     card=35 -> Typhoon DVD Maker
[31801.307698] em28xx #0:     card=36 -> NetGMBH Cam
[31801.307701] em28xx #0:     card=37 -> Gadmei UTV330
[31801.307705] em28xx #0:     card=38 -> Yakumo MovieMixer
[31801.307709] em28xx #0:     card=39 -> KWorld PVRTV 300U
[31801.307712] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
[31801.307716] em28xx #0:     card=41 -> Kworld 350 U DVB-T
[31801.307719] em28xx #0:     card=42 -> Kworld 355 U DVB-T
[31801.307723] em28xx #0:     card=43 -> Terratec Cinergy T XS
[31801.307727] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[31801.307731] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
[31801.307734] em28xx #0:     card=46 -> Compro, VideoMate U3
[31801.307738] em28xx #0:     card=47 -> KWorld DVB-T 305U
[31801.307741] em28xx #0:     card=48 -> KWorld DVB-T 310U
[31801.307745] em28xx #0:     card=49 -> MSI DigiVox A/D
[31801.307749] em28xx #0:     card=50 -> MSI DigiVox A/D II
[31801.307753] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
[31801.307756] em28xx #0:     card=52 -> DNT DA2 Hybrid
[31801.307760] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
[31801.307764] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
[31801.307768] em28xx #0:     card=55 -> Terratec Hybrid XS (em2882)
[31801.307771] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (2)
[31801.307775] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[31801.307779] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
[31801.307783] em28xx #0:     card=59 -> <NULL>
[31801.307786] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
[31801.307790] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[31801.307794] em28xx #0:     card=62 -> Gadmei TVR200
[31801.307797] em28xx #0:     card=63 -> Kaiomy TVnPC U2
[31801.307801] em28xx #0:     card=64 -> Easy Cap Capture DC-60
[31801.307804] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
[31801.307808] em28xx #0:     card=66 -> Empire dual TV
[31801.307812] em28xx #0:     card=67 -> Terratec Grabby
[31801.307815] em28xx #0:     card=68 -> Terratec AV350
[31801.307819] em28xx #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[31801.307822] em28xx #0:     card=70 -> Evga inDtube
[31801.307826] em28xx #0:     card=71 -> Silvercrest Webcam 1.3mpix
[31801.307830] em28xx #0:     card=72 -> Gadmei UTV330+
[31801.307833] em28xx #0:     card=73 -> Reddo DVB-C USB TV Box
[31801.307839] em28xx #0: v4l2 driver version 0.1.2
[31801.327112] em28xx #0: V4L2 video device registered as /dev/video1
[31801.327169] usbcore: registered new interface driver em28xx
[31801.327173] em28xx driver loaded

Ok.. unload the module and load it again with "modprobe em28xx card=45" says:

[31911.468595] em28xx: New device USB 2870 Device @ 480 Mbps (eb1a:2870,
interface 0, class 0)
[31911.468717] em28xx #0: chip ID is em2870
[31911.762306] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 70 28 c0 12 81
00 6a 22 00 00
[31911.762318] em28xx #0: i2c eeprom 10: 00 00 04 57 02 0d 00 00 00 00 00
00 00 00 00 00
[31911.762328] em28xx #0: i2c eeprom 20: 44 00 00 00 f0 10 02 00 00 00 00
00 5b 00 00 00
[31911.762339] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 00
00 4d 44 e8 48
[31911.762349] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00
[31911.762359] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00
[31911.762369] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 22
03 55 00 53 00
[31911.762379] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 37 00 30
00 20 00 44 00
[31911.762390] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00 00
00 00 00 00 00
[31911.762400] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00
[31911.762410] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00
[31911.762420] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00
[31911.762430] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00
[31911.762441] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00
[31911.762451] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00
[31911.762461] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00
[31911.762472] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0xf76752c1
[31911.762474] em28xx #0: EEPROM info:
[31911.762476] em28xx #0:	No audio on board.
[31911.762478] em28xx #0:	500mA max power
[31911.762480] em28xx #0:	Table at 0x04, strings=0x226a, 0x0000, 0x0000
[31911.763177] em28xx #0: Identified as Pinnacle PCTV DVB-T (card=45)
[31911.763180] em28xx #0:
[31911.763180]
[31911.763183] em28xx #0: The support for this board weren't valid yet.
[31911.763185] em28xx #0: Please send a report of having this working
[31911.763187] em28xx #0: not to V4L mailing list (and/or to other addresses)
[31911.763188]
[31911.763191] em28xx #0: v4l2 driver version 0.1.2
[31911.768115] em28xx #0: V4L2 video device registered as /dev/video1
[31911.768173] usbcore: registered new interface driver em28xx
[31911.768179] em28xx driver loaded

Seems ok but no "/dev/dvb" device shows up. I tried to also load
"em28xx-dvb" which says (dmesg):

[32027.166662] Em28xx: Initialized (Em28xx dvb Extension) extension

Still no /dev/dvb directory.

Could somebody help me?

Best regards!

/Mark

