Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:37052 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524AbZFFBdc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Jun 2009 21:33:32 -0400
Subject: Re: [PATCH] tuner-simple, tveeprom: Add support for the FQ1216LME
 MK3
From: Andy Walls <awalls@radix.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: hermann pitton <hermann-pitton@arcor.de>,
	linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Dmitri Belimov <d.belimov@gmail.com>, Ant <ant@symons.net.au>,
	Martin Dauskardt <martin.dauskardt@gmx.de>,
	Discussion list for development of the IVTV driver
	<ivtv-devel@ivtvdriver.org>
In-Reply-To: <20090605210221.781db05f@pedra.chehab.org>
References: <200905210909.43333.martin.dauskardt@gmx.de>
	 <1243389830.4046.52.camel@palomino.walls.org>
	 <4A1CB353.7020906@symons.net.au> <200905270809.53056.hverkuil@xs4all.nl>
	 <1243502498.3722.17.camel@pc07.localdom.local>
	 <1244238732.4440.15.camel@palomino.walls.org>
	 <20090605210221.781db05f@pedra.chehab.org>
Content-Type: text/plain
Date: Fri, 05 Jun 2009 21:29:27 -0400
Message-Id: <1244251767.3140.17.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2009-06-05 at 21:02 -0300, Mauro Carvalho Chehab wrote:
> Em Fri, 05 Jun 2009 17:52:12 -0400
> Andy Walls <awalls@radix.net> escreveu:
> 
> > Hi,
> > 
> > This patch:
> > 
> > 1. adds explicit support for the FQ1216LME MK3
> > 
> > 2. points the tveeprom module to the FQ1216LME MK3 entry for EEPROMs
> > claiming FQ1216LME MK3 and MK5.
> > 
> > 3. refactors some code in simple_post_tune() because
> > 
> > a. I needed to set the Auxillary Byte, as did TUNER_LG_TDVS_H06XF, so I
> > could set the TUA6030 TOP to external AGC per the datasheet.
> > 
> > b. I wanted to do fast tuning while managing PLL phase noise, like the
> > TUNER_MICROTUNE_4042FI5 was already doing.
> > 
> > 
> > Hermann & Dmitri,
> > 
> > I think what is done for setting the charge pump current for the
> > TUNER_MICROTUNE_4042FI5 & FQ1216LME_MK3 in this patch is better than
> > fixing the control byte to a constant value of 0xce.
> 
> The idea seems good, and it is probably interesting to do it also with other
> tuners.
> 
> On a quick view to see the code, however, one part of the code popped up on my eyes:
> 
> > +static int simple_wait_pll_lock(struct dvb_frontend *fe, unsigned int timeout,
> > +				unsigned long interval)
> > +{
> > +	unsigned long expire;
> > +	int locked = 0;
> > +
> > +	for (expire = jiffies + msecs_to_jiffies(timeout);
> > +	     !time_after(jiffies, expire);
> > +	     udelay(interval)) {
> > +
> > +		if (tuner_islocked(tuner_read_status(fe))) {
> > +			locked = 1;
> > +			break;
> > +		}
> > +	}
> > +	return locked;
> > +}
> 
> 
> It is better to use a do {} while construct in situations like above, to make
> the loop easier to read.

Ok.  That's easy to change.


> Yet, I don't like the idea of using udelay to wait for up a long interval like
> on the above code  - you can delay it up to max(unsigned int) with the above code.
> 
> Holding CPU for a long period of time is really a very bad idea. Instead, you
> should use, for example, a waitqueue for it, like:

First: I agree busy waiting is simplistic and stupid - things could be
done better.

However I essentially only reimplemented the loop that
TUNER_MICROTUNE_4042FI5 used: it busy waited for 1 ms in intervals of 10
usecs.

Aside from assuming some sort of exploit, I'm not sure how the loop
could wind up busy waiting for max(unsigned int) msecs as the two calls
to it were:

	simple_wait_pll_lock(fe, 3, 128);
	simple_wait_pll_lock(fe, 1, 10);

depending on the tuner type.  I also though time_after() was supposed to
handle jiffies wrapping around.

	

> static int simple_wait_pll_lock(struct dvb_frontend *fe, unsigned int timeout)
> {
> 	DEFINE_WAIT(wait);
> 	wait_event_timeout(wait, tuner_islocked(tuner_read_status(fe)), timeout);
> 	return (tuner_islocked(tuner_read_status(fe)));
> }
> 
> This is cleaner, and, as wait_event_timeout() will call schedule(), the CPU will
> be released to deal with other tasks or to go to low power consumption level,
> saving some power (especially important on notebooks) and causing penalty on
> machine's performance

Well, there's not a real event for which to wait.  It's really just
going to be a poll of the FL bit at an interval smaller than the minimum
wait.  Implementing something that schedule()s between the polls
shouldn't be that hard.

Although, I'll defer doing something more complex right now though,
until I test it with a tuner I have.  My real goal was to get the
FQ1216LME properly supported.


Over the air analog TV is disappearing for me in 7 days.  I may not care
about analog tuning perfomance in a week. ;)

Regards,
Andy


> Cheers,
> Mauro


