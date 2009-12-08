Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:65357 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966742AbZLHWd7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Dec 2009 17:33:59 -0500
Date: 08 Dec 2009 23:30:00 +0100
From: lirc@bartelmus.de (Christoph Bartelmus)
To: awalls@radix.net
Cc: dmitry.torokhov@gmail.com
Cc: hermann-pitton@arcor.de
Cc: j@jannau.net
Cc: jarod@redhat.com
Cc: jarod@wilsonet.com
Cc: jonsmirl@gmail.com
Cc: khc@pm.waw.pl
Cc: kraxel@redhat.com
Cc: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: mchehab@redhat.com
Cc: superm1@ubuntu.com
Message-ID: <BEVi56a1qgB@lirc>
In-Reply-To: <1260245456.3086.91.camel@palomino.walls.org>
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR  system?
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

on 07 Dec 09 at 23:10, Andy Walls wrote:
[...]
> (Christoph can correct me if I get anything wrong.)

Just a few additions.

[...]
>> What is the time standard for the data, where does it come from?

> I think it is usec, IIRC.

Yes, it is.

> I know that the hardware I work with has sub 100 ns resolution,

Highest IR carrier frequency I know is 500kHz. usec resolution is enough  
even for raw modulated IR pulses. But you only look at the signal after it  
has been demodulated by the IR chip, so higher resolution would be  
overkill.

[...]
>> How do you define the start and stop of sequences?

> For the end of Rx signalling:
>
> Well with the Conexant hardware I can set a maximum pulse (mark or
> space) width, and the hardware will generate an Rx Timeout interrupt to
> signal the end of Rx when a space ends up longer than that max pulse
> width.  The hardware also puts a special marker in the hardware pulse
> widht measurement FIFO (in band signalling essentially).
>
> I'm not sure anything like that gets communicated to userspace via
> lirc_dev, and I'm too tired to doublecheck right now.

There is no such thing in the protocol. Some devices cannot provide any  
end of signal marker, so lircd handles this using timers.

If there is some interest, the MODE2 protocol can be extended. We still  
have 7 bits unused...

> If you have determined the protocol you are after, it's easy to know
> what the pulse count should be and what the max pulse width should be (+
> slop for crappy hardware) so finding the end of an Rx isn't hard.  The
> button repeats intervals are *very* large.  I've never seen a remote
> rapid fire codes back to back.

I did. There are some protocols that have a gap of only 6000 us between  
signals. And the settop boxes are very picky about this. If you make it  
too long, they won't accept the command.

[...]
>> Is transmitting synchronous or queued?

> kfifo's IIRC.

No, it's synchronous.

>> How big is the transmit queue?

No queue.

[...]
> My particular gripes about the current LIRC interface:
>
> 1. The one thing that I wish were documented better were the distinction
> between LIRC_MODE_PULSE, LIRC_MODE_RAW, and LIRC_MODE2 modes of
> operation.  I think I've figured it out, but I had to look at a lot of
> LIRC drivers to do so.

No driver uses RAW until now and lircd does not support it.
PULSE is used on the transmit path, MODE2 on the receive path.
There is no special reasoning for that, it's rather historic.
MODE2 makes sense on the receive path because you can easily distinguish  
between pulse/space.

> 2. I have hardware where I can set max_pulse_width so I can optimize
> pulse timer resolution and have the hardware time out rapidly on end of
> RX.  I also have hardware where I can set a min_pulse_width to set a
> hardware low-pass/glitch filter.  Currently LIRC doesn't have any way to
> set these, but it would be nice to have.

Should be really easy to add these. The actual values could be derived  
from the config files easily.

> In band signalling of a
> hardware detected "end of Rx" may also make sense then too.

See above.

> 3. As I mentioned before, it would be nice if LIRC could set a batch of
> parameters atomically somehow, instead of with a series of ioctl()s.  I
> can work around this in kernel though.

Is there any particular sequence that you are concerned about?
Setting carrier frequency and then duty cycle is a bit problematic.
Currently it's solved by resetting the duty cycle to 50% each time you  
change the carrier frequency.
But as the LIRC interface is "one user only", I don't see a real problem.

Christoph
