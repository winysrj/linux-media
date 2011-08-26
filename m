Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3294 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845Ab1HZMAb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Aug 2011 08:00:31 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 5/8] pwc: switch to the new auto-cluster volatile handling.
Date: Fri, 26 Aug 2011 14:00:10 +0200
Message-Id: <358cb09cd45a665040079bfac7b16e58802ccd0d.1314359706.git.hans.verkuil@cisco.com>
In-Reply-To: <1314360013-9876-1-git-send-email-hverkuil@xs4all.nl>
References: <1314360013-9876-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <c30383666acc85a530fba5b1a14189670dfb8bb3.1314359706.git.hans.verkuil@cisco.com>
References: <c30383666acc85a530fba5b1a14189670dfb8bb3.1314359706.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Now that the auto cluster core changed to a different scheme of how to
handle volatile controls (including how to switch from auto to manual mode)
the pwc code can be simplified to use that new core support.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/pwc/pwc-v4l.c |  127 +++++++++++++++---------------------
 1 files changed, 53 insertions(+), 74 deletions(-)

diff --git a/drivers/media/video/pwc/pwc-v4l.c b/drivers/media/video/pwc/pwc-v4l.c
index b6c20aa..d15ae89 100644
--- a/drivers/media/video/pwc/pwc-v4l.c
+++ b/drivers/media/video/pwc/pwc-v4l.c
@@ -83,6 +83,7 @@ static const struct v4l2_ctrl_config pwc_contour_cfg = {
 	.id	= PWC_CID_CUSTOM(contour),
 	.type	= V4L2_CTRL_TYPE_INTEGER,
 	.name	= "Contour",
+	.flags  = V4L2_CTRL_FLAG_SLIDER,
 	.min	= 0,
 	.max	= 63,
 	.step	= 1,
@@ -206,8 +207,7 @@ int pwc_init_controls(struct pwc_device *pdev)
 	pdev->blue_balance = v4l2_ctrl_new_std(hdl, &pwc_ctrl_ops,
 				V4L2_CID_BLUE_BALANCE, 0, 255, 1, def);
 
-	v4l2_ctrl_auto_cluster(3, &pdev->auto_white_balance, awb_manual,
-			       pdev->auto_white_balance->cur.val == awb_auto);
+	v4l2_ctrl_auto_cluster(3, &pdev->auto_white_balance, awb_manual, true);
 
 	/* autogain, gain */
 	r = pwc_get_u8_ctrl(pdev, GET_LUM_CTL, AGC_MODE_FORMATTER, &def);
@@ -331,12 +331,12 @@ int pwc_init_controls(struct pwc_device *pdev)
 	pdev->restore_user = v4l2_ctrl_new_custom(hdl, &pwc_restore_user_cfg,
 						  NULL);
 	if (pdev->restore_user)
-		pdev->restore_user->flags = V4L2_CTRL_FLAG_UPDATE;
+		pdev->restore_user->flags |= V4L2_CTRL_FLAG_UPDATE;
 	pdev->restore_factory = v4l2_ctrl_new_custom(hdl,
 						     &pwc_restore_factory_cfg,
 						     NULL);
 	if (pdev->restore_factory)
-		pdev->restore_factory->flags = V4L2_CTRL_FLAG_UPDATE;
+		pdev->restore_factory->flags |= V4L2_CTRL_FLAG_UPDATE;
 
 	if (!pdev->features & FEATURE_MOTOR_PANTILT)
 		return hdl->error;
@@ -563,8 +563,10 @@ static int pwc_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
 
 	switch (ctrl->id) {
 	case V4L2_CID_AUTO_WHITE_BALANCE:
-		if (pdev->color_bal_valid && time_before(jiffies,
-				pdev->last_color_bal_update + HZ / 4)) {
+		if (pdev->color_bal_valid &&
+			(pdev->auto_white_balance->val != awb_auto ||
+			 time_before(jiffies,
+				pdev->last_color_bal_update + HZ / 4))) {
 			pdev->red_balance->val  = pdev->last_red_balance;
 			pdev->blue_balance->val = pdev->last_blue_balance;
 			break;
@@ -630,7 +632,7 @@ leave:
 
 static int pwc_set_awb(struct pwc_device *pdev)
 {
-	int ret = 0;
+	int ret;
 
 	if (pdev->auto_white_balance->is_new) {
 		ret = pwc_set_u8_ctrl(pdev, SET_CHROM_CTL,
@@ -639,52 +641,34 @@ static int pwc_set_awb(struct pwc_device *pdev)
 		if (ret)
 			return ret;
 
-		/* Update val when coming from auto or going to a preset */
-		if ((pdev->red_balance->flags & V4L2_CTRL_FLAG_VOLATILE) ||
-		    pdev->auto_white_balance->val == awb_indoor ||
-		    pdev->auto_white_balance->val == awb_outdoor ||
-		    pdev->auto_white_balance->val == awb_fl) {
-			if (!pdev->red_balance->is_new)
-				pwc_get_u8_ctrl(pdev, GET_STATUS_CTL,
-					READ_RED_GAIN_FORMATTER,
-					&pdev->red_balance->val);
-			if (!pdev->blue_balance->is_new)
-				pwc_get_u8_ctrl(pdev, GET_STATUS_CTL,
-					READ_BLUE_GAIN_FORMATTER,
-					&pdev->blue_balance->val);
-		}
-		if (pdev->auto_white_balance->val == awb_auto) {
-			pdev->red_balance->flags |= V4L2_CTRL_FLAG_VOLATILE;
-			pdev->blue_balance->flags |= V4L2_CTRL_FLAG_VOLATILE;
+		if (pdev->auto_white_balance->val != awb_manual)
 			pdev->color_bal_valid = false; /* Force cache update */
-		} else {
-			pdev->red_balance->flags &= ~V4L2_CTRL_FLAG_VOLATILE;
-			pdev->blue_balance->flags &= ~V4L2_CTRL_FLAG_VOLATILE;
-		}
 	}
+	if (pdev->auto_white_balance->val != awb_manual)
+		return 0;
 
-	if (ret == 0 && pdev->red_balance->is_new) {
-		if (pdev->auto_white_balance->val != awb_manual)
-			return -EBUSY;
+	if (pdev->red_balance->is_new) {
 		ret = pwc_set_u8_ctrl(pdev, SET_CHROM_CTL,
 				      PRESET_MANUAL_RED_GAIN_FORMATTER,
 				      pdev->red_balance->val);
+		if (ret)
+			return ret;
 	}
 
-	if (ret == 0 && pdev->blue_balance->is_new) {
-		if (pdev->auto_white_balance->val != awb_manual)
-			return -EBUSY;
+	if (pdev->blue_balance->is_new) {
 		ret = pwc_set_u8_ctrl(pdev, SET_CHROM_CTL,
 				      PRESET_MANUAL_BLUE_GAIN_FORMATTER,
 				      pdev->blue_balance->val);
+		if (ret)
+			return ret;
 	}
-	return ret;
+	return 0;
 }
 
 /* For CODEC2 models which have separate autogain and auto exposure */
 static int pwc_set_autogain(struct pwc_device *pdev)
 {
-	int ret = 0;
+	int ret;
 
 	if (pdev->autogain->is_new) {
 		ret = pwc_set_u8_ctrl(pdev, SET_LUM_CTL,
@@ -692,27 +676,28 @@ static int pwc_set_autogain(struct pwc_device *pdev)
 				      pdev->autogain->val ? 0 : 0xff);
 		if (ret)
 			return ret;
+
 		if (pdev->autogain->val)
 			pdev->gain_valid = false; /* Force cache update */
-		else if (!pdev->gain->is_new)
-			pwc_get_u8_ctrl(pdev, GET_STATUS_CTL,
-					READ_AGC_FORMATTER,
-					&pdev->gain->val);
 	}
-	if (ret == 0 && pdev->gain->is_new) {
-		if (pdev->autogain->val)
-			return -EBUSY;
+
+	if (pdev->autogain->val)
+		return 0;
+
+	if (pdev->gain->is_new) {
 		ret = pwc_set_u8_ctrl(pdev, SET_LUM_CTL,
 				      PRESET_AGC_FORMATTER,
 				      pdev->gain->val);
+		if (ret)
+			return ret;
 	}
-	return ret;
+	return 0;
 }
 
 /* For CODEC2 models which have separate autogain and auto exposure */
 static int pwc_set_exposure_auto(struct pwc_device *pdev)
 {
-	int ret = 0;
+	int ret;
 	int is_auto = pdev->exposure_auto->val == V4L2_EXPOSURE_AUTO;
 
 	if (pdev->exposure_auto->is_new) {
@@ -721,27 +706,28 @@ static int pwc_set_exposure_auto(struct pwc_device *pdev)
 				      is_auto ? 0 : 0xff);
 		if (ret)
 			return ret;
+
 		if (is_auto)
 			pdev->exposure_valid = false; /* Force cache update */
-		else if (!pdev->exposure->is_new)
-			pwc_get_u16_ctrl(pdev, GET_STATUS_CTL,
-					 READ_SHUTTER_FORMATTER,
-					 &pdev->exposure->val);
 	}
-	if (ret == 0 && pdev->exposure->is_new) {
-		if (is_auto)
-			return -EBUSY;
+
+	if (is_auto)
+		return 0;
+
+	if (pdev->exposure->is_new) {
 		ret = pwc_set_u16_ctrl(pdev, SET_LUM_CTL,
 				       PRESET_SHUTTER_FORMATTER,
 				       pdev->exposure->val);
+		if (ret)
+			return ret;
 	}
-	return ret;
+	return 0;
 }
 
 /* For CODEC3 models which have autogain controlling both gain and exposure */
 static int pwc_set_autogain_expo(struct pwc_device *pdev)
 {
-	int ret = 0;
+	int ret;
 
 	if (pdev->autogain->is_new) {
 		ret = pwc_set_u8_ctrl(pdev, SET_LUM_CTL,
@@ -749,35 +735,32 @@ static int pwc_set_autogain_expo(struct pwc_device *pdev)
 				      pdev->autogain->val ? 0 : 0xff);
 		if (ret)
 			return ret;
+
 		if (pdev->autogain->val) {
 			pdev->gain_valid     = false; /* Force cache update */
 			pdev->exposure_valid = false; /* Force cache update */
-		} else {
-			if (!pdev->gain->is_new)
-				pwc_get_u8_ctrl(pdev, GET_STATUS_CTL,
-						READ_AGC_FORMATTER,
-						&pdev->gain->val);
-			if (!pdev->exposure->is_new)
-				pwc_get_u16_ctrl(pdev, GET_STATUS_CTL,
-						 READ_SHUTTER_FORMATTER,
-						 &pdev->exposure->val);
 		}
 	}
-	if (ret == 0 && pdev->gain->is_new) {
-		if (pdev->autogain->val)
-			return -EBUSY;
+
+	if (pdev->autogain->val)
+		return 0;
+
+	if (pdev->gain->is_new) {
 		ret = pwc_set_u8_ctrl(pdev, SET_LUM_CTL,
 				      PRESET_AGC_FORMATTER,
 				      pdev->gain->val);
+		if (ret)
+			return ret;
 	}
-	if (ret == 0 && pdev->exposure->is_new) {
-		if (pdev->autogain->val)
-			return -EBUSY;
+
+	if (pdev->exposure->is_new) {
 		ret = pwc_set_u16_ctrl(pdev, SET_LUM_CTL,
 				       PRESET_SHUTTER_FORMATTER,
 				       pdev->exposure->val);
+		if (ret)
+			return ret;
 	}
-	return ret;
+	return 0;
 }
 
 static int pwc_set_motor(struct pwc_device *pdev)
@@ -878,10 +861,6 @@ static int pwc_s_ctrl(struct v4l2_ctrl *ctrl)
 					pdev->autocontour->val ? 0 : 0xff);
 		}
 		if (ret == 0 && pdev->contour->is_new) {
-			if (pdev->autocontour->val) {
-				ret = -EBUSY;
-				break;
-			}
 			ret = pwc_set_u8_ctrl(pdev, SET_LUM_CTL,
 					      PRESET_CONTOUR_FORMATTER,
 					      pdev->contour->val);
-- 
1.7.5.4

