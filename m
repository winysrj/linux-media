Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:53154 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752911AbeDPMhY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 08:37:24 -0400
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH v2 03/12] media: ov5640: Don't force the auto exposure state at start time
Date: Mon, 16 Apr 2018 14:36:52 +0200
Message-Id: <20180416123701.15901-4-maxime.ripard@bootlin.com>
In-Reply-To: <20180416123701.15901-1-maxime.ripard@bootlin.com>
References: <20180416123701.15901-1-maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The sensor needs to have the auto exposure stopped while changing mode.
However, when the new mode is set, the driver will force the auto exposure
on, disregarding whether the control has been changed or not.

Bypass the controls code entirely to do that, and only use the control
value cached when restoring the auto exposure mode.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 drivers/media/i2c/ov5640.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 28122341fc35..a41e4cd5fd17 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -1571,7 +1571,8 @@ static int ov5640_set_mode_exposure_calc(struct ov5640_dev *sensor,
  * change mode directly
  */
 static int ov5640_set_mode_direct(struct ov5640_dev *sensor,
-				  const struct ov5640_mode_info *mode)
+				  const struct ov5640_mode_info *mode,
+				  s32 exposure)
 {
 	int ret;
 
@@ -1587,7 +1588,8 @@ static int ov5640_set_mode_direct(struct ov5640_dev *sensor,
 	ret = __v4l2_ctrl_s_ctrl(sensor->ctrls.auto_gain, 1);
 	if (ret)
 		return ret;
-	return __v4l2_ctrl_s_ctrl(sensor->ctrls.auto_exp, V4L2_EXPOSURE_AUTO);
+
+	return __v4l2_ctrl_s_ctrl(sensor->ctrls.auto_exp, exposure);
 }
 
 static int ov5640_set_mode(struct ov5640_dev *sensor,
@@ -1595,6 +1597,7 @@ static int ov5640_set_mode(struct ov5640_dev *sensor,
 {
 	const struct ov5640_mode_info *mode = sensor->current_mode;
 	enum ov5640_downsize_mode dn_mode, orig_dn_mode;
+	s32 exposure;
 	int ret;
 
 	dn_mode = mode->dn_mode;
@@ -1604,7 +1607,9 @@ static int ov5640_set_mode(struct ov5640_dev *sensor,
 	ret = __v4l2_ctrl_s_ctrl(sensor->ctrls.auto_gain, 0);
 	if (ret)
 		return ret;
-	ret = __v4l2_ctrl_s_ctrl(sensor->ctrls.auto_exp, V4L2_EXPOSURE_MANUAL);
+
+	exposure = sensor->ctrls.auto_exp->val;
+	ret = ov5640_set_exposure(sensor, V4L2_EXPOSURE_MANUAL);
 	if (ret)
 		return ret;
 
@@ -1620,7 +1625,7 @@ static int ov5640_set_mode(struct ov5640_dev *sensor,
 		 * change inside subsampling or scaling
 		 * download firmware directly
 		 */
-		ret = ov5640_set_mode_direct(sensor, mode);
+		ret = ov5640_set_mode_direct(sensor, mode, exposure);
 	}
 
 	if (ret < 0)
-- 
2.17.0
