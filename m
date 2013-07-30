Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:64921 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410Ab3G3MZk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Jul 2013 08:25:40 -0400
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id 4696C40BB8
	for <linux-media@vger.kernel.org>; Tue, 30 Jul 2013 14:25:38 +0200 (CEST)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1V48zi-0003vO-0Q
	for linux-media@vger.kernel.org; Tue, 30 Jul 2013 14:25:38 +0200
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 5/6] V4L2: mt9m111: switch to asynchronous subdevice probing
Date: Tue, 30 Jul 2013 14:25:37 +0200
Message-Id: <1375187137-15045-7-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1375187137-15045-1-git-send-email-g.liakhovetski@gmx.de>
References: <1375187137-15045-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert the mt9m111 driver to asynchronous subdevice probing. Synchronous
probing is also still possible.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/i2c/soc_camera/mt9m111.c |   38 +++++++++++++++++++++----------
 1 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/drivers/media/i2c/soc_camera/mt9m111.c b/drivers/media/i2c/soc_camera/mt9m111.c
index de3605d..6f40566 100644
--- a/drivers/media/i2c/soc_camera/mt9m111.c
+++ b/drivers/media/i2c/soc_camera/mt9m111.c
@@ -946,6 +946,10 @@ static int mt9m111_probe(struct i2c_client *client,
 	if (!mt9m111)
 		return -ENOMEM;
 
+	mt9m111->clk = v4l2_clk_get(&client->dev, "mclk");
+	if (IS_ERR(mt9m111->clk))
+		return -EPROBE_DEFER;
+
 	/* Default HIGHPOWER context */
 	mt9m111->ctx = &context_b;
 
@@ -963,8 +967,10 @@ static int mt9m111_probe(struct i2c_client *client,
 			&mt9m111_ctrl_ops, V4L2_CID_EXPOSURE_AUTO, 1, 0,
 			V4L2_EXPOSURE_AUTO);
 	mt9m111->subdev.ctrl_handler = &mt9m111->hdl;
-	if (mt9m111->hdl.error)
-		return mt9m111->hdl.error;
+	if (mt9m111->hdl.error) {
+		ret = mt9m111->hdl.error;
+		goto out_clkput;
+	}
 
 	/* Second stage probe - when a capture adapter is there */
 	mt9m111->rect.left	= MT9M111_MIN_DARK_COLS;
@@ -975,18 +981,25 @@ static int mt9m111_probe(struct i2c_client *client,
 	mt9m111->lastpage	= -1;
 	mutex_init(&mt9m111->power_lock);
 
-	mt9m111->clk = v4l2_clk_get(&client->dev, "mclk");
-	if (IS_ERR(mt9m111->clk)) {
-		ret = PTR_ERR(mt9m111->clk);
-		goto eclkget;
-	}
+	ret = soc_camera_power_init(&client->dev, ssdd);
+	if (ret < 0)
+		goto out_hdlfree;
 
 	ret = mt9m111_video_probe(client);
-	if (ret) {
-		v4l2_clk_put(mt9m111->clk);
-eclkget:
-		v4l2_ctrl_handler_free(&mt9m111->hdl);
-	}
+	if (ret < 0)
+		goto out_hdlfree;
+
+	mt9m111->subdev.dev = &client->dev;
+	ret = v4l2_async_register_subdev(&mt9m111->subdev);
+	if (ret < 0)
+		goto out_hdlfree;
+
+	return 0;
+
+out_hdlfree:
+	v4l2_ctrl_handler_free(&mt9m111->hdl);
+out_clkput:
+	v4l2_clk_put(mt9m111->clk);
 
 	return ret;
 }
@@ -995,6 +1008,7 @@ static int mt9m111_remove(struct i2c_client *client)
 {
 	struct mt9m111 *mt9m111 = to_mt9m111(client);
 
+	v4l2_async_unregister_subdev(&mt9m111->subdev);
 	v4l2_clk_put(mt9m111->clk);
 	v4l2_device_unregister_subdev(&mt9m111->subdev);
 	v4l2_ctrl_handler_free(&mt9m111->hdl);
-- 
1.7.2.5

