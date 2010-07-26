Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:41330 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753477Ab0GZQUu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Jul 2010 12:20:50 -0400
Date: Mon, 26 Jul 2010 18:21:02 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>
Subject: [PATCH 4/5] V4L2: soc-camera: add a MIPI CSI-2 driver for SH-Mobile
 platforms
In-Reply-To: <Pine.LNX.4.64.1007261739180.9816@axis700.grange>
Message-ID: <Pine.LNX.4.64.1007261750520.9816@axis700.grange>
References: <Pine.LNX.4.64.1007261739180.9816@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some SH-Mobile SoCs implement a MIPI CSI-2 controller, that can interface to
several video clients and send data to the CEU or to the Image Signal
Processor.  This patch implements a v4l2-subdevice driver for CSI-2 to be used
within the soc-camera framework, implementing the second subdevice in addition
to the actual video clients.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/Kconfig          |    6 +
 drivers/media/video/Makefile         |    1 +
 drivers/media/video/sh_mobile_csi2.c |  354 ++++++++++++++++++++++++++++++++++
 include/media/sh_mobile_csi2.h       |   46 +++++
 4 files changed, 407 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/sh_mobile_csi2.c
 create mode 100644 include/media/sh_mobile_csi2.h

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index bdbc9d3..4595eb9 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -955,6 +955,12 @@ config VIDEO_PXA27x
 	---help---
 	  This is a v4l2 driver for the PXA27x Quick Capture Interface
 
+config VIDEO_SH_MOBILE_CSI2
+	tristate "SuperH Mobile MIPI CSI-2 Interface driver"
+	depends on VIDEO_DEV && SOC_CAMERA && HAVE_CLK
+	---help---
+	  This is a v4l2 driver for the SuperH MIPI CSI-2 Interface
+
 config VIDEO_SH_MOBILE_CEU
 	tristate "SuperH Mobile CEU Interface driver"
 	depends on VIDEO_DEV && SOC_CAMERA && HAS_DMA && HAVE_CLK
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index cc93859..79df307 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -164,6 +164,7 @@ obj-$(CONFIG_SOC_CAMERA_PLATFORM)	+= soc_camera_platform.o
 obj-$(CONFIG_VIDEO_MX1)			+= mx1_camera.o
 obj-$(CONFIG_VIDEO_MX3)			+= mx3_camera.o
 obj-$(CONFIG_VIDEO_PXA27x)		+= pxa_camera.o
+obj-$(CONFIG_VIDEO_SH_MOBILE_CSI2)	+= sh_mobile_csi2.o
 obj-$(CONFIG_VIDEO_SH_MOBILE_CEU)	+= sh_mobile_ceu_camera.o
 
 obj-$(CONFIG_ARCH_DAVINCI)		+= davinci/
diff --git a/drivers/media/video/sh_mobile_csi2.c b/drivers/media/video/sh_mobile_csi2.c
new file mode 100644
index 0000000..c71adf6
--- /dev/null
+++ b/drivers/media/video/sh_mobile_csi2.c
@@ -0,0 +1,354 @@
+/*
+ * Driver for the SH-Mobile MIPI CSI-2 unit
+ *
+ * Copyright (C) 2010, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/delay.h>
+#include <linux/i2c.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+#include <linux/slab.h>
+#include <linux/videodev2.h>
+
+#include <media/sh_mobile_csi2.h>
+#include <media/soc_camera.h>
+#include <media/v4l2-common.h>
+#include <media/v4l2-dev.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-mediabus.h>
+#include <media/v4l2-subdev.h>
+
+#define SH_CSI2_TREF	0x00
+#define SH_CSI2_SRST	0x04
+#define SH_CSI2_PHYCNT	0x08
+#define SH_CSI2_CHKSUM	0x0C
+#define SH_CSI2_VCDT	0x10
+
+struct sh_csi2 {
+	struct v4l2_subdev		subdev;
+	struct list_head		list;
+	struct notifier_block		notifier;
+	unsigned int			irq;
+	void __iomem			*base;
+	struct platform_device		*pdev;
+	struct sh_csi2_client_config	*client;
+};
+
+static int sh_csi2_try_fmt(struct v4l2_subdev *sd,
+			   struct v4l2_mbus_framefmt *mf)
+{
+	struct sh_csi2 *priv = container_of(sd, struct sh_csi2, subdev);
+	struct sh_csi2_pdata *pdata = priv->pdev->dev.platform_data;
+
+	if (mf->width > 8188)
+		mf->width = 8188;
+	else if (mf->width & 1)
+		mf->width &= ~1;
+
+	switch (pdata->type) {
+	case SH_CSI2C:
+		switch (mf->code) {
+		case V4L2_MBUS_FMT_YUYV8_2X8_BE:	/* YUV422 */
+		case V4L2_MBUS_FMT_YUYV8_1_5X8:		/* YUV420 */
+		case V4L2_MBUS_FMT_GREY8_1X8:		/* RAW8 */
+		case V4L2_MBUS_FMT_SBGGR8_1X8:
+		case V4L2_MBUS_FMT_SGRBG8_1X8:
+			break;
+		default:
+			/* All MIPI CSI-2 devices must support one of primary formats */
+			mf->code = V4L2_MBUS_FMT_YUYV8_2X8_LE;
+		}
+		break;
+	case SH_CSI2I:
+		switch (mf->code) {
+		case V4L2_MBUS_FMT_GREY8_1X8:		/* RAW8 */
+		case V4L2_MBUS_FMT_SBGGR8_1X8:
+		case V4L2_MBUS_FMT_SGRBG8_1X8:
+		case V4L2_MBUS_FMT_SBGGR10_1X10:	/* RAW10 */
+		case V4L2_MBUS_FMT_SBGGR12_1X12:	/* RAW12 */
+			break;
+		default:
+			/* All MIPI CSI-2 devices must support one of primary formats */
+			mf->code = V4L2_MBUS_FMT_SBGGR8_1X8;
+		}
+		break;
+	}
+
+	return 0;
+}
+
+/*
+ * We have done our best in try_fmt to try and tell the sensor, which formats
+ * we support. If now the configuration is unsuitable for us we can only
+ * error out.
+ */
+static int sh_csi2_s_fmt(struct v4l2_subdev *sd,
+			 struct v4l2_mbus_framefmt *mf)
+{
+	struct sh_csi2 *priv = container_of(sd, struct sh_csi2, subdev);
+	u32 tmp = (priv->client->channel & 3) << 8;
+
+	dev_dbg(sd->v4l2_dev->dev, "%s(%u)\n", __func__, mf->code);
+	if (mf->width > 8188 || mf->width & 1)
+		return -EINVAL;
+
+	switch (mf->code) {
+	case V4L2_MBUS_FMT_YUYV8_2X8_BE:
+		tmp |= 0x1e;	/* YUV422 8 bit */
+		break;
+	case V4L2_MBUS_FMT_YUYV8_1_5X8:
+		tmp |= 0x18;	/* YUV420 8 bit */
+		break;
+	case V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE:
+		tmp |= 0x21;	/* RGB555 */
+		break;
+	case V4L2_MBUS_FMT_RGB565_2X8_BE:
+		tmp |= 0x22;	/* RGB565 */
+		break;
+	case V4L2_MBUS_FMT_GREY8_1X8:
+	case V4L2_MBUS_FMT_SBGGR8_1X8:
+	case V4L2_MBUS_FMT_SGRBG8_1X8:
+		tmp |= 0x2a;	/* RAW8 */
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	iowrite32(tmp, priv->base + SH_CSI2_VCDT);
+
+	return 0;
+}
+
+static struct v4l2_subdev_video_ops sh_csi2_subdev_video_ops = {
+	.s_mbus_fmt	= sh_csi2_s_fmt,
+	.try_mbus_fmt	= sh_csi2_try_fmt,
+};
+
+static struct v4l2_subdev_core_ops sh_csi2_subdev_core_ops;
+
+static struct v4l2_subdev_ops sh_csi2_subdev_ops = {
+	.core	= &sh_csi2_subdev_core_ops,
+	.video	= &sh_csi2_subdev_video_ops,
+};
+
+static void sh_csi2_hwinit(struct sh_csi2 *priv)
+{
+	struct sh_csi2_pdata *pdata = priv->pdev->dev.platform_data;
+	__u32 tmp = 0x10; /* Enable MIPI CSI clock lane */
+
+	/* Reflect registers immediately */
+	iowrite32(0x00000001, priv->base + SH_CSI2_TREF);
+	/* reset CSI2 harware */
+	iowrite32(0x00000001, priv->base + SH_CSI2_SRST);
+	udelay(5);
+	iowrite32(0x00000000, priv->base + SH_CSI2_SRST);
+
+	if (priv->client->lanes & 3)
+		tmp |= priv->client->lanes & 3;
+	else
+		/* Default - both lanes */
+		tmp |= 3;
+
+	if (priv->client->phy == SH_CSI2_PHY_MAIN)
+		tmp |= 0x8000;
+
+	iowrite32(tmp, priv->base + SH_CSI2_PHYCNT);
+
+	tmp = 0;
+	if (pdata->flags & SH_CSI2_ECC)
+		tmp |= 2;
+	if (pdata->flags & SH_CSI2_CRC)
+		tmp |= 1;
+	iowrite32(tmp, priv->base + SH_CSI2_CHKSUM);
+}
+
+static int sh_csi2_set_bus_param(struct soc_camera_device *icd,
+				 unsigned long flags)
+{
+	return 0;
+}
+
+static unsigned long sh_csi2_query_bus_param(struct soc_camera_device *icd)
+{
+	struct soc_camera_link *icl = to_soc_camera_link(icd);
+	const unsigned long flags = SOCAM_PCLK_SAMPLE_RISING |
+		SOCAM_HSYNC_ACTIVE_HIGH | SOCAM_VSYNC_ACTIVE_HIGH |
+		SOCAM_MASTER | SOCAM_DATAWIDTH_8 | SOCAM_DATA_ACTIVE_HIGH;
+
+	return soc_camera_apply_sensor_flags(icl, flags);
+}
+
+static int sh_csi2_notify(struct notifier_block *nb,
+			  unsigned long action, void *data)
+{
+	struct device *dev = data;
+	struct soc_camera_device *icd = to_soc_camera_dev(dev);
+	struct v4l2_device *v4l2_dev = dev_get_drvdata(dev->parent);
+	struct sh_csi2 *priv =
+		container_of(nb, struct sh_csi2, notifier);
+	struct sh_csi2_pdata *pdata = priv->pdev->dev.platform_data;
+	int ret, i;
+
+	for (i = 0; i < pdata->num_clients; i++)
+		if (&pdata->clients[i].pdev->dev == icd->pdev)
+			break;
+
+	dev_dbg(dev, "%s(%p): action = %lu, found #%d\n", __func__, dev, action, i);
+
+	if (i == pdata->num_clients)
+		return NOTIFY_DONE;
+
+	switch (action) {
+	case BUS_NOTIFY_BOUND_DRIVER:
+		snprintf(priv->subdev.name, V4L2_SUBDEV_NAME_SIZE, "%s%s",
+			 dev_name(v4l2_dev->dev), ".mipi-csi");
+		ret = v4l2_device_register_subdev(v4l2_dev, &priv->subdev);
+		dev_dbg(dev, "%s(%p): ret(register_subdev) = %d\n", __func__, priv, ret);
+		if (ret < 0)
+			return NOTIFY_DONE;
+
+		priv->client = pdata->clients + i;
+
+		icd->ops->set_bus_param		= sh_csi2_set_bus_param;
+		icd->ops->query_bus_param	= sh_csi2_query_bus_param;
+
+		pm_runtime_get_sync(v4l2_get_subdevdata(&priv->subdev));
+
+		sh_csi2_hwinit(priv);
+		break;
+	case BUS_NOTIFY_UNBIND_DRIVER:
+		priv->client = NULL;
+
+		/* Driver is about to be unbound */
+		icd->ops->set_bus_param		= NULL;
+		icd->ops->query_bus_param	= NULL;
+
+		v4l2_device_unregister_subdev(&priv->subdev);
+
+		pm_runtime_put(v4l2_get_subdevdata(&priv->subdev));
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
+static __devinit int sh_csi2_probe(struct platform_device *pdev)
+{
+	struct resource *res;
+	unsigned int irq;
+	int ret;
+	struct sh_csi2 *priv;
+	/* Platform data specify the PHY, lanes, ECC, CRC */
+	struct sh_csi2_pdata *pdata = pdev->dev.platform_data;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	/* Interrupt unused so far */
+	irq = platform_get_irq(pdev, 0);
+
+	if (!res || (int)irq <= 0 || !pdata) {
+		dev_err(&pdev->dev, "Not enough CSI2 platform resources.\n");
+		return -ENODEV;
+	}
+
+	/* TODO: Add support for CSI2I. Careful: different register layout! */
+	if (pdata->type != SH_CSI2C) {
+		dev_err(&pdev->dev, "Only CSI2C supported ATM.\n");
+		return -EINVAL;
+	}
+
+	priv = kzalloc(sizeof(struct sh_csi2), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->irq = irq;
+	priv->notifier.notifier_call = sh_csi2_notify;
+
+	/* We MUST attach after the MIPI sensor */
+	ret = bus_register_notifier(&soc_camera_bus_type, &priv->notifier);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "CSI2 cannot register notifier\n");
+		goto ernotify;
+	}
+
+	if (!request_mem_region(res->start, resource_size(res), pdev->name)) {
+		dev_err(&pdev->dev, "CSI2 register region already claimed\n");
+		ret = -EBUSY;
+		goto ereqreg;
+	}
+
+	priv->base = ioremap(res->start, resource_size(res));
+	if (!priv->base) {
+		ret = -ENXIO;
+		dev_err(&pdev->dev, "Unable to ioremap CSI2 registers.\n");
+		goto eremap;
+	}
+
+	priv->pdev = pdev;
+
+	v4l2_subdev_init(&priv->subdev, &sh_csi2_subdev_ops);
+	v4l2_set_subdevdata(&priv->subdev, &pdev->dev);
+
+	platform_set_drvdata(pdev, priv);
+
+	pm_runtime_enable(&pdev->dev);
+
+	dev_dbg(&pdev->dev, "CSI2 probed.\n");
+
+	return 0;
+
+eremap:
+	release_mem_region(res->start, resource_size(res));
+ereqreg:
+	bus_unregister_notifier(&soc_camera_bus_type, &priv->notifier);
+ernotify:
+	kfree(priv);
+
+	return ret;
+}
+
+static __devexit int sh_csi2_remove(struct platform_device *pdev)
+{
+	struct sh_csi2 *priv = platform_get_drvdata(pdev);
+	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+
+	bus_unregister_notifier(&soc_camera_bus_type, &priv->notifier);
+	pm_runtime_disable(&pdev->dev);
+	iounmap(priv->base);
+	release_mem_region(res->start, resource_size(res));
+	platform_set_drvdata(pdev, NULL);
+	kfree(priv);
+
+	return 0;
+}
+
+static struct platform_driver __refdata sh_csi2_pdrv = {
+	.remove  = __devexit_p(sh_csi2_remove),
+	.driver  = {
+		.name	= "sh-mobile-csi2",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init sh_csi2_init(void)
+{
+	return platform_driver_probe(&sh_csi2_pdrv, sh_csi2_probe);
+}
+
+static void __exit sh_csi2_exit(void)
+{
+	platform_driver_unregister(&sh_csi2_pdrv);
+}
+
+module_init(sh_csi2_init);
+module_exit(sh_csi2_exit);
+
+MODULE_DESCRIPTION("SH-Mobile MIPI CSI-2 driver");
+MODULE_AUTHOR("Guennadi Liakhovetski <g.liakhovetski@gmx.de>");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:sh-mobile-csi2");
diff --git a/include/media/sh_mobile_csi2.h b/include/media/sh_mobile_csi2.h
new file mode 100644
index 0000000..4d26151
--- /dev/null
+++ b/include/media/sh_mobile_csi2.h
@@ -0,0 +1,46 @@
+/*
+ * Driver header for the SH-Mobile MIPI CSI-2 unit
+ *
+ * Copyright (C) 2010, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef SH_MIPI_CSI
+#define SH_MIPI_CSI
+
+enum sh_csi2_phy {
+	SH_CSI2_PHY_MAIN,
+	SH_CSI2_PHY_SUB,
+};
+
+enum sh_csi2_type {
+	SH_CSI2C,
+	SH_CSI2I,
+};
+
+#define SH_CSI2_CRC	(1 << 0)
+#define SH_CSI2_ECC	(1 << 1)
+
+struct platform_device;
+
+struct sh_csi2_client_config {
+	enum sh_csi2_phy phy;
+	unsigned char lanes;		/* bitmask[3:0] */
+	unsigned char channel;		/* 0..3 */
+	struct platform_device *pdev;	/* client platform device */
+};
+
+struct sh_csi2_pdata {
+	enum sh_csi2_type type;
+	unsigned int flags;
+	struct sh_csi2_client_config *clients;
+	int num_clients;
+};
+
+struct device;
+struct v4l2_device;
+
+#endif
-- 
1.6.2.4

