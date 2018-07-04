Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:62608 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752819AbeGDM7I (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Jul 2018 08:59:08 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>
CC: <linux-media@vger.kernel.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH 1/5] media: ov5640: fix exposure regression
Date: Wed, 4 Jul 2018 14:58:39 +0200
Message-ID: <1530709123-12445-2-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1530709123-12445-1-git-send-email-hugues.fruchet@st.com>
References: <1530709123-12445-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

fixes: bf4a4b518c20 ("media: ov5640: Don't force the auto exposure state at start time").

Symptom was black image when capturing HD or 5Mp picture
due to manual exposure set to 1 while it was intended to
set autoexposure to "manual", fix this.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/i2c/ov5640.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 1ecbb7a..4b9da8b 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -938,6 +938,12 @@ static int ov5640_load_regs(struct ov5640_dev *sensor,
 	return ret;
 }
 
+static int ov5640_set_autoexposure(struct ov5640_dev *sensor, bool on)
+{
+	return ov5640_mod_reg(sensor, OV5640_REG_AEC_PK_MANUAL,
+			      BIT(0), on ? 0 : BIT(0));
+}
+
 /* read exposure, in number of line periods */
 static int ov5640_get_exposure(struct ov5640_dev *sensor)
 {
@@ -1593,7 +1599,7 @@ static int ov5640_set_mode_exposure_calc(struct ov5640_dev *sensor,
  */
 static int ov5640_set_mode_direct(struct ov5640_dev *sensor,
 				  const struct ov5640_mode_info *mode,
-				  s32 exposure)
+				  bool auto_exp)
 {
 	int ret;
 
@@ -1610,7 +1616,8 @@ static int ov5640_set_mode_direct(struct ov5640_dev *sensor,
 	if (ret)
 		return ret;
 
-	return __v4l2_ctrl_s_ctrl(sensor->ctrls.auto_exp, exposure);
+	return __v4l2_ctrl_s_ctrl(sensor->ctrls.auto_exp, auto_exp ?
+				  V4L2_EXPOSURE_AUTO : V4L2_EXPOSURE_MANUAL);
 }
 
 static int ov5640_set_mode(struct ov5640_dev *sensor,
@@ -1618,7 +1625,7 @@ static int ov5640_set_mode(struct ov5640_dev *sensor,
 {
 	const struct ov5640_mode_info *mode = sensor->current_mode;
 	enum ov5640_downsize_mode dn_mode, orig_dn_mode;
-	s32 exposure;
+	bool auto_exp =  sensor->ctrls.auto_exp->val == V4L2_EXPOSURE_AUTO;
 	int ret;
 
 	dn_mode = mode->dn_mode;
@@ -1629,8 +1636,7 @@ static int ov5640_set_mode(struct ov5640_dev *sensor,
 	if (ret)
 		return ret;
 
-	exposure = sensor->ctrls.auto_exp->val;
-	ret = ov5640_set_exposure(sensor, V4L2_EXPOSURE_MANUAL);
+	ret = ov5640_set_autoexposure(sensor, false);
 	if (ret)
 		return ret;
 
@@ -1646,7 +1652,7 @@ static int ov5640_set_mode(struct ov5640_dev *sensor,
 		 * change inside subsampling or scaling
 		 * download firmware directly
 		 */
-		ret = ov5640_set_mode_direct(sensor, mode, exposure);
+		ret = ov5640_set_mode_direct(sensor, mode, auto_exp);
 	}
 
 	if (ret < 0)
-- 
1.9.1
