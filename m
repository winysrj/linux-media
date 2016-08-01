Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:59733 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751472AbcHAHyn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Aug 2016 03:54:43 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 3/3] soc-camera/sh_mobile_csi2: remove unused driver
Date: Mon,  1 Aug 2016 09:54:25 +0200
Message-Id: <1470038065-30789-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1470038065-30789-1-git-send-email-hverkuil@xs4all.nl>
References: <1470038065-30789-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The sh_mobile_csi2 isn't used anymore (was it ever?), so remove it.
Especially since the soc-camera framework is being deprecated.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/platform/soc_camera/Kconfig          |   7 -
 drivers/media/platform/soc_camera/Makefile         |   1 -
 .../platform/soc_camera/sh_mobile_ceu_camera.c     | 229 +-----------
 drivers/media/platform/soc_camera/sh_mobile_csi2.c | 400 ---------------------
 include/media/drv-intf/sh_mobile_ceu.h             |   1 -
 include/media/drv-intf/sh_mobile_csi2.h            |  48 ---
 6 files changed, 10 insertions(+), 676 deletions(-)
 delete mode 100644 drivers/media/platform/soc_camera/sh_mobile_csi2.c
 delete mode 100644 include/media/drv-intf/sh_mobile_csi2.h

diff --git a/drivers/media/platform/soc_camera/Kconfig b/drivers/media/platform/soc_camera/Kconfig
index 694cead..3cec521 100644
--- a/drivers/media/platform/soc_camera/Kconfig
+++ b/drivers/media/platform/soc_camera/Kconfig
@@ -25,13 +25,6 @@ config VIDEO_PXA27x
 	---help---
 	  This is a v4l2 driver for the PXA27x Quick Capture Interface
 
-config VIDEO_SH_MOBILE_CSI2
-	tristate "SuperH Mobile MIPI CSI-2 Interface driver"
-	depends on VIDEO_DEV && SOC_CAMERA && HAVE_CLK
-	depends on ARCH_SHMOBILE || SUPERH || COMPILE_TEST
-	---help---
-	  This is a v4l2 driver for the SuperH MIPI CSI-2 Interface
-
 config VIDEO_SH_MOBILE_CEU
 	tristate "SuperH Mobile CEU Interface driver"
 	depends on VIDEO_DEV && SOC_CAMERA && HAS_DMA && HAVE_CLK
diff --git a/drivers/media/platform/soc_camera/Makefile b/drivers/media/platform/soc_camera/Makefile
index 4407a9b..8d344fd 100644
--- a/drivers/media/platform/soc_camera/Makefile
+++ b/drivers/media/platform/soc_camera/Makefile
@@ -9,4 +9,3 @@ obj-$(CONFIG_SOC_CAMERA_PLATFORM)	+= soc_camera_platform.o
 obj-$(CONFIG_VIDEO_ATMEL_ISI)		+= atmel-isi.o
 obj-$(CONFIG_VIDEO_PXA27x)		+= pxa_camera.o
 obj-$(CONFIG_VIDEO_SH_MOBILE_CEU)	+= sh_mobile_ceu_camera.o
-obj-$(CONFIG_VIDEO_SH_MOBILE_CSI2)	+= sh_mobile_csi2.o
diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index 02b519d..05eafe3 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -41,7 +41,6 @@
 #include <media/v4l2-dev.h>
 #include <media/soc_camera.h>
 #include <media/drv-intf/sh_mobile_ceu.h>
-#include <media/drv-intf/sh_mobile_csi2.h>
 #include <media/videobuf2-dma-contig.h>
 #include <media/v4l2-mediabus.h>
 #include <media/drv-intf/soc_mediabus.h>
@@ -99,11 +98,6 @@ struct sh_mobile_ceu_buffer {
 
 struct sh_mobile_ceu_dev {
 	struct soc_camera_host ici;
-	/* Asynchronous CSI2 linking */
-	struct v4l2_async_subdev *csi2_asd;
-	struct v4l2_subdev *csi2_sd;
-	/* Synchronous probing compatibility */
-	struct platform_device *csi2_pdev;
 
 	unsigned int irq;
 	void __iomem *base;
@@ -517,74 +511,20 @@ out:
 	return IRQ_HANDLED;
 }
 
-static struct v4l2_subdev *find_csi2(struct sh_mobile_ceu_dev *pcdev)
-{
-	struct v4l2_subdev *sd;
-
-	if (pcdev->csi2_sd)
-		return pcdev->csi2_sd;
-
-	if (pcdev->csi2_asd) {
-		char name[] = "sh-mobile-csi2";
-		v4l2_device_for_each_subdev(sd, &pcdev->ici.v4l2_dev)
-			if (!strncmp(name, sd->name, sizeof(name) - 1)) {
-				pcdev->csi2_sd = sd;
-				return sd;
-			}
-	}
-
-	return NULL;
-}
-
-static struct v4l2_subdev *csi2_subdev(struct sh_mobile_ceu_dev *pcdev,
-				       struct soc_camera_device *icd)
-{
-	struct v4l2_subdev *sd = pcdev->csi2_sd;
-
-	return sd && sd->grp_id == soc_camera_grp_id(icd) ? sd : NULL;
-}
-
 static int sh_mobile_ceu_add_device(struct soc_camera_device *icd)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
-	struct sh_mobile_ceu_dev *pcdev = ici->priv;
-	struct v4l2_subdev *csi2_sd = find_csi2(pcdev);
-	int ret;
-
-	if (csi2_sd) {
-		csi2_sd->grp_id = soc_camera_grp_id(icd);
-		v4l2_set_subdev_hostdata(csi2_sd, icd);
-	}
-
-	ret = v4l2_subdev_call(csi2_sd, core, s_power, 1);
-	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
-		return ret;
-
-	/*
-	 * -ENODEV is special: either csi2_sd == NULL or the CSI-2 driver
-	 * has not found this soc-camera device among its clients
-	 */
-	if (csi2_sd && ret == -ENODEV)
-		csi2_sd->grp_id = 0;
-
 	dev_info(icd->parent,
-		 "SuperH Mobile CEU%s driver attached to camera %d\n",
-		 csi2_sd && csi2_sd->grp_id ? "/CSI-2" : "", icd->devnum);
+		 "SuperH Mobile CEU driver attached to camera %d\n",
+		 icd->devnum);
 
 	return 0;
 }
 
 static void sh_mobile_ceu_remove_device(struct soc_camera_device *icd)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
-	struct sh_mobile_ceu_dev *pcdev = ici->priv;
-	struct v4l2_subdev *csi2_sd = find_csi2(pcdev);
-
 	dev_info(icd->parent,
 		 "SuperH Mobile CEU driver detached from camera %d\n",
 		 icd->devnum);
-
-	v4l2_subdev_call(csi2_sd, core, s_power, 0);
 }
 
 /* Called with .host_lock held */
@@ -704,12 +644,6 @@ static void sh_mobile_ceu_set_rect(struct soc_camera_device *icd)
 		cdwdr_width *= 2;
 	}
 
-	/* CSI2 special configuration */
-	if (csi2_subdev(pcdev, icd)) {
-		in_width = ((in_width - 2) * 2);
-		left_offset *= 2;
-	}
-
 	/* Set CAMOR, CAPWR, CFSZR, take care of CDWDR */
 	camor = left_offset | (top_offset << 16);
 
@@ -758,13 +692,6 @@ static void capture_restore(struct sh_mobile_ceu_dev *pcdev, u32 capsr)
 		ceu_write(pcdev, CAPSR, capsr);
 }
 
-/* Find the bus subdevice driver, e.g., CSI2 */
-static struct v4l2_subdev *find_bus_subdev(struct sh_mobile_ceu_dev *pcdev,
-					   struct soc_camera_device *icd)
-{
-	return csi2_subdev(pcdev, icd) ? : soc_camera_to_subdev(icd);
-}
-
 #define CEU_BUS_FLAGS (V4L2_MBUS_MASTER |	\
 		V4L2_MBUS_PCLK_SAMPLE_RISING |	\
 		V4L2_MBUS_HSYNC_ACTIVE_HIGH |	\
@@ -778,7 +705,7 @@ static int sh_mobile_ceu_set_bus_param(struct soc_camera_device *icd)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
-	struct v4l2_subdev *sd = find_bus_subdev(pcdev, icd);
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct sh_mobile_ceu_cam *cam = icd->host_priv;
 	struct v4l2_mbus_config cfg = {.type = V4L2_MBUS_PARALLEL,};
 	unsigned long value, common_flags = CEU_BUS_FLAGS;
@@ -866,9 +793,7 @@ static int sh_mobile_ceu_set_bus_param(struct soc_camera_device *icd)
 	value |= common_flags & V4L2_MBUS_VSYNC_ACTIVE_LOW ? 1 << 1 : 0;
 	value |= common_flags & V4L2_MBUS_HSYNC_ACTIVE_LOW ? 1 << 0 : 0;
 
-	if (csi2_subdev(pcdev, icd)) /* CSI2 mode */
-		value |= 3 << 12;
-	else if (pcdev->is_16bit)
+	if (pcdev->is_16bit)
 		value |= 1 << 12;
 	else if (pcdev->flags & SH_CEU_FLAG_LOWER_8BIT)
 		value |= 2 << 12;
@@ -923,9 +848,7 @@ static int sh_mobile_ceu_set_bus_param(struct soc_camera_device *icd)
 static int sh_mobile_ceu_try_bus_param(struct soc_camera_device *icd,
 				       unsigned char buswidth)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
-	struct sh_mobile_ceu_dev *pcdev = ici->priv;
-	struct v4l2_subdev *sd = find_bus_subdev(pcdev, icd);
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	unsigned long common_flags = CEU_BUS_FLAGS;
 	struct v4l2_mbus_config cfg = {.type = V4L2_MBUS_PARALLEL,};
 	int ret;
@@ -1046,12 +969,9 @@ static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, unsigned int
 		return 0;
 	}
 
-	if (!csi2_subdev(pcdev, icd)) {
-		/* Are there any restrictions in the CSI-2 case? */
-		ret = sh_mobile_ceu_try_bus_param(icd, fmt->bits_per_sample);
-		if (ret < 0)
-			return 0;
-	}
+	ret = sh_mobile_ceu_try_bus_param(icd, fmt->bits_per_sample);
+	if (ret < 0)
+		return 0;
 
 	if (!icd->host_priv) {
 		struct v4l2_subdev_format fmt = {
@@ -1721,12 +1641,11 @@ static int sh_mobile_ceu_probe(struct platform_device *pdev)
 	struct resource *res;
 	void __iomem *base;
 	unsigned int irq;
-	int err, i;
+	int err;
 	struct bus_wait wait = {
 		.completion = COMPLETION_INITIALIZER_ONSTACK(wait.completion),
 		.notifier.notifier_call = bus_notify,
 	};
-	struct sh_mobile_ceu_companion *csi2;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	irq = platform_get_irq(pdev, 0);
@@ -1821,132 +1740,16 @@ static int sh_mobile_ceu_probe(struct platform_device *pdev)
 	pcdev->ici.capabilities = SOCAM_HOST_CAP_STRIDE;
 
 	if (pcdev->pdata && pcdev->pdata->asd_sizes) {
-		struct v4l2_async_subdev **asd;
-		char name[] = "sh-mobile-csi2";
-		int j;
-
-		/*
-		 * CSI2 interfacing: several groups can use CSI2, pick up the
-		 * first one
-		 */
-		asd = pcdev->pdata->asd;
-		for (j = 0; pcdev->pdata->asd_sizes[j]; j++) {
-			for (i = 0; i < pcdev->pdata->asd_sizes[j]; i++, asd++) {
-				dev_dbg(&pdev->dev, "%s(): subdev #%d, type %u\n",
-					__func__, i, (*asd)->match_type);
-				if ((*asd)->match_type == V4L2_ASYNC_MATCH_DEVNAME &&
-				    !strncmp(name, (*asd)->match.device_name.name,
-					     sizeof(name) - 1)) {
-					pcdev->csi2_asd = *asd;
-					break;
-				}
-			}
-			if (pcdev->csi2_asd)
-				break;
-		}
-
 		pcdev->ici.asd = pcdev->pdata->asd;
 		pcdev->ici.asd_sizes = pcdev->pdata->asd_sizes;
 	}
 
-	/* Legacy CSI2 interfacing */
-	csi2 = pcdev->pdata ? pcdev->pdata->csi2 : NULL;
-	if (csi2) {
-		/*
-		 * TODO: remove this once all users are converted to
-		 * asynchronous CSI2 probing. If it has to be kept, csi2
-		 * platform device resources have to be added, using
-		 * platform_device_add_resources()
-		 */
-		struct platform_device *csi2_pdev =
-			platform_device_alloc("sh-mobile-csi2", csi2->id);
-		struct sh_csi2_pdata *csi2_pdata = csi2->platform_data;
-
-		if (!csi2_pdev) {
-			err = -ENOMEM;
-			goto exit_free_clk;
-		}
-
-		pcdev->csi2_pdev		= csi2_pdev;
-
-		err = platform_device_add_data(csi2_pdev, csi2_pdata,
-					       sizeof(*csi2_pdata));
-		if (err < 0)
-			goto exit_pdev_put;
-
-		csi2_pdev->resource		= csi2->resource;
-		csi2_pdev->num_resources	= csi2->num_resources;
-
-		err = platform_device_add(csi2_pdev);
-		if (err < 0)
-			goto exit_pdev_put;
-
-		wait.dev = &csi2_pdev->dev;
-
-		err = bus_register_notifier(&platform_bus_type, &wait.notifier);
-		if (err < 0)
-			goto exit_pdev_unregister;
-
-		/*
-		 * From this point the driver module will not unload, until
-		 * we complete the completion.
-		 */
-
-		if (!csi2_pdev->dev.driver) {
-			complete(&wait.completion);
-			/* Either too late, or probing failed */
-			bus_unregister_notifier(&platform_bus_type, &wait.notifier);
-			err = -ENXIO;
-			goto exit_pdev_unregister;
-		}
-
-		/*
-		 * The module is still loaded, in the worst case it is hanging
-		 * in device release on our completion. So, _now_ dereferencing
-		 * the "owner" is safe!
-		 */
-
-		err = try_module_get(csi2_pdev->dev.driver->owner);
-
-		/* Let notifier complete, if it has been locked */
-		complete(&wait.completion);
-		bus_unregister_notifier(&platform_bus_type, &wait.notifier);
-		if (!err) {
-			err = -ENODEV;
-			goto exit_pdev_unregister;
-		}
-
-		pcdev->csi2_sd = platform_get_drvdata(csi2_pdev);
-	}
-
 	err = soc_camera_host_register(&pcdev->ici);
 	if (err)
-		goto exit_csi2_unregister;
-
-	if (csi2) {
-		err = v4l2_device_register_subdev(&pcdev->ici.v4l2_dev,
-						  pcdev->csi2_sd);
-		dev_dbg(&pdev->dev, "%s(): ret(register_subdev) = %d\n",
-			__func__, err);
-		if (err < 0)
-			goto exit_host_unregister;
-		/* v4l2_device_register_subdev() took a reference too */
-		module_put(pcdev->csi2_sd->owner);
-	}
+		goto exit_free_clk;
 
 	return 0;
 
-exit_host_unregister:
-	soc_camera_host_unregister(&pcdev->ici);
-exit_csi2_unregister:
-	if (csi2) {
-		module_put(pcdev->csi2_pdev->dev.driver->owner);
-exit_pdev_unregister:
-		platform_device_del(pcdev->csi2_pdev);
-exit_pdev_put:
-		pcdev->csi2_pdev->resource = NULL;
-		platform_device_put(pcdev->csi2_pdev);
-	}
 exit_free_clk:
 	pm_runtime_disable(&pdev->dev);
 exit_release_mem:
@@ -1958,21 +1761,11 @@ exit_release_mem:
 static int sh_mobile_ceu_remove(struct platform_device *pdev)
 {
 	struct soc_camera_host *soc_host = to_soc_camera_host(&pdev->dev);
-	struct sh_mobile_ceu_dev *pcdev = container_of(soc_host,
-					struct sh_mobile_ceu_dev, ici);
-	struct platform_device *csi2_pdev = pcdev->csi2_pdev;
 
 	soc_camera_host_unregister(soc_host);
 	pm_runtime_disable(&pdev->dev);
 	if (platform_get_resource(pdev, IORESOURCE_MEM, 1))
 		dma_release_declared_memory(&pdev->dev);
-	if (csi2_pdev && csi2_pdev->dev.driver) {
-		struct module *csi2_drv = csi2_pdev->dev.driver->owner;
-		platform_device_del(csi2_pdev);
-		csi2_pdev->resource = NULL;
-		platform_device_put(csi2_pdev);
-		module_put(csi2_drv);
-	}
 
 	return 0;
 }
@@ -2012,8 +1805,6 @@ static struct platform_driver sh_mobile_ceu_driver = {
 
 static int __init sh_mobile_ceu_init(void)
 {
-	/* Whatever return code */
-	request_module("sh_mobile_csi2");
 	return platform_driver_register(&sh_mobile_ceu_driver);
 }
 
diff --git a/drivers/media/platform/soc_camera/sh_mobile_csi2.c b/drivers/media/platform/soc_camera/sh_mobile_csi2.c
deleted file mode 100644
index 09b1836..0000000
--- a/drivers/media/platform/soc_camera/sh_mobile_csi2.c
+++ /dev/null
@@ -1,400 +0,0 @@
-/*
- * Driver for the SH-Mobile MIPI CSI-2 unit
- *
- * Copyright (C) 2010, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/delay.h>
-#include <linux/err.h>
-#include <linux/i2c.h>
-#include <linux/io.h>
-#include <linux/platform_device.h>
-#include <linux/pm_runtime.h>
-#include <linux/slab.h>
-#include <linux/videodev2.h>
-#include <linux/module.h>
-
-#include <media/drv-intf/sh_mobile_ceu.h>
-#include <media/drv-intf/sh_mobile_csi2.h>
-#include <media/soc_camera.h>
-#include <media/drv-intf/soc_mediabus.h>
-#include <media/v4l2-common.h>
-#include <media/v4l2-dev.h>
-#include <media/v4l2-device.h>
-#include <media/v4l2-mediabus.h>
-#include <media/v4l2-subdev.h>
-
-#define SH_CSI2_TREF	0x00
-#define SH_CSI2_SRST	0x04
-#define SH_CSI2_PHYCNT	0x08
-#define SH_CSI2_CHKSUM	0x0C
-#define SH_CSI2_VCDT	0x10
-
-struct sh_csi2 {
-	struct v4l2_subdev		subdev;
-	unsigned int			irq;
-	unsigned long			mipi_flags;
-	void __iomem			*base;
-	struct platform_device		*pdev;
-	struct sh_csi2_client_config	*client;
-};
-
-static void sh_csi2_hwinit(struct sh_csi2 *priv);
-
-static int sh_csi2_set_fmt(struct v4l2_subdev *sd,
-		struct v4l2_subdev_pad_config *cfg,
-		struct v4l2_subdev_format *format)
-{
-	struct sh_csi2 *priv = container_of(sd, struct sh_csi2, subdev);
-	struct sh_csi2_pdata *pdata = priv->pdev->dev.platform_data;
-	struct v4l2_mbus_framefmt *mf = &format->format;
-	u32 tmp = (priv->client->channel & 3) << 8;
-
-	if (format->pad)
-		return -EINVAL;
-
-	if (mf->width > 8188)
-		mf->width = 8188;
-	else if (mf->width & 1)
-		mf->width &= ~1;
-
-	switch (pdata->type) {
-	case SH_CSI2C:
-		switch (mf->code) {
-		case MEDIA_BUS_FMT_UYVY8_2X8:		/* YUV422 */
-		case MEDIA_BUS_FMT_YUYV8_1_5X8:		/* YUV420 */
-		case MEDIA_BUS_FMT_Y8_1X8:		/* RAW8 */
-		case MEDIA_BUS_FMT_SBGGR8_1X8:
-		case MEDIA_BUS_FMT_SGRBG8_1X8:
-			break;
-		default:
-			/* All MIPI CSI-2 devices must support one of primary formats */
-			mf->code = MEDIA_BUS_FMT_YUYV8_2X8;
-		}
-		break;
-	case SH_CSI2I:
-		switch (mf->code) {
-		case MEDIA_BUS_FMT_Y8_1X8:		/* RAW8 */
-		case MEDIA_BUS_FMT_SBGGR8_1X8:
-		case MEDIA_BUS_FMT_SGRBG8_1X8:
-		case MEDIA_BUS_FMT_SBGGR10_1X10:	/* RAW10 */
-		case MEDIA_BUS_FMT_SBGGR12_1X12:	/* RAW12 */
-			break;
-		default:
-			/* All MIPI CSI-2 devices must support one of primary formats */
-			mf->code = MEDIA_BUS_FMT_SBGGR8_1X8;
-		}
-		break;
-	}
-
-	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
-		cfg->try_fmt = *mf;
-		return 0;
-	}
-
-	if (mf->width > 8188 || mf->width & 1)
-		return -EINVAL;
-
-	switch (mf->code) {
-	case MEDIA_BUS_FMT_UYVY8_2X8:
-		tmp |= 0x1e;	/* YUV422 8 bit */
-		break;
-	case MEDIA_BUS_FMT_YUYV8_1_5X8:
-		tmp |= 0x18;	/* YUV420 8 bit */
-		break;
-	case MEDIA_BUS_FMT_RGB555_2X8_PADHI_BE:
-		tmp |= 0x21;	/* RGB555 */
-		break;
-	case MEDIA_BUS_FMT_RGB565_2X8_BE:
-		tmp |= 0x22;	/* RGB565 */
-		break;
-	case MEDIA_BUS_FMT_Y8_1X8:
-	case MEDIA_BUS_FMT_SBGGR8_1X8:
-	case MEDIA_BUS_FMT_SGRBG8_1X8:
-		tmp |= 0x2a;	/* RAW8 */
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	iowrite32(tmp, priv->base + SH_CSI2_VCDT);
-
-	return 0;
-}
-
-static int sh_csi2_g_mbus_config(struct v4l2_subdev *sd,
-				 struct v4l2_mbus_config *cfg)
-{
-	struct sh_csi2 *priv = container_of(sd, struct sh_csi2, subdev);
-
-	if (!priv->mipi_flags) {
-		struct soc_camera_device *icd = v4l2_get_subdev_hostdata(sd);
-		struct v4l2_subdev *client_sd = soc_camera_to_subdev(icd);
-		struct sh_csi2_pdata *pdata = priv->pdev->dev.platform_data;
-		unsigned long common_flags, csi2_flags;
-		struct v4l2_mbus_config client_cfg = {.type = V4L2_MBUS_CSI2,};
-		int ret;
-
-		/* Check if we can support this camera */
-		csi2_flags = V4L2_MBUS_CSI2_CONTINUOUS_CLOCK |
-			V4L2_MBUS_CSI2_1_LANE;
-
-		switch (pdata->type) {
-		case SH_CSI2C:
-			if (priv->client->lanes != 1)
-				csi2_flags |= V4L2_MBUS_CSI2_2_LANE;
-			break;
-		case SH_CSI2I:
-			switch (priv->client->lanes) {
-			default:
-				csi2_flags |= V4L2_MBUS_CSI2_4_LANE;
-			case 3:
-				csi2_flags |= V4L2_MBUS_CSI2_3_LANE;
-			case 2:
-				csi2_flags |= V4L2_MBUS_CSI2_2_LANE;
-			}
-		}
-
-		ret = v4l2_subdev_call(client_sd, video, g_mbus_config, &client_cfg);
-		if (ret == -ENOIOCTLCMD)
-			common_flags = csi2_flags;
-		else if (!ret)
-			common_flags = soc_mbus_config_compatible(&client_cfg,
-								  csi2_flags);
-		else
-			common_flags = 0;
-
-		if (!common_flags)
-			return -EINVAL;
-
-		/* All good: camera MIPI configuration supported */
-		priv->mipi_flags = common_flags;
-	}
-
-	if (cfg) {
-		cfg->flags = V4L2_MBUS_PCLK_SAMPLE_RISING |
-			V4L2_MBUS_HSYNC_ACTIVE_HIGH | V4L2_MBUS_VSYNC_ACTIVE_HIGH |
-			V4L2_MBUS_MASTER | V4L2_MBUS_DATA_ACTIVE_HIGH;
-		cfg->type = V4L2_MBUS_PARALLEL;
-	}
-
-	return 0;
-}
-
-static int sh_csi2_s_mbus_config(struct v4l2_subdev *sd,
-				 const struct v4l2_mbus_config *cfg)
-{
-	struct sh_csi2 *priv = container_of(sd, struct sh_csi2, subdev);
-	struct soc_camera_device *icd = v4l2_get_subdev_hostdata(sd);
-	struct v4l2_subdev *client_sd = soc_camera_to_subdev(icd);
-	struct v4l2_mbus_config client_cfg = {.type = V4L2_MBUS_CSI2,};
-	int ret = sh_csi2_g_mbus_config(sd, NULL);
-
-	if (ret < 0)
-		return ret;
-
-	pm_runtime_get_sync(&priv->pdev->dev);
-
-	sh_csi2_hwinit(priv);
-
-	client_cfg.flags = priv->mipi_flags;
-
-	return v4l2_subdev_call(client_sd, video, s_mbus_config, &client_cfg);
-}
-
-static struct v4l2_subdev_video_ops sh_csi2_subdev_video_ops = {
-	.g_mbus_config	= sh_csi2_g_mbus_config,
-	.s_mbus_config	= sh_csi2_s_mbus_config,
-};
-
-static struct v4l2_subdev_pad_ops sh_csi2_subdev_pad_ops = {
-	.set_fmt	= sh_csi2_set_fmt,
-};
-
-static void sh_csi2_hwinit(struct sh_csi2 *priv)
-{
-	struct sh_csi2_pdata *pdata = priv->pdev->dev.platform_data;
-	__u32 tmp = 0x10; /* Enable MIPI CSI clock lane */
-
-	/* Reflect registers immediately */
-	iowrite32(0x00000001, priv->base + SH_CSI2_TREF);
-	/* reset CSI2 harware */
-	iowrite32(0x00000001, priv->base + SH_CSI2_SRST);
-	udelay(5);
-	iowrite32(0x00000000, priv->base + SH_CSI2_SRST);
-
-	switch (pdata->type) {
-	case SH_CSI2C:
-		if (priv->client->lanes == 1)
-			tmp |= 1;
-		else
-			/* Default - both lanes */
-			tmp |= 3;
-		break;
-	case SH_CSI2I:
-		if (!priv->client->lanes || priv->client->lanes > 4)
-			/* Default - all 4 lanes */
-			tmp |= 0xf;
-		else
-			tmp |= (1 << priv->client->lanes) - 1;
-	}
-
-	if (priv->client->phy == SH_CSI2_PHY_MAIN)
-		tmp |= 0x8000;
-
-	iowrite32(tmp, priv->base + SH_CSI2_PHYCNT);
-
-	tmp = 0;
-	if (pdata->flags & SH_CSI2_ECC)
-		tmp |= 2;
-	if (pdata->flags & SH_CSI2_CRC)
-		tmp |= 1;
-	iowrite32(tmp, priv->base + SH_CSI2_CHKSUM);
-}
-
-static int sh_csi2_client_connect(struct sh_csi2 *priv)
-{
-	struct device *dev = v4l2_get_subdevdata(&priv->subdev);
-	struct sh_csi2_pdata *pdata = dev->platform_data;
-	struct soc_camera_device *icd = v4l2_get_subdev_hostdata(&priv->subdev);
-	int i;
-
-	if (priv->client)
-		return -EBUSY;
-
-	for (i = 0; i < pdata->num_clients; i++)
-		if ((pdata->clients[i].pdev &&
-		     &pdata->clients[i].pdev->dev == icd->pdev) ||
-		    (icd->control &&
-		     strcmp(pdata->clients[i].name, dev_name(icd->control))))
-			break;
-
-	dev_dbg(dev, "%s(%p): found #%d\n", __func__, dev, i);
-
-	if (i == pdata->num_clients)
-		return -ENODEV;
-
-	priv->client = pdata->clients + i;
-
-	return 0;
-}
-
-static void sh_csi2_client_disconnect(struct sh_csi2 *priv)
-{
-	if (!priv->client)
-		return;
-
-	priv->client = NULL;
-
-	pm_runtime_put(v4l2_get_subdevdata(&priv->subdev));
-}
-
-static int sh_csi2_s_power(struct v4l2_subdev *sd, int on)
-{
-	struct sh_csi2 *priv = container_of(sd, struct sh_csi2, subdev);
-
-	if (on)
-		return sh_csi2_client_connect(priv);
-
-	sh_csi2_client_disconnect(priv);
-	return 0;
-}
-
-static struct v4l2_subdev_core_ops sh_csi2_subdev_core_ops = {
-	.s_power	= sh_csi2_s_power,
-};
-
-static struct v4l2_subdev_ops sh_csi2_subdev_ops = {
-	.core	= &sh_csi2_subdev_core_ops,
-	.video	= &sh_csi2_subdev_video_ops,
-	.pad	= &sh_csi2_subdev_pad_ops,
-};
-
-static int sh_csi2_probe(struct platform_device *pdev)
-{
-	struct resource *res;
-	unsigned int irq;
-	int ret;
-	struct sh_csi2 *priv;
-	/* Platform data specify the PHY, lanes, ECC, CRC */
-	struct sh_csi2_pdata *pdata = pdev->dev.platform_data;
-
-	if (!pdata)
-		return -EINVAL;
-
-	priv = devm_kzalloc(&pdev->dev, sizeof(struct sh_csi2), GFP_KERNEL);
-	if (!priv)
-		return -ENOMEM;
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	/* Interrupt unused so far */
-	irq = platform_get_irq(pdev, 0);
-
-	if (!res || (int)irq <= 0) {
-		dev_err(&pdev->dev, "Not enough CSI2 platform resources.\n");
-		return -ENODEV;
-	}
-
-	/* TODO: Add support for CSI2I. Careful: different register layout! */
-	if (pdata->type != SH_CSI2C) {
-		dev_err(&pdev->dev, "Only CSI2C supported ATM.\n");
-		return -EINVAL;
-	}
-
-	priv->irq = irq;
-
-	priv->base = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(priv->base))
-		return PTR_ERR(priv->base);
-
-	priv->pdev = pdev;
-	priv->subdev.owner = THIS_MODULE;
-	priv->subdev.dev = &pdev->dev;
-	platform_set_drvdata(pdev, &priv->subdev);
-
-	v4l2_subdev_init(&priv->subdev, &sh_csi2_subdev_ops);
-	v4l2_set_subdevdata(&priv->subdev, &pdev->dev);
-
-	snprintf(priv->subdev.name, V4L2_SUBDEV_NAME_SIZE, "%s.mipi-csi",
-		 dev_name(&pdev->dev));
-
-	ret = v4l2_async_register_subdev(&priv->subdev);
-	if (ret < 0)
-		return ret;
-
-	pm_runtime_enable(&pdev->dev);
-
-	dev_dbg(&pdev->dev, "CSI2 probed.\n");
-
-	return 0;
-}
-
-static int sh_csi2_remove(struct platform_device *pdev)
-{
-	struct v4l2_subdev *subdev = platform_get_drvdata(pdev);
-	struct sh_csi2 *priv = container_of(subdev, struct sh_csi2, subdev);
-
-	v4l2_async_unregister_subdev(&priv->subdev);
-	pm_runtime_disable(&pdev->dev);
-
-	return 0;
-}
-
-static struct platform_driver __refdata sh_csi2_pdrv = {
-	.remove	= sh_csi2_remove,
-	.probe	= sh_csi2_probe,
-	.driver	= {
-		.name	= "sh-mobile-csi2",
-	},
-};
-
-module_platform_driver(sh_csi2_pdrv);
-
-MODULE_DESCRIPTION("SH-Mobile MIPI CSI-2 driver");
-MODULE_AUTHOR("Guennadi Liakhovetski <g.liakhovetski@gmx.de>");
-MODULE_LICENSE("GPL v2");
-MODULE_ALIAS("platform:sh-mobile-csi2");
diff --git a/include/media/drv-intf/sh_mobile_ceu.h b/include/media/drv-intf/sh_mobile_ceu.h
index 7f57056..2f43f7d 100644
--- a/include/media/drv-intf/sh_mobile_ceu.h
+++ b/include/media/drv-intf/sh_mobile_ceu.h
@@ -21,7 +21,6 @@ struct sh_mobile_ceu_info {
 	unsigned long flags;
 	int max_width;
 	int max_height;
-	struct sh_mobile_ceu_companion *csi2;
 	struct v4l2_async_subdev **asd;	/* Flat array, arranged in groups */
 	unsigned int *asd_sizes;	/* 0-terminated array pf asd group sizes */
 };
diff --git a/include/media/drv-intf/sh_mobile_csi2.h b/include/media/drv-intf/sh_mobile_csi2.h
deleted file mode 100644
index 14030db..0000000
--- a/include/media/drv-intf/sh_mobile_csi2.h
+++ /dev/null
@@ -1,48 +0,0 @@
-/*
- * Driver header for the SH-Mobile MIPI CSI-2 unit
- *
- * Copyright (C) 2010, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef SH_MIPI_CSI
-#define SH_MIPI_CSI
-
-#include <linux/list.h>
-
-enum sh_csi2_phy {
-	SH_CSI2_PHY_MAIN,
-	SH_CSI2_PHY_SUB,
-};
-
-enum sh_csi2_type {
-	SH_CSI2C,
-	SH_CSI2I,
-};
-
-#define SH_CSI2_CRC	(1 << 0)
-#define SH_CSI2_ECC	(1 << 1)
-
-struct platform_device;
-
-struct sh_csi2_client_config {
-	enum sh_csi2_phy phy;
-	unsigned char lanes;		/* bitmask[3:0] */
-	unsigned char channel;		/* 0..3 */
-	struct platform_device *pdev;	/* client platform device */
-	const char *name;		/* async matching: client name */
-};
-
-struct v4l2_device;
-
-struct sh_csi2_pdata {
-	enum sh_csi2_type type;
-	unsigned int flags;
-	struct sh_csi2_client_config *clients;
-	int num_clients;
-};
-
-#endif
-- 
2.8.1

