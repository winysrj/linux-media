Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54430 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753370AbaEDA31 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 3 May 2014 20:29:27 -0400
Received: from lanttu.localdomain (salottisipuli.retiisi.org.uk [IPv6:2001:1bc8:102:7fc9::83:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id AF65760096
	for <linux-media@vger.kernel.org>; Sun,  4 May 2014 03:29:24 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/3] smiapp: Check for GPIO validity using gpio_is_valid()
Date: Sun,  4 May 2014 03:31:56 +0300
Message-Id: <1399163517-5220-3-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1399163517-5220-1-git-send-email-sakari.ailus@iki.fi>
References: <1399163517-5220-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Do not use our special value, SMIAPP_NO_XSHUTDOWN.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/i2c/smiapp/smiapp-core.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index c1d6d1d..e4037c8 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -1128,7 +1128,7 @@ static int smiapp_power_on(struct smiapp_sensor *sensor)
 	}
 	usleep_range(1000, 1000);
 
-	if (sensor->platform_data->xshutdown != SMIAPP_NO_XSHUTDOWN)
+	if (gpio_is_valid(sensor->platform_data->xshutdown))
 		gpio_set_value(sensor->platform_data->xshutdown, 1);
 
 	sleep = SMIAPP_RESET_DELAY(sensor->platform_data->ext_clk);
@@ -1238,7 +1238,7 @@ static int smiapp_power_on(struct smiapp_sensor *sensor)
 	return 0;
 
 out_cci_addr_fail:
-	if (sensor->platform_data->xshutdown != SMIAPP_NO_XSHUTDOWN)
+	if (gpio_is_valid(sensor->platform_data->xshutdown))
 		gpio_set_value(sensor->platform_data->xshutdown, 0);
 	if (sensor->platform_data->set_xclk)
 		sensor->platform_data->set_xclk(&sensor->src->sd, 0);
@@ -1264,7 +1264,7 @@ static void smiapp_power_off(struct smiapp_sensor *sensor)
 			     SMIAPP_REG_U8_SOFTWARE_RESET,
 			     SMIAPP_SOFTWARE_RESET);
 
-	if (sensor->platform_data->xshutdown != SMIAPP_NO_XSHUTDOWN)
+	if (gpio_is_valid(sensor->platform_data->xshutdown))
 		gpio_set_value(sensor->platform_data->xshutdown, 0);
 	if (sensor->platform_data->set_xclk)
 		sensor->platform_data->set_xclk(&sensor->src->sd, 0);
@@ -2378,7 +2378,7 @@ static int smiapp_registered(struct v4l2_subdev *subdev)
 		}
 	}
 
-	if (sensor->platform_data->xshutdown != SMIAPP_NO_XSHUTDOWN) {
+	if (gpio_is_valid(sensor->platform_data->xshutdown)) {
 		if (devm_gpio_request_one(&client->dev,
 					  sensor->platform_data->xshutdown, 0,
 					  "SMIA++ xshutdown") != 0) {
@@ -2830,7 +2830,7 @@ static int smiapp_remove(struct i2c_client *client)
 	unsigned int i;
 
 	if (sensor->power_count) {
-		if (sensor->platform_data->xshutdown != SMIAPP_NO_XSHUTDOWN)
+		if (gpio_is_valid(sensor->platform_data->xshutdown))
 			gpio_set_value(sensor->platform_data->xshutdown, 0);
 		if (sensor->platform_data->set_xclk)
 			sensor->platform_data->set_xclk(&sensor->src->sd, 0);
-- 
1.7.10.4

