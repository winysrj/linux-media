Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:38395 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933577Ab3GWSlV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jul 2013 14:41:21 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, linux-samsung-soc@vger.kernel.org,
	arun.kk@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [REVIEW PATCH 1/6] V4L: Add driver for s5k6a3 image sensor
Date: Tue, 23 Jul 2013 20:39:32 +0200
Message-id: <1374604777-15523-2-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1374604777-15523-1-git-send-email-s.nawrocki@samsung.com>
References: <1374604777-15523-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds subdev driver for Samsung S5K6A3 raw image sensor.
As it is intended at the moment to be used only with the Exynos
FIMC-IS (camera ISP) subsystem it is pretty minimal subdev driver.
It doesn't do any I2C communication since the sensor is controlled
by the ISP and its own firmware.
This driver can be updated in future, should anyone need it to be
a regular subdev driver where the main CPU communicates with the
sensor directly.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/i2c/Kconfig  |    8 ++
 drivers/media/i2c/Makefile |    1 +
 drivers/media/i2c/s5k6a3.c |  315 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 324 insertions(+)
 create mode 100644 drivers/media/i2c/s5k6a3.c

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 3367ec2..dbd9cbb 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -564,6 +564,14 @@ config VIDEO_S5K6AA
 	  This is a V4L2 sensor-level driver for Samsung S5K6AA(FX) 1.3M
 	  camera sensor with an embedded SoC image signal processor.
 
+config VIDEO_S5K6A3
+	tristate "Samsung S5K6A3 sensor support"
+	depends on MEDIA_CAMERA_SUPPORT
+	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && OF
+	---help---
+	  This is a V4L2 sensor-level driver for Samsung S5K6A3 raw
+	  camera sensor.
+
 config VIDEO_S5K4ECGX
         tristate "Samsung S5K4ECGX sensor support"
         depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
index d590925..44998a2 100644
--- a/drivers/media/i2c/Makefile
+++ b/drivers/media/i2c/Makefile
@@ -64,6 +64,7 @@ obj-$(CONFIG_VIDEO_MT9V032) += mt9v032.o
 obj-$(CONFIG_VIDEO_SR030PC30)	+= sr030pc30.o
 obj-$(CONFIG_VIDEO_NOON010PC30)	+= noon010pc30.o
 obj-$(CONFIG_VIDEO_S5K6AA)	+= s5k6aa.o
+obj-$(CONFIG_VIDEO_S5K6A3)	+= s5k6a3.o
 obj-$(CONFIG_VIDEO_S5K4ECGX)	+= s5k4ecgx.o
 obj-$(CONFIG_VIDEO_S5K5BAF)	+= s5k5baf.o
 obj-$(CONFIG_VIDEO_S5C73M3)	+= s5c73m3/
diff --git a/drivers/media/i2c/s5k6a3.c b/drivers/media/i2c/s5k6a3.c
new file mode 100644
index 0000000..21680fa
--- /dev/null
+++ b/drivers/media/i2c/s5k6a3.c
@@ -0,0 +1,315 @@
+/*
+ * Samsung S5K6A3 image sensor driver
+ *
+ * Copyright (C) 2013 Samsung Electronics Co., Ltd.
+ * Author: Sylwester Nawrocki <s.nawrocki@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/errno.h>
+#include <linux/gpio.h>
+#include <linux/i2c.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of_gpio.h>
+#include <linux/pm_runtime.h>
+#include <linux/regulator/consumer.h>
+#include <linux/slab.h>
+#include <linux/videodev2.h>
+#include <media/v4l2-async.h>
+#include <media/v4l2-subdev.h>
+
+#define S5K6A3_SENSOR_MAX_WIDTH		1392
+#define S5K6A3_SENSOR_MAX_HEIGHT	1392
+#define S5K6A3_SENSOR_MIN_WIDTH		32
+#define S5K6A3_SENSOR_MIN_HEIGHT	32
+
+#define S5K6A3_DEF_PIX_WIDTH		1296
+#define S5K6A3_DEF_PIX_HEIGHT		732
+
+#define S5K6A3_DRV_NAME			"S5K6A3"
+
+#define S5K6A3_NUM_SUPPLIES		2
+
+/**
+ * struct s5k6a3 - fimc-is sensor data structure
+ * @dev: pointer to this I2C client device structure
+ * @subdev: the image sensor's v4l2 subdev
+ * @pad: subdev media source pad
+ * @supplies: image sensor's voltage regulator supplies
+ * @gpio_reset: GPIO connected to the sensor's reset pin
+ * @lock: mutex protecting the structure's members below
+ * @format: media bus format at the sensor's source pad
+ */
+struct s5k6a3 {
+	struct device *dev;
+	struct v4l2_subdev subdev;
+	struct media_pad pad;
+	struct regulator_bulk_data supplies[S5K6A3_NUM_SUPPLIES];
+	int gpio_reset;
+	struct mutex lock;
+	struct v4l2_mbus_framefmt format;
+	u32 clock_frequency;
+};
+
+static const char * const s5k6a3_supply_names[] = {
+	"svdda",
+	"svddio"
+};
+
+static inline struct s5k6a3 *sd_to_s5k6a3(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct s5k6a3, subdev);
+}
+
+static const struct v4l2_mbus_framefmt s5k6a3_formats[] = {
+	{
+		.code = V4L2_MBUS_FMT_SGRBG10_1X10,
+		.colorspace = V4L2_COLORSPACE_SRGB,
+		.field = V4L2_FIELD_NONE,
+	}
+};
+
+static const struct v4l2_mbus_framefmt *find_sensor_format(
+	struct v4l2_mbus_framefmt *mf)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(s5k6a3_formats); i++)
+		if (mf->code == s5k6a3_formats[i].code)
+			return &s5k6a3_formats[i];
+
+	return &s5k6a3_formats[0];
+}
+
+static int s5k6a3_enum_mbus_code(struct v4l2_subdev *sd,
+				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_mbus_code_enum *code)
+{
+	if (code->index >= ARRAY_SIZE(s5k6a3_formats))
+		return -EINVAL;
+
+	code->code = s5k6a3_formats[code->index].code;
+	return 0;
+}
+
+static void s5k6a3_try_format(struct v4l2_mbus_framefmt *mf)
+{
+	const struct v4l2_mbus_framefmt *fmt;
+
+	fmt = find_sensor_format(mf);
+	mf->code = fmt->code;
+	v4l_bound_align_image(&mf->width, S5K6A3_SENSOR_MIN_WIDTH,
+			      S5K6A3_SENSOR_MAX_WIDTH, 0,
+			      &mf->height, S5K6A3_SENSOR_MIN_HEIGHT,
+			      S5K6A3_SENSOR_MAX_HEIGHT, 0, 0);
+}
+
+static struct v4l2_mbus_framefmt *__s5k6a3_get_format(
+		struct s5k6a3 *sensor, struct v4l2_subdev_fh *fh,
+		u32 pad, enum v4l2_subdev_format_whence which)
+{
+	if (which == V4L2_SUBDEV_FORMAT_TRY)
+		return fh ? v4l2_subdev_get_try_format(fh, pad) : NULL;
+
+	return &sensor->format;
+}
+
+static int s5k6a3_set_fmt(struct v4l2_subdev *sd,
+				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_format *fmt)
+{
+	struct s5k6a3 *sensor = sd_to_s5k6a3(sd);
+	struct v4l2_mbus_framefmt *mf;
+
+	s5k6a3_try_format(&fmt->format);
+
+	mf = __s5k6a3_get_format(sensor, fh, fmt->pad, fmt->which);
+	if (mf) {
+		mutex_lock(&sensor->lock);
+		if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE)
+			*mf = fmt->format;
+		mutex_unlock(&sensor->lock);
+	}
+	return 0;
+}
+
+static int s5k6a3_get_fmt(struct v4l2_subdev *sd,
+				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_format *fmt)
+{
+	struct s5k6a3 *sensor = sd_to_s5k6a3(sd);
+	struct v4l2_mbus_framefmt *mf;
+
+	mf = __s5k6a3_get_format(sensor, fh, fmt->pad, fmt->which);
+
+	mutex_lock(&sensor->lock);
+	fmt->format = *mf;
+	mutex_unlock(&sensor->lock);
+	return 0;
+}
+
+static struct v4l2_subdev_pad_ops s5k6a3_pad_ops = {
+	.enum_mbus_code	= s5k6a3_enum_mbus_code,
+	.get_fmt	= s5k6a3_get_fmt,
+	.set_fmt	= s5k6a3_set_fmt,
+};
+
+static int s5k6a3_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+{
+	struct v4l2_mbus_framefmt *format = v4l2_subdev_get_try_format(fh, 0);
+
+	*format		= s5k6a3_formats[0];
+	format->width	= S5K6A3_DEF_PIX_WIDTH;
+	format->height	= S5K6A3_DEF_PIX_HEIGHT;
+
+	return 0;
+}
+
+static const struct v4l2_subdev_internal_ops s5k6a3_sd_internal_ops = {
+	.open = s5k6a3_open,
+};
+
+static int s5k6a3_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct s5k6a3 *sensor = sd_to_s5k6a3(sd);
+	int gpio = sensor->gpio_reset;
+	int ret;
+
+	if (on) {
+		ret = pm_runtime_get(sensor->dev);
+		if (ret < 0)
+			return ret;
+
+		ret = regulator_bulk_enable(S5K6A3_NUM_SUPPLIES,
+					    sensor->supplies);
+		if (ret < 0) {
+			pm_runtime_put(sensor->dev);
+			return ret;
+		}
+
+		if (gpio_is_valid(gpio)) {
+			gpio_set_value(gpio, 1);
+			usleep_range(600, 800);
+			gpio_set_value(gpio, 0);
+			usleep_range(10000, 11000);
+			gpio_set_value(gpio, 1);
+		}
+
+		/* Delay needed for the sensor initialization */
+		msleep(20);
+	} else {
+		if (gpio_is_valid(gpio))
+			gpio_set_value(gpio, 0);
+
+		ret = regulator_bulk_disable(S5K6A3_NUM_SUPPLIES,
+					     sensor->supplies);
+		if (!ret)
+			pm_runtime_put(sensor->dev);
+	}
+	return ret;
+}
+
+static struct v4l2_subdev_core_ops s5k6a3_core_ops = {
+	.s_power = s5k6a3_s_power,
+};
+
+static struct v4l2_subdev_ops s5k6a3_subdev_ops = {
+	.core = &s5k6a3_core_ops,
+	.pad = &s5k6a3_pad_ops,
+};
+
+static int s5k6a3_probe(struct i2c_client *client,
+				const struct i2c_device_id *id)
+{
+	struct device *dev = &client->dev;
+	struct s5k6a3 *sensor;
+	struct v4l2_subdev *sd;
+	int gpio, i, ret;
+
+	sensor = devm_kzalloc(dev, sizeof(*sensor), GFP_KERNEL);
+	if (!sensor)
+		return -ENOMEM;
+
+	mutex_init(&sensor->lock);
+	sensor->gpio_reset = -EINVAL;
+	sensor->dev = dev;
+
+	gpio = of_get_gpio_flags(dev->of_node, 0, NULL);
+	if (gpio_is_valid(gpio)) {
+		ret = devm_gpio_request_one(dev, gpio, GPIOF_OUT_INIT_LOW,
+							S5K6A3_DRV_NAME);
+		if (ret < 0)
+			return ret;
+	}
+	sensor->gpio_reset = gpio;
+
+	for (i = 0; i < S5K6A3_NUM_SUPPLIES; i++)
+		sensor->supplies[i].supply = s5k6a3_supply_names[i];
+
+	ret = devm_regulator_bulk_get(&client->dev, S5K6A3_NUM_SUPPLIES,
+				      sensor->supplies);
+	if (ret < 0)
+		return ret;
+
+	sd = &sensor->subdev;
+	v4l2_i2c_subdev_init(sd, client, &s5k6a3_subdev_ops);
+	snprintf(sd->name, sizeof(sd->name), S5K6A3_DRV_NAME);
+	sensor->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+
+	sensor->format.code = s5k6a3_formats[0].code;
+	sensor->format.width = S5K6A3_DEF_PIX_WIDTH;
+	sensor->format.height = S5K6A3_DEF_PIX_HEIGHT;
+
+	sensor->pad.flags = MEDIA_PAD_FL_SOURCE;
+	ret = media_entity_init(&sd->entity, 1, &sensor->pad, 0);
+	if (ret < 0)
+		return ret;
+
+	pm_runtime_no_callbacks(dev);
+	pm_runtime_enable(dev);
+
+	return 0;
+}
+
+static int s5k6a3_remove(struct i2c_client *client)
+{
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	media_entity_cleanup(&sd->entity);
+	return 0;
+}
+
+static const struct i2c_device_id s5k6a3_ids[] = {
+	{ }
+};
+
+#ifdef CONFIG_OF
+static const struct of_device_id s5k6a3_of_match[] = {
+	{ .compatible = "samsung,s5k6a3" },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, s5k6a3_of_match);
+#endif
+
+static struct i2c_driver s5k6a3_driver = {
+	.driver = {
+		.of_match_table	= of_match_ptr(s5k6a3_of_match),
+		.name		= S5K6A3_DRV_NAME,
+		.owner		= THIS_MODULE,
+	},
+	.probe		= s5k6a3_probe,
+	.remove		= s5k6a3_remove,
+	.id_table	= s5k6a3_ids,
+};
+
+module_i2c_driver(s5k6a3_driver);
+
+MODULE_DESCRIPTION("S5K6A3 image sensor subdev driver");
+MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
+MODULE_LICENSE("GPL v2");
-- 
1.7.9.5

