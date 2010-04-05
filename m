Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:54135 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752965Ab0DEBot (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 4 Apr 2010 21:44:49 -0400
Subject: Re: [PATCH 04/15] V4L/DVB: ir-core: Add logic to decode IR
 protocols at the IR core
From: Andy Walls <awalls@md.metrocast.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-input@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <4BB8D3D6.5010706@infradead.org>
References: <cover.1270142346.git.mchehab@redhat.com>
	 <20100401145632.7b1b98d5@pedra>
	 <1270251567.3027.55.camel@palomino.walls.org> <4BB69A95.5000705@redhat.com>
	 <1270314992.9169.40.camel@palomino.walls.org>  <4BB7C795.20506@redhat.com>
	 <1270384551.4979.47.camel@palomino.walls.org>
	 <4BB8D3D6.5010706@infradead.org>
Content-Type: multipart/mixed; boundary="=-sL4AHAg3BY4Ocs1g02Yj"
Date: Sun, 04 Apr 2010 21:45:11 -0400
Message-Id: <1270431911.3506.25.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-sL4AHAg3BY4Ocs1g02Yj
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Sun, 2010-04-04 at 15:00 -0300, Mauro Carvalho Chehab wrote:
> Andy Walls wrote:

> > And when you have time:
 
> > A way to generate random IR
> > glitches is with bright sunlight reflecting off of a basin of water
> > that's surface is being disturbed to make waves.  
> 
> I have a better way: just let my IR sensor to be pointed to the fluorescent
> lamp I have on my room... It produces _lots_ of glitches.

:)


 
> > Since a glitch filter is probably going to be needed by a number of
> > drivers and since the minimum acceptable pulse depends slightly on the
> > protocol, it probably makes sense for
> > 
> > 1. A driver to indicate if its raw events need glitch filtering
> > 
> > 2. A common glitch filtering library function that can be used by all
> > decoders, and that also can accept a decoder specified minimum
> > acceptable pulse width.
> 
> Seems a nice improvement. I doubt I'll have time for handling it right now,
> since there are still many things to do, but I'll put it on my todo list.
> Of course, patches adding it are wellcome ;)

:)

OK.  When I find time I'll hack something up as a prototype.



> Btw, I added a RC-5 decoder there, at my IR experimental tree:
> 	http://git.linuxtv.org/mchehab/ir.git

I'll try to review it some time this week.  Streaming state machine
decoders do seem to be best way to go with these decoders.

I have an RC-5 decoder in cx23885-input.c that isn't as clean as the NEC
protocol decoder I developed.  The cx23885-input.c RC-5 decoder is not a
very explicit state machine however (it is a bit hack-ish).


> Unfortunately, there's some problem with either my Remote Controller or 
> with the saa7134 driver. After 11 bits received, after the 2 start bits, 
> it receives a pause (see the enclosed sequence).

-ENOATTACHMENT


> I'm starting to suspect that the Hauppauge Grey IR produces a sequence with shorter
> bits, but, as the hardware decoders are capable or receiving IR codes, it may
> also be a hardware problem.

The fundamental unit in RC-5 is 32 cycles / 36 kHz = 888889 ns ~= 889 us.

I turned on the cx23888-ir.c debugging on the HVR-1850 and using a
Hauppague grey remote (address 0x1e IIRC) and got this as just one
example:

cx23885[1]/888-ir: rx read:     802037 ns  mark
cx23885[1]/888-ir: rx read:     852704 ns  space
cx23885[1]/888-ir: rx read:     775370 ns  mark
cx23885[1]/888-ir: rx read:     852407 ns  space
cx23885[1]/888-ir: rx read:     802037 ns  mark
cx23885[1]/888-ir: rx read:     852852 ns  space
cx23885[1]/888-ir: rx read:     775667 ns  mark
cx23885[1]/888-ir: rx read:     852407 ns  space
cx23885[1]/888-ir: rx read:     801741 ns  mark
cx23885[1]/888-ir: rx read:     852852 ns  space
cx23885[1]/888-ir: rx read:     775667 ns  mark
cx23885[1]/888-ir: rx read:     852407 ns  space
cx23885[1]/888-ir: rx read:    1602926 ns  mark
cx23885[1]/888-ir: rx read:     852407 ns  space
cx23885[1]/888-ir: rx read:     801741 ns  mark
cx23885[1]/888-ir: rx read:     852852 ns  space
cx23885[1]/888-ir: rx read:     775074 ns  mark
cx23885[1]/888-ir: rx read:     853148 ns  space
cx23885[1]/888-ir: rx read:     801593 ns  mark
cx23885[1]/888-ir: rx read:     852704 ns  space
cx23885[1]/888-ir: rx read:     775667 ns  mark
cx23885[1]/888-ir: rx read:     852556 ns  space
cx23885[1]/888-ir: rx read:     801741 ns  mark
cx23885[1]/888-ir: rx read:     852259 ns  space
cx23885[1]/888-ir: rx read:     775963 ns  mark
cx23885[1]/888-ir: rx read: end of rx

That should be a press of '0' on the remote.

'end of rx' means the hardware measured a really long space.

I also had the hardware low pass filter on.   I think that would effect
the space measurements by making them shorter, if IR noise caused a
glitch. 

Note that many of the marks are a bit shorter than the ideal 889 us.  In
fact the single marks from the grey remote seem to alternate between 775
us and 802 us.

I have attached a larger capture of (attempted) single presses of the
digits '0' through '9' and then an intentionally held down press of '7'.

With a quick glance, I don't see pauses from the grey remote.

Regards,
Andy


--=-sL4AHAg3BY4Ocs1g02Yj
Content-Disposition: attachment; filename="hpg-grey-ir-pulses.txt.gz"
Content-Type: application/x-gzip; name="hpg-grey-ir-pulses.txt.gz"
Content-Transfer-Encoding: base64

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
H5D7T6w+hB46wAAA


--=-sL4AHAg3BY4Ocs1g02Yj--

