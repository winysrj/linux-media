Return-path: <linux-media-owner@vger.kernel.org>
Received: from blu0-omc2-s6.blu0.hotmail.com ([65.55.111.81]:54437 "EHLO
	blu0-omc2-s6.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759221Ab3LFVxW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Dec 2013 16:53:22 -0500
Message-ID: <BLU0-SMTP308EACDBF44C4942B0DC33AE5D60@phx.gbl>
Date: Fri, 6 Dec 2013 22:48:08 +0100
From: Christoph Wanasek <christoph.wanasek@hotmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Syslog: no unique id
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

22:27:40 chris-satellite kernel: [  177.886634] usb 1-2: new high-speed 
USB device number 6 using ehci-pci
Dec  6 22:27:40 chris-satellite kernel: [  178.022346] usb 1-2: New USB 
device found, idVendor=eb1a, idProduct=2870
Dec  6 22:27:40 chris-satellite kernel: [  178.022365] usb 1-2: New USB 
device strings: Mfr=0, Product=1, SerialNumber=0
Dec  6 22:27:40 chris-satellite kernel: [  178.022374] usb 1-2: Product: 
USB 2870 Device
Dec  6 22:27:40 chris-satellite kernel: [  178.023894] em28xx: New 
device  USB 2870 Device @ 480 Mbps (eb1a:2870, interface 0, class 0)
Dec  6 22:27:40 chris-satellite kernel: [  178.023910] em28xx: Video 
interface 0 found: isoc
Dec  6 22:27:40 chris-satellite kernel: [  178.023916] em28xx: DVB 
interface 0 found: isoc
Dec  6 22:27:40 chris-satellite kernel: [  178.024833] em28xx: chip ID 
is em2870
Dec  6 22:27:40 chris-satellite kernel: [  178.103801] em2870 #0: i2c 
eeprom 00: 1a eb 67 95 1a eb 70 28 c0 12 81 00 6a 22 00 00
Dec  6 22:27:40 chris-satellite kernel: [  178.103839] em2870 #0: i2c 
eeprom 10: 00 00 04 57 02 0d 00 00 00 00 00 00 00 00 00 00
Dec  6 22:27:40 chris-satellite kernel: [  178.103868] em2870 #0: i2c 
eeprom 20: 44 00 00 00 f0 10 02 00 00 00 00 00 5b 00 00 00
Dec  6 22:27:40 chris-satellite kernel: [  178.103896] em2870 #0: i2c 
eeprom 30: 00 00 20 40 20 80 02 20 01 01 00 00 44 1c 42 49
Dec  6 22:27:40 chris-satellite kernel: [  178.103925] em2870 #0: i2c 
eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Dec  6 22:27:40 chris-satellite kernel: [  178.103952] em2870 #0: i2c 
eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Dec  6 22:27:40 chris-satellite kernel: [  178.103980] em2870 #0: i2c 
eeprom 60: 00 00 00 00 00 00 00 00 00 00 22 03 55 00 53 00
Dec  6 22:27:40 chris-satellite kernel: [  178.104008] em2870 #0: i2c 
eeprom 70: 42 00 20 00 32 00 38 00 37 00 30 00 20 00 44 00
Dec  6 22:27:40 chris-satellite kernel: [  178.104035] em2870 #0: i2c 
eeprom 80: 65 00 76 00 69 00 63 00 65 00 00 00 00 00 00 00
Dec  6 22:27:40 chris-satellite kernel: [  178.104062] em2870 #0: i2c 
eeprom 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Dec  6 22:27:40 chris-satellite kernel: [  178.104089] em2870 #0: i2c 
eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Dec  6 22:27:40 chris-satellite kernel: [  178.104116] em2870 #0: i2c 
eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Dec  6 22:27:40 chris-satellite kernel: [  178.104144] em2870 #0: i2c 
eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Dec  6 22:27:40 chris-satellite kernel: [  178.104171] em2870 #0: i2c 
eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Dec  6 22:27:40 chris-satellite kernel: [  178.104286] em2870 #0: i2c 
eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Dec  6 22:27:40 chris-satellite kernel: [  178.104314] em2870 #0: i2c 
eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Dec  6 22:27:40 chris-satellite kernel: [  178.104348] em2870 #0: EEPROM 
ID = 1a eb 67 95, EEPROM hash = 0xde2bf8c0
Dec  6 22:27:40 chris-satellite kernel: [  178.104357] em2870 #0: EEPROM 
info:
Dec  6 22:27:40 chris-satellite kernel: [  178.104363] em2870 #0:  No 
audio on board.
Dec  6 22:27:40 chris-satellite kernel: [  178.104368] em2870 #0:  500mA 
max power
Dec  6 22:27:40 chris-satellite kernel: [  178.104376] em2870 #0:  Table 
at offset 0x04, strings=0x226a, 0x0000, 0x0000
Dec  6 22:27:40 chris-satellite kernel: [  178.106971] em2870 #0: No 
sensor detected
Dec  6 22:27:40 chris-satellite kernel: [  178.139691] em2870 #0: found 
i2c device @ 0xa0 on bus 0 [eeprom]
Dec  6 22:27:40 chris-satellite kernel: [  178.145674] em2870 #0: found 
i2c device @ 0xc0 on bus 0 [tuner (analog)]
Dec  6 22:27:40 chris-satellite kernel: [  178.158169] em2870 #0: Your 
board has no unique USB ID and thus need a hint to be detected.
Dec  6 22:27:40 chris-satellite kernel: [  178.158188] em2870 #0: You 
may try to use card=<n> insmod option to workaround that.
Dec  6 22:27:40 chris-satellite kernel: [  178.158194] em2870 #0: Please 
send an email with this log to:
Dec  6 22:27:40 chris-satellite kernel: [  178.158200] em2870 #0:  V4L 
Mailing List <linux-media@vger.kernel.org>
Dec  6 22:27:40 chris-satellite kernel: [  178.158207] em2870 #0: Board 
eeprom hash is 0xde2bf8c0
Dec  6 22:27:40 chris-satellite kernel: [  178.158213] em2870 #0: Board 
i2c devicelist hash is 0x4b800080
Dec  6 22:27:40 chris-satellite kernel: [  178.158218] em2870 #0: Here 
is a list of valid choices for the card=<n> insmod option:
Dec  6 22:27:40 chris-satellite kernel: [  178.158225] em2870 #0:     
card=0 -> Unknown EM2800 video grabber
Dec  6 22:27:40 chris-satellite kernel: [  178.158232] em2870 #0:     
card=1 -> Unknown EM2750/28xx video grabber
Dec  6 22:27:40 chris-satellite kernel: [  178.158238] em2870 #0:     
card=2 -> Terratec Cinergy 250 USB
Dec  6 22:27:40 chris-satellite kernel: [  178.158244] em2870 #0:     
card=3 -> Pinnacle PCTV USB 2
Dec  6 22:27:40 chris-satellite kernel: [  178.158250] em2870 #0:     
card=4 -> Hauppauge WinTV USB 2
Dec  6 22:27:40 chris-satellite kernel: [  178.158256] em2870 #0:     
card=5 -> MSI VOX USB 2.0
Dec  6 22:27:40 chris-satellite kernel: [  178.158262] em2870 #0:     
card=6 -> Terratec Cinergy 200 USB
Dec  6 22:27:40 chris-satellite kernel: [  178.158267] em2870 #0:     
card=7 -> Leadtek Winfast USB II
Dec  6 22:27:40 chris-satellite kernel: [  178.158273] em2870 #0:     
card=8 -> Kworld USB2800
Dec  6 22:27:40 chris-satellite kernel: [  178.158279] em2870 #0:     
card=9 -> Pinnacle Dazzle DVC 90/100/101/107 / Kaiser Baas Video to DVD 
maker / Kworld DVD Maker 2 / Plextor ConvertX PX-AV100U
Dec  6 22:27:40 chris-satellite kernel: [  178.158286] em2870 #0:     
card=10 -> Hauppauge WinTV HVR 900
Dec  6 22:27:40 chris-satellite kernel: [  178.158292] em2870 #0:     
card=11 -> Terratec Hybrid XS
Dec  6 22:27:40 chris-satellite kernel: [  178.158298] em2870 #0:     
card=12 -> Kworld PVR TV 2800 RF
Dec  6 22:27:40 chris-satellite kernel: [  178.158304] em2870 #0:     
card=13 -> Terratec Prodigy XS
Dec  6 22:27:40 chris-satellite kernel: [  178.158310] em2870 #0:     
card=14 -> SIIG AVTuner-PVR / Pixelview Prolink PlayTV USB 2.0
Dec  6 22:27:40 chris-satellite kernel: [  178.158315] em2870 #0:     
card=15 -> V-Gear PocketTV
Dec  6 22:27:40 chris-satellite kernel: [  178.158321] em2870 #0:     
card=16 -> Hauppauge WinTV HVR 950
Dec  6 22:27:40 chris-satellite kernel: [  178.158327] em2870 #0:     
card=17 -> Pinnacle PCTV HD Pro Stick
Dec  6 22:27:40 chris-satellite kernel: [  178.158333] em2870 #0:     
card=18 -> Hauppauge WinTV HVR 900 (R2)
Dec  6 22:27:40 chris-satellite kernel: [  178.158338] em2870 #0:     
card=19 -> EM2860/SAA711X Reference Design
Dec  6 22:27:40 chris-satellite kernel: [  178.158344] em2870 #0:     
card=20 -> AMD ATI TV Wonder HD 600
Dec  6 22:27:40 chris-satellite kernel: [  178.158350] em2870 #0:     
card=21 -> eMPIA Technology, Inc. GrabBeeX+ Video Encoder
Dec  6 22:27:40 chris-satellite kernel: [  178.158356] em2870 #0:     
card=22 -> EM2710/EM2750/EM2751 webcam grabber
Dec  6 22:27:40 chris-satellite kernel: [  178.158362] em2870 #0:     
card=23 -> Huaqi DLCW-130
Dec  6 22:27:40 chris-satellite kernel: [  178.158367] em2870 #0:     
card=24 -> D-Link DUB-T210 TV Tuner
Dec  6 22:27:40 chris-satellite kernel: [  178.158373] em2870 #0:     
card=25 -> Gadmei UTV310
Dec  6 22:27:40 chris-satellite kernel: [  178.158379] em2870 #0:     
card=26 -> Hercules Smart TV USB 2.0
Dec  6 22:27:40 chris-satellite kernel: [  178.158384] em2870 #0:     
card=27 -> Pinnacle PCTV USB 2 (Philips FM1216ME)
Dec  6 22:27:40 chris-satellite kernel: [  178.158390] em2870 #0:     
card=28 -> Leadtek Winfast USB II Deluxe
Dec  6 22:27:40 chris-satellite kernel: [  178.158396] em2870 #0:     
card=29 -> EM2860/TVP5150 Reference Design
Dec  6 22:27:40 chris-satellite kernel: [  178.158402] em2870 #0:     
card=30 -> Videology 20K14XUSB USB2.0
Dec  6 22:27:40 chris-satellite kernel: [  178.158407] em2870 #0:     
card=31 -> Usbgear VD204v9
Dec  6 22:27:40 chris-satellite kernel: [  178.158413] em2870 #0:     
card=32 -> Supercomp USB 2.0 TV
Dec  6 22:27:40 chris-satellite kernel: [  178.158419] em2870 #0:     
card=33 -> Elgato Video Capture
Dec  6 22:27:40 chris-satellite kernel: [  178.158424] em2870 #0:     
card=34 -> Terratec Cinergy A Hybrid XS
Dec  6 22:27:40 chris-satellite kernel: [  178.158430] em2870 #0:     
card=35 -> Typhoon DVD Maker
Dec  6 22:27:40 chris-satellite kernel: [  178.158436] em2870 #0:     
card=36 -> NetGMBH Cam
Dec  6 22:27:40 chris-satellite kernel: [  178.158441] em2870 #0:     
card=37 -> Gadmei UTV330
Dec  6 22:27:40 chris-satellite kernel: [  178.158447] em2870 #0:     
card=38 -> Yakumo MovieMixer
Dec  6 22:27:40 chris-satellite kernel: [  178.158452] em2870 #0:     
card=39 -> KWorld PVRTV 300U
Dec  6 22:27:40 chris-satellite kernel: [  178.158458] em2870 #0:     
card=40 -> Plextor ConvertX PX-TV100U
Dec  6 22:27:40 chris-satellite kernel: [  178.158464] em2870 #0:     
card=41 -> Kworld 350 U DVB-T
Dec  6 22:27:40 chris-satellite kernel: [  178.158469] em2870 #0:     
card=42 -> Kworld 355 U DVB-T
Dec  6 22:27:40 chris-satellite kernel: [  178.158475] em2870 #0:     
card=43 -> Terratec Cinergy T XS
Dec  6 22:27:40 chris-satellite kernel: [  178.158481] em2870 #0:     
card=44 -> Terratec Cinergy T XS (MT2060)
Dec  6 22:27:40 chris-satellite kernel: [  178.158486] em2870 #0:     
card=45 -> Pinnacle PCTV DVB-T
Dec  6 22:27:40 chris-satellite kernel: [  178.158492] em2870 #0:     
card=46 -> Compro, VideoMate U3
Dec  6 22:27:40 chris-satellite kernel: [  178.158498] em2870 #0:     
card=47 -> KWorld DVB-T 305U
Dec  6 22:27:40 chris-satellite kernel: [  178.158503] em2870 #0:     
card=48 -> KWorld DVB-T 310U
Dec  6 22:27:40 chris-satellite kernel: [  178.158509] em2870 #0:     
card=49 -> MSI DigiVox A/D
Dec  6 22:27:40 chris-satellite kernel: [  178.158515] em2870 #0:     
card=50 -> MSI DigiVox A/D II
Dec  6 22:27:40 chris-satellite kernel: [  178.158520] em2870 #0:     
card=51 -> Terratec Hybrid XS Secam
Dec  6 22:27:40 chris-satellite kernel: [  178.158526] em2870 #0:     
card=52 -> DNT DA2 Hybrid
Dec  6 22:27:40 chris-satellite kernel: [  178.158531] em2870 #0:     
card=53 -> Pinnacle Hybrid Pro
Dec  6 22:27:40 chris-satellite kernel: [  178.158537] em2870 #0:     
card=54 -> Kworld VS-DVB-T 323UR
Dec  6 22:27:40 chris-satellite kernel: [  178.158543] em2870 #0:     
card=55 -> Terratec Cinnergy Hybrid T USB XS (em2882)
Dec  6 22:27:40 chris-satellite kernel: [  178.158549] em2870 #0:     
card=56 -> Pinnacle Hybrid Pro (330e)
Dec  6 22:27:40 chris-satellite kernel: [  178.158554] em2870 #0:     
card=57 -> Kworld PlusTV HD Hybrid 330
Dec  6 22:27:40 chris-satellite kernel: [  178.158560] em2870 #0:     
card=58 -> Compro VideoMate ForYou/Stereo
Dec  6 22:27:40 chris-satellite kernel: [  178.158566] em2870 #0:     
card=59 -> (null)
Dec  6 22:27:40 chris-satellite kernel: [  178.158571] em2870 #0:     
card=60 -> Hauppauge WinTV HVR 850
Dec  6 22:27:40 chris-satellite kernel: [  178.158577] em2870 #0:     
card=61 -> Pixelview PlayTV Box 4 USB 2.0
Dec  6 22:27:40 chris-satellite kernel: [  178.158583] em2870 #0:     
card=62 -> Gadmei TVR200
Dec  6 22:27:40 chris-satellite kernel: [  178.158588] em2870 #0:     
card=63 -> Kaiomy TVnPC U2
Dec  6 22:27:40 chris-satellite kernel: [  178.158594] em2870 #0:     
card=64 -> Easy Cap Capture DC-60
Dec  6 22:27:40 chris-satellite kernel: [  178.158599] em2870 #0:     
card=65 -> IO-DATA GV-MVP/SZ
Dec  6 22:27:40 chris-satellite kernel: [  178.158605] em2870 #0:     
card=66 -> Empire dual TV
Dec  6 22:27:40 chris-satellite kernel: [  178.158610] em2870 #0:     
card=67 -> Terratec Grabby
Dec  6 22:27:40 chris-satellite kernel: [  178.158616] em2870 #0:     
card=68 -> Terratec AV350
Dec  6 22:27:40 chris-satellite kernel: [  178.158622] em2870 #0:     
card=69 -> KWorld ATSC 315U HDTV TV Box
Dec  6 22:27:40 chris-satellite kernel: [  178.158627] em2870 #0:     
card=70 -> Evga inDtube
Dec  6 22:27:40 chris-satellite kernel: [  178.158633] em2870 #0:     
card=71 -> Silvercrest Webcam 1.3mpix
Dec  6 22:27:40 chris-satellite kernel: [  178.158638] em2870 #0:     
card=72 -> Gadmei UTV330+
Dec  6 22:27:40 chris-satellite kernel: [  178.158644] em2870 #0:     
card=73 -> Reddo DVB-C USB TV Box
Dec  6 22:27:40 chris-satellite kernel: [  178.158650] em2870 #0:     
card=74 -> Actionmaster/LinXcel/Digitus VC211A
Dec  6 22:27:40 chris-satellite kernel: [  178.158656] em2870 #0:     
card=75 -> Dikom DK300
Dec  6 22:27:40 chris-satellite kernel: [  178.158661] em2870 #0:     
card=76 -> KWorld PlusTV 340U or UB435-Q (ATSC)
Dec  6 22:27:40 chris-satellite kernel: [  178.158667] em2870 #0:     
card=77 -> EM2874 Leadership ISDBT
Dec  6 22:27:40 chris-satellite kernel: [  178.158673] em2870 #0:     
card=78 -> PCTV nanoStick T2 290e
Dec  6 22:27:40 chris-satellite kernel: [  178.158678] em2870 #0:     
card=79 -> Terratec Cinergy H5
Dec  6 22:27:40 chris-satellite kernel: [  178.158684] em2870 #0:     
card=80 -> PCTV DVB-S2 Stick (460e)
Dec  6 22:27:40 chris-satellite kernel: [  178.158690] em2870 #0:     
card=81 -> Hauppauge WinTV HVR 930C
Dec  6 22:27:40 chris-satellite kernel: [  178.158695] em2870 #0:     
card=82 -> Terratec Cinergy HTC Stick
Dec  6 22:27:40 chris-satellite kernel: [  178.158701] em2870 #0:     
card=83 -> Honestech Vidbox NW03
Dec  6 22:27:40 chris-satellite kernel: [  178.158707] em2870 #0:     
card=84 -> MaxMedia UB425-TC
Dec  6 22:27:40 chris-satellite kernel: [  178.158712] em2870 #0:     
card=85 -> PCTV QuatroStick (510e)
Dec  6 22:27:40 chris-satellite kernel: [  178.158718] em2870 #0:     
card=86 -> PCTV QuatroStick nano (520e)
Dec  6 22:27:40 chris-satellite kernel: [  178.158724] em2870 #0:     
card=87 -> Terratec Cinergy HTC USB XS
Dec  6 22:27:40 chris-satellite kernel: [  178.158729] em2870 #0:     
card=88 -> C3 Tech Digital Duo HDTV/SDTV USB
Dec  6 22:27:40 chris-satellite kernel: [  178.158735] em2870 #0:     
card=89 -> Delock 61959
Dec  6 22:27:40 chris-satellite kernel: [  178.158741] em2870 #0:     
card=90 -> KWorld USB ATSC TV Stick UB435-Q V2
Dec  6 22:27:40 chris-satellite kernel: [  178.158746] em2870 #0: Board 
not discovered
Dec  6 22:27:40 chris-satellite kernel: [  178.158753] em2870 #0: 
Identified as Unknown EM2750/28xx video grabber (card=1)
Dec  6 22:27:40 chris-satellite kernel: [  178.158759] em2870 #0: Your 
board has no unique USB ID and thus need a hint to be detected.
Dec  6 22:27:40 chris-satellite kernel: [  178.158764] em2870 #0: You 
may try to use card=<n> insmod option to workaround that.
Dec  6 22:27:40 chris-satellite kernel: [  178.158769] em2870 #0: Please 
send an email with this log to:
Dec  6 22:27:40 chris-satellite kernel: [  178.158774] em2870 #0:  V4L 
Mailing List <linux-media@vger.kernel.org>
Dec  6 22:27:40 chris-satellite kernel: [  178.158779] em2870 #0: Board 
eeprom hash is 0xde2bf8c0
Dec  6 22:27:40 chris-satellite kernel: [  178.158785] em2870 #0: Board 
i2c devicelist hash is 0x4b800080
Dec  6 22:27:40 chris-satellite kernel: [  178.158790] em2870 #0: Here 
is a list of valid choices for the card=<n> insmod option:
Dec  6 22:27:40 chris-satellite kernel: [  178.158796] em2870 #0:     
card=0 -> Unknown EM2800 video grabber
Dec  6 22:27:40 chris-satellite kernel: [  178.158801] em2870 #0:     
card=1 -> Unknown EM2750/28xx video grabber
Dec  6 22:27:40 chris-satellite kernel: [  178.158807] em2870 #0:     
card=2 -> Terratec Cinergy 250 USB
Dec  6 22:27:40 chris-satellite kernel: [  178.158812] em2870 #0:     
card=3 -> Pinnacle PCTV USB 2
Dec  6 22:27:40 chris-satellite kernel: [  178.158818] em2870 #0:     
card=4 -> Hauppauge WinTV USB 2
Dec  6 22:27:40 chris-satellite kernel: [  178.158823] em2870 #0:     
card=5 -> MSI VOX USB 2.0
Dec  6 22:27:40 chris-satellite kernel: [  178.158829] em2870 #0:     
card=6 -> Terratec Cinergy 200 USB
Dec  6 22:27:40 chris-satellite kernel: [  178.158834] em2870 #0:     
card=7 -> Leadtek Winfast USB II
Dec  6 22:27:40 chris-satellite kernel: [  178.158839] em2870 #0:     
card=8 -> Kworld USB2800
Dec  6 22:27:40 chris-satellite kernel: [  178.158846] em2870 #0:     
card=9 -> Pinnacle Dazzle DVC 90/100/101/107 / Kaiser Baas Video to DVD 
maker / Kworld DVD Maker 2 / Plextor ConvertX PX-AV100U
Dec  6 22:27:40 chris-satellite kernel: [  178.158852] em2870 #0:     
card=10 -> Hauppauge WinTV HVR 900
Dec  6 22:27:40 chris-satellite kernel: [  178.158857] em2870 #0:     
card=11 -> Terratec Hybrid XS
Dec  6 22:27:40 chris-satellite kernel: [  178.158863] em2870 #0:     
card=12 -> Kworld PVR TV 2800 RF
Dec  6 22:27:40 chris-satellite kernel: [  178.158869] em2870 #0:     
card=13 -> Terratec Prodigy XS
Dec  6 22:27:40 chris-satellite kernel: [  178.158874] em2870 #0:     
card=14 -> SIIG AVTuner-PVR / Pixelview Prolink PlayTV USB 2.0
Dec  6 22:27:40 chris-satellite kernel: [  178.158880] em2870 #0:     
card=15 -> V-Gear PocketTV
Dec  6 22:27:40 chris-satellite kernel: [  178.158885] em2870 #0:     
card=16 -> Hauppauge WinTV HVR 950
Dec  6 22:27:40 chris-satellite kernel: [  178.158891] em2870 #0:     
card=17 -> Pinnacle PCTV HD Pro Stick
Dec  6 22:27:40 chris-satellite kernel: [  178.158897] em2870 #0:     
card=18 -> Hauppauge WinTV HVR 900 (R2)
Dec  6 22:27:40 chris-satellite kernel: [  178.158902] em2870 #0:     
card=19 -> EM2860/SAA711X Reference Design
Dec  6 22:27:40 chris-satellite kernel: [  178.158908] em2870 #0:     
card=20 -> AMD ATI TV Wonder HD 600
Dec  6 22:27:40 chris-satellite kernel: [  178.158914] em2870 #0:     
card=21 -> eMPIA Technology, Inc. GrabBeeX+ Video Encoder
Dec  6 22:27:40 chris-satellite kernel: [  178.158919] em2870 #0:     
card=22 -> EM2710/EM2750/EM2751 webcam grabber
Dec  6 22:27:40 chris-satellite kernel: [  178.158925] em2870 #0:     
card=23 -> Huaqi DLCW-130
Dec  6 22:27:40 chris-satellite kernel: [  178.158930] em2870 #0:     
card=24 -> D-Link DUB-T210 TV Tuner
Dec  6 22:27:40 chris-satellite kernel: [  178.158936] em2870 #0:     
card=25 -> Gadmei UTV310
Dec  6 22:27:40 chris-satellite kernel: [  178.158941] em2870 #0:     
card=26 -> Hercules Smart TV USB 2.0
Dec  6 22:27:40 chris-satellite kernel: [  178.158947] em2870 #0:     
card=27 -> Pinnacle PCTV USB 2 (Philips FM1216ME)
Dec  6 22:27:40 chris-satellite kernel: [  178.158952] em2870 #0:     
card=28 -> Leadtek Winfast USB II Deluxe
Dec  6 22:27:40 chris-satellite kernel: [  178.158958] em2870 #0:     
card=29 -> EM2860/TVP5150 Reference Design
Dec  6 22:27:40 chris-satellite kernel: [  178.158964] em2870 #0:     
card=30 -> Videology 20K14XUSB USB2.0
Dec  6 22:27:40 chris-satellite kernel: [  178.158969] em2870 #0:     
card=31 -> Usbgear VD204v9
Dec  6 22:27:40 chris-satellite kernel: [  178.158975] em2870 #0:     
card=32 -> Supercomp USB 2.0 TV
Dec  6 22:27:40 chris-satellite kernel: [  178.158980] em2870 #0:     
card=33 -> Elgato Video Capture
Dec  6 22:27:40 chris-satellite kernel: [  178.158986] em2870 #0:     
card=34 -> Terratec Cinergy A Hybrid XS
Dec  6 22:27:40 chris-satellite kernel: [  178.158991] em2870 #0:     
card=35 -> Typhoon DVD Maker
Dec  6 22:27:40 chris-satellite kernel: [  178.158997] em2870 #0:     
card=36 -> NetGMBH Cam
Dec  6 22:27:40 chris-satellite kernel: [  178.159002] em2870 #0:     
card=37 -> Gadmei UTV330
Dec  6 22:27:40 chris-satellite kernel: [  178.159007] em2870 #0:     
card=38 -> Yakumo MovieMixer
Dec  6 22:27:40 chris-satellite kernel: [  178.159013] em2870 #0:     
card=39 -> KWorld PVRTV 300U
Dec  6 22:27:40 chris-satellite kernel: [  178.159018] em2870 #0:     
card=40 -> Plextor ConvertX PX-TV100U
Dec  6 22:27:40 chris-satellite kernel: [  178.159024] em2870 #0:     
card=41 -> Kworld 350 U DVB-T
Dec  6 22:27:40 chris-satellite kernel: [  178.159029] em2870 #0:     
card=42 -> Kworld 355 U DVB-T
Dec  6 22:27:40 chris-satellite kernel: [  178.159035] em2870 #0:     
card=43 -> Terratec Cinergy T XS
Dec  6 22:27:40 chris-satellite kernel: [  178.159040] em2870 #0:     
card=44 -> Terratec Cinergy T XS (MT2060)
Dec  6 22:27:40 chris-satellite kernel: [  178.159046] em2870 #0:     
card=45 -> Pinnacle PCTV DVB-T
Dec  6 22:27:40 chris-satellite kernel: [  178.159051] em2870 #0:     
card=46 -> Compro, VideoMate U3
Dec  6 22:27:40 chris-satellite kernel: [  178.159057] em2870 #0:     
card=47 -> KWorld DVB-T 305U
Dec  6 22:27:40 chris-satellite kernel: [  178.159062] em2870 #0:     
card=48 -> KWorld DVB-T 310U
Dec  6 22:27:40 chris-satellite kernel: [  178.159068] em2870 #0:     
card=49 -> MSI DigiVox A/D
Dec  6 22:27:40 chris-satellite kernel: [  178.159073] em2870 #0:     
card=50 -> MSI DigiVox A/D II
Dec  6 22:27:40 chris-satellite kernel: [  178.159079] em2870 #0:     
card=51 -> Terratec Hybrid XS Secam
Dec  6 22:27:40 chris-satellite kernel: [  178.159084] em2870 #0:     
card=52 -> DNT DA2 Hybrid
Dec  6 22:27:40 chris-satellite kernel: [  178.159089] em2870 #0:     
card=53 -> Pinnacle Hybrid Pro
Dec  6 22:27:40 chris-satellite kernel: [  178.159095] em2870 #0:     
card=54 -> Kworld VS-DVB-T 323UR
Dec  6 22:27:40 chris-satellite kernel: [  178.159101] em2870 #0:     
card=55 -> Terratec Cinnergy Hybrid T USB XS (em2882)
Dec  6 22:27:40 chris-satellite kernel: [  178.159106] em2870 #0:     
card=56 -> Pinnacle Hybrid Pro (330e)
Dec  6 22:27:40 chris-satellite kernel: [  178.159112] em2870 #0:     
card=57 -> Kworld PlusTV HD Hybrid 330
Dec  6 22:27:40 chris-satellite kernel: [  178.159117] em2870 #0:     
card=58 -> Compro VideoMate ForYou/Stereo
Dec  6 22:27:40 chris-satellite kernel: [  178.159123] em2870 #0:     
card=59 -> (null)
Dec  6 22:27:40 chris-satellite kernel: [  178.159128] em2870 #0:     
card=60 -> Hauppauge WinTV HVR 850
Dec  6 22:27:40 chris-satellite kernel: [  178.159134] em2870 #0:     
card=61 -> Pixelview PlayTV Box 4 USB 2.0
Dec  6 22:27:40 chris-satellite kernel: [  178.159139] em2870 #0:     
card=62 -> Gadmei TVR200
Dec  6 22:27:40 chris-satellite kernel: [  178.159144] em2870 #0:     
card=63 -> Kaiomy TVnPC U2
Dec  6 22:27:40 chris-satellite kernel: [  178.159150] em2870 #0:     
card=64 -> Easy Cap Capture DC-60
Dec  6 22:27:40 chris-satellite kernel: [  178.159155] em2870 #0:     
card=65 -> IO-DATA GV-MVP/SZ
Dec  6 22:27:40 chris-satellite kernel: [  178.159161] em2870 #0:     
card=66 -> Empire dual TV
Dec  6 22:27:40 chris-satellite kernel: [  178.159166] em2870 #0:     
card=67 -> Terratec Grabby
Dec  6 22:27:40 chris-satellite kernel: [  178.159171] em2870 #0:     
card=68 -> Terratec AV350
Dec  6 22:27:40 chris-satellite kernel: [  178.159177] em2870 #0:     
card=69 -> KWorld ATSC 315U HDTV TV Box
Dec  6 22:27:40 chris-satellite kernel: [  178.159182] em2870 #0:     
card=70 -> Evga inDtube
Dec  6 22:27:40 chris-satellite kernel: [  178.159188] em2870 #0:     
card=71 -> Silvercrest Webcam 1.3mpix
Dec  6 22:27:40 chris-satellite kernel: [  178.159193] em2870 #0:     
card=72 -> Gadmei UTV330+
Dec  6 22:27:40 chris-satellite kernel: [  178.159199] em2870 #0:     
card=73 -> Reddo DVB-C USB TV Box
Dec  6 22:27:40 chris-satellite kernel: [  178.159204] em2870 #0:     
card=74 -> Actionmaster/LinXcel/Digitus VC211A
Dec  6 22:27:40 chris-satellite kernel: [  178.159210] em2870 #0:     
card=75 -> Dikom DK300
Dec  6 22:27:40 chris-satellite kernel: [  178.159215] em2870 #0:     
card=76 -> KWorld PlusTV 340U or UB435-Q (ATSC)
Dec  6 22:27:40 chris-satellite kernel: [  178.159221] em2870 #0:     
card=77 -> EM2874 Leadership ISDBT
Dec  6 22:27:40 chris-satellite kernel: [  178.159226] em2870 #0:     
card=78 -> PCTV nanoStick T2 290e
Dec  6 22:27:40 chris-satellite kernel: [  178.159232] em2870 #0:     
card=79 -> Terratec Cinergy H5
Dec  6 22:27:40 chris-satellite kernel: [  178.159237] em2870 #0:     
card=80 -> PCTV DVB-S2 Stick (460e)
Dec  6 22:27:40 chris-satellite kernel: [  178.159243] em2870 #0:     
card=81 -> Hauppauge WinTV HVR 930C
Dec  6 22:27:40 chris-satellite kernel: [  178.159249] em2870 #0:     
card=82 -> Terratec Cinergy HTC Stick
Dec  6 22:27:40 chris-satellite kernel: [  178.159254] em2870 #0:     
card=83 -> Honestech Vidbox NW03
Dec  6 22:27:40 chris-satellite kernel: [  178.159260] em2870 #0:     
card=84 -> MaxMedia UB425-TC
Dec  6 22:27:40 chris-satellite kernel: [  178.159265] em2870 #0:     
card=85 -> PCTV QuatroStick (510e)
Dec  6 22:27:40 chris-satellite kernel: [  178.159271] em2870 #0:     
card=86 -> PCTV QuatroStick nano (520e)
Dec  6 22:27:40 chris-satellite kernel: [  178.159276] em2870 #0:     
card=87 -> Terratec Cinergy HTC USB XS
Dec  6 22:27:40 chris-satellite kernel: [  178.159282] em2870 #0:     
card=88 -> C3 Tech Digital Duo HDTV/SDTV USB
Dec  6 22:27:40 chris-satellite kernel: [  178.159287] em2870 #0:     
card=89 -> Delock 61959
Dec  6 22:27:40 chris-satellite kernel: [  178.159293] em2870 #0:     
card=90 -> KWorld USB ATSC TV Stick UB435-Q V2
Dec  6 22:27:40 chris-satellite kernel: [  178.159315] em2870 #0: v4l2 
driver version 0.2.0
Dec  6 22:27:40 chris-satellite kernel: [  178.169431] em2870 #0: V4L2 
video device registered as video1
Dec  6 22:27:40 chris-satellite kernel: [  178.169447] em2870 #0: analog 
set to isoc mode.
Dec  6 22:27:40 chris-satellite kernel: [  178.169454] em2870 #0: dvb 
set to isoc mode.
Dec  6 22:27:40 chris-satellite mtp-probe: checking bus 1, device 6: 
"/sys/devices/pci0000:00/0000:00:12.2/usb1/1-2"
Dec  6 22:27:40 chris-satellite mtp-probe: bus: 1, device: 6 was not an 
MTP device
Dec  6 22:27:40 chris-satellite colord: Device added: 
sysfs-eb1a-USB_2870_Device
Dec  6 22:29:14 chris-satellite kernel: [  272.195320] usb 1-2: USB 
disconnect, device number 6
Dec  6 22:29:14 chris-satellite kernel: [  272.195498] em2870 #0: 
disconnecting em2870 #0 video
Dec  6 22:29:14 chris-satellite kernel: [  272.195510] em2870 #0: V4L2 
device video1 deregistered
Dec  6 22:29:14 chris-satellite colord: device removed: 
sysfs-eb1a-USB_2870_Device
