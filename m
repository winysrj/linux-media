Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:50093 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558AbcFPO4m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2016 10:56:42 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
	<niklas.soderlund@ragnatech.se>
Cc: linux-media@vger.kernel.org, ulrich.hecht@gmail.com,
	hverkuil@xs4all.nl, linux-renesas-soc@vger.kernel.org,
	Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
	William Towle <william.towle@codethink.co.uk>,
	Niklas =?ISO-8859-1?Q?S=F6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: Re: [PATCH 2/8] media: rcar_vin: Use correct pad number in try_fmt
Date: Thu, 16 Jun 2016 17:56:52 +0300
Message-ID: <1916444.6UK1f8kFN6@avalon>
In-Reply-To: <1464203409-1279-3-git-send-email-niklas.soderlund@ragnatech.se>
References: <1464203409-1279-1-git-send-email-niklas.soderlund@ragnatech.se> <1464203409-1279-3-git-send-email-niklas.soderlund@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Niklas,

Thank you for the patch.

On Wednesday 25 May 2016 21:10:03 Niklas Söderlund wrote:
> From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
> 
> Fix rcar_vin_try_fmt's use of an inappropriate pad number when calling
> the subdev set_fmt function - for the ADV7612, IDs should be non-zero.
> 
> Signed-off-by: William Towle <william.towle@codethink.co.uk>
> Reviewed-by: Rob Taylor <rob.taylor@codethink.co.uk>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> [uli: adapted to rcar-vin rewrite]
> Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> b/drivers/media/platform/rcar-vin/rcar-v4l2.c index 929816b..3788f8a 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -98,7 +98,7 @@ static int __rvin_try_format_source(struct rvin_dev *vin,
>  					struct rvin_source_fmt *source)
>  {
>  	struct v4l2_subdev *sd;
> -	struct v4l2_subdev_pad_config pad_cfg;
> +	struct v4l2_subdev_pad_config *pad_cfg;
>  	struct v4l2_subdev_format format = {
>  		.which = which,
>  	};
> @@ -108,10 +108,16 @@ static int __rvin_try_format_source(struct rvin_dev
> *vin,
> 
>  	v4l2_fill_mbus_format(&format.format, pix, vin->source.code);
> 
> +	pad_cfg = v4l2_subdev_alloc_pad_config(sd);
> +	if (pad_cfg == NULL)
> +		return -ENOMEM;
> +
> +	format.pad = vin->src_pad_idx;
> +
>  	ret = v4l2_device_call_until_err(sd->v4l2_dev, 0, pad, set_fmt,
> -					 &pad_cfg, &format);
> +					 pad_cfg, &format);

pad_cfg is subdev-specific, you can't use v4l2_device_call_until_err(). You 
should use v4l2_subdev_call() instead. This will obviously not be enough if we 
have more than one subdev in the pipeline, but the code is broken in that case 
anyway.

>  	if (ret < 0)
> -		return ret;
> +		goto cleanup;
> 
>  	v4l2_fill_pix_format(pix, &format.format);
> 
> @@ -121,6 +127,8 @@ static int __rvin_try_format_source(struct rvin_dev
> *vin, vin_dbg(vin, "Source resolution: %ux%u\n", source->width,
>  		source->height);
> 
> +cleanup:

Nitpicking, I'd name the label "done".

> +	v4l2_subdev_free_pad_config(pad_cfg);
>  	return 0;
>  }

-- 
Regards,

Laurent Pinchart

