Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:61614 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755822Ab3H2Jdj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Aug 2013 05:33:39 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: mturquette@linaro.org, g.liakhovetski@gmx.de,
	laurent.pinchart@ideasonboard.com, arun.kk@samsung.com,
	hverkuil@xs4all.nl, sakari.ailus@iki.fi, a.hajda@samsung.com,
	kyungmin.park@samsung.com, t.figa@samsung.com,
	linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RESEND PATCH v2 4/7] V4L: s5k6a3: Add support for asynchronous subdev
 registration
Date: Thu, 29 Aug 2013 11:32:48 +0200
Message-id: <1377768768-16013-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch converts the driver to use v4l2 asynchronous subdev
registration API an the clock API to control the external master
clock directly.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/i2c/s5k6a3.c |   36 ++++++++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 10 deletions(-)

diff --git a/drivers/media/i2c/s5k6a3.c b/drivers/media/i2c/s5k6a3.c
index ba86e24..f65a4f8 100644
--- a/drivers/media/i2c/s5k6a3.c
+++ b/drivers/media/i2c/s5k6a3.c
@@ -34,6 +34,7 @@
 #define S5K6A3_DEFAULT_HEIGHT		732
 
 #define S5K6A3_DRV_NAME			"S5K6A3"
+#define S5K6A3_CLK_NAME			"extclk"
 #define S5K6A3_DEFAULT_CLK_FREQ		24000000U
 
 #define S5K6A3_NUM_SUPPLIES		2
@@ -56,6 +57,7 @@ struct s5k6a3 {
 	int gpio_reset;
 	struct mutex lock;
 	struct v4l2_mbus_framefmt format;
+	struct clk *clock;
 	u32 clock_frequency;
 };
 
@@ -181,19 +183,25 @@ static int s5k6a3_s_power(struct v4l2_subdev *sd, int on)
 {
 	struct s5k6a3 *sensor = sd_to_s5k6a3(sd);
 	int gpio = sensor->gpio_reset;
-	int ret;
+	int ret = 0;
 
 	if (on) {
+		ret = clk_set_rate(sensor->clock, sensor->clock_frequency);
+		if (ret < 0)
+			return ret;
+
 		ret = pm_runtime_get(sensor->dev);
 		if (ret < 0)
 			return ret;
 
 		ret = regulator_bulk_enable(S5K6A3_NUM_SUPPLIES,
 					    sensor->supplies);
-		if (ret < 0) {
-			pm_runtime_put(sensor->dev);
-			return ret;
-		}
+		if (ret < 0)
+			goto rpm_put;
+
+		ret = clk_prepare_enable(sensor->clock);
+		if (ret < 0)
+			goto reg_dis;
 
 		if (gpio_is_valid(gpio)) {
 			gpio_set_value(gpio, 1);
@@ -209,10 +217,12 @@ static int s5k6a3_s_power(struct v4l2_subdev *sd, int on)
 		if (gpio_is_valid(gpio))
 			gpio_set_value(gpio, 0);
 
-		ret = regulator_bulk_disable(S5K6A3_NUM_SUPPLIES,
-					     sensor->supplies);
-		if (!ret)
-			pm_runtime_put(sensor->dev);
+		clk_disable_unprepare(sensor->clock);
+reg_dis:
+		regulator_bulk_disable(S5K6A3_NUM_SUPPLIES,
+						sensor->supplies);
+rpm_put:
+		pm_runtime_put(sensor->dev);
 	}
 	return ret;
 }
@@ -240,6 +250,7 @@ static int s5k6a3_probe(struct i2c_client *client,
 
 	mutex_init(&sensor->lock);
 	sensor->gpio_reset = -EINVAL;
+	sensor->clock = ERR_PTR(-EINVAL);
 	sensor->dev = dev;
 
 	gpio = of_get_gpio_flags(dev->of_node, 0, NULL);
@@ -266,6 +277,10 @@ static int s5k6a3_probe(struct i2c_client *client,
 	if (ret < 0)
 		return ret;
 
+	sensor->clock = devm_clk_get(dev, S5K6A3_CLK_NAME);
+	if (IS_ERR(sensor->clock))
+		return -EPROBE_DEFER;
+
 	sd = &sensor->subdev;
 	v4l2_i2c_subdev_init(sd, client, &s5k6a3_subdev_ops);
 	sensor->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
@@ -282,7 +297,7 @@ static int s5k6a3_probe(struct i2c_client *client,
 	pm_runtime_no_callbacks(dev);
 	pm_runtime_enable(dev);
 
-	return 0;
+	return v4l2_async_register_subdev(sd);
 }
 
 static int s5k6a3_remove(struct i2c_client *client)
@@ -290,6 +305,7 @@ static int s5k6a3_remove(struct i2c_client *client)
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 
 	pm_runtime_disable(&client->dev);
+	v4l2_async_unregister_subdev(sd);
 	media_entity_cleanup(&sd->entity);
 	return 0;
 }
-- 
1.7.9.5

