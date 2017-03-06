Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:56703 "EHLO
        lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754218AbdCFO64 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Mar 2017 09:58:56 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, devicetree@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv3 11/15] ov2640: use standard clk and enable it.
Date: Mon,  6 Mar 2017 15:56:12 +0100
Message-Id: <20170306145616.38485-12-hverkuil@xs4all.nl>
In-Reply-To: <20170306145616.38485-1-hverkuil@xs4all.nl>
References: <20170306145616.38485-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Convert v4l2_clk to normal clk and enable the clock.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/ov2640.c | 32 +++++++++++++-------------------
 1 file changed, 13 insertions(+), 19 deletions(-)

diff --git a/drivers/media/i2c/ov2640.c b/drivers/media/i2c/ov2640.c
index 83f88efbce69..2f799ab4cc2b 100644
--- a/drivers/media/i2c/ov2640.c
+++ b/drivers/media/i2c/ov2640.c
@@ -16,6 +16,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/i2c.h>
+#include <linux/clk.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/gpio.h>
@@ -24,7 +25,6 @@
 #include <linux/v4l2-mediabus.h>
 #include <linux/videodev2.h>
 
-#include <media/v4l2-clk.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-ctrls.h>
@@ -284,7 +284,7 @@ struct ov2640_priv {
 	struct v4l2_subdev		subdev;
 	struct v4l2_ctrl_handler	hdl;
 	u32	cfmt_code;
-	struct v4l2_clk			*clk;
+	struct clk			*clk;
 	const struct ov2640_win_size	*win;
 
 	struct gpio_desc *resetb_gpio;
@@ -1051,19 +1051,16 @@ static int ov2640_probe(struct i2c_client *client,
 		return -ENOMEM;
 	}
 
-	priv->clk = v4l2_clk_get(&client->dev, "xvclk");
-	if (IS_ERR(priv->clk))
-		return -EPROBE_DEFER;
-
-	if (!client->dev.of_node) {
-		dev_err(&client->dev, "Missing platform_data for driver\n");
-		ret = -EINVAL;
-		goto err_clk;
+	if (client->dev.of_node) {
+		priv->clk = devm_clk_get(&client->dev, "xvclk");
+		if (IS_ERR(priv->clk))
+			return -EPROBE_DEFER;
+		clk_prepare_enable(priv->clk);
 	}
 
 	ret = ov2640_probe_dt(client, priv);
 	if (ret)
-		goto err_clk;
+		return ret;
 
 	v4l2_i2c_subdev_init(&priv->subdev, client, &ov2640_subdev_ops);
 	v4l2_ctrl_handler_init(&priv->hdl, 2);
@@ -1074,25 +1071,23 @@ static int ov2640_probe(struct i2c_client *client,
 	priv->subdev.ctrl_handler = &priv->hdl;
 	if (priv->hdl.error) {
 		ret = priv->hdl.error;
-		goto err_clk;
+		goto err_hdl;
 	}
 
 	ret = ov2640_video_probe(client);
 	if (ret < 0)
-		goto err_videoprobe;
+		goto err_hdl;
 
 	ret = v4l2_async_register_subdev(&priv->subdev);
 	if (ret < 0)
-		goto err_videoprobe;
+		goto err_hdl;
 
 	dev_info(&adapter->dev, "OV2640 Probed\n");
 
 	return 0;
 
-err_videoprobe:
+err_hdl:
 	v4l2_ctrl_handler_free(&priv->hdl);
-err_clk:
-	v4l2_clk_put(priv->clk);
 	return ret;
 }
 
@@ -1101,9 +1096,8 @@ static int ov2640_remove(struct i2c_client *client)
 	struct ov2640_priv       *priv = to_ov2640(client);
 
 	v4l2_async_unregister_subdev(&priv->subdev);
-	v4l2_clk_put(priv->clk);
-	v4l2_device_unregister_subdev(&priv->subdev);
 	v4l2_ctrl_handler_free(&priv->hdl);
+	v4l2_device_unregister_subdev(&priv->subdev);
 	return 0;
 }
 
-- 
2.11.0
