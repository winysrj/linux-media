Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:52981 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751013AbeEPUur (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 May 2018 16:50:47 -0400
Received: by mail-wm0-f68.google.com with SMTP id w194-v6so4601544wmf.2
        for <linux-media@vger.kernel.org>; Wed, 16 May 2018 13:50:47 -0700 (PDT)
Date: Wed, 16 May 2018 22:50:45 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 3/4] media: rcar-vin: Handle digital subdev in
 link_notify
Message-ID: <20180516205045.GD17838@bigcity.dyn.berto.se>
References: <1526473016-30559-1-git-send-email-jacopo+renesas@jmondi.org>
 <1526473016-30559-4-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1526473016-30559-4-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thanks for your patch,

On 2018-05-16 14:16:55 +0200, Jacopo Mondi wrote:
> Handle digital subdevices in link_notify callback. If the notified link
> involves a digital subdevice, do not change routing of the VIN-CSI-2
> devices.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 30 +++++++++++++++++++++++++++--
>  1 file changed, 28 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> index 1003c8c..ea74c55 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -168,10 +168,36 @@ static int rvin_group_link_notify(struct media_link *link, u32 flags,
>  	}
>  
>  	/* Add the new link to the existing mask and check if it works. */
> -	csi_id = rvin_group_entity_to_csi_id(group, link->source->entity);
>  	channel = rvin_group_csi_pad_to_channel(link->source->index);
> -	mask_new = mask & rvin_group_get_mask(vin, csi_id, channel);
> +	csi_id = rvin_group_entity_to_csi_id(group, link->source->entity);
> +	if (csi_id == -ENODEV) {
> +		struct v4l2_subdev *sd;
> +		unsigned int i;
> +
> +		/*
> +		 * Make sure the source entity subdevice is registered as
> +		 * a digital input of one of the enabled VINs if it is not
> +		 * one of the CSI-2 subdevices.
> +		 *
> +		 * No hardware configuration required for digital inputs,
> +		 * we can return here.
> +		 */
> +		sd = media_entity_to_v4l2_subdev(link->source->entity);
> +		for (i = 0; i < RCAR_VIN_NUM; i++) {
> +			if (group->vin[i] && group->vin[i]->digital &&
> +			    group->vin[i]->digital->subdev == sd) {
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

I like this patch, you made it so simple. I feared this would be the 
ugly part when adding parallel support to Gen3. All that is missing is 
handling of vin->mbus_cfg or how you think we best handle that for the 
different input buses.

>  
> +	mask_new = mask & rvin_group_get_mask(vin, csi_id, channel);
>  	vin_dbg(vin, "Try link change mask: 0x%x new: 0x%x\n", mask, mask_new);
>  
>  	if (!mask_new) {
> -- 
> 2.7.4
> 

-- 
Regards,
Niklas Söderlund
