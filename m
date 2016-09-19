Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35308 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753334AbcISWDK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 18:03:10 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: sre@kernel.org
Subject: [PATCH v3 04/18] smiapp: Split off sub-device registration into two
Date: Tue, 20 Sep 2016 01:02:37 +0300
Message-Id: <1474322571-20290-5-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1474322571-20290-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1474322571-20290-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove the loop in sub-device registration and create each sub-device
explicitly instead.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 82 +++++++++++++++++++---------------
 1 file changed, 45 insertions(+), 37 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 4f97503..86c0d7c 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2475,54 +2475,62 @@ static const struct v4l2_subdev_ops smiapp_ops;
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
+	if (!sink_ssd)
+		return 0;
 
-		if (!last)
-			continue;
+	rval = media_entity_pads_init(&ssd->sd.entity,
+				      ssd->npads, ssd->pads);
+	if (rval) {
+		dev_err(&client->dev,
+			"media_entity_pads_init failed\n");
+		return rval;
+	}
 
-		rval = media_entity_pads_init(&this->sd.entity,
-					 this->npads, this->pads);
-		if (rval) {
-			dev_err(&client->dev,
-				"media_entity_pads_init failed\n");
-			return rval;
-		}
+	rval = v4l2_device_register_subdev(sensor->src->sd.v4l2_dev,
+					   &ssd->sd);
+	if (rval) {
+		dev_err(&client->dev,
+			"v4l2_device_register_subdev failed\n");
+		return rval;
+	}
 
-		rval = v4l2_device_register_subdev(sensor->src->sd.v4l2_dev,
-						   &this->sd);
-		if (rval) {
-			dev_err(&client->dev,
-				"v4l2_device_register_subdev failed\n");
-			return rval;
-		}
+	rval = media_create_pad_link(&ssd->sd.entity, source_pad,
+				     &sink_ssd->sd.entity, sink_pad,
+				     link_flags);
+	if (rval) {
+		dev_err(&client->dev,
+			"media_create_pad_link failed\n");
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
+	return 0;
+}
+
+static int smiapp_register_subdevs(struct smiapp_sensor *sensor)
+{
+	int rval;
+
+	if (sensor->scaler) {
+		rval = smiapp_register_subdev(
+			sensor, sensor->binner, sensor->scaler,
+			SMIAPP_PAD_SRC, SMIAPP_PAD_SINK,
+			MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE);
+		if (rval < 0)
 			return rval;
-		}
 	}
 
-	return 0;
+	return smiapp_register_subdev(
+		sensor, sensor->pixel_array, sensor->binner,
+		SMIAPP_PA_PAD_SRC, SMIAPP_PAD_SINK,
+		MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE);
 }
 
 static void smiapp_cleanup(struct smiapp_sensor *sensor)
-- 
2.1.4

