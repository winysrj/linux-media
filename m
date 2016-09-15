Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39284 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1764393AbcIOLWl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Sep 2016 07:22:41 -0400
Received: from lanttu.localdomain (unknown [192.168.15.166])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 9F211600A8
        for <linux-media@vger.kernel.org>; Thu, 15 Sep 2016 14:22:35 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 10/17] smiapp: Unify setting up sub-devices
Date: Thu, 15 Sep 2016 14:22:24 +0300
Message-Id: <1473938551-14503-11-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1473938551-14503-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1473938551-14503-1-git-send-email-sakari.ailus@linux.intel.com>
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
index c9aee83..b446d0a 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2574,6 +2574,7 @@ static void smiapp_create_subdev(struct smiapp_sensor *sensor,
 	if (ssd != sensor->src)
 		v4l2_subdev_init(&ssd->sd, &smiapp_ops);
 
+	ssd->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 	ssd->sensor = sensor;
 
 	ssd->npads = num_pads;
@@ -2599,7 +2600,6 @@ static void smiapp_create_subdev(struct smiapp_sensor *sensor,
 	if (ssd == sensor->src)
 		return;
 
-	ssd->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 	ssd->sd.internal_ops = &smiapp_internal_ops;
 	ssd->sd.owner = THIS_MODULE;
 	v4l2_set_subdevdata(&ssd->sd, client);
@@ -2843,9 +2843,6 @@ static int smiapp_probe(struct i2c_client *client,
 
 	v4l2_i2c_subdev_init(&sensor->src->sd, client, &smiapp_ops);
 	sensor->src->sd.internal_ops = &smiapp_internal_src_ops;
-	sensor->src->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
-	sensor->src->sensor = sensor;
-	sensor->src->pads[0].flags = MEDIA_PAD_FL_SOURCE;
 
 	sensor->vana = devm_regulator_get(&client->dev, "vana");
 	if (IS_ERR(sensor->vana)) {
-- 
2.1.4

