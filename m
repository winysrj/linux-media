Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:19677 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059AbaLHL3n (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Dec 2014 06:29:43 -0500
From: Josh Wu <josh.wu@atmel.com>
To: <linux-media@vger.kernel.org>, <laurent.pinchart@ideasonboard.com>
CC: <m.chehab@samsung.com>, <linux-arm-kernel@lists.infradead.org>,
	<g.liakhovetski@gmx.de>, Josh Wu <josh.wu@atmel.com>
Subject: [PATCH 2/5] media: ov2640: add async probe function
Date: Mon, 8 Dec 2014 19:29:04 +0800
Message-ID: <1418038147-13221-3-git-send-email-josh.wu@atmel.com>
In-Reply-To: <1418038147-13221-1-git-send-email-josh.wu@atmel.com>
References: <1418038147-13221-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To support async probe for ov2640, we need remove the code to get 'mclk'
in ov2640_probe() function. oterwise, if soc_camera host is not probed
in the moment, then we will fail to get 'mclk' and quit the ov2640_probe()
function.

So in this patch, we move such 'mclk' getting code to ov2640_s_power()
function. That make ov2640 survive, as we can pass a NULL (priv-clk) to
soc_camera_set_power() function.

And if soc_camera host is probed, the when ov2640_s_power() is called,
then we can get the 'mclk' and that make us enable/disable soc_camera
host's clock as well.

Signed-off-by: Josh Wu <josh.wu@atmel.com>
---
v1 -> v2:
  no changes.

 drivers/media/i2c/soc_camera/ov2640.c | 31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/media/i2c/soc_camera/ov2640.c b/drivers/media/i2c/soc_camera/ov2640.c
index 1fdce2f..9ee910d 100644
--- a/drivers/media/i2c/soc_camera/ov2640.c
+++ b/drivers/media/i2c/soc_camera/ov2640.c
@@ -739,6 +739,15 @@ static int ov2640_s_power(struct v4l2_subdev *sd, int on)
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 	struct ov2640_priv *priv = to_ov2640(client);
+	struct v4l2_clk *clk;
+
+	if (!priv->clk) {
+		clk = v4l2_clk_get(&client->dev, "mclk");
+		if (IS_ERR(clk))
+			dev_warn(&client->dev, "Cannot get the mclk. maybe soc-camera host is not probed yet.\n");
+		else
+			priv->clk = clk;
+	}
 
 	return soc_camera_set_power(&client->dev, ssdd, priv->clk, on);
 }
@@ -1078,21 +1087,21 @@ static int ov2640_probe(struct i2c_client *client,
 	if (priv->hdl.error)
 		return priv->hdl.error;
 
-	priv->clk = v4l2_clk_get(&client->dev, "mclk");
-	if (IS_ERR(priv->clk)) {
-		ret = PTR_ERR(priv->clk);
-		goto eclkget;
-	}
-
 	ret = ov2640_video_probe(client);
 	if (ret) {
-		v4l2_clk_put(priv->clk);
-eclkget:
-		v4l2_ctrl_handler_free(&priv->hdl);
+		goto evideoprobe;
 	} else {
 		dev_info(&adapter->dev, "OV2640 Probed\n");
 	}
 
+	ret = v4l2_async_register_subdev(&priv->subdev);
+	if (ret < 0)
+		goto evideoprobe;
+
+	return 0;
+
+evideoprobe:
+	v4l2_ctrl_handler_free(&priv->hdl);
 	return ret;
 }
 
@@ -1100,7 +1109,9 @@ static int ov2640_remove(struct i2c_client *client)
 {
 	struct ov2640_priv       *priv = to_ov2640(client);
 
-	v4l2_clk_put(priv->clk);
+	v4l2_async_unregister_subdev(&priv->subdev);
+	if (priv->clk)
+		v4l2_clk_put(priv->clk);
 	v4l2_device_unregister_subdev(&priv->subdev);
 	v4l2_ctrl_handler_free(&priv->hdl);
 	return 0;
-- 
1.9.1

