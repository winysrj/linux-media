Return-path: <mchehab@gaivota>
Received: from mail02do.versatel.de ([89.245.129.22]:65274 "EHLO
	mail02do.versatel.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab0IGI6D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Sep 2010 04:58:03 -0400
Received: from webmail01do.versatel-west.de (gensfam@versanet.de@[89.245.129.37])
          (envelope-sender <gensfam@versanet.de>)
          by mail02do.versatel.de (qmail-ldap-1.03) with ESMTPA
          for <linux-media@vger.kernel.org>; 7 Sep 2010 08:57:58 -0000
Date: Tue, 7 Sep 2010 10:57:56 +0200 (CEST)
From: "gensfam@versanet.de" <gensfam@versanet.de>
To: linux-media@vger.kernel.org
Message-ID: <882172556.278707.1283849878972.JavaMail.open-xchange@webmail01do>
Subject: DVB-T, TV scan not successful: Cinergy Hybrid T USB XS
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hello!

After the new installation of openSuSE 11.3 (kernel 2.6.34-12-desktop) I tried
to install my Cinergy Hybrid T USB XS. This stick already worked under openSuSE
10.3.


If I start the Kaffeine scan for TV channels following happens (roughly):

Signal/SNR/Tuned: 60%/31%/light green, 0%
...
Singal/SNR/Tuned: 60%/73%/green, 11 %
Signal/SNR/Tuned: 100%/0%/green, 11% ... 100%

While SNR 73% scan made some weird wrong entries in column Scan Results.

I do not know what I am doing wrong. I hope so much that anybody can help.


Some system data and collected information:
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
kaffeine-1.0-25.1.x86_64
kaffeine-lang-1.0-1.pm.2.1.noarch

kdebase4-runtime-xine-4.4.4-2.4.x86_64, ...
vdr-plugin-xine-0.9.3-7.2.x86_64

kdebase4-runtime-4.4.4-2.4.x86_64, ...
---------------------
kaffeine, configure TV:
device 1: Zarlink ZL10353 DVB-T
----------------------
invoking kaffeine with:

kaffeine --dumpdvb: (while scanning for channels)

kaffeine(14378) DvbScanFilter::timerEvent: timeout while reading section; type =
2 pid = 17
kaffeine(14378) DvbScanFilter::timerEvent: timeout while reading section; type =
1 pid = 240
kaffeine(14378) DvbScanFilter::timerEvent: timeout while reading section; type =
0 pid = 0
kaffeine(14378) DvbScanFilter::timerEvent: timeout while reading section; type =
2 pid = 17
kaffeine(14378) DvbScanFilter::timerEvent: timeout while reading section; type =
4 pid = 16
kaffeine(14378) DvbDevice::frontendEvent: tuning failed
kaffeine(14378) DvbDevice::frontendEvent: tuning failed
kaffeine(14378) DvbDevice::frontendEvent: tuning failed
kaffeine(14378) DvbDevice::frontendEvent: tuning failed
kaffeine(14378) DvbDevice::frontendEvent: tuning failed
kaffeine(14378) DvbDevice::frontendEvent: tuning failed
kaffeine(14378) DvbDevice::frontendEvent: tuning failed

--------------------------------

dmesg:
[ 17.299642] em28xx: New device TerraTec Electronic GmbH Cinergy Hybrid T USB XS
(2882) @ 480 Mbps (0ccd:005e, interface 0, class 0)
[ 17.299757] em28xx #0: chip ID is em2882/em2883
...
[ 17.344047] VIA 82xx Audio 0000:00:11.5: PCI INT C -> GSI 22 (level, low) ->
IRQ 22
[ 17.344235] VIA 82xx Audio 0000:00:11.5: setting latency timer to 64
...
[ 17.458267] em28xx #0: i2c eeprom 00: 1a eb 67 95 cd 0c 5e 00 d0 12 5c 03 9e 40
de 1c
[ 17.458284] em28xx #0: i2c eeprom 10: 6a 34 27 57 46 07 01 00 00 00 00 00 00 00
00 00
[ 17.458297] em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 31 00 b8 00 14 00 5b 1e
00 00
[ 17.458309] em28xx #0: i2c eeprom 30: 00 00 20 40 20 6e 02 20 10 01 00 00 00 00
00 00
[ 17.458321] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00
[ 17.458332] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00
[ 17.458343] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 34 03 54 00
65 00
[ 17.458355] em28xx #0: i2c eeprom 70: 72 00 72 00 61 00 54 00 65 00 63 00 20 00
45 00
[ 17.458366] em28xx #0: i2c eeprom 80: 6c 00 65 00 63 00 74 00 72 00 6f 00 6e 00
69 00
[ 17.458378] em28xx #0: i2c eeprom 90: 63 00 20 00 47 00 6d 00 62 00 48 00 00 00
40 03
[ 17.458390] em28xx #0: i2c eeprom a0: 43 00 69 00 6e 00 65 00 72 00 67 00 79 00
20 00
[ 17.458401] em28xx #0: i2c eeprom b0: 48 00 79 00 62 00 72 00 69 00 64 00 20 00
54 00
[ 17.458413] em28xx #0: i2c eeprom c0: 20 00 55 00 53 00 42 00 20 00 58 00 53 00
20 00
[ 17.458424] em28xx #0: i2c eeprom d0: 28 00 32 00 38 00 38 00 32 00 29 00 00 00
1c 03
[ 17.458436] em28xx #0: i2c eeprom e0: 30 00 37 00 30 00 39 00 30 00 32 00 30 00
30 00
[ 17.458447] em28xx #0: i2c eeprom f0: 31 00 36 00 30 00 32 00 00 00 00 00 00 00
00 00
[ 17.458460] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0xb213b0be
[ 17.458463] em28xx #0: EEPROM info:
[ 17.458465] em28xx #0: AC97 audio (5 sample rates)
[ 17.458467] em28xx #0: 500mA max power
[ 17.458469] em28xx #0: Table at 0x27, strings=0x409e, 0x1cde, 0x346a
[ 17.459515] em28xx #0: Identified as Terratec Hybrid XS (em2882) (card=55)
[ 17.779888] tvp5150 1-005c: chip found @ 0xb8 (em28xx #0)
[ 18.030350] tuner 1-0061: chip found @ 0xc2 (em28xx #0)
[ 18.077720] xc2028 1-0061: creating new instance
[ 18.077725] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
[ 18.077734] usb 1-3: firmware: requesting xc3028-v27.fw
[ 18.080251] xc2028 1-0061: Loading 80 firmware images from xc3028-v27.fw, type:
xc2028 firmware, ver 2.7
[ 18.115013] xc2028 1-0061: Loading firmware for type=BASE MTS (5), id
0000000000000000.
[ 19.018857] xc2028 1-0061: Loading firmware for type=MTS (4), id
000000000000b700.
[ 19.034231] xc2028 1-0061: Loading SCODE for type=MTS LCD NOGD MONO IF SCODE
HAS_IF_4500 (6002b004), id 000000000000b700.
[ 19.197366] input: em28xx IR (em28xx #0) as
/devices/pci0000:00/0000:00:10.4/usb1/1-3/input/input5
[ 19.197552] Creating IR device irrcv0
[ 19.197867] em28xx #0: Config register raw data: 0xd0
[ 19.199035] em28xx #0: AC97 vendor ID = 0xffffffff
[ 19.199397] em28xx #0: AC97 features = 0x6a90
[ 19.199402] em28xx #0: Empia 202 AC97 audio processor detected
[ 19.295412] tvp5150 1-005c: tvp5150am1 detected.
[ 19.386808] em28xx #0: v4l2 driver version 0.1.2
[ 19.453330] em28xx #0: V4L2 video device registered as video0
[ 19.453335] em28xx #0: V4L2 VBI device registered as vbi0
[ 19.465050] usbcore: registered new interface driver em28xx
[ 19.465055] em28xx driver loaded
[ 19.487476] em28xx-audio.c: probing for em28x1 non standard usbaudio
[ 19.487482] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
[ 19.488338] Em28xx: Initialized (Em28xx Audio Extension) extension
[ 19.619061] xc2028 1-0061: attaching existing instance
[ 19.619066] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
[ 19.619069] em28xx #0: em28xx #0/2: xc3028 attached
[ 19.619072] DVB: registering new adapter (em28xx #0)
[ 19.619076] DVB: registering adapter 0 frontend 0 (Zarlink ZL10353 DVB-T)...
[ 19.619596] em28xx #0: Successfully loaded em28xx-dvb
[ 19.619601] Em28xx: Initialized (Em28xx dvb Extension) extension

...

xc2028 1-0061: Loading firmware for type=BASE F8MHZ MTS (7), id
0000000000000000.
[ 1639.728880] xc2028 1-0061: Loading firmware for type=D2633 DTV7 (90), id
0000000000000000.
[ 1639.742253] xc2028 1-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8
ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
[ 1668.606752] xc2028 1-0061: Loading firmware for type=D2633 DTV78 (110), id
0000000000000000.
[ 1668.620516] xc2028 1-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8
ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
[ 2702.705040] xc2028 1-0061: Loading firmware for type=BASE F8MHZ MTS (7), id
0000000000000000.
[ 2703.606849] xc2028 1-0061: Loading firmware for type=D2633 DTV78 (110), id
0000000000000000.
[ 2703.620225] xc2028 1-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8
ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
[ 2870.779014] xc2028 1-0061: Loading firmware for type=BASE F8MHZ MTS (7), id
0000000000000000.
[ 2871.680784] xc2028 1-0061: Loading firmware for type=D2633 DTV78 (110), id
0000000000000000.
[ 2871.694157] xc2028 1-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8
ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
[ 2911.394027] xc2028 1-0061: Loading firmware for type=BASE F8MHZ MTS (7), id
0000000000000000.
[ 2912.295811] xc2028 1-0061: Loading firmware for type=D2633 DTV78 (110), id
0000000000000000.
[ 2912.309191] xc2028 1-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8
ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
[ 3023.057018] xc2028 1-0061: Loading firmware for type=BASE F8MHZ MTS (7), id
0000000000000000.
[ 3023.958807] xc2028 1-0061: Loading firmware for type=D2633 DTV78 (110), id
0000000000000000.
[ 3023.972182] xc2028 1-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8
ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
[ 5716.667021] xc2028 1-0061: Loading firmware for type=BASE F8MHZ MTS (7), id
0000000000000000.
[ 5717.568879] xc2028 1-0061: Loading firmware for type=D2633 DTV78 (110), id
0000000000000000.
[ 5717.582253] xc2028 1-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8
ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
[ 5756.846016] xc2028 1-0061: Loading firmware for type=BASE F8MHZ MTS (7), id
0000000000000000.
[ 5757.747812] xc2028 1-0061: Loading firmware for type=D2633 DTV78 (110), id
0000000000000000.
[ 5757.761307] xc2028 1-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8
ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
[ 6118.278033] xc2028 1-0061: Loading firmware for type=BASE F8MHZ MTS (7), id
0000000000000000.
[ 6119.180893] xc2028 1-0061: Loading firmware for type=D2633 DTV78 (110), id
0000000000000000.
[ 6119.194266] xc2028 1-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8
ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
...
[ 7735.631017] xc2028 1-0061: Loading firmware for type=BASE F8MHZ MTS (7), id
0000000000000000.
[ 7736.533816] xc2028 1-0061: Loading firmware for type=D2633 DTV78 (110), id
0000000000000000.
[ 7736.547191] xc2028 1-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8
ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
[11068.099023] xc2028 1-0061: Loading firmware for type=BASE F8MHZ MTS (7), id
0000000000000000.
[11069.000906] xc2028 1-0061: Loading firmware for type=D2633 DTV78 (110), id
0000000000000000.
[11069.014280] xc2028 1-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8
ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
[13282.522033] xc2028 1-0061: Loading firmware for type=BASE F8MHZ MTS (7), id
0000000000000000.
[13283.424822] xc2028 1-0061: Loading firmware for type=D2633 DTV78 (110), id
0000000000000000.
[13283.438198] xc2028 1-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8
ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
[13354.001040] xc2028 1-0061: Loading firmware for type=BASE F8MHZ MTS (7), id
0000000000000000.
[13354.909766] xc2028 1-0061: Loading firmware for type=D2633 DTV78 (110), id
0000000000000000.
[13354.923143] xc2028 1-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8
ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
[13459.296676] xc2028 1-0061: Loading firmware for type=BASE F8MHZ MTS (7), id
0000000000000000.
[13460.202016] xc2028 1-0061: Loading firmware for type=D2633 DTV78 (110), id
0000000000000000.
[13460.215523] xc2028 1-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8
ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
...
[15032.829016] xc2028 1-0061: Loading firmware for type=BASE F8MHZ MTS (7), id
0000000000000000.
[15033.731844] xc2028 1-0061: Loading firmware for type=D2633 DTV78 (110), id
0000000000000000.
[15033.745217] xc2028 1-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8
ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


Thank you very much in advance for your help!!

Michael 
 
 
 


 
