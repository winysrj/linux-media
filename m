Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp123.rog.mail.re2.yahoo.com ([206.190.53.28]:29484 "HELO
	smtp123.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755974AbZARVUf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Jan 2009 16:20:35 -0500
Message-ID: <49739D1E.5050800@rogers.com>
Date: Sun, 18 Jan 2009 16:20:30 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Michael Krufky <mkrufky@linuxtv.org>,
	hermann pitton <hermann-pitton@arcor.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Josh Borke <joshborke@gmail.com>,
	David Lonie <loniedavid@gmail.com>, linux-media@vger.kernel.org
Subject: Re: KWorld ATSC 115 all static
References: <7994.62.70.2.252.1232028088.squirrel@webmail.xs4all.nl> <200901171720.03890.hverkuil@xs4all.nl> <49737088.7060800@rogers.com> <200901182011.11960.hverkuil@xs4all.nl>
In-Reply-To: <200901182011.11960.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> On Sunday 18 January 2009 19:10:16 CityK wrote:
>   
>> merging Hans' code eliminates the usability of Mike's "hack/workaround" ... in essence, analog TV
>> function has now been completely killed with these boards.
>>     
>
> I've made a new tree http://linuxtv.org/hg/~hverkuil/v4l-dvb-kworld/ 
> that calls 'enables the tuner' before loading the module. See if that 
> works.
>
> ...
>   
> I suspect that this might fix the bug.

Hans,

Between the time of my last message and now, your title has made a turn
for the better.  I proclaim that you are no longer "Hans-the-Destroyer",
rather you should be upheld as "Hans-the-Enabler" !!

In other words, it works !!  (across reboots etc etc).

The output of dmesg is interesting (two times tuner simple initiating):

> saa7130/34: v4l2 driver version 0.2.14 loaded
> ACPI: PCI Interrupt 0000:00:09.0[A] -> GSI 19 (level, low) -> IRQ 19
> saa7133[0]: found at 0000:00:09.0, rev: 240, irq: 19, latency: 32,
> mmio: 0xfa021000
> saa7133[0]: subsystem: 17de:7350, board: Kworld ATSC110/115
> [card=90,autodetected]
> saa7133[0]: board init: gpio is 100
> saa7133[0]: i2c eeprom 00: de 17 50 73 ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> tuner 1-0061: chip found @ 0xc2 (saa7133[0])
> tuner-simple 1-0061: creating new instance
> tuner-simple 1-0061: type set to 68 (Philips TUV1236D ATSC/NTSC dual in)
> saa7133[0]: registered device video0 [v4l2]
> saa7133[0]: registered device vbi0
> ACPI: PCI Interrupt Link [ALKC] enabled at IRQ 22
> ACPI: PCI Interrupt 0000:00:11.5[C] -> Link [ALKC] -> GSI 22 (level,
> low) -> IRQ 22
> PCI: Setting latency timer of device 0000:00:11.5 to 64
> dvb_init() allocating 1 frontend
> nxt200x: NXT2004 Detected
> tuner-simple 1-0061: attaching existing instance
> tuner-simple 1-0061: type set to 68 (Philips TUV1236D ATSC/NTSC dual in)
> DVB: registering new adapter (saa7133[0])
> DVB: registering adapter 0 frontend 0 (Nextwave NXT200X VSB/QAM
> frontend)...
> nxt2004: Waiting for firmware upload (dvb-fe-nxt2004.fw)...
> nxt2004: Waiting for firmware upload(2)...
> nxt2004: Firmware upload complete

Would you like to see the results of after enabling 12c_scan to see what
is going on, or is this the behaviour you expected?


Some Other Miscellanea:
1) Before this gets merged, can I ask you to also make one small change
to tuner-simple; specifically, swap the contents of lines 301 and 304.  
This will change the driver's default behaviour in regards to the
selection of which RF input to use for digital cable and digital
over-the-air.  Currently, the driver is set to use digital OTA on the
top RF input and digital cable on the lower RF input spigot.  However,
IMO, a more logical/convenient configuration is to have the digital
cable input be handled by the top RF input spigot, as this is the same
one that the analog cable is also drawn from by default. Mike had made
this change, on my request, previously, but it appears that it got
reverted after the tuner re-factoring. 

Note:  users have reported different default configurations in the past
(e.g. http://www.mythtv.org/wiki/Kworld_ATSC_110), but I actually doubt
that there has been any manufacturing difference with the TUV1236D. 
Rather, I suspect that the user experiences being reported are just
reflecting a combination of the different states of how our driver
behaved in the past and differences in driver version that they may have
been using (i.e. that version provided by/within their distro or by our
Hg).  After all, this configuration setting has gone from being handled
by saa7134-dvb.c to dvb-pll.c to tuner-simple.c, with changes in the
behaviour implemented along the way.

2) This is likely related to the discussion about the gate -- after
closing the analog TV app, the audio from the last channel being viewed
can still be heard if one turns up the volume on their system.  This
leakage has always been present.  But given that we are addressing this
issue now, it strikes me that the gate is being kept open on the audio
line after application closing/release occurs.

3) there is an issue about having two of these cards in the same system
--- IIRC, only one card will get /dev/video .... Mauro touched upon this
very briefly in one of the earlier messages; recall:

Mauro wrote:
> This generated lots of issues in the past, like machines with two boards
> doesn't work anymore. With two boards, and a tuner module, the first board
> probes tuner after opening the demod gateway. However, the second board will
> try to probe tuner before opening the i2c gateway. So, tuner is not found.

Now, I can't test for this myself, but I do know of several users on
AVSforums who have two such cards and can test if that issue is now
resolved .... do you suspect that the changes you have implemented to
date will have eliminated this bug too?

Cheers, and many much appreciation.
