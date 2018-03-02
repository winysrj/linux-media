Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:34019 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1425807AbeCBOfX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Mar 2018 09:35:23 -0500
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
Subject: [PATCH 03/12] media: ov5640: Don't force the auto exposure state at start time
Date: Fri,  2 Mar 2018 15:34:51 +0100
Message-Id: <20180302143500.32650-4-maxime.ripard@bootlin.com>
In-Reply-To: <20180302143500.32650-1-maxime.ripard@bootlin.com>
References: <20180302143500.32650-1-maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The sensor needs to have the auto exposure stopped while changing mode.
However, when the new mode is set, the driver will force the auto exposure
on, disregarding whether the control has been changed or not.

Bypass the controls code entirely to do that, and only use the control
value cached when restoring the auto exposure mode.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 drivers/media/i2c/ov5640.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index e6a23eb55c1d..0d8f979416cc 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -1579,7 +1579,9 @@ static int ov5640_set_mode_direct(struct ov5640_dev *sensor,
 	ret = __v4l2_ctrl_s_ctrl(sensor->ctrls.auto_gain, 1);
 	if (ret)
 		return ret;
-	return __v4l2_ctrl_s_ctrl(sensor->ctrls.auto_exp, V4L2_EXPOSURE_AUTO);
+
+	return __v4l2_ctrl_s_ctrl(sensor->ctrls.auto_exp,
+				  sensor->ctrls.auto_exp->val);
 }
 
 static int ov5640_set_mode(struct ov5640_dev *sensor,
@@ -1596,7 +1598,8 @@ static int ov5640_set_mode(struct ov5640_dev *sensor,
 	ret = __v4l2_ctrl_s_ctrl(sensor->ctrls.auto_gain, 0);
 	if (ret)
 		return ret;
-	ret = __v4l2_ctrl_s_ctrl(sensor->ctrls.auto_exp, V4L2_EXPOSURE_MANUAL);
+
+	ret = ov5640_set_exposure(sensor, V4L2_EXPOSURE_MANUAL);
 	if (ret)
 		return ret;
 
-- 
2.14.3
