Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.velocitynet.com.au ([203.17.154.25]:32768 "EHLO
	m0.velocity.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbZEaHqU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 May 2009 03:46:20 -0400
Received: from webmail.velocity.net.au (unknown [203.17.154.9])
	by m0.velocity.net.au (Postfix) with ESMTP id 6153560370
	for <linux-media@vger.kernel.org>; Sun, 31 May 2009 17:46:20 +1000 (EST)
Message-ID: <65460.202.168.20.241.1243755980.squirrel@webmail.velocity.net.au>
Date: Sun, 31 May 2009 17:46:20 +1000 (EST)
Subject: RE: Leadtek Winfast DTV-1000S
From: paul10@planar.id.au
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I've been working through this thread.

I am running 2.6.30-rc6. I've checked out the patch from
ttp://kernellabs.com/hg/~mk/hvr1110, and installed it.  I modified one
file - cx88-cards.c, which doesn't seem to work with my DTV2000H, but
otherwise just using the code per the patch.

I've added "options saa7134 card=156" into a file in /etc/modprobe.d/

So far, so good.  I have made more progress than Brad appears to have, it
is recognising the card, but appears to not be tuning it.  I suspect the
problem is the lack of firmware: dvb-fe-tda10048-1.0.fw

I have three tuner cards in my machine - a DTV2000H and an Avermedia 777,
so my full dmesg log is a bit untidy.  This is exacerbated by the fact
that the Avermedia also uses the saa7134 chipset.  I believe the lines
that relate to the DTV1000S, and that are relevant are these:

<the usual eeprom lines, ending with>
saa7130[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
tveeprom 2-0050: Encountered bad packet header [ff]. Corrupt or not a
Hauppauge eeprom.
saa7130[0]: warning: unknown hauppauge model #0
saa7130[0]: hauppauge eeprom: model=0
Chip ID is not zero. It is not a TEA5767
tuner 2-0060: chip found @ 0xc0 (saa7130[0]
tda8290: no gate control were provided!
tuner 2-0060: Tuner has no way to set tv freq
tuner 2-0060: Tuner has no way to set tv freq
tda10048_firmware_upload: waiting for firmware upload
(dvb-fe-tda10048-1.0.fw)...
saa7134 0000:05:00.0: firmware: requesting dvb-fe-tda10048-1.0.fw
tda10048_firmware_upload: Upload failed. (file not found?)
tuner-simple 3-0061: unable to probe Philips TD1316 Hybrid Tuner,
proceeding anyway.<6>tuner-simple 3-0061: creating new instance
tuner-simple 3-0061: type set to 67 (Philips TD1316 Hybrid Tuner)

I can see the appropriate firmware for the Hauppage, but I'm guessing that
I need special firmware for the WinFast implementation.  So I think I need
to do something to get the right firmware.  Is it a reasonable presumption
that the firmware is the problem here - or is it actually the earlier
messages that are the underlying problem?  Or perhaps both?

I have /dev/adapter1/ created, but it won't tune.  When trying to tune,
dmesg is getting errors along the lines of missing firmware, then seg
fault.  That was leading me to think that firmware is the issue.

Is it useful to try the hauppage firmware, or is that unlikely to work?

Thanks,

Paul



