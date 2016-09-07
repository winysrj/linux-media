Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:2285 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754547AbcIGKcL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Sep 2016 06:32:11 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
        by paasikivi.fi.intel.com (Postfix) with ESMTP id 6DEDB22E87
        for <linux-media@vger.kernel.org>; Wed,  7 Sep 2016 13:31:23 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 4/7] smiapp: Split off sub-device registration into two
Date: Wed,  7 Sep 2016 13:30:12 +0300
Message-Id: <1473244215-19432-5-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1473244215-19432-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1473244215-19432-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove the loop in sub-device registration and create each sub-device
explicitly instead.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 82 ++++++++++++++++++----------------
 1 file changed, 43 insertions(+), 39 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index fb0326d..346b677 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2467,56 +2467,60 @@ static const struct v4l2_subdev_ops smiapp_ops;
 static const struct v4l2_subdev_internal_ops smiapp_internal_ops;
 static const struct media_entity_operations smiapp_entity_ops;
 
-static int smiapp_register_subdevs(struct smiapp_sensor *sensor)
+static int smiapp_register_subdev(struct smiapp_sensor *sensor,
+				  struct smiapp_subdev *ssd,
+				  struct smiapp_subdev *sink_ssd,
+				  u16 source_pad, u16 sink_pad, u32 link_flags)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
-	struct smiapp_subdev *ssds[] = {
-		sensor->scaler,
-		sensor->binner,
-		sensor->pixel_array,
-	};
-	unsigned int i;
 	int rval;
 
-	for (i = 0; i < SMIAPP_SUBDEVS - 1; i++) {
-		struct smiapp_subdev *this = ssds[i + 1];
-		struct smiapp_subdev *last = ssds[i];
-
-		if (!last)
-			continue;
-
-		rval = media_entity_pads_init(&this->sd.entity,
-					 this->npads, this->pads);
-		if (rval) {
-			dev_err(&client->dev,
-				"media_entity_pads_init failed\n");
-			return rval;
-		}
+	rval = media_entity_pads_init(&ssd->sd.entity,
+				      ssd->npads, ssd->pads);
+	if (rval) {
+		dev_err(&client->dev,
+			"media_entity_pads_init failed\n");
+		return rval;
+	}
 
-		rval = v4l2_device_register_subdev(sensor->src->sd.v4l2_dev,
-						   &this->sd);
-		if (rval) {
-			dev_err(&client->dev,
-				"v4l2_device_register_subdev failed\n");
-			return rval;
-		}
+	rval = v4l2_device_register_subdev(sensor->src->sd.v4l2_dev,
+					   &ssd->sd);
+	if (rval) {
+		dev_err(&client->dev,
+			"v4l2_device_register_subdev failed\n");
+		return rval;
+	}
 
-		rval = media_create_pad_link(&this->sd.entity,
-					     this->source_pad,
-					     &last->sd.entity,
-					     last->sink_pad,
-					     MEDIA_LNK_FL_ENABLED |
-					     MEDIA_LNK_FL_IMMUTABLE);
-		if (rval) {
-			dev_err(&client->dev,
-				"media_create_pad_link failed\n");
-			return rval;
-		}
+	rval = media_create_pad_link(&ssd->sd.entity, source_pad,
+				     &sink_ssd->sd.entity, sink_pad,
+				     link_flags);
+	if (rval) {
+		dev_err(&client->dev,
+			"media_create_pad_link failed\n");
+		return rval;
 	}
 
 	return 0;
 }
 
+static int smiapp_register_subdevs(struct smiapp_sensor *sensor)
+{
+	int rval = 0;
+
+	if (sensor->scaler)
+		rval = smiapp_register_subdev(
+			sensor, sensor->binner, sensor->scaler,
+			sensor->binner->sink_pad, sensor->scaler->source_pad,
+			MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE);
+	if (rval < 0)
+		return rval;
+
+	return smiapp_register_subdev(
+		sensor, sensor->pixel_array, sensor->binner,
+		sensor->pixel_array->sink_pad, sensor->binner->source_pad,
+		MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE);
+}
+
 static void smiapp_cleanup(struct smiapp_sensor *sensor)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
-- 
2.7.4

