Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35320 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753413AbcISWDM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 18:03:12 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: sre@kernel.org
Subject: [PATCH v3 10/18] smiapp: Read frame format earlier
Date: Tue, 20 Sep 2016 01:02:43 +0300
Message-Id: <1474322571-20290-11-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1474322571-20290-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1474322571-20290-1-git-send-email-sakari.ailus@linux.intel.com>
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
index 384a13b..6ec17ea 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2908,6 +2908,12 @@ static int smiapp_probe(struct i2c_client *client,
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
@@ -3030,8 +3036,6 @@ static int smiapp_probe(struct i2c_client *client,
 
 	sensor->pixel_array->sd.entity.function = MEDIA_ENT_F_CAM_SENSOR;
 
-	/* final steps */
-	smiapp_read_frame_fmt(sensor);
 	rval = smiapp_init_controls(sensor);
 	if (rval < 0)
 		goto out_cleanup;
-- 
2.1.4

