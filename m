Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40715 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215Ab2D2RNu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Apr 2012 13:13:50 -0400
Received: from localhost.localdomain (unknown [91.178.160.63])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 81FFF7D13
	for <linux-media@vger.kernel.org>; Sun, 29 Apr 2012 19:13:48 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/3] mt9p031: Implement black level compensation control
Date: Sun, 29 Apr 2012 19:14:08 +0200
Message-Id: <1335719648-18239-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1335719648-18239-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1335719648-18239-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add four new controls to configure black level compensation (BLC):

- V4L2_CID_BLC_AUTO selects between manual and auto BLC
- V4L2_CID_BLC_TARGET_LEVEL sets the target level for auto BLC
- V4L2_CID_BLC_ANALOG_OFFSET sets the analog offset for manual BLC
- V4L2_CID_BLC_DIGITAL_OFFSET sets the digital offset for manual BLC

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/mt9p031.c |  118 ++++++++++++++++++++++++++++++++++++++---
 1 files changed, 111 insertions(+), 7 deletions(-)

diff --git a/drivers/media/video/mt9p031.c b/drivers/media/video/mt9p031.c
index 3a93631..8f061d9 100644
--- a/drivers/media/video/mt9p031.c
+++ b/drivers/media/video/mt9p031.c
@@ -91,7 +91,14 @@
 #define		MT9P031_GLOBAL_GAIN_MAX			1024
 #define		MT9P031_GLOBAL_GAIN_DEF			8
 #define		MT9P031_GLOBAL_GAIN_MULT		(1 << 6)
+#define MT9P031_ROW_BLACK_TARGET			0x49
 #define MT9P031_ROW_BLACK_DEF_OFFSET			0x4b
+#define MT9P031_GREEN1_OFFSET				0x60
+#define MT9P031_GREEN2_OFFSET				0x61
+#define MT9P031_BLACK_LEVEL_CALIBRATION			0x62
+#define		MT9P031_BLC_MANUAL_BLC			(1 << 0)
+#define MT9P031_RED_OFFSET				0x63
+#define MT9P031_BLUE_OFFSET				0x64
 #define MT9P031_TEST_PATTERN				0xa0
 #define		MT9P031_TEST_PATTERN_SHIFT		3
 #define		MT9P031_TEST_PATTERN_ENABLE		(1 << 0)
@@ -110,7 +117,6 @@ struct mt9p031 {
 	struct media_pad pad;
 	struct v4l2_rect crop;  /* Sensor window */
 	struct v4l2_mbus_framefmt format;
-	struct v4l2_ctrl_handler ctrls;
 	struct mt9p031_platform_data *pdata;
 	struct mutex power_lock; /* lock to protect power_count */
 	int power_count;
@@ -119,6 +125,10 @@ struct mt9p031 {
 	struct aptina_pll pll;
 	int reset;
 
+	struct v4l2_ctrl_handler ctrls;
+	struct v4l2_ctrl *blc_auto;
+	struct v4l2_ctrl *blc_offset;
+
 	/* Registers cache */
 	u16 output_control;
 	u16 mode2;
@@ -565,6 +575,10 @@ static int mt9p031_set_crop(struct v4l2_subdev *subdev,
  */
 
 #define V4L2_CID_TEST_PATTERN		(V4L2_CID_USER_BASE | 0x1001)
+#define V4L2_CID_BLC_AUTO		(V4L2_CID_USER_BASE | 0x1002)
+#define V4L2_CID_BLC_TARGET_LEVEL	(V4L2_CID_USER_BASE | 0x1003)
+#define V4L2_CID_BLC_ANALOG_OFFSET	(V4L2_CID_USER_BASE | 0x1004)
+#define V4L2_CID_BLC_DIGITAL_OFFSET	(V4L2_CID_USER_BASE | 0x1005)
 
 static int mt9p031_s_ctrl(struct v4l2_ctrl *ctrl)
 {
@@ -629,11 +643,17 @@ static int mt9p031_s_ctrl(struct v4l2_ctrl *ctrl)
 
 	case V4L2_CID_TEST_PATTERN:
 		if (!ctrl->val) {
-			ret = mt9p031_set_mode2(mt9p031,
-					0, MT9P031_READ_MODE_2_ROW_BLC);
-			if (ret < 0)
-				return ret;
-
+			/* Restore the black level compensation settings. */
+			if (mt9p031->blc_auto->cur.val != 0) {
+				ret = mt9p031_s_ctrl(mt9p031->blc_auto);
+				if (ret < 0)
+					return ret;
+			}
+			if (mt9p031->blc_offset->cur.val != 0) {
+				ret = mt9p031_s_ctrl(mt9p031->blc_offset);
+				if (ret < 0)
+					return ret;
+			}
 			return mt9p031_write(client, MT9P031_TEST_PATTERN,
 					     MT9P031_TEST_PATTERN_DISABLE);
 		}
@@ -648,10 +668,14 @@ static int mt9p031_s_ctrl(struct v4l2_ctrl *ctrl)
 		if (ret < 0)
 			return ret;
 
+		/* Disable digital black level compensation when using a test
+		 * pattern.
+		 */
 		ret = mt9p031_set_mode2(mt9p031, MT9P031_READ_MODE_2_ROW_BLC,
 					0);
 		if (ret < 0)
 			return ret;
+
 		ret = mt9p031_write(client, MT9P031_ROW_BLACK_DEF_OFFSET, 0);
 		if (ret < 0)
 			return ret;
@@ -659,7 +683,40 @@ static int mt9p031_s_ctrl(struct v4l2_ctrl *ctrl)
 		return mt9p031_write(client, MT9P031_TEST_PATTERN,
 				((ctrl->val - 1) << MT9P031_TEST_PATTERN_SHIFT)
 				| MT9P031_TEST_PATTERN_ENABLE);
+
+	case V4L2_CID_BLC_AUTO:
+		ret = mt9p031_set_mode2(mt9p031,
+				ctrl->val ? 0 : MT9P031_READ_MODE_2_ROW_BLC,
+				ctrl->val ? MT9P031_READ_MODE_2_ROW_BLC : 0);
+		if (ret < 0)
+			return ret;
+
+		return mt9p031_write(client, MT9P031_BLACK_LEVEL_CALIBRATION,
+				     ctrl->val ? 0 : MT9P031_BLC_MANUAL_BLC);
+
+	case V4L2_CID_BLC_TARGET_LEVEL:
+		return mt9p031_write(client, MT9P031_ROW_BLACK_TARGET,
+				     ctrl->val);
+
+	case V4L2_CID_BLC_ANALOG_OFFSET:
+		data = ctrl->val & ((1 << 9) - 1);
+
+		ret = mt9p031_write(client, MT9P031_GREEN1_OFFSET, data);
+		if (ret < 0)
+			return ret;
+		ret = mt9p031_write(client, MT9P031_GREEN2_OFFSET, data);
+		if (ret < 0)
+			return ret;
+		ret = mt9p031_write(client, MT9P031_RED_OFFSET, data);
+		if (ret < 0)
+			return ret;
+		return mt9p031_write(client, MT9P031_BLUE_OFFSET, data);
+
+	case V4L2_CID_BLC_DIGITAL_OFFSET:
+		return mt9p031_write(client, MT9P031_ROW_BLACK_DEF_OFFSET,
+				     ctrl->val & ((1 << 12) - 1));
 	}
+
 	return 0;
 }
 
@@ -693,6 +750,46 @@ static const struct v4l2_ctrl_config mt9p031_ctrls[] = {
 		.flags		= 0,
 		.menu_skip_mask	= 0,
 		.qmenu		= mt9p031_test_pattern_menu,
+	}, {
+		.ops		= &mt9p031_ctrl_ops,
+		.id		= V4L2_CID_BLC_AUTO,
+		.type		= V4L2_CTRL_TYPE_BOOLEAN,
+		.name		= "BLC, Auto",
+		.min		= 0,
+		.max		= 1,
+		.step		= 1,
+		.def		= 1,
+		.flags		= 0,
+	}, {
+		.ops		= &mt9p031_ctrl_ops,
+		.id		= V4L2_CID_BLC_TARGET_LEVEL,
+		.type		= V4L2_CTRL_TYPE_INTEGER,
+		.name		= "BLC Target Level",
+		.min		= 0,
+		.max		= 4095,
+		.step		= 1,
+		.def		= 168,
+		.flags		= 0,
+	}, {
+		.ops		= &mt9p031_ctrl_ops,
+		.id		= V4L2_CID_BLC_ANALOG_OFFSET,
+		.type		= V4L2_CTRL_TYPE_INTEGER,
+		.name		= "BLC Analog Offset",
+		.min		= -255,
+		.max		= 255,
+		.step		= 1,
+		.def		= 32,
+		.flags		= 0,
+	}, {
+		.ops		= &mt9p031_ctrl_ops,
+		.id		= V4L2_CID_BLC_DIGITAL_OFFSET,
+		.type		= V4L2_CTRL_TYPE_INTEGER,
+		.name		= "BLC Digital Offset",
+		.min		= -2048,
+		.max		= 2047,
+		.step		= 1,
+		.def		= 40,
+		.flags		= 0,
 	}
 };
 
@@ -872,9 +969,16 @@ static int mt9p031_probe(struct i2c_client *client,
 
 	mt9p031->subdev.ctrl_handler = &mt9p031->ctrls;
 
-	if (mt9p031->ctrls.error)
+	if (mt9p031->ctrls.error) {
 		printk(KERN_INFO "%s: control initialization error %d\n",
 		       __func__, mt9p031->ctrls.error);
+		ret = mt9p031->ctrls.error;
+		goto done;
+	}
+
+	mt9p031->blc_auto = v4l2_ctrl_find(&mt9p031->ctrls, V4L2_CID_BLC_AUTO);
+	mt9p031->blc_offset = v4l2_ctrl_find(&mt9p031->ctrls,
+					     V4L2_CID_BLC_DIGITAL_OFFSET);
 
 	mutex_init(&mt9p031->power_lock);
 	v4l2_i2c_subdev_init(&mt9p031->subdev, client, &mt9p031_subdev_ops);
-- 
1.7.3.4

