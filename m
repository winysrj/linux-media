Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:22540 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757993Ab2EQQaT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 May 2012 12:30:19 -0400
Received: from maxwell.research.nokia.com (maxwell.research.nokia.com [172.21.199.25])
	by mgw-sa02.nokia.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q4HGUGcd009768
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 17 May 2012 19:30:17 +0300
Received: from lanttu (lanttu-o.localdomain [192.168.239.74])
	by maxwell.research.nokia.com (Postfix) with ESMTPS id C318E1F4C5A
	for <linux-media@vger.kernel.org>; Thu, 17 May 2012 19:30:15 +0300 (EEST)
Received: from sakke by lanttu with local (Exim 4.72)
	(envelope-from <sakari.ailus@maxwell.research.nokia.com>)
	id 1SV3ac-00086M-VR
	for linux-media@vger.kernel.org; Thu, 17 May 2012 19:30:11 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 01/10] smiapp: Allow using external clock from the clock framework
Date: Thu, 17 May 2012 19:30:00 +0300
Message-Id: <1337272209-31061-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <4FB52770.9000400@maxwell.research.nokia.com>
References: <4FB52770.9000400@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of providing a function in platform data, allow also providing the
name of the external clock and use it through the clock framework.

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 drivers/media/video/smiapp/smiapp-core.c |   55 ++++++++++++++++++++++++++----
 drivers/media/video/smiapp/smiapp.h      |    1 +
 include/media/smiapp.h                   |    1 +
 3 files changed, 50 insertions(+), 7 deletions(-)

diff --git a/drivers/media/video/smiapp/smiapp-core.c b/drivers/media/video/smiapp/smiapp-core.c
index a8a1db9..999f3fc 100644
--- a/drivers/media/video/smiapp/smiapp-core.c
+++ b/drivers/media/video/smiapp/smiapp-core.c
@@ -26,6 +26,7 @@
  *
  */
 
+#include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/gpio.h>
@@ -1111,8 +1112,11 @@ static int smiapp_power_on(struct smiapp_sensor *sensor)
 	}
 	usleep_range(1000, 1000);
 
-	rval = sensor->platform_data->set_xclk(&sensor->src->sd,
-					sensor->platform_data->ext_clk);
+	if (sensor->platform_data->set_xclk)
+		rval = sensor->platform_data->set_xclk(
+			&sensor->src->sd, sensor->platform_data->ext_clk);
+	else
+		rval = clk_enable(sensor->ext_clk);
 	if (rval < 0) {
 		dev_dbg(&client->dev, "failed to set xclk\n");
 		goto out_xclk_fail;
@@ -1231,7 +1235,10 @@ static int smiapp_power_on(struct smiapp_sensor *sensor)
 out_cci_addr_fail:
 	if (sensor->platform_data->xshutdown != SMIAPP_NO_XSHUTDOWN)
 		gpio_set_value(sensor->platform_data->xshutdown, 0);
-	sensor->platform_data->set_xclk(&sensor->src->sd, 0);
+	if (sensor->platform_data->set_xclk)
+		sensor->platform_data->set_xclk(&sensor->src->sd, 0);
+	else
+		clk_disable(sensor->ext_clk);
 
 out_xclk_fail:
 	regulator_disable(sensor->vana);
@@ -1256,7 +1263,10 @@ static void smiapp_power_off(struct smiapp_sensor *sensor)
 
 	if (sensor->platform_data->xshutdown != SMIAPP_NO_XSHUTDOWN)
 		gpio_set_value(sensor->platform_data->xshutdown, 0);
-	sensor->platform_data->set_xclk(&sensor->src->sd, 0);
+	if (sensor->platform_data->set_xclk)
+		sensor->platform_data->set_xclk(&sensor->src->sd, 0);
+	else
+		clk_disable(sensor->ext_clk);
 	usleep_range(5000, 5000);
 	regulator_disable(sensor->vana);
 	sensor->streaming = 0;
@@ -2327,6 +2337,28 @@ static int smiapp_registered(struct v4l2_subdev *subdev)
 		return -ENODEV;
 	}
 
+	if (!sensor->platform_data->set_xclk) {
+		sensor->ext_clk = clk_get(&client->dev,
+					  sensor->platform_data->ext_clk_name);
+		if (IS_ERR(sensor->ext_clk)) {
+			dev_err(&client->dev, "could not get clock %s\n",
+				sensor->platform_data->ext_clk_name);
+			rval = -ENODEV;
+			goto out_clk_get;
+		}
+
+		rval = clk_set_rate(sensor->ext_clk,
+				    sensor->platform_data->ext_clk);
+		if (rval < 0) {
+			dev_err(&client->dev,
+				"unable to set clock %s freq to %u\n",
+				sensor->platform_data->ext_clk_name,
+				sensor->platform_data->ext_clk);
+			rval = -ENODEV;
+			goto out_clk_set_rate;
+		}
+	}
+
 	if (sensor->platform_data->xshutdown != SMIAPP_NO_XSHUTDOWN) {
 		if (gpio_request_one(sensor->platform_data->xshutdown, 0,
 				     "SMIA++ xshutdown") != 0) {
@@ -2334,7 +2366,7 @@ static int smiapp_registered(struct v4l2_subdev *subdev)
 				"unable to acquire reset gpio %d\n",
 				sensor->platform_data->xshutdown);
 			rval = -ENODEV;
-			goto out_gpio_request;
+			goto out_clk_set_rate;
 		}
 	}
 
@@ -2589,7 +2621,11 @@ out_smiapp_power_on:
 	if (sensor->platform_data->xshutdown != SMIAPP_NO_XSHUTDOWN)
 		gpio_free(sensor->platform_data->xshutdown);
 
-out_gpio_request:
+out_clk_set_rate:
+	clk_put(sensor->ext_clk);
+	sensor->ext_clk = NULL;
+
+out_clk_get:
 	regulator_put(sensor->vana);
 	sensor->vana = NULL;
 	return rval;
@@ -2778,7 +2814,10 @@ static int __exit smiapp_remove(struct i2c_client *client)
 	if (sensor->power_count) {
 		if (sensor->platform_data->xshutdown != SMIAPP_NO_XSHUTDOWN)
 			gpio_set_value(sensor->platform_data->xshutdown, 0);
-		sensor->platform_data->set_xclk(&sensor->src->sd, 0);
+		if (sensor->platform_data->set_xclk)
+			sensor->platform_data->set_xclk(&sensor->src->sd, 0);
+		else
+			clk_disable(sensor->ext_clk);
 		sensor->power_count = 0;
 	}
 
@@ -2794,6 +2833,8 @@ static int __exit smiapp_remove(struct i2c_client *client)
 	smiapp_free_controls(sensor);
 	if (sensor->platform_data->xshutdown != SMIAPP_NO_XSHUTDOWN)
 		gpio_free(sensor->platform_data->xshutdown);
+	if (sensor->ext_clk)
+		clk_put(sensor->ext_clk);
 	if (sensor->vana)
 		regulator_put(sensor->vana);
 
diff --git a/drivers/media/video/smiapp/smiapp.h b/drivers/media/video/smiapp/smiapp.h
index 35b9216..587f7f1 100644
--- a/drivers/media/video/smiapp/smiapp.h
+++ b/drivers/media/video/smiapp/smiapp.h
@@ -198,6 +198,7 @@ struct smiapp_sensor {
 	struct smiapp_subdev *pixel_array;
 	struct smiapp_platform_data *platform_data;
 	struct regulator *vana;
+	struct clk *ext_clk;
 	u32 limits[SMIAPP_LIMIT_LAST];
 	u8 nbinning_subtypes;
 	struct smiapp_binning_subtype binning_subtypes[SMIAPP_BINNING_SUBTYPES];
diff --git a/include/media/smiapp.h b/include/media/smiapp.h
index a7877cd..9ab07fd 100644
--- a/include/media/smiapp.h
+++ b/include/media/smiapp.h
@@ -77,6 +77,7 @@ struct smiapp_platform_data {
 	struct smiapp_flash_strobe_parms *strobe_setup;
 
 	int (*set_xclk)(struct v4l2_subdev *sd, int hz);
+	char *ext_clk_name;
 	int xshutdown;			/* gpio or SMIAPP_NO_XSHUTDOWN */
 };
 
-- 
1.7.2.5

