Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:53927 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965174AbcIHJ2I (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Sep 2016 05:28:08 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: <linux-media@vger.kernel.org>
CC: <mchehab@s-opensource.com>, <pavel@ucw.cz>
Subject: [PATCH 1/1] ad5820: Use bool for boolean values
Date: Mon, 5 Sep 2016 01:47:05 -0600
Message-ID: <1473061625-7179-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver used integers for what boolean would have been a better fit.
Use boolean instead.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/ad5820.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/media/i2c/ad5820.c b/drivers/media/i2c/ad5820.c
index d7ad5c1..a9382d1 100644
--- a/drivers/media/i2c/ad5820.c
+++ b/drivers/media/i2c/ad5820.c
@@ -58,7 +58,7 @@ struct ad5820_device {
 	struct mutex power_lock;
 	int power_count;
 
-	unsigned int standby : 1;
+	bool standby;
 };
 
 static int ad5820_write(struct ad5820_device *coil, u16 data)
@@ -108,7 +108,7 @@ static int ad5820_update_hw(struct ad5820_device *coil)
 /*
  * Power handling
  */
-static int ad5820_power_off(struct ad5820_device *coil, int standby)
+static int ad5820_power_off(struct ad5820_device *coil, bool standby)
 {
 	int ret = 0, ret2;
 
@@ -117,7 +117,7 @@ static int ad5820_power_off(struct ad5820_device *coil, int standby)
 	 * (single power line control for both coil and sensor).
 	 */
 	if (standby) {
-		coil->standby = 1;
+		coil->standby = true;
 		ret = ad5820_update_hw(coil);
 	}
 
@@ -127,7 +127,7 @@ static int ad5820_power_off(struct ad5820_device *coil, int standby)
 	return ret2;
 }
 
-static int ad5820_power_on(struct ad5820_device *coil, int restore)
+static int ad5820_power_on(struct ad5820_device *coil, bool restore)
 {
 	int ret;
 
@@ -137,7 +137,7 @@ static int ad5820_power_on(struct ad5820_device *coil, int restore)
 
 	if (restore) {
 		/* Restore the hardware settings. */
-		coil->standby = 0;
+		coil->standby = false;
 		ret = ad5820_update_hw(coil);
 		if (ret)
 			goto fail;
@@ -145,7 +145,7 @@ static int ad5820_power_on(struct ad5820_device *coil, int restore)
 	return 0;
 
 fail:
-	coil->standby = 1;
+	coil->standby = true;
 	regulator_disable(coil->vana);
 
 	return ret;
@@ -227,7 +227,8 @@ ad5820_set_power(struct v4l2_subdev *subdev, int on)
 	 * update the power state.
 	 */
 	if (coil->power_count == !on) {
-		ret = on ? ad5820_power_on(coil, 1) : ad5820_power_off(coil, 1);
+		ret = on ? ad5820_power_on(coil, true) :
+			ad5820_power_off(coil, false);
 		if (ret < 0)
 			goto done;
 	}
@@ -279,7 +280,7 @@ static int ad5820_suspend(struct device *dev)
 	if (!coil->power_count)
 		return 0;
 
-	return ad5820_power_off(coil, 0);
+	return ad5820_power_off(coil, false);
 }
 
 static int ad5820_resume(struct device *dev)
@@ -291,7 +292,7 @@ static int ad5820_resume(struct device *dev)
 	if (!coil->power_count)
 		return 0;
 
-	return ad5820_power_on(coil, 1);
+	return ad5820_power_on(coil, true);
 }
 
 #else
-- 
2.7.4


