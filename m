Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:63498 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791AbbEBR53 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 2 May 2015 13:57:29 -0400
Date: Sat, 2 May 2015 19:57:18 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Kamil Debski <k.debski@samsung.com>
Subject: Re: [PATCH 3/7] v4l2: replace try_mbus_fmt by set_fmt
In-Reply-To: <1428574888-46407-4-git-send-email-hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1505021902220.28045@axis700.grange>
References: <1428574888-46407-1-git-send-email-hverkuil@xs4all.nl>
 <1428574888-46407-4-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch! As already discussed on IRC, I realise, that this 
patch has already been merged. Sorry, didn't have the time to review it 
earlier. I'll provide some comments below, maybe someone decides to use 
them to improve respective locations.

On Thu, 9 Apr 2015, Hans Verkuil wrote:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The try_mbus_fmt video op is a duplicate of the pad op. Replace all uses
> in sub-devices by the set_fmt() pad op.
> 
> Since try_mbus_fmt and s_mbus_fmt both map to the set_fmt pad op (but
> with a different 'which' argument), this patch will replace both try_mbus_fmt
> and s_mbus_fmt by set_fmt.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Kamil Debski <k.debski@samsung.com>
> ---
>  drivers/media/i2c/adv7183.c                        | 36 ++++++++--------
>  drivers/media/i2c/mt9v011.c                        | 38 ++++++++---------
>  drivers/media/i2c/ov7670.c                         | 27 +++++++-----
>  drivers/media/i2c/saa6752hs.c                      | 28 +++++++------
>  drivers/media/i2c/soc_camera/imx074.c              | 39 ++++++++----------
>  drivers/media/i2c/soc_camera/mt9m001.c             | 17 +++++---
>  drivers/media/i2c/soc_camera/mt9m111.c             | 31 ++++++--------
>  drivers/media/i2c/soc_camera/mt9t031.c             | 48 +++++++++++-----------
>  drivers/media/i2c/soc_camera/mt9t112.c             | 15 +++++--
>  drivers/media/i2c/soc_camera/mt9v022.c             | 17 +++++---
>  drivers/media/i2c/soc_camera/ov2640.c              | 36 +++++-----------
>  drivers/media/i2c/soc_camera/ov5642.c              | 34 +++++++--------
>  drivers/media/i2c/soc_camera/ov6650.c              | 17 +++++---
>  drivers/media/i2c/soc_camera/ov772x.c              | 15 +++++--
>  drivers/media/i2c/soc_camera/ov9640.c              | 17 ++++++--
>  drivers/media/i2c/soc_camera/ov9740.c              | 16 ++++++--
>  drivers/media/i2c/soc_camera/rj54n1cb0c.c          | 40 +++++++-----------
>  drivers/media/i2c/soc_camera/tw9910.c              | 15 +++++--
>  drivers/media/i2c/sr030pc30.c                      | 38 ++++++++---------
>  drivers/media/i2c/vs6624.c                         | 28 ++++++-------
>  drivers/media/platform/soc_camera/sh_mobile_csi2.c | 35 ++++++++--------
>  21 files changed, 304 insertions(+), 283 deletions(-)

[snip]

> diff --git a/drivers/media/i2c/soc_camera/imx074.c b/drivers/media/i2c/soc_camera/imx074.c
> index ba60ccf..f68c235 100644
> --- a/drivers/media/i2c/soc_camera/imx074.c
> +++ b/drivers/media/i2c/soc_camera/imx074.c
> @@ -153,14 +153,24 @@ static int reg_read(struct i2c_client *client, const u16 addr)
>  	return buf[0] & 0xff; /* no sign-extension */
>  }
>  
> -static int imx074_try_fmt(struct v4l2_subdev *sd,
> -			  struct v4l2_mbus_framefmt *mf)
> +static int imx074_set_fmt(struct v4l2_subdev *sd,
> +		struct v4l2_subdev_pad_config *cfg,
> +		struct v4l2_subdev_format *format)
>  {
> +	struct v4l2_mbus_framefmt *mf = &format->format;
>  	const struct imx074_datafmt *fmt = imx074_find_datafmt(mf->code);
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	struct imx074 *priv = to_imx074(client);
> +
> +	if (format->pad)
> +		return -EINVAL;
>  
>  	dev_dbg(sd->v4l2_dev->dev, "%s(%u)\n", __func__, mf->code);
>  
>  	if (!fmt) {
> +		/* MIPI CSI could have changed the format, double-check */
> +		if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
> +			return -EINVAL;
>  		mf->code	= imx074_colour_fmts[0].code;
>  		mf->colorspace	= imx074_colour_fmts[0].colorspace;
>  	}
> @@ -169,24 +179,10 @@ static int imx074_try_fmt(struct v4l2_subdev *sd,
>  	mf->height	= IMX074_HEIGHT;
>  	mf->field	= V4L2_FIELD_NONE;
>  
> -	return 0;
> -}
> -
> -static int imx074_s_fmt(struct v4l2_subdev *sd,
> -			struct v4l2_mbus_framefmt *mf)
> -{
> -	struct i2c_client *client = v4l2_get_subdevdata(sd);
> -	struct imx074 *priv = to_imx074(client);
> -
> -	dev_dbg(sd->v4l2_dev->dev, "%s(%u)\n", __func__, mf->code);
> -
> -	/* MIPI CSI could have changed the format, double-check */
> -	if (!imx074_find_datafmt(mf->code))
> -		return -EINVAL;
> -
> -	imx074_try_fmt(sd, mf);
> -
> -	priv->fmt = imx074_find_datafmt(mf->code);
> +	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
> +		priv->fmt = imx074_find_datafmt(mf->code);

Called imx074_find_datafmt() above already, can just reuse fmt, right?

> +	else
> +		cfg->try_fmt = *mf;
>  
>  	return 0;
>  }
> @@ -282,8 +278,6 @@ static int imx074_g_mbus_config(struct v4l2_subdev *sd,
>  
>  static struct v4l2_subdev_video_ops imx074_subdev_video_ops = {
>  	.s_stream	= imx074_s_stream,
> -	.s_mbus_fmt	= imx074_s_fmt,
> -	.try_mbus_fmt	= imx074_try_fmt,
>  	.g_crop		= imx074_g_crop,
>  	.cropcap	= imx074_cropcap,
>  	.g_mbus_config	= imx074_g_mbus_config,
> @@ -296,6 +290,7 @@ static struct v4l2_subdev_core_ops imx074_subdev_core_ops = {
>  static const struct v4l2_subdev_pad_ops imx074_subdev_pad_ops = {
>  	.enum_mbus_code = imx074_enum_mbus_code,
>  	.get_fmt	= imx074_get_fmt,
> +	.set_fmt	= imx074_set_fmt,
>  };
>  
>  static struct v4l2_subdev_ops imx074_subdev_ops = {
> diff --git a/drivers/media/i2c/soc_camera/mt9m001.c b/drivers/media/i2c/soc_camera/mt9m001.c
> index 06f4e11..4fbdd1e 100644
> --- a/drivers/media/i2c/soc_camera/mt9m001.c
> +++ b/drivers/media/i2c/soc_camera/mt9m001.c
> @@ -205,7 +205,7 @@ static int mt9m001_s_crop(struct v4l2_subdev *sd, const struct v4l2_crop *a)
>  
>  	/*
>  	 * The caller provides a supported format, as verified per
> -	 * call to .try_mbus_fmt()
> +	 * call to .set_fmt(FORMAT_TRY).
>  	 */
>  	if (!ret)
>  		ret = reg_write(client, MT9M001_COLUMN_START, rect.left);
> @@ -298,13 +298,18 @@ static int mt9m001_s_fmt(struct v4l2_subdev *sd,
>  	return ret;
>  }
>  
> -static int mt9m001_try_fmt(struct v4l2_subdev *sd,
> -			   struct v4l2_mbus_framefmt *mf)
> +static int mt9m001_set_fmt(struct v4l2_subdev *sd,
> +		struct v4l2_subdev_pad_config *cfg,
> +		struct v4l2_subdev_format *format)
>  {
> +	struct v4l2_mbus_framefmt *mf = &format->format;
>  	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct mt9m001 *mt9m001 = to_mt9m001(client);
>  	const struct mt9m001_datafmt *fmt;
>  
> +	if (format->pad)
> +		return -EINVAL;
> +
>  	v4l_bound_align_image(&mf->width, MT9M001_MIN_WIDTH,
>  		MT9M001_MAX_WIDTH, 1,
>  		&mf->height, MT9M001_MIN_HEIGHT + mt9m001->y_skip_top,
> @@ -322,6 +327,9 @@ static int mt9m001_try_fmt(struct v4l2_subdev *sd,
>  
>  	mf->colorspace	= fmt->colorspace;
>  
> +	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
> +		return mt9m001_s_fmt(sd, mf);

mt9m001_find_datafmt() will be called twice now.

> +	cfg->try_fmt = *mf;
>  	return 0;
>  }
>  
> @@ -617,8 +625,6 @@ static int mt9m001_s_mbus_config(struct v4l2_subdev *sd,
>  
>  static struct v4l2_subdev_video_ops mt9m001_subdev_video_ops = {
>  	.s_stream	= mt9m001_s_stream,
> -	.s_mbus_fmt	= mt9m001_s_fmt,
> -	.try_mbus_fmt	= mt9m001_try_fmt,
>  	.s_crop		= mt9m001_s_crop,
>  	.g_crop		= mt9m001_g_crop,
>  	.cropcap	= mt9m001_cropcap,
> @@ -633,6 +639,7 @@ static struct v4l2_subdev_sensor_ops mt9m001_subdev_sensor_ops = {
>  static const struct v4l2_subdev_pad_ops mt9m001_subdev_pad_ops = {
>  	.enum_mbus_code = mt9m001_enum_mbus_code,
>  	.get_fmt	= mt9m001_get_fmt,
> +	.set_fmt	= mt9m001_set_fmt,
>  };
>  
>  static struct v4l2_subdev_ops mt9m001_subdev_ops = {

[snip]

> diff --git a/drivers/media/i2c/soc_camera/mt9t112.c b/drivers/media/i2c/soc_camera/mt9t112.c
> index 889e98e..de10a76 100644
> --- a/drivers/media/i2c/soc_camera/mt9t112.c
> +++ b/drivers/media/i2c/soc_camera/mt9t112.c
> @@ -945,14 +945,19 @@ static int mt9t112_s_fmt(struct v4l2_subdev *sd,
>  	return ret;
>  }
>  
> -static int mt9t112_try_fmt(struct v4l2_subdev *sd,
> -			   struct v4l2_mbus_framefmt *mf)
> +static int mt9t112_set_fmt(struct v4l2_subdev *sd,
> +		struct v4l2_subdev_pad_config *cfg,
> +		struct v4l2_subdev_format *format)
>  {
> +	struct v4l2_mbus_framefmt *mf = &format->format;
>  	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct mt9t112_priv *priv = to_mt9t112(client);
>  	unsigned int top, left;
>  	int i;
>  
> +	if (format->pad)
> +		return -EINVAL;
> +
>  	for (i = 0; i < priv->num_formats; i++)
>  		if (mt9t112_cfmts[i].code == mf->code)
>  			break;
> @@ -968,6 +973,9 @@ static int mt9t112_try_fmt(struct v4l2_subdev *sd,
>  
>  	mf->field = V4L2_FIELD_NONE;
>  
> +	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
> +		return mt9t112_s_fmt(sd, mf);

Now mt9t112_frame_check() will be called twice in the .s_mbus_fmt() case.

> +	cfg->try_fmt = *mf;
>  	return 0;
>  }
>  
> @@ -1016,8 +1024,6 @@ static int mt9t112_s_mbus_config(struct v4l2_subdev *sd,
>  
>  static struct v4l2_subdev_video_ops mt9t112_subdev_video_ops = {
>  	.s_stream	= mt9t112_s_stream,
> -	.s_mbus_fmt	= mt9t112_s_fmt,
> -	.try_mbus_fmt	= mt9t112_try_fmt,
>  	.cropcap	= mt9t112_cropcap,
>  	.g_crop		= mt9t112_g_crop,
>  	.s_crop		= mt9t112_s_crop,
> @@ -1028,6 +1034,7 @@ static struct v4l2_subdev_video_ops mt9t112_subdev_video_ops = {
>  static const struct v4l2_subdev_pad_ops mt9t112_subdev_pad_ops = {
>  	.enum_mbus_code = mt9t112_enum_mbus_code,
>  	.get_fmt	= mt9t112_get_fmt,
> +	.set_fmt	= mt9t112_set_fmt,
>  };
>  
>  /************************************************************************
> diff --git a/drivers/media/i2c/soc_camera/mt9v022.c b/drivers/media/i2c/soc_camera/mt9v022.c
> index b4ba3c5..f313774 100644
> --- a/drivers/media/i2c/soc_camera/mt9v022.c
> +++ b/drivers/media/i2c/soc_camera/mt9v022.c
> @@ -412,7 +412,7 @@ static int mt9v022_s_fmt(struct v4l2_subdev *sd,
>  
>  	/*
>  	 * The caller provides a supported format, as verified per call to
> -	 * .try_mbus_fmt(), datawidth is from our supported format list
> +	 * .set_fmt(FORMAT_TRY), datawidth is from our supported format list
>  	 */
>  	switch (mf->code) {
>  	case MEDIA_BUS_FMT_Y8_1X8:
> @@ -442,15 +442,20 @@ static int mt9v022_s_fmt(struct v4l2_subdev *sd,
>  	return ret;
>  }
>  
> -static int mt9v022_try_fmt(struct v4l2_subdev *sd,
> -			   struct v4l2_mbus_framefmt *mf)
> +static int mt9v022_set_fmt(struct v4l2_subdev *sd,
> +		struct v4l2_subdev_pad_config *cfg,
> +		struct v4l2_subdev_format *format)
>  {
> +	struct v4l2_mbus_framefmt *mf = &format->format;
>  	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct mt9v022 *mt9v022 = to_mt9v022(client);
>  	const struct mt9v022_datafmt *fmt;
>  	int align = mf->code == MEDIA_BUS_FMT_SBGGR8_1X8 ||
>  		mf->code == MEDIA_BUS_FMT_SBGGR10_1X10;
>  
> +	if (format->pad)
> +		return -EINVAL;
> +
>  	v4l_bound_align_image(&mf->width, MT9V022_MIN_WIDTH,
>  		MT9V022_MAX_WIDTH, align,
>  		&mf->height, MT9V022_MIN_HEIGHT + mt9v022->y_skip_top,
> @@ -465,6 +470,9 @@ static int mt9v022_try_fmt(struct v4l2_subdev *sd,
>  
>  	mf->colorspace	= fmt->colorspace;
>  
> +	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
> +		return mt9v022_s_fmt(sd, mf);

mt9v022_find_datafmt() will be called twice now.

> +	cfg->try_fmt = *mf;
>  	return 0;
>  }
>  
> @@ -845,8 +853,6 @@ static int mt9v022_s_mbus_config(struct v4l2_subdev *sd,
>  
>  static struct v4l2_subdev_video_ops mt9v022_subdev_video_ops = {
>  	.s_stream	= mt9v022_s_stream,
> -	.s_mbus_fmt	= mt9v022_s_fmt,
> -	.try_mbus_fmt	= mt9v022_try_fmt,
>  	.s_crop		= mt9v022_s_crop,
>  	.g_crop		= mt9v022_g_crop,
>  	.cropcap	= mt9v022_cropcap,
> @@ -861,6 +867,7 @@ static struct v4l2_subdev_sensor_ops mt9v022_subdev_sensor_ops = {
>  static const struct v4l2_subdev_pad_ops mt9v022_subdev_pad_ops = {
>  	.enum_mbus_code = mt9v022_enum_mbus_code,
>  	.get_fmt	= mt9v022_get_fmt,
> +	.set_fmt	= mt9v022_set_fmt,
>  };
>  
>  static struct v4l2_subdev_ops mt9v022_subdev_ops = {
> diff --git a/drivers/media/i2c/soc_camera/ov2640.c b/drivers/media/i2c/soc_camera/ov2640.c
> index 0dffc63..9b4f5de 100644
> --- a/drivers/media/i2c/soc_camera/ov2640.c
> +++ b/drivers/media/i2c/soc_camera/ov2640.c
> @@ -881,33 +881,16 @@ static int ov2640_get_fmt(struct v4l2_subdev *sd,
>  	return 0;
>  }
>  
> -static int ov2640_s_fmt(struct v4l2_subdev *sd,
> -			struct v4l2_mbus_framefmt *mf)
> +static int ov2640_set_fmt(struct v4l2_subdev *sd,
> +		struct v4l2_subdev_pad_config *cfg,
> +		struct v4l2_subdev_format *format)
>  {
> +	struct v4l2_mbus_framefmt *mf = &format->format;
>  	struct i2c_client *client = v4l2_get_subdevdata(sd);
> -	int ret;
> -
>  
> -	switch (mf->code) {
> -	case MEDIA_BUS_FMT_RGB565_2X8_BE:
> -	case MEDIA_BUS_FMT_RGB565_2X8_LE:
> -		mf->colorspace = V4L2_COLORSPACE_SRGB;
> -		break;
> -	default:
> -		mf->code = MEDIA_BUS_FMT_UYVY8_2X8;
> -	case MEDIA_BUS_FMT_YUYV8_2X8:
> -	case MEDIA_BUS_FMT_UYVY8_2X8:
> -		mf->colorspace = V4L2_COLORSPACE_JPEG;
> -	}
> -
> -	ret = ov2640_set_params(client, &mf->width, &mf->height, mf->code);
> -
> -	return ret;
> -}
> +	if (format->pad)
> +		return -EINVAL;
>  
> -static int ov2640_try_fmt(struct v4l2_subdev *sd,
> -			  struct v4l2_mbus_framefmt *mf)
> -{
>  	/*
>  	 * select suitable win, but don't store it
>  	 */
> @@ -927,6 +910,10 @@ static int ov2640_try_fmt(struct v4l2_subdev *sd,
>  		mf->colorspace = V4L2_COLORSPACE_JPEG;
>  	}
>  
> +	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
> +		return ov2640_set_params(client, &mf->width,
> +					 &mf->height, mf->code);
> +	cfg->try_fmt = *mf;

I think this can be improved a bit. Above in the former ov2640_try_fmt(), 
ov2640_select_win() is called, now for the .s_mbus_fmt() functionality we 
call ov2640_set_params(), which calls ov2640_select_win() too. This could 
be optimised, but feel free to postpone for an optional future 
incremental patch, if you don't want to be bothered.

>  	return 0;
>  }
>  
> @@ -1037,8 +1024,6 @@ static int ov2640_g_mbus_config(struct v4l2_subdev *sd,
>  
>  static struct v4l2_subdev_video_ops ov2640_subdev_video_ops = {
>  	.s_stream	= ov2640_s_stream,
> -	.s_mbus_fmt	= ov2640_s_fmt,
> -	.try_mbus_fmt	= ov2640_try_fmt,
>  	.cropcap	= ov2640_cropcap,
>  	.g_crop		= ov2640_g_crop,
>  	.g_mbus_config	= ov2640_g_mbus_config,
> @@ -1047,6 +1032,7 @@ static struct v4l2_subdev_video_ops ov2640_subdev_video_ops = {
>  static const struct v4l2_subdev_pad_ops ov2640_subdev_pad_ops = {
>  	.enum_mbus_code = ov2640_enum_mbus_code,
>  	.get_fmt	= ov2640_get_fmt,
> +	.set_fmt	= ov2640_set_fmt,
>  };
>  
>  static struct v4l2_subdev_ops ov2640_subdev_ops = {
> diff --git a/drivers/media/i2c/soc_camera/ov5642.c b/drivers/media/i2c/soc_camera/ov5642.c
> index a88397f..bab9ac0 100644
> --- a/drivers/media/i2c/soc_camera/ov5642.c
> +++ b/drivers/media/i2c/soc_camera/ov5642.c
> @@ -786,39 +786,34 @@ static int ov5642_set_resolution(struct v4l2_subdev *sd)
>  	return ret;
>  }
>  
> -static int ov5642_try_fmt(struct v4l2_subdev *sd,
> -			  struct v4l2_mbus_framefmt *mf)
> +static int ov5642_set_fmt(struct v4l2_subdev *sd,
> +		struct v4l2_subdev_pad_config *cfg,
> +		struct v4l2_subdev_format *format)
>  {
> +	struct v4l2_mbus_framefmt *mf = &format->format;
>  	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct ov5642 *priv = to_ov5642(client);
>  	const struct ov5642_datafmt *fmt = ov5642_find_datafmt(mf->code);
>  
> +	if (format->pad)
> +		return -EINVAL;
> +
>  	mf->width = priv->crop_rect.width;
>  	mf->height = priv->crop_rect.height;
>  
>  	if (!fmt) {
> +		if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
> +			return -EINVAL;
>  		mf->code	= ov5642_colour_fmts[0].code;
>  		mf->colorspace	= ov5642_colour_fmts[0].colorspace;
>  	}
>  
>  	mf->field	= V4L2_FIELD_NONE;
>  
> -	return 0;
> -}
> -
> -static int ov5642_s_fmt(struct v4l2_subdev *sd,
> -			struct v4l2_mbus_framefmt *mf)
> -{
> -	struct i2c_client *client = v4l2_get_subdevdata(sd);
> -	struct ov5642 *priv = to_ov5642(client);
> -
> -	/* MIPI CSI could have changed the format, double-check */
> -	if (!ov5642_find_datafmt(mf->code))
> -		return -EINVAL;
> -
> -	ov5642_try_fmt(sd, mf);
> -	priv->fmt = ov5642_find_datafmt(mf->code);
> -
> +	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
> +		priv->fmt = ov5642_find_datafmt(mf->code);

Uhm, we've called ov5642_find_datafmt() above already...

> +	else
> +		cfg->try_fmt = *mf;
>  	return 0;
>  }
>  
> @@ -945,8 +940,6 @@ static int ov5642_s_power(struct v4l2_subdev *sd, int on)
>  }
>  
>  static struct v4l2_subdev_video_ops ov5642_subdev_video_ops = {
> -	.s_mbus_fmt	= ov5642_s_fmt,
> -	.try_mbus_fmt	= ov5642_try_fmt,
>  	.s_crop		= ov5642_s_crop,
>  	.g_crop		= ov5642_g_crop,
>  	.cropcap	= ov5642_cropcap,
> @@ -956,6 +949,7 @@ static struct v4l2_subdev_video_ops ov5642_subdev_video_ops = {
>  static const struct v4l2_subdev_pad_ops ov5642_subdev_pad_ops = {
>  	.enum_mbus_code = ov5642_enum_mbus_code,
>  	.get_fmt	= ov5642_get_fmt,
> +	.set_fmt	= ov5642_set_fmt,
>  };
>  
>  static struct v4l2_subdev_core_ops ov5642_subdev_core_ops = {

[snip]

> diff --git a/drivers/media/i2c/soc_camera/ov772x.c b/drivers/media/i2c/soc_camera/ov772x.c
> index 1db2044..f150a8b 100644
> --- a/drivers/media/i2c/soc_camera/ov772x.c
> +++ b/drivers/media/i2c/soc_camera/ov772x.c
> @@ -920,12 +920,17 @@ static int ov772x_s_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf)
>  	return 0;
>  }
>  
> -static int ov772x_try_fmt(struct v4l2_subdev *sd,
> -			  struct v4l2_mbus_framefmt *mf)
> +static int ov772x_set_fmt(struct v4l2_subdev *sd,
> +		struct v4l2_subdev_pad_config *cfg,
> +		struct v4l2_subdev_format *format)
>  {
> +	struct v4l2_mbus_framefmt *mf = &format->format;
>  	const struct ov772x_color_format *cfmt;
>  	const struct ov772x_win_size *win;
>  
> +	if (format->pad)
> +		return -EINVAL;
> +
>  	ov772x_select_params(mf, &cfmt, &win);
>  
>  	mf->code = cfmt->code;
> @@ -934,6 +939,9 @@ static int ov772x_try_fmt(struct v4l2_subdev *sd,
>  	mf->field = V4L2_FIELD_NONE;
>  	mf->colorspace = cfmt->colorspace;
>  
> +	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
> +		return ov772x_s_fmt(sd, mf);

ov772x_select_params() will be called again.

> +	cfg->try_fmt = *mf;
>  	return 0;
>  }
>  
> @@ -1022,8 +1030,6 @@ static int ov772x_g_mbus_config(struct v4l2_subdev *sd,
>  
>  static struct v4l2_subdev_video_ops ov772x_subdev_video_ops = {
>  	.s_stream	= ov772x_s_stream,
> -	.s_mbus_fmt	= ov772x_s_fmt,
> -	.try_mbus_fmt	= ov772x_try_fmt,
>  	.cropcap	= ov772x_cropcap,
>  	.g_crop		= ov772x_g_crop,
>  	.g_mbus_config	= ov772x_g_mbus_config,
> @@ -1032,6 +1038,7 @@ static struct v4l2_subdev_video_ops ov772x_subdev_video_ops = {
>  static const struct v4l2_subdev_pad_ops ov772x_subdev_pad_ops = {
>  	.enum_mbus_code = ov772x_enum_mbus_code,
>  	.get_fmt	= ov772x_get_fmt,
> +	.set_fmt	= ov772x_set_fmt,
>  };
>  
>  static struct v4l2_subdev_ops ov772x_subdev_ops = {
> diff --git a/drivers/media/i2c/soc_camera/ov9640.c b/drivers/media/i2c/soc_camera/ov9640.c
> index 899b4d9..8caae1c 100644
> --- a/drivers/media/i2c/soc_camera/ov9640.c
> +++ b/drivers/media/i2c/soc_camera/ov9640.c
> @@ -519,9 +519,15 @@ static int ov9640_s_fmt(struct v4l2_subdev *sd,
>  	return ret;
>  }
>  
> -static int ov9640_try_fmt(struct v4l2_subdev *sd,
> -			  struct v4l2_mbus_framefmt *mf)
> +static int ov9640_set_fmt(struct v4l2_subdev *sd,
> +		struct v4l2_subdev_pad_config *cfg,
> +		struct v4l2_subdev_format *format)
>  {
> +	struct v4l2_mbus_framefmt *mf = &format->format;
> +
> +	if (format->pad)
> +		return -EINVAL;
> +
>  	ov9640_res_roundup(&mf->width, &mf->height);
>  
>  	mf->field = V4L2_FIELD_NONE;
> @@ -537,6 +543,10 @@ static int ov9640_try_fmt(struct v4l2_subdev *sd,
>  		mf->colorspace = V4L2_COLORSPACE_JPEG;
>  	}
>  
> +	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
> +		return ov9640_s_fmt(sd, mf);

ov9640_res_roundup() called twice.

> +
> +	cfg->try_fmt = *mf;
>  	return 0;
>  }
>  
> @@ -657,8 +667,6 @@ static int ov9640_g_mbus_config(struct v4l2_subdev *sd,
>  
>  static struct v4l2_subdev_video_ops ov9640_video_ops = {
>  	.s_stream	= ov9640_s_stream,
> -	.s_mbus_fmt	= ov9640_s_fmt,
> -	.try_mbus_fmt	= ov9640_try_fmt,
>  	.cropcap	= ov9640_cropcap,
>  	.g_crop		= ov9640_g_crop,
>  	.g_mbus_config	= ov9640_g_mbus_config,
> @@ -666,6 +674,7 @@ static struct v4l2_subdev_video_ops ov9640_video_ops = {
>  
>  static const struct v4l2_subdev_pad_ops ov9640_pad_ops = {
>  	.enum_mbus_code = ov9640_enum_mbus_code,
> +	.set_fmt	= ov9640_set_fmt,
>  };
>  
>  static struct v4l2_subdev_ops ov9640_subdev_ops = {
> diff --git a/drivers/media/i2c/soc_camera/ov9740.c b/drivers/media/i2c/soc_camera/ov9740.c
> index 5d9b249..03a7fc7 100644
> --- a/drivers/media/i2c/soc_camera/ov9740.c
> +++ b/drivers/media/i2c/soc_camera/ov9740.c
> @@ -704,15 +704,24 @@ static int ov9740_s_fmt(struct v4l2_subdev *sd,
>  	return ret;
>  }
>  
> -static int ov9740_try_fmt(struct v4l2_subdev *sd,
> -			  struct v4l2_mbus_framefmt *mf)
> +static int ov9740_set_fmt(struct v4l2_subdev *sd,
> +		struct v4l2_subdev_pad_config *cfg,
> +		struct v4l2_subdev_format *format)
>  {
> +	struct v4l2_mbus_framefmt *mf = &format->format;
> +
> +	if (format->pad)
> +		return -EINVAL;
> +
>  	ov9740_res_roundup(&mf->width, &mf->height);
>  
>  	mf->field = V4L2_FIELD_NONE;
>  	mf->code = MEDIA_BUS_FMT_YUYV8_2X8;
>  	mf->colorspace = V4L2_COLORSPACE_SRGB;
>  
> +	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
> +		return ov9740_s_fmt(sd, mf);

ov9740_res_roundup() duplicated

> +	cfg->try_fmt = *mf;
>  	return 0;
>  }
>  
> @@ -905,8 +914,6 @@ static int ov9740_g_mbus_config(struct v4l2_subdev *sd,
>  
>  static struct v4l2_subdev_video_ops ov9740_video_ops = {
>  	.s_stream	= ov9740_s_stream,
> -	.s_mbus_fmt	= ov9740_s_fmt,
> -	.try_mbus_fmt	= ov9740_try_fmt,
>  	.cropcap	= ov9740_cropcap,
>  	.g_crop		= ov9740_g_crop,
>  	.g_mbus_config	= ov9740_g_mbus_config,
> @@ -922,6 +929,7 @@ static struct v4l2_subdev_core_ops ov9740_core_ops = {
>  
>  static const struct v4l2_subdev_pad_ops ov9740_pad_ops = {
>  	.enum_mbus_code = ov9740_enum_mbus_code,
> +	.set_fmt	= ov9740_set_fmt,
>  };
>  
>  static struct v4l2_subdev_ops ov9740_subdev_ops = {

Thanks
Guennadi
