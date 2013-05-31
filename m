Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:55276 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756573Ab3EaMn1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 08:43:27 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MNN00EKUY049NU0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 31 May 2013 21:43:25 +0900 (KST)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, kilyeon.im@samsung.com,
	shaik.ameer@samsung.com, arunkk.samsung@gmail.com
Subject: [RFC v2 05/10] exynos5-fimc-is: Adds the sensor subdev
Date: Fri, 31 May 2013 18:33:23 +0530
Message-id: <1370005408-10853-6-git-send-email-arun.kk@samsung.com>
In-reply-to: <1370005408-10853-1-git-send-email-arun.kk@samsung.com>
References: <1370005408-10853-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

FIMC-IS uses certain sensors which are exclusively controlled
from the IS firmware. This patch adds the sensor subdev for the
fimc-is sensors.

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
Signed-off-by: Kilyeon Im <kilyeon.im@samsung.com>
---
 drivers/media/platform/exynos5-is/fimc-is-sensor.c |  463 ++++++++++++++++++++
 drivers/media/platform/exynos5-is/fimc-is-sensor.h |  168 +++++++
 2 files changed, 631 insertions(+)
 create mode 100644 drivers/media/platform/exynos5-is/fimc-is-sensor.c
 create mode 100644 drivers/media/platform/exynos5-is/fimc-is-sensor.h

diff --git a/drivers/media/platform/exynos5-is/fimc-is-sensor.c b/drivers/media/platform/exynos5-is/fimc-is-sensor.c
new file mode 100644
index 0000000..b8fb834
--- /dev/null
+++ b/drivers/media/platform/exynos5-is/fimc-is-sensor.c
@@ -0,0 +1,463 @@
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
+#include <linux/of_gpio.h>
+#include <linux/i2c.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <media/v4l2-of.h>
+#include "fimc-is-sensor.h"
+#include "fimc-is.h"
+
+#define DRIVER_NAME "fimc-is-sensor"
+
+static char *sensor_clock_name[] = {
+	[SCLK_BAYER]	= "sclk_bayer",
+	[SCLK_CAM0]	= "sclk_cam0",
+	[SCLK_CAM1]	= "sclk_cam1",
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
+		if (IS_ERR(sensor->clock[i]))
+			continue;
+		clk_unprepare(sensor->clock[i]);
+		clk_put(sensor->clock[i]);
+		sensor->clock[i] = ERR_PTR(-EINVAL);
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
+			sensor->clock[i] = ERR_PTR(-EINVAL);
+			goto err;
+		}
+	}
+
+	/* Set clock rates */
+	ret = clk_set_rate(sensor->clock[SCLK_CAM0], 24 * 1000000);
+	ret |= clk_set_rate(sensor->clock[SCLK_BAYER], 24 * 1000000);
+	if (ret) {
+		pr_err("Failed to set cam clock rates\n");
+		goto err;
+	}
+	return 0;
+err:
+	sensor_clk_put(sensor);
+	pr_err("Failed to init sensor clock\n");
+	return -ENXIO;
+}
+
+static int sensor_clk_enable(struct fimc_is_sensor *sensor)
+{
+	int ret = 0, i;
+
+	for (i = 0; i < SCLK_MAX_NUM; i++) {
+		ret = clk_enable(sensor->clock[i]);
+		if (ret)
+			return ret;
+	}
+	return ret;
+}
+
+static void sensor_clk_disable(struct fimc_is_sensor *sensor)
+{
+	int i;
+
+	for (i = 0; i < SCLK_MAX_NUM; i++)
+		clk_disable(sensor->clock[i]);
+}
+
+static int sensor_enum_mbus_code(struct v4l2_subdev *sd,
+				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_mbus_code_enum *code)
+{
+	struct fimc_is_sensor *sensor = sd_to_fimc_is_sensor(sd);
+	struct fimc_is_sensor_drv_data *sdata = sensor->drvdata;
+
+	if (!code)
+		return -EINVAL;
+
+	code->code = sensor_formats[sdata->sensor_id].code;
+	return 0;
+}
+
+static int sensor_set_fmt(struct v4l2_subdev *sd,
+			  struct v4l2_subdev_fh *fh,
+			  struct v4l2_subdev_format *fmt)
+{
+	struct fimc_is_sensor *sensor = sd_to_fimc_is_sensor(sd);
+	struct fimc_is_sensor_drv_data *sdata = sensor->drvdata;
+	struct v4l2_mbus_framefmt *sfmt = &fmt->format;
+
+	if ((sfmt->width != sensor_formats[sdata->sensor_id].width) ||
+		(sfmt->height != sensor_formats[sdata->sensor_id].height) ||
+		(sfmt->code != sensor_formats[sdata->sensor_id].code))
+		*sfmt = sensor_formats[sdata->sensor_id];
+
+	return 0;
+}
+
+static int sensor_get_fmt(struct v4l2_subdev *sd,
+			  struct v4l2_subdev_fh *fh,
+			  struct v4l2_subdev_format *fmt)
+{
+	struct fimc_is_sensor *sensor = sd_to_fimc_is_sensor(sd);
+	struct fimc_is_sensor_drv_data *sdata = sensor->drvdata;
+
+	fmt->format = sensor_formats[sdata->sensor_id];
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
+	struct v4l2_mbus_framefmt *format = v4l2_subdev_get_try_format(fh, 0);
+
+	*format = sensor_formats[0];
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
+
+	if (on) {
+		/* Power on sensor */
+		sensor_clk_enable(sensor);
+		gpio_set_value(sensor->gpio_reset, 1);
+	} else {
+		/* Power off sensor */
+		gpio_set_value(sensor->gpio_reset, 0);
+		sensor_clk_disable(sensor);
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
+		pr_debug("Stream ON\n");
+		/* Open pipeline */
+		ret = fimc_is_pipeline_open(sensor->pipeline, sensor);
+		if (ret < 0) {
+			pr_err("Pipeline already opened.\n");
+			return -EBUSY;
+		}
+
+		/* Start IS pipeline */
+		ret = fimc_is_pipeline_start(sensor->pipeline);
+		if (ret < 0) {
+			pr_err("Pipeline start failed.\n");
+			return -EINVAL;
+		}
+	} else {
+		pr_debug("Stream OFF\n");
+		/* Stop IS pipeline */
+		ret = fimc_is_pipeline_stop(sensor->pipeline);
+		if (ret < 0) {
+			pr_err("Pipeline stop failed.\n");
+			return -EINVAL;
+		}
+
+		/* Close pipeline */
+		ret = fimc_is_pipeline_close(sensor->pipeline);
+		if (ret < 0) {
+			pr_err("Pipeline close failed\n");
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
+static int sensor_parse_dt(struct fimc_is_sensor *sensor,
+			struct device_node *sensor_node)
+{
+	struct device_node *port, *ep, *remote, *fimc_is_node, *camera;
+	struct fimc_is *is_data;
+	struct platform_device *pdev_is;
+	struct v4l2_of_endpoint endpoint;
+
+	/* Parse ports */
+	port = sensor_node;
+	while ((port = of_get_next_child(port, NULL))) {
+		if (!of_node_cmp(port->name, "port"))
+			break;
+		of_node_put(port);
+	};
+	if (!port) {
+		pr_err("Sensor port undefined\n");
+		return -EINVAL;
+	}
+
+	ep = of_get_next_child(port, NULL);
+	if (!ep)
+		return -EINVAL;
+
+	port = of_parse_phandle(ep, "remote-endpoint", 0);
+	if (port) {
+		v4l2_of_parse_endpoint(port, &endpoint);
+		sensor->i2c_ch = (endpoint.port >> 2) & 0x1;
+	}
+
+	remote = v4l2_of_get_remote_port_parent(ep);
+	of_node_put(ep);
+
+	if (!remote)
+		return -EINVAL;
+
+	camera = of_get_parent(remote);
+	fimc_is_node = NULL;
+	while ((fimc_is_node = of_get_next_child(camera, fimc_is_node))) {
+		if (!of_node_cmp(fimc_is_node->name, "fimc-is"))
+			break;
+		of_node_put(fimc_is_node);
+	};
+	of_node_put(camera);
+
+	if (!fimc_is_node)
+		return -EINVAL;
+
+	/* Get the IS pipeline context */
+	pdev_is = of_find_device_by_node(fimc_is_node);
+	is_data = dev_get_drvdata(&pdev_is->dev);
+
+	if (!is_data)
+		return -EINVAL;
+
+	sensor->pipeline = &is_data->pipeline;
+
+	return 0;
+}
+
+static const struct of_device_id fimc_is_sensor_of_match[];
+
+static int fimc_is_sensor_probe(struct i2c_client *client,
+				const struct i2c_device_id *id)
+{
+	struct device *dev = &client->dev;
+	struct fimc_is_sensor *sensor;
+	const struct of_device_id *of_id;
+	struct v4l2_subdev *sd;
+	int gpio, ret;
+	unsigned int sensor_id;
+
+	sensor = devm_kzalloc(dev, sizeof(*sensor), GFP_KERNEL);
+	if (!sensor)
+		return -ENOMEM;
+
+	sensor->gpio_reset = -EINVAL;
+
+	gpio = of_get_gpio_flags(dev->of_node, 0, NULL);
+	if (gpio_is_valid(gpio)) {
+		ret = gpio_request_one(gpio, GPIOF_OUT_INIT_LOW, DRIVER_NAME);
+		if (ret < 0)
+			return ret;
+	}
+	pr_err("GPIO Request success : %d", gpio);
+	sensor->gpio_reset = gpio;
+
+	of_id = of_match_node(fimc_is_sensor_of_match, dev->of_node);
+	if (!of_id) {
+		ret = -ENODEV;
+		goto err_gpio;
+	}
+
+	sensor->drvdata = (struct fimc_is_sensor_drv_data *) of_id->data;
+	sensor->dev = dev;
+
+	/* Get FIMC-IS context */
+	ret = sensor_parse_dt(sensor, dev->of_node);
+	if (ret) {
+		pr_err("Unable to obtain IS context\n");
+		ret = -ENODEV;
+		goto err_gpio;
+	}
+
+	sd = &sensor->subdev;
+	v4l2_i2c_subdev_init(sd, client, &sensor_subdev_ops);
+	snprintf(sd->name, sizeof(sd->name), sensor->drvdata->sensor_name);
+	sensor->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+
+	sensor_id = sensor->drvdata->sensor_id;
+	sensor->format.code = sensor_formats[sensor_id].code;
+	sensor->format.width = sensor_formats[sensor_id].width;
+	sensor->format.height = sensor_formats[sensor_id].height;
+
+	sensor->pad.flags = MEDIA_PAD_FL_SOURCE;
+	ret = media_entity_init(&sd->entity, 1, &sensor->pad, 0);
+	if (ret < 0)
+		goto err_gpio;
+
+	v4l2_set_subdevdata(sd, sensor);
+	i2c_set_clientdata(client, &sensor->subdev);
+
+	pm_runtime_no_callbacks(dev);
+	pm_runtime_enable(dev);
+	sensor_clk_init(sensor);
+
+	return 0;
+err_gpio:
+	if (gpio_is_valid(sensor->gpio_reset))
+		gpio_free(sensor->gpio_reset);
+	return ret;
+}
+
+static int fimc_is_sensor_remove(struct i2c_client *client)
+{
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct fimc_is_sensor *sensor = sd_to_fimc_is_sensor(sd);
+
+	media_entity_cleanup(&sensor->subdev.entity);
+	sensor_clk_put(sensor);
+
+	return 0;
+}
+
+static const struct i2c_device_id fimc_is_sensor_ids[] = {
+	{ }
+};
+
+static const struct fimc_is_sensor_drv_data s5k4e5_drvdata = {
+	.sensor_id = SENSOR_S5K4E5,
+	.sensor_name = "s5k4e5",
+	.pixel_width = SENSOR_4E5_WIDTH + 16,
+	.pixel_height = SENSOR_4E5_HEIGHT + 10,
+	.active_width = SENSOR_4E5_WIDTH,
+	.active_height = SENSOR_4E5_HEIGHT,
+	.max_framerate = 30,
+	.setfile_name = "setfile_4e5.bin",
+	.ext = {
+		.actuator_con = {
+			.product_name = ACTUATOR_NAME_DWXXXX,
+			.peri_type = SE_I2C,
+			.peri_setting.i2c.channel = SENSOR_CONTROL_I2C0,
+		},
+		.flash_con = {
+			.product_name = FLADRV_NAME_KTD267,
+			.peri_type = SE_GPIO,
+			.peri_setting.gpio.first_gpio_port_no = 1,
+			.peri_setting.gpio.second_gpio_port_no = 2,
+		},
+		.from_con.product_name = FROMDRV_NAME_NOTHING,
+		.mclk = 0,
+		.mipi_lane_num = 0,
+		.mipi_speed = 0,
+		.fast_open_sensor = 0,
+		.self_calibration_mode = 0,
+	},
+};
+
+static const struct fimc_is_sensor_drv_data s5k6a3_drvdata = {
+	.sensor_id = SENSOR_S5K6A3,
+	.sensor_name = "s5k6a3",
+	.pixel_width = SENSOR_6A3_WIDTH + 16,
+	.pixel_height = SENSOR_6A3_HEIGHT + 10,
+	.active_width = SENSOR_6A3_WIDTH,
+	.active_height = SENSOR_6A3_HEIGHT,
+	.max_framerate = 30,
+	.setfile_name = "setfile_6a3.bin",
+};
+
+static const struct of_device_id fimc_is_sensor_of_match[] = {
+	{
+		.compatible	= "samsung,s5k4e5",
+		.data		= &s5k4e5_drvdata,
+	},
+	{
+		.compatible	= "samsung,s5k6a3",
+		.data		= &s5k6a3_drvdata,
+	},
+	{  }
+};
+MODULE_DEVICE_TABLE(of, fimc_is_sensor_of_match);
+
+static struct i2c_driver fimc_is_sensor_driver = {
+	.driver = {
+		.of_match_table	= fimc_is_sensor_of_match,
+		.name		= DRIVER_NAME,
+		.owner		= THIS_MODULE,
+	},
+	.probe		= fimc_is_sensor_probe,
+	.remove		= fimc_is_sensor_remove,
+	.id_table	= fimc_is_sensor_ids,
+};
+
+module_i2c_driver(fimc_is_sensor_driver);
+
+MODULE_AUTHOR("Arun Kumar K <arun.kk@samsung.com>");
+MODULE_DESCRIPTION("Exynos5 FIMC-IS sensor subdev driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/platform/exynos5-is/fimc-is-sensor.h b/drivers/media/platform/exynos5-is/fimc-is-sensor.h
new file mode 100644
index 0000000..75e5f20
--- /dev/null
+++ b/drivers/media/platform/exynos5-is/fimc-is-sensor.h
@@ -0,0 +1,168 @@
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
+struct fimc_is_sensor_drv_data {
+	unsigned int	sensor_id;
+	char		*sensor_name;
+	unsigned int	pixel_width;
+	unsigned int	pixel_height;
+	unsigned int	active_width;
+	unsigned int	active_height;
+	unsigned int	max_framerate;
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
+ * @dev: sensor device ptr
+ * @pipeline: is pipeline context pointer
+ * @drvdata: sensor specific driver data
+ * @format: v4l2 mbus format for the subdev
+ * @gpio_reset: gpio pin to be used for sensor power on/off
+ * @i2c_ch: sensor's i2c channel number
+ */
+struct fimc_is_sensor {
+	struct media_pad		pad;
+	struct v4l2_subdev		subdev;
+	struct clk			*clock[SCLK_MAX_NUM];
+	struct device			*dev;
+
+	struct fimc_is_pipeline		*pipeline;
+	struct fimc_is_sensor_drv_data	*drvdata;
+	struct v4l2_mbus_framefmt	format;
+	int				gpio_reset;
+	unsigned int			i2c_ch;
+};
+
+#endif /* FIMC_IS_SENSOR_H_ */
-- 
1.7.9.5

