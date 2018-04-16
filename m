Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:42487 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752630AbeDPCwY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 15 Apr 2018 22:52:24 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH v2 04/10] media: ov772x: add media controller support
Date: Mon, 16 Apr 2018 11:51:45 +0900
Message-Id: <1523847111-12986-5-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1523847111-12986-1-git-send-email-akinobu.mita@gmail.com>
References: <1523847111-12986-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Create a source pad and set the media controller type to the sensor.

Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
* v2
- Move video_probe() before the entity initialization and remove the #ifdef
  around the media_entity_cleanup()

 drivers/media/i2c/ov772x.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
index 188f2f1..0ae2a4f 100644
--- a/drivers/media/i2c/ov772x.c
+++ b/drivers/media/i2c/ov772x.c
@@ -424,6 +424,9 @@ struct ov772x_priv {
 	/* band_filter = COM8[5] ? 256 - BDBASE : 0 */
 	unsigned short                    band_filter;
 	unsigned int			  fps;
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct media_pad pad;
+#endif
 };
 
 /*
@@ -1318,16 +1321,26 @@ static int ov772x_probe(struct i2c_client *client,
 	if (ret < 0)
 		goto error_gpio_put;
 
+#ifdef CONFIG_MEDIA_CONTROLLER
+	priv->pad.flags = MEDIA_PAD_FL_SOURCE;
+	priv->subdev.entity.function = MEDIA_ENT_F_CAM_SENSOR;
+	ret = media_entity_pads_init(&priv->subdev.entity, 1, &priv->pad);
+	if (ret < 0)
+		goto error_gpio_put;
+#endif
+
 	priv->cfmt = &ov772x_cfmts[0];
 	priv->win = &ov772x_win_sizes[0];
 	priv->fps = 15;
 
 	ret = v4l2_async_register_subdev(&priv->subdev);
 	if (ret)
-		goto error_gpio_put;
+		goto error_entity_cleanup;
 
 	return 0;
 
+error_entity_cleanup:
+	media_entity_cleanup(&priv->subdev.entity);
 error_gpio_put:
 	if (priv->pwdn_gpio)
 		gpiod_put(priv->pwdn_gpio);
@@ -1343,6 +1356,7 @@ static int ov772x_remove(struct i2c_client *client)
 {
 	struct ov772x_priv *priv = to_ov772x(i2c_get_clientdata(client));
 
+	media_entity_cleanup(&priv->subdev.entity);
 	clk_put(priv->clk);
 	if (priv->pwdn_gpio)
 		gpiod_put(priv->pwdn_gpio);
-- 
2.7.4
