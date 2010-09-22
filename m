Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:58217 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753505Ab0IVOdG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Sep 2010 10:33:06 -0400
Message-ID: <4C9A139E.3090700@gmx.de>
Date: Wed, 22 Sep 2010 16:33:02 +0200
From: Lasse Seebeck <ihez@gmx.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: AvertV Hybrid Velor HX Logfile
Content-Type: multipart/mixed;
 boundary="------------070200010204070807030105"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a multi-part message in MIME format.
--------------070200010204070807030105
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



--------------070200010204070807030105
Content-Type: text/plain;
 name="avertv_hybrid_volar_hx_log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="avertv_hybrid_volar_hx_log"

lahala@Lahala:~$ dmesg | grep em28xx
[ 1761.442492] em28xx: New device USB 2860 Device @ 480 Mbps (eb1a:2860, interface 0, class 0)
[ 1761.442673] em28xx #0: chip ID is em2860
[ 1761.570422] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 60 28 c0 00 3e 01 6a 22 00 00
[ 1761.570454] em28xx #0: i2c eeprom 10: 00 00 04 57 4e 03 00 00 60 c0 60 c0 02 02 02 02
[ 1761.570483] em28xx #0: i2c eeprom 20: 16 00 00 02 f0 10 02 00 4a 00 00 00 5b 00 00 00
[ 1761.570512] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 10 01 02 01 00 00 00 00
[ 1761.570541] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 1761.570569] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 1761.570598] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 22 03 55 00 53 00
[ 1761.570626] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 36 00 30 00 20 00 44 00
[ 1761.570655] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00 00 00 00 00 00 00
[ 1761.570683] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 1761.570712] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 1761.570740] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 1761.570769] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 1761.570797] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 1761.570825] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 1761.570853] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 1761.570885] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x8f597549
[ 1761.570890] em28xx #0: EEPROM info:
[ 1761.570894] em28xx #0:	No audio on board.
[ 1761.570898] em28xx #0:	500mA max power
[ 1761.570905] em28xx #0:	Table at 0x04, strings=0x226a, 0x0000, 0x0000
[ 1761.584548] em28xx #0: Identified as Unknown EM2750/28xx video grabber (card=1)
[ 1761.599536] em28xx #0: found i2c device @ 0x4a [saa7113h]
[ 1761.616021] em28xx #0: found i2c device @ 0xa0 [eeprom]
[ 1761.623280] em28xx #0: found i2c device @ 0xc2 [tuner (analog)]
[ 1761.635532] em28xx #0: Your board has no unique USB ID and thus need a hint to be detected.
[ 1761.635541] em28xx #0: You may try to use card=<n> insmod option to workaround that.
[ 1761.635546] em28xx #0: Please send an email with this log to:
[ 1761.635551] em28xx #0: 	V4L Mailing List <linux-media@vger.kernel.org>
[ 1761.635557] em28xx #0: Board eeprom hash is 0x8f597549
[ 1761.635562] em28xx #0: Board i2c devicelist hash is 0x6bc40080
[ 1761.635567] em28xx #0: Here is a list of valid choices for the card=<n> insmod option:
[ 1761.635574] em28xx #0:     card=0 -> Unknown EM2800 video grabber
[ 1761.635580] em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
[ 1761.635586] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
[ 1761.635591] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
[ 1761.635597] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
[ 1761.635602] em28xx #0:     card=5 -> MSI VOX USB 2.0
[ 1761.635607] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
[ 1761.635613] em28xx #0:     card=7 -> Leadtek Winfast USB II
[ 1761.635619] em28xx #0:     card=8 -> Kworld USB2800
[ 1761.635624] em28xx #0:     card=9 -> Pinnacle Dazzle DVC 90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2
[ 1761.635631] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
[ 1761.635637] em28xx #0:     card=11 -> Terratec Hybrid XS
[ 1761.635642] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
[ 1761.635648] em28xx #0:     card=13 -> Terratec Prodigy XS
[ 1761.635654] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview Prolink PlayTV USB 2.0
[ 1761.635660] em28xx #0:     card=15 -> V-Gear PocketTV
[ 1761.635665] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
[ 1761.635670] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[ 1761.635676] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[ 1761.635682] em28xx #0:     card=19 -> EM2860/SAA711X Reference Design
[ 1761.635688] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
[ 1761.635693] em28xx #0:     card=21 -> eMPIA Technology, Inc. GrabBeeX+ Video Encoder
[ 1761.635700] em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam grabber
[ 1761.635705] em28xx #0:     card=23 -> Huaqi DLCW-130
[ 1761.635711] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
[ 1761.635717] em28xx #0:     card=25 -> Gadmei UTV310
[ 1761.635722] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
[ 1761.635728] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips FM1216ME)
[ 1761.635734] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
[ 1761.635740] em28xx #0:     card=29 -> <NULL>
[ 1761.635746] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
[ 1761.635752] em28xx #0:     card=31 -> Usbgear VD204v9
[ 1761.635757] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
[ 1761.635763] em28xx #0:     card=33 -> <NULL>
[ 1761.635768] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
[ 1761.635774] em28xx #0:     card=35 -> Typhoon DVD Maker
[ 1761.635780] em28xx #0:     card=36 -> NetGMBH Cam
[ 1761.635785] em28xx #0:     card=37 -> Gadmei UTV330
[ 1761.635790] em28xx #0:     card=38 -> Yakumo MovieMixer
[ 1761.635796] em28xx #0:     card=39 -> KWorld PVRTV 300U
[ 1761.635802] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
[ 1761.635807] em28xx #0:     card=41 -> Kworld 350 U DVB-T
[ 1761.635813] em28xx #0:     card=42 -> Kworld 355 U DVB-T
[ 1761.635819] em28xx #0:     card=43 -> Terratec Cinergy T XS
[ 1761.635824] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[ 1761.635830] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
[ 1761.635836] em28xx #0:     card=46 -> Compro, VideoMate U3
[ 1761.635842] em28xx #0:     card=47 -> KWorld DVB-T 305U
[ 1761.635847] em28xx #0:     card=48 -> KWorld DVB-T 310U
[ 1761.635853] em28xx #0:     card=49 -> MSI DigiVox A/D
[ 1761.635858] em28xx #0:     card=50 -> MSI DigiVox A/D II
[ 1761.635864] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
[ 1761.635870] em28xx #0:     card=52 -> DNT DA2 Hybrid
[ 1761.635875] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
[ 1761.635881] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
[ 1761.635886] em28xx #0:     card=55 -> Terratec Hybrid XS (em2882)
[ 1761.635892] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (2)
[ 1761.635898] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[ 1761.635904] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
[ 1761.635910] em28xx #0:     card=59 -> <NULL>
[ 1761.635915] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
[ 1761.635921] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[ 1761.635927] em28xx #0:     card=62 -> Gadmei TVR200
[ 1761.635932] em28xx #0:     card=63 -> Kaiomy TVnPC U2
[ 1761.635938] em28xx #0:     card=64 -> Easy Cap Capture DC-60
[ 1761.635943] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
[ 1761.635949] em28xx #0:     card=66 -> Empire dual TV
[ 1761.635954] em28xx #0:     card=67 -> Terratec Grabby
[ 1761.635960] em28xx #0:     card=68 -> Terratec AV350
[ 1761.635965] em28xx #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[ 1761.635971] em28xx #0:     card=70 -> Evga inDtube
[ 1761.635977] em28xx #0:     card=71 -> Silvercrest Webcam 1.3mpix
[ 1761.635982] em28xx #0:     card=72 -> Gadmei UTV330+
[ 1761.635988] em28xx #0:     card=73 -> Reddo DVB-C USB TV Box
[ 1761.635994] em28xx #0:     card=74 -> Actionmaster/LinXcel/Digitus VC211A
[ 1761.636000] em28xx #0:     card=75 -> Dikom DK300
[ 1761.636153] em28xx #0: Config register raw data: 0xc0
[ 1761.636160] em28xx #0: v4l2 driver version 0.1.2
[ 1762.148321] em28xx #0: V4L2 video device registered as video1
[ 1762.148328] em28xx #0: V4L2 VBI device registered as vbi0
[ 1762.148389] usbcore: registered new interface driver em28xx
[ 1762.148396] em28xx driver loaded
[ 1909.295326] em28xx #0: disconnecting em28xx #0 video
[ 1909.295334] em28xx #0: V4L2 device vbi0 deregistered
[ 1909.295484] em28xx #0: V4L2 device video1 deregistered
lahala@Lahala:~$ 

--------------070200010204070807030105--
