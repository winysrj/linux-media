Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:60838 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751687AbZFYRp5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jun 2009 13:45:57 -0400
Date: Thu, 25 Jun 2009 19:46:12 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Muralidharan Karicheri <m-karicheri2@ti.com>
cc: linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [PATCH] mt9t031 - migration to sub device frame work
In-Reply-To: <1245874609-15246-1-git-send-email-m-karicheri2@ti.com>
Message-ID: <Pine.LNX.4.64.0906251944420.4663@axis700.grange>
References: <1245874609-15246-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 24 Jun 2009, m-karicheri2@ti.com wrote:

> From: Muralidharan Karicheri <m-karicheri2@ti.com>
> 
> This patch migrates mt9t031 driver from SOC Camera interface to
> sub device interface. This is sent to get a feedback about the
> changes done since I am not sure if some of the functionality
> that is removed works okay with SOC Camera bridge driver or
> not. Following functions are to be discussed and added as needed:-
>  
> 	1) query bus parameters
> 	2) set bus parameters
> 	3) set crop
> 
> I have tested this with vpfe capture driver and I could capture
> 640x480@17fps and 2048x1536@12fps resolution frames from the sensor.
> 
> Reviewed by: Hans Verkuil <hverkuil@xs4all.nl>
> Reviewed by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Excuse me? This is the first time I see this patch. FYI, "Reviewed-by" 
means that the respective person has actually reviewed the patch and 
submitted that line _him_ or _her_self!

Thanks
Guennadi

> 
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> ---
>  drivers/media/video/mt9t031.c |  596 ++++++++++++++++++++---------------------
>  1 files changed, 293 insertions(+), 303 deletions(-)
> 
> diff --git a/drivers/media/video/mt9t031.c b/drivers/media/video/mt9t031.c
> index f72aeb7..0f32ff2 100644
> --- a/drivers/media/video/mt9t031.c
> +++ b/drivers/media/video/mt9t031.c
> @@ -13,9 +13,9 @@
>  #include <linux/i2c.h>
>  #include <linux/log2.h>
>  
> +#include <media/v4l2-device.h>
>  #include <media/v4l2-common.h>
>  #include <media/v4l2-chip-ident.h>
> -#include <media/soc_camera.h>
>  
>  /* mt9t031 i2c address 0x5d
>   * The platform has to define i2c_board_info
> @@ -52,33 +52,108 @@
>  #define MT9T031_VERTICAL_BLANK		25
>  #define MT9T031_COLUMN_SKIP		32
>  #define MT9T031_ROW_SKIP		20
> +#define MT9T031_DEFAULT_WIDTH		640
> +#define MT9T031_DEFAULT_HEIGHT		480
>  
>  #define MT9T031_BUS_PARAM	(SOCAM_PCLK_SAMPLE_RISING |	\
>  	SOCAM_PCLK_SAMPLE_FALLING | SOCAM_HSYNC_ACTIVE_HIGH |	\
>  	SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_DATA_ACTIVE_HIGH |	\
>  	SOCAM_MASTER | SOCAM_DATAWIDTH_10)
>  
> -static const struct soc_camera_data_format mt9t031_colour_formats[] = {
> +
> +/* Debug functions */
> +static int debug;
> +module_param(debug, bool, 0644);
> +MODULE_PARM_DESC(debug, "Debug level (0-1)");
> +
> +static const struct v4l2_fmtdesc mt9t031_formats[] = {
> +	{
> +		.index = 0,
> +		.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
> +		.description = "Bayer (sRGB) 10 bit",
> +		.pixelformat = V4L2_PIX_FMT_SGRBG10,
> +	},
> +};
> +static const unsigned int mt9t031_num_formats = ARRAY_SIZE(mt9t031_formats);
> +
> +static const struct v4l2_queryctrl mt9t031_controls[] = {
>  	{
> -		.name		= "Bayer (sRGB) 10 bit",
> -		.depth		= 10,
> -		.fourcc		= V4L2_PIX_FMT_SGRBG10,
> -		.colorspace	= V4L2_COLORSPACE_SRGB,
> +		.id		= V4L2_CID_VFLIP,
> +		.type		= V4L2_CTRL_TYPE_BOOLEAN,
> +		.name		= "Flip Vertically",
> +		.minimum	= 0,
> +		.maximum	= 1,
> +		.step		= 1,
> +		.default_value	= 0,
> +	}, {
> +		.id		= V4L2_CID_HFLIP,
> +		.type		= V4L2_CTRL_TYPE_BOOLEAN,
> +		.name		= "Flip Horizontally",
> +		.minimum	= 0,
> +		.maximum	= 1,
> +		.step		= 1,
> +		.default_value	= 0,
> +	}, {
> +		.id		= V4L2_CID_GAIN,
> +		.type		= V4L2_CTRL_TYPE_INTEGER,
> +		.name		= "Gain",
> +		.minimum	= 0,
> +		.maximum	= 127,
> +		.step		= 1,
> +		.default_value	= 64,
> +		.flags		= V4L2_CTRL_FLAG_SLIDER,
> +	}, {
> +		.id		= V4L2_CID_EXPOSURE,
> +		.type		= V4L2_CTRL_TYPE_INTEGER,
> +		.name		= "Exposure",
> +		.minimum	= 1,
> +		.maximum	= 255,
> +		.step		= 1,
> +		.default_value	= 255,
> +		.flags		= V4L2_CTRL_FLAG_SLIDER,
> +	}, {
> +		.id		= V4L2_CID_EXPOSURE_AUTO,
> +		.type		= V4L2_CTRL_TYPE_BOOLEAN,
> +		.name		= "Automatic Exposure",
> +		.minimum	= 0,
> +		.maximum	= 1,
> +		.step		= 1,
> +		.default_value	= 1,
>  	}
>  };
> +static const unsigned int mt9t031_num_controls = ARRAY_SIZE(mt9t031_controls);
>  
>  struct mt9t031 {
> -	struct i2c_client *client;
> -	struct soc_camera_device icd;
> +	struct v4l2_subdev sd;
>  	int model;	/* V4L2_IDENT_MT9T031* codes from v4l2-chip-ident.h */
>  	unsigned char autoexposure;
>  	u16 xskip;
>  	u16 yskip;
> +	u32 width;
> +	u32 height;
> +	unsigned short x_min;           /* Camera capabilities */
> +	unsigned short y_min;
> +	unsigned short x_current;       /* Current window location */
> +	unsigned short y_current;
> +	unsigned short width_min;
> +	unsigned short width_max;
> +	unsigned short height_min;
> +	unsigned short height_max;
> +	unsigned short y_skip_top;      /* Lines to skip at the top */
> +	unsigned short gain;
> +	unsigned short exposure;
>  };
>  
> +static inline struct mt9t031 *to_mt9t031(struct v4l2_subdev *sd)
> +{
> +	return container_of(sd, struct mt9t031, sd);
> +}
> +
>  static int reg_read(struct i2c_client *client, const u8 reg)
>  {
> -	s32 data = i2c_smbus_read_word_data(client, reg);
> +	s32 data;
> +
> +	data = i2c_smbus_read_word_data(client, reg);
>  	return data < 0 ? data : swab16(data);
>  }
>  
> @@ -110,8 +185,9 @@ static int reg_clear(struct i2c_client *client, const u8 reg,
>  	return reg_write(client, reg, ret & ~data);
>  }
>  
> -static int set_shutter(struct i2c_client *client, const u32 data)
> +static int set_shutter(struct v4l2_subdev *sd, const u32 data)
>  {
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	int ret;
>  
>  	ret = reg_write(client, MT9T031_SHUTTER_WIDTH_UPPER, data >> 16);
> @@ -122,9 +198,10 @@ static int set_shutter(struct i2c_client *client, const u32 data)
>  	return ret;
>  }
>  
> -static int get_shutter(struct i2c_client *client, u32 *data)
> +static int get_shutter(struct v4l2_subdev *sd, u32 *data)
>  {
>  	int ret;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  
>  	ret = reg_read(client, MT9T031_SHUTTER_WIDTH_UPPER);
>  	*data = ret << 16;
> @@ -136,20 +213,10 @@ static int get_shutter(struct i2c_client *client, u32 *data)
>  	return ret < 0 ? ret : 0;
>  }
>  
> -static int mt9t031_init(struct soc_camera_device *icd)
> +static int mt9t031_init(struct v4l2_subdev *sd, u32 val)
>  {
> -	struct i2c_client *client = to_i2c_client(icd->control);
> -	struct soc_camera_link *icl = client->dev.platform_data;
>  	int ret;
> -
> -	if (icl->power) {
> -		ret = icl->power(&client->dev, 1);
> -		if (ret < 0) {
> -			dev_err(icd->vdev->parent,
> -				"Platform failed to power-on the camera.\n");
> -			return ret;
> -		}
> -	}
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  
>  	/* Disable chip output, synchronous option update */
>  	ret = reg_write(client, MT9T031_RESET, 1);
> @@ -158,99 +225,67 @@ static int mt9t031_init(struct soc_camera_device *icd)
>  	if (ret >= 0)
>  		ret = reg_clear(client, MT9T031_OUTPUT_CONTROL, 2);
>  
> -	if (ret < 0 && icl->power)
> -		icl->power(&client->dev, 0);
> -
>  	return ret >= 0 ? 0 : -EIO;
>  }
>  
> -static int mt9t031_release(struct soc_camera_device *icd)
> -{
> -	struct i2c_client *client = to_i2c_client(icd->control);
> -	struct soc_camera_link *icl = client->dev.platform_data;
> -
> -	/* Disable the chip */
> -	reg_clear(client, MT9T031_OUTPUT_CONTROL, 2);
> -
> -	if (icl->power)
> -		icl->power(&client->dev, 0);
> -
> -	return 0;
> -}
> -
> -static int mt9t031_start_capture(struct soc_camera_device *icd)
> +static int mt9t031_s_stream(struct v4l2_subdev *sd, int enable)
>  {
> -	struct i2c_client *client = to_i2c_client(icd->control);
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  
>  	/* Switch to master "normal" mode */
> -	if (reg_set(client, MT9T031_OUTPUT_CONTROL, 2) < 0)
> -		return -EIO;
> -	return 0;
> -}
> -
> -static int mt9t031_stop_capture(struct soc_camera_device *icd)
> -{
> -	struct i2c_client *client = to_i2c_client(icd->control);
> -
> -	/* Stop sensor readout */
> -	if (reg_clear(client, MT9T031_OUTPUT_CONTROL, 2) < 0)
> -		return -EIO;
> +	if (enable) {
> +		if (reg_set(client, MT9T031_OUTPUT_CONTROL, 2) < 0)
> +			return -EIO;
> +	} else {
> +	/* Switch to master "" mode */
> +		if (reg_clear(client, MT9T031_OUTPUT_CONTROL, 2) < 0)
> +			return -EIO;
> +	}
>  	return 0;
>  }
>  
> -static int mt9t031_set_bus_param(struct soc_camera_device *icd,
> -				 unsigned long flags)
> +/* Round up minima and round down maxima */
> +static void recalculate_limits(struct mt9t031 *mt9t031,
> +			       u16 xskip, u16 yskip)
>  {
> -	struct i2c_client *client = to_i2c_client(icd->control);
> -
> -	/* The caller should have queried our parameters, check anyway */
> -	if (flags & ~MT9T031_BUS_PARAM)
> -		return -EINVAL;
> -
> -	if (flags & SOCAM_PCLK_SAMPLE_FALLING)
> -		reg_clear(client, MT9T031_PIXEL_CLOCK_CONTROL, 0x8000);
> -	else
> -		reg_set(client, MT9T031_PIXEL_CLOCK_CONTROL, 0x8000);
> -
> -	return 0;
> +	mt9t031->x_min = (MT9T031_COLUMN_SKIP + xskip - 1) / xskip;
> +	mt9t031->y_min = (MT9T031_ROW_SKIP + yskip - 1) / yskip;
> +	mt9t031->width_min = (MT9T031_MIN_WIDTH + xskip - 1) / xskip;
> +	mt9t031->height_min = (MT9T031_MIN_HEIGHT + yskip - 1) / yskip;
> +	mt9t031->width_max = MT9T031_MAX_WIDTH / xskip;
> +	mt9t031->height_max = MT9T031_MAX_HEIGHT / yskip;
>  }
>  
> -static unsigned long mt9t031_query_bus_param(struct soc_camera_device *icd)
> +const struct v4l2_queryctrl *mt9t031_find_qctrl(u32 id)
>  {
> -	struct mt9t031 *mt9t031 = container_of(icd, struct mt9t031, icd);
> -	struct soc_camera_link *icl = mt9t031->client->dev.platform_data;
> +	int i;
>  
> -	return soc_camera_apply_sensor_flags(icl, MT9T031_BUS_PARAM);
> -}
> -
> -/* Round up minima and round down maxima */
> -static void recalculate_limits(struct soc_camera_device *icd,
> -			       u16 xskip, u16 yskip)
> -{
> -	icd->x_min = (MT9T031_COLUMN_SKIP + xskip - 1) / xskip;
> -	icd->y_min = (MT9T031_ROW_SKIP + yskip - 1) / yskip;
> -	icd->width_min = (MT9T031_MIN_WIDTH + xskip - 1) / xskip;
> -	icd->height_min = (MT9T031_MIN_HEIGHT + yskip - 1) / yskip;
> -	icd->width_max = MT9T031_MAX_WIDTH / xskip;
> -	icd->height_max = MT9T031_MAX_HEIGHT / yskip;
> +	for (i = 0; i < mt9t031_num_controls; i++) {
> +		if (mt9t031_controls[i].id == id)
> +			return &mt9t031_controls[i];
> +	}
> +	return NULL;
>  }
>  
> -static int mt9t031_set_params(struct soc_camera_device *icd,
> +static int mt9t031_set_params(struct v4l2_subdev *sd,
>  			      struct v4l2_rect *rect, u16 xskip, u16 yskip)
>  {
> -	struct i2c_client *client = to_i2c_client(icd->control);
> -	struct mt9t031 *mt9t031 = container_of(icd, struct mt9t031, icd);
> +	struct mt9t031 *mt9t031 = to_mt9t031(sd);
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +
>  	int ret;
>  	u16 xbin, ybin, width, height, left, top;
>  	const u16 hblank = MT9T031_HORIZONTAL_BLANK,
>  		vblank = MT9T031_VERTICAL_BLANK;
>  
>  	/* Make sure we don't exceed sensor limits */
> -	if (rect->left + rect->width > icd->width_max)
> -		rect->left = (icd->width_max - rect->width) / 2 + icd->x_min;
> +	if (rect->left + rect->width > mt9t031->width_max)
> +		rect->left =
> +		(mt9t031->width_max - rect->width) / 2 + mt9t031->x_min;
>  
> -	if (rect->top + rect->height > icd->height_max)
> -		rect->top = (icd->height_max - rect->height) / 2 + icd->y_min;
> +	if (rect->top + rect->height > mt9t031->height_max)
> +		rect->top =
> +		(mt9t031->height_max - rect->height) / 2 + mt9t031->y_min;
>  
>  	width = rect->width * xskip;
>  	height = rect->height * yskip;
> @@ -260,8 +295,9 @@ static int mt9t031_set_params(struct soc_camera_device *icd,
>  	xbin = min(xskip, (u16)3);
>  	ybin = min(yskip, (u16)3);
>  
> -	dev_dbg(&icd->dev, "xskip %u, width %u/%u, yskip %u, height %u/%u\n",
> -		xskip, width, rect->width, yskip, height, rect->height);
> +	v4l2_dbg(1, debug, sd, "xskip %u, width %u/%u, yskip %u,"
> +		"height %u/%u\n", xskip, width, rect->width, yskip,
> +		height, rect->height);
>  
>  	/* Could just do roundup(rect->left, [xy]bin * 2); but this is cheaper */
>  	switch (xbin) {
> @@ -299,7 +335,7 @@ static int mt9t031_set_params(struct soc_camera_device *icd,
>  			ret = reg_write(client, MT9T031_ROW_ADDRESS_MODE,
>  					((ybin - 1) << 4) | (yskip - 1));
>  	}
> -	dev_dbg(&icd->dev, "new physical left %u, top %u\n", left, top);
> +	v4l2_dbg(1, debug, sd, "new physical left %u, top %u\n", left, top);
>  
>  	/* The caller provides a supported format, as guaranteed by
>  	 * icd->try_fmt_cap(), soc_camera_s_crop() and soc_camera_cropcap() */
> @@ -311,46 +347,41 @@ static int mt9t031_set_params(struct soc_camera_device *icd,
>  		ret = reg_write(client, MT9T031_WINDOW_WIDTH, width - 1);
>  	if (ret >= 0)
>  		ret = reg_write(client, MT9T031_WINDOW_HEIGHT,
> -				height + icd->y_skip_top - 1);
> +				height + mt9t031->y_skip_top - 1);
>  	if (ret >= 0 && mt9t031->autoexposure) {
> -		ret = set_shutter(client, height + icd->y_skip_top + vblank);
> +		ret = set_shutter(sd, height + mt9t031->y_skip_top + vblank);
>  		if (ret >= 0) {
>  			const u32 shutter_max = MT9T031_MAX_HEIGHT + vblank;
>  			const struct v4l2_queryctrl *qctrl =
> -				soc_camera_find_qctrl(icd->ops,
> -						      V4L2_CID_EXPOSURE);
> -			icd->exposure = (shutter_max / 2 + (height +
> -					 icd->y_skip_top + vblank - 1) *
> +				mt9t031_find_qctrl(V4L2_CID_EXPOSURE);
> +			mt9t031->exposure = (shutter_max / 2 + (height +
> +					 mt9t031->y_skip_top + vblank - 1) *
>  					 (qctrl->maximum - qctrl->minimum)) /
>  				shutter_max + qctrl->minimum;
>  		}
>  	}
>  
>  	/* Re-enable register update, commit all changes */
> -	if (ret >= 0)
> +	if (ret >= 0) {
>  		ret = reg_clear(client, MT9T031_OUTPUT_CONTROL, 1);
> -
> +		/* update the values */
> +		mt9t031->width	= rect->width,
> +		mt9t031->height	= rect->height,
> +		mt9t031->x_current = rect->left;
> +		mt9t031->y_current = rect->top;
> +	}
>  	return ret < 0 ? ret : 0;
>  }
>  
> -static int mt9t031_set_crop(struct soc_camera_device *icd,
> -			    struct v4l2_rect *rect)
> -{
> -	struct mt9t031 *mt9t031 = container_of(icd, struct mt9t031, icd);
> -
> -	/* CROP - no change in scaling, or in limits */
> -	return mt9t031_set_params(icd, rect, mt9t031->xskip, mt9t031->yskip);
> -}
> -
> -static int mt9t031_set_fmt(struct soc_camera_device *icd,
> +static int mt9t031_set_fmt(struct v4l2_subdev *sd,
>  			   struct v4l2_format *f)
>  {
> -	struct mt9t031 *mt9t031 = container_of(icd, struct mt9t031, icd);
> +	struct mt9t031 *mt9t031 = to_mt9t031(sd);
>  	int ret;
>  	u16 xskip, yskip;
>  	struct v4l2_rect rect = {
> -		.left	= icd->x_current,
> -		.top	= icd->y_current,
> +		.left	= mt9t031->x_current,
> +		.top	= mt9t031->y_current,
>  		.width	= f->fmt.pix.width,
>  		.height	= f->fmt.pix.height,
>  	};
> @@ -369,18 +400,17 @@ static int mt9t031_set_fmt(struct soc_camera_device *icd,
>  		if (rect.height * yskip <= MT9T031_MAX_HEIGHT)
>  			break;
>  
> -	recalculate_limits(icd, xskip, yskip);
> +	recalculate_limits(mt9t031, xskip, yskip);
>  
> -	ret = mt9t031_set_params(icd, &rect, xskip, yskip);
> +	ret = mt9t031_set_params(sd, &rect, xskip, yskip);
>  	if (!ret) {
>  		mt9t031->xskip = xskip;
>  		mt9t031->yskip = yskip;
>  	}
> -
>  	return ret;
>  }
>  
> -static int mt9t031_try_fmt(struct soc_camera_device *icd,
> +static int mt9t031_try_fmt(struct v4l2_subdev *sd,
>  			   struct v4l2_format *f)
>  {
>  	struct v4l2_pix_format *pix = &f->fmt.pix;
> @@ -396,19 +426,19 @@ static int mt9t031_try_fmt(struct soc_camera_device *icd,
>  
>  	pix->width &= ~0x01; /* has to be even */
>  	pix->height &= ~0x01; /* has to be even */
> -
>  	return 0;
>  }
>  
> -static int mt9t031_get_chip_id(struct soc_camera_device *icd,
> +static int mt9t031_get_chip_id(struct v4l2_subdev *sd,
>  			       struct v4l2_dbg_chip_ident *id)
>  {
> -	struct mt9t031 *mt9t031 = container_of(icd, struct mt9t031, icd);
> +	struct mt9t031 *mt9t031 = to_mt9t031(sd);
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);;
>  
>  	if (id->match.type != V4L2_CHIP_MATCH_I2C_ADDR)
>  		return -EINVAL;
>  
> -	if (id->match.addr != mt9t031->client->addr)
> +	if (id->match.addr != client->addr)
>  		return -ENODEV;
>  
>  	id->ident	= mt9t031->model;
> @@ -418,10 +448,11 @@ static int mt9t031_get_chip_id(struct soc_camera_device *icd,
>  }
>  
>  #ifdef CONFIG_VIDEO_ADV_DEBUG
> -static int mt9t031_get_register(struct soc_camera_device *icd,
> +static int mt9t031_get_register(struct v4l2_subdev *sd,
>  				struct v4l2_dbg_register *reg)
>  {
> -	struct i2c_client *client = to_i2c_client(icd->control);
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);;
> +	struct mt9t031 *mt9t031 = to_mt9t031(sd);
>  
>  	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0xff)
>  		return -EINVAL;
> @@ -437,10 +468,11 @@ static int mt9t031_get_register(struct soc_camera_device *icd,
>  	return 0;
>  }
>  
> -static int mt9t031_set_register(struct soc_camera_device *icd,
> +static int mt9t031_set_register(struct v4l2_subdev *sd,
>  				struct v4l2_dbg_register *reg)
>  {
> -	struct i2c_client *client = to_i2c_client(icd->control);
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	struct mt9t031 *mt9t031 = to_mt9t031(sd);
>  
>  	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0xff)
>  		return -EINVAL;
> @@ -455,85 +487,53 @@ static int mt9t031_set_register(struct soc_camera_device *icd,
>  }
>  #endif
>  
> -static const struct v4l2_queryctrl mt9t031_controls[] = {
> -	{
> -		.id		= V4L2_CID_VFLIP,
> -		.type		= V4L2_CTRL_TYPE_BOOLEAN,
> -		.name		= "Flip Vertically",
> -		.minimum	= 0,
> -		.maximum	= 1,
> -		.step		= 1,
> -		.default_value	= 0,
> -	}, {
> -		.id		= V4L2_CID_HFLIP,
> -		.type		= V4L2_CTRL_TYPE_BOOLEAN,
> -		.name		= "Flip Horizontally",
> -		.minimum	= 0,
> -		.maximum	= 1,
> -		.step		= 1,
> -		.default_value	= 0,
> -	}, {
> -		.id		= V4L2_CID_GAIN,
> -		.type		= V4L2_CTRL_TYPE_INTEGER,
> -		.name		= "Gain",
> -		.minimum	= 0,
> -		.maximum	= 127,
> -		.step		= 1,
> -		.default_value	= 64,
> -		.flags		= V4L2_CTRL_FLAG_SLIDER,
> -	}, {
> -		.id		= V4L2_CID_EXPOSURE,
> -		.type		= V4L2_CTRL_TYPE_INTEGER,
> -		.name		= "Exposure",
> -		.minimum	= 1,
> -		.maximum	= 255,
> -		.step		= 1,
> -		.default_value	= 255,
> -		.flags		= V4L2_CTRL_FLAG_SLIDER,
> -	}, {
> -		.id		= V4L2_CID_EXPOSURE_AUTO,
> -		.type		= V4L2_CTRL_TYPE_BOOLEAN,
> -		.name		= "Automatic Exposure",
> -		.minimum	= 0,
> -		.maximum	= 1,
> -		.step		= 1,
> -		.default_value	= 1,
> -	}
> -};
>  
> -static int mt9t031_video_probe(struct soc_camera_device *);
> -static void mt9t031_video_remove(struct soc_camera_device *);
> -static int mt9t031_get_control(struct soc_camera_device *, struct v4l2_control *);
> -static int mt9t031_set_control(struct soc_camera_device *, struct v4l2_control *);
> -
> -static struct soc_camera_ops mt9t031_ops = {
> -	.owner			= THIS_MODULE,
> -	.probe			= mt9t031_video_probe,
> -	.remove			= mt9t031_video_remove,
> -	.init			= mt9t031_init,
> -	.release		= mt9t031_release,
> -	.start_capture		= mt9t031_start_capture,
> -	.stop_capture		= mt9t031_stop_capture,
> -	.set_crop		= mt9t031_set_crop,
> -	.set_fmt		= mt9t031_set_fmt,
> -	.try_fmt		= mt9t031_try_fmt,
> -	.set_bus_param		= mt9t031_set_bus_param,
> -	.query_bus_param	= mt9t031_query_bus_param,
> -	.controls		= mt9t031_controls,
> -	.num_controls		= ARRAY_SIZE(mt9t031_controls),
> -	.get_control		= mt9t031_get_control,
> -	.set_control		= mt9t031_set_control,
> -	.get_chip_id		= mt9t031_get_chip_id,
> +static int mt9t031_get_control(struct v4l2_subdev *, struct v4l2_control *);
> +static int mt9t031_set_control(struct v4l2_subdev *, struct v4l2_control *);
> +static int mt9t031_queryctrl(struct v4l2_subdev *, struct v4l2_queryctrl *);
> +
> +static const struct v4l2_subdev_core_ops mt9t031_core_ops = {
> +	.g_chip_ident = mt9t031_get_chip_id,
> +	.init = mt9t031_init,
> +	.queryctrl = mt9t031_queryctrl,
> +	.g_ctrl	= mt9t031_get_control,
> +	.s_ctrl	= mt9t031_set_control,
>  #ifdef CONFIG_VIDEO_ADV_DEBUG
> -	.get_register		= mt9t031_get_register,
> -	.set_register		= mt9t031_set_register,
> +	.get_register = mt9t031_get_register,
> +	.set_register = mt9t031_set_register,
>  #endif
>  };
>  
> -static int mt9t031_get_control(struct soc_camera_device *icd, struct v4l2_control *ctrl)
> +static const struct v4l2_subdev_video_ops mt9t031_video_ops = {
> +	.s_fmt = mt9t031_set_fmt,
> +	.try_fmt = mt9t031_try_fmt,
> +	.s_stream = mt9t031_s_stream,
> +};
> +
> +static const struct v4l2_subdev_ops mt9t031_ops = {
> +	.core = &mt9t031_core_ops,
> +	.video = &mt9t031_video_ops,
> +};
> +
> +static int mt9t031_queryctrl(struct v4l2_subdev *sd,
> +			    struct v4l2_queryctrl *qctrl)
>  {
> -	struct i2c_client *client = to_i2c_client(icd->control);
> -	struct mt9t031 *mt9t031 = container_of(icd, struct mt9t031, icd);
> +	const struct v4l2_queryctrl *temp_qctrl;
> +
> +	temp_qctrl = mt9t031_find_qctrl(qctrl->id);
> +	if (!temp_qctrl) {
> +		v4l2_err(sd, "control id %d not supported", qctrl->id);
> +		return -EINVAL;
> +	}
> +	memcpy(qctrl, temp_qctrl, sizeof(*qctrl));
> +	return 0;
> +}
> +
> +static int mt9t031_get_control(struct v4l2_subdev *sd,
> +			       struct v4l2_control *ctrl)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	struct mt9t031 *mt9t031 = to_mt9t031(sd);
>  	int data;
>  
>  	switch (ctrl->id) {
> @@ -556,17 +556,22 @@ static int mt9t031_get_control(struct soc_camera_device *icd, struct v4l2_contro
>  	return 0;
>  }
>  
> -static int mt9t031_set_control(struct soc_camera_device *icd, struct v4l2_control *ctrl)
> +static int mt9t031_set_control(struct v4l2_subdev *sd,
> +			       struct v4l2_control *ctrl)
>  {
> -	struct i2c_client *client = to_i2c_client(icd->control);
> -	struct mt9t031 *mt9t031 = container_of(icd, struct mt9t031, icd);
> -	const struct v4l2_queryctrl *qctrl;
> +	struct mt9t031 *mt9t031 = to_mt9t031(sd);
> +	const struct v4l2_queryctrl *qctrl = NULL;
>  	int data;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  
> -	qctrl = soc_camera_find_qctrl(&mt9t031_ops, ctrl->id);
> +	if (NULL == ctrl)
> +		return -EINVAL;
>  
> -	if (!qctrl)
> +	qctrl = mt9t031_find_qctrl(ctrl->id);
> +	if (!qctrl) {
> +		v4l2_err(sd, "control id %d not supported", ctrl->id);
>  		return -EINVAL;
> +	}
>  
>  	switch (ctrl->id) {
>  	case V4L2_CID_VFLIP:
> @@ -594,7 +599,7 @@ static int mt9t031_set_control(struct soc_camera_device *icd, struct v4l2_contro
>  			unsigned long range = qctrl->default_value - qctrl->minimum;
>  			data = ((ctrl->value - qctrl->minimum) * 8 + range / 2) / range;
>  
> -			dev_dbg(&icd->dev, "Setting gain %d\n", data);
> +			v4l2_dbg(1, debug, sd, "Setting gain %d\n", data);
>  			data = reg_write(client, MT9T031_GLOBAL_GAIN, data);
>  			if (data < 0)
>  				return -EIO;
> @@ -606,40 +611,51 @@ static int mt9t031_set_control(struct soc_camera_device *icd, struct v4l2_contro
>  			unsigned long gain = ((ctrl->value - qctrl->default_value - 1) *
>  					       1015 + range / 2) / range + 9;
>  
> -			if (gain <= 32)		/* calculated gain 9..32 -> 9..32 */
> +			if (gain <= 32)
> +				/* calculated gain 9..32 -> 9..32 */
>  				data = gain;
> -			else if (gain <= 64)	/* calculated gain 33..64 -> 0x51..0x60 */
> +			else if (gain <= 64)
> +				/* calculated gain 33..64 -> 0x51..0x60 */
>  				data = ((gain - 32) * 16 + 16) / 32 + 80;
>  			else
> -				/* calculated gain 65..1024 -> (1..120) << 8 + 0x60 */
> +				/*
> +				 * calculated gain 65..1024 -> (1..120) << 8 +
> +				 * 0x60
> +				 */
>  				data = (((gain - 64 + 7) * 32) & 0xff00) | 0x60;
>  
> -			dev_dbg(&icd->dev, "Setting gain from 0x%x to 0x%x\n",
> -				reg_read(client, MT9T031_GLOBAL_GAIN), data);
> +			v4l2_dbg(1, debug, sd, "Setting gain from 0x%x to"
> +				 "0x%x\n",
> +				 reg_read(client, MT9T031_GLOBAL_GAIN), data);
> +
>  			data = reg_write(client, MT9T031_GLOBAL_GAIN, data);
>  			if (data < 0)
>  				return -EIO;
>  		}
>  
>  		/* Success */
> -		icd->gain = ctrl->value;
> +		mt9t031->gain = ctrl->value;
>  		break;
>  	case V4L2_CID_EXPOSURE:
>  		/* mt9t031 has maximum == default */
> -		if (ctrl->value > qctrl->maximum || ctrl->value < qctrl->minimum)
> +		if (ctrl->value > qctrl->maximum ||
> +		    ctrl->value < qctrl->minimum)
>  			return -EINVAL;
>  		else {
> -			const unsigned long range = qctrl->maximum - qctrl->minimum;
> -			const u32 shutter = ((ctrl->value - qctrl->minimum) * 1048 +
> -					     range / 2) / range + 1;
> +			const unsigned long range =
> +				qctrl->maximum - qctrl->minimum;
> +			const u32 shutter =
> +				((ctrl->value - qctrl->minimum) * 1048 +
> +					range / 2) / range + 1;
>  			u32 old;
>  
> -			get_shutter(client, &old);
> -			dev_dbg(&icd->dev, "Setting shutter width from %u to %u\n",
> +			get_shutter(sd, &old);
> +			v4l2_dbg(1, debug, sd,
> +				"Setting shutter width from %u to %u\n",
>  				old, shutter);
> -			if (set_shutter(client, shutter) < 0)
> +			if (set_shutter(sd, shutter) < 0)
>  				return -EIO;
> -			icd->exposure = ctrl->value;
> +			mt9t031->exposure = ctrl->value;
>  			mt9t031->autoexposure = 0;
>  		}
>  		break;
> @@ -647,13 +663,15 @@ static int mt9t031_set_control(struct soc_camera_device *icd, struct v4l2_contro
>  		if (ctrl->value) {
>  			const u16 vblank = MT9T031_VERTICAL_BLANK;
>  			const u32 shutter_max = MT9T031_MAX_HEIGHT + vblank;
> -			if (set_shutter(client, icd->height +
> -					icd->y_skip_top + vblank) < 0)
> +			if (set_shutter(sd, mt9t031->height +
> +					mt9t031->y_skip_top + vblank) < 0)
>  				return -EIO;
> -			qctrl = soc_camera_find_qctrl(icd->ops, V4L2_CID_EXPOSURE);
> -			icd->exposure = (shutter_max / 2 + (icd->height +
> -					 icd->y_skip_top + vblank - 1) *
> -					 (qctrl->maximum - qctrl->minimum)) /
> +
> +			qctrl = mt9t031_find_qctrl(V4L2_CID_EXPOSURE);
> +			mt9t031->exposure =
> +				(shutter_max / 2 + (mt9t031->height +
> +				mt9t031->y_skip_top + vblank - 1) *
> +				(qctrl->maximum - qctrl->minimum)) /
>  				shutter_max + qctrl->minimum;
>  			mt9t031->autoexposure = 1;
>  		} else
> @@ -665,130 +683,102 @@ static int mt9t031_set_control(struct soc_camera_device *icd, struct v4l2_contro
>  
>  /* Interface active, can use i2c. If it fails, it can indeed mean, that
>   * this wasn't our capture interface, so, we wait for the right one */
> -static int mt9t031_video_probe(struct soc_camera_device *icd)
> +static int mt9t031_detect(struct i2c_client *client, int *model)
>  {
> -	struct i2c_client *client = to_i2c_client(icd->control);
> -	struct mt9t031 *mt9t031 = container_of(icd, struct mt9t031, icd);
>  	s32 data;
> -	int ret;
> -
> -	/* We must have a parent by now. And it cannot be a wrong one.
> -	 * So this entire test is completely redundant. */
> -	if (!icd->dev.parent ||
> -	    to_soc_camera_host(icd->dev.parent)->nr != icd->iface)
> -		return -ENODEV;
>  
>  	/* Enable the chip */
>  	data = reg_write(client, MT9T031_CHIP_ENABLE, 1);
> -	dev_dbg(&icd->dev, "write: %d\n", data);
> +	dev_dbg(&client->dev, "write: %d\n", data);
>  
>  	/* Read out the chip version register */
>  	data = reg_read(client, MT9T031_CHIP_VERSION);
>  
>  	switch (data) {
>  	case 0x1621:
> -		mt9t031->model = V4L2_IDENT_MT9T031;
> -		icd->formats = mt9t031_colour_formats;
> -		icd->num_formats = ARRAY_SIZE(mt9t031_colour_formats);
> +		*model = V4L2_IDENT_MT9T031;
>  		break;
>  	default:
> -		ret = -ENODEV;
> -		dev_err(&icd->dev,
> +		dev_err(&client->dev,
>  			"No MT9T031 chip detected, register read %x\n", data);
> -		goto ei2c;
> +		return -ENODEV;
>  	}
>  
> -	dev_info(&icd->dev, "Detected a MT9T031 chip ID %x\n", data);
> -
> -	/* Now that we know the model, we can start video */
> -	ret = soc_camera_video_start(icd);
> -	if (ret)
> -		goto evstart;
> -
> +	dev_info(&client->dev, "Detected a MT9T031 chip ID %x\n", data);
>  	return 0;
> -
> -evstart:
> -ei2c:
> -	return ret;
> -}
> -
> -static void mt9t031_video_remove(struct soc_camera_device *icd)
> -{
> -	struct mt9t031 *mt9t031 = container_of(icd, struct mt9t031, icd);
> -
> -	dev_dbg(&icd->dev, "Video %x removed: %p, %p\n", mt9t031->client->addr,
> -		icd->dev.parent, icd->vdev);
> -	soc_camera_video_stop(icd);
>  }
>  
>  static int mt9t031_probe(struct i2c_client *client,
>  			 const struct i2c_device_id *did)
>  {
>  	struct mt9t031 *mt9t031;
> -	struct soc_camera_device *icd;
> -	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
> -	struct soc_camera_link *icl = client->dev.platform_data;
> +	struct v4l2_subdev *sd;
> +	int pclk_pol;
>  	int ret;
>  
> -	if (!icl) {
> -		dev_err(&client->dev, "MT9T031 driver needs platform data\n");
> -		return -EINVAL;
> -	}
> -
> -	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WORD_DATA)) {
> -		dev_warn(&adapter->dev,
> +	if (!i2c_check_functionality(client->adapter,
> +				     I2C_FUNC_SMBUS_WORD_DATA)) {
> +		dev_warn(&client->dev,
>  			 "I2C-Adapter doesn't support I2C_FUNC_SMBUS_WORD\n");
>  		return -EIO;
>  	}
>  
> +	if (!client->dev.platform_data) {
> +		dev_err(&client->dev, "No platform data!!\n");
> +		return -ENODEV;
> +	}
> +
> +	pclk_pol = (int)client->dev.platform_data;
> +
>  	mt9t031 = kzalloc(sizeof(struct mt9t031), GFP_KERNEL);
>  	if (!mt9t031)
>  		return -ENOMEM;
>  
> -	mt9t031->client = client;
> -	i2c_set_clientdata(client, mt9t031);
> -
> -	/* Second stage probe - when a capture adapter is there */
> -	icd = &mt9t031->icd;
> -	icd->ops	= &mt9t031_ops;
> -	icd->control	= &client->dev;
> -	icd->x_min	= MT9T031_COLUMN_SKIP;
> -	icd->y_min	= MT9T031_ROW_SKIP;
> -	icd->x_current	= icd->x_min;
> -	icd->y_current	= icd->y_min;
> -	icd->width_min	= MT9T031_MIN_WIDTH;
> -	icd->width_max	= MT9T031_MAX_WIDTH;
> -	icd->height_min	= MT9T031_MIN_HEIGHT;
> -	icd->height_max	= MT9T031_MAX_HEIGHT;
> -	icd->y_skip_top	= 0;
> -	icd->iface	= icl->bus_id;
> -	/* Simulated autoexposure. If enabled, we calculate shutter width
> -	 * ourselves in the driver based on vertical blanking and frame width */
> +	ret = mt9t031_detect(client, &mt9t031->model);
> +	if (ret)
> +		goto clean;
> +
> +	mt9t031->x_min		= MT9T031_COLUMN_SKIP;
> +	mt9t031->y_min		= MT9T031_ROW_SKIP;
> +	mt9t031->width		= MT9T031_DEFAULT_WIDTH;
> +	mt9t031->height		= MT9T031_DEFAULT_WIDTH;
> +	mt9t031->x_current	= mt9t031->x_min;
> +	mt9t031->y_current	= mt9t031->y_min;
> +	mt9t031->width_min	= MT9T031_MIN_WIDTH;
> +	mt9t031->width_max	= MT9T031_MAX_WIDTH;
> +	mt9t031->height_min	= MT9T031_MIN_HEIGHT;
> +	mt9t031->height_max	= MT9T031_MAX_HEIGHT;
> +	mt9t031->y_skip_top	= 0;
>  	mt9t031->autoexposure = 1;
> -
>  	mt9t031->xskip = 1;
>  	mt9t031->yskip = 1;
>  
> -	ret = soc_camera_device_register(icd);
> -	if (ret)
> -		goto eisdr;
> +	/* Register with V4L2 layer as slave device */
> +	sd = &mt9t031->sd;
> +	v4l2_i2c_subdev_init(sd, client, &mt9t031_ops);
> +	if (!pclk_pol)
> +		reg_clear(v4l2_get_subdevdata(sd),
> +			  MT9T031_PIXEL_CLOCK_CONTROL, 0x8000);
> +	else
> +		reg_set(v4l2_get_subdevdata(sd),
> +			MT9T031_PIXEL_CLOCK_CONTROL, 0x8000);
>  
> +	v4l2_info(sd, "%s decoder driver registered !!\n", sd->name);
>  	return 0;
>  
> -eisdr:
> -	i2c_set_clientdata(client, NULL);
> +clean:
>  	kfree(mt9t031);
>  	return ret;
>  }
>  
>  static int mt9t031_remove(struct i2c_client *client)
>  {
> -	struct mt9t031 *mt9t031 = i2c_get_clientdata(client);
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +	struct mt9t031 *mt9t031 = to_mt9t031(sd);
>  
> -	soc_camera_device_unregister(&mt9t031->icd);
> -	i2c_set_clientdata(client, NULL);
> -	kfree(mt9t031);
> +	v4l2_device_unregister_subdev(sd);
>  
> +	kfree(mt9t031);
>  	return 0;
>  }
>  
> -- 
> 1.6.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
