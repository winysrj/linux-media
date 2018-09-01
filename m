Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:51439 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726837AbeIAQ6e (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 1 Sep 2018 12:58:34 -0400
Received: by mail-wm0-f66.google.com with SMTP id y2-v6so7503376wma.1
        for <linux-media@vger.kernel.org>; Sat, 01 Sep 2018 05:46:37 -0700 (PDT)
From: Javier Martinez Canillas <javierm@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        linux-media@vger.kernel.org
Subject: [PATCH v2 1/2] media: ov2680: don't register the v4l2 subdevice before checking chip ID
Date: Sat,  1 Sep 2018 14:46:29 +0200
Message-Id: <20180901124630.14139-1-javierm@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver registers the v4l2 subdevice before attempting to power on the
chip and checking its ID. This means that a media device driver that it's
waiting for this subdevice to be bound, will prematurely expose its media
device node to userspace because if something goes wrong the media entity
will be cleaned up again on the ov2680 probe function.

This also simplifies the probe function error path since no initialization
is made before attempting to enable the resources or checking the chip ID.

Fixes: 3ee47cad3e69 ("media: ov2680: Add Omnivision OV2680 sensor driver")
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>

---

Changes in v2:
- Just move ov2680_check_id() before ov2680_v4l2_init() - Suggested by Sakari.

 drivers/media/i2c/ov2680.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/media/i2c/ov2680.c b/drivers/media/i2c/ov2680.c
index f753a1c333ef..3ccd584568fb 100644
--- a/drivers/media/i2c/ov2680.c
+++ b/drivers/media/i2c/ov2680.c
@@ -1088,26 +1088,20 @@ static int ov2680_probe(struct i2c_client *client)
 
 	mutex_init(&sensor->lock);
 
-	ret = ov2680_v4l2_init(sensor);
+	ret = ov2680_check_id(sensor);
 	if (ret < 0)
 		goto lock_destroy;
 
-	ret = ov2680_check_id(sensor);
+	ret = ov2680_v4l2_init(sensor);
 	if (ret < 0)
-		goto error_cleanup;
+		goto lock_destroy;
 
 	dev_info(dev, "ov2680 init correctly\n");
 
 	return 0;
 
-error_cleanup:
-	dev_err(dev, "ov2680 init fail: %d\n", ret);
-
-	media_entity_cleanup(&sensor->sd.entity);
-	v4l2_async_unregister_subdev(&sensor->sd);
-	v4l2_ctrl_handler_free(&sensor->ctrls.handler);
-
 lock_destroy:
+	dev_err(dev, "ov2680 init fail: %d\n", ret);
 	mutex_destroy(&sensor->lock);
 
 	return ret;
-- 
2.17.1
