Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl1-f196.google.com ([209.85.214.196]:40681 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726221AbeKMBzE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Nov 2018 20:55:04 -0500
Received: by mail-pl1-f196.google.com with SMTP id q19-v6so4544508pll.7
        for <linux-media@vger.kernel.org>; Mon, 12 Nov 2018 08:01:14 -0800 (PST)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 1/7] media: mt9m111: support log_status ioctl and event interface
Date: Tue, 13 Nov 2018 01:00:48 +0900
Message-Id: <1542038454-20066-2-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1542038454-20066-1-git-send-email-akinobu.mita@gmail.com>
References: <1542038454-20066-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds log_status ioctl and event interface for mt9m111's v4l2 controls.

Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/i2c/mt9m111.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/mt9m111.c b/drivers/media/i2c/mt9m111.c
index 1395986..f4fc459 100644
--- a/drivers/media/i2c/mt9m111.c
+++ b/drivers/media/i2c/mt9m111.c
@@ -21,6 +21,7 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
+#include <media/v4l2-event.h>
 
 /*
  * MT9M111, MT9M112 and MT9M131:
@@ -862,6 +863,9 @@ static const struct v4l2_ctrl_ops mt9m111_ctrl_ops = {
 
 static const struct v4l2_subdev_core_ops mt9m111_subdev_core_ops = {
 	.s_power	= mt9m111_s_power,
+	.log_status = v4l2_ctrl_subdev_log_status,
+	.subscribe_event = v4l2_ctrl_subdev_subscribe_event,
+	.unsubscribe_event = v4l2_event_subdev_unsubscribe,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register	= mt9m111_g_register,
 	.s_register	= mt9m111_s_register,
@@ -976,7 +980,8 @@ static int mt9m111_probe(struct i2c_client *client,
 	mt9m111->ctx = &context_b;
 
 	v4l2_i2c_subdev_init(&mt9m111->subdev, client, &mt9m111_subdev_ops);
-	mt9m111->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	mt9m111->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE |
+				 V4L2_SUBDEV_FL_HAS_EVENTS;
 
 	v4l2_ctrl_handler_init(&mt9m111->hdl, 5);
 	v4l2_ctrl_new_std(&mt9m111->hdl, &mt9m111_ctrl_ops,
-- 
2.7.4
