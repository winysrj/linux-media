Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56162 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752093AbeDLKVy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Apr 2018 06:21:54 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: Wenyou Yang <wenyou.yang@microchip.com>
Subject: [PATCH 2/4] ov7740: Check for possible NULL return value in control creation
Date: Thu, 12 Apr 2018 13:21:48 +0300
Message-Id: <20180412102150.29997-3-sakari.ailus@linux.intel.com>
In-Reply-To: <20180412102150.29997-1-sakari.ailus@linux.intel.com>
References: <20180412102150.29997-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Check that creating the control actually succeeded before accessing it.
A failure would lead to NULL pointer reference. Fix this.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/ov7740.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/ov7740.c b/drivers/media/i2c/ov7740.c
index c9b8bec6373f..cbfa5a3327f6 100644
--- a/drivers/media/i2c/ov7740.c
+++ b/drivers/media/i2c/ov7740.c
@@ -980,21 +980,26 @@ static int ov7740_init_controls(struct ov7740 *ov7740)
 					V4L2_CID_HFLIP, 0, 1, 1, 0);
 	ov7740->vflip = v4l2_ctrl_new_std(ctrl_hdlr, &ov7740_ctrl_ops,
 					V4L2_CID_VFLIP, 0, 1, 1, 0);
+
 	ov7740->gain = v4l2_ctrl_new_std(ctrl_hdlr, &ov7740_ctrl_ops,
 				       V4L2_CID_GAIN, 0, 1023, 1, 500);
+	if (ov7740->gain)
+		ov7740->gain->flags |= V4L2_CTRL_FLAG_VOLATILE;
+
 	ov7740->auto_gain = v4l2_ctrl_new_std(ctrl_hdlr, &ov7740_ctrl_ops,
 					    V4L2_CID_AUTOGAIN, 0, 1, 1, 1);
+
 	ov7740->exposure = v4l2_ctrl_new_std(ctrl_hdlr, &ov7740_ctrl_ops,
 					   V4L2_CID_EXPOSURE, 0, 65535, 1, 500);
+	if (ov7740->exposure)
+		ov7740->exposure->flags |= V4L2_CTRL_FLAG_VOLATILE;
+
 	ov7740->auto_exposure = v4l2_ctrl_new_std_menu(ctrl_hdlr,
 					&ov7740_ctrl_ops,
 					V4L2_CID_EXPOSURE_AUTO,
 					V4L2_EXPOSURE_MANUAL, 0,
 					V4L2_EXPOSURE_AUTO);
 
-	ov7740->gain->flags |= V4L2_CTRL_FLAG_VOLATILE;
-	ov7740->exposure->flags |= V4L2_CTRL_FLAG_VOLATILE;
-
 	v4l2_ctrl_auto_cluster(3, &ov7740->auto_wb, 0, false);
 	v4l2_ctrl_auto_cluster(2, &ov7740->auto_gain, 0, true);
 	v4l2_ctrl_auto_cluster(2, &ov7740->auto_exposure,
-- 
2.11.0
