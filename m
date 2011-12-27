Return-path: <linux-media-owner@vger.kernel.org>
Received: from metalhawk.actrix.co.nz ([203.96.16.180]:38725 "EHLO
	metalhawk.actrix.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab1L0IkC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Dec 2011 03:40:02 -0500
Received: from [192.168.1.173] (202-154-148-100.ubs-dynamic.connections.net.nz [202.154.148.100])
	by metalhawk.actrix.co.nz (Postfix) with ESMTP id 593D79F382
	for <linux-media@vger.kernel.org>; Tue, 27 Dec 2011 21:32:08 +1300 (NZDT)
Message-ID: <4EF98287.4060700@actrix.co.nz>
Date: Tue, 27 Dec 2011 21:32:07 +1300
From: barry malcolm <barrym@actrix.co.nz>
MIME-Version: 1.0
To: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Hauppauge WinTV-HVR900 hybrid TV usb stick
Content-Type: multipart/mixed;
 boundary="------------020002040900090100040508"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020002040900090100040508
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

LinuxMint 12 64bit, Kernel 3.0.0-12, does not load this USB stick
  -- part of dmesg output is attached.

When I used kernel 3.0.0-0300 with Ubuntu 11.04 the Micronas DRXD DVB-T 
tuner in this stick was identified and firmware loaded.
I've tried manually placing the 3 bits of firmware in /lib/firmware 
(xc3028-v27.fw, drxd-a2-1.1.fw, drxd-b1-1.1.fw) but with no success.
I've also tried creating a file HVR900.conf in /etc/modprobe.d/ 
containing the line
options EM28xx card=18   (or  card=10) again with no effect.

Regards
Barry

PS My hardware setup is:
Gigabyte GA-Z68MA-D2H-B3 mobo with Intel i5 2500K, 8GB Kingston HyperX 
in Antec 3480 case.

--------------020002040900090100040508
Content-Type: text/plain;
 name="dmesg_output.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg_output.txt"

[    2.635401] usb 2-1.2: new high speed USB device number 3 using ehci_hcd
[    3.002191] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[   12.885895] udevd[394]: starting version 173
[   12.994588] Adding 6072532k swap on /dev/sda5.  Priority:-1 extents:1 across:6072532k 
[   13.382574] Linux video capture interface: v2.00
[   13.407005] em28xx: New device @ 480 Mbps (eb1a:2883, interface 0, class 0)
[   13.407113] em28xx #0: chip ID is em2882/em2883
[   13.430318] wmi: Mapper loaded
[   13.453036] mei: module is from the staging directory, the quality is unknown, you have been warned.
[   13.453346] mei 0000:00:16.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   13.453350] mei 0000:00:16.0: setting latency timer to 64
[   13.487138] em28xx #0: i2c eeprom 00: 05 eb 67 95 40 20 02 65 d0 12 5c 03 82 1e 6a 18
[   13.487151] em28xx #0: i2c eeprom 10: 00 00 24 57 66 07 01 00 00 00 00 00 00 00 00 00
[   13.487161] em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 02 00 b8 00 00 00 5b e0 00 00
[   13.487171] em28xx #0: i2c eeprom 30: 00 00 20 40 20 6e 02 20 10 01 01 01 00 00 00 00
[   13.487181] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   13.487191] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   13.487200] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 18 03 34 00 30 00
[   13.487210] em28xx #0: i2c eeprom 70: 32 00 38 00 34 00 39 00 37 00 36 00 30 00 31 00
[   13.487220] em28xx #0: i2c eeprom 80: 00 00 1e 03 57 00 69 00 6e 00 54 00 56 00 20 00
[   13.487239] em28xx #0: i2c eeprom 90: 48 00 56 00 52 00 2d 00 39 00 30 00 30 00 00 00
[   13.487243] em28xx #0: i2c eeprom a0: 84 12 00 00 05 50 1a 7f d4 78 23 fa fd d0 28 89
[   13.487248] em28xx #0: i2c eeprom b0: ff 00 00 00 04 84 0a 00 01 01 20 77 00 40 c1 fe
[   13.487252] em28xx #0: i2c eeprom c0: 1d f0 74 02 01 00 01 79 6e 00 00 00 00 00 00 00
[   13.487256] em28xx #0: i2c eeprom d0: 84 12 00 00 05 50 1a 7f d4 78 23 fa fd d0 28 89
[   13.487261] em28xx #0: i2c eeprom e0: ff 00 00 00 04 84 0a 00 01 01 20 77 00 40 c1 fe
[   13.487266] em28xx #0: i2c eeprom f0: 1d f0 74 02 01 00 01 79 6e 00 00 00 00 00 00 00
[   13.487270] em28xx #0: EEPROM ID= 0x9567eb05, EEPROM hash = 0x00000000
[   13.487271] em28xx #0: EEPROM info:
[   13.487272] em28xx #0:	AC97 audio (5 sample rates)
[   13.487273] em28xx #0:	500mA max power
[   13.487274] em28xx #0:	Table at 0x24, strings=0x1e82, 0x186a, 0x0000
[   13.519347] em28xx #0: found i2c device @ 0xa0 [eeprom]
[   13.525713] em28xx #0: found i2c device @ 0xc2 [tuner (analog)]
[   13.535765] IR NEC protocol handler initialized
[   13.535860] lp: driver loaded but no devices found
[   13.537195] em28xx #0: Your board has no unique USB ID and thus need a hint to be detected.
[   13.537200] em28xx #0: You may try to use card=<n> insmod option to workaround that.
[   13.537202] em28xx #0: Please send an email with this log to:
[   13.537204] em28xx #0: 	V4L Mailing List <linux-media@vger.kernel.org>
[   13.537206] em28xx #0: Board eeprom hash is 0x00000000
[   13.537208] em28xx #0: Board i2c devicelist hash is 0x6be10080
[   13.537209] em28xx #0: Here is a list of valid choices for the card=<n> insmod option:
[   13.537212] em28xx #0:     card=0 -> Unknown EM2800 video grabber
[   13.537214] em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
[   13.537216] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
[   13.537218] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
[   13.537220] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
[   13.537222] em28xx #0:     card=5 -> MSI VOX USB 2.0
[   13.537224] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
[   13.537225] em28xx #0:     card=7 -> Leadtek Winfast USB II
[   13.537227] em28xx #0:     card=8 -> Kworld USB2800
[   13.537229] em28xx #0:     card=9 -> Pinnacle Dazzle DVC 90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2
[   13.537232] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
[   13.537234] em28xx #0:     card=11 -> Terratec Hybrid XS
[   13.537236] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
[   13.537238] em28xx #0:     card=13 -> Terratec Prodigy XS
[   13.537240] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview Prolink PlayTV USB 2.0
[   13.537243] em28xx #0:     card=15 -> V-Gear PocketTV
[   13.537245] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
[   13.537247] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[   13.537249] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[   13.537251] em28xx #0:     card=19 -> EM2860/SAA711X Reference Design
[   13.537253] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
[   13.537255] em28xx #0:     card=21 -> eMPIA Technology, Inc. GrabBeeX+ Video Encoder
[   13.537258] em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam grabber
[   13.537260] em28xx #0:     card=23 -> Huaqi DLCW-130
[   13.537262] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
[   13.537264] em28xx #0:     card=25 -> Gadmei UTV310
[   13.537266] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
[   13.537268] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips FM1216ME)
[   13.537270] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
[   13.537272] em28xx #0:     card=29 -> EM2860/TVP5150 Reference Design
[   13.537275] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
[   13.537277] em28xx #0:     card=31 -> Usbgear VD204v9
[   13.537279] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
[   13.537281] em28xx #0:     card=33 -> Elgato Video Capture
[   13.537283] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
[   13.537285] em28xx #0:     card=35 -> Typhoon DVD Maker
[   13.537287] em28xx #0:     card=36 -> NetGMBH Cam
[   13.537289] em28xx #0:     card=37 -> Gadmei UTV330
[   13.537290] em28xx #0:     card=38 -> Yakumo MovieMixer
[   13.537292] em28xx #0:     card=39 -> KWorld PVRTV 300U
[   13.537294] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
[   13.537296] em28xx #0:     card=41 -> Kworld 350 U DVB-T
[   13.537298] em28xx #0:     card=42 -> Kworld 355 U DVB-T
[   13.537300] em28xx #0:     card=43 -> Terratec Cinergy T XS
[   13.537302] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[   13.537304] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
[   13.537306] em28xx #0:     card=46 -> Compro, VideoMate U3
[   13.537308] em28xx #0:     card=47 -> KWorld DVB-T 305U
[   13.537310] em28xx #0:     card=48 -> KWorld DVB-T 310U
[   13.537312] em28xx #0:     card=49 -> MSI DigiVox A/D
[   13.537314] em28xx #0:     card=50 -> MSI DigiVox A/D II
[   13.537316] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
[   13.537318] em28xx #0:     card=52 -> DNT DA2 Hybrid
[   13.537320] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
[   13.537322] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
[   13.537324] em28xx #0:     card=55 -> Terratec Cinnergy Hybrid T USB XS (em2882)
[   13.537326] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (330e)
[   13.537328] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[   13.537331] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
[   13.537333] em28xx #0:     card=59 -> (null)
[   13.537334] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
[   13.537337] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[   13.537339] em28xx #0:     card=62 -> Gadmei TVR200
[   13.537341] em28xx #0:     card=63 -> Kaiomy TVnPC U2
[   13.537342] em28xx #0:     card=64 -> Easy Cap Capture DC-60
[   13.537344] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
[   13.537346] em28xx #0:     card=66 -> Empire dual TV
[   13.537348] em28xx #0:     card=67 -> Terratec Grabby
[   13.537350] em28xx #0:     card=68 -> Terratec AV350
[   13.537352] em28xx #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[   13.537354] em28xx #0:     card=70 -> Evga inDtube
[   13.537356] em28xx #0:     card=71 -> Silvercrest Webcam 1.3mpix
[   13.537358] em28xx #0:     card=72 -> Gadmei UTV330+
[   13.537360] em28xx #0:     card=73 -> Reddo DVB-C USB TV Box
[   13.537362] em28xx #0:     card=74 -> Actionmaster/LinXcel/Digitus VC211A
[   13.537364] em28xx #0:     card=75 -> Dikom DK300
[   13.537366] em28xx #0:     card=76 -> KWorld PlusTV 340U or UB435-Q (ATSC)
[   13.537368] em28xx #0:     card=77 -> EM2874 Leadership ISDBT
[   13.537370] em28xx #0:     card=78 -> PCTV Systems nanoStick T2 290e
[   13.537372] em28xx #0: Board not discovered
[   13.537374] em28xx #0: Identified as Unknown EM2750/28xx video grabber (card=1)
[   13.537376] em28xx #0: Your board has no unique USB ID and thus need a hint to be detected.
[   13.537378] em28xx #0: You may try to use card=<n> insmod option to workaround that.
[   13.537381] em28xx #0: Please send an email with this log to:
[   13.537383] em28xx #0: 	V4L Mailing List <linux-media@vger.kernel.org>
[   13.537385] em28xx #0: Board eeprom hash is 0x00000000
[   13.537387] em28xx #0: Board i2c devicelist hash is 0x6be10080
[   13.537388] em28xx #0: Here is a list of valid choices for the card=<n> insmod option:
[   13.537391] em28xx #0:     card=0 -> Unknown EM2800 video grabber
[   13.537393] em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
[   13.537395] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
[   13.537397] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
[   13.537399] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
[   13.537401] em28xx #0:     card=5 -> MSI VOX USB 2.0
[   13.537403] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
[   13.537405] em28xx #0:     card=7 -> Leadtek Winfast USB II
[   13.537407] em28xx #0:     card=8 -> Kworld USB2800
[   13.537409] em28xx #0:     card=9 -> Pinnacle Dazzle DVC 90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2
[   13.537412] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
[   13.537415] em28xx #0:     card=11 -> Terratec Hybrid XS
[   13.537416] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
[   13.537418] em28xx #0:     card=13 -> Terratec Prodigy XS
[   13.537420] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview Prolink PlayTV USB 2.0
[   13.537423] em28xx #0:     card=15 -> V-Gear PocketTV
[   13.537425] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
[   13.537427] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[   13.537429] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[   13.537431] em28xx #0:     card=19 -> EM2860/SAA711X Reference Design
[   13.537433] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
[   13.537435] em28xx #0:     card=21 -> eMPIA Technology, Inc. GrabBeeX+ Video Encoder
[   13.537438] em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam grabber
[   13.537440] em28xx #0:     card=23 -> Huaqi DLCW-130
[   13.537442] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
[   13.537444] em28xx #0:     card=25 -> Gadmei UTV310
[   13.537446] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
[   13.537448] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips FM1216ME)
[   13.537450] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
[   13.537452] em28xx #0:     card=29 -> EM2860/TVP5150 Reference Design
[   13.537454] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
[   13.537457] em28xx #0:     card=31 -> Usbgear VD204v9
[   13.537458] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
[   13.537460] em28xx #0:     card=33 -> Elgato Video Capture
[   13.537462] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
[   13.537464] em28xx #0:     card=35 -> Typhoon DVD Maker
[   13.537466] em28xx #0:     card=36 -> NetGMBH Cam
[   13.537468] em28xx #0:     card=37 -> Gadmei UTV330
[   13.537470] em28xx #0:     card=38 -> Yakumo MovieMixer
[   13.537472] em28xx #0:     card=39 -> KWorld PVRTV 300U
[   13.537474] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
[   13.537476] em28xx #0:     card=41 -> Kworld 350 U DVB-T
[   13.537478] em28xx #0:     card=42 -> Kworld 355 U DVB-T
[   13.537480] em28xx #0:     card=43 -> Terratec Cinergy T XS
[   13.537482] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[   13.537484] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
[   13.537486] em28xx #0:     card=46 -> Compro, VideoMate U3
[   13.537488] em28xx #0:     card=47 -> KWorld DVB-T 305U
[   13.537489] em28xx #0:     card=48 -> KWorld DVB-T 310U
[   13.537491] em28xx #0:     card=49 -> MSI DigiVox A/D
[   13.537493] em28xx #0:     card=50 -> MSI DigiVox A/D II
[   13.537495] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
[   13.537497] em28xx #0:     card=52 -> DNT DA2 Hybrid
[   13.537499] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
[   13.537501] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
[   13.537503] em28xx #0:     card=55 -> Terratec Cinnergy Hybrid T USB XS (em2882)
[   13.537506] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (330e)
[   13.537508] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[   13.537510] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
[   13.537512] em28xx #0:     card=59 -> (null)
[   13.537513] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
[   13.537515] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[   13.537518] em28xx #0:     card=62 -> Gadmei TVR200
[   13.537520] em28xx #0:     card=63 -> Kaiomy TVnPC U2
[   13.537521] em28xx #0:     card=64 -> Easy Cap Capture DC-60
[   13.537523] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
[   13.537525] em28xx #0:     card=66 -> Empire dual TV
[   13.537527] em28xx #0:     card=67 -> Terratec Grabby
[   13.537529] em28xx #0:     card=68 -> Terratec AV350
[   13.537531] em28xx #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[   13.537533] em28xx #0:     card=70 -> Evga inDtube
[   13.537535] em28xx #0:     card=71 -> Silvercrest Webcam 1.3mpix
[   13.537537] em28xx #0:     card=72 -> Gadmei UTV330+
[   13.537539] em28xx #0:     card=73 -> Reddo DVB-C USB TV Box
[   13.537541] em28xx #0:     card=74 -> Actionmaster/LinXcel/Digitus VC211A
[   13.537543] em28xx #0:     card=75 -> Dikom DK300
[   13.537545] em28xx #0:     card=76 -> KWorld PlusTV 340U or UB435-Q (ATSC)
[   13.537547] em28xx #0:     card=77 -> EM2874 Leadership ISDBT
[   13.537549] em28xx #0:     card=78 -> PCTV Systems nanoStick T2 290e
[   13.537698] em28xx #0: Config register raw data: 0x10
[   13.538945] em28xx #0: AC97 vendor ID = 0xfee9fee9
[   13.539320] em28xx #0: AC97 features = 0xfee9
[   13.539321] em28xx #0: Unknown AC97 audio processor detected!
[   13.559288] [drm] Initialized drm 1.1.0 20060810
[   13.567383] IR RC5(x) protocol handler initialized
[   13.575276] em28xx #0: v4l2 driver version 0.1.2
[   13.591784] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   13.591787] i915 0000:00:02.0: setting latency timer to 64
[   13.605402] mtrr: type mismatch for e0000000,10000000 old: write-back new: write-combining
[   13.605403] [drm] MTRR allocation failed.  Graphics performance may suffer.
[   13.605578] i915 0000:00:02.0: irq 41 for MSI/MSI-X
[   13.605581] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   13.605582] [drm] Driver supports precise vblank timestamp query.
[   13.605605] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[   13.618808] em28xx #0: V4L2 video device registered as video0
[   13.618812] em28xx #0: V4L2 VBI device registered as vbi0
[   13.618843] usbcore: registered new interface driver em28xx
[   13.618845] em28xx driver loaded
[   13.688398] em28xx-audio.c: probing for em28x1 non standard usbaudio
[   13.688400] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
[   13.688492] IR RC6 protocol handler initialized
[   13.688496] Em28xx: Initialized (Em28xx Audio Extension) extension
[   13.757353] IR JVC protocol handler initialized
[   13.821481] IR Sony protocol handler initialized
[   13.976777] lirc_dev: IR Remote Control driver registered, major 249 
[   13.977280] IR LIRC bridge handler initialized


--------------020002040900090100040508--
