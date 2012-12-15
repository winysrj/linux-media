Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:33358 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751514Ab2LOKAA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Dec 2012 05:00:00 -0500
From: Albert Wang <twang13@marvell.com>
To: corbet@lwn.net, g.liakhovetski@gmx.de
Cc: linux-media@vger.kernel.org, Albert Wang <twang13@marvell.com>,
	Libin Yang <lbyang@marvell.com>
Subject: [PATCH V3 12/15] [media] marvell-ccic: add soc_camera support in mmp driver
Date: Sat, 15 Dec 2012 17:58:01 +0800
Message-Id: <1355565484-15791-13-git-send-email-twang13@marvell.com>
In-Reply-To: <1355565484-15791-1-git-send-email-twang13@marvell.com>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
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
 drivers/media/platform/marvell-ccic/Kconfig      |   22 ++++
 drivers/media/platform/marvell-ccic/mmp-driver.c |  147 ++++++++++++++--------
 include/media/mmp-camera.h                       |    2 +
 4 files changed, 120 insertions(+), 55 deletions(-)

diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index baaa550..95c1ce5 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -11,8 +11,6 @@ obj-$(CONFIG_VIDEO_TIMBERDALE)	+= timblogiw.o
 obj-$(CONFIG_VIDEO_M32R_AR_M64278) += arv.o
 
 obj-$(CONFIG_VIDEO_VIA_CAMERA) += via-camera.o
-obj-$(CONFIG_VIDEO_CAFE_CCIC) += marvell-ccic/
-obj-$(CONFIG_VIDEO_MMP_CAMERA) += marvell-ccic/
 
 obj-$(CONFIG_VIDEO_OMAP2)		+= omap2cam.o
 obj-$(CONFIG_VIDEO_OMAP3)	+= omap3isp/
@@ -43,6 +41,8 @@ obj-$(CONFIG_VIDEO_SH_VOU)		+= sh_vou.o
 
 obj-$(CONFIG_SOC_CAMERA)		+= soc_camera/
 
+obj-$(CONFIG_VIDEO_MARVELL_CCIC) 	+= marvell-ccic/
+
 obj-y	+= davinci/
 
 obj-$(CONFIG_ARCH_OMAP)	+= omap/
diff --git a/drivers/media/platform/marvell-ccic/Kconfig b/drivers/media/platform/marvell-ccic/Kconfig
index bf739e3..910c068 100755
--- a/drivers/media/platform/marvell-ccic/Kconfig
+++ b/drivers/media/platform/marvell-ccic/Kconfig
@@ -1,23 +1,45 @@
+config VIDEO_MARVELL_CCIC
+       tristate
+config VIDEO_MRVL_SOC_CAMERA
+       bool
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
index 40c243e..cd850f4 100755
--- a/drivers/media/platform/marvell-ccic/mmp-driver.c
+++ b/drivers/media/platform/marvell-ccic/mmp-driver.c
@@ -28,6 +28,10 @@
 #include <linux/list.h>
 #include <linux/pm.h>
 #include <linux/clk.h>
+#include <linux/regulator/consumer.h>
+#include <media/videobuf2-dma-contig.h>
+#include <media/soc_camera.h>
+#include <media/soc_mediabus.h>
 
 #include "mcam-core.h"
 
@@ -40,6 +44,8 @@ struct mmp_camera {
 	struct platform_device *pdev;
 	struct mcam_camera mcam;
 	struct list_head devlist;
+	/* will change here */
+	struct clk *clk[3];	/* CCIC_GATE, CCIC_RST, CCIC_DBG clocks */
 	int irq;
 };
 
@@ -144,15 +150,17 @@ static void mmpcam_power_up(struct mcam_camera *mcam)
  * Provide power to the sensor.
  */
 	mcam_reg_write(mcam, REG_CLKCTRL, 0x60000002);
-	pdata = cam->pdev->dev.platform_data;
-	gpio_set_value(pdata->sensor_power_gpio, 1);
-	mdelay(5);
+	if (mcam->chip_id == V4L2_IDENT_ARMADA610) {
+		pdata = cam->pdev->dev.platform_data;
+		gpio_set_value(pdata->sensor_power_gpio, 1);
+		mdelay(5);
+		/* reset is active low */
+		gpio_set_value(pdata->sensor_reset_gpio, 0);
+		mdelay(5);
+		gpio_set_value(pdata->sensor_reset_gpio, 1);
+		mdelay(5);
+	}
 	mcam_reg_clear_bit(mcam, REG_CTRL1, 0x10000000);
-	gpio_set_value(pdata->sensor_reset_gpio, 0); /* reset is active low */
-	mdelay(5);
-	gpio_set_value(pdata->sensor_reset_gpio, 1); /* reset is active low */
-	mdelay(5);
-
 	mcam_clk_set(mcam, 1);
 }
 
@@ -165,13 +173,14 @@ static void mmpcam_power_down(struct mcam_camera *mcam)
  */
 	iowrite32(0, cam->power_regs + REG_CCIC_DCGCR);
 	iowrite32(0, cam->power_regs + REG_CCIC_CRCR);
-/*
- * Shut down the sensor.
- */
-	pdata = cam->pdev->dev.platform_data;
-	gpio_set_value(pdata->sensor_power_gpio, 0);
-	gpio_set_value(pdata->sensor_reset_gpio, 0);
-
+	if (mcam->chip_id == V4L2_IDENT_ARMADA610) {
+		/*
+		 * Shut down the sensor.
+		 */
+		pdata = cam->pdev->dev.platform_data;
+		gpio_set_value(pdata->sensor_power_gpio, 0);
+		gpio_set_value(pdata->sensor_reset_gpio, 0);
+	}
 	mcam_clk_set(mcam, 0);
 }
 
@@ -303,6 +312,52 @@ static void mcam_init_clk(struct mcam_camera *mcam,
 		mcam->clk_num = 0;
 }
 
+static int mmp_probe(struct mcam_camera *mcam, struct platform_device *pdev)
+{
+	struct mmp_camera_platform_data *pdata;
+	int ret;
+
+	pdata = pdev->dev.platform_data;
+	if (!pdata)
+		return -ENODEV;
+
+	/*
+	 * Find the i2c adapter.  This assumes, of course, that the
+	 * i2c bus is already up and functioning.
+	 * soc-camera manages i2c interface in sensor side
+	 */
+	mcam->i2c_adapter = platform_get_drvdata(pdata->i2c_device);
+	if (mcam->i2c_adapter == NULL) {
+		dev_err(&pdev->dev, "No i2c adapter\n");
+		return -ENODEV;
+	}
+	/*
+	 * Sensor GPIO pins.
+	 */
+	ret = devm_gpio_request(&pdev->dev, pdata->sensor_power_gpio,
+				"cam-power");
+	if (ret) {
+		dev_err(&pdev->dev, "Can't get sensor power gpio %d",
+				pdata->sensor_power_gpio);
+		return ret;
+	}
+	gpio_direction_output(pdata->sensor_power_gpio, 0);
+	ret = devm_gpio_request(&pdev->dev, pdata->sensor_reset_gpio,
+				"cam-reset");
+	if (ret) {
+		dev_err(&pdev->dev, "Can't get sensor reset gpio %d",
+				pdata->sensor_reset_gpio);
+		return ret;
+	}
+	gpio_direction_output(pdata->sensor_reset_gpio, 0);
+
+	/*
+	 * Power the device up and hand it off to the core.
+	 */
+	mmpcam_power_up(mcam);
+	return ret;
+}
+
 static int mmpcam_probe(struct platform_device *pdev)
 {
 	struct mmp_camera *cam;
@@ -322,6 +377,7 @@ static int mmpcam_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&cam->devlist);
 
 	mcam = &cam->mcam;
+	spin_lock_init(&mcam->dev_lock);
 	mcam->plat_power_up = mmpcam_power_up;
 	mcam->plat_power_down = mmpcam_power_down;
 	mcam->ctlr_reset = mcam_ctlr_reset;
@@ -329,14 +385,23 @@ static int mmpcam_probe(struct platform_device *pdev)
 	mcam->pll1 = NULL;
 	mcam->dev = &pdev->dev;
 	mcam->use_smbus = 0;
+	mcam->card_name = pdata->name;
+	mcam->mclk_min = pdata->mclk_min;
+	mcam->mclk_src = pdata->mclk_src;
+	mcam->mclk_div = pdata->mclk_div;
+	if (pdata->chip_id != V4L2_IDENT_NONE)
+		mcam->chip_id = pdata->chip_id;
+	else
+		mcam->chip_id = V4L2_IDENT_ARMADA610;
+	/* set B_DMA_sg as default */
+	mcam->buffer_mode = B_DMA_sg;
 	mcam->ccic_id = pdev->id;
 	mcam->bus_type = pdata->bus_type;
 	mcam->dphy = pdata->dphy;
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
@@ -366,40 +431,13 @@ static int mmpcam_probe(struct platform_device *pdev)
 	}
 
 	mcam_init_clk(mcam, pdata, 1);
-	/*
-	 * Find the i2c adapter.  This assumes, of course, that the
-	 * i2c bus is already up and functioning.
-	 */
-	mcam->i2c_adapter = platform_get_drvdata(pdata->i2c_device);
-	if (mcam->i2c_adapter == NULL) {
-		dev_err(&pdev->dev, "No i2c adapter\n");
-		ret = -ENODEV;
-		goto out_uninit_clk;
-	}
-	/*
-	 * Sensor GPIO pins.
-	 */
-	ret = devm_gpio_request(&pdev->dev, pdata->sensor_power_gpio,
-					"cam-power");
-	if (ret) {
-		dev_err(&pdev->dev, "Can't get sensor power gpio %d",
-				pdata->sensor_power_gpio);
-		goto out_uninit_clk;
-	}
-	gpio_direction_output(pdata->sensor_power_gpio, 0);
-	ret = devm_gpio_request(&pdev->dev, pdata->sensor_reset_gpio,
-					"cam-reset");
-	if (ret) {
-		dev_err(&pdev->dev, "Can't get sensor reset gpio %d",
-				pdata->sensor_reset_gpio);
-		goto out_uninit_clk;
+
+	if (mcam->chip_id == V4L2_IDENT_ARMADA610) {
+		ret = mmp_probe(mcam, pdev);
+		if (ret)
+			goto out_uninit_clk;
 	}
-	gpio_direction_output(pdata->sensor_reset_gpio, 0);
 
-	/*
-	 * Power the device up and hand it off to the core.
-	 */
-	mmpcam_power_up(mcam);
 	ret = mccic_register(mcam);
 	if (ret)
 		goto out_power_down;
@@ -415,6 +453,9 @@ static int mmpcam_probe(struct platform_device *pdev)
 	cam->irq = res->start;
 	ret = devm_request_irq(&pdev->dev, cam->irq, mmpcam_irq, IRQF_SHARED,
 					"mmp-camera", mcam);
+	if (ret)
+		goto out_unregister;
+
 	if (ret == 0) {
 		mmpcam_add_device(cam);
 		return 0;
@@ -423,7 +464,8 @@ static int mmpcam_probe(struct platform_device *pdev)
 out_unregister:
 	mccic_shutdown(mcam);
 out_power_down:
-	mmpcam_power_down(mcam);
+	if (mcam->chip_id == V4L2_IDENT_ARMADA610)
+		mmpcam_power_down(mcam);
 out_uninit_clk:
 	mcam_init_clk(mcam, pdata, 0);
 	return ret;
@@ -433,12 +475,11 @@ out_uninit_clk:
 static int mmpcam_remove(struct mmp_camera *cam)
 {
 	struct mcam_camera *mcam = &cam->mcam;
-	struct mmp_camera_platform_data *pdata;
+	struct mmp_camera_platform_data *pdata = cam->pdev->dev.platform_data;
 
 	mmpcam_remove_device(cam);
 	mccic_shutdown(mcam);
 	mmpcam_power_down(mcam);
-	pdata = cam->pdev->dev.platform_data;
 	mcam_init_clk(mcam, pdata, 0);
 	return 0;
 }
diff --git a/include/media/mmp-camera.h b/include/media/mmp-camera.h
index 9968031..ec4f21f 100755
--- a/include/media/mmp-camera.h
+++ b/include/media/mmp-camera.h
@@ -7,10 +7,12 @@ struct mmp_camera_platform_data {
 	struct platform_device *i2c_device;
 	int sensor_power_gpio;
 	int sensor_reset_gpio;
+	char name[16];
 	enum v4l2_mbus_type bus_type;
 	int mclk_min;
 	int mclk_src;
 	int mclk_div;
+	int chip_id;
 	/*
 	 * MIPI support
 	 */
-- 
1.7.9.5

