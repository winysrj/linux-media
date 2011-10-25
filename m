Return-path: <linux-media-owner@vger.kernel.org>
Received: from qmta03.westchester.pa.mail.comcast.net ([76.96.62.32]:54221
	"EHLO qmta03.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752069Ab1JYWdJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Oct 2011 18:33:09 -0400
Message-ID: <4EA737C7.8090908@comcast.net>
Date: Tue, 25 Oct 2011 18:27:19 -0400
From: Peter Bennett <pgbennett@comcast.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: KWorld UB435-Q New Model
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I purchased a new KWorld UB435-Q USB ATSC Stick from newegg. It is not
working. My experience suggests that it is using different chips from
the version supported by Linux Media.

I downloaded my kernel source and checked it against the latest version
in git. All the latest code for this device is in my system, including
changes made by Jarod Wilson to support it.

According to comments in the code
([media_tree.git]/drivers/media/video/em28xx/em28xx-cards.c), the KWorld
UB435-Q is the same as Empia EM2870, NXP TDA18271HD and LG DT3304, and
the KWorld PlusTV 340U, and should have vendor id 0x1b80, 0xa340 and
maps to EM2870_BOARD_KWORLD_A340.

My unit has vendor id 0x1b80, 0xe346 and that is currently not mapped to
any USB device. I recompiled drivers/media/video/em28xx/em28xx-cards.c
to map that vendor id to EM2870_BOARD_KWORLD_A340.

After installing the updated driver I received the following in dmesg:
em28xx video device (1b80:e346): interface 0, class 255 found.
em28xx This is an anciliary interface not used by the driver
usbcore: registered new interface driver em28xx
em28xx driver loaded

No device was registered.

I then installed the KWorld UB435-Q under MS Windows 7 and it worked
perfectly. The windows drivers have loaded some new rom into the device,
so that now I get a different response from Linux. A little more
hopeful, but still does not create the dvb device. It is in fact
creating a video0 device which is not useful as there is no analog
output from the USB stick.
em28xx: New device USB 2875 Device @ 480 Mbps (1b80:e346, interface 0,
class 0)
em28xx #0: chip ID is em2874
em28xx #0: Identified as KWorld PlusTV 340U or UB435-Q (ATSC) (card=76)
em28xx #0: v4l2 driver version 0.1.2
em28xx #0: V4L2 video device registered as video0
usbcore: registered new interface driver em28xx
em28xx driver loaded
lgdt3305_read_reg: error (addr 0e reg 0001 error (ret == -19)
lgdt3305_attach: error -19 on line 1144
lgdt3305_attach: unable to detect LGDT3304 hardware
em28xx #0: /2: frontend initialization failed
Em28xx: Initialized (Em28xx dvb Extension) extension

There is a file in the widows system directory called merlinFW.rom. I
suspect that this has been loaded into the memory stick and modified it.

Any ideas what I can do to support this? It would be nice to have this
tuner supported, it is good value.

Opening the USB stick I find a chip marked LGDT3305. The board is marked
HU435Q and also has a TD18271 chip. It seems to be the same as the old
UB435-Q except now has LGDT3305 instead of LGDT3304. The module
(drivers/media/dvb/frontends/lgdt3305.c) is expecting an LGDT3304 as can
be seen from the error message (lgdt3305_attach: unable to detect
LGDT3304 hardware). looking at drivers/media/video/em28xx/em28xx-dvb.c I
see that the chip type is never set to LGDT3305, only to LGDT3304 or
LGDT3303. I will try creating a new entry for this device that sets it
to LGDT3305, although if LGDT3305 is never used there is a good chance
that it does not work.

I am new to these device drivers but if anybody can point me in the
right direction I would like to get it working, then I can contribute
the code to the Linux Media effort.

