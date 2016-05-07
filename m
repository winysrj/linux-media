Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:43832 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbcEGN4o (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 May 2016 09:56:44 -0400
Date: Sat, 7 May 2016 10:56:38 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Heiner Kallweit <hkallweit1@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: media: rc: make raw event fifo size a module parameter
Message-ID: <20160507105638.0b47dda3@recife.lan>
In-Reply-To: <56EC3E55.3090008@gmail.com>
References: <56EC3E55.3090008@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Heiner,

Em Fri, 18 Mar 2016 18:43:49 +0100
Heiner Kallweit <hkallweit1@gmail.com> escreveu:

> Currently the fifo size is 512 elements. After a recent patch the size
> of struct ir_raw_event is down to 8 bytes, so the fifo still consumes
> 4KB. In most cases a much smaller fifo is sufficient, e.g. nuvoton-cir
> triggers event processing after 24 events latest. However the needed
> fifo size may also depend on system performance.
> 
> Therefore make the fifo size a module parameter with the current value
> of 512 being the default.

I didn't like this approach. If the user has more than one RC receiver
on his hardware, this approach would force all drivers to use the
same buffer size.

Instead, as this is actually a hardware limit, I guess the best is
to add a new field at struct rc_dev to allow the client drivers to
specify the desired buffer size. If zero, it would default to 512,
avoiding regressions.

That would, IMHO, give much more flexibility.

Btw, one of the things I missed on this patch is a logic that would
would prevent the user to specify crap values for buf size. 
If we let the user to specify it, some logic is need to prevent the
user to use an incredible small buffer and lose IR events (and complain
later that the driver is broken) or setup incredible big buffer, 
causing memory waste and probably causing other drivers to fail.

Regards,
Mauro.


> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/media/rc/rc-core-priv.h |  2 +-
>  drivers/media/rc/rc-ir-raw.c    | 20 +++++++++++++++++---
>  2 files changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
> index 585d5e5..ae6f81e 100644
> --- a/drivers/media/rc/rc-core-priv.h
> +++ b/drivers/media/rc/rc-core-priv.h
> @@ -39,7 +39,7 @@ struct ir_raw_event_ctrl {
>  	struct task_struct		*thread;
>  	spinlock_t			lock;
>  	/* fifo for the pulse/space durations */
> -	DECLARE_KFIFO(kfifo, struct ir_raw_event, MAX_IR_EVENT_SIZE);
> +	DECLARE_KFIFO_PTR(kfifo, struct ir_raw_event);
>  	ktime_t				last_event;	/* when last event occurred */
>  	enum raw_event_type		last_type;	/* last event type */
>  	struct rc_dev			*dev;		/* pointer to the parent rc_dev */
> diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
> index 144304c..620b036 100644
> --- a/drivers/media/rc/rc-ir-raw.c
> +++ b/drivers/media/rc/rc-ir-raw.c
> @@ -18,6 +18,7 @@
>  #include <linux/kmod.h>
>  #include <linux/sched.h>
>  #include <linux/freezer.h>
> +#include <linux/module.h>
>  #include "rc-core-priv.h"
>  
>  /* Used to keep track of IR raw clients, protected by ir_raw_handler_lock */
> @@ -28,6 +29,9 @@ static DEFINE_MUTEX(ir_raw_handler_lock);
>  static LIST_HEAD(ir_raw_handler_list);
>  static u64 available_protocols;
>  
> +/* module param */
> +static unsigned int ir_raw_event_fifo_size = MAX_IR_EVENT_SIZE;
> +
>  static int ir_raw_event_thread(void *data)
>  {
>  	struct ir_raw_event ev;
> @@ -262,7 +266,7 @@ int ir_raw_event_register(struct rc_dev *dev)
>  	int rc;
>  	struct ir_raw_handler *handler;
>  
> -	if (!dev)
> +	if (!dev || !ir_raw_event_fifo_size)
>  		return -EINVAL;
>  
>  	dev->raw = kzalloc(sizeof(*dev->raw), GFP_KERNEL);
> @@ -271,7 +275,10 @@ int ir_raw_event_register(struct rc_dev *dev)
>  
>  	dev->raw->dev = dev;
>  	dev->change_protocol = change_protocol;
> -	INIT_KFIFO(dev->raw->kfifo);
> +
> +	rc = kfifo_alloc(&dev->raw->kfifo, ir_raw_event_fifo_size, GFP_KERNEL);
> +	if (rc)
> +		goto out;
>  
>  	spin_lock_init(&dev->raw->lock);
>  	dev->raw->thread = kthread_run(ir_raw_event_thread, dev->raw,
> @@ -279,7 +286,7 @@ int ir_raw_event_register(struct rc_dev *dev)
>  
>  	if (IS_ERR(dev->raw->thread)) {
>  		rc = PTR_ERR(dev->raw->thread);
> -		goto out;
> +		goto out_kfifo;
>  	}
>  
>  	mutex_lock(&ir_raw_handler_lock);
> @@ -291,6 +298,8 @@ int ir_raw_event_register(struct rc_dev *dev)
>  
>  	return 0;
>  
> +out_kfifo:
> +	kfifo_free(&dev->raw->kfifo);
>  out:
>  	kfree(dev->raw);
>  	dev->raw = NULL;
> @@ -313,6 +322,7 @@ void ir_raw_event_unregister(struct rc_dev *dev)
>  			handler->raw_unregister(dev);
>  	mutex_unlock(&ir_raw_handler_lock);
>  
> +	kfifo_free(&dev->raw->kfifo);
>  	kfree(dev->raw);
>  	dev->raw = NULL;
>  }
> @@ -353,3 +363,7 @@ void ir_raw_handler_unregister(struct ir_raw_handler *ir_raw_handler)
>  	mutex_unlock(&ir_raw_handler_lock);
>  }
>  EXPORT_SYMBOL(ir_raw_handler_unregister);
> +
> +module_param_named(fifo_size, ir_raw_event_fifo_size, uint, S_IRUGO);
> +MODULE_PARM_DESC(fifo_size,
> +	"raw event fifo size, will be rounded up to next power of 2");


-- 
Thanks,
Mauro
