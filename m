Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:53387 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751600AbdJLQVr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Oct 2017 12:21:47 -0400
Received: by mail-pf0-f194.google.com with SMTP id t188so3032582pfd.10
        for <linux-media@vger.kernel.org>; Thu, 12 Oct 2017 09:21:47 -0700 (PDT)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 2/4] media: ov7670: use v4l2_async_unregister_subdev()
Date: Fri, 13 Oct 2017 01:21:15 +0900
Message-Id: <1507825277-18364-3-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1507825277-18364-1-git-send-email-akinobu.mita@gmail.com>
References: <1507825277-18364-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The sub-device for ov7670 is registered by v4l2_async_register_subdev().
So it should be unregistered by v4l2_async_unregister_subdev() instead of
v4l2_device_unregister_subdev().

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/i2c/ov7670.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index d3f7d61..4f89a51 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -19,6 +19,7 @@
 #include <linux/videodev2.h>
 #include <linux/gpio.h>
 #include <linux/gpio/consumer.h>
+#include <media/v4l2-async.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-mediabus.h>
@@ -1710,7 +1711,7 @@ static int ov7670_remove(struct i2c_client *client)
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 	struct ov7670_info *info = to_state(sd);
 
-	v4l2_device_unregister_subdev(sd);
+	v4l2_async_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(&info->hdl);
 	clk_disable_unprepare(info->clk);
 	return 0;
-- 
2.7.4
