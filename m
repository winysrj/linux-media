Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44034 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753052Ab3HJRnn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Aug 2013 13:43:43 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: andriy.shevchenko@intel.com, laurent.pinchart@ideasonboard.com
Subject: [PATCH 4/4] smiapp: Call the clock "ext_clk"
Date: Sat, 10 Aug 2013 20:49:48 +0300
Message-Id: <1376156988-4009-5-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1376156988-4009-1-git-send-email-sakari.ailus@iki.fi>
References: <1376156988-4009-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As the clock framework makes it possible to assign a device specific name to
the clocks, remove the ability to use a named clock in the driver.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/i2c/smiapp/smiapp-core.c |    9 +++------
 include/media/smiapp.h                 |    1 -
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 7de9892..ae66d91 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2363,11 +2363,9 @@ static int smiapp_registered(struct v4l2_subdev *subdev)
 	}
 
 	if (!sensor->platform_data->set_xclk) {
-		sensor->ext_clk = devm_clk_get(&client->dev,
-					sensor->platform_data->ext_clk_name);
+		sensor->ext_clk = devm_clk_get(&client->dev, "ext_clk");
 		if (IS_ERR(sensor->ext_clk)) {
-			dev_err(&client->dev, "could not get clock %s\n",
-				sensor->platform_data->ext_clk_name);
+			dev_err(&client->dev, "could not get clock\n");
 			return -ENODEV;
 		}
 
@@ -2375,8 +2373,7 @@ static int smiapp_registered(struct v4l2_subdev *subdev)
 				    sensor->platform_data->ext_clk);
 		if (rval < 0) {
 			dev_err(&client->dev,
-				"unable to set clock %s freq to %u\n",
-				sensor->platform_data->ext_clk_name,
+				"unable to set clock freq to %u\n",
 				sensor->platform_data->ext_clk);
 			return -ENODEV;
 		}
diff --git a/include/media/smiapp.h b/include/media/smiapp.h
index 07f96a8..0b8f124 100644
--- a/include/media/smiapp.h
+++ b/include/media/smiapp.h
@@ -77,7 +77,6 @@ struct smiapp_platform_data {
 	struct smiapp_flash_strobe_parms *strobe_setup;
 
 	int (*set_xclk)(struct v4l2_subdev *sd, int hz);
-	char *ext_clk_name;
 	int xshutdown;			/* gpio or SMIAPP_NO_XSHUTDOWN */
 };
 
-- 
1.7.10.4

