Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45397 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab1H1Rsn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Aug 2011 13:48:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bastian Hecht <hechtb@googlemail.com>
Subject: Re: [PATCH] media: Add support for arbitrary resolution for the ov5642 camera driver
Date: Sun, 28 Aug 2011 19:49:05 +0200
Cc: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <alpine.DEB.2.02.1108171551040.17540@ipanema>
In-Reply-To: <alpine.DEB.2.02.1108171551040.17540@ipanema>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108281949.05551.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bastian,

Thanks for the patch.

On Wednesday 17 August 2011 17:53:42 Bastian Hecht wrote:
> This patch adds the ability to get arbitrary resolutions with a width
> up to 2592 and a height up to 720 pixels instead of the standard 1280x720
> only.
> 
> Signed-off-by: Bastian Hecht <hechtb@gmail.com>
> ---
> 
> diff --git a/drivers/media/video/ov5642.c b/drivers/media/video/ov5642.c
> index 6410bda..1b40d90 100644
> --- a/drivers/media/video/ov5642.c
> +++ b/drivers/media/video/ov5642.c
> @@ -14,8 +14,10 @@
>   * published by the Free Software Foundation.
>   */
> 
> +#include <linux/bitops.h>
>  #include <linux/delay.h>
>  #include <linux/i2c.h>
> +#include <linux/kernel.h>
>  #include <linux/slab.h>
>  #include <linux/videodev2.h>
> 
> @@ -28,13 +30,25 @@
>  #define REG_CHIP_ID_HIGH		0x300a
>  #define REG_CHIP_ID_LOW			0x300b
> 
> +#define REG_RED_GAIN_HIGH		0x3400
> +#define REG_RED_GAIN_LOW		0x3401
> +#define REG_BLUE_GAIN_HIGH		0x3404
> +#define REG_BLUE_GAIN_LOW		0x3405
> +#define REG_AWB_MANUAL			0x3406
> +#define REG_EXP_HIGH			0x3500
> +#define REG_EXP_MIDDLE			0x3501
> +#define REG_EXP_LOW			0x3502
> +#define REG_EXP_GAIN_CTRL		0x3503
> +#define REG_GAIN			0x350b

This belongs to the second patch.

> +#define REG_EXTEND_FRAME_TIME_HIGH	0x350c
> +#define REG_EXTEND_FRAME_TIME_LOW	0x350d
>  #define REG_WINDOW_START_X_HIGH		0x3800
>  #define REG_WINDOW_START_X_LOW		0x3801
>  #define REG_WINDOW_START_Y_HIGH		0x3802
>  #define REG_WINDOW_START_Y_LOW		0x3803
>  #define REG_WINDOW_WIDTH_HIGH		0x3804
>  #define REG_WINDOW_WIDTH_LOW		0x3805
> -#define REG_WINDOW_HEIGHT_HIGH 		0x3806
> +#define REG_WINDOW_HEIGHT_HIGH		0x3806
>  #define REG_WINDOW_HEIGHT_LOW		0x3807
>  #define REG_OUT_WIDTH_HIGH		0x3808
>  #define REG_OUT_WIDTH_LOW		0x3809
> @@ -44,19 +58,56 @@
>  #define REG_OUT_TOTAL_WIDTH_LOW		0x380d
>  #define REG_OUT_TOTAL_HEIGHT_HIGH	0x380e
>  #define REG_OUT_TOTAL_HEIGHT_LOW	0x380f
> +#define REG_FLIP_SUBSAMPLE		0x3818
> +#define REG_OUTPUT_FORMAT		0x4300
> +#define REG_ISP_CTRL_01			0x5001
> +#define REG_DIGITAL_EFFECTS		0x5580
> +#define REG_HUE_COS			0x5581
> +#define REG_HUE_SIN			0x5582
> +#define REG_BLUE_SATURATION		0x5583
> +#define REG_RED_SATURATION		0x5584
> +#define REG_CONTRAST			0x5588
> +#define REG_BRIGHTNESS			0x5589
> +#define REG_D_E_AUXILLARY		0x558a
> +#define REG_AVG_WINDOW_END_X_HIGH	0x5682
> +#define REG_AVG_WINDOW_END_X_LOW	0x5683
> +#define REG_AVG_WINDOW_END_Y_HIGH	0x5686
> +#define REG_AVG_WINDOW_END_Y_LOW	0x5687

So does this.

> +
> +/* active pixel array size */
> +#define OV5642_SENSOR_SIZE_X	2592
> +#define OV5642_SENSOR_SIZE_Y	1944
> +
> +/* current maximum working size */
> +#define OV5642_MAX_WIDTH	OV5642_SENSOR_SIZE_X
> +#define OV5642_MAX_HEIGHT	720
> +
> +/* default sizes */
> +#define OV5642_DEFAULT_WIDTH	1280
> +#define OV5642_DEFAULT_HEIGHT	OV5642_MAX_HEIGHT
> +
> +/* minimum extra blanking */
> +#define BLANKING_EXTRA_WIDTH		500
> +#define BLANKING_EXTRA_HEIGHT		20
> 
>  /*
> - * define standard resolution.
> - * Works currently only for up to 720 lines
> - * eg. 320x240, 640x480, 800x600, 1280x720, 2048x720
> + * the sensor's autoexposure is buggy when setting total_height low.
> + * It tries to expose longer than 1 frame period without taking care of it
> + * and this leads to weird output. So we set 1000 lines as minimum.
>   */
> 
> -#define OV5642_WIDTH		1280
> -#define OV5642_HEIGHT		720
> -#define OV5642_TOTAL_WIDTH	3200
> -#define OV5642_TOTAL_HEIGHT	2000
> -#define OV5642_SENSOR_SIZE_X	2592
> -#define OV5642_SENSOR_SIZE_Y	1944
> +#define BLANKING_MIN_HEIGHT		1000
> +
> +/*
> + * About OV5642 resolution, cropping and binning:
> + * This sensor supports it all, at least in the feature description.
> + * Unfortunately, no combination of appropriate registers settings could
> make + * the chip work the intended way. As it works with predefined
> register lists, + * some undocumented registers are presumably changed
> there to achieve their + * goals.
> + * This driver currently only works for resolutions up to 720 lines with a
> + * 1:1 scale. Hopefully these restrictions will be removed in the future.
> + */

Can you please move this comment above the OV5642_MAX_WIDTH and 
OV5642_MAX_HEIGHT definitions ?

>  struct regval_list {
>  	u16 reg_num;
> @@ -105,10 +156,8 @@ static struct regval_list ov5642_default_regs_init[] =
> { { 0x471d, 0x5  },
>  	{ 0x4708, 0x6  },
>  	{ 0x370c, 0xa0 },
> -	{ 0x5687, 0x94 },

Unless I'm mistaken, this register value is removed and isn't replaced by 
anything in this patch or the next one. Is that intentional ?

>  	{ 0x501f, 0x0  },
>  	{ 0x5000, 0x4f },
> -	{ 0x5001, 0xcf },

This one is replaced by 0xff. I'm not sure how that's related to this patch. 
Could you please check all modifications to the ov5642_default_regs_init[] and 
ov5642_default_regs_finalise[] arrays ? Some probably need to move to the next 
patch, and others don't seem to be related to any of the two patches.

>  	{ 0x4300, 0x30 },
>  	{ 0x4300, 0x30 },
>  	{ 0x460b, 0x35 },
> @@ -121,11 +170,8 @@ static struct regval_list ov5642_default_regs_init[] =
> { { 0x4402, 0x90 },
>  	{ 0x460c, 0x22 },
>  	{ 0x3815, 0x44 },
> -	{ 0x3503, 0x7  },
>  	{ 0x3501, 0x73 },
>  	{ 0x3502, 0x80 },
> -	{ 0x350b, 0x0  },
> -	{ 0x3818, 0xc8 },
>  	{ 0x3824, 0x11 },
>  	{ 0x3a00, 0x78 },
>  	{ 0x3a1a, 0x4  },
> @@ -140,12 +186,6 @@ static struct regval_list ov5642_default_regs_init[] =
> { { 0x350d, 0xd0 },
>  	{ 0x3a0d, 0x8  },
>  	{ 0x3a0e, 0x6  },
> -	{ 0x3500, 0x0  },
> -	{ 0x3501, 0x0  },
> -	{ 0x3502, 0x0  },
> -	{ 0x350a, 0x0  },
> -	{ 0x350b, 0x0  },
> -	{ 0x3503, 0x0  },
>  	{ 0x3a0f, 0x3c },
>  	{ 0x3a10, 0x32 },
>  	{ 0x3a1b, 0x3c },
> @@ -298,7 +338,7 @@ static struct regval_list ov5642_default_regs_init[] =
> { { 0x54b7, 0xdf },
>  	{ 0x5402, 0x3f },
>  	{ 0x5403, 0x0  },
> -	{ 0x3406, 0x0  },
> +	{ REG_AWB_MANUAL, 0x0  },
>  	{ 0x5180, 0xff },
>  	{ 0x5181, 0x52 },
>  	{ 0x5182, 0x11 },
> @@ -515,7 +555,6 @@ static struct regval_list ov5642_default_regs_init[] =
> { { 0x5088, 0x0  },
>  	{ 0x5089, 0x0  },
>  	{ 0x302b, 0x0  },
> -	{ 0x3503, 0x7  },
>  	{ 0x3011, 0x8  },
>  	{ 0x350c, 0x2  },
>  	{ 0x350d, 0xe4 },
> @@ -526,7 +565,6 @@ static struct regval_list ov5642_default_regs_init[] =
> {
> 
>  static struct regval_list ov5642_default_regs_finalise[] = {
>  	{ 0x3810, 0xc2 },
> -	{ 0x3818, 0xc9 },
>  	{ 0x381c, 0x10 },
>  	{ 0x381d, 0xa0 },
>  	{ 0x381e, 0x5  },
> @@ -541,23 +579,20 @@ static struct regval_list
> ov5642_default_regs_finalise[] = { { 0x3a0d, 0x2  },
>  	{ 0x3a0e, 0x1  },
>  	{ 0x401c, 0x4  },
> -	{ 0x5682, 0x5  },
> -	{ 0x5683, 0x0  },
> -	{ 0x5686, 0x2  },
> -	{ 0x5687, 0xcc },
> -	{ 0x5001, 0x4f },
> +	{ REG_ISP_CTRL_01, 0xff },
> +	{ REG_DIGITAL_EFFECTS, 0x6 },
>  	{ 0x589b, 0x6  },
>  	{ 0x589a, 0xc5 },
> -	{ 0x3503, 0x0  },
> +	{ REG_EXP_GAIN_CTRL, 0x0  },
>  	{ 0x460c, 0x20 },
>  	{ 0x460b, 0x37 },
>  	{ 0x471c, 0xd0 },
>  	{ 0x471d, 0x5  },
>  	{ 0x3815, 0x1  },
> -	{ 0x3818, 0xc1 },
> +	{ REG_FLIP_SUBSAMPLE, 0xc1 },
>  	{ 0x501f, 0x0  },
>  	{ 0x5002, 0xe0 },
> -	{ 0x4300, 0x32 }, /* UYVY */
> +	{ REG_OUTPUT_FORMAT, 0x32 },
>  	{ 0x3002, 0x1c },
>  	{ 0x4800, 0x14 },
>  	{ 0x4801, 0xf  },
> @@ -578,9 +613,20 @@ struct ov5642_datafmt {
>  	enum v4l2_colorspace		colorspace;
>  };
> 
> +/* the output resolution and blanking information */
> +struct ov5642_out_size {
> +	int width;
> +	int height;
> +	int total_width;
> +	int total_height;
> +};
> +
>  struct ov5642 {
>  	struct v4l2_subdev		subdev;
> +
>  	const struct ov5642_datafmt	*fmt;
> +	struct v4l2_rect                crop_rect;
> +	struct ov5642_out_size		out_size;
>  };
> 
>  static const struct ov5642_datafmt ov5642_colour_fmts[] = {
> @@ -593,8 +639,7 @@ static struct ov5642 *to_ov5642(const struct i2c_client
> *client) }
> 
>  /* Find a data format by a pixel code in an array */
> -static const struct ov5642_datafmt
> -			*ov5642_find_datafmt(enum v4l2_mbus_pixelcode code)
> +static const struct ov5642_datafmt *ov5642_find_datafmt(enum
> v4l2_mbus_pixelcode code) {

checkpatch.pl won't be happy.

>  	int i;
> 
> @@ -641,6 +686,26 @@ static int reg_write(struct i2c_client *client, u16
> reg, u8 val)
> 
>  	return 0;
>  }
> +
> +/*
> + * convenience function to write 16 bit register values that are split up
> + * into two consecutive high and low parts
> + */
> +static int reg_write16(struct i2c_client *client, u16 reg, u16 val16)
> +{
> +	int ret;
> +	u8 val8;
> +
> +	val8 = val16 >> 8;
> +	ret = reg_write(client, reg, val8);

You can use val16 >> 8 directly as a function argument and get rid of the val8 
variable.

> +	if (ret)
> +		return ret;
> +	val8 = val16 & 0x00ff;
> +	ret = reg_write(client, reg + 1, val8);
> +
> +	return ret;

return reg_write(...) should be fine.

> +}
> +
>  #ifdef CONFIG_VIDEO_ADV_DEBUG
>  static int ov5642_get_register(struct v4l2_subdev *sd, struct
> v4l2_dbg_register *reg) {
> @@ -684,68 +749,72 @@ static int ov5642_write_array(struct i2c_client
> *client, return 0;
>  }
> 
> -static int ov5642_set_resolution(struct i2c_client *client)
> +static int ov5642_set_resolution(struct v4l2_subdev *sd)
>  {
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	struct ov5642 *priv = to_ov5642(client);
> +	int width = priv->out_size.width;
> +	int height = priv->out_size.height;
> +	int total_width = priv->out_size.total_width;
> +	int total_height = priv->out_size.total_height;
> +	int start_x = (OV5642_SENSOR_SIZE_X - width) / 2;
> +	int start_y = (OV5642_SENSOR_SIZE_Y - height) / 2;
>  	int ret;
> -	u8 start_x_high = ((OV5642_SENSOR_SIZE_X - OV5642_WIDTH) / 2) >> 8;
> -	u8 start_x_low  = ((OV5642_SENSOR_SIZE_X - OV5642_WIDTH) / 2) & 0xff;
> -	u8 start_y_high = ((OV5642_SENSOR_SIZE_Y - OV5642_HEIGHT) / 2) >> 8;
> -	u8 start_y_low  = ((OV5642_SENSOR_SIZE_Y - OV5642_HEIGHT) / 2) & 0xff;
> -
> -	u8 width_high	= OV5642_WIDTH  >> 8;
> -	u8 width_low	= OV5642_WIDTH  & 0xff;
> -	u8 height_high	= OV5642_HEIGHT >> 8;
> -	u8 height_low	= OV5642_HEIGHT & 0xff;
> -
> -	u8 total_width_high  = OV5642_TOTAL_WIDTH  >> 8;
> -	u8 total_width_low   = OV5642_TOTAL_WIDTH  & 0xff;
> -	u8 total_height_high = OV5642_TOTAL_HEIGHT >> 8;
> -	u8 total_height_low  = OV5642_TOTAL_HEIGHT & 0xff;
> -
> -	ret = reg_write(client, REG_WINDOW_START_X_HIGH, start_x_high);
> -	if (!ret)
> -		ret = reg_write(client, REG_WINDOW_START_X_LOW, start_x_low);
> -	if (!ret)
> -		ret = reg_write(client, REG_WINDOW_START_Y_HIGH, start_y_high);
> -	if (!ret)
> -		ret = reg_write(client, REG_WINDOW_START_Y_LOW, start_y_low);
> 
> +	/* This should set the starting point for cropping. Doesn't work so far.
> */ +	ret = reg_write16(client, REG_WINDOW_START_X_HIGH, start_x);
>  	if (!ret)
> -		ret = reg_write(client, REG_WINDOW_WIDTH_HIGH, width_high);
> -	if (!ret)
> -		ret = reg_write(client, REG_WINDOW_WIDTH_LOW , width_low);
> +		ret = reg_write16(client, REG_WINDOW_START_Y_HIGH, start_y);
> +	if (!ret) {
> +		priv->crop_rect.left = start_x;
> +		priv->crop_rect.top = start_y;
> +	}
> +
>  	if (!ret)
> -		ret = reg_write(client, REG_WINDOW_HEIGHT_HIGH, height_high);
> +		ret = reg_write16(client, REG_WINDOW_WIDTH_HIGH, width);
>  	if (!ret)
> -		ret = reg_write(client, REG_WINDOW_HEIGHT_LOW,  height_low);
> +		ret = reg_write16(client, REG_WINDOW_HEIGHT_HIGH, height);
> +	if (ret)
> +		return ret;
> +	priv->crop_rect.width = width;
> +	priv->crop_rect.height = height;
> 
> +	/* Set the output window size. Only 1:1 scale is supported so far. */
> +	ret = reg_write16(client, REG_OUT_WIDTH_HIGH, width);
>  	if (!ret)
> -		ret = reg_write(client, REG_OUT_WIDTH_HIGH, width_high);
> -	if (!ret)
> -		ret = reg_write(client, REG_OUT_WIDTH_LOW , width_low);
> +		ret = reg_write16(client, REG_OUT_HEIGHT_HIGH, height);
> +
> +	/* Total width = output size + blanking */
>  	if (!ret)
> -		ret = reg_write(client, REG_OUT_HEIGHT_HIGH, height_high);
> +		ret = reg_write16(client, REG_OUT_TOTAL_WIDTH_HIGH, total_width);
>  	if (!ret)
> -		ret = reg_write(client, REG_OUT_HEIGHT_LOW,  height_low);
> +		ret = reg_write16(client, REG_OUT_TOTAL_HEIGHT_HIGH, total_height);
> 
> +	/* set the maximum integration time */
>  	if (!ret)
> -		ret = reg_write(client, REG_OUT_TOTAL_WIDTH_HIGH, total_width_high);
> -	if (!ret)
> -		ret = reg_write(client, REG_OUT_TOTAL_WIDTH_LOW, total_width_low);
> +		ret = reg_write16(client, REG_EXTEND_FRAME_TIME_HIGH,
> +								total_height);
> +
> +	/* Sets the window for AWB calculations */
>  	if (!ret)
> -		ret = reg_write(client, REG_OUT_TOTAL_HEIGHT_HIGH, total_height_high);
> +		ret = reg_write16(client, REG_AVG_WINDOW_END_X_HIGH, width);
>  	if (!ret)
> -		ret = reg_write(client, REG_OUT_TOTAL_HEIGHT_LOW,  total_height_low);
> +		ret = reg_write16(client, REG_AVG_WINDOW_END_Y_HIGH, height);
> 
>  	return ret;
>  }
> 
> -static int ov5642_try_fmt(struct v4l2_subdev *sd,
> -			  struct v4l2_mbus_framefmt *mf)
> +static int ov5642_try_fmt(struct v4l2_subdev *sd, struct
> v4l2_mbus_framefmt *mf) {
> -	const struct ov5642_datafmt *fmt = ov5642_find_datafmt(mf->code);
> +	const struct ov5642_datafmt *fmt   = ov5642_find_datafmt(mf->code);
> 
> -	dev_dbg(sd->v4l2_dev->dev, "%s(%u) width: %u heigth: %u\n",
> +	dev_dbg(sd->v4l2_dev->dev, "%s(%u) request width: %u heigth: %u\n",
> +			__func__, mf->code, mf->width, mf->height);
> +
> +	v4l_bound_align_image(&mf->width, 48, OV5642_MAX_WIDTH, 1,
> +			      &mf->height, 32, OV5642_MAX_HEIGHT, 1, 0);
> +
> +	dev_dbg(sd->v4l2_dev->dev, "%s(%u) return width: %u heigth: %u\n",
>  			__func__, mf->code, mf->width, mf->height);
> 
>  	if (!fmt) {
> @@ -753,20 +822,16 @@ static int ov5642_try_fmt(struct v4l2_subdev *sd,
>  		mf->colorspace	= ov5642_colour_fmts[0].colorspace;
>  	}
> 
> -	mf->width	= OV5642_WIDTH;
> -	mf->height	= OV5642_HEIGHT;
>  	mf->field	= V4L2_FIELD_NONE;
> 
>  	return 0;
>  }
> 
> -static int ov5642_s_fmt(struct v4l2_subdev *sd,
> -			struct v4l2_mbus_framefmt *mf)
> +static int ov5642_s_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt
> *mf) {
>  	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct ov5642 *priv = to_ov5642(client);
> -
> -	dev_dbg(sd->v4l2_dev->dev, "%s(%u)\n", __func__, mf->code);
> +	int ret;
> 
>  	/* MIPI CSI could have changed the format, double-check */
>  	if (!ov5642_find_datafmt(mf->code))
> @@ -774,17 +839,27 @@ static int ov5642_s_fmt(struct v4l2_subdev *sd,
> 
>  	ov5642_try_fmt(sd, mf);
> 
> +	priv->out_size.width		= mf->width;
> +	priv->out_size.height		= mf->height;

It looks like to me (but I may be wrong) that you achieve different 
resolutions using cropping, not scaling. If that's correct you should 
implement s_crop support and refuse changing the resolution through s_fmt.

> +	priv->out_size.total_width	= mf->width + BLANKING_EXTRA_WIDTH;
> +	priv->out_size.total_height	= max_t(int, mf->height +
> +							BLANKING_EXTRA_HEIGHT,
> +							BLANKING_MIN_HEIGHT);

As you only use those two values once, maybe you can compute them in 
ov5642_set_resolution() instead of storing them in the device data structure.

> +	priv->crop_rect.width		= mf->width;
> +	priv->crop_rect.height		= mf->height;
> +
>  	priv->fmt = ov5642_find_datafmt(mf->code);
> 
> -	ov5642_write_array(client, ov5642_default_regs_init);
> -	ov5642_set_resolution(client);
> -	ov5642_write_array(client, ov5642_default_regs_finalise);
> +	ret = ov5642_write_array(client, ov5642_default_regs_init);
> +	if (!ret)
> +		ret = ov5642_set_resolution(sd);
> +	if (!ret)
> +		ret = ov5642_write_array(client, ov5642_default_regs_finalise);
> 
> -	return 0;
> +	return ret;
>  }
> 
> -static int ov5642_g_fmt(struct v4l2_subdev *sd,
> -			struct v4l2_mbus_framefmt *mf)
> +static int ov5642_g_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt
> *mf) {
>  	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct ov5642 *priv = to_ov5642(client);
> @@ -793,10 +868,12 @@ static int ov5642_g_fmt(struct v4l2_subdev *sd,
> 
>  	mf->code	= fmt->code;
>  	mf->colorspace	= fmt->colorspace;
> -	mf->width	= OV5642_WIDTH;
> -	mf->height	= OV5642_HEIGHT;
> +	mf->width	= priv->out_size.width;
> +	mf->height	= priv->out_size.height;
>  	mf->field	= V4L2_FIELD_NONE;
> 
> +	dev_dbg(sd->v4l2_dev->dev, "%s return width: %u heigth: %u\n", __func__,
> +			mf->width, mf->height);

Isn't that a bit too verbose ? Printing the format in a debug message in the 
s_fmt handler is useful, but maybe doing it in g_fmt is a bit too much.

>  	return 0;
>  }
> 
> @@ -829,14 +906,17 @@ static int ov5642_g_chip_ident(struct v4l2_subdev
> *sd,
> 
>  static int ov5642_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
>  {
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	struct ov5642 *priv = to_ov5642(client);
>  	struct v4l2_rect *rect = &a->c;
> -
>  	a->type		= V4L2_BUF_TYPE_VIDEO_CAPTURE;
> -	rect->top	= 0;
> -	rect->left	= 0;
> -	rect->width	= OV5642_WIDTH;
> -	rect->height	= OV5642_HEIGHT;
> +	rect->top	= priv->crop_rect.top;
> +	rect->left	= priv->crop_rect.left;
> +	rect->width	= priv->crop_rect.width;
> +	rect->height	= priv->crop_rect.height;

rect = priv->crop_rect;

should do.

> 
> +	dev_dbg(sd->v4l2_dev->dev, "%s crop width: %u heigth: %u\n", __func__,
> +			rect->width, rect->height);

Same comment as for g_fmt.

>  	return 0;
>  }
> 
> @@ -844,8 +924,8 @@ static int ov5642_cropcap(struct v4l2_subdev *sd,
> struct v4l2_cropcap *a) {
>  	a->bounds.left			= 0;
>  	a->bounds.top			= 0;
> -	a->bounds.width			= OV5642_WIDTH;
> -	a->bounds.height		= OV5642_HEIGHT;
> +	a->bounds.width			= OV5642_MAX_WIDTH;
> +	a->bounds.height		= OV5642_MAX_HEIGHT;
>  	a->defrect			= a->bounds;
>  	a->type				= V4L2_BUF_TYPE_VIDEO_CAPTURE;
>  	a->pixelaspect.numerator	= 1;
> @@ -858,9 +938,8 @@ static int ov5642_g_mbus_config(struct v4l2_subdev *sd,
>  				struct v4l2_mbus_config *cfg)
>  {
>  	cfg->type = V4L2_MBUS_CSI2;
> -	cfg->flags = V4L2_MBUS_CSI2_2_LANE |
> -		V4L2_MBUS_CSI2_CHANNEL_0 |
> -		V4L2_MBUS_CSI2_CONTINUOUS_CLOCK;
> +	cfg->flags = V4L2_MBUS_CSI2_2_LANE | V4L2_MBUS_CSI2_CHANNEL_0 |
> +					V4L2_MBUS_CSI2_CONTINUOUS_CLOCK;
> 
>  	return 0;
>  }
> @@ -941,8 +1020,15 @@ static int ov5642_probe(struct i2c_client *client,
> 
>  	v4l2_i2c_subdev_init(&priv->subdev, client, &ov5642_subdev_ops);
> 
> -	icd->ops	= NULL;
> -	priv->fmt	= &ov5642_colour_fmts[0];
> +	icd->ops		= NULL;
> +	priv->fmt		= &ov5642_colour_fmts[0];
> +
> +	priv->crop_rect.width	= OV5642_DEFAULT_WIDTH;
> +	priv->crop_rect.height	= OV5642_DEFAULT_HEIGHT;
> +	priv->crop_rect.left	= (OV5642_MAX_WIDTH - OV5642_DEFAULT_WIDTH) / 2;
> +	priv->crop_rect.top	= (OV5642_MAX_HEIGHT - OV5642_DEFAULT_HEIGHT) / 2;
> +	priv->out_size.width	= OV5642_DEFAULT_WIDTH;
> +	priv->out_size.height	= OV5642_DEFAULT_HEIGHT;
> 
>  	ret = ov5642_video_probe(icd, client);
>  	if (ret < 0)
> @@ -951,6 +1037,7 @@ static int ov5642_probe(struct i2c_client *client,
>  	return 0;
> 
>  error:
> +	icd->ops = NULL;
>  	kfree(priv);
>  	return ret;
>  }
> @@ -961,6 +1048,7 @@ static int ov5642_remove(struct i2c_client *client)
>  	struct soc_camera_device *icd = client->dev.platform_data;
>  	struct soc_camera_link *icl = to_soc_camera_link(icd);
> 
> +	icd->ops = NULL;
>  	if (icl->free_bus)
>  		icl->free_bus(icl);
>  	kfree(priv);

-- 
Regards,

Laurent Pinchart
