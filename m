Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.alsatis.com ([92.245.148.1]:59430 "EHLO mail.alsatis.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701AbaC1U3Y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Mar 2014 16:29:24 -0400
Received: from localhost (als02.fullsave.info [193.84.73.137])
	by mail.alsatis.net (Postfix) with ESMTP id 3038B11D1918
	for <linux-media@vger.kernel.org>; Fri, 28 Mar 2014 21:21:30 +0100 (CET)
Received: from mail.alsatis.net ([127.0.0.1])
	by localhost (als02.fullsave.info [127.0.0.1]) (amavisd-new, port 10025)
	with ESMTP id SUnYrBdyKqwn for <linux-media@vger.kernel.org>;
	Fri, 28 Mar 2014 21:21:27 +0100 (CET)
To: <linux-media@vger.kernel.org>
Subject: em2750 usb camera log as mentioned in dmesg
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Fri, 28 Mar 2014 21:21:27 +0100
From: aaron.moore@alsatis.net
Message-ID: <4e07daf2c73e2a12ab4b9ba812b8bc73@alsatis.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have endless problems since upgarding to ubuntu12.04 with my usb 
microscope and it's a big problem cos i need it for work.

As suggested in dmesg I have sent you the log..  Interestingly the 
em2750 camera is Ok on my desk pc with Xubuntu 12.04...  go figure.. But 
the desk pC is kinda hard to carry to customer sites.

I hope to find a solution soon

thanks

Aaron

[12699.292580] em28xx: New device   @ 480 Mbps (eb1a:2750, interface 0, 
class 0)
[12699.292585] em28xx: Video interface 0 found: isoc
[12699.292636] em28xx: chip ID is em2750
[12699.476200] em2750 #0: board has no eeprom
[12699.547792] em2750 #0: No sensor detected
[12699.583014] em2750 #0: found i2c device @ 0xba on bus 0 [webcam 
sensor or tvp5150a]
[12699.595736] em2750 #0: Your board has no unique USB ID and thus need 
a hint to be detected.
[12699.595742] em2750 #0: You may try to use card=<n> insmod option to 
workaround that.
[12699.595746] em2750 #0: Please send an email with this log to:
[12699.595749] em2750 #0: 	V4L Mailing List 
<linux-media@vger.kernel.org>
[12699.595752] em2750 #0: Board eeprom hash is 0x00000000
[12699.595756] em2750 #0: Board i2c devicelist hash is 0x1bdd0080
[12699.595759] em2750 #0: Here is a list of valid choices for the 
card=<n> insmod option:
[12699.595764] em2750 #0:     card=0 -> Unknown EM2800 video grabber
[12699.595768] em2750 #0:     card=1 -> Unknown EM2750/28xx video 
grabber
[12699.595772] em2750 #0:     card=2 -> Terratec Cinergy 250 USB
[12699.595776] em2750 #0:     card=3 -> Pinnacle PCTV USB 2
[12699.595779] em2750 #0:     card=4 -> Hauppauge WinTV USB 2
[12699.595783] em2750 #0:     card=5 -> MSI VOX USB 2.0
[12699.595786] em2750 #0:     card=6 -> Terratec Cinergy 200 USB
[12699.595790] em2750 #0:     card=7 -> Leadtek Winfast USB II
[12699.595793] em2750 #0:     card=8 -> Kworld USB2800
[12699.595798] em2750 #0:     card=9 -> Pinnacle Dazzle DVC 
90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2 / 
Plextor ConvertX PX-AV100U
[12699.595802] em2750 #0:     card=10 -> Hauppauge WinTV HVR 900
[12699.595805] em2750 #0:     card=11 -> Terratec Hybrid XS
[12699.595809] em2750 #0:     card=12 -> Kworld PVR TV 2800 RF
[12699.595812] em2750 #0:     card=13 -> Terratec Prodigy XS
[12699.595816] em2750 #0:     card=14 -> SIIG AVTuner-PVR / Pixelview 
Prolink PlayTV USB 2.0
[12699.595819] em2750 #0:     card=15 -> V-Gear PocketTV
[12699.595823] em2750 #0:     card=16 -> Hauppauge WinTV HVR 950
[12699.595827] em2750 #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[12699.595830] em2750 #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[12699.595834] em2750 #0:     card=19 -> EM2860/SAA711X Reference 
Design
[12699.595838] em2750 #0:     card=20 -> AMD ATI TV Wonder HD 600
[12699.595841] em2750 #0:     card=21 -> eMPIA Technology, Inc. 
GrabBeeX+ Video Encoder
[12699.595845] em2750 #0:     card=22 -> EM2710/EM2750/EM2751 webcam 
grabber
[12699.595849] em2750 #0:     card=23 -> Huaqi DLCW-130
[12699.595852] em2750 #0:     card=24 -> D-Link DUB-T210 TV Tuner
[12699.595856] em2750 #0:     card=25 -> Gadmei UTV310
[12699.595859] em2750 #0:     card=26 -> Hercules Smart TV USB 2.0
[12699.595863] em2750 #0:     card=27 -> Pinnacle PCTV USB 2 (Philips 
FM1216ME)
[12699.595867] em2750 #0:     card=28 -> Leadtek Winfast USB II Deluxe
[12699.595870] em2750 #0:     card=29 -> EM2860/TVP5150 Reference 
Design
[12699.595874] em2750 #0:     card=30 -> Videology 20K14XUSB USB2.0
[12699.595877] em2750 #0:     card=31 -> Usbgear VD204v9
[12699.595881] em2750 #0:     card=32 -> Supercomp USB 2.0 TV
[12699.595884] em2750 #0:     card=33 -> Elgato Video Capture
[12699.595888] em2750 #0:     card=34 -> Terratec Cinergy A Hybrid XS
[12699.595891] em2750 #0:     card=35 -> Typhoon DVD Maker
[12699.595895] em2750 #0:     card=36 -> NetGMBH Cam
[12699.595898] em2750 #0:     card=37 -> Gadmei UTV330
[12699.595902] em2750 #0:     card=38 -> Yakumo MovieMixer
[12699.595906] em2750 #0:     card=39 -> KWorld PVRTV 300U
[12699.595909] em2750 #0:     card=40 -> Plextor ConvertX PX-TV100U
[12699.595913] em2750 #0:     card=41 -> Kworld 350 U DVB-T
[12699.595916] em2750 #0:     card=42 -> Kworld 355 U DVB-T
[12699.595920] em2750 #0:     card=43 -> Terratec Cinergy T XS
[12699.595924] em2750 #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[12699.595927] em2750 #0:     card=45 -> Pinnacle PCTV DVB-T
[12699.595931] em2750 #0:     card=46 -> Compro, VideoMate U3
[12699.595934] em2750 #0:     card=47 -> KWorld DVB-T 305U
[12699.595938] em2750 #0:     card=48 -> KWorld DVB-T 310U
[12699.595941] em2750 #0:     card=49 -> MSI DigiVox A/D
[12699.595945] em2750 #0:     card=50 -> MSI DigiVox A/D II
[12699.595948] em2750 #0:     card=51 -> Terratec Hybrid XS Secam
[12699.595952] em2750 #0:     card=52 -> DNT DA2 Hybrid
[12699.595955] em2750 #0:     card=53 -> Pinnacle Hybrid Pro
[12699.595959] em2750 #0:     card=54 -> Kworld VS-DVB-T 323UR
[12699.595963] em2750 #0:     card=55 -> Terratec Cinnergy Hybrid T USB 
XS (em2882)
[12699.595966] em2750 #0:     card=56 -> Pinnacle Hybrid Pro (330e)
[12699.595970] em2750 #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[12699.595973] em2750 #0:     card=58 -> Compro VideoMate ForYou/Stereo
[12699.595977] em2750 #0:     card=59 -> Pinnacle PCTV HD Mini
[12699.595981] em2750 #0:     card=60 -> Hauppauge WinTV HVR 850
[12699.595984] em2750 #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[12699.595988] em2750 #0:     card=62 -> Gadmei TVR200
[12699.595991] em2750 #0:     card=63 -> Kaiomy TVnPC U2
[12699.595995] em2750 #0:     card=64 -> Easy Cap Capture DC-60
[12699.595998] em2750 #0:     card=65 -> IO-DATA GV-MVP/SZ
[12699.596002] em2750 #0:     card=66 -> Empire dual TV
[12699.596006] em2750 #0:     card=67 -> Terratec Grabby
[12699.596009] em2750 #0:     card=68 -> Terratec AV350
[12699.596013] em2750 #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[12699.596016] em2750 #0:     card=70 -> Evga inDtube
[12699.596020] em2750 #0:     card=71 -> Silvercrest Webcam 1.3mpix
[12699.596023] em2750 #0:     card=72 -> Gadmei UTV330+
[12699.596027] em2750 #0:     card=73 -> Reddo DVB-C USB TV Box
[12699.596031] em2750 #0:     card=74 -> Actionmaster/LinXcel/Digitus 
VC211A
[12699.596034] em2750 #0:     card=75 -> Dikom DK300
[12699.596038] em2750 #0:     card=76 -> KWorld PlusTV 340U or UB435-Q 
(ATSC)
[12699.596041] em2750 #0:     card=77 -> EM2874 Leadership ISDBT
[12699.596045] em2750 #0:     card=78 -> PCTV nanoStick T2 290e
[12699.596048] em2750 #0:     card=79 -> Terratec Cinergy H5
[12699.596052] em2750 #0:     card=80 -> PCTV DVB-S2 Stick (460e)
[12699.596055] em2750 #0:     card=81 -> Hauppauge WinTV HVR 930C
[12699.596059] em2750 #0:     card=82 -> Terratec Cinergy HTC Stick
[12699.596062] em2750 #0:     card=83 -> Honestech Vidbox NW03
[12699.596066] em2750 #0:     card=84 -> MaxMedia UB425-TC
[12699.596070] em2750 #0:     card=85 -> PCTV QuatroStick (510e)
[12699.596073] em2750 #0:     card=86 -> PCTV QuatroStick nano (520e)
[12699.596077] em2750 #0:     card=87 -> Terratec Cinergy HTC USB XS
[12699.596080] em2750 #0:     card=88 -> C3 Tech Digital Duo HDTV/SDTV 
USB
[12699.596084] em2750 #0:     card=89 -> Delock 61959
[12699.596088] em2750 #0:     card=90 -> KWorld USB ATSC TV Stick 
UB435-Q V2
[12699.596091] em2750 #0:     card=91 -> SpeedLink Vicious And Devine 
Laplace webcam
[12699.596095] em2750 #0:     card=92 -> PCTV DVB-S2 Stick (461e)
[12699.596099] em2750 #0:     card=93 -> KWorld USB ATSC TV Stick 
UB435-Q V3
[12699.596102] em2750 #0: Board not discovered
[12699.596106] em2750 #0: Identified as EM2710/EM2750/EM2751 webcam 
grabber (card=22)
[12699.596110] em2750 #0: analog set to isoc mode.
[12699.596121] em2750 #0: Registering V4L2 extension
[12700.063509] em2750 #0: V4L2 video device registered as video1
[12700.063518] em2750 #0: V4L2 extension successfully initialized
wjaelectron@wjaelectron-Aspire-3820:~$
