Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:51438 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1765728AbcJaKab (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 31 Oct 2016 06:30:31 -0400
Received: from [IPv6:2a01:e35:8b00:61c0:81bb:c2e3:b71f:f4c6] (unknown [IPv6:2a01:e35:8b00:61c0:81bb:c2e3:b71f:f4c6])
        (Authenticated sender: jean-gregoire.foulon@iddad.fr)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 3ABFC172098
        for <linux-media@vger.kernel.org>; Mon, 31 Oct 2016 11:30:28 +0100 (CET)
From: =?UTF-8?Q?Jean-Gr=c3=a9goire_Foulon?=
        <jean-gregoire.foulon@iddad.fr>
Subject: StarTech SVID2USB2 suport
To: linux-media@vger.kernel.org
Message-ID: <355aa3be-ade3-0c74-36b0-5e0452f112ec@iddad.fr>
Date: Mon, 31 Oct 2016 11:30:27 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I bought a usb2 video capture card which is not supported yet :

https://www.startech.com/AV/Converters/Video/USB-S-Video-and-Composite-Video-Capture-Device-Cable-with-Audio~SVID2USB2

I posted the pictures here :

https://linuxtv.org/wiki/index.php/File:Startech_svid2usb2_board_back.jpg

https://linuxtv.org/wiki/index.php/File:Startech_svid2usb2_open.jpg

Here is the result of dmesg :

[11662.666571] em28xx: New device  USB 2821 Device @ 480 Mbps 
(eb1a:2821, interface 0, class 0)
[11662.666576] em28xx: Video interface 0 found: bulk isoc
[11662.666698] em28xx: chip ID is em2710/2820
[11662.790996] em2710/2820 #0: EEPROM ID = 1a eb 67 95, EEPROM hash = 
0x26da7a8a
[11662.791007] em2710/2820 #0: EEPROM info:
[11662.791009] em2710/2820 #0:     AC97 audio (5 sample rates)
[11662.791010] em2710/2820 #0:     500mA max power
[11662.791012] em2710/2820 #0:     Table at offset 0x04, strings=0x226a, 
0x0000, 0x0000
[11662.849346] em2710/2820 #0: No sensor detected
[11662.866090] em2710/2820 #0: found i2c device @ 0x4a on bus 0 [saa7113h]
[11662.883297] em2710/2820 #0: found i2c device @ 0xa0 on bus 0 [eeprom]
[11662.902797] em2710/2820 #0: Your board has no unique USB ID and thus 
need a hint to be detected.
[11662.902800] em2710/2820 #0: You may try to use card=<n> insmod option 
to workaround that.
[11662.902802] em2710/2820 #0: Please send an email with this log to:
[11662.902803] em2710/2820 #0:     V4L Mailing List 
<linux-media@vger.kernel.org>
[11662.902813] em2710/2820 #0: Board eeprom hash is 0x26da7a8a
[11662.902814] em2710/2820 #0: Board i2c devicelist hash is 0x6ba50080
[11662.902816] em2710/2820 #0: Here is a list of valid choices for the 
card=<n> insmod option:
[11662.902818] em2710/2820 #0:     card=0 -> Unknown EM2800 video grabber
[11662.902819] em2710/2820 #0:     card=1 -> Unknown EM2750/28xx video 
grabber
[11662.902821] em2710/2820 #0:     card=2 -> Terratec Cinergy 250 USB
[11662.902823] em2710/2820 #0:     card=3 -> Pinnacle PCTV USB 2
[11662.902824] em2710/2820 #0:     card=4 -> Hauppauge WinTV USB 2
[11662.902826] em2710/2820 #0:     card=5 -> MSI VOX USB 2.0
[11662.902827] em2710/2820 #0:     card=6 -> Terratec Cinergy 200 USB
[11662.902829] em2710/2820 #0:     card=7 -> Leadtek Winfast USB II
[11662.902831] em2710/2820 #0:     card=8 -> Kworld USB2800
[11662.902832] em2710/2820 #0:     card=9 -> Pinnacle Dazzle DVC 
90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2 / 
Plextor ConvertX PX-AV100U
[11662.902834] em2710/2820 #0:     card=10 -> Hauppauge WinTV HVR 900
[11662.902836] em2710/2820 #0:     card=11 -> Terratec Hybrid XS
[11662.902837] em2710/2820 #0:     card=12 -> Kworld PVR TV 2800 RF
[11662.902839] em2710/2820 #0:     card=13 -> Terratec Prodigy XS
[11662.902840] em2710/2820 #0:     card=14 -> SIIG AVTuner-PVR / 
Pixelview Prolink PlayTV USB 2.0
[11662.902842] em2710/2820 #0:     card=15 -> V-Gear PocketTV
[11662.902844] em2710/2820 #0:     card=16 -> Hauppauge WinTV HVR 950
[11662.902845] em2710/2820 #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[11662.902847] em2710/2820 #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[11662.902848] em2710/2820 #0:     card=19 -> EM2860/SAA711X Reference 
Design
[11662.902850] em2710/2820 #0:     card=20 -> AMD ATI TV Wonder HD 600
[11662.902852] em2710/2820 #0:     card=21 -> eMPIA Technology, Inc. 
GrabBeeX+ Video Encoder
[11662.902853] em2710/2820 #0:     card=22 -> EM2710/EM2750/EM2751 
webcam grabber
[11662.902855] em2710/2820 #0:     card=23 -> Huaqi DLCW-130
[11662.902856] em2710/2820 #0:     card=24 -> D-Link DUB-T210 TV Tuner
[11662.902858] em2710/2820 #0:     card=25 -> Gadmei UTV310
[11662.902860] em2710/2820 #0:     card=26 -> Hercules Smart TV USB 2.0
[11662.902861] em2710/2820 #0:     card=27 -> Pinnacle PCTV USB 2 
(Philips FM1216ME)
[11662.902863] em2710/2820 #0:     card=28 -> Leadtek Winfast USB II Deluxe
[11662.902864] em2710/2820 #0:     card=29 -> EM2860/TVP5150 Reference 
Design
[11662.902866] em2710/2820 #0:     card=30 -> Videology 20K14XUSB USB2.0
[11662.902867] em2710/2820 #0:     card=31 -> Usbgear VD204v9
[11662.902869] em2710/2820 #0:     card=32 -> Supercomp USB 2.0 TV
[11662.902871] em2710/2820 #0:     card=33 -> Elgato Video Capture
[11662.902872] em2710/2820 #0:     card=34 -> Terratec Cinergy A Hybrid XS
[11662.902874] em2710/2820 #0:     card=35 -> Typhoon DVD Maker
[11662.902875] em2710/2820 #0:     card=36 -> NetGMBH Cam
[11662.902877] em2710/2820 #0:     card=37 -> Gadmei UTV330
[11662.902878] em2710/2820 #0:     card=38 -> Yakumo MovieMixer
[11662.902880] em2710/2820 #0:     card=39 -> KWorld PVRTV 300U
[11662.902881] em2710/2820 #0:     card=40 -> Plextor ConvertX PX-TV100U
[11662.902883] em2710/2820 #0:     card=41 -> Kworld 350 U DVB-T
[11662.902884] em2710/2820 #0:     card=42 -> Kworld 355 U DVB-T
[11662.902886] em2710/2820 #0:     card=43 -> Terratec Cinergy T XS
[11662.902887] em2710/2820 #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[11662.902889] em2710/2820 #0:     card=45 -> Pinnacle PCTV DVB-T
[11662.902891] em2710/2820 #0:     card=46 -> Compro, VideoMate U3
[11662.902892] em2710/2820 #0:     card=47 -> KWorld DVB-T 305U
[11662.902894] em2710/2820 #0:     card=48 -> KWorld DVB-T 310U
[11662.902895] em2710/2820 #0:     card=49 -> MSI DigiVox A/D
[11662.902897] em2710/2820 #0:     card=50 -> MSI DigiVox A/D II
[11662.902898] em2710/2820 #0:     card=51 -> Terratec Hybrid XS Secam
[11662.902900] em2710/2820 #0:     card=52 -> DNT DA2 Hybrid
[11662.902901] em2710/2820 #0:     card=53 -> Pinnacle Hybrid Pro
[11662.902903] em2710/2820 #0:     card=54 -> Kworld VS-DVB-T 323UR
[11662.902904] em2710/2820 #0:     card=55 -> Terratec Cinnergy Hybrid T 
USB XS (em2882)
[11662.902906] em2710/2820 #0:     card=56 -> Pinnacle Hybrid Pro (330e)
[11662.902907] em2710/2820 #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[11662.902909] em2710/2820 #0:     card=58 -> Compro VideoMate ForYou/Stereo
[11662.902911] em2710/2820 #0:     card=59 -> Pinnacle PCTV HD Mini
[11662.902912] em2710/2820 #0:     card=60 -> Hauppauge WinTV HVR 850
[11662.902914] em2710/2820 #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[11662.902916] em2710/2820 #0:     card=62 -> Gadmei TVR200
[11662.902917] em2710/2820 #0:     card=63 -> Kaiomy TVnPC U2
[11662.902919] em2710/2820 #0:     card=64 -> Easy Cap Capture DC-60
[11662.902920] em2710/2820 #0:     card=65 -> IO-DATA GV-MVP/SZ
[11662.902922] em2710/2820 #0:     card=66 -> Empire dual TV
[11662.902923] em2710/2820 #0:     card=67 -> Terratec Grabby
[11662.902925] em2710/2820 #0:     card=68 -> Terratec AV350
[11662.902927] em2710/2820 #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[11662.902928] em2710/2820 #0:     card=70 -> Evga inDtube
[11662.902930] em2710/2820 #0:     card=71 -> Silvercrest Webcam 1.3mpix
[11662.902931] em2710/2820 #0:     card=72 -> Gadmei UTV330+
[11662.902933] em2710/2820 #0:     card=73 -> Reddo DVB-C USB TV Box
[11662.902934] em2710/2820 #0:     card=74 -> 
Actionmaster/LinXcel/Digitus VC211A
[11662.902936] em2710/2820 #0:     card=75 -> Dikom DK300
[11662.902937] em2710/2820 #0:     card=76 -> KWorld PlusTV 340U or 
UB435-Q (ATSC)
[11662.902939] em2710/2820 #0:     card=77 -> EM2874 Leadership ISDBT
[11662.902941] em2710/2820 #0:     card=78 -> PCTV nanoStick T2 290e
[11662.902942] em2710/2820 #0:     card=79 -> Terratec Cinergy H5
[11662.902944] em2710/2820 #0:     card=80 -> PCTV DVB-S2 Stick (460e)
[11662.902945] em2710/2820 #0:     card=81 -> Hauppauge WinTV HVR 930C
[11662.902947] em2710/2820 #0:     card=82 -> Terratec Cinergy HTC Stick
[11662.902948] em2710/2820 #0:     card=83 -> Honestech Vidbox NW03
[11662.902950] em2710/2820 #0:     card=84 -> MaxMedia UB425-TC
[11662.902951] em2710/2820 #0:     card=85 -> PCTV QuatroStick (510e)
[11662.902953] em2710/2820 #0:     card=86 -> PCTV QuatroStick nano (520e)
[11662.902955] em2710/2820 #0:     card=87 -> Terratec Cinergy HTC USB XS
[11662.902956] em2710/2820 #0:     card=88 -> C3 Tech Digital Duo 
HDTV/SDTV USB
[11662.902958] em2710/2820 #0:     card=89 -> Delock 61959
[11662.902959] em2710/2820 #0:     card=90 -> KWorld USB ATSC TV Stick 
UB435-Q V2
[11662.902961] em2710/2820 #0:     card=91 -> SpeedLink Vicious And 
Devine Laplace webcam
[11662.902962] em2710/2820 #0:     card=92 -> PCTV DVB-S2 Stick (461e)
[11662.902964] em2710/2820 #0:     card=93 -> KWorld USB ATSC TV Stick 
UB435-Q V3
[11662.902965] em2710/2820 #0:     card=94 -> PCTV tripleStick (292e)
[11662.902967] em2710/2820 #0:     card=95 -> Leadtek VC100
[11662.902968] em2710/2820 #0:     card=96 -> Terratec Cinergy T2 Stick HD
[11662.902970] em2710/2820 #0:     card=97 -> Elgato EyeTV Hybrid 2008 INT
[11662.902971] em2710/2820 #0:     card=98 -> PLEX PX-BCUD
[11662.902973] em2710/2820 #0:     card=99 -> Hauppauge WinTV-dualHD DVB
[11662.902974] em2710/2820 #0: Board not discovered
[11662.902976] em2710/2820 #0: Identified as Unknown EM2750/28xx video 
grabber (card=1)
[11662.902978] em2710/2820 #0: Your board has no unique USB ID and thus 
need a hint to be detected.
[11662.902979] em2710/2820 #0: You may try to use card=<n> insmod option 
to workaround that.
[11662.902981] em2710/2820 #0: Please send an email with this log to:
[11662.902982] em2710/2820 #0:     V4L Mailing List 
<linux-media@vger.kernel.org>
[11662.902984] em2710/2820 #0: Board eeprom hash is 0x26da7a8a
[11662.902985] em2710/2820 #0: Board i2c devicelist hash is 0x6ba50080
[11662.902986] em2710/2820 #0: Here is a list of valid choices for the 
card=<n> insmod option:
[11662.902988] em2710/2820 #0:     card=0 -> Unknown EM2800 video grabber
[11662.902989] em2710/2820 #0:     card=1 -> Unknown EM2750/28xx video 
grabber
[11662.902991] em2710/2820 #0:     card=2 -> Terratec Cinergy 250 USB
[11662.902993] em2710/2820 #0:     card=3 -> Pinnacle PCTV USB 2
[11662.902994] em2710/2820 #0:     card=4 -> Hauppauge WinTV USB 2
[11662.902996] em2710/2820 #0:     card=5 -> MSI VOX USB 2.0
[11662.902997] em2710/2820 #0:     card=6 -> Terratec Cinergy 200 USB
[11662.902999] em2710/2820 #0:     card=7 -> Leadtek Winfast USB II
[11662.903000] em2710/2820 #0:     card=8 -> Kworld USB2800
[11662.903002] em2710/2820 #0:     card=9 -> Pinnacle Dazzle DVC 
90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2 / 
Plextor ConvertX PX-AV100U
[11662.903003] em2710/2820 #0:     card=10 -> Hauppauge WinTV HVR 900
[11662.903005] em2710/2820 #0:     card=11 -> Terratec Hybrid XS
[11662.903006] em2710/2820 #0:     card=12 -> Kworld PVR TV 2800 RF
[11662.903008] em2710/2820 #0:     card=13 -> Terratec Prodigy XS
[11662.903009] em2710/2820 #0:     card=14 -> SIIG AVTuner-PVR / 
Pixelview Prolink PlayTV USB 2.0
[11662.903011] em2710/2820 #0:     card=15 -> V-Gear PocketTV
[11662.903013] em2710/2820 #0:     card=16 -> Hauppauge WinTV HVR 950
[11662.903014] em2710/2820 #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[11662.903016] em2710/2820 #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[11662.903017] em2710/2820 #0:     card=19 -> EM2860/SAA711X Reference 
Design
[11662.903019] em2710/2820 #0:     card=20 -> AMD ATI TV Wonder HD 600
[11662.903020] em2710/2820 #0:     card=21 -> eMPIA Technology, Inc. 
GrabBeeX+ Video Encoder
[11662.903022] em2710/2820 #0:     card=22 -> EM2710/EM2750/EM2751 
webcam grabber
[11662.903023] em2710/2820 #0:     card=23 -> Huaqi DLCW-130
[11662.903025] em2710/2820 #0:     card=24 -> D-Link DUB-T210 TV Tuner
[11662.903026] em2710/2820 #0:     card=25 -> Gadmei UTV310
[11662.903028] em2710/2820 #0:     card=26 -> Hercules Smart TV USB 2.0
[11662.903029] em2710/2820 #0:     card=27 -> Pinnacle PCTV USB 2 
(Philips FM1216ME)
[11662.903031] em2710/2820 #0:     card=28 -> Leadtek Winfast USB II Deluxe
[11662.903033] em2710/2820 #0:     card=29 -> EM2860/TVP5150 Reference 
Design
[11662.903034] em2710/2820 #0:     card=30 -> Videology 20K14XUSB USB2.0
[11662.903036] em2710/2820 #0:     card=31 -> Usbgear VD204v9
[11662.903037] em2710/2820 #0:     card=32 -> Supercomp USB 2.0 TV
[11662.903039] em2710/2820 #0:     card=33 -> Elgato Video Capture
[11662.903040] em2710/2820 #0:     card=34 -> Terratec Cinergy A Hybrid XS
[11662.903041] em2710/2820 #0:     card=35 -> Typhoon DVD Maker
[11662.903043] em2710/2820 #0:     card=36 -> NetGMBH Cam
[11662.903044] em2710/2820 #0:     card=37 -> Gadmei UTV330
[11662.903046] em2710/2820 #0:     card=38 -> Yakumo MovieMixer
[11662.903047] em2710/2820 #0:     card=39 -> KWorld PVRTV 300U
[11662.903049] em2710/2820 #0:     card=40 -> Plextor ConvertX PX-TV100U
[11662.903050] em2710/2820 #0:     card=41 -> Kworld 350 U DVB-T
[11662.903052] em2710/2820 #0:     card=42 -> Kworld 355 U DVB-T
[11662.903053] em2710/2820 #0:     card=43 -> Terratec Cinergy T XS
[11662.903055] em2710/2820 #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[11662.903056] em2710/2820 #0:     card=45 -> Pinnacle PCTV DVB-T
[11662.903058] em2710/2820 #0:     card=46 -> Compro, VideoMate U3
[11662.903059] em2710/2820 #0:     card=47 -> KWorld DVB-T 305U
[11662.903060] em2710/2820 #0:     card=48 -> KWorld DVB-T 310U
[11662.903062] em2710/2820 #0:     card=49 -> MSI DigiVox A/D
[11662.903063] em2710/2820 #0:     card=50 -> MSI DigiVox A/D II
[11662.903065] em2710/2820 #0:     card=51 -> Terratec Hybrid XS Secam
[11662.903067] em2710/2820 #0:     card=52 -> DNT DA2 Hybrid
[11662.903068] em2710/2820 #0:     card=53 -> Pinnacle Hybrid Pro
[11662.903069] em2710/2820 #0:     card=54 -> Kworld VS-DVB-T 323UR
[11662.903071] em2710/2820 #0:     card=55 -> Terratec Cinnergy Hybrid T 
USB XS (em2882)
[11662.903073] em2710/2820 #0:     card=56 -> Pinnacle Hybrid Pro (330e)
[11662.903074] em2710/2820 #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[11662.903076] em2710/2820 #0:     card=58 -> Compro VideoMate ForYou/Stereo
[11662.903077] em2710/2820 #0:     card=59 -> Pinnacle PCTV HD Mini
[11662.903079] em2710/2820 #0:     card=60 -> Hauppauge WinTV HVR 850
[11662.903080] em2710/2820 #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[11662.903082] em2710/2820 #0:     card=62 -> Gadmei TVR200
[11662.903083] em2710/2820 #0:     card=63 -> Kaiomy TVnPC U2
[11662.903085] em2710/2820 #0:     card=64 -> Easy Cap Capture DC-60
[11662.903086] em2710/2820 #0:     card=65 -> IO-DATA GV-MVP/SZ
[11662.903088] em2710/2820 #0:     card=66 -> Empire dual TV
[11662.903089] em2710/2820 #0:     card=67 -> Terratec Grabby
[11662.903091] em2710/2820 #0:     card=68 -> Terratec AV350
[11662.903092] em2710/2820 #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[11662.903094] em2710/2820 #0:     card=70 -> Evga inDtube
[11662.903095] em2710/2820 #0:     card=71 -> Silvercrest Webcam 1.3mpix
[11662.903097] em2710/2820 #0:     card=72 -> Gadmei UTV330+
[11662.903098] em2710/2820 #0:     card=73 -> Reddo DVB-C USB TV Box
[11662.903100] em2710/2820 #0:     card=74 -> 
Actionmaster/LinXcel/Digitus VC211A
[11662.903101] em2710/2820 #0:     card=75 -> Dikom DK300
[11662.903103] em2710/2820 #0:     card=76 -> KWorld PlusTV 340U or 
UB435-Q (ATSC)
[11662.903104] em2710/2820 #0:     card=77 -> EM2874 Leadership ISDBT
[11662.903106] em2710/2820 #0:     card=78 -> PCTV nanoStick T2 290e
[11662.903107] em2710/2820 #0:     card=79 -> Terratec Cinergy H5
[11662.903109] em2710/2820 #0:     card=80 -> PCTV DVB-S2 Stick (460e)
[11662.903110] em2710/2820 #0:     card=81 -> Hauppauge WinTV HVR 930C
[11662.903112] em2710/2820 #0:     card=82 -> Terratec Cinergy HTC Stick
[11662.903113] em2710/2820 #0:     card=83 -> Honestech Vidbox NW03
[11662.903115] em2710/2820 #0:     card=84 -> MaxMedia UB425-TC
[11662.903116] em2710/2820 #0:     card=85 -> PCTV QuatroStick (510e)
[11662.903118] em2710/2820 #0:     card=86 -> PCTV QuatroStick nano (520e)
[11662.903119] em2710/2820 #0:     card=87 -> Terratec Cinergy HTC USB XS
[11662.903121] em2710/2820 #0:     card=88 -> C3 Tech Digital Duo 
HDTV/SDTV USB
[11662.903122] em2710/2820 #0:     card=89 -> Delock 61959
[11662.903124] em2710/2820 #0:     card=90 -> KWorld USB ATSC TV Stick 
UB435-Q V2
[11662.903125] em2710/2820 #0:     card=91 -> SpeedLink Vicious And 
Devine Laplace webcam
[11662.903127] em2710/2820 #0:     card=92 -> PCTV DVB-S2 Stick (461e)
[11662.903128] em2710/2820 #0:     card=93 -> KWorld USB ATSC TV Stick 
UB435-Q V3
[11662.903130] em2710/2820 #0:     card=94 -> PCTV tripleStick (292e)
[11662.903131] em2710/2820 #0:     card=95 -> Leadtek VC100
[11662.903133] em2710/2820 #0:     card=96 -> Terratec Cinergy T2 Stick HD
[11662.903134] em2710/2820 #0:     card=97 -> Elgato EyeTV Hybrid 2008 INT
[11662.903136] em2710/2820 #0:     card=98 -> PLEX PX-BCUD
[11662.903137] em2710/2820 #0:     card=99 -> Hauppauge WinTV-dualHD DVB
[11662.903139] em28xx: Currently, V4L2 is not supported on this model
[11662.903302] usbcore: registered new interface driver em28xx


# lsusb -v -d eb1a:2821

Bus 004 Device 015: ID eb1a:2821 eMPIA Technology, Inc.
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.00
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0        64
   idVendor           0xeb1a eMPIA Technology, Inc.
   idProduct          0x2821
   bcdDevice            1.00
   iManufacturer           0
   iProduct                1 USB 2821 Device
   iSerial                 0
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength          521
     bNumInterfaces          3
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0x80
       (Bus Powered)
     MaxPower              500mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           3
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      0
       bInterfaceProtocol    255
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0001  1x 1 bytes
         bInterval              11
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0000  1x 0 bytes
         bInterval               1
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x84  EP 4 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               1
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       1
       bNumEndpoints           3
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      0
       bInterfaceProtocol    255
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0001  1x 1 bytes
         bInterval              11
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0400  1x 1024 bytes
         bInterval               1
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x84  EP 4 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               1
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       2
       bNumEndpoints           3
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      0
       bInterfaceProtocol    255
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0001  1x 1 bytes
         bInterval              11
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0ad4  2x 724 bytes
         bInterval               1
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x84  EP 4 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               1
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       3
       bNumEndpoints           3
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      0
       bInterfaceProtocol    255
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0001  1x 1 bytes
         bInterval              11
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0c00  2x 1024 bytes
         bInterval               1
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x84  EP 4 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               1
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       4
       bNumEndpoints           3
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      0
       bInterfaceProtocol    255
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0001  1x 1 bytes
         bInterval              11
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x1300  3x 768 bytes
         bInterval               1
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x84  EP 4 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               1
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       5
       bNumEndpoints           3
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      0
       bInterfaceProtocol    255
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0001  1x 1 bytes
         bInterval              11
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x135c  3x 860 bytes
         bInterval               1
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x84  EP 4 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               1
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       6
       bNumEndpoints           3
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      0
       bInterfaceProtocol    255
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0001  1x 1 bytes
         bInterval              11
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x13c4  3x 964 bytes
         bInterval               1
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x84  EP 4 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               1
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       7
       bNumEndpoints           3
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      0
       bInterfaceProtocol    255
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0001  1x 1 bytes
         bInterval              11
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x1400  3x 1024 bytes
         bInterval               1
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x84  EP 4 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               1
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        1
       bAlternateSetting       0
       bNumEndpoints           0
       bInterfaceClass         1 Audio
       bInterfaceSubClass      1 Control Device
       bInterfaceProtocol      0
       iInterface              0
       AudioControl Interface Descriptor:
         bLength                 9
         bDescriptorType        36
         bDescriptorSubtype      1 (HEADER)
         bcdADC               1.00
         wTotalLength           39
         bInCollection           1
         baInterfaceNr( 0)       2
       AudioControl Interface Descriptor:
         bLength                12
         bDescriptorType        36
         bDescriptorSubtype      2 (INPUT_TERMINAL)
         bTerminalID             1
         wTerminalType      0x0603 Line Connector
         bAssocTerminal          0
         bNrChannels             2
         wChannelConfig     0x0003
           Left Front (L)
           Right Front (R)
         iChannelNames           0
         iTerminal               0
       AudioControl Interface Descriptor:
         bLength                 9
         bDescriptorType        36
         bDescriptorSubtype      6 (FEATURE_UNIT)
         bUnitID                 2
         bSourceID               1
         bControlSize            1
         bmaControls( 0)      0x03
           Mute Control
           Volume Control
         bmaControls( 1)      0x00
         iFeature                0
       AudioControl Interface Descriptor:
         bLength                 9
         bDescriptorType        36
         bDescriptorSubtype      3 (OUTPUT_TERMINAL)
         bTerminalID             3
         wTerminalType      0x0101 USB Streaming
         bAssocTerminal          0
         bSourceID               2
         iTerminal               0
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        2
       bAlternateSetting       0
       bNumEndpoints           0
       bInterfaceClass         1 Audio
       bInterfaceSubClass      2 Streaming
       bInterfaceProtocol      0
       iInterface              0
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        2
       bAlternateSetting       1
       bNumEndpoints           1
       bInterfaceClass         1 Audio
       bInterfaceSubClass      2 Streaming
       bInterfaceProtocol      0
       iInterface              0
       AudioStreaming Interface Descriptor:
         bLength                 7
         bDescriptorType        36
         bDescriptorSubtype      1 (AS_GENERAL)
         bTerminalLink           3
         bDelay                  1 frames
         wFormatTag              1 PCM
       AudioStreaming Interface Descriptor:
         bLength                11
         bDescriptorType        36
         bDescriptorSubtype      2 (FORMAT_TYPE)
         bFormatType             1 (FORMAT_TYPE_I)
         bNrChannels             2
         bSubframeSize           2
         bBitResolution         16
         bSamFreqType            1 Discrete
         tSamFreq[ 0]        48000
       Endpoint Descriptor:
         bLength                 9
         bDescriptorType         5
         bEndpointAddress     0x83  EP 3 IN
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x001c  1x 28 bytes
         bInterval               1
         bRefresh                0
         bSynchAddress           0
         AudioControl Endpoint Descriptor:
           bLength                 7
           bDescriptorType        37
           bDescriptorSubtype      1 (EP_GENERAL)
           bmAttributes         0x00
           bLockDelayUnits         0 Undefined
           wLockDelay              0 Undefined
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        2
       bAlternateSetting       2
       bNumEndpoints           1
       bInterfaceClass         1 Audio
       bInterfaceSubClass      2 Streaming
       bInterfaceProtocol      0
       iInterface              0
       AudioStreaming Interface Descriptor:
         bLength                 7
         bDescriptorType        36
         bDescriptorSubtype      1 (AS_GENERAL)
         bTerminalLink           3
         bDelay                  1 frames
         wFormatTag              1 PCM
       AudioStreaming Interface Descriptor:
         bLength                11
         bDescriptorType        36
         bDescriptorSubtype      2 (FORMAT_TYPE)
         bFormatType             1 (FORMAT_TYPE_I)
         bNrChannels             2
         bSubframeSize           2
         bBitResolution         16
         bSamFreqType            1 Discrete
         tSamFreq[ 0]        44100
       Endpoint Descriptor:
         bLength                 9
         bDescriptorType         5
         bEndpointAddress     0x83  EP 3 IN
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0018  1x 24 bytes
         bInterval               1
         bRefresh                0
         bSynchAddress           0
         AudioControl Endpoint Descriptor:
           bLength                 7
           bDescriptorType        37
           bDescriptorSubtype      1 (EP_GENERAL)
           bmAttributes         0x00
           bLockDelayUnits         0 Undefined
           wLockDelay              0 Undefined
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        2
       bAlternateSetting       3
       bNumEndpoints           1
       bInterfaceClass         1 Audio
       bInterfaceSubClass      2 Streaming
       bInterfaceProtocol      0
       iInterface              0
       AudioStreaming Interface Descriptor:
         bLength                 7
         bDescriptorType        36
         bDescriptorSubtype      1 (AS_GENERAL)
         bTerminalLink           3
         bDelay                  1 frames
         wFormatTag              1 PCM
       AudioStreaming Interface Descriptor:
         bLength                11
         bDescriptorType        36
         bDescriptorSubtype      2 (FORMAT_TYPE)
         bFormatType             1 (FORMAT_TYPE_I)
         bNrChannels             2
         bSubframeSize           2
         bBitResolution         16
         bSamFreqType            1 Discrete
         tSamFreq[ 0]        32000
       Endpoint Descriptor:
         bLength                 9
         bDescriptorType         5
         bEndpointAddress     0x83  EP 3 IN
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0014  1x 20 bytes
         bInterval               1
         bRefresh                0
         bSynchAddress           0
         AudioControl Endpoint Descriptor:
           bLength                 7
           bDescriptorType        37
           bDescriptorSubtype      1 (EP_GENERAL)
           bmAttributes         0x00
           bLockDelayUnits         0 Undefined
           wLockDelay              0 Undefined
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        2
       bAlternateSetting       4
       bNumEndpoints           1
       bInterfaceClass         1 Audio
       bInterfaceSubClass      2 Streaming
       bInterfaceProtocol      0
       iInterface              0
       AudioStreaming Interface Descriptor:
         bLength                 7
         bDescriptorType        36
         bDescriptorSubtype      1 (AS_GENERAL)
         bTerminalLink           3
         bDelay                  1 frames
         wFormatTag              1 PCM
       AudioStreaming Interface Descriptor:
         bLength                11
         bDescriptorType        36
         bDescriptorSubtype      2 (FORMAT_TYPE)
         bFormatType             1 (FORMAT_TYPE_I)
         bNrChannels             2
         bSubframeSize           2
         bBitResolution         16
         bSamFreqType            1 Discrete
         tSamFreq[ 0]        22050
       Endpoint Descriptor:
         bLength                 9
         bDescriptorType         5
         bEndpointAddress     0x83  EP 3 IN
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x000c  1x 12 bytes
         bInterval               1
         bRefresh                0
         bSynchAddress           0
         AudioControl Endpoint Descriptor:
           bLength                 7
           bDescriptorType        37
           bDescriptorSubtype      1 (EP_GENERAL)
           bmAttributes         0x00
           bLockDelayUnits         0 Undefined
           wLockDelay              0 Undefined
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        2
       bAlternateSetting       5
       bNumEndpoints           1
       bInterfaceClass         1 Audio
       bInterfaceSubClass      2 Streaming
       bInterfaceProtocol      0
       iInterface              0
       AudioStreaming Interface Descriptor:
         bLength                 7
         bDescriptorType        36
         bDescriptorSubtype      1 (AS_GENERAL)
         bTerminalLink           3
         bDelay                  1 frames
         wFormatTag              1 PCM
       AudioStreaming Interface Descriptor:
         bLength                11
         bDescriptorType        36
         bDescriptorSubtype      2 (FORMAT_TYPE)
         bFormatType             1 (FORMAT_TYPE_I)
         bNrChannels             2
         bSubframeSize           2
         bBitResolution         16
         bSamFreqType            1 Discrete
         tSamFreq[ 0]         8000
       Endpoint Descriptor:
         bLength                 9
         bDescriptorType         5
         bEndpointAddress     0x83  EP 3 IN
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0008  1x 8 bytes
         bInterval               1
         bRefresh                0
         bSynchAddress           0
         AudioControl Endpoint Descriptor:
           bLength                 7
           bDescriptorType        37
           bDescriptorSubtype      1 (EP_GENERAL)
           bmAttributes         0x00
           bLockDelayUnits         0 Undefined
           wLockDelay              0 Undefined
Device Qualifier (for other device speed):
   bLength                10
   bDescriptorType         6
   bcdUSB               2.00
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0        64
   bNumConfigurations      1
Device Status:     0x0000
   (Bus Powered)


I'm available if you need to do some tests.


Regards,
-- 
Jean-Grégoire Foulon

