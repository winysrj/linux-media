Return-path: <mchehab@gaivota>
Received: from blu0-omc2-s16.blu0.hotmail.com ([65.55.111.91]:31115 "EHLO
	blu0-omc2-s16.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751822Ab1ACUgT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Jan 2011 15:36:19 -0500
Message-ID: <BLU0-SMTP1271CDC20CA3A83DD5F907DBD070@phx.gbl>
Date: Mon, 3 Jan 2011 21:30:04 +0100
From: javier <jyjyr@hotmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

dmesg | grep bt
[   13.145402] usbcore: registered new interface driver btusb
javier@javier-desktop:~$ dmesg | grep -i9 tuner
[ 2283.004191] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[ 2283.004215] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x516cc51d
[ 2283.004219] em28xx #0: EEPROM info:
[ 2283.004223] em28xx #0:    AC97 audio (5 sample rates)
[ 2283.004226] em28xx #0:    500mA max power
[ 2283.004231] em28xx #0:    Table at 0x24, strings=0x226a, 0x108c, 0x0000
[ 2283.007555] em28xx #0: Identified as Unknown EM2750/28xx video 
grabber (card=1)
[ 2283.050116] em28xx #0: found i2c device @ 0xa0 [eeprom]
[ 2283.054615] em28xx #0: found i2c device @ 0xb8 [tvp5150a]
[ 2283.056485] em28xx #0: found i2c device @ 0xc2 [tuner (analog)]
[ 2283.067732] em28xx #0: Your board has no unique USB ID and thus need 
a hint to be detected.
[ 2283.067746] em28xx #0: You may try to use card=<n> insmod option to 
workaround that.
[ 2283.067751] em28xx #0: Please send an email with this log to:
[ 2283.067755] em28xx #0:     V4L Mailing List <linux-media@vger.kernel.org>
[ 2283.067760] em28xx #0: Board eeprom hash is 0x516cc51d
[ 2283.067764] em28xx #0: Board i2c devicelist hash is 0x27e10080
[ 2283.067769] em28xx #0: Here is a list of valid choices for the 
card=<n> insmod option:
[ 2283.067775] em28xx #0:     card=0 -> Unknown EM2800 video grabber
[ 2283.067780] em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
--
[ 2283.067799] em28xx #0:     card=5 -> MSI VOX USB 2.0
[ 2283.067803] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
[ 2283.067808] em28xx #0:     card=7 -> Leadtek Winfast USB II
[ 2283.067813] em28xx #0:     card=8 -> Kworld USB2800
[ 2283.067818] em28xx #0:     card=9 -> Pinnacle Dazzle DVC 
90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2
[ 2283.067825] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
[ 2283.067829] em28xx #0:     card=11 -> Terratec Hybrid XS
[ 2283.067834] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
[ 2283.067838] em28xx #0:     card=13 -> Terratec Prodigy XS
[ 2283.067843] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview 
Prolink PlayTV USB 2.0
[ 2283.067849] em28xx #0:     card=15 -> V-Gear PocketTV
[ 2283.067853] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
[ 2283.067858] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[ 2283.067862] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[ 2283.067867] em28xx #0:     card=19 -> EM2860/SAA711X Reference Design
[ 2283.067872] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
[ 2283.067877] em28xx #0:     card=21 -> eMPIA Technology, Inc. 
GrabBeeX+ Video Encoder
[ 2283.067882] em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam grabber
[ 2283.067887] em28xx #0:     card=23 -> Huaqi DLCW-130
[ 2283.067891] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
[ 2283.067896] em28xx #0:     card=25 -> Gadmei UTV310
[ 2283.067900] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
[ 2283.067905] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips 
FM1216ME)
[ 2283.067910] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
[ 2283.067915] em28xx #0:     card=29 -> <NULL>
[ 2283.067919] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
[ 2283.067924] em28xx #0:     card=31 -> Usbgear VD204v9
[ 2283.067928] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
[ 2283.067932] em28xx #0:     card=33 -> <NULL>

