Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:49205 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752507AbdJSQbi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Oct 2017 12:31:38 -0400
Received: by mail-pg0-f68.google.com with SMTP id g6so7626342pgn.6
        for <linux-media@vger.kernel.org>; Thu, 19 Oct 2017 09:31:38 -0700 (PDT)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 1/4] media: adv7180: don't clear V4L2_SUBDEV_FL_IS_I2C
Date: Fri, 20 Oct 2017 01:31:20 +0900
Message-Id: <1508430683-8674-2-git-send-email-akinobu.mita@gmail.com>
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

Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/i2c/adv7180.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index 3df28f2..6fb818a 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -1328,7 +1328,7 @@ static int adv7180_probe(struct i2c_client *client,
 	state->input = 0;
 	sd = &state->sd;
 	v4l2_i2c_subdev_init(sd, client, &adv7180_ops);
-	sd->flags = V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
+	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
 
 	ret = adv7180_init_controls(state);
 	if (ret)
-- 
2.7.4
