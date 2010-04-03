Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62834 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058Ab0DCW4b (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 3 Apr 2010 18:56:31 -0400
Message-ID: <4BB7C795.20506@redhat.com>
Date: Sat, 03 Apr 2010 19:56:21 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: linux-input@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 04/15] V4L/DVB: ir-core: Add logic to decode IR protocols
 at the IR core
References: <cover.1270142346.git.mchehab@redhat.com>	 <20100401145632.7b1b98d5@pedra>	 <1270251567.3027.55.camel@palomino.walls.org> <4BB69A95.5000705@redhat.com> <1270314992.9169.40.camel@palomino.walls.org>
In-Reply-To: <1270314992.9169.40.camel@palomino.walls.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy Walls wrote:
> On Fri, 2010-04-02 at 22:32 -0300, Mauro Carvalho Chehab wrote:
>> Andy Walls wrote:
>  
>>> I haven't taken a very hard look at this since I'm very busy this month.
>>>
>>> It looks OK so far. 
>> Thank you for your review. 
>>
>> One general comment: my main target of writing the NEC decoder is to have one
>> decoder for testing. I know that there are several other implementations, so I 
>> didn't try to write a perfect decoder, but, instead, I wrote a code that 
>> works, and that allows me to continue the Remote Controller subsystem design.
> 
> Understood.

Btw, I just finish rewriting the nec decoder:

http://git.linuxtv.org/mchehab/ir.git?a=blob;f=drivers/media/IR/ir-nec-decoder.c;h=33b260f517f509efd9c55067eb89c8cd748ed12c;hb=09b1808271b3d705b839ee3239fd1c85b7289f41

I've got your constants and a few of your ideas, but the code is different:
instead of getting a pulse/mark pair, the code handles event by event. Also,
it is controlled by a state machine.

The end result is that the code seems very reliable. It also handles both NEC
and NEC extended.

(btw, I just noticed that I named the bit0/bit1 symbols wrong - the timings there
are just for space - I'll write a patch fixing it).

>> I've changed on a latter patch my decoder to work with just the duration
>> of the bits.
>>
>> After reviewing the datasheet, now I think I know how to program IRQ to
>> trigger on both edges. So, my idea is to enable it and rewrite the decoder.
> 
> So that brings up and interesting decoder design requirement.
> 
> Is it the case that some drivers will only be able to perform leading
> edge detection (measuring time between marks) or trailing edge detection
> (measuring time between spaces)?

In the specific case of saa7134, the IRQ can be enabled for a positive and/or
for a negative edge.

I'm not sure about the other IRQ driven hardware. On cx88, there's no IRQ code
for IR - maybe it is not supported. I haven't check yet how IRQ's work on bttv.
I've no idea about the other devices that support raw IR decoding.

>> Yes, I know. By max/min, I've meant to handle delta variations around
>> the main time, since the driver may miss the exact moment where it were
>> supposed to collect the timestamp.
> 
> Yes, and the remote's oscillator can be pretty far off for the ideal
> timing too.

I noticed.
 
 
>>> Both of the NEC remotes that I own use the extended protocol, IIRC.
>> I found one NEC IR here that uses the extended protocol. The issue I have here is that
>> maybe it could be interesting to allow enable or disable a more pedantic check.
>> At least on the room I'm working, I have two strong fluorescent lamps that interfere
>> on the IR sensor of the saa7134 board. I'll probably add a sysfs node to allow enable/
>> disable the strict check for non-extended protocol.
> 
> Would that make the setting global or would it be on a per remote
> control basis?

The protocol sysfs nodes are per device. Yet, for now, I haven't created
such node.

> The way I handled extended NEC addressing or stardard NEC addressing was
> implicit given the specified expected remote control address.
> 
> For setting the adress for which to watch I did something like
> 
> 	if ((specified_address & 0xff00) == 0) {
> 		/* Store the 8 bit NEC address in 16 bits as A'A */
> 		ir_input->addr = (specified_address ^ 0xff) << 8 |
> 				  specified_address;
> 	} else {
> 		/* Store a 16 bit Extended NEC address directly */
> 		ir_input->addr = specified_address;
> 	}

Seems ok to me. I've used the same concept on my code.
 
> And then when checking the incoming remote code:
> 
> 	if (ir_input->addr != decoded_addr)
> 		return;
> 
> The requirement for proper bit complement of an 8-bit address was
> encoded in the expected 16-bit address.  So if what it decoded as an
> address didn't match the expected 16 bits, it discarded the code.
> 
> 
> I don't know if a driver or end user can set the expectaion of a remote
> control's NEC address in your recent design (or if the intent was to not
> require it and use discovery).

Well, bet to let it as-is. If later needed, it would be easy to add a sysfs
node parameter to control it.

-- 

Cheers,
Mauro
