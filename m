Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33283 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727661AbeHaT1O (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Aug 2018 15:27:14 -0400
Received: by mail-wr1-f65.google.com with SMTP id v90-v6so11581705wrc.0
        for <linux-media@vger.kernel.org>; Fri, 31 Aug 2018 08:19:15 -0700 (PDT)
From: Javier Martinez Canillas <javierm@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        linux-media@vger.kernel.org
Subject: [PATCH] media: ov2680: register the v4l2 subdev async at the end of probe
Date: Fri, 31 Aug 2018 17:19:06 +0200
Message-Id: <20180831151906.9315-1-javierm@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver registers the subdev async in the middle of the probe function
but this has to be done at the very end of the probe function to prevent
registering a device whose probe function could fail (i.e: the clock and
regulators enable can fail, the I2C transfers could return errors, etc).

It could also lead to a media device driver that is waiting to bound the
v4l2 subdevice to incorrectly expose its media device to userspace, since
the subdev is registered but later its media entity is cleaned up on error.

Fixes: 3ee47cad3e69 ("media: ov2680: Add Omnivision OV2680 sensor driver")
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>

---

 drivers/media/i2c/ov2680.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/ov2680.c b/drivers/media/i2c/ov2680.c
index f753a1c333ef..2ef920a17278 100644
--- a/drivers/media/i2c/ov2680.c
+++ b/drivers/media/i2c/ov2680.c
@@ -983,10 +983,6 @@ static int ov2680_v4l2_init(struct ov2680_dev *sensor)
 
 	sensor->sd.ctrl_handler = hdl;
 
-	ret = v4l2_async_register_subdev(&sensor->sd);
-	if (ret < 0)
-		goto cleanup_entity;
-
 	return 0;
 
 cleanup_entity:
@@ -1096,6 +1092,10 @@ static int ov2680_probe(struct i2c_client *client)
 	if (ret < 0)
 		goto error_cleanup;
 
+	ret = v4l2_async_register_subdev(&sensor->sd);
+	if (ret < 0)
+		goto error_cleanup;
+
 	dev_info(dev, "ov2680 init correctly\n");
 
 	return 0;
@@ -1104,7 +1104,6 @@ static int ov2680_probe(struct i2c_client *client)
 	dev_err(dev, "ov2680 init fail: %d\n", ret);
 
 	media_entity_cleanup(&sensor->sd.entity);
-	v4l2_async_unregister_subdev(&sensor->sd);
 	v4l2_ctrl_handler_free(&sensor->ctrls.handler);
 
 lock_destroy:
-- 
2.17.1
