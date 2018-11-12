Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35808 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729601AbeKMBzV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Nov 2018 20:55:21 -0500
Received: by mail-pf1-f194.google.com with SMTP id v9-v6so4533008pff.2
        for <linux-media@vger.kernel.org>; Mon, 12 Nov 2018 08:01:30 -0800 (PST)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Jacopo Mondi <jacopo@jmondi.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 7/7] media: ov772x: support log_status ioctl and event interface
Date: Tue, 13 Nov 2018 01:00:54 +0900
Message-Id: <1542038454-20066-8-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1542038454-20066-1-git-send-email-akinobu.mita@gmail.com>
References: <1542038454-20066-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds log_status ioctl and event interface for ov772x's v4l2 controls.

Cc: Jacopo Mondi <jacopo@jmondi.org>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/i2c/ov772x.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
index fefff7f..2e9a758 100644
--- a/drivers/media/i2c/ov772x.c
+++ b/drivers/media/i2c/ov772x.c
@@ -30,6 +30,7 @@
 
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
+#include <media/v4l2-event.h>
 #include <media/v4l2-image-sizes.h>
 #include <media/v4l2-subdev.h>
 
@@ -1287,6 +1288,9 @@ static const struct v4l2_ctrl_ops ov772x_ctrl_ops = {
 };
 
 static const struct v4l2_subdev_core_ops ov772x_subdev_core_ops = {
+	.log_status = v4l2_ctrl_subdev_log_status,
+	.subscribe_event = v4l2_ctrl_subdev_subscribe_event,
+	.unsubscribe_event = v4l2_event_subdev_unsubscribe,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register	= ov772x_g_register,
 	.s_register	= ov772x_s_register,
@@ -1379,7 +1383,8 @@ static int ov772x_probe(struct i2c_client *client,
 	mutex_init(&priv->lock);
 
 	v4l2_i2c_subdev_init(&priv->subdev, client, &ov772x_subdev_ops);
-	priv->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	priv->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE |
+			      V4L2_SUBDEV_FL_HAS_EVENTS;
 	v4l2_ctrl_handler_init(&priv->hdl, 3);
 	/* Use our mutex for the controls */
 	priv->hdl.lock = &priv->lock;
-- 
2.7.4
