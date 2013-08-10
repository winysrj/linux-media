Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44030 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752127Ab3HJRnn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Aug 2013 13:43:43 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: andriy.shevchenko@intel.com, laurent.pinchart@ideasonboard.com
Subject: [PATCH 1/4] smiapp: re-use clamp_t instead of min(..., max(...))
Date: Sat, 10 Aug 2013 20:49:45 +0300
Message-Id: <1376156988-4009-2-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1376156988-4009-1-git-send-email-sakari.ailus@iki.fi>
References: <1376156988-4009-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

clamp_t does the job to put a variable into the given range.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

clamp_t -> clamp as agreed with Andy.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/i2c/smiapp/smiapp-core.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 7ac7580..4d7ba54 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -1835,12 +1835,12 @@ static void smiapp_set_compose_scaler(struct v4l2_subdev *subdev,
 		* sensor->limits[SMIAPP_LIMIT_SCALER_N_MIN]
 		/ sensor->limits[SMIAPP_LIMIT_MIN_X_OUTPUT_SIZE];
 
-	a = min(sensor->limits[SMIAPP_LIMIT_SCALER_M_MAX],
-		max(a, sensor->limits[SMIAPP_LIMIT_SCALER_M_MIN]));
-	b = min(sensor->limits[SMIAPP_LIMIT_SCALER_M_MAX],
-		max(b, sensor->limits[SMIAPP_LIMIT_SCALER_M_MIN]));
-	max_m = min(sensor->limits[SMIAPP_LIMIT_SCALER_M_MAX],
-		    max(max_m, sensor->limits[SMIAPP_LIMIT_SCALER_M_MIN]));
+	a = clamp(a, sensor->limits[SMIAPP_LIMIT_SCALER_M_MIN],
+		  sensor->limits[SMIAPP_LIMIT_SCALER_M_MAX]);
+	b = clamp(b, sensor->limits[SMIAPP_LIMIT_SCALER_M_MIN],
+		  sensor->limits[SMIAPP_LIMIT_SCALER_M_MAX]);
+	max_m = clamp(max_m, sensor->limits[SMIAPP_LIMIT_SCALER_M_MIN],
+		      sensor->limits[SMIAPP_LIMIT_SCALER_M_MAX]);
 
 	dev_dbg(&client->dev, "scaling: a %d b %d max_m %d\n", a, b, max_m);
 
-- 
1.7.10.4

