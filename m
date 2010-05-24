Return-path: <linux-media-owner@vger.kernel.org>
Received: from tango.tkos.co.il ([62.219.50.35]:55485 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752834Ab0EXNWD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 May 2010 09:22:03 -0400
From: Baruch Siach <baruch@tkos.co.il>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sascha Hauer <kernel@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH v2 2/3] mx27: add support for the CSI device
Date: Mon, 24 May 2010 16:20:40 +0300
Message-Id: <009e44968586b0d010a8a56227e4cae12f9f6703.1274706733.git.baruch@tkos.co.il>
In-Reply-To: <cover.1274706733.git.baruch@tkos.co.il>
References: <cover.1274706733.git.baruch@tkos.co.il>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 arch/arm/mach-mx2/clock_imx27.c |    2 +-
 arch/arm/mach-mx2/devices.c     |   31 +++++++++++++++++++++++++++++++
 arch/arm/mach-mx2/devices.h     |    1 +
 3 files changed, 33 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-mx2/clock_imx27.c b/arch/arm/mach-mx2/clock_imx27.c
index 0f0823c..5a1aa15 100644
--- a/arch/arm/mach-mx2/clock_imx27.c
+++ b/arch/arm/mach-mx2/clock_imx27.c
@@ -644,7 +644,7 @@ static struct clk_lookup lookups[] = {
 	_REGISTER_CLOCK("spi_imx.1", NULL, cspi2_clk)
 	_REGISTER_CLOCK("spi_imx.2", NULL, cspi3_clk)
 	_REGISTER_CLOCK("imx-fb.0", NULL, lcdc_clk)
-	_REGISTER_CLOCK(NULL, "csi", csi_clk)
+	_REGISTER_CLOCK("mx2-camera.0", NULL, csi_clk)
 	_REGISTER_CLOCK("fsl-usb2-udc", "usb", usb_clk)
 	_REGISTER_CLOCK("fsl-usb2-udc", "usb_ahb", usb_clk1)
 	_REGISTER_CLOCK("mxc-ehci.0", "usb", usb_clk)
diff --git a/arch/arm/mach-mx2/devices.c b/arch/arm/mach-mx2/devices.c
index b91e412..6a49c79 100644
--- a/arch/arm/mach-mx2/devices.c
+++ b/arch/arm/mach-mx2/devices.c
@@ -40,6 +40,37 @@
 
 #include "devices.h"
 
+#ifdef CONFIG_MACH_MX27
+static struct resource mx27_camera_resources[] = {
+	{
+	       .start = MX27_CSI_BASE_ADDR,
+	       .end = MX27_CSI_BASE_ADDR + 0x1f,
+	       .flags = IORESOURCE_MEM,
+	}, {
+	       .start = MX27_EMMA_PRP_BASE_ADDR,
+	       .end = MX27_EMMA_PRP_BASE_ADDR + 0x1f,
+	       .flags = IORESOURCE_MEM,
+	}, {
+	       .start = MX27_INT_CSI,
+	       .end = MX27_INT_CSI,
+	       .flags = IORESOURCE_IRQ,
+	},{
+	       .start = MX27_INT_EMMAPRP,
+	       .end = MX27_INT_EMMAPRP,
+	       .flags = IORESOURCE_IRQ,
+	},
+};
+struct platform_device mx27_camera_device = {
+	.name = "mx2-camera",
+	.id = 0,
+	.num_resources = ARRAY_SIZE(mx27_camera_resources),
+	.resource = mx27_camera_resources,
+	.dev = {
+		.coherent_dma_mask = 0xffffffff,
+	},
+};
+#endif
+
 /*
  * SPI master controller
  *
diff --git a/arch/arm/mach-mx2/devices.h b/arch/arm/mach-mx2/devices.h
index 84ed513..8bdf018 100644
--- a/arch/arm/mach-mx2/devices.h
+++ b/arch/arm/mach-mx2/devices.h
@@ -29,6 +29,7 @@ extern struct platform_device mxc_i2c_device1;
 extern struct platform_device mxc_sdhc_device0;
 extern struct platform_device mxc_sdhc_device1;
 extern struct platform_device mxc_otg_udc_device;
+extern struct platform_device mx27_camera_device;
 extern struct platform_device mxc_otg_host;
 extern struct platform_device mxc_usbh1;
 extern struct platform_device mxc_usbh2;
-- 
1.7.1

