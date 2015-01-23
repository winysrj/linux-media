Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-190.synserver.de ([212.40.185.190]:1062 "EHLO
	smtp-out-190.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755667AbbAWPwp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2015 10:52:45 -0500
From: Lars-Peter Clausen <lars@metafoo.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Vladimir Barinov <vladimir.barinov@cogentembedded.com>,
	=?UTF-8?q?Richard=20R=C3=B6jfors?=
	<richard.rojfors@mocean-labs.com>,
	Federico Vaga <federico.vaga@gmail.com>,
	linux-media@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v2 08/15] [media] adv7180: Consolidate video mode setting
Date: Fri, 23 Jan 2015 16:52:27 +0100
Message-Id: <1422028354-31891-9-git-send-email-lars@metafoo.de>
In-Reply-To: <1422028354-31891-1-git-send-email-lars@metafoo.de>
References: <1422028354-31891-1-git-send-email-lars@metafoo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We have basically the same code to set the video standard in init_device()
and adv7180_s_std(). Factor this out into a common helper function.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7180.c | 67 ++++++++++++++++++++++-----------------------
 1 file changed, 32 insertions(+), 35 deletions(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index 349cae3..4d9bcc8 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -304,37 +304,54 @@ static int adv7180_g_input_status(struct v4l2_subdev *sd, u32 *status)
 	return ret;
 }
 
-static int adv7180_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
+static int adv7180_program_std(struct adv7180_state *state)
 {
-	struct adv7180_state *state = to_state(sd);
-	int ret = mutex_lock_interruptible(&state->mutex);
-	if (ret)
-		return ret;
+	int ret;
 
-	/* all standards -> autodetect */
-	if (std == V4L2_STD_ALL) {
+	if (state->autodetect) {
 		ret = adv7180_write(state, ADV7180_REG_INPUT_CONTROL,
 				    ADV7180_INPUT_CONTROL_AD_PAL_BG_NTSC_J_SECAM
 				    | state->input);
 		if (ret < 0)
-			goto out;
+			return ret;
 
 		__adv7180_status(state, NULL, &state->curr_norm);
-		state->autodetect = true;
 	} else {
-		ret = v4l2_std_to_adv7180(std);
+		ret = v4l2_std_to_adv7180(state->curr_norm);
 		if (ret < 0)
-			goto out;
+			return ret;
 
 		ret = adv7180_write(state, ADV7180_REG_INPUT_CONTROL,
 				    ret | state->input);
 		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int adv7180_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
+{
+	struct adv7180_state *state = to_state(sd);
+	int ret = mutex_lock_interruptible(&state->mutex);
+
+	if (ret)
+		return ret;
+
+	/* all standards -> autodetect */
+	if (std == V4L2_STD_ALL) {
+		state->autodetect = true;
+	} else {
+		/* Make sure we can support this std */
+		ret = v4l2_std_to_adv7180(std);
+		if (ret < 0)
 			goto out;
 
 		state->curr_norm = std;
 		state->autodetect = false;
 	}
-	ret = 0;
+
+	ret = adv7180_program_std(state);
 out:
 	mutex_unlock(&state->mutex);
 	return ret;
@@ -547,30 +564,10 @@ static int init_device(struct adv7180_state *state)
 	adv7180_write(state, ADV7180_REG_PWR_MAN, ADV7180_PWR_MAN_RES);
 	usleep_range(2000, 10000);
 
-	/* Initialize adv7180 */
-	/* Enable autodetection */
-	if (state->autodetect) {
-		ret = adv7180_write(state, ADV7180_REG_INPUT_CONTROL,
-				ADV7180_INPUT_CONTROL_AD_PAL_BG_NTSC_J_SECAM
-					      | state->input);
-		if (ret < 0)
-			goto out_unlock;
-
-		ret = adv7180_write(state, ADV7180_REG_AUTODETECT_ENABLE,
-					      ADV7180_AUTODETECT_DEFAULT);
-		if (ret < 0)
-			goto out_unlock;
-	} else {
-		ret = v4l2_std_to_adv7180(state->curr_norm);
-		if (ret < 0)
-			goto out_unlock;
-
-		ret = adv7180_write(state, ADV7180_REG_INPUT_CONTROL,
-					      ret | state->input);
-		if (ret < 0)
-			goto out_unlock;
+	ret = adv7180_program_std(state);
+	if (ret)
+		goto out_unlock;
 
-	}
 	/* ITU-R BT.656-4 compatible */
 	ret = adv7180_write(state, ADV7180_REG_EXTENDED_OUTPUT_CONTROL,
 			ADV7180_EXTENDED_OUTPUT_CONTROL_NTSCDIS);
-- 
1.8.0

