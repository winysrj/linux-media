Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:53252 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753005AbdHQWRa (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Aug 2017 18:17:30 -0400
From: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc: tfiga@chromium.org, jian.xu.zheng@intel.com,
        tian.shu.qiu@intel.com, rajmohan.mani@intel.com,
        hyungwoo.yang@intel.com,
        Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
Subject: [PATCH v1] media: ov5670: Limit vblank to permissible range
Date: Thu, 17 Aug 2017 15:15:48 -0700
Message-Id: <1503008148-30831-1-git-send-email-chiranjeevi.rapolu@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Previously, vblank range given to user was too big, falling outside
of permissible range for a given resolution. Sometimes, too low vblank
resulted in errors.

Now, limit vblank to only permissible range for a given resolution.
This change limits lower-bounds of vblank, doesn't affect upper bounds.

Signed-off-by: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
---
 drivers/media/i2c/ov5670.c | 40 ++++++++++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 14 deletions(-)

diff --git a/drivers/media/i2c/ov5670.c b/drivers/media/i2c/ov5670.c
index 8d8e16c..ddb7009 100644
--- a/drivers/media/i2c/ov5670.c
+++ b/drivers/media/i2c/ov5670.c
@@ -33,7 +33,6 @@
 #define OV5670_REG_VTS			0x380e
 #define OV5670_VTS_30FPS		0x0808 /* default for 30 fps */
 #define OV5670_VTS_MAX			0xffff
-#define OV5670_VBLANK_MIN		56
 
 /* horizontal-timings from sensor */
 #define OV5670_REG_HTS			0x380c
@@ -94,8 +93,11 @@ struct ov5670_mode {
 	/* Frame height in pixels */
 	u32 height;
 
-	/* Vertical timining size */
-	u32 vts;
+	/* Default vertical timining size */
+	u32 vts_def;
+
+	/* Min vertical timining size */
+	u32 vts_min;
 
 	/* Link frequency needed for this resolution */
 	u32 link_freq_index;
@@ -1731,7 +1733,8 @@ struct ov5670_mode {
 	{
 		.width = 2592,
 		.height = 1944,
-		.vts = OV5670_VTS_30FPS,
+		.vts_def = OV5670_VTS_30FPS,
+		.vts_min = OV5670_VTS_30FPS,
 		.reg_list = {
 			.num_of_regs = ARRAY_SIZE(mode_2592x1944_regs),
 			.regs = mode_2592x1944_regs,
@@ -1741,7 +1744,8 @@ struct ov5670_mode {
 	{
 		.width = 1296,
 		.height = 972,
-		.vts = OV5670_VTS_30FPS,
+		.vts_def = OV5670_VTS_30FPS,
+		.vts_min = 996,
 		.reg_list = {
 			.num_of_regs = ARRAY_SIZE(mode_1296x972_regs),
 			.regs = mode_1296x972_regs,
@@ -1751,7 +1755,8 @@ struct ov5670_mode {
 	{
 		.width = 648,
 		.height = 486,
-		.vts = OV5670_VTS_30FPS,
+		.vts_def = OV5670_VTS_30FPS,
+		.vts_min = 516,
 		.reg_list = {
 			.num_of_regs = ARRAY_SIZE(mode_648x486_regs),
 			.regs = mode_648x486_regs,
@@ -1761,7 +1766,8 @@ struct ov5670_mode {
 	{
 		.width = 2560,
 		.height = 1440,
-		.vts = OV5670_VTS_30FPS,
+		.vts_def = OV5670_VTS_30FPS,
+		.vts_min = OV5670_VTS_30FPS,
 		.reg_list = {
 			.num_of_regs = ARRAY_SIZE(mode_2560x1440_regs),
 			.regs = mode_2560x1440_regs,
@@ -1771,7 +1777,8 @@ struct ov5670_mode {
 	{
 		.width = 1280,
 		.height = 720,
-		.vts = OV5670_VTS_30FPS,
+		.vts_def = OV5670_VTS_30FPS,
+		.vts_min = 1020,
 		.reg_list = {
 			.num_of_regs = ARRAY_SIZE(mode_1280x720_regs),
 			.regs = mode_1280x720_regs,
@@ -1781,7 +1788,8 @@ struct ov5670_mode {
 	{
 		.width = 640,
 		.height = 360,
-		.vts = OV5670_VTS_30FPS,
+		.vts_def = OV5670_VTS_30FPS,
+		.vts_min = 510,
 		.reg_list = {
 			.num_of_regs = ARRAY_SIZE(mode_640x360_regs),
 			.regs = mode_640x360_regs,
@@ -2047,6 +2055,7 @@ static int ov5670_init_controls(struct ov5670 *ov5670)
 	struct v4l2_ctrl_handler *ctrl_hdlr;
 	s64 vblank_max;
 	s64 vblank_def;
+	s64 vblank_min;
 	s64 exposure_max;
 	int ret;
 
@@ -2071,9 +2080,10 @@ static int ov5670_init_controls(struct ov5670 *ov5670)
 					       link_freq_configs[0].pixel_rate);
 
 	vblank_max = OV5670_VTS_MAX - ov5670->cur_mode->height;
-	vblank_def = ov5670->cur_mode->vts - ov5670->cur_mode->height;
+	vblank_def = ov5670->cur_mode->vts_def - ov5670->cur_mode->height;
+	vblank_min = ov5670->cur_mode->vts_min - ov5670->cur_mode->height;
 	ov5670->vblank = v4l2_ctrl_new_std(ctrl_hdlr, &ov5670_ctrl_ops,
-					   V4L2_CID_VBLANK, OV5670_VBLANK_MIN,
+					   V4L2_CID_VBLANK, vblank_min,
 					   vblank_max, 1, vblank_def);
 
 	ov5670->hblank = v4l2_ctrl_new_std(
@@ -2093,7 +2103,7 @@ static int ov5670_init_controls(struct ov5670 *ov5670)
 			  OV5670_DGTL_GAIN_STEP, OV5670_DGTL_GAIN_DEFAULT);
 
 	/* Get min, max, step, default from sensor */
-	exposure_max = ov5670->cur_mode->vts - 8;
+	exposure_max = ov5670->cur_mode->vts_def - 8;
 	ov5670->exposure = v4l2_ctrl_new_std(ctrl_hdlr, &ov5670_ctrl_ops,
 					     V4L2_CID_EXPOSURE,
 					     OV5670_EXPOSURE_MIN,
@@ -2241,9 +2251,11 @@ static int ov5670_set_pad_format(struct v4l2_subdev *sd,
 			ov5670->pixel_rate,
 			link_freq_configs[mode->link_freq_index].pixel_rate);
 		/* Update limits and set FPS to default */
-		vblank_def = ov5670->cur_mode->vts - ov5670->cur_mode->height;
+		vblank_def = ov5670->cur_mode->vts_def -
+			     ov5670->cur_mode->height;
 		__v4l2_ctrl_modify_range(
-			ov5670->vblank, OV5670_VBLANK_MIN,
+			ov5670->vblank,
+			ov5670->cur_mode->vts_min - ov5670->cur_mode->height,
 			OV5670_VTS_MAX - ov5670->cur_mode->height, 1,
 			vblank_def);
 		__v4l2_ctrl_s_ctrl(ov5670->vblank, vblank_def);
-- 
1.9.1
