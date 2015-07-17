Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:42287 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757860AbbGQPNJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jul 2015 11:13:09 -0400
Message-ID: <55A91B47.10308@xs4all.nl>
Date: Fri, 17 Jul 2015 17:12:07 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>,
	Hans Verkuil <hans.verkuil@cisco.com>
CC: Mats Randgaard <matrandg@cisco.com>, linux-media@vger.kernel.org,
	kernel@pengutronix.de
Subject: Re: [PATCH v2] [media] tc358743: allow event subscription
References: <1437145614-4313-1-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1437145614-4313-1-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/17/2015 05:06 PM, Philipp Zabel wrote:
> This is useful to subscribe to HDMI hotplug events via the
> V4L2_CID_DV_RX_POWER_PRESENT control.

Very quick, but it doesn't apply. You need to combine the original
"[PATCH 5/5] [media] tc358743: allow event subscription" together with
this patch.

Regards,

	Hans

> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
> Changes since v1:
>  - Make use of v4l2_subdev_notify_event, v4l2_src_change_event_subdev_subscribe,
>    and v4l2_ctrl_subdev_subscribe_event.
> ---
>  drivers/media/i2c/tc358743.c | 18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
> index 0c3c8aa..0d31a4f 100644
> --- a/drivers/media/i2c/tc358743.c
> +++ b/drivers/media/i2c/tc358743.c
> @@ -860,8 +860,7 @@ static void tc358743_format_change(struct v4l2_subdev *sd)
>  				&timings, false);
>  	}
>  
> -	v4l2_subdev_notify(sd, V4L2_DEVICE_NOTIFY_EVENT,
> -			(void *)&tc358743_ev_fmt);
> +	v4l2_subdev_notify_event(sd, &tc358743_ev_fmt);
>  }
>  
>  static void tc358743_init_interrupts(struct v4l2_subdev *sd)
> @@ -1318,6 +1317,19 @@ static irqreturn_t tc358743_irq_handler(int irq, void *dev_id)
>  	return handled ? IRQ_HANDLED : IRQ_NONE;
>  }
>  
> +static int tc358743_subscribe_event(struct v4l2_subdev *sd, struct v4l2_fh *fh,
> +				    struct v4l2_event_subscription *sub)
> +{
> +	switch (sub->type) {
> +	case V4L2_EVENT_SOURCE_CHANGE:
> +		return v4l2_src_change_event_subdev_subscribe(sd, fh, sub);
> +	case V4L2_EVENT_CTRL:
> +		return v4l2_ctrl_subdev_subscribe_event(sd, fh, sub);
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
>  /* --------------- VIDEO OPS --------------- */
>  
>  static int tc358743_g_input_status(struct v4l2_subdev *sd, u32 *status)
> @@ -1605,7 +1617,7 @@ static const struct v4l2_subdev_core_ops tc358743_core_ops = {
>  	.s_register = tc358743_s_register,
>  #endif
>  	.interrupt_service_routine = tc358743_isr,
> -	.subscribe_event = v4l2_ctrl_subdev_subscribe_event,
> +	.subscribe_event = tc358743_subscribe_event,
>  	.unsubscribe_event = v4l2_event_subdev_unsubscribe,
>  };
>  
> 

