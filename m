Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33555 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932423AbcGFXNb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2016 19:13:31 -0400
Received: by mail-pf0-f194.google.com with SMTP id c74so114360pfb.0
        for <linux-media@vger.kernel.org>; Wed, 06 Jul 2016 16:13:31 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 08/11] adv7180: send V4L2_EVENT_SOURCE_CHANGE on std change
Date: Wed,  6 Jul 2016 16:00:01 -0700
Message-Id: <1467846004-12731-9-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1467846004-12731-1-git-send-email-steve_longerbeam@mentor.com>
References: <1467846004-12731-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Subscribe to the V4L2_EVENT_SOURCE_CHANGE event and send
V4L2_EVENT_SRC_CH_RESOLUTION in the interrupt handler on a
detected standard change.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/media/i2c/adv7180.c | 33 ++++++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index 427695d..f76a0e7 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -28,6 +28,7 @@
 #include <linux/of.h>
 #include <linux/gpio/consumer.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-event.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
@@ -824,6 +825,20 @@ static int adv7180_g_tvnorms(struct v4l2_subdev *sd, v4l2_std_id *norm)
 	return 0;
 }
 
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
@@ -838,6 +853,8 @@ static const struct v4l2_subdev_video_ops adv7180_video_ops = {
 
 static const struct v4l2_subdev_core_ops adv7180_core_ops = {
 	.s_power = adv7180_s_power,
+	.subscribe_event = adv7180_subscribe_event,
+	.unsubscribe_event = v4l2_event_subdev_unsubscribe,
 };
 
 static const struct v4l2_subdev_pad_ops adv7180_pad_ops = {
@@ -862,8 +879,18 @@ static irqreturn_t adv7180_irq(int irq, void *devid)
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
+
+		if (state->autodetect)
+			__adv7180_status(state, NULL, &state->curr_norm);
+	}
+
 	mutex_unlock(&state->mutex);
 
 	return IRQ_HANDLED;
@@ -1403,7 +1430,7 @@ static int adv7180_probe(struct i2c_client *client,
 	state->input = 0;
 	sd = &state->sd;
 	v4l2_i2c_subdev_init(sd, client, &adv7180_ops);
-	sd->flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
+	sd->flags = V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
 
 	ret = adv7180_init_controls(state);
 	if (ret)
-- 
1.9.1

