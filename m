Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:49393 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030866Ab2CFPEM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Mar 2012 10:04:12 -0500
Date: Tue, 6 Mar 2012 17:04:04 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	Martin Hostettler <martin@neutronstar.dyndns.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 5/5] v4l: Add driver for Micron MT9M032 camera sensor
Message-ID: <20120306150403.GG1075@valkosipuli.localdomain>
References: <1331035786-8938-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1331035786-8938-6-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331035786-8938-6-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the patch.

On Tue, Mar 06, 2012 at 01:09:46PM +0100, Laurent Pinchart wrote:
> From: Martin Hostettler <martin@neutronstar.dyndns.org>
> 
> The MT9M032 is a parallel 1.6MP sensor from Micron controlled through I2C.
> 
> The driver creates a V4L2 subdevice. It currently supports cropping, gain,
> exposure and v/h flipping controls in monochrome mode with an
> external pixel clock.
> 
> Signed-off-by: Martin Hostettler <martin@neutronstar.dyndns.org>
> ---
>  drivers/media/video/Kconfig   |    8 +
>  drivers/media/video/Makefile  |    1 +
>  drivers/media/video/mt9m032.c |  823 +++++++++++++++++++++++++++++++++++++++++
>  include/media/mt9m032.h       |   36 ++
>  4 files changed, 868 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/mt9m032.c
>  create mode 100644 include/media/mt9m032.h
> 
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index 666836d..2611708 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -947,6 +947,14 @@ config SOC_CAMERA_MT9M001
>  	  This driver supports MT9M001 cameras from Micron, monochrome
>  	  and colour models.
>  
> +config VIDEO_MT9M032
> +	tristate "MT9M032 camera sensor support"
> +	depends on I2C && VIDEO_V4L2
> +	select VIDEO_APTINA_PLL
> +	help
> +	  This driver supports MT9M032 cameras from Micron, monochrome
> +	  models only.
> +
>  config SOC_CAMERA_MT9M111
>  	tristate "mt9m111, mt9m112 and mt9m131 support"
>  	depends on SOC_CAMERA && I2C
> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> index d1304e1..8e037e9 100644
> --- a/drivers/media/video/Makefile
> +++ b/drivers/media/video/Makefile
> @@ -82,6 +82,7 @@ obj-$(CONFIG_VIDEO_AS3645A)	+= as3645a.o
>  
>  obj-$(CONFIG_SOC_CAMERA_IMX074)		+= imx074.o
>  obj-$(CONFIG_SOC_CAMERA_MT9M001)	+= mt9m001.o
> +obj-$(CONFIG_VIDEO_MT9M032)             += mt9m032.o
>  obj-$(CONFIG_SOC_CAMERA_MT9M111)	+= mt9m111.o
>  obj-$(CONFIG_SOC_CAMERA_MT9T031)	+= mt9t031.o
>  obj-$(CONFIG_SOC_CAMERA_MT9T112)	+= mt9t112.o
> diff --git a/drivers/media/video/mt9m032.c b/drivers/media/video/mt9m032.c
> new file mode 100644
> index 0000000..8c69099
> --- /dev/null
> +++ b/drivers/media/video/mt9m032.c
> @@ -0,0 +1,823 @@
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
> +#include <media/mt9m032.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-subdev.h>
> +
> +#include "aptina-pll.h"
> +
> +#define MT9M032_CHIP_VERSION			0x00
> +#define     MT9M032_CHIP_VERSION_VALUE		0x1402
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
> +
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
> +/*
> + * The available MT9M032 datasheet is missing documentation for register 0x10
> + * MT9P031 seems to be close enough, so use constants from that datasheet for
> + * now.
> + * But keep the name MT9P031 to remind us, that this isn't really confirmed
> + * for this sensor.
> + */
> +#define MT9P031_PLL_CONTROL			0x10
> +#define     MT9P031_PLL_CONTROL_PWROFF		0x0050
> +#define     MT9P031_PLL_CONTROL_PWRON		0x0051
> +#define     MT9P031_PLL_CONTROL_USEPLL		0x0052
> +#define MT9P031_PLL_CONFIG2			0x11
> +#define     MT9P031_PLL_CONFIG2_P1_DIV_MASK	0x1f
> +
> +/*
> + * width and height include active boundry and black parts
> + *
> + * column    0-  15 active boundry
> + * column   16-1455 image
> + * column 1456-1471 active boundry
> + * column 1472-1599 black
> + *
> + * row       0-  51 black
> + * row      53-  59 active boundry
> + * row      60-1139 image
> + * row    1140-1147 active boundry
> + * row    1148-1151 black
> + */
> +#define MT9M032_WIDTH				1600
> +#define MT9M032_HEIGHT				1152
> +#define MT9M032_MINIMALSIZE			32
> +#define MT9M032_MAX_BLANKING_ROWS		0x7ff
> +
> +struct mt9m032 {
> +	struct v4l2_subdev subdev;
> +	struct media_pad pad;
> +	struct mt9m032_platform_data *pdata;
> +
> +	struct v4l2_ctrl_handler ctrls;
> +	struct {
> +		struct v4l2_ctrl *hflip;
> +		struct v4l2_ctrl *vflip;
> +	};
> +
> +	bool streaming;
> +
> +	int pix_clock;

unsigned?

> +	struct v4l2_mbus_framefmt format;
> +	struct v4l2_rect crop;
> +	struct v4l2_fract frame_interval;
> +};
> +
> +#define to_mt9m032(sd)	container_of(sd, struct mt9m032, subdev)
> +#define to_dev(sensor) \
> +	(&((struct i2c_client *)v4l2_get_subdevdata(&(sensor)->subdev))->dev)
> +
> +static int mt9m032_read(struct i2c_client *client, u8 reg)
> +{
> +	return i2c_smbus_read_word_swapped(client, reg);
> +}
> +
> +static int mt9m032_write(struct i2c_client *client, u8 reg, const u16 data)
> +{
> +	return i2c_smbus_write_word_swapped(client, reg, data);
> +}
> +
> +static unsigned long mt9m032_row_time(struct mt9m032 *sensor, int width)
> +{
> +	int effective_width;

unsigned, this & width?

> +	u64 ns;
> +
> +	effective_width = width + 716; /* emperical value */
> +	ns = div_u64(((u64)1000000000) * effective_width, sensor->pix_clock);
> +	dev_dbg(to_dev(sensor),	"MT9M032 line time: %llu ns\n", ns);

The sensor is using rows internally for exposure as is SMIA++ sensor. Should
we use a different control or the same?

Some sensors also provide additional fine exposure control, which is in
pixels. It doesn't make sense to change the fine exposure time except in
very special situations, i.e. normally it's 0.

> +	return ns;
> +}
> +
> +static int mt9m032_update_timing(struct mt9m032 *sensor,
> +				 struct v4l2_fract *interval)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
> +	struct v4l2_rect *crop = &sensor->crop;
> +	unsigned long row_time;
> +	unsigned int min_vblank;
> +	unsigned int vblank;
> +
> +	if (!interval)
> +		interval = &sensor->frame_interval;
> +
> +	row_time = mt9m032_row_time(sensor, crop->width);
> +
> +	vblank = div_u64(1000000000ULL * interval->numerator,
> +			 ((u64)interval->denominator) * row_time)
> +	       - crop->height;
> +
> +	if (vblank > MT9M032_MAX_BLANKING_ROWS) {
> +		/* hardware limits to 11 bit values */
> +		interval->denominator = 1000;
> +		interval->numerator =
> +			div_u64((crop->height + MT9M032_MAX_BLANKING_ROWS) *
> +				(u64)row_time * interval->denominator,
> +				1000000000ULL);
> +		vblank = div_u64(1000000000ULL * interval->numerator,
> +				 ((u64)interval->denominator) * row_time)
> +		       - crop->height;
> +	}
> +	/* enforce minimal 1.6ms blanking time. */
> +	min_vblank = 1600000 / row_time;
> +	vblank = clamp_t(unsigned int, vblank, min_vblank,
> +			 MT9M032_MAX_BLANKING_ROWS);
> +
> +	return mt9m032_write(client, MT9M032_VBLANK, vblank);
> +}

You'd get rid of these calculations with the new sensor control interface.

I'm fine with you starting to support that later on but that would change
the user space API for this driver. Is that an issue?

We still need the generic library so the applications still can use these
drivers as in the past.

> +static int mt9m032_update_geom_timing(struct mt9m032 *sensor)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
> +	int ret;
> +
> +	ret = mt9m032_write(client, MT9M032_COLUMN_SIZE,
> +			    sensor->crop.width - 1);
> +	if (!ret)
> +		ret = mt9m032_write(client, MT9M032_ROW_SIZE,
> +				    sensor->crop.height - 1);
> +	/* offsets compensate for black border */
> +	if (!ret)
> +		ret = mt9m032_write(client, MT9M032_COLUMN_START,
> +				    sensor->crop.left);
> +	if (!ret)
> +		ret = mt9m032_write(client, MT9M032_ROW_START,
> +				    sensor->crop.top);
> +	if (!ret)
> +		ret = mt9m032_update_timing(sensor, NULL);
> +	return ret;
> +}
> +
> +static int update_formatter2(struct mt9m032 *sensor, bool streaming)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
> +	u16 reg_val =   MT9M032_FORMATTER2_DOUT_EN
> +		      | 0x0070;  /* parts reserved! */
> +				 /* possibly for changing to 14-bit mode */
> +
> +	if (streaming)
> +		reg_val |= MT9M032_FORMATTER2_PIXCLK_EN;   /* pixclock enable */
> +
> +	return mt9m032_write(client, MT9M032_FORMATTER2, reg_val);
> +}
> +
> +static int mt9m032_setup_pll(struct mt9m032 *sensor)
> +{
> +	static const struct aptina_pll_limits limits = {
> +		.ext_clock_min = 8000000,
> +		.ext_clock_max = 16500000,
> +		.int_clock_min = 2000000,
> +		.int_clock_max = 24000000,
> +		.out_clock_min = 322000000,
> +		.out_clock_max = 693000000,
> +		.pix_clock_max = 99000000,
> +		.n_min = 1,
> +		.n_max = 64,
> +		.m_min = 16,
> +		.m_max = 255,
> +		.p1_min = 1,
> +		.p1_max = 128,
> +	};
> +
> +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
> +	struct mt9m032_platform_data *pdata = sensor->pdata;
> +	struct aptina_pll pll;
> +	int ret;
> +
> +	pll.ext_clock = pdata->ext_clock;
> +	pll.pix_clock = pdata->pix_clock;
> +
> +	ret = aptina_pll_calculate(&client->dev, &limits, &pll);
> +	if (ret < 0)
> +		return ret;
> +
> +	sensor->pix_clock = pll.pix_clock;
> +
> +	ret = mt9m032_write(client, MT9M032_PLL_CONFIG1,
> +			    (pll.m << MT9M032_PLL_CONFIG1_MUL_SHIFT)
> +			    | (pll.p1 - 1));
> +	if (!ret)
> +		ret = mt9m032_write(client, MT9P031_PLL_CONFIG2, pll.n - 1);
> +	if (!ret)
> +		ret = mt9m032_write(client, MT9P031_PLL_CONTROL,
> +				    MT9P031_PLL_CONTROL_PWRON |
> +				    MT9P031_PLL_CONTROL_USEPLL);
> +	if (!ret)		/* more reserved, Continuous, Master Mode */
> +		ret = mt9m032_write(client, MT9M032_READ_MODE1, 0x8006);
> +	if (!ret)		/* Set 14-bit mode, select 7 divider */
> +		ret = mt9m032_write(client, MT9M032_FORMATTER1, 0x111e);
> +
> +	return ret;
> +}
> +
> +/* -----------------------------------------------------------------------------
> + * Subdev pad operations
> + */
> +
> +static int mt9m032_enum_mbus_code(struct v4l2_subdev *subdev,
> +				  struct v4l2_subdev_fh *fh,
> +				  struct v4l2_subdev_mbus_code_enum *code)
> +{
> +	if (code->index != 0)
> +		return -EINVAL;
> +
> +	code->code = V4L2_MBUS_FMT_Y8_1X8;
> +	return 0;
> +}
> +
> +static int mt9m032_enum_frame_size(struct v4l2_subdev *subdev,
> +				   struct v4l2_subdev_fh *fh,
> +				   struct v4l2_subdev_frame_size_enum *fse)
> +{
> +	if (fse->index != 0 || fse->code != V4L2_MBUS_FMT_Y8_1X8)
> +		return -EINVAL;
> +
> +	fse->min_width = MT9M032_WIDTH;
> +	fse->max_width = MT9M032_WIDTH;
> +	fse->min_height = MT9M032_HEIGHT;
> +	fse->max_height = MT9M032_HEIGHT;
> +
> +	return 0;
> +}
> +
> +/**
> + * __mt9m032_get_pad_crop() - get crop rect
> + * @sensor: pointer to the sensor struct
> + * @fh: filehandle for getting the try crop rect from
> + * @which: select try or active crop rect
> + *
> + * Returns a pointer the current active or fh relative try crop rect
> + */
> +static struct v4l2_rect *
> +__mt9m032_get_pad_crop(struct mt9m032 *sensor, struct v4l2_subdev_fh *fh,
> +		       enum v4l2_subdev_format_whence which)
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
> + * @sensor: pointer to the sensor struct
> + * @fh: filehandle for getting the try format from
> + * @which: select try or active format
> + *
> + * Returns a pointer the current active or fh relative try format
> + */
> +static struct v4l2_mbus_framefmt *
> +__mt9m032_get_pad_format(struct mt9m032 *sensor, struct v4l2_subdev_fh *fh,
> +			 enum v4l2_subdev_format_whence which)
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
> +
> +	fmt->format = *__mt9m032_get_pad_format(sensor, fh, fmt->which);
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

Setting try formats should succeed while streaming, shouldn't it?

> +	/* Scaling is not supported, the format is thus fixed. */
> +	return mt9m032_get_pad_format(subdev, fh, fmt);
> +}
> +
> +static int mt9m032_get_crop(struct v4l2_subdev *subdev,
> +			    struct v4l2_subdev_fh *fh,
> +			    struct v4l2_subdev_crop *crop)
> +{
> +	struct mt9m032 *sensor = to_mt9m032(subdev);
> +
> +	crop->rect = *__mt9m032_get_pad_crop(sensor, fh, crop->which);
> +
> +	return 0;
> +}
> +
> +static int mt9m032_set_crop(struct v4l2_subdev *subdev,
> +			    struct v4l2_subdev_fh *fh,
> +			    struct v4l2_subdev_crop *crop)
> +{
> +	struct mt9m032 *sensor = to_mt9m032(subdev);
> +	struct v4l2_mbus_framefmt *format;
> +	struct v4l2_rect *__crop;
> +	struct v4l2_rect rect;
> +
> +	if (sensor->streaming)
> +		return -EBUSY;

Same for crop.

Selection API support would be nice here.

> +	rect.top = clamp(crop->rect.top, 0,
> +			 MT9M032_HEIGHT - MT9M032_MINIMALSIZE) & ~1;
> +	rect.left = clamp(crop->rect.left, 0,
> +			  MT9M032_WIDTH - MT9M032_MINIMALSIZE);
> +	rect.height = clamp(crop->rect.height, MT9M032_MINIMALSIZE,
> +			    MT9M032_HEIGHT - rect.top);
> +	rect.width = clamp(crop->rect.width, MT9M032_MINIMALSIZE,
> +			   MT9M032_WIDTH - rect.left) & ~1;
> +
> +	__crop = __mt9m032_get_pad_crop(sensor, fh, crop->which);
> +
> +	if (rect.width != __crop->width || rect.height != __crop->height) {
> +		/* Reset the output image size if the crop rectangle size has
> +		 * been modified.
> +		 */
> +		format = __mt9m032_get_pad_format(sensor, fh, crop->which);
> +		format->width = rect.width;
> +		format->height = rect.height;
> +	}
> +
> +	*__crop = rect;
> +	crop->rect = rect;
> +
> +	if (crop->which != V4L2_SUBDEV_FORMAT_ACTIVE)
> +		return 0;
> +
> +	return mt9m032_update_geom_timing(sensor);
> +}
> +
> +static int mt9m032_get_frame_interval(struct v4l2_subdev *subdev,
> +				      struct v4l2_subdev_frame_interval *fi)
> +{
> +	struct mt9m032 *sensor = to_mt9m032(subdev);
> +
> +	memset(fi, 0, sizeof(*fi));
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
> +	ret = mt9m032_update_timing(sensor, &fi->interval);
> +	if (!ret)
> +		sensor->frame_interval = fi->interval;
> +
> +	return ret;
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
> +/* -----------------------------------------------------------------------------
> + * V4L2 subdev core operations
> + */
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
> +
> +	val = mt9m032_read(client, reg->reg);
> +	if (val < 0)
> +		return -EIO;
> +
> +	reg->size = 2;
> +	reg->val = val;
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
> +	return mt9m032_write(client, reg->reg, reg->val);
> +}
> +#endif
> +
> +/* -----------------------------------------------------------------------------
> + * V4L2 subdev control operations
> + */
> +
> +static int update_read_mode2(struct mt9m032 *sensor, bool vflip, bool hflip)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
> +	int reg_val = (!!vflip) << MT9M032_READ_MODE2_VFLIP_SHIFT
> +		    | (!!hflip) << MT9M032_READ_MODE2_HFLIP_SHIFT
> +		    | MT9M032_READ_MODE2_ROW_BLC
> +		    | 0x0007;
> +
> +	return mt9m032_write(client, MT9M032_READ_MODE2, reg_val);
> +}
> +
> +static int mt9m032_set_exposure(struct mt9m032 *sensor, s32 val)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
> +	int shutter_width;
> +	u16 high_val, low_val;
> +	int ret;

What's the unit of the exposure control? I'd use lines but I think this
driver uses something else.

> +	/* shutter width is in row times */
> +	shutter_width = (val * 1000)
> +		      / mt9m032_row_time(sensor, sensor->crop.width);
> +
> +	high_val = (shutter_width >> 16) & 0xf;
> +	low_val = shutter_width & 0xffff;
> +
> +	ret = mt9m032_write(client, MT9M032_SHUTTER_WIDTH_HIGH, high_val);
> +	if (!ret)
> +		ret = mt9m032_write(client, MT9M032_SHUTTER_WIDTH_LOW,
> +					low_val);
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
> +	reg_val = ((digital_gain_val & MT9M032_GAIN_DIGITAL_MASK)
> +		   << MT9M032_GAIN_DIGITAL_SHIFT)
> +		| ((analog_mul & 1) << MT9M032_GAIN_AMUL_SHIFT)
> +		| (analog_gain_val & MT9M032_GAIN_ANALOG_MASK);
> +
> +	return mt9m032_write(client, MT9M032_GAIN_ALL, reg_val);
> +}
> +
> +static int mt9m032_try_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	if (ctrl->id == V4L2_CID_GAIN && ctrl->val >= 63) {
> +		/* round because of multiplier used for values >= 63 */
> +		ctrl->val &= ~1;
> +	}
> +
> +	return 0;
> +}
> +
> +static int mt9m032_set_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct mt9m032 *sensor =
> +		container_of(ctrl->handler, struct mt9m032, ctrls);
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_GAIN:
> +		return mt9m032_set_gain(sensor, ctrl->val);
> +
> +	case V4L2_CID_HFLIP:
> +	case V4L2_CID_VFLIP:
> +		return update_read_mode2(sensor, sensor->vflip->val,
> +					 sensor->hflip->val);
> +
> +	case V4L2_CID_EXPOSURE:
> +		return mt9m032_set_exposure(sensor, ctrl->val);
> +
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
> +static struct v4l2_ctrl_ops mt9m032_ctrl_ops = {
> +	.s_ctrl = mt9m032_set_ctrl,
> +	.try_ctrl = mt9m032_try_ctrl,
> +};
> +
> +/* -------------------------------------------------------------------------- */
> +
> +static const struct v4l2_subdev_core_ops mt9m032_core_ops = {
> +#ifdef CONFIG_VIDEO_ADV_DEBUG
> +	.g_register = mt9m032_g_register,
> +	.s_register = mt9m032_s_register,
> +#endif
> +};
> +
> +static const struct v4l2_subdev_video_ops mt9m032_video_ops = {
> +	.s_stream = mt9m032_s_stream,
> +	.g_frame_interval = mt9m032_get_frame_interval,
> +	.s_frame_interval = mt9m032_set_frame_interval,
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
> +/* -----------------------------------------------------------------------------
> + * Driver initialization and probing
> + */
> +
> +static int mt9m032_probe(struct i2c_client *client,
> +			 const struct i2c_device_id *devid)
> +{
> +	struct i2c_adapter *adapter = client->adapter;
> +	struct mt9m032 *sensor;
> +	int chip_version;
> +	int ret;
> +
> +	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WORD_DATA)) {
> +		dev_warn(&client->dev,
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
> +	/*
> +	 * This driver was developed with a camera module with seperate external
> +	 * pix clock. For setups which use the clock from the camera interface
> +	 * the code will need to be extended with the appropriate platform
> +	 * callback to setup the clock.
> +	 */

Does this comment have something to do with the code below?

> +	chip_version = mt9m032_read(client, MT9M032_CHIP_VERSION);
> +	if (chip_version != MT9M032_CHIP_VERSION_VALUE) {
> +		dev_err(&client->dev, "MT9M032 not detected, wrong version "
> +			"0x%04x\n", chip_version);
> +		ret = -ENODEV;
> +		goto free_sensor;
> +	}
> +
> +	dev_info(&client->dev, "MT9P031 detected at address 0x%02x\n",
> +		 client->addr);
> +
> +	sensor->frame_interval.numerator = 1;
> +	sensor->frame_interval.denominator = 30;
> +
> +	sensor->crop.left = 416;
> +	sensor->crop.top = 360;
> +	sensor->crop.width = 640;
> +	sensor->crop.height = 480;

Why such a default setup?

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
> +	sensor->hflip = v4l2_ctrl_new_std(&sensor->ctrls,
> +					  &mt9m032_ctrl_ops,
> +					  V4L2_CID_HFLIP, 0, 1, 1, 0);
> +	sensor->vflip = v4l2_ctrl_new_std(&sensor->ctrls,
> +					  &mt9m032_ctrl_ops,
> +					  V4L2_CID_VFLIP, 0, 1, 1, 0);
> +	v4l2_ctrl_cluster(2, &sensor->hflip);
> +
> +	v4l2_ctrl_new_std(&sensor->ctrls, &mt9m032_ctrl_ops,
> +			  V4L2_CID_EXPOSURE, 0, 8000, 1, 1700);    /* 1.7ms */
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
> +	ret = mt9m032_write(client, MT9M032_RESET, 1);	/* reset on */
> +	if (ret < 0)
> +		goto free_ctrl;
> +	mt9m032_write(client, MT9M032_RESET, 0);	/* reset off */
> +	if (ret < 0)
> +		goto free_ctrl;
> +
> +	ret = mt9m032_setup_pll(sensor);
> +	if (ret < 0)
> +		goto free_ctrl;
> +	usleep_range(10000, 11000);
> +
> +	v4l2_ctrl_handler_setup(&sensor->ctrls);
> +
> +	/* SIZE */
> +	ret = mt9m032_update_geom_timing(sensor);
> +	if (ret < 0)
> +		goto free_ctrl;
> +
> +	ret = mt9m032_write(client, 0x41, 0x0000);	/* reserved !!! */
> +	if (ret < 0)
> +		goto free_ctrl;
> +	ret = mt9m032_write(client, 0x42, 0x0003);	/* reserved !!! */
> +	if (ret < 0)
> +		goto free_ctrl;
> +	ret = mt9m032_write(client, 0x43, 0x0003);	/* reserved !!! */
> +	if (ret < 0)
> +		goto free_ctrl;
> +	ret = mt9m032_write(client, 0x7f, 0x0000);	/* reserved !!! */
> +	if (ret < 0)
> +		goto free_ctrl;
> +	if (sensor->pdata->invert_pixclock) {
> +		ret = mt9m032_write(client, MT9M032_PIX_CLK_CTRL,
> +				    MT9M032_PIX_CLK_CTRL_INV_PIXCLK);
> +		if (ret < 0)
> +			goto free_ctrl;
> +	}
> +
> +	ret = mt9m032_write(client, MT9M032_RESTART, 1); /* Restart on */
> +	if (ret < 0)
> +		goto free_ctrl;
> +	msleep(100);
> +	ret = mt9m032_write(client, MT9M032_RESTART, 0); /* Restart off */
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
> +	{ MT9M032_NAME, 0 },
> +	{ }
> +};
> +
> +MODULE_DEVICE_TABLE(i2c, mt9m032_id_table);
> +
> +static struct i2c_driver mt9m032_i2c_driver = {
> +	.driver = {
> +		.name = MT9M032_NAME,
> +	},
> +	.probe = mt9m032_probe,
> +	.remove = mt9m032_remove,
> +	.id_table = mt9m032_id_table,
> +};
> +
> +module_i2c_driver(mt9m032_i2c_driver);
> +
> +MODULE_AUTHOR("Martin Hostettler <martin@neutronstar.dyndns.org>");
> +MODULE_DESCRIPTION("MT9M032 camera sensor driver");
> +MODULE_LICENSE("GPL v2");
> diff --git a/include/media/mt9m032.h b/include/media/mt9m032.h
> new file mode 100644
> index 0000000..804e0a5
> --- /dev/null
> +++ b/include/media/mt9m032.h
> @@ -0,0 +1,36 @@
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
> +#define MT9M032_I2C_ADDR	(0xb8 >> 1)
> +
> +struct mt9m032_platform_data {
> +	u32 ext_clock;
> +	u32 pix_clock;
> +	int invert_pixclock;

unsigned?

> +
> +};
> +#endif /* MT9M032_H */
> -- 
> 1.7.3.4
> 

Regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
