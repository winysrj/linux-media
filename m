Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:60057 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936444Ab3DRVf6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Apr 2013 17:35:58 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 12/24] V4L2: soc-camera: retrieve subdevice platform data from struct v4l2_subdev
Date: Thu, 18 Apr 2013 23:35:33 +0200
Message-Id: <1366320945-21591-13-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de>
References: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of expecting subdevice drivers to have a standard type as their
platform data, use the new .pdata member of struct v4l2_subdev. This allows
the use of arbitrary subdevice drivers with soc-camera in asynchronous
mode.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/i2c/soc_camera/imx074.c          |    1 +
 drivers/media/platform/soc_camera/soc_camera.c |   10 ++++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/soc_camera/imx074.c b/drivers/media/i2c/soc_camera/imx074.c
index 23de859..321496a 100644
--- a/drivers/media/i2c/soc_camera/imx074.c
+++ b/drivers/media/i2c/soc_camera/imx074.c
@@ -457,6 +457,7 @@ static int imx074_probe(struct i2c_client *client,
 	priv->fmt	= &imx074_colour_fmts[0];
 
 	priv->subdev.dev = &client->dev;
+	priv->subdev.pdata = &ssdd->sd_pdata;
 
 	priv->clk = v4l2_clk_get(&client->dev, "mclk");
 	if (IS_ERR(priv->clk)) {
diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index c06e660..3113287 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -1363,6 +1363,11 @@ static int soc_camera_i2c_init(struct soc_camera_device *icd,
 		return -ENODEV;
 	}
 
+	/*
+	 * Only soc-camera originated subdevice drivers can be used in
+	 * synchronous mode. They all use struct soc_camera_subdev_desc for
+	 * platform data.
+	 */
 	shd->board_info->platform_data = &sdesc->subdev_desc;
 
 	snprintf(clk_name, sizeof(clk_name), "%d-%04x",
@@ -1438,8 +1443,9 @@ static int soc_camera_async_bound(struct v4l2_async_notifier *notifier,
 		 */
 		if (client) {
 			struct soc_camera_desc *sdesc = to_soc_camera_desc(icd);
-			struct soc_camera_subdev_desc *ssdd =
-				soc_camera_i2c_to_desc(client);
+			struct v4l2_subdev_platform_data *sd_pdata = sd->sd_pdata;
+			struct soc_camera_subdev_desc *ssdd = sd_pdata ?
+				sd_pdata->host_priv : NULL;
 			if (ssdd) {
 				memcpy(&sdesc->subdev_desc, ssdd,
 				       sizeof(sdesc->subdev_desc));
-- 
1.7.2.5

