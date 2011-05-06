Return-path: <mchehab@pedra>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:41297 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425Ab1EFOar (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 May 2011 10:30:47 -0400
Received: by qyk7 with SMTP id 7so4429159qyk.19
        for <linux-media@vger.kernel.org>; Fri, 06 May 2011 07:30:46 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 7 May 2011 00:30:46 +1000
Message-ID: <BANLkTi=5cnKPpZJ4CDG2nGwLBO+WqaG-7Q@mail.gmail.com>
Subject: Pinnacle PCTV Stick not working MINT 9
From: richard overton <richard.overton2094@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 001 Device 007: ID eb1a:2870 eMPIA Technology, Inc. Pinnacle PCTV Stick
Bus 001 Device 005: ID 045e:0040 Microsoft Corp. Wheel Mouse Optical
Bus 001 Device 004: ID 046d:c317 Logitech, Inc.
Bus 001 Device 003: ID 046d:080f Logitech, Inc.
Bus 001 Device 002: ID 0409:0058 NEC Corp. HighSpeed Hub
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub


[   78.096885] em28xx: New device USB 2870 Device @ 480 Mbps
(eb1a:2870, interface 0, class 0)
[   78.097078] em28xx #0: chip ID is em2870
[   78.179682] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 70 28 c0 12
81 00 6a 22 00 00
[   78.179694] em28xx #0: i2c eeprom 10: 00 00 04 57 02 0d 00 00 00 00
00 00 00 00 00 00
[   78.179705] em28xx #0: i2c eeprom 20: 44 00 00 00 f0 10 02 00 00 00
00 00 5b 00 00 00
[   78.179716] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01
00 00 c8 8c 05 49
[   78.179727] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   78.179738] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   78.179748] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00
22 03 55 00 53 00
[   78.179759] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 37 00
30 00 20 00 44 00
[   78.179770] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00
00 00 00 00 00 00
[   78.179780] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   78.179791] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   78.179802] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   78.179812] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   78.179823] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   78.179834] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   78.179844] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   78.179857] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x539bbfc0
[   78.179859] em28xx #0: EEPROM info:
[   78.179861] em28xx #0:	No audio on board.
[   78.179863] em28xx #0:	500mA max power
[   78.179865] em28xx #0:	Table at 0x04, strings=0x226a, 0x0000, 0x0000
[   78.182308] em28xx #0: Identified as Unknown EM2750/28xx video
grabber (card=1)
[   78.212682] em28xx #0: found i2c device @ 0xa0 [eeprom]
[   78.218682] em28xx #0: found i2c device @ 0xc0 [tuner (analog)]
[   78.230309] em28xx #0: Your board has no unique USB ID and thus
need a hint to be detected.
[   78.230314] em28xx #0: You may try to use card=<n> insmod option to
workaround that.
[   78.230317] em28xx #0: Please send an email with this log to:
[   78.230319] em28xx #0: 	V4L Mailing List <linux-media@vger.kernel.org>
[   78.230321] em28xx #0: Board eeprom hash is 0x539bbfc0
[   78.230324] em28xx #0: Board i2c devicelist hash is 0x4b800080
[   78.230326] em28xx #0: Here is a list of valid choices for the
card=<n> insmod option:
[   78.230329] em28xx #0:     card=0 -> Unknown EM2800 video grabber
[   78.230332] em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
[   78.230335] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
[   78.230337] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
[   78.230340] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
[   78.230343] em28xx #0:     card=5 -> MSI VOX USB 2.0
[   78.230345] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
[   78.230348] em28xx #0:     card=7 -> Leadtek Winfast USB II
[   78.230350] em28xx #0:     card=8 -> Kworld USB2800
[   78.230353] em28xx #0:     card=9 -> Pinnacle Dazzle DVC
90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2
[   78.230356] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
[   78.230359] em28xx #0:     card=11 -> Terratec Hybrid XS
[   78.230362] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
[   78.230364] em28xx #0:     card=13 -> Terratec Prodigy XS
[   78.230367] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview
Prolink PlayTV USB 2.0
[   78.230370] em28xx #0:     card=15 -> V-Gear PocketTV
[   78.230372] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
[   78.230375] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[   78.230378] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[   78.230381] em28xx #0:     card=19 -> EM2860/SAA711X Reference Design
[   78.230383] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
[   78.230386] em28xx #0:     card=21 -> eMPIA Technology, Inc.
GrabBeeX+ Video Encoder
[   78.230389] em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam grabber
[   78.230392] em28xx #0:     card=23 -> Huaqi DLCW-130
[   78.230395] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
[   78.230398] em28xx #0:     card=25 -> Gadmei UTV310
[   78.230400] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
[   78.230403] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips FM1216ME)
[   78.230406] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
[   78.230408] em28xx #0:     card=29 -> <NULL>
[   78.230411] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
[   78.230414] em28xx #0:     card=31 -> Usbgear VD204v9
[   78.230416] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
[   78.230419] em28xx #0:     card=33 -> <NULL>
[   78.230421] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
[   78.230424] em28xx #0:     card=35 -> Typhoon DVD Maker
[   78.230427] em28xx #0:     card=36 -> NetGMBH Cam
[   78.230429] em28xx #0:     card=37 -> Gadmei UTV330
[   78.230432] em28xx #0:     card=38 -> Yakumo MovieMixer
[   78.230434] em28xx #0:     card=39 -> KWorld PVRTV 300U
[   78.230437] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
[   78.230440] em28xx #0:     card=41 -> Kworld 350 U DVB-T
[   78.230442] em28xx #0:     card=42 -> Kworld 355 U DVB-T
[   78.230445] em28xx #0:     card=43 -> Terratec Cinergy T XS
[   78.230447] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[   78.230450] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
[   78.230452] em28xx #0:     card=46 -> Compro, VideoMate U3
[   78.230455] em28xx #0:     card=47 -> KWorld DVB-T 305U
[   78.230458] em28xx #0:     card=48 -> KWorld DVB-T 310U
[   78.230460] em28xx #0:     card=49 -> MSI DigiVox A/D
[   78.230463] em28xx #0:     card=50 -> MSI DigiVox A/D II
[   78.230466] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
[   78.230468] em28xx #0:     card=52 -> DNT DA2 Hybrid
[   78.230471] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
[   78.230473] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
[   78.230476] em28xx #0:     card=55 -> Terratec Hybrid XS (em2882)
[   78.230479] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (2)
[   78.230481] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[   78.230484] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
[   78.230487] em28xx #0:     card=59 -> <NULL>
[   78.230489] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
[   78.230492] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[   78.230495] em28xx #0:     card=62 -> Gadmei TVR200
[   78.230497] em28xx #0:     card=63 -> Kaiomy TVnPC U2
[   78.230500] em28xx #0:     card=64 -> Easy Cap Capture DC-60
[   78.230502] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
[   78.230505] em28xx #0:     card=66 -> Empire dual TV
[   78.230508] em28xx #0:     card=67 -> Terratec Grabby
[   78.230510] em28xx #0:     card=68 -> Terratec AV350
[   78.230512] em28xx #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[   78.230515] em28xx #0:     card=70 -> Evga inDtube
[   78.230518] em28xx #0:     card=71 -> Silvercrest Webcam 1.3mpix
[   78.230520] em28xx #0:     card=72 -> Gadmei UTV330+
[   78.230523] em28xx #0:     card=73 -> Reddo DVB-C USB TV Box
[   78.230527] em28xx #0: v4l2 driver version 0.1.2
[   78.238178] em28xx #0: V4L2 video device registered as /dev/video1
[   78.238537] usbcore: registered new interface driver em28xx
[   78.239246] em28xx driver loaded
[  729.393597] usb 1-4: USB disconnect, address 6
[  729.393732] em28xx #0: disconnecting em28xx #0 video
[  729.393740] em28xx #0: V4L2 device /dev/video1 deregistered
