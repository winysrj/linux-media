Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:54313 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752781AbdJSQbo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Oct 2017 12:31:44 -0400
Received: by mail-pg0-f66.google.com with SMTP id l24so7612754pgu.11
        for <linux-media@vger.kernel.org>; Thu, 19 Oct 2017 09:31:44 -0700 (PDT)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 4/4] media: ov5640: don't clear V4L2_SUBDEV_FL_IS_I2C
Date: Fri, 20 Oct 2017 01:31:23 +0900
Message-Id: <1508430683-8674-5-git-send-email-akinobu.mita@gmail.com>
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

Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/i2c/ov5640.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 39a2269..c89ed66 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -2271,7 +2271,7 @@ static int ov5640_probe(struct i2c_client *client,
 
 	v4l2_i2c_subdev_init(&sensor->sd, client, &ov5640_subdev_ops);
 
-	sensor->sd.flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
+	sensor->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 	sensor->pad.flags = MEDIA_PAD_FL_SOURCE;
 	sensor->sd.entity.function = MEDIA_ENT_F_CAM_SENSOR;
 	ret = media_entity_pads_init(&sensor->sd.entity, 1, &sensor->pad);
-- 
2.7.4
