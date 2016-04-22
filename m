Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:40067 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752066AbcDVNDy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Apr 2016 09:03:54 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Federico Vaga <federico.vaga@gmail.com>
Subject: [PATCH 1/6] adv7180: fix broken standards handling
Date: Fri, 22 Apr 2016 15:03:37 +0200
Message-Id: <1461330222-34096-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1461330222-34096-1-git-send-email-hverkuil@xs4all.nl>
References: <1461330222-34096-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The adv7180 attempts to autodetect the standard. Unfortunately this
is seriously broken.

This patch removes the autodetect completely. Only the querystd op
will detect the standard. Since the design of the adv7180 requires
that you switch to a special autodetect mode you cannot call querystd
when you are streaming.

So the s_stream op has been added so we know whether we are streaming
or not, and if we are, then querystd returns EBUSY.

After testing this with a signal generator is became obvious that
a sleep is needed between changing the standard to autodetect and
reading the status. So the autodetect can never have worked well.

The s_std call now just sets the new standard without any querying.

If the driver supports the interrupt, then when it detects a standard
change it will signal that by sending the V4L2_EVENT_SOURCE_CHANGE
event.

With these changes this driver now behaves like all other video
receivers.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Federico Vaga <federico.vaga@gmail.com>
---
 drivers/media/i2c/adv7180.c | 118 ++++++++++++++++++++++++++++++--------------
 1 file changed, 80 insertions(+), 38 deletions(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index 51a92b3..5a75a91 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -26,8 +26,9 @@
 #include <linux/i2c.h>
 #include <linux/slab.h>
 #include <linux/of.h>
-#include <media/v4l2-ioctl.h>
 #include <linux/videodev2.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-event.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
 #include <linux/mutex.h>
@@ -192,8 +193,8 @@ struct adv7180_state {
 	struct mutex		mutex; /* mutual excl. when accessing chip */
 	int			irq;
 	v4l2_std_id		curr_norm;
-	bool			autodetect;
 	bool			powered;
+	bool			streaming;
 	u8			input;
 
 	struct i2c_client	*client;
@@ -338,12 +339,26 @@ static int adv7180_querystd(struct v4l2_subdev *sd, v4l2_std_id *std)
 	if (err)
 		return err;
 
-	/* when we are interrupt driven we know the state */
-	if (!state->autodetect || state->irq > 0)
-		*std = state->curr_norm;
-	else
-		err = __adv7180_status(state, NULL, std);
+	if (state->streaming) {
+		err = -EBUSY;
+		goto unlock;
+	}
+
+	err = adv7180_set_video_standard(state,
+			ADV7180_STD_AD_PAL_BG_NTSC_J_SECAM);
+	if (err)
+		goto unlock;
 
+	msleep(100);
+	__adv7180_status(state, NULL, std);
+
+	err = v4l2_std_to_adv7180(state->curr_norm);
+	if (err < 0)
+		goto unlock;
+
+	err = adv7180_set_video_standard(state, err);
+
+unlock:
 	mutex_unlock(&state->mutex);
 	return err;
 }
@@ -387,23 +402,13 @@ static int adv7180_program_std(struct adv7180_state *state)
 {
 	int ret;
 
-	if (state->autodetect) {
-		ret = adv7180_set_video_standard(state,
-			ADV7180_STD_AD_PAL_BG_NTSC_J_SECAM);
-		if (ret < 0)
-			return ret;
-
-		__adv7180_status(state, NULL, &state->curr_norm);
-	} else {
-		ret = v4l2_std_to_adv7180(state->curr_norm);
-		if (ret < 0)
-			return ret;
-
-		ret = adv7180_set_video_standard(state, ret);
-		if (ret < 0)
-			return ret;
-	}
+	ret = v4l2_std_to_adv7180(state->curr_norm);
+	if (ret < 0)
+		return ret;
 
+	ret = adv7180_set_video_standard(state, ret);
+	if (ret < 0)
+		return ret;
 	return 0;
 }
 
@@ -415,18 +420,12 @@ static int adv7180_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
 	if (ret)
 		return ret;
 
-	/* all standards -> autodetect */
-	if (std == V4L2_STD_ALL) {
-		state->autodetect = true;
-	} else {
-		/* Make sure we can support this std */
-		ret = v4l2_std_to_adv7180(std);
-		if (ret < 0)
-			goto out;
+	/* Make sure we can support this std */
+	ret = v4l2_std_to_adv7180(std);
+	if (ret < 0)
+		goto out;
 
-		state->curr_norm = std;
-		state->autodetect = false;
-	}
+	state->curr_norm = std;
 
 	ret = adv7180_program_std(state);
 out:
@@ -747,6 +746,40 @@ static int adv7180_g_tvnorms(struct v4l2_subdev *sd, v4l2_std_id *norm)
 	return 0;
 }
 
+static int adv7180_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct adv7180_state *state = to_state(sd);
+	int ret;
+
+	/* It's always safe to stop streaming, no need to take the lock */
+	if (!enable) {
+		state->streaming = enable;
+		return 0;
+	}
+
+	/* Must wait until querystd released the lock */
+	ret = mutex_lock_interruptible(&state->mutex);
+	if (ret)
+		return ret;
+	state->streaming = enable;
+	mutex_unlock(&state->mutex);
+	return 0;
+}
+
+static int adv7180_subscribe_event(struct v4l2_subdev *sd,
+				   struct v4l2_fh *fh,
+				   struct v4l2_event_subscription *sub)
+{
+	switch (sub->type) {
+	case V4L2_EVENT_SOURCE_CHANGE:
+		return v4l2_src_change_event_subdev_subscribe(sd, fh, sub);
+	case V4L2_EVENT_CTRL:
+		return v4l2_ctrl_subdev_subscribe_event(sd, fh, sub);
+	default:
+		return -EINVAL;
+	}
+}
+
 static const struct v4l2_subdev_video_ops adv7180_video_ops = {
 	.s_std = adv7180_s_std,
 	.g_std = adv7180_g_std,
@@ -756,10 +789,13 @@ static const struct v4l2_subdev_video_ops adv7180_video_ops = {
 	.g_mbus_config = adv7180_g_mbus_config,
 	.cropcap = adv7180_cropcap,
 	.g_tvnorms = adv7180_g_tvnorms,
+	.s_stream = adv7180_s_stream,
 };
 
 static const struct v4l2_subdev_core_ops adv7180_core_ops = {
 	.s_power = adv7180_s_power,
+	.subscribe_event = adv7180_subscribe_event,
+	.unsubscribe_event = v4l2_event_subdev_unsubscribe,
 };
 
 static const struct v4l2_subdev_pad_ops adv7180_pad_ops = {
@@ -784,8 +820,14 @@ static irqreturn_t adv7180_irq(int irq, void *devid)
 	/* clear */
 	adv7180_write(state, ADV7180_REG_ICR3, isr3);
 
-	if (isr3 & ADV7180_IRQ3_AD_CHANGE && state->autodetect)
-		__adv7180_status(state, NULL, &state->curr_norm);
+	if (isr3 & ADV7180_IRQ3_AD_CHANGE) {
+		static const struct v4l2_event src_ch = {
+			.type = V4L2_EVENT_SOURCE_CHANGE,
+			.u.src_change.changes = V4L2_EVENT_SRC_CH_RESOLUTION,
+		};
+
+		v4l2_subdev_notify_event(&state->sd, &src_ch);
+	}
 	mutex_unlock(&state->mutex);
 
 	return IRQ_HANDLED;
@@ -1230,7 +1272,7 @@ static int adv7180_probe(struct i2c_client *client,
 
 	state->irq = client->irq;
 	mutex_init(&state->mutex);
-	state->autodetect = true;
+	state->curr_norm = V4L2_STD_NTSC;
 	if (state->chip_info->flags & ADV7180_FLAG_RESET_POWERED)
 		state->powered = true;
 	else
@@ -1238,7 +1280,7 @@ static int adv7180_probe(struct i2c_client *client,
 	state->input = 0;
 	sd = &state->sd;
 	v4l2_i2c_subdev_init(sd, client, &adv7180_ops);
-	sd->flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
+	sd->flags = V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
 
 	ret = adv7180_init_controls(state);
 	if (ret)
-- 
2.8.0.rc3

