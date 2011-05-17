Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54061 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570Ab1EQLeK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 May 2011 07:34:10 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Javier Martin <javier.martin@vista-silicon.com>
Subject: Re: [PATCH 1/2] mt9p031: Add mt9p031 sensor driver.
Date: Tue, 17 May 2011 13:33:52 +0200
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	carlighting@yahoo.co.nz, beagleboard@googlegroups.com,
	linux-arm-kernel@lists.infradead.org
References: <1305624528-5595-1-git-send-email-javier.martin@vista-silicon.com> <1305624528-5595-2-git-send-email-javier.martin@vista-silicon.com>
In-Reply-To: <1305624528-5595-2-git-send-email-javier.martin@vista-silicon.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105171334.01607.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Javier,

Thanks for the patch.

On Tuesday 17 May 2011 11:28:47 Javier Martin wrote:
> It has been tested in beagleboard xM, using LI-5M03 module.
> 
> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>

[snip]

> diff --git a/drivers/media/video/mt9p031.c b/drivers/media/video/mt9p031.c
> new file mode 100644
> index 0000000..850cfec
> --- /dev/null
> +++ b/drivers/media/video/mt9p031.c
> @@ -0,0 +1,773 @@
> +/*
> + * Driver for MT9P031 CMOS Image Sensor from Aptina
> + *
> + * Copyright (C) 2011, Javier Martin <javier.martin@vista-silicon.com>
> + *
> + * Copyright (C) 2011, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> + *
> + * Based on the MT9V032 driver and Bastian Hecht's code.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
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
> +/* mt9p031 selected register addresses */
> +#define MT9P031_CHIP_VERSION			0x00
> +#define		MT9P031_CHIP_VERSION_VALUE	0x1801
> +#define MT9P031_ROW_START			0x01
> +#define		MT9P031_ROW_START_SKIP		54
> +#define MT9P031_COLUMN_START			0x02
> +#define		MT9P031_COLUMN_START_SKIP	16
> +#define MT9P031_WINDOW_HEIGHT			0x03
> +#define MT9P031_WINDOW_WIDTH			0x04
> +#define MT9P031_H_BLANKING			0x05
> +#define		MT9P031_H_BLANKING_VALUE	0
> +#define MT9P031_V_BLANKING			0x06
> +#define		MT9P031_V_BLANKING_VALUE	25
> +#define MT9P031_OUTPUT_CONTROL			0x07
> +#define		MT9P031_OUTPUT_CONTROL_CEN	2
> +#define		MT9P031_OUTPUT_CONTROL_SYN	1
> +#define MT9P031_SHUTTER_WIDTH_UPPER		0x08
> +#define MT9P031_SHUTTER_WIDTH			0x09
> +#define MT9P031_PIXEL_CLOCK_CONTROL		0x0a
> +#define MT9P031_FRAME_RESTART			0x0b
> +#define MT9P031_SHUTTER_DELAY			0x0c
> +#define MT9P031_RESET				0x0d
> +#define		MT9P031_RESET_ENABLE		1
> +#define		MT9P031_RESET_DISABLE		0
> +#define MT9P031_READ_MODE_1			0x1e
> +#define MT9P031_READ_MODE_2			0x20
> +#define		MT9P031_READ_MODE_2_ROW_MIR	0x8000
> +#define		MT9P031_READ_MODE_2_COL_MIR	0x4000
> +#define MT9P031_ROW_ADDRESS_MODE		0x22
> +#define MT9P031_COLUMN_ADDRESS_MODE		0x23
> +#define MT9P031_GLOBAL_GAIN			0x35
> +
> +#define MT9P031_MAX_HEIGHT			1944
> +#define MT9P031_MAX_WIDTH			2592
> +#define MT9P031_MIN_HEIGHT			2
> +#define MT9P031_MIN_WIDTH			18
> +
> +struct mt9p031 {
> +	struct v4l2_subdev subdev;
> +	struct media_pad pad;
> +	struct v4l2_rect rect;	/* Sensor window */
> +	struct v4l2_mbus_framefmt format;
> +	struct mt9p031_platform_data *pdata;
> +	int model;	/* V4L2_IDENT_MT9P031* codes from v4l2-chip-ident.h */

model is assigned by never read, you can remove it.

> +	u16 xskip;
> +	u16 yskip;
> +	struct regulator *reg_1v8, *reg_2v8;

Please split this on two lines.

You never enable the 1.8V regulator, is that intentional ?

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
> +}
> +
> +static int reg_clear(struct i2c_client *client, const u8 reg,
> +		     const u16 data)
> +{
> +	int ret;
> +
> +	ret = reg_read(client, reg);
> +	if (ret < 0)
> +		return ret;
> +	return reg_write(client, reg, ret & ~data);
> +}

I still think you should use a shadow copy of the register in the mt9p031 
structure instead of reading the value back from the hardware. As these two 
functions are only used to handle the output control register, you could 
create an mt9p031_set_output_control(struct mt9p031 *mt9p031, u16 clear, u16 
set) function instead.

> +static int mt9p031_idle(struct i2c_client *client)

This function resets the chip, what about calling it mt9p031_reset() instead ?

> +{
> +	int ret;
> +
> +	/* Disable chip output, synchronous option update */
> +	ret = reg_write(client, MT9P031_RESET, MT9P031_RESET_ENABLE);
> +	if (ret < 0)
> +		goto err;

You can return -EIO directly.

> +	ret = reg_write(client, MT9P031_RESET, MT9P031_RESET_DISABLE);
> +	if (ret < 0)
> +		goto err;

Here too.

> +	ret = reg_clear(client, MT9P031_OUTPUT_CONTROL,
> +			MT9P031_OUTPUT_CONTROL_CEN);
> +	if (ret < 0)
> +		goto err;

And here too.

> +	return 0;
> +err:
> +	return -EIO;
> +}

[snip]

> +
> +static int mt9p031_power_on(struct mt9p031 *mt9p031)
> +{
> +	int ret;
> +
> +	if (mt9p031->pdata->set_xclk)
> +		mt9p031->pdata->set_xclk(&mt9p031->subdev, 54000000);
> +	/* turn on VDD_IO */
> +	ret = regulator_enable(mt9p031->reg_2v8);
> +	if (ret) {
> +		pr_err("Failed to enable 2.8v regulator: %d\n", ret);
> +		return -1;
> +	}

I would enable the regulator first. As a general rule, chips should be powered 
up before their I/Os are actively driven.

You need to restore registers here, otherwise all controls set by the user 
will not be applied to the device.

> +	return 0;
> +}

[snip]

> +static u16 mt9p031_skip_for_crop(s32 source, s32 *target, s32 max_skip)
> +{
> +	unsigned int skip;
> +
> +	if (source - source / 4 < *target) {
> +		*target = source;
> +		return 1;
> +	}
> +
> +	skip = DIV_ROUND_CLOSEST(source, *target);
> +	if (skip > max_skip)
> +		skip = max_skip;
> +	*target = 2 * DIV_ROUND_UP(source, 2 * skip);
> +
> +	return skip;
> +}
> +
> +static int mt9p031_set_params(struct i2c_client *client,
> +			      struct v4l2_rect *rect, u16 xskip, u16 yskip)

set_params should apply the parameters, not change them. They should have 
already been validated by the callers.

> +{
> +	struct mt9p031 *mt9p031 = to_mt9p031(client);
> +	int ret;
> +	u16 xbin, ybin;
> +	const u16 hblank = MT9P031_H_BLANKING_VALUE,
> +		vblank = MT9P031_V_BLANKING_VALUE;
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
> +	ret = reg_set(client, MT9P031_OUTPUT_CONTROL,
> +				MT9P031_OUTPUT_CONTROL_SYN);
> +	if (ret < 0)
> +		goto err;
> +
> +	dev_dbg(&client->dev, "skip %u:%u, rect %ux%u@%u:%u\n",
> +		xskip, yskip, rect->width, rect->height, rect->left, rect->top);
> +
> +	/* Blanking and start values - default... */
> +	ret = reg_write(client, MT9P031_H_BLANKING, hblank);
> +	if (ret < 0)
> +		goto err;
> +	ret = reg_write(client, MT9P031_V_BLANKING, vblank);
> +	if (ret < 0)
> +		goto err;
> +
> +	if (yskip != mt9p031->yskip || xskip != mt9p031->xskip) {
> +		/* Binning, skipping */
> +		ret = reg_write(client, MT9P031_COLUMN_ADDRESS_MODE,
> +					((xbin - 1) << 4) | (xskip - 1));
> +		if (ret < 0)
> +			goto err;
> +		ret = reg_write(client, MT9P031_ROW_ADDRESS_MODE,
> +					((ybin - 1) << 4) | (yskip - 1));
> +		if (ret < 0)
> +			goto err;
> +	}
> +	dev_dbg(&client->dev, "new physical left %u, top %u\n",
> +		rect->left, rect->top);
> +
> +	ret = reg_write(client, MT9P031_COLUMN_START,
> +				rect->left + MT9P031_COLUMN_START_SKIP);
> +	if (ret < 0)
> +		goto err;
> +	ret = reg_write(client, MT9P031_ROW_START,
> +				rect->top + MT9P031_ROW_START_SKIP);
> +	if (ret < 0)
> +		goto err;
> +	ret = reg_write(client, MT9P031_WINDOW_WIDTH,
> +				rect->width - 1);
> +	if (ret < 0)
> +		goto err;
> +	ret = reg_write(client, MT9P031_WINDOW_HEIGHT,
> +				rect->height - 1);
> +	if (ret < 0)
> +		goto err;
> +
> +	/* Re-enable register update, commit all changes */
> +	ret = reg_clear(client, MT9P031_OUTPUT_CONTROL,
> +				MT9P031_OUTPUT_CONTROL_SYN);
> +	if (ret < 0)
> +		goto err;
> +
> +	mt9p031->xskip = xskip;
> +	mt9p031->yskip = yskip;
> +	return ret;
> +err:
> +	return -1;
> +}
> +
> +static int mt9p031_set_crop(struct v4l2_subdev *sd,
> +				struct v4l2_subdev_fh *fh,
> +				struct v4l2_subdev_crop *crop)
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
> +			crop->rect.width, crop->rect.height,
> +			crop->rect.left, crop->rect.top, crop->which);
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
> +
> +	*c = rect;
> +	crop->rect = rect;
> +
> +	return 0;
> +}

[snip]

> +static u16 mt9p031_skip_for_scale(s32 *source, s32 target,
> +					s32 max_skip, s32 max)
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

[snip]

> +static int mt9p031_set_format(struct v4l2_subdev *sd,
> +				struct v4l2_subdev_fh *fh,
> +				struct v4l2_subdev_format *fmt)
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

If width and height are identical to the current value, you can return 
immediately.

> +		c = mt9p031_get_pad_crop(mt9p031, fh, fmt->pad, fmt->which);
> +
> +		rect.width = c->width;
> +		rect.height = c->height;
> +
> +		xskip = mt9p031_skip_for_scale(&rect.width, format->width, 7,
> +					       MT9P031_MAX_WIDTH);
> +		if (rect.width + c->left > MT9P031_MAX_WIDTH)
> +			rect.left = (MT9P031_MAX_WIDTH - rect.width) / 2;
> +		else
> +			rect.left = c->left;
> +		yskip = mt9p031_skip_for_scale(&rect.height, format->height, 8,
> +					       MT9P031_MAX_HEIGHT);
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
> +	pr_info("%s(%ux%u : %u)\n", __func__,
> +		format->width, format->height, fmt->which);
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
> +}

[snip]

> +static int mt9p031_registered(struct v4l2_subdev *sd)
> +{
> +	struct mt9p031 *mt9p031;
> +	mt9p031 = container_of(sd, struct mt9p031, subdev);
> +
> +	mt9p031_power_off(mt9p031);

What's that for ?

> +	return 0;
> +}

[snip]

> +static int mt9p031_close(struct v4l2_subdev *sd, struct v4l2_subdev_fh
> *fh) +{
> +	struct mt9p031 *mt9p031;
> +
> +	mt9p031 = container_of(sd, struct mt9p031, subdev);
> +
> +	mt9p031_power_off(mt9p031);

You need to reference count power handling, otherwise closing the subdev file 
handle will turn the power off, even if the sensor is part of a pipeline 
actively streaming video. Have a look at the mt9v032 driver to see how that's 
done.

> +	return 0;
> +}

[snip]

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
> +	mt9p031->subdev.internal_ops = &mt9p031_subdev_internal_ops;
> +
> +	mt9p031->pdata		= pdata;
> +	mt9p031->rect.left	= 0/*MT9P031_COLUMN_SKIP*/;
> +	mt9p031->rect.top	= 0/*MT9P031_ROW_SKIP*/;

No commented out code please.

> +	mt9p031->rect.width	= MT9P031_MAX_WIDTH;
> +	mt9p031->rect.height	= MT9P031_MAX_HEIGHT;
> +
> +	mt9p031->format.code = V4L2_MBUS_FMT_SGRBG12_1X12;
> +
> +	mt9p031->format.width = MT9P031_MAX_WIDTH;
> +	mt9p031->format.height = MT9P031_MAX_HEIGHT;
> +	mt9p031->format.field = V4L2_FIELD_NONE;
> +	mt9p031->format.colorspace = V4L2_COLORSPACE_SRGB;
> +
> +	/* mt9p031_idle() will reset the chip to default. */

There's no mt9p032_idle() call here.
> +
> +	mt9p031->xskip = 1;
> +	mt9p031->yskip = 1;
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
> +	ret = mt9p031_power_on(mt9p031);
> +	if (ret) {
> +		pr_err("Failed to power on device: %d\n", ret);
> +		goto pwron;
> +	}
> +	/* turn on VDD_IO */
> +	ret = regulator_enable(mt9p031->reg_2v8);
> +	if (ret) {
> +		pr_err("Failed to enable 2.8v regulator: %d\n", ret);
> +		goto e2v8en;
> +	}

The regulator is enabled by mt9p032_power_on(), there's no need to enable it a 
second time herE.

> +
> +	if (pdata->reset)
> +		pdata->reset(sd, 1);
> +
> +	msleep(50);
> +
> +	if (pdata->reset)
> +		pdata->reset(sd, 0);
> +
> +	msleep(50);

Why do you need to reset the chip here ? If resetting it is required after 
powering it up, you should do it every time the power is turned on, not just 
here.

> +	ret = mt9p031_video_probe(client);

You have a set_xclk callback to board code, so I assume the chip can be driven 
by one of the OMAP3 ISP XCLK signals. To call back to the OMAP3 ISP from board 
code, you need to get hold of the OMAP3 ISP device pointer. Your next patch 
exports omap3isp_device, but I'm not sure that's the way to go. One option is

struct isp_device *isp = v4l2_dev_to_isp_device(subdev->v4l2_dev);

but that requires the subdev to be registered before the function can be 
called. In that case you would need to move the probe code to the registered 
subdev internal function.

A clean solution is needed in the long run, preferably not involving board 
code at all. It would be nice if the OMAP3 ISP driver could export XCLKA/XCLKB 
as generic clock objects.

> +	if (ret)
> +		goto evprobe;
> +
> +	mt9p031->pad.flags = MEDIA_PAD_FL_SOURCE;
> +	ret = media_entity_init(&mt9p031->subdev.entity, 1, &mt9p031->pad, 0);
> +	if (ret)
> +		goto evprobe;
> +
> +	mt9p031->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> +
> +	return ret;
> +
> +evprobe:
> +	regulator_disable(mt9p031->reg_2v8);
> +e2v8en:
> +	mt9p031_power_off(mt9p031);
> +pwron:
> +	regulator_put(mt9p031->reg_2v8);
> +e2v8:
> +	regulator_put(mt9p031->reg_1v8);
> +e1v8:
> +	kfree(mt9p031);
> +	return ret;
> +}


[snip]

> +MODULE_DESCRIPTION("Aptina MT9P031 Camera driver");

You mention Micron in the Kconfig file, maybe you could replace it with 
Aptina.

> +MODULE_AUTHOR("Bastian Hecht <hechtb@gmail.com>");
> +MODULE_LICENSE("GPL v2");

[snip]

> diff --git a/include/media/v4l2-chip-ident.h
> b/include/media/v4l2-chip-ident.h index b3edb67..97919f2 100644
> --- a/include/media/v4l2-chip-ident.h
> +++ b/include/media/v4l2-chip-ident.h
> @@ -297,6 +297,7 @@ enum {
>  	V4L2_IDENT_MT9T112		= 45022,
>  	V4L2_IDENT_MT9V111		= 45031,
>  	V4L2_IDENT_MT9V112		= 45032,
> +	V4L2_IDENT_MT9P031		= 45033,

This constant will become unused, you can remove it as well.

> 
>  	/* HV7131R CMOS sensor: just ident 46000 */
>  	V4L2_IDENT_HV7131R		= 46000,

-- 
Regards,

Laurent Pinchart
