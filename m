Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53731 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933682AbaFLQKW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 12:10:22 -0400
Received: from valkosipuli.retiisi.org.uk (vihersipuli.retiisi.org.uk [IPv6:2001:1bc8:102:7fc9::84:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 2BAA560096
	for <linux-media@vger.kernel.org>; Thu, 12 Jun 2014 19:10:21 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/5] smiapp: Use unlocked __v4l2_ctrl_modify_range()
Date: Thu, 12 Jun 2014 19:09:41 +0300
Message-Id: <1402589383-28165-4-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1402589383-28165-1-git-send-email-sakari.ailus@iki.fi>
References: <1402589383-28165-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

Instead of modifying the control ranges directly by manipulating struct
v4l2_ctrl, use __v4l2_ctrl_modify_range() for the purpose.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c |   47 ++++++++++----------------------
 1 file changed, 15 insertions(+), 32 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 446c82c..c669525 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -319,13 +319,7 @@ static void __smiapp_update_exposure_limits(struct smiapp_sensor *sensor)
 		+ sensor->vblank->val
 		- sensor->limits[SMIAPP_LIMIT_COARSE_INTEGRATION_TIME_MAX_MARGIN];
 
-	ctrl->maximum = max;
-	if (ctrl->default_value > max)
-		ctrl->default_value = max;
-	if (ctrl->val > max)
-		ctrl->val = max;
-	if (ctrl->cur.val > max)
-		ctrl->cur.val = max;
+	__v4l2_ctrl_modify_range(ctrl, ctrl->minimum, max, ctrl->step, max);
 }
 
 /*
@@ -782,36 +776,25 @@ static void smiapp_update_blanking(struct smiapp_sensor *sensor)
 {
 	struct v4l2_ctrl *vblank = sensor->vblank;
 	struct v4l2_ctrl *hblank = sensor->hblank;
+	int min, max;
 
-	vblank->minimum =
-		max_t(int,
-		      sensor->limits[SMIAPP_LIMIT_MIN_FRAME_BLANKING_LINES],
-		      sensor->limits[SMIAPP_LIMIT_MIN_FRAME_LENGTH_LINES_BIN] -
-		      sensor->pixel_array->crop[SMIAPP_PA_PAD_SRC].height);
-	vblank->maximum =
-		sensor->limits[SMIAPP_LIMIT_MAX_FRAME_LENGTH_LINES_BIN] -
+	min = max_t(int,
+		    sensor->limits[SMIAPP_LIMIT_MIN_FRAME_BLANKING_LINES],
+		    sensor->limits[SMIAPP_LIMIT_MIN_FRAME_LENGTH_LINES_BIN] -
+		    sensor->pixel_array->crop[SMIAPP_PA_PAD_SRC].height);
+	max = sensor->limits[SMIAPP_LIMIT_MAX_FRAME_LENGTH_LINES_BIN] -
 		sensor->pixel_array->crop[SMIAPP_PA_PAD_SRC].height;
 
-	vblank->val = clamp_t(int, vblank->val,
-			      vblank->minimum, vblank->maximum);
-	vblank->default_value = vblank->minimum;
-	vblank->val = vblank->val;
-	vblank->cur.val = vblank->val;
-
-	hblank->minimum =
-		max_t(int,
-		      sensor->limits[SMIAPP_LIMIT_MIN_LINE_LENGTH_PCK_BIN] -
-		      sensor->pixel_array->crop[SMIAPP_PA_PAD_SRC].width,
-		      sensor->limits[SMIAPP_LIMIT_MIN_LINE_BLANKING_PCK_BIN]);
-	hblank->maximum =
-		sensor->limits[SMIAPP_LIMIT_MAX_LINE_LENGTH_PCK_BIN] -
+	__v4l2_ctrl_modify_range(vblank, min, max, vblank->step, min);
+
+	min = max_t(int,
+		    sensor->limits[SMIAPP_LIMIT_MIN_LINE_LENGTH_PCK_BIN] -
+		    sensor->pixel_array->crop[SMIAPP_PA_PAD_SRC].width,
+		    sensor->limits[SMIAPP_LIMIT_MIN_LINE_BLANKING_PCK_BIN]);
+	max = sensor->limits[SMIAPP_LIMIT_MAX_LINE_LENGTH_PCK_BIN] -
 		sensor->pixel_array->crop[SMIAPP_PA_PAD_SRC].width;
 
-	hblank->val = clamp_t(int, hblank->val,
-			      hblank->minimum, hblank->maximum);
-	hblank->default_value = hblank->minimum;
-	hblank->val = hblank->val;
-	hblank->cur.val = hblank->val;
+	__v4l2_ctrl_modify_range(hblank, min, max, hblank->step, min);
 
 	__smiapp_update_exposure_limits(sensor);
 }
-- 
1.7.10.4

