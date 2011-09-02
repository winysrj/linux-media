Return-path: <linux-media-owner@vger.kernel.org>
Received: from newsmtp5.atmel.com ([204.2.163.5]:46357 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933313Ab1IBKuV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Sep 2011 06:50:21 -0400
From: Josh Wu <josh.wu@atmel.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-media@vger.kernel.org, nicolas.ferre@atmel.com,
	g.liakhovetski@gmx.de, Josh Wu <josh.wu@atmel.com>
Subject: [PATCH] at91: add Atmel ISI and ov2640 support on m10/g45 board.
Date: Fri,  2 Sep 2011 18:50:09 +0800
Message-Id: <1314960609-23396-1-git-send-email-josh.wu@atmel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

AT91: m10/g45: add Atmel ISI device and OV2640 on board.

Signed-off-by: Josh Wu <josh.wu@atmel.com>
---
 arch/arm/mach-at91/at91sam9g45_devices.c |   66 ++++++++++++++++++++
 arch/arm/mach-at91/board-sam9m10g45ek.c  |   97 ++++++++++++++++++++++++++++++
 arch/arm/mach-at91/include/mach/board.h  |    3 +-
 3 files changed, 165 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-at91/at91sam9g45_devices.c
index 1e8f275..ea9a161 100644
--- a/arch/arm/mach-at91/at91sam9g45_devices.c
+++ b/arch/arm/mach-at91/at91sam9g45_devices.c
@@ -28,6 +28,8 @@
 #include <mach/at_hdmac.h>
 #include <mach/atmel-mci.h>
 
+#include <media/atmel-isi.h>
+
 #include "generic.h"
 
 
@@ -872,6 +874,70 @@ void __init at91_add_device_ac97(struct ac97c_platform_data *data)
 void __init at91_add_device_ac97(struct ac97c_platform_data *data) {}
 #endif
 
+/* --------------------------------------------------------------------
+ *  Image Sensor Interface
+ * -------------------------------------------------------------------- */
+#if defined(CONFIG_VIDEO_ATMEL_ISI) || defined(CONFIG_VIDEO_ATMEL_ISI_MODULE)
+static u64 isi_dmamask = DMA_BIT_MASK(32);
+static struct isi_platform_data isi_data;
+
+struct resource isi_resources[] = {
+	[0] = {
+		.start	= AT91SAM9G45_BASE_ISI,
+		.end	= AT91SAM9G45_BASE_ISI + SZ_16K - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= AT91SAM9G45_ID_ISI,
+		.end	= AT91SAM9G45_ID_ISI,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device at91sam9g45_isi_device = {
+	.name		= "atmel_isi",
+	.id		= 0,
+	.dev		= {
+			.dma_mask		= &isi_dmamask,
+			.coherent_dma_mask	= DMA_BIT_MASK(32),
+			.platform_data		= &isi_data,
+	},
+	.resource	= isi_resources,
+	.num_resources	= ARRAY_SIZE(isi_resources),
+};
+
+void __init at91_add_device_isi(struct isi_platform_data * data)
+{
+	struct platform_device *pdev;
+
+	if (!data)
+		return;
+	isi_data = *data;
+
+	at91_set_A_periph(AT91_PIN_PB20, 0);	/* ISI_D0 */
+	at91_set_A_periph(AT91_PIN_PB21, 0);	/* ISI_D1 */
+	at91_set_A_periph(AT91_PIN_PB22, 0);	/* ISI_D2 */
+	at91_set_A_periph(AT91_PIN_PB23, 0);	/* ISI_D3 */
+	at91_set_A_periph(AT91_PIN_PB24, 0);	/* ISI_D4 */
+	at91_set_A_periph(AT91_PIN_PB25, 0);	/* ISI_D5 */
+	at91_set_A_periph(AT91_PIN_PB26, 0);	/* ISI_D6 */
+	at91_set_A_periph(AT91_PIN_PB27, 0);	/* ISI_D7 */
+	at91_set_A_periph(AT91_PIN_PB28, 0);	/* ISI_PCK */
+	at91_set_A_periph(AT91_PIN_PB30, 0);	/* ISI_HSYNC */
+	at91_set_A_periph(AT91_PIN_PB29, 0);	/* ISI_VSYNC */
+	at91_set_B_periph(AT91_PIN_PB31, 0);	/* ISI_MCK (PCK1) */
+	at91_set_B_periph(AT91_PIN_PB8, 0);	/* ISI_PD8 */
+	at91_set_B_periph(AT91_PIN_PB9, 0);	/* ISI_PD9 */
+	at91_set_B_periph(AT91_PIN_PB10, 0);	/* ISI_PD10 */
+	at91_set_B_periph(AT91_PIN_PB11, 0);	/* ISI_PD11 */
+
+	pdev = &at91sam9g45_isi_device;
+	platform_device_register(pdev);
+}
+#else
+void __init at91_add_device_isi(struct isi_platform_data * data) { }
+#endif
+
 
 /* --------------------------------------------------------------------
  *  LCD Controller
diff --git a/arch/arm/mach-at91/board-sam9m10g45ek.c b/arch/arm/mach-at91/board-sam9m10g45ek.c
index 6c999db..2ca219e 100644
--- a/arch/arm/mach-at91/board-sam9m10g45ek.c
+++ b/arch/arm/mach-at91/board-sam9m10g45ek.c
@@ -25,9 +25,12 @@
 #include <linux/leds.h>
 #include <linux/clk.h>
 #include <linux/atmel-mci.h>
+#include <linux/delay.h>
 
 #include <mach/hardware.h>
 #include <video/atmel_lcdc.h>
+#include <media/soc_camera.h>
+#include <media/atmel-isi.h>
 
 #include <asm/setup.h>
 #include <asm/mach-types.h>
@@ -194,6 +197,95 @@ static void __init ek_add_device_nand(void)
 	at91_add_device_nand(&ek_nand_data);
 }
 
+/*
+ *  ISI
+ */
+#if defined(CONFIG_VIDEO_ATMEL_ISI) || defined(CONFIG_VIDEO_ATMEL_ISI_MODULE)
+static struct isi_platform_data __initdata isi_data = {
+	.frate		= ISI_CFG1_FRATE_CAPTURE_ALL,
+	.has_emb_sync	= 0,
+	.emb_crc_sync = 0,
+	.hsync_act_low = 0,
+	.vsync_act_low = 0,
+	.pclk_act_falling = 0,
+	/* to use codec and preview path simultaneously */
+	.isi_full_mode = 1,
+	.data_width_flags = ISI_DATAWIDTH_8 | ISI_DATAWIDTH_10,
+};
+
+static void __init isi_set_clk(void)
+{
+	struct clk *pck1;
+	struct clk *plla;
+
+	pck1 = clk_get(NULL, "pck1");
+	plla = clk_get(NULL, "plla");
+
+	clk_set_parent(pck1, plla);
+	clk_set_rate(pck1, 25000000);
+	clk_enable(pck1);
+}
+#else
+static void __init isi_set_clk(void) {}
+
+static struct isi_platform_data __initdata isi_data;
+#endif
+
+/*
+ * soc-camera OV2640
+ */
+#if defined(CONFIG_SOC_CAMERA_OV2640)
+static unsigned long isi_camera_query_bus_param(struct soc_camera_link *link)
+{
+	/* ISI board for ek using default 8-bits connection */
+	return SOCAM_DATAWIDTH_8;
+}
+
+static int i2c_camera_power(struct device *dev, int on)
+{
+	/* enable or disable the camera */
+	pr_debug("%s: %s the camera\n", __func__, on ? "ENABLE" : "DISABLE");
+	at91_set_gpio_output(AT91_PIN_PD13, on ? 0 : 1);
+
+	if (!on)
+		goto out;
+
+	/* If enabled, give a reset impulse */
+	at91_set_gpio_output(AT91_PIN_PD12, 0);
+	msleep(20);
+	at91_set_gpio_output(AT91_PIN_PD12, 1);
+	msleep(100);
+
+out:
+	return 0;
+}
+
+static struct i2c_board_info i2c_camera = {
+	I2C_BOARD_INFO("ov2640", 0x30),
+};
+
+static struct soc_camera_link iclink_ov2640 = {
+	.bus_id		= 0,
+	.board_info	= &i2c_camera,
+	.i2c_adapter_id	= 0,
+	.power		= i2c_camera_power,
+	.query_bus_param	= isi_camera_query_bus_param,
+};
+
+static struct platform_device isi_ov2640 = {
+	.name	= "soc-camera-pdrv",
+	.id	= 0,
+	.dev	= {
+		.platform_data = &iclink_ov2640,
+	},
+};
+
+static struct platform_device *devices[] __initdata = {
+	&isi_ov2640,
+};
+#else
+static struct platform_device *devices[] __initdata = {};
+#endif
 
 /*
  * LCD Controller
@@ -409,6 +501,11 @@ static void __init ek_board_init(void)
 	ek_add_device_nand();
 	/* I2C */
 	at91_add_device_i2c(0, NULL, 0);
+	/* ISI */
+	platform_add_devices(devices, ARRAY_SIZE(devices));
+	isi_set_clk();
+	at91_add_device_isi(&isi_data);
+
 	/* LCD Controller */
 	at91_add_device_lcdc(&ek_lcdc_data);
 	/* Touch Screen */
diff --git a/arch/arm/mach-at91/include/mach/board.h b/arch/arm/mach-at91/include/mach/board.h
index 2b499eb..099c4f7 100644
--- a/arch/arm/mach-at91/include/mach/board.h
+++ b/arch/arm/mach-at91/include/mach/board.h
@@ -182,7 +182,8 @@ extern void __init at91_add_device_lcdc(struct atmel_lcdfb_info *data);
 extern void __init at91_add_device_ac97(struct ac97c_platform_data *data);
 
  /* ISI */
-extern void __init at91_add_device_isi(void);
+struct isi_platform_data;
+extern void __init at91_add_device_isi(struct isi_platform_data *data);
 
  /* Touchscreen Controller */
 struct at91_tsadcc_data {
-- 
1.6.3.3

