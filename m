Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:45196 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751193AbeBJP3C (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Feb 2018 10:29:02 -0500
Received: by mail-pl0-f65.google.com with SMTP id p5so2832761plo.12
        for <linux-media@vger.kernel.org>; Sat, 10 Feb 2018 07:29:01 -0800 (PST)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 1/2] media: ov2640: make set_fmt() work in power-down mode
Date: Sun, 11 Feb 2018 00:28:37 +0900
Message-Id: <1518276518-14034-2-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1518276518-14034-1-git-send-email-akinobu.mita@gmail.com>
References: <1518276518-14034-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The set_fmt() subdev pad operation for this driver currently does not
only do the driver internal format selection but also do the actual
register setup.

This doesn't work if the device power control via GPIO lines is enabled.
Because the set_fmt() can be called when the device is placed into power
down mode.

First of all, this fix adds flag to keep track of whether the device starts
streaming or not.  Then, the set_fmt() postpones applying the actual
register setup at this time.  Instead the setup will be applied when the
streaming is started.

Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/i2c/ov2640.c | 71 +++++++++++++++++++++++++++++++++++++---------
 1 file changed, 57 insertions(+), 14 deletions(-)

diff --git a/drivers/media/i2c/ov2640.c b/drivers/media/i2c/ov2640.c
index 4c3b927..68a356d 100644
--- a/drivers/media/i2c/ov2640.c
+++ b/drivers/media/i2c/ov2640.c
@@ -307,6 +307,9 @@ struct ov2640_priv {
 
 	struct gpio_desc *resetb_gpio;
 	struct gpio_desc *pwdn_gpio;
+
+	struct mutex lock; /* lock to protect streaming */
+	bool streaming;
 };
 
 /*
@@ -798,16 +801,13 @@ static const struct ov2640_win_size *ov2640_select_win(u32 width, u32 height)
 static int ov2640_set_params(struct i2c_client *client,
 			     const struct ov2640_win_size *win, u32 code)
 {
-	struct ov2640_priv       *priv = to_ov2640(client);
 	const struct regval_list *selected_cfmt_regs;
 	u8 val;
 	int ret;
 
-	/* select win */
-	priv->win = win;
+	if (!win)
+		return -EINVAL;
 
-	/* select format */
-	priv->cfmt_code = 0;
 	switch (code) {
 	case MEDIA_BUS_FMT_RGB565_2X8_BE:
 		dev_dbg(&client->dev, "%s: Selected cfmt RGB565 BE", __func__);
@@ -846,13 +846,13 @@ static int ov2640_set_params(struct i2c_client *client,
 		goto err;
 
 	/* select preamble */
-	dev_dbg(&client->dev, "%s: Set size to %s", __func__, priv->win->name);
+	dev_dbg(&client->dev, "%s: Set size to %s", __func__, win->name);
 	ret = ov2640_write_array(client, ov2640_size_change_preamble_regs);
 	if (ret < 0)
 		goto err;
 
 	/* set size win */
-	ret = ov2640_write_array(client, priv->win->regs);
+	ret = ov2640_write_array(client, win->regs);
 	if (ret < 0)
 		goto err;
 
@@ -872,14 +872,11 @@ static int ov2640_set_params(struct i2c_client *client,
 	if (ret < 0)
 		goto err;
 
-	priv->cfmt_code = code;
-
 	return 0;
 
 err:
 	dev_err(&client->dev, "%s: Error %d", __func__, ret);
 	ov2640_reset(client);
-	priv->win = NULL;
 
 	return ret;
 }
@@ -915,11 +912,15 @@ static int ov2640_set_fmt(struct v4l2_subdev *sd,
 {
 	struct v4l2_mbus_framefmt *mf = &format->format;
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct ov2640_priv *priv = to_ov2640(client);
 	const struct ov2640_win_size *win;
+	int ret = 0;
 
 	if (format->pad)
 		return -EINVAL;
 
+	mutex_lock(&priv->lock);
+
 	/* select suitable win */
 	win = ov2640_select_win(mf->width, mf->height);
 	mf->width	= win->width;
@@ -941,10 +942,24 @@ static int ov2640_set_fmt(struct v4l2_subdev *sd,
 		break;
 	}
 
-	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
-		return ov2640_set_params(client, win, mf->code);
-	cfg->try_fmt = *mf;
-	return 0;
+	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
+		struct ov2640_priv *priv = to_ov2640(client);
+
+		if (priv->streaming) {
+			ret = -EBUSY;
+			goto out;
+		}
+		/* select win */
+		priv->win = win;
+		/* select format */
+		priv->cfmt_code = mf->code;
+	} else {
+		cfg->try_fmt = *mf;
+	}
+out:
+	mutex_unlock(&priv->lock);
+
+	return ret;
 }
 
 static int ov2640_enum_mbus_code(struct v4l2_subdev *sd,
@@ -979,6 +994,26 @@ static int ov2640_get_selection(struct v4l2_subdev *sd,
 	}
 }
 
+static int ov2640_s_stream(struct v4l2_subdev *sd, int on)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct ov2640_priv *priv = to_ov2640(client);
+	int ret = 0;
+
+	mutex_lock(&priv->lock);
+	if (priv->streaming == !on) {
+		if (on) {
+			ret = ov2640_set_params(client, priv->win,
+						priv->cfmt_code);
+		}
+	}
+	if (!ret)
+		priv->streaming = on;
+	mutex_unlock(&priv->lock);
+
+	return ret;
+}
+
 static int ov2640_video_probe(struct i2c_client *client)
 {
 	struct ov2640_priv *priv = to_ov2640(client);
@@ -1040,9 +1075,14 @@ static const struct v4l2_subdev_pad_ops ov2640_subdev_pad_ops = {
 	.set_fmt	= ov2640_set_fmt,
 };
 
+static const struct v4l2_subdev_video_ops ov2640_subdev_video_ops = {
+	.s_stream = ov2640_s_stream,
+};
+
 static const struct v4l2_subdev_ops ov2640_subdev_ops = {
 	.core	= &ov2640_subdev_core_ops,
 	.pad	= &ov2640_subdev_pad_ops,
+	.video	= &ov2640_subdev_video_ops,
 };
 
 static int ov2640_probe_dt(struct i2c_client *client,
@@ -1116,6 +1156,7 @@ static int ov2640_probe(struct i2c_client *client,
 
 	v4l2_i2c_subdev_init(&priv->subdev, client, &ov2640_subdev_ops);
 	priv->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	mutex_init(&priv->lock);
 	v4l2_ctrl_handler_init(&priv->hdl, 2);
 	v4l2_ctrl_new_std(&priv->hdl, &ov2640_ctrl_ops,
 			V4L2_CID_VFLIP, 0, 1, 1, 0);
@@ -1150,6 +1191,7 @@ static int ov2640_probe(struct i2c_client *client,
 	media_entity_cleanup(&priv->subdev.entity);
 err_hdl:
 	v4l2_ctrl_handler_free(&priv->hdl);
+	mutex_destroy(&priv->lock);
 err_clk:
 	clk_disable_unprepare(priv->clk);
 	return ret;
@@ -1161,6 +1203,7 @@ static int ov2640_remove(struct i2c_client *client)
 
 	v4l2_async_unregister_subdev(&priv->subdev);
 	v4l2_ctrl_handler_free(&priv->hdl);
+	mutex_destroy(&priv->lock);
 	media_entity_cleanup(&priv->subdev.entity);
 	v4l2_device_unregister_subdev(&priv->subdev);
 	clk_disable_unprepare(priv->clk);
-- 
2.7.4
