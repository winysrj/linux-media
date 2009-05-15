Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:46648 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbZEOSje (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 May 2009 14:39:34 -0400
Received: from dlep35.itg.ti.com ([157.170.170.118])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id n4FIdV4A025585
	for <linux-media@vger.kernel.org>; Fri, 15 May 2009 13:39:36 -0500
From: m-karicheri2@ti.com
To: linux-media@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com,
	Muralidharan Karicheri <a0868495@dal.design.ti.com>,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH 8/9] DM6446 platform changes for vpfe capture driver
Date: Fri, 15 May 2009 14:39:30 -0400
Message-Id: <1242412770-11561-1-git-send-email-m-karicheri2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Muralidharan Karicheri <a0868495@gt516km11.gt.design.ti.com>

DM644x platform and board setup

This adds plarform and board setup changes required to support
vpfe capture driver on DM644x

This has comments incorporated from previous review.

Reviewed By "Hans Verkuil".
Reviewed By "Laurent Pinchart".

Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
---
Applies to Davinci GIT Tree

 arch/arm/mach-davinci/board-dm644x-evm.c    |   68 ++++++++++++++++++++++++++-
 arch/arm/mach-davinci/dm644x.c              |   42 ++++++++++++++++
 arch/arm/mach-davinci/include/mach/dm644x.h |    2 +
 3 files changed, 110 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c b/arch/arm/mach-davinci/board-dm644x-evm.c
index e97216c..c419dad 100644
--- a/arch/arm/mach-davinci/board-dm644x-evm.c
+++ b/arch/arm/mach-davinci/board-dm644x-evm.c
@@ -28,7 +28,8 @@
 #include <linux/io.h>
 #include <linux/phy.h>
 #include <linux/clk.h>
-
+#include <linux/videodev2.h>
+#include <media/tvp514x.h>
 #include <asm/setup.h>
 #include <asm/mach-types.h>
 
@@ -195,6 +196,57 @@ static struct platform_device davinci_fb_device = {
 	.num_resources = 0,
 };
 
+#define TVP514X_STD_ALL	(V4L2_STD_NTSC | V4L2_STD_PAL)
+/* Inputs available at the TVP5146 */
+static struct v4l2_input tvp5146_inputs[] = {
+	{
+		.index = 0,
+		.name = "COMPOSITE",
+		.type = V4L2_INPUT_TYPE_CAMERA,
+		.std = TVP514X_STD_ALL,
+	},
+	{
+		.index = 1,
+		.name = "SVIDEO",
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
+static struct v4l2_routing tvp5146_routes[] = {
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
+		.inputs = (struct v4l2_input *)tvp5146_inputs,
+		.routes = (struct v4l2_routing *)tvp5146_routes,
+		.can_route = 1,
+	},
+};
+
+static struct vpfe_config vpfe_cfg = {
+	.num_subdevs = ARRAY_SIZE(vpfe_sub_devs),
+	.sub_devs = vpfe_sub_devs,
+	.card_name = "DM6446 EVM",
+	.ccdc = "DM6446 CCDC",
+};
+
 static struct platform_device rtc_dev = {
 	.name           = "rtc_davinci_evm",
 	.id             = -1,
@@ -446,6 +498,13 @@ static struct at24_platform_data eeprom_info = {
 	.context	= (void *)0x7f00,
 };
 
+#define TVP5146_I2C_ADDR		(0x5D)
+static struct tvp514x_platform_data tvp5146_pdata = {
+	.clk_polarity = 0,
+	.hs_polarity = 1,
+	.vs_polarity = 1
+};
+
 /*
  * MSP430 supports RTC, card detection, input from IR remote, and
  * a bit more.  It triggers interrupts on GPIO(7) from pressing
@@ -557,9 +616,12 @@ static struct i2c_board_info __initdata i2c_info[] =  {
 		I2C_BOARD_INFO("24c256", 0x50),
 		.platform_data	= &eeprom_info,
 	},
+	{
+		I2C_BOARD_INFO("tvp5146", TVP5146_I2C_ADDR),
+		.platform_data = &tvp5146_pdata,
+	},
 	/* ALSO:
 	 * - tvl320aic33 audio codec (0x1b)
-	 * - tvp5146 video decoder (0x5d)
 	 */
 };
 
@@ -590,6 +652,8 @@ static struct davinci_uart_config uart_config __initdata = {
 static void __init
 davinci_evm_map_io(void)
 {
+	/* setup input configuration for VPFE input devices */
+	dm644x_set_vpfe_config(&vpfe_cfg);
 	dm644x_init();
 }
 
diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-davinci/dm644x.c
index 45abac4..c58ca9c 100644
--- a/arch/arm/mach-davinci/dm644x.c
+++ b/arch/arm/mach-davinci/dm644x.c
@@ -530,6 +530,46 @@ static struct platform_device dm644x_edma_device = {
 	.resource		= edma_resources,
 };
 
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
+	{
+		.start          = 0x01c70400,
+		.end            = 0x01c70400 + 0xff,
+		.flags          = IORESOURCE_MEM,
+	},
+	{
+		.start          = 0x01c73400,
+		.end            = 0x01c73400 + 0xff,
+		.flags          = IORESOURCE_MEM,
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
+void dm644x_set_vpfe_config(struct vpfe_config *cfg)
+{
+	vpfe_capture_dev.dev.platform_data = cfg;
+}
+
 /*----------------------------------------------------------------------*/
 
 static struct map_desc dm644x_io_desc[] = {
@@ -652,6 +692,8 @@ static int __init dm644x_init_devices(void)
 
 	platform_device_register(&dm644x_edma_device);
 	platform_device_register(&dm644x_emac_device);
+	/* Register VPFE capture device */
+	platform_device_register(&vpfe_capture_dev);
 	return 0;
 }
 postcore_initcall(dm644x_init_devices);
diff --git a/arch/arm/mach-davinci/include/mach/dm644x.h b/arch/arm/mach-davinci/include/mach/dm644x.h
index 15d42b9..0066db3 100644
--- a/arch/arm/mach-davinci/include/mach/dm644x.h
+++ b/arch/arm/mach-davinci/include/mach/dm644x.h
@@ -25,6 +25,7 @@
 #include <linux/platform_device.h>
 #include <mach/hardware.h>
 #include <mach/emac.h>
+#include <media/davinci/vpfe_capture.h>
 
 #define DM644X_EMAC_BASE		(0x01C80000)
 #define DM644X_EMAC_CNTRL_OFFSET	(0x0000)
@@ -34,5 +35,6 @@
 #define DM644X_EMAC_CNTRL_RAM_SIZE	(0x2000)
 
 void __init dm644x_init(void);
+void dm644x_set_vpfe_config(struct vpfe_config *cfg);
 
 #endif /* __ASM_ARCH_DM644X_H */
-- 
1.6.0.4

