Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:38495 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751741AbeDGPsu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 7 Apr 2018 11:48:50 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 4/6] media: ov772x: add media controller support
Date: Sun,  8 Apr 2018 00:48:08 +0900
Message-Id: <1523116090-13101-5-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1523116090-13101-1-git-send-email-akinobu.mita@gmail.com>
References: <1523116090-13101-1-git-send-email-akinobu.mita@gmail.com>
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
 drivers/media/i2c/ov772x.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
index 4bb81ff..5e91fa1 100644
--- a/drivers/media/i2c/ov772x.c
+++ b/drivers/media/i2c/ov772x.c
@@ -425,6 +425,9 @@ struct ov772x_priv {
 	unsigned short                    band_filter;
 	unsigned int			  fps;
 	int (*reg_read)(struct i2c_client *client, u8 addr);
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct media_pad pad;
+#endif
 };
 
 /*
@@ -1328,9 +1331,17 @@ static int ov772x_probe(struct i2c_client *client,
 		goto error_clk_put;
 	}
 
-	ret = ov772x_video_probe(priv);
+#ifdef CONFIG_MEDIA_CONTROLLER
+	priv->pad.flags = MEDIA_PAD_FL_SOURCE;
+	priv->subdev.entity.function = MEDIA_ENT_F_CAM_SENSOR;
+	ret = media_entity_pads_init(&priv->subdev.entity, 1, &priv->pad);
 	if (ret < 0)
 		goto error_gpio_put;
+#endif
+
+	ret = ov772x_video_probe(priv);
+	if (ret < 0)
+		goto error_entity_cleanup;
 
 	priv->cfmt = &ov772x_cfmts[0];
 	priv->win = &ov772x_win_sizes[0];
@@ -1338,11 +1349,15 @@ static int ov772x_probe(struct i2c_client *client,
 
 	ret = v4l2_async_register_subdev(&priv->subdev);
 	if (ret)
-		goto error_gpio_put;
+		goto error_entity_cleanup;
 
 	return 0;
 
+error_entity_cleanup:
+#ifdef CONFIG_MEDIA_CONTROLLER
+	media_entity_cleanup(&priv->subdev.entity);
 error_gpio_put:
+#endif
 	if (priv->pwdn_gpio)
 		gpiod_put(priv->pwdn_gpio);
 error_clk_put:
@@ -1357,6 +1372,9 @@ static int ov772x_remove(struct i2c_client *client)
 {
 	struct ov772x_priv *priv = to_ov772x(i2c_get_clientdata(client));
 
+#ifdef CONFIG_MEDIA_CONTROLLER
+	media_entity_cleanup(&priv->subdev.entity);
+#endif
 	clk_put(priv->clk);
 	if (priv->pwdn_gpio)
 		gpiod_put(priv->pwdn_gpio);
-- 
2.7.4
