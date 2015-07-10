Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33014 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932443AbbGJNLw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jul 2015 09:11:52 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mats Randgaard <matrandg@cisco.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 5/5] [media] tc358743: allow event subscription
Date: Fri, 10 Jul 2015 15:11:37 +0200
Message-Id: <1436533897-3060-5-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1436533897-3060-1-git-send-email-p.zabel@pengutronix.de>
References: <1436533897-3060-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is useful to subscribe to HDMI hotplug events via the
V4L2_CID_DV_RX_POWER_PRESENT control.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/i2c/tc358743.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index 4a889d4..91fffa8 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -40,6 +40,7 @@
 #include <media/v4l2-dv-timings.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
+#include <media/v4l2-event.h>
 #include <media/v4l2-of.h>
 #include <media/tc358743.h>
 
@@ -1604,6 +1605,8 @@ static const struct v4l2_subdev_core_ops tc358743_core_ops = {
 	.s_register = tc358743_s_register,
 #endif
 	.interrupt_service_routine = tc358743_isr,
+	.subscribe_event = v4l2_ctrl_subdev_subscribe_event,
+	.unsubscribe_event = v4l2_event_subdev_unsubscribe,
 };
 
 static const struct v4l2_subdev_video_ops tc358743_video_ops = {
-- 
2.1.4

