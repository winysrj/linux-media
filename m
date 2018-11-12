Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl1-f193.google.com ([209.85.214.193]:45107 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726221AbeKMBzI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Nov 2018 20:55:08 -0500
Received: by mail-pl1-f193.google.com with SMTP id r3-v6so3810166pls.12
        for <linux-media@vger.kernel.org>; Mon, 12 Nov 2018 08:01:17 -0800 (PST)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 2/7] media: mt9m111: add V4L2_CID_COLORFX control
Date: Tue, 13 Nov 2018 01:00:49 +0900
Message-Id: <1542038454-20066-3-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1542038454-20066-1-git-send-email-akinobu.mita@gmail.com>
References: <1542038454-20066-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The mt9m111 has special camera effects feature.  This makes use of
it through V4L2_CID_COLORFX control.

Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/i2c/mt9m111.c | 37 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/mt9m111.c b/drivers/media/i2c/mt9m111.c
index f4fc459..58d134d 100644
--- a/drivers/media/i2c/mt9m111.c
+++ b/drivers/media/i2c/mt9m111.c
@@ -102,6 +102,7 @@
 #define MT9M111_REDUCER_XSIZE_A		0x1a7
 #define MT9M111_REDUCER_YZOOM_A		0x1a9
 #define MT9M111_REDUCER_YSIZE_A		0x1aa
+#define MT9M111_EFFECTS_MODE		0x1e2
 
 #define MT9M111_OUTPUT_FORMAT_CTRL2_A	0x13a
 #define MT9M111_OUTPUT_FORMAT_CTRL2_B	0x19b
@@ -127,6 +128,7 @@
 #define MT9M111_OUTFMT_SWAP_YCbCr_C_Y_RGB_EVEN	(1 << 1)
 #define MT9M111_OUTFMT_SWAP_YCbCr_Cb_Cr_RGB_R_B	(1 << 0)
 #define MT9M111_TPG_SEL_MASK		GENMASK(2, 0)
+#define MT9M111_EFFECTS_MODE_MASK	GENMASK(2, 0)
 
 /*
  * Camera control register addresses (0x200..0x2ff not implemented)
@@ -727,6 +729,29 @@ static int mt9m111_set_test_pattern(struct mt9m111 *mt9m111, int val)
 				MT9M111_TPG_SEL_MASK);
 }
 
+static int mt9m111_set_colorfx(struct mt9m111 *mt9m111, int val)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&mt9m111->subdev);
+	static const struct v4l2_control colorfx[] = {
+		{ V4L2_COLORFX_NONE,		0 },
+		{ V4L2_COLORFX_BW,		1 },
+		{ V4L2_COLORFX_SEPIA,		2 },
+		{ V4L2_COLORFX_NEGATIVE,	3 },
+		{ V4L2_COLORFX_SOLARIZATION,	4 },
+	};
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(colorfx); i++) {
+		if (colorfx[i].id == val) {
+			return mt9m111_reg_mask(client, MT9M111_EFFECTS_MODE,
+						colorfx[i].value,
+						MT9M111_EFFECTS_MODE_MASK);
+		}
+	}
+
+	return -EINVAL;
+}
+
 static int mt9m111_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct mt9m111 *mt9m111 = container_of(ctrl->handler,
@@ -747,6 +772,8 @@ static int mt9m111_s_ctrl(struct v4l2_ctrl *ctrl)
 		return mt9m111_set_autowhitebalance(mt9m111, ctrl->val);
 	case V4L2_CID_TEST_PATTERN:
 		return mt9m111_set_test_pattern(mt9m111, ctrl->val);
+	case V4L2_CID_COLORFX:
+		return mt9m111_set_colorfx(mt9m111, ctrl->val);
 	}
 
 	return -EINVAL;
@@ -983,7 +1010,7 @@ static int mt9m111_probe(struct i2c_client *client,
 	mt9m111->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE |
 				 V4L2_SUBDEV_FL_HAS_EVENTS;
 
-	v4l2_ctrl_handler_init(&mt9m111->hdl, 5);
+	v4l2_ctrl_handler_init(&mt9m111->hdl, 7);
 	v4l2_ctrl_new_std(&mt9m111->hdl, &mt9m111_ctrl_ops,
 			V4L2_CID_VFLIP, 0, 1, 1, 0);
 	v4l2_ctrl_new_std(&mt9m111->hdl, &mt9m111_ctrl_ops,
@@ -999,6 +1026,14 @@ static int mt9m111_probe(struct i2c_client *client,
 			&mt9m111_ctrl_ops, V4L2_CID_TEST_PATTERN,
 			ARRAY_SIZE(mt9m111_test_pattern_menu) - 1, 0, 0,
 			mt9m111_test_pattern_menu);
+	v4l2_ctrl_new_std_menu(&mt9m111->hdl, &mt9m111_ctrl_ops,
+			V4L2_CID_COLORFX, V4L2_COLORFX_SOLARIZATION,
+			~(BIT(V4L2_COLORFX_NONE) |
+				BIT(V4L2_COLORFX_BW) |
+				BIT(V4L2_COLORFX_SEPIA) |
+				BIT(V4L2_COLORFX_NEGATIVE) |
+				BIT(V4L2_COLORFX_SOLARIZATION)),
+			V4L2_COLORFX_NONE);
 	mt9m111->subdev.ctrl_handler = &mt9m111->hdl;
 	if (mt9m111->hdl.error) {
 		ret = mt9m111->hdl.error;
-- 
2.7.4
