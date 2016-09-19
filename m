Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35322 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753415AbcISWDM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 18:03:12 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: sre@kernel.org
Subject: [PATCH v3 11/18] smiapp: Unify setting up sub-devices
Date: Tue, 20 Sep 2016 01:02:44 +0300
Message-Id: <1474322571-20290-12-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1474322571-20290-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1474322571-20290-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The initialisation of the source sub-device is somewhat different as it's
not created by the smiapp driver itself. Remove redundancy in initialising
the two kind of sub-devices.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 6ec17ea..7ac0d4e0 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2591,6 +2591,7 @@ static void smiapp_create_subdev(struct smiapp_sensor *sensor,
 	if (ssd != sensor->src)
 		v4l2_subdev_init(&ssd->sd, &smiapp_ops);
 
+	ssd->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 	ssd->sensor = sensor;
 
 	ssd->npads = num_pads;
@@ -2616,7 +2617,6 @@ static void smiapp_create_subdev(struct smiapp_sensor *sensor,
 	if (ssd == sensor->src)
 		return;
 
-	ssd->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 	ssd->sd.internal_ops = &smiapp_internal_ops;
 	ssd->sd.owner = THIS_MODULE;
 	v4l2_set_subdevdata(&ssd->sd, client);
@@ -2861,9 +2861,6 @@ static int smiapp_probe(struct i2c_client *client,
 
 	v4l2_i2c_subdev_init(&sensor->src->sd, client, &smiapp_ops);
 	sensor->src->sd.internal_ops = &smiapp_internal_src_ops;
-	sensor->src->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
-	sensor->src->sensor = sensor;
-	sensor->src->pads[0].flags = MEDIA_PAD_FL_SOURCE;
 
 	sensor->vana = devm_regulator_get(&client->dev, "vana");
 	if (IS_ERR(sensor->vana)) {
-- 
2.1.4

