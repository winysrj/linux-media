Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52522 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932265AbbFYKV3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jun 2015 06:21:29 -0400
Date: Thu, 25 Jun 2015 13:21:24 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH 4/5] [media] adv7604: Deliver resolution change events to
 userspace
Message-ID: <20150625102124.GK5904@valkosipuli.retiisi.org.uk>
References: <1435164631-19924-1-git-send-email-lars@metafoo.de>
 <1435164631-19924-4-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1435164631-19924-4-git-send-email-lars@metafoo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lars-Peter,

On Wed, Jun 24, 2015 at 06:50:30PM +0200, Lars-Peter Clausen wrote:
> Use the new v4l2_subdev_notify_event() helper function to deliver the
> resolution change event to userspace via the v4l2 subdev event queue as
> well as to the bridge driver using the callback notify mechanism.
> 
> This allows userspace applications to react to changes in resolution. This
> is useful and often necessary for video pipelines where there is no direct
> 1-to-1 relationship between the subdevice converter and the video capture
> device and hence it does not make sense to directly forward the event to
> the video capture device node.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
>  drivers/media/i2c/adv7604.c | 23 ++++++++++++++++++-----
>  1 file changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
> index cf1cb5a..b66f63e3 100644
> --- a/drivers/media/i2c/adv7604.c
> +++ b/drivers/media/i2c/adv7604.c
> @@ -1761,8 +1761,8 @@ static int adv76xx_s_routing(struct v4l2_subdev *sd,
>  	select_input(sd);
>  	enable_input(sd);
>  
> -	v4l2_subdev_notify(sd, V4L2_DEVICE_NOTIFY_EVENT,
> -			   (void *)&adv76xx_ev_fmt);
> +	v4l2_subdev_notify_event(sd, &adv76xx_ev_fmt);
> +
>  	return 0;
>  }
>  
> @@ -1929,8 +1929,7 @@ static int adv76xx_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
>  			"%s: fmt_change = 0x%x, fmt_change_digital = 0x%x\n",
>  			__func__, fmt_change, fmt_change_digital);
>  
> -		v4l2_subdev_notify(sd, V4L2_DEVICE_NOTIFY_EVENT,
> -				   (void *)&adv76xx_ev_fmt);
> +		v4l2_subdev_notify_event(sd, &adv76xx_ev_fmt);
>  
>  		if (handled)
>  			*handled = true;
> @@ -2348,6 +2347,20 @@ static int adv76xx_log_status(struct v4l2_subdev *sd)
>  	return 0;
>  }
>  
> +static int adv76xx_subscribe_event(struct v4l2_subdev *sd,
> +				   struct v4l2_fh *fh,
> +				   struct v4l2_event_subscription *sub)
> +{
> +	switch (sub->type) {
> +	case V4L2_EVENT_SOURCE_CHANGE:
> +		return v4l2_src_change_event_subdev_subscribe(sd, fh, sub);
> +	case V4L2_EVENT_CTRL:
> +		return v4l2_event_subdev_unsubscribe(sd, fh, sub);

This should be ..._subscribe(), shouldn't it?

You could simply use v4l2_event_subscribe(fh, sub),
v4l2_event_subdev_unsubscribe() is there so you can use it directly as the
subscribe_event() op.

> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
>  /* ----------------------------------------------------------------------- */
>  
>  static const struct v4l2_ctrl_ops adv76xx_ctrl_ops = {
> @@ -2357,7 +2370,7 @@ static const struct v4l2_ctrl_ops adv76xx_ctrl_ops = {
>  static const struct v4l2_subdev_core_ops adv76xx_core_ops = {
>  	.log_status = adv76xx_log_status,
>  	.interrupt_service_routine = adv76xx_isr,
> -	.subscribe_event = v4l2_ctrl_subdev_subscribe_event,
> +	.subscribe_event = adv76xx_subscribe_event,
>  	.unsubscribe_event = v4l2_event_subdev_unsubscribe,
>  #ifdef CONFIG_VIDEO_ADV_DEBUG
>  	.g_register = adv76xx_g_register,

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
