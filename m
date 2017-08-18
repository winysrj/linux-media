Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:39479 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750729AbdHREbN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Aug 2017 00:31:13 -0400
From: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc: tfiga@chromium.org, jian.xu.zheng@intel.com,
        tian.shu.qiu@intel.com, rajmohan.mani@intel.com,
        hyungwoo.yang@intel.com,
        Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
Subject: [PATCH v1] media: ov13858: Limit vblank to permissible range
Date: Thu, 17 Aug 2017 21:29:38 -0700
Message-Id: <1503030578-647-1-git-send-email-chiranjeevi.rapolu@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Previously, vblank range given to user was too big, falling outside
of permissible range for a given resolution. Sometimes, too low vblank
resulted in errors.

Now, limit vblank to only permissible range for a given resolution.
This change limits lower-bounds of vblank, doesn't affect upper bounds.

Signed-off-by: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
---
 drivers/media/i2c/ov13858.c | 35 +++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/media/i2c/ov13858.c b/drivers/media/i2c/ov13858.c
index 45c0e96..af7af0d 100644
--- a/drivers/media/i2c/ov13858.c
+++ b/drivers/media/i2c/ov13858.c
@@ -57,7 +57,6 @@
 #define OV13858_VTS_30FPS		0x0c8e /* 30 fps */
 #define OV13858_VTS_60FPS		0x0648 /* 60 fps */
 #define OV13858_VTS_MAX			0x7fff
-#define OV13858_VBLANK_MIN		56
 
 /* HBLANK control - read only */
 #define OV13858_PPL_270MHZ		2244
@@ -120,7 +119,8 @@ struct ov13858_mode {
 	u32 height;
 
 	/* V-timing */
-	u32 vts;
+	u32 vts_def;
+	u32 vts_min;
 
 	/* Index of Link frequency config to be used */
 	u32 link_freq_index;
@@ -982,7 +982,8 @@ struct ov13858_mode {
 	{
 		.width = 4224,
 		.height = 3136,
-		.vts = OV13858_VTS_30FPS,
+		.vts_def = OV13858_VTS_30FPS,
+		.vts_min = OV13858_VTS_30FPS,
 		.reg_list = {
 			.num_of_regs = ARRAY_SIZE(mode_4224x3136_regs),
 			.regs = mode_4224x3136_regs,
@@ -992,7 +993,8 @@ struct ov13858_mode {
 	{
 		.width = 2112,
 		.height = 1568,
-		.vts = OV13858_VTS_30FPS,
+		.vts_def = OV13858_VTS_30FPS,
+		.vts_min = 1608,
 		.reg_list = {
 			.num_of_regs = ARRAY_SIZE(mode_2112x1568_regs),
 			.regs = mode_2112x1568_regs,
@@ -1002,7 +1004,8 @@ struct ov13858_mode {
 	{
 		.width = 2112,
 		.height = 1188,
-		.vts = OV13858_VTS_30FPS,
+		.vts_def = OV13858_VTS_30FPS,
+		.vts_min = 1608,
 		.reg_list = {
 			.num_of_regs = ARRAY_SIZE(mode_2112x1188_regs),
 			.regs = mode_2112x1188_regs,
@@ -1012,7 +1015,8 @@ struct ov13858_mode {
 	{
 		.width = 1056,
 		.height = 784,
-		.vts = OV13858_VTS_30FPS,
+		.vts_def = OV13858_VTS_30FPS,
+		.vts_min = 804,
 		.reg_list = {
 			.num_of_regs = ARRAY_SIZE(mode_1056x784_regs),
 			.regs = mode_1056x784_regs,
@@ -1379,6 +1383,7 @@ static int ov13858_get_pad_format(struct v4l2_subdev *sd,
 	const struct ov13858_mode *mode;
 	struct v4l2_mbus_framefmt *framefmt;
 	s32 vblank_def;
+	s32 vblank_min;
 	s64 h_blank;
 
 	mutex_lock(&ov13858->mutex);
@@ -1399,9 +1404,12 @@ static int ov13858_get_pad_format(struct v4l2_subdev *sd,
 			ov13858->pixel_rate,
 			link_freq_configs[mode->link_freq_index].pixel_rate);
 		/* Update limits and set FPS to default */
-		vblank_def = ov13858->cur_mode->vts - ov13858->cur_mode->height;
+		vblank_def = ov13858->cur_mode->vts_def -
+			     ov13858->cur_mode->height;
+		vblank_min = ov13858->cur_mode->vts_min -
+			     ov13858->cur_mode->height;
 		__v4l2_ctrl_modify_range(
-			ov13858->vblank, OV13858_VBLANK_MIN,
+			ov13858->vblank, vblank_min,
 			OV13858_VTS_MAX - ov13858->cur_mode->height, 1,
 			vblank_def);
 		__v4l2_ctrl_s_ctrl(ov13858->vblank, vblank_def);
@@ -1607,6 +1615,8 @@ static int ov13858_init_controls(struct ov13858 *ov13858)
 	struct i2c_client *client = v4l2_get_subdevdata(&ov13858->sd);
 	struct v4l2_ctrl_handler *ctrl_hdlr;
 	s64 exposure_max;
+	s64 vblank_def;
+	s64 vblank_min;
 	int ret;
 
 	ctrl_hdlr = &ov13858->ctrl_handler;
@@ -1630,12 +1640,13 @@ static int ov13858_init_controls(struct ov13858 *ov13858)
 					link_freq_configs[0].pixel_rate, 1,
 					link_freq_configs[0].pixel_rate);
 
+	vblank_def = ov13858->cur_mode->vts_def - ov13858->cur_mode->height;
+	vblank_min = ov13858->cur_mode->vts_min - ov13858->cur_mode->height;
 	ov13858->vblank = v4l2_ctrl_new_std(
 				ctrl_hdlr, &ov13858_ctrl_ops, V4L2_CID_VBLANK,
-				OV13858_VBLANK_MIN,
+				vblank_min,
 				OV13858_VTS_MAX - ov13858->cur_mode->height, 1,
-				ov13858->cur_mode->vts
-				  - ov13858->cur_mode->height);
+				vblank_def);
 
 	ov13858->hblank = v4l2_ctrl_new_std(
 				ctrl_hdlr, &ov13858_ctrl_ops, V4L2_CID_HBLANK,
@@ -1645,7 +1656,7 @@ static int ov13858_init_controls(struct ov13858 *ov13858)
 				OV13858_PPL_540MHZ - ov13858->cur_mode->width);
 	ov13858->hblank->flags |= V4L2_CTRL_FLAG_READ_ONLY;
 
-	exposure_max = ov13858->cur_mode->vts - 8;
+	exposure_max = ov13858->cur_mode->vts_def - 8;
 	ov13858->exposure = v4l2_ctrl_new_std(
 				ctrl_hdlr, &ov13858_ctrl_ops,
 				V4L2_CID_EXPOSURE, OV13858_EXPOSURE_MIN,
-- 
1.9.1
