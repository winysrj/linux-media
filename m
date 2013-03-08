Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:8703 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932918Ab3CHOlD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Mar 2013 09:41:03 -0500
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org
Cc: s.nawrocki@samsung.com, kgene.kim@samsung.com,
	kilyeon.im@samsung.com, arunkk.samsung@gmail.com
Subject: [RFC 06/12] exynos-fimc-is: Adds the sensor subdev
Date: Fri, 08 Mar 2013 09:59:19 -0500
Message-id: <1362754765-2651-7-git-send-email-arun.kk@samsung.com>
In-reply-to: <1362754765-2651-1-git-send-email-arun.kk@samsung.com>
References: <1362754765-2651-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

FIMC-IS uses certain sensors which are exclusively controlled
from the IS firmware. This patch adds the sensor subdev for the
fimc-is sensors.

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
Signed-off-by: Kilyeon Im <kilyeon.im@samsung.com>
---
 drivers/media/platform/exynos5-is/fimc-is-sensor.c |  337 ++++++++++++++++++++
 drivers/media/platform/exynos5-is/fimc-is-sensor.h |  170 ++++++++++
 2 files changed, 507 insertions(+)
 create mode 100644 drivers/media/platform/exynos5-is/fimc-is-sensor.c
 create mode 100644 drivers/media/platform/exynos5-is/fimc-is-sensor.h

diff --git a/drivers/media/platform/exynos5-is/fimc-is-sensor.c b/drivers/media/platform/exynos5-is/fimc-is-sensor.c
new file mode 100644
index 0000000..c031493
--- /dev/null
+++ b/drivers/media/platform/exynos5-is/fimc-is-sensor.c
@@ -0,0 +1,337 @@
+/*
+ * Samsung EXYNOS5250 FIMC-IS (Imaging Subsystem) driver
+ *
+ * Copyright (C) 2013 Samsung Electronics Co., Ltd.
+ * Arun Kumar K <arun.kk@samsung.com>
+ * Kil-yeon Lim <kilyeon.im@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/gpio.h>
+#include "fimc-is-sensor.h"
+#include "fimc-is.h"
+
+static char *sensor_clock_name[] = {
+	[SCLK_BAYER]	= "sclk_bayer",
+	[SCLK_CAM0]	= "sclk_cam0",
+	[SCLK_CAM1]	= "sclk_cam1",
+};
+
+static struct fimc_is_sensor_info sensor_info[] = {
+	[SENSOR_S5K4E5] = {
+		.sensor_id = SENSOR_S5K4E5,
+		.sensor_name = "samsung,s5k4e5",
+		.pixel_width = SENSOR_4E5_WIDTH + 16,
+		.pixel_height = SENSOR_4E5_HEIGHT + 10,
+		.active_width = SENSOR_4E5_WIDTH,
+		.active_height = SENSOR_4E5_HEIGHT,
+		.max_framerate = 30,
+		.setfile_name = "setfile_4e5.bin",
+		.ext = {
+			.actuator_con = {
+				.product_name = ACTUATOR_NAME_DWXXXX,
+				.peri_type = SE_I2C,
+				.peri_setting.i2c.channel = SENSOR_CONTROL_I2C0,
+			},
+			.flash_con = {
+				.product_name = FLADRV_NAME_KTD267,
+				.peri_type = SE_GPIO,
+				.peri_setting.gpio.first_gpio_port_no = 1,
+				.peri_setting.gpio.second_gpio_port_no = 2,
+			},
+			.from_con.product_name = FROMDRV_NAME_NOTHING,
+			.mclk = 0,
+			.mipi_lane_num = 0,
+			.mipi_speed = 0,
+			.fast_open_sensor = 0,
+			.self_calibration_mode = 0,
+		},
+
+	},
+	[SENSOR_S5K6A3] = {
+		.sensor_id = SENSOR_S5K6A3,
+		.sensor_name = "samsung,s5k6a3",
+		.pixel_width = SENSOR_6A3_WIDTH + 16,
+		.pixel_height = SENSOR_6A3_HEIGHT + 10,
+		.active_width = SENSOR_6A3_WIDTH,
+		.active_height = SENSOR_6A3_HEIGHT,
+		.max_framerate = 30,
+		.setfile_name = "setfile_6a3.bin",
+	},
+};
+
+/* Sensor supported formats */
+static struct v4l2_mbus_framefmt sensor_formats[FIMC_IS_MAX_SENSORS] = {
+	[SENSOR_S5K4E5] = {
+		.width          = SENSOR_4E5_WIDTH + 16,
+		.height         = SENSOR_4E5_HEIGHT + 10,
+		.code           = V4L2_MBUS_FMT_SGRBG10_1X10,
+		.field          = V4L2_FIELD_NONE,
+		.colorspace     = V4L2_COLORSPACE_SRGB,
+	},
+	[SENSOR_S5K6A3] = {
+		.width          = SENSOR_6A3_WIDTH + 16,
+		.height         = SENSOR_6A3_HEIGHT + 10,
+		.code           = V4L2_MBUS_FMT_SGRBG10_1X10,
+		.field          = V4L2_FIELD_NONE,
+		.colorspace     = V4L2_COLORSPACE_SRGB,
+	},
+};
+
+static struct fimc_is_sensor *sd_to_fimc_is_sensor(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct fimc_is_sensor, subdev);
+}
+
+static void sensor_clk_put(struct fimc_is_sensor *sensor)
+{
+	int i;
+
+	for (i = 0; i < SCLK_MAX_NUM; i++) {
+		if (IS_ERR_OR_NULL(sensor->clock[i]))
+			continue;
+		clk_unprepare(sensor->clock[i]);
+		clk_put(sensor->clock[i]);
+		sensor->clock[i] = NULL;
+	}
+}
+
+static int sensor_clk_init(struct fimc_is_sensor *sensor)
+{
+	int i, ret;
+
+	/* Get CAM clocks */
+	for (i = 0; i < SCLK_MAX_NUM; i++) {
+		sensor->clock[i] = clk_get(NULL, sensor_clock_name[i]);
+		if (IS_ERR(sensor->clock[i]))
+			goto err;
+		ret = clk_prepare(sensor->clock[i]);
+		if (ret < 0) {
+			clk_put(sensor->clock[i]);
+			sensor->clock[i] = NULL;
+			goto err;
+		}
+	}
+
+	/* Set clock rates */
+	ret = clk_set_rate(sensor->clock[SCLK_CAM0], 24 * 1000000);
+	ret |= clk_set_rate(sensor->clock[SCLK_BAYER], 24 * 1000000);
+	if (ret) {
+		is_err("Failed to set cam clock rates\n");
+		goto err;
+	}
+	return 0;
+err:
+	sensor_clk_put(sensor);
+	is_err("Failed to init sensor clock\n");
+	return -ENXIO;
+}
+
+static int sensor_enum_mbus_code(struct v4l2_subdev *sd,
+				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_mbus_code_enum *code)
+{
+	struct fimc_is_sensor *sensor = sd_to_fimc_is_sensor(sd);
+	struct fimc_is_sensor_info *sinfo = sensor->sensor_info;
+
+	if (!code)
+		return -EINVAL;
+
+	code->code = sensor_formats[sinfo->sensor_id].code;
+	return 0;
+}
+
+static int sensor_set_fmt(struct v4l2_subdev *sd,
+			  struct v4l2_subdev_fh *fh,
+			  struct v4l2_subdev_format *fmt)
+{
+	struct fimc_is_sensor *sensor = sd_to_fimc_is_sensor(sd);
+	struct fimc_is_sensor_info *sinfo = sensor->sensor_info;
+	struct v4l2_mbus_framefmt *sfmt = &fmt->format;
+
+	if ((sfmt->width != sensor_formats[sinfo->sensor_id].width) ||
+		(sfmt->height != sensor_formats[sinfo->sensor_id].height) ||
+		(sfmt->code != sensor_formats[sinfo->sensor_id].code))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int sensor_get_fmt(struct v4l2_subdev *sd,
+			  struct v4l2_subdev_fh *fh,
+			  struct v4l2_subdev_format *fmt)
+{
+	struct fimc_is_sensor *sensor = sd_to_fimc_is_sensor(sd);
+	struct fimc_is_sensor_info *sinfo = sensor->sensor_info;
+
+	fmt->format = sensor_formats[sinfo->sensor_id];
+	return 0;
+}
+
+static struct v4l2_subdev_pad_ops sensor_pad_ops = {
+	.enum_mbus_code		= sensor_enum_mbus_code,
+	.get_fmt		= sensor_get_fmt,
+	.set_fmt		= sensor_set_fmt,
+};
+
+static int sensor_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+{
+	return 0;
+}
+
+static const struct v4l2_subdev_internal_ops sensor_sd_internal_ops = {
+	.open = sensor_open,
+};
+
+static int sensor_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct fimc_is_sensor *sensor = sd_to_fimc_is_sensor(sd);
+	struct fimc_is_sensor_data *sdata = sensor->sensor_data;
+
+	if (on) {
+		/* Power on sensor */
+		sensor_clk_init(sensor);
+		gpio_request(sdata->gpios[0], "fimc_is_sensor");
+		gpio_direction_output(sdata->gpios[0], 1);
+		gpio_free(sdata->gpios[0]);
+	} else {
+		/* Power off sensor */
+		gpio_request(sdata->gpios[0], "fimc_is_sensor");
+		gpio_direction_output(sdata->gpios[0], 0);
+		gpio_free(sdata->gpios[0]);
+		sensor_clk_put(sensor);
+	}
+	return 0;
+}
+
+static struct v4l2_subdev_core_ops sensor_core_ops = {
+	.s_power = sensor_s_power,
+};
+
+static int sensor_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct fimc_is_sensor *sensor = sd_to_fimc_is_sensor(sd);
+	int ret;
+
+	if (enable) {
+		is_dbg(3, "Stream ON\n");
+		/* Open pipeline */
+		ret = fimc_is_pipeline_open(sensor->pipeline, sensor);
+		if (ret < 0) {
+			is_err("Pipeline already opened.\n");
+			return -EBUSY;
+		}
+
+		/* Start IS pipeline */
+		ret = fimc_is_pipeline_start(sensor->pipeline);
+		if (ret < 0) {
+			is_err("Pipeline start failed.\n");
+			return -EINVAL;
+		}
+	} else {
+		is_dbg(3, "Stream OFF\n");
+		/* Stop IS pipeline */
+		ret = fimc_is_pipeline_stop(sensor->pipeline);
+		if (ret < 0) {
+			is_err("Pipeline stop failed.\n");
+			return -EINVAL;
+		}
+
+		/* Close pipeline */
+		ret = fimc_is_pipeline_close(sensor->pipeline);
+		if (ret < 0) {
+			is_err("Pipeline close failed\n");
+			return -EBUSY;
+		}
+	}
+
+	return 0;
+}
+
+static const struct v4l2_subdev_video_ops sensor_video_ops = {
+	.s_stream       = sensor_s_stream,
+};
+
+static struct v4l2_subdev_ops sensor_subdev_ops = {
+	.core = &sensor_core_ops,
+	.pad = &sensor_pad_ops,
+	.video = &sensor_video_ops,
+};
+
+static int sensor_init(struct fimc_is_sensor *sensor)
+{
+	struct fimc_is_sensor_data *sensor_data;
+
+	sensor_data = sensor->sensor_data;
+	if (strcmp(sensor_data->name,
+			sensor_info[SENSOR_S5K4E5].sensor_name) == 0)
+		sensor->sensor_info = &sensor_info[SENSOR_S5K4E5];
+	else if (strcmp(sensor_data->name,
+			sensor_info[SENSOR_S5K6A3].sensor_name) == 0)
+		sensor->sensor_info = &sensor_info[SENSOR_S5K6A3];
+	else
+		sensor->sensor_info = NULL;
+
+	if (!sensor->sensor_info)
+		return -EINVAL;
+
+	sensor->sensor_info->csi_ch = sensor->sensor_info->i2c_ch =
+		(sensor_data->csi_id >> 2) & 0x1;
+	is_dbg(3, "Sensor csi channel : %d\n", sensor->sensor_info->csi_ch);
+
+	return 0;
+}
+
+int fimc_is_sensor_subdev_create(struct fimc_is_sensor *sensor,
+		struct fimc_is_sensor_data *sensor_data,
+		struct fimc_is_pipeline *pipeline)
+{
+	struct v4l2_subdev *sd = &sensor->subdev;
+	int ret;
+
+	is_err("\n");
+	if (!sensor_data->enabled) {
+		/* Sensor not present */
+		return -EINVAL;
+	}
+
+	sensor->sensor_data = sensor_data;
+	sensor->pipeline = pipeline;
+
+	v4l2_subdev_init(sd, &sensor_subdev_ops);
+	sensor->subdev.owner = THIS_MODULE;
+	if (strcmp(sensor_data->name,
+			sensor_info[SENSOR_S5K4E5].sensor_name) == 0)
+		strlcpy(sd->name, "fimc-is-sensor-4e5", sizeof(sd->name));
+	else if (strcmp(sensor_data->name,
+			sensor_info[SENSOR_S5K6A3].sensor_name) == 0)
+		strlcpy(sd->name, "fimc-is-sensor-6a3", sizeof(sd->name));
+	else
+		strlcpy(sd->name, "fimc-is-sensor-???", sizeof(sd->name));
+	sensor->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	sensor->pad.flags = MEDIA_PAD_FL_SOURCE;
+	ret = media_entity_init(&sd->entity, 1, &sensor->pad, 0);
+	if (ret < 0)
+		goto exit;
+
+	v4l2_set_subdevdata(sd, sensor);
+
+	/* Init sensor data */
+	ret = sensor_init(sensor);
+	if (ret < 0) {
+		is_err("Sensor init failed.\n");
+		goto exit;
+	}
+
+	return 0;
+exit:
+	return ret;
+}
+
+void fimc_is_sensor_subdev_destroy(struct fimc_is_sensor *sensor)
+{
+	media_entity_cleanup(&sensor->subdev.entity);
+}
diff --git a/drivers/media/platform/exynos5-is/fimc-is-sensor.h b/drivers/media/platform/exynos5-is/fimc-is-sensor.h
new file mode 100644
index 0000000..d147ff8
--- /dev/null
+++ b/drivers/media/platform/exynos5-is/fimc-is-sensor.h
@@ -0,0 +1,170 @@
+/*
+ * Samsung EXYNOS5250 FIMC-IS (Imaging Subsystem) driver
+ *
+ * Copyright (C) 2013 Samsung Electronics Co., Ltd.
+ * Arun Kumar K <arun.kk@samsung.com>
+ * Kil-yeon Lim <kilyeon.im@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef FIMC_IS_SENSOR_H_
+#define FIMC_IS_SENSOR_H_
+
+#include <linux/clk.h>
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/consumer.h>
+#include <linux/videodev2.h>
+#include <media/v4l2-subdev.h>
+
+#include "fimc-is-pipeline.h"
+
+#define FIMC_IS_MAX_CAMIF_CLIENTS	2
+#define FIMC_IS_MAX_NAME_LEN		32
+#define FIMC_IS_MAX_GPIO_NUM		32
+#define UART_ISP_SEL			0
+#define UART_ISP_RATIO			1
+
+#define FIMC_IS_MAX_SENSORS		4
+
+#define SENSOR_4E5_WIDTH		2560
+#define SENSOR_4E5_HEIGHT		1920
+#define SENSOR_6A3_WIDTH		1392
+#define SENSOR_6A3_HEIGHT		1392
+
+enum sensor_id {
+	SENSOR_S5K3H2	= 1,
+	SENSOR_S5K6A3	= 2,
+	SENSOR_S5K4E5	= 3,
+	SENSOR_S5K3H7	= 4,
+	SENSOR_CUSTOM	= 100,
+	SENSOR_END
+};
+
+enum sensor_channel {
+	SENSOR_CONTROL_I2C0	 = 0,
+	SENSOR_CONTROL_I2C1	 = 1
+};
+
+enum actuator_name {
+	ACTUATOR_NAME_AD5823	= 1,
+	ACTUATOR_NAME_DWXXXX	= 2,
+	ACTUATOR_NAME_AK7343	= 3,
+	ACTUATOR_NAME_HYBRIDVCA	= 4,
+	ACTUATOR_NAME_NOTHING	= 100,
+	ACTUATOR_NAME_END
+};
+
+enum flash_drv_name {
+	FLADRV_NAME_KTD267	= 1,
+	FLADRV_NAME_NOTHING	= 100,
+	FLADRV_NAME_END
+};
+
+enum from_name {
+	FROMDRV_NAME_W25Q80BW	= 1,
+	FROMDRV_NAME_NOTHING
+};
+
+enum sensor_peri_type {
+	SE_I2C,
+	SE_SPI,
+	SE_GPIO,
+	SE_MPWM,
+	SE_ADC,
+	SE_NULL
+};
+
+struct i2c_type {
+	u32 channel;
+	u32 slave_address;
+	u32 speed;
+};
+
+struct spi_type {
+	u32 channel;
+};
+
+struct gpio_type {
+	u32 first_gpio_port_no;
+	u32 second_gpio_port_no;
+};
+
+union sensor_peri_format {
+	struct i2c_type i2c;
+	struct spi_type spi;
+	struct gpio_type gpio;
+};
+
+struct sensor_protocol {
+	unsigned int product_name;
+	enum sensor_peri_type peri_type;
+	union sensor_peri_format peri_setting;
+};
+
+struct fimc_is_sensor_ext {
+	struct sensor_protocol actuator_con;
+	struct sensor_protocol flash_con;
+	struct sensor_protocol from_con;
+
+	unsigned int mclk;
+	unsigned int mipi_lane_num;
+	unsigned int mipi_speed;
+	unsigned int fast_open_sensor;
+	unsigned int self_calibration_mode;
+};
+
+struct fimc_is_sensor_info {
+	unsigned int	sensor_id;
+	char		*sensor_name;
+	unsigned int	pixel_width;
+	unsigned int	pixel_height;
+	unsigned int	active_width;
+	unsigned int	active_height;
+	unsigned int	max_framerate;
+	unsigned int	csi_ch;
+	unsigned int	flite_ch;
+	unsigned int	i2c_ch;
+	struct fimc_is_sensor_ext ext;
+	char		*setfile_name;
+};
+
+enum sensor_clks {
+	SCLK_BAYER,
+	SCLK_CAM0,
+	SCLK_CAM1,
+	SCLK_MAX_NUM,
+};
+
+struct sensor_pix_format {
+	enum v4l2_mbus_pixelcode code;
+};
+
+/**
+ * struct fimc_is_sensor - fimc-is sensor context
+ * @pad: media pad
+ * @subdev: sensor subdev
+ * @clock: sensor clocks array
+ * @pipeline: is pipeline context pointer
+ * @sensor_info: fimc-is sensor config information
+ * @sensor_data: platform data received for sensor
+ */
+struct fimc_is_sensor {
+	struct media_pad		pad;
+	struct v4l2_subdev		subdev;
+	struct clk			*clock[SCLK_MAX_NUM];
+
+	struct fimc_is_pipeline		*pipeline;
+	struct fimc_is_sensor_info	*sensor_info;
+	struct fimc_is_sensor_data	*sensor_data;
+};
+
+int fimc_is_sensor_subdev_create(struct fimc_is_sensor *sensor,
+		struct fimc_is_sensor_data *sensor_data,
+		struct fimc_is_pipeline *pipeline);
+void fimc_is_sensor_subdev_destroy(struct fimc_is_sensor *sensor);
+
+#endif /* FIMC_IS_SENSOR_H_ */
-- 
1.7.9.5

