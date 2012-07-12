Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:60797 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030566Ab2GLLfn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jul 2012 07:35:43 -0400
Received: by weyx8 with SMTP id x8so1629761wey.19
        for <linux-media@vger.kernel.org>; Thu, 12 Jul 2012 04:35:42 -0700 (PDT)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	sakari.ailus@maxwell.research.nokia.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, laurent.pinchart@ideasonboard.com,
	mchehab@infradead.org, kernel@pengutronix.de,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH 2/2 v2] i.MX27: Visstrim_M10: Add support for deinterlacing driver.
Date: Thu, 12 Jul 2012 13:35:29 +0200
Message-Id: <1342092929-31590-2-git-send-email-javier.martin@vista-silicon.com>
In-Reply-To: <1342092929-31590-1-git-send-email-javier.martin@vista-silicon.com>
References: <1342092929-31590-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Visstrim_M10 have a tvp5150 whose video output must be deinterlaced.
The new mem2mem deinterlacing driver is very useful for that purpose.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
Changes since v1:
 - Removed commented out code.

---
 arch/arm/mach-imx/mach-imx27_visstrim_m10.c |   27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-imx/mach-imx27_visstrim_m10.c b/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
index 214e4ff..dbef59d 100644
--- a/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
+++ b/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
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

