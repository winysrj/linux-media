Return-path: <mchehab@pedra>
Received: from bear.ext.ti.com ([192.94.94.41]:33009 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211Ab1ANNb3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jan 2011 08:31:29 -0500
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>,
	Kevin Hilman <khilman@deeprootsystems.com>
Cc: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH v14 1/2] davinci vpbe: platform specific additions
Date: Fri, 14 Jan 2011 19:01:12 +0530
Message-Id: <1295011872-1094-1-git-send-email-manjunath.hadli@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch implements the overall device creation for the Video
display driver.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Acked-by: Muralidharan Karicheri <m-karicheri2@ti.com>
Acked-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 arch/arm/mach-davinci/devices.c               |   11 +-
 arch/arm/mach-davinci/dm355.c                 |    3 +
 arch/arm/mach-davinci/dm365.c                 |    3 +
 arch/arm/mach-davinci/dm644x.c                |  167 +++++++++++++++++++++++--
 arch/arm/mach-davinci/dm646x.c                |    3 +
 arch/arm/mach-davinci/include/mach/dm644x.h   |   10 ++
 arch/arm/mach-davinci/include/mach/hardware.h |    5 +
 7 files changed, 184 insertions(+), 18 deletions(-)

diff --git a/arch/arm/mach-davinci/devices.c b/arch/arm/mach-davinci/devices.c
index 22ebc64..f435c7d 100644
--- a/arch/arm/mach-davinci/devices.c
+++ b/arch/arm/mach-davinci/devices.c
@@ -33,6 +33,8 @@
 #define DM365_MMCSD0_BASE	     0x01D11000
 #define DM365_MMCSD1_BASE	     0x01D00000
 
+void __iomem  *davinci_sysmodbase;
+
 static struct resource i2c_resources[] = {
 	{
 		.start		= DAVINCI_I2C_BASE,
@@ -209,9 +211,7 @@ void __init davinci_setup_mmc(int module, struct davinci_mmc_config *config)
 			davinci_cfg_reg(DM355_SD1_DATA2);
 			davinci_cfg_reg(DM355_SD1_DATA3);
 		} else if (cpu_is_davinci_dm365()) {
-			void __iomem *pupdctl1 =
-				IO_ADDRESS(DAVINCI_SYSTEM_MODULE_BASE + 0x7c);
-
+			void __iomem *pupdctl1 = DAVINCI_SYSMODULE_VIRT(0x7c);
 			/* Configure pull down control */
 			__raw_writel((__raw_readl(pupdctl1) & ~0xfc0),
 					pupdctl1);
@@ -242,10 +242,7 @@ void __init davinci_setup_mmc(int module, struct davinci_mmc_config *config)
 							SZ_4K - 1;
 			mmcsd0_resources[2].start = IRQ_DM365_SDIOINT0;
 		} else if (cpu_is_davinci_dm644x()) {
-			/* REVISIT: should this be in board-init code? */
-			void __iomem *base =
-				IO_ADDRESS(DAVINCI_SYSTEM_MODULE_BASE);
-
+			void __iomem *base = DAVINCI_SYSMODULE_VIRT(0);
 			/* Power-on 3.3V IO cells */
 			__raw_writel(0, base + DM64XX_VDD3P3V_PWDN);
 			/*Set up the pull regiter for MMC */
diff --git a/arch/arm/mach-davinci/dm355.c b/arch/arm/mach-davinci/dm355.c
index 2652af1..106bc1b 100644
--- a/arch/arm/mach-davinci/dm355.c
+++ b/arch/arm/mach-davinci/dm355.c
@@ -878,6 +878,9 @@ void __init dm355_init_asp1(u32 evt_enable, struct snd_platform_data *pdata)
 
 void __init dm355_init(void)
 {
+	davinci_sysmodbase = ioremap_nocache(DAVINCI_SYSTEM_MODULE_BASE, 0x800);
+	if (!davinci_sysmodbase)
+		return;
 	davinci_common_init(&davinci_soc_info_dm355);
 }
 
diff --git a/arch/arm/mach-davinci/dm365.c b/arch/arm/mach-davinci/dm365.c
index c466d71..178c610 100644
--- a/arch/arm/mach-davinci/dm365.c
+++ b/arch/arm/mach-davinci/dm365.c
@@ -1132,6 +1132,9 @@ void __init dm365_init_rtc(void)
 
 void __init dm365_init(void)
 {
+	davinci_sysmodbase = ioremap_nocache(DAVINCI_SYSTEM_MODULE_BASE, 0x800);
+	if (!davinci_sysmodbase)
+		return;
 	davinci_common_init(&davinci_soc_info_dm365);
 }
 
diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-davinci/dm644x.c
index 9a2376b..8831026 100644
--- a/arch/arm/mach-davinci/dm644x.c
+++ b/arch/arm/mach-davinci/dm644x.c
@@ -590,8 +590,8 @@ static struct resource dm644x_vpss_resources[] = {
 	{
 		/* VPSS Base address */
 		.name		= "vpss",
-		.start          = 0x01c73400,
-		.end            = 0x01c73400 + 0xff,
+		.start          = DM644X_VPSS_REG_BASE,
+		.end            = DM644X_VPSS_REG_BASE + 0xff,
 		.flags          = IORESOURCE_MEM,
 	},
 };
@@ -618,6 +618,7 @@ static struct resource vpfe_resources[] = {
 };
 
 static u64 vpfe_capture_dma_mask = DMA_BIT_MASK(32);
+
 static struct resource dm644x_ccdc_resource[] = {
 	/* CCDC Base address */
 	{
@@ -654,6 +655,134 @@ void dm644x_set_vpfe_config(struct vpfe_config *cfg)
 	vpfe_capture_dev.dev.platform_data = cfg;
 }
 
+static struct resource dm644x_osd_resources[] = {
+	{
+		.start  = DM644X_OSD_REG_BASE,
+		.end    = DM644X_OSD_REG_BASE + 0x1ff,
+		.flags  = IORESOURCE_MEM,
+	},
+};
+
+static u64 dm644x_osd_dma_mask = DMA_BIT_MASK(32);
+
+static struct osd_platform_data osd_data = {
+	.vpbe_type     = DM644X_VPBE,
+	.field_inv_wa_enable = 0,
+};
+
+static struct platform_device dm644x_osd_dev = {
+	.name           = VPBE_OSD_SUBDEV_NAME,
+	.id             = -1,
+	.num_resources  = ARRAY_SIZE(dm644x_osd_resources),
+	.resource       = dm644x_osd_resources,
+	.dev = {
+		.dma_mask               = &dm644x_osd_dma_mask,
+		.coherent_dma_mask      = DMA_BIT_MASK(32),
+		.platform_data          = &osd_data,
+	},
+};
+
+static struct resource dm644x_venc_resources[] = {
+	/* venc registers io space */
+	{
+		.start  = DM644X_VENC_REG_BASE,
+		.end    = DM644X_VENC_REG_BASE + 0x17f,
+		.flags  = IORESOURCE_MEM,
+	},
+};
+
+static u64 dm644x_venc_dma_mask = DMA_BIT_MASK(32);
+
+static void __iomem *vpss_clkctl_reg;
+
+static int dm644x_venc_setup_clock(enum vpbe_enc_timings_type type, __u64 mode)
+{
+	int ret = 0;
+
+	switch (type) {
+	case VPBE_ENC_STD:
+		writel(0x18, vpss_clkctl_reg);
+		break;
+	case VPBE_ENC_DV_PRESET:
+		switch ((unsigned int)mode) {
+		case V4L2_DV_480P59_94:
+		case V4L2_DV_576P50:
+			writel(0x19, vpss_clkctl_reg);
+			break;
+		case V4L2_DV_720P60:
+		case V4L2_DV_1080I60:
+		case V4L2_DV_1080P30:
+			/*
+			 * For HD, use external clock source since
+			 * HD requires higher clock rate
+			 */
+			writel(0xa, vpss_clkctl_reg);
+			break;
+		default:
+			ret  = -EINVAL;
+			break;
+		}
+		break;
+	default:
+		ret  = -EINVAL;
+	}
+	return ret;
+}
+
+static u64 vpbe_display_dma_mask = DMA_BIT_MASK(32);
+
+static struct resource dm644x_v4l2_disp_resources[] = {
+	{
+		.start  = IRQ_VENCINT,
+		.end    = IRQ_VENCINT,
+		.flags  = IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device vpbe_v4l2_display = {
+	.name           = "vpbe-v4l2",
+	.id             = -1,
+	.num_resources  = ARRAY_SIZE(dm644x_v4l2_disp_resources),
+	.resource       = dm644x_v4l2_disp_resources,
+	.dev = {
+		.dma_mask               = &vpbe_display_dma_mask,
+		.coherent_dma_mask      = DMA_BIT_MASK(32),
+	},
+};
+
+struct venc_platform_data dm644x_venc_pdata = {
+	.venc_type	= DM644X_VPBE,
+	.setup_clock	= dm644x_venc_setup_clock,
+};
+
+static struct platform_device dm644x_venc_dev = {
+	.name           = VPBE_VENC_SUBDEV_NAME,
+	.id             = -1,
+	.num_resources  = ARRAY_SIZE(dm644x_venc_resources),
+	.resource       = dm644x_venc_resources,
+	.dev = {
+		.dma_mask               = &dm644x_venc_dma_mask,
+		.coherent_dma_mask      = DMA_BIT_MASK(32),
+		.platform_data          = &dm644x_venc_pdata,
+	},
+};
+
+static u64 dm644x_vpbe_dma_mask = DMA_BIT_MASK(32);
+
+static struct platform_device dm644x_vpbe_dev = {
+	.name           = "vpbe_controller",
+	.id             = -1,
+	.dev = {
+		.dma_mask               = &dm644x_vpbe_dma_mask,
+		.coherent_dma_mask      = DMA_BIT_MASK(32),
+	},
+};
+
+void dm644x_set_vpbe_display_config(struct vpbe_display_config *cfg)
+{
+	dm644x_vpbe_dev.dev.platform_data = cfg;
+}
+
 /*----------------------------------------------------------------------*/
 
 static struct map_desc dm644x_io_desc[] = {
@@ -778,28 +907,44 @@ void __init dm644x_init_asp(struct snd_platform_data *pdata)
 
 void __init dm644x_init(void)
 {
+	davinci_sysmodbase = ioremap_nocache(DAVINCI_SYSTEM_MODULE_BASE, 0x800);
+	if (!davinci_sysmodbase)
+		return;
 	davinci_common_init(&davinci_soc_info_dm644x);
 }
 
+static struct platform_device *dm644x_video_devices[] __initdata = {
+	&dm644x_vpss_device,
+	&dm644x_ccdc_dev,
+	&vpfe_capture_dev,
+	&dm644x_osd_dev,
+	&dm644x_venc_dev,
+	&dm644x_vpbe_dev,
+	&vpbe_v4l2_display,
+};
+
+static int __init dm644x_init_video(void)
+{
+	/* Add ccdc clock aliases */
+	clk_add_alias("master", dm644x_ccdc_dev.name, "vpss_master", NULL);
+	clk_add_alias("slave", dm644x_ccdc_dev.name, "vpss_slave", NULL);
+	vpss_clkctl_reg = DAVINCI_SYSMODULE_VIRT(0x44);
+	platform_add_devices(dm644x_video_devices,
+				ARRAY_SIZE(dm644x_video_devices));
+	return 0;
+}
+
 static int __init dm644x_init_devices(void)
 {
 	if (!cpu_is_davinci_dm644x())
 		return 0;
 
-	/* Add ccdc clock aliases */
-	clk_add_alias("master", dm644x_ccdc_dev.name, "vpss_master", NULL);
-	clk_add_alias("slave", dm644x_ccdc_dev.name, "vpss_slave", NULL);
 	platform_device_register(&dm644x_edma_device);
-
 	platform_device_register(&dm644x_mdio_device);
 	platform_device_register(&dm644x_emac_device);
 	clk_add_alias(NULL, dev_name(&dm644x_mdio_device.dev),
 		      NULL, &dm644x_emac_device.dev);
-
-	platform_device_register(&dm644x_vpss_device);
-	platform_device_register(&dm644x_ccdc_dev);
-	platform_device_register(&vpfe_capture_dev);
-
+	dm644x_init_video();
 	return 0;
 }
 postcore_initcall(dm644x_init_devices);
diff --git a/arch/arm/mach-davinci/dm646x.c b/arch/arm/mach-davinci/dm646x.c
index 1e0f809..a827090 100644
--- a/arch/arm/mach-davinci/dm646x.c
+++ b/arch/arm/mach-davinci/dm646x.c
@@ -901,6 +901,9 @@ int __init dm646x_init_edma(struct edma_rsv_info *rsv)
 
 void __init dm646x_init(void)
 {
+	davinci_sysmodbase = ioremap_nocache(DAVINCI_SYSTEM_MODULE_BASE, 0x800);
+	if (!davinci_sysmodbase)
+		return;
 	dm646x_board_setup_refclk(&ref_clk);
 	davinci_common_init(&davinci_soc_info_dm646x);
 }
diff --git a/arch/arm/mach-davinci/include/mach/dm644x.h b/arch/arm/mach-davinci/include/mach/dm644x.h
index 5a1b26d..790925f 100644
--- a/arch/arm/mach-davinci/include/mach/dm644x.h
+++ b/arch/arm/mach-davinci/include/mach/dm644x.h
@@ -26,6 +26,10 @@
 #include <mach/hardware.h>
 #include <mach/asp.h>
 #include <media/davinci/vpfe_capture.h>
+#include <media/davinci/vpbe_types.h>
+#include <media/davinci/vpbe.h>
+#include <media/davinci/vpss.h>
+#include <media/davinci/vpbe_osd.h>
 
 #define DM644X_EMAC_BASE		(0x01C80000)
 #define DM644X_EMAC_MDIO_BASE		(DM644X_EMAC_BASE + 0x4000)
@@ -40,8 +44,14 @@
 #define DM644X_ASYNC_EMIF_DATA_CE2_BASE 0x06000000
 #define DM644X_ASYNC_EMIF_DATA_CE3_BASE 0x08000000
 
+/* VPBE register base addresses */
+#define DM644X_VPSS_REG_BASE		0x01c73400
+#define DM644X_VENC_REG_BASE		0x01C72400
+#define DM644X_OSD_REG_BASE		0x01C72600
+
 void __init dm644x_init(void);
 void __init dm644x_init_asp(struct snd_platform_data *pdata);
 void dm644x_set_vpfe_config(struct vpfe_config *cfg);
+void dm644x_set_vpbe_display_config(struct vpbe_display_config *cfg);
 
 #endif /* __ASM_ARCH_DM644X_H */
diff --git a/arch/arm/mach-davinci/include/mach/hardware.h b/arch/arm/mach-davinci/include/mach/hardware.h
index c45ba1f..5a105c4 100644
--- a/arch/arm/mach-davinci/include/mach/hardware.h
+++ b/arch/arm/mach-davinci/include/mach/hardware.h
@@ -24,6 +24,11 @@
 /* System control register offsets */
 #define DM64XX_VDD3P3V_PWDN	0x48
 
+#ifndef __ASSEMBLER__
+	extern void __iomem  *davinci_sysmodbase;
+	#define DAVINCI_SYSMODULE_VIRT(x)       (davinci_sysmodbase+(x))
+#endif
+
 /*
  * I/O mapping
  */
-- 
1.6.2.4

