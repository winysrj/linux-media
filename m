Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37646 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751906AbdI2KkI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Sep 2017 06:40:08 -0400
Received: from lanttu.localdomain (unknown [IPv6:2001:1bc8:1a6:d3d5::e1:1002])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id F2D10600E4
        for <linux-media@vger.kernel.org>; Fri, 29 Sep 2017 13:40:06 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/2] smiapp: Use __v4l2_ctrl_handler_setup()
Date: Fri, 29 Sep 2017 13:40:05 +0300
Message-Id: <20170929104006.29892-2-sakari.ailus@linux.intel.com>
In-Reply-To: <20170929104006.29892-1-sakari.ailus@linux.intel.com>
References: <20170929104006.29892-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use unlocked __v4l2_ctrl_handler_setup() in order to make the control
setup atomic.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index fbd851be51d2..8de444080b8f 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -1325,24 +1325,28 @@ static int smiapp_power_on(struct device *dev)
 	if (!sensor->pixel_array)
 		return 0;
 
-	rval = v4l2_ctrl_handler_setup(&sensor->pixel_array->ctrl_handler);
+	mutex_lock(&sensor->mutex);
+
+	rval = __v4l2_ctrl_handler_setup(&sensor->pixel_array->ctrl_handler);
 	if (rval)
-		goto out_cci_addr_fail;
+		goto out_unlock;
 
-	rval = v4l2_ctrl_handler_setup(&sensor->src->ctrl_handler);
+	rval = __v4l2_ctrl_handler_setup(&sensor->src->ctrl_handler);
 	if (rval)
-		goto out_cci_addr_fail;
+		goto out_unlock;
 
-	mutex_lock(&sensor->mutex);
 	rval = smiapp_update_mode(sensor);
-	mutex_unlock(&sensor->mutex);
 	if (rval < 0)
-		goto out_cci_addr_fail;
+		goto out_unlock;
+
+	mutex_unlock(&sensor->mutex);
 
 	return 0;
 
-out_cci_addr_fail:
+out_unlock:
+	mutex_unlock(&sensor->mutex);
 
+out_cci_addr_fail:
 	gpiod_set_value(sensor->xshutdown, 0);
 	clk_disable_unprepare(sensor->ext_clk);
 
-- 
2.11.0
