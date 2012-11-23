Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:45979 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753362Ab2KWNeq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 08:34:46 -0500
From: Albert Wang <twang13@marvell.com>
To: corbet@lwn.net, g.liakhovetski@gmx.de
Cc: linux-media@vger.kernel.org, Albert Wang <twang13@marvell.com>,
	Libin Yang <lbyang@marvell.com>
Subject: [PATCH 12/15] [media] marvell-ccic: add soc_camera support in mmp driver
Date: Fri, 23 Nov 2012 21:34:26 +0800
Message-Id: <1353677666-24361-1-git-send-email-twang13@marvell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds the soc_camera support in the platform driver: mmp-driver.c.
Specified board driver also should be modified to support soc_camera by passing
some platform datas to platform driver.

Currently the soc_camera mode in mmp driver only supports B_DMA_contig mode.

Signed-off-by: Libin Yang <lbyang@marvell.com>
Signed-off-by: Albert Wang <twang13@marvell.com>
---
 drivers/media/platform/Makefile                  |    4 +-
 drivers/media/platform/marvell-ccic/Kconfig      |   22 ++++++
 drivers/media/platform/marvell-ccic/mmp-driver.c |   80 +++++++++++++++++++---
 include/media/mmp-camera.h                       |    2 +
 4 files changed, 97 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index baaa550..feae003 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -11,8 +11,8 @@ obj-$(CONFIG_VIDEO_TIMBERDALE)	+= timblogiw.o
 obj-$(CONFIG_VIDEO_M32R_AR_M64278) += arv.o
 
 obj-$(CONFIG_VIDEO_VIA_CAMERA) += via-camera.o
-obj-$(CONFIG_VIDEO_CAFE_CCIC) += marvell-ccic/
-obj-$(CONFIG_VIDEO_MMP_CAMERA) += marvell-ccic/
+
+obj-$(CONFIG_VIDEO_MARVELL_CCIC)       += marvell-ccic/
 
 obj-$(CONFIG_VIDEO_OMAP2)		+= omap2cam.o
 obj-$(CONFIG_VIDEO_OMAP3)	+= omap3isp/
diff --git a/drivers/media/platform/marvell-ccic/Kconfig b/drivers/media/platform/marvell-ccic/Kconfig
index bf739e3..6e3eaa0 100755
--- a/drivers/media/platform/marvell-ccic/Kconfig
+++ b/drivers/media/platform/marvell-ccic/Kconfig
@@ -1,23 +1,45 @@
+config VIDEO_MARVELL_CCIC
+       tristate
+config VIDEO_MRVL_SOC_CAMERA
+       tristate
+
 config VIDEO_CAFE_CCIC
 	tristate "Marvell 88ALP01 (Cafe) CMOS Camera Controller support"
 	depends on PCI && I2C && VIDEO_V4L2
 	select VIDEO_OV7670
 	select VIDEOBUF2_VMALLOC
 	select VIDEOBUF2_DMA_CONTIG
+	select VIDEO_MARVELL_CCIC
 	---help---
 	  This is a video4linux2 driver for the Marvell 88ALP01 integrated
 	  CMOS camera controller.  This is the controller found on first-
 	  generation OLPC systems.
 
+choice
+	prompt "Camera support on Marvell MMP"
+	depends on ARCH_MMP && VIDEO_V4L2
+	optional
 config VIDEO_MMP_CAMERA
 	tristate "Marvell Armada 610 integrated camera controller support"
 	depends on ARCH_MMP && I2C && VIDEO_V4L2
 	select VIDEO_OV7670
 	select I2C_GPIO
 	select VIDEOBUF2_DMA_SG
+	select VIDEO_MARVELL_CCIC
 	---help---
 	  This is a Video4Linux2 driver for the integrated camera
 	  controller found on Marvell Armada 610 application
 	  processors (and likely beyond).  This is the controller found
 	  in OLPC XO 1.75 systems.
 
+config VIDEO_MMP_SOC_CAMERA
+	bool "Marvell MMP camera driver based on SOC_CAMERA"
+	depends on VIDEO_DEV && SOC_CAMERA && ARCH_MMP && VIDEO_V4L2
+	select VIDEOBUF2_DMA_CONTIG
+	select VIDEO_MARVELL_CCIC
+	select VIDEO_MRVL_SOC_CAMERA
+	---help---
+	  This is a Video4Linux2 driver for the Marvell Mobile Soc
+	  PXA910/PXA688/PXA2128/PXA988 CCIC
+	  (CMOS Camera Interface Controller)
+endchoice
diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c b/drivers/media/platform/marvell-ccic/mmp-driver.c
index c3031e7..bea7224 100755
--- a/drivers/media/platform/marvell-ccic/mmp-driver.c
+++ b/drivers/media/platform/marvell-ccic/mmp-driver.c
@@ -4,6 +4,12 @@
  *
  * Copyright 2011 Jonathan Corbet <corbet@lwn.net>
  *
+ * History:
+ * Support Soc Camera
+ * Support MIPI interface and Dual CCICs in Soc Camera mode
+ * Sep-2012: Libin Yang <lbyang@marvell.com>
+ *           Albert Wang <twang13@marvell.com>
+ *
  * This file may be distributed under the terms of the GNU General
  * Public License, version 2.
  */
@@ -28,6 +34,10 @@
 #include <linux/list.h>
 #include <linux/pm.h>
 #include <linux/clk.h>
+#include <linux/regulator/consumer.h>
+#include <media/videobuf2-dma-contig.h>
+#include <media/soc_camera.h>
+#include <media/soc_mediabus.h>
 
 #include "mcam-core.h"
 
@@ -40,6 +50,8 @@ struct mmp_camera {
 	struct platform_device *pdev;
 	struct mcam_camera mcam;
 	struct list_head devlist;
+	/* will change here */
+	struct clk *clk[3];	/* CCIC_GATE, CCIC_RST, CCIC_DBG clocks */
 	int irq;
 };
 
@@ -135,7 +147,9 @@ static void mmpcam_power_up_ctlr(struct mmp_camera *cam)
 static void mmpcam_power_up(struct mcam_camera *mcam)
 {
 	struct mmp_camera *cam = mcam_to_cam(mcam);
+#ifndef CONFIG_VIDEO_MMP_SOC_CAMERA
 	struct mmp_camera_platform_data *pdata;
+#endif
 /*
  * Turn on power and clocks to the controller.
  */
@@ -144,34 +158,40 @@ static void mmpcam_power_up(struct mcam_camera *mcam)
  * Provide power to the sensor.
  */
 	mcam_reg_write(mcam, REG_CLKCTRL, 0x60000002);
+#ifndef CONFIG_VIDEO_MMP_SOC_CAMERA
 	pdata = cam->pdev->dev.platform_data;
 	gpio_set_value(pdata->sensor_power_gpio, 1);
 	mdelay(5);
+#endif
 	mcam_reg_clear_bit(mcam, REG_CTRL1, 0x10000000);
+#ifndef CONFIG_VIDEO_MMP_SOC_CAMERA
 	gpio_set_value(pdata->sensor_reset_gpio, 0); /* reset is active low */
 	mdelay(5);
 	gpio_set_value(pdata->sensor_reset_gpio, 1); /* reset is active low */
 	mdelay(5);
-
+#endif
 	mcam_clk_set(mcam, 1);
 }
 
 static void mmpcam_power_down(struct mcam_camera *mcam)
 {
 	struct mmp_camera *cam = mcam_to_cam(mcam);
+#ifndef CONFIG_VIDEO_MMP_SOC_CAMERA
 	struct mmp_camera_platform_data *pdata;
+#endif
 /*
  * Turn off clocks and set reset lines
  */
 	iowrite32(0, cam->power_regs + REG_CCIC_DCGCR);
 	iowrite32(0, cam->power_regs + REG_CCIC_CRCR);
+#ifndef CONFIG_VIDEO_MMP_SOC_CAMERA
 /*
  * Shut down the sensor.
  */
 	pdata = cam->pdev->dev.platform_data;
 	gpio_set_value(pdata->sensor_power_gpio, 0);
 	gpio_set_value(pdata->sensor_reset_gpio, 0);
-
+#endif
 	mcam_clk_set(mcam, 0);
 }
 
@@ -322,20 +342,31 @@ static int mmpcam_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&cam->devlist);
 
 	mcam = &cam->mcam;
+	spin_lock_init(&mcam->dev_lock);
 	mcam->plat_power_up = mmpcam_power_up;
 	mcam->plat_power_down = mmpcam_power_down;
 	mcam->ctlr_reset = mcam_ctlr_reset;
 	mcam->calc_dphy = mmpcam_calc_dphy;
 	mcam->dev = &pdev->dev;
 	mcam->use_smbus = 0;
+	mcam->card_name = pdata->name;
+	mcam->mclk_min = pdata->mclk_min;
+	mcam->mclk_src = pdata->mclk_src;
+	mcam->mclk_div = pdata->mclk_div;
+#ifdef CONFIG_VIDEO_MMP_SOC_CAMERA
+	mcam->chip_id = pdata->chip_id;
+	mcam->buffer_mode = B_DMA_contig;
+#else
+	mcam->chip_id = V4L2_IDENT_ARMADA610;
+	mcam->buffer_mode = B_DMA_sg;
+#endif
 	mcam->ccic_id = pdev->id;
 	mcam->bus_type = pdata->bus_type;
 	mcam->dphy = &(pdata->dphy);
 	mcam->mipi_enabled = 0;
 	mcam->lane = pdata->lane;
-	mcam->chip_id = V4L2_IDENT_ARMADA610;
-	mcam->buffer_mode = B_DMA_sg;
-	spin_lock_init(&mcam->dev_lock);
+	INIT_LIST_HEAD(&mcam->buffers);
+
 	/*
 	 * Get our I/O memory.
 	 */
@@ -365,9 +396,22 @@ static int mmpcam_probe(struct platform_device *pdev)
 	}
 
 	mcam_init_clk(mcam, pdata, 1);
+#ifdef CONFIG_VIDEO_MMP_SOC_CAMERA
+	mcam->vb_alloc_ctx =
+		vb2_dma_contig_init_ctx(&pdev->dev);
+	if (IS_ERR(mcam->vb_alloc_ctx))
+		return PTR_ERR(mcam->vb_alloc_ctx);
+
+	ret = mcam_soc_camera_host_register(mcam);
+	if (ret)
+		goto out_free_ctx;
+#endif
+
+#ifdef CONFIG_VIDEO_MMP_CAMERA
 	/*
 	 * Find the i2c adapter.  This assumes, of course, that the
 	 * i2c bus is already up and functioning.
+	 * soc-camera manages i2c interface in sensor side
 	 */
 	mcam->i2c_adapter = platform_get_drvdata(pdata->i2c_device);
 	if (mcam->i2c_adapter == NULL) {
@@ -396,9 +440,10 @@ static int mmpcam_probe(struct platform_device *pdev)
 	 * Power the device up and hand it off to the core.
 	 */
 	mmpcam_power_up(mcam);
+#endif
 	ret = mccic_register(mcam);
 	if (ret)
-		goto out_gpio2;
+		goto ccic_register_fail;
 	/*
 	 * Finally, set up our IRQ now that the core is ready to
 	 * deal with it.
@@ -418,12 +463,21 @@ static int mmpcam_probe(struct platform_device *pdev)
 
 out_unregister:
 	mccic_shutdown(mcam);
-out_gpio2:
+ccic_register_fail:
+#ifdef CONFIG_VIDEO_MMP_CAMERA
 	mmpcam_power_down(mcam);
+	mcam_init_clk(mcam, pdata, 0);
 	gpio_free(pdata->sensor_reset_gpio);
 out_gpio:
 	gpio_free(pdata->sensor_power_gpio);
+#endif
+#ifdef CONFIG_VIDEO_MMP_SOC_CAMERA
+	soc_camera_host_unregister(&mcam->soc_host);
 	mcam_init_clk(mcam, pdata, 0);
+out_free_ctx:
+	vb2_dma_contig_cleanup_ctx(mcam->vb_alloc_ctx);
+	mcam->vb_alloc_ctx = NULL;
+#endif
 	return ret;
 }
 
@@ -431,14 +485,22 @@ out_gpio:
 static int mmpcam_remove(struct mmp_camera *cam)
 {
 	struct mcam_camera *mcam = &cam->mcam;
-	struct mmp_camera_platform_data *pdata;
+#ifdef CONFIG_VIDEO_MMP_SOC_CAMERA
+	struct soc_camera_host *soc_host = &mcam->soc_host;
+#endif
+	struct mmp_camera_platform_data *pdata = cam->pdev->dev.platform_data;
 
 	mmpcam_remove_device(cam);
 	mccic_shutdown(mcam);
 	mmpcam_power_down(mcam);
-	pdata = cam->pdev->dev.platform_data;
+#ifdef CONFIG_VIDEO_MMP_SOC_CAMERA
+	soc_camera_host_unregister(soc_host);
+	vb2_dma_contig_cleanup_ctx(mcam->vb_alloc_ctx);
+	mcam->vb_alloc_ctx = NULL;
+#else
 	gpio_free(pdata->sensor_reset_gpio);
 	gpio_free(pdata->sensor_power_gpio);
+#endif
 	mcam_init_clk(mcam, pdata, 0);
 	return 0;
 }
diff --git a/include/media/mmp-camera.h b/include/media/mmp-camera.h
index 36891ed..731f81f 100755
--- a/include/media/mmp-camera.h
+++ b/include/media/mmp-camera.h
@@ -6,9 +6,11 @@ struct mmp_camera_platform_data {
 	struct platform_device *i2c_device;
 	int sensor_power_gpio;
 	int sensor_reset_gpio;
+	char name[16];
 	int mclk_min;
 	int mclk_src;
 	int mclk_div;
+	int chip_id;
 	/*
 	 * MIPI support
 	 */
-- 
1.7.9.5

