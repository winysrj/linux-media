Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.pyx.ch ([212.55.210.221] helo=dmz.pyx.ch)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <joe@pyx.ch>) id 1JpJdY-0006ev-Bg
	for linux-dvb@linuxtv.org; Fri, 25 Apr 2008 10:50:33 +0200
From: Joe Ammann <joe@pyx.ch>
To: "Markus Rechberger" <mrechberger@gmail.com>
Date: Fri, 25 Apr 2008 10:49:50 +0200
References: <200804250056.55050.joe@pyx.ch>
	<d9def9db0804242237g3dc00e43w4047127ae2be3c72@mail.gmail.com>
In-Reply-To: <d9def9db0804242237g3dc00e43w4047127ae2be3c72@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804251049.50538.joe@pyx.ch>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Problems with Hauppauge HVR 900 (B3C0) hybrid USB
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Friday 25 April 2008 07:37:18 you wrote:
> > I'd be thankful for any hints, pointing me to the most promising
> > combination :-) , and willing to post logs and stuff.
>
> could you post the dmesg output?

Currently trying with vanilla 2.6.24.5 with the tree from 
http://linuxtv.org/hg/v4l-dvb.

I must correct myself. Analoge tuning DOES WORK (in xawtv), but kdetv is not 
able to scan. I also have a problem with sound, but I remember issue with 
that on several howto's. I will try that later.

dmesg output:

usb 1-1: new high speed USB device using ehci_hcd and address 9
usb 1-1: configuration #1 chosen from 1 choice
Linux video capture interface: v2.00
em28xx v4l2 driver version 0.1.0 loaded
em28xx new video device (2040:6502): interface 0, class 255
em28xx Doesn't have usb audio class
em28xx #0: Alternate settings: 8
em28xx #0: Alternate setting 0, max size= 0
em28xx #0: Alternate setting 1, max size= 0
em28xx #0: Alternate setting 2, max size= 1448
em28xx #0: Alternate setting 3, max size= 2048
em28xx #0: Alternate setting 4, max size= 2304
em28xx #0: Alternate setting 5, max size= 2580
em28xx #0: Alternate setting 6, max size= 2892
em28xx #0: Alternate setting 7, max size= 3072
em28xx #0: chip ID is em2882/em2883
em28xx #0: i2c eeprom 00: 1a eb 67 95 40 20 02 65 d0 12 5c 03 82 1e 6a 18
em28xx #0: i2c eeprom 10: 00 00 24 57 66 07 01 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 02 00 b8 00 00 00 5b e0 00 00
em28xx #0: i2c eeprom 30: 00 00 20 40 20 6e 02 20 10 01 01 01 00 00 00 00
em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 18 03 34 00 30 00
em28xx #0: i2c eeprom 70: 33 00 30 00 35 00 34 00 37 00 37 00 30 00 32 00
em28xx #0: i2c eeprom 80: 00 00 1e 03 57 00 69 00 6e 00 54 00 56 00 20 00
em28xx #0: i2c eeprom 90: 48 00 56 00 52 00 2d 00 39 00 30 00 30 00 00 00
em28xx #0: i2c eeprom a0: 84 12 00 00 05 50 1a 7f d4 78 23 fa fd d0 38 89
em28xx #0: i2c eeprom b0: ff 00 00 00 04 84 0a 00 01 01 20 77 00 40 f6 46
em28xx #0: i2c eeprom c0: 3d f0 74 02 01 00 01 79 c1 00 00 00 00 00 00 00
em28xx #0: i2c eeprom d0: 84 12 00 00 05 50 1a 7f d4 78 23 fa fd d0 38 89
em28xx #0: i2c eeprom e0: ff 00 00 00 04 84 0a 00 01 01 20 77 00 40 f6 46
em28xx #0: i2c eeprom f0: 3d f0 74 02 01 00 01 79 c1 00 00 00 00 00 00 00
EEPROM ID= 0x9567eb1a, hash = 0x975737dd
Vendor/Product ID= 2040:6502
AC97 audio (5 sample rates)
500mA max power
Table at 0x24, strings=0x1e82, 0x186a, 0x0000
tveeprom 1-0050: Hauppauge model 65018, rev B3C0, serial# 4015862
tveeprom 1-0050: tuner model is Xceive XC3028 (idx 120, type 71)
tveeprom 1-0050: TV standards PAL(B/G) PAL(I) PAL(D/D1/K) ATSC/DVB Digital 
(eeprom 0xd4)
tveeprom 1-0050: audio processor is None (idx 0)
tveeprom 1-0050: has radio
tuner' 1-0061: chip found @ 0xc2 (em28xx #0)
xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
xc2028 1-0061: xc2028/3028 firmware name not set!
xc2028 1-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 
firmware, ver 2.7
xc2028 1-0061: Loading firmware for type=BASE MTS (5), id 0000000000000000.
xc2028 1-0061: Loading firmware for type=MTS (4), id 000000000000b700.
xc2028 1-0061: Device is Xceive 3028 version 1.0, firmware version 2.7
tvp5150 1-005c: tvp5150am1 detected.
em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
em28xx #0: Found Hauppauge WinTV HVR 900
usbcore: registered new interface driver em28xx
em28xx-audio.c: probing for em28x1 non standard usbaudio
em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
Em28xx: Initialized (Em28xx Audio Extension) extension

So I guess I'll have to read up on the sound issue. Still, I have no idea with 
the IR remote is not recognized. cat /proc/bus/input/devices gives:

I: Bus=0011 Vendor=0002 Product=0005 Version=0055
N: Name="ImPS/2 Logitech Wheel Mouse"
P: Phys=isa0060/serio1/input0
S: Sysfs=/class/input/input0
U: Uniq=
H: Handlers=mouse0 event0
B: EV=7
B: KEY=70000 0 0 0 0 0 0 0 0
B: REL=103

I: Bus=0003 Vendor=046d Product=c308 Version=0110
N: Name="Logitech Logitech USB Keyboard"
P: Phys=usb-0000:00:03.2-2.1/input0
S: Sysfs=/class/input/input1
U: Uniq=
H: Handlers=kbd event1
B: EV=120013
B: KEY=10000 7 ff800000 7ff febeffdf ffefffff ffffffff fffffffe
B: MSC=10
B: LED=1f

I: Bus=0003 Vendor=046d Product=c308 Version=0110
N: Name="Logitech Logitech USB Keyboard"
P: Phys=usb-0000:00:03.2-2.1/input1
S: Sysfs=/class/input/input2
U: Uniq=
H: Handlers=kbd mouse1 event2
B: EV=17
B: KEY=ffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff 0 
2000000 1878 d800d000 1e0000 0 0 0
B: REL=103
B: MSC=10

I: Bus=0019 Vendor=0000 Product=0002 Version=0000
N: Name="Power Button (FF)"
P: Phys=LNXPWRBN/button/input0
S: Sysfs=/class/input/input3
U: Uniq=
H: Handlers=kbd event3
B: EV=3
B: KEY=100000 0 0 0

I: Bus=0019 Vendor=0000 Product=0001 Version=0000
N: Name="Power Button (CM)"
P: Phys=PNP0C0C/button/input0
S: Sysfs=/class/input/input4
U: Uniq=
H: Handlers=kbd event4
B: EV=3
B: KEY=100000 0 0 0

I: Bus=0010 Vendor=001f Product=0001 Version=0100
N: Name="PC Speaker"
P: Phys=isa0061/input0
S: Sysfs=/class/input/input5
U: Uniq=
H: Handlers=kbd event5
B: EV=40001
B: SND=6

Thanks for you help!

CU, Joe

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
