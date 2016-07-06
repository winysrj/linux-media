Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:33424 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634AbcGFXNW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2016 19:13:22 -0400
Received: by mail-pa0-f66.google.com with SMTP id ts6so110508pac.0
        for <linux-media@vger.kernel.org>; Wed, 06 Jul 2016 16:13:21 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 02/11] Revert "[media] adv7180: fix broken standards handling"
Date: Wed,  6 Jul 2016 15:59:55 -0700
Message-Id: <1467846004-12731-3-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1467846004-12731-1-git-send-email-steve_longerbeam@mentor.com>
References: <1467846004-12731-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Autodetect was likely broken only because access to the
interrupt registers were broken, so there were no standard
change interrupts. After fixing that, and reverting this,
autodetect seems to work just fine on an i.mx6q SabreAuto.

This reverts commit 937feeed3f0ae8a0389d5732f6db63dd912acd99.
---
 drivers/media/i2c/adv7180.c | 118 ++++++++++++++------------------------------
 1 file changed, 38 insertions(+), 80 deletions(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index 95cbc85..967303a 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -26,9 +26,8 @@
 #include <linux/i2c.h>
 #include <linux/slab.h>
 #include <linux/of.h>
-#include <linux/videodev2.h>
 #include <media/v4l2-ioctl.h>
-#include <media/v4l2-event.h>
+#include <linux/videodev2.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
 #include <linux/mutex.h>
@@ -193,8 +192,8 @@ struct adv7180_state {
 	struct mutex		mutex; /* mutual excl. when accessing chip */
 	int			irq;
 	v4l2_std_id		curr_norm;
+	bool			autodetect;
 	bool			powered;
-	bool			streaming;
 	u8			input;
 
 	struct i2c_client	*client;
@@ -339,26 +338,12 @@ static int adv7180_querystd(struct v4l2_subdev *sd, v4l2_std_id *std)
 	if (err)
 		return err;
 
-	if (state->streaming) {
-		err = -EBUSY;
-		goto unlock;
-	}
-
-	err = adv7180_set_video_standard(state,
-			ADV7180_STD_AD_PAL_BG_NTSC_J_SECAM);
-	if (err)
-		goto unlock;
-
-	msleep(100);
-	__adv7180_status(state, NULL, std);
-
-	err = v4l2_std_to_adv7180(state->curr_norm);
-	if (err < 0)
-		goto unlock;
-
-	err = adv7180_set_video_standard(state, err);
+	/* when we are interrupt driven we know the state */
+	if (!state->autodetect || state->irq > 0)
+		*std = state->curr_norm;
+	else
+		err = __adv7180_status(state, NULL, std);
 
-unlock:
 	mutex_unlock(&state->mutex);
 	return err;
 }
@@ -402,13 +387,23 @@ static int adv7180_program_std(struct adv7180_state *state)
 {
 	int ret;
 
-	ret = v4l2_std_to_adv7180(state->curr_norm);
-	if (ret < 0)
-		return ret;
+	if (state->autodetect) {
+		ret = adv7180_set_video_standard(state,
+			ADV7180_STD_AD_PAL_BG_NTSC_J_SECAM);
+		if (ret < 0)
+			return ret;
+
+		__adv7180_status(state, NULL, &state->curr_norm);
+	} else {
+		ret = v4l2_std_to_adv7180(state->curr_norm);
+		if (ret < 0)
+			return ret;
+
+		ret = adv7180_set_video_standard(state, ret);
+		if (ret < 0)
+			return ret;
+	}
 
-	ret = adv7180_set_video_standard(state, ret);
-	if (ret < 0)
-		return ret;
 	return 0;
 }
 
@@ -420,12 +415,18 @@ static int adv7180_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
 	if (ret)
 		return ret;
 
-	/* Make sure we can support this std */
-	ret = v4l2_std_to_adv7180(std);
-	if (ret < 0)
-		goto out;
+	/* all standards -> autodetect */
+	if (std == V4L2_STD_ALL) {
+		state->autodetect = true;
+	} else {
+		/* Make sure we can support this std */
+		ret = v4l2_std_to_adv7180(std);
+		if (ret < 0)
+			goto out;
 
-	state->curr_norm = std;
+		state->curr_norm = std;
+		state->autodetect = false;
+	}
 
 	ret = adv7180_program_std(state);
 out:
@@ -746,40 +747,6 @@ static int adv7180_g_tvnorms(struct v4l2_subdev *sd, v4l2_std_id *norm)
 	return 0;
 }
 
-static int adv7180_s_stream(struct v4l2_subdev *sd, int enable)
-{
-	struct adv7180_state *state = to_state(sd);
-	int ret;
-
-	/* It's always safe to stop streaming, no need to take the lock */
-	if (!enable) {
-		state->streaming = enable;
-		return 0;
-	}
-
-	/* Must wait until querystd released the lock */
-	ret = mutex_lock_interruptible(&state->mutex);
-	if (ret)
-		return ret;
-	state->streaming = enable;
-	mutex_unlock(&state->mutex);
-	return 0;
-}
-
-static int adv7180_subscribe_event(struct v4l2_subdev *sd,
-				   struct v4l2_fh *fh,
-				   struct v4l2_event_subscription *sub)
-{
-	switch (sub->type) {
-	case V4L2_EVENT_SOURCE_CHANGE:
-		return v4l2_src_change_event_subdev_subscribe(sd, fh, sub);
-	case V4L2_EVENT_CTRL:
-		return v4l2_ctrl_subdev_subscribe_event(sd, fh, sub);
-	default:
-		return -EINVAL;
-	}
-}
-
 static const struct v4l2_subdev_video_ops adv7180_video_ops = {
 	.s_std = adv7180_s_std,
 	.g_std = adv7180_g_std,
@@ -789,13 +756,10 @@ static const struct v4l2_subdev_video_ops adv7180_video_ops = {
 	.g_mbus_config = adv7180_g_mbus_config,
 	.cropcap = adv7180_cropcap,
 	.g_tvnorms = adv7180_g_tvnorms,
-	.s_stream = adv7180_s_stream,
 };
 
 static const struct v4l2_subdev_core_ops adv7180_core_ops = {
 	.s_power = adv7180_s_power,
-	.subscribe_event = adv7180_subscribe_event,
-	.unsubscribe_event = v4l2_event_subdev_unsubscribe,
 };
 
 static const struct v4l2_subdev_pad_ops adv7180_pad_ops = {
@@ -820,14 +784,8 @@ static irqreturn_t adv7180_irq(int irq, void *devid)
 	/* clear */
 	adv7180_write(state, ADV7180_REG_ICR3, isr3);
 
-	if (isr3 & ADV7180_IRQ3_AD_CHANGE) {
-		static const struct v4l2_event src_ch = {
-			.type = V4L2_EVENT_SOURCE_CHANGE,
-			.u.src_change.changes = V4L2_EVENT_SRC_CH_RESOLUTION,
-		};
-
-		v4l2_subdev_notify_event(&state->sd, &src_ch);
-	}
+	if (isr3 & ADV7180_IRQ3_AD_CHANGE && state->autodetect)
+		__adv7180_status(state, NULL, &state->curr_norm);
 	mutex_unlock(&state->mutex);
 
 	return IRQ_HANDLED;
@@ -1272,7 +1230,7 @@ static int adv7180_probe(struct i2c_client *client,
 
 	state->irq = client->irq;
 	mutex_init(&state->mutex);
-	state->curr_norm = V4L2_STD_NTSC;
+	state->autodetect = true;
 	if (state->chip_info->flags & ADV7180_FLAG_RESET_POWERED)
 		state->powered = true;
 	else
@@ -1280,7 +1238,7 @@ static int adv7180_probe(struct i2c_client *client,
 	state->input = 0;
 	sd = &state->sd;
 	v4l2_i2c_subdev_init(sd, client, &adv7180_ops);
-	sd->flags = V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
+	sd->flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
 
 	ret = adv7180_init_controls(state);
 	if (ret)
-- 
1.9.1

