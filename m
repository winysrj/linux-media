Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:56294 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812AbZELRqI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2009 13:46:08 -0400
Received: by fxm2 with SMTP id 2so124547fxm.37
        for <linux-media@vger.kernel.org>; Tue, 12 May 2009 10:46:08 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 12 May 2009 19:46:07 +0200
Message-ID: <adc8a4750905121046q447d757bje42bfa2aa18725b0@mail.gmail.com>
Subject: Not only TV LV5H hybrid tv card
From: Martin Kragelund <martin.kragelund@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
I have just bought the Not only TV (LV5H) tv-card which should be
equipped with the em28xx chip - I'm trying to get it to work in ubuntu
(8.10) but it doesn't  work completely. I've attached the output from
dmesg below. I'm a bit new to linux and don't know how to use the
insmod command as suggested in the dmesg output

Best Regards,
Martin

[ 2829.852110] usb 5-7: new high speed USB device using ehci_hcd and address 4
[ 2829.990101] usb 5-7: configuration #1 chosen from 1 choice
[ 2829.990585] em28xx: New device USB 2883 Device @ 480 Mbps
(eb1a:2883, interface 0, class 0)
[ 2829.990601] em28xx #0: Identified as Unknown EM2750/28xx video
grabber (card=1)
[ 2829.990709] em28xx #0: chip ID is em2882/em2883
[ 2830.082328] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 83 28 d0 12
65 03 6a 22 8c 10
[ 2830.082350] em28xx #0: i2c eeprom 10: 00 00 24 57 4e 37 41 00 60 00
00 00 02 00 00 00
[ 2830.082363] em28xx #0: i2c eeprom 20: 5e 00 01 00 f0 10 01 00 b8 00
00 00 5b 1e 00 00
[ 2830.082379] em28xx #0: i2c eeprom 30: 00 00 20 40 20 6e 04 20 10 01
03 00 00 00 00 00
[ 2830.082395] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00
00 00 d3 c4 00 00
[ 2830.082409] em28xx #0: i2c eeprom 50: 00 a2 b2 87 81 80 00 00 00 00
00 00 00 00 00 00
[ 2830.082427] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00
22 03 55 00 53 00
[ 2830.082442] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 38 00
33 00 20 00 44 00
[ 2830.082456] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00
00 00 10 03 32 00
[ 2830.082471] em28xx #0: i2c eeprom 90: 30 00 30 00 37 00 31 00 30 00
00 00 00 00 00 00
[ 2830.082486] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 2830.082501] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 2830.082515] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 2830.082532] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 2830.082547] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 2830.082563] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 2830.082580] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x516cc51d
[ 2830.082583] em28xx #0: EEPROM info:
[ 2830.082587] em28xx #0:    AC97 audio (5 sample rates)
[ 2830.082589] em28xx #0:    500mA max power
[ 2830.082592] em28xx #0:    Table at 0x24, strings=0x226a, 0x108c, 0x0000
[ 2830.115222] em28xx #0: found i2c device @ 0xa0 [eeprom]
[ 2830.119718] em28xx #0: found i2c device @ 0xb8 [tvp5150a]
[ 2830.121606] em28xx #0: found i2c device @ 0xc2 [tuner (analog)]
[ 2830.132857] em28xx #0: Your board has no unique USB ID and thus
need a hint to be detected.
[ 2830.132868] em28xx #0: You may try to use card=<n> insmod option to
workaround that.
[ 2830.132873] em28xx #0: Please send an email with this log to:
[ 2830.132878] em28xx #0:     V4L Mailing List <linux-media@vger.kernel.org>
[ 2830.132884] em28xx #0: Board eeprom hash is 0x516cc51d
[ 2830.132888] em28xx #0: Board i2c devicelist hash is 0x27e10080
[ 2830.132895] em28xx #0: Here is a list of valid choices for the
card=<n> insmod option:
[ 2830.132901] em28xx #0:     card=0 -> Unknown EM2800 video grabber
[ 2830.132907] em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
[ 2830.132913] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
[ 2830.132931] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
[ 2830.132934] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
[ 2830.132937] em28xx #0:     card=5 -> MSI VOX USB 2.0
[ 2830.132944] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
[ 2830.132947] em28xx #0:     card=7 -> Leadtek Winfast USB II
[ 2830.132950] em28xx #0:     card=8 -> Kworld USB2800
[ 2830.132956] em28xx #0:     card=9 -> Pinnacle Dazzle DVC
90/100/101/107 / Kaiser Baas Video to DVD maker
[ 2830.132960] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
[ 2830.132964] em28xx #0:     card=11 -> Terratec Hybrid XS
[ 2830.132967] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
[ 2830.132970] em28xx #0:     card=13 -> Terratec Prodigy XS
[ 2830.132980] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview
Prolink PlayTV USB 2.0
[ 2830.132984] em28xx #0:     card=15 -> V-Gear PocketTV
[ 2830.132987] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
[ 2830.132990] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[ 2830.132998] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[ 2830.133001] em28xx #0:     card=19 -> PointNix Intra-Oral Camera
[ 2830.133004] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
[ 2830.133008] em28xx #0:     card=21 -> eMPIA Technology, Inc.
GrabBeeX+ Video Encoder
[ 2830.133011] em28xx #0:     card=22 -> Unknown EM2750/EM2751 webcam grabber
[ 2830.133015] em28xx #0:     card=23 -> Huaqi DLCW-130
[ 2830.133017] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
[ 2830.133020] em28xx #0:     card=25 -> Gadmei UTV310
[ 2830.133027] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
[ 2830.133030] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips FM1216ME)
[ 2830.133033] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
[ 2830.133041] em28xx #0:     card=29 -> <NULL>
[ 2830.133044] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
[ 2830.133047] em28xx #0:     card=31 -> Usbgear VD204v9
[ 2830.133053] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
[ 2830.133056] em28xx #0:     card=33 -> <NULL>
[ 2830.133059] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
[ 2830.133066] em28xx #0:     card=35 -> Typhoon DVD Maker
[ 2830.133069] em28xx #0:     card=36 -> NetGMBH Cam
[ 2830.133072] em28xx #0:     card=37 -> Gadmei UTV330
[ 2830.133078] em28xx #0:     card=38 -> Yakumo MovieMixer
[ 2830.133081] em28xx #0:     card=39 -> KWorld PVRTV 300U
[ 2830.133084] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
[ 2830.133091] em28xx #0:     card=41 -> Kworld 350 U DVB-T
[ 2830.133094] em28xx #0:     card=42 -> Kworld 355 U DVB-T
[ 2830.133097] em28xx #0:     card=43 -> Terratec Cinergy T XS
[ 2830.133104] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[ 2830.133107] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
[ 2830.133110] em28xx #0:     card=46 -> Compro, VideoMate U3
[ 2830.133117] em28xx #0:     card=47 -> KWorld DVB-T 305U
[ 2830.133120] em28xx #0:     card=48 -> KWorld DVB-T 310U
[ 2830.133123] em28xx #0:     card=49 -> MSI DigiVox A/D
[ 2830.133130] em28xx #0:     card=50 -> MSI DigiVox A/D II
[ 2830.133133] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
[ 2830.133136] em28xx #0:     card=52 -> DNT DA2 Hybrid
[ 2830.133142] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
[ 2830.133145] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
[ 2830.133148] em28xx #0:     card=55 -> Terratec Hybrid XS (em2882)
[ 2830.133155] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (2)
[ 2830.133158] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[ 2830.133161] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
[ 2830.133168] em28xx #0:     card=59 -> <NULL>
[ 2830.133171] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
[ 2830.133174] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[ 2830.133181] em28xx #0:     card=62 -> Gadmei TVR200
[ 2830.133184] em28xx #0:     card=63 -> Kaiomy TVnPC U2
[ 2830.133187] em28xx #0:     card=64 -> Easy Cap Capture DC-60
[ 2830.133194] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
[ 2830.133197] em28xx #0:     card=66 -> Empire dual TV
[ 2830.133331] em28xx #0: Config register raw data: 0xd0
[ 2830.134075] em28xx #0: AC97 vendor ID = 0xfae0fae0
[ 2830.134451] em28xx #0: AC97 features = 0xfae0
[ 2830.134453] em28xx #0: Unknown AC97 audio processor detected!
[ 2830.167828] em28xx #0: v4l2 driver version 0.1.2
[ 2830.203932] em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
[ 2830.203941] em28xx-audio.c: probing for em28x1 non standard usbaudio
[ 2830.203944] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger


--
Martin Kragelund, M.Sc.E.E., Ph.D. Student
Aalborg University Denmark
Department of Electronic Systems, Automation and Control
Fredrik Bajers Vej 7C, 9220 Aalborg Ø, Denmark, Room C4-207
Office: +45 99408746, Mobile: +45 40856086, Fax: +45 98151739



--
Martin Kragelund, M.Sc.E.E., Ph.D. Student
Aalborg University Denmark
Department of Electronic Systems, Automation and Control
Fredrik Bajers Vej 7C, 9220 Aalborg Ø, Denmark, Room C4-207
Office: +45 99408746, Mobile: +45 40856086, Fax: +45 98151739
