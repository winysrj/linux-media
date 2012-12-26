Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:51095 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab2LZRtS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Dec 2012 12:49:18 -0500
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 5/6] imx074: support asynchronous probing
Date: Wed, 26 Dec 2012 18:49:10 +0100
Message-Id: <1356544151-6313-6-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1356544151-6313-1-git-send-email-g.liakhovetski@gmx.de>
References: <1356544151-6313-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Both synchronous and asynchronous imx074 subdevice probing is supported by
this patch.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/i2c/soc_camera/imx074.c |   23 ++++++++++++++++++++---
 1 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/soc_camera/imx074.c b/drivers/media/i2c/soc_camera/imx074.c
index cee5345..a097dd1 100644
--- a/drivers/media/i2c/soc_camera/imx074.c
+++ b/drivers/media/i2c/soc_camera/imx074.c
@@ -18,6 +18,7 @@
 #include <linux/module.h>
 
 #include <media/soc_camera.h>
+#include <media/v4l2-async.h>
 #include <media/v4l2-clk.h>
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-chip-ident.h>
@@ -79,6 +80,7 @@ struct imx074 {
 	struct v4l2_subdev		subdev;
 	const struct imx074_datafmt	*fmt;
 	struct v4l2_clk			*clk;
+	struct v4l2_async_subdev_list	asdl;
 };
 
 static const struct imx074_datafmt imx074_colour_fmts[] = {
@@ -455,14 +457,27 @@ static int imx074_probe(struct i2c_client *client,
 
 	priv->fmt	= &imx074_colour_fmts[0];
 
+	priv->asdl.subdev = &priv->subdev;
+	priv->asdl.dev = &client->dev;
+
+	ret = v4l2_async_subdev_bind(&priv->asdl);
+	if (ret < 0)
+		return ret;
+
 	priv->clk = v4l2_clk_get(&priv->subdev, "mclk");
-	if (IS_ERR(priv->clk))
-		return PTR_ERR(priv->clk);
+	if (IS_ERR(priv->clk)) {
+		dev_info(&client->dev, "Error %ld getting clock\n", PTR_ERR(priv->clk));
+		return -EPROBE_DEFER;
+	}
 
 	ret = imx074_video_probe(client);
 	if (ret < 0)
-		v4l2_clk_put(priv->clk);
+		goto eprobe;
+
+	return v4l2_async_subdev_bound(&priv->asdl);
 
+eprobe:
+	v4l2_clk_put(priv->clk);
 	return ret;
 }
 
@@ -471,7 +486,9 @@ static int imx074_remove(struct i2c_client *client)
 	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 	struct imx074 *priv = to_imx074(client);
 
+	v4l2_async_subdev_unbind(&priv->asdl);
 	v4l2_clk_put(priv->clk);
+
 	if (ssdd->free_bus)
 		ssdd->free_bus(ssdd);
 
-- 
1.7.2.5

