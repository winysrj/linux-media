Return-path: <linux-media-owner@vger.kernel.org>
Received: from tango.tkos.co.il ([62.219.50.35]:49973 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758455Ab0EFONX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 6 May 2010 10:13:23 -0400
From: Baruch Siach <baruch@tkos.co.il>
To: linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	Sascha Hauer <kernel@pengutronix.de>,
	Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH 3/3] mx25: add support for the CSI device
Date: Thu,  6 May 2010 16:09:41 +0300
Message-Id: <e2a1cd7e286c8fe799cbbd145b1eb8e7dcea90ee.1273150585.git.baruch@tkos.co.il>
In-Reply-To: <cover.1273150585.git.baruch@tkos.co.il>
References: <cover.1273150585.git.baruch@tkos.co.il>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 arch/arm/mach-mx25/clock.c            |   14 ++++++++++++--
 arch/arm/mach-mx25/devices.c          |   22 ++++++++++++++++++++++
 arch/arm/mach-mx25/devices.h          |    1 +
 arch/arm/plat-mxc/include/mach/mx25.h |    2 ++
 4 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-mx25/clock.c b/arch/arm/mach-mx25/clock.c
index 1550149..7a98d18 100644
--- a/arch/arm/mach-mx25/clock.c
+++ b/arch/arm/mach-mx25/clock.c
@@ -129,6 +129,11 @@ static unsigned long get_rate_lcdc(struct clk *clk)
 	return get_rate_per(7);
 }
 
+static unsigned long get_rate_csi(struct clk *clk)
+{
+	return get_rate_per(0);
+}
+
 static unsigned long get_rate_otg(struct clk *clk)
 {
 	return 48000000; /* FIXME */
@@ -174,6 +179,8 @@ DEFINE_CLOCK(cspi3_clk,  0, CCM_CGCR1,  7, get_rate_ipg, NULL, NULL);
 DEFINE_CLOCK(fec_ahb_clk, 0, CCM_CGCR0, 23, NULL,	 NULL, NULL);
 DEFINE_CLOCK(lcdc_ahb_clk, 0, CCM_CGCR0, 24, NULL,	 NULL, NULL);
 DEFINE_CLOCK(lcdc_per_clk, 0, CCM_CGCR0,  7, NULL,	 NULL, &lcdc_ahb_clk);
+DEFINE_CLOCK(csi_ahb_clk, 0, CCM_CGCR0, 18, get_rate_csi, NULL, NULL);
+DEFINE_CLOCK(csi_per_clk, 0, CCM_CGCR0, 0, get_rate_csi, NULL, &csi_ahb_clk);
 DEFINE_CLOCK(uart1_clk,  0, CCM_CGCR2, 14, get_rate_uart, NULL, &uart_per_clk);
 DEFINE_CLOCK(uart2_clk,  0, CCM_CGCR2, 15, get_rate_uart, NULL, &uart_per_clk);
 DEFINE_CLOCK(uart3_clk,  0, CCM_CGCR2, 16, get_rate_uart, NULL, &uart_per_clk);
@@ -191,6 +198,7 @@ DEFINE_CLOCK(i2c_clk,	 0, CCM_CGCR0,  6, get_rate_i2c, NULL, NULL);
 DEFINE_CLOCK(fec_clk,	 0, CCM_CGCR1, 15, get_rate_ipg, NULL, &fec_ahb_clk);
 DEFINE_CLOCK(dryice_clk, 0, CCM_CGCR1,  8, get_rate_ipg, NULL, NULL);
 DEFINE_CLOCK(lcdc_clk,	 0, CCM_CGCR1, 29, get_rate_lcdc, NULL, &lcdc_per_clk);
+DEFINE_CLOCK(csi_clk,    0, CCM_CGCR1,  4, get_rate_csi, NULL,  &csi_per_clk);
 
 #define _REGISTER_CLOCK(d, n, c)	\
 	{				\
@@ -225,6 +233,7 @@ static struct clk_lookup lookups[] = {
 	_REGISTER_CLOCK("fec.0", NULL, fec_clk)
 	_REGISTER_CLOCK("imxdi_rtc.0", NULL, dryice_clk)
 	_REGISTER_CLOCK("imx-fb.0", NULL, lcdc_clk)
+	_REGISTER_CLOCK("mx2-camera.0", NULL, csi_clk)
 };
 
 int __init mx25_clocks_init(void)
@@ -239,8 +248,9 @@ int __init mx25_clocks_init(void)
 	__raw_writel((0xf << 16) | (3 << 26), CRM_BASE + CCM_CGCR1);
 	__raw_writel((1 << 5), CRM_BASE + CCM_CGCR2);
 
-	/* Clock source for lcdc is upll */
-	__raw_writel(__raw_readl(CRM_BASE+0x64) | (1 << 7), CRM_BASE + 0x64);
+	/* Clock source for lcdc and csi is upll */
+	__raw_writel(__raw_readl(CRM_BASE+0x64) | (1 << 7) | (1 << 0),
+			CRM_BASE + 0x64);
 
 	mxc_timer_init(&gpt_clk, MX25_IO_ADDRESS(MX25_GPT1_BASE_ADDR), 54);
 
diff --git a/arch/arm/mach-mx25/devices.c b/arch/arm/mach-mx25/devices.c
index 3f4b8a0..bc6d189 100644
--- a/arch/arm/mach-mx25/devices.c
+++ b/arch/arm/mach-mx25/devices.c
@@ -500,3 +500,25 @@ struct platform_device mx25_fb_device = {
 		.coherent_dma_mask = 0xFFFFFFFF,
 	},
 };
+
+static struct resource mx25_csi_resources[] = {
+	{
+		.start	= MX25_CSI_BASE_ADDR,
+		.end	= MX25_CSI_BASE_ADDR + 0xfff,
+		.flags	= IORESOURCE_MEM,
+	},
+	{
+		.start	= MX25_INT_CSI,
+		.flags	= IORESOURCE_IRQ
+	},
+};
+
+struct platform_device mx25_csi_device = {
+	.name	= "mx2-camera",
+	.id	= 0,
+	.num_resources	= ARRAY_SIZE(mx25_csi_resources),
+	.resource	= mx25_csi_resources,
+	.dev		= {
+		.coherent_dma_mask = 0xFFFFFFFF,
+	},
+};
diff --git a/arch/arm/mach-mx25/devices.h b/arch/arm/mach-mx25/devices.h
index 39560e1..1e80ac2 100644
--- a/arch/arm/mach-mx25/devices.h
+++ b/arch/arm/mach-mx25/devices.h
@@ -21,3 +21,4 @@ extern struct platform_device mx25_fec_device;
 extern struct platform_device mxc_nand_device;
 extern struct platform_device mx25_rtc_device;
 extern struct platform_device mx25_fb_device;
+extern struct platform_device mx25_csi_device;
diff --git a/arch/arm/plat-mxc/include/mach/mx25.h b/arch/arm/plat-mxc/include/mach/mx25.h
index 4eb6e33..5e6a8b5 100644
--- a/arch/arm/plat-mxc/include/mach/mx25.h
+++ b/arch/arm/plat-mxc/include/mach/mx25.h
@@ -34,11 +34,13 @@
 #define MX25_NFC_BASE_ADDR		0xbb000000
 #define MX25_DRYICE_BASE_ADDR		0x53ffc000
 #define MX25_LCDC_BASE_ADDR		0x53fbc000
+#define MX25_CSI_BASE_ADDR		0x53ff8000
 
 #define MX25_INT_DRYICE	25
 #define MX25_INT_FEC	57
 #define MX25_INT_NANDFC	33
 #define MX25_INT_LCDC	39
+#define MX25_INT_CSI	17
 
 #if defined(IMX_NEEDS_DEPRECATED_SYMBOLS)
 #define UART1_BASE_ADDR			MX25_UART1_BASE_ADDR
-- 
1.7.0

