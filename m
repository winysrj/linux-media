Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:46984 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030979AbeEXKcV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 May 2018 06:32:21 -0400
Received: by mail-wr0-f194.google.com with SMTP id x9-v6so2132889wrl.13
        for <linux-media@vger.kernel.org>; Thu, 24 May 2018 03:32:20 -0700 (PDT)
Date: Thu, 24 May 2018 12:32:18 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v3 6/9] media: rcar-vin: Link parallel input media
 entities
Message-ID: <20180524103218.GF31036@bigcity.dyn.berto.se>
References: <1526654445-10702-1-git-send-email-jacopo+renesas@jmondi.org>
 <1526654445-10702-7-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1526654445-10702-7-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thanks for your patch.

On 2018-05-18 16:40:42 +0200, Jacopo Mondi wrote:
> When running with media-controller link the parallel input
> media entities with the VIN entities at 'complete' callback time.
> 
> To create media links the v4l2_device should be registered first.
> Check if the device is already registered, to avoid double registrations.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 26 ++++++++++++++++++++++++--
>  1 file changed, 24 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> index 745e8ee..d13bbcf 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -478,6 +478,8 @@ static void rvin_parallel_subdevice_detach(struct rvin_dev *vin)
>  static int rvin_parallel_notify_complete(struct v4l2_async_notifier *notifier)
>  {
>  	struct rvin_dev *vin = notifier_to_vin(notifier);
> +	struct media_entity *source;
> +	struct media_entity *sink;
>  	int ret;
>  
>  	ret = v4l2_device_register_subdev_nodes(&vin->v4l2_dev);
> @@ -486,7 +488,26 @@ static int rvin_parallel_notify_complete(struct v4l2_async_notifier *notifier)
>  		return ret;
>  	}
>  
> -	return rvin_v4l2_register(vin);
> +	if (!video_is_registered(&vin->vdev)) {
> +		ret = rvin_v4l2_register(vin);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	if (!vin->info->use_mc)
> +		return 0;
> +
> +	/* If we're running with media-controller, link the subdevs. */
> +	source = &vin->parallel->subdev->entity;
> +	sink = &vin->vdev.entity;
> +
> +	ret = media_create_pad_link(source, vin->parallel->source_pad,
> +				    sink, vin->parallel->sink_pad, 0);
> +	if (ret)
> +		vin_err(vin, "Error adding link from %s to %s: %d\n",
> +			source->name, sink->name, ret);
> +
> +	return ret;
>  }
>  
>  static void rvin_parallel_notify_unbind(struct v4l2_async_notifier *notifier,
> @@ -611,7 +632,8 @@ static int rvin_group_notify_complete(struct v4l2_async_notifier *notifier)
>  
>  	/* Register all video nodes for the group. */
>  	for (i = 0; i < RCAR_VIN_NUM; i++) {
> -		if (vin->group->vin[i]) {
> +		if (vin->group->vin[i] &&
> +		    !video_is_registered(&vin->group->vin[i]->vdev)) {
>  			ret = rvin_v4l2_register(vin->group->vin[i]);
>  			if (ret)
>  				return ret;
> -- 
> 2.7.4
> 

-- 
Regards,
Niklas Söderlund
