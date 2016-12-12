Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:58960 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752680AbcLLPz1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Dec 2016 10:55:27 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 11/15] ov2640: enable clock, fix power/reset and add MC support
Date: Mon, 12 Dec 2016 16:55:16 +0100
Message-Id: <20161212155520.41375-12-hverkuil@xs4all.nl>
In-Reply-To: <20161212155520.41375-1-hverkuil@xs4all.nl>
References: <20161212155520.41375-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Convert v4l2_clk to normal clk, enable the clock, fix the power/reset
handling and add MC support.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/ov2640.c | 90 +++++++++++++++++++++++-----------------------
 1 file changed, 45 insertions(+), 45 deletions(-)

diff --git a/drivers/media/i2c/ov2640.c b/drivers/media/i2c/ov2640.c
index 83f88ef..5871712 100644
--- a/drivers/media/i2c/ov2640.c
+++ b/drivers/media/i2c/ov2640.c
@@ -16,15 +16,14 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/i2c.h>
+#include <linux/clk.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/gpio.h>
 #include <linux/gpio/consumer.h>
-#include <linux/of_gpio.h>
 #include <linux/v4l2-mediabus.h>
 #include <linux/videodev2.h>
 
-#include <media/v4l2-clk.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-ctrls.h>
@@ -282,9 +281,12 @@ struct ov2640_win_size {
 
 struct ov2640_priv {
 	struct v4l2_subdev		subdev;
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	struct media_pad pad;
+#endif
 	struct v4l2_ctrl_handler	hdl;
 	u32	cfmt_code;
-	struct v4l2_clk			*clk;
+	struct clk			*clk;
 	const struct ov2640_win_size	*win;
 
 	struct gpio_desc *resetb_gpio;
@@ -656,8 +658,9 @@ static int ov2640_mask_set(struct i2c_client *client,
 	return i2c_smbus_write_byte_data(client, reg, val);
 }
 
-static int ov2640_reset(struct i2c_client *client)
+static int ov2640_reset(struct v4l2_subdev *sd, u32 val)
 {
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	int ret;
 	const struct regval_list reset_seq[] = {
 		{BANK_SEL, BANK_SEL_SENS},
@@ -735,21 +738,6 @@ static int ov2640_s_register(struct v4l2_subdev *sd,
 }
 #endif
 
-static int ov2640_s_power(struct v4l2_subdev *sd, int on)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct ov2640_priv *priv = to_ov2640(client);
-
-	gpiod_direction_output(priv->pwdn_gpio, !on);
-	if (on && priv->resetb_gpio) {
-		/* Active the resetb pin to perform a reset pulse */
-		gpiod_direction_output(priv->resetb_gpio, 1);
-		usleep_range(3000, 5000);
-		gpiod_direction_output(priv->resetb_gpio, 0);
-	}
-	return 0;
-}
-
 /* Select the nearest higher resolution for capture */
 static const struct ov2640_win_size *ov2640_select_win(u32 *width, u32 *height)
 {
@@ -769,9 +757,10 @@ static const struct ov2640_win_size *ov2640_select_win(u32 *width, u32 *height)
 	return &ov2640_supported_win_sizes[default_size];
 }
 
-static int ov2640_set_params(struct i2c_client *client, u32 *width, u32 *height,
+static int ov2640_set_params(struct v4l2_subdev *sd, u32 *width, u32 *height,
 			     u32 code)
 {
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct ov2640_priv       *priv = to_ov2640(client);
 	const struct regval_list *selected_cfmt_regs;
 	int ret;
@@ -802,7 +791,7 @@ static int ov2640_set_params(struct i2c_client *client, u32 *width, u32 *height,
 	}
 
 	/* reset hardware */
-	ov2640_reset(client);
+	ov2640_reset(sd, 0);
 
 	/* initialize the sensor with default data */
 	dev_dbg(&client->dev, "%s: Init default", __func__);
@@ -840,7 +829,7 @@ static int ov2640_set_params(struct i2c_client *client, u32 *width, u32 *height,
 
 err:
 	dev_err(&client->dev, "%s: Error %d", __func__, ret);
-	ov2640_reset(client);
+	ov2640_reset(sd, 0);
 	priv->win = NULL;
 
 	return ret;
@@ -877,7 +866,6 @@ static int ov2640_set_fmt(struct v4l2_subdev *sd,
 		struct v4l2_subdev_format *format)
 {
 	struct v4l2_mbus_framefmt *mf = &format->format;
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
 	if (format->pad)
 		return -EINVAL;
@@ -902,7 +890,7 @@ static int ov2640_set_fmt(struct v4l2_subdev *sd,
 	}
 
 	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
-		return ov2640_set_params(client, &mf->width,
+		return ov2640_set_params(sd, &mf->width,
 					 &mf->height, mf->code);
 	cfg->try_fmt = *mf;
 	return 0;
@@ -947,10 +935,6 @@ static int ov2640_video_probe(struct i2c_client *client)
 	const char *devname;
 	int ret;
 
-	ret = ov2640_s_power(&priv->subdev, 1);
-	if (ret < 0)
-		return ret;
-
 	/*
 	 * check and show product ID and manufacturer ID
 	 */
@@ -978,7 +962,6 @@ static int ov2640_video_probe(struct i2c_client *client)
 	ret = v4l2_ctrl_handler_setup(&priv->hdl);
 
 done:
-	ov2640_s_power(&priv->subdev, 0);
 	return ret;
 }
 
@@ -991,7 +974,7 @@ static struct v4l2_subdev_core_ops ov2640_subdev_core_ops = {
 	.g_register	= ov2640_g_register,
 	.s_register	= ov2640_s_register,
 #endif
-	.s_power	= ov2640_s_power,
+	.reset		= ov2640_reset,
 };
 
 static const struct v4l2_subdev_pad_ops ov2640_subdev_pad_ops = {
@@ -1006,9 +989,17 @@ static struct v4l2_subdev_ops ov2640_subdev_ops = {
 	.pad	= &ov2640_subdev_pad_ops,
 };
 
-static int ov2640_probe_dt(struct i2c_client *client,
-		struct ov2640_priv *priv)
+static int ov2640_init_gpio(struct i2c_client *client,
+			    struct ov2640_priv *priv)
 {
+	/* Request the power down GPIO deasserted */
+	priv->pwdn_gpio = devm_gpiod_get_optional(&client->dev, "pwdn",
+			GPIOD_OUT_LOW);
+	if (!priv->pwdn_gpio)
+		dev_dbg(&client->dev, "pwdn gpio is not assigned!\n");
+	else if (IS_ERR(priv->pwdn_gpio))
+		return PTR_ERR(priv->pwdn_gpio);
+
 	/* Request the reset GPIO deasserted */
 	priv->resetb_gpio = devm_gpiod_get_optional(&client->dev, "resetb",
 			GPIOD_OUT_LOW);
@@ -1017,14 +1008,6 @@ static int ov2640_probe_dt(struct i2c_client *client,
 	else if (IS_ERR(priv->resetb_gpio))
 		return PTR_ERR(priv->resetb_gpio);
 
-	/* Request the power down GPIO asserted */
-	priv->pwdn_gpio = devm_gpiod_get_optional(&client->dev, "pwdn",
-			GPIOD_OUT_HIGH);
-	if (!priv->pwdn_gpio)
-		dev_dbg(&client->dev, "pwdn gpio is not assigned!\n");
-	else if (IS_ERR(priv->pwdn_gpio))
-		return PTR_ERR(priv->pwdn_gpio);
-
 	return 0;
 }
 
@@ -1051,9 +1034,10 @@ static int ov2640_probe(struct i2c_client *client,
 		return -ENOMEM;
 	}
 
-	priv->clk = v4l2_clk_get(&client->dev, "xvclk");
+	priv->clk = clk_get(&client->dev, "xvclk");
 	if (IS_ERR(priv->clk))
 		return -EPROBE_DEFER;
+	clk_prepare_enable(priv->clk);
 
 	if (!client->dev.of_node) {
 		dev_err(&client->dev, "Missing platform_data for driver\n");
@@ -1061,7 +1045,7 @@ static int ov2640_probe(struct i2c_client *client,
 		goto err_clk;
 	}
 
-	ret = ov2640_probe_dt(client, priv);
+	ret = ov2640_init_gpio(client, priv);
 	if (ret)
 		goto err_clk;
 
@@ -1076,6 +1060,13 @@ static int ov2640_probe(struct i2c_client *client,
 		ret = priv->hdl.error;
 		goto err_clk;
 	}
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	priv->pad.flags = MEDIA_PAD_FL_SOURCE;
+	priv->subdev.entity.function = MEDIA_ENT_F_CAM_SENSOR;
+	ret = media_entity_pads_init(&priv->subdev.entity, 1, &priv->pad);
+	if (ret < 0)
+		goto err_hdl;
+#endif
 
 	ret = ov2640_video_probe(client);
 	if (ret < 0)
@@ -1090,9 +1081,14 @@ static int ov2640_probe(struct i2c_client *client,
 	return 0;
 
 err_videoprobe:
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	media_entity_cleanup(&priv->subdev.entity);
+#endif
+err_hdl:
 	v4l2_ctrl_handler_free(&priv->hdl);
 err_clk:
-	v4l2_clk_put(priv->clk);
+	clk_disable_unprepare(priv->clk);
+	clk_put(priv->clk);
 	return ret;
 }
 
@@ -1101,9 +1097,13 @@ static int ov2640_remove(struct i2c_client *client)
 	struct ov2640_priv       *priv = to_ov2640(client);
 
 	v4l2_async_unregister_subdev(&priv->subdev);
-	v4l2_clk_put(priv->clk);
-	v4l2_device_unregister_subdev(&priv->subdev);
+	clk_disable_unprepare(priv->clk);
+	clk_put(priv->clk);
 	v4l2_ctrl_handler_free(&priv->hdl);
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	media_entity_cleanup(&priv->subdev.entity);
+#endif
+	v4l2_device_unregister_subdev(&priv->subdev);
 	return 0;
 }
 
-- 
2.10.2

