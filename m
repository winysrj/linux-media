Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46369 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864Ab0DESdq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Apr 2010 14:33:46 -0400
Message-ID: <4BBA2D05.2080505@infradead.org>
Date: Mon, 05 Apr 2010 15:33:41 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: linux-input@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 04/15] V4L/DVB: ir-core: Add logic to decode IR protocols
 at the IR core
References: <cover.1270142346.git.mchehab@redhat.com>	 <20100401145632.7b1b98d5@pedra>	 <1270251567.3027.55.camel@palomino.walls.org> <4BB69A95.5000705@redhat.com>	 <1270314992.9169.40.camel@palomino.walls.org>  <4BB7C795.20506@redhat.com>	 <1270384551.4979.47.camel@palomino.walls.org>	 <4BB8D3D6.5010706@infradead.org> <1270431911.3506.25.camel@palomino.walls.org>
In-Reply-To: <1270431911.3506.25.camel@palomino.walls.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy Walls wrote:
>>> 2. A common glitch filtering library function that can be used by all
>>> decoders, and that also can accept a decoder specified minimum
>>> acceptable pulse width.
>> Seems a nice improvement. I doubt I'll have time for handling it right now,
>> since there are still many things to do, but I'll put it on my todo list.
>> Of course, patches adding it are wellcome ;)
> 
> :)
> 
> OK.  When I find time I'll hack something up as a prototype.

Thanks!
 
>> Btw, I added a RC-5 decoder there, at my IR experimental tree:
>> 	http://git.linuxtv.org/mchehab/ir.git
> 
> I'll try to review it some time this week.  Streaming state machine
> decoders do seem to be best way to go with these decoders.
> 
> I have an RC-5 decoder in cx23885-input.c that isn't as clean as the NEC
> protocol decoder I developed.  The cx23885-input.c RC-5 decoder is not a
> very explicit state machine however (it is a bit hack-ish).

The state machine seems to be working fine with the code, but I think I
found the issue: it was expecting 14 bits after the start+toggle bits, instead
of a total of 14 bits. I'll fix it. I'll probably end by simplifying it to have
only 3 states: inactive, mark-space and trailer.

>> Unfortunately, there's some problem with either my Remote Controller or 
>> with the saa7134 driver. After 11 bits received, after the 2 start bits, 
>> it receives a pause (see the enclosed sequence).
> 
> -ENOATTACHMENT

Sorry! It is basically the same output as yours. See enclosed. 

>> I'm starting to suspect that the Hauppauge Grey IR produces a sequence with shorter
>> bits, but, as the hardware decoders are capable or receiving IR codes, it may
>> also be a hardware problem.
> 
> The fundamental unit in RC-5 is 32 cycles / 36 kHz = 888889 ns ~= 889 us.
> 
> I turned on the cx23888-ir.c debugging on the HVR-1850 and using a
> Hauppague grey remote (address 0x1e IIRC) and got this as just one
> example:
> 
> cx23885[1]/888-ir: rx read:     802037 ns  mark
> cx23885[1]/888-ir: rx read:     852704 ns  space
> cx23885[1]/888-ir: rx read:     775370 ns  mark
> cx23885[1]/888-ir: rx read:     852407 ns  space
> cx23885[1]/888-ir: rx read:     802037 ns  mark
> cx23885[1]/888-ir: rx read:     852852 ns  space
> cx23885[1]/888-ir: rx read:     775667 ns  mark
> cx23885[1]/888-ir: rx read:     852407 ns  space
> cx23885[1]/888-ir: rx read:     801741 ns  mark
> cx23885[1]/888-ir: rx read:     852852 ns  space
> cx23885[1]/888-ir: rx read:     775667 ns  mark
> cx23885[1]/888-ir: rx read:     852407 ns  space
> cx23885[1]/888-ir: rx read:    1602926 ns  mark
> cx23885[1]/888-ir: rx read:     852407 ns  space
> cx23885[1]/888-ir: rx read:     801741 ns  mark
> cx23885[1]/888-ir: rx read:     852852 ns  space
> cx23885[1]/888-ir: rx read:     775074 ns  mark
> cx23885[1]/888-ir: rx read:     853148 ns  space
> cx23885[1]/888-ir: rx read:     801593 ns  mark
> cx23885[1]/888-ir: rx read:     852704 ns  space
> cx23885[1]/888-ir: rx read:     775667 ns  mark
> cx23885[1]/888-ir: rx read:     852556 ns  space
> cx23885[1]/888-ir: rx read:     801741 ns  mark
> cx23885[1]/888-ir: rx read:     852259 ns  space
> cx23885[1]/888-ir: rx read:     775963 ns  mark
> cx23885[1]/888-ir: rx read: end of rx
> 
> That should be a press of '0' on the remote.
> 
> 'end of rx' means the hardware measured a really long space.
> 
> I also had the hardware low pass filter on.   I think that would effect
> the space measurements by making them shorter, if IR noise caused a
> glitch. 
> 
> Note that many of the marks are a bit shorter than the ideal 889 us.  In
> fact the single marks from the grey remote seem to alternate between 775
> us and 802 us.

The same happened here. The carrier doesn't seem to be precisely 36 kHz.
The code on saa7134 has a way to adjust the time, plus a logic a timer
to adjust the end of a RC5 code reception. It seems a good idea to allow
adjusting those timers via sysfs.

> I have attached a larger capture of (attempted) single presses of the
> digits '0' through '9' and then an intentionally held down press of '7'.
> 
> With a quick glance, I don't see pauses from the grey remote.

Thanks for your dumps! It is not clear that the saa7134 is doing the right
thing, and that the IR uses less bits than the standard.
> 
> Regards,
> Andy
> 

-- 

Cheers,
Mauro

The ir-raw-event output for digit '0' is:

[ 2803.106396] ir_raw_event_handle: event type 6, time before event: 0000000us
[ 2803.106404] ir_raw_event_handle: event type 1, time before event: 0000919us
[ 2803.106409] ir_raw_event_handle: event type 2, time before event: 0000868us
[ 2803.106412] ir_raw_event_handle: event type 1, time before event: 0000893us
[ 2803.106415] ir_raw_event_handle: event type 2, time before event: 0000869us
[ 2803.106418] ir_raw_event_handle: event type 1, time before event: 0000921us
[ 2803.106424] ir_raw_event_handle: event type 2, time before event: 0000869us
[ 2803.106427] ir_raw_event_handle: event type 1, time before event: 0000893us
[ 2803.106433] ir_raw_event_handle: event type 2, time before event: 0000869us
[ 2803.106436] ir_raw_event_handle: event type 1, time before event: 0000922us
[ 2803.106442] ir_raw_event_handle: event type 2, time before event: 0000868us
[ 2803.106444] ir_raw_event_handle: event type 1, time before event: 0000893us
[ 2803.106451] ir_raw_event_handle: event type 2, time before event: 0000869us
[ 2803.106453] ir_raw_event_handle: event type 1, time before event: 0001788us
[ 2803.106460] ir_raw_event_handle: event type 2, time before event: 0000869us
[ 2803.106462] ir_raw_event_handle: event type 1, time before event: 0000921us
[ 2803.106469] ir_raw_event_handle: event type 2, time before event: 0000868us
[ 2803.106471] ir_raw_event_handle: event type 1, time before event: 0000893us
[ 2803.106478] ir_raw_event_handle: event type 2, time before event: 0000869us
[ 2803.106480] ir_raw_event_handle: event type 1, time before event: 0000921us
[ 2803.106486] ir_raw_event_handle: event type 2, time before event: 0000869us
[ 2803.106489] ir_raw_event_handle: event type 1, time before event: 0000893us
[ 2803.106495] ir_raw_event_handle: event type 2, time before event: 0000869us
[ 2803.106498] ir_raw_event_handle: event type 1, time before event: 0000921us
[ 2803.106504] ir_raw_event_handle: event type 2, time before event: 0000869us
[ 2803.106507] ir_raw_event_handle: event type 1, time before event: 0000893us
[ 2803.106513] ir_raw_event_handle: event type 2, time before event: 0090992us

The type 1 is space, type 2 is mark, type 6 is mark+start.
