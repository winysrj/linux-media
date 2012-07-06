Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:59427 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757291Ab2GFM6J (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2012 08:58:09 -0400
Received: by wibhr14 with SMTP id hr14so829275wib.1
        for <linux-media@vger.kernel.org>; Fri, 06 Jul 2012 05:58:08 -0700 (PDT)
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
Subject: [PATCH 1/3] i.MX: coda: Add platform support for coda in i.MX27.
Date: Fri,  6 Jul 2012 14:57:49 +0200
Message-Id: <1341579471-25208-2-git-send-email-javier.martin@vista-silicon.com>
In-Reply-To: <1341579471-25208-1-git-send-email-javier.martin@vista-silicon.com>
References: <1341579471-25208-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

i.MX27 SoC include a codadx6 codec that is able to encode
and decode H.264, H.263 and MPEG4.
---
 arch/arm/mach-imx/clk-imx27.c                   |    4 +--
 arch/arm/mach-imx/devices-imx27.h               |    4 +++
 arch/arm/plat-mxc/devices/Kconfig               |    6 +++-
 arch/arm/plat-mxc/devices/Makefile              |    1 +
 arch/arm/plat-mxc/devices/platform-imx27-coda.c |   37 +++++++++++++++++++++++
 arch/arm/plat-mxc/include/mach/devices-common.h |    8 +++++
 6 files changed, 57 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm/plat-mxc/devices/platform-imx27-coda.c

diff --git a/arch/arm/mach-imx/clk-imx27.c b/arch/arm/mach-imx/clk-imx27.c
index 373c8fd..6e9cb02 100644
--- a/arch/arm/mach-imx/clk-imx27.c
+++ b/arch/arm/mach-imx/clk-imx27.c
@@ -239,8 +239,8 @@ int __init mx27_clocks_init(unsigned long fref)
 	clk_register_clkdev(clk[ssi1_ipg_gate], NULL, "imx-ssi.0");
 	clk_register_clkdev(clk[ssi2_ipg_gate], NULL, "imx-ssi.1");
 	clk_register_clkdev(clk[nfc_baud_gate], NULL, "mxc_nand.0");
-	clk_register_clkdev(clk[vpu_baud_gate], "per", "imx-vpu");
-	clk_register_clkdev(clk[vpu_ahb_gate], "ahb", "imx-vpu");
+	clk_register_clkdev(clk[vpu_baud_gate], "per", "coda-imx27.0");
+	clk_register_clkdev(clk[vpu_ahb_gate], "ahb", "coda-imx27.0");
 	clk_register_clkdev(clk[dma_ahb_gate], "ahb", "imx-dma");
 	clk_register_clkdev(clk[dma_ipg_gate], "ipg", "imx-dma");
 	clk_register_clkdev(clk[fec_ipg_gate], "ipg", "imx27-fec.0");
diff --git a/arch/arm/mach-imx/devices-imx27.h b/arch/arm/mach-imx/devices-imx27.h
index 28537a5..a2aaa7c 100644
--- a/arch/arm/mach-imx/devices-imx27.h
+++ b/arch/arm/mach-imx/devices-imx27.h
@@ -17,6 +17,10 @@ extern const struct imx_fsl_usb2_udc_data imx27_fsl_usb2_udc_data;
 #define imx27_add_fsl_usb2_udc(pdata)	\
 	imx_add_fsl_usb2_udc(&imx27_fsl_usb2_udc_data, pdata)
 
+extern const struct imx_imx27_coda_data imx27_coda_data;
+#define imx27_add_coda()	\
+	imx_add_imx27_coda(&imx27_coda_data)
+
 extern const struct imx_imx2_wdt_data imx27_imx2_wdt_data;
 #define imx27_add_imx2_wdt(pdata)	\
 	imx_add_imx2_wdt(&imx27_imx2_wdt_data)
diff --git a/arch/arm/plat-mxc/devices/Kconfig b/arch/arm/plat-mxc/devices/Kconfig
index cb3e3ee..6b46cee 100644
--- a/arch/arm/plat-mxc/devices/Kconfig
+++ b/arch/arm/plat-mxc/devices/Kconfig
@@ -15,7 +15,11 @@ config IMX_HAVE_PLATFORM_GPIO_KEYS
 
 config IMX_HAVE_PLATFORM_IMX21_HCD
 	bool
-	
+
+config IMX_HAVE_PLATFORM_IMX27_CODA
+	bool
+	default y if SOC_IMX27
+
 config IMX_HAVE_PLATFORM_IMX2_WDT
 	bool
 
diff --git a/arch/arm/plat-mxc/devices/Makefile b/arch/arm/plat-mxc/devices/Makefile
index c11ac84..76f3195 100644
--- a/arch/arm/plat-mxc/devices/Makefile
+++ b/arch/arm/plat-mxc/devices/Makefile
@@ -4,6 +4,7 @@ obj-$(CONFIG_IMX_HAVE_PLATFORM_FSL_USB2_UDC) += platform-fsl-usb2-udc.o
 obj-$(CONFIG_IMX_HAVE_PLATFORM_GPIO_KEYS) += platform-gpio_keys.o
 obj-y += platform-gpio-mxc.o
 obj-$(CONFIG_IMX_HAVE_PLATFORM_IMX21_HCD) += platform-imx21-hcd.o
+obj-$(CONFIG_IMX_HAVE_PLATFORM_IMX27_CODA) += platform-imx27-coda.o
 obj-$(CONFIG_IMX_HAVE_PLATFORM_IMX2_WDT) += platform-imx2-wdt.o
 obj-$(CONFIG_IMX_HAVE_PLATFORM_IMXDI_RTC) += platform-imxdi_rtc.o
 obj-y += platform-imx-dma.o
diff --git a/arch/arm/plat-mxc/devices/platform-imx27-coda.c b/arch/arm/plat-mxc/devices/platform-imx27-coda.c
new file mode 100644
index 0000000..8b12aac
--- /dev/null
+++ b/arch/arm/plat-mxc/devices/platform-imx27-coda.c
@@ -0,0 +1,37 @@
+/*
+ * Copyright (C) 2012 Vista Silicon
+ * Javier Martin <javier.martin@vista-silicon.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License version 2 as published by the
+ * Free Software Foundation.
+ */
+
+#include <mach/hardware.h>
+#include <mach/devices-common.h>
+
+#ifdef CONFIG_SOC_IMX27
+const struct imx_imx27_coda_data imx27_coda_data __initconst = {
+	.iobase = MX27_VPU_BASE_ADDR,
+	.iosize = SZ_512,
+	.irq = MX27_INT_VPU,
+};
+#endif
+
+struct platform_device *__init imx_add_imx27_coda(
+		const struct imx_imx27_coda_data *data)
+{
+	struct resource res[] = {
+		{
+			.start = data->iobase,
+			.end = data->iobase + data->iosize - 1,
+			.flags = IORESOURCE_MEM,
+		}, {
+			.start = data->irq,
+			.end = data->irq,
+			.flags = IORESOURCE_IRQ,
+		},
+	};
+	return imx_add_platform_device_dmamask("coda-imx27", 0, res, 2, NULL,
+					0, DMA_BIT_MASK(32));
+}
diff --git a/arch/arm/plat-mxc/include/mach/devices-common.h b/arch/arm/plat-mxc/include/mach/devices-common.h
index 1b2258d..ee38186 100644
--- a/arch/arm/plat-mxc/include/mach/devices-common.h
+++ b/arch/arm/plat-mxc/include/mach/devices-common.h
@@ -83,6 +83,14 @@ struct platform_device *__init imx_add_imx21_hcd(
 		const struct imx_imx21_hcd_data *data,
 		const struct mx21_usbh_platform_data *pdata);
 
+struct imx_imx27_coda_data {
+	resource_size_t iobase;
+	resource_size_t iosize;
+	resource_size_t irq;
+};
+struct platform_device *__init imx_add_imx27_coda(
+		const struct imx_imx27_coda_data *data);
+
 struct imx_imx2_wdt_data {
 	int id;
 	resource_size_t iobase;
-- 
1.7.9.5

