Return-path: <mchehab@gaivota>
Received: from arroyo.ext.ti.com ([192.94.94.40]:49226 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289Ab0LOJ3M (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Dec 2010 04:29:12 -0500
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: Kevin Hilman <khilman@deeprootsystems.com>,
	LMML <linux-media@vger.kernel.org>
Cc: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH 5/7] davinci vpbe: platform specific additions KHilman
Date: Wed, 15 Dec 2010 14:58:51 +0530
Message-Id: <1292405331-18416-1-git-send-email-manjunath.hadli@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

This patch implements the overall device creation for the Video
display driver, and addition of tables for the mode and output list.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Acked-by: Muralidharan Karicheri <m-karicheri2@ti.com>
Acked-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 arch/arm/mach-davinci/board-dm644x-evm.c    |   79 +++++++++++--
 arch/arm/mach-davinci/dm644x.c              |  165 +++++++++++++++++++++++++-
 arch/arm/mach-davinci/include/mach/dm644x.h |    4 +
 3 files changed, 228 insertions(+), 20 deletions(-)

diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c b/arch/arm/mach-davinci/board-dm644x-evm.c
index 0ca90b8..81d52c1 100644
--- a/arch/arm/mach-davinci/board-dm644x-evm.c
+++ b/arch/arm/mach-davinci/board-dm644x-evm.c
@@ -176,18 +176,6 @@ static struct platform_device davinci_evm_nandflash_device = {
 	.resource	= davinci_evm_nandflash_resource,
 };
 
-static u64 davinci_fb_dma_mask = DMA_BIT_MASK(32);
-
-static struct platform_device davinci_fb_device = {
-	.name		= "davincifb",
-	.id		= -1,
-	.dev = {
-		.dma_mask		= &davinci_fb_dma_mask,
-		.coherent_dma_mask      = DMA_BIT_MASK(32),
-	},
-	.num_resources = 0,
-};
-
 static struct tvp514x_platform_data tvp5146_pdata = {
 	.clk_polarity = 0,
 	.hs_polarity = 1,
@@ -616,8 +604,71 @@ static void __init evm_init_i2c(void)
 	i2c_register_board_info(1, i2c_info, ARRAY_SIZE(i2c_info));
 }
 
+#define VENC_STD_ALL    (V4L2_STD_NTSC | V4L2_STD_PAL)
+/* venc standards timings */
+static struct vpbe_enc_mode_info vbpe_enc_std_timings[] = {
+	{"ntsc", VPBE_ENC_STD, {V4L2_STD_525_60}, 1, 720, 480,
+	{11, 10}, {30000, 1001}, 0x79, 0, 0x10, 0, 0, 0, 0},
+	{"pal", VPBE_ENC_STD, {V4L2_STD_625_50}, 1, 720, 576,
+	{54, 59}, {25, 1}, 0x7E, 0, 0x16, 0, 0, 0, 0},
+};
+
+/* venc dv preset timings */
+static struct vpbe_enc_mode_info vbpe_enc_preset_timings[] = {
+	{"480p59_94", VPBE_ENC_DV_PRESET, {V4L2_DV_480P59_94}, 0, 720, 480,
+	{1, 1}, {5994, 100}, 0x80, 0, 0x20, 0, 0, 0, 0},
+	{"576p50", VPBE_ENC_DV_PRESET, {V4L2_DV_576P50}, 0, 720, 576,
+	{1, 1}, {50, 1}, 0x7E, 0, 0x30, 0, 0, 0, 0},
+};
+
+/*
+ * The outputs available from VPBE + ecnoders. Keep the
+ * the order same as that of encoders. First that from venc followed by that
+ * from encoders. Index in the output refers to index on a particular encoder.
+ * Driver uses this index to pass it to encoder when it supports more than
+ * one output. Application uses index of the array to set an output.
+ */
+static struct vpbe_output dm644x_vpbe_outputs[] = {
+	{
+		.output = {
+			.index = 0,
+			.name = "Composite",
+			.type = V4L2_OUTPUT_TYPE_ANALOG,
+			.std = VENC_STD_ALL,
+			.capabilities = V4L2_OUT_CAP_STD,
+		},
+		.subdev_name = VPBE_VENC_SUBDEV_NAME,
+		.default_mode = "ntsc",
+		.num_modes = ARRAY_SIZE(vbpe_enc_std_timings),
+		.modes = vbpe_enc_std_timings,
+	},
+	{
+		.output = {
+			.index = 1,
+			.name = "Component",
+			.type = V4L2_OUTPUT_TYPE_ANALOG,
+			.capabilities = V4L2_OUT_CAP_PRESETS,
+		},
+		.subdev_name = VPBE_VENC_SUBDEV_NAME,
+		.default_mode = "480p59_94",
+		.num_modes = ARRAY_SIZE(vbpe_enc_preset_timings),
+		.modes = vbpe_enc_preset_timings,
+	},
+};
+
+static struct vpbe_display_config vpbe_display_cfg = {
+	.module_name = "dm644x-vpbe-display",
+	.i2c_adapter_id = 1,
+	.osd = {
+		.module_name = VPBE_OSD_SUBDEV_NAME,
+	},
+	.venc = {
+		.module_name = VPBE_VENC_SUBDEV_NAME,
+	},
+	.num_outputs = ARRAY_SIZE(dm644x_vpbe_outputs),
+	.outputs = dm644x_vpbe_outputs,
+};
 static struct platform_device *davinci_evm_devices[] __initdata = {
-	&davinci_fb_device,
 	&rtc_dev,
 };
 
@@ -630,6 +681,8 @@ davinci_evm_map_io(void)
 {
 	/* setup input configuration for VPFE input devices */
 	dm644x_set_vpfe_config(&vpfe_cfg);
+	/* setup configuration for vpbe devices */
+	dm644x_set_vpbe_display_config(&vpbe_display_cfg);
 	dm644x_init();
 }
 
diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-davinci/dm644x.c
index 9a2376b..9db2b53 100644
--- a/arch/arm/mach-davinci/dm644x.c
+++ b/arch/arm/mach-davinci/dm644x.c
@@ -654,8 +654,165 @@ void dm644x_set_vpfe_config(struct vpfe_config *cfg)
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
 static struct map_desc dm644x_io_desc[] = {
 	{
 		.virtual	= IO_VIRT,
@@ -787,19 +944,13 @@ static int __init dm644x_init_devices(void)
 		return 0;
 
 	/* Add ccdc clock aliases */
-	clk_add_alias("master", dm644x_ccdc_dev.name, "vpss_master", NULL);
-	clk_add_alias("slave", dm644x_ccdc_dev.name, "vpss_slave", NULL);
 	platform_device_register(&dm644x_edma_device);
-
 	platform_device_register(&dm644x_mdio_device);
 	platform_device_register(&dm644x_emac_device);
 	clk_add_alias(NULL, dev_name(&dm644x_mdio_device.dev),
 		      NULL, &dm644x_emac_device.dev);
 
-	platform_device_register(&dm644x_vpss_device);
-	platform_device_register(&dm644x_ccdc_dev);
-	platform_device_register(&vpfe_capture_dev);
-
+	dm644x_init_video();
 	return 0;
 }
 postcore_initcall(dm644x_init_devices);
diff --git a/arch/arm/mach-davinci/include/mach/dm644x.h b/arch/arm/mach-davinci/include/mach/dm644x.h
index 5a1b26d..8c0fad2 100644
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
 #define DM644X_EMAC_MDIO_BASE		(DM644X_EMAC_BASE + 0x4000)
@@ -43,5 +46,6 @@
 void __init dm644x_init(void);
 void __init dm644x_init_asp(struct snd_platform_data *pdata);
 void dm644x_set_vpfe_config(struct vpfe_config *cfg);
+void dm644x_set_vpbe_display_config(struct vpbe_display_config *cfg);
 
 #endif /* __ASM_ARCH_DM644X_H */
-- 
1.7.0.4

