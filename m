Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39282 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1764371AbcIOLWl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Sep 2016 07:22:41 -0400
Received: from lanttu.localdomain (unknown [192.168.15.166])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 812F6600A7
        for <linux-media@vger.kernel.org>; Thu, 15 Sep 2016 14:22:35 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 09/17] smiapp: Read frame format earlier
Date: Thu, 15 Sep 2016 14:22:23 +0300
Message-Id: <1473938551-14503-10-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1473938551-14503-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1473938551-14503-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The information gathered during frame format reading will be required
earlier in the initialisation when it was available. Also return an error
if frame format cannot be obtained.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 0b5671c..c9aee83 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2890,6 +2890,12 @@ static int smiapp_probe(struct i2c_client *client,
 		goto out_power_off;
 	}
 
+	rval = smiapp_read_frame_fmt(sensor);
+	if (rval) {
+		rval = -ENODEV;
+		goto out_power_off;
+	}
+
 	/*
 	 * Handle Sensor Module orientation on the board.
 	 *
@@ -3013,8 +3019,6 @@ static int smiapp_probe(struct i2c_client *client,
 
 	sensor->pixel_array->sd.entity.function = MEDIA_ENT_F_CAM_SENSOR;
 
-	/* final steps */
-	smiapp_read_frame_fmt(sensor);
 	rval = smiapp_init_controls(sensor);
 	if (rval < 0)
 		goto out_cleanup;
-- 
2.1.4

