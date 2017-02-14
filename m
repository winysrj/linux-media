Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:32503 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753706AbdBNMXG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Feb 2017 07:23:06 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: pavel@ucw.cz
Subject: [PATCH v3 2/2] ad5820: Use VOICE_COIL_CURRENT control
Date: Tue, 14 Feb 2017 14:20:23 +0200
Message-Id: <1487074823-28274-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1487074823-28274-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1487074823-28274-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add V4L2_CID_VOICE_COIL_CURRENT control support to the ad5820 driver. The
usage of the control is equivalent to how V4L2_CID_FOCUS_ABSOLUTE was used
by the driver. The old control remains supported.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/ad5820.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/media/i2c/ad5820.c b/drivers/media/i2c/ad5820.c
index a9026a91..e5ff1a2 100644
--- a/drivers/media/i2c/ad5820.c
+++ b/drivers/media/i2c/ad5820.c
@@ -51,7 +51,7 @@ struct ad5820_device {
 	struct regulator *vana;
 
 	struct v4l2_ctrl_handler ctrls;
-	u32 focus_absolute;
+	struct v4l2_ctrl *focus, *curr;
 	u32 focus_ramp_time;
 	u32 focus_ramp_mode;
 
@@ -59,6 +59,7 @@ struct ad5820_device {
 	int power_count;
 
 	bool standby;
+	bool in_set_ctrl;
 };
 
 static int ad5820_write(struct ad5820_device *coil, u16 data)
@@ -98,7 +99,7 @@ static int ad5820_update_hw(struct ad5820_device *coil)
 	status = RAMP_US_TO_CODE(coil->focus_ramp_time);
 	status |= coil->focus_ramp_mode
 		? AD5820_RAMP_MODE_64_16 : AD5820_RAMP_MODE_LINEAR;
-	status |= coil->focus_absolute << AD5820_DAC_SHIFT;
+	status |= coil->curr->val << AD5820_DAC_SHIFT;
 
 	if (coil->standby)
 		status |= AD5820_POWER_DOWN;
@@ -160,9 +161,16 @@ static int ad5820_set_ctrl(struct v4l2_ctrl *ctrl)
 	struct ad5820_device *coil =
 		container_of(ctrl->handler, struct ad5820_device, ctrls);
 
+	if (coil->in_set_ctrl)
+		return 0;
+
 	switch (ctrl->id) {
 	case V4L2_CID_FOCUS_ABSOLUTE:
-		coil->focus_absolute = ctrl->val;
+	case V4L2_CID_VOICE_COIL_CURRENT:
+		coil->in_set_ctrl = true;
+		__v4l2_ctrl_s_ctrl(ctrl == coil->focus ?
+				   coil->curr : coil->focus, ctrl->val);
+		coil->in_set_ctrl = false;
 		return ad5820_update_hw(coil);
 	}
 
@@ -189,14 +197,21 @@ static int ad5820_init_controls(struct ad5820_device *coil)
 	 * will just use abstract codes here. In any case, smaller value = focus
 	 * position farther from camera. The default zero value means focus at
 	 * infinity, and also least current consumption.
+	 *
+	 * The two controls below control the current. The
+	 * FOCUS_ABSOLUTE is there for compatibility with old user
+	 * space whereas the VOICE_COIL_CURRENT should be used by both
+	 * new applications and drivers.
 	 */
-	v4l2_ctrl_new_std(&coil->ctrls, &ad5820_ctrl_ops,
-			  V4L2_CID_FOCUS_ABSOLUTE, 0, 1023, 1, 0);
+	coil->focus = v4l2_ctrl_new_std(&coil->ctrls, &ad5820_ctrl_ops,
+					V4L2_CID_FOCUS_ABSOLUTE, 0, 1023, 1, 0);
+	coil->curr = v4l2_ctrl_new_std(&coil->ctrls, &ad5820_ctrl_ops,
+					  V4L2_CID_VOICE_COIL_CURRENT,
+					  0, 1023, 1, 0);
 
 	if (coil->ctrls.error)
 		return coil->ctrls.error;
 
-	coil->focus_absolute = 0;
 	coil->focus_ramp_time = 0;
 	coil->focus_ramp_mode = 0;
 
-- 
2.7.4
