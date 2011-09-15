Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53661 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156Ab1IOGFK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Sep 2011 02:05:10 -0400
Received: by bkbzt4 with SMTP id zt4so2173219bkb.19
        for <linux-media@vger.kernel.org>; Wed, 14 Sep 2011 23:05:09 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 15 Sep 2011 00:05:09 -0600
Message-ID: <CAEaup1nQH7nSWAJuHsg-zjSWk+p4K9iqVW+YcKCZkGGdeSKijA@mail.gmail.com>
Subject: USB 2.0 video capture
From: Frank R <linuxrojas@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I purchase the following video capture USB device: : SVID2USB2
Not sure what to do at this point.


dmesg said to email the following:

[  217.496381] CE: hpet increased min_delta_ns to 11520 nsec
[  229.836347] usb 2-3: new high speed USB device using ehci_hcd and address 5
[  230.017201] IR NEC protocol handler initialized
[  230.019414] IR RC5(x) protocol handler initialized
[  230.026432] Linux video capture interface: v2.00
[  230.031560] IR RC6 protocol handler initialized
[  230.039551] IR JVC protocol handler initialized
[  230.043706] IR Sony protocol handler initialized
[  230.048324] em28xx: New device USB 2821 Device @ 480 Mbps
(eb1a:2821, interface 0, class 0)
[  230.049016] em28xx #0: chip ID is em2820 (or em2710)
[  230.053677] lirc_dev: IR Remote Control driver registered, major 249
[  230.056352] IR LIRC bridge handler initialized
[  230.182603] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 21 28 90 00
11 03 6a 22 00 00
[  230.182624] em28xx #0: i2c eeprom 10: 00 00 04 57 06 21 00 00 00 00
00 00 00 00 00 00
[  230.182646] em28xx #0: i2c eeprom 20: 02 00 01 01 f0 10 00 00 00 00
00 00 5b 00 00 00
[  230.182667] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01
03 01 00 00 00 00
[  230.182686] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  230.182704] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  230.182723] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00
22 03 55 00 53 00
[  230.182738] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 32 00
31 00 20 00 44 00
[  230.182758] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00
00 00 00 00 00 00
[  230.182777] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  230.182802] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  230.182817] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  230.182831] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  230.182846] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  230.182868] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  230.182892] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  230.182914] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x26da7a8a
[  230.182917] em28xx #0: EEPROM info:
[  230.182920] em28xx #0:	AC97 audio (5 sample rates)
[  230.182923] em28xx #0:	500mA max power
[  230.182928] em28xx #0:	Table at 0x04, strings=0x226a, 0x0000, 0x0000
[  230.223716] em28xx #0: found i2c device @ 0x4a [saa7113h]
[  230.254189] em28xx #0: found i2c device @ 0xa0 [eeprom]
[  230.283403] em28xx #0: Your board has no unique USB ID and thus
need a hint to be detected.
[  230.283411] em28xx #0: You may try to use card=<n> insmod option to
workaround that.
[  230.283416] em28xx #0: Please send an email with this log to:
[  230.283420] em28xx #0: 	V4L Mailing List <linux-media@vger.kernel.org>
[  230.283424] em28xx #0: Board eeprom hash is 0x26da7a8a
[  230.283427] em28xx #0: Board i2c devicelist hash is 0x6ba50080
[  230.283431] em28xx #0: Here is a list of valid choices for the
card=<n> insmod option:
[  230.283436] em28xx #0:     card=0 -> Unknown EM2800 video grabber
[  230.283441] em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
[  230.283445] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
[  230.283449] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
[  230.283453] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
[  230.283457] em28xx #0:     card=5 -> MSI VOX USB 2.0
[  230.283460] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
[  230.283464] em28xx #0:     card=7 -> Leadtek Winfast USB II
[  230.283468] em28xx #0:     card=8 -> Kworld USB2800
[  230.283472] em28xx #0:     card=9 -> Pinnacle Dazzle DVC
90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2
[  230.283478] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
[  230.283482] em28xx #0:     card=11 -> Terratec Hybrid XS
[  230.283486] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
[  230.283490] em28xx #0:     card=13 -> Terratec Prodigy XS
[  230.283494] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview
Prolink PlayTV USB 2.0
[  230.283498] em28xx #0:     card=15 -> V-Gear PocketTV
[  230.283502] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
[  230.283506] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[  230.283510] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[  230.283514] em28xx #0:     card=19 -> EM2860/SAA711X Reference Design
[  230.283518] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
[  230.283522] em28xx #0:     card=21 -> eMPIA Technology, Inc.
GrabBeeX+ Video Encoder
[  230.283527] em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam grabber
[  230.283531] em28xx #0:     card=23 -> Huaqi DLCW-130
[  230.283535] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
[  230.283539] em28xx #0:     card=25 -> Gadmei UTV310
[  230.283542] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
[  230.283546] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips FM1216ME)
[  230.283551] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
[  230.283555] em28xx #0:     card=29 -> EM2860/TVP5150 Reference Design
[  230.283559] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
[  230.283563] em28xx #0:     card=31 -> Usbgear VD204v9
[  230.283567] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
[  230.283570] em28xx #0:     card=33 -> Elgato Video Capture
[  230.283574] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
[  230.283578] em28xx #0:     card=35 -> Typhoon DVD Maker
[  230.283582] em28xx #0:     card=36 -> NetGMBH Cam
[  230.283586] em28xx #0:     card=37 -> Gadmei UTV330
[  230.283589] em28xx #0:     card=38 -> Yakumo MovieMixer
[  230.283593] em28xx #0:     card=39 -> KWorld PVRTV 300U
[  230.283597] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
[  230.283601] em28xx #0:     card=41 -> Kworld 350 U DVB-T
[  230.283605] em28xx #0:     card=42 -> Kworld 355 U DVB-T
[  230.283608] em28xx #0:     card=43 -> Terratec Cinergy T XS
[  230.283612] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[  230.283616] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
[  230.283620] em28xx #0:     card=46 -> Compro, VideoMate U3
[  230.283624] em28xx #0:     card=47 -> KWorld DVB-T 305U
[  230.283628] em28xx #0:     card=48 -> KWorld DVB-T 310U
[  230.283631] em28xx #0:     card=49 -> MSI DigiVox A/D
[  230.283635] em28xx #0:     card=50 -> MSI DigiVox A/D II
[  230.283639] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
[  230.283643] em28xx #0:     card=52 -> DNT DA2 Hybrid
[  230.283646] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
[  230.283650] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
[  230.283654] em28xx #0:     card=55 -> Terratec Cinnergy Hybrid T
USB XS (em2882)
[  230.283659] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (2)
[  230.283662] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[  230.283666] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
[  230.283671] em28xx #0:     card=59 -> (null)
[  230.283674] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
[  230.283678] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[  230.283682] em28xx #0:     card=62 -> Gadmei TVR200
[  230.283686] em28xx #0:     card=63 -> Kaiomy TVnPC U2
[  230.283689] em28xx #0:     card=64 -> Easy Cap Capture DC-60
[  230.283693] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
[  230.283697] em28xx #0:     card=66 -> Empire dual TV
[  230.283700] em28xx #0:     card=67 -> Terratec Grabby
[  230.283704] em28xx #0:     card=68 -> Terratec AV350
[  230.283708] em28xx #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[  230.283712] em28xx #0:     card=70 -> Evga inDtube
[  230.283715] em28xx #0:     card=71 -> Silvercrest Webcam 1.3mpix
[  230.283719] em28xx #0:     card=72 -> Gadmei UTV330+
[  230.283723] em28xx #0:     card=73 -> Reddo DVB-C USB TV Box
[  230.283727] em28xx #0:     card=74 -> Actionmaster/LinXcel/Digitus VC211A
[  230.283731] em28xx #0:     card=75 -> Dikom DK300
[  230.283735] em28xx #0:     card=76 -> KWorld PlusTV 340U or UB435-Q (ATSC)
[  230.283739] em28xx #0:     card=77 -> EM2874 Leadership ISDBT
[  230.283743] em28xx #0: Board not discovered
[  230.283746] em28xx #0: Identified as Unknown EM2750/28xx video
grabber (card=1)
[  230.283751] em28xx #0: Your board has no unique USB ID and thus
need a hint to be detected.
[  230.283755] em28xx #0: You may try to use card=<n> insmod option to
workaround that.
[  230.283759] em28xx #0: Please send an email with this log to:
[  230.283762] em28xx #0: 	V4L Mailing List <linux-media@vger.kernel.org>
[  230.283766] em28xx #0: Board eeprom hash is 0x26da7a8a
[  230.283770] em28xx #0: Board i2c devicelist hash is 0x6ba50080
[  230.283773] em28xx #0: Here is a list of valid choices for the
card=<n> insmod option:
[  230.283778] em28xx #0:     card=0 -> Unknown EM2800 video grabber
[  230.283782] em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
[  230.283786] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
[  230.283790] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
[  230.283794] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
[  230.283797] em28xx #0:     card=5 -> MSI VOX USB 2.0
[  230.283801] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
[  230.283805] em28xx #0:     card=7 -> Leadtek Winfast USB II
[  230.283809] em28xx #0:     card=8 -> Kworld USB2800
[  230.283813] em28xx #0:     card=9 -> Pinnacle Dazzle DVC
90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2
[  230.283818] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
[  230.283822] em28xx #0:     card=11 -> Terratec Hybrid XS
[  230.283826] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
[  230.283832] em28xx #0:     card=13 -> Terratec Prodigy XS
[  230.283836] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview
Prolink PlayTV USB 2.0
[  230.283840] em28xx #0:     card=15 -> V-Gear PocketTV
[  230.283844] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
[  230.283848] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[  230.283852] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[  230.283856] em28xx #0:     card=19 -> EM2860/SAA711X Reference Design
[  230.283860] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
[  230.283864] em28xx #0:     card=21 -> eMPIA Technology, Inc.
GrabBeeX+ Video Encoder
[  230.283868] em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam grabber
[  230.283872] em28xx #0:     card=23 -> Huaqi DLCW-130
[  230.283876] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
[  230.283880] em28xx #0:     card=25 -> Gadmei UTV310
[  230.283883] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
[  230.283887] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips FM1216ME)
[  230.283892] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
[  230.283896] em28xx #0:     card=29 -> EM2860/TVP5150 Reference Design
[  230.283900] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
[  230.283904] em28xx #0:     card=31 -> Usbgear VD204v9
[  230.283907] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
[  230.283911] em28xx #0:     card=33 -> Elgato Video Capture
[  230.283915] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
[  230.283919] em28xx #0:     card=35 -> Typhoon DVD Maker
[  230.283923] em28xx #0:     card=36 -> NetGMBH Cam
[  230.283926] em28xx #0:     card=37 -> Gadmei UTV330
[  230.283930] em28xx #0:     card=38 -> Yakumo MovieMixer
[  230.283933] em28xx #0:     card=39 -> KWorld PVRTV 300U
[  230.283937] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
[  230.283941] em28xx #0:     card=41 -> Kworld 350 U DVB-T
[  230.283945] em28xx #0:     card=42 -> Kworld 355 U DVB-T
[  230.283948] em28xx #0:     card=43 -> Terratec Cinergy T XS
[  230.283952] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[  230.283956] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
[  230.283960] em28xx #0:     card=46 -> Compro, VideoMate U3
[  230.283964] em28xx #0:     card=47 -> KWorld DVB-T 305U
[  230.283968] em28xx #0:     card=48 -> KWorld DVB-T 310U
[  230.283971] em28xx #0:     card=49 -> MSI DigiVox A/D
[  230.283975] em28xx #0:     card=50 -> MSI DigiVox A/D II
[  230.283979] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
[  230.283982] em28xx #0:     card=52 -> DNT DA2 Hybrid
[  230.283986] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
[  230.283990] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
[  230.283994] em28xx #0:     card=55 -> Terratec Cinnergy Hybrid T
USB XS (em2882)
[  230.283998] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (2)
[  230.284019] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[  230.284026] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
[  230.284032] em28xx #0:     card=59 -> (null)
[  230.284038] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
[  230.284045] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[  230.284051] em28xx #0:     card=62 -> Gadmei TVR200
[  230.284056] em28xx #0:     card=63 -> Kaiomy TVnPC U2
[  230.284062] em28xx #0:     card=64 -> Easy Cap Capture DC-60
[  230.284068] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
[  230.284074] em28xx #0:     card=66 -> Empire dual TV
[  230.284080] em28xx #0:     card=67 -> Terratec Grabby
[  230.284086] em28xx #0:     card=68 -> Terratec AV350
[  230.284092] em28xx #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[  230.284099] em28xx #0:     card=70 -> Evga inDtube
[  230.284104] em28xx #0:     card=71 -> Silvercrest Webcam 1.3mpix
[  230.284110] em28xx #0:     card=72 -> Gadmei UTV330+
[  230.284116] em28xx #0:     card=73 -> Reddo DVB-C USB TV Box
[  230.284122] em28xx #0:     card=74 -> Actionmaster/LinXcel/Digitus VC211A
[  230.284129] em28xx #0:     card=75 -> Dikom DK300
[  230.284134] em28xx #0:     card=76 -> KWorld PlusTV 340U or UB435-Q (ATSC)
[  230.284141] em28xx #0:     card=77 -> EM2874 Leadership ISDBT
[  230.284247] em28xx #0: Config register raw data: 0x90
[  230.309142] em28xx #0: AC97 vendor ID = 0x83847650
[  230.321449] em28xx #0: AC97 features = 0x6a90
[  230.321454] em28xx #0: Sigmatel audio processor detected(stac 9750)
[  230.438249] VirtualBox[2098]: segfault at 0 ip b77295df sp acc03d7c
error 4 in libc-2.13.so[b76b4000+15a000]
[  230.752036] em28xx #0: v4l2 driver version 0.1.2
[  231.584418] em28xx #0: V4L2 video device registered as video0
[  231.584452] em28xx audio device (eb1a:2821): interface 1, class 1
[  231.584477] em28xx audio device (eb1a:2821): interface 2, class 1
[  231.584520] usbcore: registered new interface driver em28xx
[  231.584524] em28xx driver loaded
[  231.602576] usbcore: registered new interface driver snd-usb-audio
