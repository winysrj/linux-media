Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:57805 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab3CWOs7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Mar 2013 10:48:59 -0400
Message-ID: <514DC0D7.8080401@gmail.com>
Date: Sat, 23 Mar 2013 15:48:55 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Arun Kumar K <arun.kk@samsung.com>
CC: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org, s.nawrocki@samsung.com,
	kgene.kim@samsung.com, kilyeon.im@samsung.com,
	arunkk.samsung@gmail.com
Subject: Re: [RFC 06/12] exynos-fimc-is: Adds the sensor subdev
References: <1362754765-2651-1-git-send-email-arun.kk@samsung.com> <1362754765-2651-7-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1362754765-2651-7-git-send-email-arun.kk@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/08/2013 03:59 PM, Arun Kumar K wrote:
> FIMC-IS uses certain sensors which are exclusively controlled
> from the IS firmware. This patch adds the sensor subdev for the
> fimc-is sensors.
>
> Signed-off-by: Arun Kumar K<arun.kk@samsung.com>
> Signed-off-by: Kilyeon Im<kilyeon.im@samsung.com>
> ---
>   drivers/media/platform/exynos5-is/fimc-is-sensor.c |  337 ++++++++++++++++++++
>   drivers/media/platform/exynos5-is/fimc-is-sensor.h |  170 ++++++++++
>   2 files changed, 507 insertions(+)
>   create mode 100644 drivers/media/platform/exynos5-is/fimc-is-sensor.c
>   create mode 100644 drivers/media/platform/exynos5-is/fimc-is-sensor.h
>
> diff --git a/drivers/media/platform/exynos5-is/fimc-is-sensor.c b/drivers/media/platform/exynos5-is/fimc-is-sensor.c
> new file mode 100644
> index 0000000..c031493
> --- /dev/null
> +++ b/drivers/media/platform/exynos5-is/fimc-is-sensor.c
> @@ -0,0 +1,337 @@
> +/*
> + * Samsung EXYNOS5250 FIMC-IS (Imaging Subsystem) driver
> + *
> + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
> + * Arun Kumar K<arun.kk@samsung.com>
> + * Kil-yeon Lim<kilyeon.im@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include<linux/gpio.h>
> +#include "fimc-is-sensor.h"
> +#include "fimc-is.h"
> +
> +static char *sensor_clock_name[] = {
> +	[SCLK_BAYER]	= "sclk_bayer",
> +	[SCLK_CAM0]	= "sclk_cam0",

Aren't there any dependencies on other IP state for this clock ?
For example up to Exynos4412 "fimc" clocks needs to be enabled
to actually enable SCLK_CAM clocks through "sclk_cam0" and the
CAM power domain needs to be enabled.

> +/* Sensor supported formats */
> +static struct v4l2_mbus_framefmt sensor_formats[FIMC_IS_MAX_SENSORS] = {
> +	[SENSOR_S5K4E5] = {
> +		.width          = SENSOR_4E5_WIDTH + 16,
> +		.height         = SENSOR_4E5_HEIGHT + 10,
> +		.code           = V4L2_MBUS_FMT_SGRBG10_1X10,
> +		.field          = V4L2_FIELD_NONE,
> +		.colorspace     = V4L2_COLORSPACE_SRGB,
> +	},
> +	[SENSOR_S5K6A3] = {
> +		.width          = SENSOR_6A3_WIDTH + 16,
> +		.height         = SENSOR_6A3_HEIGHT + 10,
> +		.code           = V4L2_MBUS_FMT_SGRBG10_1X10,
> +		.field          = V4L2_FIELD_NONE,
> +		.colorspace     = V4L2_COLORSPACE_SRGB,
> +	},
> +};
> +
> +static struct fimc_is_sensor *sd_to_fimc_is_sensor(struct v4l2_subdev *sd)
> +{
> +	return container_of(sd, struct fimc_is_sensor, subdev);
> +}
> +
> +static void sensor_clk_put(struct fimc_is_sensor *sensor)
> +{
> +	int i;
> +
> +	for (i = 0; i<  SCLK_MAX_NUM; i++) {
> +		if (IS_ERR_OR_NULL(sensor->clock[i]))

Please try to eliminate this IS_ERR_OR_NULL() usage, e.g. by filling
clock[] array with ERR_PTR(-EINVAL) at the very beginning of the driver's
initialization process.

> +			continue;
> +		clk_unprepare(sensor->clock[i]);
> +		clk_put(sensor->clock[i]);
> +		sensor->clock[i] = NULL;

		sensor->clock[i] = ERR_PTR(-EINVAL);

> +	}
> +}
> +
> +static int sensor_clk_init(struct fimc_is_sensor *sensor)
> +{
> +	int i, ret;
> +
> +	/* Get CAM clocks */
> +	for (i = 0; i<  SCLK_MAX_NUM; i++) {
> +		sensor->clock[i] = clk_get(NULL, sensor_clock_name[i]);
> +		if (IS_ERR(sensor->clock[i]))
> +			goto err;
> +		ret = clk_prepare(sensor->clock[i]);
> +		if (ret<  0) {
> +			clk_put(sensor->clock[i]);
> +			sensor->clock[i] = NULL;

			sensor->clock[i] = ERR_PTR(-EINVAL);

> +			goto err;
> +		}
> +	}
> +
> +	/* Set clock rates */
> +	ret = clk_set_rate(sensor->clock[SCLK_CAM0], 24 * 1000000);
> +	ret |= clk_set_rate(sensor->clock[SCLK_BAYER], 24 * 1000000);
> +	if (ret) {
> +		is_err("Failed to set cam clock rates\n");
> +		goto err;
> +	}
> +	return 0;
> +err:
> +	sensor_clk_put(sensor);
> +	is_err("Failed to init sensor clock\n");
> +	return -ENXIO;
> +}
> +
> +static int sensor_enum_mbus_code(struct v4l2_subdev *sd,
> +				  struct v4l2_subdev_fh *fh,
> +				  struct v4l2_subdev_mbus_code_enum *code)
> +{
> +	struct fimc_is_sensor *sensor = sd_to_fimc_is_sensor(sd);
> +	struct fimc_is_sensor_info *sinfo = sensor->sensor_info;
> +
> +	if (!code)
> +		return -EINVAL;
> +
> +	code->code = sensor_formats[sinfo->sensor_id].code;
> +	return 0;
> +}
> +
> +static int sensor_set_fmt(struct v4l2_subdev *sd,
> +			  struct v4l2_subdev_fh *fh,
> +			  struct v4l2_subdev_format *fmt)
> +{
> +	struct fimc_is_sensor *sensor = sd_to_fimc_is_sensor(sd);
> +	struct fimc_is_sensor_info *sinfo = sensor->sensor_info;
> +	struct v4l2_mbus_framefmt *sfmt =&fmt->format;
> +
> +	if ((sfmt->width != sensor_formats[sinfo->sensor_id].width) ||
> +		(sfmt->height != sensor_formats[sinfo->sensor_id].height) ||
> +		(sfmt->code != sensor_formats[sinfo->sensor_id].code))
> +		return -EINVAL;

No, the driver should not return any errors here. Instead it should
adjust passed frame format to its capabilities. So it should be more
something like:

	*sfmt = sensor_formats[sinfo->sensor_id];

But even now it is not optimal, it would be useful to be able to
set various resolutions at the sensor subdev, within supported range.
Anyway I'm fine with have it fixed temporarily. It all depends
on the firmware though, what sort of configuration is supported there.

> +	return 0;
> +}
> +
> +static int sensor_get_fmt(struct v4l2_subdev *sd,
> +			  struct v4l2_subdev_fh *fh,
> +			  struct v4l2_subdev_format *fmt)
> +{
> +	struct fimc_is_sensor *sensor = sd_to_fimc_is_sensor(sd);
> +	struct fimc_is_sensor_info *sinfo = sensor->sensor_info;
> +
> +	fmt->format = sensor_formats[sinfo->sensor_id];
> +	return 0;
> +}
> +
> +static struct v4l2_subdev_pad_ops sensor_pad_ops = {
> +	.enum_mbus_code		= sensor_enum_mbus_code,
> +	.get_fmt		= sensor_get_fmt,
> +	.set_fmt		= sensor_set_fmt,
> +};
> +
> +static int sensor_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
> +{
> +	return 0;

You should fill the TRY format data structure here, which is stored in fh.

> +}
> +
> +static const struct v4l2_subdev_internal_ops sensor_sd_internal_ops = {
> +	.open = sensor_open,
> +};
> +
> +static int sensor_s_power(struct v4l2_subdev *sd, int on)
> +{
> +	struct fimc_is_sensor *sensor = sd_to_fimc_is_sensor(sd);
> +	struct fimc_is_sensor_data *sdata = sensor->sensor_data;
> +
> +	if (on) {
> +		/* Power on sensor */
> +		sensor_clk_init(sensor);

Clocks should be initialized once. And here we only enable/disable them.

> +		gpio_request(sdata->gpios[0], "fimc_is_sensor");
> +		gpio_direction_output(sdata->gpios[0], 1);
> +		gpio_free(sdata->gpios[0]);

Similar mistake with the GPIO. Why don't you request GPIO in probe/remove
functions ?

And why gpio_direction_output() is used to set state of an GPIO output ?
Are there some political reasons for which you choose to not use
gpio_set_value() ?

> +	} else {
> +		/* Power off sensor */
> +		gpio_request(sdata->gpios[0], "fimc_is_sensor");
> +		gpio_direction_output(sdata->gpios[0], 0);
> +		gpio_free(sdata->gpios[0]);
> +		sensor_clk_put(sensor);
> +	}
> +	return 0;
> +}
> +
> +static struct v4l2_subdev_core_ops sensor_core_ops = {
> +	.s_power = sensor_s_power,
> +};
> +
> +static int sensor_s_stream(struct v4l2_subdev *sd, int enable)
> +{
> +	struct fimc_is_sensor *sensor = sd_to_fimc_is_sensor(sd);
> +	int ret;
> +
> +	if (enable) {
> +		is_dbg(3, "Stream ON\n");
> +		/* Open pipeline */
> +		ret = fimc_is_pipeline_open(sensor->pipeline, sensor);
> +		if (ret<  0) {
> +			is_err("Pipeline already opened.\n");
> +			return -EBUSY;
> +		}
> +
> +		/* Start IS pipeline */
> +		ret = fimc_is_pipeline_start(sensor->pipeline);
> +		if (ret<  0) {
> +			is_err("Pipeline start failed.\n");
> +			return -EINVAL;
> +		}

Hmm, because of those 2 pipelines dependent on each other :

sensor -> mipi-csis -> fimc-lite -> memory

memory -> is-isp -> scalerx -> memory

You need to initiate streaming from sensor driver level ? Normally this
is managed by /dev/video driver. I guess, it wouldn't work in your case ?

> +	} else {
> +		is_dbg(3, "Stream OFF\n");
> +		/* Stop IS pipeline */
> +		ret = fimc_is_pipeline_stop(sensor->pipeline);
> +		if (ret<  0) {
> +			is_err("Pipeline stop failed.\n");
> +			return -EINVAL;
> +		}
> +
> +		/* Close pipeline */
> +		ret = fimc_is_pipeline_close(sensor->pipeline);
> +		if (ret<  0) {
> +			is_err("Pipeline close failed\n");
> +			return -EBUSY;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_subdev_video_ops sensor_video_ops = {
> +	.s_stream       = sensor_s_stream,
> +};
> +
> +static struct v4l2_subdev_ops sensor_subdev_ops = {
> +	.core =&sensor_core_ops,
> +	.pad =&sensor_pad_ops,
> +	.video =&sensor_video_ops,
> +};
> +
> +static int sensor_init(struct fimc_is_sensor *sensor)
> +{
> +	struct fimc_is_sensor_data *sensor_data;
> +
> +	sensor_data = sensor->sensor_data;
> +	if (strcmp(sensor_data->name,
> +			sensor_info[SENSOR_S5K4E5].sensor_name) == 0)
> +		sensor->sensor_info =&sensor_info[SENSOR_S5K4E5];
> +	else if (strcmp(sensor_data->name,
> +			sensor_info[SENSOR_S5K6A3].sensor_name) == 0)
> +		sensor->sensor_info =&sensor_info[SENSOR_S5K6A3];
> +	else
> +		sensor->sensor_info = NULL;

I think such matching would better done through 'compatible' property.

> +	if (!sensor->sensor_info)
> +		return -EINVAL;
> +
> +	sensor->sensor_info->csi_ch = sensor->sensor_info->i2c_ch =
> +		(sensor_data->csi_id>>  2)&  0x1;
> +	is_dbg(3, "Sensor csi channel : %d\n", sensor->sensor_info->csi_ch);
> +
> +	return 0;
> +}
> +
> +int fimc_is_sensor_subdev_create(struct fimc_is_sensor *sensor,
> +		struct fimc_is_sensor_data *sensor_data,
> +		struct fimc_is_pipeline *pipeline)
> +{
> +	struct v4l2_subdev *sd =&sensor->subdev;
> +	int ret;
> +
> +	is_err("\n");

Might be some debugging leftover. I would also suggest to avoid
custom driver-specific debug macros.

> +	if (!sensor_data->enabled) {
> +		/* Sensor not present */
> +		return -EINVAL;
> +	}
> +
> +	sensor->sensor_data = sensor_data;
> +	sensor->pipeline = pipeline;
> +
> +	v4l2_subdev_init(sd,&sensor_subdev_ops);
> +	sensor->subdev.owner = THIS_MODULE;
> +	if (strcmp(sensor_data->name,
> +			sensor_info[SENSOR_S5K4E5].sensor_name) == 0)
> +		strlcpy(sd->name, "fimc-is-sensor-4e5", sizeof(sd->name));
> +	else if (strcmp(sensor_data->name,
> +			sensor_info[SENSOR_S5K6A3].sensor_name) == 0)
> +		strlcpy(sd->name, "fimc-is-sensor-6a3", sizeof(sd->name));
> +	else
> +		strlcpy(sd->name, "fimc-is-sensor-???", sizeof(sd->name));
> +	sensor->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> +	sensor->pad.flags = MEDIA_PAD_FL_SOURCE;
> +	ret = media_entity_init(&sd->entity, 1,&sensor->pad, 0);
> +	if (ret<  0)
> +		goto exit;
> +
> +	v4l2_set_subdevdata(sd, sensor);
> +
> +	/* Init sensor data */
> +	ret = sensor_init(sensor);
> +	if (ret<  0) {
> +		is_err("Sensor init failed.\n");
> +		goto exit;

Just drop this goto...

> +	}
> +
> +	return 0;

	return ret;

> +exit:
> +	return ret;

And remove these 2 lines.
