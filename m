Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:50838 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbaFGDHN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jun 2014 23:07:13 -0400
Received: by mail-wg0-f47.google.com with SMTP id k14so2693626wgh.30
        for <linux-media@vger.kernel.org>; Fri, 06 Jun 2014 20:07:11 -0700 (PDT)
Received: from [192.168.1.68] (host-78-149-212-195.as13285.net. [78.149.212.195])
        by mx.google.com with ESMTPSA id 18sm14693981wju.15.2014.06.06.20.07.09
        for <linux-media@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Jun 2014 20:07:10 -0700 (PDT)
Message-ID: <539281DC.102@gmail.com>
Date: Sat, 07 Jun 2014 04:07:08 +0100
From: Alexi Nones <alexi.nones@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: em28xx: New device @ 480 Mbps (eb1a:2861, interface 0, class 0)
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I've made tests with an August ​device.​

Model: August VGB200 USB 2.0 Video capture adapter
idVendor=eb1a, idProduct=2861

I couldn't get analogue capture to work in Debian Linux using VLC​.

The manufacturer's website for the device is: 
http://www.augustint.com/en/productmsg-90-125.html

Tested by​:Alexi Nones <alexi.nones@gmail.com>

​The output of d​mesg is:

[   35.990801] usb 4-2: new high-speed USB device number 2 using ehci-pci
[   36.123101] usb 4-2: New USB device found, idVendor=eb1a, idProduct=2861
[   36.123109] usb 4-2: New USB device strings: Mfr=0, Product=0, 
SerialNumber=0
[   36.145793] media: Linux media interface: v0.10
[   36.151799] Linux video capture interface: v2.00
[   36.155113] em28xx: New device   @ 480 Mbps (eb1a:2861, interface 0, 
class 0)
[   36.155115] em28xx: Video interface 0 found: isoc
[   36.155535] em28xx: chip ID is em2860
[   36.280956] em2860 #0: unknown eeprom format or eeprom corrupted !
[   36.293007] em2860 #0: couldn't read from i2c device 0xb8: error -6
[   36.303418] em2860 #0: couldn't read from i2c device 0xba: error -6
[   36.317647] em2860 #0: couldn't read from i2c device 0x90: error -6
[   36.327452] em2860 #0: couldn't read from i2c device 0x42: error -6
[   36.341609] em2860 #0: couldn't read from i2c device 0x60: error -6
[   36.341616] em2860 #0: No sensor detected
[   36.357157] em2860 #0: found i2c device @ 0x4a on bus 0 [saa7113h]
[   36.375668] em2860 #0: found i2c device @ 0xa0 on bus 0 [eeprom]
[   36.395093] em2860 #0: Your board has no unique USB ID and thus need 
a hint to be detected.
[   36.395100] em2860 #0: You may try to use card=<n> insmod option to 
workaround that.
[   36.395103] em2860 #0: Please send an email with this log to:
[   36.395105] em2860 #0: V4L Mailing List <linux-media@vger.kernel.org>
[   36.395108] em2860 #0: Board eeprom hash is 0x00000000
[   36.395111] em2860 #0: Board i2c devicelist hash is 0x6ba50080
[   36.395113] em2860 #0: Here is a list of valid choices for the 
card=<n> insmod option:
[   36.395116] em2860 #0:     card=0 -> Unknown EM2800 video grabber
[   36.395119] em2860 #0:     card=1 -> Unknown EM2750/28xx video grabber
[   36.395122] em2860 #0:     card=2 -> Terratec Cinergy 250 USB
[   36.395124] em2860 #0:     card=3 -> Pinnacle PCTV USB 2
[   36.395127] em2860 #0:     card=4 -> Hauppauge WinTV USB 2
[   36.395129] em2860 #0:     card=5 -> MSI VOX USB 2.0
[   36.395131] em2860 #0:     card=6 -> Terratec Cinergy 200 USB
[   36.395134] em2860 #0:     card=7 -> Leadtek Winfast USB II
[   36.395136] em2860 #0:     card=8 -> Kworld USB2800
[   36.395139] em2860 #0:     card=9 -> Pinnacle Dazzle DVC 
90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2 / 
Plextor ConvertX PX-AV100U
[   36.395141] em2860 #0:     card=10 -> Hauppauge WinTV HVR 900
[   36.395143] em2860 #0:     card=11 -> Terratec Hybrid XS
[   36.395146] em2860 #0:     card=12 -> Kworld PVR TV 2800 RF
[   36.395148] em2860 #0:     card=13 -> Terratec Prodigy XS
[   36.395150] em2860 #0:     card=14 -> SIIG AVTuner-PVR / Pixelview 
Prolink PlayTV USB 2.0
[   36.395153] em2860 #0:     card=15 -> V-Gear PocketTV
[   36.395155] em2860 #0:     card=16 -> Hauppauge WinTV HVR 950
[   36.395157] em2860 #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[   36.395159] em2860 #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[   36.395162] em2860 #0:     card=19 -> EM2860/SAA711X Reference Design
[   36.395164] em2860 #0:     card=20 -> AMD ATI TV Wonder HD 600
[   36.395166] em2860 #0:     card=21 -> eMPIA Technology, Inc. 
GrabBeeX+ Video Encoder
[   36.395169] em2860 #0:     card=22 -> EM2710/EM2750/EM2751 webcam grabber
[   36.395171] em2860 #0:     card=23 -> Huaqi DLCW-130
[   36.395173] em2860 #0:     card=24 -> D-Link DUB-T210 TV Tuner
[   36.395176] em2860 #0:     card=25 -> Gadmei UTV310
[   36.395178] em2860 #0:     card=26 -> Hercules Smart TV USB 2.0
[   36.395180] em2860 #0:     card=27 -> Pinnacle PCTV USB 2 (Philips 
FM1216ME)
[   36.395183] em2860 #0:     card=28 -> Leadtek Winfast USB II Deluxe
[   36.395185] em2860 #0:     card=29 -> EM2860/TVP5150 Reference Design
[   36.395187] em2860 #0:     card=30 -> Videology 20K14XUSB USB2.0
[   36.395190] em2860 #0:     card=31 -> Usbgear VD204v9
[   36.395192] em2860 #0:     card=32 -> Supercomp USB 2.0 TV
[   36.395194] em2860 #0:     card=33 -> Elgato Video Capture
[   36.395196] em2860 #0:     card=34 -> Terratec Cinergy A Hybrid XS
[   36.395199] em2860 #0:     card=35 -> Typhoon DVD Maker
[   36.395201] em2860 #0:     card=36 -> NetGMBH Cam
[   36.395203] em2860 #0:     card=37 -> Gadmei UTV330
[   36.395205] em2860 #0:     card=38 -> Yakumo MovieMixer
[   36.395207] em2860 #0:     card=39 -> KWorld PVRTV 300U
[   36.395210] em2860 #0:     card=40 -> Plextor ConvertX PX-TV100U
[   36.395212] em2860 #0:     card=41 -> Kworld 350 U DVB-T
[   36.395214] em2860 #0:     card=42 -> Kworld 355 U DVB-T
[   36.395217] em2860 #0:     card=43 -> Terratec Cinergy T XS
[   36.395219] em2860 #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[   36.395221] em2860 #0:     card=45 -> Pinnacle PCTV DVB-T
[   36.395224] em2860 #0:     card=46 -> Compro, VideoMate U3
[   36.395226] em2860 #0:     card=47 -> KWorld DVB-T 305U
[   36.395228] em2860 #0:     card=48 -> KWorld DVB-T 310U
[   36.395230] em2860 #0:     card=49 -> MSI DigiVox A/D
[   36.395236] em2860 #0:     card=50 -> MSI DigiVox A/D II
[   36.395243] em2860 #0:     card=51 -> Terratec Hybrid XS Secam
[   36.395244] em2860 #0:     card=52 -> DNT DA2 Hybrid
[   36.395245] em2860 #0:     card=53 -> Pinnacle Hybrid Pro
[   36.395246] em2860 #0:     card=54 -> Kworld VS-DVB-T 323UR
[   36.395247] em2860 #0:     card=55 -> Terratec Cinnergy Hybrid T USB 
XS (em2882)
[   36.395248] em2860 #0:     card=56 -> Pinnacle Hybrid Pro (330e)
[   36.395250] em2860 #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[   36.395251] em2860 #0:     card=58 -> Compro VideoMate ForYou/Stereo
[   36.395252] em2860 #0:     card=59 -> (null)
[   36.395253] em2860 #0:     card=60 -> Hauppauge WinTV HVR 850
[   36.395254] em2860 #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[   36.395255] em2860 #0:     card=62 -> Gadmei TVR200
[   36.395256] em2860 #0:     card=63 -> Kaiomy TVnPC U2
[   36.395257] em2860 #0:     card=64 -> Easy Cap Capture DC-60
[   36.395259] em2860 #0:     card=65 -> IO-DATA GV-MVP/SZ
[   36.395260] em2860 #0:     card=66 -> Empire dual TV
[   36.395261] em2860 #0:     card=67 -> Terratec Grabby
[   36.395262] em2860 #0:     card=68 -> Terratec AV350
[   36.395263] em2860 #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[   36.395264] em2860 #0:     card=70 -> Evga inDtube
[   36.395265] em2860 #0:     card=71 -> Silvercrest Webcam 1.3mpix
[   36.395267] em2860 #0:     card=72 -> Gadmei UTV330+
[   36.395268] em2860 #0:     card=73 -> Reddo DVB-C USB TV Box
[   36.395269] em2860 #0:     card=74 -> Actionmaster/LinXcel/Digitus VC211A
[   36.395270] em2860 #0:     card=75 -> Dikom DK300
[   36.395271] em2860 #0:     card=76 -> KWorld PlusTV 340U or UB435-Q 
(ATSC)
[   36.395272] em2860 #0:     card=77 -> EM2874 Leadership ISDBT
[   36.395274] em2860 #0:     card=78 -> PCTV nanoStick T2 290e
[   36.395275] em2860 #0:     card=79 -> Terratec Cinergy H5
[   36.395276] em2860 #0:     card=80 -> PCTV DVB-S2 Stick (460e)
[   36.395277] em2860 #0:     card=81 -> Hauppauge WinTV HVR 930C
[   36.395278] em2860 #0:     card=82 -> Terratec Cinergy HTC Stick
[   36.395279] em2860 #0:     card=83 -> Honestech Vidbox NW03
[   36.395280] em2860 #0:     card=84 -> MaxMedia UB425-TC
[   36.395281] em2860 #0:     card=85 -> PCTV QuatroStick (510e)
[   36.395283] em2860 #0:     card=86 -> PCTV QuatroStick nano (520e)
[   36.395284] em2860 #0:     card=87 -> Terratec Cinergy HTC USB XS
[   36.395285] em2860 #0:     card=88 -> C3 Tech Digital Duo HDTV/SDTV USB
[   36.395286] em2860 #0:     card=89 -> Delock 61959
[   36.395287] em2860 #0:     card=90 -> KWorld USB ATSC TV Stick UB435-Q V2
[   36.395288] em2860 #0:     card=91 -> SpeedLink Vicious And Devine 
Laplace webcam
[   36.395290] em2860 #0:     card=92 -> PCTV DVB-S2 Stick (461e)
[   36.395291] em2860 #0: Board not discovered
[   36.395292] em2860 #0: Identified as Unknown EM2750/28xx video 
grabber (card=1)
[   36.395293] em2860 #0: Your board has no unique USB ID and thus need 
a hint to be detected.
[   36.395294] em2860 #0: You may try to use card=<n> insmod option to 
workaround that.
[   36.395295] em2860 #0: Please send an email with this log to:
[   36.395296] em2860 #0: V4L Mailing List <linux-media@vger.kernel.org>
[   36.395297] em2860 #0: Board eeprom hash is 0x00000000
[   36.395299] em2860 #0: Board i2c devicelist hash is 0x6ba50080
[   36.395300] em2860 #0: Here is a list of valid choices for the 
card=<n> insmod option:
[   36.395301] em2860 #0:     card=0 -> Unknown EM2800 video grabber
[   36.395302] em2860 #0:     card=1 -> Unknown EM2750/28xx video grabber
[   36.395303] em2860 #0:     card=2 -> Terratec Cinergy 250 USB
[   36.395304] em2860 #0:     card=3 -> Pinnacle PCTV USB 2
[   36.395305] em2860 #0:     card=4 -> Hauppauge WinTV USB 2
[   36.395306] em2860 #0:     card=5 -> MSI VOX USB 2.0
[   36.395308] em2860 #0:     card=6 -> Terratec Cinergy 200 USB
[   36.395309] em2860 #0:     card=7 -> Leadtek Winfast USB II
[   36.395310] em2860 #0:     card=8 -> Kworld USB2800
[   36.395311] em2860 #0:     card=9 -> Pinnacle Dazzle DVC 
90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2 / 
Plextor ConvertX PX-AV100U
[   36.395312] em2860 #0:     card=10 -> Hauppauge WinTV HVR 900
[   36.395314] em2860 #0:     card=11 -> Terratec Hybrid XS
[   36.395315] em2860 #0:     card=12 -> Kworld PVR TV 2800 RF
[   36.395316] em2860 #0:     card=13 -> Terratec Prodigy XS
[   36.395317] em2860 #0:     card=14 -> SIIG AVTuner-PVR / Pixelview 
Prolink PlayTV USB 2.0
[   36.395318] em2860 #0:     card=15 -> V-Gear PocketTV
[   36.395319] em2860 #0:     card=16 -> Hauppauge WinTV HVR 950
[   36.395320] em2860 #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[   36.395322] em2860 #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[   36.395323] em2860 #0:     card=19 -> EM2860/SAA711X Reference Design
[   36.395324] em2860 #0:     card=20 -> AMD ATI TV Wonder HD 600
[   36.395325] em2860 #0:     card=21 -> eMPIA Technology, Inc. 
GrabBeeX+ Video Encoder
[   36.395326] em2860 #0:     card=22 -> EM2710/EM2750/EM2751 webcam grabber
[   36.395327] em2860 #0:     card=23 -> Huaqi DLCW-130
[   36.395329] em2860 #0:     card=24 -> D-Link DUB-T210 TV Tuner
[   36.395330] em2860 #0:     card=25 -> Gadmei UTV310
[   36.395331] em2860 #0:     card=26 -> Hercules Smart TV USB 2.0
[   36.395332] em2860 #0:     card=27 -> Pinnacle PCTV USB 2 (Philips 
FM1216ME)
[   36.395333] em2860 #0:     card=28 -> Leadtek Winfast USB II Deluxe
[   36.395334] em2860 #0:     card=29 -> EM2860/TVP5150 Reference Design
[   36.395335] em2860 #0:     card=30 -> Videology 20K14XUSB USB2.0
[   36.395337] em2860 #0:     card=31 -> Usbgear VD204v9
[   36.395338] em2860 #0:     card=32 -> Supercomp USB 2.0 TV
[   36.395339] em2860 #0:     card=33 -> Elgato Video Capture
[   36.395340] em2860 #0:     card=34 -> Terratec Cinergy A Hybrid XS
[   36.395341] em2860 #0:     card=35 -> Typhoon DVD Maker
[   36.395342] em2860 #0:     card=36 -> NetGMBH Cam
[   36.395343] em2860 #0:     card=37 -> Gadmei UTV330
[   36.395345] em2860 #0:     card=38 -> Yakumo MovieMixer
[   36.395346] em2860 #0:     card=39 -> KWorld PVRTV 300U
[   36.395347] em2860 #0:     card=40 -> Plextor ConvertX PX-TV100U
[   36.395348] em2860 #0:     card=41 -> Kworld 350 U DVB-T
[   36.395349] em2860 #0:     card=42 -> Kworld 355 U DVB-T
[   36.395350] em2860 #0:     card=43 -> Terratec Cinergy T XS
[   36.395351] em2860 #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[   36.395352] em2860 #0:     card=45 -> Pinnacle PCTV DVB-T
[   36.395354] em2860 #0:     card=46 -> Compro, VideoMate U3
[   36.395355] em2860 #0:     card=47 -> KWorld DVB-T 305U
[   36.395356] em2860 #0:     card=48 -> KWorld DVB-T 310U
[   36.395357] em2860 #0:     card=49 -> MSI DigiVox A/D
[   36.395358] em2860 #0:     card=50 -> MSI DigiVox A/D II
[   36.395359] em2860 #0:     card=51 -> Terratec Hybrid XS Secam
[   36.395360] em2860 #0:     card=52 -> DNT DA2 Hybrid
[   36.395361] em2860 #0:     card=53 -> Pinnacle Hybrid Pro
[   36.395362] em2860 #0:     card=54 -> Kworld VS-DVB-T 323UR
[   36.395364] em2860 #0:     card=55 -> Terratec Cinnergy Hybrid T USB 
XS (em2882)
[   36.395365] em2860 #0:     card=56 -> Pinnacle Hybrid Pro (330e)
[   36.395366] em2860 #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[   36.395367] em2860 #0:     card=58 -> Compro VideoMate ForYou/Stereo
[   36.395368] em2860 #0:     card=59 -> (null)
[   36.395369] em2860 #0:     card=60 -> Hauppauge WinTV HVR 850
[   36.395370] em2860 #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[   36.395372] em2860 #0:     card=62 -> Gadmei TVR200
[   36.395373] em2860 #0:     card=63 -> Kaiomy TVnPC U2
[   36.395374] em2860 #0:     card=64 -> Easy Cap Capture DC-60
[   36.395375] em2860 #0:     card=65 -> IO-DATA GV-MVP/SZ
[   36.395376] em2860 #0:     card=66 -> Empire dual TV
[   36.395377] em2860 #0:     card=67 -> Terratec Grabby
[   36.395378] em2860 #0:     card=68 -> Terratec AV350
[   36.395379] em2860 #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[   36.395380] em2860 #0:     card=70 -> Evga inDtube
[   36.395382] em2860 #0:     card=71 -> Silvercrest Webcam 1.3mpix
[   36.395383] em2860 #0:     card=72 -> Gadmei UTV330+
[   36.395384] em2860 #0:     card=73 -> Reddo DVB-C USB TV Box
[   36.395385] em2860 #0:     card=74 -> Actionmaster/LinXcel/Digitus VC211A
[   36.395386] em2860 #0:     card=75 -> Dikom DK300
[   36.395387] em2860 #0:     card=76 -> KWorld PlusTV 340U or UB435-Q 
(ATSC)
[   36.395388] em2860 #0:     card=77 -> EM2874 Leadership ISDBT
[   36.395389] em2860 #0:     card=78 -> PCTV nanoStick T2 290e
[   36.395391] em2860 #0:     card=79 -> Terratec Cinergy H5
[   36.395392] em2860 #0:     card=80 -> PCTV DVB-S2 Stick (460e)
[   36.395393] em2860 #0:     card=81 -> Hauppauge WinTV HVR 930C
[   36.395394] em2860 #0:     card=82 -> Terratec Cinergy HTC Stick
[   36.395395] em2860 #0:     card=83 -> Honestech Vidbox NW03
[   36.395396] em2860 #0:     card=84 -> MaxMedia UB425-TC
[   36.395397] em2860 #0:     card=85 -> PCTV QuatroStick (510e)
[   36.395399] em2860 #0:     card=86 -> PCTV QuatroStick nano (520e)
[   36.395400] em2860 #0:     card=87 -> Terratec Cinergy HTC USB XS
[   36.395401] em2860 #0:     card=88 -> C3 Tech Digital Duo HDTV/SDTV USB
[   36.395402] em2860 #0:     card=89 -> Delock 61959
[   36.395403] em2860 #0:     card=90 -> KWorld USB ATSC TV Stick UB435-Q V2
[   36.395404] em2860 #0:     card=91 -> SpeedLink Vicious And Devine 
Laplace webcam
[   36.395405] em2860 #0:     card=92 -> PCTV DVB-S2 Stick (461e)
[   36.395407] em2860 #0: analog set to isoc mode.
[   36.395478] usbcore: registered new interface driver em28xx
[   36.411048] em2860 #0: Registering V4L2 extension
[   36.439342] [UFW BLOCK] IN=wlan0 OUT= MAC= 
SRC=fe80:0000:0000:0000:ae22:0bff:fe95:8a4e 
DST=ff02:0000:0000:0000:0000:0000:0000:0001 LEN=64 TC=0 HOPLIMIT=1 
FLOWLBL=0 PROTO=UDP SPT=8612 DPT=8612 LEN=24
[   36.449606] [UFW BLOCK] IN=wlan0 OUT= MAC= 
SRC=fe80:0000:0000:0000:ae22:0bff:fe95:8a4e 
DST=ff02:0000:0000:0000:0000:0000:0000:0001 LEN=64 TC=0 HOPLIMIT=1 
FLOWLBL=0 PROTO=UDP SPT=8612 DPT=8612 LEN=24
[   36.973859] em2860 #0: V4L2 video device registered as video0
[   36.973865] em2860 #0: V4L2 VBI device registered as vbi0
[   36.973867] em2860 #0: V4L2 extension successfully initialized
[   36.973870] em28xx: Registered (Em28xx v4l2 Extension) extension
