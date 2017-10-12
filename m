Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:52633 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752430AbdJLQVx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Oct 2017 12:21:53 -0400
Received: by mail-pf0-f195.google.com with SMTP id e64so5539490pfk.9
        for <linux-media@vger.kernel.org>; Thu, 12 Oct 2017 09:21:53 -0700 (PDT)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 3/4] media: ov7670: add media controller support
Date: Fri, 13 Oct 2017 01:21:16 +0900
Message-Id: <1507825277-18364-4-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1507825277-18364-1-git-send-email-akinobu.mita@gmail.com>
References: <1507825277-18364-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Create a source pad and set the media controller type to the sensor.

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/i2c/ov7670.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index 4f89a51..38e1876 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -214,6 +214,9 @@ struct ov7670_devtype {
 struct ov7670_format_struct;  /* coming later */
 struct ov7670_info {
 	struct v4l2_subdev sd;
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct media_pad pad;
+#endif
 	struct v4l2_ctrl_handler hdl;
 	struct {
 		/* gain cluster */
@@ -1654,6 +1657,14 @@ static int ov7670_probe(struct i2c_client *client,
 	if (info->pclk_hb_disable)
 		ov7670_write(sd, REG_COM10, COM10_PCLK_HB);
 
+#ifdef CONFIG_MEDIA_CONTROLLER
+	info->pad.flags = MEDIA_PAD_FL_SOURCE;
+	sd->entity.function = MEDIA_ENT_F_CAM_SENSOR;
+	ret = media_entity_pads_init(&sd->entity, 1, &info->pad);
+	if (ret)
+		goto clk_disable;
+#endif
+
 	v4l2_ctrl_handler_init(&info->hdl, 10);
 	v4l2_ctrl_new_std(&info->hdl, &ov7670_ctrl_ops,
 			V4L2_CID_BRIGHTNESS, 0, 255, 1, 128);
@@ -1700,6 +1711,9 @@ static int ov7670_probe(struct i2c_client *client,
 
 hdl_free:
 	v4l2_ctrl_handler_free(&info->hdl);
+#ifdef CONFIG_MEDIA_CONTROLLER
+	media_entity_cleanup(&sd->entity);
+#endif
 clk_disable:
 	clk_disable_unprepare(info->clk);
 	return ret;
@@ -1713,6 +1727,9 @@ static int ov7670_remove(struct i2c_client *client)
 
 	v4l2_async_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(&info->hdl);
+#ifdef CONFIG_MEDIA_CONTROLLER
+	media_entity_cleanup(&sd->entity);
+#endif
 	clk_disable_unprepare(info->clk);
 	return 0;
 }
-- 
2.7.4
