Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:47655 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753627Ab0G2Q65 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jul 2010 12:58:57 -0400
Subject: Re: [PATCH 0/9 v2] IR: few fixes, additions and ENE driver
From: Andy Walls <awalls@md.metrocast.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Christoph Bartelmus <lirc@bartelmus.de>, jarod@wilsonet.com,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	lirc-list@lists.sourceforge.net, mchehab@redhat.com
In-Reply-To: <1280420775.32069.5.camel@maxim-laptop>
References: <BTlMsWzZjFB@christoph> <1280414519.29938.53.camel@maxim-laptop>
	 <1280417934.15757.20.camel@morgan.silverblock.net>
	 <1280420775.32069.5.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Jul 2010 12:58:14 -0400
Message-ID: <1280422694.21700.17.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2010-07-29 at 19:26 +0300, Maxim Levitsky wrote:
> On Thu, 2010-07-29 at 11:38 -0400, Andy Walls wrote: 
> > On Thu, 2010-07-29 at 17:41 +0300, Maxim Levitsky wrote:
> > > On Thu, 2010-07-29 at 09:23 +0200, Christoph Bartelmus wrote: 
> > > > Hi Maxim,
> > > > 
> > > > on 29 Jul 10 at 02:40, Maxim Levitsky wrote:
> > > > [...]
> > > > > In addition to comments, I changed helper function that processes samples
> > > > > so it sends last space as soon as timeout is reached.
> > > > > This breaks somewhat lirc, because now it gets 2 spaces in row.
> > > > > However, if it uses timeout reports (which are now fully supported)
> > > > > it will get such report in middle.
> > > > >
> > > > > Note that I send timeout report with zero value.
> > > > > I don't think that this value is importaint.
> > > > 
> > > > This does not sound good. Of course the value is important to userspace  
> > > > and 2 spaces in a row will break decoding.
> > > > 
> > > > Christoph
> > > 
> > > Could you explain exactly how timeout reports work?
> > > 
> > > Lirc interface isn't set to stone, so how about a reasonable compromise.
> > > After reasonable long period of inactivity (200 ms for example), space
> > > is sent, and then next report starts with a pulse.
> > > So gaps between keypresses will be maximum of 200 ms, and as a bonus I
> > > could rip of the logic that deals with remembering the time?
> > > 
> > > Best regards,
> > > Maxim Levitsky
> 
> So, timeout report is just another sample, with a mark attached, that
> this is last sample? right?

On a measurement timeout, the Conexant hardware RX FIFO has this special
timer overflow value in it as the last measurement:

	value = 0x1ffff => a mark with a measurement of 65535 * 4 clocks

(and the measurement before this one in the FIFO is usually the last
actual mark received). 

I ultimately translate that to

	pulse = false;		/* a space */
	duration = 0x7fffffff;  /* 2.147 seconds */

to give the in kernel decoders a final space.

What is lost is the actual space measurement by the hardware (whatever
65535 * 4 Rx clocks is), before the timeout.

If LIRC likes to measure intertransmission gaps, what I am currently
doing will not give LIRC a reasonable gap estimate/measurement, if the
timeout is shorter than the actual gap.

> Christoph, right?
> 
> In that case, lets do that this way:
> 
> As soon as timeout is reached, I just send lirc the timeout report.
> Then next keypress will start with pulse.
> 
> I think this is the best solution.

I'm flexible.  I don't know LIRC internals well enough to know what's
best.  I suspect sending a valid space measurement of the timeout,
before the timeout report, may be useful for LIRC to obtain information
on the gaps that are longer than the hardware timeout.

Regards,
Andy

> Best regards,
> Maxim Levitsky
> 


