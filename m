Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:11289 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753095AbdG1XWv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Jul 2017 19:22:51 -0400
From: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc: tfiga@chromium.org, jian.xu.zheng@intel.com,
        tian.shu.qiu@intel.com, rajmohan.mani@intel.com,
        hyungwoo.yang@intel.com,
        Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
Subject: [PATCH v1] media: ov13858: Increase digital gain granularity, range
Date: Fri, 28 Jul 2017 16:21:03 -0700
Message-Id: <1501284063-23771-1-git-send-email-chiranjeevi.rapolu@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Previously, possible digital gains were just 1x, 2x and 4x. These
coarse gains were not sufficient in fine-tuning the image capture.

Now, digital gain range is [0, 16x] with each step 1/1024, default 1x.
This is achieved through OV13858 MWB R/G/B gain controls.

Signed-off-by: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
---
 drivers/media/i2c/ov13858.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/media/i2c/ov13858.c b/drivers/media/i2c/ov13858.c
index 86550d8..b78e323b 100644
--- a/drivers/media/i2c/ov13858.c
+++ b/drivers/media/i2c/ov13858.c
@@ -78,13 +78,13 @@
 #define OV13858_ANA_GAIN_DEFAULT	0x80
 
 /* Digital gain control */
-#define OV13858_REG_DIGITAL_GAIN	0x350a
-#define OV13858_DGTL_GAIN_MASK		0xf3
-#define OV13858_DGTL_GAIN_SHIFT		2
-#define OV13858_DGTL_GAIN_MIN		1
-#define OV13858_DGTL_GAIN_MAX		4
-#define OV13858_DGTL_GAIN_STEP		1
-#define OV13858_DGTL_GAIN_DEFAULT	1
+#define OV13858_REG_B_MWB_GAIN		0x5100
+#define OV13858_REG_G_MWB_GAIN		0x5102
+#define OV13858_REG_R_MWB_GAIN		0x5104
+#define OV13858_DGTL_GAIN_MIN		0
+#define OV13858_DGTL_GAIN_MAX		16384	/* Max = 16 X */
+#define OV13858_DGTL_GAIN_DEFAULT	1024	/* Default gain = 1 X */
+#define OV13858_DGTL_GAIN_STEP		1	/* Each step = 1/1024 */
 
 /* Test Pattern Control */
 #define OV13858_REG_TEST_PATTERN	0x4503
@@ -1161,21 +1161,21 @@ static int ov13858_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 static int ov13858_update_digital_gain(struct ov13858 *ov13858, u32 d_gain)
 {
 	int ret;
-	u32 val;
 
-	if (d_gain == 3)
-		return -EINVAL;
+	ret = ov13858_write_reg(ov13858, OV13858_REG_B_MWB_GAIN,
+				OV13858_REG_VALUE_16BIT, d_gain);
+	if (ret)
+		return ret;
 
-	ret = ov13858_read_reg(ov13858, OV13858_REG_DIGITAL_GAIN,
-			       OV13858_REG_VALUE_08BIT, &val);
+	ret = ov13858_write_reg(ov13858, OV13858_REG_G_MWB_GAIN,
+				OV13858_REG_VALUE_16BIT, d_gain);
 	if (ret)
 		return ret;
 
-	val &= OV13858_DGTL_GAIN_MASK;
-	val |= (d_gain - 1) << OV13858_DGTL_GAIN_SHIFT;
+	ret = ov13858_write_reg(ov13858, OV13858_REG_R_MWB_GAIN,
+				OV13858_REG_VALUE_16BIT, d_gain);
 
-	return ov13858_write_reg(ov13858, OV13858_REG_DIGITAL_GAIN,
-				 OV13858_REG_VALUE_08BIT, val);
+	return ret;
 }
 
 static int ov13858_enable_test_pattern(struct ov13858 *ov13858, u32 pattern)
-- 
1.9.1
