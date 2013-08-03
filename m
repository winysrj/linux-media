Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:64013 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696Ab3HCVsw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Aug 2013 17:48:52 -0400
Message-ID: <51FD7AC0.3040000@gmail.com>
Date: Sat, 03 Aug 2013 23:48:48 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Arun Kumar K <arun.kk@samsung.com>
CC: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree@vger.kernel.org, s.nawrocki@samsung.com,
	hverkuil@xs4all.nl, a.hajda@samsung.com, sachin.kamat@linaro.org,
	shaik.ameer@samsung.com, kilyeon.im@samsung.com,
	arunkk.samsung@gmail.com
Subject: Re: [RFC v3 08/13] [media] exynos5-fimc-is: Add sensor interface
References: <1375455762-22071-1-git-send-email-arun.kk@samsung.com> <1375455762-22071-9-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1375455762-22071-9-git-send-email-arun.kk@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/02/2013 05:02 PM, Arun Kumar K wrote:
> Some sensors to be used with fimc-is are exclusively controlled
> by the fimc-is firmware. This minimal sensor driver provides
> the required info for the firmware to configure the sensors
> sitting on I2C bus.
>
> Signed-off-by: Arun Kumar K<arun.kk@samsung.com>
> ---
>   drivers/media/platform/exynos5-is/fimc-is-sensor.c |   46 +++++++++++++
>   drivers/media/platform/exynos5-is/fimc-is-sensor.h |   69 ++++++++++++++++++++
>   2 files changed, 115 insertions(+)
>   create mode 100644 drivers/media/platform/exynos5-is/fimc-is-sensor.c
>   create mode 100644 drivers/media/platform/exynos5-is/fimc-is-sensor.h
>
> diff --git a/drivers/media/platform/exynos5-is/fimc-is-sensor.c b/drivers/media/platform/exynos5-is/fimc-is-sensor.c
> new file mode 100644
> index 0000000..3e4aae9
> --- /dev/null
> +++ b/drivers/media/platform/exynos5-is/fimc-is-sensor.c
> @@ -0,0 +1,46 @@
> +/*
> + * Samsung EXYNOS5250 FIMC-IS (Imaging Subsystem) driver
> + *
> + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
> + * Authors:  Sylwester Nawrocki<s.nawrocki@samsung.com>
> + *           Arun Kumar K<arun.kk@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include "fimc-is-sensor.h"
> +
> +static const struct sensor_drv_data s5k6a3_drvdata = {
> +	.id		= FIMC_IS_SENSOR_ID_S5K6A3,
> +	.open_timeout	= S5K6A3_OPEN_TIMEOUT,
> +	.setfile_name	= "setfile_6a3.bin",
> +};
> +
> +static const struct sensor_drv_data s5k4e5_drvdata = {
> +	.id		= FIMC_IS_SENSOR_ID_S5K4E5,
> +	.open_timeout	= S5K4E5_OPEN_TIMEOUT,
> +	.setfile_name	= "setfile_4e5.bin",
> +};
> +
> +static const struct of_device_id fimc_is_sensor_of_ids[] = {
> +	{
> +		.compatible	= "samsung,s5k6a3",
> +		.data		=&s5k6a3_drvdata,
> +	},
> +	{
> +		.compatible	= "samsung,s5k4e5",
> +		.data		=&s5k4e5_drvdata,
> +	},
> +	{  }
> +};
> +
> +const struct sensor_drv_data *exynos5_is_sensor_get_drvdata(
> +			struct device_node *node)
> +{
> +	const struct of_device_id *of_id;
> +
> +	of_id = of_match_node(fimc_is_sensor_of_ids, node);
> +	return of_id ? of_id->data : NULL;
> +}
> diff --git a/drivers/media/platform/exynos5-is/fimc-is-sensor.h b/drivers/media/platform/exynos5-is/fimc-is-sensor.h
> new file mode 100644
> index 0000000..51e18ea
> --- /dev/null
> +++ b/drivers/media/platform/exynos5-is/fimc-is-sensor.h
> @@ -0,0 +1,69 @@
> +/*
> + * Samsung EXYNOS4x12 FIMC-IS (Imaging Subsystem) driver
> + *
> + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
> + *
> + * Authors:  Sylwester Nawrocki<s.nawrocki@samsung.com>
> + *	     Younghwan Joo<yhwan.joo@samsung.com>
> + *	     Arun Kumar K<arun.kk@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +#ifndef FIMC_IS_SENSOR_H_
> +#define FIMC_IS_SENSOR_H_
> +
> +#include<linux/of.h>
> +#include<linux/types.h>
> +
> +#define S5K6A3_OPEN_TIMEOUT		2000 /* ms */
> +#define S5K6A3_SENSOR_WIDTH		1392
> +#define S5K6A3_SENSOR_HEIGHT		1392
> +
> +#define S5K4E5_OPEN_TIMEOUT		2000 /* ms */
> +#define S5K4E5_SENSOR_WIDTH		2560
> +#define S5K4E5_SENSOR_HEIGHT		1920
> +
> +#define SENSOR_WIDTH_PADDING		16
> +#define SENSOR_HEIGHT_PADDING		10
> +
> +enum fimc_is_sensor_id {
> +	FIMC_IS_SENSOR_ID_S5K3H2 = 1,
> +	FIMC_IS_SENSOR_ID_S5K6A3,
> +	FIMC_IS_SENSOR_ID_S5K4E5,
> +	FIMC_IS_SENSOR_ID_S5K3H7,
> +	FIMC_IS_SENSOR_ID_CUSTOM,
> +	FIMC_IS_SENSOR_ID_END
> +};
> +
> +#define IS_SENSOR_CTRL_BUS_I2C0		0
> +#define IS_SENSOR_CTRL_BUS_I2C1		1

Are these two constants used anywhere ?

> +struct sensor_drv_data {
> +	enum fimc_is_sensor_id id;
> +	/* sensor open timeout in ms */
> +	unsigned short open_timeout;
> +	char *setfile_name;
> +};
> +
> +/**
> + * struct fimc_is_sensor - fimc-is sensor data structure
> + * @drvdata: a pointer to the sensor's parameters data structure
> + * @i2c_bus: ISP I2C bus index (0...1)
> + * @test_pattern: true to enable video test pattern
> + */
> +struct fimc_is_sensor {
> +	const struct sensor_drv_data *drvdata;
> +	unsigned int i2c_bus;

> +	unsigned int width;
> +	unsigned int height;
> +	unsigned int pixel_width;
> +	unsigned int pixel_height;

What is difference between width/height and pixel_width/pixel_height ?
Would be good to add some documentation for these fields.

> +	u8 test_pattern;
> +};
> +
> +const struct sensor_drv_data *exynos5_is_sensor_get_drvdata(
> +			struct device_node *node);
> +
> +#endif /* FIMC_IS_SENSOR_H_ */

Thanks,
Sylwester
