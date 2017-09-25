Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:42336 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934055AbdIYKIH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Sep 2017 06:08:07 -0400
Subject: Re: [PATCH v6 16/25] rcar-vin: break out format alignment and
 checking
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <20170822232640.26147-1-niklas.soderlund+renesas@ragnatech.se>
 <20170822232640.26147-17-niklas.soderlund+renesas@ragnatech.se>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        tomoharu.fukawa.eb@renesas.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <34d03f81-ff25-3fe0-8dee-33496ff9b46e@xs4all.nl>
Date: Mon, 25 Sep 2017 12:08:04 +0200
MIME-Version: 1.0
In-Reply-To: <20170822232640.26147-17-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 23/08/17 01:26, Niklas Söderlund wrote:
> Part of the format aliment and checking can be shared with the Gen3

aliment -> alignment

> format handling. Break that part out to it's own function. While doing

it's -> its

> this clean up the checking and add more checks.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

Please note the small typo in a comment below.

Regards,

	Hans


> ---
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 98 +++++++++++++++--------------
>  1 file changed, 51 insertions(+), 47 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> index fb9f802e553e9b80..f71dea8d5d40323a 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -86,6 +86,56 @@ static u32 rvin_format_sizeimage(struct v4l2_pix_format *pix)
>  	return pix->bytesperline * pix->height;
>  }
>  
> +static int rvin_format_align(struct rvin_dev *vin, struct v4l2_pix_format *pix)
> +{
> +	u32 walign;
> +
> +	/* If requested format is not supported fallback to the default */
> +	if (!rvin_format_from_pixel(pix->pixelformat)) {
> +		vin_dbg(vin, "Format 0x%x not found, using default 0x%x\n",
> +			pix->pixelformat, RVIN_DEFAULT_FORMAT);
> +		pix->pixelformat = RVIN_DEFAULT_FORMAT;
> +	}
> +
> +	switch (pix->field) {
> +	case V4L2_FIELD_TOP:
> +	case V4L2_FIELD_BOTTOM:
> +	case V4L2_FIELD_NONE:
> +	case V4L2_FIELD_INTERLACED_TB:
> +	case V4L2_FIELD_INTERLACED_BT:
> +	case V4L2_FIELD_INTERLACED:
> +		break;
> +	default:
> +		pix->field = V4L2_FIELD_NONE;
> +		break;
> +	}
> +
> +	/* Check that colorspace is resonable, if not keep current */

resonable -> reasonable

> +	if (!pix->colorspace || pix->colorspace >= 0xff)
> +		pix->colorspace = vin->format.colorspace;
> +
> +	/* HW limit width to a multiple of 32 (2^5) for NV16 else 2 (2^1) */
> +	walign = vin->format.pixelformat == V4L2_PIX_FMT_NV16 ? 5 : 1;
> +
> +	/* Limit to VIN capabilities */
> +	v4l_bound_align_image(&pix->width, 2, vin->info->max_width, walign,
> +			      &pix->height, 4, vin->info->max_height, 2, 0);
> +
> +	pix->bytesperline = rvin_format_bytesperline(pix);
> +	pix->sizeimage = rvin_format_sizeimage(pix);
> +
> +	if (vin->info->chip == RCAR_M1 &&
> +	    pix->pixelformat == V4L2_PIX_FMT_XBGR32) {
> +		vin_err(vin, "pixel format XBGR32 not supported on M1\n");
> +		return -EINVAL;
> +	}
> +
> +	vin_dbg(vin, "Format %ux%u bpl: %d size: %d\n",
> +		pix->width, pix->height, pix->bytesperline, pix->sizeimage);
> +
> +	return 0;
> +}
> +
>  /* -----------------------------------------------------------------------------
>   * V4L2
>   */
> @@ -191,64 +241,18 @@ static int __rvin_try_format_source(struct rvin_dev *vin,
>  static int __rvin_try_format(struct rvin_dev *vin,
>  			     u32 which, struct v4l2_pix_format *pix)
>  {
> -	u32 walign;
>  	int ret;
>  
>  	/* Keep current field if no specific one is asked for */
>  	if (pix->field == V4L2_FIELD_ANY)
>  		pix->field = vin->format.field;
>  
> -	/* If requested format is not supported fallback to the default */
> -	if (!rvin_format_from_pixel(pix->pixelformat)) {
> -		vin_dbg(vin, "Format 0x%x not found, using default 0x%x\n",
> -			pix->pixelformat, RVIN_DEFAULT_FORMAT);
> -		pix->pixelformat = RVIN_DEFAULT_FORMAT;
> -	}
> -
> -	/* Always recalculate */
> -	pix->bytesperline = 0;
> -	pix->sizeimage = 0;
> -
>  	/* Limit to source capabilities */
>  	ret = __rvin_try_format_source(vin, which, pix);
>  	if (ret)
>  		return ret;
>  
> -	switch (pix->field) {
> -	case V4L2_FIELD_TOP:
> -	case V4L2_FIELD_BOTTOM:
> -	case V4L2_FIELD_NONE:
> -	case V4L2_FIELD_INTERLACED_TB:
> -	case V4L2_FIELD_INTERLACED_BT:
> -	case V4L2_FIELD_INTERLACED:
> -		break;
> -	default:
> -		pix->field = V4L2_FIELD_NONE;
> -		break;
> -	}
> -
> -	/* HW limit width to a multiple of 32 (2^5) for NV16 else 2 (2^1) */
> -	walign = vin->format.pixelformat == V4L2_PIX_FMT_NV16 ? 5 : 1;
> -
> -	/* Limit to VIN capabilities */
> -	v4l_bound_align_image(&pix->width, 2, vin->info->max_width, walign,
> -			      &pix->height, 4, vin->info->max_height, 2, 0);
> -
> -	pix->bytesperline = max_t(u32, pix->bytesperline,
> -				  rvin_format_bytesperline(pix));
> -	pix->sizeimage = max_t(u32, pix->sizeimage,
> -			       rvin_format_sizeimage(pix));
> -
> -	if (vin->info->chip == RCAR_M1 &&
> -	    pix->pixelformat == V4L2_PIX_FMT_XBGR32) {
> -		vin_err(vin, "pixel format XBGR32 not supported on M1\n");
> -		return -EINVAL;
> -	}
> -
> -	vin_dbg(vin, "Format %ux%u bpl: %d size: %d\n",
> -		pix->width, pix->height, pix->bytesperline, pix->sizeimage);
> -
> -	return 0;
> +	return rvin_format_align(vin, pix);
>  }
>  
>  static int rvin_querycap(struct file *file, void *priv,
> 
