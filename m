Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:43293 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751822AbeEFOUX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 6 May 2018 10:20:23 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH v5 13/14] media: ov772x: make set_fmt() and s_frame_interval() return -EBUSY while streaming
Date: Sun,  6 May 2018 23:19:28 +0900
Message-Id: <1525616369-8843-14-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1525616369-8843-1-git-send-email-akinobu.mita@gmail.com>
References: <1525616369-8843-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ov772x driver is going to offer a V4L2 sub-device interface, so
changing the output data format and the frame interval on this sub-device
can be made anytime.  However, these requests are preferred to fail while
the video stream on the device is active.

Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
* v5:
- Make s_frame_interval() return -EBUSY while streaming

 drivers/media/i2c/ov772x.c | 43 +++++++++++++++++++++++++++++++++----------
 1 file changed, 33 insertions(+), 10 deletions(-)

diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
index 262a7e5..4b479f9 100644
--- a/drivers/media/i2c/ov772x.c
+++ b/drivers/media/i2c/ov772x.c
@@ -424,9 +424,10 @@ struct ov772x_priv {
 	/* band_filter = COM8[5] ? 256 - BDBASE : 0 */
 	struct v4l2_ctrl		 *band_filter_ctrl;
 	unsigned int			  fps;
-	/* lock to protect power_count */
+	/* lock to protect power_count and streaming */
 	struct mutex			  lock;
 	int				  power_count;
+	int				  streaming;
 #ifdef CONFIG_MEDIA_CONTROLLER
 	struct media_pad pad;
 #endif
@@ -603,18 +604,28 @@ static int ov772x_s_stream(struct v4l2_subdev *sd, int enable)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct ov772x_priv *priv = to_ov772x(sd);
+	int ret = 0;
 
-	if (!enable) {
-		ov772x_mask_set(client, COM2, SOFT_SLEEP_MODE, SOFT_SLEEP_MODE);
-		return 0;
-	}
+	mutex_lock(&priv->lock);
 
-	ov772x_mask_set(client, COM2, SOFT_SLEEP_MODE, 0);
+	if (priv->streaming == enable)
+		goto done;
 
-	dev_dbg(&client->dev, "format %d, win %s\n",
-		priv->cfmt->code, priv->win->name);
+	ret = ov772x_mask_set(client, COM2, SOFT_SLEEP_MODE,
+			      enable ? 0 : SOFT_SLEEP_MODE);
+	if (ret)
+		goto done;
 
-	return 0;
+	if (enable) {
+		dev_dbg(&client->dev, "format %d, win %s\n",
+			priv->cfmt->code, priv->win->name);
+	}
+	priv->streaming = enable;
+
+done:
+	mutex_unlock(&priv->lock);
+
+	return ret;
 }
 
 static unsigned int ov772x_select_fps(struct ov772x_priv *priv,
@@ -743,9 +754,15 @@ static int ov772x_s_frame_interval(struct v4l2_subdev *sd,
 	unsigned int fps;
 	int ret = 0;
 
+	mutex_lock(&priv->lock);
+
+	if (priv->streaming) {
+		ret = -EBUSY;
+		goto error;
+	}
+
 	fps = ov772x_select_fps(priv, tpf);
 
-	mutex_lock(&priv->lock);
 	/*
 	 * If the device is not powered up by the host driver do
 	 * not apply any changes to H/W at this time. Instead
@@ -1222,6 +1239,12 @@ static int ov772x_set_fmt(struct v4l2_subdev *sd,
 	}
 
 	mutex_lock(&priv->lock);
+
+	if (priv->streaming) {
+		ret = -EBUSY;
+		goto error;
+	}
+
 	/*
 	 * If the device is not powered up by the host driver do
 	 * not apply any changes to H/W at this time. Instead
-- 
2.7.4
