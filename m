Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58406 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbaFDQ7H (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Jun 2014 12:59:07 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v3 1/2] [media] mt9v032: register v4l2 asynchronous subdevice
Date: Wed,  4 Jun 2014 18:57:02 +0200
Message-Id: <1401901023-18213-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for registering the sensor subdevice using the v4l2-async API.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v1:
 - Simplified error path, call media_entity_cleanup even
   if media_entity_init failed.
---
 drivers/media/i2c/mt9v032.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
index 6c97dc1..cbd3546 100644
--- a/drivers/media/i2c/mt9v032.c
+++ b/drivers/media/i2c/mt9v032.c
@@ -1010,10 +1010,19 @@ static int mt9v032_probe(struct i2c_client *client,
 
 	mt9v032->pad.flags = MEDIA_PAD_FL_SOURCE;
 	ret = media_entity_init(&mt9v032->subdev.entity, 1, &mt9v032->pad, 0);
+	if (ret < 0)
+		goto err;
 
+	mt9v032->subdev.dev = &client->dev;
+	ret = v4l2_async_register_subdev(&mt9v032->subdev);
 	if (ret < 0)
-		v4l2_ctrl_handler_free(&mt9v032->ctrls);
+		goto err;
+
+	return 0;
 
+err:
+	media_entity_cleanup(&mt9v032->subdev.entity);
+	v4l2_ctrl_handler_free(&mt9v032->ctrls);
 	return ret;
 }
 
@@ -1022,6 +1031,7 @@ static int mt9v032_remove(struct i2c_client *client)
 	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
 	struct mt9v032 *mt9v032 = to_mt9v032(subdev);
 
+	v4l2_async_unregister_subdev(subdev);
 	v4l2_ctrl_handler_free(&mt9v032->ctrls);
 	v4l2_device_unregister_subdev(subdev);
 	media_entity_cleanup(&subdev->entity);
-- 
2.0.0.rc2

