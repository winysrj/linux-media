Return-path: <mchehab@gaivota>
Received: from mailout-de.gmx.net ([213.165.64.22]:57824 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752864Ab1AFSeF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 6 Jan 2011 13:34:05 -0500
Subject: KWorld 355 U DVB-T support
From: Florian Brandes <florian.brandes@gmx.de>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 Jan 2011 19:34:01 +0100
Message-ID: <1294338841.3264.10.camel@ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hello, 

I've been trying to get my USB-DVB-T stick to work and I've been
searching quite a bit, but now I think I need a little bit help.

I've bought a XTension XD 380 stick in Germany through Amazon, but the
USB-ID differs from the one in the wiki. The page shows "1ae7:0381" as a
USB-ID, but my sticks offers "1ae7:0380". This doesn't sound like to
much a difference, but it appears that my stick has an Empia 2870 USB
chip built in. 

After some trial and error I got the "em28xx-new" driver working for my
Ubuntu installation, although I couldn't compile the driver myself. (I
guess the driver is too far outdated, as it complains about certain i2c
errors). The precompiled driver worked for me. dmesg should the
following:

usb 1-1: new high speed USB device using ehci_hcd and address 3
usb 1-1: configuration #1 chosen from 1 choice
Linux video capture interface: v2.00
em28xx v4l2 driver version 0.0.1 loaded
em28xx: new video device (1ae7:0380): interface 0, class 255
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
em28xx #0: Found Empia QT1010 - ZL10353
usbcore: registered new interface driver em28xx
em2880-dvb.c: DVB Init
Quantek QT1010 successfully identified.
DVB: registering new adapter (em2880 DVB-T)
DVB: registering adapter 0 frontend 0 (Zarlink ZL10353 DVB-T)...
Em28xx: Initialized (Em2880 DVB Extension) extension

The driver source offers me "EM2870_BOARD_KWORLD_355U" as the
corresponding board. It appears to me that the combination of Zarlink
ZL10353 frontend and Qantek QT1010 seems to be working, since I can
watch TV in quite a good quality through me-tv.

Now the knack:

The precompiled "em28xx-new" driver module is not available for the
kernel I'd like to use. 

Therefore I turned to v4l and looked for the KWorld 355U DVB-T stick.

I found it in "em28xx-cards.c" and added the unique USB-ID to it.

After compiling and installing, the driver recognizes my stick:
dmesg:

usb 1-1: new high speed USB device using ehci_hcd and address 6
usb 1-1: configuration #1 chosen from 1 choice
em28xx: New device USB 2870 Device @ 480 Mbps (1ae7:0380, interface 0,
class 0)
em28xx #0: chip ID is em2870
(eeprom image)
em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0xb7dcaae2
em28xx #0: EEPROM info:
em28xx #0: No audio on board.
em28xx #0: 500mA max power
em28xx #0: Table at 0x04, strings=0x226a, 0x0000, 0x0000
em28xx #0: Identified as Kworld 355 U DVB-T (card=42)
em28xx #0: 
em28xx #0: The support for this board weren't valid yet.
em28xx #0: Please send a report of having this working
em28xx #0: not to V4L mailing list (and/or to other addresses)
em28xx #0: v4l2 driver version 0.1.2
em28xx #0: V4L2 video device registered as video0

But I don't know how to add the tuner support.

I changed my em28xx-dvb.c file and added the following case (this is the
bachporting tree!):

case EM2870_BOARD_KWORLD_355U:
	dvb->frontend = dvb_attach(zl10353_attach,
	   &em28xx_zl10353_with_xc3028,
  	 &dev->i2c_adap);

	if (dvb->frontend != NULL)
		dvb_attach(qt1010_attach, dvb->frontend,
		&dev->i2c_adap, &em2870_qt1010_config);


break;

as I've seen this at the gl861.c file, which uses Zarlink and Qantek for
the same device. 
But how can I add support in the "em28xx-cards.c" file? The section
concerning the device is (which I already changed):

[EM2870_BOARD_KWORLD_355U] = {
		.name         = "Kworld 355 U DVB-T",
		.valid        = EM28XX_BOARD_NOT_VALIDATED,
		.has_dvb      = 1,
		.tuner_type   = (what to enter here?!),
/*		.dvb_gpio     = em2870_kworld_355u_digital,
		.dvb_gpio     = default_digital,*/

	},

If someone could point me to the right direction, I'd very much
appreciate it. 

Thanks in advance,

Florian Brandes

