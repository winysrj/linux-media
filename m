Return-path: <mchehab@gaivota>
Received: from comal.ext.ti.com ([198.47.26.152]:51297 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755915Ab0LTNy4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Dec 2010 08:54:56 -0500
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>
Cc: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH v8 5/8] davinci vpbe: platform specific additions
Date: Mon, 20 Dec 2010 19:24:40 +0530
Message-Id: <1292853280-2617-1-git-send-email-manjunath.hadli@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

This patch implements the overall device creation for the Video
display driver

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Acked-by: Muralidharan Karicheri <m-karicheri2@ti.com>
Acked-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 arch/arm/mach-davinci/dm644x.c              |  164 ++++++++++++++++++++++++++-
 arch/arm/mach-davinci/include/mach/dm644x.h |    4 +
 2 files changed, 162 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-davinci/dm644x.c
index 5e5b0a7..e8b8e94 100644
--- a/arch/arm/mach-davinci/dm644x.c
+++ b/arch/arm/mach-davinci/dm644x.c
@@ -640,6 +640,142 @@ void dm644x_set_vpfe_config(struct vpfe_config *cfg)
 	vpfe_capture_dev.dev.platform_data = cfg;
 }
 
+static struct resource dm644x_osd_resources[] = {
+	{
+		.start  = 0x01C72600,
+		.end    = 0x01C72600 + 0x200,
+		.flags  = IORESOURCE_MEM,
+	},
+};
+
+static u64 dm644x_osd_dma_mask = DMA_BIT_MASK(32);
+
+static struct platform_device dm644x_osd_dev = {
+	.name           = VPBE_OSD_SUBDEV_NAME,
+	.id             = -1,
+	.num_resources  = ARRAY_SIZE(dm644x_osd_resources),
+	.resource       = dm644x_osd_resources,
+	.dev = {
+		.dma_mask               = &dm644x_osd_dma_mask,
+		.coherent_dma_mask      = DMA_BIT_MASK(32),
+		.platform_data          = (void *)DM644X_VPBE,
+	},
+};
+
+static struct resource dm644x_venc_resources[] = {
+	/* venc registers io space */
+	{
+		.start  = 0x01C72400,
+		.end    = 0x01C72400 + 0x180,
+		.flags  = IORESOURCE_MEM,
+	},
+};
+
+static u64 dm644x_venc_dma_mask = DMA_BIT_MASK(32);
+
+#define VPSS_CLKCTL     0x01C40044
+static void __iomem *vpss_clkctl_reg;
+
+/* TBD. Check what VENC_CLOCK_SEL settings for HDTV and EDTV */
+static int dm644x_venc_setup_clock(enum vpbe_enc_timings_type type, __u64 mode)
+{
+	int ret = 0;
+
+	if (NULL == vpss_clkctl_reg)
+		return -EINVAL;
+	if (type == VPBE_ENC_STD) {
+		__raw_writel(0x18, vpss_clkctl_reg);
+	} else if (type == VPBE_ENC_DV_PRESET) {
+		switch ((unsigned int)mode) {
+		case V4L2_DV_480P59_94:
+		case V4L2_DV_576P50:
+			 __raw_writel(0x19, vpss_clkctl_reg);
+			break;
+		case V4L2_DV_720P60:
+		case V4L2_DV_1080I60:
+		case V4L2_DV_1080P30:
+		/*
+		* For HD, use external clock source since HD requires higher
+		* clock rate
+		*/
+			__raw_writel(0xa, vpss_clkctl_reg);
+			break;
+		default:
+			ret  = -EINVAL;
+			break;
+		}
+	} else
+		ret  = -EINVAL;
+
+	return ret;
+}
+
+
+static inline u32 dm644x_reg_modify(void *reg, u32 val, u32 mask)
+{
+	u32 new_val = (__raw_readl(reg) & ~mask) | (val & mask);
+	__raw_writel(new_val, reg);
+	return new_val;
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
+	{
+		.start  = 0x01C72400,
+		.end    = 0x01C72400 + 0x180,
+		.flags  = IORESOURCE_MEM,
+	},
+
+};
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
+struct venc_platform_data dm644x_venc_pdata = {
+	.venc_type = DM644X_VPBE,
+	.setup_clock = dm644x_venc_setup_clock,
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
+		.platform_data          = (void *)&dm644x_venc_pdata,
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
@@ -767,20 +903,36 @@ void __init dm644x_init(void)
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
+	vpss_clkctl_reg = ioremap_nocache(VPSS_CLKCTL, 4);
+	platform_add_devices(dm644x_video_devices,
+				ARRAY_SIZE(dm644x_video_devices));
+	return 0;
+}
+
 static int __init dm644x_init_devices(void)
 {
 	if (!cpu_is_davinci_dm644x())
 		return 0;
 
 	/* Add ccdc clock aliases */
-	clk_add_alias("master", dm644x_ccdc_dev.name, "vpss_master", NULL);
-	clk_add_alias("slave", dm644x_ccdc_dev.name, "vpss_slave", NULL);
 	platform_device_register(&dm644x_edma_device);
 	platform_device_register(&dm644x_emac_device);
-	platform_device_register(&dm644x_vpss_device);
-	platform_device_register(&dm644x_ccdc_dev);
-	platform_device_register(&vpfe_capture_dev);
-
+	dm644x_init_video();
 	return 0;
 }
 postcore_initcall(dm644x_init_devices);
diff --git a/arch/arm/mach-davinci/include/mach/dm644x.h b/arch/arm/mach-davinci/include/mach/dm644x.h
index 6fca568..bf7adcd 100644
--- a/arch/arm/mach-davinci/include/mach/dm644x.h
+++ b/arch/arm/mach-davinci/include/mach/dm644x.h
@@ -26,6 +26,9 @@
 #include <mach/hardware.h>
 #include <mach/asp.h>
 #include <media/davinci/vpfe_capture.h>
+#include <media/davinci/vpbe_types.h>
+#include <media/davinci/vpbe.h>
+#include <media/davinci/vpss.h>
 
 #define DM644X_EMAC_BASE		(0x01C80000)
 #define DM644X_EMAC_CNTRL_OFFSET	(0x0000)
@@ -43,5 +46,6 @@
 void __init dm644x_init(void);
 void __init dm644x_init_asp(struct snd_platform_data *pdata);
 void dm644x_set_vpfe_config(struct vpfe_config *cfg);
+void dm644x_set_vpbe_display_config(struct vpbe_display_config *cfg);
 
 #endif /* __ASM_ARCH_DM644X_H */
-- 
1.6.2.4

