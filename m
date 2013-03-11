Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:25929 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455Ab3CKTp0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 15:45:26 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
	dh09.lee@samsung.com, shaik.samsung@gmail.com, arun.kk@samsung.com,
	a.hajda@samsung.com, linux-samsung-soc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org,
	linux-arm-kernel@lists.infradead.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RFC PATCH 4/8] s5p-fimc: Add common FIMC-IS image sensor driver
Date: Mon, 11 Mar 2013 20:44:48 +0100
Message-id: <1363031092-29950-5-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1363031092-29950-1-git-send-email-s.nawrocki@samsung.com>
References: <1363031092-29950-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This subdev driver currently only handles an image sensor's
power supplies and reset signal. There is no any I2C communication
here as it is handled by the ISP's firmware.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-is-sensor.c |  308 ++++++++++++++++++++++
 drivers/media/platform/s5p-fimc/fimc-is-sensor.h |   80 ++++++
 2 files changed, 388 insertions(+)
 create mode 100644 drivers/media/platform/s5p-fimc/fimc-is-sensor.c
 create mode 100644 drivers/media/platform/s5p-fimc/fimc-is-sensor.h

diff --git a/drivers/media/platform/s5p-fimc/fimc-is-sensor.c b/drivers/media/platform/s5p-fimc/fimc-is-sensor.c
new file mode 100644
index 0000000..151915c
--- /dev/null
+++ b/drivers/media/platform/s5p-fimc/fimc-is-sensor.c
@@ -0,0 +1,308 @@
+/*
+ * Samsung EXYNOS4x12 FIMC-IS (Imaging Subsystem) driver
+ *
+ * Copyright (C) 2013 Samsung Electronics Co., Ltd.
+ * Sylwester Nawrocki <s.nawrocki@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/errno.h>
+#include <linux/gpio.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/kernel.h>
+#include <linux/memory.h>
+#include <linux/module.h>
+#include <linux/of_gpio.h>
+#include <linux/regulator/consumer.h>
+#include <linux/slab.h>
+#include <media/v4l2-subdev.h>
+
+#include "fimc-is.h"
+#include "fimc-is-sensor.h"
+
+#define DRIVER_NAME "FIMC-IS-SENSOR"
+
+static const char * const sensor_supply_names[] = {
+	"svdda",
+	"svddio",
+};
+
+static const struct v4l2_mbus_framefmt fimc_is_sensor_formats[] = {
+	{
+		.code = V4L2_MBUS_FMT_SGRBG10_1X10,
+		.colorspace = V4L2_COLORSPACE_SRGB,
+		.field = V4L2_FIELD_NONE,
+	}
+};
+
+static struct fimc_is_sensor *sd_to_fimc_is_sensor(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct fimc_is_sensor, subdev);
+}
+
+static const struct v4l2_mbus_framefmt *find_sensor_format(
+	struct v4l2_mbus_framefmt *mf)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(fimc_is_sensor_formats); i++)
+		if (mf->code == fimc_is_sensor_formats[i].code)
+			return &fimc_is_sensor_formats[i];
+
+	return &fimc_is_sensor_formats[0];
+}
+
+static int fimc_is_sensor_enum_mbus_code(struct v4l2_subdev *sd,
+				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_mbus_code_enum *code)
+{
+	if (code->index >= ARRAY_SIZE(fimc_is_sensor_formats))
+		return -EINVAL;
+
+	code->code = fimc_is_sensor_formats[code->index].code;
+	return 0;
+}
+
+static void fimc_is_sensor_try_format(struct fimc_is_sensor *sensor,
+				      struct v4l2_mbus_framefmt *mf)
+{
+	const struct sensor_drv_data *dd = sensor->drvdata;
+	const struct v4l2_mbus_framefmt *fmt;
+
+	fmt = find_sensor_format(mf);
+	mf->code = fmt->code;
+	v4l_bound_align_image(&mf->width, 16 + 8, dd->width, 0,
+			      &mf->height, 12 + 8, dd->height, 0, 0);
+}
+
+static struct v4l2_mbus_framefmt *__fimc_is_sensor_get_format(
+		struct fimc_is_sensor *sensor, struct v4l2_subdev_fh *fh,
+		u32 pad, enum v4l2_subdev_format_whence which)
+{
+	if (which == V4L2_SUBDEV_FORMAT_TRY)
+		return fh ? v4l2_subdev_get_try_format(fh, pad) : NULL;
+
+	return &sensor->format;
+}
+
+static int fimc_is_sensor_set_fmt(struct v4l2_subdev *sd,
+				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_format *fmt)
+{
+	struct fimc_is_sensor *sensor = sd_to_fimc_is_sensor(sd);
+	struct v4l2_mbus_framefmt *mf;
+
+	fimc_is_sensor_try_format(sensor, &fmt->format);
+
+	mf = __fimc_is_sensor_get_format(sensor, fh, fmt->pad, fmt->which);
+	if (mf) {
+		mutex_lock(&sensor->lock);
+		if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE)
+			sensor->format = *mf;
+		mutex_unlock(&sensor->lock);
+	}
+	return 0;
+}
+
+static int fimc_is_sensor_get_fmt(struct v4l2_subdev *sd,
+				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_format *fmt)
+{
+	struct fimc_is_sensor *sensor = sd_to_fimc_is_sensor(sd);
+	struct v4l2_mbus_framefmt *mf;
+
+	mf = __fimc_is_sensor_get_format(sensor, fh, fmt->pad, fmt->which);
+
+	mutex_lock(&sensor->lock);
+	fmt->format = *mf;
+	mutex_unlock(&sensor->lock);
+	return 0;
+}
+
+static struct v4l2_subdev_pad_ops fimc_is_sensor_pad_ops = {
+	.enum_mbus_code	= fimc_is_sensor_enum_mbus_code,
+	.get_fmt	= fimc_is_sensor_get_fmt,
+	.set_fmt	= fimc_is_sensor_set_fmt,
+};
+
+static int fimc_is_sensor_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+{
+	struct v4l2_mbus_framefmt *format = v4l2_subdev_get_try_format(fh, 0);
+
+	*format		= fimc_is_sensor_formats[0];
+	format->width	= FIMC_IS_SENSOR_DEF_PIX_WIDTH;
+	format->height	= FIMC_IS_SENSOR_DEF_PIX_HEIGHT;
+
+	return 0;
+}
+
+static const struct v4l2_subdev_internal_ops fimc_is_sensor_sd_internal_ops = {
+	.open = fimc_is_sensor_open,
+};
+
+static int fimc_is_sensor_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct fimc_is_sensor *sensor = v4l2_get_subdevdata(sd);
+	int gpio = sensor->gpio_reset;
+	int ret;
+
+	pr_debug("%s:%d: on: %d\n", __func__, __LINE__, on);
+
+	if (on) {
+		ret = regulator_bulk_enable(SENSOR_NUM_SUPPLIES,
+					    sensor->supplies);
+		if (gpio_is_valid(gpio)) {
+			gpio_set_value(gpio, 1);
+			usleep_range(600, 800);
+			gpio_set_value(gpio, 0);
+			usleep_range(10000, 11000);
+			gpio_set_value(gpio, 1);
+		}
+	} else {
+		if (gpio_is_valid(gpio))
+			gpio_set_value(gpio, 0);
+
+		ret = regulator_bulk_disable(SENSOR_NUM_SUPPLIES,
+					     sensor->supplies);
+	}
+
+	return ret;
+}
+
+static struct v4l2_subdev_core_ops fimc_is_sensor_core_ops = {
+	.s_power = fimc_is_sensor_s_power,
+};
+
+static struct v4l2_subdev_ops fimc_is_sensor_subdev_ops = {
+	.core = &fimc_is_sensor_core_ops,
+	.pad = &fimc_is_sensor_pad_ops,
+};
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
+	int gpio, i, ret;
+
+	sensor = devm_kzalloc(dev, sizeof(*sensor), GFP_KERNEL);
+	if (!sensor)
+		return -ENOMEM;
+
+	mutex_init(&sensor->lock);
+	sensor->gpio_reset = -EINVAL;
+
+	gpio = of_get_gpio_flags(dev->of_node, 0, NULL); /* &of_flags); */
+	if (gpio_is_valid(gpio)) {
+		/* gpio->level = !(of_flags & OF_GPIO_ACTIVE_LOW); */
+		ret = gpio_request_one(gpio, GPIOF_OUT_INIT_LOW, DRIVER_NAME);
+		if (ret < 0)
+			return ret;
+	}
+	sensor->gpio_reset = gpio;
+
+	for (i = 0; i < SENSOR_NUM_SUPPLIES; i++)
+		sensor->supplies[i].supply = sensor_supply_names[i];
+
+	ret = devm_regulator_bulk_get(&client->dev, SENSOR_NUM_SUPPLIES,
+				      sensor->supplies);
+	if (ret < 0)
+		goto err_gpio;
+
+	of_id = of_match_node(fimc_is_sensor_of_match, dev->of_node);
+	if (!of_id) {
+		ret = -ENODEV;
+		goto err_reg;
+	}
+
+	sensor->drvdata = of_id->data;
+
+	sd = &sensor->subdev;
+	v4l2_i2c_subdev_init(sd, client, &fimc_is_sensor_subdev_ops);
+	snprintf(sd->name, sizeof(sd->name), sensor->drvdata->subdev_name);
+	sensor->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+
+	sensor->format.code = fimc_is_sensor_formats[0].code;
+	sensor->format.width = FIMC_IS_SENSOR_DEF_PIX_WIDTH;
+	sensor->format.height = FIMC_IS_SENSOR_DEF_PIX_HEIGHT;
+
+	sensor->pad.flags = MEDIA_PAD_FL_SOURCE;
+	ret = media_entity_init(&sd->entity, 1, &sensor->pad, 0);
+	if (ret < 0)
+		goto err_reg;
+
+	v4l2_set_subdevdata(sd, sensor);
+
+	return 0;
+err_reg:
+	regulator_bulk_free(SENSOR_NUM_SUPPLIES, sensor->supplies);
+err_gpio:
+	if (gpio_is_valid(sensor->gpio_reset))
+		gpio_free(sensor->gpio_reset);
+	return ret;
+}
+
+static int fimc_is_sensor_remove(struct i2c_client *client)
+{
+	struct fimc_is_sensor *sensor;
+
+	regulator_bulk_free(SENSOR_NUM_SUPPLIES, sensor->supplies);
+	media_entity_cleanup(&sensor->subdev.entity);
+
+	return 0;
+}
+
+static const struct i2c_device_id fimc_is_sensor_ids[] = {
+	{ }
+};
+
+static const struct sensor_drv_data s5k6a3_drvdata = {
+	.id		= FIMC_IS_SENSOR_ID_S5K6A3,
+	.subdev_name	= "S5K6A3",
+	.width		= S5K6A3_SENSOR_WIDTH,
+	.height		= S5K6A3_SENSOR_HEIGHT,
+};
+
+static const struct of_device_id fimc_is_sensor_of_match[] = {
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
+int fimc_is_register_sensor_driver(void)
+{
+	return i2c_add_driver(&fimc_is_sensor_driver);
+}
+
+void fimc_is_unregister_sensor_driver(void)
+{
+	i2c_del_driver(&fimc_is_sensor_driver);
+}
+
+MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
+MODULE_DESCRIPTION("Exynos4x12 FIMC-IS image sensor subdev driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/platform/s5p-fimc/fimc-is-sensor.h b/drivers/media/platform/s5p-fimc/fimc-is-sensor.h
new file mode 100644
index 0000000..e80490e
--- /dev/null
+++ b/drivers/media/platform/s5p-fimc/fimc-is-sensor.h
@@ -0,0 +1,80 @@
+/*
+ * Samsung EXYNOS4x12 FIMC-IS (Imaging Subsystem) driver
+ *
+ * Copyright (C) 2012 Samsung Electronics Co., Ltd.
+ *  Younghwan Joo <yhwan.joo@samsung.com>
+ *  Sylwester Nawrocki <s.nawrocki@samsung.com>
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
+#define FIMC_IS_SENSOR_OPEN_TIMEOUT	2000 /* ms */
+
+#define FIMC_IS_SENSOR_DEF_PIX_WIDTH	1296
+#define FIMC_IS_SENSOR_DEF_PIX_HEIGHT	732
+
+#define S5K6A3_SENSOR_WIDTH		1392
+#define S5K6A3_SENSOR_HEIGHT		1392
+
+#define SENSOR_NUM_SUPPLIES		2
+
+enum fimc_is_sensor_id {
+	FIMC_IS_SENSOR_ID_S5K3H2 = 1,
+	FIMC_IS_SENSOR_ID_S5K6A3,
+	FIMC_IS_SENSOR_ID_S5K4E5,
+	FIMC_IS_SENSOR_ID_S5K3H7,
+	FIMC_IS_SENSOR_ID_CUSTOM,
+	FIMC_IS_SENSOR_ID_END
+};
+
+#define IS_SENSOR_CTRL_BUS_I2C0		0
+#define IS_SENSOR_CTRL_BUS_I2C1		1
+
+struct sensor_drv_data {
+	enum fimc_is_sensor_id id;
+	const char * const subdev_name;
+	unsigned int width;
+	unsigned int height;
+};
+
+/**
+ * struct fimc_is_sensor - fimc-is sensor data structure
+ * @subdev: the image sensor's v4l2 subdev
+ * @pad: subdev media source pad
+ * @supplies: image sensor's voltage regulator supplies
+ * @gpio_reset: GPIO connected to the sensor's reset pin
+ * @drvdata: a pointer to the sensor's parameters data structure
+ * @i2c_bus: ISP I2C bus index (0...1)
+ * @test_pattern: true to enable video test pattern
+ * @lock: mutex protecting the structure's members below
+ * @format: media bus format at the sensor's source pad
+ */
+struct fimc_is_sensor {
+	struct v4l2_subdev subdev;
+	struct media_pad pad;
+	struct regulator_bulk_data supplies[SENSOR_NUM_SUPPLIES];
+	int gpio_reset;
+	const struct sensor_drv_data *drvdata;
+	unsigned int i2c_bus;
+	bool test_pattern;
+
+	struct mutex lock;
+	struct v4l2_mbus_framefmt format;
+};
+
+int fimc_is_register_sensor_driver(void);
+void fimc_is_unregister_sensor_driver(void);
+
+#endif /* FIMC_IS_SENSOR_H_ */
-- 
1.7.9.5

