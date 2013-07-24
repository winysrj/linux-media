Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39829 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333Ab3GXPWH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jul 2013 11:22:07 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Sakari Ailus <sakari.ailus@iki.fi>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] smiapp: re-use clamp_t instead of min(..., max(...))
Date: Wed, 24 Jul 2013 18:21:18 +0300
Message-Id: <1374679278-9856-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

clamp_t does the job to put a variable into the given range.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 7ac7580..914e52f 100644
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
+	a = clamp_t(u32, a, sensor->limits[SMIAPP_LIMIT_SCALER_M_MIN],
+		    sensor->limits[SMIAPP_LIMIT_SCALER_M_MAX]);
+	b = clamp_t(u32, b, sensor->limits[SMIAPP_LIMIT_SCALER_M_MIN],
+		    sensor->limits[SMIAPP_LIMIT_SCALER_M_MAX]);
+	max_m = clamp_t(u32, max_m, sensor->limits[SMIAPP_LIMIT_SCALER_M_MIN],
+			sensor->limits[SMIAPP_LIMIT_SCALER_M_MAX]);
 
 	dev_dbg(&client->dev, "scaling: a %d b %d max_m %d\n", a, b, max_m);
 
-- 
1.8.3.2

