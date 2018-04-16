Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:42498 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752854AbeDPCwg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 15 Apr 2018 22:52:36 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH v2 08/10] media: ov772x: handle nested s_power() calls
Date: Mon, 16 Apr 2018 11:51:49 +0900
Message-Id: <1523847111-12986-9-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1523847111-12986-1-git-send-email-akinobu.mita@gmail.com>
References: <1523847111-12986-1-git-send-email-akinobu.mita@gmail.com>
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
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
* v2
- New patch

 drivers/media/i2c/ov772x.c | 33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
index 4245a46..2cd6e85 100644
--- a/drivers/media/i2c/ov772x.c
+++ b/drivers/media/i2c/ov772x.c
@@ -424,6 +424,9 @@ struct ov772x_priv {
 	/* band_filter = COM8[5] ? 256 - BDBASE : 0 */
 	unsigned short                    band_filter;
 	unsigned int			  fps;
+	/* lock to protect power_count */
+	struct mutex			  power_lock;
+	int				  power_count;
 #ifdef CONFIG_MEDIA_CONTROLLER
 	struct media_pad pad;
 #endif
@@ -871,9 +874,25 @@ static int ov772x_power_off(struct ov772x_priv *priv)
 static int ov772x_s_power(struct v4l2_subdev *sd, int on)
 {
 	struct ov772x_priv *priv = to_ov772x(sd);
+	int ret = 0;
+
+	mutex_lock(&priv->power_lock);
 
-	return on ? ov772x_power_on(priv) :
-		    ov772x_power_off(priv);
+	/* If the power count is modified from 0 to != 0 or from != 0 to 0,
+	 * update the power state.
+	 */
+	if (priv->power_count == !on)
+		ret = on ? ov772x_power_on(priv) : ov772x_power_off(priv);
+
+	if (!ret) {
+		/* Update the power count. */
+		priv->power_count += on ? 1 : -1;
+		WARN_ON(priv->power_count < 0);
+	}
+
+	mutex_unlock(&priv->power_lock);
+
+	return ret;
 }
 
 static const struct ov772x_win_size *ov772x_select_win(u32 width, u32 height)
@@ -1303,6 +1322,7 @@ static int ov772x_probe(struct i2c_client *client,
 		return -ENOMEM;
 
 	priv->info = client->dev.platform_data;
+	mutex_init(&priv->power_lock);
 
 	v4l2_i2c_subdev_init(&priv->subdev, client, &ov772x_subdev_ops);
 	priv->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
@@ -1314,8 +1334,10 @@ static int ov772x_probe(struct i2c_client *client,
 	v4l2_ctrl_new_std(&priv->hdl, &ov772x_ctrl_ops,
 			  V4L2_CID_BAND_STOP_FILTER, 0, 256, 1, 0);
 	priv->subdev.ctrl_handler = &priv->hdl;
-	if (priv->hdl.error)
-		return priv->hdl.error;
+	if (priv->hdl.error) {
+		ret = priv->hdl.error;
+		goto error_mutex_destroy;
+	}
 
 	priv->clk = clk_get(&client->dev, "xclk");
 	if (IS_ERR(priv->clk)) {
@@ -1363,6 +1385,8 @@ static int ov772x_probe(struct i2c_client *client,
 	clk_put(priv->clk);
 error_ctrl_free:
 	v4l2_ctrl_handler_free(&priv->hdl);
+error_mutex_destroy:
+	mutex_destroy(&priv->power_lock);
 
 	return ret;
 }
@@ -1377,6 +1401,7 @@ static int ov772x_remove(struct i2c_client *client)
 		gpiod_put(priv->pwdn_gpio);
 	v4l2_async_unregister_subdev(&priv->subdev);
 	v4l2_ctrl_handler_free(&priv->hdl);
+	mutex_destroy(&priv->power_lock);
 
 	return 0;
 }
-- 
2.7.4
