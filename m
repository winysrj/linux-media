Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:39764 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751193AbeBJP3D (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Feb 2018 10:29:03 -0500
Received: by mail-pg0-f67.google.com with SMTP id w17so5253199pgv.6
        for <linux-media@vger.kernel.org>; Sat, 10 Feb 2018 07:29:03 -0800 (PST)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 2/2] media: ov2640: make s_ctrl() work in power-down mode
Date: Sun, 11 Feb 2018 00:28:38 +0900
Message-Id: <1518276518-14034-3-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1518276518-14034-1-git-send-email-akinobu.mita@gmail.com>
References: <1518276518-14034-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The s_ctrl() operation can be called when the device is placed into
power down mode.  Then, applying controls to H/W should be postponed at
this time.  Instead the controls will be restored when the streaming is
started.

Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/i2c/ov2640.c | 43 ++++++++++++++++++++++++++++++++++++-------
 1 file changed, 36 insertions(+), 7 deletions(-)

diff --git a/drivers/media/i2c/ov2640.c b/drivers/media/i2c/ov2640.c
index 68a356d..beb7220 100644
--- a/drivers/media/i2c/ov2640.c
+++ b/drivers/media/i2c/ov2640.c
@@ -308,8 +308,9 @@ struct ov2640_priv {
 	struct gpio_desc *resetb_gpio;
 	struct gpio_desc *pwdn_gpio;
 
-	struct mutex lock; /* lock to protect streaming */
+	struct mutex lock; /* lock to protect streaming and power_count */
 	bool streaming;
+	int power_count;
 };
 
 /*
@@ -712,9 +713,20 @@ static int ov2640_s_ctrl(struct v4l2_ctrl *ctrl)
 	struct v4l2_subdev *sd =
 		&container_of(ctrl->handler, struct ov2640_priv, hdl)->subdev;
 	struct i2c_client  *client = v4l2_get_subdevdata(sd);
+	struct ov2640_priv *priv = to_ov2640(client);
 	u8 val;
 	int ret;
 
+	/* v4l2_ctrl_lock() locks our own mutex */
+
+	/*
+	 * If the device is not powered up by the host driver, do not apply any
+	 * controls to H/W at this time. Instead the controls will be restored
+	 * when the streaming is started.
+	 */
+	if (!priv->power_count)
+		return 0;
+
 	ret = i2c_smbus_write_byte_data(client, BANK_SEL, BANK_SEL_SENS);
 	if (ret < 0)
 		return ret;
@@ -766,12 +778,9 @@ static int ov2640_s_register(struct v4l2_subdev *sd,
 }
 #endif
 
-static int ov2640_s_power(struct v4l2_subdev *sd, int on)
+static void ov2640_set_power(struct ov2640_priv *priv, int on)
 {
 #ifdef CONFIG_GPIOLIB
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct ov2640_priv *priv = to_ov2640(client);
-
 	if (priv->pwdn_gpio)
 		gpiod_direction_output(priv->pwdn_gpio, !on);
 	if (on && priv->resetb_gpio) {
@@ -781,6 +790,25 @@ static int ov2640_s_power(struct v4l2_subdev *sd, int on)
 		gpiod_set_value(priv->resetb_gpio, 0);
 	}
 #endif
+}
+
+static int ov2640_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct ov2640_priv *priv = to_ov2640(client);
+
+	mutex_lock(&priv->lock);
+
+	/*
+	 * If the power count is modified from 0 to != 0 or from != 0 to 0,
+	 * update the power state.
+	 */
+	if (priv->power_count == !on)
+		ov2640_set_power(priv, on);
+	priv->power_count += on ? 1 : -1;
+	WARN_ON(priv->power_count < 0);
+	mutex_unlock(&priv->lock);
+
 	return 0;
 }
 
@@ -1005,6 +1033,8 @@ static int ov2640_s_stream(struct v4l2_subdev *sd, int on)
 		if (on) {
 			ret = ov2640_set_params(client, priv->win,
 						priv->cfmt_code);
+			if (!ret)
+				ret = __v4l2_ctrl_handler_setup(&priv->hdl);
 		}
 	}
 	if (!ret)
@@ -1049,8 +1079,6 @@ static int ov2640_video_probe(struct i2c_client *client)
 		 "%s Product ID %0x:%0x Manufacturer ID %x:%x\n",
 		 devname, pid, ver, midh, midl);
 
-	ret = v4l2_ctrl_handler_setup(&priv->hdl);
-
 done:
 	ov2640_s_power(&priv->subdev, 0);
 	return ret;
@@ -1158,6 +1186,7 @@ static int ov2640_probe(struct i2c_client *client,
 	priv->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 	mutex_init(&priv->lock);
 	v4l2_ctrl_handler_init(&priv->hdl, 2);
+	priv->hdl.lock = &priv->lock;
 	v4l2_ctrl_new_std(&priv->hdl, &ov2640_ctrl_ops,
 			V4L2_CID_VFLIP, 0, 1, 1, 0);
 	v4l2_ctrl_new_std(&priv->hdl, &ov2640_ctrl_ops,
-- 
2.7.4
