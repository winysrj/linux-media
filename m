Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:42669 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751110Ab0HAQsV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Aug 2010 12:48:21 -0400
Date: Sun, 1 Aug 2010 18:48:36 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Michael Grzeschik <m.grzeschik@pengutronix.de>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Robert Jarzmik <robert.jarzmik@free.fr>, p.wiesner@phytec.de
Subject: Re: [PATCH 11/20] mt9m111: added mt9m111 format structure
In-Reply-To: <1280501618-23634-12-git-send-email-m.grzeschik@pengutronix.de>
Message-ID: <Pine.LNX.4.64.1008011843310.1909@axis700.grange>
References: <1280501618-23634-1-git-send-email-m.grzeschik@pengutronix.de>
 <1280501618-23634-12-git-send-email-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 30 Jul 2010, Michael Grzeschik wrote:

> removed unused rect and fmt structs from mt9m111 struct

Don't understand. Both rect and fmt do seem to be used to me. If they were 
unused, you could have _just_ removed them. Instead you add a new struct 
mt9m111_format. Why? So, I don't understand this patch. If you find some 
unused data / code - it is ok to remove it, this is one patch. If you want 
to change default data format:

> set default values for mf.colorspace and mf.code to the common raw
> format V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE.

This is a separate patch too. From this patch description I don't 
understand how these two changes are connected and why you need them and 
why you put them in one patch.

Thanks
Guennadi

> 
> rewrote following functions to make use the new format structure:
> 
> * restore_state,
> * g_fmt,
> * s_fmt,
> * g_crop,
> * s_crop,
> * setup_rect
> 
> Signed-off-by: Philipp Wiesner <p.wiesner@phytec.de>
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> ---
>  drivers/media/video/mt9m111.c |   99 ++++++++++++++++++++++-------------------
>  1 files changed, 53 insertions(+), 46 deletions(-)
> 
> diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
> index db5ac32..cc0f996 100644
> --- a/drivers/media/video/mt9m111.c
> +++ b/drivers/media/video/mt9m111.c
> @@ -173,13 +173,17 @@ enum mt9m111_context {
>  	LOWPOWER,
>  };
>  
> +struct mt9m111_format {
> +     struct v4l2_rect rect;
> +     struct v4l2_mbus_framefmt mf;
> +};
> +
>  struct mt9m111 {
>  	struct v4l2_subdev subdev;
>  	int model;	/* V4L2_IDENT_MT9M111 or V4L2_IDENT_MT9M112 code */
>  			/* from v4l2-chip-ident.h */
>  	enum mt9m111_context context;
> -	struct v4l2_rect rect;
> -	const struct mt9m111_datafmt *fmt;
> +	struct mt9m111_format format;
>  	unsigned int gain;
>  	unsigned char autoexposure;
>  	unsigned char datawidth;
> @@ -278,15 +282,15 @@ static int mt9m111_set_context(struct i2c_client *client,
>  }
>  
>  static int mt9m111_setup_rect(struct i2c_client *client,
> -			      struct v4l2_rect *rect)
> +			      struct mt9m111_format *format)
>  {
> -	struct mt9m111 *mt9m111 = to_mt9m111(client);
> +	struct v4l2_rect *rect = &format->rect;
>  	int ret, is_raw_format;
>  	int width = rect->width;
>  	int height = rect->height;
>  
> -	if (mt9m111->fmt->code == V4L2_MBUS_FMT_SBGGR8_1X8 ||
> -	    mt9m111->fmt->code == V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE)
> +	if (format->mf.code == V4L2_MBUS_FMT_SBGGR8_1X8 ||
> +	    format->mf.code == V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE)
>  		is_raw_format = 1;
>  	else
>  		is_raw_format = 0;
> @@ -425,10 +429,10 @@ static int mt9m111_set_bus_param(struct soc_camera_device *icd, unsigned long f)
>  }
>  
>  static int mt9m111_make_rect(struct i2c_client *client,
> -			     struct v4l2_rect *rect)
> +			     struct mt9m111_format *format)
>  {
> -	struct mt9m111 *mt9m111 = to_mt9m111(client);
> -	enum v4l2_mbus_pixelcode code = mt9m111->fmt->code;
> +	struct v4l2_rect *rect = &format->rect;
> +	enum v4l2_mbus_pixelcode code = format->mf.code;
>  
>  	/* FIXME: the datasheet doesn't specify minimum sizes */
>  	soc_camera_limit_side(&rect->left, &rect->width,
> @@ -459,22 +463,30 @@ static int mt9m111_make_rect(struct i2c_client *client,
>  		"mf: pixelcode=%d\n", __func__, rect->left, rect->top,
>  		rect->width, rect->height, code);
>  
> -	return mt9m111_setup_rect(client, rect);
> +	return mt9m111_setup_rect(client, format);
>  }
>  
>  static int mt9m111_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
>  {
> -	struct v4l2_rect rect = a->c;
>  	struct i2c_client *client = sd->priv;
>  	struct mt9m111 *mt9m111 = to_mt9m111(client);
> +	struct mt9m111_format format;
> +	struct v4l2_mbus_framefmt *mf = &format.mf;
>  	int ret;
>  
> -	dev_dbg(&client->dev, "%s left=%d, top=%d, width=%d, height=%d\n",
> -		__func__, rect.left, rect.top, rect.width, rect.height);
> +	format.rect	= a->c;
> +	format.mf	= mt9m111->format.mf;
> +
> +	dev_dbg(&client->dev, "%s: rect: left=%d top=%d width=%d height=%d\n",
> +		__func__, a->c.left, a->c.top, a->c.width, a->c.height);
> +	dev_dbg(&client->dev, "%s: mf: width=%d height=%d pixelcode=%d "
> +		"field=%x colorspace=%x\n", __func__, mf->width, mf->height,
> +		mf->code, mf->field, mf->colorspace);
>  
> -	ret = mt9m111_make_rect(client, &rect);
> +	ret = mt9m111_make_rect(client, &format);
>  	if (!ret)
> -		mt9m111->rect = rect;
> +		mt9m111->format = format;
> +
>  	return ret;
>  }
>  
> @@ -483,7 +495,7 @@ static int mt9m111_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
>  	struct i2c_client *client = sd->priv;
>  	struct mt9m111 *mt9m111 = to_mt9m111(client);
>  
> -	a->c	= mt9m111->rect;
> +	a->c	= mt9m111->format.rect;
>  	a->type	= V4L2_BUF_TYPE_VIDEO_CAPTURE;
>  
>  	return 0;
> @@ -514,10 +526,7 @@ static int mt9m111_g_fmt(struct v4l2_subdev *sd,
>  	struct i2c_client *client = sd->priv;
>  	struct mt9m111 *mt9m111 = to_mt9m111(client);
>  
> -	mf->width	= mt9m111->rect.width;
> -	mf->height	= mt9m111->rect.height;
> -	mf->code	= mt9m111->fmt->code;
> -	mf->field	= V4L2_FIELD_NONE;
> +	*mf = mt9m111->format.mf;
>  
>  	return 0;
>  }
> @@ -576,12 +585,8 @@ static int mt9m111_s_fmt(struct v4l2_subdev *sd,
>  	struct i2c_client *client = sd->priv;
>  	const struct mt9m111_datafmt *fmt;
>  	struct mt9m111 *mt9m111 = to_mt9m111(client);
> -	struct v4l2_rect rect = {
> -		.left	= mt9m111->rect.left,
> -		.top	= mt9m111->rect.top,
> -		.width	= mf->width,
> -		.height	= mf->height,
> -	};
> +	struct v4l2_rect *rect;
> +	struct mt9m111_format format;
>  	int ret;
>  
>  	fmt = mt9m111_find_datafmt(mf->code, mt9m111_colour_fmts,
> @@ -589,18 +594,19 @@ static int mt9m111_s_fmt(struct v4l2_subdev *sd,
>  	if (!fmt)
>  		return -EINVAL;
>  
> +	format.rect	= mt9m111->format.rect;
> +	format.mf	= *mf;
> +	rect		= &format.rect;
> +
>  	dev_dbg(&client->dev,
>  		"%s code=%x left=%d, top=%d, width=%d, height=%d\n", __func__,
> -		mf->code, rect.left, rect.top, rect.width, rect.height);
> +		mf->code, rect->left, rect->top, rect->width, rect->height);
>  
> -	ret = mt9m111_make_rect(client, &rect);
> +	ret = mt9m111_make_rect(client, &format);
>  	if (!ret)
> -		ret = mt9m111_set_pixfmt(client, mf->code);
> -	if (!ret) {
> -		mt9m111->rect	= rect;
> -		mt9m111->fmt	= fmt;
> -		mf->colorspace	= fmt->colorspace;
> -	}
> +		ret = mt9m111_set_pixfmt(client, format.mf.code);
> +	if (!ret)
> +		mt9m111->format = format;
>  
>  	return ret;
>  }
> @@ -609,17 +615,14 @@ static int mt9m111_try_fmt(struct v4l2_subdev *sd,
>  			   struct v4l2_mbus_framefmt *mf)
>  {
>  	struct i2c_client *client = sd->priv;
> -	struct mt9m111 *mt9m111 = to_mt9m111(client);
>  	const struct mt9m111_datafmt *fmt;
>  	bool bayer = mf->code == V4L2_MBUS_FMT_SBGGR8_1X8 ||
>  		mf->code == V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE;
>  
>  	fmt = mt9m111_find_datafmt(mf->code, mt9m111_colour_fmts,
>  				   ARRAY_SIZE(mt9m111_colour_fmts));
> -	if (!fmt) {
> -		fmt = mt9m111->fmt;
> -		mf->code = fmt->code;
> -	}
> +	if (!fmt)
> +		return -EINVAL;
>  
>  	/*
>  	 * With Bayer format enforce even side lengths, but let the user play
> @@ -930,8 +933,8 @@ static int mt9m111_restore_state(struct i2c_client *client)
>  	struct mt9m111 *mt9m111 = to_mt9m111(client);
>  
>  	mt9m111_set_context(client, mt9m111->context);
> -	mt9m111_set_pixfmt(client, mt9m111->fmt->code);
> -	mt9m111_setup_rect(client, &mt9m111->rect);
> +	mt9m111_set_pixfmt(client, mt9m111->format.mf.code);
> +	mt9m111_setup_rect(client, &mt9m111->format);
>  	mt9m111_set_flip(client, mt9m111->hflip, MT9M111_RMB_MIRROR_COLS);
>  	mt9m111_set_flip(client, mt9m111->vflip, MT9M111_RMB_MIRROR_ROWS);
>  	mt9m111_set_global_gain(client, mt9m111->gain);
> @@ -1096,11 +1099,15 @@ static int mt9m111_probe(struct i2c_client *client,
>  	/* Second stage probe - when a capture adapter is there */
>  	icd->ops		= &mt9m111_ops;
>  
> -	mt9m111->rect.left	= MT9M111_MIN_DARK_COLS;
> -	mt9m111->rect.top	= MT9M111_MIN_DARK_ROWS;
> -	mt9m111->rect.width	= MT9M111_MAX_WIDTH;
> -	mt9m111->rect.height	= MT9M111_MAX_HEIGHT;
> -	mt9m111->fmt		= &mt9m111_colour_fmts[0];
> +	mt9m111->format.rect.left       = MT9M111_DEF_DARK_COLS;
> +	mt9m111->format.rect.top        = MT9M111_DEF_DARK_ROWS;
> +	mt9m111->format.rect.width      = MT9M111_DEF_WIDTH;
> +	mt9m111->format.rect.height     = MT9M111_DEF_HEIGHT;
> +	mt9m111->format.mf.width        = MT9M111_DEF_WIDTH;
> +	mt9m111->format.mf.height       = MT9M111_DEF_HEIGHT;
> +	mt9m111->format.mf.code         = mt9m111_colour_fmts[2].code;
> +	mt9m111->format.mf.field        = V4L2_FIELD_NONE;
> +	mt9m111->format.mf.colorspace   = mt9m111_colour_fmts[2].colorspace;
>  
>  	ret = mt9m111_video_probe(icd, client);
>  	if (ret) {
> -- 
> 1.7.1
> 
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
