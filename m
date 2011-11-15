Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:31931 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896Ab1KORuK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Nov 2011 12:50:10 -0500
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	sakari.ailus@maxwell.research.nokia.com
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5/9] as3645a: move limits to the platform_data
Date: Tue, 15 Nov 2011 19:49:57 +0200
Message-Id: <e0aec658bba4af4871056f3d2748c255c85e4096.1321379276.git.andriy.shevchenko@linux.intel.com>
In-Reply-To: <cover.1321379276.git.andriy.shevchenko@linux.intel.com>
References: <1321374065-20063-3-git-send-email-laurent.pinchart@ideasonboard.com>
 <cover.1321379276.git.andriy.shevchenko@linux.intel.com>
In-Reply-To: <cover.1321379276.git.andriy.shevchenko@linux.intel.com>
References: <cover.1321379276.git.andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/media/video/as3645a.c |   12 ++++++------
 include/media/as3645a.h       |   32 +++++++++++++-------------------
 2 files changed, 19 insertions(+), 25 deletions(-)

diff --git a/drivers/media/video/as3645a.c b/drivers/media/video/as3645a.c
index 108bc0f..541f8bc 100644
--- a/drivers/media/video/as3645a.c
+++ b/drivers/media/video/as3645a.c
@@ -724,8 +724,8 @@ static int as3645a_init_controls(struct as3645a *flash)
 			  V4L2_CID_FLASH_STROBE_STOP, 0, 0, 0, 0);
 
 	/* V4L2_CID_FLASH_TIMEOUT */
-	minimum = pdata->limits.timeout_min;
-	maximum = pdata->limits.timeout_max;
+	minimum = pdata->timeout_min;
+	maximum = pdata->timeout_max;
 
 	v4l2_ctrl_new_std(&flash->ctrls, &as3645a_ctrl_ops,
 			  V4L2_CID_FLASH_TIMEOUT, minimum, maximum,
@@ -734,8 +734,8 @@ static int as3645a_init_controls(struct as3645a *flash)
 	flash->timeout = maximum;
 
 	/* V4L2_CID_FLASH_INTENSITY */
-	minimum = pdata->limits.flash_min_current;
-	maximum = pdata->limits.flash_max_current;
+	minimum = pdata->flash_min_current;
+	maximum = pdata->flash_max_current;
 
 	v4l2_ctrl_new_std(&flash->ctrls, &as3645a_ctrl_ops,
 			  V4L2_CID_FLASH_INTENSITY, minimum, maximum,
@@ -745,8 +745,8 @@ static int as3645a_init_controls(struct as3645a *flash)
 			     / AS3645A_FLASH_INTENSITY_STEP;
 
 	/* V4L2_CID_FLASH_TORCH_INTENSITY */
-	minimum = pdata->limits.torch_min_current;
-	maximum = pdata->limits.torch_max_current;
+	minimum = pdata->torch_min_current;
+	maximum = pdata->torch_max_current;
 
 	v4l2_ctrl_new_std(&flash->ctrls, &as3645a_ctrl_ops,
 			  V4L2_CID_FLASH_TORCH_INTENSITY, minimum, maximum,
diff --git a/include/media/as3645a.h b/include/media/as3645a.h
index d8a3c41..11d77c9 100644
--- a/include/media/as3645a.h
+++ b/include/media/as3645a.h
@@ -47,15 +47,25 @@
 #define AS3645A_INDICATOR_INTENSITY_STEP	2500
 
 /*
- * as3645a_flash_torch_limits - Flash and torch currents and timeout limits
+ * as3645a_platform_data - Flash controller platform data
+ * @set_power:	Set power callback
+ * @vref:	VREF offset (0=0V, 1=+0.3V, 2=-0.3V, 3=+0.6V)
+ * @peak:	Inductor peak current limit (0=1.25A, 1=1.5A, 2=1.75A, 3=2.0A)
+ * @ext_strobe:	True if external flash strobe can be used
  * @flash_min_current:	Min flash current (mA, >= AS3645A_FLASH_INTENSITY_MIN)
- * @flash_max_current:	Max flash current (mA, <= AS3645A_FLASH_INTENSITY_MAX*)
+ * @flash_max_current:	Max flash current (mA, <= AS3645A_FLASH_INTENSITY_MAX)
  * @torch_min_current:	Min torch current (mA, <= AS3645A_TORCH_INTENSITY_MIN)
  * @torch_max_current:	Max torch current (mA, >= AS3645A_TORCH_INTENSITY_MAX)
  * @timeout_min:	Min flash timeout (us, >= 1)
  * @timeout_max:	Max flash timeout (us, <= AS3645A_FLASH_TIMEOUT_MAX)
  */
-struct as3645a_flash_torch_limits {
+struct as3645a_platform_data {
+	int (*set_power)(struct v4l2_subdev *subdev, int on);
+	unsigned int vref;
+	unsigned int peak;
+	bool ext_strobe;
+
+	/* Flash and torch currents and timeout limits */
 	unsigned int flash_min_current;
 	unsigned int flash_max_current;
 	unsigned int torch_min_current;
@@ -64,20 +74,4 @@ struct as3645a_flash_torch_limits {
 	unsigned int timeout_max;
 };
 
-/*
- * as3645a_platform_data - Flash controller platform data
- * @set_power:	Set power callback
- * @vref:	VREF offset (0=0V, 1=+0.3V, 2=-0.3V, 3=+0.6V)
- * @peak:	Inductor peak current limit (0=1.25A, 1=1.5A, 2=1.75A, 3=2.0A)
- * @ext_strobe:	True if external flash strobe can be used
- * @limits:	Flash and torch currents and timeout limits
- */
-struct as3645a_platform_data {
-	int (*set_power)(struct v4l2_subdev *subdev, int on);
-	unsigned int vref;
-	unsigned int peak;
-	bool ext_strobe;
-	struct as3645a_flash_torch_limits limits;
-};
-
 #endif /* __AS3645A_H__ */
-- 
1.7.7.1

