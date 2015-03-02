Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:21301 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbbCBBvB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Mar 2015 20:51:01 -0500
From: Josh Wu <josh.wu@atmel.com>
To: <g.liakhovetski@gmx.de>
CC: <laurent.pinchart@ideasonboard.com>, <linux-media@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<devicetree@vger.kernel.org>, Josh Wu <josh.wu@atmel.com>
Subject: [PATCH v5 2/4][resend] media: ov2640: add async probe function
Date: Mon, 2 Mar 2015 09:52:38 +0800
Message-ID: <1425261158-14603-1-git-send-email-josh.wu@atmel.com>
In-Reply-To: <Pine.LNX.4.64.1503012202460.2412@axis700.grange>
References: <Pine.LNX.4.64.1503012202460.2412@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In async probe, there is a case that ov2640 is probed before the
host device which provided 'mclk'.
To support this async probe, we will get 'mclk' at first in the probe(),
if failed it will return -EPROBE_DEFER. That will let ov2640 wait for
the host device probed.

Signed-off-by: Josh Wu <josh.wu@atmel.com>
---

Changes in v5 resend:
- refine the error handling flow according to Guennadi's comment.

Changes in v5:
- don't change the ov2640_s_power() code.
- will get 'mclk' at the beginning of ov2640_probe().

 drivers/media/i2c/soc_camera/ov2640.c | 36 +++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/media/i2c/soc_camera/ov2640.c b/drivers/media/i2c/soc_camera/ov2640.c
index 1fdce2f..16adbcc 100644
--- a/drivers/media/i2c/soc_camera/ov2640.c
+++ b/drivers/media/i2c/soc_camera/ov2640.c
@@ -1068,6 +1068,10 @@ static int ov2640_probe(struct i2c_client *client,
 		return -ENOMEM;
 	}
 
+	priv->clk = v4l2_clk_get(&client->dev, "mclk");
+	if (IS_ERR(priv->clk))
+		return -EPROBE_DEFER;
+
 	v4l2_i2c_subdev_init(&priv->subdev, client, &ov2640_subdev_ops);
 	v4l2_ctrl_handler_init(&priv->hdl, 2);
 	v4l2_ctrl_new_std(&priv->hdl, &ov2640_ctrl_ops,
@@ -1075,24 +1079,27 @@ static int ov2640_probe(struct i2c_client *client,
 	v4l2_ctrl_new_std(&priv->hdl, &ov2640_ctrl_ops,
 			V4L2_CID_HFLIP, 0, 1, 1, 0);
 	priv->subdev.ctrl_handler = &priv->hdl;
-	if (priv->hdl.error)
-		return priv->hdl.error;
-
-	priv->clk = v4l2_clk_get(&client->dev, "mclk");
-	if (IS_ERR(priv->clk)) {
-		ret = PTR_ERR(priv->clk);
-		goto eclkget;
+	if (priv->hdl.error) {
+		ret = priv->hdl.error;
+		goto err_clk;
 	}
 
 	ret = ov2640_video_probe(client);
-	if (ret) {
-		v4l2_clk_put(priv->clk);
-eclkget:
-		v4l2_ctrl_handler_free(&priv->hdl);
-	} else {
-		dev_info(&adapter->dev, "OV2640 Probed\n");
-	}
+	if (ret < 0)
+		goto err_videoprobe;
 
+	ret = v4l2_async_register_subdev(&priv->subdev);
+	if (ret < 0)
+		goto err_videoprobe;
+
+	dev_info(&adapter->dev, "OV2640 Probed\n");
+
+	return 0;
+
+err_videoprobe:
+	v4l2_ctrl_handler_free(&priv->hdl);
+err_clk:
+	v4l2_clk_put(priv->clk);
 	return ret;
 }
 
@@ -1100,6 +1107,7 @@ static int ov2640_remove(struct i2c_client *client)
 {
 	struct ov2640_priv       *priv = to_ov2640(client);
 
+	v4l2_async_unregister_subdev(&priv->subdev);
 	v4l2_clk_put(priv->clk);
 	v4l2_device_unregister_subdev(&priv->subdev);
 	v4l2_ctrl_handler_free(&priv->hdl);
-- 
1.9.1

