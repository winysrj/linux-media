Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-240.synserver.de ([212.40.185.240]:1042 "EHLO
	smtp-out-240.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbbFXQui (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jun 2015 12:50:38 -0400
From: Lars-Peter Clausen <lars@metafoo.de>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 1/5] [media] adv7604: Add support for control event notifications
Date: Wed, 24 Jun 2015 18:50:27 +0200
Message-Id: <1435164631-19924-1-git-send-email-lars@metafoo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allow userspace applications to subscribe to control change events. This
can e.g. be used to monitor the 5V detect control to be notified when a
source is connected or disconnected.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/media/i2c/adv7604.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 808360f..cf1cb5a 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -41,6 +41,7 @@
 #include <media/adv7604.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
+#include <media/v4l2-event.h>
 #include <media/v4l2-dv-timings.h>
 #include <media/v4l2-of.h>
 
@@ -2356,6 +2357,8 @@ static const struct v4l2_ctrl_ops adv76xx_ctrl_ops = {
 static const struct v4l2_subdev_core_ops adv76xx_core_ops = {
 	.log_status = adv76xx_log_status,
 	.interrupt_service_routine = adv76xx_isr,
+	.subscribe_event = v4l2_ctrl_subdev_subscribe_event,
+	.unsubscribe_event = v4l2_event_subdev_unsubscribe,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register = adv76xx_g_register,
 	.s_register = adv76xx_s_register,
@@ -2833,7 +2836,7 @@ static int adv76xx_probe(struct i2c_client *client,
 	snprintf(sd->name, sizeof(sd->name), "%s %d-%04x",
 		id->name, i2c_adapter_id(client->adapter),
 		client->addr);
-	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
 
 	/*
 	 * Verify that the chip is present. On ADV7604 the RD_INFO register only
-- 
2.1.4

