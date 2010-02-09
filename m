Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:45740 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753933Ab0BINGd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Feb 2010 08:06:33 -0500
Subject: Re: Leadtek WinFast DVR3100 H zl10353_read_register: readreg error
 (reg=127, ret==-6)
From: Andy Walls <awalls@radix.net>
To: Patrick Cairns <patrick_cairns@yahoo.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <846727.96589.qm@web33506.mail.mud.yahoo.com>
References: <846727.96589.qm@web33506.mail.mud.yahoo.com>
Content-Type: text/plain
Date: Tue, 09 Feb 2010 08:05:25 -0500
Message-Id: <1265720725.3072.21.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Patrick,

On Tue, 2010-02-09 at 03:35 -0800, Patrick Cairns wrote:
> Hello
> 
> I'm testing use of multiple Leadtek WinFast DVR3100 H cards for a
> project.   I've had large numbers of them working well in the same
> machine as encoders (haven't been using the DVB-T capabilities).
> 
> However if I use more than a few of these cards in the same machine
> then upon startup there are always one or two cards where Zarlink
> zl10353 reading errors are reported preventing their use:-
> 
> options: enc_yuv_buffers=0 enc_pcm_buffers=0 enc_vbi_buffers=0 radio=0 enc_idx_buffers=0 enc_mpg_bufsize=64
>
> cx18-10: Initializing card 10
> cx18-10: Autodetected Leadtek WinFast DVR3100 H card
> cx18 0000:05:09.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
> cx18-10: Unreasonably low latency timer, setting to 64 (was 32)
> cx18-10: cx23418 revision 01010000 (B)
> cx18-10: Simultaneous DVB-T and Analog capture supported,
>         except when capturing Analog from the antenna input.
> IRQ 18/cx18-10: IRQF_DISABLED is not guaranteed on shared IRQs
> cx18-10: Disabled encoder YUV device
> cx18-10: Disabled encoder VBI device
> cx18-10: Disabled encoder PCM audio device
> cx18-10: Disabled encoder IDX device
> cx18-10: Registered device video10 for encoder MPEG (32 x 64 kB)
> DVB: registering new adapter (cx18)
> zl10353_read_register: readreg error (reg=127, ret==-6)

Register 127 is the CHIP_ID register of the Zarlink ZL10353, it is the
first register the zl10353 driver tries to read.  It is returning with
an error obviously.

> cx18-10: frontend initialization failed
> cx18-10: DVB failed to register
> cx18-10: Registered device radio10 for encoder radio

Hmmm. I have to look into why the radio=0 option isn't honored.

> cx18-10: Error -1 registering devices
> cx18-10: Error -1 on initialization
> cx18: probe of 0000:05:09.0 failed with error -1
> 
> Looking/flailing around for more diagnostic information and related
> posts I tried a few things and found that if I enabled the bit_test in
> i2c-algo-bit, the second test failed with the offending cards whereas
> it normally succeeds.   I'm not certain this is relevant but it might
> indicate an underlying fault in card<->driver communication:-
> 
> cx18-10: Initializing card 10
> cx18-10: Autodetected Leadtek WinFast DVR3100 H card
> cx18-10: cx23418 revision 01010000 (B)
> cx18-10:  i2c: i2c init
> cx18 i2c driver #10-0: Test OK
> cx18 i2c driver #10-1: bus seems to be busy
> cx18-10: Could not initialize i2c
> cx18-10: Error -19 on initialization

This was an excellent test to perform.  IIRC, only the ZL10353 and
XC3028 are on the second I2C bus (#10-1 in this case), which likely
means one of those two chips is hung.

In the cx18 driver, I have a way of explicitly resetting the XC3028, and
the driver does reset it.  So either the XC3028 may not be all the way
out of reset yet or the ZL10353 is hung.


> Can anyone advise how to debug this further or know any fixes to try?
> I'm not quite sure what's going on under the hood.


In cx18-gpio.c:resetctrl_reset(), find

       case CX18_GPIO_RESET_XC2028:
                if (cx->card->tuners[0].tuner == TUNER_XC2028)
                        gpio_reset_seq(cx, (1 << cx->card->xceive_pin), 0,
                                       1, 1);

and change the "1, 1);" from 1 msec assert and recovery delays to
something like 30 msec for each.  Most likely the recovery delay (the
second one) will be the one that matters.  We want to make sure the
XC3028 is out of reset before talking on the I2C bus to the ZL10353.


I'll have to look at what can be done to reset the ZL10353. I don't know
if the board has a separate hardware line to the ZL10353, so this may
not be possible.


(I should really also implement hardware master I2C in the cx18 driver
instead of bit-banging I2C, but I suspect it would be unlikely to have
an effect on this particular problem.)

> More information:-
> 
> Tested against Kernel 2.6.32 (our own custom config including
> increased max dvb adapter count) with or without latest v4l staging
> development repository overlayed (the above dmesg output is from the
> default 2.6.32 v4l).
> 
> The problem almost always persists across soft reboots affecting the
> same one or two cards each time.   A full power cycle however often
> results in different cards being affected.   Reordering cards, varying
> bus positions/locations (there are 3 buses on my main test system) has
> no apparent effect on the problem.   So there is apparent randomness.
> Problem has occurred with as few as 4 cards (not sure about 2/3 yet).
> Sometimes, after a power cycle, no cards are affected, but within a
> few soft cycles, one or 2 cards become afflicted and the problem
> remains until power cycled.
  ^^^^^^^^^^^^^^^^^^^^^^^^^^

Sounds like the ZL10353 getting hung.

So do you need the DVB side at all, or would you be OK with a patch to
have the card working with only analog baseband (the tuner is on the
problem I2C bus), if DVB initialization fails?

> I'm now testing a couple of alternative systems to see if the same
> behaviour occurs there but thought it best at this stage to post for
> suggestions.
> 
> Regards
> 
> Patrick Cairns

Regards,
Andy

