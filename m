Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:34943 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753433AbdLTQd5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Dec 2017 11:33:57 -0500
Received: by mail-pg0-f68.google.com with SMTP id q20so12128293pgv.2
        for <linux-media@vger.kernel.org>; Wed, 20 Dec 2017 08:33:57 -0800 (PST)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 4/4] meida: mt9m111: add V4L2_CID_TEST_PATTERN control
Date: Thu, 21 Dec 2017 01:33:34 +0900
Message-Id: <1513787614-12008-5-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1513787614-12008-1-git-send-email-akinobu.mita@gmail.com>
References: <1513787614-12008-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The mt9m111 has the test pattern generator features.  This makes use of
it through V4L2_CID_TEST_PATTERN control.

Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/i2c/mt9m111.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/media/i2c/mt9m111.c b/drivers/media/i2c/mt9m111.c
index e1d5032..d74f254 100644
--- a/drivers/media/i2c/mt9m111.c
+++ b/drivers/media/i2c/mt9m111.c
@@ -92,6 +92,7 @@
  */
 #define MT9M111_OPER_MODE_CTRL		0x106
 #define MT9M111_OUTPUT_FORMAT_CTRL	0x108
+#define MT9M111_TPG_CTRL		0x148
 #define MT9M111_REDUCER_XZOOM_B		0x1a0
 #define MT9M111_REDUCER_XSIZE_B		0x1a1
 #define MT9M111_REDUCER_YZOOM_B		0x1a3
@@ -124,6 +125,7 @@
 #define MT9M111_OUTFMT_AVG_CHROMA	(1 << 2)
 #define MT9M111_OUTFMT_SWAP_YCbCr_C_Y_RGB_EVEN	(1 << 1)
 #define MT9M111_OUTFMT_SWAP_YCbCr_Cb_Cr_RGB_R_B	(1 << 0)
+#define MT9M111_TPG_SEL_MASK		GENMASK(2, 0)
 
 /*
  * Camera control register addresses (0x200..0x2ff not implemented)
@@ -706,6 +708,25 @@ static int mt9m111_set_autowhitebalance(struct mt9m111 *mt9m111, int on)
 	return reg_clear(OPER_MODE_CTRL, MT9M111_OPMODE_AUTOWHITEBAL_EN);
 }
 
+static const char * const mt9m111_test_pattern_menu[] = {
+	"Disabled",
+	"Vertical monochrome gradient",
+	"Flat color type 1",
+	"Flat color type 2",
+	"Flat color type 3",
+	"Flat color type 4",
+	"Flat color type 5",
+	"Color bar",
+};
+
+static int mt9m111_set_test_pattern(struct mt9m111 *mt9m111, int val)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&mt9m111->subdev);
+
+	return mt9m111_reg_mask(client, MT9M111_TPG_CTRL, val,
+				MT9M111_TPG_SEL_MASK);
+}
+
 static int mt9m111_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct mt9m111 *mt9m111 = container_of(ctrl->handler,
@@ -724,6 +745,8 @@ static int mt9m111_s_ctrl(struct v4l2_ctrl *ctrl)
 		return mt9m111_set_autoexposure(mt9m111, ctrl->val);
 	case V4L2_CID_AUTO_WHITE_BALANCE:
 		return mt9m111_set_autowhitebalance(mt9m111, ctrl->val);
+	case V4L2_CID_TEST_PATTERN:
+		return mt9m111_set_test_pattern(mt9m111, ctrl->val);
 	}
 
 	return -EINVAL;
@@ -968,6 +991,10 @@ static int mt9m111_probe(struct i2c_client *client,
 	v4l2_ctrl_new_std_menu(&mt9m111->hdl,
 			&mt9m111_ctrl_ops, V4L2_CID_EXPOSURE_AUTO, 1, 0,
 			V4L2_EXPOSURE_AUTO);
+	v4l2_ctrl_new_std_menu_items(&mt9m111->hdl,
+			&mt9m111_ctrl_ops, V4L2_CID_TEST_PATTERN,
+			ARRAY_SIZE(mt9m111_test_pattern_menu) - 1, 0, 0,
+			mt9m111_test_pattern_menu);
 	mt9m111->subdev.ctrl_handler = &mt9m111->hdl;
 	if (mt9m111->hdl.error) {
 		ret = mt9m111->hdl.error;
-- 
2.7.4
