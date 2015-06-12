Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:36209 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753117AbbFLJRk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jun 2015 05:17:40 -0400
Message-ID: <557AA3A7.1090105@xs4all.nl>
Date: Fri, 12 Jun 2015 11:17:27 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: William Towle <william.towle@codethink.co.uk>,
	linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk
CC: guennadi liakhovetski <g.liakhovetski@gmx.de>,
	sergei shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH 10/15] media: rcar_vin: Use correct pad number in try_fmt
References: <1433340002-1691-1-git-send-email-william.towle@codethink.co.uk> <1433340002-1691-11-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1433340002-1691-11-git-send-email-william.towle@codethink.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/03/2015 03:59 PM, William Towle wrote:
> Fix rcar_vin_try_fmt to use the correct pad number when calling the
> subdev set_fmt. Previously pad number 0 was always used, resulting in
> EINVAL if the subdev cares about the pad number (e.g. ADV7612).
> 
> Signed-off-by: William Towle <william.towle@codethink.co.uk>
> Reviewed-by: Rob Taylor <rob.taylor@codethink.co.uk>
> ---
>  drivers/media/platform/soc_camera/rcar_vin.c |   20 +++++++++++++++-----
>  1 file changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
> index 00c1034..cc993bc 100644
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
> @@ -1706,6 +1706,8 @@ static int rcar_vin_try_fmt(struct soc_camera_device *icd,
>  	int width, height;
>  	int ret;
>  
> +	pad_cfg = v4l2_subdev_alloc_pad_config(sd);
> +
>  	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
>  	if (!xlate) {
>  		xlate = icd->current_fmt;
> @@ -1734,10 +1736,15 @@ static int rcar_vin_try_fmt(struct soc_camera_device *icd,
>  	mf->code = xlate->code;
>  	mf->colorspace = pix->colorspace;
>  
> -	ret = v4l2_device_call_until_err(sd->v4l2_dev, soc_camera_grp_id(icd),
> -					 pad, set_fmt, &pad_cfg, &format);
> -	if (ret < 0)
> +	format.pad = icd->src_pad_idx;
> +	ret = v4l2_device_call_until_err(sd->v4l2_dev,
> +					soc_camera_grp_id(icd), pad,
> +					set_fmt, pad_cfg,
> +					&format);
> +	if (ret < 0) {
> +		v4l2_subdev_free_pad_config(pad_cfg);
>  		return ret;

I would use a goto to the end of the function here.

> +	}
>  
>  	/* Adjust only if VIN cannot scale */
>  	if (pix->width > mf->width * 2)
> @@ -1759,13 +1766,15 @@ static int rcar_vin_try_fmt(struct soc_camera_device *icd,
>  			 */
>  			mf->width = VIN_MAX_WIDTH;
>  			mf->height = VIN_MAX_HEIGHT;
> +			format.pad = icd->src_pad_idx;
>  			ret = v4l2_device_call_until_err(sd->v4l2_dev,
>  							 soc_camera_grp_id(icd),
> -							 pad, set_fmt, &pad_cfg,
> +							 pad, set_fmt, pad_cfg,
>  							 &format);
>  			if (ret < 0) {
>  				dev_err(icd->parent,
>  					"client try_fmt() = %d\n", ret);
> +				v4l2_subdev_free_pad_config(pad_cfg);
>  				return ret;

Ditto.

>  			}
>  		}
> @@ -1776,6 +1785,7 @@ static int rcar_vin_try_fmt(struct soc_camera_device *icd,
>  			pix->height = height;
>  	}
>  

With the error label here.

> +	v4l2_subdev_free_pad_config(pad_cfg);
>  	return ret;
>  }
>  
> 

