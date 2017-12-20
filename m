Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:38871 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753433AbdLTQdx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Dec 2017 11:33:53 -0500
Received: by mail-pf0-f193.google.com with SMTP id u25so12768960pfg.5
        for <linux-media@vger.kernel.org>; Wed, 20 Dec 2017 08:33:53 -0800 (PST)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 2/4] meida: mt9m111: add media controller support
Date: Thu, 21 Dec 2017 01:33:32 +0900
Message-Id: <1513787614-12008-3-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1513787614-12008-1-git-send-email-akinobu.mita@gmail.com>
References: <1513787614-12008-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Create a source pad and set the media controller type to the sensor.

Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/i2c/mt9m111.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/mt9m111.c b/drivers/media/i2c/mt9m111.c
index 4fa10df..e1d5032 100644
--- a/drivers/media/i2c/mt9m111.c
+++ b/drivers/media/i2c/mt9m111.c
@@ -215,6 +215,9 @@ struct mt9m111 {
 	int power_count;
 	const struct mt9m111_datafmt *fmt;
 	int lastpage;	/* PageMap cache value */
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct media_pad pad;
+#endif
 };
 
 /* Find a data format by a pixel code */
@@ -971,6 +974,14 @@ static int mt9m111_probe(struct i2c_client *client,
 		goto out_clkput;
 	}
 
+#ifdef CONFIG_MEDIA_CONTROLLER
+	mt9m111->pad.flags = MEDIA_PAD_FL_SOURCE;
+	mt9m111->subdev.entity.function = MEDIA_ENT_F_CAM_SENSOR;
+	ret = media_entity_pads_init(&mt9m111->subdev.entity, 1, &mt9m111->pad);
+	if (ret < 0)
+		goto out_hdlfree;
+#endif
+
 	/* Second stage probe - when a capture adapter is there */
 	mt9m111->rect.left	= MT9M111_MIN_DARK_COLS;
 	mt9m111->rect.top	= MT9M111_MIN_DARK_ROWS;
@@ -982,16 +993,20 @@ static int mt9m111_probe(struct i2c_client *client,
 
 	ret = mt9m111_video_probe(client);
 	if (ret < 0)
-		goto out_hdlfree;
+		goto out_entityclean;
 
 	mt9m111->subdev.dev = &client->dev;
 	ret = v4l2_async_register_subdev(&mt9m111->subdev);
 	if (ret < 0)
-		goto out_hdlfree;
+		goto out_entityclean;
 
 	return 0;
 
+out_entityclean:
+#ifdef CONFIG_MEDIA_CONTROLLER
+	media_entity_cleanup(&mt9m111->subdev.entity);
 out_hdlfree:
+#endif
 	v4l2_ctrl_handler_free(&mt9m111->hdl);
 out_clkput:
 	v4l2_clk_put(mt9m111->clk);
@@ -1004,6 +1019,9 @@ static int mt9m111_remove(struct i2c_client *client)
 	struct mt9m111 *mt9m111 = to_mt9m111(client);
 
 	v4l2_async_unregister_subdev(&mt9m111->subdev);
+#ifdef CONFIG_MEDIA_CONTROLLER
+	media_entity_cleanup(&mt9m111->subdev.entity);
+#endif
 	v4l2_clk_put(mt9m111->clk);
 	v4l2_ctrl_handler_free(&mt9m111->hdl);
 
-- 
2.7.4
