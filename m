Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60957 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbbC3LLQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2015 07:11:16 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mats Randgaard <matrandg@cisco.com>
Cc: Hans Verkuil <hansverk@cisco.com>, linux-media@vger.kernel.org,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [RFC 12/12] [media] tc358743: allow event subscription
Date: Mon, 30 Mar 2015 13:10:56 +0200
Message-Id: <1427713856-10240-13-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1427713856-10240-1-git-send-email-p.zabel@pengutronix.de>
References: <1427713856-10240-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is useful to subscribe to HDMI hotplug events via the
V4L2_CID_DV_RX_POWER_PRESENT control.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/i2c/tc358743.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index 7d70acc..aec4457 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -39,6 +39,7 @@
 #include <media/v4l2-dv-timings.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
+#include <media/v4l2-event.h>
 #include <media/v4l2-of.h>
 #include <media/tc358743.h>
 
@@ -1627,6 +1628,8 @@ static const struct v4l2_subdev_core_ops tc358743_core_ops = {
 	.s_register = tc358743_s_register,
 #endif
 	.interrupt_service_routine = tc358743_isr,
+	.subscribe_event = v4l2_ctrl_subdev_subscribe_event,
+	.unsubscribe_event = v4l2_event_subdev_unsubscribe,
 };
 
 static const struct v4l2_subdev_video_ops tc358743_video_ops = {
-- 
2.1.4

