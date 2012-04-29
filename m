Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40714 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213Ab2D2RNu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Apr 2012 13:13:50 -0400
Received: from localhost.localdomain (unknown [91.178.160.63])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 5624F7D11
	for <linux-media@vger.kernel.org>; Sun, 29 Apr 2012 19:13:48 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/3] mt9p031: Replace the reset board callback by a GPIO number
Date: Sun, 29 Apr 2012 19:14:07 +0200
Message-Id: <1335719648-18239-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1335719648-18239-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1335719648-18239-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the GPIO from the sensor driver instead of calling back to board
code.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/mt9p031.c |   29 +++++++++++++++++++++++------
 include/media/mt9p031.h       |   13 ++++++++++---
 2 files changed, 33 insertions(+), 9 deletions(-)

diff --git a/drivers/media/video/mt9p031.c b/drivers/media/video/mt9p031.c
index 5b8a396..3a93631 100644
--- a/drivers/media/video/mt9p031.c
+++ b/drivers/media/video/mt9p031.c
@@ -14,6 +14,7 @@
 
 #include <linux/delay.h>
 #include <linux/device.h>
+#include <linux/gpio.h>
 #include <linux/module.h>
 #include <linux/i2c.h>
 #include <linux/log2.h>
@@ -116,6 +117,7 @@ struct mt9p031 {
 
 	enum mt9p031_model model;
 	struct aptina_pll pll;
+	int reset;
 
 	/* Registers cache */
 	u16 output_control;
@@ -247,8 +249,8 @@ static inline int mt9p031_pll_disable(struct mt9p031 *mt9p031)
 static int mt9p031_power_on(struct mt9p031 *mt9p031)
 {
 	/* Ensure RESET_BAR is low */
-	if (mt9p031->pdata->reset) {
-		mt9p031->pdata->reset(&mt9p031->subdev, 1);
+	if (mt9p031->reset != -1) {
+		gpio_set_value(mt9p031->reset, 0);
 		usleep_range(1000, 2000);
 	}
 
@@ -258,8 +260,8 @@ static int mt9p031_power_on(struct mt9p031 *mt9p031)
 					 mt9p031->pdata->ext_freq);
 
 	/* Now RESET_BAR must be high */
-	if (mt9p031->pdata->reset) {
-		mt9p031->pdata->reset(&mt9p031->subdev, 0);
+	if (mt9p031->reset != -1) {
+		gpio_set_value(mt9p031->reset, 1);
 		usleep_range(1000, 2000);
 	}
 
@@ -268,8 +270,8 @@ static int mt9p031_power_on(struct mt9p031 *mt9p031)
 
 static void mt9p031_power_off(struct mt9p031 *mt9p031)
 {
-	if (mt9p031->pdata->reset) {
-		mt9p031->pdata->reset(&mt9p031->subdev, 1);
+	if (mt9p031->reset != -1) {
+		gpio_set_value(mt9p031->reset, 0);
 		usleep_range(1000, 2000);
 	}
 
@@ -849,6 +851,7 @@ static int mt9p031_probe(struct i2c_client *client,
 	mt9p031->output_control	= MT9P031_OUTPUT_CONTROL_DEF;
 	mt9p031->mode2 = MT9P031_READ_MODE_2_ROW_BLC;
 	mt9p031->model = did->driver_data;
+	mt9p031->reset = -1;
 
 	v4l2_ctrl_handler_init(&mt9p031->ctrls, ARRAY_SIZE(mt9p031_ctrls) + 4);
 
@@ -899,10 +902,22 @@ static int mt9p031_probe(struct i2c_client *client,
 	mt9p031->format.field = V4L2_FIELD_NONE;
 	mt9p031->format.colorspace = V4L2_COLORSPACE_SRGB;
 
+	if (pdata->reset != -1) {
+		ret = gpio_request_one(pdata->reset, GPIOF_OUT_INIT_LOW,
+				       "mt9p031_rst");
+		if (ret < 0)
+			goto done;
+
+		mt9p031->reset = pdata->reset;
+	}
+
 	ret = mt9p031_pll_setup(mt9p031);
 
 done:
 	if (ret < 0) {
+		if (mt9p031->reset != -1)
+			gpio_free(mt9p031->reset);
+
 		v4l2_ctrl_handler_free(&mt9p031->ctrls);
 		media_entity_cleanup(&mt9p031->subdev.entity);
 		kfree(mt9p031);
@@ -919,6 +934,8 @@ static int mt9p031_remove(struct i2c_client *client)
 	v4l2_ctrl_handler_free(&mt9p031->ctrls);
 	v4l2_device_unregister_subdev(subdev);
 	media_entity_cleanup(&subdev->entity);
+	if (mt9p031->reset != -1)
+		gpio_free(mt9p031->reset);
 	kfree(mt9p031);
 
 	return 0;
diff --git a/include/media/mt9p031.h b/include/media/mt9p031.h
index 5b5090f..0c97b19 100644
--- a/include/media/mt9p031.h
+++ b/include/media/mt9p031.h
@@ -3,11 +3,18 @@
 
 struct v4l2_subdev;
 
+/*
+ * struct mt9p031_platform_data - MT9P031 platform data
+ * @set_xclk: Clock frequency set callback
+ * @reset: Chip reset GPIO (set to -1 if not used)
+ * @ext_freq: Input clock frequency
+ * @target_freq: Pixel clock frequency
+ */
 struct mt9p031_platform_data {
 	int (*set_xclk)(struct v4l2_subdev *subdev, int hz);
-	int (*reset)(struct v4l2_subdev *subdev, int active);
-	int ext_freq; /* input frequency to the mt9p031 for PLL dividers */
-	int target_freq; /* frequency target for the PLL */
+	int reset;
+	int ext_freq;
+	int target_freq;
 };
 
 #endif
-- 
1.7.3.4

