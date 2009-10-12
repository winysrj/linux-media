Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:41309 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767AbZJLXYH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Oct 2009 19:24:07 -0400
Received: by bwz6 with SMTP id 6so3505882bwz.37
        for <linux-media@vger.kernel.org>; Mon, 12 Oct 2009 16:23:29 -0700 (PDT)
Date: Tue, 13 Oct 2009 01:22:55 +0200
From: Giuseppe Borzi <gborzi@gmail.com>
To: linux-media@vger.kernel.org
Subject: Re: Dazzle TV Hybrid USB and em28xx
Message-ID: <20091013012255.260afea3@ieee.org>
In-Reply-To: <829197380910121437m4f1fb7cld8d7dc351f468671@mail.gmail.com>
References: <loom.20091011T180513-771@post.gmane.org>
	<829197380910111218q5739eb5ex9a87f19899a13e98@mail.gmail.com>
	<loom.20091012T223603-551@post.gmane.org>
	<829197380910121437m4f1fb7cld8d7dc351f468671@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> 
> Yeah, that happens with Ubuntu Karmic.  The v4l-dvb firedtv driver
> depends on headers that are private to ieee1394 and not in their
> kernel headers package.
> 
> To workaround the issue, open v4l/.config and set the firedtv driver
> from "=m" to "=n"
> 
> Devin
> 

Thanks Devin,
following your instruction for firedtv I've compiled
v4l-dvb-5578cc977a13 but the results aren't so good. After doing an
"make rminstall" , compiling and "make install" I plugged the USB
stick, the various devices were created (including /dev/dvb) and here
is the dmesg output (now it's identified as card=1)

usb 1-3.1: new high speed USB device using ehci_hcd and address 7
usb 1-3.1: configuration #1 chosen from 1 choice
Linux video capture interface: v2.00
em28xx: New device USB 2881 Video @ 480 Mbps (eb1a:2881, interface 0,
class 0) em28xx #0: chip ID is em2882/em2883
em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 81 28 58 12 5c 00 6a 20 6a
00 em28xx #0: i2c eeprom 10: 00 00 04 57 64 57 00 00 60 f4 00 00 02 02
00 00 em28xx #0: i2c eeprom 20: 56 00 01 00 00 00 02 00 b8 00 00 00 5b
1e 00 00 em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 10 02 00 00
00 00 00 00 em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00
00 20 03 55 00 53 00 em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00
38 00 31 00 20 00 56 00 em28xx #0: i2c eeprom 80: 69 00 64 00 65 00 6f
00 00 00 00 00 00 00 00 00 em28xx #0: i2c eeprom 90: 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 em28xx #0: i2c eeprom a0: 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 em28xx #0: i2c eeprom b0: 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 em28xx #0: i2c eeprom c0: 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 em28xx #0: i2c eeprom d0: 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 em28xx #0: i2c eeprom e0: 5a
00 55 aa 79 55 54 03 00 17 98 01 00 00 00 00 em28xx #0: i2c eeprom f0:
0c 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 em28xx #0: EEPROM ID=
0x9567eb1a, EEPROM hash = 0xb8846b20 em28xx #0: EEPROM info:
em28xx #0:	AC97 audio (5 sample rates)
em28xx #0:	USB Remote wakeup capable
em28xx #0:	500mA max power
em28xx #0:	Table at 0x04, strings=0x206a, 0x006a, 0x0000
em28xx #0: Identified as Unknown EM2750/28xx video grabber (card=1)
em28xx #0: Your board has no unique USB ID.
em28xx #0: A hint were successfully done, based on eeprom hash.
em28xx #0: This method is not 100% failproof.
em28xx #0: If the board were missdetected, please email this log to:
em28xx #0: 	V4L Mailing List  <linux-media@vger.kernel.org>
em28xx #0: Board detected as Pinnacle Hybrid Pro
tvp5150 2-005c: chip found @ 0xb8 (em28xx #0)
tuner 2-0061: chip found @ 0xc2 (em28xx #0)
xc2028 2-0061: creating new instance
xc2028 2-0061: type set to XCeive xc2028/xc3028 tuner
usb 1-3.1: firmware: requesting xc3028-v27.fw
xc2028 2-0061: Loading 80 firmware images from xc3028-v27.fw, type:
xc2028 firmware, ver 2.7 xc2028 2-0061: Loading firmware for type=BASE
(1), id 0000000000000000. xc2028 2-0061: Loading firmware for type=(0),
id 000000000000b700. SCODE (20000000), id 000000000000b700:
xc2028 2-0061: Loading SCODE for type=MONO SCODE HAS_IF_4320
(60008000), id 0000000000008000. em28xx #0: Config register raw data:
0x58 em28xx #0: AC97 vendor ID = 0xffffffff
em28xx #0: AC97 features = 0x6a90
em28xx #0: Empia 202 AC97 audio processor detected
tvp5150 2-005c: tvp5150am1 detected.
em28xx #0: v4l2 driver version 0.1.2
em28xx #0: V4L2 video device registered as /dev/video0
em28xx #0: V4L2 VBI device registered as /dev/vbi0
em28xx audio device (eb1a:2881): interface 1, class 1
em28xx audio device (eb1a:2881): interface 2, class 1
usbcore: registered new interface driver em28xx
em28xx driver loaded
usbcore: registered new interface driver snd-usb-audio
xc2028 2-0061: attaching existing instance
xc2028 2-0061: type set to XCeive xc2028/xc3028 tuner
em28xx #0/2: xc3028 attached
DVB: registering new adapter (em28xx #0)
DVB: registering adapter 0 frontend 0 (Zarlink ZL10353 DVB-T)...
Successfully loaded em28xx-dvb
Em28xx: Initialized (Em28xx dvb Extension) extension
tvp5150 2-005c: tvp5150am1 detected.
xc2028 2-0061: Loading firmware for type=BASE F8MHZ (3), id
0000000000000000. xc2028 2-0061: Loading firmware for type=D2633 DTV8
(210), id 0000000000000000. xc2028 2-0061: Loading SCODE for type=DTV6
QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id
0000000000000000. xc2028 2-0061: Loading firmware for type=BASE F8MHZ
(3), id 0000000000000000. xc2028 2-0061: Loading firmware for
type=D2633 DTV8 (210), id 0000000000000000. xc2028 2-0061: Loading
SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE
       HAS_IF_4760
(620003e0), id 0000000000000000. xc2028 2-0061: Loading firmware for
type=BASE F8MHZ (3), id 0000000000000000. xc2028 2-0061: Loading
firmware for type=D2633 DTV78 (110), id 0000000000000000. xc2028
2-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456
SCODE HAS_IF_4760 (620003e0), id 0000000000000000. tvp5150 2-005c:
tvp5150am1 detected. xc2028 2-0061: Loading firmware for type=BASE
F8MHZ (3), id 0000000000000000. (0), id 00000000000000ff: xc2028
2-0061: Loading firmware for type=(0), id 0000000100000007. xc2028
2-0061: Loading SCODE for type=MONO SCODE HAS_IF_5320 (60008000), id
0000000f00000007. mtt[18144]: segfault at 0 ip (null) sp
00007fffcd5b12f8 error 4 in mtt[400000+26000] tvp5150 2-005c:
tvp5150am1 detected. xc2028 2-0061: Loading firmware for type=BASE
F8MHZ (3), id 0000000000000000. (0), id 00000000000000ff: xc2028
2-0061: Loading firmware for type=(0), id 0000000100000007. xc2028
2-0061: Loading SCODE for type=MONO SCODE HAS_IF_5320 (60008000), id
0000000f00000007. tvp5150 2-005c: tvp5150am1 detected. tvp5150 2-005c:
tvp5150am1 detected. xc2028 2-0061: Loading firmware for type=BASE
F8MHZ (3), id 0000000000000000. (0), id 00000000000000ff: xc2028
2-0061: Loading firmware for type=(0), id 0000000100000007. xc2028
2-0061: Loading SCODE for type=MONO SCODE HAS_IF_5320 (60008000), id
0000000f00000007. tvp5150 2-005c: tvp5150am1 detected. tvp5150 2-005c:
tvp5150am1 detected. xc2028 2-0061: Loading firmware for type=BASE
F8MHZ (3), id 0000000000000000. (0), id 00000000000000ff: xc2028
2-0061: Loading firmware for type=(0), id 0000000100000007. xc2028
2-0061: Loading SCODE for type=MONO SCODE HAS_IF_5320 (60008000), id
0000000f00000007. xc2028 2-0061: Loading firmware for type=BASE F8MHZ
(3), id 0000000000000000. xc2028 2-0061: Loading firmware for
type=D2633 DTV78 (110), id 0000000000000000. xc2028 2-0061: Loading
SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE
      HAS_IF_4760
(620003e0), id 0000000000000000. xc2028 2-0061: Loading firmware for
type=BASE F8MHZ (3), id 0000000000000000. xc2028 2-0061: Loading
firmware for type=D2633 DTV78 (110), id 0000000000000000. xc2028
2-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456
SCODE HAS_IF_4760 (620003e0), id 0000000000000000. xc2028 2-0061:
Loading firmware for type=BASE F8MHZ (3), id 0000000000000000. xc2028
2-0061: Loading firmware for type=D2633 DTV78 (110), id
0000000000000000. xc2028 2-0061: Loading SCODE for type=DTV6 QAM DTV7
DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id
0000000000000000. wlan0: disassociating by local choice (reason=3)
[drm] TV-14: set mode NTSC 480i 0

then I started checking if it works. The command "vlc channels.conf"
works, i.e. it plays the first channel in the list, but is unable to
switch channel. me-tv doesn't start, but I think this is related to the
recent gnome upgrade. w_scan doesn't find any channel.
Analog TV only shows video, no audio. Tried this both with sox and vlc.
When you say that I have to choose the right TV standard (PAL for my
region) do you mean I have to select this in the TV app I'm using
(tvtime, vlc, xawtv) or as a module option? I've not seen any em28xx
option for TV standard, so I suppose it's in the app.
Finally, I've noticed that the device is much less hot than it happened
with out of kernel modules and the card=11 workaround.
Is your latest post "em28xx mode switching" related to my device?


