Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:42950 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753771AbdKXOlM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Nov 2017 09:41:12 -0500
Received: by mail-pl0-f65.google.com with SMTP id z3so4561987plh.9
        for <linux-media@vger.kernel.org>; Fri, 24 Nov 2017 06:41:11 -0800 (PST)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH] media: ov7670: add V4L2_CID_TEST_PATTERN control
Date: Fri, 24 Nov 2017 23:40:45 +0900
Message-Id: <1511534445-30512-2-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1511534445-30512-1-git-send-email-akinobu.mita@gmail.com>
References: <1511534445-30512-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ov7670 has the test pattern generator features.  This makes use of
it through V4L2_CID_TEST_PATTERN control.

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/i2c/ov7670.c | 46 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 45 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index b61d88e..c6c32f6 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -163,6 +163,11 @@ MODULE_PARM_DESC(debug, "Debug level (0-1)");
 #define   DBLV_X6	  0x10	  /* clock x6 */
 #define   DBLV_X8	  0x11	  /* clock x8 */
 
+#define REG_SCALING_XSC	0x70	/* Test pattern and horizontal scale factor */
+#define   TEST_PATTTERN_0 0x80
+#define REG_SCALING_YSC	0x71	/* Test pattern and vertical scale factor */
+#define   TEST_PATTTERN_1 0x80
+
 #define REG_REG76	0x76	/* OV's name */
 #define   R76_BLKPCOR	  0x80	  /* Black pixel correction enable */
 #define   R76_WHTPCOR	  0x40	  /* White pixel correction enable */
@@ -292,7 +297,8 @@ static struct regval_list ov7670_default_regs[] = {
 
 	{ REG_COM3, 0 },	{ REG_COM14, 0 },
 	/* Mystery scaling numbers */
-	{ 0x70, 0x3a },		{ 0x71, 0x35 },
+	{ REG_SCALING_XSC, 0x3a },
+	{ REG_SCALING_YSC, 0x35 },
 	{ 0x72, 0x11 },		{ 0x73, 0xf0 },
 	{ 0xa2, 0x02 },		{ REG_COM10, 0x0 },
 
@@ -568,6 +574,19 @@ static int ov7670_write(struct v4l2_subdev *sd, unsigned char reg,
 		return ov7670_write_i2c(sd, reg, value);
 }
 
+static int ov7670_update_bits(struct v4l2_subdev *sd, unsigned char reg,
+		unsigned char mask, unsigned char value)
+{
+	unsigned char orig;
+	int ret;
+
+	ret = ov7670_read(sd, reg, &orig);
+	if (ret)
+		return ret;
+
+	return ov7670_write(sd, reg, (orig & ~mask) | (value & mask));
+}
+
 /*
  * Write a list of register settings; ff/ff stops the process.
  */
@@ -1470,6 +1489,25 @@ static int ov7670_s_autoexp(struct v4l2_subdev *sd,
 	return ret;
 }
 
+static const char * const ov7670_test_pattern_menu[] = {
+	"No test output",
+	"Shifting \"1\"",
+	"8-bar color bar",
+	"Fade to gray color bar",
+};
+
+static int ov7670_s_test_pattern(struct v4l2_subdev *sd, int value)
+{
+	int ret;
+
+	ret = ov7670_update_bits(sd, REG_SCALING_XSC, TEST_PATTTERN_0,
+				value & BIT(0) ? TEST_PATTTERN_0 : 0);
+	if (ret)
+		return ret;
+
+	return ov7670_update_bits(sd, REG_SCALING_YSC, TEST_PATTTERN_1,
+				value & BIT(1) ? TEST_PATTTERN_1 : 0);
+}
 
 static int ov7670_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
 {
@@ -1516,6 +1554,8 @@ static int ov7670_s_ctrl(struct v4l2_ctrl *ctrl)
 			return ov7670_s_exp(sd, info->exposure->val);
 		}
 		return ov7670_s_autoexp(sd, ctrl->val);
+	case V4L2_CID_TEST_PATTERN:
+		return ov7670_s_test_pattern(sd, ctrl->val);
 	}
 	return -EINVAL;
 }
@@ -1770,6 +1810,10 @@ static int ov7670_probe(struct i2c_client *client,
 	info->auto_exposure = v4l2_ctrl_new_std_menu(&info->hdl, &ov7670_ctrl_ops,
 			V4L2_CID_EXPOSURE_AUTO, V4L2_EXPOSURE_MANUAL, 0,
 			V4L2_EXPOSURE_AUTO);
+	v4l2_ctrl_new_std_menu_items(&info->hdl, &ov7670_ctrl_ops,
+			V4L2_CID_TEST_PATTERN,
+			ARRAY_SIZE(ov7670_test_pattern_menu) - 1, 0, 0,
+			ov7670_test_pattern_menu);
 	sd->ctrl_handler = &info->hdl;
 	if (info->hdl.error) {
 		ret = info->hdl.error;
-- 
2.7.4
