Return-path: <linux-media-owner@vger.kernel.org>
Received: from cp-out7.libero.it ([212.52.84.107]:55800 "EHLO
	cp-out7.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbZHEUIY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Aug 2009 16:08:24 -0400
Received: from [192.168.1.21] (151.59.219.5) by cp-out7.libero.it (8.5.107) (authenticated as efa@iol.it)
        id 4A700F4300B50187 for linux-media@vger.kernel.org; Wed, 5 Aug 2009 22:08:24 +0200
Message-ID: <4A79E6B7.5090408@iol.it>
Date: Wed, 05 Aug 2009 22:08:23 +0200
From: Valerio Messina <efa@iol.it>
Reply-To: efa@iol.it
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Terratec Cinergy HibridT XS
References: <4A6F8AA5.3040900@iol.it> <4A729117.6010001@iol.it>	 <829197380907310109r1ca7231cqd86803f0fe640904@mail.gmail.com>	 <4A739DD6.8030504@iol.it>	 <829197380908032002v196384c9oa0aff78627959db@mail.gmail.com>	 <4A79320B.7090401@iol.it>	 <829197380908050627u892b526wc5fb8ef1f6be6b53@mail.gmail.com>	 <4A79CEBD.1050909@iol.it>	 <829197380908051134x5fda787fx5bf9adf786aa739e@mail.gmail.com>	 <4A79E07F.1000301@iol.it> <829197380908051251x6996414ek951d259373401dd7@mail.gmail.com>
In-Reply-To: <829197380908051251x6996414ek951d259373401dd7@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller ha scritto:
> I don't know what the process is for uninstalling the mcentral.de
> em28xx driver.  Probably involves removing that directory and
> re-running depmod or something.

ok, I run:
$ sudo mv /lib/modules/2.6.28-14-generic/empia/ ~/temp
$ sudo depmod -a

then connected the TVtuner, Kaffeine identify the TV tuner and the 
video/audio is OK.
And now IR send digit to text editor and Kaffeine.

thanks
Valerio


dmesg show:

Aug  5 21:59:50 01ath3200 kernel: [ 6635.764021] usb 1-3: new high speed 
USB device using ehci_hcd and address 4
Aug  5 21:59:50 01ath3200 kernel: [ 6635.906865] usb 1-3: configuration 
#1 chosen from 1 choice
Aug  5 21:59:50 01ath3200 kernel: [ 6636.195926] em28xx: New device 
TerraTec Electronic GmbH Cinergy Hybrid T USB XS @ 480 Mbps (0ccd:0042, 
interface 0, class 0)
Aug  5 21:59:50 01ath3200 kernel: [ 6636.195934] em28xx #0: Identified 
as Terratec Hybrid XS (card=11)
Aug  5 21:59:50 01ath3200 kernel: [ 6636.204453] em28xx #0: chip ID is 
em2882/em2883
Aug  5 21:59:50 01ath3200 kernel: [ 6636.364894] em28xx #0: i2c eeprom 
00: 1a eb 67 95 cd 0c 42 00 50 12 5c 03 6a 32 9c 34
Aug  5 21:59:50 01ath3200 kernel: [ 6636.364903] em28xx #0: i2c eeprom 
10: 00 00 06 57 46 07 00 00 00 00 00 00 00 00 00 00
Aug  5 21:59:50 01ath3200 kernel: [ 6636.364910] em28xx #0: i2c eeprom 
20: 46 00 01 00 f0 10 31 00 b8 00 14 00 5b 00 00 00
Aug  5 21:59:50 01ath3200 kernel: [ 6636.364917] em28xx #0: i2c eeprom 
30: 00 00 20 40 20 6e 02 20 10 01 00 00 00 00 00 00
Aug  5 21:59:50 01ath3200 kernel: [ 6636.364923] em28xx #0: i2c eeprom 
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Aug  5 21:59:50 01ath3200 kernel: [ 6636.364929] em28xx #0: i2c eeprom 
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Aug  5 21:59:50 01ath3200 kernel: [ 6636.364936] em28xx #0: i2c eeprom 
60: 00 00 00 00 00 00 00 00 00 00 32 03 43 00 69 00
Aug  5 21:59:50 01ath3200 kernel: [ 6636.364942] em28xx #0: i2c eeprom 
70: 6e 00 65 00 72 00 67 00 79 00 20 00 48 00 79 00
Aug  5 21:59:50 01ath3200 kernel: [ 6636.364948] em28xx #0: i2c eeprom 
80: 62 00 72 00 69 00 64 00 20 00 54 00 20 00 55 00
Aug  5 21:59:50 01ath3200 kernel: [ 6636.364955] em28xx #0: i2c eeprom 
90: 53 00 42 00 20 00 58 00 53 00 00 00 34 03 54 00
Aug  5 21:59:50 01ath3200 kernel: [ 6636.364961] em28xx #0: i2c eeprom 
a0: 65 00 72 00 72 00 61 00 54 00 65 00 63 00 20 00
Aug  5 21:59:50 01ath3200 kernel: [ 6636.364968] em28xx #0: i2c eeprom 
b0: 45 00 6c 00 65 00 63 00 74 00 72 00 6f 00 6e 00
Aug  5 21:59:50 01ath3200 kernel: [ 6636.364974] em28xx #0: i2c eeprom 
c0: 69 00 63 00 20 00 47 00 6d 00 62 00 48 00 00 00
Aug  5 21:59:50 01ath3200 kernel: [ 6636.364980] em28xx #0: i2c eeprom 
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Aug  5 21:59:50 01ath3200 kernel: [ 6636.364987] em28xx #0: i2c eeprom 
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Aug  5 21:59:50 01ath3200 kernel: [ 6636.364993] em28xx #0: i2c eeprom 
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Aug  5 21:59:50 01ath3200 kernel: [ 6636.365001] em28xx #0: EEPROM ID= 
0x9567eb1a, EEPROM hash = 0x41d0bf96
Aug  5 21:59:50 01ath3200 kernel: [ 6636.365002] em28xx #0: EEPROM info:
Aug  5 21:59:50 01ath3200 kernel: [ 6636.365004] em28xx #0:^IAC97 audio 
(5 sample rates)
Aug  5 21:59:50 01ath3200 kernel: [ 6636.365006] em28xx #0:^I500mA max power
Aug  5 21:59:50 01ath3200 kernel: [ 6636.365008] em28xx #0:^ITable at 
0x06, strings=0x326a, 0x349c, 0x0000
Aug  5 21:59:50 01ath3200 kernel: [ 6636.382818] tvp5150 1-005c: chip 
found @ 0xb8 (em28xx #0)
Aug  5 21:59:50 01ath3200 kernel: [ 6636.398433] tuner 1-0061: chip 
found @ 0xc2 (em28xx #0)
Aug  5 21:59:50 01ath3200 kernel: [ 6636.408529] xc2028 1-0061: creating 
new instance
Aug  5 21:59:50 01ath3200 kernel: [ 6636.408533] xc2028 1-0061: type set 
to XCeive xc2028/xc3028 tuner
Aug  5 21:59:50 01ath3200 kernel: [ 6636.408543] usb 1-3: firmware: 
requesting xc3028-v27.fw
Aug  5 21:59:50 01ath3200 kernel: [ 6636.484304] xc2028 1-0061: Loading 
80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
Aug  5 21:59:50 01ath3200 kernel: [ 6636.532022] xc2028 1-0061: Loading 
firmware for type=BASE (1), id 0000000000000000.
Aug  5 21:59:51 01ath3200 kernel: [ 6637.614070] xc2028 1-0061: Loading 
firmware for type=(0), id 000000000000b700.
Aug  5 21:59:51 01ath3200 kernel: [ 6637.630491] SCODE (20000000), id 
000000000000b700:
Aug  5 21:59:51 01ath3200 kernel: [ 6637.630496] xc2028 1-0061: Loading 
SCODE for type=MONO SCODE HAS_IF_4320 (60008000), id 0000000000008000.
Aug  5 21:59:52 01ath3200 kernel: [ 6637.812497] input: em28xx IR 
(em28xx #0) as /devices/pci0000:00/0000:00:03.3/usb1/1-3/input/input10
Aug  5 21:59:52 01ath3200 pulseaudio[4364]: alsa-util.c: Cannot find 
fallback mixer control "Mic" or mixer control is no combination of 
switch/volume.
Aug  5 21:59:52 01ath3200 kernel: [ 6637.836243] em28xx #0: Config 
register raw data: 0x50
Aug  5 21:59:52 01ath3200 kernel: [ 6637.836986] em28xx #0: AC97 vendor 
ID = 0xffffffff
Aug  5 21:59:52 01ath3200 kernel: [ 6637.837368] em28xx #0: AC97 
features = 0x6a90
Aug  5 21:59:52 01ath3200 kernel: [ 6637.837370] em28xx #0: Empia 202 
AC97 audio processor detected
Aug  5 21:59:52 01ath3200 kernel: [ 6637.948487] tvp5150 1-005c: 
tvp5150am1 detected.
Aug  5 21:59:52 01ath3200 kernel: [ 6638.044877] em28xx #0: v4l2 driver 
version 0.1.2
Aug  5 21:59:52 01ath3200 kernel: [ 6638.115102] em28xx #0: V4L2 device 
registered as /dev/video0 and /dev/vbi0
Aug  5 21:59:52 01ath3200 kernel: [ 6638.131502] usbcore: registered new 
interface driver em28xx
Aug  5 21:59:52 01ath3200 kernel: [ 6638.131507] em28xx driver loaded
Aug  5 21:59:52 01ath3200 kernel: [ 6638.280453] xc2028 1-0061: 
attaching existing instance
Aug  5 21:59:52 01ath3200 kernel: [ 6638.280457] xc2028 1-0061: type set 
to XCeive xc2028/xc3028 tuner
Aug  5 21:59:52 01ath3200 kernel: [ 6638.280460] em28xx #0/2: xc3028 
attached
Aug  5 21:59:52 01ath3200 kernel: [ 6638.280463] DVB: registering new 
adapter (em28xx #0)
Aug  5 21:59:52 01ath3200 kernel: [ 6638.280467] DVB: registering 
adapter 0 frontend 0 (Zarlink ZL10353 DVB-T)...
Aug  5 21:59:52 01ath3200 kernel: [ 6638.280878] Successfully loaded 
em28xx-dvb
Aug  5 21:59:52 01ath3200 kernel: [ 6638.280881] Em28xx: Initialized 
(Em28xx dvb Extension) extension
Aug  5 21:59:52 01ath3200 kernel: [ 6638.564739] tvp5150 1-005c: 
tvp5150am1 detected.

Aug  5 22:00:36 01ath3200 kernel: [ 6681.848015] xc2028 1-0061: Loading 
firmware for type=BASE F8MHZ (3), id 0000000000000000.
Aug  5 22:00:37 01ath3200 kernel: [ 6682.781882] xc2028 1-0061: Loading 
firmware for type=D2633 DTV8 (210), id 0000000000000000.
Aug  5 22:00:37 01ath3200 kernel: [ 6682.795251] xc2028 1-0061: Loading 
SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 
(620003e0), id 0000000000000000.

