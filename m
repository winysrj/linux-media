Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:33240 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752010AbZJKI1D (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Oct 2009 04:27:03 -0400
From: Michael G <miga_miga@gmx.de>
To: linux-media@vger.kernel.org
Subject: Re: 2.6.32 dvbdev error / Cinergy XS [0ccd:0043]
Date: Sun, 11 Oct 2009 10:06:46 +0200
References: <200910102219.23667.miga_miga@gmx.de> <829197380910101448w4240eb35g8f51daca2b7c961c@mail.gmail.com>
In-Reply-To: <829197380910101448w4240eb35g8f51daca2b7c961c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910111006.46716.miga_miga@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Samstag, 10. Oktober 2009 23:48:37 schrieb Devin Heitmueller:
> On Sat, Oct 10, 2009 at 4:19 PM, Michael G <miga_miga@gmx.de> wrote:
> > Hi,
> > can someone please help me to get my
> > Cinergy XS (Bus 001 Device 010: ID 0ccd:0043 TerraTec Electronic GmbH)
> > to run in a 2.6.32 RC3 gentoo system?
> >
> > When I use the in-kernel driver I'll get the following output:
> > usb 1-1: new high speed USB device using ehci_hcd and address 10
> > usb 1-1: configuration #1 chosen from 1 choice
> > em28xx: New device TerraTec Electronic GmbH Cinergy T USB XS @ 480 Mbps
> > (0ccd:0043, interface 0, class 0)
> > em28xx #0: chip ID is em2870
> > em28xx #0: i2c eeprom 00: 1a eb 67 95 cd 0c 43 00 c0 12 81 00 6a 24 8e 34
> > em28xx #0: i2c eeprom 10: 00 00 06 57 02 0c 00 00 00 00 00 00 00 00 00 00
> > em28xx #0: i2c eeprom 20: 44 00 00 00 f0 10 01 00 00 00 00 00 5b 00 00 00
> > em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 00 00 ee 2d 46 4a
> > em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 24 03 43 00 69 00
> > em28xx #0: i2c eeprom 70: 6e 00 65 00 72 00 67 00 79 00 20 00 54 00 20 00
> > em28xx #0: i2c eeprom 80: 55 00 53 00 42 00 20 00 58 00 53 00 00 00 34 03
> > em28xx #0: i2c eeprom 90: 54 00 65 00 72 00 72 00 61 00 54 00 65 00 63 00
> > em28xx #0: i2c eeprom a0: 20 00 45 00 6c 00 65 00 63 00 74 00 72 00 6f 00
> > em28xx #0: i2c eeprom b0: 6e 00 69 00 63 00 20 00 47 00 6d 00 62 00 48 00
> > em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x339064dc
> > em28xx #0: EEPROM info:
> > em28xx #0:      No audio on board.
> > em28xx #0:      500mA max power
> > em28xx #0:      Table at 0x06, strings=0x246a, 0x348e, 0x0000
> > em28xx #0: Identified as Terratec Cinergy T XS (card=43)
> > em28xx #0:
> >
> > em28xx #0: The support for this board weren't valid yet.
> > em28xx #0: Please send a report of having this working
> > em28xx #0: not to V4L mailing list (and/or to other addresses)
> >
> > Chip ID is not zero. It is not a TEA5767
> > tuner 0-0060: chip found @ 0xc0 (em28xx #0)
> > xc2028 0-0060: creating new instance
> > xc2028 0-0060: type set to XCeive xc2028/xc3028 tuner
> > usb 1-1: firmware: requesting xc3028-v27.fw
> > xc2028 0-0060: Loading 80 firmware images from xc3028-v27.fw, type:
> > xc2028 firmware, ver 2.7
> > xc2028 0-0060: Loading firmware for type=BASE (1), id 0000000000000000.
> > xc2028 0-0060: Loading firmware for type=(0), id 000000000000b700.
> > SCODE (20000000), id 000000000000b700:
> > xc2028 0-0060: Loading SCODE for type=MONO SCODE HAS_IF_4320 (60008000),
> > id 0000000000008000.
> > xc2028 0-0060: Incorrect readback of firmware version.
> > xc2028 0-0060: Loading firmware for type=BASE (1), id 0000000000000000.
> > xc2028 0-0060: Loading firmware for type=(0), id 000000000000b700.
> > SCODE (20000000), id 000000000000b700:
> > xc2028 0-0060: Loading SCODE for type=MONO SCODE HAS_IF_4320 (60008000),
> > id 0000000000008000.
> > xc2028 0-0060: Incorrect readback of firmware version.
> > em28xx #0: v4l2 driver version 0.1.2
> > em28xx #0: V4L2 video device registered as /dev/video1
> >
> >
> > No /dev/dvb, so no DVT-T. I tried to use the latest v4l-dvb but I can't
> > compile it:
> >
> > /root/v4l-dvb/v4l/dvbdev.c: In function 'init_dvbdev':
> > /root/v4l-dvb/v4l/dvbdev.c:516: error: 'struct class' has no member named
> > 'nodename'
> > make[3]: *** [/root/v4l-dvb/v4l/dvbdev.o] Error 1
> > make[2]: *** [_module_/root/v4l-dvb/v4l] Error 2
> > make[2]: Leaving directory `/usr/src/linux-2.6.32-rc3'
> > make[1]: *** [default] Error 2
> > make[1]: Leaving directory `/root/v4l-dvb/v4l'
> > make: *** [all] Error 2
> >
> > Any help is appreciated!
> >
> > Thanks,
> > Michael
> 
> Hello Michael,
> 
> Don't bother trying to compile the latest v4l-dvb code.  It's not
> supported even in the latest code (and there is presently no work
> going on to add support).
> 
> Devin

Hi Devin,
thanks for the info. I'll keep waiting and hoping :)

Just a quick addition. With 2.6.30 an em28xx-new it runs an the dmesg output 
looks like this:

usb 1-1: new high speed USB device using ehci_hcd and address 14
usb 1-1: configuration #1 chosen from 1 choice
em28xx v4l2 driver version 0.0.1 loaded
em28xx: new video device (0ccd:0043): interface 0, class 255
em28xx: device is attached to a USB 2.0 bus
em28xx #0: Alternate settings: 8
em28xx #0: Alternate setting 0, max size= 0
em28xx #0: Alternate setting 1, max size= 0
em28xx #0: Alternate setting 2, max size= 1448
em28xx #0: Alternate setting 3, max size= 2048
em28xx #0: Alternate setting 4, max size= 2304
em28xx #0: Alternate setting 5, max size= 2580
em28xx #0: Alternate setting 6, max size= 2892
em28xx #0: Alternate setting 7, max size= 3072
em28xx-video.c: New Terratec XS Detected
em28xx #0: Found Terratec Cinergy T XS (MT2060)
usbcore: registered new interface driver em28xx
em2880-dvb.c: DVB Init
MT2060: successfully identified (IF1 = 1220)
DVB: registering new adapter (em2880 DVB-T)
DVB: registering adapter 0 frontend 0 (Zarlink ZL10353 DVB-T)...
Em28xx: Initialized (Em2880 DVB Extension) extension

Cheers,
Michael
