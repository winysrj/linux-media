Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42221 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726221AbeKMBzN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Nov 2018 20:55:13 -0500
Received: by mail-pf1-f196.google.com with SMTP id 64so54666pfr.9
        for <linux-media@vger.kernel.org>; Mon, 12 Nov 2018 08:01:22 -0800 (PST)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 4/7] media: ov2640: support log_status ioctl and event interface
Date: Tue, 13 Nov 2018 01:00:51 +0900
Message-Id: <1542038454-20066-5-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1542038454-20066-1-git-send-email-akinobu.mita@gmail.com>
References: <1542038454-20066-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds log_status ioctl and event interface for ov2640's v4l2 controls.

Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/i2c/ov2640.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov2640.c b/drivers/media/i2c/ov2640.c
index 4992d77..d8e91bc 100644
--- a/drivers/media/i2c/ov2640.c
+++ b/drivers/media/i2c/ov2640.c
@@ -26,6 +26,7 @@
 #include <linux/videodev2.h>
 
 #include <media/v4l2-device.h>
+#include <media/v4l2-event.h>
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-image-sizes.h>
@@ -1096,6 +1097,9 @@ static const struct v4l2_ctrl_ops ov2640_ctrl_ops = {
 };
 
 static const struct v4l2_subdev_core_ops ov2640_subdev_core_ops = {
+	.log_status = v4l2_ctrl_subdev_log_status,
+	.subscribe_event = v4l2_ctrl_subdev_subscribe_event,
+	.unsubscribe_event = v4l2_event_subdev_unsubscribe,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register	= ov2640_g_register,
 	.s_register	= ov2640_s_register,
@@ -1190,7 +1194,8 @@ static int ov2640_probe(struct i2c_client *client,
 		goto err_clk;
 
 	v4l2_i2c_subdev_init(&priv->subdev, client, &ov2640_subdev_ops);
-	priv->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	priv->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE |
+			      V4L2_SUBDEV_FL_HAS_EVENTS;
 	mutex_init(&priv->lock);
 	v4l2_ctrl_handler_init(&priv->hdl, 3);
 	priv->hdl.lock = &priv->lock;
-- 
2.7.4
