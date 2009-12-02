Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:55283 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755327AbZLBXv2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Dec 2009 18:51:28 -0500
Received: by yxe17 with SMTP id 17so665769yxe.33
        for <linux-media@vger.kernel.org>; Wed, 02 Dec 2009 15:51:34 -0800 (PST)
Message-ID: <4B16FD66.6040801@gmail.com>
Date: Wed, 02 Dec 2009 18:51:02 -0500
From: Techcowboy <techcowboy77@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Super Digital Video Dazzle Series USB2.0 TV BOX - dmesg log
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[86426.568031] usb 1-2: new high speed USB device using ehci_hcd and 
address 2
[86426.700561] usb 1-2: configuration #1 chosen from 1 choice
[86426.706409] em28xx: New device @ 480 Mbps (eb1a:2821, interface 0, 
class 0)
[86426.706916] em28xx #0: chip ID is em2820 (or em2710)
[86426.805160] em28xx #0: board has no eeprom
[86426.816486] em28xx #0: Identified as Unknown EM2750/28xx video 
grabber (card=1)
[86426.832737] em28xx #0: found i2c device @ 0x4a [saa7113h]
[86426.836982] em28xx #0: found i2c device @ 0x60 [remote IR sensor]
[86426.855359] em28xx #0: found i2c device @ 0xc2 [tuner (analog)]
[86426.856226] em28xx #0: found i2c device @ 0xc6 [tuner (analog)]
[86426.866735] em28xx #0: Your board has no unique USB ID and thus need 
a hint to be detected.
[86426.866744] em28xx #0: You may try to use card=<n> insmod option to 
workaround that.
[86426.866748] em28xx #0: Please send an email with this log to:
[86426.866752] em28xx #0:     V4L Mailing List <linux-media@vger.kernel.org>
[86426.866756] em28xx #0: Board eeprom hash is 0x00000000
[86426.866760] em28xx #0: Board i2c devicelist hash is 0xf53100e3
[86426.866763] em28xx #0: Here is a list of valid choices for the 
card=<n> insmod option:
[86426.866768] em28xx #0:     card=0 -> Unknown EM2800 video grabber
[86426.866773] em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
[86426.866777] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
[86426.866782] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
[86426.866786] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
[86426.866790] em28xx #0:     card=5 -> MSI VOX USB 2.0
[86426.866794] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
[86426.866798] em28xx #0:     card=7 -> Leadtek Winfast USB II
[86426.866802] em28xx #0:     card=8 -> Kworld USB2800
[86426.866807] em28xx #0:     card=9 -> Pinnacle Dazzle DVC 
90/100/101/107 / Kaiser Baas Video to DVD maker
[86426.866812] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
[86426.866816] em28xx #0:     card=11 -> Terratec Hybrid XS
[86426.866820] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
[86426.866824] em28xx #0:     card=13 -> Terratec Prodigy XS
[86426.866829] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview 
Prolink PlayTV USB 2.0
[86426.866834] em28xx #0:     card=15 -> V-Gear PocketTV
[86426.866838] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
[86426.866842] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[86426.866846] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[86426.866851] em28xx #0:     card=19 -> EM2860/SAA711X Reference Design
[86426.866855] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
[86426.866860] em28xx #0:     card=21 -> eMPIA Technology, Inc. 
GrabBeeX+ Video Encoder
[86426.866864] em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam grabber
[86426.866869] em28xx #0:     card=23 -> Huaqi DLCW-130
[86426.866873] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
[86426.866877] em28xx #0:     card=25 -> Gadmei UTV310
[86426.866881] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
[86426.866886] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips 
FM1216ME)
[86426.866890] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
[86426.866895] em28xx #0:     card=29 -> <NULL>
[86426.866899] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
[86426.866903] em28xx #0:     card=31 -> Usbgear VD204v9
[86426.866907] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
[86426.866911] em28xx #0:     card=33 -> <NULL>
[86426.866915] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
[86426.866919] em28xx #0:     card=35 -> Typhoon DVD Maker
[86426.866923] em28xx #0:     card=36 -> NetGMBH Cam
[86426.866927] em28xx #0:     card=37 -> Gadmei UTV330
[86426.866932] em28xx #0:     card=38 -> Yakumo MovieMixer
[86426.866936] em28xx #0:     card=39 -> KWorld PVRTV 300U
[86426.866940] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
[86426.866944] em28xx #0:     card=41 -> Kworld 350 U DVB-T
[86426.866948] em28xx #0:     card=42 -> Kworld 355 U DVB-T
[86426.866952] em28xx #0:     card=43 -> Terratec Cinergy T XS
[86426.866957] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[86426.866961] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
[86426.866965] em28xx #0:     card=46 -> Compro, VideoMate U3
[86426.866969] em28xx #0:     card=47 -> KWorld DVB-T 305U
[86426.866973] em28xx #0:     card=48 -> KWorld DVB-T 310U
[86426.866978] em28xx #0:     card=49 -> MSI DigiVox A/D
[86426.866982] em28xx #0:     card=50 -> MSI DigiVox A/D II
[86426.866986] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
[86426.866990] em28xx #0:     card=52 -> DNT DA2 Hybrid
[86426.866994] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
[86426.866999] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
[86426.867003] em28xx #0:     card=55 -> Terratec Hybrid XS (em2882)
[86426.867007] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (2)
[86426.867012] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[86426.867016] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
[86426.867021] em28xx #0:     card=59 -> <NULL>
[86426.867025] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
[86426.867029] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[86426.867033] em28xx #0:     card=62 -> Gadmei TVR200
[86426.867037] em28xx #0:     card=63 -> Kaiomy TVnPC U2
[86426.867041] em28xx #0:     card=64 -> Easy Cap Capture DC-60
[86426.867046] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
[86426.867050] em28xx #0:     card=66 -> Empire dual TV
[86426.867054] em28xx #0:     card=67 -> Terratec Grabby
[86426.867058] em28xx #0:     card=68 -> Terratec AV350
[86426.867062] em28xx #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[86426.867066] em28xx #0:     card=70 -> Evga inDtube
[86426.867070] em28xx #0:     card=71 -> Silvercrest Webcam 1.3mpix
[86426.867232] em28xx #0: Config register raw data: 0x10
[86426.888244] em28xx #0: AC97 vendor ID = 0xffffffff
[86426.900240] em28xx #0: AC97 features = 0x6a90
[86426.900245] em28xx #0: Empia 202 AC97 audio processor detected
[86427.312025] em28xx #0: v4l2 driver version 0.1.2
[86428.156227] em28xx #0: V4L2 device registered as /dev/video0 and 
/dev/vbi0
[86428.162433] em28xx audio device (eb1a:2821): interface 1, class 1

