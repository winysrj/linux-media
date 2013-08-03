Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:37227 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586Ab3HCVtY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Aug 2013 17:49:24 -0400
Message-ID: <51FD7AE0.7010608@gmail.com>
Date: Sat, 03 Aug 2013 23:49:20 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Arun Kumar K <arun.kk@samsung.com>
CC: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree@vger.kernel.org, s.nawrocki@samsung.com,
	hverkuil@xs4all.nl, a.hajda@samsung.com, sachin.kamat@linaro.org,
	shaik.ameer@samsung.com, kilyeon.im@samsung.com,
	arunkk.samsung@gmail.com
Subject: Re: [RFC v3 13/13] V4L: Add driver for s5k4e5 image sensor
References: <1375455762-22071-1-git-send-email-arun.kk@samsung.com> <1375455762-22071-14-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1375455762-22071-14-git-send-email-arun.kk@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/02/2013 05:02 PM, Arun Kumar K wrote:
> This patch adds subdev driver for Samsung S5K4E5 raw image sensor.
> Like s5k6a3, it is also another fimc-is firmware controlled
> sensor. This minimal sensor driver doesn't do any I2C communications
> as its done by ISP firmware. It can be updated if needed to a
> regular sensor driver by adding the I2C communication.
>
> Signed-off-by: Arun Kumar K<arun.kk@samsung.com>
> ---
>   drivers/media/i2c/Kconfig  |    8 +
>   drivers/media/i2c/Makefile |    1 +
>   drivers/media/i2c/s5k4e5.c |  362 ++++++++++++++++++++++++++++++++++++++++++++

Hmm, we also need the device tree binding documentation file.

>   3 files changed, 371 insertions(+)
>   create mode 100644 drivers/media/i2c/s5k4e5.c
[...]
> new file mode 100644
> index 0000000..a713c6a
> --- /dev/null
> +++ b/drivers/media/i2c/s5k4e5.c
> @@ -0,0 +1,362 @@
> +/*
> + * Samsung S5K4E5 image sensor driver
> + *
> + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
> + * Author: Arun Kumar K<arun.kk@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include<linux/clk.h>
> +#include<linux/delay.h>
> +#include<linux/device.h>
> +#include<linux/errno.h>
> +#include<linux/gpio.h>
> +#include<linux/i2c.h>
> +#include<linux/kernel.h>
> +#include<linux/module.h>
> +#include<linux/of_gpio.h>
> +#include<linux/pm_runtime.h>
> +#include<linux/regulator/consumer.h>
> +#include<linux/slab.h>
> +#include<linux/videodev2.h>
> +#include<media/v4l2-async.h>
> +#include<media/v4l2-subdev.h>
> +
> +#define S5K4E5_SENSOR_MAX_WIDTH		2560
> +#define S5K4E5_SENSOR_MAX_HEIGHT	1920
> +#define S5K4E5_SENSOR_MIN_WIDTH		32
> +#define S5K4E5_SENSOR_MIN_HEIGHT	32
> +
> +#define S5K4E5_WIDTH_PADDING		16
> +#define S5K4E5_HEIGHT_PADDING		10
> +
> +#define S5K4E5_DEF_PIX_WIDTH		1296
> +#define S5K4E5_DEF_PIX_HEIGHT		732

Please see my comments to patch 12/13 WRT to these defines.

> +#define S5K4E5_DRV_NAME			"S5K4E5"
> +#define S5K4E5_CLK_NAME			"mclk"
> +
> +#define S5K4E5_NUM_SUPPLIES		2
> +
> +/**
> + * struct s5k4e5 - fimc-is sensor data structure

s/fimc-is/s5k4e5 ?

> + * @dev: pointer to this I2C client device structure
> + * @subdev: the image sensor's v4l2 subdev
> + * @pad: subdev media source pad
> + * @supplies: image sensor's voltage regulator supplies
> + * @gpio_reset: GPIO connected to the sensor's reset pin
> + * @lock: mutex protecting the structure's members below
> + * @format: media bus format at the sensor's source pad
> + */
> +struct s5k4e5 {
> +	struct device *dev;
> +	struct v4l2_subdev subdev;
> +	struct media_pad pad;
> +	struct regulator_bulk_data supplies[S5K4E5_NUM_SUPPLIES];
> +	int gpio_reset;
> +	struct mutex lock;
> +	struct v4l2_mbus_framefmt format;
> +	struct clk *clock;
> +	u32 clock_frequency;
> +};
> +
> +static const char * const s5k4e5_supply_names[] = {
> +	"svdda",
> +	"svddio"
> +};
[...]
> +static int s5k4e5_probe(struct i2c_client *client,
> +				const struct i2c_device_id *id)
> +{
> +	struct device *dev =&client->dev;
> +	struct s5k4e5 *sensor;
> +	struct v4l2_subdev *sd;
> +	int gpio, i, ret;
> +
> +	sensor = devm_kzalloc(dev, sizeof(*sensor), GFP_KERNEL);
> +	if (!sensor)
> +		return -ENOMEM;
> +
> +	mutex_init(&sensor->lock);
> +	sensor->gpio_reset = -EINVAL;
> +	sensor->clock = ERR_PTR(-EINVAL);
> +	sensor->dev = dev;
> +
> +	gpio = of_get_gpio_flags(dev->of_node, 0, NULL);
> +	if (gpio_is_valid(gpio)) {
> +		ret = devm_gpio_request_one(dev, gpio, GPIOF_OUT_INIT_LOW,
> +							S5K4E5_DRV_NAME);
> +		if (ret<  0)
> +			return ret;
> +	}
> +	sensor->gpio_reset = gpio;
> +
> +	if (of_property_read_u32(dev->of_node, "clock-frequency",
> +				&sensor->clock_frequency)) {
> +		dev_err(dev, "clock-frequency property not found at %s\n",
> +						dev->of_node->full_name);
> +		return -EINVAL;

I would make "clock-frequency" property optional and instead of returning
error use some default frequency value when this property is not specified
in DT. This also need to be put into the DT binding document.

> +	}
> +
> +	for (i = 0; i<  S5K4E5_NUM_SUPPLIES; i++)
> +		sensor->supplies[i].supply = s5k4e5_supply_names[i];
> +
> +	ret = devm_regulator_bulk_get(&client->dev, S5K4E5_NUM_SUPPLIES,
> +				      sensor->supplies);
> +	if (ret<  0)
> +		return ret;
> +
> +	/* Defer probing if the clock is not available yet */
> +	sensor->clock = clk_get(dev, S5K4E5_CLK_NAME);
> +	if (IS_ERR(sensor->clock))
> +		return -EPROBE_DEFER;
> +
> +	sd =&sensor->subdev;
> +	v4l2_i2c_subdev_init(sd, client,&s5k4e5_subdev_ops);
> +	snprintf(sd->name, sizeof(sd->name), S5K4E5_DRV_NAME);

Unfortunately this line needs to be removed, the subdev name should
be unique and should have I2C bus number and I2C slave address appended
to it. It's already being done in v4l2_i2c_subdev_init() function.

	snprintf(sd->name, sizeof(sd->name), "%s %d-%04x",
		client->driver->driver.name, i2c_adapter_id(client->adapter),
		client->addr);

I've also dropped such overriding for the s5k6a3 sensor.

> +	sensor->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> +
> +	sensor->format.code = s5k4e5_formats[0].code;
> +	sensor->format.width = S5K4E5_DEF_PIX_WIDTH;
> +	sensor->format.height = S5K4E5_DEF_PIX_HEIGHT;
> +
> +	sensor->pad.flags = MEDIA_PAD_FL_SOURCE;
> +	ret = media_entity_init(&sd->entity, 1,&sensor->pad, 0);
> +	if (ret<  0)
> +		return ret;
> +
> +	pm_runtime_no_callbacks(dev);
> +	pm_runtime_enable(dev);
> +
> +	ret = v4l2_async_register_subdev(sd);
> +
> +	/*
> +	 * Don't hold reference to the clock to avoid circular dependency
> +	 * between the subdev and the host driver, in case the host is
> +	 * a supplier of the clock.
> +	 * clk_get()/clk_put() will be called in s_power callback.
> +	 */
> +	clk_put(sensor->clock);
> +
> +	return ret;
> +}
[...]
> +static struct i2c_driver s5k4e5_driver = {
> +	.driver = {
> +		.of_match_table	= of_match_ptr(s5k4e5_of_match),
> +		.name		= S5K4E5_DRV_NAME,
> +		.owner		= THIS_MODULE,
> +	},
> +	.probe		= s5k4e5_probe,
> +	.remove		= s5k4e5_remove,
> +	.id_table	= s5k4e5_ids,
> +};

Otherwise looks good to me.

--
Regards,
Sylwester
