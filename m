Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:61032 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934226AbcHaNCb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Aug 2016 09:02:31 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org, sre@kernel.org
Subject: [PATCH v1.1 6/6] smiapp: Remove set_xclk() callback from hwconfig
Date: Wed, 31 Aug 2016 16:01:37 +0300
Message-Id: <1472648497-26658-1-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1472629325-30875-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1472629325-30875-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The clock framework is generally so well supported that there's no reason
to keep this one around.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 49 ++++++++++++----------------------
 include/media/i2c/smiapp.h             |  2 --
 2 files changed, 17 insertions(+), 34 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 1ecc9a4..05ab0d0 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -1201,11 +1201,7 @@ static int smiapp_power_on(struct smiapp_sensor *sensor)
 	}
 	usleep_range(1000, 1000);
 
-	if (sensor->hwcfg->set_xclk)
-		rval = sensor->hwcfg->set_xclk(
-			&sensor->src->sd, sensor->hwcfg->ext_clk);
-	else
-		rval = clk_prepare_enable(sensor->ext_clk);
+	rval = clk_prepare_enable(sensor->ext_clk);
 	if (rval < 0) {
 		dev_dbg(&client->dev, "failed to enable xclk\n");
 		goto out_xclk_fail;
@@ -1322,10 +1318,7 @@ static int smiapp_power_on(struct smiapp_sensor *sensor)
 
 out_cci_addr_fail:
 	gpiod_set_value(sensor->xshutdown, 0);
-	if (sensor->hwcfg->set_xclk)
-		sensor->hwcfg->set_xclk(&sensor->src->sd, 0);
-	else
-		clk_disable_unprepare(sensor->ext_clk);
+	clk_disable_unprepare(sensor->ext_clk);
 
 out_xclk_fail:
 	regulator_disable(sensor->vana);
@@ -1347,10 +1340,7 @@ static void smiapp_power_off(struct smiapp_sensor *sensor)
 			     SMIAPP_SOFTWARE_RESET);
 
 	gpiod_set_value(sensor->xshutdown, 0);
-	if (sensor->hwcfg->set_xclk)
-		sensor->hwcfg->set_xclk(&sensor->src->sd, 0);
-	else
-		clk_disable_unprepare(sensor->ext_clk);
+	clk_disable_unprepare(sensor->ext_clk);
 	usleep_range(5000, 5000);
 	regulator_disable(sensor->vana);
 	sensor->streaming = false;
@@ -2551,22 +2541,20 @@ static int smiapp_init(struct smiapp_sensor *sensor)
 		return PTR_ERR(sensor->vana);
 	}
 
-	if (!sensor->hwcfg->set_xclk) {
-		sensor->ext_clk = devm_clk_get(&client->dev, NULL);
-		if (IS_ERR(sensor->ext_clk)) {
-			dev_err(&client->dev, "could not get clock (%ld)\n",
-				PTR_ERR(sensor->ext_clk));
-			return -EPROBE_DEFER;
-		}
+	sensor->ext_clk = devm_clk_get(&client->dev, NULL);
+	if (IS_ERR(sensor->ext_clk)) {
+		dev_err(&client->dev, "could not get clock (%ld)\n",
+			PTR_ERR(sensor->ext_clk));
+		return -EPROBE_DEFER;
+	}
 
-		rval = clk_set_rate(sensor->ext_clk,
-				    sensor->hwcfg->ext_clk);
-		if (rval < 0) {
-			dev_err(&client->dev,
-				"unable to set clock freq to %u\n",
-				sensor->hwcfg->ext_clk);
-			return rval;
-		}
+	rval = clk_set_rate(sensor->ext_clk,
+			    sensor->hwcfg->ext_clk);
+	if (rval < 0) {
+		dev_err(&client->dev,
+			"unable to set clock freq to %u\n",
+			sensor->hwcfg->ext_clk);
+		return rval;
 	}
 
 	sensor->xshutdown = devm_gpiod_get_optional(&client->dev, "xshutdown",
@@ -3108,10 +3096,7 @@ static int smiapp_remove(struct i2c_client *client)
 
 	if (sensor->power_count) {
 		gpiod_set_value(sensor->xshutdown, 0);
-		if (sensor->hwcfg->set_xclk)
-			sensor->hwcfg->set_xclk(&sensor->src->sd, 0);
-		else
-			clk_disable_unprepare(sensor->ext_clk);
+		clk_disable_unprepare(sensor->ext_clk);
 		sensor->power_count = 0;
 	}
 
diff --git a/include/media/i2c/smiapp.h b/include/media/i2c/smiapp.h
index eacc3f4..635007e 100644
--- a/include/media/i2c/smiapp.h
+++ b/include/media/i2c/smiapp.h
@@ -73,8 +73,6 @@ struct smiapp_hwconfig {
 	enum smiapp_module_board_orient module_board_orient;
 
 	struct smiapp_flash_strobe_parms *strobe_setup;
-
-	int (*set_xclk)(struct v4l2_subdev *sd, int hz);
 };
 
 #endif /* __SMIAPP_H_  */
-- 
2.7.4

