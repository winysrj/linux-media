Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpout012-vf.aruba.it ([62.149.179.211]:57769 "HELO
	smtp01-vf.aruba.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1751019Ab1KSPWQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Nov 2011 10:22:16 -0500
Message-ID: <4EC7C813.4090800@tiscali.it>
Date: Sat, 19 Nov 2011 16:15:31 +0100
From: daniel <tiburonis@tiscali.it>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Card "Pinnacle PCTV usb Stik" Not faund. in not more supported?
Content-Type: multipart/mixed;
 boundary="------------090505030700010606010807"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090505030700010606010807
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit






--------------090505030700010606010807
Content-Type: text/plain;
 name="Kernel log.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="Kernel log.txt"

daniel@ubuntu-portatil:~$ tail -f /var/log/kern.log
Nov 19 13:53:28 ubuntu-portatil kernel: [  757.268995] em28xx #0:     card=77 -> EM2874 Leadership ISDBT
Nov 19 13:53:28 ubuntu-portatil kernel: [  757.268998] em28xx #0:     card=78 -> PCTV nanoStick T2 290e
Nov 19 13:53:28 ubuntu-portatil kernel: [  757.269000] em28xx #0:     card=79 -> Terratec Cinergy H5
Nov 19 13:53:28 ubuntu-portatil kernel: [  757.269005] em28xx #0: v4l2 driver version 0.1.3
Nov 19 13:53:28 ubuntu-portatil kernel: [  757.277303] em28xx #0: V4L2 video device registered as video0
Nov 19 13:53:28 ubuntu-portatil kernel: [  757.278070] usbcore: registered new interface driver em28xx
Nov 19 13:53:28 ubuntu-portatil kernel: [  757.278074] em28xx driver loaded
Nov 19 15:13:13 ubuntu-portatil kernel: [ 5542.060142] usb 1-1: USB disconnect, device number 4
Nov 19 15:13:13 ubuntu-portatil kernel: [ 5542.060241] em28xx #0: disconnecting em28xx #0 video
Nov 19 15:13:13 ubuntu-portatil kernel: [ 5542.060248] em28xx #0: V4L2 device video0 deregistered
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.136037] usb 1-1: new high speed USB device number 5 using ehci_hcd
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.272753] em28xx: New device USB 2870 Device @ 480 Mbps (eb1a:2870, interface 0, class 0)
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.272816] em28xx #0: chip ID is em2870
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.355070] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 70 28 c0 12 81 00 6a 22 00 00
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.355085] em28xx #0: i2c eeprom 10: 00 00 04 57 02 0d 00 00 00 00 00 00 00 00 00 00
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.355097] em28xx #0: i2c eeprom 20: 44 00 00 00 f0 10 02 00 00 00 00 00 5b 00 00 00
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.355108] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 00 00 af 54 57 47
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.355119] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.355130] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.355141] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 22 03 55 00 53 00
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.355153] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 37 00 30 00 20 00 44 00
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.355164] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00 00 00 00 00 00 00
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.355175] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.355186] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.355197] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.355208] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.355219] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.355230] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.355241] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.355254] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0xc663edce
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.355257] em28xx #0: EEPROM info:
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.355259] em28xx #0:	No audio on board.
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.355261] em28xx #0:	500mA max power
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.355264] em28xx #0:	Table at 0x04, strings=0x226a, 0x0000, 0x0000
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.434571] em28xx #0: found i2c device @ 0xa0 [eeprom]
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.440558] em28xx #0: found i2c device @ 0xc0 [tuner (analog)]
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452444] em28xx #0: Your board has no unique USB ID and thus need a hint to be detected.
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452451] em28xx #0: You may try to use card=<n> insmod option to workaround that.
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452454] em28xx #0: Please send an email with this log to:
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452456] em28xx #0: 	V4L Mailing List <linux-media@vger.kernel.org>
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452459] em28xx #0: Board eeprom hash is 0xc663edce
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452461] em28xx #0: Board i2c devicelist hash is 0x4b800080
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452464] em28xx #0: Here is a list of valid choices for the card=<n> insmod option:
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452467] em28xx #0:     card=0 -> Unknown EM2800 video grabber
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452470] em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452473] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452476] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452479] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452481] em28xx #0:     card=5 -> MSI VOX USB 2.0
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452484] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452487] em28xx #0:     card=7 -> Leadtek Winfast USB II
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452489] em28xx #0:     card=8 -> Kworld USB2800
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452492] em28xx #0:     card=9 -> Pinnacle Dazzle DVC 90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452496] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452499] em28xx #0:     card=11 -> Terratec Hybrid XS
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452501] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452504] em28xx #0:     card=13 -> Terratec Prodigy XS
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452507] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview Prolink PlayTV USB 2.0
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452510] em28xx #0:     card=15 -> V-Gear PocketTV
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452513] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452515] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452518] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452521] em28xx #0:     card=19 -> EM2860/SAA711X Reference Design
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452524] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452527] em28xx #0:     card=21 -> eMPIA Technology, Inc. GrabBeeX+ Video Encoder
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452530] em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam grabber
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452533] em28xx #0:     card=23 -> Huaqi DLCW-130
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452535] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452538] em28xx #0:     card=25 -> Gadmei UTV310
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452540] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452543] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips FM1216ME)
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452546] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452549] em28xx #0:     card=29 -> EM2860/TVP5150 Reference Design
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452552] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452555] em28xx #0:     card=31 -> Usbgear VD204v9
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452557] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452560] em28xx #0:     card=33 -> Elgato Video Capture
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452563] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452566] em28xx #0:     card=35 -> Typhoon DVD Maker
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452568] em28xx #0:     card=36 -> NetGMBH Cam
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452571] em28xx #0:     card=37 -> Gadmei UTV330
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452573] em28xx #0:     card=38 -> Yakumo MovieMixer
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452576] em28xx #0:     card=39 -> KWorld PVRTV 300U
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452578] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452581] em28xx #0:     card=41 -> Kworld 350 U DVB-T
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452584] em28xx #0:     card=42 -> Kworld 355 U DVB-T
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452587] em28xx #0:     card=43 -> Terratec Cinergy T XS
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452589] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452592] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452595] em28xx #0:     card=46 -> Compro, VideoMate U3
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452597] em28xx #0:     card=47 -> KWorld DVB-T 305U
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452600] em28xx #0:     card=48 -> KWorld DVB-T 310U
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452603] em28xx #0:     card=49 -> MSI DigiVox A/D
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452605] em28xx #0:     card=50 -> MSI DigiVox A/D II
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452608] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452611] em28xx #0:     card=52 -> DNT DA2 Hybrid
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452613] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452616] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452619] em28xx #0:     card=55 -> Terratec Cinnergy Hybrid T USB XS (em2882)
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452622] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (330e)
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452624] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452627] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452630] em28xx #0:     card=59 -> (null)
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452633] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452635] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452638] em28xx #0:     card=62 -> Gadmei TVR200
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452641] em28xx #0:     card=63 -> Kaiomy TVnPC U2
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452643] em28xx #0:     card=64 -> Easy Cap Capture DC-60
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452646] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452649] em28xx #0:     card=66 -> Empire dual TV
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452651] em28xx #0:     card=67 -> Terratec Grabby
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452654] em28xx #0:     card=68 -> Terratec AV350
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452656] em28xx #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452659] em28xx #0:     card=70 -> Evga inDtube
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452662] em28xx #0:     card=71 -> Silvercrest Webcam 1.3mpix
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452665] em28xx #0:     card=72 -> Gadmei UTV330+
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452667] em28xx #0:     card=73 -> Reddo DVB-C USB TV Box
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452670] em28xx #0:     card=74 -> Actionmaster/LinXcel/Digitus VC211A
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452673] em28xx #0:     card=75 -> Dikom DK300
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452675] em28xx #0:     card=76 -> KWorld PlusTV 340U or UB435-Q (ATSC)
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452678] em28xx #0:     card=77 -> EM2874 Leadership ISDBT
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452681] em28xx #0:     card=78 -> PCTV nanoStick T2 290e
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452684] em28xx #0:     card=79 -> Terratec Cinergy H5
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452687] em28xx #0: Board not discovered
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452689] em28xx #0: Identified as Unknown EM2750/28xx video grabber (card=1)
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452692] em28xx #0: Your board has no unique USB ID and thus need a hint to be detected.
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452695] em28xx #0: You may try to use card=<n> insmod option to workaround that.
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452698] em28xx #0: Please send an email with this log to:
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452700] em28xx #0: 	V4L Mailing List <linux-media@vger.kernel.org>
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452703] em28xx #0: Board eeprom hash is 0xc663edce
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452705] em28xx #0: Board i2c devicelist hash is 0x4b800080
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452708] em28xx #0: Here is a list of valid choices for the card=<n> insmod option:
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452711] em28xx #0:     card=0 -> Unknown EM2800 video grabber
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452713] em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452716] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452719] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452721] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452724] em28xx #0:     card=5 -> MSI VOX USB 2.0
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452726] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452729] em28xx #0:     card=7 -> Leadtek Winfast USB II
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452731] em28xx #0:     card=8 -> Kworld USB2800
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452734] em28xx #0:     card=9 -> Pinnacle Dazzle DVC 90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452737] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452740] em28xx #0:     card=11 -> Terratec Hybrid XS
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452743] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452745] em28xx #0:     card=13 -> Terratec Prodigy XS
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452748] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview Prolink PlayTV USB 2.0
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452751] em28xx #0:     card=15 -> V-Gear PocketTV
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452753] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452756] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452759] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452761] em28xx #0:     card=19 -> EM2860/SAA711X Reference Design
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452764] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452767] em28xx #0:     card=21 -> eMPIA Technology, Inc. GrabBeeX+ Video Encoder
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452770] em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam grabber
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452773] em28xx #0:     card=23 -> Huaqi DLCW-130
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452775] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452778] em28xx #0:     card=25 -> Gadmei UTV310
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452780] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452783] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips FM1216ME)
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452786] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452788] em28xx #0:     card=29 -> EM2860/TVP5150 Reference Design
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452791] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452794] em28xx #0:     card=31 -> Usbgear VD204v9
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452796] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452799] em28xx #0:     card=33 -> Elgato Video Capture
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452801] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452804] em28xx #0:     card=35 -> Typhoon DVD Maker
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452807] em28xx #0:     card=36 -> NetGMBH Cam
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452809] em28xx #0:     card=37 -> Gadmei UTV330
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452811] em28xx #0:     card=38 -> Yakumo MovieMixer
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452814] em28xx #0:     card=39 -> KWorld PVRTV 300U
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452816] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452819] em28xx #0:     card=41 -> Kworld 350 U DVB-T
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452822] em28xx #0:     card=42 -> Kworld 355 U DVB-T
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452824] em28xx #0:     card=43 -> Terratec Cinergy T XS
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452827] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452829] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452832] em28xx #0:     card=46 -> Compro, VideoMate U3
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452835] em28xx #0:     card=47 -> KWorld DVB-T 305U
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452837] em28xx #0:     card=48 -> KWorld DVB-T 310U
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452840] em28xx #0:     card=49 -> MSI DigiVox A/D
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452842] em28xx #0:     card=50 -> MSI DigiVox A/D II
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452845] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452847] em28xx #0:     card=52 -> DNT DA2 Hybrid
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452850] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452852] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452855] em28xx #0:     card=55 -> Terratec Cinnergy Hybrid T USB XS (em2882)
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452858] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (330e)
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452860] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452863] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452866] em28xx #0:     card=59 -> (null)
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452868] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452871] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452873] em28xx #0:     card=62 -> Gadmei TVR200
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452876] em28xx #0:     card=63 -> Kaiomy TVnPC U2
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452878] em28xx #0:     card=64 -> Easy Cap Capture DC-60
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452881] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452883] em28xx #0:     card=66 -> Empire dual TV
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452886] em28xx #0:     card=67 -> Terratec Grabby
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452888] em28xx #0:     card=68 -> Terratec AV350
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452891] em28xx #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452893] em28xx #0:     card=70 -> Evga inDtube
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452896] em28xx #0:     card=71 -> Silvercrest Webcam 1.3mpix
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452899] em28xx #0:     card=72 -> Gadmei UTV330+
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452901] em28xx #0:     card=73 -> Reddo DVB-C USB TV Box
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452904] em28xx #0:     card=74 -> Actionmaster/LinXcel/Digitus VC211A
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452906] em28xx #0:     card=75 -> Dikom DK300
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452909] em28xx #0:     card=76 -> KWorld PlusTV 340U or UB435-Q (ATSC)
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452912] em28xx #0:     card=77 -> EM2874 Leadership ISDBT
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452914] em28xx #0:     card=78 -> PCTV nanoStick T2 290e
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452917] em28xx #0:     card=79 -> Terratec Cinergy H5
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.452923] em28xx #0: v4l2 driver version 0.1.3
Nov 19 15:13:45 ubuntu-portatil kernel: [ 5574.459432] em28xx #0: V4L2 video device registered as video0






--------------090505030700010606010807--
