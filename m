Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:54541 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753531AbdA3OJC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jan 2017 09:09:02 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, devicetree@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 11/16] ov2640: allow use inside em28xx
Date: Mon, 30 Jan 2017 15:06:23 +0100
Message-Id: <20170130140628.18088-12-hverkuil@xs4all.nl>
In-Reply-To: <20170130140628.18088-1-hverkuil@xs4all.nl>
References: <20170130140628.18088-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/Kconfig  |  2 +-
 drivers/media/i2c/ov2640.c | 14 +++++---------
 2 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 159ef64..1859783 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -522,7 +522,7 @@ config VIDEO_SMIAPP_PLL
 
 config VIDEO_OV2640
 	tristate "OmniVision OV2640 sensor support"
-	depends on VIDEO_V4L2 && I2C
+	depends on GPIOLIB && VIDEO_V4L2 && I2C
 	depends on MEDIA_CAMERA_SUPPORT
 	help
 	  This is a Video4Linux2 sensor-level driver for the OmniVision
diff --git a/drivers/media/i2c/ov2640.c b/drivers/media/i2c/ov2640.c
index 565742b..bd96889 100644
--- a/drivers/media/i2c/ov2640.c
+++ b/drivers/media/i2c/ov2640.c
@@ -1031,15 +1031,11 @@ static int ov2640_probe(struct i2c_client *client,
 		return -ENOMEM;
 	}
 
-	priv->clk = clk_get(&client->dev, "xvclk");
-	if (IS_ERR(priv->clk))
-		return -EPROBE_DEFER;
-	clk_prepare_enable(priv->clk);
-
-	if (!client->dev.of_node) {
-		dev_err(&client->dev, "Missing platform_data for driver\n");
-		ret = -EINVAL;
-		goto err_clk;
+	if (client->dev.of_node) {
+		priv->clk = clk_get(&client->dev, "xvclk");
+		if (IS_ERR(priv->clk))
+			return -EPROBE_DEFER;
+		clk_prepare_enable(priv->clk);
 	}
 
 	ret = ov2640_init_gpio(client, priv);
-- 
2.10.2

