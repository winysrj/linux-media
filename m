Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52062 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727268AbeH2Osy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Aug 2018 10:48:54 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [PATCH 2/3] smiapp: Use v4l2_i2c_subdev_set_name
Date: Wed, 29 Aug 2018 13:52:32 +0300
Message-Id: <20180829105233.3852-3-sakari.ailus@linux.intel.com>
In-Reply-To: <20180829105233.3852-1-sakari.ailus@linux.intel.com>
References: <20180829105233.3852-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use v4l2_i2c_subdev_set_name() to set the name of the smiapp driver's
sub-devices. There is no functional change.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 1236683da8f7..99f3b295ae3c 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2617,9 +2617,7 @@ static void smiapp_create_subdev(struct smiapp_sensor *sensor,
 	ssd->npads = num_pads;
 	ssd->source_pad = num_pads - 1;
 
-	snprintf(ssd->sd.name,
-		 sizeof(ssd->sd.name), "%s %s %d-%4.4x", sensor->minfo.name,
-		 name, i2c_adapter_id(client->adapter), client->addr);
+	v4l2_i2c_subdev_set_name(&ssd->sd, client, sensor->minfo.name, name);
 
 	smiapp_get_native_size(ssd, &ssd->sink_fmt);
 
@@ -3064,9 +3062,9 @@ static int smiapp_probe(struct i2c_client *client,
 	if (sensor->minfo.smiapp_profile == SMIAPP_PROFILE_0)
 		sensor->pll.flags |= SMIAPP_PLL_FLAG_NO_OP_CLOCKS;
 
-	smiapp_create_subdev(sensor, sensor->scaler, "scaler", 2);
-	smiapp_create_subdev(sensor, sensor->binner, "binner", 2);
-	smiapp_create_subdev(sensor, sensor->pixel_array, "pixel_array", 1);
+	smiapp_create_subdev(sensor, sensor->scaler, " scaler", 2);
+	smiapp_create_subdev(sensor, sensor->binner, " binner", 2);
+	smiapp_create_subdev(sensor, sensor->pixel_array, " pixel_array", 1);
 
 	dev_dbg(&client->dev, "profile %d\n", sensor->minfo.smiapp_profile);
 
-- 
2.11.0
