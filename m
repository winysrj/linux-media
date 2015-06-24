Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-240.synserver.de ([212.40.185.240]:1061 "EHLO
	smtp-out-240.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752405AbbFXQui (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jun 2015 12:50:38 -0400
From: Lars-Peter Clausen <lars@metafoo.de>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 2/5] [media] adv7842: Add support for control event notifications
Date: Wed, 24 Jun 2015 18:50:28 +0200
Message-Id: <1435164631-19924-2-git-send-email-lars@metafoo.de>
In-Reply-To: <1435164631-19924-1-git-send-email-lars@metafoo.de>
References: <1435164631-19924-1-git-send-email-lars@metafoo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allow userspace applications to subscribe to control change events. This
can e.g. be used to monitor the 5V detect control to be notified when a
source is connected or disconnected.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/media/i2c/adv7842.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 4cf79b2..ffc0655 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -40,6 +40,7 @@
 #include <linux/v4l2-dv-timings.h>
 #include <linux/hdmi.h>
 #include <media/v4l2-device.h>
+#include <media/v4l2-event.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-dv-timings.h>
 #include <media/adv7842.h>
@@ -3015,6 +3016,8 @@ static const struct v4l2_subdev_core_ops adv7842_core_ops = {
 	.log_status = adv7842_log_status,
 	.ioctl = adv7842_ioctl,
 	.interrupt_service_routine = adv7842_isr,
+	.subscribe_event = v4l2_ctrl_subdev_subscribe_event,
+	.unsubscribe_event = v4l2_event_subdev_unsubscribe,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register = adv7842_g_register,
 	.s_register = adv7842_s_register,
@@ -3210,7 +3213,7 @@ static int adv7842_probe(struct i2c_client *client,
 
 	sd = &state->sd;
 	v4l2_i2c_subdev_init(sd, client, &adv7842_ops);
-	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
 	state->mode = pdata->mode;
 
 	state->hdmi_port_a = pdata->input == ADV7842_SELECT_HDMI_PORT_A;
-- 
2.1.4

