Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40902 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751795AbdIVHOv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Sep 2017 03:14:51 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: chiranjeevi.rapolu@intel.com
Subject: [PATCH v2 1/1] ov13858: Use do_div() for dividing a 64-bit number
Date: Fri, 22 Sep 2017 10:14:50 +0300
Message-Id: <20170922071450.9479-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ov13858 contained a 64-bit division. Use do_div() for calculating it.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/ov13858.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/ov13858.c b/drivers/media/i2c/ov13858.c
index 2bd659976c30..fdce2befed02 100644
--- a/drivers/media/i2c/ov13858.c
+++ b/drivers/media/i2c/ov13858.c
@@ -951,7 +951,13 @@ static const char * const ov13858_test_pattern_menu[] = {
  * pixel_rate = link_freq * data-rate * nr_of_lanes / bits_per_sample
  * data rate => double data rate; number of lanes => 4; bits per pixel => 10
  */
-#define LINK_FREQ_TO_PIXEL_RATE(f)	(((f) * 2 * 4) / 10)
+static u64 link_freq_to_pixel_rate(u64 f)
+{
+	f *= 2 * 4;
+	do_div(f, 10);
+
+	return f;
+}
 
 /* Menu items for LINK_FREQ V4L2 control */
 static const s64 link_freq_menu_items[OV13858_NUM_OF_LINK_FREQS] = {
@@ -1404,7 +1410,7 @@ ov13858_set_pad_format(struct v4l2_subdev *sd,
 		ov13858->cur_mode = mode;
 		__v4l2_ctrl_s_ctrl(ov13858->link_freq, mode->link_freq_index);
 		link_freq = link_freq_menu_items[mode->link_freq_index];
-		pixel_rate = LINK_FREQ_TO_PIXEL_RATE(link_freq);
+		pixel_rate = link_freq_to_pixel_rate(link_freq);
 		__v4l2_ctrl_s_ctrl_int64(ov13858->pixel_rate, pixel_rate);
 
 		/* Update limits and set FPS to default */
@@ -1642,8 +1648,8 @@ static int ov13858_init_controls(struct ov13858 *ov13858)
 				link_freq_menu_items);
 	ov13858->link_freq->flags |= V4L2_CTRL_FLAG_READ_ONLY;
 
-	pixel_rate_max = LINK_FREQ_TO_PIXEL_RATE(link_freq_menu_items[0]);
-	pixel_rate_min = LINK_FREQ_TO_PIXEL_RATE(link_freq_menu_items[1]);
+	pixel_rate_max = link_freq_to_pixel_rate(link_freq_menu_items[0]);
+	pixel_rate_min = link_freq_to_pixel_rate(link_freq_menu_items[1]);
 	/* By default, PIXEL_RATE is read only */
 	ov13858->pixel_rate = v4l2_ctrl_new_std(ctrl_hdlr, &ov13858_ctrl_ops,
 						V4L2_CID_PIXEL_RATE,
-- 
2.11.0
