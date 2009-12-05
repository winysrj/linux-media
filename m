Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f171.google.com ([209.85.222.171]:60978 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069AbZLER7S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Dec 2009 12:59:18 -0500
Received: by pzk1 with SMTP id 1so513809pzk.33
        for <linux-media@vger.kernel.org>; Sat, 05 Dec 2009 09:59:24 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 5 Dec 2009 23:29:24 +0530
Message-ID: <e8627cb10912050959h31bae5b6gbd5615f2ee893450@mail.gmail.com>
Subject: GrabBeeX light
From: Ajit M S <ajit.ms@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I recently bought a "GrabbeeX light" video capture USB device that
seems to be based on the EM2820 chipset. But I can't get it to work.
Does anyone else have this card or  have tried to get it to work ? I'm
using Ubuntu 9.10 with Linux kernel version 2.6.31-16-generic.

Here are the kernel prints when I plugged in the device:

Dec  4 10:52:15 marvin kernel: [  294.732251] usb 2-2: new high speed
USB device using ehci_hcd and address 4
Dec  4 10:52:15 marvin kernel: [  294.870541] usb 2-2: configuration
#1 chosen from 1 choice
Dec  4 10:52:15 marvin kernel: [  294.927578] Linux video capture
interface: v2.00
Dec  4 10:52:15 marvin kernel: [  294.973120] em28xx: New device USB
2820 Device @ 480 Mbps (eb1a:2820, interface 0, class 0)
Dec  4 10:52:15 marvin kernel: [  294.973219] em28xx #0: chip ID is
em2820 (or em2710)
Dec  4 10:52:15 marvin kernel: [  295.119666] em28xx #0: i2c eeprom
00: 1a eb 67 95 1a eb 20 28 80 00 11 03 6a 22 00 00
Dec  4 10:52:15 marvin kernel: [  295.119696] em28xx #0: i2c eeprom
10: 00 00 04 57 06 21 00 00 00 00 00 00 00 00 00 00
Dec  4 10:52:15 marvin kernel: [  295.119722] em28xx #0: i2c eeprom
20: 02 00 00 01 f0 10 00 00 00 00 00 00 5b 00 00 00
Dec  4 10:52:15 marvin kernel: [  295.119748] em28xx #0: i2c eeprom
30: 00 00 20 40 20 80 02 20 10 01 03 01 00 00 00 00
Dec  4 10:52:15 marvin kernel: [  295.119774] em28xx #0: i2c eeprom
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Dec  4 10:52:15 marvin kernel: [  295.119800] em28xx #0: i2c eeprom
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Dec  4 10:52:15 marvin kernel: [  295.119825] em28xx #0: i2c eeprom
60: 00 00 00 00 00 00 00 00 00 00 22 03 55 00 53 00
Dec  4 10:52:15 marvin kernel: [  295.119850] em28xx #0: i2c eeprom
70: 42 00 20 00 32 00 38 00 32 00 30 00 20 00 44 00
Dec  4 10:52:15 marvin kernel: [  295.119876] em28xx #0: i2c eeprom
80: 65 00 76 00 69 00 63 00 65 00 00 00 00 00 00 00
Dec  4 10:52:15 marvin kernel: [  295.119901] em28xx #0: i2c eeprom
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Dec  4 10:52:15 marvin kernel: [  295.119926] em28xx #0: i2c eeprom
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Dec  4 10:52:15 marvin kernel: [  295.119952] em28xx #0: i2c eeprom
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Dec  4 10:52:15 marvin kernel: [  295.119977] em28xx #0: i2c eeprom
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Dec  4 10:52:15 marvin kernel: [  295.120023] em28xx #0: i2c eeprom
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Dec  4 10:52:15 marvin kernel: [  295.120048] em28xx #0: i2c eeprom
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Dec  4 10:52:15 marvin kernel: [  295.120073] em28xx #0: i2c eeprom
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Dec  4 10:52:15 marvin kernel: [  295.120102] em28xx #0: EEPROM ID=
0x9567eb1a, EEPROM hash = 0xd5da7b8a
Dec  4 10:52:15 marvin kernel: [  295.120107] em28xx #0: EEPROM info:
Dec  4 10:52:15 marvin kernel: [  295.120111] em28xx #0:    No audio on board.
Dec  4 10:52:15 marvin kernel: [  295.120115] em28xx #0:    500mA max power
Dec  4 10:52:15 marvin kernel: [  295.120121] em28xx #0:    Table at
0x04, strings=0x226a, 0x0000, 0x0000
Dec  4 10:52:15 marvin kernel: [  295.133525] em28xx #0: Identified as
Unknown EM2750/28xx video grabber (card=1)
Dec  4 10:52:15 marvin kernel: [  295.147762] em28xx #0: found i2c
device @ 0x4a [saa7113h]
Dec  4 10:52:15 marvin kernel: [  295.167726] em28xx #0: found i2c
device @ 0xa0 [eeprom]
Dec  4 10:52:15 marvin kernel: [  295.185978] em28xx #0: Your board
has no unique USB ID and thus need a hint to be detected.
Dec  4 10:52:15 marvin kernel: [  295.185984] em28xx #0: You may try
to use card=<n> insmod option to workaround that.
Dec  4 10:52:15 marvin kernel: [  295.185987] em28xx #0: Please send
an email with this log to:
Dec  4 10:52:15 marvin kernel: [  295.185989] em28xx #0:     V4L
Mailing List <linux-media@vger.kernel.org>
Dec  4 10:52:15 marvin kernel: [  295.185992] em28xx #0: Board eeprom
hash is 0xd5da7b8a
Dec  4 10:52:15 marvin kernel: [  295.185995] em28xx #0: Board i2c
devicelist hash is 0x6ba50080
Dec  4 10:52:15 marvin kernel: [  295.185997] em28xx #0: Here is a
list of valid choices for the card=<n> insmod option:
Dec  4 10:52:15 marvin kernel: [  295.186001] em28xx #0:     card=0 ->
Unknown EM2800 video grabber
Dec  4 10:52:15 marvin kernel: [  295.186004] em28xx #0:     card=1 ->
Unknown EM2750/28xx video grabber
Dec  4 10:52:15 marvin kernel: [  295.186007] em28xx #0:     card=2 ->
Terratec Cinergy 250 USB
Dec  4 10:52:15 marvin kernel: [  295.186009] em28xx #0:     card=3 ->
Pinnacle PCTV USB 2
Dec  4 10:52:15 marvin kernel: [  295.186012] em28xx #0:     card=4 ->
Hauppauge WinTV USB 2
Dec  4 10:52:15 marvin kernel: [  295.186015] em28xx #0:     card=5 ->
MSI VOX USB 2.0
Dec  4 10:52:15 marvin kernel: [  295.186017] em28xx #0:     card=6 ->
Terratec Cinergy 200 USB
Dec  4 10:52:15 marvin kernel: [  295.186020] em28xx #0:     card=7 ->
Leadtek Winfast USB II
Dec  4 10:52:15 marvin kernel: [  295.186023] em28xx #0:     card=8 ->
Kworld USB2800
Dec  4 10:52:15 marvin kernel: [  295.186026] em28xx #0:     card=9 ->
Pinnacle Dazzle DVC 90/100/101/107 / Kaiser Baas Video to DVD maker
Dec  4 10:52:15 marvin kernel: [  295.186029] em28xx #0:     card=10
-> Hauppauge WinTV HVR 900
Dec  4 10:52:15 marvin kernel: [  295.186032] em28xx #0:     card=11
-> Terratec Hybrid XS
Dec  4 10:52:15 marvin kernel: [  295.186035] em28xx #0:     card=12
-> Kworld PVR TV 2800 RF
Dec  4 10:52:15 marvin kernel: [  295.186037] em28xx #0:     card=13
-> Terratec Prodigy XS
Dec  4 10:52:15 marvin kernel: [  295.186040] em28xx #0:     card=14
-> SIIG AVTuner-PVR / Pixelview Prolink PlayTV USB 2.0
Dec  4 10:52:15 marvin kernel: [  295.186043] em28xx #0:     card=15
-> V-Gear PocketTV
Dec  4 10:52:15 marvin kernel: [  295.186046] em28xx #0:     card=16
-> Hauppauge WinTV HVR 950
Dec  4 10:52:15 marvin kernel: [  295.186049] em28xx #0:     card=17
-> Pinnacle PCTV HD Pro Stick
Dec  4 10:52:15 marvin kernel: [  295.186052] em28xx #0:     card=18
-> Hauppauge WinTV HVR 900 (R2)
Dec  4 10:52:15 marvin kernel: [  295.186055] em28xx #0:     card=19
-> EM2860/SAA711X Reference Design
Dec  4 10:52:15 marvin kernel: [  295.186058] em28xx #0:     card=20
-> AMD ATI TV Wonder HD 600
Dec  4 10:52:15 marvin kernel: [  295.186060] em28xx #0:     card=21
-> eMPIA Technology, Inc. GrabBeeX+ Video Encoder
Dec  4 10:52:15 marvin kernel: [  295.186064] em28xx #0:     card=22
-> EM2710/EM2750/EM2751 webcam grabber
Dec  4 10:52:15 marvin kernel: [  295.186066] em28xx #0:     card=23
-> Huaqi DLCW-130
Dec  4 10:52:15 marvin kernel: [  295.186069] em28xx #0:     card=24
-> D-Link DUB-T210 TV Tuner
Dec  4 10:52:15 marvin kernel: [  295.186072] em28xx #0:     card=25
-> Gadmei UTV310
Dec  4 10:52:15 marvin kernel: [  295.186075] em28xx #0:     card=26
-> Hercules Smart TV USB 2.0
Dec  4 10:52:15 marvin kernel: [  295.186078] em28xx #0:     card=27
-> Pinnacle PCTV USB 2 (Philips FM1216ME)
Dec  4 10:52:15 marvin kernel: [  295.186081] em28xx #0:     card=28
-> Leadtek Winfast USB II Deluxe
Dec  4 10:52:15 marvin kernel: [  295.186089] em28xx #0:     card=29 -> <NULL>
Dec  4 10:52:15 marvin kernel: [  295.186091] em28xx #0:     card=30
-> Videology 20K14XUSB USB2.0
Dec  4 10:52:15 marvin kernel: [  295.186092] em28xx #0:     card=31
-> Usbgear VD204v9
Dec  4 10:52:15 marvin kernel: [  295.186094] em28xx #0:     card=32
-> Supercomp USB 2.0 TV
Dec  4 10:52:15 marvin kernel: [  295.186096] em28xx #0:     card=33 -> <NULL>
Dec  4 10:52:15 marvin kernel: [  295.186098] em28xx #0:     card=34
-> Terratec Cinergy A Hybrid XS
Dec  4 10:52:15 marvin kernel: [  295.186100] em28xx #0:     card=35
-> Typhoon DVD Maker
Dec  4 10:52:15 marvin kernel: [  295.186102] em28xx #0:     card=36
-> NetGMBH Cam
Dec  4 10:52:15 marvin kernel: [  295.186103] em28xx #0:     card=37
-> Gadmei UTV330
Dec  4 10:52:15 marvin kernel: [  295.186105] em28xx #0:     card=38
-> Yakumo MovieMixer
Dec  4 10:52:15 marvin kernel: [  295.186107] em28xx #0:     card=39
-> KWorld PVRTV 300U
Dec  4 10:52:15 marvin kernel: [  295.186109] em28xx #0:     card=40
-> Plextor ConvertX PX-TV100U
Dec  4 10:52:15 marvin kernel: [  295.186111] em28xx #0:     card=41
-> Kworld 350 U DVB-T
Dec  4 10:52:15 marvin kernel: [  295.186113] em28xx #0:     card=42
-> Kworld 355 U DVB-T
Dec  4 10:52:15 marvin kernel: [  295.186115] em28xx #0:     card=43
-> Terratec Cinergy T XS
Dec  4 10:52:15 marvin kernel: [  295.186116] em28xx #0:     card=44
-> Terratec Cinergy T XS (MT2060)
Dec  4 10:52:15 marvin kernel: [  295.186118] em28xx #0:     card=45
-> Pinnacle PCTV DVB-T
Dec  4 10:52:15 marvin kernel: [  295.186120] em28xx #0:     card=46
-> Compro, VideoMate U3
Dec  4 10:52:15 marvin kernel: [  295.186122] em28xx #0:     card=47
-> KWorld DVB-T 305U
Dec  4 10:52:15 marvin kernel: [  295.186124] em28xx #0:     card=48
-> KWorld DVB-T 310U
Dec  4 10:52:15 marvin kernel: [  295.186126] em28xx #0:     card=49
-> MSI DigiVox A/D
Dec  4 10:52:15 marvin kernel: [  295.186128] em28xx #0:     card=50
-> MSI DigiVox A/D II
Dec  4 10:52:15 marvin kernel: [  295.186129] em28xx #0:     card=51
-> Terratec Hybrid XS Secam
Dec  4 10:52:15 marvin kernel: [  295.186131] em28xx #0:     card=52
-> DNT DA2 Hybrid
Dec  4 10:52:15 marvin kernel: [  295.186133] em28xx #0:     card=53
-> Pinnacle Hybrid Pro
Dec  4 10:52:15 marvin kernel: [  295.186135] em28xx #0:     card=54
-> Kworld VS-DVB-T 323UR
Dec  4 10:52:15 marvin kernel: [  295.186137] em28xx #0:     card=55
-> Terratec Hybrid XS (em2882)
Dec  4 10:52:15 marvin kernel: [  295.186139] em28xx #0:     card=56
-> Pinnacle Hybrid Pro (2)
Dec  4 10:52:15 marvin kernel: [  295.186141] em28xx #0:     card=57
-> Kworld PlusTV HD Hybrid 330
Dec  4 10:52:15 marvin kernel: [  295.186143] em28xx #0:     card=58
-> Compro VideoMate ForYou/Stereo
Dec  4 10:52:15 marvin kernel: [  295.186144] em28xx #0:     card=59 -> <NULL>
Dec  4 10:52:15 marvin kernel: [  295.186146] em28xx #0:     card=60
-> Hauppauge WinTV HVR 850
Dec  4 10:52:15 marvin kernel: [  295.186148] em28xx #0:     card=61
-> Pixelview PlayTV Box 4 USB 2.0
Dec  4 10:52:15 marvin kernel: [  295.186150] em28xx #0:     card=62
-> Gadmei TVR200
Dec  4 10:52:15 marvin kernel: [  295.186152] em28xx #0:     card=63
-> Kaiomy TVnPC U2
Dec  4 10:52:15 marvin kernel: [  295.186153] em28xx #0:     card=64
-> Easy Cap Capture DC-60
Dec  4 10:52:15 marvin kernel: [  295.186155] em28xx #0:     card=65
-> IO-DATA GV-MVP/SZ
Dec  4 10:52:15 marvin kernel: [  295.186157] em28xx #0:     card=66
-> Empire dual TV
Dec  4 10:52:15 marvin kernel: [  295.186159] em28xx #0:     card=67
-> Terratec Grabby
Dec  4 10:52:15 marvin kernel: [  295.186161] em28xx #0:     card=68
-> Terratec AV350
Dec  4 10:52:15 marvin kernel: [  295.186163] em28xx #0:     card=69
-> KWorld ATSC 315U HDTV TV Box
Dec  4 10:52:15 marvin kernel: [  295.186164] em28xx #0:     card=70
-> Evga inDtube
Dec  4 10:52:15 marvin kernel: [  295.186166] em28xx #0:     card=71
-> Silvercrest Webcam 1.3mpix
Dec  4 10:52:15 marvin kernel: [  295.186223] em28xx #0: Config
register raw data: 0x80
Dec  4 10:52:15 marvin kernel: [  295.186226] em28xx #0: v4l2 driver
version 0.1.2
Dec  4 10:52:15 marvin kernel: [  295.632157] em28xx #0: V4L2 device
registered as /dev/video0 and /dev/vbi0
Dec  4 10:52:15 marvin kernel: [  295.632180] usbcore: registered new
interface driver em28xx
Dec  4 10:52:15 marvin kernel: [  295.632183] em28xx driver loaded
