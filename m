Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:43701 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752110AbcIGKba (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Sep 2016 06:31:30 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
        by paasikivi.fi.intel.com (Postfix) with ESMTP id 54CCF22E6F
        for <linux-media@vger.kernel.org>; Wed,  7 Sep 2016 13:31:23 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/7] smiapp: Initialise media entity after sensor init
Date: Wed,  7 Sep 2016 13:30:11 +0300
Message-Id: <1473244215-19432-4-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1473244215-19432-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1473244215-19432-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This allows determining the number of pads in the entity based on the
sensor.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 4f96797..fb0326d 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -3048,12 +3048,7 @@ static int smiapp_probe(struct i2c_client *client,
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
@@ -3061,6 +3056,11 @@ static int smiapp_probe(struct i2c_client *client,
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
2.7.4

