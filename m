Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44032 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752701Ab3HJRnn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Aug 2013 13:43:43 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: andriy.shevchenko@intel.com, laurent.pinchart@ideasonboard.com
Subject: [PATCH 3/4] smiapp: Prepare and unprepare clocks correctly
Date: Sat, 10 Aug 2013 20:49:47 +0300
Message-Id: <1376156988-4009-4-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1376156988-4009-1-git-send-email-sakari.ailus@iki.fi>
References: <1376156988-4009-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Prepare clocks before enabling and unprepare after disabling them.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/i2c/smiapp/smiapp-core.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 4d7ba54..7de9892 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -1122,9 +1122,9 @@ static int smiapp_power_on(struct smiapp_sensor *sensor)
 		rval = sensor->platform_data->set_xclk(
 			&sensor->src->sd, sensor->platform_data->ext_clk);
 	else
-		rval = clk_enable(sensor->ext_clk);
+		rval = clk_prepare_enable(sensor->ext_clk);
 	if (rval < 0) {
-		dev_dbg(&client->dev, "failed to set xclk\n");
+		dev_dbg(&client->dev, "failed to enable xclk\n");
 		goto out_xclk_fail;
 	}
 	usleep_range(1000, 1000);
@@ -1244,7 +1244,7 @@ out_cci_addr_fail:
 	if (sensor->platform_data->set_xclk)
 		sensor->platform_data->set_xclk(&sensor->src->sd, 0);
 	else
-		clk_disable(sensor->ext_clk);
+		clk_disable_unprepare(sensor->ext_clk);
 
 out_xclk_fail:
 	regulator_disable(sensor->vana);
@@ -1270,7 +1270,7 @@ static void smiapp_power_off(struct smiapp_sensor *sensor)
 	if (sensor->platform_data->set_xclk)
 		sensor->platform_data->set_xclk(&sensor->src->sd, 0);
 	else
-		clk_disable(sensor->ext_clk);
+		clk_disable_unprepare(sensor->ext_clk);
 	usleep_range(5000, 5000);
 	regulator_disable(sensor->vana);
 	sensor->streaming = 0;
@@ -2839,7 +2839,7 @@ static int smiapp_remove(struct i2c_client *client)
 		if (sensor->platform_data->set_xclk)
 			sensor->platform_data->set_xclk(&sensor->src->sd, 0);
 		else
-			clk_disable(sensor->ext_clk);
+			clk_disable_unprepare(sensor->ext_clk);
 		sensor->power_count = 0;
 	}
 
-- 
1.7.10.4

