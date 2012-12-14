Return-path: <linux-media-owner@vger.kernel.org>
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:32136 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754461Ab2LNSGv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Dec 2012 13:06:51 -0500
Date: Fri, 14 Dec 2012 10:06:45 -0800
From: Tony Lindgren <tony@atomide.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Timo Kokkonen <timo.t.kokkonen@iki.fi>, linux-omap@vger.kernel.org,
	linux-media@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/7] ir-rx51: Handle signals properly
Message-ID: <20121214180645.GW4989@atomide.com>
References: <1353251589-26143-1-git-send-email-timo.t.kokkonen@iki.fi>
 <1353251589-26143-2-git-send-email-timo.t.kokkonen@iki.fi>
 <20121120195755.GM18567@atomide.com>
 <20121214172809.GT4989@atomide.com>
 <20121214172616.GC9620@arwen.pp.htv.fi>
 <20121214174629.GV4989@atomide.com>
 <20121214174918.GA11029@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121214174918.GA11029@arwen.pp.htv.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Felipe Balbi <balbi@ti.com> [121214 09:59]:
> On Fri, Dec 14, 2012 at 09:46:29AM -0800, Tony Lindgren wrote:
> > * Felipe Balbi <balbi@ti.com> [121214 09:36]:
> > > 
> > > if it's really for PWM, shouldn't we be using drivers/pwm/ ??
> > > 
> > > Meaning that $SUBJECT would just request a PWM device and use it. That
> > > doesn't solve the whole problem, however, as pwm-omap.c would still need
> > > access to timer-omap.h.
> > 
> > That would only help with omap_dm_timer_set_pwm() I think.
> > 
> > The other functions are also needed by the clocksource and clockevent
> > drivers. And tidspbridge too:
> 
> well, we _do_ have drivers/clocksource ;-)

That's where the dmtimer code should live. But still it does not help
with the header.

Thomas, maybe we could use the hrtimer framework for it if there was
some way to completely leave out the rb tree for the dedicated hardware
timers? There's no queue needed as there's always just one value tied to
a specific timer.

Regards,

Tony
