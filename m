Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55138 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114Ab1EYIFQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 04:05:16 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Javier Martin <javier.martin@vista-silicon.com>
Subject: Re: [PATCH][RFC] Add mt9p031 sensor support.
Date: Wed, 25 May 2011 10:05:27 +0200
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	carlighting@yahoo.co.nz, beagleboard@googlegroups.com,
	linux-arm-kernel@lists.infradead.org
References: <1306247443-2191-1-git-send-email-javier.martin@vista-silicon.com>
In-Reply-To: <1306247443-2191-1-git-send-email-javier.martin@vista-silicon.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105251005.28691.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Javier,

Thanks for the patch. Here's a review of the power handling code.

On Tuesday 24 May 2011 16:30:43 Javier Martin wrote:
> This RFC includes a power management implementation that causes
> the sensor to show images with horizontal artifacts (usually
> monochrome lines that appear on the image randomly).
> 
> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>

[snip]

> diff --git a/drivers/media/video/mt9p031.c b/drivers/media/video/mt9p031.c
> new file mode 100644
> index 0000000..04d8812
> --- /dev/null
> +++ b/drivers/media/video/mt9p031.c

[snip]


> @@ -0,0 +1,841 @@
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

This header is not needed anymore.

> +#include <media/v4l2-subdev.h>
> +#include <media/v4l2-device.h>
> +
> +#define MT9P031_PIXCLK_FREQ			54000000
> +
> +/* mt9p031 selected register addresses */
> +#define MT9P031_CHIP_VERSION			0x00
> +#define		MT9P031_CHIP_VERSION_VALUE	0x1801
> +#define MT9P031_ROW_START			0x01
> +#define		MT9P031_ROW_START_DEF		54
> +#define MT9P031_COLUMN_START			0x02
> +#define		MT9P031_COLUMN_START_DEF	16
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
> +#define MT9P031_RST				0x0d
> +#define		MT9P031_RST_ENABLE		1
> +#define		MT9P031_RST_DISABLE		0
> +#define MT9P031_READ_MODE_1			0x1e
> +#define MT9P031_READ_MODE_2			0x20
> +#define		MT9P031_READ_MODE_2_ROW_MIR	0x8000
> +#define		MT9P031_READ_MODE_2_COL_MIR	0x4000
> +#define MT9P031_ROW_ADDRESS_MODE		0x22
> +#define MT9P031_COLUMN_ADDRESS_MODE		0x23
> +#define MT9P031_GLOBAL_GAIN			0x35
> +
> +#define MT9P031_WINDOW_HEIGHT_MAX		1944
> +#define MT9P031_WINDOW_WIDTH_MAX		2592
> +#define MT9P031_WINDOW_HEIGHT_MIN		2
> +#define MT9P031_WINDOW_WIDTH_MIN		18

Can you move those 4 constants right below MT9P031_WINDOW_HEIGHT and 
MT9P031_WINDOW_WIDTH ? The max values are not correct, according to the 
datasheet they should be 2005 and 2751. You can define *_DEF constants for the 
default width and height.

> +struct mt9p031 {
> +	struct v4l2_subdev subdev;
> +	struct media_pad pad;
> +	struct v4l2_rect rect;	/* Sensor window */
> +	struct v4l2_mbus_framefmt format;
> +	struct mt9p031_platform_data *pdata;
> +	struct mutex power_lock; /* lock to protect power_count */
> +	int power_count;
> +	u16 xskip;
> +	u16 yskip;
> +	/* cache register values */
> +	u16 output_control;
> +	u16 h_blanking;
> +	u16 v_blanking;
> +	u16 column_address_mode;
> +	u16 row_address_mode;
> +	u16 column_start;
> +	u16 row_start;
> +	u16 window_width;
> +	u16 window_height;
> +	struct regulator *reg_1v8;
> +	struct regulator *reg_2v8;
> +};

[snip]

> +static int restore_registers(struct i2c_client *client)
> +{
> +	int ret;
> +	struct mt9p031 *mt9p031 = to_mt9p031(client);
> +
> +	/* Disable register update, reconfigure atomically */
> +	ret = mt9p031_set_output_control(mt9p031, 0,
> +					MT9P031_OUTPUT_CONTROL_SYN);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* Blanking and start values - default... */
> +	ret = reg_write(client, MT9P031_H_BLANKING, mt9p031->h_blanking);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = reg_write(client, MT9P031_V_BLANKING, mt9p031->v_blanking);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = reg_write(client, MT9P031_COLUMN_ADDRESS_MODE,
> +				mt9p031->column_address_mode);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = reg_write(client, MT9P031_ROW_ADDRESS_MODE,
> +				mt9p031->row_address_mode);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = reg_write(client, MT9P031_COLUMN_START,
> +				mt9p031->column_start);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = reg_write(client, MT9P031_ROW_START,
> +				mt9p031->row_start);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = reg_write(client, MT9P031_WINDOW_WIDTH,
> +				mt9p031->window_width);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = reg_write(client, MT9P031_WINDOW_HEIGHT,
> +				mt9p031->window_height);
> +	if (ret < 0)
> +		return ret;

All those registers will be written to in mt9p031_s_stream(), there's no need 
to restore them when powering the chip up. You can remove this function 
completely, as well as the register cache.

> +	/* Re-enable register update, commit all changes */
> +	ret = mt9p031_set_output_control(mt9p031,
> +					MT9P031_OUTPUT_CONTROL_SYN, 0);
> +	if (ret < 0)
> +		return ret;
> +	return 0;
> +}

[snip]

> +static int mt9p031_power_on(struct mt9p031 *mt9p031)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&mt9p031->subdev);
> +	int ret;
> +
> +	/* Ensure RESET_BAR is low */
> +	if (mt9p031->pdata->reset)
> +		mt9p031->pdata->reset(&mt9p031->subdev, 1);
> +	/* turn on digital supply first */
> +	ret = regulator_enable(mt9p031->reg_1v8);
> +	if (ret) {
> +		dev_err(&client->dev,
> +			"Failed to enable 1.8v regulator: %d\n", ret);
> +		goto err_1v8;

You can return ret immediately.

> +	}

According to the datasheet (see figure 31) you need a delay of minimum 1ms 
here. regulator_enable() probably doesn't wait for the power to stabilize 
before returning (correct me if I'm wrong), so a slightly longer delay would 
be safer.

> +	/* now turn on analog supply */
> +	ret = regulator_enable(mt9p031->reg_2v8);
> +	if (ret) {
> +		dev_err(&client->dev,
> +			"Failed to enable 2.8v regulator: %d\n", ret);
> +		goto err_rst;
> +	}
>
> +	/* Now RESET_BAR must be high */
> +	if (mt9p031->pdata->reset)

Similarly, you need to wait for the 2.8V power supply to stabilize before de-
asserting the reset signal. A short delay is probably required. You can put it 
inside the 'if', as the delay is not needed if the reset signal can't be 
controlled.

> +		mt9p031->pdata->reset(&mt9p031->subdev, 0);
> +
> +	if (mt9p031->pdata->set_xclk)
> +		mt9p031->pdata->set_xclk(&mt9p031->subdev, MT9P031_PIXCLK_FREQ);
> +
> +	/* soft reset */
> +	ret = mt9p031_reset(client);
> +	if (ret < 0) {
> +		dev_err(&client->dev, "Failed to reset the camera\n");
> +		goto err_rst;
> +	}
> +
> +	ret = restore_registers(client);
> +	if (ret < 0) {
> +		dev_err(&client->dev, "Failed to restore registers\n");
> +		goto err_rst;
> +	}
> +
> +	return 0;
> +err_rst:
> +	regulator_disable(mt9p031->reg_1v8);

You should disable both regulators here, and only the 1.8V regulator if 
enabling the 2.8V regulator fails.

> +err_1v8:
> +	return ret;
> +
> +}

[snip]

> +static int mt9p031_set_power(struct v4l2_subdev *sd, int on)
> +{
> +	struct mt9p031 *mt9p031 = container_of(sd, struct mt9p031, subdev);
> +	int ret = 0;
> +
> +	mutex_lock(&mt9p031->power_lock);
> +
> +	/*
> +	 * If the power count is modified from 0 to != 0 or from != 0 to 0,
> +	 * update the power state.
> +	 */
> +	if (mt9p031->power_count == !on) {
> +		if (on) {
> +			ret = mt9p031_power_on(mt9p031);
> +			if (ret) {
> +				dev_err(mt9p031->subdev.v4l2_dev->dev,
> +				"Failed to enable 2.8v regulator: %d\n", ret);

This message isn't correct anymore, as mt9p031_power_on() now handles two 
regulators. As mt9p031_power_on() already prints an error message in the case 
of failure, you can remove this message.

> +				goto out;
> +			}
> +		} else {
> +			mt9p031_power_off(mt9p031);
> +		}
> +	}
> +
> +	/* Update the power count. */
> +	mt9p031->power_count += on ? 1 : -1;
> +	WARN_ON(mt9p031->power_count < 0);
> +
> +out:
> +	mutex_unlock(&mt9p031->power_lock);
> +	return ret;
> +}
> +
> +static int mt9p031_registered(struct v4l2_subdev *sd)
> +{
> +	struct mt9p031 *mt9p031 = container_of(sd, struct mt9p031, subdev);
> +	struct i2c_client *client = v4l2_get_subdevdata(&mt9p031->subdev);
> +	int ret;
> +
> +	ret = mt9p031_set_power(&mt9p031->subdev, 1);
> +	if (ret) {
> +		dev_err(&client->dev,
> +			"Failed to power on device: %d\n", ret);
> +		goto err_pwron;

You can return ret directly.

> +	}
> +
> +	ret = mt9p031_video_probe(client);
> +	if (ret)
> +		goto err_evprobe;
> +

Code from here

> +	mt9p031->pad.flags = MEDIA_PAD_FL_SOURCE;
> +	ret = media_entity_init(&mt9p031->subdev.entity, 1, &mt9p031->pad, 0);
> +	if (ret)
> +		goto err_evprobe;
> +
> +	mt9p031->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;

to here can be moved to the probe() function, it will simplify 
mt9p031_registered(). The function will become so small that you can directly 
inline mt9p031_video_probe() inside it.

> +	mt9p031_set_power(&mt9p031->subdev, 0);
> +
> +	return 0;
> +err_evprobe:
> +	mt9p031_set_power(&mt9p031->subdev, 0);
> +err_pwron:
> +	return ret;
> +}

-- 
Regards,

Laurent Pinchart
