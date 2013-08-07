Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:38675 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932285Ab3HGJE4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Aug 2013 05:04:56 -0400
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree@vger.kernel.org
Cc: s.nawrocki@samsung.com, hverkuil@xs4all.nl, a.hajda@samsung.com,
	sachin.kamat@linaro.org, shaik.ameer@samsung.com,
	kilyeon.im@samsung.com, arunkk.samsung@gmail.com
Subject: [PATCH v4 13/13] V4L: Add driver for s5k4e5 image sensor
Date: Wed,  7 Aug 2013 14:34:01 +0530
Message-Id: <1375866242-18084-14-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1375866242-18084-1-git-send-email-arun.kk@samsung.com>
References: <1375866242-18084-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds subdev driver for Samsung S5K4E5 raw image sensor.
Like s5k6a3, it is also another fimc-is firmware controlled
sensor. This minimal sensor driver doesn't do any I2C communications
as its done by ISP firmware. It can be updated if needed to a
regular sensor driver by adding the I2C communication.

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 .../devicetree/bindings/media/i2c/s5k4e5.txt       |   44 +++
 drivers/media/i2c/Kconfig                          |    8 +
 drivers/media/i2c/Makefile                         |    1 +
 drivers/media/i2c/s5k4e5.c                         |  361 ++++++++++++++++++++
 4 files changed, 414 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/s5k4e5.txt
 create mode 100644 drivers/media/i2c/s5k4e5.c

diff --git a/Documentation/devicetree/bindings/media/i2c/s5k4e5.txt b/Documentation/devicetree/bindings/media/i2c/s5k4e5.txt
new file mode 100644
index 0000000..88dd726
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/s5k4e5.txt
@@ -0,0 +1,44 @@
+* Samsung S5K4E5 Raw Image Sensor
+
+S5K4E5 is a raw image sensor with maximum resolution of 2560x1920
+pixels. Data transfer is carried out via MIPI-CSI2 port and controls
+via I2C bus.
+
+Required Properties:
+- compatible	: must be "samsung,s5k4e5"
+- reg		: I2C device address
+- gpios		: reset gpio pin
+- clocks	: clock specifier for the clock-names property.
+- clock-names	: must contain "mclk" entry and matching clock property
+                  entry.
+- svdda-supply	: core voltage supply
+- svddio-supply	: I/O voltage supply
+
+Optional Properties:
+- clock-frequency : operating frequency for the sensor
+                    default value will be taken if not provided.
+
+The device node should be added to their control bus controller (e.g.
+I2C0) nodes and linked to the csis port node, using the common video
+interfaces bindings, defined in video-interfaces.txt.
+
+Example:
+
+	i2c-isp@13130000 {
+		s5k4e5@20 {
+			compatible = "samsung,s5k4e5";
+			reg = <0x20>;
+			gpios = <&gpx1 2 1>;
+			clock-frequency = <24000000>;
+			clocks = <&clock 129>;
+			clock-names = "mclk";
+			svdda-supply = <...>;
+			svddio-supply = <...>;
+			port {
+				is_s5k4e5_ep: endpoint {
+					data-lanes = <1 2 3 4>;
+					remote-endpoint = <&csis0_ep>;
+				};
+			};
+		};
+	};
diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index f7e9147..271028b 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -572,6 +572,14 @@ config VIDEO_S5K6A3
 	  This is a V4L2 sensor-level driver for Samsung S5K6A3 raw
 	  camera sensor.
 
+config VIDEO_S5K4E5
+	tristate "Samsung S5K4E5 sensor support"
+	depends on MEDIA_CAMERA_SUPPORT
+	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && OF
+	---help---
+	  This is a V4L2 sensor-level driver for Samsung S5K4E5 raw
+	  camera sensor.
+
 config VIDEO_S5K4ECGX
         tristate "Samsung S5K4ECGX sensor support"
         depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
index cf3cf03..0aeed8e 100644
--- a/drivers/media/i2c/Makefile
+++ b/drivers/media/i2c/Makefile
@@ -65,6 +65,7 @@ obj-$(CONFIG_VIDEO_SR030PC30)	+= sr030pc30.o
 obj-$(CONFIG_VIDEO_NOON010PC30)	+= noon010pc30.o
 obj-$(CONFIG_VIDEO_S5K6AA)	+= s5k6aa.o
 obj-$(CONFIG_VIDEO_S5K6A3)	+= s5k6a3.o
+obj-$(CONFIG_VIDEO_S5K4E5)	+= s5k4e5.o
 obj-$(CONFIG_VIDEO_S5K4ECGX)	+= s5k4ecgx.o
 obj-$(CONFIG_VIDEO_S5C73M3)	+= s5c73m3/
 obj-$(CONFIG_VIDEO_ADP1653)	+= adp1653.o
diff --git a/drivers/media/i2c/s5k4e5.c b/drivers/media/i2c/s5k4e5.c
new file mode 100644
index 0000000..0a6ece6
--- /dev/null
+++ b/drivers/media/i2c/s5k4e5.c
@@ -0,0 +1,361 @@
+/*
+ * Samsung S5K4E5 image sensor driver
+ *
+ * Copyright (C) 2013 Samsung Electronics Co., Ltd.
+ * Author: Arun Kumar K <arun.kk@samsung.com>
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
+#define S5K4E5_SENSOR_MAX_WIDTH		2576
+#define S5K4E5_SENSOR_MAX_HEIGHT	1930
+
+#define S5K4E5_SENSOR_ACTIVE_WIDTH	2560
+#define S5K4E5_SENSOR_ACTIVE_HEIGHT	1920
+
+#define S5K4E5_SENSOR_MIN_WIDTH		(32 + 16)
+#define S5K4E5_SENSOR_MIN_HEIGHT	(32 + 10)
+
+#define S5K4E5_DEF_WIDTH		1296
+#define S5K4E5_DEF_HEIGHT		732
+
+#define S5K4E5_DRV_NAME			"S5K4E5"
+#define S5K4E5_CLK_NAME			"mclk"
+
+#define S5K4E5_NUM_SUPPLIES		2
+
+#define S5K4E5_DEF_CLK_FREQ		24000000
+
+/**
+ * struct s5k4e5 - s5k4e5 sensor data structure
+ * @dev: pointer to this I2C client device structure
+ * @subdev: the image sensor's v4l2 subdev
+ * @pad: subdev media source pad
+ * @supplies: image sensor's voltage regulator supplies
+ * @gpio_reset: GPIO connected to the sensor's reset pin
+ * @lock: mutex protecting the structure's members below
+ * @format: media bus format at the sensor's source pad
+ */
+struct s5k4e5 {
+	struct device *dev;
+	struct v4l2_subdev subdev;
+	struct media_pad pad;
+	struct regulator_bulk_data supplies[S5K4E5_NUM_SUPPLIES];
+	int gpio_reset;
+	struct mutex lock;
+	struct v4l2_mbus_framefmt format;
+	struct clk *clock;
+	u32 clock_frequency;
+};
+
+static const char * const s5k4e5_supply_names[] = {
+	"svdda",
+	"svddio"
+};
+
+static inline struct s5k4e5 *sd_to_s5k4e5(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct s5k4e5, subdev);
+}
+
+static const struct v4l2_mbus_framefmt s5k4e5_formats[] = {
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
+	for (i = 0; i < ARRAY_SIZE(s5k4e5_formats); i++)
+		if (mf->code == s5k4e5_formats[i].code)
+			return &s5k4e5_formats[i];
+
+	return &s5k4e5_formats[0];
+}
+
+static int s5k4e5_enum_mbus_code(struct v4l2_subdev *sd,
+				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_mbus_code_enum *code)
+{
+	if (code->index >= ARRAY_SIZE(s5k4e5_formats))
+		return -EINVAL;
+
+	code->code = s5k4e5_formats[code->index].code;
+	return 0;
+}
+
+static void s5k4e5_try_format(struct v4l2_mbus_framefmt *mf)
+{
+	const struct v4l2_mbus_framefmt *fmt;
+
+	fmt = find_sensor_format(mf);
+	mf->code = fmt->code;
+	v4l_bound_align_image(&mf->width,
+			S5K4E5_SENSOR_MIN_WIDTH, S5K4E5_SENSOR_MAX_WIDTH, 0,
+			&mf->height,
+			S5K4E5_SENSOR_MIN_HEIGHT, S5K4E5_SENSOR_MAX_HEIGHT, 0,
+			0);
+}
+
+static struct v4l2_mbus_framefmt *__s5k4e5_get_format(
+		struct s5k4e5 *sensor, struct v4l2_subdev_fh *fh,
+		u32 pad, enum v4l2_subdev_format_whence which)
+{
+	if (which == V4L2_SUBDEV_FORMAT_TRY)
+		return fh ? v4l2_subdev_get_try_format(fh, pad) : NULL;
+
+	return &sensor->format;
+}
+
+static int s5k4e5_set_fmt(struct v4l2_subdev *sd,
+				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_format *fmt)
+{
+	struct s5k4e5 *sensor = sd_to_s5k4e5(sd);
+	struct v4l2_mbus_framefmt *mf;
+
+	s5k4e5_try_format(&fmt->format);
+
+	mf = __s5k4e5_get_format(sensor, fh, fmt->pad, fmt->which);
+	if (mf) {
+		mutex_lock(&sensor->lock);
+		if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE)
+			*mf = fmt->format;
+		mutex_unlock(&sensor->lock);
+	}
+	return 0;
+}
+
+static int s5k4e5_get_fmt(struct v4l2_subdev *sd,
+				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_format *fmt)
+{
+	struct s5k4e5 *sensor = sd_to_s5k4e5(sd);
+	struct v4l2_mbus_framefmt *mf;
+
+	mf = __s5k4e5_get_format(sensor, fh, fmt->pad, fmt->which);
+
+	mutex_lock(&sensor->lock);
+	fmt->format = *mf;
+	mutex_unlock(&sensor->lock);
+	return 0;
+}
+
+static struct v4l2_subdev_pad_ops s5k4e5_pad_ops = {
+	.enum_mbus_code	= s5k4e5_enum_mbus_code,
+	.get_fmt	= s5k4e5_get_fmt,
+	.set_fmt	= s5k4e5_set_fmt,
+};
+
+static int s5k4e5_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+{
+	struct v4l2_mbus_framefmt *format = v4l2_subdev_get_try_format(fh, 0);
+
+	*format		= s5k4e5_formats[0];
+	format->width	= S5K4E5_DEF_WIDTH;
+	format->height	= S5K4E5_DEF_HEIGHT;
+
+	return 0;
+}
+
+static const struct v4l2_subdev_internal_ops s5k4e5_sd_internal_ops = {
+	.open = s5k4e5_open,
+};
+
+static int s5k4e5_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct s5k4e5 *sensor = sd_to_s5k4e5(sd);
+	int gpio = sensor->gpio_reset;
+	int ret = 0;
+
+	if (on) {
+		sensor->clock = clk_get(sensor->dev, S5K4E5_CLK_NAME);
+		if (IS_ERR(sensor->clock))
+			return PTR_ERR(sensor->clock);
+
+		ret = clk_set_rate(sensor->clock, sensor->clock_frequency);
+		if (ret < 0)
+			goto clk_put;
+
+		ret = pm_runtime_get(sensor->dev);
+		if (ret < 0)
+			goto clk_put;
+
+		ret = regulator_bulk_enable(S5K4E5_NUM_SUPPLIES,
+					    sensor->supplies);
+		if (ret < 0)
+			goto rpm_put;
+
+		ret = clk_prepare_enable(sensor->clock);
+		if (ret < 0)
+			goto reg_dis;
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
+		clk_disable_unprepare(sensor->clock);
+reg_dis:
+		regulator_bulk_disable(S5K4E5_NUM_SUPPLIES,
+						sensor->supplies);
+rpm_put:
+		pm_runtime_put(sensor->dev);
+clk_put:
+		clk_put(sensor->clock);
+	}
+	return ret;
+}
+
+static struct v4l2_subdev_core_ops s5k4e5_core_ops = {
+	.s_power = s5k4e5_s_power,
+};
+
+static struct v4l2_subdev_ops s5k4e5_subdev_ops = {
+	.core = &s5k4e5_core_ops,
+	.pad = &s5k4e5_pad_ops,
+};
+
+static int s5k4e5_probe(struct i2c_client *client,
+				const struct i2c_device_id *id)
+{
+	struct device *dev = &client->dev;
+	struct s5k4e5 *sensor;
+	struct v4l2_subdev *sd;
+	int gpio, i, ret;
+
+	sensor = devm_kzalloc(dev, sizeof(*sensor), GFP_KERNEL);
+	if (!sensor)
+		return -ENOMEM;
+
+	mutex_init(&sensor->lock);
+	sensor->gpio_reset = -EINVAL;
+	sensor->clock = ERR_PTR(-EINVAL);
+	sensor->dev = dev;
+
+	gpio = of_get_gpio_flags(dev->of_node, 0, NULL);
+	if (gpio_is_valid(gpio)) {
+		ret = devm_gpio_request_one(dev, gpio, GPIOF_OUT_INIT_LOW,
+							S5K4E5_DRV_NAME);
+		if (ret < 0)
+			return ret;
+	}
+	sensor->gpio_reset = gpio;
+
+	if (of_property_read_u32(dev->of_node, "clock-frequency",
+				 &sensor->clock_frequency)) {
+		/* Fallback to default value */
+		sensor->clock_frequency = S5K4E5_DEF_CLK_FREQ;
+	}
+
+	for (i = 0; i < S5K4E5_NUM_SUPPLIES; i++)
+		sensor->supplies[i].supply = s5k4e5_supply_names[i];
+
+	ret = devm_regulator_bulk_get(&client->dev, S5K4E5_NUM_SUPPLIES,
+				      sensor->supplies);
+	if (ret < 0)
+		return ret;
+
+	/* Defer probing if the clock is not available yet */
+	sensor->clock = clk_get(dev, S5K4E5_CLK_NAME);
+	if (IS_ERR(sensor->clock))
+		return -EPROBE_DEFER;
+
+	sd = &sensor->subdev;
+	v4l2_i2c_subdev_init(sd, client, &s5k4e5_subdev_ops);
+	sensor->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+
+	sensor->format.code = s5k4e5_formats[0].code;
+	sensor->format.width = S5K4E5_DEF_WIDTH;
+	sensor->format.height = S5K4E5_DEF_HEIGHT;
+
+	sensor->pad.flags = MEDIA_PAD_FL_SOURCE;
+	ret = media_entity_init(&sd->entity, 1, &sensor->pad, 0);
+	if (ret < 0)
+		return ret;
+
+	pm_runtime_no_callbacks(dev);
+	pm_runtime_enable(dev);
+
+	ret = v4l2_async_register_subdev(sd);
+
+	/*
+	 * Don't hold reference to the clock to avoid circular dependency
+	 * between the subdev and the host driver, in case the host is
+	 * a supplier of the clock.
+	 * clk_get()/clk_put() will be called in s_power callback.
+	 */
+	clk_put(sensor->clock);
+
+	return ret;
+}
+
+static int s5k4e5_remove(struct i2c_client *client)
+{
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+
+	v4l2_async_unregister_subdev(sd);
+	media_entity_cleanup(&sd->entity);
+	return 0;
+}
+
+static const struct i2c_device_id s5k4e5_ids[] = {
+	{ }
+};
+
+#ifdef CONFIG_OF
+static const struct of_device_id s5k4e5_of_match[] = {
+	{ .compatible = "samsung,s5k4e5" },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, s5k4e5_of_match);
+#endif
+
+static struct i2c_driver s5k4e5_driver = {
+	.driver = {
+		.of_match_table	= of_match_ptr(s5k4e5_of_match),
+		.name		= S5K4E5_DRV_NAME,
+		.owner		= THIS_MODULE,
+	},
+	.probe		= s5k4e5_probe,
+	.remove		= s5k4e5_remove,
+	.id_table	= s5k4e5_ids,
+};
+
+module_i2c_driver(s5k4e5_driver);
+
+MODULE_DESCRIPTION("S5K4E5 image sensor subdev driver");
+MODULE_AUTHOR("Arun Kumar K <arun.kk@samsung.com>");
+MODULE_LICENSE("GPL v2");
-- 
1.7.9.5

