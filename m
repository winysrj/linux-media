Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42370 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbaEGPkf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 May 2014 11:40:35 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH] mt9p031: Really disable Black Level Calibration in test pattern mode
Date: Wed,  7 May 2014 17:40:55 +0200
Message-Id: <1399477255-21207-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The digital side of the Black Level Calibration (BLC) function must be
disabled when generating a test pattern to avoid artifacts in the image.
The driver disables BLC correctly at the hardware level, but the feature
gets reenabled by v4l2_ctrl_handler_setup() the next time the device is
powered on.

Fix this by marking the BLC controls as inactive when generating a test
pattern, and ignoring control set requests on inactive controls.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/mt9p031.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
index 33daace..9102b23 100644
--- a/drivers/media/i2c/mt9p031.c
+++ b/drivers/media/i2c/mt9p031.c
@@ -655,6 +655,9 @@ static int mt9p031_s_ctrl(struct v4l2_ctrl *ctrl)
 	u16 data;
 	int ret;
 
+	if (ctrl->flags & V4L2_CTRL_FLAG_INACTIVE)
+		return 0;
+
 	switch (ctrl->id) {
 	case V4L2_CID_EXPOSURE:
 		ret = mt9p031_write(client, MT9P031_SHUTTER_WIDTH_UPPER,
@@ -709,8 +712,16 @@ static int mt9p031_s_ctrl(struct v4l2_ctrl *ctrl)
 					MT9P031_READ_MODE_2_ROW_MIR, 0);
 
 	case V4L2_CID_TEST_PATTERN:
+		/* The digital side of the Black Level Calibration function must
+		 * be disabled when generating a test pattern to avoid artifacts
+		 * in the image. Activate (deactivate) the BLC-related controls
+		 * when the test pattern is enabled (disabled).
+		 */
+		v4l2_ctrl_activate(mt9p031->blc_auto, ctrl->val == 0);
+		v4l2_ctrl_activate(mt9p031->blc_offset, ctrl->val == 0);
+
 		if (!ctrl->val) {
-			/* Restore the black level compensation settings. */
+			/* Restore the BLC settings. */
 			if (mt9p031->blc_auto->cur.val != 0) {
 				ret = mt9p031_s_ctrl(mt9p031->blc_auto);
 				if (ret < 0)
@@ -735,9 +746,7 @@ static int mt9p031_s_ctrl(struct v4l2_ctrl *ctrl)
 		if (ret < 0)
 			return ret;
 
-		/* Disable digital black level compensation when using a test
-		 * pattern.
-		 */
+		/* Disable digital BLC when generating a test pattern. */
 		ret = mt9p031_set_mode2(mt9p031, MT9P031_READ_MODE_2_ROW_BLC,
 					0);
 		if (ret < 0)
-- 
Regards,

Laurent Pinchart

