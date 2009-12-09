Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:51785 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757484AbZLIXJt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Dec 2009 18:09:49 -0500
From: m-karicheri2@ti.com
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	khilman@deeprootsystems.com
Cc: davinci-linux-open-source@linux.davincidsp.com,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH - v2 4/4] DaVinci - vpfe capture converting ccdc drivers to platform driver
Date: Wed,  9 Dec 2009 18:09:52 -0500
Message-Id: <1260400192-32527-4-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1260400192-32527-3-git-send-email-m-karicheri2@ti.com>
References: <1260400192-32527-1-git-send-email-m-karicheri2@ti.com>
 <1260400192-32527-2-git-send-email-m-karicheri2@ti.com>
 <1260400192-32527-3-git-send-email-m-karicheri2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Muralidharan Karicheri <m-karicheri2@ti.com>

This combines the two patches sent earlier to change the clock configuration
and converting ccdc drivers to platform drivers. This has updated comments
against v1 of these patches. Two new clocks are defined for ccdc driver
as per comments from Kevin Hilman.

This adds platform code for ccdc driver on DM355 and DM6446.

Reviewed-by: Vaibhav Hiremath <hvaibhav@ti.com>
Reviewed-by: Kevin Hilman <khilman@deeprootsystems.com>

Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
---
Applies to linux-davinci tree
 arch/arm/mach-davinci/dm355.c  |   51 ++++++++++++++++++++++++++++++---------
 arch/arm/mach-davinci/dm644x.c |   30 ++++++++++++++++++++++-
 2 files changed, 68 insertions(+), 13 deletions(-)

diff --git a/arch/arm/mach-davinci/dm355.c b/arch/arm/mach-davinci/dm355.c
index 2244e8c..3cfa709 100644
--- a/arch/arm/mach-davinci/dm355.c
+++ b/arch/arm/mach-davinci/dm355.c
@@ -335,6 +335,16 @@ static struct clk usb_clk = {
 	.lpsc = DAVINCI_LPSC_USB,
 };
 
+static struct clk ccdc_master_clk = {
+	.name		= "dm355_ccdc",
+	.parent		= &vpss_master_clk,
+};
+
+static struct clk ccdc_slave_clk = {
+	.name		= "dm355_ccdc",
+	.parent		= &vpss_slave_clk,
+};
+
 static struct davinci_clk dm355_clks[] = {
 	CLK(NULL, "ref", &ref_clk),
 	CLK(NULL, "pll1", &pll1_clk),
@@ -378,6 +388,8 @@ static struct davinci_clk dm355_clks[] = {
 	CLK(NULL, "timer3", &timer3_clk),
 	CLK(NULL, "rto", &rto_clk),
 	CLK(NULL, "usb", &usb_clk),
+	CLK("dm355_ccdc", "master", &ccdc_master_clk),
+	CLK("dm355_ccdc", "slave", &ccdc_slave_clk),
 	CLK(NULL, NULL, NULL),
 };
 
@@ -665,6 +677,17 @@ static struct platform_device dm355_asp1_device = {
 	.resource	= dm355_asp1_resources,
 };
 
+static void dm355_ccdc_setup_pinmux(void)
+{
+	davinci_cfg_reg(DM355_VIN_PCLK);
+	davinci_cfg_reg(DM355_VIN_CAM_WEN);
+	davinci_cfg_reg(DM355_VIN_CAM_VD);
+	davinci_cfg_reg(DM355_VIN_CAM_HD);
+	davinci_cfg_reg(DM355_VIN_YIN_EN);
+	davinci_cfg_reg(DM355_VIN_CINL_EN);
+	davinci_cfg_reg(DM355_VIN_CINH_EN);
+}
+
 static struct resource dm355_vpss_resources[] = {
 	{
 		/* VPSS BL Base address */
@@ -701,6 +724,10 @@ static struct resource vpfe_resources[] = {
 		.end            = IRQ_VDINT1,
 		.flags          = IORESOURCE_IRQ,
 	},
+};
+
+static u64 vpfe_capture_dma_mask = DMA_BIT_MASK(32);
+static struct resource dm355_ccdc_resource[] = {
 	/* CCDC Base address */
 	{
 		.flags          = IORESOURCE_MEM,
@@ -708,8 +735,18 @@ static struct resource vpfe_resources[] = {
 		.end            = 0x01c70600 + 0x1ff,
 	},
 };
+static struct platform_device dm355_ccdc_dev = {
+	.name           = "dm355_ccdc",
+	.id             = -1,
+	.num_resources  = ARRAY_SIZE(dm355_ccdc_resource),
+	.resource       = dm355_ccdc_resource,
+	.dev = {
+		.dma_mask               = &vpfe_capture_dma_mask,
+		.coherent_dma_mask      = DMA_BIT_MASK(32),
+		.platform_data		= dm355_ccdc_setup_pinmux,
+	},
+};
 
-static u64 vpfe_capture_dma_mask = DMA_BIT_MASK(32);
 static struct platform_device vpfe_capture_dev = {
 	.name		= CAPTURE_DRV_NAME,
 	.id		= -1,
@@ -860,17 +897,7 @@ static int __init dm355_init_devices(void)
 	davinci_cfg_reg(DM355_INT_EDMA_CC);
 	platform_device_register(&dm355_edma_device);
 	platform_device_register(&dm355_vpss_device);
-	/*
-	 * setup Mux configuration for vpfe input and register
-	 * vpfe capture platform device
-	 */
-	davinci_cfg_reg(DM355_VIN_PCLK);
-	davinci_cfg_reg(DM355_VIN_CAM_WEN);
-	davinci_cfg_reg(DM355_VIN_CAM_VD);
-	davinci_cfg_reg(DM355_VIN_CAM_HD);
-	davinci_cfg_reg(DM355_VIN_YIN_EN);
-	davinci_cfg_reg(DM355_VIN_CINL_EN);
-	davinci_cfg_reg(DM355_VIN_CINH_EN);
+	platform_device_register(&dm355_ccdc_dev);
 	platform_device_register(&vpfe_capture_dev);
 
 	return 0;
diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-davinci/dm644x.c
index e65e29e..ca0843a 100644
--- a/arch/arm/mach-davinci/dm644x.c
+++ b/arch/arm/mach-davinci/dm644x.c
@@ -277,6 +277,16 @@ static struct clk timer2_clk = {
 	.usecount = ATOMIC_INIT(1), /* REVISIT: why cant' this be disabled? */
 };
 
+static struct clk ccdc_master_clk = {
+	.name		= "dm644x_ccdc",
+	.parent		= &vpss_master_clk,
+};
+
+static struct clk ccdc_slave_clk = {
+	.name		= "dm644x_ccdc",
+	.parent		= &vpss_slave_clk,
+};
+
 struct davinci_clk dm644x_clks[] = {
 	CLK(NULL, "ref", &ref_clk),
 	CLK(NULL, "pll1", &pll1_clk),
@@ -315,6 +325,8 @@ struct davinci_clk dm644x_clks[] = {
 	CLK(NULL, "timer0", &timer0_clk),
 	CLK(NULL, "timer1", &timer1_clk),
 	CLK("watchdog", NULL, &timer2_clk),
+	CLK("dm644x_ccdc", "master", &ccdc_master_clk),
+	CLK("dm644x_ccdc", "slave", &ccdc_slave_clk),
 	CLK(NULL, NULL, NULL),
 };
 
@@ -612,6 +624,11 @@ static struct resource vpfe_resources[] = {
 		.end            = IRQ_VDINT1,
 		.flags          = IORESOURCE_IRQ,
 	},
+};
+
+static u64 vpfe_capture_dma_mask = DMA_BIT_MASK(32);
+static struct resource dm644x_ccdc_resource[] = {
+	/* CCDC Base address */
 	{
 		.start          = 0x01c70400,
 		.end            = 0x01c70400 + 0xff,
@@ -619,7 +636,17 @@ static struct resource vpfe_resources[] = {
 	},
 };
 
-static u64 vpfe_capture_dma_mask = DMA_BIT_MASK(32);
+static struct platform_device dm644x_ccdc_dev = {
+	.name           = "dm644x_ccdc",
+	.id             = -1,
+	.num_resources  = ARRAY_SIZE(dm644x_ccdc_resource),
+	.resource       = dm644x_ccdc_resource,
+	.dev = {
+		.dma_mask               = &vpfe_capture_dma_mask,
+		.coherent_dma_mask      = DMA_BIT_MASK(32),
+	},
+};
+
 static struct platform_device vpfe_capture_dev = {
 	.name		= CAPTURE_DRV_NAME,
 	.id		= -1,
@@ -772,6 +799,7 @@ static int __init dm644x_init_devices(void)
 	platform_device_register(&dm644x_edma_device);
 	platform_device_register(&dm644x_emac_device);
 	platform_device_register(&dm644x_vpss_device);
+	platform_device_register(&dm644x_ccdc_dev);
 	platform_device_register(&vpfe_capture_dev);
 
 	return 0;
-- 
1.6.0.4

