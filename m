Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39270 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751758AbcIOLWi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Sep 2016 07:22:38 -0400
Received: from lanttu.localdomain (unknown [192.168.15.166])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 494E1600A1
        for <linux-media@vger.kernel.org>; Thu, 15 Sep 2016 14:22:34 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 03/17] smiapp: Initialise media entity after sensor init
Date: Thu, 15 Sep 2016 14:22:17 +0300
Message-Id: <1473938551-14503-4-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1473938551-14503-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1473938551-14503-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This allows determining the number of pads in the entity based on the
sensor.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index be74ba3..0a03f30 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -3056,12 +3056,7 @@ static int smiapp_probe(struct i2c_client *client,
 	sensor->src->sd.internal_ops = &smiapp_internal_src_ops;
 	sensor->src->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 	sensor->src->sensor = sensor;
-
 	sensor->src->pads[0].flags = MEDIA_PAD_FL_SOURCE;
-	rval = media_entity_pads_init(&sensor->src->sd.entity, 2,
-				 sensor->src->pads);
-	if (rval < 0)
-		return rval;
 
 	if (client->dev.of_node) {
 		rval = smiapp_init(sensor);
@@ -3069,6 +3064,11 @@ static int smiapp_probe(struct i2c_client *client,
 			goto out_media_entity_cleanup;
 	}
 
+	rval = media_entity_pads_init(&sensor->src->sd.entity, 2,
+				 sensor->src->pads);
+	if (rval < 0)
+		goto out_media_entity_cleanup;
+
 	rval = v4l2_async_register_subdev(&sensor->src->sd);
 	if (rval < 0)
 		goto out_media_entity_cleanup;
-- 
2.1.4

