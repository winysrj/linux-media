Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:31080 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752717AbdIEXwj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Sep 2017 19:52:39 -0400
From: Rajmohan Mani <rajmohan.mani@intel.com>
To: rajmohan.mani@intel.com, linux-media@vger.kernel.org,
        sakari.ailus@linux.intel.com
Cc: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>,
        tfiga@chromium.org
Subject: [PATCH v1] media: ov13858: Calculate pixel-rate at runtime, use mode
Date: Tue,  5 Sep 2017 16:44:58 -0700
Message-Id: <1504655098-39951-1-git-send-email-rajmohan.mani@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>

Instead of calculating pixle-rate at two different places, calculate at run
time at a single place.

Instead of using hardcoded pixels-per-line, extract it from current sensor
mode.

Signed-off-by: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
---
 drivers/media/i2c/ov13858.c | 42 +++++++++++++++++++++++++-----------------
 1 file changed, 25 insertions(+), 17 deletions(-)

diff --git a/drivers/media/i2c/ov13858.c b/drivers/media/i2c/ov13858.c
index af7af0d..2821824 100644
--- a/drivers/media/i2c/ov13858.c
+++ b/drivers/media/i2c/ov13858.c
@@ -955,11 +955,9 @@ struct ov13858_mode {
 };
 
 /* Link frequency configs */
-static const struct ov13858_link_freq_config
+static struct ov13858_link_freq_config
 			link_freq_configs[OV13858_NUM_OF_LINK_FREQS] = {
 	{
-		/* pixel_rate = link_freq * 2 * nr_of_lanes / bits_per_sample */
-		.pixel_rate = (OV13858_LINK_FREQ_540MHZ * 2 * 4) / 10,
 		.pixels_per_line = OV13858_PPL_540MHZ,
 		.reg_list = {
 			.num_of_regs = ARRAY_SIZE(mipi_data_rate_1080mbps),
@@ -967,8 +965,6 @@ struct ov13858_mode {
 		}
 	},
 	{
-		/* pixel_rate = link_freq * 2 * nr_of_lanes / bits_per_sample */
-		.pixel_rate = (OV13858_LINK_FREQ_270MHZ * 2 * 4) / 10,
 		.pixels_per_line = OV13858_PPL_270MHZ,
 		.reg_list = {
 			.num_of_regs = ARRAY_SIZE(mipi_data_rate_540mbps),
@@ -1617,6 +1613,10 @@ static int ov13858_init_controls(struct ov13858 *ov13858)
 	s64 exposure_max;
 	s64 vblank_def;
 	s64 vblank_min;
+	s64 hblank;
+	s64 pixel_rate_min;
+	s64 pixel_rate_max;
+	const struct ov13858_mode *mode;
 	int ret;
 
 	ctrl_hdlr = &ov13858->ctrl_handler;
@@ -1634,29 +1634,30 @@ static int ov13858_init_controls(struct ov13858 *ov13858)
 				link_freq_menu_items);
 	ov13858->link_freq->flags |= V4L2_CTRL_FLAG_READ_ONLY;
 
+	pixel_rate_max = link_freq_configs[0].pixel_rate;
+	pixel_rate_min = link_freq_configs[1].pixel_rate;
 	/* By default, PIXEL_RATE is read only */
 	ov13858->pixel_rate = v4l2_ctrl_new_std(ctrl_hdlr, &ov13858_ctrl_ops,
-					V4L2_CID_PIXEL_RATE, 0,
-					link_freq_configs[0].pixel_rate, 1,
-					link_freq_configs[0].pixel_rate);
+						V4L2_CID_PIXEL_RATE,
+						pixel_rate_min, pixel_rate_max,
+						1, pixel_rate_max);
 
-	vblank_def = ov13858->cur_mode->vts_def - ov13858->cur_mode->height;
-	vblank_min = ov13858->cur_mode->vts_min - ov13858->cur_mode->height;
+	mode = ov13858->cur_mode;
+	vblank_def = mode->vts_def - mode->height;
+	vblank_min = mode->vts_min - mode->height;
 	ov13858->vblank = v4l2_ctrl_new_std(
 				ctrl_hdlr, &ov13858_ctrl_ops, V4L2_CID_VBLANK,
-				vblank_min,
-				OV13858_VTS_MAX - ov13858->cur_mode->height, 1,
+				vblank_min, OV13858_VTS_MAX - mode->height, 1,
 				vblank_def);
 
+	hblank = link_freq_configs[mode->link_freq_index].pixels_per_line -
+		 mode->width;
 	ov13858->hblank = v4l2_ctrl_new_std(
 				ctrl_hdlr, &ov13858_ctrl_ops, V4L2_CID_HBLANK,
-				OV13858_PPL_540MHZ - ov13858->cur_mode->width,
-				OV13858_PPL_540MHZ - ov13858->cur_mode->width,
-				1,
-				OV13858_PPL_540MHZ - ov13858->cur_mode->width);
+				hblank, hblank, 1, hblank);
 	ov13858->hblank->flags |= V4L2_CTRL_FLAG_READ_ONLY;
 
-	exposure_max = ov13858->cur_mode->vts_def - 8;
+	exposure_max = mode->vts_def - 8;
 	ov13858->exposure = v4l2_ctrl_new_std(
 				ctrl_hdlr, &ov13858_ctrl_ops,
 				V4L2_CID_EXPOSURE, OV13858_EXPOSURE_MIN,
@@ -1704,6 +1705,7 @@ static int ov13858_probe(struct i2c_client *client,
 			 const struct i2c_device_id *devid)
 {
 	struct ov13858 *ov13858;
+	int i;
 	int ret;
 	u32 val = 0;
 
@@ -1725,6 +1727,12 @@ static int ov13858_probe(struct i2c_client *client,
 		return ret;
 	}
 
+	for (i = 0; i < OV13858_NUM_OF_LINK_FREQS; i++) {
+		/* pixel_rate = link_freq * 2 * nr_of_lanes / bits_per_sample */
+		link_freq_configs[i].pixel_rate  =
+					(link_freq_menu_items[i] * 2 * 4) / 10;
+	}
+
 	/* Set default mode to max resolution */
 	ov13858->cur_mode = &supported_modes[0];
 
-- 
1.9.1
