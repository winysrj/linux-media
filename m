Return-path: <mchehab@pedra>
Received: from d1.icnet.pl ([212.160.220.21]:37449 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754544Ab0I0BDe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Sep 2010 21:03:34 -0400
To: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: [PATCH v3] OMAP1: Add support for SoC camera interface
Cc: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Tony Lindgren <tony@atomide.com>,
	"Discussion of the Amstrad E3 emailer hardware/software"
	<e3-hacking@earth.li>
Content-Disposition: inline
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Date: Mon, 27 Sep 2010 03:02:27 +0200
Message-Id: <201009270302.28655.jkrzyszt@tis.icnet.pl>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch adds a definition of the OMAP1 camera interface platform device, 
and a function that allows for providing a board specific platform data. 
The device will be used with the upcoming OMAP1 SoC camera interface driver.

Created and tested against linux-2.6.36-rc5 on Amstrad Delta.

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
---

Tony,
I hope this now satisfies your requirements.

I resubmit only this updated patch, not the other two, Amstrad Delta specific, 
which you have alredy applied. Those are still valid (work for me), only the 
not yet merged include/media/omap1_camera.h header file is required for 
successfull compilation of board-ams-delta.c. I hope this is not a problem.

I'll submit the driver for Guennadi to push it via the media tree soon.


v2->v3 changes:

requested or inspired by Tony Lindgren (thanks!):
- don't #include <mach/camera.h> into devices.c in order to allow for 
  successfull compilation while the camera.h still includes a not yet merged 
  <media/omap1_camera.h>,
- move the OMAP1_CAMERA_IOSIZE macro defintion from camera.h to devices.c,
- to remove any remaining <mach/camera.h> or <media/omap1_camera.h> 
  dependencies from devices.c, replace the struct omap1_cam_platform_data * 
  argument type with a void *, and provide an inline wrapper function in 
  camera.h that converts back from void * to struct omap1_cam_platform_data *,

suggested by Guennadi Liakhovetski (thanks!):
- try groupping headers according to their location and keeping them sorted 
  alphabeticaly,
- drop "extern" qualifier from fuction declaration,


v1->v2 changes:
- no functional changes,
- refreshed against linux-2.6.36-rc3


 arch/arm/mach-omap1/devices.c             |   43 ++++++++++++++++++++++++++++++
 arch/arm/mach-omap1/include/mach/camera.h |   13 +++++++++
 2 files changed, 56 insertions(+)


diff -upr linux-2.6.36-rc5.orig/arch/arm/mach-omap1/devices.c linux-2.6.36-rc5/arch/arm/mach-omap1/devices.c
--- linux-2.6.36-rc5.orig/arch/arm/mach-omap1/devices.c	2010-09-24 15:34:27.000000000 +0200
+++ linux-2.6.36-rc5/arch/arm/mach-omap1/devices.c	2010-09-25 03:47:55.000000000 +0200
@@ -9,6 +9,7 @@
  * (at your option) any later version.
  */
 
+#include <linux/dma-mapping.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
@@ -191,6 +192,48 @@ static inline void omap_init_spi100k(voi
 }
 #endif
 
+
+#define OMAP1_CAMERA_BASE	0xfffb6800
+#define OMAP1_CAMERA_IOSIZE	0x1c
+
+static struct resource omap1_camera_resources[] = {
+	[0] = {
+		.start	= OMAP1_CAMERA_BASE,
+		.end	= OMAP1_CAMERA_BASE + OMAP1_CAMERA_IOSIZE - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= INT_CAMERA,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static u64 omap1_camera_dma_mask = DMA_BIT_MASK(32);
+
+static struct platform_device omap1_camera_device = {
+	.name		= "omap1-camera",
+	.id		= 0, /* This is used to put cameras on this interface */
+	.dev		= {
+		.dma_mask		= &omap1_camera_dma_mask,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
+	},
+	.num_resources	= ARRAY_SIZE(omap1_camera_resources),
+	.resource	= omap1_camera_resources,
+};
+
+void __init omap1_camera_init(void *info)
+{
+	struct platform_device *dev = &omap1_camera_device;
+	int ret;
+
+	dev->dev.platform_data = info;
+
+	ret = platform_device_register(dev);
+	if (ret)
+		dev_err(&dev->dev, "unable to register device: %d\n", ret);
+}
+
+
 /*-------------------------------------------------------------------------*/
 
 static inline void omap_init_sti(void) {}
diff -upr linux-2.6.36-rc5.orig/arch/arm/mach-omap1/include/mach/camera.h linux-2.6.36-rc5/arch/arm/mach-omap1/include/mach/camera.h
--- linux-2.6.36-rc5.orig/arch/arm/mach-omap1/include/mach/camera.h	2010-09-24 15:39:07.000000000 +0200
+++ linux-2.6.36-rc5/arch/arm/mach-omap1/include/mach/camera.h	2010-09-25 03:19:12.000000000 +0200
@@ -0,0 +1,13 @@
+#ifndef __ASM_ARCH_CAMERA_H_
+#define __ASM_ARCH_CAMERA_H_
+
+#include <media/omap1_camera.h>
+
+void omap1_camera_init(void *);
+
+static inline void omap1_set_camera_info(struct omap1_cam_platform_data *info)
+{
+	omap1_camera_init(info);
+}
+
+#endif /* __ASM_ARCH_CAMERA_H_ */


