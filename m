Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:14250 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab2BOGCp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Feb 2012 01:02:45 -0500
Received: from epcpsbgm2.samsung.com (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LZF006S17G9YXP0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 15 Feb 2012 15:02:39 +0900 (KST)
Received: from NOSUNGCHUNK01 ([12.23.119.73])
 by mmp1.samsung.com (Oracle Communications Messaging Exchange Server 7u4-19.01
 64bit (built Sep  7 2010)) with ESMTPA id <0LZF00L8N7GESH60@mmp1.samsung.com>
 for linux-media@vger.kernel.org; Wed, 15 Feb 2012 15:02:39 +0900 (KST)
Reply-to: sungchun.kang@samsung.com
From: Sungchun Kang <sungchun.kang@samsung.com>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, mchehab@redhat.com,
	laurent.pinchart@ideasonboard.com, younglak1004.kim@samsung.com,
	june.bae@samsung.com, ym.song@samsung.com, jaeryul.oh@samsung.com,
	sy0816.kang@samsung.com, sungchun.kang@samsung.com,
	jtp.park@samsung.com, jiun.yu@samsung.com, jonghun.han@samsung.com,
	jg1.han@samsung.com, khw0178.kim@samsung.com, kgene.kim@samsung.com
Subject: [PATCH] media: media-dev: Add media devices for EXYNOS5
Date: Wed, 15 Feb 2012 15:02:38 +0900
Message-id: <005301cceba7$6be94fe0$43bbefa0$%kang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since the EXYNOS5 SoCs have various multimedia IPs
such as Gscaler, FIMC-LITE, and MIXER, and so on.
Additionally, media controller interface is needed
to configure connection between them and to control each IPs.

This patch adds support media device for EXYNOS5 SoCs.
Actually, there are three media devices such as below
diagram which are using media control framework.
Since they are not belong to one hardware block, we
need to manage it for connecting with each devices.

Follwing is detailed list of them:

* Gscaler: general scaler
  Support memory to memory interface
  Support output interface from memory to display device(LCD, TV)
  Support capture interface from device(FIMC-LITE, FIMD) to memory

* MIPI-CSIS
  Support interconnection(subdev interface) between devices

* FIMC-LITE
  Support capture interface from device(Sensor, MIPI-CSIS) to memory
  Support interconnection(subdev interface) between devices

* MIXER
  Support output interface from memory to device(HDMI)
  Support interconnection(subdev interface) between devices

* FIMD
  Support framebuffer interface
  Support subdev interface to display frames sent from Gscaler

* Rotator
  Support memory to memory interface

* m2m-scaler
  Support only memory to memory interface

* And so on...

 1) media 0
  LCD Output path consists of Gscaler and FIMD(display controller).
  +----------------+     +------+
  | Gscaler-output | --> | FIMD | --> LCD
  +----------------+     +------+

  HDMI Output path consists of Gscaler, Mixer and HDMI.
  +----------------+     +-------+     +------+
  | Gscaler-output | --> | MIXER | --> | HDMI | --> TV
  +----------------+     +-------+     +------+

+--------+     +-----------+     +-----------+     +-----------------+

 2) media 1
  Camera Capture path consists of MIPI-CSIS, FIMC-LITE and Gscaler
  +--------+     +-----------+     +-----------------+
  | Sensor | --> | FIMC-LITE | --> | Gscaler-capture |
  +--------+     +-----------+     +-----------------+

  +--------+     +-----------+     +-----------+     +-----------------+
  | Sensor | --> | MIPI-CSIS | --> | FIMC-LITE | --> | Gscaler-capture |
  +--------+     +-----------+     +-----------+     +-----------------+

Signed-off-by: Sungchun Kang <sungchun.kang@samsung.com>
---
 drivers/media/video/exynos/mdev/Kconfig       |    8 ++
 drivers/media/video/exynos/mdev/Makefile      |    2 +
 drivers/media/video/exynos/mdev/exynos-mdev.c |  115 ++++++++++++++++++
 include/media/exynos_mc.h                     |  160 +++++++++++++++++++++++++
 4 files changed, 285 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/exynos/mdev/Kconfig
 create mode 100644 drivers/media/video/exynos/mdev/Makefile
 create mode 100644 drivers/media/video/exynos/mdev/exynos-mdev.c
 create mode 100644 include/media/exynos_mc.h

diff --git a/drivers/media/video/exynos/mdev/Kconfig b/drivers/media/video/exynos/mdev/Kconfig
new file mode 100644
index 0000000..15134b0
--- /dev/null
+++ b/drivers/media/video/exynos/mdev/Kconfig
@@ -0,0 +1,8 @@
+config EXYNOS_MEDIA_DEVICE
+	bool
+	depends on MEDIA_EXYNOS
+	select MEDIA_CONTROLLER
+	select VIDEO_V4L2_SUBDEV_API
+	default y
+	help
+	  This is a v4l2 driver for exynos media device.
diff --git a/drivers/media/video/exynos/mdev/Makefile b/drivers/media/video/exynos/mdev/Makefile
new file mode 100644
index 0000000..175a4bc
--- /dev/null
+++ b/drivers/media/video/exynos/mdev/Makefile
@@ -0,0 +1,2 @@
+mdev-objs := exynos-mdev.o
+obj-$(CONFIG_EXYNOS_MEDIA_DEVICE)	+= mdev.o
diff --git a/drivers/media/video/exynos/mdev/exynos-mdev.c b/drivers/media/video/exynos/mdev/exynos-mdev.c
new file mode 100644
index 0000000..a76e7c3
--- /dev/null
+++ b/drivers/media/video/exynos/mdev/exynos-mdev.c
@@ -0,0 +1,115 @@
+/* drviers/media/video/exynos/mdev/exynos-mdev.c
+ *
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * EXYNOS5 SoC series media device driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#include <linux/bug.h>
+#include <linux/device.h>
+#include <linux/errno.h>
+#include <linux/i2c.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+#include <linux/types.h>
+#include <linux/slab.h>
+#include <linux/version.h>
+#include <media/v4l2-ctrls.h>
+#include <media/media-device.h>
+#include <media/exynos_mc.h>
+
+static int __devinit mdev_probe(struct platform_device *pdev)
+{
+	struct v4l2_device *v4l2_dev;
+	struct exynos_md *mdev;
+	int ret;
+
+	mdev = kzalloc(sizeof(struct exynos_md), GFP_KERNEL);
+	if (!mdev)
+		return -ENOMEM;
+
+	mdev->id = pdev->id;
+	mdev->pdev = pdev;
+	spin_lock_init(&mdev->slock);
+
+	snprintf(mdev->media_dev.model, sizeof(mdev->media_dev.model), "%s%d",
+		 dev_name(&pdev->dev), mdev->id);
+
+	mdev->media_dev.dev = &pdev->dev;
+
+	v4l2_dev = &mdev->v4l2_dev;
+	v4l2_dev->mdev = &mdev->media_dev;
+	snprintf(v4l2_dev->name, sizeof(v4l2_dev->name), "%s",
+		 dev_name(&pdev->dev));
+
+	ret = v4l2_device_register(&pdev->dev, &mdev->v4l2_dev);
+	if (ret < 0) {
+		v4l2_err(v4l2_dev, "Failed to register v4l2_device: %d\n", ret);
+		goto err_v4l2_reg;
+	}
+	ret = media_device_register(&mdev->media_dev);
+	if (ret < 0) {
+		v4l2_err(v4l2_dev, "Failed to register media device: %d\n", ret);
+		goto err_mdev_reg;
+	}
+
+	platform_set_drvdata(pdev, mdev);
+	v4l2_info(v4l2_dev, "Media%d[0x%08x] was registered successfully\n",
+		  mdev->id, (unsigned int)mdev);
+	return 0;
+
+err_mdev_reg:
+	v4l2_device_unregister(&mdev->v4l2_dev);
+err_v4l2_reg:
+	kfree(mdev);
+	return ret;
+}
+
+static int __devexit mdev_remove(struct platform_device *pdev)
+{
+	struct exynos_md *mdev = platform_get_drvdata(pdev);
+
+	if (!mdev)
+		return 0;
+	media_device_unregister(&mdev->media_dev);
+	v4l2_device_unregister(&mdev->v4l2_dev);
+	kfree(mdev);
+	return 0;
+}
+
+static struct platform_driver mdev_driver = {
+	.probe		= mdev_probe,
+	.remove		= __devexit_p(mdev_remove),
+	.driver = {
+		.name	= MDEV_MODULE_NAME,
+		.owner	= THIS_MODULE,
+	}
+};
+
+int __init mdev_init(void)
+{
+	int ret = platform_driver_register(&mdev_driver);
+	if (ret)
+		err("platform_driver_register failed: %d\n", ret);
+	return ret;
+}
+
+void __exit mdev_exit(void)
+{
+	platform_driver_unregister(&mdev_driver);
+}
+
+module_init(mdev_init);
+module_exit(mdev_exit);
+
+MODULE_AUTHOR("Hyunwoong Kim <khw0178.kim@samsung.com>");
+MODULE_DESCRIPTION("EXYNOS5 SoC series media device driver");
+MODULE_LICENSE("GPL");
diff --git a/include/media/exynos_mc.h b/include/media/exynos_mc.h
new file mode 100644
index 0000000..54875fb
--- /dev/null
+++ b/include/media/exynos_mc.h
@@ -0,0 +1,160 @@
+/* linux/inclue/media/exynos_mc.h
+ *
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * header file for exynos media device driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef GSC_MDEVICE_H_
+#define GSC_MDEVICE_H_
+
+#include <linux/clk.h>
+#include <linux/platform_device.h>
+#include <linux/mutex.h>
+#include <linux/device.h>
+#include <media/media-device.h>
+#include <media/media-entity.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-subdev.h>
+
+#define err(fmt, args...) \
+	printk(KERN_ERR "%s:%d: " fmt "\n", __func__, __LINE__, ##args)
+
+#define MDEV_MODULE_NAME "exynos-mdev"
+#define MAX_GSC_SUBDEV		4
+#define MDEV_MAX_NUM	3
+
+#define GSC_OUT_PAD_SINK	0
+#define GSC_OUT_PAD_SOURCE	1
+
+#define GSC_CAP_PAD_SINK	0
+#define GSC_CAP_PAD_SOURCE	1
+
+#define FLITE_PAD_SINK		0
+#define FLITE_PAD_SOURCE_PREV	1
+#define FLITE_PAD_SOURCE_CAMCORD	2
+#define FLITE_PAD_SOURCE_MEM		3
+#define FLITE_PADS_NUM		4
+
+#define CSIS_PAD_SINK		0
+#define CSIS_PAD_SOURCE		1
+#define CSIS_PADS_NUM		2
+
+#define MAX_CAMIF_CLIENTS	2
+
+#define MXR_SUBDEV_NAME		"s5p-mixer"
+
+#define GSC_MODULE_NAME			"exynos-gsc"
+#define GSC_SUBDEV_NAME			"exynos-gsc-sd"
+#define FIMD_MODULE_NAME		"s5p-fimd1"
+#define FIMD_ENTITY_NAME		"s3c-fb-window"
+#define FLITE_MODULE_NAME		"exynos-fimc-lite"
+#define CSIS_MODULE_NAME		"s5p-mipi-csis"
+
+#define GSC_CAP_GRP_ID			(1 << 0)
+#define FLITE_GRP_ID			(1 << 1)
+#define CSIS_GRP_ID			(1 << 2)
+#define SENSOR_GRP_ID			(1 << 3)
+#define FIMD_GRP_ID			(1 << 4)
+
+#define SENSOR_MAX_ENTITIES		MAX_CAMIF_CLIENTS
+#define FLITE_MAX_ENTITIES		2
+#define CSIS_MAX_ENTITIES		2
+
+enum mdev_node {
+	MDEV_OUTPUT,
+	MDEV_CAPTURE,
+	MDEV_ISP,
+};
+
+enum mxr_data_from {
+	FROM_GSC_SD,
+	FROM_MXR_VD,
+};
+
+struct exynos_media_ops {
+	int (*power_off)(struct v4l2_subdev *sd);
+};
+
+struct exynos_entity_data {
+	const struct exynos_media_ops *media_ops;
+	enum mxr_data_from mxr_data_from;
+};
+
+/**
+ * struct exynos_md - Exynos media device information
+ * @media_dev: top level media device
+ * @v4l2_dev: top level v4l2_device holding up the subdevs
+ * @pdev: platform device this media device is hooked up into
+ * @slock: spinlock protecting @sensor array
+ * @id: media device IDs
+ * @gsc_sd: each pointer of g-scaler's subdev array
+ */
+struct exynos_md {
+	struct media_device	media_dev;
+	struct v4l2_device	v4l2_dev;
+	struct platform_device	*pdev;
+	struct v4l2_subdev	*gsc_sd[MAX_GSC_SUBDEV];
+	struct v4l2_subdev	*gsc_cap_sd[MAX_GSC_SUBDEV];
+	struct v4l2_subdev	*csis_sd[CSIS_MAX_ENTITIES];
+	struct v4l2_subdev	*flite_sd[FLITE_MAX_ENTITIES];
+	struct v4l2_subdev	*sensor_sd[SENSOR_MAX_ENTITIES];
+	u16			id;
+	spinlock_t slock;
+};
+
+static int dummy_callback(struct device *dev, void *md)
+{
+	/* non-zero return stops iteration */
+	return -1;
+}
+
+static inline void *module_name_to_driver_data(char *module_name)
+{
+	struct device_driver *drv;
+	struct device *dev;
+	void *driver_data;
+
+	drv = driver_find(module_name, &platform_bus_type);
+	if (drv) {
+		dev = driver_find_device(drv, NULL, NULL, dummy_callback);
+		driver_data = dev_get_drvdata(dev);
+		put_driver(drv);
+		return driver_data;
+	} else
+		return NULL;
+}
+
+/* print entity information for debug*/
+static inline void entity_info_print(struct media_entity *me, struct device *dev)
+{
+	u16 num_pads = me->num_pads;
+	u16 num_links = me->num_links;
+	int i;
+
+	dev_dbg(dev, "entity name : %s\n", me->name);
+	dev_dbg(dev, "number of pads = %d\n", num_pads);
+	for (i = 0; i < num_pads; ++i) {
+		dev_dbg(dev, "pad[%d] flag : %s\n", i,
+			(me->pads[i].flags == 1) ? "SINK" : "SOURCE");
+	}
+
+	dev_dbg(dev, "number of links = %d\n", num_links);
+
+	for (i = 0; i < num_links; ++i) {
+		dev_dbg(dev, "link[%d] info  =  ", i);
+		dev_dbg(dev, "%s : %s[%d]  --->  %s : %s[%d]\n",
+			me->links[i].source->entity->name,
+			me->links[i].source->flags == 1 ? "SINK" : "SOURCE",
+			me->links[i].source->index,
+			me->links[i].sink->entity->name,
+			me->links[i].sink->flags == 1 ? "SINK" : "SOURCE",
+			me->links[i].sink->index);
+	}
+}
+#endif
-- 
1.7.1


