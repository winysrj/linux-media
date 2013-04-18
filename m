Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:55396 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936485Ab3DRVf7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Apr 2013 17:35:59 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 24/24] ARM: pcm037: support mt9p031 / mt9p006 camera sensors
Date: Thu, 18 Apr 2013 23:35:45 +0200
Message-Id: <1366320945-21591-25-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de>
References: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We don't know how to support pluggable camera sensors yet. This is just
an example, how support for an mt9p031 or mt9p006 camera sensor could be
added to pcm037.

not-Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 arch/arm/mach-imx/mach-pcm037.c |   44 +++++++++++++++++++++++++++++++++++++-
 1 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-imx/mach-pcm037.c b/arch/arm/mach-imx/mach-pcm037.c
index f138481..18ba328 100644
--- a/arch/arm/mach-imx/mach-pcm037.c
+++ b/arch/arm/mach-imx/mach-pcm037.c
@@ -36,6 +36,7 @@
 #include <linux/regulator/fixed.h>
 
 #include <media/soc_camera.h>
+#include <media/mt9p031.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -363,6 +364,22 @@ static struct i2c_board_info pcm037_i2c_devices[] = {
 	}
 };
 
+static struct mt9p031_platform_data mt9p031_pdata = {
+	.target_freq = 20000000,
+	.ext_freq = 20000000,
+	.sd_pdata	= {
+		.num_regulators = ARRAY_SIZE(cam_supply),
+		.regulators = cam_supply,
+	},
+};
+
+static struct i2c_board_info pcm037_i2c2_devices[] = {
+	{
+		I2C_BOARD_INFO("mt9p031", 0x48),
+		.platform_data = &mt9p031_pdata,
+	},
+};
+
 static struct platform_device pcm037_mt9t031 = {
 	.name	= "soc-camera-pdrv",
 	.id	= 0,
@@ -441,9 +458,30 @@ static const struct imxmmc_platform_data sdhc_pdata __initconst = {
 	.exit = pcm970_sdhc1_exit,
 };
 
+static struct soc_camera_async_subdev mt9p006_sd = {
+	.asd.hw = {
+		.bus_type = V4L2_ASYNC_BUS_I2C,
+		.match.i2c = {
+			.adapter_id = 2,
+			.address = 0x48,
+		},
+	},
+	.role = SOCAM_SUBDEV_DATA_SOURCE,
+};
+
+static struct v4l2_async_subdev *cam_subdevs[] = {
+	/* Single 1-element group */
+	&mt9p006_sd.asd,
+};
+
+/* 0-terminated array of group-sizes */
+static int cam_subdev_sizes[] = {ARRAY_SIZE(cam_subdevs), 0};
+
 struct mx3_camera_pdata camera_pdata __initdata = {
 	.flags		= MX3_CAMERA_DATAWIDTH_8 | MX3_CAMERA_DATAWIDTH_10,
 	.mclk_10khz	= 2000,
+	.asd		= cam_subdevs,
+	.asd_sizes	= cam_subdev_sizes,
 };
 
 static phys_addr_t mx3_camera_base __initdata;
@@ -476,8 +514,8 @@ static struct platform_device *devices[] __initdata = {
 	&pcm037_flash,
 	&pcm037_sram_device,
 	&vcc_cam,
-	&pcm037_mt9t031,
-	&pcm037_mt9v022,
+//	&pcm037_mt9t031,
+//	&pcm037_mt9v022,
 };
 
 static const struct fb_videomode fb_modedb[] = {
@@ -677,6 +715,8 @@ static void __init pcm037_init(void)
 	/* I2C adapters and devices */
 	i2c_register_board_info(1, pcm037_i2c_devices,
 			ARRAY_SIZE(pcm037_i2c_devices));
+	i2c_register_board_info(2, pcm037_i2c2_devices,
+			ARRAY_SIZE(pcm037_i2c2_devices));
 
 	imx31_add_imx_i2c1(&pcm037_i2c1_data);
 	imx31_add_imx_i2c2(&pcm037_i2c2_data);
-- 
1.7.2.5

