Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBNBZTeL028393
	for <video4linux-list@redhat.com>; Tue, 23 Dec 2008 06:35:29 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mBNBZCp4019659
	for <video4linux-list@redhat.com>; Tue, 23 Dec 2008 06:35:13 -0500
Date: Tue, 23 Dec 2008 12:35:20 +0100 (CET)
From: Guennadi Liakhovetski <lg@denx.de>
To: video4linux-list@redhat.com
In-Reply-To: <Pine.LNX.4.64.0812231225520.5188@axis700.grange>
Message-ID: <Pine.LNX.4.64.0812231232500.5188@axis700.grange>
References: <Pine.LNX.4.64.0812231225520.5188@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: 
Subject: [PATCH 3/3 v2] soc-camera: board bindings for camera host driver
 for i.MX3x SoCs
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
videobuf-dma-sg.c uses fixed page-sized buffers.

Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
---
 arch/arm/mach-mx3/devices.c                 |   60 +++++++++++++++++++++++++++
 arch/arm/mach-mx3/pcm037.c                  |   46 ++++++++++++++++++++
 arch/arm/plat-mxc/include/mach/mx3_camera.h |    2 +
 3 files changed, 108 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-mx3/devices.c b/arch/arm/mach-mx3/devices.c
index 1654028..40c68ec 100644
--- a/arch/arm/mach-mx3/devices.c
+++ b/arch/arm/mach-mx3/devices.c
@@ -28,6 +28,7 @@
 #include <mach/iomux-mx3.h>
 #include <mach/ipu.h>
 #include <mach/mx3fb.h>
+#include <mach/mx3_camera.h>
 
 static struct resource uart0[] = {
 	{
@@ -237,6 +238,65 @@ int __init mx3_register_fb(const char *name, const struct fb_videomode *modes,
 	return platform_device_register(&mx3_fb);
 }
 
+struct mx3_camera_pdata camera_pdata = {
+	.dma_dev = &mx3_ipu.dev,
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
+static struct platform_device mx3_camera = {
+	.name		= "mx3-camera",
+	.id		= 0,
+	.num_resources	= ARRAY_SIZE(camera_resources),
+	.resource	= camera_resources,
+	.dev		= {
+		.platform_data		= &camera_pdata,
+		.coherent_dma_mask	= DMA_32BIT_MASK,
+	},
+};
+
+int __init mx3_register_camera(size_t buf_size, unsigned long flags,
+			       unsigned long mclk_freq_10khz)
+{
+	dma_addr_t dma_handle;
+	void *buf;
+
+	if (!ipu_registered) {
+		int ret = platform_device_register(&mx3_ipu);
+		if (ret < 0)
+			return ret;
+		ipu_registered = true;
+	}
+
+	buf = dma_alloc_coherent(NULL, buf_size, &dma_handle,
+				 GFP_KERNEL);
+	if (!buf) {
+		pr_err("%s: cannot allocate camera buffer-memory\n", __func__);
+		return -ENOMEM;
+	}
+
+	memset(buf, 0, buf_size);
+
+	dma_declare_coherent_memory(&mx3_camera.dev,
+				    dma_handle, dma_handle, buf_size,
+				    DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE);
+
+	camera_pdata.flags = flags;
+	camera_pdata.mclk_10khz = mclk_freq_10khz;
+
+	return platform_device_register(&mx3_camera);
+}
+
 /* Resource definition for the I2C1 */
 static struct resource mxci2c1_resources[] = {
 	[0] = {
diff --git a/arch/arm/mach-mx3/pcm037.c b/arch/arm/mach-mx3/pcm037.c
index d110b7a..bd40444 100644
--- a/arch/arm/mach-mx3/pcm037.c
+++ b/arch/arm/mach-mx3/pcm037.c
@@ -42,6 +42,7 @@
 #include <mach/iomux-mx3.h>
 #include <mach/board-pcm037.h>
 #include <mach/mx3fb.h>
+#include <mach/mx3_camera.h>
 
 #include "devices.h"
 
@@ -132,6 +133,12 @@ static struct i2c_board_info __initdata pcm037_i2c_devices[] = {
 	},
 };
 
+/*
+ * Try to reserve buffer space enough for 8 buffers 320x240@1 for
+ * streaming plus 2 buffers 2048x1536@1 for still image < 10MB
+ */
+#define PCM037_CAMERA_MEM_SIZE (4 * 1024 * 1024)
+
 static struct platform_device *devices[] __initdata = {
 	&pcm037_flash,
 	&pcm037_eth,
@@ -183,6 +190,8 @@ static const struct fb_videomode fb_modedb[] = {
  */
 static void __init mxc_board_init(void)
 {
+	int ret;
+
 	platform_add_devices(devices, ARRAY_SIZE(devices));
 
 	mxc_iomux_mode(MX31_PIN_CTS1__CTS1);
@@ -238,6 +247,43 @@ static void __init mxc_board_init(void)
 	mxc_iomux_mode(IOMUX_MODE(MX31_PIN_D3_CLS, IOMUX_CONFIG_FUNC));
 
 	mx3_register_fb(fb_modedb[1].name, fb_modedb, ARRAY_SIZE(fb_modedb));
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
+
+	mx3_register_camera(PCM037_CAMERA_MEM_SIZE,
+			    MX3_CAMERA_DATAWIDTH_8 | MX3_CAMERA_DATAWIDTH_10,
+			    2000);
 }
 
 /*
diff --git a/arch/arm/plat-mxc/include/mach/mx3_camera.h b/arch/arm/plat-mxc/include/mach/mx3_camera.h
index 36d7ff2..eddbdc0 100644
--- a/arch/arm/plat-mxc/include/mach/mx3_camera.h
+++ b/arch/arm/plat-mxc/include/mach/mx3_camera.h
@@ -49,4 +49,6 @@ struct mx3_camera_pdata {
 	struct device *dma_dev;
 };
 
+extern int mx3_register_camera(size_t, unsigned long, unsigned long);
+
 #endif
-- 
1.5.4

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
