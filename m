Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3N890GE019992
	for <video4linux-list@redhat.com>; Wed, 23 Apr 2008 04:09:00 -0400
Received: from web27910.mail.ukl.yahoo.com (web27910.mail.ukl.yahoo.com
	[217.146.182.60])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m3N88lcb006118
	for <video4linux-list@redhat.com>; Wed, 23 Apr 2008 04:08:48 -0400
Date: Wed, 23 Apr 2008 09:08:41 +0100 (BST)
From: "Edward J. Sheldrake" <ejs1920@yahoo.co.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <20080422183740.5aac8772@gaivota>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0-1966068896-1208938121=:36100"
Content-Transfer-Encoding: 8bit
Message-ID: <920100.36100.qm@web27910.mail.ukl.yahoo.com>
Cc: video4linux-list@redhat.com
Subject: Re: em28xx/xc3028: changeset 7651 breaks analog audio?
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

--0-1966068896-1208938121=:36100
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Content-Id: 
Content-Disposition: inline

--- Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> I'm enclosing two hacks. please, re-apply 7651, and try first
> hack1.patch.
> Then, revert it and apply hack2.patch.
> 
> Please tell me if both hacks work or not, and send me the dmesgs for
> each case
> (after loading mplayer).
> 
Hi Mauro

I started with a fresh copy of the v4l-dvb repo updated to changeset
7673 each time.

hack1: works
hack2: works

I opened and closed mplayer twice for each test, so there are some
normal "resubmit of audio urb failed" messages included. Dmesg output
is attached, hack1 first.

--

Edward Sheldrake


      __________________________________________________________
Sent from Yahoo! Mail.
A Smarter Email http://uk.docs.yahoo.com/nowyoucan.html
--0-1966068896-1208938121=:36100
Content-Type: text/plain; name="hack1-works-dmesg.txt"
Content-Description: 3884911716-hack1-works-dmesg.txt
Content-Disposition: inline; filename="hack1-works-dmesg.txt"

usb 1-4.1: new high speed USB device using ehci_hcd and address 4
usb 1-4.1: configuration #1 chosen from 1 choice
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
em28xx #0: i2c eeprom 70: 32 00 38 00 37 00 33 00 35 00 39 00 39 00 37 00
em28xx #0: i2c eeprom 80: 00 00 1e 03 57 00 69 00 6e 00 54 00 56 00 20 00
em28xx #0: i2c eeprom 90: 48 00 56 00 52 00 2d 00 39 00 30 00 30 00 00 00
em28xx #0: i2c eeprom a0: 84 12 00 00 05 50 1a 7f d4 78 23 fa fd d0 38 89
em28xx #0: i2c eeprom b0: ff 00 00 00 04 84 0a 00 01 01 20 77 00 40 fd a1
em28xx #0: i2c eeprom c0: 21 f0 74 02 01 00 01 79 7b 00 00 00 00 00 00 00
em28xx #0: i2c eeprom d0: 84 12 00 00 05 50 1a 7f d4 78 23 fa fd d0 38 89
em28xx #0: i2c eeprom e0: ff 00 00 00 04 84 0a 00 01 01 20 77 00 40 fd a1
em28xx #0: i2c eeprom f0: 21 f0 74 02 01 00 01 79 7b 00 00 00 00 00 00 00
EEPROM ID= 0x9567eb1a, hash = 0x8f1f33dd
Vendor/Product ID= 2040:6502
AC97 audio (5 sample rates)
500mA max power
Table at 0x24, strings=0x1e82, 0x186a, 0x0000
tveeprom 1-0050: Hauppauge model 65018, rev B3C0, serial# 2204157
tveeprom 1-0050: tuner model is Xceive XC3028 (idx 120, type 71)
tveeprom 1-0050: TV standards PAL(B/G) PAL(I) PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xd4)
tveeprom 1-0050: audio processor is None (idx 0)
tveeprom 1-0050: has radio
tuner' 1-0061: chip found @ 0xc2 (em28xx #0)
xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
xc2028 1-0061: xc2028/3028 firmware name not set!
xc2028 1-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
xc2028 1-0061: Loading firmware for type=BASE MTS (5), id 0000000000000000.
xc2028 1-0061: Loading firmware for type=MTS (4), id 000000000000b700.
xc2028 1-0061: Loading SCODE for type=MONO SCODE HAS_IF_6000 (60008000), id 000000000000b700.
tvp5150 1-005c: tvp5150am1 detected.
em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
em28xx #0: Found Hauppauge WinTV HVR 900
usbcore: registered new interface driver em28xx
em28xx-audio.c: probing for em28x1 non standard usbaudio
em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
Em28xx: Initialized (Em28xx Audio Extension) extension
tvp5150 1-005c: tvp5150am1 detected.
xc2028 1-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.
xc2028 1-0061: Loading firmware for type=MTS (4), id 0000000000000010.
xc2028 1-0061: Loading SCODE for type=MONO SCODE HAS_IF_6000 (60008000), id 0000000000000010.
em28xx #0: resubmit of audio urb failed (error=-2)
em28xx #0: resubmit of audio urb failed (error=-2)
em28xx #0: resubmit of audio urb failed (error=-2)
em28xx #0: resubmit of audio urb failed (error=-2)
em28xx #0: resubmit of audio urb failed (error=-2)
An underrun very likely occurred. Ignoring it.
tvp5150 1-005c: tvp5150am1 detected.
em28xx #0: resubmit of audio urb failed (error=-2)
em28xx #0: resubmit of audio urb failed (error=-2)
em28xx #0: resubmit of audio urb failed (error=-2)
em28xx #0: resubmit of audio urb failed (error=-2)
em28xx #0: resubmit of audio urb failed (error=-2)
An underrun very likely occurred. Ignoring it.

--0-1966068896-1208938121=:36100
Content-Type: text/plain; name="hack2-works-dmesg.txt"
Content-Description: 1461461597-hack2-works-dmesg.txt
Content-Disposition: inline; filename="hack2-works-dmesg.txt"

usb 1-4.1: new high speed USB device using ehci_hcd and address 5
usb 1-4.1: configuration #1 chosen from 1 choice
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
em28xx #0: i2c eeprom 70: 32 00 38 00 37 00 33 00 35 00 39 00 39 00 37 00
em28xx #0: i2c eeprom 80: 00 00 1e 03 57 00 69 00 6e 00 54 00 56 00 20 00
em28xx #0: i2c eeprom 90: 48 00 56 00 52 00 2d 00 39 00 30 00 30 00 00 00
em28xx #0: i2c eeprom a0: 84 12 00 00 05 50 1a 7f d4 78 23 fa fd d0 38 89
em28xx #0: i2c eeprom b0: ff 00 00 00 04 84 0a 00 01 01 20 77 00 40 fd a1
em28xx #0: i2c eeprom c0: 21 f0 74 02 01 00 01 79 7b 00 00 00 00 00 00 00
em28xx #0: i2c eeprom d0: 84 12 00 00 05 50 1a 7f d4 78 23 fa fd d0 38 89
em28xx #0: i2c eeprom e0: ff 00 00 00 04 84 0a 00 01 01 20 77 00 40 fd a1
em28xx #0: i2c eeprom f0: 21 f0 74 02 01 00 01 79 7b 00 00 00 00 00 00 00
EEPROM ID= 0x9567eb1a, hash = 0x8f1f33dd
Vendor/Product ID= 2040:6502
AC97 audio (5 sample rates)
500mA max power
Table at 0x24, strings=0x1e82, 0x186a, 0x0000
tveeprom 1-0050: Hauppauge model 65018, rev B3C0, serial# 2204157
tveeprom 1-0050: tuner model is Xceive XC3028 (idx 120, type 71)
tveeprom 1-0050: TV standards PAL(B/G) PAL(I) PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xd4)
tveeprom 1-0050: audio processor is None (idx 0)
tveeprom 1-0050: has radio
tuner' 1-0061: chip found @ 0xc2 (em28xx #0)
xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
xc2028 1-0061: xc2028/3028 firmware name not set!
xc2028 1-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
xc2028 1-0061: Loading firmware for type=BASE MTS (5), id 0000000000000000.
xc2028 1-0061: Loading firmware for type=MTS (4), id 000000000000b700.
xc2028 1-0061: Loading SCODE for type=MTS LCD NOGD MONO IF SCODE HAS_IF_4500 (6002b004), id 000000000000b700.
tvp5150 1-005c: tvp5150am1 detected.
em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
em28xx #0: Found Hauppauge WinTV HVR 900
usbcore: registered new interface driver em28xx
em28xx-audio.c: probing for em28x1 non standard usbaudio
em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
Em28xx: Initialized (Em28xx Audio Extension) extension
tvp5150 1-005c: tvp5150am1 detected.
xc2028 1-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.
xc2028 1-0061: Loading firmware for type=MTS (4), id 0000000000000010.
em28xx #0: resubmit of audio urb failed (error=-2)
em28xx #0: resubmit of audio urb failed (error=-2)
em28xx #0: resubmit of audio urb failed (error=-2)
em28xx #0: resubmit of audio urb failed (error=-2)
em28xx #0: resubmit of audio urb failed (error=-2)
An underrun very likely occurred. Ignoring it.
tvp5150 1-005c: tvp5150am1 detected.
em28xx #0: resubmit of audio urb failed (error=-2)
em28xx #0: resubmit of audio urb failed (error=-2)
em28xx #0: resubmit of audio urb failed (error=-2)
em28xx #0: resubmit of audio urb failed (error=-2)
em28xx #0: resubmit of audio urb failed (error=-2)
An underrun very likely occurred. Ignoring it.

--0-1966068896-1208938121=:36100
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--0-1966068896-1208938121=:36100--
