Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:24103 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030765Ab3HITZW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Aug 2013 15:25:22 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: a.hajda@samsung.com, arun.kk@samsung.com,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 02/10] V4L: s5k6a3: Add support for asynchronous subdev
 registration
Date: Fri, 09 Aug 2013 21:24:04 +0200
Message-id: <1376076252-30150-2-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1376076252-30150-1-git-send-email-s.nawrocki@samsung.com>
References: <1376076122-29963-1-git-send-email-s.nawrocki@samsung.com>
 <1376076252-30150-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch converts the driver to use v4l2 asynchronous subdev
registration API an the common clock API.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Changes since v1:
 - clock-frequency property is now optional and a default frequency
   value will be used when it is missing, rather than bailing out.
---
 drivers/media/i2c/s5k6a3.c |   63 ++++++++++++++++++++++++++++++++++++--------
 1 file changed, 52 insertions(+), 11 deletions(-)

diff --git a/drivers/media/i2c/s5k6a3.c b/drivers/media/i2c/s5k6a3.c
index 0817664..d396cfe 100644
--- a/drivers/media/i2c/s5k6a3.c
+++ b/drivers/media/i2c/s5k6a3.c
@@ -34,6 +34,8 @@
 #define S5K6A3_DEFAULT_HEIGHT		732
 
 #define S5K6A3_DRV_NAME			"S5K6A3"
+#define S5K6A3_CLK_NAME			"mclk"
+#define S5K6A3_DEFAULT_CLK_FREQ		24000000U
 
 #define S5K6A3_NUM_SUPPLIES		2
 
@@ -55,6 +57,7 @@ struct s5k6a3 {
 	int gpio_reset;
 	struct mutex lock;
 	struct v4l2_mbus_framefmt format;
+	struct clk *clock;
 	u32 clock_frequency;
 };
 
@@ -180,19 +183,29 @@ static int s5k6a3_s_power(struct v4l2_subdev *sd, int on)
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
@@ -208,10 +221,14 @@ static int s5k6a3_s_power(struct v4l2_subdev *sd, int on)
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
@@ -239,6 +256,7 @@ static int s5k6a3_probe(struct i2c_client *client,
 
 	mutex_init(&sensor->lock);
 	sensor->gpio_reset = -EINVAL;
+	sensor->clock = ERR_PTR(-EINVAL);
 	sensor->dev = dev;
 
 	gpio = of_get_gpio_flags(dev->of_node, 0, NULL);
@@ -250,6 +268,13 @@ static int s5k6a3_probe(struct i2c_client *client,
 	}
 	sensor->gpio_reset = gpio;
 
+	if (of_property_read_u32(dev->of_node, "clock-frequency",
+				 &sensor->clock_frequency)) {
+		sensor->clock_frequency = S5K6A3_DEFAULT_CLK_FREQ;
+		dev_info(dev, "using default %u Hz clock frequency\n",
+					sensor->clock_frequency);
+	}
+
 	for (i = 0; i < S5K6A3_NUM_SUPPLIES; i++)
 		sensor->supplies[i].supply = s5k6a3_supply_names[i];
 
@@ -258,6 +283,11 @@ static int s5k6a3_probe(struct i2c_client *client,
 	if (ret < 0)
 		return ret;
 
+	/* Defer probing if the clock is not available yet */
+	sensor->clock = clk_get(dev, S5K6A3_CLK_NAME);
+	if (IS_ERR(sensor->clock))
+		return -EPROBE_DEFER;
+
 	sd = &sensor->subdev;
 	v4l2_i2c_subdev_init(sd, client, &s5k6a3_subdev_ops);
 	sensor->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
@@ -274,7 +304,17 @@ static int s5k6a3_probe(struct i2c_client *client,
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
@@ -282,6 +322,7 @@ static int s5k6a3_remove(struct i2c_client *client)
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 
 	pm_runtime_disable(&client->dev);
+	v4l2_async_unregister_subdev(sd);
 	media_entity_cleanup(&sd->entity);
 	return 0;
 }
-- 
1.7.9.5

