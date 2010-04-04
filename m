Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43201 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab0DDSA7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Apr 2010 14:00:59 -0400
Message-ID: <4BB8D3D6.5010706@infradead.org>
Date: Sun, 04 Apr 2010 15:00:54 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: linux-input@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 04/15] V4L/DVB: ir-core: Add logic to decode IR protocols
 at the IR core
References: <cover.1270142346.git.mchehab@redhat.com>	 <20100401145632.7b1b98d5@pedra>	 <1270251567.3027.55.camel@palomino.walls.org> <4BB69A95.5000705@redhat.com>	 <1270314992.9169.40.camel@palomino.walls.org>  <4BB7C795.20506@redhat.com> <1270384551.4979.47.camel@palomino.walls.org>
In-Reply-To: <1270384551.4979.47.camel@palomino.walls.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy Walls wrote:
> On Sat, 2010-04-03 at 19:56 -0300, Mauro Carvalho Chehab wrote:
>> Andy Walls wrote:
>>> On Fri, 2010-04-02 at 22:32 -0300, Mauro Carvalho Chehab wrote:
>>>> Andy Walls wrote:
>>>  
>>>>> I haven't taken a very hard look at this since I'm very busy this month.
>>>>>
>>>>> It looks OK so far. 
>>>> Thank you for your review. 
>>>>
>>>> One general comment: my main target of writing the NEC decoder is to have one
>>>> decoder for testing. I know that there are several other implementations, so I 
>>>> didn't try to write a perfect decoder, but, instead, I wrote a code that 
>>>> works, and that allows me to continue the Remote Controller subsystem design.
>>> Understood.
>> Btw, I just finish rewriting the nec decoder:
>>
>> http://git.linuxtv.org/mchehab/ir.git?a=blob;f=drivers/media/IR/ir-nec-decoder.c;h=33b260f517f509efd9c55067eb89c8cd748ed12c;hb=09b1808271b3d705b839ee3239fd1c85b7289f41
>>
>> I've got your constants and a few of your ideas, but the code is different:
>> instead of getting a pulse/mark pair, the code handles event by event. Also,
>> it is controlled by a state machine.
>>
>> The end result is that the code seems very reliable. It also handles both NEC
>> and NEC extended.
> 
> Looks good.
> 
> On intervals that are supposed to be longer than 1 NEC_UNIT, the
> tolerance of NEC_UNIT / 2 is a little unforgiving.  However, if this
> decoder is called not knowing apriori that the protocol is NEC, it is
> probably the right thing to do.

Yes. That's why the code is a little rigid. We want to reduce the risk of badly decoded
codes.
> 
> And when you have time:
> 
> I think all that is missing is a glitch (low pass) filter to discard
> pulses much shorter than 1 NEC_UNIT.  A way to generate random IR
> glitches is with bright sunlight reflecting off of a basin of water
> that's surface is being disturbed to make waves.  

I have a better way: just let my IR sensor to be pointed to the fluorescent
lamp I have on my room... It produces _lots_ of glitches.

> LIRC has a software glitch filter implementation in 
> 
> 	lirc-0.8.5/drivers/lirc_serial/lirc_serial.c:frbwrite()
> 
> but it's not the simplest code to understand and it keeps its state in
> static variables in the function.
> 
> (My kernel NEC decoder implementation didn't have a software glitch
> filter, because there was a filter provided by the hardware.  For NEC, I
> decided to discard any pulse less than 5/8 * NEC_UNIT.  For RC-5, I set
> it to discard pulses less than 3/4 of a pulse time.)
> 
> 
> Since a glitch filter is probably going to be needed by a number of
> drivers and since the minimum acceptable pulse depends slightly on the
> protocol, it probably makes sense for
> 
> 1. A driver to indicate if its raw events need glitch filtering
> 
> 2. A common glitch filtering library function that can be used by all
> decoders, and that also can accept a decoder specified minimum
> acceptable pulse width.

Seems a nice improvement. I doubt I'll have time for handling it right now,
since there are still many things to do, but I'll put it on my todo list.
Of course, patches adding it are wellcome ;)

Btw, I added a RC-5 decoder there, at my IR experimental tree:
	http://git.linuxtv.org/mchehab/ir.git

Unfortunately, there's some problem with either my Remote Controller or 
with the saa7134 driver. After 11 bits received, after the 2 start bits, 
it receives a pause (see the enclosed sequence).

I'm starting to suspect that the Hauppauge Grey IR produces a sequence with shorter
bits, but, as the hardware decoders are capable or receiving IR codes, it may
also be a hardware problem.
> 
> 
>>> Is it the case that some drivers will only be able to perform leading
>>> edge detection (measuring time between marks) or trailing edge detection
>>> (measuring time between spaces)?
>> In the specific case of saa7134, the IRQ can be enabled for a positive and/or
>> for a negative edge.
>>
>> I'm not sure about the other IRQ driven hardware. On cx88, there's no IRQ code
>> for IR - maybe it is not supported. I haven't check yet how IRQ's work on bttv.
>> I've no idea about the other devices that support raw IR decoding.
> 
> I can look into what the cx88 and bttv chips can do.  How the boards are
> wired up is a different issue.

Thanks. Unfortunately, the cx88 devices I have here in hand have hardware 
IR decoders, or no IR support. I haven't check yet the bttv devices.

Btw, by playing with one of them I got one that has a broken^Hincomplete
decoding support: It validates the address internally, and returns only the
command, if the address is the expected one.
> 
> 
> 
>>>> I found one NEC IR here that uses the extended protocol. The issue I have here is that
>>>> maybe it could be interesting to allow enable or disable a more pedantic check.
>>>> At least on the room I'm working, I have two strong fluorescent lamps that interfere
>>>> on the IR sensor of the saa7134 board. I'll probably add a sysfs node to allow enable/
>>>> disable the strict check for non-extended protocol.
>>> Would that make the setting global or would it be on a per remote
>>> control basis?
>> The protocol sysfs nodes are per device. Yet, for now, I haven't created
>> such node.
> 
> Per device means per IR receiver device?
> 
>  
>>> I don't know if a driver or end user can set the expectaion of a remote
>>> control's NEC address in your recent design (or if the intent was to not
>>> require it and use discovery).
>> Well, bet to let it as-is. If later needed, it would be easy to add a sysfs
>> node parameter to control it.
> 
> OK.
> 
> Regards,
> Andy
> 


-- 

Cheers,
Mauro
