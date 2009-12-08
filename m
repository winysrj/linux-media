Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:33729 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935569AbZLHALj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Dec 2009 19:11:39 -0500
From: m-karicheri2@ti.com
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	khilman@deeprootsystems.com
Cc: davinci-linux-open-source@linux.davincidsp.com, hvaibhav@ti.com,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH v1 4/4] DaVinci - vpfe capture - converting ccdc drivers to platform driver
Date: Mon,  7 Dec 2009 19:11:40 -0500
Message-Id: <1260231100-1226-4-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1260231100-1226-3-git-send-email-m-karicheri2@ti.com>
References: <1260231100-1226-1-git-send-email-m-karicheri2@ti.com>
 <1260231100-1226-2-git-send-email-m-karicheri2@ti.com>
 <1260231100-1226-3-git-send-email-m-karicheri2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Muralidharan Karicheri <m-karicheri2@ti.com>

This combines the two patches sent earlier to change the clock configuration
and converting ccdc drivers to platform drivers. This has updated comments
against v0 of these patches.

This adds platform code for ccdc driver on DM355 and DM6446.

Reviewed-by: Vaibhav Hiremath <hvaibhav@ti.com>
Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
---
Applies to linux-davinci tree
 arch/arm/mach-davinci/dm355.c  |   39 +++++++++++++++++++++++++++------------
 arch/arm/mach-davinci/dm644x.c |   18 +++++++++++++++++-
 2 files changed, 44 insertions(+), 13 deletions(-)

diff --git a/arch/arm/mach-davinci/dm355.c b/arch/arm/mach-davinci/dm355.c
index dedf4d4..0a23820 100644
--- a/arch/arm/mach-davinci/dm355.c
+++ b/arch/arm/mach-davinci/dm355.c
@@ -665,6 +665,17 @@ static struct platform_device dm355_asp1_device = {
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
@@ -701,6 +712,10 @@ static struct resource vpfe_resources[] = {
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
@@ -708,8 +723,18 @@ static struct resource vpfe_resources[] = {
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
@@ -860,17 +885,7 @@ static int __init dm355_init_devices(void)
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
index 2cd0081..982be1f 100644
--- a/arch/arm/mach-davinci/dm644x.c
+++ b/arch/arm/mach-davinci/dm644x.c
@@ -612,6 +612,11 @@ static struct resource vpfe_resources[] = {
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
@@ -619,7 +624,17 @@ static struct resource vpfe_resources[] = {
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
@@ -772,6 +787,7 @@ static int __init dm644x_init_devices(void)
 	platform_device_register(&dm644x_edma_device);
 	platform_device_register(&dm644x_emac_device);
 	platform_device_register(&dm644x_vpss_device);
+	platform_device_register(&dm644x_ccdc_dev);
 	platform_device_register(&vpfe_capture_dev);
 
 	return 0;
-- 
1.6.0.4

