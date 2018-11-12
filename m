Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45448 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726221AbeKMBzS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Nov 2018 20:55:18 -0500
Received: by mail-pg1-f196.google.com with SMTP id y4so4244000pgc.12
        for <linux-media@vger.kernel.org>; Mon, 12 Nov 2018 08:01:27 -0800 (PST)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 6/7] media: ov7670: support log_status ioctl and event interface
Date: Tue, 13 Nov 2018 01:00:53 +0900
Message-Id: <1542038454-20066-7-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1542038454-20066-1-git-send-email-akinobu.mita@gmail.com>
References: <1542038454-20066-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds log_status ioctl and event interface for ov7670's v4l2 controls.

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/i2c/ov7670.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index bc68a3a..a70a6ff 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -20,6 +20,7 @@
 #include <linux/gpio.h>
 #include <linux/gpio/consumer.h>
 #include <media/v4l2-device.h>
+#include <media/v4l2-event.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-fwnode.h>
 #include <media/v4l2-mediabus.h>
@@ -1651,6 +1652,9 @@ static int ov7670_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 static const struct v4l2_subdev_core_ops ov7670_core_ops = {
 	.reset = ov7670_reset,
 	.init = ov7670_init,
+	.log_status = v4l2_ctrl_subdev_log_status,
+	.subscribe_event = v4l2_ctrl_subdev_subscribe_event,
+	.unsubscribe_event = v4l2_event_subdev_unsubscribe,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register = ov7670_g_register,
 	.s_register = ov7670_s_register,
@@ -1773,7 +1777,7 @@ static int ov7670_probe(struct i2c_client *client,
 
 #ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
 	sd->internal_ops = &ov7670_subdev_internal_ops;
-	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
 #endif
 
 	info->clock_speed = 30; /* default: a guess */
-- 
2.7.4
