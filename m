Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:46055 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752913Ab0DVIuT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Apr 2010 04:50:19 -0400
Date: Thu, 22 Apr 2010 10:50:20 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Valentin Longchamp <valentin.longchamp@epfl.ch>
Subject: Re: [PATCH] mt9t031: preserve output format on VIDIOC_S_CROP
In-Reply-To: <Pine.LNX.4.64.1004141605110.9388@axis700.grange>
Message-ID: <Pine.LNX.4.64.1004221048420.4655@axis700.grange>
References: <Pine.LNX.4.64.1004141605110.9388@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 14 Apr 2010, Guennadi Liakhovetski wrote:

> Interpretation of the V4L2 API specification, according to which the 
> VIDIOC_S_CROP ioctl for capture devices shall set the input window and 
> preserve the scales, thus possibly changing the output window, seems to be 
> incorrect. Switch to using a more intuitive definition, i.e., to 
> preserving the output format while changing scales.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
> 
> Val, I do not have any mt9t031 hardware any more, could you, please, test 
> this patch and verify, that it does indeed do, what's described above?

There hasn't been any replies to this, so, I presume, this patch cannot be 
tested at present. Therefore I'm going to leave it out of my pull requests 
until it gets tested somehow.

Thanks
Guennadi

> 
> diff --git a/drivers/media/video/mt9t031.c b/drivers/media/video/mt9t031.c
> index a9061bf..a604fa0 100644
> --- a/drivers/media/video/mt9t031.c
> +++ b/drivers/media/video/mt9t031.c
> @@ -63,6 +63,8 @@
>  struct mt9t031 {
>  	struct v4l2_subdev subdev;
>  	struct v4l2_rect rect;	/* Sensor window */
> +	unsigned int out_width;
> +	unsigned int out_height;
>  	int model;	/* V4L2_IDENT_MT9T031* codes from v4l2-chip-ident.h */
>  	u16 xskip;
>  	u16 yskip;
> @@ -284,6 +286,26 @@ static u16 mt9t031_skip(s32 *source, s32 target, s32 max)
>  	return skip;
>  }
>  
> +static u16 mt9t031_skip_out(s32 *source, s32 *target)
> +{
> +	unsigned int skip;
> +
> +	if (*source < *target + *target / 2) {
> +		*target = *source;
> +		return 1;
> +	}
> +
> +	skip = (*source + *target / 2) / *target;
> +	if (skip > 8) {
> +		skip = 8;
> +		*target = (*source + 4) / 8;
> +	}
> +	/* We try to preserve input, but with division we have to adjust it too */
> +	*source = *target * skip;
> +
> +	return skip;
> +}
> +
>  /* rect is the sensor rectangle, the caller guarantees parameter validity */
>  static int mt9t031_set_params(struct i2c_client *client,
>  			      struct v4l2_rect *rect, u16 xskip, u16 yskip)
> @@ -393,6 +415,7 @@ static int mt9t031_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
>  	struct v4l2_rect rect = a->c;
>  	struct i2c_client *client = sd->priv;
>  	struct mt9t031 *mt9t031 = to_mt9t031(client);
> +	u16 xskip, yskip;
>  
>  	rect.width = ALIGN(rect.width, 2);
>  	rect.height = ALIGN(rect.height, 2);
> @@ -403,7 +426,10 @@ static int mt9t031_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
>  	soc_camera_limit_side(&rect.top, &rect.height,
>  		     MT9T031_ROW_SKIP, MT9T031_MIN_HEIGHT, MT9T031_MAX_HEIGHT);
>  
> -	return mt9t031_set_params(client, &rect, mt9t031->xskip, mt9t031->yskip);
> +	xskip = mt9t031_skip_out(&rect.width, &mt9t031->out_width);
> +	yskip = mt9t031_skip_out(&rect.height, &mt9t031->out_height);
> +
> +	return mt9t031_set_params(client, &rect, xskip, yskip);
>  }
>  
>  static int mt9t031_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
> @@ -437,8 +463,8 @@ static int mt9t031_g_fmt(struct v4l2_subdev *sd,
>  	struct i2c_client *client = sd->priv;
>  	struct mt9t031 *mt9t031 = to_mt9t031(client);
>  
> -	mf->width	= mt9t031->rect.width / mt9t031->xskip;
> -	mf->height	= mt9t031->rect.height / mt9t031->yskip;
> +	mf->width	= mt9t031->out_width;
> +	mf->height	= mt9t031->out_height;
>  	mf->code	= V4L2_MBUS_FMT_SBGGR10_1X10;
>  	mf->colorspace	= V4L2_COLORSPACE_SRGB;
>  	mf->field	= V4L2_FIELD_NONE;
> @@ -455,8 +481,9 @@ static int mt9t031_s_fmt(struct v4l2_subdev *sd,
>  	struct v4l2_rect rect = mt9t031->rect;
>  
>  	/*
> -	 * try_fmt has put width and height within limits.
> -	 * S_FMT: use binning and skipping for scaling
> +	 * try_fmt has put width and height within limits. Note: when converting
> +	 * to a generic v4l2-subdev driver, try_fmt will have to be called
> +	 * explicitly. S_FMT: use binning and skipping for scaling.
>  	 */
>  	xskip = mt9t031_skip(&rect.width, mf->width, MT9T031_MAX_WIDTH);
>  	yskip = mt9t031_skip(&rect.height, mf->height, MT9T031_MAX_HEIGHT);
> @@ -464,6 +491,9 @@ static int mt9t031_s_fmt(struct v4l2_subdev *sd,
>  	mf->code	= V4L2_MBUS_FMT_SBGGR10_1X10;
>  	mf->colorspace	= V4L2_COLORSPACE_SRGB;
>  
> +	mt9t031->out_width	= mf->width;
> +	mt9t031->out_height	= mf->height;
> +
>  	/* mt9t031_set_params() doesn't change width and height */
>  	return mt9t031_set_params(client, &rect, xskip, yskip);
>  }
> @@ -807,6 +837,9 @@ static int mt9t031_probe(struct i2c_client *client,
>  	mt9t031->rect.width	= MT9T031_MAX_WIDTH;
>  	mt9t031->rect.height	= MT9T031_MAX_HEIGHT;
>  
> +	mt9t031->out_width	= MT9T031_MAX_WIDTH;
> +	mt9t031->out_height	= MT9T031_MAX_HEIGHT;
> +
>  	/*
>  	 * Simulated autoexposure. If enabled, we calculate shutter width
>  	 * ourselves in the driver based on vertical blanking and frame width
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
