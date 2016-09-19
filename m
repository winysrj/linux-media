Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35314 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753407AbcISWDM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 18:03:12 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: sre@kernel.org
Subject: [PATCH v3 07/18] smiapp: Always initialise the sensor in probe
Date: Tue, 20 Sep 2016 01:02:40 +0300
Message-Id: <1474322571-20290-8-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1474322571-20290-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1474322571-20290-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Initialise the sensor in probe. The reason why it wasn't previously done
in case of platform data was that the probe() of the driver that provided
the clock through the set_xclk() callback would need to finish before the
probe() function of the smiapp driver. The set_xclk() callback no longer
exists.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 30 +++++-------------------------
 1 file changed, 5 insertions(+), 25 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 9873b3d..8a58c64 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2530,8 +2530,9 @@ static int smiapp_register_subdev(struct smiapp_sensor *sensor,
 	return 0;
 }
 
-static int smiapp_register_subdevs(struct smiapp_sensor *sensor)
+static int smiapp_registered(struct v4l2_subdev *subdev)
 {
+	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
 	int rval;
 
 	if (sensor->scaler) {
@@ -2819,25 +2820,6 @@ out_power_off:
 	return rval;
 }
 
-static int smiapp_registered(struct v4l2_subdev *subdev)
-{
-	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
-	struct i2c_client *client = v4l2_get_subdevdata(subdev);
-	int rval;
-
-	if (!client->dev.of_node) {
-		rval = smiapp_init(sensor);
-		if (rval)
-			return rval;
-	}
-
-	rval = smiapp_register_subdevs(sensor);
-	if (rval)
-		smiapp_cleanup(sensor);
-
-	return rval;
-}
-
 static int smiapp_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 {
 	struct smiapp_subdev *ssd = to_smiapp_subdev(sd);
@@ -3079,11 +3061,9 @@ static int smiapp_probe(struct i2c_client *client,
 	sensor->src->sensor = sensor;
 	sensor->src->pads[0].flags = MEDIA_PAD_FL_SOURCE;
 
-	if (client->dev.of_node) {
-		rval = smiapp_init(sensor);
-		if (rval)
-			goto out_media_entity_cleanup;
-	}
+	rval = smiapp_init(sensor);
+	if (rval)
+		goto out_media_entity_cleanup;
 
 	rval = media_entity_pads_init(&sensor->src->sd.entity, 2,
 				 sensor->src->pads);
-- 
2.1.4

