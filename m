Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52114 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755849Ab1IRWsY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Sep 2011 18:48:24 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Martin Hostettler <martin@neutronstar.dyndns.org>
Subject: Re: [PATCH v2] v4l: Add driver for Micron MT9M032 camera sensor
Date: Mon, 19 Sep 2011 00:48:24 +0200
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
References: <1316251771-858-1-git-send-email-martin@neutronstar.dyndns.org>
In-Reply-To: <1316251771-858-1-git-send-email-martin@neutronstar.dyndns.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109190048.25335.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Martin,

Thanks for the patch.

On Saturday 17 September 2011 11:29:31 Martin Hostettler wrote:
> The MT9M032 is a parallel 3MP sensor from Micron controlled through I2C.

According to the Aptina datasheet, it's an 1.6MP sensor :-)

> The driver creates a V4L2 subdevice. It currently supports cropping, gain,
> exposure and v/h flipping controls in monochrome mode with an
> external pixel clock.
> 
> Signed-off-by: Martin Hostettler <martin@neutronstar.dyndns.org>
> ---
>  drivers/media/video/Kconfig     |    7 +
>  drivers/media/video/Makefile    |    1 +
>  drivers/media/video/mt9m032.c   |  814
> +++++++++++++++++++++++++++++++++++++++ include/media/mt9m032.h         | 
>  38 ++
>  include/media/v4l2-chip-ident.h |    1 +
>  5 files changed, 861 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/mt9m032.c
>  create mode 100644 include/media/mt9m032.h
> 
> Changes in V2
>  * ported to current mainline
>  * Moved dispatching for subdev ioctls VIDIOC_DBG_G_REGISTER and
> VIDIOC_DBG_S_REGISTER into v4l2-subdev
>  * Removed VIDIOC_DBG_G_CHIP_IDENT support
>  * moved header to media/
>  * Fixed missing error handling
>  * lowercase hex constants
>  * moved v4l2_get_subdevdata to register access helpers
>  * use div_u64 instead of do_div
>  * moved all know register values into #define:ed constants
>  * Fixed error reporting, used clamp instead of open coding.
>  * lots of style fixes.
>  * add try_ctrl to make sure user space sees rounded values
>  * Fixed some problem in control framework usage.
>  * Fixed set_format to force width and height setup via crop. Simplyfied
> code.
> 
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index f574dc0..41c6c12 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -798,6 +798,13 @@ config SOC_CAMERA_MT9M001
>  	  This driver supports MT9M001 cameras from Micron, monochrome
>  	  and colour models.
> 
> +config VIDEO_MT9M032
> +	tristate "MT9M032 camera sensor support"
> +	depends on I2C && VIDEO_V4L2
> +	help
> +	  This driver supports MT9M032 cameras from Micron, monochrome
> +	  models only.
> +
>  config SOC_CAMERA_MT9M111
>  	tristate "mt9m111, mt9m112 and mt9m131 support"
>  	depends on SOC_CAMERA && I2C
> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> index 2723900..0d86830 100644
> --- a/drivers/media/video/Makefile
> +++ b/drivers/media/video/Makefile
> @@ -74,6 +74,7 @@ obj-$(CONFIG_VIDEO_ADP1653)	+= adp1653.o
> 
>  obj-$(CONFIG_SOC_CAMERA_IMX074)		+= imx074.o
>  obj-$(CONFIG_SOC_CAMERA_MT9M001)	+= mt9m001.o
> +obj-$(CONFIG_VIDEO_MT9M032)             += mt9m032.o
>  obj-$(CONFIG_SOC_CAMERA_MT9M111)	+= mt9m111.o
>  obj-$(CONFIG_SOC_CAMERA_MT9T031)	+= mt9t031.o
>  obj-$(CONFIG_SOC_CAMERA_MT9T112)	+= mt9t112.o
> diff --git a/drivers/media/video/mt9m032.c b/drivers/media/video/mt9m032.c
> new file mode 100644
> index 0000000..8a64193
> --- /dev/null
> +++ b/drivers/media/video/mt9m032.c
> @@ -0,0 +1,814 @@
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
> +#include <linux/math64.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/v4l2-mediabus.h>
> +
> +#include <media/media-entity.h>
> +#include <media/v4l2-chip-ident.h>

You can remove this header.

> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-subdev.h>
> +
> +#include <media/mt9m032.h>
> +
> +#define MT9M032_CHIP_VERSION			0x00
> +#define MT9M032_ROW_START			0x01
> +#define MT9M032_COLUMN_START			0x02
> +#define MT9M032_ROW_SIZE			0x03
> +#define MT9M032_COLUMN_SIZE			0x04
> +#define MT9M032_HBLANK				0x05
> +#define MT9M032_VBLANK				0x06
> +#define MT9M032_SHUTTER_WIDTH_HIGH		0x08
> +#define MT9M032_SHUTTER_WIDTH_LOW		0x09
> +#define MT9M032_PIX_CLK_CTRL			0x0a
> +#define     MT9M032_PIX_CLK_CTRL_INV_PIXCLK	0x8000
> +#define MT9M032_RESTART				0x0b
> +#define MT9M032_RESET				0x0d
> +#define MT9M032_PLL_CONFIG1			0x11
> +#define     MT9M032_PLL_CONFIG1_OUTDIV_MASK	0x3f
> +#define     MT9M032_PLL_CONFIG1_MUL_SHIFT	8
> +#define MT9M032_READ_MODE1			0x1e
> +#define MT9M032_READ_MODE2			0x20
> +#define     MT9M032_READ_MODE2_VFLIP_SHIFT	15
> +#define     MT9M032_READ_MODE2_HFLIP_SHIFT	14
> +#define     MT9M032_READ_MODE2_ROW_BLC		0x40
> +#define MT9M032_GAIN_GREEN1			0x2b
> +#define MT9M032_GAIN_BLUE			0x2c
> +#define MT9M032_GAIN_RED			0x2d
> +#define MT9M032_GAIN_GREEN2			0x2e
> +/* write only */
> +#define MT9M032_GAIN_ALL			0x35
> +#define     MT9M032_GAIN_DIGITAL_MASK		0x7f
> +#define     MT9M032_GAIN_DIGITAL_SHIFT		8
> +#define     MT9M032_GAIN_AMUL_SHIFT		6
> +#define     MT9M032_GAIN_ANALOG_MASK		0x3f
> +#define MT9M032_FORMATTER1			0x9e
> +#define MT9M032_FORMATTER2			0x9f
> +#define     MT9M032_FORMATTER2_DOUT_EN		0x1000
> +#define     MT9M032_FORMATTER2_PIXCLK_EN	0x2000
> +
> +#define MT9M032_MAX_BLANKING_ROWS		0x7ff
> +
> +#define to_mt9m032(sd)	container_of(sd, struct mt9m032, subdev)
> +#define to_dev(sensor)	&((struct i2c_client
> *)v4l2_get_subdevdata(&sensor->subdev))->dev +
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
> in crop */ +	struct v4l2_rect crop;
> +	struct v4l2_fract frame_interval;
> +
> +	struct v4l2_ctrl *hflip, *vflip;
> +};
> +
> +
> +static int mt9m032_read_reg(struct mt9m032 *sensor, const u8 reg)

No need for the const keyword, this isn't a pointer :-)

> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
> +	s32 data = i2c_smbus_read_word_data(client, reg);
> +
> +	return data < 0 ? data : swab16(data);

You should use be16_to_cpu() here.

> +}
> +
> +static int mt9m032_write_reg(struct mt9m032 *sensor, const u8 reg,
> +		     const u16 data)

No need for const either.

> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
> +
> +	return i2c_smbus_write_word_data(client, reg, swab16(data));

And cpu_to_be16() here.

> +}
> +
> +

I'm not a big fan of several blank lines (you even use 3 of them in 
mt9m032_probe) to separate code blocks. If you want to divide the code (which 
I find good for readability), using comments usually works better. I 
personally use

/* ---------------------------------------------------------------------------
 * Foo Bar
 */

to split drivers in sections.

This is up to you.

> +static unsigned long mt9m032_row_time(struct mt9m032 *sensor, int width)
> +{
> +	int effective_width;
> +	u64 ns;
> +
> +	effective_width = width + 716; /* emperical value */
> +	ns = div_u64(((u64)1000000000) * effective_width, sensor->pix_clock);
> +	dev_dbg(to_dev(sensor),	"MT9M032 line time: %llu ns\n", ns);
> +	return ns;
> +}
> +
> +static int mt9m032_update_timing(struct mt9m032 *sensor,
> +				 struct v4l2_fract *interval,
> +				 const struct v4l2_rect *crop)
> +{
> +	unsigned long row_time;
> +	int additional_blanking_rows;
> +	int min_blank;

Those can't be negative, what about using unsigned it ?

> +
> +	if (!interval)
> +		interval = &sensor->frame_interval;

This will have the side effect of possibly modifying the frame interval stored 
in the mt9m032 structure. Is that on purpose ?

> +	if (!crop)
> +		crop = &sensor->crop;

If I'm not mistaken the function is always called with the crop parameter set 
to either NULL or &sensor->crop. I think the parameter could be removed.

> +
> +	row_time = mt9m032_row_time(sensor, crop->width);
> +
> +	additional_blanking_rows = div_u64(((u64)1000000000) *
> interval->numerator, +	                                 
> ((u64)interval->denominator) * row_time) +	                           -
> crop->height;
> +
> +	if (additional_blanking_rows > MT9M032_MAX_BLANKING_ROWS) {
> +		/* hardware limits to 11 bit values */
> +		interval->denominator = 1000;
> +		interval->numerator = div_u64((crop->height + MT9M032_MAX_BLANKING_ROWS)
> +		                              * ((u64)row_time) * interval->denominator
> +					      , 1000000000);

You're exceeding the 80 columns limit anyway, the comma can be put at the end 
of the previous row.

> +		additional_blanking_rows = div_u64(((u64)1000000000) *
> interval->numerator,
> +	                              ((u64)interval->denominator) * row_time)
> +	                           - crop->height;
> +	}
> +	/* enforce minimal 1.6ms blanking time. */
> +	min_blank = 1600000 / row_time;
> +	additional_blanking_rows = clamp(additional_blanking_rows,
> +	                                 min_blank, MT9M032_MAX_BLANKING_ROWS);
> +
> +	return mt9m032_write_reg(sensor, MT9M032_VBLANK, additional_blanking_rows);
> +}
> +
> +static int mt9m032_update_geom_timing(struct mt9m032 *sensor,
> +				 const struct v4l2_rect *crop)
> +{
> +	int ret;
> +
> +	ret = mt9m032_write_reg(sensor, MT9M032_COLUMN_SIZE, crop->width - 1);
> +	if (!ret)
> +		ret = mt9m032_write_reg(sensor, MT9M032_ROW_SIZE, crop->height - 1);
> +	/* offsets compensate for black border */
> +	if (!ret)
> +		ret = mt9m032_write_reg(sensor, MT9M032_COLUMN_START, crop->left + 16);
> +	if (!ret)
> +		ret = mt9m032_write_reg(sensor, MT9M032_ROW_START, crop->top + 52);

I don't think the black rows/columns offsets should be added implicitly by the 
driver. Wouldn't it be beter to make them explicit ?

> +	if (!ret)
> +		ret = mt9m032_update_timing(sensor, NULL, crop);
> +	return ret;
> +}
> +
> +static int update_formatter2(struct mt9m032 *sensor, bool streaming)
> +{
> +	u16 reg_val =   MT9M032_FORMATTER2_DOUT_EN
> +		      | 0x0070;  /* parts reserved! */
> +				 /* possibly for changing to 14-bit mode */

Does the sensor support 14-bit output ?

> +
> +	if (streaming)
> +		reg_val |= MT9M032_FORMATTER2_PIXCLK_EN;   /* pixclock enable */
> +
> +	return mt9m032_write_reg(sensor, MT9M032_FORMATTER2, reg_val);
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

Shouldn't that be 1472 ?

> +	fse->min_height = 32;
> +	fse->max_height = 1096;

You don't support binning/skipping, so I think min width/height should be 
equal to max width/height.

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
> +static int mt9m032_get_pad_format(struct v4l2_subdev *subdev,
> +				  struct v4l2_subdev_fh *fh,
> +				  struct v4l2_subdev_format *fmt)
> +{
> +	struct mt9m032 *sensor = to_mt9m032(subdev);
> +	struct v4l2_mbus_framefmt *format;
> +
> +	if (fmt->pad != 0)
> +		return -EINVAL;

fmt->pad is already validated by the core. Same comment for the set operation.

> +	format = __mt9m032_get_pad_format(sensor, fh, fmt->which);
> +	if (format == NULL)
> +		return -EINVAL;

fmt->which is validated by the core as well, so __mt9m032_get_pad_format() 
can't return NULL. Same for cropping.

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
> +
> +	if (sensor->streaming)
> +		return -EBUSY;
> +
> +	if (fmt->pad != 0)
> +		return -EINVAL;
> +
> +
> +	/*
> +	 * fmt->format.colorspace, fmt->format.code and fmt->format.field are
> ignored
> +	 * and thus forced to fixed values by the get call below.
> +	 *
> +	 * fmt->format.width, fmt->format.height are forced to the values set via
> crop
> +	 */
> +
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
> +
> +static int mt9m032_set_crop(struct v4l2_subdev *subdev, struct
> v4l2_subdev_fh *fh, +		     struct v4l2_subdev_crop *crop)
> +{
> +	struct mt9m032 *sensor = to_mt9m032(subdev);
> +	struct v4l2_mbus_framefmt tmp_format;
> +	struct v4l2_rect tmp_crop_rect;
> +	struct v4l2_mbus_framefmt *format;
> +	struct v4l2_rect *crop_rect;
> +
> +	if (sensor->streaming)
> +		return -EBUSY;
> +
> +	if (crop->pad != 0)
> +		return -EINVAL;
> +
> +	format = __mt9m032_get_pad_format(sensor, fh, crop->which);
> +	crop_rect = __mt9m032_get_pad_crop(sensor, fh, crop->which);
> +	if (!format || !crop_rect)
> +		return -EINVAL;
> +	if (crop->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
> +		tmp_crop_rect = *crop_rect;
> +		tmp_format = *format;
> +		format = &tmp_format;
> +		crop_rect = &tmp_crop_rect;
> +	}
> +
> +	crop_rect->top = crop->rect.top & ~0x1;
> +	crop_rect->left = crop->rect.left;
> +	crop_rect->height = crop->rect.height;
> +	crop_rect->width = crop->rect.width & ~1;

You should validate the crop rectangle here.

> +	format->height = crop_rect->height;
> +	format->width = crop_rect->width;
> +
> +	if (crop->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
> +		int ret = mt9m032_update_geom_timing(sensor, crop_rect);

As the format can't be changed during streaming, what about moving this to the 
s_stream handler ? You could then also remove the call from the probe() 
function.

> +
> +		if (!ret) {
> +			sensor->crop = tmp_crop_rect;
> +			sensor->format = tmp_format;
> +		}
> +		return ret;
> +	}
> +
> +	return mt9m032_get_crop(subdev, fh, crop);

I don't think you need that.

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
> +	struct mt9m032 *sensor = to_mt9m032(sd);
> +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
> +	int val;
> +
> +	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0xff)
> +		return -EINVAL;
> +	if (reg->match.addr != client->addr)
> +		return -ENODEV;

Do you think those checks should be kept when using the MC API ?

> +	val = mt9m032_read_reg(sensor, reg->reg);
> +	if (val < 0)
> +		return -EIO;
> +
> +	reg->size = 2;
> +	reg->val = (u64) val;

Is there a need for an explicit cast ?

> +
> +	return 0;
> +}
> +
> +static int mt9m032_s_register(struct v4l2_subdev *sd,
> +			      struct v4l2_dbg_register *reg)
> +{
> +	struct mt9m032 *sensor = to_mt9m032(sd);
> +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
> +
> +	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0xff)
> +		return -EINVAL;
> +
> +	if (reg->match.addr != client->addr)
> +		return -ENODEV;
> +
> +	if (mt9m032_write_reg(sensor, reg->reg, reg->val) < 0)
> +		return -EIO;
> +
> +	return 0;
> +}
> +#endif
> +
> +static int update_read_mode2(struct mt9m032 *sensor, bool vflip, bool
> hflip) +{
> +	int reg_val = (!!vflip) << MT9M032_READ_MODE2_VFLIP_SHIFT
> +		      | (!!hflip) << MT9M032_READ_MODE2_HFLIP_SHIFT
> +		      | MT9M032_READ_MODE2_ROW_BLC
> +		      | 0x0007;
> +
> +	return mt9m032_write_reg(sensor, MT9M032_READ_MODE2, reg_val);
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
> +	int shutter_width;
> +	u16 high_val, low_val;
> +	int ret;
> +
> +	/* shutter width is in row times */
> +	shutter_width = (val * 1000) / mt9m032_row_time(sensor,
> sensor->crop.width); +
> +	high_val = (shutter_width >> 16) & 0xf;
> +	low_val = shutter_width & 0xffff;
> +
> +	ret = mt9m032_write_reg(sensor, MT9M032_SHUTTER_WIDTH_HIGH, high_val);
> +	if (!ret)
> +		mt9m032_write_reg(sensor, MT9M032_SHUTTER_WIDTH_LOW, low_val);
> +
> +	return ret;
> +}
> +
> +static int mt9m032_set_gain(struct mt9m032 *sensor, s32 val)
> +{
> +	int digital_gain_val;	/* in 1/8th (0..127) */
> +	int analog_mul;		/* 0 or 1 */
> +	int analog_gain_val;	/* in 1/16th. (0..63) */
> +	u16 reg_val;
> +
> +	digital_gain_val = 51; /* from setup example */
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
> +	reg_val = (digital_gain_val & MT9M032_GAIN_DIGITAL_MASK) <<
> MT9M032_GAIN_DIGITAL_SHIFT +		  | (analog_mul & 1) <<
> MT9M032_GAIN_AMUL_SHIFT
> +		  | (analog_gain_val & MT9M032_GAIN_ANALOG_MASK);
> +
> +	return mt9m032_write_reg(sensor, MT9M032_GAIN_ALL, reg_val);
> +}
> +
> +static int mt9m032_setup_pll(struct mt9m032 *sensor)
> +{
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
> +	}
> +	pre_div = 6;

The mt9p031 driver also needs to setup a PLL. I think it's time to compute the 
PLL parameters at runtime instead of relying on board code.

> +
> +	sensor->pix_clock = pdata->ext_clock * pdata->pll_mul /
> +		(pre_div * pdata->pll_out_div);
> +
> +	reg_pll1 = ((pdata->pll_out_div - 1) & MT9M032_PLL_CONFIG1_OUTDIV_MASK)
> +		   | pdata->pll_mul << MT9M032_PLL_CONFIG1_MUL_SHIFT;
> +
> +	ret = mt9m032_write_reg(sensor, MT9M032_PLL_CONFIG1, reg_pll1);
> +	if (!ret)
> +		ret = mt9m032_write_reg(sensor, 0x10, 0x53); /* Select PLL as clock
> source */ +
> +	if (!ret)
> +		ret = mt9m032_write_reg(sensor, MT9M032_READ_MODE1, 0x8006);
> +							/* more reserved, Continuous */
> +							/* Master Mode */
> +	if (!ret)
> +		res = mt9m032_read_reg(sensor, MT9M032_READ_MODE1);
> +
> +	if (!ret)
> +		ret = mt9m032_write_reg(sensor, MT9M032_FORMATTER1, 0x111e);
> +					/* Set 14-bit mode, select 7 divider */
> +
> +	return ret;
> +}
> +
> +static int mt9m032_try_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	if (ctrl->id == V4L2_CID_GAIN && ctrl->val >= 63) {
> +		 /* round because of multiplier used for values >= 63 */
> +		ctrl->val &= ~1;
> +	}
> +
> +	return 0;
> +}
> +
> +static int mt9m032_set_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct mt9m032 *sensor = container_of(ctrl->handler, struct mt9m032,
> ctrls); +
> +	switch (ctrl->id) {
> +	case V4L2_CID_GAIN:
> +		return mt9m032_set_gain(sensor, ctrl->val);
> +
> +	case V4L2_CID_HFLIP:
> +		return mt9m032_set_hflip(sensor, ctrl->val);
> +
> +	case V4L2_CID_VFLIP:
> +		return mt9m032_set_vflip(sensor, ctrl->val);
> +
> +	case V4L2_CID_EXPOSURE:
> +		return mt9m032_set_exposure(sensor, ctrl->val);
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
> +static struct v4l2_ctrl_ops mt9m032_ctrl_ops = {
> +	.s_ctrl = mt9m032_set_ctrl,
> +	.try_ctrl = mt9m032_try_ctrl,
> +};
> +
> +
> +static const struct v4l2_subdev_core_ops mt9m032_core_ops = {
> +#ifdef CONFIG_VIDEO_ADV_DEBUG
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
> +	int res, ret;
> +
> +
> +	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_WORD_DATA))
> { +		dev_warn(&client->adapter->dev,
> +			 "I2C-Adapter doesn't support I2C_FUNC_SMBUS_WORD\n");
> +		return -EIO;
> +	}
> +
> +	if (!client->dev.platform_data)
> +		return -ENODEV;
> +
> +	sensor = kzalloc(sizeof(*sensor), GFP_KERNEL);
> +	if (sensor == NULL)
> +		return -ENOMEM;
> +
> +	sensor->pdata = client->dev.platform_data;
> +
> +	v4l2_i2c_subdev_init(&sensor->subdev, client, &mt9m032_ops);
> +	sensor->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> +
> +
> +	/*
> +	 * This driver was developed with a camera module with seperate external
> +	 * pix clock. For setups which use the clock from the camera interface
> +	 * the code will need to be extended with the appropriate platform
> +	 * callback to setup the clock.
> +	 */
> +	chip_version = mt9m032_read_reg(sensor, MT9M032_CHIP_VERSION);
> +	if (0x1402 == chip_version) {
> +		dev_info(&client->dev, "mt9m032: detected sensor.\n");
> +	} else {
> +		dev_warn(&client->dev, "mt9m032: error: detected unsupported chip
> version 0x%x\n", +			 chip_version);
> +		ret = -ENODEV;
> +		goto free_sensor;
> +	}
> +
> +
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
> +	v4l2_ctrl_new_std(&sensor->ctrls, &mt9m032_ctrl_ops,
> +			  V4L2_CID_GAIN, 0, 127, 1, 64);
> +
> +	sensor->hflip = v4l2_ctrl_new_std(&sensor->ctrls, &mt9m032_ctrl_ops,
> +			  V4L2_CID_HFLIP, 0, 1, 1, 0);
> +	sensor->vflip = v4l2_ctrl_new_std(&sensor->ctrls, &mt9m032_ctrl_ops,
> +			  V4L2_CID_VFLIP, 0, 1, 1, 0);
> +	v4l2_ctrl_new_std(&sensor->ctrls, &mt9m032_ctrl_ops,
> +			  V4L2_CID_EXPOSURE, 0, 8000, 1, 1700);    /* 1.7ms */
> +
> +
> +	if (sensor->ctrls.error) {
> +		ret = sensor->ctrls.error;
> +		dev_err(&client->dev, "control initialization error %d\n", ret);
> +		goto free_ctrl;
> +	}
> +
> +	sensor->subdev.ctrl_handler = &sensor->ctrls;
> +	sensor->pad.flags = MEDIA_PAD_FL_SOURCE;
> +	ret = media_entity_init(&sensor->subdev.entity, 1, &sensor->pad, 0);
> +	if (ret < 0)
> +		goto free_ctrl;
> +
> +	ret = mt9m032_write_reg(sensor, MT9M032_RESET, 1);	/* reset on */
> +	if (ret < 0)
> +		goto free_ctrl;
> +	mt9m032_write_reg(sensor, MT9M032_RESET, 0);	/* reset off */
> +	if (ret < 0)
> +		goto free_ctrl;
> +
> +	ret = mt9m032_setup_pll(sensor);
> +	if (ret < 0)
> +		goto free_ctrl;
> +	msleep(10);
> +
> +	v4l2_ctrl_handler_setup(&sensor->ctrls);
> +
> +	/* SIZE */
> +	ret = mt9m032_update_geom_timing(sensor, &sensor->crop);
> +	if (ret < 0)
> +		goto free_ctrl;
> +
> +	ret = mt9m032_write_reg(sensor, 0x41, 0x0000);	/* reserved !!! */
> +	if (ret < 0)
> +		goto free_ctrl;
> +	ret = mt9m032_write_reg(sensor, 0x42, 0x0003);	/* reserved !!! */
> +	if (ret < 0)
> +		goto free_ctrl;
> +	ret = mt9m032_write_reg(sensor, 0x43, 0x0003);	/* reserved !!! */
> +	if (ret < 0)
> +		goto free_ctrl;
> +	ret = mt9m032_write_reg(sensor, 0x7f, 0x0000);	/* reserved !!! */
> +	if (ret < 0)
> +		goto free_ctrl;
> +	if (sensor->pdata->invert_pixclock) {
> +		mt9m032_write_reg(sensor, MT9M032_PIX_CLK_CTRL,
> MT9M032_PIX_CLK_CTRL_INV_PIXCLK); +		if (ret < 0)
> +			goto free_ctrl;
> +	}
> +
> +	res = mt9m032_read_reg(sensor, MT9M032_PIX_CLK_CTRL);
> +
> +	ret = mt9m032_write_reg(sensor, MT9M032_RESTART, 1); /* Restart on */
> +	if (ret < 0)
> +		goto free_ctrl;
> +	msleep(100);
> +	ret = mt9m032_write_reg(sensor, MT9M032_RESTART, 0); /* Restart off */
> +	if (ret < 0)
> +		goto free_ctrl;
> +	msleep(100);
> +	ret = update_formatter2(sensor, false);
> +	if (ret < 0)
> +		goto free_ctrl;
> +
> +	return ret;
> +
> +free_ctrl:
> +	v4l2_ctrl_handler_free(&sensor->ctrls);
> +
> +free_sensor:
> +	kfree(sensor);
> +	return ret;
> +}
> +
> +static int mt9m032_remove(struct i2c_client *client)
> +{
> +	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
> +	struct mt9m032 *sensor = to_mt9m032(subdev);
> +
> +	v4l2_device_unregister_subdev(&sensor->subdev);
> +	v4l2_ctrl_handler_free(&sensor->ctrls);
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
> diff --git a/include/media/mt9m032.h b/include/media/mt9m032.h
> new file mode 100644
> index 0000000..a473af4
> --- /dev/null
> +++ b/include/media/mt9m032.h
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

We tend to use lower-case hex constants in the kernel.

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
> b/include/media/v4l2-chip-ident.h index 63fd9d3..384967f 100644
> --- a/include/media/v4l2-chip-ident.h
> +++ b/include/media/v4l2-chip-ident.h
> @@ -290,6 +290,7 @@ enum {
>  	/* Micron CMOS sensor chips: 45000-45099 */
>  	V4L2_IDENT_MT9M001C12ST		= 45000,
>  	V4L2_IDENT_MT9M001C12STM	= 45005,
> +	V4L2_IDENT_MT9M032              = 45006,

This isn't needed anymore.

>  	V4L2_IDENT_MT9M111		= 45007,
>  	V4L2_IDENT_MT9M112		= 45008,
>  	V4L2_IDENT_MT9V022IX7ATC	= 45010, /* No way to detect "normal" I77ATx */

-- 
Regards,

Laurent Pinchart
