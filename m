Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:27693 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757886AbaDWTeF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Apr 2014 15:34:05 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
	by paasikivi.fi.intel.com (Postfix) with ESMTP id B27E5203B1
	for <linux-media@vger.kernel.org>; Wed, 23 Apr 2014 22:33:33 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/3] smiapp: Call limits quirk immediately after retrieving the limits
Date: Wed, 23 Apr 2014 22:33:58 +0300
Message-Id: <1398281639-15839-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1398281639-15839-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1398281639-15839-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some of the limits are used before the limits quirk is called. Move the call
immediately after obtaining the limits.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index da4422e..0a74e14 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2423,6 +2423,12 @@ static int smiapp_registered(struct v4l2_subdev *subdev)
 		sensor->hvflip_inv_mask = SMIAPP_IMAGE_ORIENTATION_HFLIP |
 					  SMIAPP_IMAGE_ORIENTATION_VFLIP;
 
+	rval = smiapp_call_quirk(sensor, limits);
+	if (rval) {
+		dev_err(&client->dev, "limits quirks failed\n");
+		goto out_power_off;
+	}
+
 	rval = smiapp_get_mbus_formats(sensor);
 	if (rval) {
 		rval = -ENODEV;
@@ -2483,12 +2489,6 @@ static int smiapp_registered(struct v4l2_subdev *subdev)
 		}
 	}
 
-	rval = smiapp_call_quirk(sensor, limits);
-	if (rval) {
-		dev_err(&client->dev, "limits quirks failed\n");
-		goto out_nvm_release;
-	}
-
 	/* We consider this as profile 0 sensor if any of these are zero. */
 	if (!sensor->limits[SMIAPP_LIMIT_MIN_OP_SYS_CLK_DIV] ||
 	    !sensor->limits[SMIAPP_LIMIT_MAX_OP_SYS_CLK_DIV] ||
-- 
1.8.3.2

