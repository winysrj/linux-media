Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mABGvRvJ000532
	for <video4linux-list@redhat.com>; Tue, 11 Nov 2008 11:57:27 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mABGumjm002662
	for <video4linux-list@redhat.com>; Tue, 11 Nov 2008 11:56:49 -0500
Date: Tue, 11 Nov 2008 17:57:01 +0100 (CET)
From: Guennadi Liakhovetski <lg@denx.de>
To: video4linux-list@redhat.com
In-Reply-To: <Pine.LNX.4.64.0811111738010.4565@axis700.grange>
Message-ID: <Pine.LNX.4.64.0811111747200.4565@axis700.grange>
References: <Pine.LNX.4.64.0811111738010.4565@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: 
Subject: [PATCH 3/3] soc-camera: board bindings for camera host driver for
 i.MX3x SoCs
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

The driver has been tested on a pcm037 test-board from Phycore. The driver 
uses a coherent memory buffer, because although i.MX31 supports video to 
scatter-gather lists, it can only pack an integer number of rows in an 
sg-buffer, which makes it useless with fixed size sg-elements, and 
videobuf-dma-sg.c uses fixed page-sized buffers. Therefore we have to 
increase CONSISTENT_DMA_SIZE. I also increase the GPIO number range for 
external GPIO expanders. This patch also adds the necessary i2c-data to 
pcm037.c.

Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
---
diff --git a/arch/arm/mach-mx3/pcm037.c b/arch/arm/mach-mx3/pcm037.c
index d428a7d..099853e 100644
--- a/arch/arm/mach-mx3/pcm037.c
+++ b/arch/arm/mach-mx3/pcm037.c
@@ -22,9 +22,14 @@
 #include <linux/platform_device.h>
 #include <linux/mtd/physmap.h>
 #include <linux/memory.h>
+#include <linux/i2c.h>
+#include <linux/i2c/pca953x.h>
 #include <linux/interrupt.h>
 #include <linux/gpio.h>
 #include <linux/smc911x.h>
+#include <linux/dma-mapping.h>
+
+#include <media/soc_camera.h>
 
 #include <mach/hardware.h>
 #include <asm/mach-types.h>
@@ -32,9 +37,11 @@
 #include <asm/mach/time.h>
 #include <asm/mach/map.h>
 #include <mach/common.h>
+#include <mach/i2c.h>
 #include <mach/imx-uart.h>
 #include <mach/iomux-mx3.h>
 #include <mach/board-pcm037.h>
+#include <mach/mx3_camera.h>
 
 #include "devices.h"
 
@@ -90,9 +97,117 @@ static struct platform_device pcm037_eth = {
 	},
 };
 
+/* I2C bus configuration */
+static struct mxc_i2c_board_data pcm037_i2c_adap[] = {
+	{
+		.data	= {
+			.i2c_clk = 100000,
+		},
+		.id	= 0,
+	}, {
+		.data	= {
+			.i2c_clk = 100000,
+		},
+		.id	= 1,
+	}, {
+		.data	= {
+			/* pcm037 doesn't handle higher frequencies on #3 */
+			.i2c_clk = 20000,
+		},
+		.id	= 2,
+	}
+};
+
+/* Board I2C devices. */
+static struct pca953x_platform_data pca9536_data = {
+	.gpio_base	= GPIO_NUM_PIN * GPIO_PORT_NUM + 1,
+};
+
+static struct soc_camera_link iclink[] = {
+	{
+		.bus_id	= 0, /* Must match with the camera ID */
+	}, {
+		.bus_id	= 0, /* Must match with the camera ID */
+		.gpio	= GPIO_NUM_PIN * GPIO_PORT_NUM + 1,
+	},
+};
+
+static struct i2c_board_info __initdata pcm037_i2c_devices[] = {
+	{
+		/* Must initialize before the camera(s) */
+		I2C_BOARD_INFO("pca9536", 0x41),
+		.platform_data = &pca9536_data,
+	}, {
+		I2C_BOARD_INFO("mt9v022", 0x48),
+		.platform_data = &iclink[1], /* With extender */
+	}, {
+		I2C_BOARD_INFO("mt9m001", 0x5d),
+		.platform_data = &iclink[1], /* With extender */
+	},
+};
+
+struct mx3_camera_pdata camera_info = {
+	.flags		= MX3_CAMERA_DATAWIDTH_8 | MX3_CAMERA_DATAWIDTH_10,
+	.mclk_10khz	= 2000,
+};
+
+static struct resource camera_resources[] = {
+	{
+		.start = IPU_CTRL_BASE_ADDR + 0x60,
+		.end = IPU_CTRL_BASE_ADDR + 0x87,
+		.flags = IORESOURCE_MEM,
+	}, {
+		.start = IPU_IRQ_SENSOR_EOF,
+		.end = IPU_IRQ_SENSOR_EOF,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device pcm037_camera = {
+	.name		= "mx3-camera",
+	.id		= 0,
+	.num_resources	= ARRAY_SIZE(camera_resources),
+	.resource	= camera_resources,
+	.dev		= {
+		.platform_data		= &camera_info,
+		.coherent_dma_mask	= DMA_32BIT_MASK,
+	},
+};
+
+/*
+ * Try to allocate buffer space enough for 8 buffers 320x240@2 for
+ * streaming plus 1 buffer 640x480@2 for still image < 2MB
+ */
+#define PCM037_CAMERA_MEM_SIZE	2 * 1024 * 1024
+
+/* Shall be called after the pcm037_camera platform device is registered */
+static __init int pcm037_camera_alloc(void)
+{
+	dma_addr_t dma_handle;
+	void *buf;
+
+	buf = dma_alloc_coherent(NULL, PCM037_CAMERA_MEM_SIZE, &dma_handle,
+				 GFP_KERNEL);
+	if (!buf) {
+		pr_warning("pcm037: cannot allocate camera buffer-memory\n");
+		return -ENOMEM;
+	}
+
+	memset(buf, 0, PCM037_CAMERA_MEM_SIZE);
+
+	dma_declare_coherent_memory(&pcm037_camera.dev,
+				    dma_handle, dma_handle,
+				    PCM037_CAMERA_MEM_SIZE,
+				    DMA_MEMORY_MAP |
+				    DMA_MEMORY_EXCLUSIVE);
+
+	return 0;
+}
+
 static struct platform_device *devices[] __initdata = {
 	&pcm037_flash,
 	&pcm037_eth,
+	&pcm037_camera,
 };
 
 /*
@@ -100,7 +215,10 @@ static struct platform_device *devices[] __initdata = {
  */
 static void __init mxc_board_init(void)
 {
+	int ret;
+
 	platform_add_devices(devices, ARRAY_SIZE(devices));
+	pcm037_camera_alloc();
 
 	mxc_iomux_mode(MX31_PIN_CTS1__CTS1);
 	mxc_iomux_mode(MX31_PIN_RTS1__RTS1);
@@ -119,6 +237,13 @@ static void __init mxc_board_init(void)
 	if (!gpio_request(MX31_PIN_GPIO3_1, "pcm037-eth"))
 		gpio_direction_input(MX31_PIN_GPIO3_1);
 
+	/* I2C */
+	mxc_i2c_register_adapters(pcm037_i2c_adap, ARRAY_SIZE(pcm037_i2c_adap));
+
+	/* Camera*/
+	i2c_register_board_info(2, pcm037_i2c_devices,
+				ARRAY_SIZE(pcm037_i2c_devices));
+
 	/* Display Interface #3 */
 	mxc_iomux_mode(IOMUX_MODE(MX31_PIN_LD0, IOMUX_CONFIG_FUNC));
 	mxc_iomux_mode(IOMUX_MODE(MX31_PIN_LD1, IOMUX_CONFIG_FUNC));
@@ -146,6 +271,39 @@ static void __init mxc_board_init(void)
 	mxc_iomux_mode(IOMUX_MODE(MX31_PIN_CONTRAST, IOMUX_CONFIG_FUNC));
 	mxc_iomux_mode(IOMUX_MODE(MX31_PIN_D3_SPL, IOMUX_CONFIG_FUNC));
 	mxc_iomux_mode(IOMUX_MODE(MX31_PIN_D3_CLS, IOMUX_CONFIG_FUNC));
+
+	/* CSI */
+	mxc_iomux_mode(IOMUX_MODE(MX31_PIN_CSI_D6, IOMUX_CONFIG_FUNC));
+	mxc_iomux_mode(IOMUX_MODE(MX31_PIN_CSI_D7, IOMUX_CONFIG_FUNC));
+	mxc_iomux_mode(IOMUX_MODE(MX31_PIN_CSI_D8, IOMUX_CONFIG_FUNC));
+	mxc_iomux_mode(IOMUX_MODE(MX31_PIN_CSI_D9, IOMUX_CONFIG_FUNC));
+	mxc_iomux_mode(IOMUX_MODE(MX31_PIN_CSI_D10, IOMUX_CONFIG_FUNC));
+	mxc_iomux_mode(IOMUX_MODE(MX31_PIN_CSI_D11, IOMUX_CONFIG_FUNC));
+	mxc_iomux_mode(IOMUX_MODE(MX31_PIN_CSI_D12, IOMUX_CONFIG_FUNC));
+	mxc_iomux_mode(IOMUX_MODE(MX31_PIN_CSI_D13, IOMUX_CONFIG_FUNC));
+	mxc_iomux_mode(IOMUX_MODE(MX31_PIN_CSI_D14, IOMUX_CONFIG_FUNC));
+	mxc_iomux_mode(IOMUX_MODE(MX31_PIN_CSI_D15, IOMUX_CONFIG_FUNC));
+	mxc_iomux_mode(IOMUX_MODE(MX31_PIN_CSI_HSYNC, IOMUX_CONFIG_FUNC));
+	mxc_iomux_mode(IOMUX_MODE(MX31_PIN_CSI_MCLK, IOMUX_CONFIG_FUNC));
+	mxc_iomux_mode(IOMUX_MODE(MX31_PIN_CSI_PIXCLK, IOMUX_CONFIG_FUNC));
+	mxc_iomux_mode(IOMUX_MODE(MX31_PIN_CSI_VSYNC, IOMUX_CONFIG_FUNC));
+
+	/* ATA power off, disable ATA Buffer, enable CSI buffer  */
+	ret = gpio_request(IOMUX_TO_GPIO(MX31_PIN_CSI_D4), "CSI D4");
+	if (!ret) {
+		mxc_iomux_mode(IOMUX_MODE(MX31_PIN_CSI_D4, IOMUX_CONFIG_GPIO));
+		gpio_direction_output(IOMUX_TO_GPIO(MX31_PIN_CSI_D4), 0);
+	} else
+		printk(KERN_WARNING "Could not get GPIO %u\n",
+		       IOMUX_TO_GPIO(MX31_PIN_CSI_D4));
+
+	ret = gpio_request(IOMUX_TO_GPIO(MX31_PIN_CSI_D5), "CSI D5");
+	if (!ret) {
+		mxc_iomux_mode(IOMUX_MODE(MX31_PIN_CSI_D5, IOMUX_CONFIG_GPIO));
+		gpio_direction_output(IOMUX_TO_GPIO(MX31_PIN_CSI_D5), 1);
+	} else
+		printk(KERN_WARNING "Could not get GPIO %u\n",
+		       IOMUX_TO_GPIO(MX31_PIN_CSI_D5));
 }
 
 /*
diff --git a/arch/arm/plat-mxc/include/mach/memory.h b/arch/arm/plat-mxc/include/mach/memory.h
index d7a8d3e..13f00f0 100644
--- a/arch/arm/plat-mxc/include/mach/memory.h
+++ b/arch/arm/plat-mxc/include/mach/memory.h
@@ -13,6 +13,9 @@
 
 #include <mach/hardware.h>
 
+/* We allocate 2MB for the camera driver video buffers */
+#define CONSISTENT_DMA_SIZE SZ_4M
+
 /*
  * Virtual view <-> DMA view memory address translations
  * This macro is used to translate the virtual address to an address
diff --git a/arch/arm/plat-mxc/include/mach/mx31.h b/arch/arm/plat-mxc/include/mach/mx31.h
index a47f862..0b38be3 100644
--- a/arch/arm/plat-mxc/include/mach/mx31.h
+++ b/arch/arm/plat-mxc/include/mach/mx31.h
@@ -503,8 +503,8 @@
 
 /* Mandatory defines used globally */
 
-/* this CPU supports up to 96 GPIOs */
-#define ARCH_NR_GPIOS		96
+/* this CPU supports up to 96 GPIOs, add 32 more for expanders */
+#define ARCH_NR_GPIOS		(GPIO_NUM_PIN * GPIO_PORT_NUM + 32)
 
 #if !defined(__ASSEMBLY__) && !defined(__MXC_BOOT_UNCOMPRESS)
 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
