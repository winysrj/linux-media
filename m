Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51916 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab0FWTP5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jun 2010 15:15:57 -0400
Received: by wyi11 with SMTP id 11so1086170wyi.19
        for <linux-media@vger.kernel.org>; Wed, 23 Jun 2010 12:15:55 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 23 Jun 2010 21:15:54 +0200
Message-ID: <AANLkTin-NHIX-HKPnC21H5p7fHYrjzwEZFBJLjfgeJ5p@mail.gmail.com>
Subject: Please send an email with this log to: V4L Mailing List
	<linux-media@vger.kernel.org>
From: "Alessandro S." <allxsan@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

( this with UBUNTU 10.04 AMD64, maybe some firmware problem on 64 bit
architecture ? )

This is the product :

http://www.magnex.it/magnex/prodotti/video_processing/index.htm




[   14.037770] w83627ehf: Found W83627DHG-P chip at 0x290
[   14.097263] Linux video capture interface: v2.00
[   14.157699] em28xx: New device USB 2881 Video @ 480 Mbps
(eb1a:2881, interface 0, class 0)
[   14.157874] em28xx #0: chip ID is em2882/em2883
[   14.196847] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 18
[   14.196851]   alloc irq_desc for 18 on node 0
[   14.196853]   alloc kstat_irqs on node 0
[   14.196860] rt61pci 0000:01:08.0: PCI INT A -> Link[LNKA] -> GSI 18
(level, low) -> IRQ 18
[   14.206641] phy0: Selected rate control algorithm 'minstrel'
[   14.207037] Registered led device: rt61pci-phy0::radio
[   14.207050] Registered led device: rt61pci-phy0::assoc
[   14.237128] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 81 28 58 12
5c 00 6a 20 6a 00
[   14.237134] em28xx #0: i2c eeprom 10: 00 00 04 57 64 56 00 00 60 f4
00 00 02 02 00 00
[   14.237138] em28xx #0: i2c eeprom 20: 56 00 01 00 00 00 01 00 b8 00
00 00 5b 1e 00 00
[   14.237142] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 10 02
00 00 00 00 00 00
[   14.237146] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   14.237150] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   14.237154] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00
20 03 55 00 53 00
[   14.237158] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 38 00
31 00 20 00 56 00
[   14.237162] em28xx #0: i2c eeprom 80: 69 00 64 00 65 00 6f 00 00 00
00 00 00 00 00 00
[   14.237166] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   14.237170] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   14.237174] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   14.237177] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   14.237181] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   14.237185] em28xx #0: i2c eeprom e0: 5a 00 55 aa 87 ed 53 03 00 17
08 01 00 00 00 00
[   14.237189] em28xx #0: i2c eeprom f0: 07 00 00 01 00 00 00 00 00 00
00 00 00 00 00 00
[   14.237194] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x4e17ff20
[   14.237195] em28xx #0: EEPROM info:
[   14.237196] em28xx #0:	AC97 audio (5 sample rates)
[   14.237196] em28xx #0:	USB Remote wakeup capable
[   14.237197] em28xx #0:	500mA max power
[   14.237199] em28xx #0:	Table at 0x04, strings=0x206a, 0x006a, 0x0000
[   14.238503] em28xx #0: Identified as Unknown EM2750/28xx video
grabber (card=1)
[   14.270503] em28xx #0: found i2c device @ 0xa0 [eeprom]
[   14.275127] em28xx #0: found i2c device @ 0xb8 [tvp5150a]
[   14.277003] em28xx #0: found i2c device @ 0xc2 [tuner (analog)]
[   14.288252] em28xx #0: Your board has no unique USB ID and thus
need a hint to be detected.
[   14.288256] em28xx #0: You may try to use card=<n> insmod option to
workaround that.
[   14.288257] em28xx #0: Please send an email with this log to:
[   14.288258] em28xx #0: 	V4L Mailing List <linux-media@vger.kernel.org>
[   14.288259] em28xx #0: Board eeprom hash is 0x4e17ff20
[   14.288260] em28xx #0: Board i2c devicelist hash is 0x27e10080
[   14.288261] em28xx #0: Here is a list of valid choices for the
card=<n> insmod option:
[   14.288263] em28xx #0:     card=0 -> Unknown EM2800 video grabber
[   14.288264] em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
[   14.288265] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
[   14.288266] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
[   14.288267] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
[   14.288268] em28xx #0:     card=5 -> MSI VOX USB 2.0
[   14.288269] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
[   14.288270] em28xx #0:     card=7 -> Leadtek Winfast USB II
[   14.288271] em28xx #0:     card=8 -> Kworld USB2800
[   14.288273] em28xx #0:     card=9 -> Pinnacle Dazzle DVC
90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2
[   14.288274] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
[   14.288275] em28xx #0:     card=11 -> Terratec Hybrid XS
[   14.288276] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
[   14.288277] em28xx #0:     card=13 -> Terratec Prodigy XS
[   14.288278] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview
Prolink PlayTV USB 2.0
[   14.288279] em28xx #0:     card=15 -> V-Gear PocketTV
[   14.288280] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
[   14.288281] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[   14.288283] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[   14.288284] em28xx #0:     card=19 -> EM2860/SAA711X Reference Design
[   14.288285] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
[   14.288286] em28xx #0:     card=21 -> eMPIA Technology, Inc.
GrabBeeX+ Video Encoder
[   14.288287] em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam grabber
[   14.288288] em28xx #0:     card=23 -> Huaqi DLCW-130
[   14.288289] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
[   14.288290] em28xx #0:     card=25 -> Gadmei UTV310
[   14.288291] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
[   14.288292] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips FM1216ME)
[   14.288293] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
[   14.288294] em28xx #0:     card=29 -> <NULL>
[   14.288295] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
[   14.288296] em28xx #0:     card=31 -> Usbgear VD204v9
[   14.288297] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
[   14.288298] em28xx #0:     card=33 -> <NULL>
[   14.288299] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
[   14.288300] em28xx #0:     card=35 -> Typhoon DVD Maker
[   14.288301] em28xx #0:     card=36 -> NetGMBH Cam
[   14.288302] em28xx #0:     card=37 -> Gadmei UTV330
[   14.288303] em28xx #0:     card=38 -> Yakumo MovieMixer
[   14.288304] em28xx #0:     card=39 -> KWorld PVRTV 300U
[   14.288305] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
[   14.288306] em28xx #0:     card=41 -> Kworld 350 U DVB-T
[   14.288307] em28xx #0:     card=42 -> Kworld 355 U DVB-T
[   14.288308] em28xx #0:     card=43 -> Terratec Cinergy T XS
[   14.288309] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[   14.288310] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
[   14.288311] em28xx #0:     card=46 -> Compro, VideoMate U3
[   14.288312] em28xx #0:     card=47 -> KWorld DVB-T 305U
[   14.288313] em28xx #0:     card=48 -> KWorld DVB-T 310U
[   14.288314] em28xx #0:     card=49 -> MSI DigiVox A/D
[   14.288315] em28xx #0:     card=50 -> MSI DigiVox A/D II
[   14.288316] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
[   14.288317] em28xx #0:     card=52 -> DNT DA2 Hybrid
[   14.288318] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
[   14.288319] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
[   14.288320] em28xx #0:     card=55 -> Terratec Hybrid XS (em2882)
[   14.288321] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (2)
[   14.288322] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[   14.288324] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
[   14.288325] em28xx #0:     card=59 -> <NULL>
[   14.288326] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
[   14.288327] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[   14.288328] em28xx #0:     card=62 -> Gadmei TVR200
[   14.288329] em28xx #0:     card=63 -> Kaiomy TVnPC U2
[   14.288330] em28xx #0:     card=64 -> Easy Cap Capture DC-60
[   14.288331] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
[   14.288332] em28xx #0:     card=66 -> Empire dual TV
[   14.288333] em28xx #0:     card=67 -> Terratec Grabby
[   14.288333] em28xx #0:     card=68 -> Terratec AV350
[   14.288335] em28xx #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[   14.288336] em28xx #0:     card=70 -> Evga inDtube
[   14.288337] em28xx #0:     card=71 -> Silvercrest Webcam 1.3mpix
[   14.288338] em28xx #0:     card=72 -> Gadmei UTV330+
[   14.288339] em28xx #0:     card=73 -> Reddo DVB-C USB TV Box
[   14.288502] em28xx #0: Config register raw data: 0x58
[   14.289252] em28xx #0: AC97 vendor ID = 0x2c282c28
[   14.289616] em28xx #0: AC97 features = 0x2c28
[   14.289618] em28xx #0: Unknown AC97 audio processor detected!
[   14.344254] em28xx #0: v4l2 driver version 0.1.2
[   14.374669] input: ImExPS/2 Generic Explorer Mouse as
/devices/platform/i8042/serio1/input/input5
[   14.387664] em28xx #0: V4L2 video device registered as /dev/video0
[   14.387667] em28xx #0: V4L2 VBI device registered as /dev/vbi0
[   14.387680] em28xx audio device (eb1a:2881): interface 1, class 1
[   14.387687] em28xx audio device (eb1a:2881): interface 2, class 1
[   14.387706] usbcore: registered new interface driver em28xx
[   14.387708] em28xx driver loaded
[   14.615648] ALSA pcm.c:174: 2:2:1: endpoint lacks sample rate
attribute bit, cannot set.
[   14.615770] ALSA pcm.c:174: 2:2:2: endpoint lacks sample rate
attribute bit, cannot set.
[   14.615894] ALSA pcm.c:174: 2:2:3: endpoint lacks sample rate
attribute bit, cannot set.
[   14.616019] ALSA pcm.c:174: 2:2:4: endpoint lacks sample rate
attribute bit, cannot set.
[   14.616143] ALSA pcm.c:174: 2:2:5: endpoint lacks sample rate
attribute bit, cannot set.
[   14.619753] usbcore: registered new interface driver snd-us

--------------------------------------------------------------------------------

this is the

dmesg | tail -n 30

after removing/reniserting the stick

desktop:~$ dmesg | tail -n 30
[ 8126.220204] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
[ 8126.220208] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[ 8126.220212] em28xx #0:     card=62 -> Gadmei TVR200
[ 8126.220216] em28xx #0:     card=63 -> Kaiomy TVnPC U2
[ 8126.220220] em28xx #0:     card=64 -> Easy Cap Capture DC-60
[ 8126.220223] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
[ 8126.220227] em28xx #0:     card=66 -> Empire dual TV
[ 8126.220231] em28xx #0:     card=67 -> Terratec Grabby
[ 8126.220234] em28xx #0:     card=68 -> Terratec AV350
[ 8126.220238] em28xx #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[ 8126.220242] em28xx #0:     card=70 -> Evga inDtube
[ 8126.220246] em28xx #0:     card=71 -> Silvercrest Webcam 1.3mpix
[ 8126.220250] em28xx #0:     card=72 -> Gadmei UTV330+
[ 8126.220254] em28xx #0:     card=73 -> Reddo DVB-C USB TV Box
[ 8126.220391] em28xx #0: Config register raw data: 0x58
[ 8126.224299] em28xx #0: AC97 vendor ID = 0x2c282c28
[ 8126.224679] em28xx #0: AC97 features = 0x2c28
[ 8126.224681] em28xx #0: Unknown AC97 audio processor detected!
[ 8126.264926] em28xx #0: v4l2 driver version 0.1.2
[ 8126.307515] em28xx #0: V4L2 video device registered as /dev/video0
[ 8126.307518] em28xx #0: V4L2 VBI device registered as /dev/vbi0
[ 8126.307558] em28xx audio device (eb1a:2881): interface 1, class 1
[ 8126.310546] ALSA pcm.c:174: 10:2:1: endpoint lacks sample rate
attribute bit, cannot set.
[ 8126.310657] ALSA pcm.c:174: 10:2:2: endpoint lacks sample rate
attribute bit, cannot set.
[ 8126.310805] ALSA pcm.c:174: 10:2:3: endpoint lacks sample rate
attribute bit, cannot set.
[ 8126.310909] ALSA pcm.c:174: 10:2:4: endpoint lacks sample rate
attribute bit, cannot set.
[ 8126.311059] ALSA pcm.c:174: 10:2:5: endpoint lacks sample rate
attribute bit, cannot set.
[ 8126.445708] ALSA pcm.c:174: 10:2:2: endpoint lacks sample rate
attribute bit, cannot set.
[ 8126.446444] ALSA pcm.c:174: 10:2:2: endpoint lacks sample rate
attribute bit, cannot set.
[ 8126.449062] ALSA pcm.c:174: 10:2:2: endpoint lacks sample rate
attribute bit, cannot set.
