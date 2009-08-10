Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:33554 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752273AbZHJSgJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Aug 2009 14:36:09 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain
Received: from ironport-out-1.rz.rwth-aachen.de ([134.130.5.40])
 by mta-1.ms.rz.RWTH-Aachen.de
 (Sun Java(tm) System Messaging Server 6.3-7.04 (built Sep 26 2008))
 with ESMTP id <0KO600GRUBO9YR00@mta-1.ms.rz.RWTH-Aachen.de> for
 linux-media@vger.kernel.org; Mon, 10 Aug 2009 20:36:09 +0200 (CEST)
Received: from [192.168.2.8] (p50896EA2.dip.t-dialin.net [80.137.110.162])
	by relay.rwth-aachen.de (8.13.8+Sun/8.13.8/1) with ESMTP id n7AIa94Y001746	for
 <linux-media@vger.kernel.org>; Mon, 10 Aug 2009 20:36:09 +0200 (CEST)
Subject: Hauppauge WinTV-HVR 900: help requested for installation
From: Jobst Hoffmann <j.hoffmann@fh-aachen.de>
To: linux-media@vger.kernel.org
Date: Mon, 10 Aug 2009 20:36:09 +0200
Message-id: <1249929369.2673.15.camel@doityourselfII.athome>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi there,

I'm new in this list, so it may be the wrong place. If so, please excuse
me and let me know, which list I should attend.


My problem: I just want to test me-tv to use DVB-T TV, but it reclaims:

There are no available DVB tuner devices

What I did until now:

1) Downloaded the v4l-dvb tree
2) compiled and loaded the modules
3) checked the modules

lsmod | grep em28 

em28xx_dvb              9588  0 
dvb_core               89792  1 em28xx_dvb
em28xx_alsa             8564  0 
em28xx                 86304  2 em28xx_dvb,em28xx_alsa
ir_common              44836  1 em28xx
v4l2_common            16560  3 tuner,tvp5150,em28xx
videodev               35872  4 tuner,tvp5150,em28xx,v4l2_common
videobuf_vmalloc        6852  1 em28xx
videobuf_core          16388  2 em28xx,videobuf_vmalloc
tveeprom               13716  1 em28xx
snd_pcm                79368  3 em28xx_alsa,snd_hda_intel,snd_hda_codec
snd                    65112  11
em28xx_alsa,snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_timer
i2c_core               22288  10
zl10353,tuner_xc2028,tuner,tvp5150,em28xx,v4l2_common,videodev,tveeprom,nvidia,i2c_i801

4) looked at the output of dmesg

dmesg (excerpt)

Linux video capture interface: v2.00
usbcore: registered new interface driver em28xx
em28xx driver loaded
Em28xx: Initialized (Em28xx dvb Extension) extension
Em28xx: Initialized (Em28xx Audio Extension) extension
usb 2-5: new high speed USB device using ehci_hcd and address 2
usb 2-5: New USB device found, idVendor=2040, idProduct=6502
usb 2-5: New USB device strings: Mfr=0, Product=1, SerialNumber=2
usb 2-5: Product: WinTV HVR-900
usb 2-5: SerialNumber: 4028599240
usb 2-5: configuration #1 chosen from 1 choice
em28xx: New device WinTV HVR-900 @ 480 Mbps (2040:6502, interface 0,
class 0)
em28xx #0: Identified as Hauppauge WinTV HVR 900 (card=10)
em28xx #0: chip ID is em2882/em2883
em28xx #0: i2c eeprom 00: 1a eb 67 95 40 20 02 65 d0 12 5c 03 82 1e 6a
18
em28xx #0: i2c eeprom 10: 00 00 24 57 66 07 01 00 00 00 00 00 00 00 00
00
em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 02 00 b8 00 00 00 5b e0 00
00
em28xx #0: i2c eeprom 30: 00 00 20 40 20 6e 02 20 10 01 01 01 00 00 00
00
em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00
em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00
em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 18 03 34 00 30
00
em28xx #0: i2c eeprom 70: 32 00 38 00 35 00 39 00 39 00 32 00 34 00 30
00
em28xx #0: i2c eeprom 80: 00 00 1e 03 57 00 69 00 6e 00 54 00 56 00 20
00
em28xx #0: i2c eeprom 90: 48 00 56 00 52 00 2d 00 39 00 30 00 30 00 00
00
em28xx #0: i2c eeprom a0: 84 12 00 00 05 50 1a 7f d4 78 23 fa fd d0 28
89
em28xx #0: i2c eeprom b0: ff 00 00 00 04 84 0a 00 01 01 20 77 00 40 c8
8b
em28xx #0: i2c eeprom c0: 1f f0 74 02 01 00 01 79 d8 00 00 00 00 00 00
00
em28xx #0: i2c eeprom d0: 84 12 00 00 05 50 1a 7f d4 78 23 fa fd d0 28
89
em28xx #0: i2c eeprom e0: ff 00 00 00 04 84 0a 00 01 01 20 77 00 40 c8
8b
em28xx #0: i2c eeprom f0: 1f f0 74 02 01 00 01 79 d8 00 00 00 00 00 00
00
em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0xc93735dd
em28xx #0: EEPROM info:
em28xx #0:	AC97 audio (5 sample rates)
em28xx #0:	500mA max power
em28xx #0:	Table at 0x24, strings=0x1e82, 0x186a, 0x0000
tveeprom 3-0050: Hauppauge model 65018, rev B2C0, serial# 2067400
tveeprom 3-0050: tuner model is Xceive XC3028 (idx 120, type 71)
tveeprom 3-0050: TV standards PAL(B/G) PAL(I) PAL(D/D1/K) ATSC/DVB
Digital (eeprom 0xd4)
tveeprom 3-0050: audio processor is None (idx 0)
tveeprom 3-0050: has radio
tvp5150 3-005c: chip found @ 0xb8 (em28xx #0)
tuner 3-0061: chip found @ 0xc2 (em28xx #0)
xc2028 3-0061: creating new instance
xc2028 3-0061: type set to XCeive xc2028/xc3028 tuner
usb 2-5: firmware: requesting xc3028-v27.fw
xc2028 3-0061: Loading 80 firmware images from xc3028-v27.fw, type:
xc2028 firmware, ver 2.7
xc2028 3-0061: Loading firmware for type=BASE MTS (5), id
0000000000000000.
xc2028 3-0061: Loading firmware for type=MTS (4), id 000000000000b700.
xc2028 3-0061: Loading SCODE for type=MTS LCD NOGD MONO IF SCODE
HAS_IF_4500 (6002b004), id 000000000000b700.
input: em28xx IR (em28xx #0)
as /devices/pci0000:00/0000:00:1d.7/usb2/2-5/input/input6
em28xx #0: Config register raw data: 0xd0
em28xx #0: AC97 vendor ID = 0xffffffff
em28xx #0: AC97 features = 0x6a90
em28xx #0: Empia 202 AC97 audio processor detected
tvp5150 3-005c: tvp5150am1 detected.
em28xx #0: v4l2 driver version 0.1.2
em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
zl10353_read_register: readreg error (reg=127, ret==-19)
em28xx #0/2: dvb frontend not attached. Can't attach xc3028
em28xx-audio.c: probing for em28x1 non standard usbaudio
em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
tvp5150 3-005c: tvp5150am1 detected.

I searched the net for the error messages

zl10353_read_register: readreg error (reg=127, ret==-19)

and

em28xx #0/2: dvb frontend not attached. Can't attach xc3028

but that wasn't very helpful. Is there anybody, who can give me a hint?
Where is my mistake? Any help is appreciated!

In
http://www.linuxtv.org/wiki/index.php/Em28xx_devices#How_to_compile_the_latest_em28xx_driver.3F
the stick is announced as validated.

Many thanks in advance
Jobst

PS. With earlier kernels - without em28xx support - I've succeeded by
using the kernel modules of M. Rechberger.
-- 
J. Hoffmann                             
                                        email: j.hoffmann@fh-aachen.de

