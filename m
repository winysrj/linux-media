Return-path: <mchehab@pedra>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63132 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab0HIUwR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Aug 2010 16:52:17 -0400
Received: by gxk23 with SMTP id 23so3568799gxk.19
        for <linux-media@vger.kernel.org>; Mon, 09 Aug 2010 13:52:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTin1sY6U3WPmG9XKPKK5wKmpPJkpWOL4bbQG0=b_@mail.gmail.com>
References: <AANLkTin1sY6U3WPmG9XKPKK5wKmpPJkpWOL4bbQG0=b_@mail.gmail.com>
From: Lars Sarauw Hansen <sarauw76@gmail.com>
Date: Mon, 9 Aug 2010 22:51:56 +0200
Message-ID: <AANLkTikFaZxZDnuseLZH97UuPENd91RKj=ArJiE3Gzht@mail.gmail.com>
Subject: Unknown EM2750/28xx video grabber - dmesg output
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

As requested, I'm sending my dmesg output when connecting an external
TV-grabber box.
I got the box from my dad and he really can't remember how he got it.
It seems to be quite decent quality - yet it is only labeled "USB 2.0
TV BOX". IMHO a truly no-name grabber :-)

Hopefully it can be identified as one of the existing cards from the
list in dmesg.

Here goes:
[249160.380080] usb 1-4: new high speed USB device using ehci_hcd and address 7
[249160.530722] usb 1-4: configuration #1 chosen from 1 choice
[249160.615476] Linux video capture interface: v2.00
[249160.635939] em28xx: New device @ 480 Mbps (eb1a:2820, interface 0, class 0)
[249160.636101] em28xx #0: chip ID is em2820 (or em2710)
[249160.794940] em28xx #0: i2c eeprom 00: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[249160.794947] em28xx #0: i2c eeprom 10: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[249160.794952] em28xx #0: i2c eeprom 20: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[249160.794958] em28xx #0: i2c eeprom 30: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[249160.794963] em28xx #0: i2c eeprom 40: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[249160.794968] em28xx #0: i2c eeprom 50: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[249160.794973] em28xx #0: i2c eeprom 60: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[249160.794977] em28xx #0: i2c eeprom 70: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[249160.794982] em28xx #0: i2c eeprom 80: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[249160.794987] em28xx #0: i2c eeprom 90: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[249160.794992] em28xx #0: i2c eeprom a0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[249160.794997] em28xx #0: i2c eeprom b0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[249160.795002] em28xx #0: i2c eeprom c0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[249160.795007] em28xx #0: i2c eeprom d0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[249160.795012] em28xx #0: i2c eeprom e0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[249160.795017] em28xx #0: i2c eeprom f0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[249160.795023] em28xx #0: EEPROM ID= 0xffffffff, EEPROM hash = 0x00000000
[249160.795024] em28xx #0: EEPROM info:
[249160.795025] em28xx #0:	I2S audio, 3 sample rates
[249160.795026] em28xx #0:	USB Remote wakeup capable
[249160.795027] em28xx #0:	USB Self power capable
[249160.795028] em28xx #0:	200mA max power
[249160.795030] em28xx #0:	Table at 0xff, strings=0xffff, 0xffff, 0xffff
[249160.811443] Unknown Micron Sensor 0x00ff
[249160.811445] em28xx #0: Identified as Unknown EM2750/28xx video
grabber (card=1)
[249160.825687] em28xx #0: found i2c device @ 0x4a [saa7113h]
[249160.841817] em28xx #0: found i2c device @ 0xa0 [eeprom]
[249160.846685] em28xx #0: found i2c device @ 0xba [webcam sensor or tvp5150a]
[249160.848931] em28xx #0: found i2c device @ 0xc6 [tuner (analog)]
[249160.859431] em28xx #0: Your board has no unique USB ID and thus
need a hint to be detected.
[249160.859433] em28xx #0: You may try to use card=<n> insmod option
to workaround that.
[249160.859435] em28xx #0: Please send an email with this log to:
[249160.859436] em28xx #0: 	V4L Mailing List <linux-media@vger.kernel.org>
[249160.859437] em28xx #0: Board eeprom hash is 0x00000000
[249160.859439] em28xx #0: Board i2c devicelist hash is 0x156500e3
[249160.859440] em28xx #0: Here is a list of valid choices for the
card=<n> insmod option:
[249160.859442] em28xx #0:     card=0 -> Unknown EM2800 video grabber
[249160.859443] em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
[249160.859445] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
[249160.859446] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
[249160.859448] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
[249160.859449] em28xx #0:     card=5 -> MSI VOX USB 2.0
[249160.859450] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
[249160.859452] em28xx #0:     card=7 -> Leadtek Winfast USB II
[249160.859453] em28xx #0:     card=8 -> Kworld USB2800
[249160.859455] em28xx #0:     card=9 -> Pinnacle Dazzle DVC
90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2
[249160.859457] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
[249160.859458] em28xx #0:     card=11 -> Terratec Hybrid XS
[249160.859460] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
[249160.859461] em28xx #0:     card=13 -> Terratec Prodigy XS
[249160.859462] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview
Prolink PlayTV USB 2.0
[249160.859464] em28xx #0:     card=15 -> V-Gear PocketTV
[249160.859465] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
[249160.859467] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[249160.859468] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[249160.859470] em28xx #0:     card=19 -> EM2860/SAA711X Reference Design
[249160.859471] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
[249160.859473] em28xx #0:     card=21 -> eMPIA Technology, Inc.
GrabBeeX+ Video Encoder
[249160.859474] em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam grabber
[249160.859476] em28xx #0:     card=23 -> Huaqi DLCW-130
[249160.859477] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
[249160.859478] em28xx #0:     card=25 -> Gadmei UTV310
[249160.859480] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
[249160.859481] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips FM1216ME)
[249160.859483] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
[249160.859484] em28xx #0:     card=29 -> <NULL>
[249160.859486] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
[249160.859487] em28xx #0:     card=31 -> Usbgear VD204v9
[249160.859488] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
[249160.859490] em28xx #0:     card=33 -> <NULL>
[249160.859491] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
[249160.859492] em28xx #0:     card=35 -> Typhoon DVD Maker
[249160.859493] em28xx #0:     card=36 -> NetGMBH Cam
[249160.859495] em28xx #0:     card=37 -> Gadmei UTV330
[249160.859496] em28xx #0:     card=38 -> Yakumo MovieMixer
[249160.859497] em28xx #0:     card=39 -> KWorld PVRTV 300U
[249160.859499] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
[249160.859500] em28xx #0:     card=41 -> Kworld 350 U DVB-T
[249160.859501] em28xx #0:     card=42 -> Kworld 355 U DVB-T
[249160.859503] em28xx #0:     card=43 -> Terratec Cinergy T XS
[249160.859504] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[249160.859506] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
[249160.859507] em28xx #0:     card=46 -> Compro, VideoMate U3
[249160.859508] em28xx #0:     card=47 -> KWorld DVB-T 305U
[249160.859510] em28xx #0:     card=48 -> KWorld DVB-T 310U
[249160.859511] em28xx #0:     card=49 -> MSI DigiVox A/D
[249160.859512] em28xx #0:     card=50 -> MSI DigiVox A/D II
[249160.859514] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
[249160.859515] em28xx #0:     card=52 -> DNT DA2 Hybrid
[249160.859516] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
[249160.859518] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
[249160.859519] em28xx #0:     card=55 -> Terratec Hybrid XS (em2882)
[249160.859521] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (2)
[249160.859522] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[249160.859523] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
[249160.859525] em28xx #0:     card=59 -> <NULL>
[249160.859526] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
[249160.859527] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[249160.859529] em28xx #0:     card=62 -> Gadmei TVR200
[249160.859530] em28xx #0:     card=63 -> Kaiomy TVnPC U2
[249160.859531] em28xx #0:     card=64 -> Easy Cap Capture DC-60
[249160.859533] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
[249160.859534] em28xx #0:     card=66 -> Empire dual TV
[249160.859535] em28xx #0:     card=67 -> Terratec Grabby
[249160.859537] em28xx #0:     card=68 -> Terratec AV350
[249160.859538] em28xx #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[249160.859539] em28xx #0:     card=70 -> Evga inDtube
[249160.859541] em28xx #0:     card=71 -> Silvercrest Webcam 1.3mpix
[249160.859542] em28xx #0:     card=72 -> Gadmei UTV330+
[249160.859543] em28xx #0:     card=73 -> Reddo DVB-C USB TV Box
[249160.859681] em28xx #0: Config register raw data: 0x00
[249160.859683] em28xx #0: v4l2 driver version 0.1.2
[249161.520906] em28xx #0: V4L2 video device registered as /dev/video0
[249161.520925] usbcore: registered new interface driver em28xx
[249161.520927] em28xx driver loaded

BR Lars
