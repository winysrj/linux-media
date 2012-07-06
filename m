Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:43848 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757295Ab2GFM6L (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2012 08:58:11 -0400
Received: by wibhr14 with SMTP id hr14so829297wib.1
        for <linux-media@vger.kernel.org>; Fri, 06 Jul 2012 05:58:10 -0700 (PDT)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	sakari.ailus@maxwell.research.nokia.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, laurent.pinchart@ideasonboard.com,
	shawn.guo@linaro.org, fabio.estevam@freescale.com,
	richard.zhu@linaro.org, arnaud.patard@rtp-net.org,
	kernel@pengutronix.de, mchehab@infradead.org,
	p.zabel@pengutronix.de,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH 3/3] Visstrim M10: Add support for Coda.
Date: Fri,  6 Jul 2012 14:57:51 +0200
Message-Id: <1341579471-25208-4-git-send-email-javier.martin@vista-silicon.com>
In-Reply-To: <1341579471-25208-1-git-send-email-javier.martin@vista-silicon.com>
References: <1341579471-25208-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Support the codadx6 that is included in
the i.MX27 SoC.
---
 arch/arm/mach-imx/mach-imx27_visstrim_m10.c |   24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-imx/mach-imx27_visstrim_m10.c b/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
index f76edb9..bee2714 100644
--- a/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
+++ b/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
@@ -232,10 +232,10 @@ static void __init visstrim_camera_init(void)
 static void __init visstrim_reserve(void)
 {
 	/* reserve 4 MiB for mx2-camera */
-	mx2_camera_base = memblock_alloc(MX2_CAMERA_BUF_SIZE,
+	mx2_camera_base = memblock_alloc(2 * MX2_CAMERA_BUF_SIZE,
 			MX2_CAMERA_BUF_SIZE);
-	memblock_free(mx2_camera_base, MX2_CAMERA_BUF_SIZE);
-	memblock_remove(mx2_camera_base, MX2_CAMERA_BUF_SIZE);
+	memblock_free(mx2_camera_base, 2 * MX2_CAMERA_BUF_SIZE);
+	memblock_remove(mx2_camera_base, 2 * MX2_CAMERA_BUF_SIZE);
 }
 
 /* GPIOs used as events for applications */
@@ -404,6 +404,23 @@ static const struct imx_ssi_platform_data visstrim_m10_ssi_pdata __initconst = {
 	.flags			= IMX_SSI_DMA | IMX_SSI_SYN,
 };
 
+/* coda */
+
+static void __init visstrim_coda_init(void)
+{
+	struct platform_device *pdev;
+	int dma;
+
+	pdev = imx27_add_coda();
+	dma = dma_declare_coherent_memory(&pdev->dev,
+					  mx2_camera_base + MX2_CAMERA_BUF_SIZE,
+					  mx2_camera_base + MX2_CAMERA_BUF_SIZE,
+					  MX2_CAMERA_BUF_SIZE,
+					  DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE);
+	if (!(dma & DMA_MEMORY_MAP))
+		return;
+}
+
 static void __init visstrim_m10_revision(void)
 {
 	int exp_version = 0;
@@ -467,6 +484,7 @@ static void __init visstrim_m10_board_init(void)
 				      &iclink_tvp5150, sizeof(iclink_tvp5150));
 	gpio_led_register_device(0, &visstrim_m10_led_data);
 	visstrim_camera_init();
+	visstrim_coda_init();
 }
 
 static void __init visstrim_m10_timer_init(void)
-- 
1.7.9.5

