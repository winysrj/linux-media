Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:44864 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752781AbdJSQbm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Oct 2017 12:31:42 -0400
Received: by mail-pg0-f67.google.com with SMTP id j3so7627988pga.1
        for <linux-media@vger.kernel.org>; Thu, 19 Oct 2017 09:31:41 -0700 (PDT)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 3/4] media: ov2640: don't clear V4L2_SUBDEV_FL_IS_I2C
Date: Fri, 20 Oct 2017 01:31:22 +0900
Message-Id: <1508430683-8674-4-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1508430683-8674-1-git-send-email-akinobu.mita@gmail.com>
References: <1508430683-8674-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The v4l2_i2c_subdev_init() sets V4L2_SUBDEV_FL_IS_I2C flag in the
subdev->flags.  But this driver overwrites subdev->flags immediately after
calling v4l2_i2c_subdev_init().  So V4L2_SUBDEV_FL_IS_I2C is not set after
all.

This stops breaking subdev->flags and preserves V4L2_SUBDEV_FL_IS_I2C.

Side note: According to the comment in v4l2_device_unregister(), this is
problematic only if the device is platform bus device.  Device tree or
ACPI based devices are not affected.

Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/i2c/ov2640.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov2640.c b/drivers/media/i2c/ov2640.c
index e6d0c1f..5b035d1 100644
--- a/drivers/media/i2c/ov2640.c
+++ b/drivers/media/i2c/ov2640.c
@@ -1116,7 +1116,7 @@ static int ov2640_probe(struct i2c_client *client,
 		goto err_clk;
 
 	v4l2_i2c_subdev_init(&priv->subdev, client, &ov2640_subdev_ops);
-	priv->subdev.flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
+	priv->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 	v4l2_ctrl_handler_init(&priv->hdl, 2);
 	v4l2_ctrl_new_std(&priv->hdl, &ov2640_ctrl_ops,
 			V4L2_CID_VFLIP, 0, 1, 1, 0);
-- 
2.7.4
