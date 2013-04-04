Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40518 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756642Ab3DDLHz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Apr 2013 07:07:55 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi, Mike Turquette <mturquette@linaro.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 2/2] mt9p031: Use the common clock framework
Date: Thu,  4 Apr 2013 13:08:39 +0200
Message-Id: <1365073719-8038-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1365073719-8038-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1365073719-8038-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Configure the device external clock using the common clock framework
instead of a board code callback function.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/mt9p031.c | 22 +++++++++++++++-------
 include/media/mt9p031.h     |  2 --
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
index e328332..825cc2d 100644
--- a/drivers/media/i2c/mt9p031.c
+++ b/drivers/media/i2c/mt9p031.c
@@ -12,6 +12,7 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/gpio.h>
@@ -121,6 +122,8 @@ struct mt9p031 {
 	struct mutex power_lock; /* lock to protect power_count */
 	int power_count;
 
+	struct clk *clk;
+
 	enum mt9p031_model model;
 	struct aptina_pll pll;
 	int reset;
@@ -195,7 +198,7 @@ static int mt9p031_reset(struct mt9p031 *mt9p031)
 					  0);
 }
 
-static int mt9p031_pll_setup(struct mt9p031 *mt9p031)
+static int mt9p031_clk_setup(struct mt9p031 *mt9p031)
 {
 	static const struct aptina_pll_limits limits = {
 		.ext_clock_min = 6000000,
@@ -216,6 +219,12 @@ static int mt9p031_pll_setup(struct mt9p031 *mt9p031)
 	struct i2c_client *client = v4l2_get_subdevdata(&mt9p031->subdev);
 	struct mt9p031_platform_data *pdata = mt9p031->pdata;
 
+	mt9p031->clk = devm_clk_get(&client->dev, NULL);
+	if (IS_ERR(mt9p031->clk))
+		return PTR_ERR(mt9p031->clk);
+
+	clk_set_rate(mt9p031->clk, pdata->ext_freq);
+
 	mt9p031->pll.ext_clock = pdata->ext_freq;
 	mt9p031->pll.pix_clock = pdata->target_freq;
 
@@ -265,9 +274,8 @@ static int mt9p031_power_on(struct mt9p031 *mt9p031)
 	}
 
 	/* Emable clock */
-	if (mt9p031->pdata->set_xclk)
-		mt9p031->pdata->set_xclk(&mt9p031->subdev,
-					 mt9p031->pdata->ext_freq);
+	if (mt9p031->clk)
+		clk_prepare_enable(mt9p031->clk);
 
 	/* Now RESET_BAR must be high */
 	if (mt9p031->reset != -1) {
@@ -285,8 +293,8 @@ static void mt9p031_power_off(struct mt9p031 *mt9p031)
 		usleep_range(1000, 2000);
 	}
 
-	if (mt9p031->pdata->set_xclk)
-		mt9p031->pdata->set_xclk(&mt9p031->subdev, 0);
+	if (mt9p031->clk)
+		clk_disable_unprepare(mt9p031->clk);
 }
 
 static int __mt9p031_set_power(struct mt9p031 *mt9p031, bool on)
@@ -1009,7 +1017,7 @@ static int mt9p031_probe(struct i2c_client *client,
 		mt9p031->reset = pdata->reset;
 	}
 
-	ret = mt9p031_pll_setup(mt9p031);
+	ret = mt9p031_clk_setup(mt9p031);
 
 done:
 	if (ret < 0) {
diff --git a/include/media/mt9p031.h b/include/media/mt9p031.h
index 0c97b19..b1e63f2 100644
--- a/include/media/mt9p031.h
+++ b/include/media/mt9p031.h
@@ -5,13 +5,11 @@ struct v4l2_subdev;
 
 /*
  * struct mt9p031_platform_data - MT9P031 platform data
- * @set_xclk: Clock frequency set callback
  * @reset: Chip reset GPIO (set to -1 if not used)
  * @ext_freq: Input clock frequency
  * @target_freq: Pixel clock frequency
  */
 struct mt9p031_platform_data {
-	int (*set_xclk)(struct v4l2_subdev *subdev, int hz);
 	int reset;
 	int ext_freq;
 	int target_freq;
-- 
1.8.1.5

