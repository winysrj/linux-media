Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48866 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbaEHNHk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 May 2014 09:07:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH] mt9p031: Fix BLC configuration restore when disabling test pattern
Date: Thu,  8 May 2014 15:08:01 +0200
Message-Id: <1399554481-5939-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Auto BLC and BLC digital offset are disabled when enabling the test
pattern and must be restored when disabling it. The driver does so by
calling the set control handler on the auto BLC and BLC offset controls,
but this programs the hardware with the new value of those controls, not
the current value. Fix this by writing to the registers directly.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/mt9p031.c | 36 ++++++++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 10 deletions(-)

diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
index 9102b23..e18797f 100644
--- a/drivers/media/i2c/mt9p031.c
+++ b/drivers/media/i2c/mt9p031.c
@@ -647,6 +647,28 @@ static int mt9p031_set_crop(struct v4l2_subdev *subdev,
 #define V4L2_CID_BLC_ANALOG_OFFSET	(V4L2_CID_USER_BASE | 0x1004)
 #define V4L2_CID_BLC_DIGITAL_OFFSET	(V4L2_CID_USER_BASE | 0x1005)
 
+static int mt9p031_restore_blc(struct mt9p031 *mt9p031)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&mt9p031->subdev);
+	int ret;
+
+	if (mt9p031->blc_auto->cur.val != 0) {
+		ret = mt9p031_set_mode2(mt9p031, 0,
+					MT9P031_READ_MODE_2_ROW_BLC);
+		if (ret < 0)
+			return ret;
+	}
+
+	if (mt9p031->blc_offset->cur.val != 0) {
+		ret = mt9p031_write(client, MT9P031_ROW_BLACK_TARGET,
+				    mt9p031->blc_offset->cur.val);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
 static int mt9p031_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct mt9p031 *mt9p031 =
@@ -722,16 +744,10 @@ static int mt9p031_s_ctrl(struct v4l2_ctrl *ctrl)
 
 		if (!ctrl->val) {
 			/* Restore the BLC settings. */
-			if (mt9p031->blc_auto->cur.val != 0) {
-				ret = mt9p031_s_ctrl(mt9p031->blc_auto);
-				if (ret < 0)
-					return ret;
-			}
-			if (mt9p031->blc_offset->cur.val != 0) {
-				ret = mt9p031_s_ctrl(mt9p031->blc_offset);
-				if (ret < 0)
-					return ret;
-			}
+			ret = mt9p031_restore_blc(mt9p031);
+			if (ret < 0)
+				return ret;
+
 			return mt9p031_write(client, MT9P031_TEST_PATTERN,
 					     MT9P031_TEST_PATTERN_DISABLE);
 		}
-- 
Regards,

Laurent Pinchart

