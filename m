Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34773 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbbA2VYm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2015 16:24:42 -0500
Date: Thu, 29 Jan 2015 22:24:40 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Jacek Anaszewski <j.anaszewski@samsung.com>,
	Bryan Wu <cooloney@gmail.com>,
	Linux LED Subsystem <linux-leds@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	b.zolnierkie@samsung.com, "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH/RFC v8 02/14] Documentation: leds: Add description of LED
 Flash class extension
Message-ID: <20150129212440.GB21140@amd>
References: <547C539A.4010500@samsung.com>
 <20141201130437.GB24737@amd>
 <547C7420.4080801@samsung.com>
 <CAK5ve-KMNszyz6br_Q_dOhvk=_8ev6Uz-ZhPnYBn-ZvuohQpVA@mail.gmail.com>
 <20141206124310.GB3411@amd>
 <5485D7F8.10807@samsung.com>
 <20141208201855.GA16648@amd>
 <5486B8AE.5000408@samsung.com>
 <20141209155033.GB21422@amd>
 <20141210231431.GP15559@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141210231431.GP15559@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

> > > This approach would require implementing additional mechanisms on
> > > both sides: LED Flash class core and a LED Flash class driver.
> > > In the former the sysfs attribute write permissions would have
> > > to be decided in the runtime and in the latter caching mechanism
> > 
> > Write attributes at runtime? Why? We can emulate sane and consistent
> > behaviour for all the controllers: read gives you list of faults,
> > write clears it. We can do it for all the controllers.
> > 
> > Only cost is few lines of code in the drivers where hardware clears
> > faults at read.
> 
> Please take the time to read this, and consider it.
> 
> I'd say the cost is I2C register access, not so much a few lines added to
> the drivers. The functionality and behaviour between the flash controllers
> varies. They have different faults, presence of (some) faults may prevent
> strobing, some support reading the flash status and some don't.
> 
> Some of the flash faults are mostly relevant in production testing, some can
> be used to find hardware issues during use (rare) and some are produced in
> common use (timeout, for instance).
> 
> The V4L2 flash API defines that reading the faults clears them, but does not
> state whether presence of faults would prevent further use of the flash.
> This is flash controller chip specific.

Yeah, but we are discussing sysfs reads. V4L2 API can just behave differently.

> I think you *could* force a policy on the level of kernel API, for instance
> require that the user clears the faults before strobing again rather than
> relying on the chip requiring this instead.

Yes, we could do that.

> Most of the time there are no faults. When there are, they may appear at
> some point of time after the strobing, but how long? Probably roughly after
> the timeout period the flash should have faults available if there were any
> --- except if the strobe is external such as a sensor timed strobe. In that
> case the software running on the CPU has no knowledge when the flash is
> strobed nor when the faults should be read. So the requirement of checking
> the faults would probably have to be limited to software strobe only. The
> user would still have to be able to check the faults for externally strobed
> pulses. Would it be acceptable that the interface was different
> there?

Should the user just read the faults before scheduling next strobe?

> So, after the user has strobed, when the user should check the flash faults?
> After the timeout period has passed? Right before strobing again? If this
> was a requirement, it adds an additional I2C access to potentially the place
> which should absolutely have no extra delay --- the flash strobe time. This
> would be highly unwanted.

I'd do it before strobing again. Not neccessarily "just" before
strobing again (you claim it is slow ... is it really so slow it matters)?

> Finally, should the LED flash class enforce such a policy, would the V4L2
> flash API which is provided to the same devices be changed as well? I'm not
> against that if we have
> 
> 	1) can come up with a good policy that is understood to be
> 	   meaningful for all thinkable flash controller implementations and
> 
> 	2) agreement the behaviour can be changed.

I am saying that reading from /sys should not have side effects. For
V4L2, existing behaviour might be ok.

Each driver should have two operations: read_faults() and
clear_faults().

On devices where i2c read clears faults, operations will be:

int my_faults

read_faults()
	my_faults |= read_i2c_faults()
	return my_faults

clear_faults()
	my_faults = 0

Best regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
