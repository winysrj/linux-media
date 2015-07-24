Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:44296 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753672AbbGXOPT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jul 2015 10:15:19 -0400
Message-ID: <55B2482F.3040202@xs4all.nl>
Date: Fri, 24 Jul 2015 16:14:07 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: William Towle <william.towle@codethink.co.uk>,
	linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH 08/13] media: rcar_vin: Use correct pad number in try_fmt
References: <1437654103-26409-1-git-send-email-william.towle@codethink.co.uk> <1437654103-26409-9-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1437654103-26409-9-git-send-email-william.towle@codethink.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/23/2015 02:21 PM, William Towle wrote:
> Fix rcar_vin_try_fmt's use of an inappropriate pad number when calling
> the subdev set_fmt function - for the ADV7612, IDs should be non-zero.
> 
> Signed-off-by: William Towle <william.towle@codethink.co.uk>
> Reviewed-by: Rob Taylor <rob.taylor@codethink.co.uk>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/platform/soc_camera/rcar_vin.c |   17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
> index 00c1034..dab729a 100644
> --- a/drivers/media/platform/soc_camera/rcar_vin.c
> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
> @@ -1697,7 +1697,7 @@ static int rcar_vin_try_fmt(struct soc_camera_device *icd,
>  	const struct soc_camera_format_xlate *xlate;
>  	struct v4l2_pix_format *pix = &f->fmt.pix;
>  	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> -	struct v4l2_subdev_pad_config pad_cfg;
> +	struct v4l2_subdev_pad_config *pad_cfg;
>  	struct v4l2_subdev_format format = {
>  		.which = V4L2_SUBDEV_FORMAT_TRY,
>  	};
> @@ -1706,6 +1706,10 @@ static int rcar_vin_try_fmt(struct soc_camera_device *icd,
>  	int width, height;
>  	int ret;
>  
> +	pad_cfg = v4l2_subdev_alloc_pad_config(sd);
> +	if (pad_cfg == NULL)
> +		return -ENOMEM;
> +
>  	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
>  	if (!xlate) {
>  		xlate = icd->current_fmt;
> @@ -1734,10 +1738,11 @@ static int rcar_vin_try_fmt(struct soc_camera_device *icd,
>  	mf->code = xlate->code;
>  	mf->colorspace = pix->colorspace;
>  
> +	format.pad = icd->src_pad_idx;
>  	ret = v4l2_device_call_until_err(sd->v4l2_dev, soc_camera_grp_id(icd),
> -					 pad, set_fmt, &pad_cfg, &format);
> +					 pad, set_fmt, pad_cfg, &format);
>  	if (ret < 0)
> -		return ret;
> +		goto cleanup;
>  
>  	/* Adjust only if VIN cannot scale */
>  	if (pix->width > mf->width * 2)
> @@ -1761,12 +1766,12 @@ static int rcar_vin_try_fmt(struct soc_camera_device *icd,
>  			mf->height = VIN_MAX_HEIGHT;
>  			ret = v4l2_device_call_until_err(sd->v4l2_dev,
>  							 soc_camera_grp_id(icd),
> -							 pad, set_fmt, &pad_cfg,
> +							 pad, set_fmt, pad_cfg,
>  							 &format);
>  			if (ret < 0) {
>  				dev_err(icd->parent,
>  					"client try_fmt() = %d\n", ret);
> -				return ret;
> +				goto cleanup;
>  			}
>  		}
>  		/* We will scale exactly */
> @@ -1776,6 +1781,8 @@ static int rcar_vin_try_fmt(struct soc_camera_device *icd,
>  			pix->height = height;
>  	}
>  
> +cleanup:
> +	v4l2_subdev_free_pad_config(pad_cfg);
>  	return ret;
>  }
>  
> 

