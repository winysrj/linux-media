Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35300 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753384AbcISWDK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 18:03:10 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: sre@kernel.org
Subject: [PATCH v3 02/18] smiapp: Explicitly define number of pads in initialisation
Date: Tue, 20 Sep 2016 01:02:35 +0300
Message-Id: <1474322571-20290-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1474322571-20290-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1474322571-20290-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Define the number of pads explicitly in initialising the sub-devices.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 957e37e..2090b7f 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2536,7 +2536,8 @@ static void smiapp_cleanup(struct smiapp_sensor *sensor)
 }
 
 static void smiapp_create_subdev(struct smiapp_sensor *sensor,
-				 struct smiapp_subdev *ssd, const char *name)
+				 struct smiapp_subdev *ssd, const char *name,
+				 unsigned short num_pads)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
 
@@ -2548,12 +2549,8 @@ static void smiapp_create_subdev(struct smiapp_sensor *sensor,
 
 	ssd->sensor = sensor;
 
-	if (ssd == sensor->pixel_array) {
-		ssd->npads = 1;
-	} else {
-		ssd->npads = 2;
-		ssd->source_pad = 1;
-	}
+	ssd->npads = num_pads;
+	ssd->source_pad = num_pads - 1;
 
 	snprintf(ssd->sd.name,
 		 sizeof(ssd->sd.name), "%s %s %d-%4.4x", sensor->minfo.name,
@@ -2747,9 +2744,9 @@ static int smiapp_init(struct smiapp_sensor *sensor)
 	if (sensor->minfo.smiapp_profile == SMIAPP_PROFILE_0)
 		pll->flags |= SMIAPP_PLL_FLAG_NO_OP_CLOCKS;
 
-	smiapp_create_subdev(sensor, sensor->scaler, "scaler");
-	smiapp_create_subdev(sensor, sensor->binner, "binner");
-	smiapp_create_subdev(sensor, sensor->pixel_array, "pixel_array");
+	smiapp_create_subdev(sensor, sensor->scaler, "scaler", 2);
+	smiapp_create_subdev(sensor, sensor->binner, "binner", 2);
+	smiapp_create_subdev(sensor, sensor->pixel_array, "pixel_array", 1);
 
 	dev_dbg(&client->dev, "profile %d\n", sensor->minfo.smiapp_profile);
 
-- 
2.1.4

