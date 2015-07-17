Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33414 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758445AbbGQP0w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jul 2015 11:26:52 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mats Randgaard <matrandg@cisco.com>, linux-media@vger.kernel.org,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v3] [media] tc358743: allow event subscription
Date: Fri, 17 Jul 2015 17:26:45 +0200
Message-Id: <1437146805-32005-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is useful to subscribe to HDMI hotplug events via the
V4L2_CID_DV_RX_POWER_PRESENT control.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v1:
 - Make use of v4l2_subdev_notify_event, v4l2_src_change_event_subdev_subscribe,
   and v4l2_ctrl_subdev_subscribe_event.
Changes since v2:
 - Actually include the changes of v1, too.
---
 drivers/media/i2c/tc358743.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index 8c455f3..7eba223 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -40,6 +40,7 @@
 #include <media/v4l2-dv-timings.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
+#include <media/v4l2-event.h>
 #include <media/v4l2-of.h>
 #include <media/tc358743.h>
 
@@ -859,8 +860,7 @@ static void tc358743_format_change(struct v4l2_subdev *sd)
 				&timings, false);
 	}
 
-	v4l2_subdev_notify(sd, V4L2_DEVICE_NOTIFY_EVENT,
-			(void *)&tc358743_ev_fmt);
+	v4l2_subdev_notify_event(sd, &tc358743_ev_fmt);
 }
 
 static void tc358743_init_interrupts(struct v4l2_subdev *sd)
@@ -1317,6 +1317,19 @@ static irqreturn_t tc358743_irq_handler(int irq, void *dev_id)
 	return handled ? IRQ_HANDLED : IRQ_NONE;
 }
 
+static int tc358743_subscribe_event(struct v4l2_subdev *sd, struct v4l2_fh *fh,
+				    struct v4l2_event_subscription *sub)
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
 /* --------------- VIDEO OPS --------------- */
 
 static int tc358743_g_input_status(struct v4l2_subdev *sd, u32 *status)
@@ -1604,6 +1617,8 @@ static const struct v4l2_subdev_core_ops tc358743_core_ops = {
 	.s_register = tc358743_s_register,
 #endif
 	.interrupt_service_routine = tc358743_isr,
+	.subscribe_event = tc358743_subscribe_event,
+	.unsubscribe_event = v4l2_event_subdev_unsubscribe,
 };
 
 static const struct v4l2_subdev_video_ops tc358743_video_ops = {
-- 
2.1.4

