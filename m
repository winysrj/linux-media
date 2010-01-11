Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:57788 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab0AKTXI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2010 14:23:08 -0500
From: m-karicheri2@ti.com
To: linux-media@vger.kernel.org, khilman@deeprootsystems.com,
	mchehab@infradead.org
Cc: hverkuil@xs4all.nl, davinci-linux-open-source@linux.davincidsp.com,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH - v4 4/4] DaVinci-vpfe-capture-converting-ccdc-drivers-to-platform-drivers
Date: Mon, 11 Jan 2010 14:22:55 -0500
Message-Id: <1263237778-22361-1-git-send-email-m-karicheri2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Muralidharan Karicheri <m-karicheri2@ti.com>

Re-sending the patches based on Kevin's comments.
Following are the changes from v3 :-

 - replaced CLK entries with clk_add_alias() calls
 - removed unused vpss_master and vpss_slave entries

This combines the two patches sent earlier to change the clock configuration
and converting ccdc drivers to platform drivers. This has updated comments
against v2 of these patches. Two new clocks "master" and "slave" are defined for ccdc driver
as per comments from Kevin Hilman.

This adds platform code for ccdc driver on DM355 and DM6446.

Reviewed-by: Vaibhav Hiremath <hvaibhav@ti.com>
Reviewed-by: Kevin Hilman <khilman@deeprootsystems.com>
Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>

Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
---
Applies to Linus tree
 arch/arm/mach-davinci/dm355.c  |   58 ++++++++++++++++++++-------------------
 arch/arm/mach-davinci/dm644x.c |   36 ++++++++++++++-----------
 2 files changed, 50 insertions(+), 44 deletions(-)

diff --git a/arch/arm/mach-davinci/dm355.c b/arch/arm/mach-davinci/dm355.c
index dedf4d4..b4d0396 100644
--- a/arch/arm/mach-davinci/dm355.c
+++ b/arch/arm/mach-davinci/dm355.c
@@ -112,20 +112,6 @@ static struct clk vpss_dac_clk = {
 	.lpsc = DM355_LPSC_VPSS_DAC,
 };
 
-static struct clk vpss_master_clk = {
-	.name = "vpss_master",
-	.parent = &pll1_sysclk4,
-	.lpsc = DAVINCI_LPSC_VPSSMSTR,
-	.flags = CLK_PSC,
-};
-
-static struct clk vpss_slave_clk = {
-	.name = "vpss_slave",
-	.parent = &pll1_sysclk4,
-	.lpsc = DAVINCI_LPSC_VPSSSLV,
-};
-
-
 static struct clk clkout1_clk = {
 	.name = "clkout1",
 	.parent = &pll1_aux_clk,
@@ -345,8 +331,6 @@ static struct davinci_clk dm355_clks[] = {
 	CLK(NULL, "pll1_aux", &pll1_aux_clk),
 	CLK(NULL, "pll1_sysclkbp", &pll1_sysclkbp),
 	CLK(NULL, "vpss_dac", &vpss_dac_clk),
-	CLK(NULL, "vpss_master", &vpss_master_clk),
-	CLK(NULL, "vpss_slave", &vpss_slave_clk),
 	CLK(NULL, "clkout1", &clkout1_clk),
 	CLK(NULL, "clkout2", &clkout2_clk),
 	CLK(NULL, "pll2", &pll2_clk),
@@ -665,6 +649,17 @@ static struct platform_device dm355_asp1_device = {
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
@@ -701,6 +696,10 @@ static struct resource vpfe_resources[] = {
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
@@ -708,8 +707,18 @@ static struct resource vpfe_resources[] = {
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
@@ -857,20 +866,13 @@ static int __init dm355_init_devices(void)
 	if (!cpu_is_davinci_dm355())
 		return 0;
 
+	/* Add ccdc clock aliases */
+	clk_add_alias("master", dm355_ccdc_dev.name, "pll1_sysclk4", NULL);
+	clk_add_alias("slave", dm355_ccdc_dev.name, "pll1_sysclk4", NULL);
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
index 2cd0081..569c541 100644
--- a/arch/arm/mach-davinci/dm644x.c
+++ b/arch/arm/mach-davinci/dm644x.c
@@ -149,19 +149,6 @@ static struct clk vicp_clk = {
 	.usecount = 1,			/* REVISIT how to disable? */
 };
 
-static struct clk vpss_master_clk = {
-	.name = "vpss_master",
-	.parent = &pll1_sysclk3,
-	.lpsc = DAVINCI_LPSC_VPSSMSTR,
-	.flags = CLK_PSC,
-};
-
-static struct clk vpss_slave_clk = {
-	.name = "vpss_slave",
-	.parent = &pll1_sysclk3,
-	.lpsc = DAVINCI_LPSC_VPSSSLV,
-};
-
 static struct clk uart0_clk = {
 	.name = "uart0",
 	.parent = &pll1_aux_clk,
@@ -293,8 +280,6 @@ struct davinci_clk dm644x_clks[] = {
 	CLK(NULL, "dsp", &dsp_clk),
 	CLK(NULL, "arm", &arm_clk),
 	CLK(NULL, "vicp", &vicp_clk),
-	CLK(NULL, "vpss_master", &vpss_master_clk),
-	CLK(NULL, "vpss_slave", &vpss_slave_clk),
 	CLK(NULL, "arm", &arm_clk),
 	CLK(NULL, "uart0", &uart0_clk),
 	CLK(NULL, "uart1", &uart1_clk),
@@ -612,6 +597,11 @@ static struct resource vpfe_resources[] = {
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
@@ -619,7 +609,17 @@ static struct resource vpfe_resources[] = {
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
@@ -769,9 +769,13 @@ static int __init dm644x_init_devices(void)
 	if (!cpu_is_davinci_dm644x())
 		return 0;
 
+	/* Add ccdc clock aliases */
+	clk_add_alias("master", dm644x_ccdc_dev.name, "pll1_sysclk3", NULL);
+	clk_add_alias("slave", dm644x_ccdc_dev.name, "pll1_sysclk3", NULL);
 	platform_device_register(&dm644x_edma_device);
 	platform_device_register(&dm644x_emac_device);
 	platform_device_register(&dm644x_vpss_device);
+	platform_device_register(&dm644x_ccdc_dev);
 	platform_device_register(&vpfe_capture_dev);
 
 	return 0;
-- 
1.6.0.4

