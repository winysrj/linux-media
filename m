Return-path: <linux-media-owner@vger.kernel.org>
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:61736 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756604Ab2LNR2N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Dec 2012 12:28:13 -0500
Date: Fri, 14 Dec 2012 09:28:09 -0800
From: Tony Lindgren <tony@atomide.com>
To: Timo Kokkonen <timo.t.kokkonen@iki.fi>
Cc: linux-omap@vger.kernel.org, linux-media@vger.kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/7] ir-rx51: Handle signals properly
Message-ID: <20121214172809.GT4989@atomide.com>
References: <1353251589-26143-1-git-send-email-timo.t.kokkonen@iki.fi>
 <1353251589-26143-2-git-send-email-timo.t.kokkonen@iki.fi>
 <20121120195755.GM18567@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121120195755.GM18567@atomide.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Tony Lindgren <tony@atomide.com> [121120 12:00]:
> Hi,
> 
> * Timo Kokkonen <timo.t.kokkonen@iki.fi> [121118 07:15]:
> > --- a/drivers/media/rc/ir-rx51.c
> > +++ b/drivers/media/rc/ir-rx51.c
> > @@ -74,6 +74,19 @@ static void lirc_rx51_off(struct lirc_rx51 *lirc_rx51)
> >  			      OMAP_TIMER_TRIGGER_NONE);
> >  }
> >  
> > +static void lirc_rx51_stop_tx(struct lirc_rx51 *lirc_rx51)
> > +{
> > +	if (lirc_rx51->wbuf_index < 0)
> > +		return;
> > +
> > +	lirc_rx51_off(lirc_rx51);
> > +	lirc_rx51->wbuf_index = -1;
> > +	omap_dm_timer_stop(lirc_rx51->pwm_timer);
> > +	omap_dm_timer_stop(lirc_rx51->pulse_timer);
> > +	omap_dm_timer_set_int_enable(lirc_rx51->pulse_timer, 0);
> > +	wake_up(&lirc_rx51->wqueue);
> > +}
> > +
> >  static int init_timing_params(struct lirc_rx51 *lirc_rx51)
> >  {
> >  	u32 load, match;
> 
> Good fixes in general.. But you won't be able to access the
> omap_dm_timer functions after we enable ARM multiplatform support
> for omap2+. That's for v3.9 probably right after v3.8-rc1.
> 
> We need to find some Linux generic API to use hardware timers
> like this, so I've added Thomas Gleixner and linux-arm-kernel
> mailing list to cc.
> 
> If no such API is available, then maybe we can export some of
> the omap_dm_timer functions if Thomas is OK with that.

Just to update the status on this.. It seems that we'll be moving
parts of plat/dmtimer into a minimal include/linux/timer-omap.h
unless people have better ideas on what to do with custom
hardware timers for PWM etc.
 
> The other alternative is to set them up as platform_data
> function pointers, but that won't work after we make omap2+
> device tree only. And that really just postpones the problem.
> 
> Cheers,
> 
> Tony
> 
> 
> > @@ -163,13 +176,7 @@ static irqreturn_t lirc_rx51_interrupt_handler(int irq, void *ptr)
> >  
> >  	return IRQ_HANDLED;
> >  end:
> > -	/* Stop TX here */
> > -	lirc_rx51_off(lirc_rx51);
> > -	lirc_rx51->wbuf_index = -1;
> > -	omap_dm_timer_stop(lirc_rx51->pwm_timer);
> > -	omap_dm_timer_stop(lirc_rx51->pulse_timer);
> > -	omap_dm_timer_set_int_enable(lirc_rx51->pulse_timer, 0);
> > -	wake_up_interruptible(&lirc_rx51->wqueue);
> > +	lirc_rx51_stop_tx(lirc_rx51);
> >  
> >  	return IRQ_HANDLED;
> >  }
> > @@ -249,8 +256,9 @@ static ssize_t lirc_rx51_write(struct file *file, const char *buf,
> >  	if ((count > WBUF_LEN) || (count % 2 == 0))
> >  		return -EINVAL;
> >  
> > -	/* Wait any pending transfers to finish */
> > -	wait_event_interruptible(lirc_rx51->wqueue, lirc_rx51->wbuf_index < 0);
> > +	/* We can have only one transmit at a time */
> > +	if (lirc_rx51->wbuf_index >= 0)
> > +		return -EBUSY;
> >  
> >  	if (copy_from_user(lirc_rx51->wbuf, buf, n))
> >  		return -EFAULT;
> > @@ -276,9 +284,18 @@ static ssize_t lirc_rx51_write(struct file *file, const char *buf,
> >  
> >  	/*
> >  	 * Don't return back to the userspace until the transfer has
> > -	 * finished
> > +	 * finished. However, we wish to not spend any more than 500ms
> > +	 * in kernel. No IR code TX should ever take that long.
> > +	 */
> > +	i = wait_event_timeout(lirc_rx51->wqueue, lirc_rx51->wbuf_index < 0,
> > +			HZ / 2);
> > +
> > +	/*
> > +	 * Ensure transmitting has really stopped, even if the timers
> > +	 * went mad or something else happened that caused it still
> > +	 * sending out something.
> >  	 */
> > -	wait_event_interruptible(lirc_rx51->wqueue, lirc_rx51->wbuf_index < 0);
> > +	lirc_rx51_stop_tx(lirc_rx51);
> >  
> >  	/* We can sleep again */
> >  	lirc_rx51->pdata->set_max_mpu_wakeup_lat(lirc_rx51->dev, -1);
> > -- 
> > 1.8.0
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
