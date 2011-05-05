Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53972 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819Ab1EEQzE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 May 2011 12:55:04 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: javier Martin <javier.martin@vista-silicon.com>
Subject: Re: Current status report of mt9p031.
Date: Thu, 5 May 2011 18:55:32 +0200
Cc: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Chris Rodley <carlighting@yahoo.co.nz>
References: <BANLkTi=pS07RymXLOFsRihd5Jso-y6OsHg@mail.gmail.com>
In-Reply-To: <BANLkTi=pS07RymXLOFsRihd5Jso-y6OsHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105051855.32405.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Javier,

Here's the review of 0002-mt9p031.patch.

> diff --git a/arch/arm/mach-omap2/board-omap3beagle-camera.c b/arch/arm/mach
> -omap2/board-omap3beagle-camera.c
> new file mode 100644
> index 0000000..92389dd
> --- /dev/null
> +++ b/arch/arm/mach-omap2/board-omap3beagle-camera.c
> @@ -0,0 +1,158 @@

[snip]

(This is clearly proof of concept code given the amount of lines that are 
commented out, so I'll skip the review.)

> +module_init(beagle_camera_init);
> +module_exit(beagle_camera_exit);
> +
> +MODULE_LICENSE("GPL v2");

The OMAP3 ISP isn't supposed to be registered in a loadable module. There have 
been preliminary discussions regarding how to properly achieve this, but not 
decision yet. For now it should be built-in, and you should use the 
omap3_init_camera() function.

> diff --git a/drivers/media/video/mt9p031.c b/drivers/media/video/mt9p031.c
> new file mode 100644
> index 0000000..d42d783
> --- /dev/null
> +++ b/drivers/media/video/mt9p031.c
> @@ -0,0 +1,884 @@
> +#include <linux/delay.h>
> +#include <linux/device.h>
> +#include <linux/i2c.h>
> +#include <linux/log2.h>
> +#include <linux/pm.h>
> +#include <linux/regulator/consumer.h>
> +#include <linux/slab.h>
> +#include <media/v4l2-subdev.h>
> +#include <linux/videodev2.h>
> +
> +#include <media/mt9p031.h>
> +#include <media/v4l2-chip-ident.h>
> +#include <media/v4l2-subdev.h>
> +#include <media/v4l2-device.h>
> +
> +/*
> + * mt9p031 i2c address 0x5d (0xBA read, 0xBB write) same as mt9t031
> + * The platform has to define i2c_board_info and link to it from
> + * struct soc_camera_link
> + */
> +
> +/* mt9p031 selected register addresses */
> +#define MT9P031_CHIP_VERSION		0x00
> +#define MT9P031_ROW_START		0x01
> +#define MT9P031_COLUMN_START		0x02
> +#define MT9P031_WINDOW_HEIGHT		0x03
> +#define MT9P031_WINDOW_WIDTH		0x04
> +#define MT9P031_HORIZONTAL_BLANKING	0x05
> +#define MT9P031_VERTICAL_BLANKING	0x06
> +#define MT9P031_OUTPUT_CONTROL		0x07
> +#define MT9P031_SHUTTER_WIDTH_UPPER	0x08
> +#define MT9P031_SHUTTER_WIDTH		0x09
> +#define MT9P031_PIXEL_CLOCK_CONTROL	0x0a
> +#define MT9P031_FRAME_RESTART		0x0b
> +#define MT9P031_SHUTTER_DELAY		0x0c
> +#define MT9P031_RESET			0x0d
> +#define MT9P031_READ_MODE_1		0x1e
> +#define MT9P031_READ_MODE_2		0x20
> +//#define MT9T031_READ_MODE_3		0x21 // NA readmode_2 is 2 bytes

No commented out code please, and C code should be commented with /* ... */ in 
the Linux kernel.

> +#define MT9P031_ROW_ADDRESS_MODE	0x22
> +#define MT9P031_COLUMN_ADDRESS_MODE	0x23
> +#define MT9P031_GLOBAL_GAIN		0x35
> +//#define MT9T031_CHIP_ENABLE		0xF8 // PDN is pin signal. no i2c 
register
> +
> +#define MT9P031_MAX_HEIGHT		1944
> +#define MT9P031_MAX_WIDTH		2592
> +#define MT9P031_MIN_HEIGHT		2
> +#define MT9P031_MIN_WIDTH		18
> +#define MT9P031_HORIZONTAL_BLANK	0
> +#define MT9P031_VERTICAL_BLANK		25
> +#define MT9P031_COLUMN_SKIP		16
> +#define MT9P031_ROW_SKIP		54
> +
> +#define MT9P031_CHIP_VERSION_VALUE	0x1801

Could you move those constants just below the register that uses them, and 
make sure they have names that start with the register name ? Have a look at 
http://git.linuxtv.org/pinchartl/media.git?a=commit;h=d3fd150967a90a99fadd24ad4f5b4c1cce833493 
for an example.

> +/*
> +#define MT9T031_BUS_PARAM	(SOCAM_PCLK_SAMPLE_RISING |	\
> +	SOCAM_PCLK_SAMPLE_FALLING | SOCAM_HSYNC_ACTIVE_HIGH |	\
> +	SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_DATA_ACTIVE_HIGH |	\
> +	SOCAM_MASTER | SOCAM_DATAWIDTH_10)
> +*/
> +struct mt9p031 {
> +	struct v4l2_subdev subdev;
> +        struct media_pad pad;

s/        /\t/. Please run scripts/checkpatch.pl on your patches and fix the 
reported warnings and errors.

> +
> +	struct v4l2_rect rect;	/* Sensor window */
> +	struct v4l2_mbus_framefmt format;
> +	int model;	/* V4L2_IDENT_MT9P031* codes from v4l2-chip-ident.h */
> +	u16 xskip;
> +	u16 yskip;
> +	struct regulator *reg_1v8, *reg_2v8;
> +};

[snip]

> +static int reg_set(struct i2c_client *client, const u8 reg,
> +		   const u16 data)
> +{
> +	int ret;
> +
> +	ret = reg_read(client, reg);
> +	if (ret < 0)
> +		return ret;
> +	return reg_write(client, reg, ret | data);

To avoid an unnecessary I2C transaction, I would cache the register value in 
the driver instead of reading it back from the device.

> +}

[snip]

> +static int set_shutter(struct i2c_client *client, const u32 data)

This function isn't used.

> +{
> +	int ret;
> +
> +	ret = reg_write(client, MT9P031_SHUTTER_WIDTH_UPPER, data >> 16);
> +
> +	if (ret >= 0)
> +		ret = reg_write(client, MT9P031_SHUTTER_WIDTH, data & 0xffff);
> +
> +	return ret;
> +}
> +
> +static int get_shutter(struct i2c_client *client, u32 *data)

And this one isn't used either.

> +{
> +	int ret;
> +
> +	ret = reg_read(client, MT9P031_SHUTTER_WIDTH_UPPER);
> +	*data = ret << 16;
> +
> +	if (ret >= 0)
> +		ret = reg_read(client, MT9P031_SHUTTER_WIDTH);
> +	*data |= ret & 0xffff;
> +
> +	return ret < 0 ? ret : 0;
> +}
> +
> +static int mt9p031_idle(struct i2c_client *client)
> +{
> +        int ret;
> +
> +        /* Disable chip output, synchronous option update */
> +        ret = reg_write(client, MT9P031_RESET, 1);
> +        if (!ret)

Please bail out in case of error (with a goto done; for instance), and 
continue when everything goes fine. The code flow gets difficult to read 
otherwise. This applies elsewhere in the driver as well.

> +                ret = reg_write(client, MT9P031_RESET, 0);
> +        if (!ret)
> +                ret = reg_clear(client, MT9P031_OUTPUT_CONTROL, 2);

Please define constants for register contents instead of using magic values.

> +
> +        return ret >= 0 ? 0 : -EIO;
> +}
> +
> +static int mt9p031_enum_mbus_code(struct v4l2_subdev *sd,
> +                                  struct v4l2_subdev_fh *fh,
> +                                  struct v4l2_subdev_mbus_code_enum *code)
> +{
> +	struct mt9p031 *mt9p031 = container_of(sd, struct mt9p031, subdev);
> +
> +	if (code->pad || code->index)
> +		return -EINVAL;
> +
> +	code->code = mt9p031->format.code;
> +
> +        return 0;
> +}
> +#if 0
> +static int mt9p031_enum_frame_size(struct v4l2_subdev *sd,
> +                                   struct v4l2_subdev_fh *fh,
> +                                   struct v4l2_subdev_frame_size_enum *fse)
> +{
> +	pr_info("%s()\n", __func__);
> +       	return 0;
> +}
> +#endif

No commented out code please.

> +static struct v4l2_mbus_framefmt *mt9p031_get_pad_format(struct mt9p031
> *mt9p031,
> +			struct v4l2_subdev_fh *fh, unsigned int pad, u32 which)
> +{
> +	switch (which) {
> +	case V4L2_SUBDEV_FORMAT_TRY:
> +		return v4l2_subdev_get_try_format(fh, pad);
> +	case V4L2_SUBDEV_FORMAT_ACTIVE:
> +		return &mt9p031->format;
> +	default:
> +		return NULL;
> +	}
> +}
> +
> +static struct v4l2_rect *mt9p031_get_pad_crop(struct mt9p031 *mt9p031,
> +			struct v4l2_subdev_fh *fh, unsigned int pad, u32 which)
> +{
> +	switch (which) {
> +	case V4L2_SUBDEV_FORMAT_TRY:
> +		return v4l2_subdev_get_try_crop(fh, pad);
> +	case V4L2_SUBDEV_FORMAT_ACTIVE:
> +		return &mt9p031->rect;
> +	default:
> +		return NULL;
> +	}
> +}
> +
> +static int mt9p031_get_crop(struct v4l2_subdev *sd,
> +                            struct v4l2_subdev_fh *fh,
> +                            struct v4l2_subdev_crop *crop)
> +{
> +	struct mt9p031 *mt9p031 = container_of(sd, struct mt9p031, subdev);
> +	struct v4l2_rect *rect = mt9p031_get_pad_crop(mt9p031, fh, crop->pad,
> +							crop->which);
> +	pr_info("%s()\n", __func__);
> +
> +	if (!rect)
> +		return -EINVAL;
> +
> +	crop->rect = *rect;
> +
> +        return 0;
> +}
> +
> +static u16 mt9p031_skip_for_crop(s32 source, s32 *target, s32 max_skip)
> +{
> +	unsigned int skip;
> +
> +	if (source - source / 4 < *target) {
> +		*target = source;
> +		return 1;
> +	}
> +
> +	skip = (source + *target / 2) / *target;

Please use DIV_ROUND_CLOSEST.

> +	if (skip > max_skip)
> +		skip = max_skip;
> +
> +	*target = 2 * ((source + 2 * skip - 1) / (2 * skip));

and DIV_ROUND_UP.

> +
> +	return skip;
> +}
> +
> +static int mt9p031_set_params(struct i2c_client *client,
> +			      struct v4l2_rect *rect, u16 xskip, u16 yskip)
> +{
> +	struct mt9p031 *mt9p031 = to_mt9p031(client);
> +	int ret;
> +	u16 xbin, ybin;
> +	const u16 hblank = MT9P031_HORIZONTAL_BLANK,
> +		vblank = MT9P031_VERTICAL_BLANK;
> +
> +	/*
> +	 * TODO: Attention! When implementing horizontal flipping, adjust
> +	 * alignment according to R2 "Column Start" description in the datasheet
> +	 */
> +	if (xskip & 1) {
> +		xbin = 1;
> +		rect->left &= ~3;
> +	} else if (xskip & 2) {
> +		xbin = 2;
> +		rect->left &= ~7;
> +	} else {
> +		xbin = 4;
> +		rect->left &= ~15;
> +	}
> +
> +	ybin = min(yskip, (u16)4);
> +
> +	rect->top &= ~1;
> +
> +	/* Disable register update, reconfigure atomically */
> +	ret = reg_set(client, MT9P031_OUTPUT_CONTROL, 1);
> +	if (ret < 0)
> +		return ret;
> +
> +	dev_dbg(&client->dev, "skip %u:%u, rect %ux%u@%u:%u\n",
> +		xskip, yskip, rect->width, rect->height, rect->left, rect->top);
> +
> +	/* Blanking and start values - default... */
> +	ret = reg_write(client, MT9P031_HORIZONTAL_BLANKING, hblank);
> +	if (!ret)
> +		ret = reg_write(client, MT9P031_VERTICAL_BLANKING, vblank);
> +
> +	if (yskip != mt9p031->yskip || xskip != mt9p031->xskip) {
> +		/* Binning, skipping */
> +		if (!ret)
> +			ret = reg_write(client, MT9P031_COLUMN_ADDRESS_MODE,
> +					((xbin - 1) << 4) | (xskip - 1));
> +		if (!ret)
> +			ret = reg_write(client, MT9P031_ROW_ADDRESS_MODE,
> +					((ybin - 1) << 4) | (yskip - 1));
> +	}
> +	dev_dbg(&client->dev, "new physical left %u, top %u\n",
> +		rect->left, rect->top);
> +
> +	if (!ret)
> +		ret = reg_write(client, MT9P031_COLUMN_START,
> +				rect->left + MT9P031_COLUMN_SKIP);
> +	if (!ret)
> +		ret = reg_write(client, MT9P031_ROW_START,
> +				rect->top + MT9P031_ROW_SKIP);
> +	if (!ret)
> +		ret = reg_write(client, MT9P031_WINDOW_WIDTH,
> +				rect->width - 1);
> +	if (!ret)
> +		ret = reg_write(client, MT9P031_WINDOW_HEIGHT,
> +				rect->height - 1);
> +
> +	/* Re-enable register update, commit all changes */
> +	if (!ret)
> +		ret = reg_clear(client, MT9P031_OUTPUT_CONTROL, 1);
> +
> +	if (!ret) {
> +		mt9p031->xskip = xskip;
> +		mt9p031->yskip = yskip;
> +	}
> +
> +	return ret;
> +}
> +
> +static int mt9p031_set_crop(struct v4l2_subdev *sd,
> +                            struct v4l2_subdev_fh *fh,
> +                            struct v4l2_subdev_crop *crop)
> +{	
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	struct mt9p031 *mt9p031 = container_of(sd, struct mt9p031, subdev);
> +	struct v4l2_mbus_framefmt *f;
> +	struct v4l2_rect *c;
> +	struct v4l2_rect rect;
> +	u16 xskip, yskip;
> +	s32 width, height;
> +	int ret;
> +
> +	pr_info("%s(%ux%u@%u:%u : %u)\n", __func__,
> +		crop->rect.width, crop->rect.height, crop->rect.left, crop->rect.top, 
crop->which);
> +
> +	/*
> +	 * Clamp the crop rectangle boundaries and align them to a multiple of 2
> +	 * pixels.
> +	 */
> +	rect.width = ALIGN(clamp(crop->rect.width,
> +				 MT9P031_MIN_WIDTH, MT9P031_MAX_WIDTH), 2);
> +	rect.height = ALIGN(clamp(crop->rect.height,
> +				  MT9P031_MIN_HEIGHT, MT9P031_MAX_HEIGHT), 2);
> +	rect.left = ALIGN(clamp(crop->rect.left,
> +				0, MT9P031_MAX_WIDTH - rect.width), 2);
> +	rect.top = ALIGN(clamp(crop->rect.top,
> +			       0, MT9P031_MAX_HEIGHT - rect.height), 2);
> +
> +	c = mt9p031_get_pad_crop(mt9p031, fh, crop->pad, crop->which);
> +
> +#if 1
> +	if (rect.width != c->width || rect.height != c->height) {
> +		/*
> +		 * Reset the output image size if the crop rectangle size has
> +		 * been modified.
> +		 */
> +		f = mt9p031_get_pad_format(mt9p031, fh, crop->pad,
> +						    crop->which);
> +		width = f->width;
> +		height = f->height;
> +
> +		xskip = mt9p031_skip_for_crop(rect.width, &width, 7);
> +		yskip = mt9p031_skip_for_crop(rect.height, &height, 8);
> +	} else {
> +		xskip = mt9p031->xskip;
> +		yskip = mt9p031->yskip;
> +		f = NULL;
> +	}
> +
> +	if (crop->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
> +		ret = mt9p031_set_params(client, &rect, xskip, yskip);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	if (f) {
> +		f->width = width;
> +		f->height = height;
> +	}
> +#else
> +	f = mt9p031_get_pad_format(mt9p031, fh, crop->pad,
> +					    crop->which);
> +	f->width = rect.width;
> +	f->height = rect.height;
> +#endif
> +
> +	*c = rect;
> +	crop->rect = rect;
> +
> +	return 0;
> +}
> +
> +static int mt9p031_get_format(struct v4l2_subdev *sd,
> +                              struct v4l2_subdev_fh *fh,
> +                              struct v4l2_subdev_format *fmt)
> +{
> +	struct mt9p031 *mt9p031 = container_of(sd, struct mt9p031, subdev);
> +//	fmt->format = mt9p031->format;
> +	pr_info("%s()\n", __func__);
> +
> +	fmt->format = *mt9p031_get_pad_format(mt9p031, fh, fmt->pad, fmt->which);
> +        return 0;
> +}
> +
> +static u16 mt9p031_skip_for_scale(s32 *source, s32 target, s32 max_skip, 
s32 max)
> +{
> +	unsigned int skip;
> +
> +	if (*source - *source / 4 < target) {
> +		*source = target;
> +		return 1;
> +	}
> +
> +	skip = min(max, *source + target / 2) / target;
> +	if (skip > max_skip)
> +		skip = max_skip;
> +	*source = target * skip;
> +
> +	return skip;
> +}
> +
> +static int mt9p031_fmt_validate(struct v4l2_subdev *sd, struct 
v4l2_subdev_format *fmt)
> +{
> +	struct mt9p031 *mt9p031 = container_of(sd, struct mt9p031, subdev);
> +	struct v4l2_mbus_framefmt *format = &fmt->format;
> +
> +	if (format->code != mt9p031->format.code || fmt->pad)
> +		return -EINVAL;
> +
> +	format->colorspace = V4L2_COLORSPACE_SRGB;
> +	format->width = clamp_t(int, ALIGN(format->width, 2), 2, 
MT9P031_MAX_WIDTH);
> +	format->height = clamp_t(int, ALIGN(format->height, 2), 2, 
MT9P031_MAX_HEIGHT);
> +	format->field = V4L2_FIELD_NONE;
> +
> +	return 0;
> +}
> +
> +static int mt9p031_set_format(struct v4l2_subdev *sd,
> +                              struct v4l2_subdev_fh *fh,
> +                              struct v4l2_subdev_format *fmt)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	struct v4l2_subdev_format sdf = *fmt;
> +	struct v4l2_mbus_framefmt *f, *format = &sdf.format;
> +	struct v4l2_rect *c, rect;
> +	struct mt9p031 *mt9p031 = container_of(sd, struct mt9p031, subdev);
> +	u16 xskip, yskip;
> +	int ret;
> +
> +	ret = mt9p031_fmt_validate(sd, &sdf);
> +	if (ret < 0)
> +		return ret;
> +
> +	f = mt9p031_get_pad_format(mt9p031, fh, fmt->pad, fmt->which);
> +
> +	if (f->width != format->width || f->height != format->height) {
> +		c = mt9p031_get_pad_crop(mt9p031, fh, fmt->pad, fmt->which);
> +
> +		rect.width = c->width;
> +		rect.height = c->height;
> +
> +		xskip = mt9p031_skip_for_scale(&rect.width, format->width, 7, 
MT9P031_MAX_WIDTH);
> +		if (rect.width + c->left > MT9P031_MAX_WIDTH)
> +			rect.left = (MT9P031_MAX_WIDTH - rect.width) / 2;
> +		else
> +			rect.left = c->left;
> +		yskip = mt9p031_skip_for_scale(&rect.height, format->height, 8, 
MT9P031_MAX_HEIGHT);
> +		if (rect.height + c->top > MT9P031_MAX_HEIGHT)
> +			rect.top = (MT9P031_MAX_HEIGHT - rect.height) / 2;
> +		else
> +			rect.top = c->top;
> +	} else {
> +		xskip = mt9p031->xskip;
> +		yskip = mt9p031->yskip;
> +		c = NULL;
> +	}
> +
> +	pr_info("%s(%ux%u : %u)\n", __func__, format->width, format->height, fmt-
>which);
> +
> +	if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
> +		/* mt9p031_set_params() doesn't change width and height */
> +		ret = mt9p031_set_params(client, &rect, xskip, yskip);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	if (c)
> +		*c = rect;
> +
> +	*f = *format;
> +	fmt->format = *format;
> +
> +	return 0;
> +#if 0
> +//	fmt->format = mt9p031->format;
> +        ret = mt9p031_set_crop(sd, fh, &crop);
> +	if (!ret)
> +		fmt->format = *mt9p031_get_pad_format(mt9p031, fh, fmt->pad, fmt-
>which);
> +
> +	return ret;
> +#endif
> +}
> +
> +static int mt9p031_s_stream(struct v4l2_subdev *sd, int enable)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	int ret;
> +
> +	if (enable)
> +		/* Switch to master "normal" mode */
> +		ret = reg_set(client, MT9P031_OUTPUT_CONTROL, 2);
> +	else
> +		/* Stop sensor readout */
> +		ret = reg_clear(client, MT9P031_OUTPUT_CONTROL, 2);
> +
> +	if (ret < 0)
> +		return -EIO;
> +
> +	return 0;
> +}
> +
> +enum {
> +        MT9P031_CTRL_VFLIP,
> +        MT9P031_CTRL_HFLIP,
> +        MT9P031_CTRL_GAIN,
> +        MT9P031_CTRL_EXPOSURE,
> +        MT9P031_CTRL_EXPOSURE_AUTO,
> +};
> +
> +static const struct v4l2_queryctrl mt9p031_controls[] = {
> +	[MT9P031_CTRL_VFLIP] = {
> +		.id		= V4L2_CID_VFLIP,
> +		.type		= V4L2_CTRL_TYPE_BOOLEAN,
> +		.name		= "Flip Vertically",
> +		.minimum	= 0,
> +		.maximum	= 1,
> +		.step		= 1,
> +		.default_value	= 0,
> +	},
> +	[MT9P031_CTRL_HFLIP] = {
> +		.id		= V4L2_CID_HFLIP,
> +		.type		= V4L2_CTRL_TYPE_BOOLEAN,
> +		.name		= "Flip Horizontally",
> +		.minimum	= 0,
> +		.maximum	= 1,
> +		.step		= 1,
> +		.default_value	= 0,
> +	},
> +};
> +
> +static int mt9p031_g_chip_ident(struct v4l2_subdev *sd,
> +				struct v4l2_dbg_chip_ident *id)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	struct mt9p031 *mt9p031 = container_of(sd, struct mt9p031, subdev);
> +
> +	if (id->match.type != V4L2_CHIP_MATCH_I2C_ADDR)
> +		return -EINVAL;
> +
> +	if (id->match.addr != client->addr)
> +		return -ENODEV;
> +
> +	id->ident	= mt9p031->model;
> +	id->revision	= 0;
> +
> +	return 0;
> +}
> +
> +static int mt9p031_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control 
*ctrl)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	int data;
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_VFLIP:
> +		data = reg_read(client, MT9P031_READ_MODE_2);
> +		if (data < 0)
> +			return -EIO;
> +		ctrl->value = !!(data & 0x8000);
> +		break;
> +	case V4L2_CID_HFLIP:
> +		data = reg_read(client, MT9P031_READ_MODE_2);
> +		if (data < 0)
> +			return -EIO;
> +		ctrl->value = !!(data & 0x4000);
> +		break;
> +	}
> +	return 0;
> +}
> +
> +static int mt9p031_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control 
*ctrl)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	int data;
> +
> +	pr_info("%s()\n", __func__);
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_VFLIP:
> +		if (ctrl->value)
> +			data = reg_set(client, MT9P031_READ_MODE_2, 0x8000);
> +		else
> +			data = reg_clear(client, MT9P031_READ_MODE_2, 0x8000);
> +		if (data < 0)
> +			return -EIO;
> +		break;
> +	case V4L2_CID_HFLIP:
> +		if (ctrl->value)
> +			data = reg_set(client, MT9P031_READ_MODE_2, 0x4000);
> +		else
> +			data = reg_clear(client, MT9P031_READ_MODE_2, 0x4000);
> +		if (data < 0)
> +			return -EIO;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
> +/*
> +static struct dev_pm_ops mt9p031_dev_pm_ops = {
> +	.runtime_suspend	= mt9p031_runtime_suspend,
> +	.runtime_resume		= mt9p031_runtime_resume,
> +};
> +
> +static struct device_type mt9p031_dev_type = {
> +	.name	= "MT9P031",
> +	.pm	= &mt9p031_dev_pm_ops,
> +};
> +*/
> +
> +/*
> + * Interface active, can use i2c. If it fails, it can indeed mean, that
> + * this wasn't our capture interface, so, we wait for the right one
> + */
> +static int mt9p031_video_probe(struct i2c_client *client)
> +{
> +	struct mt9p031 *mt9p031 = to_mt9p031(client);
> +	s32 data;
> +	int ret;
> +
> +	/* Enable the chip */
> +	//data = reg_write(client, MT9P031_CHIP_ENABLE, 1);
> +	//dev_dbg(&client->dev, "write: %d\n", data);
> +
> +	/* Read out the chip version register */
> +	data = reg_read(client, MT9P031_CHIP_VERSION);
> +
> +	switch (data) {
> +	case MT9P031_CHIP_VERSION_VALUE:
> +		mt9p031->model = V4L2_IDENT_MT9P031;
> +		break;
> +	default:
> +		dev_err(&client->dev,
> +			"No MT9P031 chip detected, register read %x\n", data);
> +		return -ENODEV;
> +	}
> +
> +	dev_info(&client->dev, "Detected a MT9P031 chip ID %x\n", data);
> +
> +	ret = mt9p031_idle(client);
> +	if (ret < 0)
> +		dev_err(&client->dev, "Failed to initialise the camera\n");
> +
> +	return ret;
> +}
> +
> +static int mt9p031_open(struct v4l2_subdev *sd, u32 i)
> +{
> +	pr_info("%s()\n", __func__);
> +        return 0;
> +}
> +static int mt9p031_query_ctrl(struct v4l2_subdev *sd,
> +                              struct v4l2_queryctrl *qc)
> +{
> +        return 0;
> +}
> +
> +static struct v4l2_subdev_core_ops mt9p031_subdev_core_ops = {
> +	.g_ctrl		= mt9p031_g_ctrl,
> +	.s_ctrl		= mt9p031_s_ctrl,

You should use the control framework. Control operations will then be handled 
automatically.

> +	.g_chip_ident	= mt9p031_g_chip_ident,

There's no need to implement .g_chip_ident.

> +	.init           = mt9p031_open,

.init is deprecated, please don't use it.

> +	.queryctrl      = mt9p031_query_ctrl,
> +};
> +
> +static struct v4l2_subdev_video_ops mt9p031_subdev_video_ops = {
> +	.s_stream	= mt9p031_s_stream,
> +};
> +
> +static struct v4l2_subdev_pad_ops mt9p031_subdev_pad_ops = {
> +	.enum_mbus_code = mt9p031_enum_mbus_code,
> +//	.enum_frame_size = mt9p031_enum_frame_size,
> +	.get_fmt = mt9p031_get_format,
> +	.set_fmt = mt9p031_set_format,
> +	.get_crop = mt9p031_get_crop,
> +	.set_crop = mt9p031_set_crop,
> +};
> +
> +static struct v4l2_subdev_ops mt9p031_subdev_ops = {
> +	.core	= &mt9p031_subdev_core_ops,
> +	.video	= &mt9p031_subdev_video_ops,
> +	.pad	= &mt9p031_subdev_pad_ops,
> +};
> +
> +static int mt9p031_probe(struct i2c_client *client,
> +			 const struct i2c_device_id *did)
> +{
> +	struct mt9p031 *mt9p031;
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +	struct mt9p031_platform_data *pdata = client->dev.platform_data;
> +	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
> +	int ret;
> +
> +	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WORD_DATA)) {
> +		dev_warn(&adapter->dev,
> +			 "I2C-Adapter doesn't support I2C_FUNC_SMBUS_WORD\n");
> +		return -EIO;
> +	}
> +
> +	mt9p031 = kzalloc(sizeof(struct mt9p031), GFP_KERNEL);
> +	if (!mt9p031)
> +		return -ENOMEM;
> +
> +	v4l2_i2c_subdev_init(&mt9p031->subdev, client, &mt9p031_subdev_ops);
> +
> +//       struct isp_device *isp = v4l2_dev_to_isp_device(subdev->v4l2_dev);
> +//       isp_set_xclk(isp, 16*1000*1000, ISP_XCLK_A);
> +
> +	mt9p031->rect.left	= 0/*MT9P031_COLUMN_SKIP*/;
> +	mt9p031->rect.top	= 0/*MT9P031_ROW_SKIP*/;
> +	mt9p031->rect.width	= MT9P031_MAX_WIDTH;
> +	mt9p031->rect.height	= MT9P031_MAX_HEIGHT;
> +
> +	switch (pdata->data_shift) {
> +	case 2:
> +		mt9p031->format.code = V4L2_MBUS_FMT_SGRBG8_1X8;
> +		break;
> +	case 1:
> +		mt9p031->format.code = V4L2_MBUS_FMT_SGRBG10_1X10;
> +		break;
> +	case 0:
> +		mt9p031->format.code = V4L2_MBUS_FMT_SBGGR12_1X12;
> +	}

Why ? The sensor produces 12-bit data, you shouldn't fake other data widths.

> +	mt9p031->format.width = MT9P031_MAX_WIDTH;
> +	mt9p031->format.height = MT9P031_MAX_HEIGHT;
> +	mt9p031->format.field = V4L2_FIELD_NONE;
> +	mt9p031->format.colorspace = V4L2_COLORSPACE_SRGB;
> +
> +	/* mt9p031_idle() will reset the chip to default. */
> +
> +	mt9p031->xskip = 1;
> +	mt9p031->yskip = 1;
> +
> +//#error FIXME: this is needed for i2c chip detection, but then has to be
> desabled and reloaded for capture!
> +#if 1
> +	if (pdata->set_xclk)
> +		pdata->set_xclk(sd, 54000000);
> +#endif
> +
> +	mt9p031->reg_1v8 = regulator_get(NULL, "cam_1v8");
> +	if (IS_ERR(mt9p031->reg_1v8)) {
> +		ret = PTR_ERR(mt9p031->reg_1v8);
> +		pr_err("Failed 1.8v regulator: %d\n", ret);
> +		goto e1v8;
> +	}
> +
> +	mt9p031->reg_2v8 = regulator_get(NULL, "cam_2v8");
> +	if (IS_ERR(mt9p031->reg_2v8)) {
> +		ret = PTR_ERR(mt9p031->reg_2v8);
> +		pr_err("Failed 2.8v regulator: %d\n", ret);
> +		goto e2v8;
> +	}
> +
> +	if (pdata->reset)
> +		pdata->reset(sd, 1);
> +
> +	/* turn on VDD */
> +	ret = regulator_enable(mt9p031->reg_1v8);
> +	if (ret) {
> +		pr_err("Failed to enable 1.8v regulator: %d\n", ret);
> +		goto e1v8en;
> +	}
> +
> +//	msleep(1);
> +
> +	/* turn on VDD_IO */
> +	ret = regulator_enable(mt9p031->reg_2v8);
> +	if (ret) {
> +		pr_err("Failed to enable 2.8v regulator: %d\n", ret);
> +		goto e2v8en;
> +	}

You should enable the regulators only when needed. Keeping the sensor powered 
up at all times will unnecessarily consume power. A subdev s_power operation 
would be a good start. Have a look at 
http://git.linuxtv.org/pinchartl/media.git?a=commit;h=d3fd150967a90a99fadd24ad4f5b4c1cce833493 
or 
http://git.linuxtv.org/pinchartl/media.git?a=commitdiff;h=2207a787437c8d0f9abad5962ecee197d3989911;hp=1f48016c73feb1275c6808bb5fc7a6e753884d63 
for examples.

> +	msleep(50);
> +
> +	if (pdata->reset)
> +		pdata->reset(sd, 0);
> +
> +//	udelay(500);
> +	msleep(50);
> +
> +//	mt9p031_idle(client);
> +
> +	ret = mt9p031_video_probe(client);
> +
> +	//mt9p031_disable(client);
> +
> +	if (ret)
> +		goto evprobe;
> +
> +	mt9p031->pad.flags = MEDIA_PAD_FL_SOURCE;
> +	ret = media_entity_init(&mt9p031->subdev.entity, 1, &mt9p031->pad, 0);
> +	if (ret)
> +		goto evprobe;
> +
> +	mt9p031->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> +#if 0
> +	if (pdata->set_xclk)
> +		pdata->set_xclk(sd, 0);
> +
> +	msleep(1);
> +
> +	if (pdata->set_xclk)
> +		pdata->set_xclk(sd, 54000000);
> +
> +	msleep(1);
> +#endif
> +	return ret;
> +
> +evprobe:
> +	regulator_disable(mt9p031->reg_2v8);
> +e2v8en:
> +	regulator_disable(mt9p031->reg_1v8);
> +e1v8en:
> +	regulator_put(mt9p031->reg_2v8);
> +e2v8:
> +	regulator_put(mt9p031->reg_1v8);
> +e1v8:
> +	kfree(mt9p031);
> +	return ret;
> +}
> +
> +static int mt9p031_remove(struct i2c_client *client)
> +{
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +	struct mt9p031 *mt9p031 = container_of(sd, struct mt9p031, subdev);
> +
> +	v4l2_device_unregister_subdev(sd);
> +	media_entity_cleanup(&sd->entity);
> +	regulator_disable(mt9p031->reg_2v8);
> +	regulator_disable(mt9p031->reg_1v8);
> +	regulator_put(mt9p031->reg_2v8);
> +	regulator_put(mt9p031->reg_1v8);
> +	kfree(mt9p031);
> +
> +	return 0;
> +}
> +
> +static const struct i2c_device_id mt9p031_id[] = {
> +	{ "mt9p031", 0 },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, mt9p031_id);
> +
> +static struct i2c_driver mt9p031_i2c_driver = {
> +	.driver = {
> +		.name = "mt9p031",
> +	},
> +	.probe		= mt9p031_probe,
> +	.remove		= mt9p031_remove,
> +	.id_table	= mt9p031_id,
> +};
> +
> +static int __init mt9p031_mod_init(void)
> +{
> +	return i2c_add_driver(&mt9p031_i2c_driver);
> +}
> +
> +static void __exit mt9p031_mod_exit(void)
> +{
> +	i2c_del_driver(&mt9p031_i2c_driver);
> +}
> +
> +module_init(mt9p031_mod_init);
> +module_exit(mt9p031_mod_exit);
> +
> +MODULE_DESCRIPTION("Micron MT9P031 Camera driver");
> +MODULE_AUTHOR("Bastian Hecht <hechtb@gmail.com>");
> +MODULE_LICENSE("GPL v2");
> diff --git a/include/media/mt9p031.h b/include/media/mt9p031.h
> new file mode 100644
> index 0000000..ee2d2ba
> --- /dev/null
> +++ b/include/media/mt9p031.h
> @@ -0,0 +1,12 @@
> +#ifndef MT9P031_H
> +#define MT9P031_H
> +
> +struct v4l2_subdev;
> +
> +struct mt9p031_platform_data {
> +	int (*set_xclk)(struct v4l2_subdev *subdev, int hz);
> +	int (*reset)(struct v4l2_subdev *subdev, int active);
> +	unsigned int data_shift;
> +};
> +
> +#endif
> 

-- 
Regards,

Laurent Pinchart
