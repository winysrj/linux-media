Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33830 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754059AbeD2ROL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 29 Apr 2018 13:14:11 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH v4 13/14] media: ov772x: make set_fmt() return -EBUSY while streaming
Date: Mon, 30 Apr 2018 02:13:12 +0900
Message-Id: <1525021993-17789-14-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1525021993-17789-1-git-send-email-akinobu.mita@gmail.com>
References: <1525021993-17789-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ov772x driver is going to offer a V4L2 sub-device interface, so
changing the output data format on this sub-device can be made anytime.
However, the request is preferred to fail while the video stream on the
device is active.

Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
* v4
- No changes

 drivers/media/i2c/ov772x.c | 35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
index bd37169..f3c4f78 100644
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
@@ -1222,6 +1233,12 @@ static int ov772x_set_fmt(struct v4l2_subdev *sd,
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
