Return-path: <linux-media-owner@vger.kernel.org>
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:28894 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756620Ab2LNRqg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Dec 2012 12:46:36 -0500
Date: Fri, 14 Dec 2012 09:46:29 -0800
From: Tony Lindgren <tony@atomide.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Timo Kokkonen <timo.t.kokkonen@iki.fi>, linux-omap@vger.kernel.org,
	linux-media@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/7] ir-rx51: Handle signals properly
Message-ID: <20121214174629.GV4989@atomide.com>
References: <1353251589-26143-1-git-send-email-timo.t.kokkonen@iki.fi>
 <1353251589-26143-2-git-send-email-timo.t.kokkonen@iki.fi>
 <20121120195755.GM18567@atomide.com>
 <20121214172809.GT4989@atomide.com>
 <20121214172616.GC9620@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121214172616.GC9620@arwen.pp.htv.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Felipe Balbi <balbi@ti.com> [121214 09:36]:
> Hi,
> 
> On Fri, Dec 14, 2012 at 09:28:09AM -0800, Tony Lindgren wrote:
> > * Tony Lindgren <tony@atomide.com> [121120 12:00]:
> > > Hi,
> > > 
> > > * Timo Kokkonen <timo.t.kokkonen@iki.fi> [121118 07:15]:
> > > > --- a/drivers/media/rc/ir-rx51.c
> > > > +++ b/drivers/media/rc/ir-rx51.c
> > > > @@ -74,6 +74,19 @@ static void lirc_rx51_off(struct lirc_rx51 *lirc_rx51)
> > > >  			      OMAP_TIMER_TRIGGER_NONE);
> > > >  }
> > > >  
> > > > +static void lirc_rx51_stop_tx(struct lirc_rx51 *lirc_rx51)
> > > > +{
> > > > +	if (lirc_rx51->wbuf_index < 0)
> > > > +		return;
> > > > +
> > > > +	lirc_rx51_off(lirc_rx51);
> > > > +	lirc_rx51->wbuf_index = -1;
> > > > +	omap_dm_timer_stop(lirc_rx51->pwm_timer);
> > > > +	omap_dm_timer_stop(lirc_rx51->pulse_timer);
> > > > +	omap_dm_timer_set_int_enable(lirc_rx51->pulse_timer, 0);
> > > > +	wake_up(&lirc_rx51->wqueue);
> > > > +}
> > > > +
> > > >  static int init_timing_params(struct lirc_rx51 *lirc_rx51)
> > > >  {
> > > >  	u32 load, match;
> > > 
> > > Good fixes in general.. But you won't be able to access the
> > > omap_dm_timer functions after we enable ARM multiplatform support
> > > for omap2+. That's for v3.9 probably right after v3.8-rc1.
> > > 
> > > We need to find some Linux generic API to use hardware timers
> > > like this, so I've added Thomas Gleixner and linux-arm-kernel
> > > mailing list to cc.
> > > 
> > > If no such API is available, then maybe we can export some of
> > > the omap_dm_timer functions if Thomas is OK with that.
> > 
> > Just to update the status on this.. It seems that we'll be moving
> > parts of plat/dmtimer into a minimal include/linux/timer-omap.h
> > unless people have better ideas on what to do with custom
> > hardware timers for PWM etc.
> 
> if it's really for PWM, shouldn't we be using drivers/pwm/ ??
> 
> Meaning that $SUBJECT would just request a PWM device and use it. That
> doesn't solve the whole problem, however, as pwm-omap.c would still need
> access to timer-omap.h.

That would only help with omap_dm_timer_set_pwm() I think.

The other functions are also needed by the clocksource and clockevent
drivers. And tidspbridge too:

$ grep -r omap_dm_timer drivers/
...

Regards,

Tony
