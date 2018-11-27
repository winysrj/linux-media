Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:44847 "EHLO
        srv-hp10-72.netsons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729474AbeK0TcH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Nov 2018 14:32:07 -0500
From: Luca Ceresoli <luca@lucaceresoli.net>
To: linux-media@vger.kernel.org
Cc: Luca Ceresoli <luca@lucaceresoli.net>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Leon Luo <leonl@leopardimaging.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] media: imx274: select REGMAP_I2C
Date: Tue, 27 Nov 2018 09:34:45 +0100
Message-Id: <20181127083445.27737-3-luca@lucaceresoli.net>
In-Reply-To: <20181127083445.27737-1-luca@lucaceresoli.net>
References: <20181127083445.27737-1-luca@lucaceresoli.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The imx274 driver uses regmap and the build will fail without it.

Fixes:

  drivers/media/i2c/imx274.c:142:21: error: variable ‘imx274_regmap_config’ has initializer but incomplete type
   static const struct regmap_config imx274_regmap_config = {
                       ^~~~~~~~~~~~~
  drivers/media/i2c/imx274.c:1869:19: error: implicit declaration of function ‘devm_regmap_init_i2c’ [-Werror=implicit-function-declaration]
    imx274->regmap = devm_regmap_init_i2c(client, &imx274_regmap_config);
                     ^~~~~~~~~~~~~~~~~~~~

and others.

Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
---
 drivers/media/i2c/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 66bbbec487ec..005fc2bd0d05 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -622,6 +622,7 @@ config VIDEO_IMX274
 	tristate "Sony IMX274 sensor support"
 	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	depends on MEDIA_CAMERA_SUPPORT
+	select REGMAP_I2C
 	---help---
 	  This is a V4L2 sensor driver for the Sony IMX274
 	  CMOS image sensor.
-- 
2.17.1
