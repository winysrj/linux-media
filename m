Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.velocitynet.com.au ([203.17.154.25]:55538 "EHLO
	m0.velocity.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706AbZFGHwV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Jun 2009 03:52:21 -0400
Received: from webmail.velocity.net.au (unknown [203.17.154.9])
	by m0.velocity.net.au (Postfix) with ESMTP id 6BC9260063
	for <linux-media@vger.kernel.org>; Sun,  7 Jun 2009 17:52:21 +1000 (EST)
Message-ID: <64501.202.168.20.241.1244361141.squirrel@webmail.velocity.net.au>
Date: Sun, 7 Jun 2009 17:52:21 +1000 (EST)
Subject: RE: Leadtek Winfast DTV-1000S
From: paul10@planar.id.au
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

OK, I've pulled the card and taken a photo, and then removed the other
cards in my box so as to see the messages for this card only.

It looks to me like it doesn't like the tuner, perhaps because the eeprom
information isn't as expected.  Further, I probably don't have the right
firmware, as I copied the firmware from the Hauppage driver.

Information attached here is:
  1.  Links to everything I've found on the web that is relevant
  2.  Link to the photo of the card.  The chips aren't particularly
readable 3.  List of every number I can read on the various chips (at
least the
larger ones)
  4.  Kernel logs from my boot

I'm hoping Mike or someone else can help me with where to go next.  I
reckon a good start is to get the firmware - I have the windows drivers
but no idea how to get firmware out of them.  I also reckon I need the
eeprom info, but also no idea how I go about setting that up either.

Thanks for any advice anyone can give on how to progress from here.  I see
somewhere I can specify a tuner for the card, but I actually can't work
out what tuner this card has - the TDA10048 doesn't seem to be a tuner,
and I can't see any other chips that are tuners.

Paul



1.  Links:
  Some other guy trying to get this working - prior to TDA10048 support
being included
  http://www.linuxtv.org/pipermail/linux-dvb/2008-April/025586.html

  The driver version I pulled and used from Mike Krufky
  http://kernellabs.com/hg/~mk/hvr1110

  A thread from a local forum in which I discussed this, may be useful
http://forums.whirlpool.net.au/forum-replies-archive.cfm/1212297.html

  Windows drivers
  http://drivers.softpedia.com/get/TV-Tuner-Co/LEADTEK/Leadtek-WinFast-DTV1000S-XP-Driver-20070907-WHQL.shtml

  Instructions for getting firmware for an hvr1200
  steventoth.net/linux/hvr1200

2.  Link to photo of the card
   planar.id.au/img_0050.jpg

3.  All the numbers from the various chips.  Where there are a few spaces
between numbers for a given chip, that generally means it runs over
multiple lines on the chip itself.  I've searched on the web to see what
each of them are, and put that info in where I could find it (after the
:).

   Top left (small black) - TDA 10048HN   Q617YFD   07   2PGD7062 :Channel
receiver
  Top mid-right (mid black) - AT8PS56S    HKECSG752 :Microcontroller Top
mid (small black) - HT24LC02 :Memory device
  Bottom mid (large black)  NXP SAA7130HL  VL3669.1   17   kS607491 :Video
broadcast decoder
  mid-right (silver oval) - 32.1F7M
  Far right (small black) - MT1117    3.30719A :Linear voltage / regulator
Bottom mid-left (small black) - MT1117    3.3.0719A

4.  Kernel logs of the boot
   planar.id.au/dmesg.log

Interesting bits from that log copied in here:
[   10.515224] Linux video capture interface: v2.00
[   10.607398] saa7130/34: v4l2 driver version 0.2.15 loaded
[   10.615508] saa7134 0000:05:00.0: PCI INT A -> GSI 20 (level, low) ->
IRQ 20
[   10.623719] saa7130[0]: found at 0000:05:00.0, rev: 1, irq: 20,
latency: 32, mmio: 0xf9100000
[   10.632179] saa7130[0]: subsystem: 107d:6655, board: Hauppauge
WinTV-HVR1110r3 DVB-T/Hybrid [card=156,insmod option]
[   10.640920] saa7130[0]: board init: gpio is 22000
[   10.672049] IRQ 20/saa7130[0]: IRQF_DISABLED is not guaranteed on
shared IRQs
[   10.718381] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) ->
IRQ 22
[   10.727458] HDA Intel 0000:00:1b.0: setting latency timer to 64 [  
10.832019] saa7130[0]: i2c eeprom 00: 7d 10 55 66 54 20 1c 00 43 43 a9 1c
55 d2 b2 92
[   10.832026] saa7130[0]: i2c eeprom 10: 00 ff 82 0e ff 20 ff ff ff ff ff
ff ff ff ff ff
[   10.832031] saa7130[0]: i2c eeprom 20: 01 40 01 01 01 ff 01 03 08 ff 00
8a ff ff ff ff
[   10.832037] saa7130[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[   10.832042] saa7130[0]: i2c eeprom 40: ff 35 00 c0 00 10 03 02 ff 04 ff
ff ff ff ff ff
[   10.832048] saa7130[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[   10.832053] saa7130[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[   10.832059] saa7130[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[   10.832064] saa7130[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[   10.832070] saa7130[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[   10.832075] saa7130[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[   10.832081] saa7130[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[   10.832087] saa7130[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[   10.832092] saa7130[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[   10.832098] saa7130[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[   10.832103] saa7130[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[   10.832110] tveeprom 1-0050: Encountered bad packet header [ff].
Corrupt or not a Hauppauge eeprom.
[   10.832112] saa7130[0]: warning: unknown hauppauge model #0
[   10.832114] saa7130[0]: hauppauge eeprom: model=0
[   10.876030] Chip ID is not zero. It is not a TEA5767
[   10.876076] tuner 1-0060: chip found @ 0xc0 (saa7130[0])
[   10.940029] tda8290: no gate control were provided!
[   10.940080] tuner 1-0060: Tuner has no way to set tv freq
[   10.940086] tuner 1-0060: Tuner has no way to set tv freq
[   10.940138] saa7130[0]: registered device video0 [v4l2]
[   10.940156] saa7130[0]: registered device vbi0
[   10.940176] saa7130[0]: registered device radio0
[   11.141895] dvb_init() allocating 1 frontend
[   11.311046] tda18271 1-0060: creating new instance
[   11.328032] TDA18271HD/C1 detected @ 1-0060
[   11.752019] DVB: registering new adapter (saa7130[0])
[   11.759684] DVB: registering adapter 0 frontend 0 (NXP TDA10048HN
DVB-T)...
[   11.939570] Adding 3903784k swap on /dev/sde2.  Priority:-1 extents:1
across:3903784k
[   11.959709] Adding 3903784k swap on /dev/sdd2.  Priority:-2 extents:1
across:3903784k
[   12.100022] tda10048_firmware_upload: waiting for firmware upload
(dvb-fe-tda10048-1.0.fw)...
[   12.108284] saa7134 0000:05:00.0: firmware: requesting
dvb-fe-tda10048-1.0.fw
[   12.166215] tda10048_firmware_upload: firmware read 24878 bytes. [  
12.174376] tda10048_firmware_upload: firmware uploading
[   16.260025] tda10048_firmware_upload: firmware uploaded




