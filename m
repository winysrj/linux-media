Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:19800 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059AbaLHLbA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Dec 2014 06:31:00 -0500
From: Josh Wu <josh.wu@atmel.com>
To: <linux-media@vger.kernel.org>, <laurent.pinchart@ideasonboard.com>
CC: <m.chehab@samsung.com>, <linux-arm-kernel@lists.infradead.org>,
	<g.liakhovetski@gmx.de>, Josh Wu <josh.wu@atmel.com>,
	<devicetree@vger.kernel.org>
Subject: [PATCH 4/5] media: ov2640: add a master clock for sensor
Date: Mon, 8 Dec 2014 19:29:06 +0800
Message-ID: <1418038147-13221-5-git-send-email-josh.wu@atmel.com>
In-Reply-To: <1418038147-13221-1-git-send-email-josh.wu@atmel.com>
References: <1418038147-13221-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The master clock (xvclk) is mandatory. It's a common clock framework clock.
It can make sensor output a pixel clock to the camera interface.

Cc: devicetree@vger.kernel.org
Signed-off-by: Josh Wu <josh.wu@atmel.com>
---
v1 -> v2:
  1. change the clock's name.
  2. Make the clock is mandatory.

 drivers/media/i2c/soc_camera/ov2640.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/soc_camera/ov2640.c b/drivers/media/i2c/soc_camera/ov2640.c
index 2a57979..7cb61e2 100644
--- a/drivers/media/i2c/soc_camera/ov2640.c
+++ b/drivers/media/i2c/soc_camera/ov2640.c
@@ -13,6 +13,7 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/clk.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/i2c.h>
@@ -31,6 +32,7 @@
 
 #define VAL_SET(x, mask, rshift, lshift)  \
 		((((x) >> rshift) & mask) << lshift)
+
 /*
  * DSP registers
  * register offset for BANK_SEL == BANK_SEL_DSP
@@ -284,6 +286,7 @@ struct ov2640_priv {
 	struct v4l2_ctrl_handler	hdl;
 	u32	cfmt_code;
 	struct v4l2_clk			*clk;
+	struct clk			*master_clk;
 	const struct ov2640_win_size	*win;
 
 	struct soc_camera_subdev_desc	ssdd_dt;
@@ -746,6 +749,7 @@ static int ov2640_s_power(struct v4l2_subdev *sd, int on)
 	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 	struct ov2640_priv *priv = to_ov2640(client);
 	struct v4l2_clk *clk;
+	int ret;
 
 	if (!priv->clk) {
 		clk = v4l2_clk_get(&client->dev, "mclk");
@@ -755,7 +759,20 @@ static int ov2640_s_power(struct v4l2_subdev *sd, int on)
 			priv->clk = clk;
 	}
 
-	return soc_camera_set_power(&client->dev, ssdd, priv->clk, on);
+	if (on) {
+		ret = clk_prepare_enable(priv->master_clk);
+		if (ret)
+			return ret;
+	} else {
+		clk_disable_unprepare(priv->master_clk);
+	}
+
+	ret = soc_camera_set_power(&client->dev, ssdd, priv->clk, on);
+
+	if (ret && on)
+		clk_disable_unprepare(priv->master_clk);
+
+	return ret;
 }
 
 /* Select the nearest higher resolution for capture */
@@ -1144,6 +1161,10 @@ static int ov2640_probe(struct i2c_client *client,
 		}
 	}
 
+	priv->master_clk = devm_clk_get(&client->dev, "xvclk");
+	if (IS_ERR(priv->master_clk))
+		return -EINVAL;
+
 	v4l2_i2c_subdev_init(&priv->subdev, client, &ov2640_subdev_ops);
 	v4l2_ctrl_handler_init(&priv->hdl, 2);
 	v4l2_ctrl_new_std(&priv->hdl, &ov2640_ctrl_ops,
-- 
1.9.1

