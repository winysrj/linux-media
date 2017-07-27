Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:40252 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751782AbdG0HaB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Jul 2017 03:30:01 -0400
From: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc: jian.xu.zheng@intel.com, rajmohan.mani@intel.com,
        hyungwoo.yang@intel.com, tfiga@chromium.org,
        Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
Subject: [PATCH v1] [media] ov13858 Set default fps as current fps
Date: Thu, 27 Jul 2017 00:28:05 -0700
Message-Id: <1501140485-27879-1-git-send-email-chiranjeevi.rapolu@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On format change, sometimes, sensor was streaming at a much higher
FPS than the default. This was resulting in various problems like
frame drops/corruption.

Upon format change, set default vblank as current vblank. This will
ensure that sensor will start streaming at default fps.

Signed-off-by: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
---
 drivers/media/i2c/ov13858.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov13858.c b/drivers/media/i2c/ov13858.c
index 86550d8..8e6c8f0 100644
--- a/drivers/media/i2c/ov13858.c
+++ b/drivers/media/i2c/ov13858.c
@@ -1377,6 +1377,7 @@ static int ov13858_get_pad_format(struct v4l2_subdev *sd,
 	struct ov13858 *ov13858 = to_ov13858(sd);
 	const struct ov13858_mode *mode;
 	struct v4l2_mbus_framefmt *framefmt;
+	s32 vblank_def;
 	s64 h_blank;
 
 	mutex_lock(&ov13858->mutex);
@@ -1397,10 +1398,12 @@ static int ov13858_get_pad_format(struct v4l2_subdev *sd,
 			ov13858->pixel_rate,
 			link_freq_configs[mode->link_freq_index].pixel_rate);
 		/* Update limits and set FPS to default */
+		vblank_def = ov13858->cur_mode->vts - ov13858->cur_mode->height;
 		__v4l2_ctrl_modify_range(
 			ov13858->vblank, OV13858_VBLANK_MIN,
 			OV13858_VTS_MAX - ov13858->cur_mode->height, 1,
-			ov13858->cur_mode->vts - ov13858->cur_mode->height);
+			vblank_def);
+		__v4l2_ctrl_s_ctrl(ov13858->vblank, vblank_def);
 		h_blank =
 			link_freq_configs[mode->link_freq_index].pixels_per_line
 			 - ov13858->cur_mode->width;
-- 
1.9.1
