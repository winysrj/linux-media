Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:41128 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751777AbeEFOUL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 6 May 2018 10:20:11 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH v5 09/14] media: ov772x: handle nested s_power() calls
Date: Sun,  6 May 2018 23:19:24 +0900
Message-Id: <1525616369-8843-10-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1525616369-8843-1-git-send-email-akinobu.mita@gmail.com>
References: <1525616369-8843-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Depending on the v4l2 driver, calling s_power() could be nested.  So the
actual transitions between power saving mode and normal operation mode
should only happen at the first power on and the last power off.

This adds an s_power() nesting counter and updates the power state if the
counter is modified from 0 to != 0 or from != 0 to 0.

Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Reviewed-by: Jacopo Mondi <jacopo@jmondi.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
* v5
- No changes

 drivers/media/i2c/ov772x.c | 34 ++++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
index 2b02411..6c0c792 100644
--- a/drivers/media/i2c/ov772x.c
+++ b/drivers/media/i2c/ov772x.c
@@ -424,6 +424,9 @@ struct ov772x_priv {
 	/* band_filter = COM8[5] ? 256 - BDBASE : 0 */
 	unsigned short                    band_filter;
 	unsigned int			  fps;
+	/* lock to protect power_count */
+	struct mutex			  lock;
+	int				  power_count;
 #ifdef CONFIG_MEDIA_CONTROLLER
 	struct media_pad pad;
 #endif
@@ -871,9 +874,26 @@ static int ov772x_power_off(struct ov772x_priv *priv)
 static int ov772x_s_power(struct v4l2_subdev *sd, int on)
 {
 	struct ov772x_priv *priv = to_ov772x(sd);
+	int ret = 0;
+
+	mutex_lock(&priv->lock);
+
+	/* If the power count is modified from 0 to != 0 or from != 0 to 0,
+	 * update the power state.
+	 */
+	if (priv->power_count == !on)
+		ret = on ? ov772x_power_on(priv) : ov772x_power_off(priv);
+
+	if (!ret) {
+		/* Update the power count. */
+		priv->power_count += on ? 1 : -1;
+		WARN(priv->power_count < 0, "Unbalanced power count\n");
+		WARN(priv->power_count > 1, "Duplicated s_power call\n");
+	}
+
+	mutex_unlock(&priv->lock);
 
-	return on ? ov772x_power_on(priv) :
-		    ov772x_power_off(priv);
+	return ret;
 }
 
 static const struct ov772x_win_size *ov772x_select_win(u32 width, u32 height)
@@ -1303,6 +1323,7 @@ static int ov772x_probe(struct i2c_client *client,
 		return -ENOMEM;
 
 	priv->info = client->dev.platform_data;
+	mutex_init(&priv->lock);
 
 	v4l2_i2c_subdev_init(&priv->subdev, client, &ov772x_subdev_ops);
 	v4l2_ctrl_handler_init(&priv->hdl, 3);
@@ -1313,8 +1334,10 @@ static int ov772x_probe(struct i2c_client *client,
 	v4l2_ctrl_new_std(&priv->hdl, &ov772x_ctrl_ops,
 			  V4L2_CID_BAND_STOP_FILTER, 0, 256, 1, 0);
 	priv->subdev.ctrl_handler = &priv->hdl;
-	if (priv->hdl.error)
-		return priv->hdl.error;
+	if (priv->hdl.error) {
+		ret = priv->hdl.error;
+		goto error_mutex_destroy;
+	}
 
 	priv->clk = clk_get(&client->dev, NULL);
 	if (IS_ERR(priv->clk)) {
@@ -1362,6 +1385,8 @@ static int ov772x_probe(struct i2c_client *client,
 	clk_put(priv->clk);
 error_ctrl_free:
 	v4l2_ctrl_handler_free(&priv->hdl);
+error_mutex_destroy:
+	mutex_destroy(&priv->lock);
 
 	return ret;
 }
@@ -1376,6 +1401,7 @@ static int ov772x_remove(struct i2c_client *client)
 		gpiod_put(priv->pwdn_gpio);
 	v4l2_async_unregister_subdev(&priv->subdev);
 	v4l2_ctrl_handler_free(&priv->hdl);
+	mutex_destroy(&priv->lock);
 
 	return 0;
 }
-- 
2.7.4
