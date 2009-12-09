Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:39969 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754843AbZLICXH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Dec 2009 21:23:07 -0500
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR  system?
From: Andy Walls <awalls@radix.net>
To: Christoph Bartelmus <lirc@bartelmus.de>
Cc: dmitry.torokhov@gmail.com, hermann-pitton@arcor.de, j@jannau.net,
	jarod@redhat.com, jarod@wilsonet.com, jonsmirl@gmail.com,
	khc@pm.waw.pl, kraxel@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	mchehab@redhat.com, superm1@ubuntu.com
In-Reply-To: <BEVi56a1qgB@lirc>
References: <BEVi56a1qgB@lirc>
Content-Type: text/plain
Date: Tue, 08 Dec 2009 21:21:30 -0500
Message-Id: <1260325290.3091.40.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2009-12-08 at 23:30 +0100, Christoph Bartelmus wrote:
> Hi Andy,
> 
> on 07 Dec 09 at 23:10, Andy Walls wrote:
> [...]
> > (Christoph can correct me if I get anything wrong.)
> 
> Just a few additions.

Christoph,

Thanks for the corrections and additions. :)

> [...]

> > I know that the hardware I work with has sub 100 ns resolution,
> 
> Highest IR carrier frequency I know is 500kHz. usec resolution is enough  
> even for raw modulated IR pulses. But you only look at the signal after it  
> has been demodulated by the IR chip, so higher resolution would be  
> overkill.

Yes, it's overkill.  It is more of a side effect of how I set up the
hardware to uses as much of the bits in the pulse width measurement
counter as possible for the longest expected valid measurment width.
The LSB of the hardware pulse width measurement counter can convey a
time change of as little as 74 ns depending on the setup of the Conexant
integrated IR controller.


> [...]
> >> How do you define the start and stop of sequences?
> 
> > For the end of Rx signalling:
> >
> > Well with the Conexant hardware I can set a maximum pulse (mark or
> > space) width, and the hardware will generate an Rx Timeout interrupt to
> > signal the end of Rx when a space ends up longer than that max pulse
> > width.  The hardware also puts a special marker in the hardware pulse
> > widht measurement FIFO (in band signalling essentially).
> >
> > I'm not sure anything like that gets communicated to userspace via
> > lirc_dev, and I'm too tired to doublecheck right now.
> 
> There is no such thing in the protocol. Some devices cannot provide any  
> end of signal marker, so lircd handles this using timers.
> 
> If there is some interest, the MODE2 protocol can be extended. We still  
> have 7 bits unused...

As I thought about this more, I could just pass up a space the length of
the pulse width measurment timeout from the kernel up to LIRC.  LIRC's
decoders should know that the space is too long as well.  No changes
needed - I think.




> [...]
> >> Is transmitting synchronous or queued?
> 
> > kfifo's IIRC.
> 
> No, it's synchronous.
> 
> >> How big is the transmit queue?
> 
> No queue.

Oops, thanks for the correction.



> [...]
> > My particular gripes about the current LIRC interface:

> > 2. I have hardware where I can set max_pulse_width so I can optimize
> > pulse timer resolution and have the hardware time out rapidly on end of
> > RX.  I also have hardware where I can set a min_pulse_width to set a
> > hardware low-pass/glitch filter.  Currently LIRC doesn't have any way to
> > set these, but it would be nice to have.
> 
> Should be really easy to add these. The actual values could be derived  
> from the config files easily.

Good.  I thought it would be so.

> > In band signalling of a
> > hardware detected "end of Rx" may also make sense then too.
> 
> See above.
> 
> > 3. As I mentioned before, it would be nice if LIRC could set a batch of
> > parameters atomically somehow, instead of with a series of ioctl()s.  I
> > can work around this in kernel though.
> 
> Is there any particular sequence that you are concerned about?
> Setting carrier frequency and then duty cycle is a bit problematic.
> Currently it's solved by resetting the duty cycle to 50% each time you  
> change the carrier frequency.
> But as the LIRC interface is "one user only", I don't see a real problem.

The case I worry about is enabling the IR Rx hardware without the low
pass filter properly set up to be consistent with the minimum expected
Rx pulse width and the desired Rx carrier window or maximum expected Rx
pulse width.  The result could be a lot of useless interrupts from IR
"glitch" measurements in bad ambient light conditions until all the
parameters are consistent.

Regards,
Andy

> Christoph


