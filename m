Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBK8SO4u019865
	for <video4linux-list@redhat.com>; Sat, 20 Dec 2008 03:28:24 -0500
Received: from jakubs.kubs.cz (jakubs.lantanet.cz [82.119.255.42])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBK8S8Cd017105
	for <video4linux-list@redhat.com>; Sat, 20 Dec 2008 03:28:09 -0500
Message-ID: <494CAC8C.6040905@kubs.cz>
Date: Sat, 20 Dec 2008 09:27:56 +0100
From: Jakub Skopal <j@kubs.cz>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: MSI DigiVOX A/D II not working
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

Hello,

I have MSI DigiVOX A/D II adapter, which should support analog and 
digital TV. Unfortunatelly, the /dev/dvb nodes are not created under 
udev, so I guess something is wrong:

syslog after inserting adapter:

Dec 20 08:58:17 aragorn kernel: [  621.898560] em28xx v4l2 driver 
version 0.1.0 loaded
Dec 20 08:58:17 aragorn kernel: [  621.899506] em28xx new video device 
(eb1a:e323): interface 0, class 255
Dec 20 08:58:17 aragorn kernel: [  621.899521] em28xx Doesn't have usb 
audio class
Dec 20 08:58:17 aragorn kernel: [  621.899525] em28xx #0: Alternate 
settings: 8
Dec 20 08:58:17 aragorn kernel: [  621.899530] em28xx #0: Alternate 
setting 0, max size= 0
Dec 20 08:58:17 aragorn kernel: [  621.899534] em28xx #0: Alternate 
setting 1, max size= 0
Dec 20 08:58:17 aragorn kernel: [  621.899538] em28xx #0: Alternate 
setting 2, max size= 1448
Dec 20 08:58:17 aragorn kernel: [  621.899543] em28xx #0: Alternate 
setting 3, max size= 2048
Dec 20 08:58:17 aragorn kernel: [  621.899547] em28xx #0: Alternate 
setting 4, max size= 2304
Dec 20 08:58:17 aragorn kernel: [  621.899551] em28xx #0: Alternate 
setting 5, max size= 2580
Dec 20 08:58:17 aragorn kernel: [  621.899556] em28xx #0: Alternate 
setting 6, max size= 2892
Dec 20 08:58:17 aragorn kernel: [  621.899561] em28xx #0: Alternate 
setting 7, max size= 3072
Dec 20 08:58:17 aragorn kernel: [  621.909895] em28xx #0: chip ID is 
em2882/em2883
Dec 20 08:58:17 aragorn kernel: [  621.944763] em28xx #0: i2c eeprom 00: 
1a eb 67 95 1a eb 23 e3 d0 12 5c 00 6a 22 00 00
Dec 20 08:58:17 aragorn kernel: [  621.944794] em28xx #0: i2c eeprom 10: 
00 00 04 57 4e 07 01 00 00 00 00 00 00 00 00 00
Dec 20 08:58:17 aragorn kernel: [  621.944817] em28xx #0: i2c eeprom 20: 
46 00 01 00 f0 10 01 00 00 00 00 00 5b 1e 00 00
Dec 20 08:58:17 aragorn kernel: [  621.944839] em28xx #0: i2c eeprom 30: 
00 00 20 40 20 80 02 20 01 01 00 00 00 00 00 00
Dec 20 08:58:17 aragorn kernel: [  621.944862] em28xx #0: i2c eeprom 40: 
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Dec 20 08:58:17 aragorn kernel: [  621.944884] em28xx #0: i2c eeprom 50: 
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Dec 20 08:58:17 aragorn kernel: [  621.944906] em28xx #0: i2c eeprom 60: 
00 00 00 00 00 00 00 00 00 00 22 03 55 00 53 00
Dec 20 08:58:17 aragorn kernel: [  621.944928] em28xx #0: i2c eeprom 70: 
42 00 20 00 32 00 38 00 38 00 33 00 20 00 44 00
Dec 20 08:58:17 aragorn kernel: [  621.944951] em28xx #0: i2c eeprom 80: 
65 00 76 00 69 00 63 00 65 00 00 00 00 00 00 00
Dec 20 08:58:17 aragorn kernel: [  621.944973] em28xx #0: i2c eeprom 90: 
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Dec 20 08:58:17 aragorn kernel: [  621.944995] em28xx #0: i2c eeprom a0: 
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Dec 20 08:58:17 aragorn kernel: [  621.945016] em28xx #0: i2c eeprom b0: 
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Dec 20 08:58:17 aragorn kernel: [  621.945038] em28xx #0: i2c eeprom c0: 
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Dec 20 08:58:17 aragorn kernel: [  621.945060] em28xx #0: i2c eeprom d0: 
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Dec 20 08:58:17 aragorn kernel: [  621.945083] em28xx #0: i2c eeprom e0: 
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Dec 20 08:58:17 aragorn kernel: [  621.945105] em28xx #0: i2c eeprom f0: 
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Dec 20 08:58:17 aragorn kernel: [  621.945129] EEPROM ID= 0x9567eb1a, 
hash = 0x4e913442
Dec 20 08:58:17 aragorn kernel: [  621.945133] Vendor/Product ID= eb1a:e323
Dec 20 08:58:17 aragorn kernel: [  621.945137] AC97 audio (5 sample rates)
Dec 20 08:58:17 aragorn kernel: [  621.945140] 500mA max power
Dec 20 08:58:17 aragorn kernel: [  621.945144] Table at 0x04, 
strings=0x226a, 0x0000, 0x0000
Dec 20 08:58:17 aragorn kernel: [  621.945150] em28xx #0:
Dec 20 08:58:17 aragorn kernel: [  621.945151]
Dec 20 08:58:17 aragorn kernel: [  621.945156] em28xx #0: The support 
for this board weren't valid yet.
Dec 20 08:58:17 aragorn kernel: [  621.945160] em28xx #0: Please send a 
report of having this working
Dec 20 08:58:17 aragorn kernel: [  621.945165] em28xx #0: not to V4L 
mailing list (and/or to other addresses)
Dec 20 08:58:17 aragorn kernel: [  621.945168]
Dec 20 08:58:17 aragorn kernel: [  622.013668] tuner' 0-0061: chip found 
@ 0xc2 (em28xx #0)
Dec 20 08:58:17 aragorn kernel: [  622.076730] xc2028 0-0061: creating 
new instance
Dec 20 08:58:17 aragorn kernel: [  622.076744] xc2028 0-0061: type set 
to XCeive xc2028/xc3028 tuner
Dec 20 08:58:17 aragorn kernel: [  622.076767] firmware: requesting 
xc3028-v27.fw
Dec 20 08:58:17 aragorn kernel: [  622.145241] xc2028 0-0061: Loading 80 
firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
Dec 20 08:58:17 aragorn kernel: [  622.145410] xc2028 0-0061: Loading 
firmware for type=BASE (1), id 0000000000000000.
Dec 20 08:58:18 aragorn kernel: [  623.148156] xc2028 0-0061: Loading 
firmware for type=(0), id 000000000000b700.
Dec 20 08:58:18 aragorn kernel: [  623.166170] SCODE (20000000), id 
000000000000b700:
Dec 20 08:58:18 aragorn kernel: [  623.166188] xc2028 0-0061: Loading 
SCODE for type=MONO SCODE HAS_IF_4320 (60008000), id 0000000000008000.
Dec 20 08:58:18 aragorn kernel: [  623.444899] tvp5150 0-005c: 
tvp5150am1 detected.
Dec 20 08:58:18 aragorn kernel: [  623.614294] em28xx #0: V4L2 device 
registered as /dev/video1 and /dev/vbi0
Dec 20 08:58:18 aragorn kernel: [  623.615628] em28xx #0: Found Kworld 
VS-DVB-T 323UR
Dec 20 08:58:18 aragorn kernel: [  623.616567] usbcore: registered new 
interface driver em28xx
Dec 20 08:58:18 aragorn kernel: [  623.644515] tvp5150 0-005c: 
tvp0050am1 detected.
Dec 20 08:58:18 aragorn kernel: [  623.668506] em28xx-audio.c: probing 
for em28x1 non standard usbaudio
Dec 20 08:58:18 aragorn kernel: [  623.668518] em28xx-audio.c: Copyright 
(C) 2006 Markus Rechberger
Dec 20 08:58:18 aragorn kernel: [  623.670354] Em28xx: Initialized 
(Em28xx Audio Extension) extension

I tried to modprobe em28xx-dvb extension manually. It loads, but does 
not register dvb nodes in /dev either:

Dec 20 09:09:01 aragorn kernel: [ 1266.341178] bttv: driver version 
0.9.17 loaded
Dec 20 09:09:01 aragorn kernel: [ 1266.341191] bttv: using 8 buffers 
with 2080k (520 pages) each for capture
Dec 20 09:09:01 aragorn kernel: [ 1266.370902] bt878: AUDIO driver 
version 0.0.0 loaded
Dec 20 09:11:21 aragorn kernel: [ 1405.967934] Em28xx: Initialized 
(Em28xx dvb Extension) extension

lspci:

Bus 008 Device 002: ID eb1a:e323 eMPIA Technology, Inc.
Bus 008 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 004 Device 003: ID 05ca:18a1 Ricoh Co., Ltd
Bus 004 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 007 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 001 Device 006: ID 413c:8156 Dell Computer Corp.
Bus 001 Device 005: ID 413c:8158 Dell Computer Corp.
Bus 001 Device 004: ID 413c:8157 Dell Computer Corp.
Bus 001 Device 003: ID 0a5c:4500 Broadcom Corp.
Bus 001 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub

I'm running Ubuntu 8.10 on amd64 architecture.

hope this will be usefull to anybody :-)) I'm 100% willing to help with 
detecting/debugging this card, I have no experience with DVB under linux 
though :(

Kuba

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
