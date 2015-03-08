Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35653 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbbCHNko (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Mar 2015 09:40:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Lad Prabhakar <prabhakar.csengg@gmail.com>
Subject: [PATCH] v4l: mt9p031: Convert to the gpiod API
Date: Sun,  8 Mar 2015 15:40:43 +0200
Message-Id: <1425822043-18733-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This simplifies platform data and DT integration.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/mt9p031.c | 31 +++++++++++--------------------
 include/media/mt9p031.h     |  2 --
 2 files changed, 11 insertions(+), 22 deletions(-)

diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
index 89ae2b4..1757ef6 100644
--- a/drivers/media/i2c/mt9p031.c
+++ b/drivers/media/i2c/mt9p031.c
@@ -15,12 +15,11 @@
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/device.h>
-#include <linux/gpio.h>
+#include <linux/gpio/consumer.h>
 #include <linux/i2c.h>
 #include <linux/log2.h>
 #include <linux/module.h>
 #include <linux/of.h>
-#include <linux/of_gpio.h>
 #include <linux/of_graph.h>
 #include <linux/pm.h>
 #include <linux/regulator/consumer.h>
@@ -136,7 +135,7 @@ struct mt9p031 {
 	struct aptina_pll pll;
 	unsigned int clk_div;
 	bool use_pll;
-	int reset;
+	struct gpio_desc *reset;
 
 	struct v4l2_ctrl_handler ctrls;
 	struct v4l2_ctrl *blc_auto;
@@ -309,9 +308,9 @@ static int mt9p031_power_on(struct mt9p031 *mt9p031)
 {
 	int ret;
 
-	/* Ensure RESET_BAR is low */
-	if (gpio_is_valid(mt9p031->reset)) {
-		gpio_set_value(mt9p031->reset, 0);
+	/* Ensure RESET_BAR is active */
+	if (mt9p031->reset) {
+		gpiod_set_value(mt9p031->reset, 1);
 		usleep_range(1000, 2000);
 	}
 
@@ -332,8 +331,8 @@ static int mt9p031_power_on(struct mt9p031 *mt9p031)
 	}
 
 	/* Now RESET_BAR must be high */
-	if (gpio_is_valid(mt9p031->reset)) {
-		gpio_set_value(mt9p031->reset, 1);
+	if (mt9p031->reset) {
+		gpiod_set_value(mt9p031->reset, 0);
 		usleep_range(1000, 2000);
 	}
 
@@ -342,8 +341,8 @@ static int mt9p031_power_on(struct mt9p031 *mt9p031)
 
 static void mt9p031_power_off(struct mt9p031 *mt9p031)
 {
-	if (gpio_is_valid(mt9p031->reset)) {
-		gpio_set_value(mt9p031->reset, 0);
+	if (mt9p031->reset) {
+		gpiod_set_value(mt9p031->reset, 1);
 		usleep_range(1000, 2000);
 	}
 
@@ -1023,7 +1022,6 @@ mt9p031_get_pdata(struct i2c_client *client)
 	if (!pdata)
 		goto done;
 
-	pdata->reset = of_get_named_gpio(client->dev.of_node, "reset-gpios", 0);
 	of_property_read_u32(np, "input-clock-frequency", &pdata->ext_freq);
 	of_property_read_u32(np, "pixel-clock-frequency", &pdata->target_freq);
 
@@ -1060,7 +1058,6 @@ static int mt9p031_probe(struct i2c_client *client,
 	mt9p031->output_control	= MT9P031_OUTPUT_CONTROL_DEF;
 	mt9p031->mode2 = MT9P031_READ_MODE_2_ROW_BLC;
 	mt9p031->model = did->driver_data;
-	mt9p031->reset = -1;
 
 	mt9p031->regulators[0].supply = "vdd";
 	mt9p031->regulators[1].supply = "vdd_io";
@@ -1136,14 +1133,8 @@ static int mt9p031_probe(struct i2c_client *client,
 	mt9p031->format.field = V4L2_FIELD_NONE;
 	mt9p031->format.colorspace = V4L2_COLORSPACE_SRGB;
 
-	if (gpio_is_valid(pdata->reset)) {
-		ret = devm_gpio_request_one(&client->dev, pdata->reset,
-					    GPIOF_OUT_INIT_LOW, "mt9p031_rst");
-		if (ret < 0)
-			goto done;
-
-		mt9p031->reset = pdata->reset;
-	}
+	mt9p031->reset = devm_gpiod_get_optional(&client->dev, "reset",
+						 GPIOD_OUT_HIGH);
 
 	ret = mt9p031_clk_setup(mt9p031);
 	if (ret)
diff --git a/include/media/mt9p031.h b/include/media/mt9p031.h
index b1e63f2..1ba3612 100644
--- a/include/media/mt9p031.h
+++ b/include/media/mt9p031.h
@@ -5,12 +5,10 @@ struct v4l2_subdev;
 
 /*
  * struct mt9p031_platform_data - MT9P031 platform data
- * @reset: Chip reset GPIO (set to -1 if not used)
  * @ext_freq: Input clock frequency
  * @target_freq: Pixel clock frequency
  */
 struct mt9p031_platform_data {
-	int reset;
 	int ext_freq;
 	int target_freq;
 };
-- 
Regards,

Laurent Pinchart

