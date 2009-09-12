Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:58160 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbZILIgS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Sep 2009 04:36:18 -0400
Received: by bwz19 with SMTP id 19so1216224bwz.37
        for <linux-media@vger.kernel.org>; Sat, 12 Sep 2009 01:36:20 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 12 Sep 2009 15:36:20 +0700
Message-ID: <c62e66e90909120136s6e0bc796jc9cb3e45d2b7e467@mail.gmail.com>
Subject: Re: ZC0301 webcam, successful trace from spca5xx driver
From: "test.r test.r" <test.application.r@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Using the old spca5xx with Debian kernel 2.6.18 the webcam is working.
"Release 0.60.00 as spca5xx-v4l1-goodbye" available in Debian etch.
The traces below may help someone wanting to port this webcam to the
new driver architecture.

Have a good day,
Guillaume


Below, the dmesg after modprobe spca5xx debug=5 and plugging the webcam:
usbcore: registered new driver spca5xx
/usr/src/modules/spca5xx/drivers/usb/spca5xx.c: spca5xx driver
00.60.00 registered
usb 1-1: new full speed USB device using uhci_hcd and address 3
usb 1-1: configuration #1 chosen from 1 choice
/usr/src/modules/spca5xx/drivers/usb/spca5xx.c: USB SPCA5XX camera
found. Type Vimicro Zc301P 0x301b
/usr/src/modules/spca5xx/drivers/usb/spca5xx.c: [spca5xx_probe:5480]
Camera type JPEG
/usr/src/modules/spca5xx/drivers/usb/spca5xx.c:
[spca50x_configure:3298] video_register_device succeeded
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegWrite:131]
reg write: 0x40, 0xA0,0x01, 0x00
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegWrite:131]
reg write: 0x40, 0xA0,0x0F, 0x10
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegWrite:131]
reg write: 0x40, 0xA0,0x01, 0x01
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegWrite:131]
reg write: 0x40, 0xA0,0x03, 0x12
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegWrite:131]
reg write: 0x40, 0xA0,0x01, 0x12
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegWrite:131]
reg write: 0x40, 0xA0,0x08, 0x8D
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegWrite:131]
reg write: 0x40, 0xA0,0x00, 0x92
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegWrite:131]
reg write: 0x40, 0xA0,0x02, 0x90
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegRead:94]
reg read: 0xC0, 0xA1, 0x01, 0x91: 0x0000
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegRead:94]
reg read: 0xC0, 0xA1, 0x01, 0x95: 0x0000
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegRead:94]
reg read: 0xC0, 0xA1, 0x01, 0x96: 0x0000
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegWrite:131]
reg write: 0x40, 0xA0,0x01, 0x92
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegWrite:131]
reg write: 0x40, 0xA0,0x02, 0x90
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegRead:94]
reg read: 0xC0, 0xA1, 0x01, 0x91: 0x0000
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegRead:94]
reg read: 0xC0, 0xA1, 0x01, 0x95: 0x0000
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegRead:94]
reg read: 0xC0, 0xA1, 0x01, 0x96: 0x0000
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegWrite:131]
reg write: 0x40, 0xA0,0x03, 0x92
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegWrite:131]
reg write: 0x40, 0xA0,0xAA, 0x93
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegWrite:131]
reg write: 0x40, 0xA0,0x00, 0x94
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegWrite:131]
reg write: 0x40, 0xA0,0x01, 0x90
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegRead:94]
reg read: 0xC0, 0xA1, 0x01, 0x91: 0x0000
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegWrite:131]
reg write: 0x40, 0xA0,0x03, 0x92
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegWrite:131]
reg write: 0x40, 0xA0,0x02, 0x90
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegRead:94]
reg read: 0xC0, 0xA1, 0x01, 0x91: 0x0000
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegRead:94]
reg read: 0xC0, 0xA1, 0x01, 0x95: 0x0000
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegRead:94]
reg read: 0xC0, 0xA1, 0x01, 0x96: 0x0000
/usr/src/modules/spca5xx/drivers/usb/zc3xx.h: [zcxx_probeSensor:176]
sensor answer1  0
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegWrite:131]
reg write: 0x40, 0xA0,0x01, 0x00
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegWrite:131]
reg write: 0x40, 0xA0,0x00, 0x10
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegWrite:131]
reg write: 0x40, 0xA0,0x01, 0x01
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegWrite:131]
reg write: 0x40, 0xA0,0x03, 0x12
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegWrite:131]
reg write: 0x40, 0xA0,0x01, 0x12
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegWrite:131]
reg write: 0x40, 0xA0,0x01, 0x92
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegWrite:131]
reg write: 0x40, 0xA0,0xAA, 0x93
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegWrite:131]
reg write: 0x40, 0xA0,0x00, 0x94
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegWrite:131]
reg write: 0x40, 0xA0,0x01, 0x90
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegRead:94]
reg read: 0xC0, 0xA1, 0x01, 0x91: 0x0000
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegWrite:131]
reg write: 0x40, 0xA0,0x00, 0x92
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegWrite:131]
reg write: 0x40, 0xA0,0x02, 0x90
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegRead:94]
reg read: 0xC0, 0xA1, 0x01, 0x91: 0x0000
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegRead:94]
reg read: 0xC0, 0xA1, 0x01, 0x95: 0x0000
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegRead:94]
reg read: 0xC0, 0xA1, 0x01, 0x96: 0x0000
/usr/src/modules/spca5xx/drivers/usb/zc3xx.h: [zcxx_probeSensor:251]
check sensor id  0x0000
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegWrite:131]
reg write: 0x40, 0xA0,0x01, 0x92
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegWrite:131]
reg write: 0x40, 0xA0,0x02, 0x90
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegRead:94]
reg read: 0xC0, 0xA1, 0x01, 0x91: 0x0000
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegRead:94]
reg read: 0xC0, 0xA1, 0x01, 0x95: 0x0000
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegRead:94]
reg read: 0xC0, 0xA1, 0x01, 0x96: 0x0000
/usr/src/modules/spca5xx/drivers/usb/zc3xx.h: [zcxx_probeSensor:259]
sensor answervga  0
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegWrite:131]
reg write: 0x40, 0xA0,0x01, 0x00
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegWrite:131]
reg write: 0x40, 0xA0,0x04, 0x10
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegWrite:131]
reg write: 0x40, 0xA0,0x01, 0x01
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegWrite:131]
reg write: 0x40, 0xA0,0x03, 0x12
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegWrite:131]
reg write: 0x40, 0xA0,0x01, 0x12
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegWrite:131]
reg write: 0x40, 0xA0,0x01, 0x92
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegWrite:131]
reg write: 0x40, 0xA0,0xAA, 0x93
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegWrite:131]
reg write: 0x40, 0xA0,0x00, 0x94
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegWrite:131]
reg write: 0x40, 0xA0,0x01, 0x90
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegRead:94]
reg read: 0xC0, 0xA1, 0x01, 0x91: 0x0000
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegWrite:131]
reg write: 0x40, 0xA0,0x00, 0x92
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegWrite:131]
reg write: 0x40, 0xA0,0x02, 0x90
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegRead:94]
reg read: 0xC0, 0xA1, 0x01, 0x91: 0x0000
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegRead:94]
reg read: 0xC0, 0xA1, 0x01, 0x95: 0x0000
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegRead:94]
reg read: 0xC0, 0xA1, 0x01, 0x96: 0x0000
/usr/src/modules/spca5xx/drivers/usb/zc3xx.h: [zcxx_probeSensor:251]
check sensor id  0x0000
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegWrite:131]
reg write: 0x40, 0xA0,0x01, 0x92
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegWrite:131]
reg write: 0x40, 0xA0,0x02, 0x90
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegRead:94]
reg read: 0xC0, 0xA1, 0x01, 0x91: 0x0000
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegRead:94]
reg read: 0xC0, 0xA1, 0x01, 0x95: 0x0045
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegRead:94]
reg read: 0xC0, 0xA1, 0x01, 0x96: 0x0000
/usr/src/modules/spca5xx/drivers/usb/zc3xx.h: [zcxx_probeSensor:259]
sensor answervga  69
/usr/src/modules/spca5xx/drivers/usb/zc3xx.h: [zc3xx_config:503] Find
Sensor CS2102
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegWrite:131]
reg write: 0x40, 0xA0,0x04, 0x10
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegRead:94]
reg read: 0xC0, 0xA1, 0x01, 0x10: 0x0004
/usr/src/modules/spca5xx/drivers/usb/spca5xx.c:
[spca50x_set_packet_size:1405] iface alt size: 0 0 0
/usr/src/modules/spca5xx/drivers/usb/spca5xx.c:
[spca50x_set_packet_size:1441] set real packet size: 0, alt=0
/usr/src/modules/spca5xx/drivers/usb/spca5xx.c:
[spca5xx_getcapability:1765] maxw 640 maxh 480 minw 176 minh 144
/usr/src/modules/spca5xx/drivers/usb/spca5xx.c:
[spca50x_configure:3321] Spca5xx Configure done !!
/usr/src/modules/spca5xx/drivers/usb/spca5xx.c: [spca5xx_probe:5514]
setting video device = e7822000, spca50x = e0148000



Below the very beginning of dmesg after issuing command mplayer tv://
Jan  1 00:05:20 debian kernel:
/usr/src/modules/spca5xx/drivers/usb/spca5xx.c: [spca5xx_open:2404]
opening
Jan  1 00:05:20 debian kernel:
/usr/src/modules/spca5xx/drivers/usb/spca5xx.c: [spca50x_alloc:2192]
entered
Jan  1 00:05:20 debian kernel:
/usr/src/modules/spca5xx/drivers/usb/spca5xx.c: [spca50x_alloc:2211]
frame[0] @ e8d35000
Jan  1 00:05:20 debian kernel:
/usr/src/modules/spca5xx/drivers/usb/spca5xx.c: [spca50x_alloc:2211]
frame[1] @ e8e61008
Jan  1 00:05:20 debian kernel:
/usr/src/modules/spca5xx/drivers/usb/spca5xx.c: [spca50x_alloc:2220]
sbuf[0] @ dc71c000
Jan  1 00:05:20 debian kernel:
/usr/src/modules/spca5xx/drivers/usb/spca5xx.c: [spca50x_alloc:2220]
sbuf[1] @ dc720000
Jan  1 00:05:20 debian kernel:
/usr/src/modules/spca5xx/drivers/usb/spca5xx.c: [spca50x_alloc:2225]
leaving
Jan  1 00:05:20 debian kernel:
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegWrite:131]
reg write: 0x40, 0xA0,0x01, 0x00
Jan  1 00:05:20 debian kernel:
/usr/src/modules/spca5xx/drivers/usb/spca5xx.c: [spca5xx_setMode:1825]
spca5xx set mode asked w 320 h 240 p 4
Jan  1 00:05:20 debian kernel:
/usr/src/modules/spca5xx/drivers/usb/spca5xx.c: [spca5xx_setMode:1898]
Found code 1 method 0
Jan  1 00:05:20 debian kernel:
/usr/src/modules/spca5xx/drivers/usb/spca5xx.c: [spca5xx_setMode:1900]
Soft Win width height 320 x 240
Jan  1 00:05:20 debian kernel:
/usr/src/modules/spca5xx/drivers/usb/spca5xx.c: [spca5xx_setMode:1902]
Hard Win width height 320 x 240
Jan  1 00:05:20 debian kernel:
/usr/src/modules/spca5xx/drivers/usb/spca5xx.c:
[spca50x_init_isoc:1583] *** Initializing capture ***
Jan  1 00:05:20 debian kernel:
/usr/src/modules/spca5xx/drivers/usb/spca5xx.c:
[spca50x_set_packet_size:1405] iface alt size: 0 7 1023
Jan  1 00:05:20 debian kernel:
/usr/src/modules/spca5xx/drivers/usb/spca5xx.c:
[spca50x_set_packet_size:1441] set real packet size: 1023, alt=7
Jan  1 00:05:20 debian kernel:
/usr/src/modules/spca5xx/drivers/usb/spca5xx.c:
[spca50x_init_isoc:1592] setpacketsize 1023
Jan  1 00:05:20 debian kernel:
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegRead:94]
reg read: 0xC0, 0xA1, 0x01, 0x08: 0x0011
Jan  1 00:05:20 debian kernel:
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegRead:94]
reg read: 0xC0, 0xA1, 0x01, 0x08: 0x0011
Jan  1 00:05:20 debian kernel:
/usr/src/modules/spca5xx/drivers/usb/spcausb.h: [spca5xxRegWrite:131]
reg write: 0x40, 0xA0,0x01, 0x00
