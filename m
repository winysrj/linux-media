Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:40414 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756544AbZFQULa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 16:11:30 -0400
Received: from dlep33.itg.ti.com ([157.170.170.112])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id n5HKBSJc009840
	for <linux-media@vger.kernel.org>; Wed, 17 Jun 2009 15:11:33 -0500
From: m-karicheri2@ti.com
To: linux-media@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH 7/11 - v3] DM355 platform changes for vpfe capture driver
Date: Wed, 17 Jun 2009 16:11:20 -0400
Message-Id: <1245269484-8325-8-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1245269484-8325-7-git-send-email-m-karicheri2@ti.com>
References: <1245269484-8325-1-git-send-email-m-karicheri2@ti.com>
 <1245269484-8325-2-git-send-email-m-karicheri2@ti.com>
 <1245269484-8325-3-git-send-email-m-karicheri2@ti.com>
 <1245269484-8325-4-git-send-email-m-karicheri2@ti.com>
 <1245269484-8325-5-git-send-email-m-karicheri2@ti.com>
 <1245269484-8325-6-git-send-email-m-karicheri2@ti.com>
 <1245269484-8325-7-git-send-email-m-karicheri2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Muralidharan Karicheri <m-karicheri2@ti.com>

DM355 platform and board setup

This has platform and board setup changes to support vpfe capture
driver for DM355 EVMs.

summary of changes
	1) replaced v4l2_routing structure with vpfe structure for route
	2) ccdc bus parameter settings added
	3) input name string changed to Composite and S-Video
 
Reviewed by: Hans Verkuil <hverkuil@xs4all.nl>
Reviewed by: Laurent Pinchart <laurent.pinchart@skynet.be>
Reviewed by: Kevin Hilman <khilman@deeprootsystems.com>
Reviewed by: David Brownell <david-b@pacbell.net>

Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
---
Applies to Davinci GIT Tree

 arch/arm/mach-davinci/board-dm355-evm.c    |   76 ++++++++++++++++++++++++-
 arch/arm/mach-davinci/dm355.c              |   83 ++++++++++++++++++++++++++++
 arch/arm/mach-davinci/include/mach/dm355.h |    2 +
 arch/arm/mach-davinci/include/mach/mux.h   |    9 +++
 4 files changed, 167 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-davinci/board-dm355-evm.c b/arch/arm/mach-davinci/board-dm355-evm.c
index 5ac2f56..513be53 100644
--- a/arch/arm/mach-davinci/board-dm355-evm.c
+++ b/arch/arm/mach-davinci/board-dm355-evm.c
@@ -20,6 +20,8 @@
 #include <linux/io.h>
 #include <linux/gpio.h>
 #include <linux/clk.h>
+#include <linux/videodev2.h>
+#include <media/tvp514x.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/eeprom.h>
 
@@ -134,12 +136,22 @@ static void dm355evm_mmcsd_gpios(unsigned gpio)
 	dm355evm_mmc_gpios = gpio;
 }
 
+static struct tvp514x_platform_data tvp5146_pdata = {
+	.clk_polarity = 0,
+	.hs_polarity = 1,
+	.vs_polarity = 1
+};
+
 static struct i2c_board_info dm355evm_i2c_info[] = {
-	{ I2C_BOARD_INFO("dm355evm_msp", 0x25),
+	{	I2C_BOARD_INFO("dm355evm_msp", 0x25),
 		.platform_data = dm355evm_mmcsd_gpios,
-		/* plus irq */ },
+	},
+	{
+		I2C_BOARD_INFO("tvp5146", 0x5d),
+		.platform_data = &tvp5146_pdata,
+	},
+	/* { plus irq  }, */
 	/* { I2C_BOARD_INFO("tlv320aic3x", 0x1b), }, */
-	/* { I2C_BOARD_INFO("tvp5146", 0x5d), }, */
 };
 
 static void __init evm_init_i2c(void)
@@ -178,6 +190,62 @@ static struct platform_device dm355evm_dm9000 = {
 	.num_resources	= ARRAY_SIZE(dm355evm_dm9000_rsrc),
 };
 
+#define TVP514X_STD_ALL	(V4L2_STD_NTSC | V4L2_STD_PAL)
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
+	{
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
+	}
+};
+
+static struct vpfe_config vpfe_cfg = {
+	.num_subdevs = ARRAY_SIZE(vpfe_sub_devs),
+	.sub_devs = vpfe_sub_devs,
+	.card_name = "DM355 EVM",
+	.ccdc = "DM355 CCDC",
+};
+
 static struct platform_device *davinci_evm_devices[] __initdata = {
 	&dm355evm_dm9000,
 	&davinci_nand_device,
@@ -189,6 +257,8 @@ static struct davinci_uart_config uart_config __initdata = {
 
 static void __init dm355_evm_map_io(void)
 {
+	/* setup input configuration for VPFE input devices */
+	dm355_set_vpfe_config(&vpfe_cfg);
 	dm355_init();
 }
 
diff --git a/arch/arm/mach-davinci/dm355.c b/arch/arm/mach-davinci/dm355.c
index f0b10b4..7a7b020 100644
--- a/arch/arm/mach-davinci/dm355.c
+++ b/arch/arm/mach-davinci/dm355.c
@@ -481,6 +481,14 @@ INT_CFG(DM355,  INT_EDMA_TC1_ERR,     4,    1,    1,     false)
 EVT_CFG(DM355,  EVT8_ASP1_TX,	      0,    1,    0,     false)
 EVT_CFG(DM355,  EVT9_ASP1_RX,	      1,    1,    0,     false)
 EVT_CFG(DM355,  EVT26_MMC0_RX,	      2,    1,    0,     false)
+
+MUX_CFG(DM355,	VIN_PCLK,	0,   14,    1,    1,	 false)
+MUX_CFG(DM355,	VIN_CAM_WEN,	0,   13,    1,    1,	 false)
+MUX_CFG(DM355,	VIN_CAM_VD,	0,   12,    1,    1,	 false)
+MUX_CFG(DM355,	VIN_CAM_HD,	0,   11,    1,    1,	 false)
+MUX_CFG(DM355,	VIN_YIN_EN,	0,   10,    1,    1,	 false)
+MUX_CFG(DM355,	VIN_CINL_EN,	0,   0,   0xff, 0x55,	 false)
+MUX_CFG(DM355,	VIN_CINH_EN,	0,   8,     3,    3,	 false)
 #endif
 };
 
@@ -623,6 +631,67 @@ static struct platform_device dm355_edma_device = {
 	.resource		= edma_resources,
 };
 
+static struct resource dm355_vpss_resources[] = {
+	{
+		/* VPSS BL Base address */
+		.name		= "vpss",
+		.start          = 0x01c70800,
+		.end            = 0x01c70800 + 0xff,
+		.flags          = IORESOURCE_MEM,
+	},
+	{
+		/* VPSS CLK Base address */
+		.name		= "vpss",
+		.start          = 0x01c70000,
+		.end            = 0x01c70000 + 0xf,
+		.flags          = IORESOURCE_MEM,
+	},
+};
+
+static struct platform_device dm355_vpss_device = {
+	.name			= "vpss",
+	.id			= -1,
+	.dev.platform_data	= "dm355_vpss",
+	.num_resources		= ARRAY_SIZE(dm355_vpss_resources),
+	.resource		= dm355_vpss_resources,
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
+	/* CCDC Base address */
+	{
+		.flags          = IORESOURCE_MEM,
+		.start          = 0x01c70600,
+		.end            = 0x01c70600 + 0x1ff,
+	},
+};
+
+static u64 vpfe_capture_dma_mask = DMA_BIT_MASK(32);
+static struct platform_device vpfe_capture_dev = {
+	.name		= CAPTURE_DRV_NAME,
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(vpfe_resources),
+	.resource	= vpfe_resources,
+	.dev = {
+		.dma_mask		= &vpfe_capture_dma_mask,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
+	},
+};
+
+void dm355_set_vpfe_config(struct vpfe_config *cfg)
+{
+	vpfe_capture_dev.dev.platform_data = cfg;
+}
+
 /*----------------------------------------------------------------------*/
 
 static struct map_desc dm355_io_desc[] = {
@@ -743,6 +812,20 @@ static int __init dm355_init_devices(void)
 
 	davinci_cfg_reg(DM355_INT_EDMA_CC);
 	platform_device_register(&dm355_edma_device);
+	platform_device_register(&dm355_vpss_device);
+	/*
+	 * setup Mux configuration for vpfe input and register
+	 * vpfe capture platform device
+	 */
+	davinci_cfg_reg(DM355_VIN_PCLK);
+	davinci_cfg_reg(DM355_VIN_CAM_WEN);
+	davinci_cfg_reg(DM355_VIN_CAM_VD);
+	davinci_cfg_reg(DM355_VIN_CAM_HD);
+	davinci_cfg_reg(DM355_VIN_YIN_EN);
+	davinci_cfg_reg(DM355_VIN_CINL_EN);
+	davinci_cfg_reg(DM355_VIN_CINH_EN);
+	platform_device_register(&vpfe_capture_dev);
+
 	return 0;
 }
 postcore_initcall(dm355_init_devices);
diff --git a/arch/arm/mach-davinci/include/mach/dm355.h b/arch/arm/mach-davinci/include/mach/dm355.h
index 54903b7..e28713c 100644
--- a/arch/arm/mach-davinci/include/mach/dm355.h
+++ b/arch/arm/mach-davinci/include/mach/dm355.h
@@ -12,11 +12,13 @@
 #define __ASM_ARCH_DM355_H
 
 #include <mach/hardware.h>
+#include <media/davinci/vpfe_capture.h>
 
 struct spi_board_info;
 
 void __init dm355_init(void);
 void dm355_init_spi0(unsigned chipselect_mask,
 		struct spi_board_info *info, unsigned len);
+void dm355_set_vpfe_config(struct vpfe_config *cfg);
 
 #endif /* __ASM_ARCH_DM355_H */
diff --git a/arch/arm/mach-davinci/include/mach/mux.h b/arch/arm/mach-davinci/include/mach/mux.h
index a5eed8f..e21eec1 100644
--- a/arch/arm/mach-davinci/include/mach/mux.h
+++ b/arch/arm/mach-davinci/include/mach/mux.h
@@ -154,6 +154,15 @@ enum davinci_dm355_index {
 	DM355_EVT8_ASP1_TX,
 	DM355_EVT9_ASP1_RX,
 	DM355_EVT26_MMC0_RX,
+
+	/* Video In Pin Mux */
+	DM355_VIN_PCLK,
+	DM355_VIN_CAM_WEN,
+	DM355_VIN_CAM_VD,
+	DM355_VIN_CAM_HD,
+	DM355_VIN_YIN_EN,
+	DM355_VIN_CINL_EN,
+	DM355_VIN_CINH_EN,
 };
 
 enum davinci_dm365_index {
-- 
1.6.0.4

