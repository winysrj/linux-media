Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:32316 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932344AbaHELF5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Aug 2014 07:05:57 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
	by paasikivi.fi.intel.com (Postfix) with ESMTP id A464D20231
	for <linux-media@vger.kernel.org>; Tue,  5 Aug 2014 14:05:03 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/1] smiapp: Fix power count handling
Date: Tue,  5 Aug 2014 14:05:01 +0300
Message-Id: <1407236701-12778-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The sensor may be powered by either one of its sub-devices being accessed
from the user space (an open file handle) or by its s_power() op being
called with non-zero on argument. The driver counts the users and if any
reason to keep the device powered exists it will be powered.

However, a faulty condition was used in recognising the need to power off
the sensor, leading it to be powered off every time any of its uses went
away.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 94ae3a3..a9c6f9b 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -1400,19 +1400,12 @@ static int smiapp_set_power(struct v4l2_subdev *subdev, int on)
 
 	mutex_lock(&sensor->power_mutex);
 
-	/*
-	 * If the power count is modified from 0 to != 0 or from != 0
-	 * to 0, update the power state.
-	 */
-	if (!sensor->power_count == !on)
-		goto out;
-
-	if (on) {
+	if (on && !sensor->power_count) {
 		/* Power on and perform initialisation. */
 		ret = smiapp_power_on(sensor);
 		if (ret < 0)
 			goto out;
-	} else {
+	} else if (!on && sensor->power_count == 1) {
 		smiapp_power_off(sensor);
 	}
 
-- 
1.8.3.2

