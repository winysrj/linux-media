Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:49228 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936498Ab3DRVgB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Apr 2013 17:36:01 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 16/24] V4L2: mt9p031: add support for V4L2 clock and asynchronous probing
Date: Thu, 18 Apr 2013 23:35:37 +0200
Message-Id: <1366320945-21591-17-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de>
References: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds support for V4L2 clock and asynchronous subdevice probing.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/i2c/mt9p031.c |   31 +++++++++++++++++++++++++++++--
 1 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
index e328332..9ba38f5 100644
--- a/drivers/media/i2c/mt9p031.c
+++ b/drivers/media/i2c/mt9p031.c
@@ -23,7 +23,9 @@
 #include <linux/videodev2.h>
 
 #include <media/mt9p031.h>
+#include <media/v4l2-async.h>
 #include <media/v4l2-chip-ident.h>
+#include <media/v4l2-clk.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-subdev.h>
@@ -117,6 +119,7 @@ struct mt9p031 {
 	struct media_pad pad;
 	struct v4l2_rect crop;  /* Sensor window */
 	struct v4l2_mbus_framefmt format;
+	struct v4l2_clk *clk;
 	struct mt9p031_platform_data *pdata;
 	struct mutex power_lock; /* lock to protect power_count */
 	int power_count;
@@ -258,6 +261,10 @@ static inline int mt9p031_pll_disable(struct mt9p031 *mt9p031)
 
 static int mt9p031_power_on(struct mt9p031 *mt9p031)
 {
+	int ret = v4l2_clk_enable(mt9p031->clk);
+	if (ret < 0)
+		return ret;
+
 	/* Ensure RESET_BAR is low */
 	if (mt9p031->reset != -1) {
 		gpio_set_value(mt9p031->reset, 0);
@@ -287,6 +294,8 @@ static void mt9p031_power_off(struct mt9p031 *mt9p031)
 
 	if (mt9p031->pdata->set_xclk)
 		mt9p031->pdata->set_xclk(&mt9p031->subdev, 0);
+
+	v4l2_clk_disable(mt9p031->clk);
 }
 
 static int __mt9p031_set_power(struct mt9p031 *mt9p031, bool on)
@@ -912,6 +921,7 @@ static int mt9p031_probe(struct i2c_client *client,
 {
 	struct mt9p031_platform_data *pdata = client->dev.platform_data;
 	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
+	struct v4l2_clk *clk;
 	struct mt9p031 *mt9p031;
 	unsigned int i;
 	int ret;
@@ -927,11 +937,20 @@ static int mt9p031_probe(struct i2c_client *client,
 		return -EIO;
 	}
 
+	clk = v4l2_clk_get(&client->dev, "mclk");
+	if (IS_ERR(clk)) {
+		dev_info(&client->dev, "Error %ld getting clock\n", PTR_ERR(clk));
+		return -EPROBE_DEFER;
+	}
+
 	mt9p031 = kzalloc(sizeof(*mt9p031), GFP_KERNEL);
-	if (mt9p031 == NULL)
-		return -ENOMEM;
+	if (mt9p031 == NULL) {
+		ret = -ENOMEM;
+		goto done;
+	}
 
 	mt9p031->pdata = pdata;
+	mt9p031->clk = clk;
 	mt9p031->output_control	= MT9P031_OUTPUT_CONTROL_DEF;
 	mt9p031->mode2 = MT9P031_READ_MODE_2_ROW_BLC;
 	mt9p031->model = did->driver_data;
@@ -1010,6 +1029,11 @@ static int mt9p031_probe(struct i2c_client *client,
 	}
 
 	ret = mt9p031_pll_setup(mt9p031);
+	if (ret < 0)
+		goto done;
+
+	mt9p031->subdev.dev = &client->dev;
+	ret = v4l2_async_register_subdev(&mt9p031->subdev);
 
 done:
 	if (ret < 0) {
@@ -1019,6 +1043,7 @@ done:
 		v4l2_ctrl_handler_free(&mt9p031->ctrls);
 		media_entity_cleanup(&mt9p031->subdev.entity);
 		kfree(mt9p031);
+		v4l2_clk_put(clk);
 	}
 
 	return ret;
@@ -1029,11 +1054,13 @@ static int mt9p031_remove(struct i2c_client *client)
 	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
 	struct mt9p031 *mt9p031 = to_mt9p031(subdev);
 
+	v4l2_async_unregister_subdev(subdev);
 	v4l2_ctrl_handler_free(&mt9p031->ctrls);
 	v4l2_device_unregister_subdev(subdev);
 	media_entity_cleanup(&subdev->entity);
 	if (mt9p031->reset != -1)
 		gpio_free(mt9p031->reset);
+	v4l2_clk_put(mt9p031->clk);
 	kfree(mt9p031);
 
 	return 0;
-- 
1.7.2.5

