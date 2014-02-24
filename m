Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:26231 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978AbaBXRhI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Feb 2014 12:37:08 -0500
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, robh+dt@kernel.org,
	mark.rutland@arm.com, galak@codeaurora.org,
	kyungmin.park@samsung.com, kgene.kim@samsung.com,
	a.hajda@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v5 06/10] exynos4-is: Use external s5k6a3 sensor driver
Date: Mon, 24 Feb 2014 18:35:18 +0100
Message-id: <1393263322-28215-7-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1393263322-28215-1-git-send-email-s.nawrocki@samsung.com>
References: <1393263322-28215-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch removes the common fimc-is-sensor driver for image sensors
that are normally controlled by the FIMC-IS firmware. The FIMC-IS
driver now contains only a table of properties specific to each sensor.
The sensor properties required for the ISP's firmware are parsed from
device tree and retrieved from the internal table, which is selected
based on the compatible property of an image sensor.

To use the Exynos4x12 internal ISP the S5K6A3 sensor driver (drivers/
media/i2c/s5k6a3.c) is now required.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Changes since v4:
  - none.
---
 drivers/media/platform/exynos4-is/fimc-is-regs.c   |    2 +-
 drivers/media/platform/exynos4-is/fimc-is-sensor.c |  285 +-------------------
 drivers/media/platform/exynos4-is/fimc-is-sensor.h |   49 +---
 drivers/media/platform/exynos4-is/fimc-is.c        |   97 +++----
 drivers/media/platform/exynos4-is/fimc-is.h        |    4 +-
 5 files changed, 57 insertions(+), 380 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-is-regs.c b/drivers/media/platform/exynos4-is/fimc-is-regs.c
index 2628733..5c7bd2a 100644
--- a/drivers/media/platform/exynos4-is/fimc-is-regs.c
+++ b/drivers/media/platform/exynos4-is/fimc-is-regs.c
@@ -112,7 +112,7 @@ void fimc_is_hw_set_sensor_num(struct fimc_is *is)
 	mcuctl_write(IH_REPLY_DONE, is, MCUCTL_REG_ISSR(0));
 	mcuctl_write(is->sensor_index, is, MCUCTL_REG_ISSR(1));
 	mcuctl_write(IHC_GET_SENSOR_NUM, is, MCUCTL_REG_ISSR(2));
-	mcuctl_write(FIMC_IS_SENSOR_NUM, is, MCUCTL_REG_ISSR(3));
+	mcuctl_write(FIMC_IS_SENSORS_NUM, is, MCUCTL_REG_ISSR(3));
 }
 
 void fimc_is_hw_close_sensor(struct fimc_is *is, unsigned int index)
diff --git a/drivers/media/platform/exynos4-is/fimc-is-sensor.c b/drivers/media/platform/exynos4-is/fimc-is-sensor.c
index 6647421..10e82e2 100644
--- a/drivers/media/platform/exynos4-is/fimc-is-sensor.c
+++ b/drivers/media/platform/exynos4-is/fimc-is-sensor.c
@@ -2,276 +2,21 @@
  * Samsung EXYNOS4x12 FIMC-IS (Imaging Subsystem) driver
  *
  * Copyright (C) 2013 Samsung Electronics Co., Ltd.
- *
  * Author: Sylwester Nawrocki <s.nawrocki@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
-#include <linux/delay.h>
-#include <linux/device.h>
-#include <linux/errno.h>
-#include <linux/gpio.h>
-#include <linux/i2c.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/of_gpio.h>
-#include <linux/pm_runtime.h>
-#include <linux/regulator/consumer.h>
-#include <linux/slab.h>
-#include <media/v4l2-subdev.h>
 
-#include "fimc-is.h"
 #include "fimc-is-sensor.h"
 
-#define DRIVER_NAME "FIMC-IS-SENSOR"
-
-static const char * const sensor_supply_names[] = {
-	"svdda",
-	"svddio",
-};
-
-static const struct v4l2_mbus_framefmt fimc_is_sensor_formats[] = {
-	{
-		.code = V4L2_MBUS_FMT_SGRBG10_1X10,
-		.colorspace = V4L2_COLORSPACE_SRGB,
-		.field = V4L2_FIELD_NONE,
-	}
-};
-
-static const struct v4l2_mbus_framefmt *find_sensor_format(
-	struct v4l2_mbus_framefmt *mf)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(fimc_is_sensor_formats); i++)
-		if (mf->code == fimc_is_sensor_formats[i].code)
-			return &fimc_is_sensor_formats[i];
-
-	return &fimc_is_sensor_formats[0];
-}
-
-static int fimc_is_sensor_enum_mbus_code(struct v4l2_subdev *sd,
-				  struct v4l2_subdev_fh *fh,
-				  struct v4l2_subdev_mbus_code_enum *code)
-{
-	if (code->index >= ARRAY_SIZE(fimc_is_sensor_formats))
-		return -EINVAL;
-
-	code->code = fimc_is_sensor_formats[code->index].code;
-	return 0;
-}
-
-static void fimc_is_sensor_try_format(struct fimc_is_sensor *sensor,
-				      struct v4l2_mbus_framefmt *mf)
-{
-	const struct sensor_drv_data *dd = sensor->drvdata;
-	const struct v4l2_mbus_framefmt *fmt;
-
-	fmt = find_sensor_format(mf);
-	mf->code = fmt->code;
-	v4l_bound_align_image(&mf->width, 16 + 8, dd->width, 0,
-			      &mf->height, 12 + 8, dd->height, 0, 0);
-}
-
-static struct v4l2_mbus_framefmt *__fimc_is_sensor_get_format(
-		struct fimc_is_sensor *sensor, struct v4l2_subdev_fh *fh,
-		u32 pad, enum v4l2_subdev_format_whence which)
-{
-	if (which == V4L2_SUBDEV_FORMAT_TRY)
-		return fh ? v4l2_subdev_get_try_format(fh, pad) : NULL;
-
-	return &sensor->format;
-}
-
-static int fimc_is_sensor_set_fmt(struct v4l2_subdev *sd,
-				  struct v4l2_subdev_fh *fh,
-				  struct v4l2_subdev_format *fmt)
-{
-	struct fimc_is_sensor *sensor = sd_to_fimc_is_sensor(sd);
-	struct v4l2_mbus_framefmt *mf;
-
-	fimc_is_sensor_try_format(sensor, &fmt->format);
-
-	mf = __fimc_is_sensor_get_format(sensor, fh, fmt->pad, fmt->which);
-	if (mf) {
-		mutex_lock(&sensor->lock);
-		if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE)
-			*mf = fmt->format;
-		mutex_unlock(&sensor->lock);
-	}
-	return 0;
-}
-
-static int fimc_is_sensor_get_fmt(struct v4l2_subdev *sd,
-				  struct v4l2_subdev_fh *fh,
-				  struct v4l2_subdev_format *fmt)
-{
-	struct fimc_is_sensor *sensor = sd_to_fimc_is_sensor(sd);
-	struct v4l2_mbus_framefmt *mf;
-
-	mf = __fimc_is_sensor_get_format(sensor, fh, fmt->pad, fmt->which);
-
-	mutex_lock(&sensor->lock);
-	fmt->format = *mf;
-	mutex_unlock(&sensor->lock);
-	return 0;
-}
-
-static struct v4l2_subdev_pad_ops fimc_is_sensor_pad_ops = {
-	.enum_mbus_code	= fimc_is_sensor_enum_mbus_code,
-	.get_fmt	= fimc_is_sensor_get_fmt,
-	.set_fmt	= fimc_is_sensor_set_fmt,
-};
-
-static int fimc_is_sensor_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
-{
-	struct v4l2_mbus_framefmt *format = v4l2_subdev_get_try_format(fh, 0);
-
-	*format		= fimc_is_sensor_formats[0];
-	format->width	= FIMC_IS_SENSOR_DEF_PIX_WIDTH;
-	format->height	= FIMC_IS_SENSOR_DEF_PIX_HEIGHT;
-
-	return 0;
-}
-
-static const struct v4l2_subdev_internal_ops fimc_is_sensor_sd_internal_ops = {
-	.open = fimc_is_sensor_open,
-};
-
-static int fimc_is_sensor_s_power(struct v4l2_subdev *sd, int on)
-{
-	struct fimc_is_sensor *sensor = sd_to_fimc_is_sensor(sd);
-	int gpio = sensor->gpio_reset;
-	int ret;
-
-	if (on) {
-		ret = pm_runtime_get(sensor->dev);
-		if (ret < 0)
-			return ret;
-
-		ret = regulator_bulk_enable(SENSOR_NUM_SUPPLIES,
-					    sensor->supplies);
-		if (ret < 0) {
-			pm_runtime_put(sensor->dev);
-			return ret;
-		}
-		if (gpio_is_valid(gpio)) {
-			gpio_set_value(gpio, 1);
-			usleep_range(600, 800);
-			gpio_set_value(gpio, 0);
-			usleep_range(10000, 11000);
-			gpio_set_value(gpio, 1);
-		}
-
-		/* A delay needed for the sensor initialization. */
-		msleep(20);
-	} else {
-		if (gpio_is_valid(gpio))
-			gpio_set_value(gpio, 0);
-
-		ret = regulator_bulk_disable(SENSOR_NUM_SUPPLIES,
-					     sensor->supplies);
-		if (!ret)
-			pm_runtime_put(sensor->dev);
-	}
-
-	pr_info("%s:%d: on: %d, ret: %d\n", __func__, __LINE__, on, ret);
-
-	return ret;
-}
-
-static struct v4l2_subdev_core_ops fimc_is_sensor_core_ops = {
-	.s_power = fimc_is_sensor_s_power,
-};
-
-static struct v4l2_subdev_ops fimc_is_sensor_subdev_ops = {
-	.core = &fimc_is_sensor_core_ops,
-	.pad = &fimc_is_sensor_pad_ops,
-};
-
-static const struct of_device_id fimc_is_sensor_of_match[];
-
-static int fimc_is_sensor_probe(struct i2c_client *client,
-				const struct i2c_device_id *id)
-{
-	struct device *dev = &client->dev;
-	struct fimc_is_sensor *sensor;
-	const struct of_device_id *of_id;
-	struct v4l2_subdev *sd;
-	int gpio, i, ret;
-
-	sensor = devm_kzalloc(dev, sizeof(*sensor), GFP_KERNEL);
-	if (!sensor)
-		return -ENOMEM;
-
-	mutex_init(&sensor->lock);
-	sensor->gpio_reset = -EINVAL;
-
-	gpio = of_get_gpio_flags(dev->of_node, 0, NULL);
-	if (gpio_is_valid(gpio)) {
-		ret = devm_gpio_request_one(dev, gpio, GPIOF_OUT_INIT_LOW,
-							DRIVER_NAME);
-		if (ret < 0)
-			return ret;
-	}
-	sensor->gpio_reset = gpio;
-
-	for (i = 0; i < SENSOR_NUM_SUPPLIES; i++)
-		sensor->supplies[i].supply = sensor_supply_names[i];
-
-	ret = devm_regulator_bulk_get(&client->dev, SENSOR_NUM_SUPPLIES,
-				      sensor->supplies);
-	if (ret < 0)
-		return ret;
-
-	of_id = of_match_node(fimc_is_sensor_of_match, dev->of_node);
-	if (!of_id)
-		return -ENODEV;
-
-	sensor->drvdata = of_id->data;
-	sensor->dev = dev;
-
-	sd = &sensor->subdev;
-	v4l2_i2c_subdev_init(sd, client, &fimc_is_sensor_subdev_ops);
-	snprintf(sd->name, sizeof(sd->name), sensor->drvdata->subdev_name);
-	sensor->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
-
-	sensor->format.code = fimc_is_sensor_formats[0].code;
-	sensor->format.width = FIMC_IS_SENSOR_DEF_PIX_WIDTH;
-	sensor->format.height = FIMC_IS_SENSOR_DEF_PIX_HEIGHT;
-
-	sensor->pad.flags = MEDIA_PAD_FL_SOURCE;
-	ret = media_entity_init(&sd->entity, 1, &sensor->pad, 0);
-	if (ret < 0)
-		return ret;
-
-	pm_runtime_no_callbacks(dev);
-	pm_runtime_enable(dev);
-
-	return ret;
-}
-
-static int fimc_is_sensor_remove(struct i2c_client *client)
-{
-	struct v4l2_subdev *sd = i2c_get_clientdata(client);
-	media_entity_cleanup(&sd->entity);
-	return 0;
-}
-
-static const struct i2c_device_id fimc_is_sensor_ids[] = {
-	{ }
-};
-
 static const struct sensor_drv_data s5k6a3_drvdata = {
 	.id		= FIMC_IS_SENSOR_ID_S5K6A3,
-	.subdev_name	= "S5K6A3",
-	.width		= S5K6A3_SENSOR_WIDTH,
-	.height		= S5K6A3_SENSOR_HEIGHT,
+	.open_timeout	= S5K6A3_OPEN_TIMEOUT,
 };
 
-static const struct of_device_id fimc_is_sensor_of_match[] = {
+static const struct of_device_id fimc_is_sensor_of_ids[] = {
 	{
 		.compatible	= "samsung,s5k6a3",
 		.data		= &s5k6a3_drvdata,
@@ -279,27 +24,11 @@ static const struct of_device_id fimc_is_sensor_of_match[] = {
 	{  }
 };
 
-static struct i2c_driver fimc_is_sensor_driver = {
-	.driver = {
-		.of_match_table	= fimc_is_sensor_of_match,
-		.name		= DRIVER_NAME,
-		.owner		= THIS_MODULE,
-	},
-	.probe		= fimc_is_sensor_probe,
-	.remove		= fimc_is_sensor_remove,
-	.id_table	= fimc_is_sensor_ids,
-};
-
-int fimc_is_register_sensor_driver(void)
+const struct sensor_drv_data *fimc_is_sensor_get_drvdata(
+			struct device_node *node)
 {
-	return i2c_add_driver(&fimc_is_sensor_driver);
-}
+	const struct of_device_id *of_id;
 
-void fimc_is_unregister_sensor_driver(void)
-{
-	i2c_del_driver(&fimc_is_sensor_driver);
+	of_id = of_match_node(fimc_is_sensor_of_ids, node);
+	return of_id ? of_id->data : NULL;
 }
-
-MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
-MODULE_DESCRIPTION("Exynos4x12 FIMC-IS image sensor subdev driver");
-MODULE_LICENSE("GPL");
diff --git a/drivers/media/platform/exynos4-is/fimc-is-sensor.h b/drivers/media/platform/exynos4-is/fimc-is-sensor.h
index 6036d49..173ccff 100644
--- a/drivers/media/platform/exynos4-is/fimc-is-sensor.h
+++ b/drivers/media/platform/exynos4-is/fimc-is-sensor.h
@@ -13,24 +13,13 @@
 #ifndef FIMC_IS_SENSOR_H_
 #define FIMC_IS_SENSOR_H_
 
-#include <linux/clk.h>
-#include <linux/device.h>
-#include <linux/kernel.h>
-#include <linux/platform_device.h>
-#include <linux/regulator/consumer.h>
-#include <linux/videodev2.h>
-#include <media/v4l2-subdev.h>
-
-#define FIMC_IS_SENSOR_OPEN_TIMEOUT	2000 /* ms */
-
-#define FIMC_IS_SENSOR_DEF_PIX_WIDTH	1296
-#define FIMC_IS_SENSOR_DEF_PIX_HEIGHT	732
+#include <linux/of.h>
+#include <linux/types.h>
 
+#define S5K6A3_OPEN_TIMEOUT		2000 /* ms */
 #define S5K6A3_SENSOR_WIDTH		1392
 #define S5K6A3_SENSOR_HEIGHT		1392
 
-#define SENSOR_NUM_SUPPLIES		2
-
 enum fimc_is_sensor_id {
 	FIMC_IS_SENSOR_ID_S5K3H2 = 1,
 	FIMC_IS_SENSOR_ID_S5K6A3,
@@ -45,45 +34,23 @@ enum fimc_is_sensor_id {
 
 struct sensor_drv_data {
 	enum fimc_is_sensor_id id;
-	const char * const subdev_name;
-	unsigned int width;
-	unsigned int height;
+	/* sensor open timeout in ms */
+	unsigned short open_timeout;
 };
 
 /**
  * struct fimc_is_sensor - fimc-is sensor data structure
- * @dev: pointer to this I2C client device structure
- * @subdev: the image sensor's v4l2 subdev
- * @pad: subdev media source pad
- * @supplies: image sensor's voltage regulator supplies
- * @gpio_reset: GPIO connected to the sensor's reset pin
  * @drvdata: a pointer to the sensor's parameters data structure
  * @i2c_bus: ISP I2C bus index (0...1)
  * @test_pattern: true to enable video test pattern
- * @lock: mutex protecting the structure's members below
- * @format: media bus format at the sensor's source pad
  */
 struct fimc_is_sensor {
-	struct device *dev;
-	struct v4l2_subdev subdev;
-	struct media_pad pad;
-	struct regulator_bulk_data supplies[SENSOR_NUM_SUPPLIES];
-	int gpio_reset;
 	const struct sensor_drv_data *drvdata;
 	unsigned int i2c_bus;
-	bool test_pattern;
-
-	struct mutex lock;
-	struct v4l2_mbus_framefmt format;
+	u8 test_pattern;
 };
 
-static inline
-struct fimc_is_sensor *sd_to_fimc_is_sensor(struct v4l2_subdev *sd)
-{
-	return container_of(sd, struct fimc_is_sensor, subdev);
-}
-
-int fimc_is_register_sensor_driver(void);
-void fimc_is_unregister_sensor_driver(void);
+const struct sensor_drv_data *fimc_is_sensor_get_drvdata(
+				struct device_node *node);
 
 #endif /* FIMC_IS_SENSOR_H_ */
diff --git a/drivers/media/platform/exynos4-is/fimc-is.c b/drivers/media/platform/exynos4-is/fimc-is.c
index 13a4228..a8f5845 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/exynos4-is/fimc-is.c
@@ -161,78 +161,66 @@ static void fimc_is_disable_clocks(struct fimc_is *is)
 	}
 }
 
-static int fimc_is_parse_sensor_config(struct fimc_is_sensor *sensor,
-				       struct device_node *np)
+static int fimc_is_parse_sensor_config(struct fimc_is *is, unsigned int index,
+						struct device_node *node)
 {
+	struct fimc_is_sensor *sensor = &is->sensor[index];
 	u32 tmp = 0;
 	int ret;
 
-	np = v4l2_of_get_next_endpoint(np, NULL);
-	if (!np)
+	sensor->drvdata = fimc_is_sensor_get_drvdata(node);
+	if (!sensor->drvdata) {
+		dev_err(&is->pdev->dev, "no driver data found for: %s\n",
+							 node->full_name);
+		return -EINVAL;
+	}
+
+	node = v4l2_of_get_next_endpoint(node, NULL);
+	if (!node)
 		return -ENXIO;
-	np = v4l2_of_get_remote_port(np);
-	if (!np)
+
+	node = v4l2_of_get_remote_port(node);
+	if (!node)
 		return -ENXIO;
 
 	/* Use MIPI-CSIS channel id to determine the ISP I2C bus index. */
-	ret = of_property_read_u32(np, "reg", &tmp);
-	sensor->i2c_bus = tmp - FIMC_INPUT_MIPI_CSI2_0;
+	ret = of_property_read_u32(node, "reg", &tmp);
+	if (ret < 0) {
+		dev_err(&is->pdev->dev, "reg property not found at: %s\n",
+							 node->full_name);
+		return ret;
+	}
 
-	return ret;
+	sensor->i2c_bus = tmp - FIMC_INPUT_MIPI_CSI2_0;
+	return 0;
 }
 
 static int fimc_is_register_subdevs(struct fimc_is *is)
 {
-	struct device_node *adapter, *child;
-	int ret;
+	struct device_node *i2c_bus, *child;
+	int ret, index = 0;
 
 	ret = fimc_isp_subdev_create(&is->isp);
 	if (ret < 0)
 		return ret;
 
-	for_each_compatible_node(adapter, NULL, FIMC_IS_I2C_COMPATIBLE) {
-		if (!of_find_device_by_node(adapter)) {
-			of_node_put(adapter);
-			return -EPROBE_DEFER;
-		}
+	for_each_compatible_node(i2c_bus, NULL, FIMC_IS_I2C_COMPATIBLE) {
+		for_each_available_child_of_node(i2c_bus, child) {
+			ret = fimc_is_parse_sensor_config(is, index, child);
 
-		for_each_available_child_of_node(adapter, child) {
-			struct i2c_client *client;
-			struct v4l2_subdev *sd;
-
-			client = of_find_i2c_device_by_node(child);
-			if (!client)
-				goto e_retry;
-
-			sd = i2c_get_clientdata(client);
-			if (!sd)
-				goto e_retry;
-
-			/* FIXME: Add support for multiple sensors. */
-			if (WARN_ON(is->sensor))
-				continue;
-
-			is->sensor = sd_to_fimc_is_sensor(sd);
-
-			if (fimc_is_parse_sensor_config(is->sensor, child)) {
-				dev_warn(&is->pdev->dev, "DT parse error: %s\n",
-							 child->full_name);
+			if (ret < 0 || index >= FIMC_IS_SENSORS_NUM) {
+				of_node_put(child);
+				return ret;
 			}
-			pr_debug("%s(): registered subdev: %p\n",
-				 __func__, sd->name);
+			index++;
 		}
 	}
 	return 0;
-
-e_retry:
-	of_node_put(child);
-	return -EPROBE_DEFER;
 }
 
 static int fimc_is_unregister_subdevs(struct fimc_is *is)
 {
 	fimc_isp_subdev_destroy(&is->isp);
-	is->sensor = NULL;
 	return 0;
 }
 
@@ -647,7 +635,7 @@ static int fimc_is_hw_open_sensor(struct fimc_is *is,
 	fimc_is_hw_set_intgr0_gd0(is);
 
 	return fimc_is_wait_event(is, IS_ST_OPEN_SENSOR, 1,
-				  FIMC_IS_SENSOR_OPEN_TIMEOUT);
+				  sensor->drvdata->open_timeout);
 }
 
 
@@ -661,8 +649,8 @@ int fimc_is_hw_initialize(struct fimc_is *is)
 	u32 prev_id;
 	int i, ret;
 
-	/* Sensor initialization. */
-	ret = fimc_is_hw_open_sensor(is, is->sensor);
+	/* Sensor initialization. Only one sensor is currently supported. */
+	ret = fimc_is_hw_open_sensor(is, &is->sensor[0]);
 	if (ret < 0)
 		return ret;
 
@@ -977,27 +965,20 @@ static int fimc_is_module_init(void)
 {
 	int ret;
 
-	ret = fimc_is_register_sensor_driver();
-	if (ret < 0)
-		return ret;
-
 	ret = fimc_is_register_i2c_driver();
 	if (ret < 0)
-		goto err_sens;
+		return ret;
 
 	ret = platform_driver_register(&fimc_is_driver);
-	if (!ret)
-		return ret;
 
-	fimc_is_unregister_i2c_driver();
-err_sens:
-	fimc_is_unregister_sensor_driver();
+	if (ret < 0)
+		fimc_is_unregister_i2c_driver();
+
 	return ret;
 }
 
 static void fimc_is_module_exit(void)
 {
-	fimc_is_unregister_sensor_driver();
 	fimc_is_unregister_i2c_driver();
 	platform_driver_unregister(&fimc_is_driver);
 }
diff --git a/drivers/media/platform/exynos4-is/fimc-is.h b/drivers/media/platform/exynos4-is/fimc-is.h
index 61bb012..01f802f 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.h
+++ b/drivers/media/platform/exynos4-is/fimc-is.h
@@ -39,7 +39,7 @@
 #define FIMC_IS_FW_LOAD_TIMEOUT		1000 /* ms */
 #define FIMC_IS_POWER_ON_TIMEOUT	1000 /* us */
 
-#define FIMC_IS_SENSOR_NUM		2
+#define FIMC_IS_SENSORS_NUM		2
 
 /* Memory definitions */
 #define FIMC_IS_CPU_MEM_SIZE		(0xa00000)
@@ -253,7 +253,7 @@ struct fimc_is {
 	struct firmware			*f_w;
 
 	struct fimc_isp			isp;
-	struct fimc_is_sensor		*sensor;
+	struct fimc_is_sensor		sensor[FIMC_IS_SENSORS_NUM];
 	struct fimc_is_setfile		setfile;
 
 	struct vb2_alloc_ctx		*alloc_ctx;
-- 
1.7.9.5

