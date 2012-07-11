Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:47317 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab2GKIzS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jul 2012 04:55:18 -0400
Received: by wibhr14 with SMTP id hr14so885135wib.1
        for <linux-media@vger.kernel.org>; Wed, 11 Jul 2012 01:55:17 -0700 (PDT)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	sakari.ailus@maxwell.research.nokia.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, laurent.pinchart@ideasonboard.com,
	mchehab@infradead.org, kernel@pengutronix.de,
	linux@arm.linux.org.uk,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH 2/2] i.MX27: Visstrim_M10: Add support for deinterlacing driver.
Date: Wed, 11 Jul 2012 10:55:04 +0200
Message-Id: <1341996904-22893-3-git-send-email-javier.martin@vista-silicon.com>
In-Reply-To: <1341996904-22893-1-git-send-email-javier.martin@vista-silicon.com>
References: <1341996904-22893-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Visstrim_M10 have a tvp5150 whose video output must be deinterlaced.
The new mem2mem deinterlacing driver is very useful for that purpose.
---
 arch/arm/mach-imx/mach-imx27_visstrim_m10.c |   31 ++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-imx/mach-imx27_visstrim_m10.c b/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
index 214e4ff..1566126 100644
--- a/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
+++ b/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
@@ -192,8 +192,8 @@ static struct soc_camera_link iclink_tvp5150 = {
 	.bus_id         = 0,
 	.board_info     = &visstrim_i2c_camera,
 	.i2c_adapter_id = 0,
-	.power = visstrim_camera_power,
-	.reset = visstrim_camera_reset,
+// 	.power = visstrim_camera_power,
+// 	.reset = visstrim_camera_reset,
 };
 
 static struct mx2_camera_platform_data visstrim_camera = {
@@ -232,7 +232,7 @@ static void __init visstrim_camera_init(void)
 static void __init visstrim_reserve(void)
 {
 	/* reserve 4 MiB for mx2-camera */
-	mx2_camera_base = arm_memblock_steal(2 * MX2_CAMERA_BUF_SIZE,
+	mx2_camera_base = arm_memblock_steal(3 * MX2_CAMERA_BUF_SIZE,
 			MX2_CAMERA_BUF_SIZE);
 }
 
@@ -419,6 +419,30 @@ static void __init visstrim_coda_init(void)
 		return;
 }
 
+/* DMA deinterlace */
+static struct platform_device visstrim_deinterlace = {
+	.name = "m2m-deinterlace",
+	.id = 0,
+};
+
+static void __init visstrim_deinterlace_init(void)
+{
+	int ret = -ENOMEM;
+	struct platform_device *pdev = &visstrim_deinterlace;
+	int dma;
+
+	ret = platform_device_register(pdev);
+
+	dma = dma_declare_coherent_memory(&pdev->dev,
+					  mx2_camera_base + 2 * MX2_CAMERA_BUF_SIZE,
+					  mx2_camera_base + 2 * MX2_CAMERA_BUF_SIZE,
+					  MX2_CAMERA_BUF_SIZE,
+					  DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE);
+	if (!(dma & DMA_MEMORY_MAP))
+		return;
+}
+
+
 static void __init visstrim_m10_revision(void)
 {
 	int exp_version = 0;
@@ -481,6 +505,7 @@ static void __init visstrim_m10_board_init(void)
 	platform_device_register_resndata(NULL, "soc-camera-pdrv", 0, NULL, 0,
 				      &iclink_tvp5150, sizeof(iclink_tvp5150));
 	gpio_led_register_device(0, &visstrim_m10_led_data);
+	visstrim_deinterlace_init();
 	visstrim_camera_init();
 	visstrim_coda_init();
 }
-- 
1.7.9.5

