Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n03BOVP2014483
	for <video4linux-list@redhat.com>; Sat, 3 Jan 2009 06:24:31 -0500
Received: from smtp.eutelia.it (mp1-smtp-6.eutelia.it [62.94.10.166])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n03BOE68023536
	for <video4linux-list@redhat.com>; Sat, 3 Jan 2009 06:24:14 -0500
Received: from [192.168.1.160] (ip-174-171.sn3.eutelia.it [213.136.174.171])
	by smtp.eutelia.it (Eutelia) with ESMTP id 43B21458472
	for <video4linux-list@redhat.com>; Sat,  3 Jan 2009 12:24:07 +0100 (CET)
Message-ID: <495F4AD1.7010707@email.it>
Date: Sat, 03 Jan 2009 12:24:01 +0100
From: xwang1976@email.it
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Empire Dual Pen with kubuntu 8.10 (kernel 2.6.27-11-generic)
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi,
I've just upgraded my system from kubuntu 8.04 to 8.10 and I've tried my
hybrid TV pen drive
(http://www.empiremedia.it/site/prodotto.asp?idprodotto=231&tit=Pen%20Dual%20TV&lingua) 

to see if it is recognized out of the box from the new kernel (on kernel
2.6.24 I used the em28xx driver from Markus Rechberger repository
<mrechberger@gmail.com>).
So I've inserted the pen and since in the output of the dmesg command
there is the request for it, I'm sending it to you.
Meanwhile, how can I pass the card option? I believe it is a re-branded
Kworld 310U (this code appears near the bar code) and so, maybe it will
just need the card=48 option.
Moreover I see that the firmware xc3028-v27.fw is needed. How can I
obtain it?
Can you help me,
Thank you,
Xwang

PS Happy new year!!!

dmesg output:
[11195.953036] em28xx new video device (eb1a:e310): interface 0, class
255
[11195.953055] em28xx Doesn't have usb audio
class
[11195.953062] em28xx #0: Alternate settings:
8
[11195.953069] em28xx #0: Alternate setting 0, max size=
0
[11195.953076] em28xx #0: Alternate setting 1, max size=
0
[11195.953084] em28xx #0: Alternate setting 2, max size=
1448
[11195.953092] em28xx #0: Alternate setting 3, max size=
2048
[11195.953099] em28xx #0: Alternate setting 4, max size=
2304
[11195.953106] em28xx #0: Alternate setting 5, max size=
2580
[11195.953114] em28xx #0: Alternate setting 6, max size=
2892
[11195.953121] em28xx #0: Alternate setting 7, max size=
3072
[11195.957820] em28xx #0: chip ID is
em2882/em2883
[11196.149054] tuner' 3-0061: chip found @ 0xc2 (em28xx
#0)
[11196.181543] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 10 e3 d0 12
5c 03 6a 22 00
00
[11196.181559] em28xx #0: i2c eeprom 10: 00 00 04 57 4e 07 00 00 00 00
00 00 00 00 00
00
[11196.181572] em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 01 00 00 00
00 00 5b 1e 00
00
[11196.181585] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01
00 00 00 00 00
00
[11196.181598] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00
00
[11196.181610] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00
00
[11196.181622] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00
22 03 55 00 53
00
[11196.181635] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 38 00
31 00 20 00 44
00
[11196.181648] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00
00 00 00 00 00
00
[11196.181660] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00
00
[11196.181673] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00
00
[11196.181685] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00
00
[11196.181698] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00
00
[11196.181710] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00
00
[11196.181722] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00
00
[11196.181735] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00
00
[11196.181749] EEPROM ID= 0x9567eb1a, hash =
0x166a0441
[11196.181752] Vendor/Product ID=
eb1a:e310
[11196.181754] AC97 audio (5 sample
rates)
[11196.181757] 500mA max
power
[11196.181759] Table at 0x04, strings=0x226a, 0x0000,
0x0000
[11196.201039] em28xx #0: found i2c device @ 0x1e
[???]
[11196.225910] em28xx #0: found i2c device @ 0xa0
[eeprom]
[11196.231033] em28xx #0: found i2c device @ 0xb8
[tvp5150a]
[11196.233408] em28xx #0: found i2c device @ 0xc2 [tuner
(analog)]
[11196.264039] em28xx #0: Your board has no unique USB ID and thus need
a hint to be
detected.
[11196.264051] em28xx #0: You may try to use card=<n> insmod option to
workaround
that. 


[11196.264055] em28xx #0: Please send an email with this log
to:
[11196.264058] em28xx #0:       V4L Mailing List
<video4linux-list@redhat.com>
[11196.264061] em28xx #0: Board eeprom hash is
0x166a0441
[11196.264065] em28xx #0: Board i2c devicelist hash is
0x944d008f
[11196.264068] em28xx #0: Here is a list of valid choices for the
card=<n> insmod
option: 


[11196.264073] em28xx #0:     card=0 -> Unknown EM2800 video
grabber
[11196.264076] em28xx #0:     card=1 -> Unknown EM2750/28xx video
grabber
[11196.264080] em28xx #0:     card=2 -> Terratec Cinergy 250
USB
[11196.264083] em28xx #0:     card=3 -> Pinnacle PCTV USB
2
[11196.264086] em28xx #0:     card=4 -> Hauppauge WinTV USB
2
[11196.264089] em28xx #0:     card=5 -> MSI VOX USB
2.0
[11196.264093] em28xx #0:     card=6 -> Terratec Cinergy 200
USB
[11196.264096] em28xx #0:     card=7 -> Leadtek Winfast USB
II
[11196.264099] em28xx #0:     card=8 -> Kworld
USB2800
[11196.264102] em28xx #0:     card=9 -> Pinnacle Dazzle DVC 90/DVC
100
[11196.264105] em28xx #0:     card=10 -> Hauppauge WinTV HVR
900
[11196.264109] em28xx #0:     card=11 -> Terratec Hybrid
XS
[11196.264112] em28xx #0:     card=12 -> Kworld PVR TV 2800
RF
[11196.264115] em28xx #0:     card=13 -> Terratec Prodigy
XS
[11196.264118] em28xx #0:     card=14 -> Pixelview Prolink PlayTV USB
2.0
[11196.264122] em28xx #0:     card=15 -> V-Gear
PocketTV
[11196.264125] em28xx #0:     card=16 -> Hauppauge WinTV HVR
950
[11196.264128] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro
Stick
[11196.264131] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900
(R2)
[11196.264135] em28xx #0:     card=19 -> PointNix Intra-Oral
Camera
[11196.264138] em28xx #0:     card=20 -> AMD ATI TV Wonder HD
600
[11196.264141] em28xx #0:     card=21 -> eMPIA Technology, Inc.
GrabBeeX+ Video
Encoder 


[11196.264145] em28xx #0:     card=22 -> Unknown EM2750/EM2751 webcam
grabber
[11196.264149] em28xx #0:     card=23 -> Huaqi
DLCW-130
[11196.264171] em28xx #0:     card=24 -> D-Link DUB-T210 TV
Tuner
[11196.264174] em28xx #0:     card=25 -> Gadmei
UTV310
[11196.264177] em28xx #0:     card=26 -> Hercules Smart TV USB
2.0
[11196.264180] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips
FM1216ME)
[11196.264184] em28xx #0:     card=28 -> Leadtek Winfast USB II
Deluxe
[11196.264187] em28xx #0:     card=29 -> Pinnacle Dazzle DVC
100
[11196.264191] em28xx #0:     card=30 -> Videology 20K14XUSB
USB2.0
[11196.264194] em28xx #0:     card=31 -> Usbgear
VD204v9
[11196.264197] em28xx #0:     card=32 -> Supercomp USB 2.0
TV
[11196.264200] em28xx #0:     card=33 -> SIIG AVTuner-PVR/Prolink PlayTV
USB 2.0
[11196.264204] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid
XS
[11196.264207] em28xx #0:     card=35 -> Typhoon DVD
Maker
[11196.264210] em28xx #0:     card=36 -> NetGMBH
Cam
[11196.264213] em28xx #0:     card=37 -> Gadmei
UTV330
[11196.264217] em28xx #0:     card=38 -> Yakumo
MovieMixer
[11196.264220] em28xx #0:     card=39 -> KWorld PVRTV
300U
[11196.264223] em28xx #0:     card=40 -> Plextor ConvertX
PX-TV100U
[11196.264226] em28xx #0:     card=41 -> Kworld 350 U
DVB-T
[11196.264230] em28xx #0:     card=42 -> Kworld 355 U
DVB-T
[11196.264233] em28xx #0:     card=43 -> Terratec Cinergy T
XS
[11196.264236] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[11196.264239] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
[11196.264242] em28xx #0:     card=46 -> Compro, VideoMate U3
[11196.264246] em28xx #0:     card=47 -> KWorld DVB-T 305U
[11196.264249] em28xx #0:     card=48 -> KWorld DVB-T 310U
[11196.264252] em28xx #0:     card=49 -> MSI DigiVox A/D
[11196.264255] em28xx #0:     card=50 -> MSI DigiVox A/D II
[11196.264258] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
[11196.264261] em28xx #0:     card=52 -> DNT DA2 Hybrid
[11196.264264] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
[11196.264267] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
[11196.264270] em28xx #0:     card=55 -> Terratec Hybrid XS (em2882)
[11196.264274] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (2)
[11196.264277] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[11196.264280] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
[11196.264284] em28xx #0:
[11196.264285]
[11196.264288] em28xx #0: The support for this board weren't valid yet.
[11196.264291] em28xx #0: Please send a report of having this working
[11196.264294] em28xx #0: not to V4L mailing list (and/or to other
addresses)
[11196.264296]
[11196.341874] xc2028 3-0061: creating new instance
[11196.341881] xc2028 3-0061: type set to XCeive xc2028/xc3028 tuner
[11196.341893] firmware: requesting xc3028-v27.fw
[11196.504193] xc2028 3-0061: Error: firmware xc3028-v27.fw not found.
[11196.604484] tvp5150 3-005c: tvp5150am1 detected.
[11196.765205] em28xx #0: V4L2 device registered as /dev/video0 and
/dev/vbi0
[11196.766887] em28xx-audio.c: probing for em28x1 non standard usbaudio
[11196.766900] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
[11196.770833] em28xx #0: Found MSI DigiVox A/D
[11196.793400] em28xx new video device (eb1a:e310): interface 1, class 255
[11196.793418] em28xx probing error: endpoint is non-ISO endpoint!
[11197.176380] tvp5150 3-005c: tvp5150am1 detected.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
