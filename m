Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:62699 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711AbcAXQMI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jan 2016 11:12:08 -0500
Date: Sun, 24 Jan 2016 17:11:33 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Josh Wu <rainyfeeling@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Nicolas Ferre <nicolas.ferre@atmel.com>,
	linux-arm-kernel@lists.infradead.org,
	Ludovic Desroches <ludovic.desroches@atmel.com>,
	Songjun Wu <songjun.wu@atmel.com>, Josh Wu <josh.wu@atmel.com>
Subject: Re: [PATCH 01/13] atmel-isi: use try_or_set_fmt() for both set_fmt()
 and try_fmt()
In-Reply-To: <1453119709-20940-2-git-send-email-rainyfeeling@gmail.com>
Message-ID: <Pine.LNX.4.64.1601241552430.16570@axis700.grange>
References: <1453119709-20940-1-git-send-email-rainyfeeling@gmail.com>
 <1453119709-20940-2-git-send-email-rainyfeeling@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 18 Jan 2016, Josh Wu wrote:

> From: Josh Wu <josh.wu@atmel.com>
> 
> Since atmel-isi has similar set_fmt() and try_fmt() functions. So this
> patch will add a new function which can be called by set_fmt() and
> try_fmt().
> 
> That can increase the reusability.
> 
> Signed-off-by: Josh Wu <rainyfeeling@gmail.com>
> ---
> 
>  drivers/media/platform/soc_camera/atmel-isi.c | 105 ++++++++++----------------
>  1 file changed, 41 insertions(+), 64 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
> index c398b28..dc81df3 100644
> --- a/drivers/media/platform/soc_camera/atmel-isi.c
> +++ b/drivers/media/platform/soc_camera/atmel-isi.c
> @@ -571,16 +571,16 @@ static int isi_camera_init_videobuf(struct vb2_queue *q,
>  	return vb2_queue_init(q);
>  }
>  
> -static int isi_camera_set_fmt(struct soc_camera_device *icd,
> -			      struct v4l2_format *f)
> +static int try_or_set_fmt(struct soc_camera_device *icd,
> +		   struct v4l2_format *f,
> +		   struct v4l2_subdev_format *format)
>  {
> -	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> -	const struct soc_camera_format_xlate *xlate;
>  	struct v4l2_pix_format *pix = &f->fmt.pix;
> -	struct v4l2_subdev_format format = {
> -		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
> -	};
> -	struct v4l2_mbus_framefmt *mf = &format.format;
> +	const struct soc_camera_format_xlate *xlate;
> +	struct v4l2_subdev_pad_config pad_cfg;
> +
> +	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> +	struct v4l2_mbus_framefmt *mf = &format->format;
>  	int ret;
>  
>  	/* check with atmel-isi support format, if not support use YUYV */
> @@ -594,8 +594,11 @@ static int isi_camera_set_fmt(struct soc_camera_device *icd,
>  		return -EINVAL;

Since you're already touching this, please, also fix the "if (!xlate)" 
check in the .try_fmt() case. Basically .try_fmt() shouldn't fail because 
of unsupported parameters. If input parameters are unsupported, the driver 
should replace them with "default" or "closest" ones, at least with 
something, that is supported. For an example, please, have a look at 
sh_mobile_ceu.c or rcar_vin.c. So, once you unite .set_fmt() and 
.try_fmt() in your new try_or_set_fmt() function, you can do:

	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
	if (!xlate) {
		if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
			dev_warn(icd->parent, "Format %x not found\n",
				 pix->pixelformat);
			return -EINVAL;
		}

		/* Pick up a supported format */
		xlate = icd->current_fmt;
		pixfmt = xlate->host_fmt->fourcc;
		pix->pixelformat = pixfmt;
		pix->colorspace = icd->colorspace;
	}

if you decide to keep the current format, or pick up another 
known-supported one.

>  	}
>  
> -	dev_dbg(icd->parent, "Plan to set format %dx%d\n",
> -			pix->width, pix->height);
> +	/* limit to Atmel ISI hardware capabilities */
> +	if (pix->height > MAX_SUPPORT_HEIGHT)
> +		pix->height = MAX_SUPPORT_HEIGHT;
> +	if (pix->width > MAX_SUPPORT_WIDTH)
> +		pix->width = MAX_SUPPORT_WIDTH;

This isn't needed in the .set_fmt() case. soc-camera only calls .set_fmt() 
after having (successfully) called .try_fmt, so, sizes have already been 
adjusted. You can put this into isi_camera_try_fmt() before calling 
try_or_set_fmt().

>  
>  	mf->width	= pix->width;
>  	mf->height	= pix->height;
> @@ -603,7 +606,11 @@ static int isi_camera_set_fmt(struct soc_camera_device *icd,
>  	mf->colorspace	= pix->colorspace;
>  	mf->code	= xlate->code;
>  
> -	ret = v4l2_subdev_call(sd, pad, set_fmt, NULL, &format);
> +	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
> +		ret = v4l2_subdev_call(sd, pad, set_fmt, NULL, format);

I don't think you have to special case this just to use NULL, using 
&pad_cfg for both should work.

> +	else
> +		ret = v4l2_subdev_call(sd, pad, set_fmt, &pad_cfg, format);
> +
>  	if (ret < 0)
>  		return ret;
>  
> @@ -614,64 +621,14 @@ static int isi_camera_set_fmt(struct soc_camera_device *icd,
>  	pix->height		= mf->height;
>  	pix->field		= mf->field;
>  	pix->colorspace		= mf->colorspace;
> -	icd->current_fmt	= xlate;
> -
> -	dev_dbg(icd->parent, "Finally set format %dx%d\n",
> -		pix->width, pix->height);
> -
> -	return ret;
> -}
> -
> -static int isi_camera_try_fmt(struct soc_camera_device *icd,
> -			      struct v4l2_format *f)
> -{
> -	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> -	const struct soc_camera_format_xlate *xlate;
> -	struct v4l2_pix_format *pix = &f->fmt.pix;
> -	struct v4l2_subdev_pad_config pad_cfg;
> -	struct v4l2_subdev_format format = {
> -		.which = V4L2_SUBDEV_FORMAT_TRY,
> -	};
> -	struct v4l2_mbus_framefmt *mf = &format.format;
> -	u32 pixfmt = pix->pixelformat;
> -	int ret;
> -
> -	/* check with atmel-isi support format, if not support use YUYV */
> -	if (!is_supported(icd, pix->pixelformat))
> -		pix->pixelformat = V4L2_PIX_FMT_YUYV;
> -
> -	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
> -	if (pixfmt && !xlate) {
> -		dev_warn(icd->parent, "Format %x not found\n", pixfmt);
> -		return -EINVAL;
> -	}
>  
> -	/* limit to Atmel ISI hardware capabilities */
> -	if (pix->height > MAX_SUPPORT_HEIGHT)
> -		pix->height = MAX_SUPPORT_HEIGHT;
> -	if (pix->width > MAX_SUPPORT_WIDTH)
> -		pix->width = MAX_SUPPORT_WIDTH;
> -
> -	/* limit to sensor capabilities */
> -	mf->width	= pix->width;
> -	mf->height	= pix->height;
> -	mf->field	= pix->field;
> -	mf->colorspace	= pix->colorspace;
> -	mf->code	= xlate->code;
> -
> -	ret = v4l2_subdev_call(sd, pad, set_fmt, &pad_cfg, &format);
> -	if (ret < 0)
> -		return ret;
> -
> -	pix->width	= mf->width;
> -	pix->height	= mf->height;
> -	pix->colorspace	= mf->colorspace;
> +	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
> +		icd->current_fmt = xlate;
>  
>  	switch (mf->field) {
>  	case V4L2_FIELD_ANY:
> -		pix->field = V4L2_FIELD_NONE;
> -		break;
>  	case V4L2_FIELD_NONE:
> +		pix->field = V4L2_FIELD_NONE;
>  		break;
>  	default:
>  		dev_err(icd->parent, "Field type %d unsupported.\n",

The driver only supports progressive field order. So, I would just 
directly set .field = V4L2_FIELD_NONE before calling subdev's .set_fmt().
Then in the .set_fmt() case check, whether the subdev has changed it to 
anything else, and fail if so.

Thanks
Guennadi

> @@ -682,6 +639,26 @@ static int isi_camera_try_fmt(struct soc_camera_device *icd,
>  	return ret;
>  }
>  
> +static int isi_camera_set_fmt(struct soc_camera_device *icd,
> +			      struct v4l2_format *f)
> +{
> +	struct v4l2_subdev_format format = {
> +		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
> +	};
> +
> +	return try_or_set_fmt(icd, f, &format);
> +}
> +
> +static int isi_camera_try_fmt(struct soc_camera_device *icd,
> +			      struct v4l2_format *f)
> +{
> +	struct v4l2_subdev_format format = {
> +		.which = V4L2_SUBDEV_FORMAT_TRY,
> +	};
> +
> +	return try_or_set_fmt(icd, f, &format);
> +}
> +
>  static const struct soc_mbus_pixelfmt isi_camera_formats[] = {
>  	{
>  		.fourcc			= V4L2_PIX_FMT_YUYV,
> -- 
> 1.9.1
> 
