Return-path: <linux-media-owner@vger.kernel.org>
Received: from web26507.mail.ukl.yahoo.com ([217.146.176.44]:42170 "HELO
	web26507.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753378AbZEOS2J convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 May 2009 14:28:09 -0400
Message-ID: <948400.69790.qm@web26507.mail.ukl.yahoo.com>
Date: Fri, 15 May 2009 18:28:08 +0000 (GMT)
From: Lars Hansen <lars.hansen@yahoo.co.uk>
Subject: log of em28xx based KWorld DVB-T310U as requested by driver
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hello,
 
here is the dmesg for the USB tv stick I purchased as Kworld/V-Stream DVB-T310U DVB-T/Analog-Tuner,USB Stick.
It indeed seems to be from KWorld according to its labelling :-)
 
Picture works in tvtime. No sound. arecord -l lists no audio capture device other than my audio chips.
V4L2 used is v4l-dvb-83712d149893.
 
Markus Rechberger got sound to work back in Ubuntu 8.04 days with a vanilla kernel I compiled. I used his driver though.
 
The card= options needs to be 48. It gets autodetected to 49. Perhaps a typo somewhere. Using 48 I get the dmesg I attach below the first. The only difference seems to be the registering of the dvb-t interface.
 
Ubuntu 9.04 autoloads the driver. Where would I have to insert the card=48 option (twice it may appear from the dmesg)?
 
Do you have help on getting analog sound to work here?
 
 
[ 10.951996] em28xx: New device USB 2881 Device @ 480 Mbps (eb1a:e310, interface 0, class 0)
[ 10.952019] em28xx #0: Identified as MSI DigiVox A/D (card=49)
[ 10.952213] em28xx #0: chip ID is em2882/em2883
[ 11.019577] ath_hal: module license 'Proprietary' taints kernel.
[ 11.021383] AR5210, AR5211, AR5212, AR5416, RF5111, RF5112, RF2413, RF5413, RF2133, RF2425, RF2417)
[ 11.120218] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 10 e3 d0 12 5c 03 6a 22 00 00
[ 11.120227] em28xx #0: i2c eeprom 10: 00 00 04 57 4e 07 00 00 00 00 00 00 00 00 00 00
[ 11.120233] em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 01 00 00 00 00 00 5b 1e 00 00
[ 11.120239] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 00 00 00 00 00 00
[ 11.120245] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 11.120251] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 11.120257] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 22 03 55 00 53 00
[ 11.120262] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 38 00 31 00 20 00 44 00
[ 11.120268] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00 00 00 00 00 00 00
[ 11.120274] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 11.120280] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 11.120286] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 11.120292] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 11.120297] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 11.120303] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 11.120309] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 11.120316] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x166a0441
[ 11.120318] em28xx #0: EEPROM info:
[ 11.120319] em28xx #0: AC97 audio (5 sample rates)
[ 11.120321] em28xx #0: 500mA max power
[ 11.120322] em28xx #0: Table at 0x04, strings=0x226a, 0x0000, 0x0000
[ 11.126494] em28xx #0: found i2c device @ 0x1e [???]
[ 11.167853] em28xx #0: found i2c device @ 0xa0 [eeprom]
[ 11.173598] em28xx #0: found i2c device @ 0xb8 [tvp5150a]
[ 11.175476] em28xx #0: found i2c device @ 0xc2 [tuner (analog)]
[ 11.187855] em28xx #0: Your board has no unique USB ID and thus need a hint to be detected.
[ 11.187859] em28xx #0: You may try to use card=<n> insmod option to workaround that.
[ 11.187861] em28xx #0: Please send an email with this log to:
[ 11.187862] em28xx #0: V4L Mailing List <linux-media@vger.kernel.org>
[ 11.187864] em28xx #0: Board eeprom hash is 0x166a0441
[ 11.187866] em28xx #0: Board i2c devicelist hash is 0x944d008f
[ 11.187867] em28xx #0: Here is a list of valid choices for the card=<n> insmod option:
[ 11.187869] em28xx #0: card=0 -> Unknown EM2800 video grabber
[ 11.187871] em28xx #0: card=1 -> Unknown EM2750/28xx video grabber
[ 11.187873] em28xx #0: card=2 -> Terratec Cinergy 250 USB
[ 11.187875] em28xx #0: card=3 -> Pinnacle PCTV USB 2
[ 11.187877] em28xx #0: card=4 -> Hauppauge WinTV USB 2
[ 11.187878] em28xx #0: card=5 -> MSI VOX USB 2.0
[ 11.187880] em28xx #0: card=6 -> Terratec Cinergy 200 USB
[ 11.187882] em28xx #0: card=7 -> Leadtek Winfast USB II
[ 11.187883] em28xx #0: card=8 -> Kworld USB2800
[ 11.187885] em28xx #0: card=9 -> Pinnacle Dazzle DVC 90/100/101/107 / Kaiser Baas Video to DVD maker
[ 11.187887] em28xx #0: card=10 -> Hauppauge WinTV HVR 900
[ 11.187889] em28xx #0: card=11 -> Terratec Hybrid XS
[ 11.187891] em28xx #0: card=12 -> Kworld PVR TV 2800 RF
[ 11.187893] em28xx #0: card=13 -> Terratec Prodigy XS
[ 11.187894] em28xx #0: card=14 -> SIIG AVTuner-PVR / Pixelview Prolink PlayTV USB 2.0
[ 11.187896] em28xx #0: card=15 -> V-Gear PocketTV
[ 11.187898] em28xx #0: card=16 -> Hauppauge WinTV HVR 950
[ 11.187900] em28xx #0: card=17 -> Pinnacle PCTV HD Pro Stick
[ 11.187901] em28xx #0: card=18 -> Hauppauge WinTV HVR 900 (R2)
[ 11.187903] em28xx #0: card=19 -> PointNix Intra-Oral Camera
[ 11.187905] em28xx #0: card=20 -> AMD ATI TV Wonder HD 600
[ 11.187907] em28xx #0: card=21 -> eMPIA Technology, Inc. GrabBeeX+ Video Encoder
[ 11.187909] em28xx #0: card=22 -> Unknown EM2750/EM2751 webcam grabber
[ 11.187911] em28xx #0: card=23 -> Huaqi DLCW-130
[ 11.187912] em28xx #0: card=24 -> D-Link DUB-T210 TV Tuner
[ 11.187914] em28xx #0: card=25 -> Gadmei UTV310
[ 11.187916] em28xx #0: card=26 -> Hercules Smart TV USB 2.0
[ 11.187917] em28xx #0: card=27 -> Pinnacle PCTV USB 2 (Philips FM1216ME)
[ 11.187919] em28xx #0: card=28 -> Leadtek Winfast USB II Deluxe
[ 11.187921] em28xx #0: card=29 -> <NULL>
[ 11.187923] em28xx #0: card=30 -> Videology 20K14XUSB USB2.0
[ 11.187924] em28xx #0: card=31 -> Usbgear VD204v9
[ 11.187926] em28xx #0: card=32 -> Supercomp USB 2.0 TV
[ 11.187928] em28xx #0: card=33 -> <NULL>
[ 11.187929] em28xx #0: card=34 -> Terratec Cinergy A Hybrid XS
[ 11.187931] em28xx #0: card=35 -> Typhoon DVD Maker
[ 11.187933] em28xx #0: card=36 -> NetGMBH Cam
[ 11.187934] em28xx #0: card=37 -> Gadmei UTV330
[ 11.187936] em28xx #0: card=38 -> Yakumo MovieMixer
[ 11.187937] em28xx #0: card=39 -> KWorld PVRTV 300U
[ 11.187939] em28xx #0: card=40 -> Plextor ConvertX PX-TV100U
[ 11.187941] em28xx #0: card=41 -> Kworld 350 U DVB-T
[ 11.187942] em28xx #0: card=42 -> Kworld 355 U DVB-T
[ 11.187944] em28xx #0: card=43 -> Terratec Cinergy T XS
[ 11.187946] em28xx #0: card=44 -> Terratec Cinergy T XS (MT2060)
[ 11.187948] em28xx #0: card=45 -> Pinnacle PCTV DVB-T
[ 11.187949] em28xx #0: card=46 -> Compro, VideoMate U3
[ 11.187951] em28xx #0: card=47 -> KWorld DVB-T 305U
[ 11.187953] em28xx #0: card=48 -> KWorld DVB-T 310U
[ 11.187954] em28xx #0: card=49 -> MSI DigiVox A/D
[ 11.187956] em28xx #0: card=50 -> MSI DigiVox A/D II
[ 11.187958] em28xx #0: card=51 -> Terratec Hybrid XS Secam
[ 11.187959] em28xx #0: card=52 -> DNT DA2 Hybrid
[ 11.187961] em28xx #0: card=53 -> Pinnacle Hybrid Pro
[ 11.187963] em28xx #0: card=54 -> Kworld VS-DVB-T 323UR
[ 11.187964] em28xx #0: card=55 -> Terratec Hybrid XS (em2882)
[ 11.187966] em28xx #0: card=56 -> Pinnacle Hybrid Pro (2)
[ 11.187968] em28xx #0: card=57 -> Kworld PlusTV HD Hybrid 330
[ 11.187970] em28xx #0: card=58 -> Compro VideoMate ForYou/Stereo
[ 11.187972] em28xx #0: card=59 -> <NULL>
[ 11.187973] em28xx #0: card=60 -> Hauppauge WinTV HVR 850
[ 11.187975] em28xx #0: card=61 -> Pixelview PlayTV Box 4 USB 2.0
[ 11.187977] em28xx #0: card=62 -> Gadmei TVR200
[ 11.187978] em28xx #0: card=63 -> Kaiomy TVnPC U2
[ 11.187980] em28xx #0: card=64 -> Easy Cap Capture DC-60
[ 11.187982] em28xx #0: card=65 -> IO-DATA GV-MVP/SZ
[ 11.187983] em28xx #0: card=66 -> Empire dual TV
[ 11.187985] em28xx #0: 
[ 11.187985] 
[ 11.187987] em28xx #0: The support for this board weren't valid yet.
[ 11.187988] em28xx #0: Please send a report of having this working
[ 11.187990] em28xx #0: not to V4L mailing list (and/or to other addresses)
[ 11.187991] 
[ 11.271207] tvp5150 1-005c: chip found @ 0xb8 (em28xx #0)
[ 11.314441] tuner 1-0061: chip found @ 0xc2 (em28xx #0)
[ 11.330920] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[ 11.433211] xc2028 1-0061: creating new instance
[ 11.433215] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
[ 11.433224] i2c-adapter i2c-1: firmware: requesting xc3028-v27.fw
[ 11.483762] xc2028 1-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
[ 11.532020] xc2028 1-0061: Loading firmware for type=BASE (1), id 0000000000000000.
[ 11.717200] Synaptics Touchpad, model: 1, fw: 6.2, id: 0x1280b1, caps: 0xa04713/0x204000
[ 11.773911] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/input9
[ 12.453729] xc2028 1-0061: Loading firmware for type=(0), id 000000000000b700.
[ 12.467474] SCODE (20000000), id 000000000000b700:
[ 12.467478] xc2028 1-0061: Loading SCODE for type=MONO SCODE HAS_IF_4320 (60008000), id 0000000000008000.
[ 12.648116] em28xx #0: Config register raw data: 0xd0
[ 12.648862] em28xx #0: AC97 vendor ID = 0x414c4740
[ 12.649236] em28xx #0: AC97 features = 0x5990
[ 12.649238] em28xx #0: Unknown AC97 audio processor detected!
[ 12.760500] tvp5150 1-005c: tvp5150am1 detected.
[ 12.860883] em28xx #0: v4l2 driver version 0.1.2
[ 12.927321] em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
[ 12.944043] em28xx: New device USB 2881 Device @ 480 Mbps (eb1a:e310, interface 1, class 1)
[ 12.944051] em28xx #1: Identified as MSI DigiVox A/D (card=49)
[ 12.945758] em28xx #1: chip ID is em2882/em2883
[ 13.103400] em28xx #1: i2c eeprom 00: 1a eb 67 95 1a eb 10 e3 d0 12 5c 03 6a 22 00 00
[ 13.103408] em28xx #1: i2c eeprom 10: 00 00 04 57 4e 07 00 00 00 00 00 00 00 00 00 00
[ 13.103414] em28xx #1: i2c eeprom 20: 46 00 01 00 f0 10 01 00 00 00 00 00 5b 1e 00 00
[ 13.103420] em28xx #1: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 00 00 00 00 00 00
[ 13.103426] em28xx #1: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 13.103432] em28xx #1: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 13.103438] em28xx #1: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 22 03 55 00 53 00
[ 13.103444] em28xx #1: i2c eeprom 70: 42 00 20 00 32 00 38 00 38 00 31 00 20 00 44 00
[ 13.103449] em28xx #1: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00 00 00 00 00 00 00
[ 13.103455] em28xx #1: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 13.103461] em28xx #1: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 13.103467] em28xx #1: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 13.103473] em28xx #1: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 13.103478] em28xx #1: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 13.103484] em28xx #1: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 13.103490] em28xx #1: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 13.103497] em28xx #1: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x166a0441
[ 13.103499] em28xx #1: EEPROM info:
[ 13.103500] em28xx #1: AC97 audio (5 sample rates)
[ 13.103502] em28xx #1: 500mA max power
[ 13.103503] em28xx #1: Table at 0x04, strings=0x226a, 0x0000, 0x0000
[ 13.109528] em28xx #1: found i2c device @ 0x1e [???]
[ 13.134028] em28xx #1: found i2c device @ 0xa0 [eeprom]
[ 13.138654] em28xx #1: found i2c device @ 0xb8 [tvp5150a]
[ 13.140528] em28xx #1: found i2c device @ 0xc2 [tuner (analog)]
[ 13.151780] em28xx #1: Your board has no unique USB ID and thus need a hint to be detected.
[ 13.151783] em28xx #1: You may try to use card=<n> insmod option to workaround that.
[ 13.151785] em28xx #1: Please send an email with this log to:
[ 13.151787] em28xx #1: V4L Mailing List <linux-media@vger.kernel.org>
[ 13.151789] em28xx #1: Board eeprom hash is 0x166a0441
[ 13.151790] em28xx #1: Board i2c devicelist hash is 0x944d008f
[ 13.151792] em28xx #1: Here is a list of valid choices for the card=<n> insmod option:
[ 13.151794] em28xx #1: card=0 -> Unknown EM2800 video grabber
[ 13.151796] em28xx #1: card=1 -> Unknown EM2750/28xx video grabber
[ 13.151798] em28xx #1: card=2 -> Terratec Cinergy 250 USB
[ 13.151800] em28xx #1: card=3 -> Pinnacle PCTV USB 2
[ 13.151802] em28xx #1: card=4 -> Hauppauge WinTV USB 2
[ 13.151803] em28xx #1: card=5 -> MSI VOX USB 2.0
[ 13.151805] em28xx #1: card=6 -> Terratec Cinergy 200 USB
[ 13.151807] em28xx #1: card=7 -> Leadtek Winfast USB II
[ 13.151808] em28xx #1: card=8 -> Kworld USB2800
[ 13.151810] em28xx #1: card=9 -> Pinnacle Dazzle DVC 90/100/101/107 / Kaiser Baas Video to DVD maker
[ 13.151812] em28xx #1: card=10 -> Hauppauge WinTV HVR 900
[ 13.151814] em28xx #1: card=11 -> Terratec Hybrid XS
[ 13.151816] em28xx #1: card=12 -> Kworld PVR TV 2800 RF
[ 13.151817] em28xx #1: card=13 -> Terratec Prodigy XS
[ 13.151819] em28xx #1: card=14 -> SIIG AVTuner-PVR / Pixelview Prolink PlayTV USB 2.0
[ 13.151821] em28xx #1: card=15 -> V-Gear PocketTV
[ 13.151823] em28xx #1: card=16 -> Hauppauge WinTV HVR 950
[ 13.151825] em28xx #1: card=17 -> Pinnacle PCTV HD Pro Stick
[ 13.151826] em28xx #1: card=18 -> Hauppauge WinTV HVR 900 (R2)
[ 13.151828] em28xx #1: card=19 -> PointNix Intra-Oral Camera
[ 13.151830] em28xx #1: card=20 -> AMD ATI TV Wonder HD 600
[ 13.151832] em28xx #1: card=21 -> eMPIA Technology, Inc. GrabBeeX+ Video Encoder
[ 13.151834] em28xx #1: card=22 -> Unknown EM2750/EM2751 webcam grabber
[ 13.151836] em28xx #1: card=23 -> Huaqi DLCW-130
[ 13.151837] em28xx #1: card=24 -> D-Link DUB-T210 TV Tuner
[ 13.151839] em28xx #1: card=25 -> Gadmei UTV310
[ 13.151840] em28xx #1: card=26 -> Hercules Smart TV USB 2.0
[ 13.151842] em28xx #1: card=27 -> Pinnacle PCTV USB 2 (Philips FM1216ME)
[ 13.151844] em28xx #1: card=28 -> Leadtek Winfast USB II Deluxe
[ 13.151846] em28xx #1: card=29 -> <NULL>
[ 13.151847] em28xx #1: card=30 -> Videology 20K14XUSB USB2.0
[ 13.151849] em28xx #1: card=31 -> Usbgear VD204v9
[ 13.151851] em28xx #1: card=32 -> Supercomp USB 2.0 TV
[ 13.151852] em28xx #1: card=33 -> <NULL>
[ 13.151854] em28xx #1: card=34 -> Terratec Cinergy A Hybrid XS
[ 13.151856] em28xx #1: card=35 -> Typhoon DVD Maker
[ 13.151857] em28xx #1: card=36 -> NetGMBH Cam
[ 13.151859] em28xx #1: card=37 -> Gadmei UTV330
[ 13.151861] em28xx #1: card=38 -> Yakumo MovieMixer
[ 13.151862] em28xx #1: card=39 -> KWorld PVRTV 300U
[ 13.151864] em28xx #1: card=40 -> Plextor ConvertX PX-TV100U
[ 13.151866] em28xx #1: card=41 -> Kworld 350 U DVB-T
[ 13.151867] em28xx #1: card=42 -> Kworld 355 U DVB-T
[ 13.151869] em28xx #1: card=43 -> Terratec Cinergy T XS
[ 13.151871] em28xx #1: card=44 -> Terratec Cinergy T XS (MT2060)
[ 13.151872] em28xx #1: card=45 -> Pinnacle PCTV DVB-T
[ 13.151874] em28xx #1: card=46 -> Compro, VideoMate U3
[ 13.151876] em28xx #1: card=47 -> KWorld DVB-T 305U
[ 13.151877] em28xx #1: card=48 -> KWorld DVB-T 310U
[ 13.151879] em28xx #1: card=49 -> MSI DigiVox A/D
[ 13.151881] em28xx #1: card=50 -> MSI DigiVox A/D II
[ 13.151882] em28xx #1: card=51 -> Terratec Hybrid XS Secam
[ 13.151884] em28xx #1: card=52 -> DNT DA2 Hybrid
[ 13.151885] em28xx #1: card=53 -> Pinnacle Hybrid Pro
[ 13.151887] em28xx #1: card=54 -> Kworld VS-DVB-T 323UR
[ 13.151889] em28xx #1: card=55 -> Terratec Hybrid XS (em2882)
[ 13.151891] em28xx #1: card=56 -> Pinnacle Hybrid Pro (2)
[ 13.151892] em28xx #1: card=57 -> Kworld PlusTV HD Hybrid 330
[ 13.151894] em28xx #1: card=58 -> Compro VideoMate ForYou/Stereo
[ 13.151896] em28xx #1: card=59 -> <NULL>
[ 13.151897] em28xx #1: card=60 -> Hauppauge WinTV HVR 850
[ 13.151899] em28xx #1: card=61 -> Pixelview PlayTV Box 4 USB 2.0
[ 13.151901] em28xx #1: card=62 -> Gadmei TVR200
[ 13.151903] em28xx #1: card=63 -> Kaiomy TVnPC U2
[ 13.151904] em28xx #1: card=64 -> Easy Cap Capture DC-60
[ 13.151906] em28xx #1: card=65 -> IO-DATA GV-MVP/SZ
[ 13.151908] em28xx #1: card=66 -> Empire dual TV
[ 13.151909] em28xx #1: 
[ 13.151910] 
[ 13.151911] em28xx #1: The support for this board weren't valid yet.
[ 13.151913] em28xx #1: Please send a report of having this working
[ 13.151914] em28xx #1: not to V4L mailing list (and/or to other addresses)
[ 13.151915] 
[ 13.153872] tvp5150 2-005c: chip found @ 0xb8 (em28xx #1)
[ 13.158518] tuner 2-0061: chip found @ 0xc2 (em28xx #1)
[ 13.158612] xc2028 2-0061: creating new instance
[ 13.158614] xc2028 2-0061: type set to XCeive xc2028/xc3028 tuner
[ 13.158620] i2c-adapter i2c-2: firmware: requesting xc3028-v27.fw
[ 13.163219] xc2028 2-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
[ 13.208008] xc2028 2-0061: Loading firmware for type=BASE (1), id 0000000000000000.
[ 14.101737] xc2028 2-0061: Loading firmware for type=(0), id 000000000000b700.
[ 14.115361] SCODE (20000000), id 000000000000b700:
[ 14.115364] xc2028 2-0061: Loading SCODE for type=MONO SCODE HAS_IF_4320 (60008000), id 0000000000008000.
[ 14.296125] em28xx #1: Config register raw data: 0xd0
[ 14.296875] em28xx #1: AC97 vendor ID = 0x414c4740
[ 14.297245] em28xx #1: AC97 features = 0x5990
[ 14.297246] em28xx #1: Unknown AC97 audio processor detected!
[ 14.408510] tvp5150 2-005c: tvp5150am1 detected.
[ 14.504768] em28xx #1: v4l2 driver version 0.1.2
[ 14.571043] em28xx #1: V4L2 device registered as /dev/video1 and /dev/vbi1
[ 14.584027] usbcore: registered new interface driver em28xx
[ 14.584051] em28xx driver loaded
[ 14.675318] em28xx-audio.c: probing for em28x1 non standard usbaudio
[ 14.675321] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
[ 14.675322] em28xx-audio.c: probing for em28x1 non standard usbaudio
[ 14.675324] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
[ 14.675326] Em28xx: Initialized (Em28xx Audio Extension) extension
 
 
 
[ 2803.636233] Em28xx: Removed (Em28xx Audio Extension) extension
[ 2805.913205] usbcore: deregistering interface driver em28xx
[ 2805.913263] em28xx #1: disconnecting em28xx #1 video
[ 2805.913270] em28xx #1: V4L2 device /dev/vbi1 deregistered
[ 2805.913410] em28xx #1: V4L2 device /dev/video1 deregistered
[ 2805.913611] xc2028 2-0061: destroying instance
[ 2805.913788] em28xx #0: disconnecting em28xx #0 video
[ 2805.913793] em28xx #0: V4L2 device /dev/vbi0 deregistered
[ 2805.913872] em28xx #0: V4L2 device /dev/video0 deregistered
[ 2805.914050] xc2028 1-0061: destroying instance
[ 2809.768928] em28xx: New device USB 2881 Device @ 480 Mbps (eb1a:e310, interface 0, class 0)
[ 2809.768948] em28xx #0: Identified as KWorld DVB-T 310U (card=48)
[ 2809.769174] em28xx #0: chip ID is em2882/em2883
[ 2809.927553] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 10 e3 d0 12 5c 03 6a 22 00 00
[ 2809.927578] em28xx #0: i2c eeprom 10: 00 00 04 57 4e 07 00 00 00 00 00 00 00 00 00 00
[ 2809.927600] em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 01 00 00 00 00 00 5b 1e 00 00
[ 2809.927621] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 00 00 00 00 00 00
[ 2809.927641] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 2809.927661] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 2809.927681] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 22 03 55 00 53 00
[ 2809.927701] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 38 00 31 00 20 00 44 00
[ 2809.927721] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00 00 00 00 00 00 00
[ 2809.927742] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 2809.927762] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 2809.927781] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 2809.927801] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 2809.927821] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 2809.927841] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 2809.927861] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 2809.927885] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x166a0441
[ 2809.927889] em28xx #0: EEPROM info:
[ 2809.927893] em28xx #0: AC97 audio (5 sample rates)
[ 2809.927897] em28xx #0: 500mA max power
[ 2809.927901] em28xx #0: Table at 0x04, strings=0x226a, 0x0000, 0x0000
[ 2809.940402] tvp5150 1-005c: chip found @ 0xb8 (em28xx #0)
[ 2809.949643] tuner 1-0061: chip found @ 0xc2 (em28xx #0)
[ 2809.949892] xc2028 1-0061: creating new instance
[ 2809.949898] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
[ 2809.949914] i2c-adapter i2c-1: firmware: requesting xc3028-v27.fw
[ 2809.965831] xc2028 1-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
[ 2810.012036] xc2028 1-0061: Loading firmware for type=BASE MTS (5), id 0000000000000000.
[ 2811.033955] xc2028 1-0061: Loading firmware for type=MTS (4), id 000000000000b700.
[ 2811.050439] xc2028 1-0061: Loading SCODE for type=MTS LCD NOGD MONO IF SCODE HAS_IF_4500 (6002b004), id 000000000000b700.
[ 2811.232228] em28xx #0: Config register raw data: 0xd0
[ 2811.232962] em28xx #0: AC97 vendor ID = 0x414c4740
[ 2811.233333] em28xx #0: AC97 features = 0x5990
[ 2811.233337] em28xx #0: Unknown AC97 audio processor detected!
[ 2811.344481] tvp5150 1-005c: tvp5150am1 detected.
[ 2811.440873] em28xx #0: v4l2 driver version 0.1.2
[ 2811.507074] em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
[ 2811.520112] em28xx: New device USB 2881 Device @ 480 Mbps (eb1a:e310, interface 1, class 1)
[ 2811.520130] em28xx #1: Identified as MSI DigiVox A/D (card=49)
[ 2811.520438] em28xx #1: chip ID is em2882/em2883
[ 2811.644809] tvp5150 1-005c: tvp5150am1 detected.
[ 2811.676169] em28xx #1: i2c eeprom 00: 00 00 00 00 6c 00 4b 81 56 46 69 0b 5c e1 0c 2c
[ 2811.676195] em28xx #1: i2c eeprom 10: 15 01 00 00 6c 00 4b 81 56 46 69 0b 5c e1 0c 2c
[ 2811.676217] em28xx #1: i2c eeprom 20: 1a eb 10 e3 d0 12 5c 03 6a 22 00 00 00 00 04 57
[ 2811.676238] em28xx #1: i2c eeprom 30: 4e 07 00 00 00 00 00 00 00 00 00 00 46 00 01 00
[ 2811.676258] em28xx #1: i2c eeprom 40: 1b 14 00 00 00 00 00 00 00 00 00 00 46 00 01 00
[ 2811.676279] em28xx #1: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 46 00 01 00
[ 2811.676299] em28xx #1: i2c eeprom 60: 1e 00 00 00 00 00 00 00 00 00 00 00 46 00 01 00
[ 2811.676319] em28xx #1: i2c eeprom 70: 00 00 00 00 00 00 00 00 00 00 00 00 46 00 01 00
[ 2811.676340] em28xx #1: i2c eeprom 80: 2f 01 00 00 00 00 00 00 00 00 00 00 46 00 01 00
[ 2811.676360] em28xx #1: i2c eeprom 90: 00 00 00 5b 1e 00 00 00 00 20 40 20 80 02 20 01
[ 2811.676381] em28xx #1: i2c eeprom a0: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 2811.676401] em28xx #1: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 2811.676421] em28xx #1: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 2811.676441] em28xx #1: i2c eeprom d0: 00 22 03 55 00 53 00 42 00 20 00 32 00 38 00 38
[ 2811.676462] em28xx #1: i2c eeprom e0: 00 31 00 20 00 44 00 65 00 76 00 69 00 63 00 65
[ 2811.676482] em28xx #1: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 2811.676533] em28xx #1: EEPROM ID= 0x00000000, EEPROM hash = 0x00000000
[ 2811.676537] em28xx #1: EEPROM info:
[ 2811.676541] em28xx #1: AC97 audio (5 sample rates)
[ 2811.676545] em28xx #1: USB Self power capable
[ 2811.676549] em28xx #1: 300mA max power
[ 2811.676553] em28xx #1: Table at 0x00, strings=0xe15c, 0x2c0c, 0x0115
[ 2811.677163] em28xx #1: found i2c device @ 0x0 [???]
[ 2811.678029] em28xx #1: found i2c device @ 0x2 [???]
[ 2811.678911] em28xx #1: found i2c device @ 0x4 [???]
[ 2811.679781] em28xx #1: found i2c device @ 0x6 [???]
[ 2811.689284] em28xx #1: found i2c device @ 0x8 [???]
[ 2811.690026] em28xx #1: found i2c device @ 0xa [???]
[ 2811.690666] em28xx #1: found i2c device @ 0xc [???]
[ 2811.691535] em28xx #1: found i2c device @ 0xe [???]
[ 2811.693841] em28xx #1: found i2c device @ 0x10 [???]
[ 2811.694413] em28xx #1: found i2c device @ 0x12 [???]
[ 2811.695281] em28xx #1: found i2c device @ 0x14 [???]
[ 2811.696629] em28xx #1: found i2c device @ 0x16 [???]
[ 2811.697910] em28xx #1: found i2c device @ 0x1a [???]
[ 2811.698791] em28xx #1: found i2c device @ 0x1c [???]
[ 2811.699663] em28xx #1: found i2c device @ 0x1e [???]
[ 2811.701789] em28xx #1: found i2c device @ 0x22 [???]
[ 2811.702658] em28xx #1: found i2c device @ 0x24 [???]
[ 2811.703536] em28xx #1: found i2c device @ 0x26 [???]
[ 2811.704669] em28xx #1: found i2c device @ 0x28 [???]
[ 2811.705281] em28xx #1: found i2c device @ 0x2a [???]
[ 2811.706035] em28xx #1: found i2c device @ 0x2c [???]
[ 2811.706907] em28xx #1: found i2c device @ 0x2e [???]
[ 2811.707778] em28xx #1: found i2c device @ 0x30 [???]
[ 2811.709645] em28xx #1: found i2c device @ 0x32 [???]
[ 2811.710294] em28xx #1: found i2c device @ 0x34 [???]
[ 2811.711165] em28xx #1: found i2c device @ 0x36 [???]
[ 2811.712943] em28xx #1: found i2c device @ 0x38 [???]
[ 2811.713786] em28xx #1: found i2c device @ 0x3a [???]
[ 2811.714661] em28xx #1: found i2c device @ 0x3c [???]
[ 2811.715536] em28xx #1: found i2c device @ 0x3e [???]
[ 2811.716876] em28xx #1: found i2c device @ 0x40 [???]
[ 2811.718294] em28xx #1: found i2c device @ 0x44 [???]
[ 2811.719166] em28xx #1: found i2c device @ 0x46 [???]
[ 2811.720978] em28xx #1: found i2c device @ 0x48 [???]
[ 2811.721776] em28xx #1: found i2c device @ 0x4a [saa7113h]
[ 2811.722289] em28xx #1: found i2c device @ 0x4c [???]
[ 2811.723861] em28xx #1: found i2c device @ 0x4e [???]
[ 2811.725799] em28xx #1: found i2c device @ 0x50 [???]
[ 2811.726657] em28xx #1: found i2c device @ 0x52 [???]
[ 2811.727282] em28xx #1: found i2c device @ 0x54 [???]
[ 2811.727910] em28xx #1: found i2c device @ 0x56 [???]
[ 2811.730039] em28xx #1: found i2c device @ 0x58 [???]
[ 2811.730658] em28xx #1: found i2c device @ 0x5a [???]
[ 2811.731414] em28xx #1: found i2c device @ 0x5c [???]
[ 2811.732650] em28xx #1: found i2c device @ 0x5e [???]
[ 2811.733168] em28xx #1: found i2c device @ 0x60 [remote IR sensor]
[ 2811.734036] em28xx #1: found i2c device @ 0x62 [???]
[ 2811.734918] em28xx #1: found i2c device @ 0x64 [???]
[ 2811.735781] em28xx #1: found i2c device @ 0x66 [???]
[ 2811.737282] em28xx #1: found i2c device @ 0x68 [???]
[ 2811.738177] em28xx #1: found i2c device @ 0x6a [???]
[ 2811.738801] em28xx #1: found i2c device @ 0x6c [???]
[ 2811.739671] em28xx #1: found i2c device @ 0x6e [???]
[ 2811.741799] em28xx #1: found i2c device @ 0x72 [???]
[ 2811.742663] em28xx #1: found i2c device @ 0x74 [???]
[ 2811.743543] em28xx #1: found i2c device @ 0x76 [???]
[ 2811.744681] em28xx #1: found i2c device @ 0x78 [???]
[ 2811.745289] em28xx #1: found i2c device @ 0x7a [???]
[ 2811.746035] em28xx #1: found i2c device @ 0x7c [???]
[ 2811.746798] em28xx #1: found i2c device @ 0x7e [???]
[ 2811.747670] em28xx #1: found i2c device @ 0x80 [msp34xx]
[ 2811.750544] em28xx #1: found i2c device @ 0x86 [tda9887]
[ 2811.751418] em28xx #1: found i2c device @ 0x88 [msp34xx]
[ 2811.757668] em28xx #1: found i2c device @ 0xa0 [eeprom]
[ 2811.762530] em28xx #1: found i2c device @ 0xb8 [tvp5150a]
[ 2811.765184] em28xx #1: found i2c device @ 0xc2 [tuner (analog)]
[ 2811.767047] em28xx #1: found i2c device @ 0xc8 [???]
[ 2811.767792] em28xx #1: found i2c device @ 0xca [???]
[ 2811.769930] em28xx #1: found i2c device @ 0xd0 [???]
[ 2811.779290] em28xx #1: Your board has no unique USB ID and thus need a hint to be detected.
[ 2811.779300] em28xx #1: You may try to use card=<n> insmod option to workaround that.
[ 2811.779305] em28xx #1: Please send an email with this log to:
[ 2811.779310] em28xx #1: V4L Mailing List <linux-media@vger.kernel.org>
[ 2811.779314] em28xx #1: Board eeprom hash is 0x00000000
[ 2811.779318] em28xx #1: Board i2c devicelist hash is 0xaf0000c3
[ 2811.779323] em28xx #1: Here is a list of valid choices for the card=<n> insmod option:
[ 2811.779329] em28xx #1: card=0 -> Unknown EM2800 video grabber
[ 2811.779334] em28xx #1: card=1 -> Unknown EM2750/28xx video grabber
[ 2811.779339] em28xx #1: card=2 -> Terratec Cinergy 250 USB
[ 2811.779344] em28xx #1: card=3 -> Pinnacle PCTV USB 2
[ 2811.779348] em28xx #1: card=4 -> Hauppauge WinTV USB 2
[ 2811.779353] em28xx #1: card=5 -> MSI VOX USB 2.0
[ 2811.779358] em28xx #1: card=6 -> Terratec Cinergy 200 USB
[ 2811.779362] em28xx #1: card=7 -> Leadtek Winfast USB II
[ 2811.779367] em28xx #1: card=8 -> Kworld USB2800
[ 2811.779371] em28xx #1: card=9 -> Pinnacle Dazzle DVC 90/100/101/107 / Kaiser Baas Video to DVD maker
[ 2811.779378] em28xx #1: card=10 -> Hauppauge WinTV HVR 900
[ 2811.779382] em28xx #1: card=11 -> Terratec Hybrid XS
[ 2811.779387] em28xx #1: card=12 -> Kworld PVR TV 2800 RF
[ 2811.779392] em28xx #1: card=13 -> Terratec Prodigy XS
[ 2811.779396] em28xx #1: card=14 -> SIIG AVTuner-PVR / Pixelview Prolink PlayTV USB 2.0
[ 2811.779402] em28xx #1: card=15 -> V-Gear PocketTV
[ 2811.779406] em28xx #1: card=16 -> Hauppauge WinTV HVR 950
[ 2811.779411] em28xx #1: card=17 -> Pinnacle PCTV HD Pro Stick
[ 2811.779416] em28xx #1: card=18 -> Hauppauge WinTV HVR 900 (R2)
[ 2811.779421] em28xx #1: card=19 -> PointNix Intra-Oral Camera
[ 2811.779425] em28xx #1: card=20 -> AMD ATI TV Wonder HD 600
[ 2811.779430] em28xx #1: card=21 -> eMPIA Technology, Inc. GrabBeeX+ Video Encoder
[ 2811.779436] em28xx #1: card=22 -> Unknown EM2750/EM2751 webcam grabber
[ 2811.779441] em28xx #1: card=23 -> Huaqi DLCW-130
[ 2811.779446] em28xx #1: card=24 -> D-Link DUB-T210 TV Tuner
[ 2811.779450] em28xx #1: card=25 -> Gadmei UTV310
[ 2811.779455] em28xx #1: card=26 -> Hercules Smart TV USB 2.0
[ 2811.779460] em28xx #1: card=27 -> Pinnacle PCTV USB 2 (Philips FM1216ME)
[ 2811.779465] em28xx #1: card=28 -> Leadtek Winfast USB II Deluxe
[ 2811.779469] em28xx #1: card=29 -> <NULL>
[ 2811.779474] em28xx #1: card=30 -> Videology 20K14XUSB USB2.0
[ 2811.779478] em28xx #1: card=31 -> Usbgear VD204v9
[ 2811.779483] em28xx #1: card=32 -> Supercomp USB 2.0 TV
[ 2811.779487] em28xx #1: card=33 -> <NULL>
[ 2811.779491] em28xx #1: card=34 -> Terratec Cinergy A Hybrid XS
[ 2811.779496] em28xx #1: card=35 -> Typhoon DVD Maker
[ 2811.779500] em28xx #1: card=36 -> NetGMBH Cam
[ 2811.779505] em28xx #1: card=37 -> Gadmei UTV330
[ 2811.779509] em28xx #1: card=38 -> Yakumo MovieMixer
[ 2811.779513] em28xx #1: card=39 -> KWorld PVRTV 300U
[ 2811.779518] em28xx #1: card=40 -> Plextor ConvertX PX-TV100U
[ 2811.779523] em28xx #1: card=41 -> Kworld 350 U DVB-T
[ 2811.779527] em28xx #1: card=42 -> Kworld 355 U DVB-T
[ 2811.779532] em28xx #1: card=43 -> Terratec Cinergy T XS
[ 2811.779536] em28xx #1: card=44 -> Terratec Cinergy T XS (MT2060)
[ 2811.779541] em28xx #1: card=45 -> Pinnacle PCTV DVB-T
[ 2811.779546] em28xx #1: card=46 -> Compro, VideoMate U3
[ 2811.779550] em28xx #1: card=47 -> KWorld DVB-T 305U
[ 2811.779555] em28xx #1: card=48 -> KWorld DVB-T 310U
[ 2811.779559] em28xx #1: card=49 -> MSI DigiVox A/D
[ 2811.779564] em28xx #1: card=50 -> MSI DigiVox A/D II
[ 2811.779568] em28xx #1: card=51 -> Terratec Hybrid XS Secam
[ 2811.779573] em28xx #1: card=52 -> DNT DA2 Hybrid
[ 2811.779577] em28xx #1: card=53 -> Pinnacle Hybrid Pro
[ 2811.779582] em28xx #1: card=54 -> Kworld VS-DVB-T 323UR
[ 2811.779586] em28xx #1: card=55 -> Terratec Hybrid XS (em2882)
[ 2811.779591] em28xx #1: card=56 -> Pinnacle Hybrid Pro (2)
[ 2811.779596] em28xx #1: card=57 -> Kworld PlusTV HD Hybrid 330
[ 2811.779601] em28xx #1: card=58 -> Compro VideoMate ForYou/Stereo
[ 2811.779606] em28xx #1: card=59 -> <NULL>
[ 2811.779610] em28xx #1: card=60 -> Hauppauge WinTV HVR 850
[ 2811.779615] em28xx #1: card=61 -> Pixelview PlayTV Box 4 USB 2.0
[ 2811.779619] em28xx #1: card=62 -> Gadmei TVR200
[ 2811.779624] em28xx #1: card=63 -> Kaiomy TVnPC U2
[ 2811.779628] em28xx #1: card=64 -> Easy Cap Capture DC-60
[ 2811.779633] em28xx #1: card=65 -> IO-DATA GV-MVP/SZ
[ 2811.779637] em28xx #1: card=66 -> Empire dual TV
[ 2811.779641] em28xx #1: 
[ 2811.779643] 
[ 2811.779646] em28xx #1: The support for this board weren't valid yet.
[ 2811.779651] em28xx #1: Please send a report of having this working
[ 2811.779655] em28xx #1: not to V4L mailing list (and/or to other addresses)
[ 2811.779658] 
[ 2811.852163] tvp5150 2-005c: chip found @ 0xb8 (em28xx #1)
[ 2811.876737] tuner 2-0061: chip found @ 0xc2 (em28xx #1)
[ 2811.876988] xc2028 2-0061: creating new instance
[ 2811.876993] xc2028 2-0061: type set to XCeive xc2028/xc3028 tuner
[ 2811.877010] i2c-adapter i2c-2: firmware: requesting xc3028-v27.fw
[ 2812.050439] xc2028 2-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
[ 2812.096097] xc2028 2-0061: Loading firmware for type=BASE (1), id 0000000000000000.
[ 2813.114353] xc2028 2-0061: Loading firmware for type=(0), id 000000000000b700.
[ 2813.129103] SCODE (20000000), id 000000000000b700:
[ 2813.129113] xc2028 2-0061: Loading SCODE for type=MONO SCODE HAS_IF_4320 (60008000), id 0000000000008000.
[ 2813.312260] em28xx #1: Config register raw data: 0xd0
[ 2813.312984] em28xx #1: AC97 vendor ID = 0x414c4740
[ 2813.317071] em28xx #1: AC97 features = 0x5990
[ 2813.317080] em28xx #1: Unknown AC97 audio processor detected!
[ 2813.432512] tvp5150 2-005c: tvp5150am1 detected.
[ 2813.529396] em28xx #1: v4l2 driver version 0.1.2
[ 2813.596481] em28xx #1: V4L2 device registered as /dev/video1 and /dev/vbi1
[ 2813.612141] usbcore: registered new interface driver em28xx
[ 2813.612153] em28xx driver loaded
[ 2813.637767] em28xx-audio.c: probing for em28x1 non standard usbaudio
[ 2813.637774] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
[ 2813.637778] em28xx-audio.c: probing for em28x1 non standard usbaudio
[ 2813.637783] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
[ 2813.637787] Em28xx: Initialized (Em28xx Audio Extension) extension
[ 2813.751169] tvp5150 2-005c: tvp5150am1 detected.
[ 2813.767068] xc2028 1-0061: attaching existing instance
[ 2813.767077] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
[ 2813.767082] em28xx #0/2: xc3028 attached
[ 2813.767087] DVB: registering new adapter (em28xx #0)
[ 2813.767096] DVB: registering adapter 0 frontend 0 (Zarlink ZL10353 DVB-T)...
[ 2813.767739] Successfully loaded em28xx-dvb
[ 2813.767745] Em28xx: Initialized (Em28xx dvb Extension) extension
 
 
 
Thanks!
 
Bye
 
Lars


      
