Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:55005 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751077AbcKYKIL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Nov 2016 05:08:11 -0500
Date: Fri, 25 Nov 2016 09:59:23 +0000
From: Sean Young <sean@mess.org>
To: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] media: rc: refactor raw handler kthread
Message-ID: <20161125095922.GB8403@gofer.mess.org>
References: <f1b01f8c-934a-3bfe-ca1f-880b9c1ad233@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1b01f8c-934a-3bfe-ca1f-880b9c1ad233@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 02, 2016 at 07:44:07AM +0200, Heiner Kallweit wrote:
> I think we can get rid of the spinlock protecting the kthread from being
> interrupted by a wakeup in certain parts.
> Even with the current implementation of the kthread the only lost wakeup
> scenario could happen if the wakeup occurs between the kfifo_len check
> and setting the state to TASK_INTERRUPTIBLE.
> 
> In the changed version we could lose a wakeup if it occurs between
> processing the fifo content and setting the state to TASK_INTERRUPTIBLE.
> This scenario is covered by an additional check for available events in
> the fifo and setting the state to TASK_RUNNING in this case.
> 
> In addition the changed version flushes the kfifo before ending
> when the kthread is stopped.
> 
> With this patch we gain:
> - Get rid of the spinlock
> - Simplify code
> - Don't grep / release the mutex for each individual event but just once
>   for the complete fifo content. This reduces overhead if a driver e.g.
>   triggers processing after writing the content of a hw fifo to the kfifo.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Looks good to me and I've also tested it.

Tested-by: Sean Young <sean@mess.org>

> ---
>  drivers/media/rc/rc-core-priv.h |  2 --
>  drivers/media/rc/rc-ir-raw.c    | 46 +++++++++++++++--------------------------
>  2 files changed, 17 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
> index 585d5e5..577128a 100644
> --- a/drivers/media/rc/rc-core-priv.h
> +++ b/drivers/media/rc/rc-core-priv.h
> @@ -20,7 +20,6 @@
>  #define	MAX_IR_EVENT_SIZE	512
>  
>  #include <linux/slab.h>
> -#include <linux/spinlock.h>
>  #include <media/rc-core.h>
>  
>  struct ir_raw_handler {
> @@ -37,7 +36,6 @@ struct ir_raw_handler {
>  struct ir_raw_event_ctrl {
>  	struct list_head		list;		/* to keep track of raw clients */
>  	struct task_struct		*thread;
> -	spinlock_t			lock;
>  	/* fifo for the pulse/space durations */
>  	DECLARE_KFIFO(kfifo, struct ir_raw_event, MAX_IR_EVENT_SIZE);
>  	ktime_t				last_event;	/* when last event occurred */
> diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
> index 205ecc6..71a3e17 100644
> --- a/drivers/media/rc/rc-ir-raw.c
> +++ b/drivers/media/rc/rc-ir-raw.c
> @@ -17,7 +17,6 @@
>  #include <linux/mutex.h>
>  #include <linux/kmod.h>
>  #include <linux/sched.h>
> -#include <linux/freezer.h>
>  #include "rc-core-priv.h"
>  
>  /* Used to keep track of IR raw clients, protected by ir_raw_handler_lock */
> @@ -35,32 +34,26 @@ static int ir_raw_event_thread(void *data)
>  	struct ir_raw_handler *handler;
>  	struct ir_raw_event_ctrl *raw = (struct ir_raw_event_ctrl *)data;
>  
> -	while (!kthread_should_stop()) {
> -
> -		spin_lock_irq(&raw->lock);
> -
> -		if (!kfifo_len(&raw->kfifo)) {
> -			set_current_state(TASK_INTERRUPTIBLE);
> -
> -			if (kthread_should_stop())
> -				set_current_state(TASK_RUNNING);
> -
> -			spin_unlock_irq(&raw->lock);
> -			schedule();
> -			continue;
> +	while (1) {
> +		mutex_lock(&ir_raw_handler_lock);
> +		while (kfifo_out(&raw->kfifo, &ev, 1)) {
> +			list_for_each_entry(handler, &ir_raw_handler_list, list)
> +				if (raw->dev->enabled_protocols &
> +				    handler->protocols || !handler->protocols)
> +					handler->decode(raw->dev, ev);
> +			raw->prev_ev = ev;
>  		}
> +		mutex_unlock(&ir_raw_handler_lock);
>  
> -		if(!kfifo_out(&raw->kfifo, &ev, 1))
> -			dev_err(&raw->dev->dev, "IR event FIFO is empty!\n");
> -		spin_unlock_irq(&raw->lock);
> +		set_current_state(TASK_INTERRUPTIBLE);
>  
> -		mutex_lock(&ir_raw_handler_lock);
> -		list_for_each_entry(handler, &ir_raw_handler_list, list)
> -			if (raw->dev->enabled_protocols & handler->protocols ||
> -			    !handler->protocols)
> -				handler->decode(raw->dev, ev);
> -		raw->prev_ev = ev;
> -		mutex_unlock(&ir_raw_handler_lock);
> +		if (kthread_should_stop()) {
> +			__set_current_state(TASK_RUNNING);
> +			break;
> +		} else if (!kfifo_is_empty(&raw->kfifo))
> +			set_current_state(TASK_RUNNING);
> +
> +		schedule();
>  	}
>  
>  	return 0;
> @@ -219,14 +212,10 @@ EXPORT_SYMBOL_GPL(ir_raw_event_set_idle);
>   */
>  void ir_raw_event_handle(struct rc_dev *dev)
>  {
> -	unsigned long flags;
> -
>  	if (!dev->raw)
>  		return;
>  
> -	spin_lock_irqsave(&dev->raw->lock, flags);
>  	wake_up_process(dev->raw->thread);
> -	spin_unlock_irqrestore(&dev->raw->lock, flags);
>  }
>  EXPORT_SYMBOL_GPL(ir_raw_event_handle);
>  
> @@ -274,7 +263,6 @@ int ir_raw_event_register(struct rc_dev *dev)
>  	dev->change_protocol = change_protocol;
>  	INIT_KFIFO(dev->raw->kfifo);
>  
> -	spin_lock_init(&dev->raw->lock);
>  	dev->raw->thread = kthread_run(ir_raw_event_thread, dev->raw,
>  				       "rc%u", dev->minor);
>  
> -- 
> 2.9.0
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
