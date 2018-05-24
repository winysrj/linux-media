Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:52236 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S968496AbeEXKhe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 May 2018 06:37:34 -0400
Received: by mail-wm0-f67.google.com with SMTP id w194-v6so3694507wmf.2
        for <linux-media@vger.kernel.org>; Thu, 24 May 2018 03:37:33 -0700 (PDT)
Date: Thu, 24 May 2018 12:37:31 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v3 7/9] media: rcar-vin: Handle parallel subdev in
 link_notify
Message-ID: <20180524103731.GG31036@bigcity.dyn.berto.se>
References: <1526654445-10702-1-git-send-email-jacopo+renesas@jmondi.org>
 <1526654445-10702-8-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1526654445-10702-8-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thanks for your patch.

On 2018-05-18 16:40:43 +0200, Jacopo Mondi wrote:
> Handle parallel subdevices in link_notify callback. If the notified link
> involves a parallel subdevice, do not change routing of the VIN-CSI-2
> devices and mark the VIN instance as using a parallel input. If the
> CSI-2 link setup succeeds instead, mark the VIN instance as using CSI-2.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 36 +++++++++++++++++++++++++++--
>  1 file changed, 34 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> index d13bbcf..dcebb42 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -168,10 +168,37 @@ static int rvin_group_link_notify(struct media_link *link, u32 flags,
>  	}
>  
>  	/* Add the new link to the existing mask and check if it works. */
> -	csi_id = rvin_group_entity_to_csi_id(group, link->source->entity);
>  	channel = rvin_group_csi_pad_to_channel(link->source->index);

I think you should move the channel = ...; bellow the new if statement 
the same way you do with mask_new.

> -	mask_new = mask & rvin_group_get_mask(vin, csi_id, channel);
> +	csi_id = rvin_group_entity_to_csi_id(group, link->source->entity);

Missing new line.

With these two nits fixed:

Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> +	if (csi_id == -ENODEV) {
> +		struct v4l2_subdev *sd;
> +		unsigned int i;
> +
> +		/*
> +		 * Make sure the source entity subdevice is registered as
> +		 * a parallel input of one of the enabled VINs if it is not
> +		 * one of the CSI-2 subdevices.
> +		 *
> +		 * No hardware configuration required for parallel inputs,
> +		 * we can return here.
> +		 */
> +		sd = media_entity_to_v4l2_subdev(link->source->entity);
> +		for (i = 0; i < RCAR_VIN_NUM; i++) {
> +			if (group->vin[i] && group->vin[i]->parallel &&
> +			    group->vin[i]->parallel->subdev == sd) {
> +				group->vin[i]->is_csi = false;
> +				ret = 0;
> +				goto out;
> +			}
> +		}
> +
> +		vin_err(vin, "Subdevice %s not registered to any VIN\n",
> +			link->source->entity->name);
> +		ret = -ENODEV;
> +		goto out;
> +	}
>  
> +	mask_new = mask & rvin_group_get_mask(vin, csi_id, channel);
>  	vin_dbg(vin, "Try link change mask: 0x%x new: 0x%x\n", mask, mask_new);
>  
>  	if (!mask_new) {
> @@ -181,6 +208,11 @@ static int rvin_group_link_notify(struct media_link *link, u32 flags,
>  
>  	/* New valid CHSEL found, set the new value. */
>  	ret = rvin_set_channel_routing(group->vin[master_id], __ffs(mask_new));
> +	if (ret)
> +		goto out;
> +
> +	vin->is_csi = true;
> +
>  out:
>  	mutex_unlock(&group->lock);
>  
> -- 
> 2.7.4
> 

-- 
Regards,
Niklas Söderlund
