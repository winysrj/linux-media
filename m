Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f47.google.com ([209.85.213.47]:34712 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab3HVUrQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Aug 2013 16:47:16 -0400
Received: by mail-yh0-f47.google.com with SMTP id 29so656072yhl.6
        for <linux-media@vger.kernel.org>; Thu, 22 Aug 2013 13:47:16 -0700 (PDT)
Message-ID: <521678C6.2020908@gmail.com>
Date: Thu, 22 Aug 2013 17:47:02 -0300
From: "Abel S." <abelnicolas1976@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: BDA-2875
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Plugging plate with bda2875 chip does not seem to detect the kernel 
correctly (I think that is not in the list).
This is the message from kernel:


[17419.315987] usb 1-4: new high-speed USB device number 3 using ehci-pci
[17419.448607] usb 1-4: New USB device found, idVendor=eb1a, idProduct=2875
[17419.448615] usb 1-4: New USB device strings: Mfr=0, Product=1, 
SerialNumber=2
[17419.448621] usb 1-4: Product: USB 2875 Device
[17419.448626] usb 1-4: SerialNumber: 123456789ABCD
[17419.575625] em28xx: New device  USB 2875 Device @ 480 Mbps 
(eb1a:2875, interface 0, class 0)
[17419.575632] em28xx: DVB interface 0 found
[17419.575734] em28xx #0: chip ID is em2874
[17419.705441] em28xx #0: found i2c device @ 0xa0 [eeprom]
[17419.719924] em28xx #0: Your board has no unique USB ID.
[17419.719930] em28xx #0: A hint were successfully done, based on i2c 
devicelist hash.
[17419.719934] em28xx #0: This method is not 100% failproof.
[17419.719936] em28xx #0: If the board were missdetected, please email 
this log to:
[17419.719939] em28xx #0:     V4L Mailing List <linux-media@vger.kernel.org>
[17419.719942] em28xx #0: Board detected as EM2874 Leadership ISDBT
[17419.823511] em28xx #0: Identified as EM2874 Leadership ISDBT (card=77)
[17419.823519] em28xx #0: v4l2 driver version 0.1.3
[17419.828468] em28xx #0: V4L2 video device registered as video1
[17419.828896] usbcore: registered new interface driver em28xx
[17419.938874] s921: s921_attach:
[17419.938882] DVB: registering new adapter (em28xx #0)
[17419.938893] usb 1-4: DVB: registering adapter 0 frontend 0 (Sharp 
S921)...
[17419.939834] em28xx #0: Successfully loaded em28xx-dvb
[17419.939842] Em28xx: Initialized (Em28xx dvb Extension) extension

_______________________________________________________________________________________________________

When i load the module with card=0 the message is:


[18217.667516] em28xx: New device  USB 2875 Device @ 480 Mbps 
(eb1a:2875, interface 0, class 0)
[18217.667521] em28xx: DVB interface 0 found
[18217.667617] em28xx #0: chip ID is em2874
[18223.861181] em28xx #0: Your board has no unique USB ID and thus need 
a hint to be detected.
[18223.861186] em28xx #0: You may try to use card=<n> insmod option to 
workaround that.
[18223.861188] em28xx #0: Please send an email with this log to:
[18223.861189] em28xx #0:     V4L Mailing List <linux-media@vger.kernel.org>
[18223.861191] em28xx #0: Board eeprom hash is 0x00000000
[18223.861192] em28xx #0: Board i2c devicelist hash is 0x1b800080
[18223.861193] em28xx #0: Here is a list of valid choices for the 
card=<n> insmod option:
[18223.861195] em28xx #0:     card=0 -> Unknown EM2800 video grabber
[18223.861197] em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
[18223.861198] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
[18223.861200] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
[18223.861201] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
[18223.861202] em28xx #0:     card=5 -> MSI VOX USB 2.0
[18223.861203] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
[18223.861205] em28xx #0:     card=7 -> Leadtek Winfast USB II
[18223.861206] em28xx #0:     card=8 -> Kworld USB2800
[18223.861207] em28xx #0:     card=9 -> Pinnacle Dazzle DVC 
90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2 / 
Plextor ConvertX PX-AV100U
[18223.861209] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
[18223.861210] em28xx #0:     card=11 -> Terratec Hybrid XS
[18223.861212] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
[18223.861213] em28xx #0:     card=13 -> Terratec Prodigy XS
[18223.861214] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview 
Prolink PlayTV USB 2.0
[18223.861216] em28xx #0:     card=15 -> V-Gear PocketTV
[18223.861217] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
[18223.861218] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[18223.861219] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[18223.861221] em28xx #0:     card=19 -> EM2860/SAA711X Reference Design
[18223.861222] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
[18223.861223] em28xx #0:     card=21 -> eMPIA Technology, Inc. 
GrabBeeX+ Video Encoder
[18223.861224] em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam grabber
[18223.861226] em28xx #0:     card=23 -> Huaqi DLCW-130
[18223.861227] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
[18223.861228] em28xx #0:     card=25 -> Gadmei UTV310
[18223.861229] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
[18223.861231] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips 
FM1216ME)
[18223.861232] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
[18223.861233] em28xx #0:     card=29 -> EM2860/TVP5150 Reference Design
[18223.861234] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
[18223.861236] em28xx #0:     card=31 -> Usbgear VD204v9
[18223.861237] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
[18223.861238] em28xx #0:     card=33 -> Elgato Video Capture
[18223.861239] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
[18223.861241] em28xx #0:     card=35 -> Typhoon DVD Maker
[18223.861242] em28xx #0:     card=36 -> NetGMBH Cam
[18223.861243] em28xx #0:     card=37 -> Gadmei UTV330
[18223.861244] em28xx #0:     card=38 -> Yakumo MovieMixer
[18223.861245] em28xx #0:     card=39 -> KWorld PVRTV 300U
[18223.861247] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
[18223.861248] em28xx #0:     card=41 -> Kworld 350 U DVB-T
[18223.861249] em28xx #0:     card=42 -> Kworld 355 U DVB-T
[18223.861250] em28xx #0:     card=43 -> Terratec Cinergy T XS
[18223.861252] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[18223.861253] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
[18223.861254] em28xx #0:     card=46 -> Compro, VideoMate U3
[18223.861255] em28xx #0:     card=47 -> KWorld DVB-T 305U
[18223.861256] em28xx #0:     card=48 -> KWorld DVB-T 310U
[18223.861258] em28xx #0:     card=49 -> MSI DigiVox A/D
[18223.861259] em28xx #0:     card=50 -> MSI DigiVox A/D II
[18223.861260] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
[18223.861261] em28xx #0:     card=52 -> DNT DA2 Hybrid
[18223.861263] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
[18223.861264] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
[18223.861265] em28xx #0:     card=55 -> Terratec Cinnergy Hybrid T USB 
XS (em2882)
[18223.861267] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (330e)
[18223.861268] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[18223.861269] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
[18223.861270] em28xx #0:     card=59 -> (null)
[18223.861271] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
[18223.861273] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[18223.861274] em28xx #0:     card=62 -> Gadmei TVR200
[18223.861275] em28xx #0:     card=63 -> Kaiomy TVnPC U2
[18223.861276] em28xx #0:     card=64 -> Easy Cap Capture DC-60
[18223.861278] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
[18223.861279] em28xx #0:     card=66 -> Empire dual TV
[18223.861280] em28xx #0:     card=67 -> Terratec Grabby
[18223.861281] em28xx #0:     card=68 -> Terratec AV350
[18223.861283] em28xx #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[18223.861284] em28xx #0:     card=70 -> Evga inDtube
[18223.861285] em28xx #0:     card=71 -> Silvercrest Webcam 1.3mpix
[18223.861286] em28xx #0:     card=72 -> Gadmei UTV330+
[18223.861287] em28xx #0:     card=73 -> Reddo DVB-C USB TV Box
[18223.861289] em28xx #0:     card=74 -> Actionmaster/LinXcel/Digitus VC211A
[18223.861290] em28xx #0:     card=75 -> Dikom DK300
[18223.861291] em28xx #0:     card=76 -> KWorld PlusTV 340U or UB435-Q 
(ATSC)
[18223.861292] em28xx #0:     card=77 -> EM2874 Leadership ISDBT
[18223.861294] em28xx #0:     card=78 -> PCTV nanoStick T2 290e
[18223.861295] em28xx #0:     card=79 -> Terratec Cinergy H5
[18223.861296] em28xx #0:     card=80 -> PCTV DVB-S2 Stick (460e)
[18223.861297] em28xx #0:     card=81 -> Hauppauge WinTV HVR 930C
[18223.861299] em28xx #0:     card=82 -> Terratec Cinergy HTC Stick
[18223.861300] em28xx #0:     card=83 -> Honestech Vidbox NW03
[18223.861301] em28xx #0:     card=84 -> MaxMedia UB425-TC
[18223.861302] em28xx #0:     card=85 -> PCTV QuatroStick (510e)
[18223.861304] em28xx #0:     card=86 -> PCTV QuatroStick nano (520e)
[18223.861305] em28xx #0:     card=87 -> Terratec Cinergy HTC USB XS
[18223.861306] em28xx #0: Board not discovered
[18223.861308] em28xx #0: Identified as Unknown EM2800 video grabber 
(card=0)
[18223.861309] em28xx #0: Your board has no unique USB ID and thus need 
a hint to be detected.
[18223.861310] em28xx #0: You may try to use card=<n> insmod option to 
workaround that.
[18223.861311] em28xx #0: Please send an email with this log to:
[18223.861312] em28xx #0:     V4L Mailing List <linux-media@vger.kernel.org>
[18223.861314] em28xx #0: Board eeprom hash is 0x00000000
[18223.861315] em28xx #0: Board i2c devicelist hash is 0x1b800080
[18223.861316] em28xx #0: Here is a list of valid choices for the 
card=<n> insmod option:
[18223.861317] em28xx #0:     card=0 -> Unknown EM2800 video grabber
[18223.861319] em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
[18223.861320] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
[18223.861321] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
[18223.861322] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
[18223.861324] em28xx #0:     card=5 -> MSI VOX USB 2.0
[18223.861325] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
[18223.861326] em28xx #0:     card=7 -> Leadtek Winfast USB II
[18223.861327] em28xx #0:     card=8 -> Kworld USB2800
[18223.861329] em28xx #0:     card=9 -> Pinnacle Dazzle DVC 
90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2 / 
Plextor ConvertX PX-AV100U
[18223.861330] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
[18223.861331] em28xx #0:     card=11 -> Terratec Hybrid XS
[18223.861333] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
[18223.861334] em28xx #0:     card=13 -> Terratec Prodigy XS
[18223.861335] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview 
Prolink PlayTV USB 2.0
[18223.861336] em28xx #0:     card=15 -> V-Gear PocketTV
[18223.861338] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
[18223.861339] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[18223.861340] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[18223.861341] em28xx #0:     card=19 -> EM2860/SAA711X Reference Design
[18223.861343] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
[18223.861344] em28xx #0:     card=21 -> eMPIA Technology, Inc. 
GrabBeeX+ Video Encoder
[18223.861345] em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam grabber
[18223.861347] em28xx #0:     card=23 -> Huaqi DLCW-130
[18223.861348] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
[18223.861349] em28xx #0:     card=25 -> Gadmei UTV310
[18223.861350] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
[18223.861352] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips 
FM1216ME)
[18223.861353] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
[18223.861354] em28xx #0:     card=29 -> EM2860/TVP5150 Reference Design
[18223.861355] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
[18223.861357] em28xx #0:     card=31 -> Usbgear VD204v9
[18223.861358] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
[18223.861359] em28xx #0:     card=33 -> Elgato Video Capture
[18223.861360] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
[18223.861362] em28xx #0:     card=35 -> Typhoon DVD Maker
[18223.861363] em28xx #0:     card=36 -> NetGMBH Cam
[18223.861364] em28xx #0:     card=37 -> Gadmei UTV330
[18223.861365] em28xx #0:     card=38 -> Yakumo MovieMixer
[18223.861366] em28xx #0:     card=39 -> KWorld PVRTV 300U
[18223.861368] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
[18223.861369] em28xx #0:     card=41 -> Kworld 350 U DVB-T
[18223.861370] em28xx #0:     card=42 -> Kworld 355 U DVB-T
[18223.861371] em28xx #0:     card=43 -> Terratec Cinergy T XS
[18223.861373] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[18223.861374] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
[18223.861375] em28xx #0:     card=46 -> Compro, VideoMate U3
[18223.861376] em28xx #0:     card=47 -> KWorld DVB-T 305U
[18223.861378] em28xx #0:     card=48 -> KWorld DVB-T 310U
[18223.861379] em28xx #0:     card=49 -> MSI DigiVox A/D
[18223.861380] em28xx #0:     card=50 -> MSI DigiVox A/D II
[18223.861381] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
[18223.861382] em28xx #0:     card=52 -> DNT DA2 Hybrid
[18223.861384] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
[18223.861385] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
[18223.861386] em28xx #0:     card=55 -> Terratec Cinnergy Hybrid T USB 
XS (em2882)
[18223.861387] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (330e)
[18223.861389] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[18223.861390] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
[18223.861391] em28xx #0:     card=59 -> (null)
[18223.861392] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
[18223.861394] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[18223.861395] em28xx #0:     card=62 -> Gadmei TVR200
[18223.861396] em28xx #0:     card=63 -> Kaiomy TVnPC U2
[18223.861397] em28xx #0:     card=64 -> Easy Cap Capture DC-60
[18223.861399] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
[18223.861400] em28xx #0:     card=66 -> Empire dual TV
[18223.861401] em28xx #0:     card=67 -> Terratec Grabby
[18223.861402] em28xx #0:     card=68 -> Terratec AV350
[18223.861403] em28xx #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[18223.861405] em28xx #0:     card=70 -> Evga inDtube
[18223.861406] em28xx #0:     card=71 -> Silvercrest Webcam 1.3mpix
[18223.861407] em28xx #0:     card=72 -> Gadmei UTV330+
[18223.861408] em28xx #0:     card=73 -> Reddo DVB-C USB TV Box
[18223.861409] em28xx #0:     card=74 -> Actionmaster/LinXcel/Digitus VC211A
[18223.861411] em28xx #0:     card=75 -> Dikom DK300
[18223.861412] em28xx #0:     card=76 -> KWorld PlusTV 340U or UB435-Q 
(ATSC)
[18223.861413] em28xx #0:     card=77 -> EM2874 Leadership ISDBT
[18223.861414] em28xx #0:     card=78 -> PCTV nanoStick T2 290e
[18223.861416] em28xx #0:     card=79 -> Terratec Cinergy H5
[18223.861417] em28xx #0:     card=80 -> PCTV DVB-S2 Stick (460e)
[18223.861418] em28xx #0:     card=81 -> Hauppauge WinTV HVR 930C
[18223.861419] em28xx #0:     card=82 -> Terratec Cinergy HTC Stick
[18223.861421] em28xx #0:     card=83 -> Honestech Vidbox NW03
[18223.861422] em28xx #0:     card=84 -> MaxMedia UB425-TC
[18223.861423] em28xx #0:     card=85 -> PCTV QuatroStick (510e)
[18223.861424] em28xx #0:     card=86 -> PCTV QuatroStick nano (520e)
[18223.861426] em28xx #0:     card=87 -> Terratec Cinergy HTC USB XS
[18224.065002] em28xx #0: v4l2 driver version 0.1.3
[18224.070263] em28xx #0: V4L2 video device registered as video1
[18224.070717] usbcore: registered new interface driver em28xx


I hope this information will be useful for future releases  ;)
and excuse me, my english is bad

