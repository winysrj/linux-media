Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:39580 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750950AbdG0HqI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Jul 2017 03:46:08 -0400
From: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc: jian.xu.zheng@intel.com, rajmohan.mani@intel.com,
        hyungwoo.yang@intel.com, tfiga@chromium.org,
        Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
Subject: [PATCH v1] media: ov13858: Fix initial expsoure max
Date: Thu, 27 Jul 2017 00:44:19 -0700
Message-Id: <1501141459-18717-1-git-send-email-chiranjeevi.rapolu@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Previously, initial exposure max was set incorrectly to (0x7fff - 8).
Now, limit exposure max to current resolution (VTS - 8).

Signed-off-by: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
---
 drivers/media/i2c/ov13858.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ov13858.c b/drivers/media/i2c/ov13858.c
index 86550d8..013c565 100644
--- a/drivers/media/i2c/ov13858.c
+++ b/drivers/media/i2c/ov13858.c
@@ -66,7 +66,6 @@
 /* Exposure control */
 #define OV13858_REG_EXPOSURE		0x3500
 #define OV13858_EXPOSURE_MIN		4
-#define OV13858_EXPOSURE_MAX		(OV13858_VTS_MAX - 8)
 #define OV13858_EXPOSURE_STEP		1
 #define OV13858_EXPOSURE_DEFAULT	0x640
 
@@ -1602,6 +1601,7 @@ static int ov13858_init_controls(struct ov13858 *ov13858)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&ov13858->sd);
 	struct v4l2_ctrl_handler *ctrl_hdlr;
+	s64 exposure_max;
 	int ret;
 
 	ctrl_hdlr = &ov13858->ctrl_handler;
@@ -1640,10 +1640,11 @@ static int ov13858_init_controls(struct ov13858 *ov13858)
 				OV13858_PPL_1080MHZ - ov13858->cur_mode->width);
 	ov13858->hblank->flags |= V4L2_CTRL_FLAG_READ_ONLY;
 
+	exposure_max = ov13858->cur_mode->vts - 8;
 	ov13858->exposure = v4l2_ctrl_new_std(
 				ctrl_hdlr, &ov13858_ctrl_ops,
 				V4L2_CID_EXPOSURE, OV13858_EXPOSURE_MIN,
-				OV13858_EXPOSURE_MAX, OV13858_EXPOSURE_STEP,
+				exposure_max, OV13858_EXPOSURE_STEP,
 				OV13858_EXPOSURE_DEFAULT);
 
 	v4l2_ctrl_new_std(ctrl_hdlr, &ov13858_ctrl_ops, V4L2_CID_ANALOGUE_GAIN,
-- 
1.9.1
