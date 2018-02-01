Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:44603 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751423AbeBAIof (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Feb 2018 03:44:35 -0500
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>
CC: <linux-media@vger.kernel.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v2] media: ov5640: various typo & style fixes
Date: Thu, 1 Feb 2018 09:44:06 +0100
Message-ID: <1517474646-18785-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Various typo & style fixes either detected by code
review or checkpatch.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
version 2:
   As per Sakari's review comment:
  - Drop module_param() permission update, will be pushed into a new commit
  - Drop changes related to checkpatch "CHECK: Lines should not end with a '('
    style result is worse than before

 drivers/media/i2c/ov5640.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 6f18460..696a28b 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -14,14 +14,14 @@
 #include <linux/ctype.h>
 #include <linux/delay.h>
 #include <linux/device.h>
+#include <linux/gpio/consumer.h>
 #include <linux/i2c.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/of_device.h>
+#include <linux/regulator/consumer.h>
 #include <linux/slab.h>
 #include <linux/types.h>
-#include <linux/gpio/consumer.h>
-#include <linux/regulator/consumer.h>
 #include <media/v4l2-async.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
@@ -139,7 +139,7 @@ struct ov5640_pixfmt {
 
 /* regulator supplies */
 static const char * const ov5640_supply_name[] = {
-	"DOVDD", /* Digital I/O (1.8V) suppply */
+	"DOVDD", /* Digital I/O (1.8V) supply */
 	"DVDD",  /* Digital Core (1.5V) supply */
 	"AVDD",  /* Analog (2.8V) supply */
 };
@@ -245,7 +245,6 @@ static inline struct v4l2_subdev *ctrl_to_sd(struct v4l2_ctrl *ctrl)
  */
 
 static const struct reg_value ov5640_init_setting_30fps_VGA[] = {
-
 	{0x3103, 0x11, 0, 0}, {0x3008, 0x82, 0, 5}, {0x3008, 0x42, 0, 0},
 	{0x3103, 0x03, 0, 0}, {0x3017, 0x00, 0, 0}, {0x3018, 0x00, 0, 0},
 	{0x3034, 0x18, 0, 0}, {0x3035, 0x14, 0, 0}, {0x3036, 0x38, 0, 0},
@@ -334,7 +333,6 @@ static inline struct v4l2_subdev *ctrl_to_sd(struct v4l2_ctrl *ctrl)
 };
 
 static const struct reg_value ov5640_setting_30fps_VGA_640_480[] = {
-
 	{0x3035, 0x14, 0, 0}, {0x3036, 0x38, 0, 0}, {0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3820, 0x41, 0, 0}, {0x3821, 0x07, 0, 0}, {0x3814, 0x31, 0, 0},
@@ -377,7 +375,6 @@ static inline struct v4l2_subdev *ctrl_to_sd(struct v4l2_ctrl *ctrl)
 };
 
 static const struct reg_value ov5640_setting_30fps_XGA_1024_768[] = {
-
 	{0x3035, 0x14, 0, 0}, {0x3036, 0x38, 0, 0}, {0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3820, 0x41, 0, 0}, {0x3821, 0x07, 0, 0}, {0x3814, 0x31, 0, 0},
@@ -484,6 +481,7 @@ static inline struct v4l2_subdev *ctrl_to_sd(struct v4l2_ctrl *ctrl)
 	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
 	{0x3824, 0x02, 0, 0}, {0x5001, 0xa3, 0, 0},
 };
+
 static const struct reg_value ov5640_setting_15fps_QCIF_176_144[] = {
 	{0x3035, 0x22, 0, 0}, {0x3036, 0x38, 0, 0}, {0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
@@ -886,7 +884,7 @@ static int ov5640_read_reg16(struct ov5640_dev *sensor, u16 reg, u16 *val)
 	ret = ov5640_read_reg(sensor, reg, &hi);
 	if (ret)
 		return ret;
-	ret = ov5640_read_reg(sensor, reg+1, &lo);
+	ret = ov5640_read_reg(sensor, reg + 1, &lo);
 	if (ret)
 		return ret;
 
@@ -947,7 +945,7 @@ static int ov5640_load_regs(struct ov5640_dev *sensor,
 			break;
 
 		if (delay_ms)
-			usleep_range(1000*delay_ms, 1000*delay_ms+100);
+			usleep_range(1000 * delay_ms, 1000 * delay_ms + 100);
 	}
 
 	return ret;
@@ -1289,7 +1287,6 @@ static int ov5640_set_bandingfilter(struct ov5640_dev *sensor)
 		return ret;
 	prev_vts = ret;
 
-
 	/* calculate banding filter */
 	/* 60Hz */
 	band_step60 = sensor->prev_sysclk * 100 / sensor->prev_hts * 100 / 120;
@@ -1405,8 +1402,8 @@ static int ov5640_set_virtual_channel(struct ov5640_dev *sensor)
  * sensor changes between scaling and subsampling, go through
  * exposure calculation
  */
-static int ov5640_set_mode_exposure_calc(
-	struct ov5640_dev *sensor, const struct ov5640_mode_info *mode)
+static int ov5640_set_mode_exposure_calc(struct ov5640_dev *sensor,
+					 const struct ov5640_mode_info *mode)
 {
 	u32 prev_shutter, prev_gain16;
 	u32 cap_shutter, cap_gain16;
@@ -1416,7 +1413,7 @@ static int ov5640_set_mode_exposure_calc(
 	u8 average;
 	int ret;
 
-	if (mode->reg_data == NULL)
+	if (!mode->reg_data)
 		return -EINVAL;
 
 	/* read preview shutter */
@@ -1570,7 +1567,7 @@ static int ov5640_set_mode_direct(struct ov5640_dev *sensor,
 {
 	int ret;
 
-	if (mode->reg_data == NULL)
+	if (!mode->reg_data)
 		return -EINVAL;
 
 	/* Write capture setting */
@@ -2117,7 +2114,8 @@ static int ov5640_set_ctrl_gain(struct ov5640_dev *sensor, int auto_gain)
 
 	if (ctrls->auto_gain->is_new) {
 		ret = ov5640_mod_reg(sensor, OV5640_REG_AEC_PK_MANUAL,
-				     BIT(1), ctrls->auto_gain->val ? 0 : BIT(1));
+				     BIT(1),
+				     ctrls->auto_gain->val ? 0 : BIT(1));
 		if (ret)
 			return ret;
 	}
@@ -2297,10 +2295,12 @@ static int ov5640_enum_frame_size(struct v4l2_subdev *sd,
 	if (fse->index >= OV5640_NUM_MODES)
 		return -EINVAL;
 
-	fse->min_width = fse->max_width =
+	fse->min_width =
 		ov5640_mode_data[0][fse->index].width;
-	fse->min_height = fse->max_height =
+	fse->max_width = fse->min_width;
+	fse->min_height =
 		ov5640_mode_data[0][fse->index].height;
+	fse->max_height = fse->min_height;
 
 	return 0;
 }
@@ -2376,8 +2376,8 @@ static int ov5640_s_frame_interval(struct v4l2_subdev *sd,
 }
 
 static int ov5640_enum_mbus_code(struct v4l2_subdev *sd,
-				  struct v4l2_subdev_pad_config *cfg,
-				  struct v4l2_subdev_mbus_code_enum *code)
+				 struct v4l2_subdev_pad_config *cfg,
+				 struct v4l2_subdev_mbus_code_enum *code)
 {
 	if (code->pad != 0)
 		return -EINVAL;
-- 
1.9.1
