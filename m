Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:42527 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753773AbbE2KY0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 May 2015 06:24:26 -0400
Message-ID: <55683E4D.9070003@xs4all.nl>
Date: Fri, 29 May 2015 12:24:13 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: William Towle <william.towle@codethink.co.uk>,
	linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH 10/15] media: rcar_vin: Use correct pad number in try_fmt
References: <1432743053-13479-1-git-send-email-william.towle@codethink.co.uk> <1432743053-13479-11-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1432743053-13479-11-git-send-email-william.towle@codethink.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/27/2015 06:10 PM, William Towle wrote:
> Fix rcar_vin_try_fmt to use the correct pad number when calling the
> subdev set_fmt. Previously pad number 0 was always used, resulting in
> EINVAL if the subdev cares about the pad number (e.g. ADV7612).
> 
> Signed-off-by: William Towle <william.towle@codethink.co.uk>
> Reviewed-by: Rob Taylor <rob.taylor@codethink.co.uk>
> ---
>  drivers/media/platform/soc_camera/rcar_vin.c |   36 ++++++++++++++++++++++----
>  1 file changed, 31 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
> index 0df3212..5523d04 100644
> --- a/drivers/media/platform/soc_camera/rcar_vin.c
> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
> @@ -1702,7 +1702,7 @@ static int rcar_vin_try_fmt(struct soc_camera_device *icd,
>  	const struct soc_camera_format_xlate *xlate;
>  	struct v4l2_pix_format *pix = &f->fmt.pix;
>  	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> -	struct v4l2_subdev_pad_config pad_cfg;
> +	struct v4l2_subdev_pad_config *pad_cfg = NULL;
>  	struct v4l2_subdev_format format = {
>  		.which = V4L2_SUBDEV_FORMAT_TRY,
>  	};
> @@ -1710,6 +1710,11 @@ static int rcar_vin_try_fmt(struct soc_camera_device *icd,
>  	__u32 pixfmt = pix->pixelformat;
>  	int width, height;
>  	int ret;
> +#if defined(CONFIG_MEDIA_CONTROLLER)
> +	struct media_pad *remote_pad;
> +
> +	pad_cfg = v4l2_subdev_alloc_pad_config(sd);
> +#endif
>  
>  	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
>  	if (!xlate) {
> @@ -1739,10 +1744,22 @@ static int rcar_vin_try_fmt(struct soc_camera_device *icd,
>  	mf->code = xlate->code;
>  	mf->colorspace = pix->colorspace;
>  
> -	ret = v4l2_device_call_until_err(sd->v4l2_dev, soc_camera_grp_id(icd),
> -					 pad, set_fmt, &pad_cfg, &format);
> -	if (ret < 0)
> +#if defined(CONFIG_MEDIA_CONTROLLER)
> +	remote_pad = media_entity_remote_pad(
> +				&icd->vdev->entity.pads[0]);

Can't you store this when you setup the link in soc_camera_probe_finish? Rather then
looking it up every time?

Also, I think r-car should just depend on MEDIA_CONTROLLER, rather than adding these
#ifdef's everywhere. But that's up to you.

Regards,

	Hans

> +	format.pad = remote_pad->index;
> +#endif
> +
> +	ret = v4l2_device_call_until_err(sd->v4l2_dev,
> +					soc_camera_grp_id(icd), pad,
> +					set_fmt, pad_cfg,
> +					&format);
> +	if (ret < 0) {
> +#if defined(CONFIG_MEDIA_CONTROLLER)
> +		v4l2_subdev_free_pad_config(pad_cfg);
> +#endif
>  		return ret;
> +	}
>  
>  	/* Adjust only if VIN cannot scale */
>  	if (pix->width > mf->width * 2)
> @@ -1764,13 +1781,19 @@ static int rcar_vin_try_fmt(struct soc_camera_device *icd,
>  			 */
>  			mf->width = VIN_MAX_WIDTH;
>  			mf->height = VIN_MAX_HEIGHT;
> +#if defined(CONFIG_MEDIA_CONTROLLER)
> +			format.pad = remote_pad->index;
> +#endif
>  			ret = v4l2_device_call_until_err(sd->v4l2_dev,
>  							 soc_camera_grp_id(icd),
> -							 pad, set_fmt, &pad_cfg,
> +							 pad, set_fmt, pad_cfg,
>  							 &format);
>  			if (ret < 0) {
>  				dev_err(icd->parent,
>  					"client try_fmt() = %d\n", ret);
> +#if defined(CONFIG_MEDIA_CONTROLLER)
> +				v4l2_subdev_free_pad_config(pad_cfg);
> +#endif
>  				return ret;
>  			}
>  		}
> @@ -1781,6 +1804,9 @@ static int rcar_vin_try_fmt(struct soc_camera_device *icd,
>  			pix->height = height;
>  	}
>  
> +#if defined(CONFIG_MEDIA_CONTROLLER)
> +	v4l2_subdev_free_pad_config(pad_cfg);
> +#endif
>  	return ret;
>  }
>  
> 

