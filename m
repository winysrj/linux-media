Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:34896 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754561AbeGINDa (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Jul 2018 09:03:30 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv5 08/12] ad9389b/adv7511: set proper media entity function
Date: Mon, 09 Jul 2018 16:04:03 +0300
Message-ID: <16467558.2TVdu2jfZS@avalon>
In-Reply-To: <20180629114331.7617-9-hverkuil@xs4all.nl>
References: <20180629114331.7617-1-hverkuil@xs4all.nl> <20180629114331.7617-9-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Friday, 29 June 2018 14:43:27 EEST Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> These two drivers both have function MEDIA_ENT_F_DV_ENCODER.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

As this patch is separate from 06/12, I think it would make sense to split the 
driver changes from 05/12 to a separate patch.

> ---
>  drivers/media/i2c/ad9389b.c | 1 +
>  drivers/media/i2c/adv7511.c | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/drivers/media/i2c/ad9389b.c b/drivers/media/i2c/ad9389b.c
> index 91ff06088572..5b008b0002c0 100644
> --- a/drivers/media/i2c/ad9389b.c
> +++ b/drivers/media/i2c/ad9389b.c
> @@ -1134,6 +1134,7 @@ static int ad9389b_probe(struct i2c_client *client,
> const struct i2c_device_id * goto err_hdl;
>  	}
>  	state->pad.flags = MEDIA_PAD_FL_SINK;
> +	sd->entity.function = MEDIA_ENT_F_DV_ENCODER;
>  	err = media_entity_pads_init(&sd->entity, 1, &state->pad);
>  	if (err)
>  		goto err_hdl;
> diff --git a/drivers/media/i2c/adv7511.c b/drivers/media/i2c/adv7511.c
> index 5731751d3f2a..55c2ea0720d9 100644
> --- a/drivers/media/i2c/adv7511.c
> +++ b/drivers/media/i2c/adv7511.c
> @@ -1847,6 +1847,7 @@ static int adv7511_probe(struct i2c_client *client,
> const struct i2c_device_id * goto err_hdl;
>  	}
>  	state->pad.flags = MEDIA_PAD_FL_SINK;
> +	sd->entity.function = MEDIA_ENT_F_DV_ENCODER;
>  	err = media_entity_pads_init(&sd->entity, 1, &state->pad);
>  	if (err)
>  		goto err_hdl;


-- 
Regards,

Laurent Pinchart
