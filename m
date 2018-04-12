Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56164 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751870AbeDLKVz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Apr 2018 06:21:55 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: Wenyou Yang <wenyou.yang@microchip.com>
Subject: [PATCH 3/4] ov7740: Fix control handler error at the end of control init
Date: Thu, 12 Apr 2018 13:21:49 +0300
Message-Id: <20180412102150.29997-4-sakari.ailus@linux.intel.com>
In-Reply-To: <20180412102150.29997-1-sakari.ailus@linux.intel.com>
References: <20180412102150.29997-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Check that no error happened during adding controls to the driver's
control handler. Print an error message and bail out if there was one.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/ov7740.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/i2c/ov7740.c b/drivers/media/i2c/ov7740.c
index cbfa5a3327f6..0c15b67f3c34 100644
--- a/drivers/media/i2c/ov7740.c
+++ b/drivers/media/i2c/ov7740.c
@@ -1000,6 +1000,13 @@ static int ov7740_init_controls(struct ov7740 *ov7740)
 					V4L2_EXPOSURE_MANUAL, 0,
 					V4L2_EXPOSURE_AUTO);
 
+	if (ctrl_hdlr->error) {
+		ret = ctrl_hdlr->error;
+		dev_err(&client->dev, "controls initialisation failed (%d)\n",
+			ret);
+		goto error;
+	}
+
 	v4l2_ctrl_auto_cluster(3, &ov7740->auto_wb, 0, false);
 	v4l2_ctrl_auto_cluster(2, &ov7740->auto_gain, 0, true);
 	v4l2_ctrl_auto_cluster(2, &ov7740->auto_exposure,
-- 
2.11.0
