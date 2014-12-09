Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53109 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755260AbaLIAEv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Dec 2014 19:04:51 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, mark.rutland@arm.com
Subject: [REVIEW PATCH v3 11/12] smiapp: Split sub-device initialisation off from the registered callback
Date: Tue,  9 Dec 2014 02:04:19 +0200
Message-Id: <1418083460-28556-12-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1418083460-28556-1-git-send-email-sakari.ailus@iki.fi>
References: <1418083460-28556-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The registered callback is called by the V4L2 async framework after the
bound callback. This allows separating the functionality in the registered
callback so that on DT based systems only sub-device registration is done
there.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/i2c/smiapp/smiapp-core.c |   82 +++++++++++++++++++++-----------
 1 file changed, 54 insertions(+), 28 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 1e60f4a..c2bf718 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2467,6 +2467,56 @@ static const struct v4l2_subdev_ops smiapp_ops;
 static const struct v4l2_subdev_internal_ops smiapp_internal_ops;
 static const struct media_entity_operations smiapp_entity_ops;
 
+static int smiapp_register_subdevs(struct smiapp_sensor *sensor)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
+	struct smiapp_subdev *ssds[] = {
+		sensor->scaler,
+		sensor->binner,
+		sensor->pixel_array,
+	};
+	unsigned int i;
+	int rval;
+
+	for (i = 0; i < SMIAPP_SUBDEVS - 1; i++) {
+		struct smiapp_subdev *this = ssds[i + 1];
+		struct smiapp_subdev *last = ssds[i];
+
+		if (!last)
+			continue;
+
+		rval = media_entity_init(&this->sd.entity,
+					 this->npads, this->pads, 0);
+		if (rval) {
+			dev_err(&client->dev,
+				"media_entity_init failed\n");
+			return rval;
+		}
+
+		rval = media_entity_create_link(&this->sd.entity,
+						this->source_pad,
+						&last->sd.entity,
+						last->sink_pad,
+						MEDIA_LNK_FL_ENABLED |
+						MEDIA_LNK_FL_IMMUTABLE);
+		if (rval) {
+			dev_err(&client->dev,
+				"media_entity_create_link failed\n");
+			return rval;
+		}
+
+		rval = v4l2_device_register_subdev(sensor->src->sd.v4l2_dev,
+						   &this->sd);
+		if (rval) {
+			dev_err(&client->dev,
+				"v4l2_device_register_subdev failed\n");
+			return rval;
+		}
+	}
+
+	return 0;
+}
+
 static int smiapp_registered(struct v4l2_subdev *subdev)
 {
 	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
@@ -2705,37 +2755,13 @@ static int smiapp_registered(struct v4l2_subdev *subdev)
 		this->sd.owner = THIS_MODULE;
 		v4l2_set_subdevdata(&this->sd, client);
 
-		rval = media_entity_init(&this->sd.entity,
-					 this->npads, this->pads, 0);
-		if (rval) {
-			dev_err(&client->dev,
-				"media_entity_init failed\n");
-			goto out_nvm_release;
-		}
-
-		rval = media_entity_create_link(&this->sd.entity,
-						this->source_pad,
-						&last->sd.entity,
-						last->sink_pad,
-						MEDIA_LNK_FL_ENABLED |
-						MEDIA_LNK_FL_IMMUTABLE);
-		if (rval) {
-			dev_err(&client->dev,
-				"media_entity_create_link failed\n");
-			goto out_nvm_release;
-		}
-
-		rval = v4l2_device_register_subdev(sensor->src->sd.v4l2_dev,
-						   &this->sd);
-		if (rval) {
-			dev_err(&client->dev,
-				"v4l2_device_register_subdev failed\n");
-			goto out_nvm_release;
-		}
-
 		last = this;
 	}
 
+	rval = smiapp_register_subdevs(sensor);
+	if (rval)
+		goto out_nvm_release;
+
 	dev_dbg(&client->dev, "profile %d\n", sensor->minfo.smiapp_profile);
 
 	sensor->pixel_array->sd.entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
-- 
1.7.10.4

