Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:37883 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730015AbeGRL4v (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Jul 2018 07:56:51 -0400
From: Jacopo Mondi <jacopo@jmondi.org>
To: mchehab@kernel.org, laurent.pinchart@ideasonboard.com,
        maxime.ripard@bootlin.com, sam@elite-embedded.com,
        jagan@amarulasolutions.com, festevam@gmail.com, pza@pengutronix.de,
        steve_longerbeam@mentor.com, hugues.fruchet@st.com,
        loic.poulain@linaro.org, daniel@zonque.org
Cc: Jacopo Mondi <jacopo@jmondi.org>, linux-media@vger.kernel.org
Subject: [PATCH 2/2] media: ov5640: Fix auto-exposure disabling
Date: Wed, 18 Jul 2018 13:19:03 +0200
Message-Id: <1531912743-24767-3-git-send-email-jacopo@jmondi.org>
In-Reply-To: <1531912743-24767-1-git-send-email-jacopo@jmondi.org>
References: <1531912743-24767-1-git-send-email-jacopo@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As of:
commit bf4a4b518c20 ("media: ov5640: Don't force the auto exposure state at
start time") auto-exposure got disabled before programming new capture modes to
the sensor. Unfortunately the function used to do that (ov5640_set_exposure())
does not enable/disable auto-exposure engine through register 0x3503[0] bit, but
programs registers [0x3500 - 0x3502] which represent the desired exposure time
when running with manual exposure. As a result, auto-exposure was not actually
disabled at all.

To actually disable auto-exposure, go through the control framework instead of
calling ov5640_set_exposure() function directly.

Also, as auto-gain and auto-exposure are disabled un-conditionally but only
restored to their previous values in ov5640_set_mode_direct() function, move
controls restoring so that their value is re-programmed opportunely after
either ov5640_set_mode_direct() or ov5640_set_mode_exposure_calc() have been
executed.

Fixes: bf4a4b518c20 ("media: ov5640: Don't force the auto exposure state at start time")
Signed-off-by: Jacopo Mondi <jacopo@jmondi.org>

---
Is it worth doing with auto-gain what we're doing with auto-exposure? Cache the
value and then re-program it instead of unconditionally disable/enable it?

Thanks
  j
---
---
 drivers/media/i2c/ov5640.c | 29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 12b3496..bc75cb7 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -1588,25 +1588,13 @@ static int ov5640_set_mode_exposure_calc(struct ov5640_dev *sensor,
  * change mode directly
  */
 static int ov5640_set_mode_direct(struct ov5640_dev *sensor,
-				  const struct ov5640_mode_info *mode,
-				  s32 exposure)
+				  const struct ov5640_mode_info *mode)
 {
-	int ret;
-
 	if (!mode->reg_data)
 		return -EINVAL;
 
 	/* Write capture setting */
-	ret = ov5640_load_regs(sensor, mode);
-	if (ret < 0)
-		return ret;
-
-	/* turn auto gain/exposure back on for direct mode */
-	ret = __v4l2_ctrl_s_ctrl(sensor->ctrls.auto_gain, 1);
-	if (ret)
-		return ret;
-
-	return __v4l2_ctrl_s_ctrl(sensor->ctrls.auto_exp, exposure);
+	return  ov5640_load_regs(sensor, mode);
 }
 
 static int ov5640_set_mode(struct ov5640_dev *sensor,
@@ -1626,7 +1614,7 @@ static int ov5640_set_mode(struct ov5640_dev *sensor,
 		return ret;
 
 	exposure = sensor->ctrls.auto_exp->val;
-	ret = ov5640_set_exposure(sensor, V4L2_EXPOSURE_MANUAL);
+	ret = __v4l2_ctrl_s_ctrl(sensor->ctrls.auto_exp, V4L2_EXPOSURE_MANUAL);
 	if (ret)
 		return ret;
 
@@ -1642,12 +1630,21 @@ static int ov5640_set_mode(struct ov5640_dev *sensor,
 		 * change inside subsampling or scaling
 		 * download firmware directly
 		 */
-		ret = ov5640_set_mode_direct(sensor, mode, exposure);
+		ret = ov5640_set_mode_direct(sensor, mode);
 	}
 
 	if (ret < 0)
 		return ret;
 
+	/* Restore auto-gain and auto-exposure after mode has changed. */
+	ret = __v4l2_ctrl_s_ctrl(sensor->ctrls.auto_gain, 1);
+	if (ret)
+		return ret;
+
+	ret = __v4l2_ctrl_s_ctrl(sensor->ctrls.auto_exp, exposure)
+	if (ret)
+		return ret;
+
 	ret = ov5640_set_binning(sensor, dn_mode != SCALING);
 	if (ret < 0)
 		return ret;
-- 
2.7.4
