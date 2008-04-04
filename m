Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [195.7.61.12] (helo=killala.koala.ie)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <simon@koala.ie>) id 1JhkR5-0005zG-Ao
	for linux-dvb@linuxtv.org; Fri, 04 Apr 2008 13:50:25 +0200
Received: from [195.7.61.7] (cozumel.koala.ie [195.7.61.7])
	(authenticated bits=0)
	by killala.koala.ie (8.14.0/8.13.7) with ESMTP id m34BoIGv031597
	for <linux-dvb@linuxtv.org>; Fri, 4 Apr 2008 12:50:19 +0100
From: Simon Kenyon <simon@koala.ie>
To: linux-dvb@linuxtv.org
In-Reply-To: <c8b4dbe10803311302n6edc8d0dtb1f816099e020946@mail.gmail.com>
References: <a413d4880803301640u20b77b9cya5a812efec8ee25c@mail.gmail.com>
	<c8b4dbe10803311302n6edc8d0dtb1f816099e020946@mail.gmail.com>
Date: Fri, 04 Apr 2008 11:50:15 +0000
Message-Id: <1207309815.10140.4.camel@localhost>
Mime-Version: 1.0
Subject: Re: [linux-dvb] Lifeview DVB-T from v4l-dvb and Pinnacle Hybrid	USb
	from v4l-dvb-kernel......help
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


On Mon, 2008-03-31 at 21:02 +0100, Aidan Thornton wrote:
> Not trivially, since v4l-dvb-kernel contains changes to the core code
> that the em28xx driver relies on and that are incompatible with
> changes in the main v4l-dvb repository since. You can try
> http://www.makomk.com/hg/v4l-dvb-makomk - it's the em28xx and xc3028
> drivers grafted onto a version of v4l-dvb that's about 5 months old at
> this point - though it's really not a great starting point for porting
> them onto newer versions, since you'd want to drop the xc3028 driver
> in favour of the newer one

thanks for making that work with 2.6.24
works for my terratec cinergy xs device

regards
--
simon
PS output included for the record

usb 1-1: new high speed USB device using ehci_hcd and address 4
usb 1-1: configuration #1 chosen from 1 choice
Linux video capture interface: v2.00
em28xx v4l2 driver version 0.0.1 loaded
em28xx new video device (0ccd:0042): interface 0, class 255
em28xx: device is attached to a USB 2.0 bus
em28xx: you're using the experimental/unstable tree from mcentral.de
em28xx: there's also a stable tree available but which is limited to
em28xx: linux <=2.6.19.2
em28xx: it's fine to use this driver but keep in mind that it will move
em28xx: to http://mcentral.de/hg/~mrec/v4l-dvb-kernel as soon as it's
em28xx: proved to be stable
em28xx #0: Alternate settings: 8
em28xx #0: Alternate setting 0, max size= 0
em28xx #0: Alternate setting 1, max size= 0
em28xx #0: Alternate setting 2, max size= 1448
em28xx #0: Alternate setting 3, max size= 2048
em28xx #0: Alternate setting 4, max size= 2304
em28xx #0: Alternate setting 5, max size= 2580
em28xx #0: Alternate setting 6, max size= 2892
em28xx #0: Alternate setting 7, max size= 3072
Picked tuner type 71
input: em2880/em2870 remote control as /class/input/input6
em28xx-input.c: remote control handler attached
attach_inform: eeprom detected.
em28xx #0: i2c eeprom 00: 1a eb 67 95 cd 0c 42 00 50 12 5c 03 6a 32 9c
34
em28xx #0: i2c eeprom 10: 00 00 06 57 46 07 00 00 00 00 00 00 00 00 00
00
em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 31 00 b8 00 14 00 5b 00 00
00
em28xx #0: i2c eeprom 30: 00 00 20 40 20 6e 02 20 10 01 00 00 00 00 00
00
em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00
em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00
em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 32 03 43 00 69
00
em28xx #0: i2c eeprom 70: 6e 00 65 00 72 00 67 00 79 00 20 00 48 00 79
00
em28xx #0: i2c eeprom 80: 62 00 72 00 69 00 64 00 20 00 54 00 20 00 55
00
em28xx #0: i2c eeprom 90: 53 00 42 00 20 00 58 00 53 00 00 00 34 03 54
00
em28xx #0: i2c eeprom a0: 65 00 72 00 72 00 61 00 54 00 65 00 63 00 20
00
em28xx #0: i2c eeprom b0: 45 00 6c 00 65 00 63 00 74 00 72 00 6f 00 6e
00
em28xx #0: i2c eeprom c0: 69 00 63 00 20 00 47 00 6d 00 62 00 48 00 00
00
em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00
em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00
em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00
EEPROM ID= 0x9567eb1a
Vendor/Product ID= 0ccd:0042
AC97 audio (5 sample rates)
500mA max power
Table at 0x06, strings=0x326a, 0x349c, 0x0000
tuner 4-0061: chip found @ 0xc2 (em28xx #0)
attach inform (default): detected I2C address c2
/opt/v4l-dvb-makomk/v4l/xc3028.c: attach request!
tuner 4-0061: type set to XC3028
/opt/v4l-dvb-makomk/v4l/xc3028.c: attach request!
tuner 4-0061: type set to XC3028
attach_inform: tvp5150 detected.
tvp5150 4-005c: tvp5150am1 detected.
xc3208: DEBUG freq=9076 mode=2 audmode=1 std=0
xc3028 debug: XC3028_GET_MODE returned 0
ANALOG TV REQUEST
Loading base firmware: xc3028_init0.i2c.fw
upload_firmware_new, Loading default analogue TV settings:
xc3028_BG_PAL_A2_A.i                                            2c.fw
xc3028-tuner.c: firmware 2.7
em28xx #0: V4L2 VBI device registered as /dev/vbi0
em28xx #0: V4L2 device registered as /dev/video0
em28xx #0: Found Terratec Hybrid XS
em28xx audio device (0ccd:0042): interface 1, class 1
em28xx audio device (0ccd:0042): interface 2, class 1
usbcore: registered new interface driver em28xx
em2880-dvb.c: DVB Init
em28xx_acquire: acquired, mode = 3
/opt/v4l-dvb-makomk/v4l/xc3028.c: attach request!
DVB: registering new adapter (em2880 DVB-T)
DVB: registering frontend 0 (Zarlink ZL10353 DVB-T)...
em28xx_release: released, mode = 3
Em28xx: Initialized (Em2880 DVB Extension) extension



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
