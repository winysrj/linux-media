Return-path: <mchehab@pedra>
Received: from arroyo.ext.ti.com ([192.94.94.40]:33471 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754603Ab0KHO4d (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Nov 2010 09:56:33 -0500
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>
Cc: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Muralidharan Karicheri <m-karicheri2@ti.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH 5/6] davinci vpbe: platform specific additions
Date: Mon,  8 Nov 2010 20:25:44 +0530
Message-Id: <1289228144-5218-1-git-send-email-manjunath.hadli@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Muralidharan Karicheri <m-karicheri2@ti.com>

This patch implements the overall device creation for the Video
display driver, and addition of tables for the mode and output list.

Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
---
 arch/arm/mach-davinci/board-dm644x-evm.c    |   85 +++++++++++--
 arch/arm/mach-davinci/dm644x.c              |  181 ++++++++++++++++++++++++++-
 arch/arm/mach-davinci/include/mach/dm644x.h |    4 +
 3 files changed, 251 insertions(+), 19 deletions(-)

diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c b/arch/arm/mach-davinci/board-dm644x-evm.c
index 34c8b41..b275d8a 100644
--- a/arch/arm/mach-davinci/board-dm644x-evm.c
+++ b/arch/arm/mach-davinci/board-dm644x-evm.c
@@ -166,18 +166,6 @@ static struct platform_device davinci_evm_nandflash_device = {
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
@@ -606,8 +594,77 @@ static void __init evm_init_i2c(void)
 	i2c_register_board_info(1, i2c_info, ARRAY_SIZE(i2c_info));
 }
 
+#define VENC_STD_ALL    (V4L2_STD_NTSC | V4L2_STD_PAL)
+/* venc standards timings */
+static struct vpbe_enc_mode_info vbpe_enc_std_timings[] = {
+	{"ntsc", VPBE_ENC_STD, {V4L2_STD_525_60}, 1, 720, 480,
+	{11, 10}, {30000, 1001}, 0x79, 0, 0x10, 0, 0, 0, 0},
+	{"pal",  VPBE_ENC_STD, {V4L2_STD_625_50}, 1, 720, 576,
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
+		.if_params = {
+			.if_type = VPBE_ANALOG_TV_IF,
+		},
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
+		.if_params = {
+			.if_type = VPBE_ANALOG_TV_IF,
+		},
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
 
@@ -620,6 +677,8 @@ davinci_evm_map_io(void)
 {
 	/* setup input configuration for VPFE input devices */
 	dm644x_set_vpfe_config(&vpfe_cfg);
+	/* setup configuration for vpbe devices */
+	dm644x_set_vpbe_display_config(&vpbe_display_cfg);
 	dm644x_init();
 }
 
diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-davinci/dm644x.c
index 5e5b0a7..bc62123 100644
--- a/arch/arm/mach-davinci/dm644x.c
+++ b/arch/arm/mach-davinci/dm644x.c
@@ -640,6 +640,159 @@ void dm644x_set_vpfe_config(struct vpfe_config *cfg)
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
+static int dm644x_vpbe_setup_pinmux(enum vpbe_if_types if_type,
+				    enum vpbe_rgb_modes rgb_mode,
+				    int field)
+{
+	int ret = 0;
+
+	switch (if_type) {
+	case VPBE_DIGITAL_IF_PRGB:
+		if (rgb_mode == VPBE_RGB666) {
+			davinci_cfg_reg(DM644X_GPIO46_47);
+			davinci_cfg_reg(DM644X_GPIO0);
+			davinci_cfg_reg(DM644X_RGB666);
+			davinci_cfg_reg(DM644X_LOEEN);
+			davinci_cfg_reg(DM644X_GPIO3);
+		} else
+			ret = -EINVAL;
+		break;
+	case VPBE_DIGITAL_IF_YCC16:
+		if (field)
+			davinci_cfg_reg(DM644X_LFLDEN);
+		else
+			davinci_cfg_reg(DM644X_GPIO3);
+		davinci_cfg_reg(DM644X_LOEEN);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+#define VPSS_CLKCTL     0x01C40044
+static void __iomem *vpss_clkctl_reg;
+/* TBD. Check what VENC_CLOCK_SEL settings for HDTV and EDTV */
+static int dm644x_venc_setup_clock(enum vpbe_display_modes mode)
+{
+	int ret = 0;
+
+	if (NULL == vpss_clkctl_reg)
+		return -EINVAL;
+
+	switch (mode) {
+	case VPBE_MODE_HDTV:
+		/*
+		 * For HD, use external clock source since HD requires higher
+		 * clock rate
+		 */
+		__raw_writel(0xa, vpss_clkctl_reg);
+		break;
+	case VPBE_MODE_LCD:
+	case VPBE_MODE_SDTV:
+		__raw_writel(0x18, vpss_clkctl_reg);
+		break;
+	case VPBE_MODE_EDTV:
+		__raw_writel(0x19, vpss_clkctl_reg);
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
+	.setup_pinmux = dm644x_vpbe_setup_pinmux,
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
@@ -767,20 +920,36 @@ void __init dm644x_init(void)
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

