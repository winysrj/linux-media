Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50654 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736Ab1ASARc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jan 2011 19:17:32 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Martin Hostettler <martin@neutronstar.dyndns.org>
Subject: Re: [PATCH] v4l: Add driver for Micron MT9M032 camera sensor
Date: Wed, 19 Jan 2011 01:17:28 +0100
Cc: linux-media@vger.kernel.org
References: <1295389122-30325-1-git-send-email-martin@neutronstar.dyndns.org>
In-Reply-To: <1295389122-30325-1-git-send-email-martin@neutronstar.dyndns.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201101190117.29265.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Martin,

Thanks for the patch.

On Tuesday 18 January 2011 23:18:42 Martin Hostettler wrote:
> The MT9M032 is a parallel 1284x812 sensor from Micron controlled through
> I2C.
> 
> The driver creates a V4L2 subdevice. It currently supports cropping, gain,
> exposure and v/h flipping controls in monochrome mode with an
> external pixel clock.
> 
> Signed-off-by: Martin Hostettler <martin@neutronstar.dyndns.org>
> ---
>  drivers/media/video/Kconfig     |    7 +
>  drivers/media/video/Makefile    |    1 +
>  drivers/media/video/mt9m032.c   |  834 ++++++++++++++++++++++++++++++++++++
>  drivers/media/video/mt9m032.h   |   38 ++
>  include/media/v4l2-chip-ident.h |    1 +
>  5 files changed, 881 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/mt9m032.c
>  create mode 100644 drivers/media/video/mt9m032.h
> 

[snip]

> diff --git a/drivers/media/video/mt9m032.c b/drivers/media/video/mt9m032.c
> new file mode 100644
> index 0000000..fe6af7b
> --- /dev/null
> +++ b/drivers/media/video/mt9m032.c
> @@ -0,0 +1,834 @@
> +/*
> + * Driver for MT9M032 CMOS Image Sensor from Micron
> + *
> + * Copyright (C) 2010-2011 Lund Engineering
> + * Contact: Gil Lund <gwlund@lundeng.com>
> + * Author: Martin Hostettler <martin@neutronstar.dyndns.org>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
> + * 02110-1301 USA
> + */
> +
> +#include <linux/delay.h>
> +#include <linux/i2c.h>
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/v4l2-mediabus.h>
> +
> +#include <media/media-entity.h>
> +#include <media/v4l2-chip-ident.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-subdev.h>
> +
> +#include "mt9m032.h"
> +
> +#define MT9M032_CHIP_VERSION		0x00
> +#define MT9M032_ROW_START		0x01
> +#define MT9M032_COLUMN_START		0x02
> +#define MT9M032_ROW_SIZE		0x03
> +#define MT9M032_COLUMN_SIZE		0x04
> +#define MT9M032_HBLANK			0x05
> +#define MT9M032_VBLANK			0x06
> +#define MT9M032_SHUTTER_WIDTH_HIGH	0x08
> +#define MT9M032_SHUTTER_WIDTH_LOW	0x09
> +#define MT9M032_PIX_CLK_CTRL		0x0A

Kernel code usually uses lowercase hex constants.

> +#define MT9M032_RESTART			0x0B
> +#define MT9M032_RESET			0x0D
> +#define MT9M032_PLL_CONFIG1		0x11
> +#define MT9M032_READ_MODE1		0x1E
> +#define MT9M032_READ_MODE2		0x20
> +#define MT9M032_GAIN_GREEN1		0x2B
> +#define MT9M032_GAIN_BLUE		0x2C
> +#define MT9M032_GAIN_RED		0x2D
> +#define MT9M032_GAIN_GREEN2		0x2E
> +/* write only */
> +#define MT9M032_GAIN_ALL		0x35
> +#define MT9M032_FORMATTER1		0x9E
> +#define MT9M032_FORMATTER2		0x9F
> +
> +#define to_mt9m032(sd)	container_of(sd, struct mt9m032, subdev)
> +#define to_dev(sensor)	&((struct i2c_client*)v4l2_get_subdevdata(&sensor-
> >subdev))->dev
>+
> +struct mt9m032 {
> +	struct v4l2_subdev subdev;
> +	struct media_pad pad;
> +	struct mt9m032_platform_data *pdata;
> +	struct v4l2_ctrl_handler ctrls;
> +
> +	bool streaming;
> +
> +	int pix_clock;
> +
> +	struct v4l2_mbus_framefmt format;	/* height and width always the same as
> in crop */
> +	struct v4l2_rect crop;
> +	struct v4l2_fract frame_interval;
> +
> +	struct v4l2_ctrl *hflip, *vflip, *gain, *exposure;
> +};
> +


> +static unsigned long mt9m032_row_time(struct mt9m032 *sensor, int width)
> +{
> +	int effective_width;
> +	u64 ns;
> +	effective_width = width + 716; /* emperical value */

Where does it come from ?

> +	ns = 1000000000ll * effective_width;
> +	do_div(ns, sensor->pix_clock);

Do you have high enough clock frequencies that you would loose precision by 
dividing 1e9 by the clock first, and the multiplying it by the row length ? If 
so I would use div_u64().

> +	dev_dbg(to_dev(sensor),	"MT9M032 line time: %llu ns\n", ns);
> +	return ns;
> +}
> +
> +static int mt9m032_update_timing(struct mt9m032 *sensor,
> +				 const struct v4l2_fract *interval,
> +				 const struct v4l2_rect *crop)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
> +	u64 ns = 1000000000; /* 1 sec */
> +	unsigned long row_time;
> +	int additional_blanking_rows;
> +	int min_blank;
> +
> +	if (!interval)
> +		interval = &sensor->frame_interval;
> +	if (!crop)
> +		crop = &sensor->crop;
> +
> +	ns = ns * interval->numerator;
> +	do_div(ns, interval->denominator);

div_u64 as well.

> +
> +	row_time = mt9m032_row_time(sensor, crop->width);
> +	do_div(ns, row_time);
> +
> +	additional_blanking_rows = ns - crop->height;
> +
> +	/* enforce minimal 1.6ms blanking time. */
> +	min_blank = 1600000 / row_time;
> +	if (additional_blanking_rows < min_blank)
> +		additional_blanking_rows = min_blank;

You can use the min() macro.

> +	dev_dbg(to_dev(sensor),
> +		"%s: V-blank %i\n", __func__, additional_blanking_rows);
> +	if (additional_blanking_rows > 0x7ff) {
> +		/* hardware limits 11 bit values */
> +		dev_warn(to_dev(sensor),
> +			"mt9m032: frame rate too low.\n");
> +		additional_blanking_rows = 0x7ff;
> +	}

Or rather the clamp() macro.

> +	return mt9m032_write_reg(client, MT9M032_VBLANK,
> additional_blanking_rows);
> +}
> +
> +static int mt9m032_update_geom_timing(struct mt9m032 *sensor,
> +				 const struct v4l2_rect *crop)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
> +	int ret;
> +
> +	if (!crop)
> +		crop = &sensor->crop;

I'd rather have the caller do this instead of magically working around a NULL 
argument.

> +	ret = mt9m032_write_reg(client, MT9M032_COLUMN_SIZE, crop->width - 1);
> +	if (!ret)
> +		mt9m032_write_reg(client, MT9M032_ROW_SIZE, crop->height - 1);

Aren't you missing a ret = here (and below) ?

> +	/* offsets compensate for black border */
> +	if (!ret)
> +		mt9m032_write_reg(client, MT9M032_COLUMN_START, crop->left + 16);
> +	if (!ret)
> +		mt9m032_write_reg(client, MT9M032_ROW_START, crop->top + 52);
> +	if (!ret)
> +		ret = mt9m032_update_timing(sensor, NULL, crop);
> +	return ret;
> +}
> +
> +static int update_formatter2(struct mt9m032 *sensor, bool streaming)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
> +
> +	u16 reg_val =   0x1000   /* Dout enable */
> +		      | 0x0070;  /* parts reserved! */
> +				 /* possibly for changing to 14-bit mode */
> +
> +	if (streaming)
> +		reg_val |= 0x2000;   /* pixclock enable */

Please define constants at the beginning of the file (with the register 
addresses) instead of using magic numbers.

> +
> +	return mt9m032_write_reg(client, MT9M032_FORMATTER2, reg_val);
> +}
> +
> +static int mt9m032_s_stream(struct v4l2_subdev *subdev, int streaming)
> +{
> +	struct mt9m032 *sensor = to_mt9m032(subdev);
> +	int ret;
> +
> +	ret = update_formatter2(sensor, streaming);
> +	if (!ret)
> +		sensor->streaming = streaming;
> +	return ret;
> +}
> +
> +static int mt9m032_enum_mbus_code(struct v4l2_subdev *subdev,
> +				  struct v4l2_subdev_fh *fh,
> +				  struct v4l2_subdev_mbus_code_enum *code)
> +{
> +	if (code->index != 0 || code->pad != 0)
> +		return -EINVAL;
> +	code->code = V4L2_MBUS_FMT_Y8_1X8;
> +	return 0;
> +}
> +
> +static int mt9m032_enum_frame_size(struct v4l2_subdev *subdev,
> +				   struct v4l2_subdev_fh *fh,
> +				   struct v4l2_subdev_frame_size_enum *fse)
> +{
> +	if (fse->index != 0 || fse->code != V4L2_MBUS_FMT_Y8_1X8 || fse->pad !=
> 0) +		return -EINVAL;
> +
> +	fse->min_width = 32;
> +	fse->max_width = 1440;
> +	fse->min_height = 32;
> +	fse->max_height = 1096;
> +
> +	return 0;
> +}
> +
> +/**
> + * __mt9m032_get_pad_crop() - get crop rect
> + * @sensor:	pointer to the sensor struct
> + * @fh:	filehandle for getting the try crop rect from
> + * @which:	select try or active crop rect
> + * Returns a pointer the current active or fh relative try crop rect
> + */
> +static struct v4l2_rect *__mt9m032_get_pad_crop(struct mt9m032 *sensor,
> +						struct v4l2_subdev_fh *fh,
> +						u32 which)
> +{
> +	switch (which) {
> +	case V4L2_SUBDEV_FORMAT_TRY:
> +		return v4l2_subdev_get_try_crop(fh, 0);
> +	case V4L2_SUBDEV_FORMAT_ACTIVE:
> +		return &sensor->crop;
> +	default:
> +		return NULL;
> +	}
> +}
> +
> +/**
> + * __mt9m032_get_pad_format() - get format
> + * @sensor:	pointer to the sensor struct
> + * @fh:	filehandle for getting the try format from
> + * @which:	select try or active format
> + * Returns a pointer the current active or fh relative try format
> + */
> +static struct v4l2_mbus_framefmt *__mt9m032_get_pad_format(struct mt9m032
> *sensor, +							   struct v4l2_subdev_fh *fh,
> +							   u32 which)
> +{
> +	switch (which) {
> +	case V4L2_SUBDEV_FORMAT_TRY:
> +		return v4l2_subdev_get_try_format(fh, 0);
> +	case V4L2_SUBDEV_FORMAT_ACTIVE:
> +		return &sensor->format;
> +	default:
> +		return NULL;
> +	}
> +}
> +
> +#define OFFSET_UNCHANGED	0xFFFFFFFF
> +static int mt9m032_set_pad_geom(struct mt9m032 *sensor,
> +				struct v4l2_subdev_fh *fh,
> +				u32 which, u32 pad,
> +				s32 top, s32 left, s32 width, s32 height)
> +{
> +	struct v4l2_mbus_framefmt tmp_format;
> +	struct v4l2_rect tmp_crop;
> +	struct v4l2_mbus_framefmt *format;
> +	struct v4l2_rect *crop;
> +
> +	if (pad != 0)
> +		return -EINVAL;
> +
> +	format = __mt9m032_get_pad_format(sensor, fh, which);
> +	crop = __mt9m032_get_pad_crop(sensor, fh, which);
> +	if (!format || !crop)
> +		return -EINVAL;
> +	if (which == V4L2_SUBDEV_FORMAT_ACTIVE) {
> +		tmp_crop = *crop;
> +		tmp_format = *format;
> +		format = &tmp_format;
> +		crop = &tmp_crop;
> +	}
> +
> +	if (top != OFFSET_UNCHANGED)
> +		crop->top = top & ~0x1;
> +	if (left != OFFSET_UNCHANGED)
> +		crop->left = left;
> +	crop->height = height;
> +	crop->width = width & ~1;
> +
> +	format->height = crop->height;
> +	format->width = crop->width;

This looks very weird to me. If your sensor doesn't include a scaler, it 
should support a single fixed format. Crop will then be used to select the 
crop rectangle. You're mixing the two for no obvious reason.

> +	if (which == V4L2_SUBDEV_FORMAT_ACTIVE) {
> +		int ret = mt9m032_update_geom_timing(sensor, crop);
> +		if (!ret) {
> +			sensor->crop = tmp_crop;
> +			sensor->format = tmp_format;
> +		}
> +		return ret;
> +	} else {
> +		return 0;
> +	}
> +}
> +
> +static int mt9m032_get_pad_format(struct v4l2_subdev *subdev,
> +				  struct v4l2_subdev_fh *fh,
> +				  struct v4l2_subdev_format *fmt)
> +{
> +	struct mt9m032 *sensor = to_mt9m032(subdev);
> +	struct v4l2_mbus_framefmt *format;
> +
> +	if (fmt->pad != 0)
> +		return -EINVAL;
> +	format = __mt9m032_get_pad_format(sensor, fh, fmt->which);
> +	if (format == NULL)
> +		return -EINVAL;
> +
> +	fmt->format = *format;
> +
> +	return 0;
> +}
> +
> +static int mt9m032_set_pad_format(struct v4l2_subdev *subdev,
> +				  struct v4l2_subdev_fh *fh,
> +				  struct v4l2_subdev_format *fmt)
> +{
> +	struct mt9m032 *sensor = to_mt9m032(subdev);
> +	int ret;
> +
> +	if (sensor->streaming)
> +		return -EBUSY;
> +	if (fmt->format.code != V4L2_MBUS_FMT_Y8_1X8)
> +		return -EINVAL;

Don't return -EINVAL, force the code to V4L2_MBUS_FMT_Y8_1X8 instead.

> +	/*
> +	 * fmt->format.colorspace and fmt->format.field are ignored
> +	 * and thus forced to fixed values by the get call below
> +	 */
> +
> +	ret = mt9m032_set_pad_geom(sensor, fh, fmt->which, fmt->pad,
> +				   OFFSET_UNCHANGED, OFFSET_UNCHANGED,
> +				   fmt->format.width, fmt->format.height);
> +
> +	if (ret < 0)
> +		return ret;
> +	return mt9m032_get_pad_format(subdev, fh, fmt);
> +}
> +
> +static int mt9m032_get_crop(struct v4l2_subdev *subdev, struct
> v4l2_subdev_fh *fh, +			    struct v4l2_subdev_crop *crop)
> +{
> +	struct mt9m032 *sensor = to_mt9m032(subdev);
> +	struct v4l2_rect *curcrop;
> +
> +	if (crop->pad != 0)
> +		return -EINVAL;
> +	curcrop = __mt9m032_get_pad_crop(sensor, fh, crop->which);
> +	if (!curcrop)
> +		return -EINVAL;
> +
> +	crop->rect = *curcrop;
> +
> +	return 0;
> +}
> +
> +static int mt9m032_set_crop(struct v4l2_subdev *subdev, struct
> v4l2_subdev_fh *fh, +		     struct v4l2_subdev_crop *crop)
> +{
> +	struct mt9m032 *sensor = to_mt9m032(subdev);
> +	int ret;
> +
> +	if (sensor->streaming)
> +		return -EBUSY;
> +	ret = mt9m032_set_pad_geom(sensor, fh, crop->which, crop->pad,
> +				   crop->rect.top, crop->rect.left,
> +				   crop->rect.width, crop->rect.height);
> +	if (ret < 0)
> +		return ret;
> +	return mt9m032_get_crop(subdev, fh, crop);
> +}
> +
> +static int mt9m032_get_frame_interval(struct v4l2_subdev *subdev,
> +				      struct v4l2_subdev_frame_interval *fi)
> +{
> +	struct mt9m032 *sensor = to_mt9m032(subdev);
> +
> +	fi->pad = 0;
> +	memset(fi->reserved, 0, sizeof(fi->reserved));
> +	fi->interval = sensor->frame_interval;
> +
> +	return 0;
> +}
> +
> +static int mt9m032_set_frame_interval(struct v4l2_subdev *subdev,
> +				      struct v4l2_subdev_frame_interval *fi)
> +{
> +	struct mt9m032 *sensor = to_mt9m032(subdev);
> +	int ret;
> +
> +	if (sensor->streaming)
> +		return -EBUSY;
> +
> +	memset(fi->reserved, 0, sizeof(fi->reserved));
> +
> +	ret = mt9m032_update_timing(sensor, &fi->interval, NULL);
> +	if (!ret)
> +		sensor->frame_interval = fi->interval;
> +	return ret;
> +}
> +
> +#ifdef CONFIG_VIDEO_ADV_DEBUG
> +static int mt9m032_g_register(struct v4l2_subdev *sd,
> +			      struct v4l2_dbg_register *reg)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	int val;
> +
> +	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0xff)
> +		return -EINVAL;
> +	if (reg->match.addr != client->addr)
> +		return -ENODEV;
> +
> +	val = mt9m032_read_reg(client, reg->reg);
> +	if (val < 0)
> +		return -EIO;
> +
> +	reg->size = 2;
> +	reg->val = (u64) val;
> +
> +	return 0;
> +}
> +
> +static int mt9m032_s_register(struct v4l2_subdev *sd,
> +			      struct v4l2_dbg_register *reg)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +
> +	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0xff)
> +		return -EINVAL;
> +
> +	if (reg->match.addr != client->addr)
> +		return -ENODEV;
> +
> +	if (mt9m032_write_reg(client, reg->reg, reg->val) < 0)
> +		return -EIO;
> +
> +	return 0;
> +}
> +#endif
> +
> +static int update_read_mode2(struct mt9m032 *sensor, bool vflip, bool
> hflip) +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
> +
> +	int reg_val = (!!vflip) << 15
> +		      | (!!hflip) << 14
> +		      | 0x0040	/* row black level correction (ROW BLC) */
> +		      | 0x0007;
> +
> +	return mt9m032_write_reg(client, MT9M032_READ_MODE2, reg_val);
> +}
> +
> +static int mt9m032_set_hflip(struct mt9m032 *sensor, s32 val)
> +{
> +	return update_read_mode2(sensor, sensor->vflip->cur.val, val);
> +}
> +
> +static int mt9m032_set_vflip(struct mt9m032 *sensor, s32 val)
> +{
> +	return update_read_mode2(sensor, val, sensor->hflip->cur.val);
> +}
> +
> +static int mt9m032_set_exposure(struct mt9m032 *sensor, s32 val)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
> +	int shutter_width;
> +	u16 high_val, low_val;
> +	int ret;
> +
> +	/* shutter width is in row times */
> +	shutter_width = (val * 1000) / mt9m032_row_time(sensor,
> sensor->crop.width); +
> +	high_val = (shutter_width >> 16) & 0xF;
> +	low_val = shutter_width & 0xFFFF;
> +
> +	ret = mt9m032_write_reg(client, MT9M032_SHUTTER_WIDTH_HIGH, high_val);
> +	if (!ret)
> +		mt9m032_write_reg(client, MT9M032_SHUTTER_WIDTH_LOW, low_val);
> +
> +	return ret;
> +}
> +
> +static int mt9m032_set_gain(struct mt9m032 *sensor, s32 val)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
> +	int digital_gain_val;	/* in 1/8th (0..127) */
> +	int analog_mul;		/* 0 or 1 */
> +	int analog_gain_val;	/* in 1/16th. (0..63) */
> +	u16 reg_val;
> +
> +	digital_gain_val = 51; /* from setup example */

So the digital gain isn't configurable ?

> +
> +	if (val < 63) {
> +		analog_mul = 0;
> +		analog_gain_val = val;
> +	} else {
> +		analog_mul = 1;
> +		analog_gain_val = val / 2;
> +	}
> +
> +	/* a_gain = (1+analog_mul) + (analog_gain_val+1)/16 */
> +	/* overall_gain = a_gain * (1 + digital_gain_val / 8) */
> +
> +	reg_val = (digital_gain_val & 0x7f) << 8
> +		  | (analog_mul & 1) << 6
> +		  | (analog_gain_val & 0x3f);
> +
> +	return mt9m032_write_reg(client, MT9M032_GAIN_ALL, reg_val);
> +}
> +
> +static int mt9m032_setup_pll(struct mt9m032 *sensor)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
> +	struct mt9m032_platform_data* pdata = sensor->pdata;
> +	u16 reg_pll1;
> +	unsigned int pre_div;
> +	int res, ret;
> +
> +	/* TODO: also support other pre-div values */
> +	if (pdata->pll_pre_div != 6) {
> +		dev_warn(to_dev(sensor),
> +			"Unsupported PLL pre-divisor value %u, using default 6\n",
> +			pdata->pll_pre_div);
> +		pre_div = 6;
> +	} else {
> +		pre_div = pdata->pll_pre_div;
> +	}

You can keep the dev_warn, but I would just hardcode prev_div to 6, there's no 
need for an else.

> +
> +	sensor->pix_clock = pdata->ext_clock * pdata->pll_mul /
> +		(pre_div * pdata->pll_out_div);
> +
> +	reg_pll1 = ((pdata->pll_out_div - 1) & 0x3F)
> +		   | pdata->pll_mul << 8;
> +
> +	ret = mt9m032_write_reg(client, MT9M032_PLL_CONFIG1, reg_pll1);
> +	if (!ret)
> +		ret = mt9m032_write_reg(client, 0x10, 0x53); /* Select PLL as clock

No magic numbers please.

> source */ +
> +	if (!ret)
> +		ret = mt9m032_write_reg(client, MT9M032_READ_MODE1, 0x8006);
> +							/* more reserved, Continuous */
> +							/* Master Mode */
> +	if (!ret)
> +		res = mt9m032_read_reg(client, MT9M032_READ_MODE1);
> +
> +	if (!ret)
> +		ret = mt9m032_write_reg(client, MT9M032_FORMATTER1, 0x111e);
> +					/* Set 14-bit mode, select 7 divider */
> +
> +	return ret;
> +}
> +
> +static int mt9m032_get_chip_ident(struct v4l2_subdev *subdev,
> +		       struct v4l2_dbg_chip_ident *chip)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(subdev);
> +
> +	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_MT9M032, 0);
> +}

Is g_chip_ident needed ?

> +static int mt9m032_set_config(struct v4l2_subdev *subdev, int irq, void
> *pdata) +{
> +	struct mt9m032 *sensor = to_mt9m032(subdev);
> +	struct i2c_client *client = v4l2_get_subdevdata(subdev);
> +
> +	int res, ret;
> +
> +	if (!pdata)
> +		return -ENODEV;
> +
> +	sensor->pdata = pdata;
> +
> +	ret = mt9m032_write_reg(client, MT9M032_RESET, 1);	/* reset on */
> +	if (!ret)
> +		mt9m032_write_reg(client, MT9M032_RESET, 0);	/* reset off */

Does the chip need a minimum reset duration ?

> +	if (!ret) {
> +		ret = mt9m032_setup_pll(sensor);
> +		msleep(10);
> +	}
> +	/* Sensor Gain */
> +	if (!ret)
> +		ret = mt9m032_set_gain(sensor, sensor->gain->cur.val);
> +
> +	   /* Shutter Width */
> +	if (!ret)
> +		ret = mt9m032_set_exposure(sensor, sensor->exposure->cur.val);
> +
> +	/* SIZE */
> +	if (!ret)
> +		ret = mt9m032_update_geom_timing(sensor, NULL);

Do you really need to override the default reset values ?

> +	if (!ret)
> +		ret = update_read_mode2(sensor, sensor->vflip->cur.val,
> sensor->hflip->cur.val); +
> +	if (!ret)
> +		ret = mt9m032_write_reg(client, 0x41, 0x0000);	/* reserved !!! */
> +	if (!ret)
> +		ret = mt9m032_write_reg(client, 0x42, 0x0003);	/* reserved !!! */
> +	if (!ret)
> +		ret = mt9m032_write_reg(client, 0x43, 0x0003);	/* reserved !!! */
> +	if (!ret)
> +		ret = mt9m032_write_reg(client, 0x7F, 0x0000);	/* reserved !!! */

Reserved for what ? No magic numbers here either.

> +	if (ret == 0 && sensor->pdata->invert_pixclock)
> +		mt9m032_write_reg(client, MT9M032_PIX_CLK_CTRL, 0x8000);
> +
> +	res = mt9m032_read_reg(client, MT9M032_PIX_CLK_CTRL);
> +
> +	if (!ret) {
> +		ret = mt9m032_write_reg(client, MT9M032_RESTART, 0x0001); /* Restart on
> */ +		msleep(100);
> +	}
> +	if (!ret) {
> +		ret = mt9m032_write_reg(client, MT9M032_RESTART, 0x0000); /* Restart off
> */ +		msleep(100);
> +	}
> +	if (!ret)
> +		ret = update_formatter2(sensor, false);

Instead of all those !ret conditions, you should return ret on failure.

> +	return ret;
> +}
> +
> +static int mt9m032_set_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct mt9m032 *sensor = container_of(ctrl->handler, struct mt9m032,
> ctrls); +
> +	switch (ctrl->id) {
> +	case V4L2_CID_GAIN:
> +		return mt9m032_set_gain(sensor, ctrl->val);

As your gain control has two analog stages and a digital stage, 
mt9m032_set_gain() will sometimes round the gain value. ctrl->val should be 
updated accordingly.

> +		break;
> +
> +	case V4L2_CID_HFLIP:
> +		return mt9m032_set_hflip(sensor, ctrl->val);
> +		break;
> +
> +	case V4L2_CID_VFLIP:
> +		return mt9m032_set_vflip(sensor, ctrl->val);
> +		break;
> +
> +	case V4L2_CID_EXPOSURE:
> +		return mt9m032_set_exposure(sensor, ctrl->val);
> +		break;
> +
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
> +static const struct v4l2_subdev_video_ops mt9m032_video_ops = {
> +	.s_stream = mt9m032_s_stream,
> +	.g_frame_interval = mt9m032_get_frame_interval,
> +	.s_frame_interval = mt9m032_set_frame_interval,
> +};
> +
> +#ifdef CONFIG_VIDEO_ADV_DEBUG
> +static long mt9m032_ioctl(struct v4l2_subdev *sd, unsigned int cmd, void
> *arg) +{
> +	if (cmd == VIDIOC_DBG_G_REGISTER || cmd == VIDIOC_DBG_S_REGISTER) {
> +		struct v4l2_dbg_register *p = arg;
> +
> +		if (!capable(CAP_SYS_ADMIN))
> +			return -EPERM;
> +
> +		if (cmd == VIDIOC_DBG_G_REGISTER)
> +			return v4l2_subdev_call(sd, core, g_register, p);
> +		else
> +			return v4l2_subdev_call(sd, core, s_register, p);
> +	} else {
> +		return -ENOIOCTLCMD;
> +	}
> +}
> +#endif
> +
> +static struct v4l2_ctrl_ops mt9m032_ctrl_ops = {
> +	.s_ctrl = mt9m032_set_ctrl,
> +};
> +
> +
> +static const struct v4l2_subdev_core_ops mt9m032_core_ops = {
> +	.g_chip_ident = mt9m032_get_chip_ident,
> +	.s_config = mt9m032_set_config,
> +#ifdef CONFIG_VIDEO_ADV_DEBUG
> +	.ioctl = mt9m032_ioctl,
> +	.g_register = mt9m032_g_register,
> +	.s_register = mt9m032_s_register,
> +#endif
> +};
> +
> +static const struct v4l2_subdev_pad_ops mt9m032_pad_ops = {
> +	.enum_mbus_code = mt9m032_enum_mbus_code,
> +	.enum_frame_size = mt9m032_enum_frame_size,
> +	.get_fmt = mt9m032_get_pad_format,
> +	.set_fmt = mt9m032_set_pad_format,
> +	.set_crop = mt9m032_set_crop,
> +	.get_crop = mt9m032_get_crop,
> +};
> +
> +static const struct v4l2_subdev_ops mt9m032_ops = {
> +	.core = &mt9m032_core_ops,
> +	.video = &mt9m032_video_ops,
> +	.pad = &mt9m032_pad_ops,
> +};
> +
> +static int mt9m032_probe(struct i2c_client *client,
> +			 const struct i2c_device_id *devid)
> +{
> +	struct mt9m032 *sensor;
> +	int chip_version;
> +	int ret;
> +
> +	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_WORD_DATA))
> { +		dev_warn(&client->adapter->dev,
> +			 "I2C-Adapter doesn't support I2C_FUNC_SMBUS_WORD\n");
> +		return -EIO;
> +	}
> +
> +	/*
> +	 * This driver was developed with a camera module with seperate external
> +	 * pix clock. For setups which use the clock from the camera interface
> +	 * the code will need to be extended with the appropriate platform
> +	 * callback to setup the clock.
> +	 */
> +	chip_version = mt9m032_read_reg(client, MT9M032_CHIP_VERSION);
> +	if (0x1402 == chip_version) {

Still no magic numbers please.

> +		dev_info(&client->dev, "mt9m032: detected chip version 0x%x\n",
> chip_version);

As only 0x1402 is valid, I don't think there's a need to print it here.

> +	} else {
> +		dev_warn(&client->dev, "mt9m032: error: detected unsupported chip
> version 0x%x\n", +			 chip_version);
> +		return -ENODEV;
> +	}
> +
> +	sensor = kzalloc(sizeof(*sensor), GFP_KERNEL);
> +	if (sensor == NULL)
> +		return -ENOMEM;
> +
> +	sensor->frame_interval.numerator = 1;
> +	sensor->frame_interval.denominator = 30;
> +
> +	sensor->crop.left = 416;
> +	sensor->crop.top = 360;
> +	sensor->crop.width = 640;
> +	sensor->crop.height = 480;
> +
> +	sensor->format.width = sensor->crop.width;
> +	sensor->format.height = sensor->crop.height;
> +	sensor->format.code = V4L2_MBUS_FMT_Y8_1X8;
> +	sensor->format.field = V4L2_FIELD_NONE;
> +	sensor->format.colorspace = V4L2_COLORSPACE_SRGB;
> +
> +	v4l2_ctrl_handler_init(&sensor->ctrls, 4);
> +
> +	sensor->gain = v4l2_ctrl_new_std(&sensor->ctrls, &mt9m032_ctrl_ops,
> +			  V4L2_CID_GAIN, 0, 127, 1, 64);
> +
> +	sensor->hflip = v4l2_ctrl_new_std(&sensor->ctrls, &mt9m032_ctrl_ops,
> +			  V4L2_CID_HFLIP, 0, 1, 1, 0);
> +	sensor->vflip = v4l2_ctrl_new_std(&sensor->ctrls, &mt9m032_ctrl_ops,
> +			  V4L2_CID_VFLIP, 0, 1, 1, 0);
> +	sensor->exposure = v4l2_ctrl_new_std(&sensor->ctrls, &mt9m032_ctrl_ops,
> +			  V4L2_CID_EXPOSURE, 0, 8000, 1, 1700);    /* 1.7ms */
> +
> +	v4l2_i2c_subdev_init(&sensor->subdev, client, &mt9m032_ops);
> +	sensor->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> +	sensor->subdev.ctrl_handler = &sensor->ctrls;
> +
> +	sensor->pad.flags = MEDIA_PAD_FLAG_OUTPUT;
> +	ret = media_entity_init(&sensor->subdev.entity, 1, &sensor->pad, 0);
> +	if (ret < 0)
> +		kfree(sensor);
> +
> +	return ret;
> +}
> +
> +static int mt9m032_remove(struct i2c_client *client)
> +{
> +	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
> +	struct mt9m032 *sensor = to_mt9m032(subdev);
> +
> +	v4l2_device_unregister_subdev(&sensor->subdev);
> +	media_entity_cleanup(&sensor->subdev.entity);
> +	kfree(sensor);
> +	return 0;
> +}
> +
> +static const struct i2c_device_id mt9m032_id_table[] = {
> +	{MT9M032_NAME, 0},
> +	{}
> +};
> +
> +MODULE_DEVICE_TABLE(i2c, mt9m032_id_table);
> +
> +static struct i2c_driver mt9m032_i2c_driver = {
> +	.driver = {
> +		   .name = MT9M032_NAME,
> +		   },
> +	.probe = mt9m032_probe,
> +	.remove = mt9m032_remove,
> +	.id_table = mt9m032_id_table,
> +};
> +
> +static int __init mt9m032_init(void)
> +{
> +	int rval;
> +
> +	rval = i2c_add_driver(&mt9m032_i2c_driver);
> +	if (rval)
> +		pr_err("%s: failed registering " MT9M032_NAME "\n", __func__);
> +
> +	return rval;
> +}
> +
> +static void mt9m032_exit(void)
> +{
> +	i2c_del_driver(&mt9m032_i2c_driver);
> +}
> +
> +module_init(mt9m032_init);
> +module_exit(mt9m032_exit);
> +
> +MODULE_AUTHOR("Martin Hostettler");
> +MODULE_DESCRIPTION("MT9M032 camera sensor driver");
> +MODULE_LICENSE("GPL v2");
> diff --git a/drivers/media/video/mt9m032.h b/drivers/media/video/mt9m032.h
> new file mode 100644
> index 0000000..a473af4
> --- /dev/null
> +++ b/drivers/media/video/mt9m032.h
> @@ -0,0 +1,38 @@
> +/*
> + * Driver for MT9M032 CMOS Image Sensor from Micron
> + *
> + * Copyright (C) 2010-2011 Lund Engineering
> + * Contact: Gil Lund <gwlund@lundeng.com>
> + * Author: Martin Hostettler <martin@neutronstar.dyndns.org>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
> + * 02110-1301 USA
> + *
> + */
> +
> +#ifndef MT9M032_H
> +#define MT9M032_H
> +
> +#define MT9M032_NAME		"mt9m032"
> +#define MT9M032_I2C_ADDR	(0xB8 >> 1)
> +
> +struct mt9m032_platform_data {
> +	u32 ext_clock;
> +	u32 pll_pre_div;
> +	u32 pll_mul;
> +	u32 pll_out_div;
> +	int invert_pixclock;
> +
> +};
> +#endif /* MT9M032_H */
> diff --git a/include/media/v4l2-chip-ident.h
> b/include/media/v4l2-chip-ident.h index a7194fb..7d4e5c5 100644
> --- a/include/media/v4l2-chip-ident.h
> +++ b/include/media/v4l2-chip-ident.h
> @@ -283,6 +283,7 @@ enum {
>  	/* Micron CMOS sensor chips: 45000-45099 */
>  	V4L2_IDENT_MT9M001C12ST		= 45000,
>  	V4L2_IDENT_MT9M001C12STM	= 45005,
> +	V4L2_IDENT_MT9M032              = 45006,
>  	V4L2_IDENT_MT9M111		= 45007,
>  	V4L2_IDENT_MT9M112		= 45008,
>  	V4L2_IDENT_MT9V022IX7ATC	= 45010, /* No way to detect "normal" I77ATx */

-- 
Regards,

Laurent Pinchart
