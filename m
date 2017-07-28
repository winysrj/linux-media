Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:42681 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752229AbdG1Suj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Jul 2017 14:50:39 -0400
From: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc: tfiga@chromium.org, jian.xu.zheng@intel.com,
        tian.shu.qiu@intel.com, rajmohan.mani@intel.com,
        hyungwoo.yang@intel.com,
        Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
Subject: [PATCH v1] media: ov13858: Correct link-frequency and pixel-rate
Date: Fri, 28 Jul 2017 11:48:10 -0700
Message-Id: <1501267690-2338-1-git-send-email-chiranjeevi.rapolu@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Previously both link-frequency and pixel-rate reported by
the sensor was incorrect, resulting in incorrect FPS.
Report link-frequency in Hz rather than link data rate in bps.
Calculate pixel-rate from link-frequency.

Signed-off-by: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
---
 drivers/media/i2c/ov13858.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/media/i2c/ov13858.c b/drivers/media/i2c/ov13858.c
index 86550d8..2a5bb43 100644
--- a/drivers/media/i2c/ov13858.c
+++ b/drivers/media/i2c/ov13858.c
@@ -60,8 +60,8 @@
 #define OV13858_VBLANK_MIN		56
 
 /* HBLANK control - read only */
-#define OV13858_PPL_540MHZ		2244
-#define OV13858_PPL_1080MHZ		4488
+#define OV13858_PPL_270MHZ		2244
+#define OV13858_PLL_540MHZ		4488
 
 /* Exposure control */
 #define OV13858_REG_EXPOSURE		0x3500
@@ -944,31 +944,33 @@ struct ov13858_mode {
 
 /* Configurations for supported link frequencies */
 #define OV13858_NUM_OF_LINK_FREQS	2
-#define OV13858_LINK_FREQ_1080MBPS	1080000000
-#define OV13858_LINK_FREQ_540MBPS	540000000
+#define OV13858_LINK_FREQ_540MHZ	540000000
+#define OV13858_LINK_FREQ_270MHZ	270000000
 #define OV13858_LINK_FREQ_INDEX_0	0
 #define OV13858_LINK_FREQ_INDEX_1	1
 
 /* Menu items for LINK_FREQ V4L2 control */
 static const s64 link_freq_menu_items[OV13858_NUM_OF_LINK_FREQS] = {
-	OV13858_LINK_FREQ_1080MBPS,
-	OV13858_LINK_FREQ_540MBPS
+	OV13858_LINK_FREQ_540MHZ,
+	OV13858_LINK_FREQ_270MHZ
 };
 
 /* Link frequency configs */
 static const struct ov13858_link_freq_config
 			link_freq_configs[OV13858_NUM_OF_LINK_FREQS] = {
 	{
-		.pixel_rate = 864000000,
-		.pixels_per_line = OV13858_PPL_1080MHZ,
+		/* pixel_rate = link_freq * 2 * nr_of_lanes / bits_per_sample */
+		.pixel_rate = ((uint64_t)OV13858_LINK_FREQ_540MHZ * 2 * 4) / 10,
+		.pixels_per_line = OV13858_PLL_540MHZ,
 		.reg_list = {
 			.num_of_regs = ARRAY_SIZE(mipi_data_rate_1080mbps),
 			.regs = mipi_data_rate_1080mbps,
 		}
 	},
 	{
-		.pixel_rate = 432000000,
-		.pixels_per_line = OV13858_PPL_540MHZ,
+		/* pixel_rate = link_freq * 2 * nr_of_lanes / bits_per_sample */
+		.pixel_rate = ((uint64_t)OV13858_LINK_FREQ_270MHZ * 2 * 4) / 10,
+		.pixels_per_line = OV13858_PPL_270MHZ,
 		.reg_list = {
 			.num_of_regs = ARRAY_SIZE(mipi_data_rate_540mbps),
 			.regs = mipi_data_rate_540mbps,
@@ -1634,10 +1636,10 @@ static int ov13858_init_controls(struct ov13858 *ov13858)
 
 	ov13858->hblank = v4l2_ctrl_new_std(
 				ctrl_hdlr, &ov13858_ctrl_ops, V4L2_CID_HBLANK,
-				OV13858_PPL_1080MHZ - ov13858->cur_mode->width,
-				OV13858_PPL_1080MHZ - ov13858->cur_mode->width,
+				OV13858_PLL_540MHZ - ov13858->cur_mode->width,
+				OV13858_PLL_540MHZ - ov13858->cur_mode->width,
 				1,
-				OV13858_PPL_1080MHZ - ov13858->cur_mode->width);
+				OV13858_PLL_540MHZ - ov13858->cur_mode->width);
 	ov13858->hblank->flags |= V4L2_CTRL_FLAG_READ_ONLY;
 
 	ov13858->exposure = v4l2_ctrl_new_std(
-- 
1.9.1
