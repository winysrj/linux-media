Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:43541 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1168438AbcKAKeM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 1 Nov 2016 06:34:12 -0400
Date: Tue, 1 Nov 2016 10:34:08 +0000
From: Sean Young <sean@mess.org>
To: Andi Shyti <andi.shyti@samsung.com>
Cc: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andi Shyti <andi@etezian.org>
Subject: Re: [PATCH v2 5/7] [media] ir-lirc-codec: don't wait any
 transmitting time for tx only devices
Message-ID: <20161101103408.GA15939@gofer.mess.org>
References: <20161027143601.GA5103@gofer.mess.org>
 <20160901171629.15422-1-andi.shyti@samsung.com>
 <20160901171629.15422-6-andi.shyti@samsung.com>
 <CGME20160902084206epcas1p26e535506ec1c418ede9ba230d40f0656@epcas1p2.samsung.com>
 <20160902084158.GA25342@gofer.mess.org>
 <20161027074401.wxg5icc6hcpwnfsf@gangnam.samsung>
 <7e2f88ed83c4044c30bc03aaea9f09e1@hardeman.nu>
 <20161031170526.GA8183@gofer.mess.org>
 <20161101065111.hofyxjps2iwmxpzj@gangnam.samsung>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161101065111.hofyxjps2iwmxpzj@gangnam.samsung>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Andi,

On Tue, Nov 01, 2016 at 03:51:11PM +0900, Andi Shyti wrote:
> > Andi, it would be good to know what the use-case for the original change is.
> 
> the use case is the ir-spi itself which doesn't need the lirc to
> perform any waiting on its behalf.

Here is the crux of the problem: in the ir-spi case no wait will actually 
happen here, and certainly no "over-wait". The patch below will not change
behaviour at all.

In the ir-spi case, "towait" will be 0 and no wait happens.

I think the code is already in good shape but somehow there is a 
misunderstanding. Did I miss something?


Sean

> To me it just doesn't look right to simulate a fake transmission
> period and wait unnecessary time. Of course, the "over-wait" is not
> a big deal and at the end we can decide to drop it.
> 
> Otherwise, an alternative could be to add the boolean
> 'tx_no_wait' in the rc_dev structure. It could be set by the
> device driver during the initialization and the we can follow
> your approach.
> 
> Something like this:
> 
> diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
> index c327730..4553d04 100644
> --- a/drivers/media/rc/ir-lirc-codec.c
> +++ b/drivers/media/rc/ir-lirc-codec.c
> @@ -161,15 +161,19 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
>  
>         ret *= sizeof(unsigned int);
>  
> -       /*
> -        * The lircd gap calculation expects the write function to
> -        * wait for the actual IR signal to be transmitted before
> -        * returning.
> -        */
> -       towait = ktime_us_delta(ktime_add_us(start, duration), ktime_get());
> -       if (towait > 0) {
> -               set_current_state(TASK_INTERRUPTIBLE);
> -               schedule_timeout(usecs_to_jiffies(towait));
> +       if (!dev->tx_no_wait) {
> +               /*
> +                * The lircd gap calculation expects the write function to
> +                * wait for the actual IR signal to be transmitted before
> +                * returning.
> +                */
> +               towait = ktime_us_delta(ktime_add_us(start, duration),
> +                                                               ktime_get());
> +               if (towait > 0) {
> +                       set_current_state(TASK_INTERRUPTIBLE);
> +                       schedule_timeout(usecs_to_jiffies(towait));
> +               }
> +
>         }
>  
>  out:
> diff --git a/drivers/media/rc/ir-spi.c b/drivers/media/rc/ir-spi.c
> index fcda1e4..e44abfa 100644
> --- a/drivers/media/rc/ir-spi.c
> +++ b/drivers/media/rc/ir-spi.c
> @@ -149,6 +149,7 @@ static int ir_spi_probe(struct spi_device *spi)
>         if (!idata->rc)
>                 return -ENOMEM;
>  
> +       idata->rc->tx_no_wait      = true;
>         idata->rc->tx_ir           = ir_spi_tx;
>         idata->rc->s_tx_carrier    = ir_spi_set_tx_carrier;
>         idata->rc->s_tx_duty_cycle = ir_spi_set_duty_cycle;
> diff --git a/include/media/rc-core.h b/include/media/rc-core.h
> index fe0c9c4..c3ced9b 100644
> --- a/include/media/rc-core.h
> +++ b/include/media/rc-core.h
> @@ -85,6 +85,9 @@ enum rc_filter_type {
>   * @input_dev: the input child device used to communicate events to userspace
>   * @driver_type: specifies if protocol decoding is done in hardware or software
>   * @idle: used to keep track of RX state
> + * @tx_no_wait: decides whether to perform or not a sync write or not. The
> + *      device driver setting it to true must make sure to not break the ABI
> + *      which requires a sync transfer.
>   * @allowed_protocols: bitmask with the supported RC_BIT_* protocols
>   * @enabled_protocols: bitmask with the enabled RC_BIT_* protocols
>   * @allowed_wakeup_protocols: bitmask with the supported RC_BIT_* wakeup protocols
> @@ -147,6 +150,7 @@ struct rc_dev {
>         struct input_dev                *input_dev;
>         enum rc_driver_type             driver_type;
>         bool                            idle;
> +       bool                            tx_no_wait;
>         u64                             allowed_protocols;
>         u64                             enabled_protocols;
>         u64                             allowed_wakeup_protocols;
> 
> Thanks,
> Andi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
