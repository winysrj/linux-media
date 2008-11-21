Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mALHs1qs024939
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 12:54:01 -0500
Received: from rn-out-0910.google.com (rn-out-0910.google.com [64.233.170.186])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mALHroEF029890
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 12:53:50 -0500
Received: by rn-out-0910.google.com with SMTP id k32so987318rnd.7
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 09:53:50 -0800 (PST)
Message-ID: <4ae04ade0811210953i1572aa2ch5c94c049ae29da91@mail.gmail.com>
Date: Fri, 21 Nov 2008 18:53:50 +0100
From: "=?ISO-8859-1?Q?Vladim=EDr_Fuka?=" <vladimir.fuka@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: em28xx: new board id [eb1a:e323]
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

 I've made tests with my MSI DIGIVOX A/D II

I got this dmesg:

Linux video capture interface: v2.00
em28xx v4l2 driver version 0.1.0 loaded
usbcore: registered new interface driver em28xx
usb 2-3.3: new high speed USB device using ehci_hcd and address 7
usb 2-3.3: configuration #1 chosen from 1 choice
em28xx new video device (eb1a:e323): interface 0, class 255
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
em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 23 e3 d0 12 5c 00 6a 22 00 00
em28xx #0: i2c eeprom 10: 00 00 04 57 4e 07 01 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 01 00 00 00 00 00 5b 1e 00 00
em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 00 00 00 00 00 00
em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 22 03 55 00 53 00
em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 38 00 33 00 20 00 44 00
em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
EEPROM ID= 0x9567eb1a, hash = 0x4e913442
Vendor/Product ID= eb1a:e323
AC97 audio (5 sample rates)
500mA max power
Table at 0x04, strings=0x226a, 0x0000, 0x0000
em28xx #0:

em28xx #0: The support for this board weren't valid yet.
em28xx #0: Please send a report of having this working
em28xx #0: not to V4L mailing list (and/or to other addresses)

tuner' 1-0061: chip found @ 0xc2 (em28xx #0)
xc2028 1-0061: creating new instance
xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
xc2028 1-0061: Loading 80 firmware images from xc3028-v27.fw, type:
xc2028 firmware, ver 2.7
xc2028 1-0061: Loading firmware for type=BASE (1), id 0000000000000000.
xc2028 1-0061: Loading firmware for type=(0), id 000000000000b700.
SCODE (20000000), id 000000000000b700:
xc2028 1-0061: Loading SCODE for type=MONO SCODE HAS_IF_4320
(60008000), id 0000000000008000.
em28xx #0: Config register raw data: 0xd0
em28xx #0: AC97 vendor ID = 0x7d057d05
em28xx #0: AC97 features = 0x7d05
em28xx #0: Unknown AC97 audio processor detected!
tvp5150 1-005c: tvp5150am1 detected.
em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
em28xx #0: Found Kworld VS-DVB-T 323UR
em28xx-audio.c: probing for em28x1 non standard usbaudio
em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
Em28xx: Initialized (Em28xx Audio Extension) extension
usb 2-3.3: New USB device found, idVendor=eb1a, idProduct=e323
usb 2-3.3: New USB device strings: Mfr=0, Product=1, SerialNumber=0
usb 2-3.3: Product: USB 2883 Device
tvp5150 1-005c: tvp5150am1 detected.
xc2028 1-0061: Loading firmware for type=(0), id 000000000000b700.
SCODE (20000000), id 000000000000b700:
xc2028 1-0061: Loading SCODE for type=MONO SCODE HAS_IF_4320
(60008000), id 0000000000008000.
submit of urb 0 failed (error=-90)
submit of urb 0 failed (error=-90)
submit of urb 0 failed (error=-90)
submit of urb 0 failed (error=-90)
tvp5150 1-005c: tvp5150am1 detected.
submit of urb 0 failed (error=-90)
submit of urb 0 failed (error=-90)
submit of urb 0 failed (error=-90)
submit of urb 0 failed (error=-90)
tvp5150 1-005c: tvp5150am1 detected.
tvp5150 1-005c: tvp5150am1 detected.
tvp5150 1-005c: tvp5150am1 detected.


The device didn't work.

         Vladimir Fuka

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
