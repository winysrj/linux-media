Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:51132 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754745Ab2CIVhA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Mar 2012 16:37:00 -0500
Received: by wejx9 with SMTP id x9so1431210wej.19
        for <linux-media@vger.kernel.org>; Fri, 09 Mar 2012 13:36:58 -0800 (PST)
Message-ID: <4F5A7667.4000709@gmail.com>
Date: Fri, 09 Mar 2012 22:30:15 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, sakari.ailus@iki.fi,
	Martin Hostettler <martin@neutronstar.dyndns.org>
Subject: Re: [PATCH v5 1/1] v4l: Add driver for Micron MT9M032 camera sensor
References: <1331305285-10781-6-git-send-email-laurent.pinchart@ideasonboard.com> <1331324481-9926-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1331324481-9926-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

I have a few minor comments, if you don't mind. :)

On 03/09/2012 09:21 PM, Laurent Pinchart wrote:
> From: Martin Hostettler<martin@neutronstar.dyndns.org>
> 
> The MT9M032 is a parallel 1.6MP sensor from Micron controlled through I2C.
> 
> The driver creates a V4L2 subdevice. It currently supports cropping, gain,
> exposure and v/h flipping controls in monochrome mode with an
> external pixel clock.
> 
> Signed-off-by: Martin Hostettler<martin@neutronstar.dyndns.org>
> [Lots of clean up, fixes and enhancements]
> Signed-off-by: Laurent Pinchart<laurent.pinchart@ideasonboard.com>
> ---
>   drivers/media/video/Kconfig   |    8 +
>   drivers/media/video/Makefile  |    1 +
>   drivers/media/video/mt9m032.c |  863 +++++++++++++++++++++++++++++++++++++++++
>   include/media/mt9m032.h       |   36 ++
>   4 files changed, 908 insertions(+), 0 deletions(-)
>   create mode 100644 drivers/media/video/mt9m032.c
>   create mode 100644 include/media/mt9m032.h
> 
> Resending the MT9P032 driver only, as the other patches in the set haven't
> been modified since v4.
> 
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index 666836d..745e958 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -470,6 +470,14 @@ config VIDEO_OV7670
>   	  OV7670 VGA camera.  It currently only works with the M88ALP01
>   	  controller.
> 
> +config VIDEO_MT9M032
> +	tristate "MT9M032 camera sensor support"
> +	depends on I2C&&  VIDEO_V4L2
> +	select VIDEO_APTINA_PLL
> +	---help---
> +	  This driver supports MT9M032 camera sensors from Aptina, monochrome
> +	  models only.
> +
>   config VIDEO_MT9P031
>   	tristate "Aptina MT9P031 support"
>   	depends on I2C&&  VIDEO_V4L2&&  VIDEO_V4L2_SUBDEV_API
> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> index d1304e1..f6af1d3 100644
> --- a/drivers/media/video/Makefile
> +++ b/drivers/media/video/Makefile
> @@ -69,6 +69,7 @@ obj-$(CONFIG_VIDEO_UPD64083) += upd64083.o
>   obj-$(CONFIG_VIDEO_OV7670) 	+= ov7670.o
>   obj-$(CONFIG_VIDEO_TCM825X) += tcm825x.o
>   obj-$(CONFIG_VIDEO_TVEEPROM) += tveeprom.o
> +obj-$(CONFIG_VIDEO_MT9M032) += mt9m032.o
>   obj-$(CONFIG_VIDEO_MT9P031) += mt9p031.o
>   obj-$(CONFIG_VIDEO_MT9T001) += mt9t001.o
>   obj-$(CONFIG_VIDEO_MT9V011) += mt9v011.o
> diff --git a/drivers/media/video/mt9m032.c b/drivers/media/video/mt9m032.c
> new file mode 100644
> index 0000000..f2f6168
> --- /dev/null
> +++ b/drivers/media/video/mt9m032.c
> @@ -0,0 +1,863 @@
> +/*
> + * Driver for MT9M032 CMOS Image Sensor from Micron
> + *
> + * Copyright (C) 2010-2011 Lund Engineering
> + * Contact: Gil Lund<gwlund@lundeng.com>
> + * Author: Martin Hostettler<martin@neutronstar.dyndns.org>
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
> +#include<linux/delay.h>
> +#include<linux/i2c.h>
> +#include<linux/init.h>
> +#include<linux/kernel.h>
> +#include<linux/math64.h>
> +#include<linux/module.h>
> +#include<linux/mutex.h>
> +#include<linux/slab.h>
> +#include<linux/v4l2-mediabus.h>
> +
> +#include<media/media-entity.h>
> +#include<media/mt9m032.h>
> +#include<media/v4l2-ctrls.h>
> +#include<media/v4l2-device.h>
> +#include<media/v4l2-subdev.h>
> +
> +#include "aptina-pll.h"
> +
> +/*
> + * width and height include active boundary and black parts
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

s/boundry/boundary

> + * row    1148-1151 black
> + */
> +
> +#define MT9M032_PIXEL_ARRAY_WIDTH			1600
> +#define MT9M032_PIXEL_ARRAY_HEIGHT			1152
> +
> +#define MT9M032_CHIP_VERSION				0x00
> +#define		MT9M032_CHIP_VERSION_VALUE		0x1402
> +#define MT9M032_ROW_START				0x01
> +#define		MT9M032_ROW_START_MIN			0
> +#define		MT9M032_ROW_START_MAX			1152
> +#define		MT9M032_ROW_START_DEF			60
> +#define MT9M032_COLUMN_START				0x02
> +#define		MT9M032_COLUMN_START_MIN		0
> +#define		MT9M032_COLUMN_START_MAX		1600
> +#define		MT9M032_COLUMN_START_DEF		16
> +#define MT9M032_ROW_SIZE				0x03
> +#define		MT9M032_ROW_SIZE_MIN			32
> +#define		MT9M032_ROW_SIZE_MAX			1152
> +#define		MT9M032_ROW_SIZE_DEF			1080
> +#define MT9M032_COLUMN_SIZE				0x04
> +#define		MT9M032_COLUMN_SIZE_MIN			32
> +#define		MT9M032_COLUMN_SIZE_MAX			1600
> +#define		MT9M032_COLUMN_SIZE_DEF			1440
> +#define MT9M032_HBLANK					0x05
> +#define MT9M032_VBLANK					0x06
> +#define		MT9M032_VBLANK_MAX			0x7ff
> +#define MT9M032_SHUTTER_WIDTH_HIGH			0x08
> +#define MT9M032_SHUTTER_WIDTH_LOW			0x09
> +#define		MT9M032_SHUTTER_WIDTH_MIN		1
> +#define		MT9M032_SHUTTER_WIDTH_MAX		1048575
> +#define		MT9M032_SHUTTER_WIDTH_DEF		1943
> +#define MT9M032_PIX_CLK_CTRL				0x0a
> +#define		MT9M032_PIX_CLK_CTRL_INV_PIXCLK		0x8000
> +#define MT9M032_RESTART					0x0b
> +#define MT9M032_RESET					0x0d
> +#define MT9M032_PLL_CONFIG1				0x11
> +#define		MT9M032_PLL_CONFIG1_OUTDIV_MASK		0x3f
> +#define		MT9M032_PLL_CONFIG1_MUL_SHIFT		8
> +#define MT9M032_READ_MODE1				0x1e
> +#define MT9M032_READ_MODE2				0x20
> +#define		MT9M032_READ_MODE2_VFLIP_SHIFT		15
> +#define		MT9M032_READ_MODE2_HFLIP_SHIFT		14
> +#define		MT9M032_READ_MODE2_ROW_BLC		0x40
> +#define MT9M032_GAIN_GREEN1				0x2b
> +#define MT9M032_GAIN_BLUE				0x2c
> +#define MT9M032_GAIN_RED				0x2d
> +#define MT9M032_GAIN_GREEN2				0x2e
> +
> +/* write only */
> +#define MT9M032_GAIN_ALL				0x35
> +#define		MT9M032_GAIN_DIGITAL_MASK		0x7f
> +#define		MT9M032_GAIN_DIGITAL_SHIFT		8
> +#define		MT9M032_GAIN_AMUL_SHIFT			6
> +#define		MT9M032_GAIN_ANALOG_MASK		0x3f
> +#define MT9M032_FORMATTER1				0x9e
> +#define MT9M032_FORMATTER2				0x9f
> +#define		MT9M032_FORMATTER2_DOUT_EN		0x1000
> +#define		MT9M032_FORMATTER2_PIXCLK_EN		0x2000
> +
> +/*
> + * The available MT9M032 datasheet is missing documentation for register 0x10
> + * MT9P031 seems to be close enough, so use constants from that datasheet for
> + * now.
> + * But keep the name MT9P031 to remind us, that this isn't really confirmed
> + * for this sensor.
> + */
> +#define MT9P031_PLL_CONTROL				0x10
> +#define		MT9P031_PLL_CONTROL_PWROFF		0x0050
> +#define		MT9P031_PLL_CONTROL_PWRON		0x0051
> +#define		MT9P031_PLL_CONTROL_USEPLL		0x0052
> +#define MT9P031_PLL_CONFIG2				0x11
> +#define		MT9P031_PLL_CONFIG2_P1_DIV_MASK		0x1f
> +
> +struct mt9m032 {
> +	struct v4l2_subdev subdev;
> +	struct media_pad pad;
> +	struct mt9m032_platform_data *pdata;
> +
> +	unsigned int pix_clock;
> +
> +	struct v4l2_ctrl_handler ctrls;
> +	struct {
> +		struct v4l2_ctrl *hflip;
> +		struct v4l2_ctrl *vflip;
> +	};
> +
> +	struct mutex lock; /* Protects streaming, format, interval and crop */
> +
> +	bool streaming;
> +
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
> +static u32 mt9m032_row_time(struct mt9m032 *sensor, unsigned int width)
> +{
> +	unsigned int effective_width;
> +	u32 ns;
> +
> +	effective_width = width + 716; /* emperical value */

s/emperical/empirical 

> +	ns = div_u64(1000000000ULL * effective_width, sensor->pix_clock);
> +	dev_dbg(to_dev(sensor),	"MT9M032 line time: %u ns\n", ns);
> +	return ns;
> +}
> +
> +static int mt9m032_update_timing(struct mt9m032 *sensor,
> +				 struct v4l2_fract *interval)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
> +	struct v4l2_rect *crop =&sensor->crop;
> +	unsigned int min_vblank;
> +	unsigned int vblank;
> +	u32 row_time;
> +
> +	if (!interval)
> +		interval =&sensor->frame_interval;
> +
> +	row_time = mt9m032_row_time(sensor, crop->width);
> +
> +	vblank = div_u64(1000000000ULL * interval->numerator,
> +			 (u64)row_time * interval->denominator)
> +	       - crop->height;
> +
> +	if (vblank>  MT9M032_VBLANK_MAX) {
> +		/* hardware limits to 11 bit values */
> +		interval->denominator = 1000;
> +		interval->numerator =
> +			div_u64((crop->height + MT9M032_VBLANK_MAX) *
> +				(u64)row_time * interval->denominator,
> +				1000000000ULL);
> +		vblank = div_u64(1000000000ULL * interval->numerator,
> +				 (u64)row_time * interval->denominator)
> +		       - crop->height;
> +	}
> +	/* enforce minimal 1.6ms blanking time. */
> +	min_vblank = 1600000 / row_time;
> +	vblank = clamp_t(unsigned int, vblank, min_vblank, MT9M032_VBLANK_MAX);
> +
> +	return mt9m032_write(client, MT9M032_VBLANK, vblank);
> +}
> +
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
> +	ret = aptina_pll_calculate(&client->dev,&limits,&pll);
> +	if (ret<  0)
> +		return ret;
> +
> +	sensor->pix_clock = pll.pix_clock;
> +
> +	ret = mt9m032_write(client, MT9M032_PLL_CONFIG1,
> +			    (pll.m<<  MT9M032_PLL_CONFIG1_MUL_SHIFT)
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
> +	fse->min_width = MT9M032_COLUMN_SIZE_DEF;
> +	fse->max_width = MT9M032_COLUMN_SIZE_DEF;
> +	fse->min_height = MT9M032_ROW_SIZE_DEF;
> +	fse->max_height = MT9M032_ROW_SIZE_DEF;
> +
> +	return 0;
> +}
> +
> +/**
> + * __mt9m032_get_pad_crop() - get crop rect
> + * @sensor: pointer to the sensor struct
> + * @fh: filehandle for getting the try crop rect from

s/filehandle/ file handle ?

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
> +		return&sensor->crop;
> +	default:
> +		return NULL;
> +	}
> +}
> +
> +/**
> + * __mt9m032_get_pad_format() - get format
> + * @sensor: pointer to the sensor struct
> + * @fh: filehandle for getting the try format from

s/filehandle/ file handle ?

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
> +		return&sensor->format;
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
> +	mutex_lock(&sensor->lock);
> +	fmt->format = *__mt9m032_get_pad_format(sensor, fh, fmt->which);
> +	mutex_unlock(&sensor->lock);
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
> +	mutex_lock(&sensor->lock);
> +
> +	if (sensor->streaming&&  fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
> +		ret = -EBUSY;
> +		goto done;
> +	}
> +
> +	/* Scaling is not supported, the format is thus fixed. */
> +	ret = mt9m032_get_pad_format(subdev, fh, fmt);
> +
> +done:
> +	mutex_lock(&sensor->lock);
> +	return ret;
> +}
> +
> +static int mt9m032_get_pad_crop(struct v4l2_subdev *subdev,
> +				struct v4l2_subdev_fh *fh,
> +				struct v4l2_subdev_crop *crop)
> +{
> +	struct mt9m032 *sensor = to_mt9m032(subdev);
> +
> +	mutex_lock(&sensor->lock);
> +	crop->rect = *__mt9m032_get_pad_crop(sensor, fh, crop->which);
> +	mutex_unlock(&sensor->lock);
> +
> +	return 0;
> +}
> +
> +static int mt9m032_set_pad_crop(struct v4l2_subdev *subdev,
> +				struct v4l2_subdev_fh *fh,
> +				struct v4l2_subdev_crop *crop)
> +{
> +	struct mt9m032 *sensor = to_mt9m032(subdev);
> +	struct v4l2_mbus_framefmt *format;
> +	struct v4l2_rect *__crop;
> +	struct v4l2_rect rect;
> +	int ret = 0;
> +
> +	mutex_lock(&sensor->lock);
> +
> +	if (sensor->streaming&&  crop->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
> +		ret = -EBUSY;
> +		goto done;
> +	}
> +
> +	/* Clamp the crop rectangle boundaries and align them to a multiple of 2
> +	 * pixels to ensure a GRBG Bayer pattern.
> +	 */
> +	rect.left = clamp(ALIGN(crop->rect.left, 2), MT9M032_COLUMN_START_MIN,
> +			  MT9M032_COLUMN_START_MAX);
> +	rect.top = clamp(ALIGN(crop->rect.top, 2), MT9M032_ROW_START_MIN,
> +			 MT9M032_ROW_START_MAX);
> +	rect.width = clamp(ALIGN(crop->rect.width, 2), MT9M032_COLUMN_SIZE_MIN,
> +			   MT9M032_COLUMN_SIZE_MAX);
> +	rect.height = clamp(ALIGN(crop->rect.height, 2), MT9M032_ROW_SIZE_MIN,
> +			    MT9M032_ROW_SIZE_MAX);
> +
> +	rect.width = min(rect.width, MT9M032_PIXEL_ARRAY_WIDTH - rect.left);
> +	rect.height = min(rect.height, MT9M032_PIXEL_ARRAY_HEIGHT - rect.top);
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
> +	if (crop->which == V4L2_SUBDEV_FORMAT_ACTIVE)
> +		ret = mt9m032_update_geom_timing(sensor);
> +
> +done:
> +	mutex_unlock(&sensor->lock);
> +	return ret;
> +}
> +
> +static int mt9m032_get_frame_interval(struct v4l2_subdev *subdev,
> +				      struct v4l2_subdev_frame_interval *fi)
> +{
> +	struct mt9m032 *sensor = to_mt9m032(subdev);
> +
> +	mutex_lock(&sensor->lock);
> +	memset(fi, 0, sizeof(*fi));
> +	fi->interval = sensor->frame_interval;
> +	mutex_unlock(&sensor->lock);
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
> +	mutex_lock(&sensor->lock);
> +
> +	if (sensor->streaming) {
> +		ret = -EBUSY;
> +		goto done;
> +	}
> +
> +	ret = mt9m032_update_timing(sensor,&fi->interval);
> +	if (!ret)
> +		sensor->frame_interval = fi->interval;
> +
> +done:
> +	mutex_unlock(&sensor->lock);
> +	return ret;
> +}
> +
> +static int mt9m032_s_stream(struct v4l2_subdev *subdev, int streaming)
> +{
> +	struct mt9m032 *sensor = to_mt9m032(subdev);
> +	int ret;
> +
> +	mutex_lock(&sensor->lock);
> +	ret = update_formatter2(sensor, streaming);
> +	if (!ret)
> +		sensor->streaming = streaming;
> +	mutex_unlock(&sensor->lock);
> +
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
> +	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg>  0xff)
> +		return -EINVAL;
> +	if (reg->match.addr != client->addr)
> +		return -ENODEV;
> +
> +	val = mt9m032_read(client, reg->reg);
> +	if (val<  0)
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
> +	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg>  0xff)
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
> +	int reg_val = (!!vflip)<<  MT9M032_READ_MODE2_VFLIP_SHIFT
> +		    | (!!hflip)<<  MT9M032_READ_MODE2_HFLIP_SHIFT

You don't need !! here, since the type of hflip, vflip is already bool. 
The arguments will be converted to bool values when being passed to this 
function.

> +		    | MT9M032_READ_MODE2_ROW_BLC
> +		    | 0x0007;
> +
> +	return mt9m032_write(client, MT9M032_READ_MODE2, reg_val);
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
> +	if (val<  63) {
> +		analog_mul = 0;
> +		analog_gain_val = val;
> +	} else {
> +		analog_mul = 1;
> +		analog_gain_val = val / 2;
> +	}
> +
> +	/* a_gain = (1+analog_mul) + (analog_gain_val+1)/16 */

nit: I would use same whitespacing rules as for the line below.

> +	/* overall_gain = a_gain * (1 + digital_gain_val / 8) */
> +
> +	reg_val = ((digital_gain_val&  MT9M032_GAIN_DIGITAL_MASK)
> +		<<  MT9M032_GAIN_DIGITAL_SHIFT)
> +		| ((analog_mul&  1)<<  MT9M032_GAIN_AMUL_SHIFT)
> +		| (analog_gain_val&  MT9M032_GAIN_ANALOG_MASK);
> +
> +	return mt9m032_write(client, MT9M032_GAIN_ALL, reg_val);
> +}
> +
> +static int mt9m032_try_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	if (ctrl->id == V4L2_CID_GAIN&&  ctrl->val>= 63) {
> +		/* round because of multiplier used for values>= 63 */
> +		ctrl->val&= ~1;
> +	}
> +
> +	return 0;
> +}
> +
> +static int mt9m032_set_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct mt9m032 *sensor =
> +		container_of(ctrl->handler, struct mt9m032, ctrls);
> +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
> +	int ret;
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_GAIN:
> +		return mt9m032_set_gain(sensor, ctrl->val);
> +
> +	case V4L2_CID_HFLIP:
> +	case V4L2_CID_VFLIP:

mt9m032_set_ctrl() will never be called with V4L2_CID_VFLIP control id, 
since the first control in the cluster is HFLIP.

> +		return update_read_mode2(sensor, sensor->vflip->val,
> +					 sensor->hflip->val);
> +
> +	case V4L2_CID_EXPOSURE:
> +		ret = mt9m032_write(client, MT9M032_SHUTTER_WIDTH_HIGH,
> +				    (ctrl->val>>  16)&  0xffff);
> +		if (ret<  0)
> +			return ret;
> +
> +		return mt9m032_write(client, MT9M032_SHUTTER_WIDTH_LOW,
> +				     ctrl->val&  0xffff);
> +
> +	default:

This is an impossible case, isn't it ? The control framework won't call s_ctrl 
op for controls that were never registered to the control handler, AFAIK. So it 
should be safe to omit the "default" case. OTOH some rules say that it is a good
practice to always have the "default" case with a switch statement.

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
> +	.set_crop = mt9m032_set_pad_crop,
> +	.get_crop = mt9m032_get_pad_crop,
> +};
> +
> +static const struct v4l2_subdev_ops mt9m032_ops = {
> +	.core =&mt9m032_core_ops,
> +	.video =&mt9m032_video_ops,
> +	.pad =&mt9m032_pad_ops,
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

Haven't you consider using devm_kzalloc() ?
(http://www.kernel.org/doc/htmldocs/device-drivers/API-devm-kzalloc.html)
It would slightly simplify the code, however it will use a couple of bytes
of memory for the resource tracking.

> +	if (sensor == NULL)
> +		return -ENOMEM;
> +
> +	mutex_init(&sensor->lock);
> +
> +	sensor->pdata = client->dev.platform_data;
> +
> +	v4l2_i2c_subdev_init(&sensor->subdev, client,&mt9m032_ops);
> +	sensor->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> +
> +	chip_version = mt9m032_read(client, MT9M032_CHIP_VERSION);
> +	if (chip_version != MT9M032_CHIP_VERSION_VALUE) {
> +		dev_err(&client->dev, "MT9M032 not detected, wrong version "
> +			"0x%04x\n", chip_version);
> +		ret = -ENODEV;
> +		goto error_sensor;
> +	}
> +
> +	dev_info(&client->dev, "MT9M032 detected at address 0x%02x\n",
> +		 client->addr);
> +
> +	sensor->frame_interval.numerator = 1;
> +	sensor->frame_interval.denominator = 30;
> +
> +	sensor->crop.left = MT9M032_COLUMN_START_DEF;
> +	sensor->crop.top = MT9M032_ROW_START_DEF;
> +	sensor->crop.width = MT9M032_COLUMN_SIZE_DEF;
> +	sensor->crop.height = MT9M032_ROW_SIZE_DEF;
> +
> +	sensor->format.width = sensor->crop.width;
> +	sensor->format.height = sensor->crop.height;
> +	sensor->format.code = V4L2_MBUS_FMT_Y8_1X8;
> +	sensor->format.field = V4L2_FIELD_NONE;
> +	sensor->format.colorspace = V4L2_COLORSPACE_SRGB;
> +
> +	v4l2_ctrl_handler_init(&sensor->ctrls, 4);
> +
> +	v4l2_ctrl_new_std(&sensor->ctrls,&mt9m032_ctrl_ops,
> +			  V4L2_CID_GAIN, 0, 127, 1, 64);
> +
> +	sensor->hflip = v4l2_ctrl_new_std(&sensor->ctrls,
> +					&mt9m032_ctrl_ops,
> +					  V4L2_CID_HFLIP, 0, 1, 1, 0);
> +	sensor->vflip = v4l2_ctrl_new_std(&sensor->ctrls,
> +					&mt9m032_ctrl_ops,
> +					  V4L2_CID_VFLIP, 0, 1, 1, 0);
> +
> +	v4l2_ctrl_new_std(&sensor->ctrls,&mt9m032_ctrl_ops,
> +			  V4L2_CID_EXPOSURE, MT9M032_SHUTTER_WIDTH_MIN,
> +			  MT9M032_SHUTTER_WIDTH_MAX, 1,
> +			  MT9M032_SHUTTER_WIDTH_DEF);
> +
> +	if (sensor->ctrls.error) {
> +		ret = sensor->ctrls.error;
> +		dev_err(&client->dev, "control initialization error %d\n", ret);
> +		goto error_ctrl;
> +	}
> +
> +	v4l2_ctrl_cluster(2,&sensor->hflip);
> +
> +	sensor->subdev.ctrl_handler =&sensor->ctrls;
> +	sensor->pad.flags = MEDIA_PAD_FL_SOURCE;
> +	ret = media_entity_init(&sensor->subdev.entity, 1,&sensor->pad, 0);
> +	if (ret<  0)
> +		goto error_ctrl;
> +
> +	ret = mt9m032_write(client, MT9M032_RESET, 1);	/* reset on */
> +	if (ret<  0)
> +		goto error_entity;
> +	mt9m032_write(client, MT9M032_RESET, 0);	/* reset off */
> +	if (ret<  0)
> +		goto error_entity;
> +
> +	ret = mt9m032_setup_pll(sensor);
> +	if (ret<  0)
> +		goto error_entity;
> +	usleep_range(10000, 11000);
> +
> +	v4l2_ctrl_handler_setup(&sensor->ctrls);

I guess you ignore the return value delibrately ?

> +	/* SIZE */
> +	ret = mt9m032_update_geom_timing(sensor);
> +	if (ret<  0)
> +		goto error_entity;
> +
> +	ret = mt9m032_write(client, 0x41, 0x0000);	/* reserved !!! */
> +	if (ret<  0)
> +		goto error_entity;
> +	ret = mt9m032_write(client, 0x42, 0x0003);	/* reserved !!! */
> +	if (ret<  0)
> +		goto error_entity;
> +	ret = mt9m032_write(client, 0x43, 0x0003);	/* reserved !!! */
> +	if (ret<  0)
> +		goto error_entity;
> +	ret = mt9m032_write(client, 0x7f, 0x0000);	/* reserved !!! */
> +	if (ret<  0)
> +		goto error_entity;
> +	if (sensor->pdata->invert_pixclock) {
> +		ret = mt9m032_write(client, MT9M032_PIX_CLK_CTRL,
> +				    MT9M032_PIX_CLK_CTRL_INV_PIXCLK);
> +		if (ret<  0)
> +			goto error_entity;
> +	}
> +
> +	ret = mt9m032_write(client, MT9M032_RESTART, 1); /* Restart on */
> +	if (ret<  0)
> +		goto error_entity;
> +	msleep(100);
> +	ret = mt9m032_write(client, MT9M032_RESTART, 0); /* Restart off */
> +	if (ret<  0)
> +		goto error_entity;
> +	msleep(100);
> +	ret = update_formatter2(sensor, false);
> +	if (ret<  0)
> +		goto error_entity;
> +
> +	return ret;
> +
> +error_entity:
> +	media_entity_cleanup(&sensor->subdev.entity);
> +error_ctrl:
> +	v4l2_ctrl_handler_free(&sensor->ctrls);
> +error_sensor:
> +	mutex_destroy(&sensor->lock);
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
> +	mutex_destroy(&sensor->lock);
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
> +MODULE_AUTHOR("Martin Hostettler<martin@neutronstar.dyndns.org>");
> +MODULE_DESCRIPTION("MT9M032 camera sensor driver");
> +MODULE_LICENSE("GPL v2");
> diff --git a/include/media/mt9m032.h b/include/media/mt9m032.h
> new file mode 100644
> index 0000000..c3a7811
> --- /dev/null
> +++ b/include/media/mt9m032.h
> @@ -0,0 +1,36 @@
> +/*
> + * Driver for MT9M032 CMOS Image Sensor from Micron
> + *
> + * Copyright (C) 2010-2011 Lund Engineering
> + * Contact: Gil Lund<gwlund@lundeng.com>
> + * Author: Martin Hostettler<martin@neutronstar.dyndns.org>
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
> +#define MT9M032_I2C_ADDR	(0xb8>>  1)
>
> +struct mt9m032_platform_data {
> +	u32 ext_clock;
> +	u32 pix_clock;
> +	bool invert_pixclock;
> +
> +};
> +#endif /* MT9M032_H */

--
Regards,
Sylwester
