Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([93.97.41.153]:51742 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758828Ab2HXKDa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Aug 2012 06:03:30 -0400
Date: Fri, 24 Aug 2012 11:03:28 +0100
From: Sean Young <sean@mess.org>
To: Timo Kokkonen <timo.t.kokkonen@iki.fi>
Cc: linux-omap@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/8] ir-rx51: Handle signals properly
Message-ID: <20120824100328.GA20481@pequod.mess.org>
References: <1345665041-15211-1-git-send-email-timo.t.kokkonen@iki.fi>
 <1345665041-15211-3-git-send-email-timo.t.kokkonen@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345665041-15211-3-git-send-email-timo.t.kokkonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 22, 2012 at 10:50:35PM +0300, Timo Kokkonen wrote:
> The lirc-dev expects the ir-code to be transmitted when the write call
> returns back to the user space. We should not leave TX ongoing no
> matter what is the reason we return to the user space. Easiest
> solution for that is to simply remove interruptible sleeps.
> 
> The first wait_event_interruptible is thus replaced with return -EBUSY
> in case there is still ongoing transfer. This should suffice as the
> concept of sending multiple codes in parallel does not make sense.
> 
> The second wait_event_interruptible call is replaced with
> wait_even_timeout with a fixed and safe timeout that should prevent
> the process from getting stuck in kernel for too long.
> 
> Also, from now on we will force the TX to stop before we return from
> write call. If the TX happened to time out for some reason, we should
> not leave the HW transmitting anything.
> 
> Signed-off-by: Timo Kokkonen <timo.t.kokkonen@iki.fi>
> ---
>  drivers/media/rc/ir-rx51.c | 39 ++++++++++++++++++++++++++++-----------
>  1 file changed, 28 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/media/rc/ir-rx51.c b/drivers/media/rc/ir-rx51.c
> index 9487dd3..a7b787a 100644
> --- a/drivers/media/rc/ir-rx51.c
> +++ b/drivers/media/rc/ir-rx51.c
> @@ -74,6 +74,19 @@ static void lirc_rx51_off(struct lirc_rx51 *lirc_rx51)
>  			      OMAP_TIMER_TRIGGER_NONE);
>  }
>  
> +static void lirc_rx51_stop_tx(struct lirc_rx51 *lirc_rx51)
> +{
> +	if (lirc_rx51->wbuf_index < 0)
> +		return;
> +
> +	lirc_rx51_off(lirc_rx51);
> +	lirc_rx51->wbuf_index = -1;
> +	omap_dm_timer_stop(lirc_rx51->pwm_timer);
> +	omap_dm_timer_stop(lirc_rx51->pulse_timer);
> +	omap_dm_timer_set_int_enable(lirc_rx51->pulse_timer, 0);
> +	wake_up_interruptible(&lirc_rx51->wqueue);

Unless I'm mistaken, wait_up_interruptable() won't wake up any 
non-interruptable sleepers. Should this not be wake_up()?

> +}
> +
>  static int init_timing_params(struct lirc_rx51 *lirc_rx51)
>  {
>  	u32 load, match;
> @@ -160,13 +173,7 @@ static irqreturn_t lirc_rx51_interrupt_handler(int irq, void *ptr)
>  
>  	return IRQ_HANDLED;
>  end:
> -	/* Stop TX here */
> -	lirc_rx51_off(lirc_rx51);
> -	lirc_rx51->wbuf_index = -1;
> -	omap_dm_timer_stop(lirc_rx51->pwm_timer);
> -	omap_dm_timer_stop(lirc_rx51->pulse_timer);
> -	omap_dm_timer_set_int_enable(lirc_rx51->pulse_timer, 0);
> -	wake_up_interruptible(&lirc_rx51->wqueue);
> +	lirc_rx51_stop_tx(lirc_rx51);
>  
>  	return IRQ_HANDLED;
>  }
> @@ -246,8 +253,9 @@ static ssize_t lirc_rx51_write(struct file *file, const char *buf,
>  	if ((count > WBUF_LEN) || (count % 2 == 0))
>  		return -EINVAL;
>  
> -	/* Wait any pending transfers to finish */
> -	wait_event_interruptible(lirc_rx51->wqueue, lirc_rx51->wbuf_index < 0);
> +	/* We can have only one transmit at a time */
> +	if (lirc_rx51->wbuf_index >= 0)
> +		return -EBUSY;
>  
>  	if (copy_from_user(lirc_rx51->wbuf, buf, n))
>  		return -EFAULT;
> @@ -273,9 +281,18 @@ static ssize_t lirc_rx51_write(struct file *file, const char *buf,
>  
>  	/*
>  	 * Don't return back to the userspace until the transfer has
> -	 * finished
> +	 * finished. However, we wish to not spend any more than 500ms
> +	 * in kernel. No IR code TX should ever take that long.
> +	 */
> +	i = wait_event_timeout(lirc_rx51->wqueue, lirc_rx51->wbuf_index < 0,

Note non-interruptable sleeper.

> +			HZ / 2);
> +
> +	/*
> +	 * Ensure transmitting has really stopped, even if the timers
> +	 * went mad or something else happened that caused it still
> +	 * sending out something.
>  	 */
> -	wait_event_interruptible(lirc_rx51->wqueue, lirc_rx51->wbuf_index < 0);
> +	lirc_rx51_stop_tx(lirc_rx51);
>  
>  	/* We can sleep again */
>  	lirc_rx51->pdata->set_max_mpu_wakeup_lat(lirc_rx51->dev, -1);
> -- 
> 1.7.12
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
