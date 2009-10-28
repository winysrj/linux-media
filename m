Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp102.sbc.mail.ac4.yahoo.com ([76.13.13.241]:21641 "HELO
	smtp102.sbc.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757116AbZJ1BWi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Oct 2009 21:22:38 -0400
Subject: AirLink101 USB capture device
From: Tony <tmiles9561@att.net>
To: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Tue, 27 Oct 2009 21:15:55 -0400
Message-Id: <1256692555.7615.20.camel@tony-nix>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, I have an Airlink101 ATVUSB02 capture device that is currently not
working. The product page can be found at
http://www.airlink101.com/products/atvusb02.php. I am using Ubuntu
8.10(Intrepid), kernel 2.6.27-15-generic, and as-of 10/27/09, the latest
v4l-dvb.

dmesg:
[  491.352065] usb 3-1: new high speed USB device using ehci_hcd and
address 2
[  491.492075] usb 3-1: configuration #1 chosen from 1 choice
[  491.850968] Linux video capture interface: v2.00
[  491.914702] em28xx: New device @ 480 Mbps (eb1a:2800, interface 0,
class 0)
[  491.917479] em28xx #0: em28xx chip ID = 7
[  492.068059] em28xx #0: board has no eeprom
[  492.068098] em28xx #0: Identified as Unknown EM2800 video grabber
(card=0)
[  501.352045] em28xx #0: Your board has no unique USB ID and thus need
a hint to be detected.
[  501.352089] em28xx #0: You may try to use card=<n> insmod option to
workaround that.
[  501.352096] em28xx #0: Please send an email with this log to:
[  501.352102] em28xx #0: 	V4L Mailing List
<linux-media@vger.kernel.org>
[  501.352108] em28xx #0: Board eeprom hash is 0x00000000
[  501.352113] em28xx #0: Board i2c devicelist hash is 0x1b800080
[  501.352119] em28xx #0: Here is a list of valid choices for the
card=<n> insmod option:
[  501.352127] em28xx #0:     card=0 -> Unknown EM2800 video grabber
[  501.352134] em28xx #0:     card=1 -> Unknown EM2750/28xx video
grabber
[  501.352140] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
[  501.352145] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
[  501.352151] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
[  501.352156] em28xx #0:     card=5 -> MSI VOX USB 2.0
[  501.352161] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
[  501.352167] em28xx #0:     card=7 -> Leadtek Winfast USB II
[  501.352172] em28xx #0:     card=8 -> Kworld USB2800
[  501.352178] em28xx #0:     card=9 -> Pinnacle Dazzle DVC
90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2
[  501.352186] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
[  501.352192] em28xx #0:     card=11 -> Terratec Hybrid XS
[  501.352197] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
[  501.352203] em28xx #0:     card=13 -> Terratec Prodigy XS
[  501.352208] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview
Prolink PlayTV USB 2.0
[  501.352216] em28xx #0:     card=15 -> V-Gear PocketTV
[  501.352221] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
[  501.352226] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[  501.352232] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[  501.352238] em28xx #0:     card=19 -> EM2860/SAA711X Reference Design
[  501.352244] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
[  501.352250] em28xx #0:     card=21 -> eMPIA Technology, Inc. GrabBeeX
+ Video Encoder
[  501.352257] em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam
grabber
[  501.352263] em28xx #0:     card=23 -> Huaqi DLCW-130
[  501.352268] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
[  501.352273] em28xx #0:     card=25 -> Gadmei UTV310
[  501.352279] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
[  501.352284] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips
FM1216ME)
[  501.352291] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
[  501.352297] em28xx #0:     card=29 -> <NULL>
[  501.352302] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
[  501.352307] em28xx #0:     card=31 -> Usbgear VD204v9
[  501.352313] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
[  501.352318] em28xx #0:     card=33 -> <NULL>
[  501.352323] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
[  501.352329] em28xx #0:     card=35 -> Typhoon DVD Maker
[  501.352334] em28xx #0:     card=36 -> NetGMBH Cam
[  501.352339] em28xx #0:     card=37 -> Gadmei UTV330
[  501.352344] em28xx #0:     card=38 -> Yakumo MovieMixer
[  501.352350] em28xx #0:     card=39 -> KWorld PVRTV 300U
[  501.352355] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
[  501.352361] em28xx #0:     card=41 -> Kworld 350 U DVB-T
[  501.352366] em28xx #0:     card=42 -> Kworld 355 U DVB-T
[  501.352371] em28xx #0:     card=43 -> Terratec Cinergy T XS
[  501.352377] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[  501.352382] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
[  501.352388] em28xx #0:     card=46 -> Compro, VideoMate U3
[  501.352393] em28xx #0:     card=47 -> KWorld DVB-T 305U
[  501.352398] em28xx #0:     card=48 -> KWorld DVB-T 310U
[  501.352404] em28xx #0:     card=49 -> MSI DigiVox A/D
[  501.352409] em28xx #0:     card=50 -> MSI DigiVox A/D II
[  501.352414] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
[  501.352420] em28xx #0:     card=52 -> DNT DA2 Hybrid
[  501.352425] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
[  501.352430] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
[  501.352436] em28xx #0:     card=55 -> Terratec Hybrid XS (em2882)
[  501.352442] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (2)
[  501.352448] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[  501.352454] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
[  501.352459] em28xx #0:     card=59 -> <NULL>
[  501.352464] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
[  501.352470] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[  501.352475] em28xx #0:     card=62 -> Gadmei TVR200
[  501.352480] em28xx #0:     card=63 -> Kaiomy TVnPC U2
[  501.352486] em28xx #0:     card=64 -> Easy Cap Capture DC-60
[  501.352491] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
[  501.352496] em28xx #0:     card=66 -> Empire dual TV
[  501.352502] em28xx #0:     card=67 -> Terratec Grabby
[  501.352507] em28xx #0:     card=68 -> Terratec AV350
[  501.352512] em28xx #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[  501.352518] em28xx #0:     card=70 -> Evga inDtube
[  501.352523] em28xx #0:     card=71 -> Silvercrest Webcam 1.3mpix
[  501.352529] em28xx #0:     card=72 -> Gadmei UTV330+
[  501.352534] em28xx #0:     card=73 -> Reddo DVB-C USB TV Box
[  501.716278] em28xx #0: Config register raw data: 0xeb
[  501.716290] em28xx #0: I2S Audio (3 sample rates)
[  501.716295] em28xx #0: No AC97 audio processor
[  501.780067] em28xx #0: v4l2 driver version 0.1.2
[  502.216763] em28xx #0: V4L2 video device registered as /dev/video0
[  502.218126] usbcore: registered new interface driver em28xx
[  502.236045] em28xx driver loaded
[  502.289388] em28xx-audio.c: probing for em28x1 non standard usbaudio
[  502.289402] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
[  502.290323] Em28xx: Initialized (Em28xx Audio Extension) extension
[  503.280058] usbcore: selecting invalid altsetting 7

lsusb:
Bus 003 Device 002: ID eb1a:2800 eMPIA Technology, Inc. Terratec Cinergy
200
Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 001 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub

Any help is appreciated.

