Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:38400 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933577Ab3GWSlY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jul 2013 14:41:24 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, linux-samsung-soc@vger.kernel.org,
	arun.kk@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [REVIEW PATCH 2/6] V4L: s5k6a3: Add support for asynchronous subdev
 registration
Date: Tue, 23 Jul 2013 20:39:33 +0200
Message-id: <1374604777-15523-3-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1374604777-15523-1-git-send-email-s.nawrocki@samsung.com>
References: <1374604777-15523-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch converts the driver to use v4l2 asynchronous subdev
registration API an the common clock API.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/i2c/s5k6a3.c |   63 ++++++++++++++++++++++++++++++++++++--------
 1 file changed, 52 insertions(+), 11 deletions(-)

diff --git a/drivers/media/i2c/s5k6a3.c b/drivers/media/i2c/s5k6a3.c
index 21680fa..ccbb4fc 100644
--- a/drivers/media/i2c/s5k6a3.c
+++ b/drivers/media/i2c/s5k6a3.c
@@ -34,6 +34,7 @@
 #define S5K6A3_DEF_PIX_HEIGHT		732
 
 #define S5K6A3_DRV_NAME			"S5K6A3"
+#define S5K6A3_CLK_NAME			"mclk"
 
 #define S5K6A3_NUM_SUPPLIES		2
 
@@ -55,6 +56,7 @@ struct s5k6a3 {
 	int gpio_reset;
 	struct mutex lock;
 	struct v4l2_mbus_framefmt format;
+	struct clk *clock;
 	u32 clock_frequency;
 };
 
@@ -180,19 +182,29 @@ static int s5k6a3_s_power(struct v4l2_subdev *sd, int on)
 {
 	struct s5k6a3 *sensor = sd_to_s5k6a3(sd);
 	int gpio = sensor->gpio_reset;
-	int ret;
+	int ret = 0;
 
 	if (on) {
+		sensor->clock = clk_get(sensor->dev, S5K6A3_CLK_NAME);
+		if (IS_ERR(sensor->clock))
+			return PTR_ERR(sensor->clock);
+
+		ret = clk_set_rate(sensor->clock, sensor->clock_frequency);
+		if (ret < 0)
+			goto clk_put;
+
 		ret = pm_runtime_get(sensor->dev);
 		if (ret < 0)
-			return ret;
+			goto clk_put;
 
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
@@ -208,10 +220,14 @@ static int s5k6a3_s_power(struct v4l2_subdev *sd, int on)
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
+clk_put:
+		clk_put(sensor->clock);
 	}
 	return ret;
 }
@@ -239,6 +255,7 @@ static int s5k6a3_probe(struct i2c_client *client,
 
 	mutex_init(&sensor->lock);
 	sensor->gpio_reset = -EINVAL;
+	sensor->clock = ERR_PTR(-EINVAL);
 	sensor->dev = dev;
 
 	gpio = of_get_gpio_flags(dev->of_node, 0, NULL);
@@ -250,6 +267,13 @@ static int s5k6a3_probe(struct i2c_client *client,
 	}
 	sensor->gpio_reset = gpio;
 
+	if (of_property_read_u32(dev->of_node, "clock-frequency",
+				 &sensor->clock_frequency)) {
+		dev_err(dev, "clock-frequency property not found at %s\n",
+						dev->of_node->full_name);
+		return -EINVAL;
+	}
+
 	for (i = 0; i < S5K6A3_NUM_SUPPLIES; i++)
 		sensor->supplies[i].supply = s5k6a3_supply_names[i];
 
@@ -258,6 +282,11 @@ static int s5k6a3_probe(struct i2c_client *client,
 	if (ret < 0)
 		return ret;
 
+	/* Defer probing if the clock is not available yet */
+	sensor->clock = clk_get(dev, S5K6A3_CLK_NAME);
+	if (IS_ERR(sensor->clock))
+		return -EPROBE_DEFER;
+
 	sd = &sensor->subdev;
 	v4l2_i2c_subdev_init(sd, client, &s5k6a3_subdev_ops);
 	snprintf(sd->name, sizeof(sd->name), S5K6A3_DRV_NAME);
@@ -275,12 +304,24 @@ static int s5k6a3_probe(struct i2c_client *client,
 	pm_runtime_no_callbacks(dev);
 	pm_runtime_enable(dev);
 
-	return 0;
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
 }
 
 static int s5k6a3_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+
+	v4l2_async_unregister_subdev(sd);
 	media_entity_cleanup(&sd->entity);
 	return 0;
 }
-- 
1.7.9.5

