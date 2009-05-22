Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:59481 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752640AbZEVK6Q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 May 2009 06:58:16 -0400
Date: Fri, 22 May 2009 12:58:24 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Magnus Damm <magnus.damm@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Darius Augulis <augulis.darius@gmail.com>,
	Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH] pcm037: add MT9T031 camera support
In-Reply-To: <20090520073844.GP9288@pengutronix.de>
Message-ID: <Pine.LNX.4.64.0905221241180.4418@axis700.grange>
References: <Pine.LNX.4.64.0905151817070.4658@axis700.grange>
 <Pine.LNX.4.64.0905151824040.4658@axis700.grange> <20090520073844.GP9288@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Guennadi Liakhovetski <lg@denx.de>

Add support for the MT9T031 CMOS camera sensor from Aptina to the PCM037
board. Also add two I2C iomux pin definitions, needed for pcm037. Also 
remove now unneeded #ifdef CONFIG_I2C_IMX.

Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
---

On Wed, 20 May 2009, Sascha Hauer wrote:

> On Fri, May 15, 2009 at 07:19:10PM +0200, Guennadi Liakhovetski wrote:
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> > 
> > This is actually a completion to the other single patches I've sent 
> > earlier for various boards. As I said, pcm037 doesn't have all its 
> > outstanding patches in next yet, so, you'll need to collect them from 
> > trees / lists, or get them when I upload them.
> 
> As I haven't got camera support for pcm037 in my tree yet, you can
> combine this with the patch which adds camera support. How are we going
> to sync this with the according changes to soc-camera?

Two patches merged, based on your current mxc-master plus cherry-picked 
patches from v4l-dvb. Tested to build and run. As I said, it depends on

http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-next.git;a=commitdiff;h=2bda41a0e9d42cf977a99e8df4fd6e331bb4f50d

from the v4l -next tree.

 arch/arm/mach-mx3/pcm037.c                 |  115 ++++++++++++++++++++++++---
 arch/arm/plat-mxc/include/mach/iomux-mx3.h |    2 +
 2 files changed, 104 insertions(+), 13 deletions(-)

diff --git a/arch/arm/mach-mx3/pcm037.c b/arch/arm/mach-mx3/pcm037.c
index c6f61a1..aae7fe7 100644
--- a/arch/arm/mach-mx3/pcm037.c
+++ b/arch/arm/mach-mx3/pcm037.c
@@ -18,7 +18,7 @@
 
 #include <linux/types.h>
 #include <linux/init.h>
-
+#include <linux/dma-mapping.h>
 #include <linux/platform_device.h>
 #include <linux/mtd/physmap.h>
 #include <linux/mtd/plat-ram.h>
@@ -33,22 +33,23 @@
 #include <linux/irq.h>
 #include <linux/fsl_devices.h>
 
-#include <mach/hardware.h>
+#include <media/soc_camera.h>
+
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/time.h>
 #include <asm/mach/map.h>
+#include <mach/board-pcm037.h>
 #include <mach/common.h>
+#include <mach/hardware.h>
+#include <mach/i2c.h>
 #include <mach/imx-uart.h>
 #include <mach/iomux-mx3.h>
 #include <mach/ipu.h>
-#include <mach/board-pcm037.h>
+#include <mach/mmc.h>
+#include <mach/mx3_camera.h>
 #include <mach/mx3fb.h>
 #include <mach/mxc_nand.h>
-#include <mach/mmc.h>
-#ifdef CONFIG_I2C_IMX
-#include <mach/i2c.h>
-#endif
 
 #include "devices.h"
 
@@ -56,6 +57,8 @@ static unsigned int pcm037_pins[] = {
 	/* I2C */
 	MX31_PIN_CSPI2_MOSI__SCL,
 	MX31_PIN_CSPI2_MISO__SDA,
+	MX31_PIN_CSPI2_SS2__I2C3_SDA,
+	MX31_PIN_CSPI2_SCLK__I2C3_SCL,
 	/* SDHC1 */
 	MX31_PIN_SD1_DATA3__SD1_DATA3,
 	MX31_PIN_SD1_DATA2__SD1_DATA2,
@@ -120,6 +123,22 @@ static unsigned int pcm037_pins[] = {
 	MX31_PIN_D3_SPL__D3_SPL,
 	MX31_PIN_D3_CLS__D3_CLS,
 	MX31_PIN_LCS0__GPI03_23,
+	/* CSI */
+	IOMUX_MODE(MX31_PIN_CSI_D5, IOMUX_CONFIG_GPIO),
+	MX31_PIN_CSI_D6__CSI_D6,
+	MX31_PIN_CSI_D7__CSI_D7,
+	MX31_PIN_CSI_D8__CSI_D8,
+	MX31_PIN_CSI_D9__CSI_D9,
+	MX31_PIN_CSI_D10__CSI_D10,
+	MX31_PIN_CSI_D11__CSI_D11,
+	MX31_PIN_CSI_D12__CSI_D12,
+	MX31_PIN_CSI_D13__CSI_D13,
+	MX31_PIN_CSI_D14__CSI_D14,
+	MX31_PIN_CSI_D15__CSI_D15,
+	MX31_PIN_CSI_HSYNC__CSI_HSYNC,
+	MX31_PIN_CSI_MCLK__CSI_MCLK,
+	MX31_PIN_CSI_PIXCLK__CSI_PIXCLK,
+	MX31_PIN_CSI_VSYNC__CSI_VSYNC,
 };
 
 static struct physmap_flash_data pcm037_flash_data = {
@@ -250,19 +269,43 @@ static struct mxc_nand_platform_data pcm037_nand_board_info = {
 	.hw_ecc = 1,
 };
 
-#ifdef CONFIG_I2C_IMX
 static struct imxi2c_platform_data pcm037_i2c_1_data = {
 	.bitrate = 100000,
 };
 
+static struct imxi2c_platform_data pcm037_i2c_2_data = {
+	.bitrate = 20000,
+};
+
 static struct at24_platform_data board_eeprom = {
 	.byte_len = 4096,
 	.page_size = 32,
 	.flags = AT24_FLAG_ADDR16,
 };
 
+static int pcm037_camera_power(struct device *dev, int on)
+{
+	/* disable or enable the camera in X7 or X8 PCM970 connector */
+	gpio_set_value(IOMUX_TO_GPIO(MX31_PIN_CSI_D5), !on);
+	return 0;
+}
+
+static struct i2c_board_info pcm037_i2c_2_devices[] = {
+	{
+		I2C_BOARD_INFO("mt9t031", 0x5d),
+	},
+};
+
+static struct soc_camera_link iclink = {
+	.bus_id		= 0,		/* Must match with the camera ID */
+	.power		= pcm037_camera_power,
+	.board_info	= &pcm037_i2c_2_devices[0],
+	.i2c_adapter_id	= 2,
+	.module_name	= "mt9t031",
+};
+
 static struct i2c_board_info pcm037_i2c_devices[] = {
-       {
+	{
 		I2C_BOARD_INFO("at24", 0x52), /* E0=0, E1=1, E2=0 */
 		.platform_data = &board_eeprom,
 	}, {
@@ -270,7 +313,14 @@ static struct i2c_board_info pcm037_i2c_devices[] = {
 		.type = "pcf8563",
 	}
 };
-#endif
+
+static struct platform_device pcm037_camera = {
+	.name	= "soc-camera-pdrv",
+	.id	= 0,
+	.dev	= {
+		.platform_data = &iclink,
+	},
+};
 
 /* Not connected by default */
 #ifdef PCM970_SDHC_RW_SWITCH
@@ -334,9 +384,41 @@ static struct imxmmc_platform_data sdhc_pdata = {
 	.exit = pcm970_sdhc1_exit,
 };
 
+struct mx3_camera_pdata camera_pdata = {
+	.dma_dev	= &mx3_ipu.dev,
+	.flags		= MX3_CAMERA_DATAWIDTH_8 | MX3_CAMERA_DATAWIDTH_10,
+	.mclk_10khz	= 2000,
+};
+
+static int __init pcm037_camera_alloc_dma(const size_t buf_size)
+{
+	dma_addr_t dma_handle;
+	void *buf;
+	int dma;
+
+	if (buf_size < 2 * 1024 * 1024)
+		return -EINVAL;
+
+	buf = dma_alloc_coherent(NULL, buf_size, &dma_handle, GFP_KERNEL);
+	if (!buf) {
+		pr_err("%s: cannot allocate camera buffer-memory\n", __func__);
+		return -ENOMEM;
+	}
+
+	memset(buf, 0, buf_size);
+
+	dma = dma_declare_coherent_memory(&mx3_camera.dev,
+					dma_handle, dma_handle, buf_size,
+					DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE);
+
+	/* The way we call dma_declare_coherent_memory only a malloc can fail */
+	return dma & DMA_MEMORY_MAP ? 0 : -ENOMEM;
+}
+
 static struct platform_device *devices[] __initdata = {
 	&pcm037_flash,
 	&pcm037_sram_device,
+	&pcm037_camera,
 };
 
 static struct ipu_platform_data mx3_ipu_data = {
@@ -414,19 +496,26 @@ static void __init mxc_board_init(void)
 		platform_device_register(&pcm037_eth);
 	}
 
-
-#ifdef CONFIG_I2C_IMX
+	/* I2C adapters and devices */
 	i2c_register_board_info(1, pcm037_i2c_devices,
 			ARRAY_SIZE(pcm037_i2c_devices));
 
 	mxc_register_device(&mxc_i2c_device1, &pcm037_i2c_1_data);
-#endif
+	mxc_register_device(&mxc_i2c_device2, &pcm037_i2c_2_data);
+
 	mxc_register_device(&mxc_nand_device, &pcm037_nand_board_info);
 	mxc_register_device(&mxcsdhc_device0, &sdhc_pdata);
 	mxc_register_device(&mx3_ipu, &mx3_ipu_data);
 	mxc_register_device(&mx3_fb, &mx3fb_pdata);
 	if (!gpio_usbotg_hs_activate())
 		mxc_register_device(&mxc_otg_udc_device, &usb_pdata);
+
+	/* CSI */
+	/* Camera power: default - off */
+	gpio_direction_output(IOMUX_TO_GPIO(MX31_PIN_CSI_D5), 1);
+
+	if (!pcm037_camera_alloc_dma(4 * 1024 * 1024))
+		mxc_register_device(&mx3_camera, &camera_pdata);
 }
 
 static void __init pcm037_timer_init(void)
diff --git a/arch/arm/plat-mxc/include/mach/iomux-mx3.h b/arch/arm/plat-mxc/include/mach/iomux-mx3.h
index 27f8d1b..2eb182f 100644
--- a/arch/arm/plat-mxc/include/mach/iomux-mx3.h
+++ b/arch/arm/plat-mxc/include/mach/iomux-mx3.h
@@ -602,6 +602,8 @@ enum iomux_pins {
 #define MX31_PIN_I2C_DAT__SDA		IOMUX_MODE(MX31_PIN_I2C_DAT, IOMUX_CONFIG_FUNC)
 #define MX31_PIN_DCD_DTE1__I2C2_SDA	IOMUX_MODE(MX31_PIN_DCD_DTE1, IOMUX_CONFIG_ALT2)
 #define MX31_PIN_RI_DTE1__I2C2_SCL	IOMUX_MODE(MX31_PIN_RI_DTE1, IOMUX_CONFIG_ALT2)
+#define MX31_PIN_CSPI2_SS2__I2C3_SDA	IOMUX_MODE(MX31_PIN_CSPI2_SS2, IOMUX_CONFIG_ALT1)
+#define MX31_PIN_CSPI2_SCLK__I2C3_SCL	IOMUX_MODE(MX31_PIN_CSPI2_SCLK, IOMUX_CONFIG_ALT1)
 #define MX31_PIN_CSI_D4__CSI_D4		IOMUX_MODE(MX31_PIN_CSI_D4, IOMUX_CONFIG_FUNC)
 #define MX31_PIN_CSI_D5__CSI_D5		IOMUX_MODE(MX31_PIN_CSI_D5, IOMUX_CONFIG_FUNC)
 #define MX31_PIN_CSI_D6__CSI_D6		IOMUX_MODE(MX31_PIN_CSI_D6, IOMUX_CONFIG_FUNC)
-- 
1.6.2.4

