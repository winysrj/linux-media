Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-240.synserver.de ([212.40.185.240]:1064 "EHLO
	smtp-out-240.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802AbbFXQui (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jun 2015 12:50:38 -0400
From: Lars-Peter Clausen <lars@metafoo.de>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 4/5] [media] adv7604: Deliver resolution change events to userspace
Date: Wed, 24 Jun 2015 18:50:30 +0200
Message-Id: <1435164631-19924-4-git-send-email-lars@metafoo.de>
In-Reply-To: <1435164631-19924-1-git-send-email-lars@metafoo.de>
References: <1435164631-19924-1-git-send-email-lars@metafoo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the new v4l2_subdev_notify_event() helper function to deliver the
resolution change event to userspace via the v4l2 subdev event queue as
well as to the bridge driver using the callback notify mechanism.

This allows userspace applications to react to changes in resolution. This
is useful and often necessary for video pipelines where there is no direct
1-to-1 relationship between the subdevice converter and the video capture
device and hence it does not make sense to directly forward the event to
the video capture device node.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/media/i2c/adv7604.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index cf1cb5a..b66f63e3 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -1761,8 +1761,8 @@ static int adv76xx_s_routing(struct v4l2_subdev *sd,
 	select_input(sd);
 	enable_input(sd);
 
-	v4l2_subdev_notify(sd, V4L2_DEVICE_NOTIFY_EVENT,
-			   (void *)&adv76xx_ev_fmt);
+	v4l2_subdev_notify_event(sd, &adv76xx_ev_fmt);
+
 	return 0;
 }
 
@@ -1929,8 +1929,7 @@ static int adv76xx_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 			"%s: fmt_change = 0x%x, fmt_change_digital = 0x%x\n",
 			__func__, fmt_change, fmt_change_digital);
 
-		v4l2_subdev_notify(sd, V4L2_DEVICE_NOTIFY_EVENT,
-				   (void *)&adv76xx_ev_fmt);
+		v4l2_subdev_notify_event(sd, &adv76xx_ev_fmt);
 
 		if (handled)
 			*handled = true;
@@ -2348,6 +2347,20 @@ static int adv76xx_log_status(struct v4l2_subdev *sd)
 	return 0;
 }
 
+static int adv76xx_subscribe_event(struct v4l2_subdev *sd,
+				   struct v4l2_fh *fh,
+				   struct v4l2_event_subscription *sub)
+{
+	switch (sub->type) {
+	case V4L2_EVENT_SOURCE_CHANGE:
+		return v4l2_src_change_event_subdev_subscribe(sd, fh, sub);
+	case V4L2_EVENT_CTRL:
+		return v4l2_event_subdev_unsubscribe(sd, fh, sub);
+	default:
+		return -EINVAL;
+	}
+}
+
 /* ----------------------------------------------------------------------- */
 
 static const struct v4l2_ctrl_ops adv76xx_ctrl_ops = {
@@ -2357,7 +2370,7 @@ static const struct v4l2_ctrl_ops adv76xx_ctrl_ops = {
 static const struct v4l2_subdev_core_ops adv76xx_core_ops = {
 	.log_status = adv76xx_log_status,
 	.interrupt_service_routine = adv76xx_isr,
-	.subscribe_event = v4l2_ctrl_subdev_subscribe_event,
+	.subscribe_event = adv76xx_subscribe_event,
 	.unsubscribe_event = v4l2_event_subdev_unsubscribe,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register = adv76xx_g_register,
-- 
2.1.4

