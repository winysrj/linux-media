Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB5GCMCt030519
	for <video4linux-list@redhat.com>; Fri, 5 Dec 2008 11:12:22 -0500
Received: from carla.brutex.net (carla.brutex.net [85.10.196.13])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB5GAHQC019669
	for <video4linux-list@redhat.com>; Fri, 5 Dec 2008 11:10:18 -0500
Received: from dslb-084-062-174-137.pools.arcor-ip.net ([84.62.174.137]
	helo=[192.168.1.240]) by carla.brutex.net with esmtpa (Exim 4.63)
	(envelope-from <brian@brutex.de>) id 1L8dFw-0001fS-Du
	for video4linux-list@redhat.com; Fri, 05 Dec 2008 17:10:16 +0100
From: Brian Rosenberger <brian@brutex.de>
To: video4linux-list@redhat.com
Content-Type: text/plain
Date: Fri, 05 Dec 2008 17:10:15 +0100
Message-Id: <1228493415.439.8.camel@bru02>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Pinnacle PCTV USB (DVB-T device [eb1a:2870])
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi,

I am trying to get my Pinnacle PCTV USB (DVB-T device [eb1a:2870]) to
work. I fetched sources from http://linuxtv.org/hg/v4l-dvb and then did
a make, make install and make load. Everything went fine as far my
understanding is (yes with reboot in between).
Next I plugged the usb stick and checked dmesg (see below). I am a bit
stuck right now, I did try some card=xx variants, but /dev/dvb isn't
created.

What are the next steps?

Thanks
Brian


lsusb:
Bus 001 Device 009: ID eb1a:2870 eMPIA Technology, Inc.

dmesg:
[ 1056.236017] usb 1-2: new high speed USB device using ehci_hcd and
address 9
[ 1056.372377] usb 1-2: configuration #1 chosen from 1 choice
[ 1056.373501] em28xx: New device USB 2870 Device @ 480 Mbps (eb1a:2870,
interface 0, class 0)
[ 1056.373508] em28xx #0: Identified as Unknown EM2750/28xx video
grabber (card=1)
[ 1056.375238] em28xx #0: em28xx chip ID = 35
[ 1056.415407] compat_ioctl32: exports duplicate symbol
v4l_compat_ioctl32 (owned by v4l2_compat_ioctl32)
[ 1056.703611] Chip ID is not zero. It is not a TEA5767
[ 1056.703669] tuner' 5-0060: chip found @ 0xc0 (em28xx #0)
[ 1056.746239] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 70 28 c0 12
81 00 6a 22 00 00
[ 1056.746246] em28xx #0: i2c eeprom 10: 00 00 04 57 02 0d 00 00 00 00
00 00 00 00 00 00
[ 1056.746252] em28xx #0: i2c eeprom 20: 44 00 00 00 f0 10 02 00 00 00
00 00 5b 00 00 00
[ 1056.746256] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01
00 00 27 e6 39 4a
[ 1056.746261] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 1056.746266] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 1056.746271] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00
22 03 55 00 53 00
[ 1056.746276] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 37 00
30 00 20 00 44 00
[ 1056.746281] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00
00 00 00 00 00 00
[ 1056.746286] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 1056.746291] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 1056.746295] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 1056.746300] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 1056.746305] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 1056.746310] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 1056.746315] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 1056.746321] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash =
0x391183c3
[ 1056.746322] em28xx #0: EEPROM info:
[ 1056.746323] em28xx #0:	No audio on board.
[ 1056.746324] em28xx #0:	500mA max power
[ 1056.746325] em28xx #0:	Table at 0x04, strings=0x226a, 0x0000, 0x0000
[ 1056.793489] em28xx #0: found i2c device @ 0xa0 [eeprom]
[ 1056.799989] em28xx #0: found i2c device @ 0xc0 [tuner (analog)]
[ 1056.810365] em28xx #0: Your board has no unique USB ID and thus need
a hint to be detected.
[ 1056.810370] em28xx #0: You may try to use card=<n> insmod option to
workaround that.
[ 1056.810371] em28xx #0: Please send an email with this log to:
[ 1056.810372] em28xx #0: 	V4L Mailing List
<video4linux-list@redhat.com>
[ 1056.810373] em28xx #0: Board eeprom hash is 0x391183c3
[ 1056.810375] em28xx #0: Board i2c devicelist hash is 0x4b800080
[ 1056.810376] em28xx #0: Here is a list of valid choices for the
card=<n> insmod option:
[ 1056.810377] em28xx #0:     card=0 -> Unknown EM2800 video grabber
[ 1056.810379] em28xx #0:     card=1 -> Unknown EM2750/28xx video
grabber
[ 1056.810380] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
[ 1056.810381] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
[ 1056.810383] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
[ 1056.810384] em28xx #0:     card=5 -> MSI VOX USB 2.0
[ 1056.810385] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
[ 1056.810386] em28xx #0:     card=7 -> Leadtek Winfast USB II
[ 1056.810388] em28xx #0:     card=8 -> Kworld USB2800
[ 1056.810389] em28xx #0:     card=9 -> Pinnacle Dazzle DVC 90/DVC 100
[ 1056.810390] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
[ 1056.810392] em28xx #0:     card=11 -> Terratec Hybrid XS
[ 1056.810393] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
[ 1056.810394] em28xx #0:     card=13 -> Terratec Prodigy XS
[ 1056.810395] em28xx #0:     card=14 -> Pixelview Prolink PlayTV USB
2.0
[ 1056.810397] em28xx #0:     card=15 -> V-Gear PocketTV
[ 1056.810398] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
[ 1056.810399] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[ 1056.810401] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[ 1056.810402] em28xx #0:     card=19 -> PointNix Intra-Oral Camera
[ 1056.810403] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
[ 1056.810405] em28xx #0:     card=21 -> eMPIA Technology, Inc. GrabBeeX
+ Video Encoder
[ 1056.810406] em28xx #0:     card=22 -> Unknown EM2750/EM2751 webcam
grabber
[ 1056.810407] em28xx #0:     card=23 -> Huaqi DLCW-130
[ 1056.810409] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
[ 1056.810410] em28xx #0:     card=25 -> Gadmei UTV310
[ 1056.810411] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
[ 1056.810412] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips
FM1216ME)
[ 1056.810414] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
[ 1056.810415] em28xx #0:     card=29 -> Pinnacle Dazzle DVC 100
[ 1056.810416] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
[ 1056.810418] em28xx #0:     card=31 -> Usbgear VD204v9
[ 1056.810419] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
[ 1056.810420] em28xx #0:     card=33 -> SIIG AVTuner-PVR/Prolink PlayTV
USB 2.0
[ 1056.810422] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
[ 1056.810423] em28xx #0:     card=35 -> Typhoon DVD Maker
[ 1056.810424] em28xx #0:     card=36 -> NetGMBH Cam
[ 1056.810426] em28xx #0:     card=37 -> Gadmei UTV330
[ 1056.810427] em28xx #0:     card=38 -> Yakumo MovieMixer
[ 1056.810428] em28xx #0:     card=39 -> KWorld PVRTV 300U
[ 1056.810429] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
[ 1056.810430] em28xx #0:     card=41 -> Kworld 350 U DVB-T
[ 1056.810432] em28xx #0:     card=42 -> Kworld 355 U DVB-T
[ 1056.810433] em28xx #0:     card=43 -> Terratec Cinergy T XS
[ 1056.810434] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[ 1056.810436] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
[ 1056.810437] em28xx #0:     card=46 -> Compro, VideoMate U3
[ 1056.810438] em28xx #0:     card=47 -> KWorld DVB-T 305U
[ 1056.810439] em28xx #0:     card=48 -> KWorld DVB-T 310U
[ 1056.810440] em28xx #0:     card=49 -> MSI DigiVox A/D
[ 1056.810442] em28xx #0:     card=50 -> MSI DigiVox A/D II
[ 1056.810443] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
[ 1056.810444] em28xx #0:     card=52 -> DNT DA2 Hybrid
[ 1056.810445] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
[ 1056.810447] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
[ 1056.810448] em28xx #0:     card=55 -> Terratec Hybrid XS (em2882)
[ 1056.810449] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (2)
[ 1056.810450] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[ 1056.810452] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
[ 1056.810453] em28xx #0:     card=59 -> Pinnacle PCTV HD Mini
[ 1056.824367] em28xx #0: Config register raw data: 0xc0
[ 1056.824368] em28xx #0: No AC97 audio processor
[ 1057.156130] em28xx #0: V4L2 device registered as /dev/video1
and /dev/vbi0
[ 1057.156136] em28xx-audio.c: probing for em28x1 non standard usbaudio
[ 1057.156137] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
[ 1057.169918] compat_ioctl32: exports duplicate symbol
v4l_compat_ioctl32 (owned by v4l2_compat_ioctl32)


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
