Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:10314 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751555AbdHITUT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Aug 2017 15:20:19 -0400
From: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc: tfiga@chromium.org, jian.xu.zheng@intel.com,
        tian.shu.qiu@intel.com, rajmohan.mani@intel.com,
        hyungwoo.yang@intel.com,
        Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
Subject: [PATCH v1] media: ov5670: Fix incorrect fps reported by user
Date: Wed,  9 Aug 2017 12:17:42 -0700
Message-Id: <1502306262-30400-1-git-send-email-chiranjeevi.rapolu@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Previously, pixel-rate/(pixels-per-line * lines-per-frame) was
yielding incorrect fps for the user. This results in much lower fps
reported by user than the actual fps on the bus.

OV sensor is using internal timing and this requires
conversion (internal timing -> PPL) for correct HBLANK calculation.

Now, change pixels-per-line domain from internal sensor clock to
pixels domain. Set HBLANK read-only because fixed PPL is used for all
resolutions. And, use more accurate link-frequency 422.4MHz instead of
rounding down to 420MHz.

Signed-off-by: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
---
 drivers/media/i2c/ov5670.c | 31 +++++++++++++------------------
 1 file changed, 13 insertions(+), 18 deletions(-)

diff --git a/drivers/media/i2c/ov5670.c b/drivers/media/i2c/ov5670.c
index 8d8e16c..f42b21e 100644
--- a/drivers/media/i2c/ov5670.c
+++ b/drivers/media/i2c/ov5670.c
@@ -37,7 +37,7 @@
 
 /* horizontal-timings from sensor */
 #define OV5670_REG_HTS			0x380c
-#define OV5670_DEF_PPL			3360	/* Default pixels per line */
+#define OV5670_DEF_PPL			2724	/* Default pixels per line */
 
 /* Exposure controls from sensor */
 #define OV5670_REG_EXPOSURE		0x3500
@@ -1705,12 +1705,12 @@ struct ov5670_mode {
 };
 
 /* Supported link frequencies */
-#define OV5670_LINK_FREQ_420MHZ		420000000
-#define OV5670_LINK_FREQ_420MHZ_INDEX	0
+#define OV5670_LINK_FREQ_422MHZ		422400000
+#define OV5670_LINK_FREQ_422MHZ_INDEX	0
 static const struct ov5670_link_freq_config link_freq_configs[] = {
 	{
 		/* pixel_rate = link_freq * 2 * nr_of_lanes / bits_per_sample */
-		.pixel_rate = (OV5670_LINK_FREQ_420MHZ * 2 * 2) / 10,
+		.pixel_rate = (OV5670_LINK_FREQ_422MHZ * 2 * 2) / 10,
 		.reg_list = {
 			.num_of_regs = ARRAY_SIZE(mipi_data_rate_840mbps),
 			.regs = mipi_data_rate_840mbps,
@@ -1719,7 +1719,7 @@ struct ov5670_mode {
 };
 
 static const s64 link_freq_menu_items[] = {
-	OV5670_LINK_FREQ_420MHZ
+	OV5670_LINK_FREQ_422MHZ
 };
 
 /*
@@ -1736,7 +1736,7 @@ struct ov5670_mode {
 			.num_of_regs = ARRAY_SIZE(mode_2592x1944_regs),
 			.regs = mode_2592x1944_regs,
 		},
-		.link_freq_index = OV5670_LINK_FREQ_420MHZ_INDEX,
+		.link_freq_index = OV5670_LINK_FREQ_422MHZ_INDEX,
 	},
 	{
 		.width = 1296,
@@ -1746,7 +1746,7 @@ struct ov5670_mode {
 			.num_of_regs = ARRAY_SIZE(mode_1296x972_regs),
 			.regs = mode_1296x972_regs,
 		},
-		.link_freq_index = OV5670_LINK_FREQ_420MHZ_INDEX,
+		.link_freq_index = OV5670_LINK_FREQ_422MHZ_INDEX,
 	},
 	{
 		.width = 648,
@@ -1756,7 +1756,7 @@ struct ov5670_mode {
 			.num_of_regs = ARRAY_SIZE(mode_648x486_regs),
 			.regs = mode_648x486_regs,
 		},
-		.link_freq_index = OV5670_LINK_FREQ_420MHZ_INDEX,
+		.link_freq_index = OV5670_LINK_FREQ_422MHZ_INDEX,
 	},
 	{
 		.width = 2560,
@@ -1766,7 +1766,7 @@ struct ov5670_mode {
 			.num_of_regs = ARRAY_SIZE(mode_2560x1440_regs),
 			.regs = mode_2560x1440_regs,
 		},
-		.link_freq_index = OV5670_LINK_FREQ_420MHZ_INDEX,
+		.link_freq_index = OV5670_LINK_FREQ_422MHZ_INDEX,
 	},
 	{
 		.width = 1280,
@@ -1776,7 +1776,7 @@ struct ov5670_mode {
 			.num_of_regs = ARRAY_SIZE(mode_1280x720_regs),
 			.regs = mode_1280x720_regs,
 		},
-		.link_freq_index = OV5670_LINK_FREQ_420MHZ_INDEX,
+		.link_freq_index = OV5670_LINK_FREQ_422MHZ_INDEX,
 	},
 	{
 		.width = 640,
@@ -1786,7 +1786,7 @@ struct ov5670_mode {
 			.num_of_regs = ARRAY_SIZE(mode_640x360_regs),
 			.regs = mode_640x360_regs,
 		},
-		.link_freq_index = OV5670_LINK_FREQ_420MHZ_INDEX,
+		.link_freq_index = OV5670_LINK_FREQ_422MHZ_INDEX,
 	}
 };
 
@@ -2016,13 +2016,6 @@ static int ov5670_set_ctrl(struct v4l2_ctrl *ctrl)
 				       OV5670_REG_VALUE_16BIT,
 				       ov5670->cur_mode->height + ctrl->val);
 		break;
-	case V4L2_CID_HBLANK:
-		/* Update HTS that meets expected horizontal blanking */
-		ret = ov5670_write_reg(ov5670, OV5670_REG_HTS,
-				       OV5670_REG_VALUE_16BIT,
-				       (ov5670->cur_mode->width +
-					ctrl->val) / 2);
-		break;
 	case V4L2_CID_TEST_PATTERN:
 		ret = ov5670_enable_test_pattern(ov5670, ctrl->val);
 		break;
@@ -2081,6 +2074,8 @@ static int ov5670_init_controls(struct ov5670 *ov5670)
 				OV5670_DEF_PPL - ov5670->cur_mode->width,
 				OV5670_DEF_PPL - ov5670->cur_mode->width, 1,
 				OV5670_DEF_PPL - ov5670->cur_mode->width);
+	if (ov5670->hblank)
+		ov5670->hblank->flags |= V4L2_CTRL_FLAG_READ_ONLY;
 
 	/* Get min, max, step, default from sensor */
 	v4l2_ctrl_new_std(ctrl_hdlr, &ov5670_ctrl_ops, V4L2_CID_ANALOGUE_GAIN,
-- 
1.9.1
