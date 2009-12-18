Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:46707 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890AbZLRX6b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2009 18:58:31 -0500
From: m-karicheri2@ti.com
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	khilman@deeprootsystems.com, hvaibhav@ti.com, nsekhar@ti.com
Cc: davinci-linux-open-source@linux.davincidsp.com,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH - v2 6/6] DaVinci - Adding platform code for vpfe capture on DM365
Date: Fri, 18 Dec 2009 18:58:20 -0500
Message-Id: <1261180705-8150-1-git-send-email-m-karicheri2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Muralidharan Karicheri <m-karicheri2@ti.com>

updated based on comments against v1 of the patch

Adding platform code for supporting vpfe capture and ISIF driver on DM365.

Reviewed-by: Kevin Hilman <khilman@deeprootsystems.com>
Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
---
Applies to linux-next of v4l-dvb
 arch/arm/mach-davinci/board-dm365-evm.c    |   71 +++++++++++++++++++
 arch/arm/mach-davinci/dm365.c              |  101 +++++++++++++++++++++++++++-
 arch/arm/mach-davinci/include/mach/dm365.h |    2 +
 3 files changed, 173 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-davinci/board-dm365-evm.c b/arch/arm/mach-davinci/board-dm365-evm.c
index 289fe1b..06f53bf 100644
--- a/arch/arm/mach-davinci/board-dm365-evm.c
+++ b/arch/arm/mach-davinci/board-dm365-evm.c
@@ -37,6 +37,8 @@
 #include <mach/nand.h>
 #include <mach/keyscan.h>
 
+#include <media/tvp514x.h>
+
 static inline int have_imager(void)
 {
 	/* REVISIT when it's supported, trigger via Kconfig */
@@ -302,6 +304,73 @@ static void dm365evm_mmc_configure(void)
 	davinci_cfg_reg(DM365_SD1_DATA0);
 }
 
+static struct tvp514x_platform_data tvp5146_pdata = {
+	.clk_polarity = 0,
+	.hs_polarity = 1,
+	.vs_polarity = 1
+};
+
+#define TVP514X_STD_ALL        (V4L2_STD_NTSC | V4L2_STD_PAL)
+/* Inputs available at the TVP5146 */
+static struct v4l2_input tvp5146_inputs[] = {
+	{
+		.index = 0,
+		.name = "Composite",
+		.type = V4L2_INPUT_TYPE_CAMERA,
+		.std = TVP514X_STD_ALL,
+	},
+	{
+		.index = 1,
+		.name = "S-Video",
+		.type = V4L2_INPUT_TYPE_CAMERA,
+		.std = TVP514X_STD_ALL,
+	},
+};
+
+/*
+ * this is the route info for connecting each input to decoder
+ * ouput that goes to vpfe. There is a one to one correspondence
+ * with tvp5146_inputs
+ */
+static struct vpfe_route tvp5146_routes[] = {
+	{
+		.input = INPUT_CVBS_VI2B,
+		.output = OUTPUT_10BIT_422_EMBEDDED_SYNC,
+	},
+{
+		.input = INPUT_SVIDEO_VI2C_VI1C,
+		.output = OUTPUT_10BIT_422_EMBEDDED_SYNC,
+	},
+};
+
+static struct vpfe_subdev_info vpfe_sub_devs[] = {
+	{
+		.name = "tvp5146",
+		.grp_id = 0,
+		.num_inputs = ARRAY_SIZE(tvp5146_inputs),
+		.inputs = tvp5146_inputs,
+		.routes = tvp5146_routes,
+		.can_route = 1,
+		.ccdc_if_params = {
+			.if_type = VPFE_BT656,
+			.hdpol = VPFE_PINPOL_POSITIVE,
+			.vdpol = VPFE_PINPOL_POSITIVE,
+		},
+		.board_info = {
+			I2C_BOARD_INFO("tvp5146", 0x5d),
+			.platform_data = &tvp5146_pdata,
+		},
+	},
+};
+
+static struct vpfe_config vpfe_cfg = {
+       .num_subdevs = ARRAY_SIZE(vpfe_sub_devs),
+       .sub_devs = vpfe_sub_devs,
+	.i2c_adapter_id = 1,
+       .card_name = "DM365 EVM",
+       .ccdc = "ISIF",
+};
+
 static void __init evm_init_i2c(void)
 {
 	davinci_init_i2c(&i2c_pdata);
@@ -493,6 +562,8 @@ static struct davinci_uart_config uart_config __initdata = {
 
 static void __init dm365_evm_map_io(void)
 {
+	/* setup input configuration for VPFE input devices */
+	dm365_set_vpfe_config(&vpfe_cfg);
 	dm365_init();
 }
 
diff --git a/arch/arm/mach-davinci/dm365.c b/arch/arm/mach-davinci/dm365.c
index 2ec619e..7da8a91 100644
--- a/arch/arm/mach-davinci/dm365.c
+++ b/arch/arm/mach-davinci/dm365.c
@@ -459,6 +459,7 @@ static struct davinci_clk dm365_clks[] = {
 	CLK("davinci-asp.0", NULL, &asp0_clk),
 	CLK(NULL, "rto", &rto_clk),
 	CLK(NULL, "mjcp", &mjcp_clk),
+	CLK("isif", "master", &vpss_master_clk),
 	CLK(NULL, NULL, NULL),
 };
 
@@ -1009,6 +1010,97 @@ void __init dm365_init(void)
 	davinci_common_init(&davinci_soc_info_dm365);
 }
 
+static struct resource dm365_vpss_resources[] = {
+	{
+		/* VPSS ISP5 Base address */
+		.name           = "isp5",
+		.start          = 0x01c70000,
+		.end            = 0x01c70000 + 0xff,
+		.flags          = IORESOURCE_MEM,
+	},
+	{
+		/* VPSS CLK Base address */
+		.name           = "vpss",
+		.start          = 0x01c70200,
+		.end            = 0x01c70200 + 0xff,
+		.flags          = IORESOURCE_MEM,
+	},
+};
+
+static struct platform_device dm365_vpss_device = {
+       .name                   = "vpss",
+       .id                     = -1,
+       .dev.platform_data      = "dm365_vpss",
+       .num_resources          = ARRAY_SIZE(dm365_vpss_resources),
+       .resource               = dm365_vpss_resources,
+};
+
+static struct resource vpfe_resources[] = {
+	{
+		.start          = IRQ_VDINT0,
+		.end            = IRQ_VDINT0,
+		.flags          = IORESOURCE_IRQ,
+	},
+	{
+		.start          = IRQ_VDINT1,
+		.end            = IRQ_VDINT1,
+		.flags          = IORESOURCE_IRQ,
+	},
+};
+
+static u64 vpfe_capture_dma_mask = DMA_BIT_MASK(32);
+static struct platform_device vpfe_capture_dev = {
+	.name           = CAPTURE_DRV_NAME,
+	.id             = -1,
+	.num_resources  = ARRAY_SIZE(vpfe_resources),
+	.resource       = vpfe_resources,
+	.dev = {
+		.dma_mask               = &vpfe_capture_dma_mask,
+		.coherent_dma_mask      = DMA_BIT_MASK(32),
+	},
+};
+
+static void dm365_isif_setup_pinmux(void)
+{
+	davinci_cfg_reg(DM365_VIN_CAM_WEN);
+	davinci_cfg_reg(DM365_VIN_CAM_VD);
+	davinci_cfg_reg(DM365_VIN_CAM_HD);
+	davinci_cfg_reg(DM365_VIN_YIN4_7_EN);
+	davinci_cfg_reg(DM365_VIN_YIN0_3_EN);
+}
+
+static struct resource isif_resource[] = {
+	/* ISIF Base address */
+	{
+		.start          = 0x01c71000,
+		.end            = 0x01c71000 + 0x1ff,
+		.flags          = IORESOURCE_MEM,
+	},
+	/* ISIF Linearization table 0 */
+	{
+		.start          = 0x1C7C000,
+		.end            = 0x1C7C000 + 0x2ff,
+		.flags          = IORESOURCE_MEM,
+	},
+	/* ISIF Linearization table 1 */
+	{
+		.start          = 0x1C7C400,
+		.end            = 0x1C7C400 + 0x2ff,
+		.flags          = IORESOURCE_MEM,
+	},
+};
+static struct platform_device dm365_isif_dev = {
+	.name           = "isif",
+	.id             = -1,
+	.num_resources  = ARRAY_SIZE(isif_resource),
+	.resource       = isif_resource,
+	.dev = {
+		.dma_mask               = &vpfe_capture_dma_mask,
+		.coherent_dma_mask      = DMA_BIT_MASK(32),
+		.platform_data		= dm365_isif_setup_pinmux,
+	},
+};
+
 static int __init dm365_init_devices(void)
 {
 	if (!cpu_is_davinci_dm365())
@@ -1017,7 +1109,14 @@ static int __init dm365_init_devices(void)
 	davinci_cfg_reg(DM365_INT_EDMA_CC);
 	platform_device_register(&dm365_edma_device);
 	platform_device_register(&dm365_emac_device);
-
+	platform_device_register(&dm365_vpss_device);
+	platform_device_register(&dm365_isif_dev);
+	platform_device_register(&vpfe_capture_dev);
 	return 0;
 }
 postcore_initcall(dm365_init_devices);
+
+void dm365_set_vpfe_config(struct vpfe_config *cfg)
+{
+       vpfe_capture_dev.dev.platform_data = cfg;
+}
diff --git a/arch/arm/mach-davinci/include/mach/dm365.h b/arch/arm/mach-davinci/include/mach/dm365.h
index f1710a3..9fc5a64 100644
--- a/arch/arm/mach-davinci/include/mach/dm365.h
+++ b/arch/arm/mach-davinci/include/mach/dm365.h
@@ -18,6 +18,7 @@
 #include <mach/emac.h>
 #include <mach/asp.h>
 #include <mach/keyscan.h>
+#include <media/davinci/vpfe_capture.h>
 
 #define DM365_EMAC_BASE			(0x01D07000)
 #define DM365_EMAC_CNTRL_OFFSET		(0x0000)
@@ -36,4 +37,5 @@ void __init dm365_init_asp(struct snd_platform_data *pdata);
 void __init dm365_init_ks(struct davinci_ks_platform_data *pdata);
 void __init dm365_init_rtc(void);
 
+void dm365_set_vpfe_config(struct vpfe_config *cfg);
 #endif /* __ASM_ARCH_DM365_H */
-- 
1.6.0.4

