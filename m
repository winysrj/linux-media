Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:51170 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965100AbcIGKc0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Sep 2016 06:32:26 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
        by paasikivi.fi.intel.com (Postfix) with ESMTP id 5562822E7B
        for <linux-media@vger.kernel.org>; Wed,  7 Sep 2016 13:31:23 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/7] smiapp: Explicitly define number of pads in initialisation
Date: Wed,  7 Sep 2016 13:30:10 +0300
Message-Id: <1473244215-19432-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1473244215-19432-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1473244215-19432-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Define the number of pads explicitly in initialising the sub-devices.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 5ef9177..4f96797 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2528,7 +2528,8 @@ static void smiapp_cleanup(struct smiapp_sensor *sensor)
 }
 
 static void smiapp_create_subdev(struct smiapp_sensor *sensor,
-				 struct smiapp_subdev *ssd, const char *name)
+				 struct smiapp_subdev *ssd, const char *name,
+				 unsigned short num_pads)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
 
@@ -2537,12 +2538,8 @@ static void smiapp_create_subdev(struct smiapp_sensor *sensor,
 
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
@@ -2737,9 +2734,9 @@ static int smiapp_init(struct smiapp_sensor *sensor)
 		pll->flags |= SMIAPP_PLL_FLAG_NO_OP_CLOCKS;
 
 	if (sensor->scaler)
-		smiapp_create_subdev(sensor, sensor->scaler, "scaler");
-	smiapp_create_subdev(sensor, sensor->binner, "binner");
-	smiapp_create_subdev(sensor, sensor->pixel_array, "pixel_array");
+		smiapp_create_subdev(sensor, sensor->scaler, "scaler", 2);
+	smiapp_create_subdev(sensor, sensor->binner, "binner", 2);
+	smiapp_create_subdev(sensor, sensor->pixel_array, "pixel_array", 1);
 
 	dev_dbg(&client->dev, "profile %d\n", sensor->minfo.smiapp_profile);
 
-- 
2.7.4

