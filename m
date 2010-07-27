Return-path: <linux-media-owner@vger.kernel.org>
Received: from server1.velnet.net ([94.102.147.194]:46600 "EHLO
	server1.velnet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703Ab0G0KHf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jul 2010 06:07:35 -0400
Received: from host83-217-168-208.dsl.vispa.com ([83.217.168.208] helo=comerford.org.uk)
	by server1.velnet.net with esmtp (Exim 4.69)
	(envelope-from <jim@comerford.org.uk>)
	id 1OdgMS-0005BW-Oy
	for linux-media@vger.kernel.org; Tue, 27 Jul 2010 10:22:09 +0100
Received: from [192.168.2.6] ([83.217.168.208]) by comerford.org.uk ([192.168.2.3] running VPOP3) with ESMTP for <linux-media@vger.kernel.org>; Tue, 27 Jul 2010 10:22:06 +0100
Message-ID: <4C4EA53E.9030703@comerford.org.uk>
Date: Tue, 27 Jul 2010 10:22:06 +0100
From: Jim Comerford <jim@comerford.org.uk>
MIME-Version: 1.0
To: V4L Mailing List <linux-media@vger.kernel.org>
Subject: dmesg log - unknown USB video grabber
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I recently bought a Video Grabber USB stick.
The unit works with Windows XP and is supplied with a driver for it. I 
hoped that I could get it to work with Linux.

It is made by AGK Nordic and is model 3015. Below is a copy of the 
relevant lines from dmesg after inserting it.

Regards,
Jim Comerford

[ 2082.744121] usb 1-1: new high speed USB device using ehci_hcd and 
address 6
[ 2082.877991] usb 1-1: configuration #1 chosen from 1 choice
[ 2082.878502] em28xx: New device @ 480 Mbps (eb1a:2861, interface 0, 
class 0)
[ 2082.878711] em28xx #0: chip ID is em2860
[ 2082.968804] em28xx #0: board has no eeprom
[ 2082.980570] em28xx #0: Identified as Unknown EM2750/28xx video 
grabber (card=1)
[ 2083.016565] em28xx #0: found i2c device @ 0xb8 [tvp5150a]
[ 2083.029944] em28xx #0: Your board has no unique USB ID and thus need 
a hint to be detected.
[ 2083.029961] em28xx #0: You may try to use card=<n> insmod option to 
workaround that.
[ 2083.029973] em28xx #0: Please send an email with this log to:
[ 2083.029982] em28xx #0:     V4L Mailing List <linux-media@vger.kernel.org>
[ 2083.029992] em28xx #0: Board eeprom hash is 0x00000000
[ 2083.030002] em28xx #0: Board i2c devicelist hash is 0x77800080
[ 2083.030011] em28xx #0: Here is a list of valid choices for the 
card=<n> insmod option:
[ 2083.030023] em28xx #0:     card=0 -> Unknown EM2800 video grabber
[ 2083.030035] em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
[ 2083.030046] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
[ 2083.030056] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
[ 2083.030066] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
[ 2083.030075] em28xx #0:     card=5 -> MSI VOX USB 2.0
[ 2083.030085] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
[ 2083.030095] em28xx #0:     card=7 -> Leadtek Winfast USB II
[ 2083.030105] em28xx #0:     card=8 -> Kworld USB2800
[ 2083.030116] em28xx #0:     card=9 -> Pinnacle Dazzle DVC 
90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2
[ 2083.030129] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
[ 2083.030140] em28xx #0:     card=11 -> Terratec Hybrid XS
[ 2083.030150] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
[ 2083.030160] em28xx #0:     card=13 -> Terratec Prodigy XS
[ 2083.030170] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview 
Prolink PlayTV USB 2.0
[ 2083.030182] em28xx #0:     card=15 -> V-Gear PocketTV
[ 2083.030192] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
[ 2083.030202] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[ 2083.030212] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[ 2083.030223] em28xx #0:     card=19 -> EM2860/SAA711X Reference Design
[ 2083.030234] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
[ 2083.030244] em28xx #0:     card=21 -> eMPIA Technology, Inc. 
GrabBeeX+ Video Encoder
[ 2083.030256] em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam grabber
[ 2083.030266] em28xx #0:     card=23 -> Huaqi DLCW-130
[ 2083.030276] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
[ 2083.030286] em28xx #0:     card=25 -> Gadmei UTV310
[ 2083.030296] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
[ 2083.030307] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips 
FM1216ME)
[ 2083.030318] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
[ 2083.030328] em28xx #0:     card=29 -> <NULL>
[ 2083.030338] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
[ 2083.030348] em28xx #0:     card=31 -> Usbgear VD204v9
[ 2083.030358] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
[ 2083.030368] em28xx #0:     card=33 -> <NULL>
[ 2083.030377] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
[ 2083.030388] em28xx #0:     card=35 -> Typhoon DVD Maker
[ 2083.030397] em28xx #0:     card=36 -> NetGMBH Cam
[ 2083.030407] em28xx #0:     card=37 -> Gadmei UTV330
[ 2083.030417] em28xx #0:     card=38 -> Yakumo MovieMixer
[ 2083.030426] em28xx #0:     card=39 -> KWorld PVRTV 300U
[ 2083.030436] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
[ 2083.030447] em28xx #0:     card=41 -> Kworld 350 U DVB-T
[ 2083.030456] em28xx #0:     card=42 -> Kworld 355 U DVB-T
[ 2083.030466] em28xx #0:     card=43 -> Terratec Cinergy T XS
[ 2083.030477] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[ 2083.030487] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
[ 2083.030497] em28xx #0:     card=46 -> Compro, VideoMate U3
[ 2083.030507] em28xx #0:     card=47 -> KWorld DVB-T 305U
[ 2083.030517] em28xx #0:     card=48 -> KWorld DVB-T 310U
[ 2083.030527] em28xx #0:     card=49 -> MSI DigiVox A/D
[ 2083.030536] em28xx #0:     card=50 -> MSI DigiVox A/D II
[ 2083.030546] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
[ 2083.030557] em28xx #0:     card=52 -> DNT DA2 Hybrid
[ 2083.030566] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
[ 2083.030576] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
[ 2083.030586] em28xx #0:     card=55 -> Terratec Hybrid XS (em2882)
[ 2083.030597] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (2)
[ 2083.030607] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[ 2083.030618] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
[ 2083.030628] em28xx #0:     card=59 -> <NULL>
[ 2083.030637] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
[ 2083.030648] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[ 2083.030658] em28xx #0:     card=62 -> Gadmei TVR200
[ 2083.030668] em28xx #0:     card=63 -> Kaiomy TVnPC U2
[ 2083.030678] em28xx #0:     card=64 -> Easy Cap Capture DC-60
[ 2083.030688] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
[ 2083.030697] em28xx #0:     card=66 -> Empire dual TV
[ 2083.030707] em28xx #0:     card=67 -> Terratec Grabby
[ 2083.030717] em28xx #0:     card=68 -> Terratec AV350
[ 2083.030727] em28xx #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[ 2083.030737] em28xx #0:     card=70 -> Evga inDtube
[ 2083.030747] em28xx #0:     card=71 -> Silvercrest Webcam 1.3mpix
[ 2083.030757] em28xx #0:     card=72 -> Gadmei UTV330+
[ 2083.030767] em28xx #0:     card=73 -> Reddo DVB-C USB TV Box
[ 2083.030927] em28xx #0: Config register raw data: 0x10
[ 2083.052324] em28xx #0: AC97 vendor ID = 0xffffffff
[ 2083.064322] em28xx #0: AC97 features = 0x6a90
[ 2083.064334] em28xx #0: Empia 202 AC97 audio processor detected
[ 2083.476112] em28xx #0: v4l2 driver version 0.1.2
[ 2084.413128] em28xx #0: V4L2 video device registered as /dev/video1
[ 2084.413137] em28xx #0: V4L2 VBI device registered as /dev/vbi0

