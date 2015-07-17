Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48320 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401AbbGQPG7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jul 2015 11:06:59 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mats Randgaard <matrandg@cisco.com>, linux-media@vger.kernel.org,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2] [media] tc358743: allow event subscription
Date: Fri, 17 Jul 2015 17:06:54 +0200
Message-Id: <1437145614-4313-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is useful to subscribe to HDMI hotplug events via the
V4L2_CID_DV_RX_POWER_PRESENT control.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v1:
 - Make use of v4l2_subdev_notify_event, v4l2_src_change_event_subdev_subscribe,
   and v4l2_ctrl_subdev_subscribe_event.
---
 drivers/media/i2c/tc358743.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index 0c3c8aa..0d31a4f 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -860,8 +860,7 @@ static void tc358743_format_change(struct v4l2_subdev *sd)
 				&timings, false);
 	}
 
-	v4l2_subdev_notify(sd, V4L2_DEVICE_NOTIFY_EVENT,
-			(void *)&tc358743_ev_fmt);
+	v4l2_subdev_notify_event(sd, &tc358743_ev_fmt);
 }
 
 static void tc358743_init_interrupts(struct v4l2_subdev *sd)
@@ -1318,6 +1317,19 @@ static irqreturn_t tc358743_irq_handler(int irq, void *dev_id)
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
@@ -1605,7 +1617,7 @@ static const struct v4l2_subdev_core_ops tc358743_core_ops = {
 	.s_register = tc358743_s_register,
 #endif
 	.interrupt_service_routine = tc358743_isr,
-	.subscribe_event = v4l2_ctrl_subdev_subscribe_event,
+	.subscribe_event = tc358743_subscribe_event,
 	.unsubscribe_event = v4l2_event_subdev_unsubscribe,
 };
 
-- 
2.1.4

