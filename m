Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:54170 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbZK3GZD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Nov 2009 01:25:03 -0500
Received: by bwz27 with SMTP id 27so2253387bwz.21
        for <linux-media@vger.kernel.org>; Sun, 29 Nov 2009 22:25:08 -0800 (PST)
MIME-Version: 1.0
Reply-To: jefferybradberry@daliun.net
Date: Mon, 30 Nov 2009 01:25:08 -0500
Message-ID: <3e95e4c30911292225g57479a9dnb0c774cee0a6e412@mail.gmail.com>
Subject: StarTech.com USB 2.0 Video Capture Cable SVID2USB2 dmesg log
From: Jeffery Bradberry <jefferybradberry@daliun.net>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello! I have a StarTech.com USB 2.0 Video Capture Cable SVID2USB2
device. I have yet to get the device working for me under Fedora 12. I
found the request to send an email with the log, so I thought I'd pass
it along. I tried several card=<n> insmod options (0, 1, and 8) with
no luck. I would like to get the device working and am willing to
contribute to the project if there's anything I can do to help out.
Please let me know if there's any more information about my setup
you'd like to know.


em28xx: New device USB 2821 Device @ 480 Mbps (eb1a:2821, interface 0, class 0)
em28xx #0: chip ID is em2820 (or em2710)
em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 21 28 90 00 11 03 6a 22 00 00
em28xx #0: i2c eeprom 10: 00 00 04 57 06 21 01 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 20: 02 00 01 01 f0 10 00 00 00 00 00 00 5b 00 00 00
em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 10 01 03 01 00 00 00 00
em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 22 03 55 00 53 00
em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 32 00 31 00 20 00 44 00
em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x37da7b8a
em28xx #0: EEPROM info:
em28xx #0:	AC97 audio (5 sample rates)
em28xx #0:	500mA max power
em28xx #0:	Table at 0x04, strings=0x226a, 0x0000, 0x0000
em28xx #0: Identified as Unknown EM2750/28xx video grabber (card=1)
em28xx #0: found i2c device @ 0x4a [saa7113h]
em28xx #0: found i2c device @ 0xa0 [eeprom]
em28xx #0: Your board has no unique USB ID and thus need a hint to be detected.
em28xx #0: You may try to use card=<n> insmod option to workaround that.
em28xx #0: Please send an email with this log to:
em28xx #0: 	V4L Mailing List <linux-media@vger.kernel.org>
em28xx #0: Board eeprom hash is 0x37da7b8a
em28xx #0: Board i2c devicelist hash is 0x6ba50080
em28xx #0: Here is a list of valid choices for the card=<n> insmod option:
em28xx #0:     card=0 -> Unknown EM2800 video grabber
em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
em28xx #0:     card=2 -> Terratec Cinergy 250 USB
em28xx #0:     card=3 -> Pinnacle PCTV USB 2
em28xx #0:     card=4 -> Hauppauge WinTV USB 2
em28xx #0:     card=5 -> MSI VOX USB 2.0
em28xx #0:     card=6 -> Terratec Cinergy 200 USB
em28xx #0:     card=7 -> Leadtek Winfast USB II
em28xx #0:     card=8 -> Kworld USB2800
em28xx #0:     card=9 -> Pinnacle Dazzle DVC 90/100/101/107 / Kaiser
Baas Video to DVD maker
em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
em28xx #0:     card=11 -> Terratec Hybrid XS
em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
em28xx #0:     card=13 -> Terratec Prodigy XS
em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview Prolink PlayTV USB 2.0
em28xx #0:     card=15 -> V-Gear PocketTV
em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
em28xx #0:     card=19 -> EM2860/SAA711X Reference Design
em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
em28xx #0:     card=21 -> eMPIA Technology, Inc. GrabBeeX+ Video Encoder
em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam grabber
em28xx #0:     card=23 -> Huaqi DLCW-130
em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
em28xx #0:     card=25 -> Gadmei UTV310
em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips FM1216ME)
em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
em28xx #0:     card=29 -> <NULL>
em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
em28xx #0:     card=31 -> Usbgear VD204v9
em28xx #0:     card=32 -> Supercomp USB 2.0 TV
em28xx #0:     card=33 -> <NULL>
em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
em28xx #0:     card=35 -> Typhoon DVD Maker
em28xx #0:     card=36 -> NetGMBH Cam
em28xx #0:     card=37 -> Gadmei UTV330
em28xx #0:     card=38 -> Yakumo MovieMixer
em28xx #0:     card=39 -> KWorld PVRTV 300U
em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
em28xx #0:     card=41 -> Kworld 350 U DVB-T
em28xx #0:     card=42 -> Kworld 355 U DVB-T
em28xx #0:     card=43 -> Terratec Cinergy T XS
em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
em28xx #0:     card=46 -> Compro, VideoMate U3
em28xx #0:     card=47 -> KWorld DVB-T 305U
em28xx #0:     card=48 -> KWorld DVB-T 310U
em28xx #0:     card=49 -> MSI DigiVox A/D
em28xx #0:     card=50 -> MSI DigiVox A/D II
em28xx #0:     card=51 -> Terratec Hybrid XS Secam
em28xx #0:     card=52 -> DNT DA2 Hybrid
em28xx #0:     card=53 -> Pinnacle Hybrid Pro
em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
em28xx #0:     card=55 -> Terratec Hybrid XS (em2882)
em28xx #0:     card=56 -> Pinnacle Hybrid Pro (2)
em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
em28xx #0:     card=59 -> <NULL>
em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
em28xx #0:     card=62 -> Gadmei TVR200
em28xx #0:     card=63 -> Kaiomy TVnPC U2
em28xx #0:     card=64 -> Easy Cap Capture DC-60
em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
em28xx #0:     card=66 -> Empire dual TV
em28xx #0:     card=67 -> Terratec Grabby
em28xx #0:     card=68 -> Terratec AV350
em28xx #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
em28xx #0:     card=70 -> Evga inDtube
em28xx #0:     card=71 -> Silvercrest Webcam 1.3mpix
em28xx #0: Config register raw data: 0x90
em28xx #0: AC97 vendor ID = 0x83847650
em28xx #0: AC97 features = 0x6a90
em28xx #0: Sigmatel audio processor detected(stac 9750)
em28xx #0: v4l2 driver version 0.1.2
em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
usbcore: registered new interface driver em28xx
em28xx driver loaded
