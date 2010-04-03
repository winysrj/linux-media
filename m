Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:58222 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752094Ab0DCRQU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 3 Apr 2010 13:16:20 -0400
Subject: Re: [PATCH 04/15] V4L/DVB: ir-core: Add logic to decode IR
 protocols at the IR core
From: Andy Walls <awalls@md.metrocast.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-input@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <4BB69A95.5000705@redhat.com>
References: <cover.1270142346.git.mchehab@redhat.com>
	 <20100401145632.7b1b98d5@pedra>
	 <1270251567.3027.55.camel@palomino.walls.org> <4BB69A95.5000705@redhat.com>
Content-Type: text/plain
Date: Sat, 03 Apr 2010 13:16:32 -0400
Message-Id: <1270314992.9169.40.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2010-04-02 at 22:32 -0300, Mauro Carvalho Chehab wrote:
> Andy Walls wrote:
 
> > I haven't taken a very hard look at this since I'm very busy this month.
> > 
> > It looks OK so far. 
> 
> Thank you for your review. 
> 
> One general comment: my main target of writing the NEC decoder is to have one
> decoder for testing. I know that there are several other implementations, so I 
> didn't try to write a perfect decoder, but, instead, I wrote a code that 
> works, and that allows me to continue the Remote Controller subsystem design.

Understood.


> >> +/* Start time: 4.5 ms  */
> >> +#define MIN_START_TIME	3900000
> >> +#define MAX_START_TIME	5100000
> > 
> > Hmmm.
> > 
> > An NEC header pulse is nominally        16 * 560 us = 8.96 ms
> > An NEC header space is nominally         8 * 560 us = 4.48 ms
> > An NEC repeat header space is nominally  4 * 560 us = 2.24 ms
> > 
> > I think you need a more explicit name than {MIN,MAX}_START_TIME.
> 
> Part of the problem with this decoder is that it was conceived to work with
> the saa7134 driver. The driver is currently programmed to trigger IRQ on just
> one of the edge (positive or negative, I need to double check). Due to that,
> this time is just half of the time it should be.

Hmm.  It is the right time duration for the space in a normal,
non-repeat, header.  


> I've changed on a latter patch my decoder to work with just the duration
> of the bits.
> 
> After reviewing the datasheet, now I think I know how to program IRQ to
> trigger on both edges. So, my idea is to enable it and rewrite the decoder.

So that brings up and interesting decoder design requirement.

Is it the case that some drivers will only be able to perform leading
edge detection (measuring time between marks) or trailing edge detection
(measuring time between spaces)?




> >> +/* Pulse time: 560 us  */
> >> +#define MIN_PULSE_TIME	460000
> >> +#define MAX_PULSE_TIME	660000
> >> +
> >> +/* Bit 1 space time: 2.25ms-560 us */
> >> +#define MIN_BIT1_TIME	1490000
> >> +#define MAX_BIT1_TIME	1890000
> >> +
> >> +/* Bit 0 space time: 1.12ms-560 us */
> >> +#define MIN_BIT0_TIME	360000
> >> +#define MAX_BIT0_TIME	760000
> >> +
> > 
> > The fundamental unit of time in the NEC protocol is ideally:
> > 
> > 	4192/197 cycles / 38 kHz = 559978.6 ns ~= 560 ns
> > 
> > All other time durations in the NEC protocol are multiples of this unit.
> 
> Yes, I know. By max/min, I've meant to handle delta variations around
> the main time, since the driver may miss the exact moment where it were
> supposed to collect the timestamp.

Yes, and the remote's oscillator can be pretty far off for the ideal
timing too.


> > Both of the NEC remotes that I own use the extended protocol, IIRC.
> 
> I found one NEC IR here that uses the extended protocol. The issue I have here is that
> maybe it could be interesting to allow enable or disable a more pedantic check.
> At least on the room I'm working, I have two strong fluorescent lamps that interfere
> on the IR sensor of the saa7134 board. I'll probably add a sysfs node to allow enable/
> disable the strict check for non-extended protocol.

Would that make the setting global or would it be on a per remote
control basis?


The way I handled extended NEC addressing or stardard NEC addressing was
implicit given the specified expected remote control address.

For setting the adress for which to watch I did something like

	if ((specified_address & 0xff00) == 0) {
		/* Store the 8 bit NEC address in 16 bits as A'A */
		ir_input->addr = (specified_address ^ 0xff) << 8 |
				  specified_address;
	} else {
		/* Store a 16 bit Extended NEC address directly */
		ir_input->addr = specified_address;
	}


And then when checking the incoming remote code:

	if (ir_input->addr != decoded_addr)
		return;

The requirement for proper bit complement of an 8-bit address was
encoded in the expected 16-bit address.  So if what it decoded as an
address didn't match the expected 16 bits, it discarded the code.


I don't know if a driver or end user can set the expectaion of a remote
control's NEC address in your recent design (or if the intent was to not
require it and use discovery).


Regards,
Andy

