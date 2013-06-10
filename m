Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55481 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab3FJJvl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jun 2013 05:51:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Fabio Estevam <festevam@gmail.com>
Subject: [PATCH] mt9p031: Use bulk regulator API
Date: Mon, 10 Jun 2013 11:51:43 +0200
Message-Id: <1370857903-12526-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The sensor is powered by three supplies. Use the bulk regulator API to
enable and disable them instead of performing the operations manually.
This fixes a warning caused by ignoring the return value of
regulator_enable().

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/mt9p031.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

Changes since v1:

- Return the devm_regulator_bulk_get() return code instead of -ENODEV

diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
index 6187416..c93640b 100644
--- a/drivers/media/i2c/mt9p031.c
+++ b/drivers/media/i2c/mt9p031.c
@@ -126,9 +126,7 @@ struct mt9p031 {
 	int power_count;
 
 	struct clk *clk;
-	struct regulator *vaa;
-	struct regulator *vdd;
-	struct regulator *vdd_io;
+	struct regulator_bulk_data regulators[3];
 
 	enum mt9p031_model model;
 	struct aptina_pll pll;
@@ -273,6 +271,8 @@ static inline int mt9p031_pll_disable(struct mt9p031 *mt9p031)
 
 static int mt9p031_power_on(struct mt9p031 *mt9p031)
 {
+	int ret;
+
 	/* Ensure RESET_BAR is low */
 	if (gpio_is_valid(mt9p031->reset)) {
 		gpio_set_value(mt9p031->reset, 0);
@@ -280,9 +280,10 @@ static int mt9p031_power_on(struct mt9p031 *mt9p031)
 	}
 
 	/* Bring up the supplies */
-	regulator_enable(mt9p031->vdd);
-	regulator_enable(mt9p031->vdd_io);
-	regulator_enable(mt9p031->vaa);
+	ret = regulator_bulk_enable(ARRAY_SIZE(mt9p031->regulators),
+				   mt9p031->regulators);
+	if (ret < 0)
+		return ret;
 
 	/* Emable clock */
 	if (mt9p031->clk)
@@ -304,9 +305,8 @@ static void mt9p031_power_off(struct mt9p031 *mt9p031)
 		usleep_range(1000, 2000);
 	}
 
-	regulator_disable(mt9p031->vaa);
-	regulator_disable(mt9p031->vdd_io);
-	regulator_disable(mt9p031->vdd);
+	regulator_bulk_disable(ARRAY_SIZE(mt9p031->regulators),
+			       mt9p031->regulators);
 
 	if (mt9p031->clk)
 		clk_disable_unprepare(mt9p031->clk);
@@ -986,14 +986,14 @@ static int mt9p031_probe(struct i2c_client *client,
 	mt9p031->model = did->driver_data;
 	mt9p031->reset = -1;
 
-	mt9p031->vaa = devm_regulator_get(&client->dev, "vaa");
-	mt9p031->vdd = devm_regulator_get(&client->dev, "vdd");
-	mt9p031->vdd_io = devm_regulator_get(&client->dev, "vdd_io");
+	mt9p031->regulators[0].supply = "vdd";
+	mt9p031->regulators[1].supply = "vdd_io";
+	mt9p031->regulators[2].supply = "vaa";
 
-	if (IS_ERR(mt9p031->vaa) || IS_ERR(mt9p031->vdd) ||
-	    IS_ERR(mt9p031->vdd_io)) {
+	ret = devm_regulator_bulk_get(&client->dev, 3, mt9p031->regulators);
+	if (ret < 0) {
 		dev_err(&client->dev, "Unable to get regulators\n");
-		return -ENODEV;
+		return ret;
 	}
 
 	v4l2_ctrl_handler_init(&mt9p031->ctrls, ARRAY_SIZE(mt9p031_ctrls) + 6);
-- 
Regards,

Laurent Pinchart

