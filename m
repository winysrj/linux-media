Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38354 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726221AbeKMBzP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Nov 2018 20:55:15 -0500
Received: by mail-pf1-f194.google.com with SMTP id v76-v6so1704349pfa.5
        for <linux-media@vger.kernel.org>; Mon, 12 Nov 2018 08:01:24 -0800 (PST)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5/7] media: ov5640: support log_status ioctl and event interface
Date: Tue, 13 Nov 2018 01:00:52 +0900
Message-Id: <1542038454-20066-6-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1542038454-20066-1-git-send-email-akinobu.mita@gmail.com>
References: <1542038454-20066-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds log_status ioctl and event interface for ov5640's v4l2 controls.

Cc: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/i2c/ov5640.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index eaefdb5..a91d917 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -25,6 +25,7 @@
 #include <media/v4l2-async.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
+#include <media/v4l2-event.h>
 #include <media/v4l2-fwnode.h>
 #include <media/v4l2-subdev.h>
 
@@ -2641,6 +2642,9 @@ static int ov5640_s_stream(struct v4l2_subdev *sd, int enable)
 
 static const struct v4l2_subdev_core_ops ov5640_core_ops = {
 	.s_power = ov5640_s_power,
+	.log_status = v4l2_ctrl_subdev_log_status,
+	.subscribe_event = v4l2_ctrl_subdev_subscribe_event,
+	.unsubscribe_event = v4l2_event_subdev_unsubscribe,
 };
 
 static const struct v4l2_subdev_video_ops ov5640_video_ops = {
@@ -2795,7 +2799,8 @@ static int ov5640_probe(struct i2c_client *client,
 
 	v4l2_i2c_subdev_init(&sensor->sd, client, &ov5640_subdev_ops);
 
-	sensor->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	sensor->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE |
+			    V4L2_SUBDEV_FL_HAS_EVENTS;
 	sensor->pad.flags = MEDIA_PAD_FL_SOURCE;
 	sensor->sd.entity.function = MEDIA_ENT_F_CAM_SENSOR;
 	ret = media_entity_pads_init(&sensor->sd.entity, 1, &sensor->pad);
-- 
2.7.4
