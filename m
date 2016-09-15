Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39264 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1756202AbcIOLWi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Sep 2016 07:22:38 -0400
Received: from lanttu.localdomain (unknown [192.168.15.166])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id F26A06009F
        for <linux-media@vger.kernel.org>; Thu, 15 Sep 2016 14:22:33 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 01/17] smiapp: Move sub-device initialisation into a separate function
Date: Thu, 15 Sep 2016 14:22:15 +0300
Message-Id: <1473938551-14503-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1473938551-14503-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1473938551-14503-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Simplify smiapp_init() by moving the initialisation of individual
sub-devices to a separate function.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 108 +++++++++++++++------------------
 1 file changed, 49 insertions(+), 59 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 44f8c7e..862017e 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2535,11 +2535,55 @@ static void smiapp_cleanup(struct smiapp_sensor *sensor)
 	smiapp_free_controls(sensor);
 }
 
+static void smiapp_create_subdev(struct smiapp_sensor *sensor,
+				 struct smiapp_subdev *ssd, const char *name)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
+
+	if (ssd != sensor->src)
+		v4l2_subdev_init(&ssd->sd, &smiapp_ops);
+
+	ssd->sensor = sensor;
+
+	if (ssd == sensor->pixel_array) {
+		ssd->npads = 1;
+	} else {
+		ssd->npads = 2;
+		ssd->source_pad = 1;
+	}
+
+	snprintf(ssd->sd.name,
+		 sizeof(ssd->sd.name), "%s %s %d-%4.4x", sensor->minfo.name,
+		 name, i2c_adapter_id(client->adapter), client->addr);
+
+	ssd->sink_fmt.width =
+		sensor->limits[SMIAPP_LIMIT_X_ADDR_MAX] + 1;
+	ssd->sink_fmt.height =
+		sensor->limits[SMIAPP_LIMIT_Y_ADDR_MAX] + 1;
+	ssd->compose.width = ssd->sink_fmt.width;
+	ssd->compose.height = ssd->sink_fmt.height;
+	ssd->crop[ssd->source_pad] = ssd->compose;
+	ssd->pads[ssd->source_pad].flags = MEDIA_PAD_FL_SOURCE;
+	if (ssd != sensor->pixel_array) {
+		ssd->crop[ssd->sink_pad] = ssd->compose;
+		ssd->pads[ssd->sink_pad].flags = MEDIA_PAD_FL_SINK;
+	}
+
+	ssd->sd.entity.ops = &smiapp_entity_ops;
+
+	if (ssd == sensor->src)
+		return;
+
+	ssd->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	ssd->sd.internal_ops = &smiapp_internal_ops;
+	ssd->sd.owner = THIS_MODULE;
+	v4l2_set_subdevdata(&ssd->sd, client);
+}
+
 static int smiapp_init(struct smiapp_sensor *sensor)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
 	struct smiapp_pll *pll = &sensor->pll;
-	struct smiapp_subdev *last = NULL;
 	unsigned int i;
 	int rval;
 
@@ -2700,64 +2744,10 @@ static int smiapp_init(struct smiapp_sensor *sensor)
 	if (sensor->minfo.smiapp_profile == SMIAPP_PROFILE_0)
 		pll->flags |= SMIAPP_PLL_FLAG_NO_OP_CLOCKS;
 
-	for (i = 0; i < SMIAPP_SUBDEVS; i++) {
-		struct {
-			struct smiapp_subdev *ssd;
-			char *name;
-		} const __this[] = {
-			{ sensor->scaler, "scaler", },
-			{ sensor->binner, "binner", },
-			{ sensor->pixel_array, "pixel array", },
-		}, *_this = &__this[i];
-		struct smiapp_subdev *this = _this->ssd;
-
-		if (!this)
-			continue;
-
-		if (this != sensor->src)
-			v4l2_subdev_init(&this->sd, &smiapp_ops);
-
-		this->sensor = sensor;
-
-		if (this == sensor->pixel_array) {
-			this->npads = 1;
-		} else {
-			this->npads = 2;
-			this->source_pad = 1;
-		}
-
-		snprintf(this->sd.name,
-			 sizeof(this->sd.name), "%s %s %d-%4.4x",
-			 sensor->minfo.name, _this->name,
-			 i2c_adapter_id(client->adapter), client->addr);
-
-		this->sink_fmt.width =
-			sensor->limits[SMIAPP_LIMIT_X_ADDR_MAX] + 1;
-		this->sink_fmt.height =
-			sensor->limits[SMIAPP_LIMIT_Y_ADDR_MAX] + 1;
-		this->compose.width = this->sink_fmt.width;
-		this->compose.height = this->sink_fmt.height;
-		this->crop[this->source_pad] = this->compose;
-		this->pads[this->source_pad].flags = MEDIA_PAD_FL_SOURCE;
-		if (this != sensor->pixel_array) {
-			this->crop[this->sink_pad] = this->compose;
-			this->pads[this->sink_pad].flags = MEDIA_PAD_FL_SINK;
-		}
-
-		this->sd.entity.ops = &smiapp_entity_ops;
-
-		if (last == NULL) {
-			last = this;
-			continue;
-		}
-
-		this->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
-		this->sd.internal_ops = &smiapp_internal_ops;
-		this->sd.owner = THIS_MODULE;
-		v4l2_set_subdevdata(&this->sd, client);
-
-		last = this;
-	}
+	if (sensor->scaler)
+		smiapp_create_subdev(sensor, sensor->scaler, "scaler");
+	smiapp_create_subdev(sensor, sensor->binner, "binner");
+	smiapp_create_subdev(sensor, sensor->pixel_array, "pixel_array");
 
 	dev_dbg(&client->dev, "profile %d\n", sensor->minfo.smiapp_profile);
 
-- 
2.1.4

