Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:31146 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab1FHMDu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jun 2011 08:03:50 -0400
Received: from eu_spt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LMH000KI0686O@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 08 Jun 2011 13:03:48 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LMH00J630673H@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 08 Jun 2011 13:03:44 +0100 (BST)
Date: Wed, 08 Jun 2011 14:03:31 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 3/3] s5p-tv: add drivers for TV on Samsung S5P platform
In-reply-to: <1307534611-32283-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, t.stanislaws@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com,
	sakari.ailus@maxwell.research.nokia.com, mchehab@redhat.com
Message-id: <1307534611-32283-4-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1307534611-32283-1-git-send-email-t.stanislaws@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add drivers for TV outputs on Samsung platforms from S5P family.
- HDMIPHY - auxiliary I2C driver need by TV driver
- HDMI    - generation and control of streaming by HDMI output
- SDO     - streaming analog TV by Composite connector
- MIXER   - merging images from three layers and passing result to the output

Interface:
- 3 video nodes with output queues
- support for multi plane API
- each nodes has up to 2 outputs (HDMI and SDO)
- outputs are controlled by S_STD and S_DV_PRESET ioctls

Drivers are using:
- v4l2 framework
- videobuf2
- videobuf2-dma-contig as memory allocator
- runtime PM

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/video/Kconfig                  |   15 +
 drivers/media/video/Makefile                 |    1 +
 drivers/media/video/s5p-tv/Kconfig           |   69 ++
 drivers/media/video/s5p-tv/Makefile          |   17 +
 drivers/media/video/s5p-tv/hdmi.h            |   73 ++
 drivers/media/video/s5p-tv/hdmi_drv.c        |  999 ++++++++++++++++++++++++++
 drivers/media/video/s5p-tv/hdmiphy_drv.c     |  202 ++++++
 drivers/media/video/s5p-tv/mixer.h           |  368 ++++++++++
 drivers/media/video/s5p-tv/mixer_drv.c       |  494 +++++++++++++
 drivers/media/video/s5p-tv/mixer_grp_layer.c |  181 +++++
 drivers/media/video/s5p-tv/mixer_reg.c       |  540 ++++++++++++++
 drivers/media/video/s5p-tv/mixer_video.c     |  956 ++++++++++++++++++++++++
 drivers/media/video/s5p-tv/mixer_vp_layer.c  |  207 ++++++
 drivers/media/video/s5p-tv/regs-hdmi.h       |  141 ++++
 drivers/media/video/s5p-tv/regs-mixer.h      |  121 ++++
 drivers/media/video/s5p-tv/regs-sdo.h        |   63 ++
 drivers/media/video/s5p-tv/regs-vp.h         |   88 +++
 drivers/media/video/s5p-tv/sdo_drv.c         |  498 +++++++++++++
 18 files changed, 5033 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/s5p-tv/Kconfig
 create mode 100644 drivers/media/video/s5p-tv/Makefile
 create mode 100644 drivers/media/video/s5p-tv/hdmi.h
 create mode 100644 drivers/media/video/s5p-tv/hdmi_drv.c
 create mode 100644 drivers/media/video/s5p-tv/hdmiphy_drv.c
 create mode 100644 drivers/media/video/s5p-tv/mixer.h
 create mode 100644 drivers/media/video/s5p-tv/mixer_drv.c
 create mode 100644 drivers/media/video/s5p-tv/mixer_grp_layer.c
 create mode 100644 drivers/media/video/s5p-tv/mixer_reg.c
 create mode 100644 drivers/media/video/s5p-tv/mixer_video.c
 create mode 100644 drivers/media/video/s5p-tv/mixer_vp_layer.c
 create mode 100644 drivers/media/video/s5p-tv/regs-hdmi.h
 create mode 100644 drivers/media/video/s5p-tv/regs-mixer.h
 create mode 100644 drivers/media/video/s5p-tv/regs-sdo.h
 create mode 100644 drivers/media/video/s5p-tv/regs-vp.h
 create mode 100644 drivers/media/video/s5p-tv/sdo_drv.c

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index bb53de7..bca099a 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -1057,3 +1057,18 @@ config VIDEO_MEM2MEM_TESTDEV
 
 
 endif # V4L_MEM2MEM_DRIVERS
+
+menuconfig VIDEO_OUTPUT_DRIVERS
+	bool "Video output devices"
+	depends on VIDEO_V4L2
+	default y
+	---help---
+	  Say Y here to enable selecting the video output interfaces for
+	  analog/digital modulators.
+
+if VIDEO_OUTPUT_DRIVERS
+
+source "drivers/media/video/s5p-tv/Kconfig"
+
+endif # VIDEO_OUTPUT_DRIVERS
+
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index f0fecd6..f90587d 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -168,6 +168,7 @@ obj-$(CONFIG_VIDEO_SH_MOBILE_CEU)	+= sh_mobile_ceu_camera.o
 obj-$(CONFIG_VIDEO_OMAP1)		+= omap1_camera.o
 
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_FIMC) 	+= s5p-fimc/
+obj-$(CONFIG_VIDEO_SAMSUNG_S5P_TV)	+= s5p-tv/
 
 obj-$(CONFIG_ARCH_DAVINCI)		+= davinci/
 
diff --git a/drivers/media/video/s5p-tv/Kconfig b/drivers/media/video/s5p-tv/Kconfig
new file mode 100644
index 0000000..d5ce651
--- /dev/null
+++ b/drivers/media/video/s5p-tv/Kconfig
@@ -0,0 +1,69 @@
+# drivers/media/video/s5p-tv/Kconfig
+#
+# Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
+#	http://www.samsung.com/
+# Tomasz Stanislawski <t.stanislaws@samsung.com>
+#
+# Licensed under GPL
+
+config VIDEO_SAMSUNG_S5P_TV
+	bool "Samsung TV driver for S5P platform"
+	depends on PLAT_S5P
+	default n
+	---help---
+	  Say Y here to enable selecting the TV output devices for
+	  Samsung S5P platform.
+
+if VIDEO_SAMSUNG_S5P_TV
+
+config VIDEO_SAMSUNG_S5P_MIXER
+	tristate "Samsung Mixer and Video Processor Driver"
+	depends on VIDEO_DEV && VIDEO_V4L2
+	depends on VIDEO_SAMSUNG_S5P_TV
+	select VIDEOBUF2_DMA_CONTIG
+	help
+	  Say Y here if you want support for the Mixer in Samsung S5P SoCs.
+	  This device produce image data to one of output interfaces.
+
+config VIDEO_SAMSUNG_S5P_MIXER_LOG_LEVEL
+	int "Log level for Samsung Mixer/Video Processor Driver"
+	depends on VIDEO_SAMSUNG_S5P_MIXER
+	range 0 7
+	default 6
+	help
+	  Select driver log level 0(emerg) to 7 (debug).
+
+config VIDEO_SAMSUNG_S5P_HDMI
+	tristate "Samsung HDMI Driver"
+	depends on VIDEO_V4L2
+	depends on VIDEO_SAMSUNG_S5P_TV
+	select VIDEO_SAMSUNG_S5P_HDMIPHY
+	help
+	  Say Y here if you want support for the HDMI output
+	  interface in S5P Samsung SoC. The driver can be compiled
+	  as module. It is an auxiliary driver, that exposes a V4L2
+	  subdev for use by other drivers. This driver requires
+	  hdmiphy driver to work correctly.
+
+config VIDEO_SAMSUNG_S5P_HDMIPHY
+	tristate "Samsung HDMIPHY Driver"
+	depends on VIDEO_DEV && VIDEO_V4L2 && I2C
+	depends on VIDEO_SAMSUNG_S5P_TV
+	help
+	  Say Y here if you want support for the physical HDMI
+	  interface in S5P Samsung SoC. The driver can be compiled
+	  as module. It is an I2C driver, that exposes a V4L2
+	  subdev for use by other drivers.
+
+config VIDEO_SAMSUNG_S5P_SDO
+	tristate "Samsung Analog TV Driver"
+	depends on VIDEO_DEV && VIDEO_V4L2
+	depends on VIDEO_SAMSUNG_S5P_TV
+	help
+	  Say Y here if you want support for the analog TV output
+	  interface in S5P Samsung SoC. The driver can be compiled
+	  as module. It is an auxiliary driver, that exposes a V4L2
+	  subdev for use by other drivers. This driver requires
+	  hdmiphy driver to work correctly.
+
+endif # VIDEO_SAMSUNG_S5P_TV
diff --git a/drivers/media/video/s5p-tv/Makefile b/drivers/media/video/s5p-tv/Makefile
new file mode 100644
index 0000000..37e4c17
--- /dev/null
+++ b/drivers/media/video/s5p-tv/Makefile
@@ -0,0 +1,17 @@
+# drivers/media/video/samsung/tvout/Makefile
+#
+# Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
+#	http://www.samsung.com/
+# Tomasz Stanislawski <t.stanislaws@samsung.com>
+#
+# Licensed under GPL
+
+obj-$(CONFIG_VIDEO_SAMSUNG_S5P_HDMIPHY) += s5p-hdmiphy.o
+s5p-hdmiphy-y += hdmiphy_drv.o
+obj-$(CONFIG_VIDEO_SAMSUNG_S5P_HDMI) += s5p-hdmi.o
+s5p-hdmi-y += hdmi_drv.o
+obj-$(CONFIG_VIDEO_SAMSUNG_S5P_SDO) += s5p-sdo.o
+s5p-sdo-y += sdo_drv.o
+obj-$(CONFIG_VIDEO_SAMSUNG_S5P_MIXER) += s5p-mixer.o
+s5p-mixer-y += mixer_drv.o mixer_video.o mixer_reg.o mixer_grp_layer.o mixer_vp_layer.o
+
diff --git a/drivers/media/video/s5p-tv/hdmi.h b/drivers/media/video/s5p-tv/hdmi.h
new file mode 100644
index 0000000..824fb27
--- /dev/null
+++ b/drivers/media/video/s5p-tv/hdmi.h
@@ -0,0 +1,73 @@
+/*
+ * Samsung HDMI interface driver
+ *
+ * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
+ *
+ * Tomasz Stanislawski, <t.stanislaws@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundiation. either version 2 of the License,
+ * or (at your option) any later version
+ */
+
+#ifndef SAMSUNG_HDMI_H
+#define SAMSUNG_HDMI_H __FILE__
+
+#include <linux/kernel.h>
+#include <linux/videodev2.h>
+#include <media/v4l2-mediabus.h>
+
+struct hdmi_tg_regs {
+	u8 cmd;
+	u8 h_fsz_l;
+	u8 h_fsz_h;
+	u8 hact_st_l;
+	u8 hact_st_h;
+	u8 hact_sz_l;
+	u8 hact_sz_h;
+	u8 v_fsz_l;
+	u8 v_fsz_h;
+	u8 vsync_l;
+	u8 vsync_h;
+	u8 vsync2_l;
+	u8 vsync2_h;
+	u8 vact_st_l;
+	u8 vact_st_h;
+	u8 vact_sz_l;
+	u8 vact_sz_h;
+	u8 field_chg_l;
+	u8 field_chg_h;
+	u8 vact_st2_l;
+	u8 vact_st2_h;
+	u8 vsync_top_hdmi_l;
+	u8 vsync_top_hdmi_h;
+	u8 vsync_bot_hdmi_l;
+	u8 vsync_bot_hdmi_h;
+	u8 field_top_hdmi_l;
+	u8 field_top_hdmi_h;
+	u8 field_bot_hdmi_l;
+	u8 field_bot_hdmi_h;
+};
+
+struct hdmi_core_regs {
+	u8 h_blank[2];
+	u8 v_blank[3];
+	u8 h_v_line[3];
+	u8 vsync_pol[1];
+	u8 int_pro_mode[1];
+	u8 v_blank_f[3];
+	u8 h_sync_gen[3];
+	u8 v_sync_gen1[3];
+	u8 v_sync_gen2[3];
+	u8 v_sync_gen3[3];
+};
+
+struct hdmi_preset_conf {
+	struct hdmi_core_regs core;
+	struct hdmi_tg_regs tg;
+	struct v4l2_mbus_framefmt mbus_fmt;
+};
+
+#endif /* SAMSUNG_HDMI_H */
+
diff --git a/drivers/media/video/s5p-tv/hdmi_drv.c b/drivers/media/video/s5p-tv/hdmi_drv.c
new file mode 100644
index 0000000..6209bb6
--- /dev/null
+++ b/drivers/media/video/s5p-tv/hdmi_drv.c
@@ -0,0 +1,999 @@
+/*
+ * Samsung HDMI interface driver
+ *
+ * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
+ *
+ * Tomasz Stanislawski, <t.stanislaws@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundiation. either version 2 of the License,
+ * or (at your option) any later version
+ */
+
+#include "hdmi.h"
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/io.h>
+#include <linux/i2c.h>
+#include <linux/platform_device.h>
+#include <media/v4l2-subdev.h>
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/delay.h>
+#include <linux/bug.h>
+#include <linux/pm_runtime.h>
+#include <linux/clk.h>
+#include <linux/regulator/consumer.h>
+
+#include <media/v4l2-common.h>
+#include <media/v4l2-dev.h>
+#include <media/v4l2-device.h>
+
+#include "regs-hdmi.h"
+
+MODULE_AUTHOR("Tomasz Stanislawski, <t.stanislaws@samsung.com>");
+MODULE_DESCRIPTION("Samsung HDMI");
+MODULE_LICENSE("GPL");
+
+/* default preset configured on probe */
+#define HDMI_DEFAULT_PRESET V4L2_DV_1080P60
+
+/* D R I V E R   I N I T I A L I Z A T I O N */
+
+static struct platform_driver hdmi_driver;
+
+static int __init hdmi_init(void)
+{
+	int ret;
+	static const char banner[] __initdata = KERN_INFO \
+		"Samsung HDMI output driver, "
+		"(c) 2010-2011 Samsung Electronics Co., Ltd.\n";
+	printk(banner);
+
+	ret = platform_driver_register(&hdmi_driver);
+	if (ret)
+		printk(KERN_ERR "HDMI platform driver register failed\n");
+
+	return ret;
+}
+module_init(hdmi_init);
+
+static void __exit hdmi_exit(void)
+{
+	platform_driver_unregister(&hdmi_driver);
+}
+module_exit(hdmi_exit);
+
+struct hdmi_resources {
+	struct clk *hdmi;
+	struct clk *sclk_hdmi;
+	struct clk *sclk_pixel;
+	struct clk *sclk_hdmiphy;
+	struct clk *hdmiphy;
+	struct regulator_bulk_data *regul_bulk;
+	int regul_count;
+};
+
+struct hdmi_device {
+	/** base address of HDMI registers */
+	void __iomem *regs;
+	/** HDMI interrupt */
+	unsigned int irq;
+	/** pointer to device parent */
+	struct device *dev;
+	/** subdev generated by HDMI device */
+	struct v4l2_subdev sd;
+	/** V4L2 device structure */
+	struct v4l2_device vdev;
+	/** subdev of HDMIPHY interface */
+	struct v4l2_subdev *phy_sd;
+	/** configuration of current graphic mode */
+	const struct hdmi_preset_conf *cur_conf;
+	/** current preset */
+	u32 cur_preset;
+	/** other resources */
+	struct hdmi_resources res;
+};
+
+struct hdmi_driver_data {
+	int hdmiphy_bus;
+};
+
+/* I2C module and id for HDMIPHY */
+static struct i2c_board_info hdmiphy_info = {
+	I2C_BOARD_INFO("hdmiphy", 0x38),
+};
+
+static struct hdmi_driver_data hdmi_driver_data[] = {
+	{ .hdmiphy_bus = 3 },
+	{ .hdmiphy_bus = 8 },
+};
+
+static struct platform_device_id hdmi_driver_types[] = {
+	{
+		.name		= "s5pv210-hdmi",
+		.driver_data	= (unsigned long)&hdmi_driver_data[0],
+	}, {
+		.name		= "exynos4-hdmi",
+		.driver_data	= (unsigned long)&hdmi_driver_data[1],
+	}, {
+		/* end node */
+	}
+};
+
+static irqreturn_t hdmi_irq_handler(int irq, void *dev_data);
+
+static const struct v4l2_subdev_ops hdmi_sd_ops;
+
+static const struct hdmi_preset_conf *hdmi_preset2conf(u32 preset);
+
+static struct hdmi_device *sd_to_hdmi_dev(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct hdmi_device, sd);
+}
+
+static int hdmi_resources_init(struct hdmi_device *hdev);
+static void hdmi_resources_cleanup(struct hdmi_device *hdev);
+
+static int __devinit hdmi_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct resource *res;
+	struct i2c_adapter *phy_adapter;
+	struct v4l2_subdev *sd;
+	struct hdmi_device *hdmi_dev = NULL;
+	struct hdmi_driver_data *drv_data;
+	int ret;
+
+	dev_info(dev, "probe start\n");
+
+	hdmi_dev = kzalloc(sizeof(*hdmi_dev), GFP_KERNEL);
+	if (!hdmi_dev) {
+		dev_err(dev, "out of memory\n");
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	hdmi_dev->dev = dev;
+
+	ret = hdmi_resources_init(hdmi_dev);
+	if (ret)
+		goto fail_hdev;
+
+	/* mapping HDMI registers */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res == NULL) {
+		dev_err(dev, "get memory resource failed.\n");
+		ret = -ENXIO;
+		goto fail_init;
+	}
+
+	hdmi_dev->regs = ioremap(res->start, resource_size(res));
+	if (hdmi_dev->regs == NULL) {
+		dev_err(dev, "register mapping failed.\n");
+		ret = -ENXIO;
+		goto fail_hdev;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (res == NULL) {
+		dev_err(dev, "get interrupt resource failed.\n");
+		ret = -ENXIO;
+		goto fail_regs;
+	}
+
+	ret = request_irq(res->start, hdmi_irq_handler, 0, "hdmi", hdmi_dev);
+	if (ret) {
+		dev_err(dev, "request interrupt failed.\n");
+		goto fail_regs;
+	}
+	hdmi_dev->irq = res->start;
+
+	ret = v4l2_device_register(dev, &hdmi_dev->vdev);
+	if (ret) {
+		dev_err(dev, "could not register v4l2 device.\n");
+		goto fail_irq;
+	}
+
+	drv_data = (struct hdmi_driver_data *)
+		platform_get_device_id(pdev)->driver_data;
+	phy_adapter = i2c_get_adapter(drv_data->hdmiphy_bus);
+	if (phy_adapter == NULL) {
+		dev_err(dev, "adapter request failed\n");
+		ret = -ENXIO;
+		goto fail_vdev;
+	}
+
+	hdmi_dev->phy_sd = v4l2_i2c_new_subdev_board(&hdmi_dev->vdev,
+		phy_adapter, &hdmiphy_info, NULL);
+	/* on failure or not adapter is no longer useful */
+	i2c_put_adapter(phy_adapter);
+	if (hdmi_dev->phy_sd == NULL) {
+		dev_err(dev, "missing subdev for hdmiphy\n");
+		ret = -ENODEV;
+		goto fail_vdev;
+	}
+
+	pm_runtime_enable(dev);
+
+	sd = &hdmi_dev->sd;
+	v4l2_subdev_init(sd, &hdmi_sd_ops);
+	sd->owner = THIS_MODULE;
+
+	strlcpy(sd->name, hdmi_driver.driver.name, sizeof sd->name);
+	hdmi_dev->cur_preset = HDMI_DEFAULT_PRESET;
+	/* FIXME: missing fail preset is not supported */
+	hdmi_dev->cur_conf = hdmi_preset2conf(hdmi_dev->cur_preset);
+
+	/* storing subdev for call that have only access to struct device */
+	dev_set_drvdata(dev, sd);
+
+	dev_info(dev, "probe sucessful\n");
+
+	return 0;
+
+fail_vdev:
+	v4l2_device_unregister(&hdmi_dev->vdev);
+
+fail_irq:
+	free_irq(hdmi_dev->irq, hdmi_dev);
+
+fail_regs:
+	iounmap(hdmi_dev->regs);
+
+fail_init:
+	hdmi_resources_cleanup(hdmi_dev);
+
+fail_hdev:
+	kfree(hdmi_dev);
+
+fail:
+	dev_info(dev, "probe failed\n");
+	return ret;
+}
+
+static int __devexit hdmi_remove(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct v4l2_subdev *sd = dev_get_drvdata(dev);
+	struct hdmi_device *hdmi_dev = sd_to_hdmi_dev(sd);
+
+	pm_runtime_disable(dev);
+	v4l2_device_unregister(&hdmi_dev->vdev);
+	disable_irq(hdmi_dev->irq);
+	free_irq(hdmi_dev->irq, hdmi_dev);
+	iounmap(hdmi_dev->regs);
+	hdmi_resources_cleanup(hdmi_dev);
+	kfree(hdmi_dev);
+	dev_info(dev, "remove sucessful\n");
+
+	return 0;
+}
+
+static void hdmi_resource_poweron(struct hdmi_resources *res);
+static void hdmi_resource_poweroff(struct hdmi_resources *res);
+static int hdmi_conf_apply(struct hdmi_device *hdmi_dev);
+
+static int hdmi_runtime_suspend(struct device *dev)
+{
+	struct v4l2_subdev *sd = dev_get_drvdata(dev);
+	struct hdmi_device *hdev = sd_to_hdmi_dev(sd);
+
+	dev_info(dev, "%s\n", __func__);
+	hdmi_resource_poweroff(&hdev->res);
+	return 0;
+}
+
+static int hdmi_runtime_resume(struct device *dev)
+{
+	struct v4l2_subdev *sd = dev_get_drvdata(dev);
+	struct hdmi_device *hdev = sd_to_hdmi_dev(sd);
+	int ret = 0;
+
+	dev_info(dev, "%s\n", __func__);
+
+	hdmi_resource_poweron(&hdev->res);
+
+	ret = hdmi_conf_apply(hdev);
+	if (ret)
+		goto fail;
+
+	dev_info(dev, "poweron succeed\n");
+
+	return 0;
+
+fail:
+	hdmi_resource_poweroff(&hdev->res);
+	dev_info(dev, "poweron failed\n");
+
+	return ret;
+}
+
+static const struct dev_pm_ops hdmi_pm_ops = {
+	.runtime_suspend = hdmi_runtime_suspend,
+	.runtime_resume	 = hdmi_runtime_resume,
+};
+
+static struct platform_driver hdmi_driver __refdata = {
+	.probe = hdmi_probe,
+	.remove = __devexit_p(hdmi_remove),
+	.id_table = hdmi_driver_types,
+	.driver = {
+		.name = "s5p-hdmi",
+		.owner = THIS_MODULE,
+		.pm = &hdmi_pm_ops,
+	}
+};
+
+static int hdmi_resources_init(struct hdmi_device *hdev)
+{
+	struct device *dev = hdev->dev;
+	struct hdmi_resources *res = &hdev->res;
+	static char *supply[] = {
+		"hdmi-en",
+		"vdd",
+		"vdd_osc",
+		"vdd_pll",
+	};
+	int i, ret;
+
+	dev_info(dev, "HDMI resource init\n");
+
+	memset(res, 0, sizeof *res);
+	/* get clocks, power */
+
+	res->hdmi = clk_get(dev, "hdmi");
+	if (IS_ERR_OR_NULL(res->hdmi)) {
+		dev_err(dev, "failed to get clock 'hdmi'\n");
+		goto fail;
+	}
+	res->sclk_hdmi = clk_get(dev, "sclk_hdmi");
+	if (IS_ERR_OR_NULL(res->sclk_hdmi)) {
+		dev_err(dev, "failed to get clock 'sclk_hdmi'\n");
+		goto fail;
+	}
+	res->sclk_pixel = clk_get(dev, "sclk_pixel");
+	if (IS_ERR_OR_NULL(res->sclk_pixel)) {
+		dev_err(dev, "failed to get clock 'sclk_pixel'\n");
+		goto fail;
+	}
+	res->sclk_hdmiphy = clk_get(dev, "sclk_hdmiphy");
+	if (IS_ERR_OR_NULL(res->sclk_hdmiphy)) {
+		dev_err(dev, "failed to get clock 'sclk_hdmiphy'\n");
+		goto fail;
+	}
+	res->hdmiphy = clk_get(dev, "hdmiphy");
+	if (IS_ERR_OR_NULL(res->hdmiphy)) {
+		dev_err(dev, "failed to get clock 'hdmiphy'\n");
+		goto fail;
+	}
+	res->regul_bulk = kzalloc(ARRAY_SIZE(supply) *
+		sizeof res->regul_bulk[0], GFP_KERNEL);
+	if (!res->regul_bulk) {
+		dev_err(dev, "failed to get memory for regulators\n");
+		goto fail;
+	}
+	for (i = 0; i < ARRAY_SIZE(supply); ++i) {
+		res->regul_bulk[i].supply = supply[i];
+		res->regul_bulk[i].consumer = NULL;
+	}
+
+	ret = regulator_bulk_get(dev, ARRAY_SIZE(supply), res->regul_bulk);
+	if (ret) {
+		dev_err(dev, "failed to get regulators\n");
+		goto fail;
+	}
+	res->regul_count = ARRAY_SIZE(supply);
+
+	return 0;
+fail:
+	dev_err(dev, "HDMI resource init - failed\n");
+	hdmi_resources_cleanup(hdev);
+	return -ENODEV;
+}
+
+static void hdmi_resources_cleanup(struct hdmi_device *hdev)
+{
+	struct hdmi_resources *res = &hdev->res;
+
+	dev_info(hdev->dev, "HDMI resource cleanup\n");
+	/* put clocks, power */
+	if (res->regul_count)
+		regulator_bulk_free(res->regul_count, res->regul_bulk);
+	/* kfree is NULL-safe */
+	kfree(res->regul_bulk);
+	if (!IS_ERR_OR_NULL(res->hdmiphy))
+		clk_put(res->hdmiphy);
+	if (!IS_ERR_OR_NULL(res->sclk_hdmiphy))
+		clk_put(res->sclk_hdmiphy);
+	if (!IS_ERR_OR_NULL(res->sclk_pixel))
+		clk_put(res->sclk_pixel);
+	if (!IS_ERR_OR_NULL(res->sclk_hdmi))
+		clk_put(res->sclk_hdmi);
+	if (!IS_ERR_OR_NULL(res->hdmi))
+		clk_put(res->hdmi);
+	memset(res, 0, sizeof *res);
+}
+
+static inline
+void hdmi_write(struct hdmi_device *hdev, u32 reg_id, u32 value)
+{
+	writel(value, hdev->regs + reg_id);
+}
+
+static inline
+void hdmi_write_mask(struct hdmi_device *hdev, u32 reg_id, u32 value, u32 mask)
+{
+	u32 old = readl(hdev->regs + reg_id);
+	value = (value & mask) | (old & ~mask);
+	writel(value, hdev->regs + reg_id);
+}
+
+static inline
+void hdmi_writeb(struct hdmi_device *hdev, u32 reg_id, u8 value)
+{
+	writeb(value, hdev->regs + reg_id);
+}
+
+static inline u32 hdmi_read(struct hdmi_device *hdev, u32 reg_id)
+{
+	return readl(hdev->regs + reg_id);
+}
+
+static irqreturn_t hdmi_irq_handler(int irq, void *dev_data)
+{
+	struct hdmi_device *hdev = dev_data;
+	u32 intc_flag;
+
+	(void)irq;
+	intc_flag = hdmi_read(hdev, HDMI_INTC_FLAG);
+	/* clearing flags for HPD plug/unplug */
+	if (intc_flag & HDMI_INTC_FLAG_HPD_UNPLUG) {
+		printk(KERN_INFO "unplugged\n");
+		hdmi_write_mask(hdev, HDMI_INTC_FLAG, ~0,
+			HDMI_INTC_FLAG_HPD_UNPLUG);
+	}
+	if (intc_flag & HDMI_INTC_FLAG_HPD_PLUG) {
+		printk(KERN_INFO "plugged\n");
+		hdmi_write_mask(hdev, HDMI_INTC_FLAG, ~0,
+			HDMI_INTC_FLAG_HPD_PLUG);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int hdmi_s_dv_preset(struct v4l2_subdev *sd,
+	struct v4l2_dv_preset *preset);
+
+static void hdmi_resource_poweron(struct hdmi_resources *res)
+{
+	/* turn HDMI power on */
+	regulator_bulk_enable(res->regul_count, res->regul_bulk);
+	/* power-on hdmi physical interface */
+	clk_enable(res->hdmiphy);
+	/* use VPP as parent clock; HDMIPHY is not working yet */
+	clk_set_parent(res->sclk_hdmi, res->sclk_pixel);
+	/* turn clocks on */
+	clk_enable(res->hdmi);
+	clk_enable(res->sclk_hdmi);
+}
+
+static void hdmi_resource_poweroff(struct hdmi_resources *res)
+{
+	/* turn clocks off */
+	clk_disable(res->sclk_hdmi);
+	clk_disable(res->hdmi);
+	/* power-off hdmiphy */
+	clk_disable(res->hdmiphy);
+	/* turn HDMI power off */
+	regulator_bulk_disable(res->regul_count, res->regul_bulk);
+}
+
+static int hdmi_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct hdmi_device *hdev = sd_to_hdmi_dev(sd);
+	int ret;
+
+	if (on)
+		ret = pm_runtime_get_sync(hdev->dev);
+	else
+		ret = pm_runtime_put_sync(hdev->dev);
+	/* only values < 0 indicate errors */
+	return IS_ERR_VALUE(ret) ? ret : 0;
+}
+
+static void hdmi_timing_apply(struct hdmi_device *hdev,
+	const struct hdmi_preset_conf *conf);
+static void hdmi_dumpregs(struct hdmi_device *hdev, char *prefix);
+
+static void hdmi_reg_init(struct hdmi_device *hdev)
+{
+	/* enable HPD interrupts */
+	hdmi_write_mask(hdev, HDMI_INTC_CON, ~0, HDMI_INTC_EN_GLOBAL |
+		HDMI_INTC_EN_HPD_PLUG | HDMI_INTC_EN_HPD_UNPLUG);
+	/* choose HDMI mode */
+	hdmi_write_mask(hdev, HDMI_MODE_SEL,
+		HDMI_MODE_HDMI_EN, HDMI_MODE_MASK);
+	/* disable bluescreen */
+	hdmi_write_mask(hdev, HDMI_CON_0, 0, HDMI_BLUE_SCR_EN);
+	/* choose bluescreen (fecal) color */
+	hdmi_writeb(hdev, HDMI_BLUE_SCREEN_0, 0x12);
+	hdmi_writeb(hdev, HDMI_BLUE_SCREEN_1, 0x34);
+	hdmi_writeb(hdev, HDMI_BLUE_SCREEN_2, 0x56);
+	/* enable AVI packet every vsync, fixes purple line problem */
+	hdmi_writeb(hdev, HDMI_AVI_CON, 0x02);
+	/* force YUV444, look to CEA-861-D, table 7 for more detail */
+	hdmi_writeb(hdev, HDMI_AVI_BYTE(0), 2 << 5);
+	hdmi_write_mask(hdev, HDMI_CON_1, 2, 3 << 5);
+}
+
+static int hdmi_conf_apply(struct hdmi_device *hdmi_dev)
+{
+	struct device *dev = hdmi_dev->dev;
+	const struct hdmi_preset_conf *conf = hdmi_dev->cur_conf;
+	struct v4l2_dv_preset preset;
+	int ret;
+
+	dev_info(dev, "%s\n", __func__);
+
+	/* reset hdmiphy */
+	hdmi_write_mask(hdmi_dev, HDMI_PHY_RSTOUT, ~0, HDMI_PHY_SW_RSTOUT);
+	mdelay(10);
+	hdmi_write_mask(hdmi_dev, HDMI_PHY_RSTOUT,  0, HDMI_PHY_SW_RSTOUT);
+	mdelay(10);
+
+	/* configure presets */
+	preset.preset = hdmi_dev->cur_preset;
+	ret = v4l2_subdev_call(hdmi_dev->phy_sd, video, s_dv_preset, &preset);
+	if (ret) {
+		dev_err(dev, "failed to set preset (%u)\n", preset.preset);
+		return ret;
+	}
+
+	/* resetting HDMI core */
+	hdmi_write_mask(hdmi_dev, HDMI_CORE_RSTOUT,  0, HDMI_CORE_SW_RSTOUT);
+	mdelay(10);
+	hdmi_write_mask(hdmi_dev, HDMI_CORE_RSTOUT, ~0, HDMI_CORE_SW_RSTOUT);
+	mdelay(10);
+
+	hdmi_reg_init(hdmi_dev);
+
+	/* setting core registers */
+	hdmi_timing_apply(hdmi_dev, conf);
+
+	return 0;
+}
+
+static int hdmi_s_dv_preset(struct v4l2_subdev *sd,
+	struct v4l2_dv_preset *preset)
+{
+	struct hdmi_device *hdev = sd_to_hdmi_dev(sd);
+	struct device *dev = hdev->dev;
+	const struct hdmi_preset_conf *conf;
+
+	conf = hdmi_preset2conf(preset->preset);
+	if (conf == NULL) {
+		dev_err(dev, "preset (%u) not supported\n", preset->preset);
+		return -ENXIO;
+	}
+	hdev->cur_conf = conf;
+	hdev->cur_preset = preset->preset;
+	return 0;
+}
+
+static int hdmi_enum_dv_presets(struct v4l2_subdev *sd,
+	struct v4l2_dv_enum_preset *preset);
+
+static int hdmi_g_mbus_fmt(struct v4l2_subdev *sd,
+	  struct v4l2_mbus_framefmt *fmt)
+{
+	struct hdmi_device *hdev = sd_to_hdmi_dev(sd);
+	struct device *dev = hdev->dev;
+
+	dev_info(dev, "%s\n", __func__);
+	if (!hdev->cur_conf)
+		return -ENXIO;
+	*fmt = hdev->cur_conf->mbus_fmt;
+	return 0;
+}
+
+static int hdmi_streamon(struct hdmi_device *hdev)
+{
+	struct device *dev = hdev->dev;
+	struct hdmi_resources *res = &hdev->res;
+	int ret, tries;
+
+	dev_info(dev, "%s\n", __func__);
+
+	ret = v4l2_subdev_call(hdev->phy_sd, video, s_stream, 1);
+	if (ret)
+		return ret;
+
+	/* waiting for HDMIPHY's PLL to get to steady state */
+	for (tries = 100; tries; --tries) {
+		u32 val = hdmi_read(hdev, HDMI_PHY_STATUS);
+		if (val & HDMI_PHY_STATUS_READY)
+			break;
+		mdelay(1);
+	}
+	/* steady state not achieved */
+	if (tries == 0) {
+		dev_err(dev, "hdmiphy's pll could not reach steady state.\n");
+		v4l2_subdev_call(hdev->phy_sd, video, s_stream, 0);
+		hdmi_dumpregs(hdev, "s_stream");
+		return -EIO;
+	}
+
+	/* hdmiphy clock is used for HDMI in streaming mode */
+	clk_disable(res->sclk_hdmi);
+	clk_set_parent(res->sclk_hdmi, res->sclk_hdmiphy);
+	clk_enable(res->sclk_hdmi);
+
+	/* enable HDMI and timing generator */
+	hdmi_write_mask(hdev, HDMI_CON_0, ~0, HDMI_EN);
+	hdmi_write_mask(hdev, HDMI_TG_CMD, ~0, HDMI_TG_EN);
+	hdmi_dumpregs(hdev, "streamon");
+	return 0;
+}
+
+static int hdmi_streamoff(struct hdmi_device *hdev)
+{
+	struct device *dev = hdev->dev;
+	struct hdmi_resources *res = &hdev->res;
+
+	dev_info(dev, "%s\n", __func__);
+
+	hdmi_write_mask(hdev, HDMI_CON_0, 0, HDMI_EN);
+	hdmi_write_mask(hdev, HDMI_TG_CMD, 0, HDMI_TG_EN);
+
+	/* pixel(vpll) clock is used for HDMI in config mode */
+	clk_disable(res->sclk_hdmi);
+	clk_set_parent(res->sclk_hdmi, res->sclk_pixel);
+	clk_enable(res->sclk_hdmi);
+
+	v4l2_subdev_call(hdev->phy_sd, video, s_stream, 0);
+
+	hdmi_dumpregs(hdev, "streamoff");
+	return 0;
+}
+
+static int hdmi_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct hdmi_device *hdev = sd_to_hdmi_dev(sd);
+	struct device *dev = hdev->dev;
+
+	dev_info(dev, "%s(%d)\n", __func__, enable);
+	if (enable)
+		return hdmi_streamon(hdev);
+	else
+		return hdmi_streamoff(hdev);
+}
+
+static const struct v4l2_subdev_core_ops hdmi_sd_core_ops = {
+	.s_power = hdmi_s_power,
+};
+
+static const struct v4l2_subdev_video_ops hdmi_sd_video_ops = {
+	.s_dv_preset = hdmi_s_dv_preset,
+	.enum_dv_presets = hdmi_enum_dv_presets,
+	.g_mbus_fmt = hdmi_g_mbus_fmt,
+	.s_stream = hdmi_s_stream,
+};
+
+static const struct v4l2_subdev_ops hdmi_sd_ops = {
+	.core = &hdmi_sd_core_ops,
+	.video = &hdmi_sd_video_ops,
+};
+
+static void hdmi_timing_apply(struct hdmi_device *hdev,
+	const struct hdmi_preset_conf *conf)
+{
+	const struct hdmi_core_regs *core = &conf->core;
+	const struct hdmi_tg_regs *tg = &conf->tg;
+
+	/* setting core registers */
+	hdmi_writeb(hdev, HDMI_H_BLANK_0, core->h_blank[0]);
+	hdmi_writeb(hdev, HDMI_H_BLANK_1, core->h_blank[1]);
+	hdmi_writeb(hdev, HDMI_V_BLANK_0, core->v_blank[0]);
+	hdmi_writeb(hdev, HDMI_V_BLANK_1, core->v_blank[1]);
+	hdmi_writeb(hdev, HDMI_V_BLANK_2, core->v_blank[2]);
+	hdmi_writeb(hdev, HDMI_H_V_LINE_0, core->h_v_line[0]);
+	hdmi_writeb(hdev, HDMI_H_V_LINE_1, core->h_v_line[1]);
+	hdmi_writeb(hdev, HDMI_H_V_LINE_2, core->h_v_line[2]);
+	hdmi_writeb(hdev, HDMI_VSYNC_POL, core->vsync_pol[0]);
+	hdmi_writeb(hdev, HDMI_INT_PRO_MODE, core->int_pro_mode[0]);
+	hdmi_writeb(hdev, HDMI_V_BLANK_F_0, core->v_blank_f[0]);
+	hdmi_writeb(hdev, HDMI_V_BLANK_F_1, core->v_blank_f[1]);
+	hdmi_writeb(hdev, HDMI_V_BLANK_F_2, core->v_blank_f[2]);
+	hdmi_writeb(hdev, HDMI_H_SYNC_GEN_0, core->h_sync_gen[0]);
+	hdmi_writeb(hdev, HDMI_H_SYNC_GEN_1, core->h_sync_gen[1]);
+	hdmi_writeb(hdev, HDMI_H_SYNC_GEN_2, core->h_sync_gen[2]);
+	hdmi_writeb(hdev, HDMI_V_SYNC_GEN_1_0, core->v_sync_gen1[0]);
+	hdmi_writeb(hdev, HDMI_V_SYNC_GEN_1_1, core->v_sync_gen1[1]);
+	hdmi_writeb(hdev, HDMI_V_SYNC_GEN_1_2, core->v_sync_gen1[2]);
+	hdmi_writeb(hdev, HDMI_V_SYNC_GEN_2_0, core->v_sync_gen2[0]);
+	hdmi_writeb(hdev, HDMI_V_SYNC_GEN_2_1, core->v_sync_gen2[1]);
+	hdmi_writeb(hdev, HDMI_V_SYNC_GEN_2_2, core->v_sync_gen2[2]);
+	hdmi_writeb(hdev, HDMI_V_SYNC_GEN_3_0, core->v_sync_gen3[0]);
+	hdmi_writeb(hdev, HDMI_V_SYNC_GEN_3_1, core->v_sync_gen3[1]);
+	hdmi_writeb(hdev, HDMI_V_SYNC_GEN_3_2, core->v_sync_gen3[2]);
+	/* Timing generator registers */
+	hdmi_writeb(hdev, HDMI_TG_H_FSZ_L, tg->h_fsz_l);
+	hdmi_writeb(hdev, HDMI_TG_H_FSZ_H, tg->h_fsz_h);
+	hdmi_writeb(hdev, HDMI_TG_HACT_ST_L, tg->hact_st_l);
+	hdmi_writeb(hdev, HDMI_TG_HACT_ST_H, tg->hact_st_h);
+	hdmi_writeb(hdev, HDMI_TG_HACT_SZ_L, tg->hact_sz_l);
+	hdmi_writeb(hdev, HDMI_TG_HACT_SZ_H, tg->hact_sz_h);
+	hdmi_writeb(hdev, HDMI_TG_V_FSZ_L, tg->v_fsz_l);
+	hdmi_writeb(hdev, HDMI_TG_V_FSZ_H, tg->v_fsz_h);
+	hdmi_writeb(hdev, HDMI_TG_VSYNC_L, tg->vsync_l);
+	hdmi_writeb(hdev, HDMI_TG_VSYNC_H, tg->vsync_h);
+	hdmi_writeb(hdev, HDMI_TG_VSYNC2_L, tg->vsync2_l);
+	hdmi_writeb(hdev, HDMI_TG_VSYNC2_H, tg->vsync2_h);
+	hdmi_writeb(hdev, HDMI_TG_VACT_ST_L, tg->vact_st_l);
+	hdmi_writeb(hdev, HDMI_TG_VACT_ST_H, tg->vact_st_h);
+	hdmi_writeb(hdev, HDMI_TG_VACT_SZ_L, tg->vact_sz_l);
+	hdmi_writeb(hdev, HDMI_TG_VACT_SZ_H, tg->vact_sz_h);
+	hdmi_writeb(hdev, HDMI_TG_FIELD_CHG_L, tg->field_chg_l);
+	hdmi_writeb(hdev, HDMI_TG_FIELD_CHG_H, tg->field_chg_h);
+	hdmi_writeb(hdev, HDMI_TG_VACT_ST2_L, tg->vact_st2_l);
+	hdmi_writeb(hdev, HDMI_TG_VACT_ST2_H, tg->vact_st2_h);
+	hdmi_writeb(hdev, HDMI_TG_VSYNC_TOP_HDMI_L, tg->vsync_top_hdmi_l);
+	hdmi_writeb(hdev, HDMI_TG_VSYNC_TOP_HDMI_H, tg->vsync_top_hdmi_h);
+	hdmi_writeb(hdev, HDMI_TG_VSYNC_BOT_HDMI_L, tg->vsync_bot_hdmi_l);
+	hdmi_writeb(hdev, HDMI_TG_VSYNC_BOT_HDMI_H, tg->vsync_bot_hdmi_h);
+	hdmi_writeb(hdev, HDMI_TG_FIELD_TOP_HDMI_L, tg->field_top_hdmi_l);
+	hdmi_writeb(hdev, HDMI_TG_FIELD_TOP_HDMI_H, tg->field_top_hdmi_h);
+	hdmi_writeb(hdev, HDMI_TG_FIELD_BOT_HDMI_L, tg->field_bot_hdmi_l);
+	hdmi_writeb(hdev, HDMI_TG_FIELD_BOT_HDMI_H, tg->field_bot_hdmi_h);
+}
+
+static const struct hdmi_preset_conf hdmi_conf_480p = {
+	.core = {
+		.h_blank = {0x8a, 0x00},
+		.v_blank = {0x0d, 0x6a, 0x01},
+		.h_v_line = {0x0d, 0xa2, 0x35},
+		.vsync_pol = {0x01},
+		.int_pro_mode = {0x00},
+		.v_blank_f = {0x00, 0x00, 0x00},
+		.h_sync_gen = {0x0e, 0x30, 0x11},
+		.v_sync_gen1 = {0x0f, 0x90, 0x00},
+		/* other don't care */
+	},
+	.tg = {
+		0x00, /* cmd */
+		0x5a, 0x03, /* h_fsz */
+		0x8a, 0x00, 0xd0, 0x02, /* hact */
+		0x0d, 0x02, /* v_fsz */
+		0x01, 0x00, 0x33, 0x02, /* vsync */
+		0x2d, 0x00, 0xe0, 0x01, /* vact */
+		0x33, 0x02, /* field_chg */
+		0x49, 0x02, /* vact_st2 */
+		0x01, 0x00, 0x33, 0x02, /* vsync top/bot */
+		0x01, 0x00, 0x33, 0x02, /* field top/bot */
+	},
+	.mbus_fmt = {
+		.width = 720,
+		.height = 480,
+		.code = V4L2_MBUS_FMT_FIXED, /* means RGB888 */
+		.field = V4L2_FIELD_NONE,
+	},
+};
+
+static const struct hdmi_preset_conf hdmi_conf_720p60 = {
+	.core = {
+		.h_blank = {0x72, 0x01},
+		.v_blank = {0xee, 0xf2, 0x00},
+		.h_v_line = {0xee, 0x22, 0x67},
+		.vsync_pol = {0x00},
+		.int_pro_mode = {0x00},
+		.v_blank_f = {0x00, 0x00, 0x00}, /* don't care */
+		.h_sync_gen = {0x6c, 0x50, 0x02},
+		.v_sync_gen1 = {0x0a, 0x50, 0x00},
+		/* other don't care */
+	},
+	.tg = {
+		0x00, /* cmd */
+		0x72, 0x06, /* h_fsz */
+		0x72, 0x01, 0x00, 0x05, /* hact */
+		0xee, 0x02, /* v_fsz */
+		0x01, 0x00, 0x33, 0x02, /* vsync */
+		0x1e, 0x00, 0xd0, 0x02, /* vact */
+		0x33, 0x02, /* field_chg */
+		0x49, 0x02, /* vact_st2 */
+		0x01, 0x00, 0x33, 0x02, /* vsync top/bot */
+		0x01, 0x00, 0x33, 0x02, /* field top/bot */
+	},
+	.mbus_fmt = {
+		.width = 1280,
+		.height = 720,
+		.code = V4L2_MBUS_FMT_FIXED, /* means RGB888 */
+		.field = V4L2_FIELD_NONE,
+	},
+};
+
+static const struct hdmi_preset_conf hdmi_conf_1080p50 = {
+	.core = {
+		.h_blank = {0xd0, 0x02},
+		.v_blank = {0x65, 0x6c, 0x01},
+		.h_v_line = {0x65, 0x04, 0xa5},
+		.vsync_pol = {0x00},
+		.int_pro_mode = {0x00},
+		.v_blank_f = {0x00, 0x00, 0x00}, /* don't care */
+		.h_sync_gen = {0x0e, 0xea, 0x08},
+		.v_sync_gen1 = {0x09, 0x40, 0x00},
+		/* other don't care */
+	},
+	.tg = {
+		0x00, /* cmd */
+		0x98, 0x08, /* h_fsz */
+		0x18, 0x01, 0x80, 0x07, /* hact */
+		0x65, 0x04, /* v_fsz */
+		0x01, 0x00, 0x33, 0x02, /* vsync */
+		0x2d, 0x00, 0x38, 0x04, /* vact */
+		0x33, 0x02, /* field_chg */
+		0x49, 0x02, /* vact_st2 */
+		0x01, 0x00, 0x33, 0x02, /* vsync top/bot */
+		0x01, 0x00, 0x33, 0x02, /* field top/bot */
+	},
+	.mbus_fmt = {
+		.width = 1920,
+		.height = 1080,
+		.code = V4L2_MBUS_FMT_FIXED, /* means RGB888 */
+		.field = V4L2_FIELD_NONE,
+	},
+};
+
+static const struct hdmi_preset_conf hdmi_conf_1080p60 = {
+	.core = {
+		.h_blank = {0x18, 0x01},
+		.v_blank = {0x65, 0x6c, 0x01},
+		.h_v_line = {0x65, 0x84, 0x89},
+		.vsync_pol = {0x00},
+		.int_pro_mode = {0x00},
+		.v_blank_f = {0x00, 0x00, 0x00}, /* don't care */
+		.h_sync_gen = {0x56, 0x08, 0x02},
+		.v_sync_gen1 = {0x09, 0x40, 0x00},
+		/* other don't care */
+	},
+	.tg = {
+		0x00, /* cmd */
+		0x98, 0x08, /* h_fsz */
+		0x18, 0x01, 0x80, 0x07, /* hact */
+		0x65, 0x04, /* v_fsz */
+		0x01, 0x00, 0x33, 0x02, /* vsync */
+		0x2d, 0x00, 0x38, 0x04, /* vact */
+		0x33, 0x02, /* field_chg */
+		0x48, 0x02, /* vact_st2 */
+		0x01, 0x00, 0x01, 0x00, /* vsync top/bot */
+		0x01, 0x00, 0x33, 0x02, /* field top/bot */
+	},
+	.mbus_fmt = {
+		.width = 1920,
+		.height = 1080,
+		.code = V4L2_MBUS_FMT_FIXED, /* means RGB888 */
+		.field = V4L2_FIELD_NONE,
+	},
+};
+
+static const struct {
+	u32 preset;
+	const struct hdmi_preset_conf *conf;
+} hdmi_conf[] = {
+	{ V4L2_DV_480P59_94, &hdmi_conf_480p },
+	{ V4L2_DV_720P59_94, &hdmi_conf_720p60 },
+	{ V4L2_DV_1080P50, &hdmi_conf_1080p50 },
+	{ V4L2_DV_1080P30, &hdmi_conf_1080p60 },
+	{ V4L2_DV_1080P60, &hdmi_conf_1080p60 },
+	{ V4L2_DV_1080P59_94, &hdmi_conf_1080p60 },
+};
+
+static const struct hdmi_preset_conf *hdmi_preset2conf(u32 preset)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(hdmi_conf); ++i)
+		if (hdmi_conf[i].preset == preset)
+			return  hdmi_conf[i].conf;
+	return NULL;
+}
+
+static int hdmi_enum_dv_presets(struct v4l2_subdev *sd,
+	struct v4l2_dv_enum_preset *preset)
+{
+	if (preset->index >= ARRAY_SIZE(hdmi_conf))
+		return -EINVAL;
+	return v4l_fill_dv_preset_info(hdmi_conf[preset->index].preset, preset);
+}
+
+static void hdmi_dumpregs(struct hdmi_device *hdev, char *prefix)
+{
+#define DUMPREG(reg_id) \
+	printk(KERN_DEBUG "%s:" #reg_id " = %08x\n", prefix, \
+	readl(hdev->regs + reg_id))
+
+	printk(KERN_ERR "%s: ---- CONTROL REGISTERS ----\n", prefix);
+	DUMPREG(HDMI_INTC_FLAG);
+	DUMPREG(HDMI_INTC_CON);
+	DUMPREG(HDMI_HPD_STATUS);
+	DUMPREG(HDMI_PHY_RSTOUT);
+	DUMPREG(HDMI_PHY_VPLL);
+	DUMPREG(HDMI_PHY_CMU);
+	DUMPREG(HDMI_CORE_RSTOUT);
+
+	printk(KERN_ERR "%s: ---- CORE REGISTERS ----\n", prefix);
+	DUMPREG(HDMI_CON_0);
+	DUMPREG(HDMI_CON_1);
+	DUMPREG(HDMI_CON_2);
+	DUMPREG(HDMI_SYS_STATUS);
+	DUMPREG(HDMI_PHY_STATUS);
+	DUMPREG(HDMI_STATUS_EN);
+	DUMPREG(HDMI_HPD);
+	DUMPREG(HDMI_MODE_SEL);
+	DUMPREG(HDMI_HPD_GEN);
+	DUMPREG(HDMI_DC_CONTROL);
+	DUMPREG(HDMI_VIDEO_PATTERN_GEN);
+
+	printk(KERN_ERR "%s: ---- CORE SYNC REGISTERS ----\n", prefix);
+	DUMPREG(HDMI_H_BLANK_0);
+	DUMPREG(HDMI_H_BLANK_1);
+	DUMPREG(HDMI_V_BLANK_0);
+	DUMPREG(HDMI_V_BLANK_1);
+	DUMPREG(HDMI_V_BLANK_2);
+	DUMPREG(HDMI_H_V_LINE_0);
+	DUMPREG(HDMI_H_V_LINE_1);
+	DUMPREG(HDMI_H_V_LINE_2);
+	DUMPREG(HDMI_VSYNC_POL);
+	DUMPREG(HDMI_INT_PRO_MODE);
+	DUMPREG(HDMI_V_BLANK_F_0);
+	DUMPREG(HDMI_V_BLANK_F_1);
+	DUMPREG(HDMI_V_BLANK_F_2);
+	DUMPREG(HDMI_H_SYNC_GEN_0);
+	DUMPREG(HDMI_H_SYNC_GEN_1);
+	DUMPREG(HDMI_H_SYNC_GEN_2);
+	DUMPREG(HDMI_V_SYNC_GEN_1_0);
+	DUMPREG(HDMI_V_SYNC_GEN_1_1);
+	DUMPREG(HDMI_V_SYNC_GEN_1_2);
+	DUMPREG(HDMI_V_SYNC_GEN_2_0);
+	DUMPREG(HDMI_V_SYNC_GEN_2_1);
+	DUMPREG(HDMI_V_SYNC_GEN_2_2);
+	DUMPREG(HDMI_V_SYNC_GEN_3_0);
+	DUMPREG(HDMI_V_SYNC_GEN_3_1);
+	DUMPREG(HDMI_V_SYNC_GEN_3_2);
+
+	printk(KERN_ERR "%s: ---- TG REGISTERS ----\n", prefix);
+	DUMPREG(HDMI_TG_CMD);
+	DUMPREG(HDMI_TG_H_FSZ_L);
+	DUMPREG(HDMI_TG_H_FSZ_H);
+	DUMPREG(HDMI_TG_HACT_ST_L);
+	DUMPREG(HDMI_TG_HACT_ST_H);
+	DUMPREG(HDMI_TG_HACT_SZ_L);
+	DUMPREG(HDMI_TG_HACT_SZ_H);
+	DUMPREG(HDMI_TG_V_FSZ_L);
+	DUMPREG(HDMI_TG_V_FSZ_H);
+	DUMPREG(HDMI_TG_VSYNC_L);
+	DUMPREG(HDMI_TG_VSYNC_H);
+	DUMPREG(HDMI_TG_VSYNC2_L);
+	DUMPREG(HDMI_TG_VSYNC2_H);
+	DUMPREG(HDMI_TG_VACT_ST_L);
+	DUMPREG(HDMI_TG_VACT_ST_H);
+	DUMPREG(HDMI_TG_VACT_SZ_L);
+	DUMPREG(HDMI_TG_VACT_SZ_H);
+	DUMPREG(HDMI_TG_FIELD_CHG_L);
+	DUMPREG(HDMI_TG_FIELD_CHG_H);
+	DUMPREG(HDMI_TG_VACT_ST2_L);
+	DUMPREG(HDMI_TG_VACT_ST2_H);
+	DUMPREG(HDMI_TG_VSYNC_TOP_HDMI_L);
+	DUMPREG(HDMI_TG_VSYNC_TOP_HDMI_H);
+	DUMPREG(HDMI_TG_VSYNC_BOT_HDMI_L);
+	DUMPREG(HDMI_TG_VSYNC_BOT_HDMI_H);
+	DUMPREG(HDMI_TG_FIELD_TOP_HDMI_L);
+	DUMPREG(HDMI_TG_FIELD_TOP_HDMI_H);
+	DUMPREG(HDMI_TG_FIELD_BOT_HDMI_L);
+	DUMPREG(HDMI_TG_FIELD_BOT_HDMI_H);
+#undef DUMPREG
+}
+
diff --git a/drivers/media/video/s5p-tv/hdmiphy_drv.c b/drivers/media/video/s5p-tv/hdmiphy_drv.c
new file mode 100644
index 0000000..14f9590
--- /dev/null
+++ b/drivers/media/video/s5p-tv/hdmiphy_drv.c
@@ -0,0 +1,202 @@
+/*
+ * Samsung HDMI Physical interface driver
+ *
+ * Copyright (C) 2010-2011 Samsung Electronics Co.Ltd
+ * Author: Tomasz Stanislawski <t.stanislaws@samsung.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/slab.h>
+#include <linux/clk.h>
+#include <linux/io.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/err.h>
+
+#include <media/v4l2-subdev.h>
+
+MODULE_AUTHOR("Tomasz Stanislawski <t.stanislaws@samsung.com>");
+MODULE_DESCRIPTION("Samsung HDMI Physical interface driver");
+MODULE_LICENSE("GPL");
+
+struct hdmiphy_conf {
+	u32 preset;
+	const u8 *data;
+};
+
+static struct i2c_driver hdmiphy_driver;
+static const struct v4l2_subdev_ops hdmiphy_ops;
+static const struct hdmiphy_conf hdmiphy_conf[];
+
+static int __init hdmiphy_init(void)
+{
+	return i2c_add_driver(&hdmiphy_driver);
+}
+module_init(hdmiphy_init);
+
+static void __exit hdmiphy_exit(void)
+{
+	i2c_del_driver(&hdmiphy_driver);
+}
+module_exit(hdmiphy_exit);
+
+static int __devinit hdmiphy_probe(struct i2c_client *client,
+	const struct i2c_device_id *id)
+{
+	static struct v4l2_subdev sd;
+
+	v4l2_i2c_subdev_init(&sd, client, &hdmiphy_ops);
+	dev_info(&client->dev, "probe successful\n");
+	return 0;
+}
+
+static int __devexit hdmiphy_remove(struct i2c_client *client)
+{
+	dev_info(&client->dev, "remove successful\n");
+	return 0;
+}
+
+static const struct i2c_device_id hdmiphy_id[] = {
+	{ "hdmiphy", 0 },
+	{ },
+};
+MODULE_DEVICE_TABLE(i2c, hdmiphy_id);
+
+static struct i2c_driver hdmiphy_driver = {
+	.driver = {
+		.name	= "s5p-hdmiphy",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= hdmiphy_probe,
+	.remove		= __devexit_p(hdmiphy_remove),
+	.id_table = hdmiphy_id,
+};
+
+static int hdmiphy_s_power(struct v4l2_subdev *sd, int on)
+{
+	/* to be implemented */
+	return 0;
+}
+
+const u8 *hdmiphy_preset2conf(u32 preset)
+{
+	int i;
+	for (i = 0; hdmiphy_conf[i].preset != V4L2_DV_INVALID; ++i)
+		if (hdmiphy_conf[i].preset == preset)
+			return hdmiphy_conf[i].data;
+	return NULL;
+}
+
+static int hdmiphy_s_dv_preset(struct v4l2_subdev *sd,
+	struct v4l2_dv_preset *preset)
+{
+	const u8 *data;
+	u8 buffer[32];
+	int ret;
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct device *dev = &client->dev;
+
+	dev_info(dev, "s_dv_preset(preset = %d)\n", preset->preset);
+	data = hdmiphy_preset2conf(preset->preset);
+	if (!data) {
+		dev_err(dev, "format not supported\n");
+		return -ENXIO;
+	}
+
+	/* storing configuration to the device */
+	memcpy(buffer, data, 32);
+	ret = i2c_master_send(client, buffer, 32);
+	if (ret != 32) {
+		dev_err(dev, "failed to configure HDMIPHY via I2C\n");
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int hdmiphy_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct device *dev = &client->dev;
+	u8 buffer[2];
+	int ret;
+
+	dev_info(dev, "s_stream(%d)\n", enable);
+	/* going to/from configuration from/to operation mode */
+	buffer[0] = 0x1f;
+	buffer[1] = enable ? 0x80 : 0x00;
+
+	ret = i2c_master_send(client, buffer, 2);
+	if (ret != 2) {
+		dev_err(dev, "stream (%d) failed\n", enable);
+		return -EIO;
+	}
+	return 0;
+}
+
+static const struct v4l2_subdev_core_ops hdmiphy_core_ops = {
+	.s_power =  hdmiphy_s_power,
+};
+
+static const struct v4l2_subdev_video_ops hdmiphy_video_ops = {
+	.s_dv_preset = hdmiphy_s_dv_preset,
+	.s_stream =  hdmiphy_s_stream,
+};
+
+static const struct v4l2_subdev_ops hdmiphy_ops = {
+	.core = &hdmiphy_core_ops,
+	.video = &hdmiphy_video_ops,
+};
+
+static const u8 hdmiphy_conf27[32] = {
+	0x01, 0x05, 0x00, 0xD8, 0x10, 0x1C, 0x30, 0x40,
+	0x6B, 0x10, 0x02, 0x51, 0xDf, 0xF2, 0x54, 0x87,
+	0x84, 0x00, 0x30, 0x38, 0x00, 0x08, 0x10, 0xE0,
+	0x22, 0x40, 0xe3, 0x26, 0x00, 0x00, 0x00, 0x00,
+};
+
+static const u8 hdmiphy_conf74_175[32] = {
+	0x01, 0x05, 0x00, 0xD8, 0x10, 0x9C, 0xef, 0x5B,
+	0x6D, 0x10, 0x01, 0x51, 0xef, 0xF3, 0x54, 0xb9,
+	0x84, 0x00, 0x30, 0x38, 0x00, 0x08, 0x10, 0xE0,
+	0x22, 0x40, 0xa5, 0x26, 0x01, 0x00, 0x00, 0x00,
+};
+
+static const u8 hdmiphy_conf74_25[32] = {
+	0x01, 0x05, 0x00, 0xd8, 0x10, 0x9c, 0xf8, 0x40,
+	0x6a, 0x10, 0x01, 0x51, 0xff, 0xf1, 0x54, 0xba,
+	0x84, 0x00, 0x30, 0x38, 0x00, 0x08, 0x10, 0xe0,
+	0x22, 0x40, 0xa4, 0x26, 0x01, 0x00, 0x00, 0x00,
+};
+
+static const u8 hdmiphy_conf148_5[32] = {
+	0x01, 0x05, 0x00, 0xD8, 0x10, 0x9C, 0xf8, 0x40,
+	0x6A, 0x18, 0x00, 0x51, 0xff, 0xF1, 0x54, 0xba,
+	0x84, 0x00, 0x10, 0x38, 0x00, 0x08, 0x10, 0xE0,
+	0x22, 0x40, 0xa4, 0x26, 0x02, 0x00, 0x00, 0x00,
+};
+
+static const u8 hdmiphy_conf148_35[32] = {
+	0x01, 0x05, 0x00, 0xD8, 0x10, 0x9C, 0xef, 0x5B,
+	0x6D, 0x18, 0x00, 0x51, 0xef, 0xF3, 0x54, 0xb9,
+	0x84, 0x00, 0x30, 0x38, 0x00, 0x08, 0x10, 0xE0,
+	0x22, 0x40, 0xa5, 0x26, 0x02, 0x00, 0x00, 0x00,
+};
+
+static const struct hdmiphy_conf hdmiphy_conf[] = {
+	{ V4L2_DV_480P59_94, hdmiphy_conf27 },
+	{ V4L2_DV_1080P30, hdmiphy_conf74_175 },
+	{ V4L2_DV_720P59_94, hdmiphy_conf74_175 },
+	{ V4L2_DV_720P60, hdmiphy_conf74_25 },
+	{ V4L2_DV_1080P50, hdmiphy_conf148_5 },
+	{ V4L2_DV_1080P60, hdmiphy_conf148_5 },
+	{ V4L2_DV_1080P59_94, hdmiphy_conf148_35},
+	{ V4L2_DV_INVALID, NULL },
+};
+
diff --git a/drivers/media/video/s5p-tv/mixer.h b/drivers/media/video/s5p-tv/mixer.h
new file mode 100644
index 0000000..6176b0a
--- /dev/null
+++ b/drivers/media/video/s5p-tv/mixer.h
@@ -0,0 +1,368 @@
+/*
+ * Samsung TV Mixer driver
+ *
+ * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
+ *
+ * Tomasz Stanislawski, <t.stanislaws@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundiation. either version 2 of the License,
+ * or (at your option) any later version
+ */
+
+#ifndef SAMSUNG_MIXER_H
+#define SAMSUNG_MIXER_H
+
+#if CONFIG_VIDEO_SAMSUNG_S5P_MIXER_LOG_LEVEL >= 7
+	#define DEBUG
+#endif
+
+#include <linux/fb.h>
+#include <linux/kernel.h>
+#include <linux/spinlock.h>
+#include <linux/wait.h>
+#include <media/v4l2-device.h>
+#include <media/videobuf2-core.h>
+
+#include "regs-mixer.h"
+
+/** maximum number of output interfaces */
+#define MXR_MAX_OUTPUTS 2
+/** maximum number of input interfaces (layers) */
+#define MXR_MAX_LAYERS 3
+#define MXR_DRIVER_NAME "s5p-mixer"
+/** maximal number of planes for every layer */
+#define MXR_MAX_PLANES	2
+
+#define MXR_ENABLE 1
+#define MXR_DISABLE 0
+
+/** description of a macroblock for packed formats */
+struct mxr_block {
+	/** vertical number of pixels in macroblock */
+	unsigned int width;
+	/** horizontal number of pixels in macroblock */
+	unsigned int height;
+	/** size of block in bytes */
+	unsigned int size;
+};
+
+/** description of supported format */
+struct mxr_format {
+	/** format name/mnemonic */
+	char *name;
+	/** fourcc identifier */
+	u32 fourcc;
+	/** number of planes in image data */
+	int num_planes;
+	/** description of block for each plane */
+	struct mxr_block plane[MXR_MAX_PLANES];
+	/** number of subframes in image data */
+	int num_subframes;
+	/** specifies to which subframe belong given plane */
+	int plane2subframe[MXR_MAX_PLANES];
+	/** internal code, driver dependant */
+	unsigned long cookie;
+};
+
+/** description of crop configuration for image */
+struct mxr_crop {
+	/** width of layer in pixels */
+	unsigned int full_width;
+	/** height of layer in pixels */
+	unsigned int full_height;
+	/** horizontal offset of first pixel to be displayed */
+	unsigned int x_offset;
+	/** vertical offset of first pixel to be displayed */
+	unsigned int y_offset;
+	/** width of displayed data in pixels */
+	unsigned int width;
+	/** height of displayed data in pixels */
+	unsigned int height;
+	/** indicate which fields are present in buffer */
+	unsigned int field;
+};
+
+/** description of transformation from source to destination image */
+struct mxr_geometry {
+	/** cropping for source image */
+	struct mxr_crop src;
+	/** cropping for destination image */
+	struct mxr_crop dst;
+	/** layer-dependant description of horizontal scaling */
+	unsigned int x_ratio;
+	/** layer-dependant description of vertical scaling */
+	unsigned int y_ratio;
+};
+
+/** instance of a buffer */
+struct mxr_buffer {
+	/** common v4l buffer stuff -- must be first */
+	struct vb2_buffer	vb;
+	/** node for layer's lists */
+	struct list_head	list;
+};
+
+
+/** internal states of layer */
+enum mxr_layer_state {
+	/** layers is not shown */
+	MXR_LAYER_IDLE = 0,
+	/** state between STREAMON and hardware start */
+	MXR_LAYER_STREAMING_START,
+	/** layer is shown */
+	MXR_LAYER_STREAMING,
+	/** state before STREAMOFF is finished */
+	MXR_LAYER_STREAMING_FINISH,
+};
+
+/** forward declarations */
+struct mxr_device;
+struct mxr_layer;
+
+/** callback for layers operation */
+struct mxr_layer_ops {
+	/* TODO: try to port it to subdev API */
+	/** handler for resource release function */
+	void (*release)(struct mxr_layer *);
+	/** setting buffer to HW */
+	void (*buffer_set)(struct mxr_layer *, struct mxr_buffer *);
+	/** setting format and geometry in HW */
+	void (*format_set)(struct mxr_layer *);
+	/** streaming stop/start */
+	void (*stream_set)(struct mxr_layer *, int);
+	/** adjusting geometry */
+	void (*fix_geometry)(struct mxr_layer *);
+};
+
+/** layer instance, a single window and content displayed on output */
+struct mxr_layer {
+	/** parent mixer device */
+	struct mxr_device *mdev;
+	/** layer index (unique identifier) */
+	int idx;
+	/** callbacks for layer methods */
+	struct mxr_layer_ops ops;
+	/** format array */
+	const struct mxr_format **fmt_array;
+	/** size of format array */
+	unsigned long fmt_array_size;
+
+	/** lock for protection of list and state fields */
+	spinlock_t enq_slock;
+	/** list for enqueued buffers */
+	struct list_head enq_list;
+	/** buffer currently owned by hardware in temporary registers */
+	struct mxr_buffer *update_buf;
+	/** buffer currently owned by hardware in shadow registers */
+	struct mxr_buffer *shadow_buf;
+	/** state of layer IDLE/STREAMING */
+	enum mxr_layer_state state;
+
+	/** mutex for protection of fields below */
+	struct mutex mutex;
+	/** use count */
+	int n_user;
+	/** handler for video node */
+	struct video_device vfd;
+	/** queue for output buffers */
+	struct vb2_queue vb_queue;
+	/** current image format */
+	const struct mxr_format *fmt;
+	/** current geometry of image */
+	struct mxr_geometry geo;
+};
+
+/** description of mixers output interface */
+struct mxr_output {
+	/** name of output */
+	char name[32];
+	/** output subdev */
+	struct v4l2_subdev *sd;
+	/** cookie used for configuration of registers */
+	int cookie;
+};
+
+/** specify source of output subdevs */
+struct mxr_output_conf {
+	/** name of output (connector) */
+	char *output_name;
+	/** name of module that generates output subdev */
+	char *module_name;
+	/** cookie need for mixer HW */
+	int cookie;
+};
+
+struct clk;
+struct regulator;
+
+/** auxiliary resources used my mixer */
+struct mxr_resources {
+	/** interrupt index */
+	int irq;
+	/** pointer to Mixer registers */
+	void __iomem *mxr_regs;
+	/** pointer to Video Processor registers */
+	void __iomem *vp_regs;
+	/** other resources, should used under mxr_device.mutex */
+	struct clk *mixer;
+	struct clk *vp;
+	struct clk *sclk_mixer;
+	struct clk *sclk_hdmi;
+	struct clk *sclk_dac;
+};
+
+/* event flags used  */
+enum mxr_devide_flags {
+	MXR_EVENT_VSYNC = 0,
+};
+
+/** drivers instance */
+struct mxr_device {
+	/** master device */
+	struct device *dev;
+	/** state of each layer */
+	struct mxr_layer *layer[MXR_MAX_LAYERS];
+	/** state of each output */
+	struct mxr_output *output[MXR_MAX_OUTPUTS];
+	/** number of registered outputs */
+	int output_cnt;
+
+	/* video resources */
+
+	/** V4L2 device */
+	struct v4l2_device v4l2_dev;
+	/** context of allocator */
+	void *alloc_ctx;
+	/** event wait queue */
+	wait_queue_head_t event_queue;
+	/** state flags */
+	unsigned long event_flags;
+
+	/** spinlock for protection of registers */
+	spinlock_t reg_slock;
+
+	/** mutex for protection of fields below */
+	struct mutex mutex;
+	/** number of entities depndant on output configuration */
+	int n_output;
+	/** number of users that do streaming */
+	int n_streamer;
+	/** index of current output */
+	int current_output;
+	/** auxiliary resources used my mixer */
+	struct mxr_resources res;
+};
+
+/** transform device structure into mixer device */
+static inline struct mxr_device *to_mdev(struct device *dev)
+{
+	struct v4l2_device *vdev = dev_get_drvdata(dev);
+	return container_of(vdev, struct mxr_device, v4l2_dev);
+}
+
+/** get current output data, should be called under mdev's mutex */
+static inline struct mxr_output *to_output(struct mxr_device *mdev)
+{
+	return mdev->output[mdev->current_output];
+}
+
+/** get current output subdev, should be called under mdev's mutex */
+static inline struct v4l2_subdev *to_outsd(struct mxr_device *mdev)
+{
+	struct mxr_output *out = to_output(mdev);
+	return out ? out->sd : NULL;
+}
+
+/** forward declaration for mixer platform data */
+struct mxr_platform_data;
+
+/** acquiring common video resources */
+int __devinit mxr_acquire_video(struct mxr_device *mdev,
+	struct mxr_output_conf *output_cont, int output_count);
+
+/** releasing common video resources */
+void __devexit mxr_release_video(struct mxr_device *mdev);
+
+struct mxr_layer *mxr_graph_layer_create(struct mxr_device *mdev, int idx);
+struct mxr_layer *mxr_vp_layer_create(struct mxr_device *mdev, int idx);
+struct mxr_layer *mxr_base_layer_create(struct mxr_device *mdev,
+	int idx, char *name, struct mxr_layer_ops *ops);
+
+void mxr_base_layer_release(struct mxr_layer *layer);
+void mxr_layer_release(struct mxr_layer *layer);
+
+int mxr_base_layer_register(struct mxr_layer *layer);
+void mxr_base_layer_unregister(struct mxr_layer *layer);
+
+unsigned long mxr_get_plane_size(const struct mxr_block *blk,
+	unsigned int width, unsigned int height);
+
+/** adds new consumer for mixer's power */
+int __must_check mxr_power_get(struct mxr_device *mdev);
+/** removes consumer for mixer's power */
+void mxr_power_put(struct mxr_device *mdev);
+/** add new client for output configuration */
+void mxr_output_get(struct mxr_device *mdev);
+/** removes new client for output configuration */
+void mxr_output_put(struct mxr_device *mdev);
+/** add new client for streaming */
+void mxr_streamer_get(struct mxr_device *mdev);
+/** removes new client for streaming */
+void mxr_streamer_put(struct mxr_device *mdev);
+/** returns format of data delivared to current output */
+void mxr_get_mbus_fmt(struct mxr_device *mdev,
+	struct v4l2_mbus_framefmt *mbus_fmt);
+
+/* Debug */
+
+#if CONFIG_VIDEO_SAMSUNG_S5P_MIXER_LOG_LEVEL >= 3
+	#define mxr_err(mdev, fmt, ...)  dev_err(mdev->dev, fmt, ##__VA_ARGS__)
+#else
+	#define mxr_err(mdev, fmt, ...)  do { (void) mdev; } while (0)
+#endif
+
+#if CONFIG_VIDEO_SAMSUNG_S5P_MIXER_LOG_LEVEL >= 4
+	#define mxr_warn(mdev, fmt, ...) dev_warn(mdev->dev, fmt, ##__VA_ARGS__)
+#else
+	#define mxr_warn(mdev, fmt, ...)  do { (void) mdev; } while (0)
+#endif
+
+#if CONFIG_VIDEO_SAMSUNG_S5P_MIXER_LOG_LEVEL >= 6
+	#define mxr_info(mdev, fmt, ...) dev_info(mdev->dev, fmt, ##__VA_ARGS__)
+#else
+	#define mxr_info(mdev, fmt, ...)  do {(void) mdev; } while (0)
+#endif
+
+#if CONFIG_VIDEO_SAMSUNG_S5P_MIXER_LOG_LEVEL >= 7
+	#define mxr_dbg(mdev, fmt, ...)  dev_dbg(mdev->dev, fmt, ##__VA_ARGS__)
+#else
+	#define mxr_dbg(mdev, fmt, ...)  do { (void) mdev; } while (0)
+#endif
+
+/* accessing Mixer's and Video Processor's registers */
+
+void mxr_vsync_set_update(struct mxr_device *mdev, int en);
+void mxr_reg_reset(struct mxr_device *mdev);
+irqreturn_t mxr_irq_handler(int irq, void *dev_data);
+void mxr_reg_s_output(struct mxr_device *mdev, int cookie);
+void mxr_reg_streamon(struct mxr_device *mdev);
+void mxr_reg_streamoff(struct mxr_device *mdev);
+int mxr_reg_wait4vsync(struct mxr_device *mdev);
+void mxr_reg_set_mbus_fmt(struct mxr_device *mdev,
+	struct v4l2_mbus_framefmt *fmt);
+void mxr_reg_graph_layer_stream(struct mxr_device *mdev, int idx, int en);
+void mxr_reg_graph_buffer(struct mxr_device *mdev, int idx, dma_addr_t addr);
+void mxr_reg_graph_format(struct mxr_device *mdev, int idx,
+	const struct mxr_format *fmt, const struct mxr_geometry *geo);
+
+void mxr_reg_vp_layer_stream(struct mxr_device *mdev, int en);
+void mxr_reg_vp_buffer(struct mxr_device *mdev,
+	dma_addr_t luma_addr[2], dma_addr_t chroma_addr[2]);
+void mxr_reg_vp_format(struct mxr_device *mdev,
+	const struct mxr_format *fmt, const struct mxr_geometry *geo);
+void mxr_reg_dump(struct mxr_device *mdev);
+
+#endif /* SAMSUNG_MIXER_H */
+
diff --git a/drivers/media/video/s5p-tv/mixer_drv.c b/drivers/media/video/s5p-tv/mixer_drv.c
new file mode 100644
index 0000000..5dca57b
--- /dev/null
+++ b/drivers/media/video/s5p-tv/mixer_drv.c
@@ -0,0 +1,494 @@
+/*
+ * Samsung TV Mixer driver
+ *
+ * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
+ *
+ * Tomasz Stanislawski, <t.stanislaws@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundiation. either version 2 of the License,
+ * or (at your option) any later version
+ */
+
+#include "mixer.h"
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/io.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/fb.h>
+#include <linux/delay.h>
+#include <linux/pm_runtime.h>
+#include <linux/clk.h>
+
+MODULE_AUTHOR("Tomasz Stanislawski, <t.stanislaws@samsung.com>");
+MODULE_DESCRIPTION("Samsung MIXER");
+MODULE_LICENSE("GPL");
+
+/* --------- DRIVER PARAMETERS ---------- */
+
+static struct mxr_output_conf mxr_output_conf[] = {
+	{
+		.output_name = "S5P HDMI connector",
+		.module_name = "s5p-hdmi",
+		.cookie = 1,
+	},
+	{
+		.output_name = "S5P SDO connector",
+		.module_name = "s5p-sdo",
+		.cookie = 0,
+	},
+};
+
+/* --------- DRIVER INITIALIZATION ---------- */
+
+static struct platform_driver mxr_driver __refdata;
+
+static int __init mxr_init(void)
+{
+	int i, ret;
+	static const char banner[] __initdata = KERN_INFO
+		"Samsung TV Mixer driver, "
+		"(c) 2010-2011 Samsung Electronics Co., Ltd.\n";
+	printk(banner);
+
+	/* Loading auxiliary modules */
+	for (i = 0; i < ARRAY_SIZE(mxr_output_conf); ++i)
+		request_module(mxr_output_conf[i].module_name);
+
+	ret = platform_driver_register(&mxr_driver);
+	if (ret != 0) {
+		printk(KERN_ERR "registration of MIXER driver failed\n");
+		return -ENXIO;
+	}
+
+	return 0;
+}
+module_init(mxr_init);
+
+static void __exit mxr_exit(void)
+{
+	platform_driver_unregister(&mxr_driver);
+}
+module_exit(mxr_exit);
+
+static int __devinit mxr_acquire_resources(struct mxr_device *mdev,
+	struct platform_device *pdev);
+
+static void mxr_release_resources(struct mxr_device *mdev);
+
+static int __devinit mxr_acquire_layers(struct mxr_device *mdev,
+	struct mxr_platform_data *pdata);
+
+static void mxr_release_layers(struct mxr_device *mxr_dev);
+
+static int __devinit mxr_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct mxr_platform_data *pdata = dev->platform_data;
+	struct mxr_device *mdev;
+	int ret;
+
+	/* mdev does not exist yet so no mxr_dbg is used */
+	dev_info(dev, "probe start\n");
+
+	mdev = kzalloc(sizeof *mdev, GFP_KERNEL);
+	if (!mdev) {
+		mxr_err(mdev, "not enough memory.\n");
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	/* setup pointer to master device */
+	mdev->dev = dev;
+
+	mutex_init(&mdev->mutex);
+	spin_lock_init(&mdev->reg_slock);
+	init_waitqueue_head(&mdev->event_queue);
+
+	/* acquire resources: regs, irqs, clocks, regulators */
+	ret = mxr_acquire_resources(mdev, pdev);
+	if (ret)
+		goto fail_mem;
+
+	/* configure resources for video output */
+	ret = mxr_acquire_video(mdev, mxr_output_conf,
+		ARRAY_SIZE(mxr_output_conf));
+	if (ret)
+		goto fail_resources;
+
+	/* configure layers */
+	ret = mxr_acquire_layers(mdev, pdata);
+	if (ret)
+		goto fail_video;
+
+	pm_runtime_enable(dev);
+
+	mxr_info(mdev, "probe successful\n");
+	return 0;
+
+fail_video:
+	mxr_release_video(mdev);
+
+fail_resources:
+	mxr_release_resources(mdev);
+
+fail_mem:
+	kfree(mdev);
+
+fail:
+	dev_info(dev, "probe failed\n");
+	return ret;
+}
+
+static int __devexit mxr_remove(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct mxr_device *mdev = to_mdev(dev);
+
+	pm_runtime_disable(dev);
+
+	mxr_release_layers(mdev);
+	mxr_release_video(mdev);
+	mxr_release_resources(mdev);
+
+	kfree(mdev);
+
+	dev_info(dev, "remove sucessful\n");
+	return 0;
+}
+
+static int mxr_runtime_resume(struct device *dev)
+{
+	struct mxr_device *mdev = to_mdev(dev);
+	struct mxr_resources *res = &mdev->res;
+
+	mxr_dbg(mdev, "resume - start\n");
+	mutex_lock(&mdev->mutex);
+	/* turn clocks on */
+	clk_enable(res->mixer);
+	clk_enable(res->vp);
+	clk_enable(res->sclk_mixer);
+	mxr_dbg(mdev, "resume - finished\n");
+
+	mutex_unlock(&mdev->mutex);
+	return 0;
+}
+
+static int mxr_runtime_suspend(struct device *dev)
+{
+	struct mxr_device *mdev = to_mdev(dev);
+	struct mxr_resources *res = &mdev->res;
+	mxr_dbg(mdev, "suspend - start\n");
+	mutex_lock(&mdev->mutex);
+	/* turn clocks off */
+	clk_disable(res->sclk_mixer);
+	clk_disable(res->vp);
+	clk_disable(res->mixer);
+	mutex_unlock(&mdev->mutex);
+	mxr_dbg(mdev, "suspend - finished\n");
+	return 0;
+}
+
+static const struct dev_pm_ops mxr_pm_ops = {
+	.runtime_suspend = mxr_runtime_suspend,
+	.runtime_resume	 = mxr_runtime_resume,
+};
+
+static struct platform_driver mxr_driver __refdata = {
+	.probe = mxr_probe,
+	.remove = __devexit_p(mxr_remove),
+	.driver = {
+		.name = MXR_DRIVER_NAME,
+		.owner = THIS_MODULE,
+		.pm = &mxr_pm_ops,
+	}
+};
+
+static int __devinit mxr_acquire_plat_resources(struct mxr_device *mdev,
+	struct platform_device *pdev)
+{
+	struct resource *res;
+	int ret;
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "mxr");
+	if (res == NULL) {
+		mxr_err(mdev, "get memory resource failed.\n");
+		ret = -ENXIO;
+		goto fail;
+	}
+
+	mdev->res.mxr_regs = ioremap(res->start, resource_size(res));
+	if (mdev->res.mxr_regs == NULL) {
+		mxr_err(mdev, "register mapping failed.\n");
+		ret = -ENXIO;
+		goto fail;
+	}
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "vp");
+	if (res == NULL) {
+		mxr_err(mdev, "get memory resource failed.\n");
+		ret = -ENXIO;
+		goto fail_mxr_regs;
+	}
+
+	mdev->res.vp_regs = ioremap(res->start, resource_size(res));
+	if (mdev->res.vp_regs == NULL) {
+		mxr_err(mdev, "register mapping failed.\n");
+		ret = -ENXIO;
+		goto fail_mxr_regs;
+	}
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_IRQ, "irq");
+	if (res == NULL) {
+		mxr_err(mdev, "get interrupt resource failed.\n");
+		ret = -ENXIO;
+		goto fail_vp_regs;
+	}
+
+	ret = request_irq(res->start, mxr_irq_handler, 0, "s5p-mixer", mdev);
+	if (ret) {
+		mxr_err(mdev, "request interrupt failed.\n");
+		goto fail_vp_regs;
+	}
+	mdev->res.irq = res->start;
+
+	return 0;
+
+fail_vp_regs:
+	iounmap(mdev->res.vp_regs);
+
+fail_mxr_regs:
+	iounmap(mdev->res.mxr_regs);
+
+fail:
+	return ret;
+}
+
+static void mxr_release_plat_resources(struct mxr_device *mdev)
+{
+	free_irq(mdev->res.irq, mdev);
+	iounmap(mdev->res.vp_regs);
+	iounmap(mdev->res.mxr_regs);
+}
+
+static void mxr_release_clocks(struct mxr_device *mdev)
+{
+	struct mxr_resources *res = &mdev->res;
+
+	if (!IS_ERR_OR_NULL(res->sclk_dac))
+		clk_put(res->sclk_dac);
+	if (!IS_ERR_OR_NULL(res->sclk_hdmi))
+		clk_put(res->sclk_hdmi);
+	if (!IS_ERR_OR_NULL(res->sclk_mixer))
+		clk_put(res->sclk_mixer);
+	if (!IS_ERR_OR_NULL(res->vp))
+		clk_put(res->vp);
+	if (!IS_ERR_OR_NULL(res->mixer))
+		clk_put(res->mixer);
+}
+
+static int mxr_acquire_clocks(struct mxr_device *mdev)
+{
+	struct mxr_resources *res = &mdev->res;
+	struct device *dev = mdev->dev;
+
+	res->mixer = clk_get(dev, "mixer");
+	if (IS_ERR_OR_NULL(res->mixer)) {
+		mxr_err(mdev, "failed to get clock 'mixer'\n");
+		goto fail;
+	}
+	res->vp = clk_get(dev, "vp");
+	if (IS_ERR_OR_NULL(res->vp)) {
+		mxr_err(mdev, "failed to get clock 'vp'\n");
+		goto fail;
+	}
+	res->sclk_mixer = clk_get(dev, "sclk_mixer");
+	if (IS_ERR_OR_NULL(res->sclk_mixer)) {
+		mxr_err(mdev, "failed to get clock 'sclk_mixer'\n");
+		goto fail;
+	}
+	res->sclk_hdmi = clk_get(dev, "sclk_hdmi");
+	if (IS_ERR_OR_NULL(res->sclk_hdmi)) {
+		mxr_err(mdev, "failed to get clock 'sclk_hdmi'\n");
+		goto fail;
+	}
+	res->sclk_dac = clk_get(dev, "sclk_dac");
+	if (IS_ERR_OR_NULL(res->sclk_dac)) {
+		mxr_err(mdev, "failed to get clock 'sclk_dac'\n");
+		goto fail;
+	}
+
+	return 0;
+fail:
+	mxr_release_clocks(mdev);
+	return -ENODEV;
+}
+
+static int __devinit mxr_acquire_resources(struct mxr_device *mdev,
+	struct platform_device *pdev)
+{
+	int ret;
+	ret = mxr_acquire_plat_resources(mdev, pdev);
+
+	if (ret)
+		goto fail;
+
+	ret = mxr_acquire_clocks(mdev);
+	if (ret)
+		goto fail_plat;
+
+	mxr_info(mdev, "resources acquired\n");
+	return 0;
+
+fail_plat:
+	mxr_release_plat_resources(mdev);
+fail:
+	mxr_err(mdev, "resources acquire failed\n");
+	return ret;
+}
+
+static void mxr_release_resources(struct mxr_device *mdev)
+{
+	mxr_release_clocks(mdev);
+	mxr_release_plat_resources(mdev);
+	memset(&mdev->res, 0, sizeof mdev->res);
+}
+
+static int __devinit mxr_acquire_layers(struct mxr_device *mdev,
+	struct mxr_platform_data *pdata)
+{
+	mdev->layer[0] = mxr_graph_layer_create(mdev, 0);
+	mdev->layer[1] = mxr_graph_layer_create(mdev, 1);
+	mdev->layer[2] = mxr_vp_layer_create(mdev, 0);
+
+	if (!mdev->layer[0] || !mdev->layer[1] || !mdev->layer[2]) {
+		mxr_err(mdev, "failed to acquire layers\n");
+		goto fail;
+	}
+
+	return 0;
+
+fail:
+	mxr_release_layers(mdev);
+	return -ENODEV;
+}
+
+static void mxr_release_layers(struct mxr_device *mdev)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(mdev->layer); ++i)
+		if (mdev->layer[i])
+			mxr_layer_release(mdev->layer[i]);
+}
+
+int mxr_power_get(struct mxr_device *mdev)
+{
+	int ret = pm_runtime_get_sync(mdev->dev);
+
+	/* returning 1 means that power is already enabled,
+	 * so zero success be returned */
+	if (IS_ERR_VALUE(ret))
+		return ret;
+	return 0;
+}
+
+void mxr_power_put(struct mxr_device *mdev)
+{
+	pm_runtime_put_sync(mdev->dev);
+}
+
+void mxr_get_mbus_fmt(struct mxr_device *mdev,
+	struct v4l2_mbus_framefmt *mbus_fmt)
+{
+	struct v4l2_subdev *sd;
+	int ret;
+
+	mutex_lock(&mdev->mutex);
+	sd = to_outsd(mdev);
+	ret = v4l2_subdev_call(sd, video, g_mbus_fmt, mbus_fmt);
+	WARN(ret, "failed to get mbus_fmt for output %s\n", sd->name);
+	mutex_unlock(&mdev->mutex);
+}
+
+void mxr_streamer_get(struct mxr_device *mdev)
+{
+	mutex_lock(&mdev->mutex);
+	++mdev->n_streamer;
+	mxr_dbg(mdev, "%s(%d)\n", __func__, mdev->n_streamer);
+	if (mdev->n_streamer == 1) {
+		struct v4l2_subdev *sd = to_outsd(mdev);
+		struct v4l2_mbus_framefmt mbus_fmt;
+		struct mxr_resources *res = &mdev->res;
+		int ret;
+
+		ret = v4l2_subdev_call(sd, video, g_mbus_fmt, &mbus_fmt);
+		WARN(ret, "failed to get mbus_fmt for output %s\n", sd->name);
+		ret = v4l2_subdev_call(sd, video, s_stream, 1);
+		WARN(ret, "starting stream failed for output %s\n", sd->name);
+		if (to_output(mdev)->cookie == 0)
+			clk_set_parent(res->sclk_mixer, res->sclk_dac);
+		else
+			clk_set_parent(res->sclk_mixer, res->sclk_hdmi);
+		/* apply default configuration */
+		mxr_reg_reset(mdev);
+		mxr_reg_set_mbus_fmt(mdev, &mbus_fmt);
+		mxr_reg_s_output(mdev, to_output(mdev)->cookie);
+		mxr_reg_streamon(mdev);
+		ret = mxr_reg_wait4vsync(mdev);
+		WARN(ret, "failed to get vsync (%d) from output\n", ret);
+	}
+	mutex_unlock(&mdev->mutex);
+	mxr_reg_dump(mdev);
+	/* FIXME: what to do when streaming fails? */
+}
+
+void mxr_streamer_put(struct mxr_device *mdev)
+{
+	mutex_lock(&mdev->mutex);
+	--mdev->n_streamer;
+	mxr_dbg(mdev, "%s(%d)\n", __func__, mdev->n_streamer);
+	if (mdev->n_streamer == 0) {
+		int ret;
+		struct v4l2_subdev *sd = to_outsd(mdev);
+
+		mxr_reg_streamoff(mdev);
+		/* vsync applies Mixer setup */
+		ret = mxr_reg_wait4vsync(mdev);
+		WARN(ret, "failed to get vsync (%d) from output\n", ret);
+		ret = v4l2_subdev_call(sd, video, s_stream, 0);
+		WARN(ret, "stopping stream failed for output %s\n", sd->name);
+	}
+	WARN(mdev->n_streamer < 0, "negative number of streamers (%d)\n",
+		mdev->n_streamer);
+	mutex_unlock(&mdev->mutex);
+	mxr_reg_dump(mdev);
+}
+
+void mxr_output_get(struct mxr_device *mdev)
+{
+	mutex_lock(&mdev->mutex);
+	++mdev->n_output;
+	mxr_dbg(mdev, "%s(%d)\n", __func__, mdev->n_output);
+	/* turn on auxliary driver */
+	if (mdev->n_output == 1)
+		v4l2_subdev_call(to_outsd(mdev), core, s_power, 1);
+	mutex_unlock(&mdev->mutex);
+}
+
+void mxr_output_put(struct mxr_device *mdev)
+{
+	mutex_lock(&mdev->mutex);
+	--mdev->n_output;
+	mxr_dbg(mdev, "%s(%d)\n", __func__, mdev->n_output);
+	/* turn on auxliary driver */
+	if (mdev->n_output == 0)
+		v4l2_subdev_call(to_outsd(mdev), core, s_power, 0);
+	WARN(mdev->n_output < 0, "negative number of output users (%d)\n",
+		mdev->n_output);
+	mutex_unlock(&mdev->mutex);
+}
+
diff --git a/drivers/media/video/s5p-tv/mixer_grp_layer.c b/drivers/media/video/s5p-tv/mixer_grp_layer.c
new file mode 100644
index 0000000..8c14531
--- /dev/null
+++ b/drivers/media/video/s5p-tv/mixer_grp_layer.c
@@ -0,0 +1,181 @@
+/*
+ * Samsung TV Mixer driver
+ *
+ * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
+ *
+ * Tomasz Stanislawski, <t.stanislaws@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundiation. either version 2 of the License,
+ * or (at your option) any later version
+ */
+
+#include "mixer.h"
+
+#include <media/videobuf2-dma-contig.h>
+
+/* FORMAT DEFINITIONS */
+
+static const struct mxr_format mxr_fb_fmt_rgb565 = {
+	.name = "RGB565",
+	.fourcc = V4L2_PIX_FMT_RGB565,
+	.num_planes = 1,
+	.plane = {
+		{ .width = 1, .height = 1, .size = 2 },
+	},
+	.num_subframes = 1,
+	.cookie = 4,
+};
+
+static const struct mxr_format mxr_fb_fmt_argb1555 = {
+	.name = "ARGB1555",
+	.num_planes = 1,
+	.fourcc = V4L2_PIX_FMT_RGB555,
+	.plane = {
+		{ .width = 1, .height = 1, .size = 2 },
+	},
+	.num_subframes = 1,
+	.cookie = 5,
+};
+
+static const struct mxr_format mxr_fb_fmt_argb4444 = {
+	.name = "ARGB4444",
+	.num_planes = 1,
+	.fourcc = V4L2_PIX_FMT_RGB444,
+	.plane = {
+		{ .width = 1, .height = 1, .size = 2 },
+	},
+	.num_subframes = 1,
+	.cookie = 6,
+};
+
+static const struct mxr_format mxr_fb_fmt_argb8888 = {
+	.name = "ARGB8888",
+	.fourcc = V4L2_PIX_FMT_BGR32,
+	.num_planes = 1,
+	.plane = {
+		{ .width = 1, .height = 1, .size = 4 },
+	},
+	.num_subframes = 1,
+	.cookie = 7,
+};
+
+static const struct mxr_format *mxr_graph_format[] = {
+	&mxr_fb_fmt_rgb565,
+	&mxr_fb_fmt_argb1555,
+	&mxr_fb_fmt_argb4444,
+	&mxr_fb_fmt_argb8888,
+};
+
+/* AUXILIARY CALLBACKS */
+
+static void mxr_graph_layer_release(struct mxr_layer *layer)
+{
+	mxr_base_layer_unregister(layer);
+	mxr_base_layer_release(layer);
+}
+
+static void mxr_graph_buffer_set(struct mxr_layer *layer,
+	struct mxr_buffer *buf)
+{
+	dma_addr_t addr = 0;
+
+	if (buf)
+		addr = vb2_dma_contig_plane_paddr(&buf->vb, 0);
+	mxr_reg_graph_buffer(layer->mdev, layer->idx, addr);
+}
+
+static void mxr_graph_stream_set(struct mxr_layer *layer, int en)
+{
+	mxr_reg_graph_layer_stream(layer->mdev, layer->idx, en);
+}
+
+static void mxr_graph_format_set(struct mxr_layer *layer)
+{
+	mxr_reg_graph_format(layer->mdev, layer->idx,
+		layer->fmt, &layer->geo);
+}
+
+static void mxr_graph_fix_geometry(struct mxr_layer *layer)
+{
+	struct mxr_geometry *geo = &layer->geo;
+
+	/* limit to boundary size */
+	geo->src.full_width = clamp_val(geo->src.full_width, 1, 32767);
+	geo->src.full_height = clamp_val(geo->src.full_height, 1, 2047);
+	geo->src.width = clamp_val(geo->src.width, 1, geo->src.full_width);
+	geo->src.width = min(geo->src.width, 2047U);
+	/* not possible to crop of Y axis */
+	geo->src.y_offset = min(geo->src.y_offset, geo->src.full_height - 1);
+	geo->src.height = geo->src.full_height - geo->src.y_offset;
+	/* limitting offset */
+	geo->src.x_offset = min(geo->src.x_offset,
+		geo->src.full_width - geo->src.width);
+
+	/* setting position in output */
+	geo->dst.width = min(geo->dst.width, geo->dst.full_width);
+	geo->dst.height = min(geo->dst.height, geo->dst.full_height);
+
+	/* Mixer supports only 1x and 2x scaling */
+	if (geo->dst.width >= 2 * geo->src.width) {
+		geo->x_ratio = 1;
+		geo->dst.width = 2 * geo->src.width;
+	} else {
+		geo->x_ratio = 0;
+		geo->dst.width = geo->src.width;
+	}
+
+	if (geo->dst.height >= 2 * geo->src.height) {
+		geo->y_ratio = 1;
+		geo->dst.height = 2 * geo->src.height;
+	} else {
+		geo->y_ratio = 0;
+		geo->dst.height = geo->src.height;
+	}
+
+	geo->dst.x_offset = min(geo->dst.x_offset,
+		geo->dst.full_width - geo->dst.width);
+	geo->dst.y_offset = min(geo->dst.y_offset,
+		geo->dst.full_height - geo->dst.height);
+}
+
+/* PUBLIC API */
+
+struct mxr_layer *mxr_graph_layer_create(struct mxr_device *mdev, int idx)
+{
+	struct mxr_layer *layer;
+	int ret;
+	struct mxr_layer_ops ops = {
+		.release = mxr_graph_layer_release,
+		.buffer_set = mxr_graph_buffer_set,
+		.stream_set = mxr_graph_stream_set,
+		.format_set = mxr_graph_format_set,
+		.fix_geometry = mxr_graph_fix_geometry,
+	};
+	char name[32];
+
+	sprintf(name, "graph%d", idx);
+
+	layer = mxr_base_layer_create(mdev, idx, name, &ops);
+	if (layer == NULL) {
+		mxr_err(mdev, "failed to initialize layer(%d) base\n", idx);
+		goto fail;
+	}
+
+	layer->fmt_array = mxr_graph_format;
+	layer->fmt_array_size = ARRAY_SIZE(mxr_graph_format);
+
+	ret = mxr_base_layer_register(layer);
+	if (ret)
+		goto fail_layer;
+
+	return layer;
+
+fail_layer:
+	mxr_base_layer_release(layer);
+
+fail:
+	return NULL;
+}
+
diff --git a/drivers/media/video/s5p-tv/mixer_reg.c b/drivers/media/video/s5p-tv/mixer_reg.c
new file mode 100644
index 0000000..c60f85f8
--- /dev/null
+++ b/drivers/media/video/s5p-tv/mixer_reg.c
@@ -0,0 +1,540 @@
+/*
+ * Samsung TV Mixer driver
+ *
+ * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
+ *
+ * Tomasz Stanislawski, <t.stanislaws@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundiation. either version 2 of the License,
+ * or (at your option) any later version
+ */
+
+#include "mixer.h"
+#include "regs-mixer.h"
+#include "regs-vp.h"
+
+#include <linux/delay.h>
+
+/* Register access subroutines */
+
+static inline u32 vp_read(struct mxr_device *mdev, u32 reg_id)
+{
+	return readl(mdev->res.vp_regs + reg_id);
+}
+
+static inline void vp_write(struct mxr_device *mdev, u32 reg_id, u32 val)
+{
+	writel(val, mdev->res.vp_regs + reg_id);
+}
+
+static inline void vp_write_mask(struct mxr_device *mdev, u32 reg_id,
+	u32 val, u32 mask)
+{
+	u32 old = vp_read(mdev, reg_id);
+
+	val = (val & mask) | (old & ~mask);
+	writel(val, mdev->res.vp_regs + reg_id);
+}
+
+static inline u32 mxr_read(struct mxr_device *mdev, u32 reg_id)
+{
+	return readl(mdev->res.mxr_regs + reg_id);
+}
+
+static inline void mxr_write(struct mxr_device *mdev, u32 reg_id, u32 val)
+{
+	writel(val, mdev->res.mxr_regs + reg_id);
+}
+
+static inline void mxr_write_mask(struct mxr_device *mdev, u32 reg_id,
+	u32 val, u32 mask)
+{
+	u32 old = mxr_read(mdev, reg_id);
+
+	val = (val & mask) | (old & ~mask);
+	writel(val, mdev->res.mxr_regs + reg_id);
+}
+
+void mxr_vsync_set_update(struct mxr_device *mdev, int en)
+{
+	/* block update on vsync */
+	mxr_write_mask(mdev, MXR_STATUS, en ? MXR_STATUS_SYNC_ENABLE : 0,
+		MXR_STATUS_SYNC_ENABLE);
+	vp_write(mdev, VP_SHADOW_UPDATE, en ? VP_SHADOW_UPDATE_ENABLE : 0);
+}
+
+static void __mxr_reg_vp_reset(struct mxr_device *mdev)
+{
+	int tries = 100;
+
+	vp_write(mdev, VP_SRESET, VP_SRESET_PROCESSING);
+	for (tries = 100; tries; --tries) {
+		/* waiting until VP_SRESET_PROCESSING is 0 */
+		if (~vp_read(mdev, VP_SRESET) & VP_SRESET_PROCESSING)
+			break;
+		mdelay(10);
+	}
+	WARN(tries == 0, "failed to reset Video Processor\n");
+}
+
+static void mxr_reg_vp_default_filter(struct mxr_device *mdev);
+
+void mxr_reg_reset(struct mxr_device *mdev)
+{
+	unsigned long flags;
+	u32 val; /* value stored to register */
+
+	spin_lock_irqsave(&mdev->reg_slock, flags);
+	mxr_vsync_set_update(mdev, MXR_DISABLE);
+
+	/* set output in RGB888 mode */
+	mxr_write(mdev, MXR_CFG, MXR_CFG_OUT_YUV444);
+
+	/* 16 beat burst in DMA */
+	mxr_write_mask(mdev, MXR_STATUS, MXR_STATUS_16_BURST,
+		MXR_STATUS_BURST_MASK);
+
+	/* setting default layer priority: layer1 > video > layer0
+	 * because typical usage scenario would be
+	 * layer0 - framebuffer
+	 * video - video overlay
+	 * layer1 - OSD
+	 */
+	val  = MXR_LAYER_CFG_GRP0_VAL(1);
+	val |= MXR_LAYER_CFG_VP_VAL(2);
+	val |= MXR_LAYER_CFG_GRP1_VAL(3);
+	mxr_write(mdev, MXR_LAYER_CFG, val);
+
+	/* use dark gray background color */
+	mxr_write(mdev, MXR_BG_COLOR0, 0x808080);
+	mxr_write(mdev, MXR_BG_COLOR1, 0x808080);
+	mxr_write(mdev, MXR_BG_COLOR2, 0x808080);
+
+	/* setting graphical layers */
+
+	val  = MXR_GRP_CFG_COLOR_KEY_DISABLE; /* no blank key */
+	val |= MXR_GRP_CFG_BLEND_PRE_MUL; /* premul mode */
+	val |= MXR_GRP_CFG_ALPHA_VAL(0xff); /* non-transparent alpha */
+
+	/* the same configuration for both layers */
+	mxr_write(mdev, MXR_GRAPHIC_CFG(0), val);
+	mxr_write(mdev, MXR_GRAPHIC_CFG(1), val);
+
+	/* configuration of Video Processor Registers */
+	__mxr_reg_vp_reset(mdev);
+	mxr_reg_vp_default_filter(mdev);
+
+	/* enable all interrupts */
+	mxr_write_mask(mdev, MXR_INT_EN, ~0, MXR_INT_EN_ALL);
+
+	mxr_vsync_set_update(mdev, MXR_ENABLE);
+	spin_unlock_irqrestore(&mdev->reg_slock, flags);
+}
+
+void mxr_reg_graph_format(struct mxr_device *mdev, int idx,
+	const struct mxr_format *fmt, const struct mxr_geometry *geo)
+{
+	u32 val;
+	unsigned long flags;
+
+	spin_lock_irqsave(&mdev->reg_slock, flags);
+	mxr_vsync_set_update(mdev, MXR_DISABLE);
+
+	/* setup format */
+	mxr_write_mask(mdev, MXR_GRAPHIC_CFG(idx),
+		MXR_GRP_CFG_FORMAT_VAL(fmt->cookie), MXR_GRP_CFG_FORMAT_MASK);
+
+	/* setup geometry */
+	mxr_write(mdev, MXR_GRAPHIC_SPAN(idx), geo->src.full_width);
+	val  = MXR_GRP_WH_WIDTH(geo->src.width);
+	val |= MXR_GRP_WH_HEIGHT(geo->src.height);
+	val |= MXR_GRP_WH_H_SCALE(geo->x_ratio);
+	val |= MXR_GRP_WH_V_SCALE(geo->y_ratio);
+	mxr_write(mdev, MXR_GRAPHIC_WH(idx), val);
+
+	/* setup offsets in source image */
+	val  = MXR_GRP_SXY_SX(geo->src.x_offset);
+	val |= MXR_GRP_SXY_SY(geo->src.y_offset);
+	mxr_write(mdev, MXR_GRAPHIC_SXY(idx), val);
+
+	/* setup offsets in display image */
+	val  = MXR_GRP_DXY_DX(geo->dst.x_offset);
+	val |= MXR_GRP_DXY_DY(geo->dst.y_offset);
+	mxr_write(mdev, MXR_GRAPHIC_DXY(idx), val);
+
+	mxr_vsync_set_update(mdev, MXR_ENABLE);
+	spin_unlock_irqrestore(&mdev->reg_slock, flags);
+}
+
+void mxr_reg_vp_format(struct mxr_device *mdev,
+	const struct mxr_format *fmt, const struct mxr_geometry *geo)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&mdev->reg_slock, flags);
+	mxr_vsync_set_update(mdev, MXR_DISABLE);
+
+	vp_write_mask(mdev, VP_MODE, fmt->cookie, VP_MODE_FMT_MASK);
+
+	/* setting size of input image */
+	vp_write(mdev, VP_IMG_SIZE_Y, VP_IMG_HSIZE(geo->src.full_width) |
+		VP_IMG_VSIZE(geo->src.full_height));
+	/* chroma height has to reduced by 2 to avoid chroma distorions */
+	vp_write(mdev, VP_IMG_SIZE_C, VP_IMG_HSIZE(geo->src.full_width) |
+		VP_IMG_VSIZE(geo->src.full_height / 2));
+
+	vp_write(mdev, VP_SRC_WIDTH, geo->src.width);
+	vp_write(mdev, VP_SRC_HEIGHT, geo->src.height);
+	vp_write(mdev, VP_SRC_H_POSITION,
+		VP_SRC_H_POSITION_VAL(geo->src.x_offset));
+	vp_write(mdev, VP_SRC_V_POSITION, geo->src.y_offset);
+
+	vp_write(mdev, VP_DST_WIDTH, geo->dst.width);
+	vp_write(mdev, VP_DST_H_POSITION, geo->dst.x_offset);
+	if (geo->dst.field == V4L2_FIELD_INTERLACED) {
+		vp_write(mdev, VP_DST_HEIGHT, geo->dst.height / 2);
+		vp_write(mdev, VP_DST_V_POSITION, geo->dst.y_offset / 2);
+	} else {
+		vp_write(mdev, VP_DST_HEIGHT, geo->dst.height);
+		vp_write(mdev, VP_DST_V_POSITION, geo->dst.y_offset);
+	}
+
+	vp_write(mdev, VP_H_RATIO, geo->x_ratio);
+	vp_write(mdev, VP_V_RATIO, geo->y_ratio);
+
+	vp_write(mdev, VP_ENDIAN_MODE, VP_ENDIAN_MODE_LITTLE);
+
+	mxr_vsync_set_update(mdev, MXR_ENABLE);
+	spin_unlock_irqrestore(&mdev->reg_slock, flags);
+
+}
+
+void mxr_reg_graph_buffer(struct mxr_device *mdev, int idx, dma_addr_t addr)
+{
+	u32 val = addr ? ~0 : 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&mdev->reg_slock, flags);
+	mxr_vsync_set_update(mdev, MXR_DISABLE);
+
+	if (idx == 0)
+		mxr_write_mask(mdev, MXR_CFG, val, MXR_CFG_GRP0_ENABLE);
+	else
+		mxr_write_mask(mdev, MXR_CFG, val, MXR_CFG_GRP1_ENABLE);
+	mxr_write(mdev, MXR_GRAPHIC_BASE(idx), addr);
+
+	mxr_vsync_set_update(mdev, MXR_ENABLE);
+	spin_unlock_irqrestore(&mdev->reg_slock, flags);
+}
+
+void mxr_reg_vp_buffer(struct mxr_device *mdev,
+	dma_addr_t luma_addr[2], dma_addr_t chroma_addr[2])
+{
+	u32 val = luma_addr[0] ? ~0 : 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&mdev->reg_slock, flags);
+	mxr_vsync_set_update(mdev, MXR_DISABLE);
+
+	mxr_write_mask(mdev, MXR_CFG, val, MXR_CFG_VP_ENABLE);
+	vp_write_mask(mdev, VP_ENABLE, val, VP_ENABLE_ON);
+	/* TODO: fix tiled mode */
+	vp_write(mdev, VP_TOP_Y_PTR, luma_addr[0]);
+	vp_write(mdev, VP_TOP_C_PTR, chroma_addr[0]);
+	vp_write(mdev, VP_BOT_Y_PTR, luma_addr[1]);
+	vp_write(mdev, VP_BOT_C_PTR, chroma_addr[1]);
+
+	mxr_vsync_set_update(mdev, MXR_ENABLE);
+	spin_unlock_irqrestore(&mdev->reg_slock, flags);
+}
+
+static void mxr_irq_layer_handle(struct mxr_layer *layer)
+{
+	struct list_head *head = &layer->enq_list;
+	struct mxr_buffer *done;
+
+	/* skip non-existing layer */
+	if (layer == NULL)
+		return;
+
+	spin_lock(&layer->enq_slock);
+	if (layer->state == MXR_LAYER_IDLE)
+		goto done;
+
+	done = layer->shadow_buf;
+	layer->shadow_buf = layer->update_buf;
+
+	if (list_empty(head)) {
+		if (layer->state != MXR_LAYER_STREAMING)
+			layer->update_buf = NULL;
+	} else {
+		struct mxr_buffer *next;
+		next = list_first_entry(head, struct mxr_buffer, list);
+		list_del(&next->list);
+		layer->update_buf = next;
+	}
+
+	layer->ops.buffer_set(layer, layer->update_buf);
+
+	if (done && done != layer->shadow_buf)
+		vb2_buffer_done(&done->vb, VB2_BUF_STATE_DONE);
+
+done:
+	spin_unlock(&layer->enq_slock);
+}
+
+irqreturn_t mxr_irq_handler(int irq, void *dev_data)
+{
+	struct mxr_device *mdev = dev_data;
+	u32 i, val;
+
+	spin_lock(&mdev->reg_slock);
+	val = mxr_read(mdev, MXR_INT_STATUS);
+
+	/* wake up process waiting for VSYNC */
+	if (val & MXR_INT_STATUS_VSYNC) {
+		set_bit(MXR_EVENT_VSYNC, &mdev->event_flags);
+		wake_up(&mdev->event_queue);
+	}
+
+	/* clear interrupts */
+	if (~val & MXR_INT_EN_VSYNC) {
+		/* vsync interrupt use different bit for read and clear */
+		val &= ~MXR_INT_EN_VSYNC;
+		val |= MXR_INT_CLEAR_VSYNC;
+	}
+	mxr_write(mdev, MXR_INT_STATUS, val);
+
+	spin_unlock(&mdev->reg_slock);
+	/* leave on non-vsync event */
+	if (~val & MXR_INT_CLEAR_VSYNC)
+		return IRQ_HANDLED;
+	for (i = 0; i < MXR_MAX_LAYERS; ++i)
+		mxr_irq_layer_handle(mdev->layer[i]);
+	return IRQ_HANDLED;
+}
+
+void mxr_reg_s_output(struct mxr_device *mdev, int cookie)
+{
+	u32 val;
+
+	val = cookie == 0 ? MXR_CFG_DST_SDO : MXR_CFG_DST_HDMI;
+	mxr_write_mask(mdev, MXR_CFG, val, MXR_CFG_DST_MASK);
+}
+
+void mxr_reg_streamon(struct mxr_device *mdev)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&mdev->reg_slock, flags);
+	/* single write -> no need to block vsync update */
+
+	/* start MIXER */
+	mxr_write_mask(mdev, MXR_STATUS, ~0, MXR_STATUS_REG_RUN);
+
+	spin_unlock_irqrestore(&mdev->reg_slock, flags);
+}
+
+void mxr_reg_streamoff(struct mxr_device *mdev)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&mdev->reg_slock, flags);
+	/* single write -> no need to block vsync update */
+
+	/* stop MIXER */
+	mxr_write_mask(mdev, MXR_STATUS, 0, MXR_STATUS_REG_RUN);
+
+	spin_unlock_irqrestore(&mdev->reg_slock, flags);
+}
+
+int mxr_reg_wait4vsync(struct mxr_device *mdev)
+{
+	int ret;
+
+	clear_bit(MXR_EVENT_VSYNC, &mdev->event_flags);
+	/* TODO: consider adding interruptible */
+	ret = wait_event_timeout(mdev->event_queue,
+		test_bit(MXR_EVENT_VSYNC, &mdev->event_flags),
+		msecs_to_jiffies(1000));
+	if (ret > 0)
+		return 0;
+	if (ret < 0)
+		return ret;
+	return -ETIME;
+}
+
+void mxr_reg_set_mbus_fmt(struct mxr_device *mdev,
+	struct v4l2_mbus_framefmt *fmt)
+{
+	u32 val = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&mdev->reg_slock, flags);
+	mxr_vsync_set_update(mdev, MXR_DISABLE);
+
+	/* choosing between interlace and progressive mode */
+	if (fmt->field == V4L2_FIELD_INTERLACED)
+		val |= MXR_CFG_SCAN_INTERLACE;
+	else
+		val |= MXR_CFG_SCAN_PROGRASSIVE;
+
+	/* choosing between porper HD and SD mode */
+	if (fmt->height == 480)
+		val |= MXR_CFG_SCAN_NTSC | MXR_CFG_SCAN_SD;
+	else if (fmt->height == 576)
+		val |= MXR_CFG_SCAN_PAL | MXR_CFG_SCAN_SD;
+	else if (fmt->height == 720)
+		val |= MXR_CFG_SCAN_HD_720 | MXR_CFG_SCAN_HD;
+	else if (fmt->height == 1080)
+		val |= MXR_CFG_SCAN_HD_1080 | MXR_CFG_SCAN_HD;
+	else
+		WARN(1, "unrecognized mbus height %u!\n", fmt->height);
+
+	mxr_write_mask(mdev, MXR_CFG, val, MXR_CFG_SCAN_MASK);
+
+	val = (fmt->field == V4L2_FIELD_INTERLACED) ? ~0 : 0;
+	vp_write_mask(mdev, VP_MODE, val,
+		VP_MODE_LINE_SKIP | VP_MODE_FIELD_ID_AUTO_TOGGLING);
+
+	mxr_vsync_set_update(mdev, MXR_ENABLE);
+	spin_unlock_irqrestore(&mdev->reg_slock, flags);
+}
+
+void mxr_reg_graph_layer_stream(struct mxr_device *mdev, int idx, int en)
+{
+	/* no extra actions need to be done */
+}
+
+void mxr_reg_vp_layer_stream(struct mxr_device *mdev, int en)
+{
+	/* no extra actions need to be done */
+}
+
+static const u8 filter_y_horiz_tap8[] = {
+	0,	-1,	-1,	-1,	-1,	-1,	-1,	-1,
+	-1,	-1,	-1,	-1,	-1,	0,	0,	0,
+	0,	2,	4,	5,	6,	6,	6,	6,
+	6,	5,	5,	4,	3,	2,	1,	1,
+	0,	-6,	-12,	-16,	-18,	-20,	-21,	-20,
+	-20,	-18,	-16,	-13,	-10,	-8,	-5,	-2,
+	127,	126,	125,	121,	114,	107,	99,	89,
+	79,	68,	57,	46,	35,	25,	16,	8,
+};
+
+static const u8 filter_y_vert_tap4[] = {
+	0,	-3,	-6,	-8,	-8,	-8,	-8,	-7,
+	-6,	-5,	-4,	-3,	-2,	-1,	-1,	0,
+	127,	126,	124,	118,	111,	102,	92,	81,
+	70,	59,	48,	37,	27,	19,	11,	5,
+	0,	5,	11,	19,	27,	37,	48,	59,
+	70,	81,	92,	102,	111,	118,	124,	126,
+	0,	0,	-1,	-1,	-2,	-3,	-4,	-5,
+	-6,	-7,	-8,	-8,	-8,	-8,	-6,	-3,
+};
+
+static const u8 filter_cr_horiz_tap4[] = {
+	0,	-3,	-6,	-8,	-8,	-8,	-8,	-7,
+	-6,	-5,	-4,	-3,	-2,	-1,	-1,	0,
+	127,	126,	124,	118,	111,	102,	92,	81,
+	70,	59,	48,	37,	27,	19,	11,	5,
+};
+
+static inline void mxr_reg_vp_filter_set(struct mxr_device *mdev,
+	int reg_id, const u8 *data, unsigned int size)
+{
+	/* assure 4-byte align */
+	BUG_ON(size & 3);
+	for (; size; size -= 4, reg_id += 4, data += 4) {
+		u32 val = (data[0] << 24) |  (data[1] << 16) |
+			(data[2] << 8) | data[3];
+		vp_write(mdev, reg_id, val);
+	}
+}
+
+static void mxr_reg_vp_default_filter(struct mxr_device *mdev)
+{
+	mxr_reg_vp_filter_set(mdev, VP_POLY8_Y0_LL,
+		filter_y_horiz_tap8, sizeof filter_y_horiz_tap8);
+	mxr_reg_vp_filter_set(mdev, VP_POLY4_Y0_LL,
+		filter_y_vert_tap4, sizeof filter_y_vert_tap4);
+	mxr_reg_vp_filter_set(mdev, VP_POLY4_C0_LL,
+		filter_cr_horiz_tap4, sizeof filter_cr_horiz_tap4);
+}
+
+static void mxr_reg_mxr_dump(struct mxr_device *mdev)
+{
+#define DUMPREG(reg_id) \
+do { \
+	mxr_dbg(mdev, #reg_id " = %08x\n", \
+		(u32)readl(mdev->res.mxr_regs + reg_id)); \
+} while (0)
+
+	DUMPREG(MXR_STATUS);
+	DUMPREG(MXR_CFG);
+	DUMPREG(MXR_INT_EN);
+	DUMPREG(MXR_INT_STATUS);
+
+	DUMPREG(MXR_LAYER_CFG);
+	DUMPREG(MXR_VIDEO_CFG);
+
+	DUMPREG(MXR_GRAPHIC0_CFG);
+	DUMPREG(MXR_GRAPHIC0_BASE);
+	DUMPREG(MXR_GRAPHIC0_SPAN);
+	DUMPREG(MXR_GRAPHIC0_WH);
+	DUMPREG(MXR_GRAPHIC0_SXY);
+	DUMPREG(MXR_GRAPHIC0_DXY);
+
+	DUMPREG(MXR_GRAPHIC1_CFG);
+	DUMPREG(MXR_GRAPHIC1_BASE);
+	DUMPREG(MXR_GRAPHIC1_SPAN);
+	DUMPREG(MXR_GRAPHIC1_WH);
+	DUMPREG(MXR_GRAPHIC1_SXY);
+	DUMPREG(MXR_GRAPHIC1_DXY);
+#undef DUMPREG
+}
+
+static void mxr_reg_vp_dump(struct mxr_device *mdev)
+{
+#define DUMPREG(reg_id) \
+do { \
+	mxr_dbg(mdev, #reg_id " = %08x\n", \
+		(u32) readl(mdev->res.vp_regs + reg_id)); \
+} while (0)
+
+
+	DUMPREG(VP_ENABLE);
+	DUMPREG(VP_SRESET);
+	DUMPREG(VP_SHADOW_UPDATE);
+	DUMPREG(VP_FIELD_ID);
+	DUMPREG(VP_MODE);
+	DUMPREG(VP_IMG_SIZE_Y);
+	DUMPREG(VP_IMG_SIZE_C);
+	DUMPREG(VP_PER_RATE_CTRL);
+	DUMPREG(VP_TOP_Y_PTR);
+	DUMPREG(VP_BOT_Y_PTR);
+	DUMPREG(VP_TOP_C_PTR);
+	DUMPREG(VP_BOT_C_PTR);
+	DUMPREG(VP_ENDIAN_MODE);
+	DUMPREG(VP_SRC_H_POSITION);
+	DUMPREG(VP_SRC_V_POSITION);
+	DUMPREG(VP_SRC_WIDTH);
+	DUMPREG(VP_SRC_HEIGHT);
+	DUMPREG(VP_DST_H_POSITION);
+	DUMPREG(VP_DST_V_POSITION);
+	DUMPREG(VP_DST_WIDTH);
+	DUMPREG(VP_DST_HEIGHT);
+	DUMPREG(VP_H_RATIO);
+	DUMPREG(VP_V_RATIO);
+
+#undef DUMPREG
+}
+
+void mxr_reg_dump(struct mxr_device *mdev)
+{
+	mxr_reg_mxr_dump(mdev);
+	mxr_reg_vp_dump(mdev);
+}
+
diff --git a/drivers/media/video/s5p-tv/mixer_video.c b/drivers/media/video/s5p-tv/mixer_video.c
new file mode 100644
index 0000000..f4fc3e1
--- /dev/null
+++ b/drivers/media/video/s5p-tv/mixer_video.c
@@ -0,0 +1,956 @@
+/*
+ * Samsung TV Mixer driver
+ *
+ * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
+ *
+ * Tomasz Stanislawski, <t.stanislaws@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundiation. either version 2 of the License,
+ * or (at your option) any later version
+ */
+
+#include "mixer.h"
+
+#include <media/v4l2-ioctl.h>
+#include <linux/videodev2.h>
+#include <linux/mm.h>
+#include <linux/version.h>
+#include <linux/timer.h>
+#include <media/videobuf2-dma-contig.h>
+
+static int find_reg_callback(struct device *dev, void *p)
+{
+	struct v4l2_subdev **sd = p;
+
+	*sd = dev_get_drvdata(dev);
+	/* non-zero value stops iteration */
+	return 1;
+}
+
+static struct v4l2_subdev *find_and_register_subdev(
+	struct mxr_device *mdev, char *module_name)
+{
+	struct device_driver *drv;
+	struct v4l2_subdev *sd = NULL;
+	int ret;
+
+	/* TODO: add waiting until probe is finished */
+	drv = driver_find(module_name, &platform_bus_type);
+	if (!drv) {
+		mxr_warn(mdev, "module %s is missing\n", module_name);
+		return NULL;
+	}
+	/* driver refcnt is increased, it is safe to iterate over devices */
+	ret = driver_for_each_device(drv, NULL, &sd, find_reg_callback);
+	/* ret == 0 means that find_reg_callback was never executed */
+	if (sd == NULL) {
+		mxr_warn(mdev, "module %s provides no subdev!\n", module_name);
+		goto done;
+	}
+	/* v4l2_device_register_subdev detects if sd is NULL */
+	ret = v4l2_device_register_subdev(&mdev->v4l2_dev, sd);
+	if (ret) {
+		mxr_warn(mdev, "failed to register subdev %s\n", sd->name);
+		sd = NULL;
+	}
+
+done:
+	put_driver(drv);
+	return sd;
+}
+
+int __devinit mxr_acquire_video(struct mxr_device *mdev,
+	struct mxr_output_conf *output_conf, int output_count)
+{
+	struct device *dev = mdev->dev;
+	struct v4l2_device *vdev = &mdev->v4l2_dev;
+	int i;
+	int ret = 0;
+	struct v4l2_subdev *sd;
+
+	strlcpy(vdev->name, "s5p-tv", sizeof(vdev->name));
+	/* prepare context for V4L2 device */
+	ret = v4l2_device_register(dev, vdev);
+	if (ret) {
+		mxr_err(mdev, "could not register v4l2 device.\n");
+		goto fail;
+	}
+
+	mdev->alloc_ctx = vb2_dma_contig_init_ctx(mdev->dev);
+	if (IS_ERR_OR_NULL(mdev->alloc_ctx)) {
+		mxr_err(mdev, "could not acquire vb2 allocator\n");
+		goto fail_v4l2_dev;
+	}
+
+	/* registering outputs */
+	mdev->output_cnt = 0;
+	for (i = 0; i < output_count; ++i) {
+		struct mxr_output_conf *conf = &output_conf[i];
+		struct mxr_output *out;
+		sd = find_and_register_subdev(mdev, conf->module_name);
+		/* trying to register next output */
+		if (sd == NULL)
+			continue;
+		out = kzalloc(sizeof *out, GFP_KERNEL);
+		if (out == NULL) {
+			mxr_err(mdev, "no memory for '%s'\n",
+				conf->output_name);
+			ret = -ENOMEM;
+			/* registered subdevs are removed in fail_v4l2_dev */
+			goto fail_output;
+		}
+		strlcpy(out->name, conf->output_name, sizeof(out->name));
+		out->sd = sd;
+		out->cookie = conf->cookie;
+		mdev->output[mdev->output_cnt++] = out;
+		mxr_info(mdev, "added output '%s' from module '%s'\n",
+			conf->output_name, conf->module_name);
+		/* checking if maximal number of outputs is reached */
+		if (mdev->output_cnt >= MXR_MAX_OUTPUTS)
+			break;
+	}
+
+	if (mdev->output_cnt == 0) {
+		mxr_err(mdev, "failed to register any output\n");
+		ret = -ENODEV;
+		/* skipping fail_output because there is nothing to free */
+		goto fail_vb2_allocator;
+	}
+
+	return 0;
+
+fail_output:
+	/* kfree is NULL-safe */
+	for (i = 0; i < mdev->output_cnt; ++i)
+		kfree(mdev->output[i]);
+	memset(mdev->output, 0, sizeof mdev->output);
+
+fail_vb2_allocator:
+	/* freeing allocator context */
+	vb2_dma_contig_cleanup_ctx(mdev->alloc_ctx);
+
+fail_v4l2_dev:
+	/* NOTE: automatically unregisteres all subdevs */
+	v4l2_device_unregister(vdev);
+
+fail:
+	return ret;
+}
+
+void __devexit mxr_release_video(struct mxr_device *mdev)
+{
+	int i;
+
+	/* kfree is NULL-safe */
+	for (i = 0; i < mdev->output_cnt; ++i)
+		kfree(mdev->output[i]);
+
+	vb2_dma_contig_cleanup_ctx(mdev->alloc_ctx);
+	v4l2_device_unregister(&mdev->v4l2_dev);
+}
+
+static int mxr_querycap(struct file *file, void *priv,
+	struct v4l2_capability *cap)
+{
+	struct mxr_layer *layer = video_drvdata(file);
+
+	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
+
+	strlcpy(cap->driver, MXR_DRIVER_NAME, sizeof cap->driver);
+	strlcpy(cap->card, layer->vfd.name, sizeof cap->card);
+	sprintf(cap->bus_info, "%d", layer->idx);
+	cap->version = KERNEL_VERSION(0, 1, 0);
+	cap->capabilities = V4L2_CAP_STREAMING |
+		V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_VIDEO_OUTPUT_MPLANE;
+
+	return 0;
+}
+
+/* Geometry handling */
+static void mxr_layer_geo_fix(struct mxr_layer *layer)
+{
+	struct mxr_device *mdev = layer->mdev;
+	struct v4l2_mbus_framefmt mbus_fmt;
+
+	/* TODO: add some dirty flag to avoid unneccessary adjustments */
+	mxr_get_mbus_fmt(mdev, &mbus_fmt);
+	layer->geo.dst.full_width = mbus_fmt.width;
+	layer->geo.dst.full_height = mbus_fmt.height;
+	layer->geo.dst.field = mbus_fmt.field;
+	layer->ops.fix_geometry(layer);
+}
+
+static void mxr_layer_default_geo(struct mxr_layer *layer)
+{
+	struct mxr_device *mdev = layer->mdev;
+	struct v4l2_mbus_framefmt mbus_fmt;
+
+	memset(&layer->geo, 0, sizeof layer->geo);
+
+	mxr_get_mbus_fmt(mdev, &mbus_fmt);
+
+	layer->geo.dst.full_width = mbus_fmt.width;
+	layer->geo.dst.full_height = mbus_fmt.height;
+	layer->geo.dst.width = layer->geo.dst.full_width;
+	layer->geo.dst.height = layer->geo.dst.full_height;
+	layer->geo.dst.field = mbus_fmt.field;
+
+	layer->geo.src.full_width = mbus_fmt.width;
+	layer->geo.src.full_height = mbus_fmt.height;
+	layer->geo.src.width = layer->geo.src.full_width;
+	layer->geo.src.height = layer->geo.src.full_height;
+
+	layer->ops.fix_geometry(layer);
+}
+
+static void mxr_geometry_dump(struct mxr_device *mdev, struct mxr_geometry *geo)
+{
+	mxr_dbg(mdev, "src.full_size = (%u, %u)\n",
+		geo->src.full_width, geo->src.full_height);
+	mxr_dbg(mdev, "src.size = (%u, %u)\n",
+		geo->src.width, geo->src.height);
+	mxr_dbg(mdev, "src.offset = (%u, %u)\n",
+		geo->src.x_offset, geo->src.y_offset);
+	mxr_dbg(mdev, "dst.full_size = (%u, %u)\n",
+		geo->dst.full_width, geo->dst.full_height);
+	mxr_dbg(mdev, "dst.size = (%u, %u)\n",
+		geo->dst.width, geo->dst.height);
+	mxr_dbg(mdev, "dst.offset = (%u, %u)\n",
+		geo->dst.x_offset, geo->dst.y_offset);
+	mxr_dbg(mdev, "ratio = (%u, %u)\n",
+		geo->x_ratio, geo->y_ratio);
+}
+
+
+static const struct mxr_format *find_format_by_fourcc(
+	struct mxr_layer *layer, unsigned long fourcc);
+static const struct mxr_format *find_format_by_index(
+	struct mxr_layer *layer, unsigned long index);
+
+static int mxr_enum_fmt(struct file *file, void  *priv,
+	struct v4l2_fmtdesc *f)
+{
+	struct mxr_layer *layer = video_drvdata(file);
+	struct mxr_device *mdev = layer->mdev;
+	const struct mxr_format *fmt;
+
+	mxr_dbg(mdev, "%s\n", __func__);
+	fmt = find_format_by_index(layer, f->index);
+	if (fmt == NULL)
+		return -EINVAL;
+
+	strlcpy(f->description, fmt->name, sizeof(f->description));
+	f->pixelformat = fmt->fourcc;
+
+	return 0;
+}
+
+static int mxr_s_fmt(struct file *file, void *priv,
+	struct v4l2_format *f)
+{
+	struct mxr_layer *layer = video_drvdata(file);
+	const struct mxr_format *fmt;
+	struct v4l2_pix_format_mplane *pix;
+	struct mxr_device *mdev = layer->mdev;
+	struct mxr_geometry *geo = &layer->geo;
+	int i;
+
+	mxr_dbg(mdev, "%s:%d\n", __func__, __LINE__);
+
+	pix = &f->fmt.pix_mp;
+	fmt = find_format_by_fourcc(layer, pix->pixelformat);
+	if (fmt == NULL) {
+		mxr_warn(mdev, "not recognized fourcc: %08x\n",
+			pix->pixelformat);
+		return -EINVAL;
+	}
+	layer->fmt = fmt;
+	geo->src.full_width = pix->width;
+	geo->src.width = pix->width;
+	geo->src.full_height = pix->height;
+	geo->src.height = pix->height;
+	/* assure consistency of geometry */
+	mxr_layer_geo_fix(layer);
+
+	for (i = 0; i < fmt->num_subframes; ++i) {
+		unsigned int n_pixel = fmt->plane[i].height *
+			fmt->plane[i].width;
+		pix->plane_fmt[i].bytesperline = geo->src.full_width *
+			fmt->plane[i].size / n_pixel;
+	}
+	mxr_dbg(mdev, "width=%u height=%u bpp=%u span=%u\n",
+		geo->src.width, geo->src.height,
+		pix->plane_fmt[0].bytesperline, geo->src.full_width);
+	return 0;
+}
+
+static int mxr_g_fmt(struct file *file, void *priv,
+			     struct v4l2_format *f)
+{
+	struct mxr_layer *layer = video_drvdata(file);
+
+	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
+
+	f->fmt.pix.width	= layer->geo.src.full_width;
+	f->fmt.pix.height	= layer->geo.src.full_height;
+	f->fmt.pix.field	= V4L2_FIELD_NONE;
+	f->fmt.pix.pixelformat	= layer->fmt->fourcc;
+
+	return 0;
+}
+
+static inline struct mxr_crop *choose_crop_by_type(struct mxr_geometry *geo,
+	enum v4l2_buf_type type)
+{
+	switch (type) {
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
+		return &geo->dst;
+	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
+		return &geo->src;
+	default:
+		return NULL;
+	}
+}
+
+static int mxr_g_crop(struct file *file, void *fh, struct v4l2_crop *a)
+{
+	struct mxr_layer *layer = video_drvdata(file);
+	struct mxr_crop *crop;
+
+	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
+	crop = choose_crop_by_type(&layer->geo, a->type);
+	if (crop == NULL)
+		return -EINVAL;
+	mxr_layer_geo_fix(layer);
+	a->c.left = crop->x_offset;
+	a->c.top = crop->y_offset;
+	a->c.width = crop->width;
+	a->c.height = crop->height;
+	return 0;
+}
+
+static int mxr_s_crop(struct file *file, void *fh, struct v4l2_crop *a)
+{
+	struct mxr_layer *layer = video_drvdata(file);
+	struct mxr_crop *crop;
+
+	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
+	crop = choose_crop_by_type(&layer->geo, a->type);
+	if (crop == NULL)
+		return -EINVAL;
+	crop->x_offset = a->c.left;
+	crop->y_offset = a->c.top;
+	crop->width = a->c.width;
+	crop->height = a->c.height;
+	mxr_layer_geo_fix(layer);
+	return 0;
+}
+
+static int mxr_cropcap(struct file *file, void *fh, struct v4l2_cropcap *a)
+{
+	struct mxr_layer *layer = video_drvdata(file);
+	struct mxr_crop *crop;
+
+	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
+	crop = choose_crop_by_type(&layer->geo, a->type);
+	if (crop == NULL)
+		return -EINVAL;
+	mxr_layer_geo_fix(layer);
+	a->bounds.left = 0;
+	a->bounds.top = 0;
+	a->bounds.width = crop->full_width;
+	a->bounds.top = crop->full_height;
+	a->defrect = a->bounds;
+	return 0;
+}
+
+static int mxr_enum_dv_presets(struct file *file, void *fh,
+	struct v4l2_dv_enum_preset *preset)
+{
+	struct mxr_layer *layer = video_drvdata(file);
+	struct mxr_device *mdev = layer->mdev;
+	int ret;
+
+	/* lock protects from changing sd_out */
+	mutex_lock(&mdev->mutex);
+	ret = v4l2_subdev_call(to_outsd(mdev), video, enum_dv_presets, preset);
+	mutex_unlock(&mdev->mutex);
+
+	return ret ? -EINVAL : 0;
+}
+
+static int mxr_s_dv_preset(struct file *file, void *fh,
+	struct v4l2_dv_preset *preset)
+{
+	struct mxr_layer *layer = video_drvdata(file);
+	struct mxr_device *mdev = layer->mdev;
+	int ret;
+
+	/* lock protects from changing sd_out */
+	mutex_lock(&mdev->mutex);
+
+	/* preset change cannot be done while there is an entity
+	 * dependant on output configuration
+	 */
+	if (mdev->n_output == 0)
+		ret = v4l2_subdev_call(to_outsd(mdev), video, s_dv_preset,
+			preset);
+	else
+		ret = -EBUSY;
+
+	mutex_unlock(&mdev->mutex);
+
+	return ret;
+}
+
+static int mxr_g_dv_preset(struct file *file, void *fh,
+	struct v4l2_dv_preset *preset)
+{
+	struct mxr_layer *layer = video_drvdata(file);
+	struct mxr_device *mdev = layer->mdev;
+	int ret;
+
+	/* lock protects from changing sd_out */
+	mutex_lock(&mdev->mutex);
+	ret = v4l2_subdev_call(to_outsd(mdev), video, query_dv_preset, preset);
+	mutex_unlock(&mdev->mutex);
+
+	return ret;
+}
+
+static int mxr_s_std(struct file *file, void *fh, v4l2_std_id *norm)
+{
+	struct mxr_layer *layer = video_drvdata(file);
+	struct mxr_device *mdev = layer->mdev;
+	int ret;
+
+	/* lock protects from changing sd_out */
+	mutex_lock(&mdev->mutex);
+
+	/* standard change cannot be done while there is an entity
+	 * dependant on output configuration
+	 */
+	if (mdev->n_output == 0)
+		ret = v4l2_subdev_call(to_outsd(mdev), video, s_std_output,
+			*norm);
+	else
+		ret = -EBUSY;
+
+	mutex_unlock(&mdev->mutex);
+
+	return ret;
+}
+
+static int mxr_enum_output(struct file *file, void *fh, struct v4l2_output *a)
+{
+	struct mxr_layer *layer = video_drvdata(file);
+	struct mxr_device *mdev = layer->mdev;
+	struct mxr_output *out;
+	struct v4l2_subdev *sd;
+
+	if (a->index >= mdev->output_cnt)
+		return -EINVAL;
+	out = mdev->output[a->index];
+	BUG_ON(out == NULL);
+	sd = out->sd;
+	strlcpy(a->name, out->name, sizeof(a->name));
+
+	/* try to obtain supported tv norms */
+	v4l2_subdev_call(sd, video, g_tvnorms, &a->std);
+	a->capabilities = 0;
+	if (sd->ops->video && sd->ops->video->s_dv_preset)
+		a->capabilities |= V4L2_OUT_CAP_PRESETS;
+	if (sd->ops->video && sd->ops->video->s_std_output)
+		a->capabilities |= V4L2_OUT_CAP_STD;
+
+	return 0;
+}
+
+static int mxr_s_output(struct file *file, void *fh, unsigned int i)
+{
+	struct video_device *vfd = video_devdata(file);
+	struct mxr_layer *layer = video_drvdata(file);
+	struct mxr_device *mdev = layer->mdev;
+	int ret = 0;
+
+	if (i >= mdev->output_cnt || mdev->output[i] == NULL)
+		return -EINVAL;
+
+	mutex_lock(&mdev->mutex);
+	if (mdev->n_output > 0) {
+		ret = -EBUSY;
+		goto done;
+	}
+	mdev->current_output = i;
+	mxr_info(mdev, "tvnorms = %08llx\n", vfd->tvnorms);
+	vfd->tvnorms = 0;
+	v4l2_subdev_call(to_outsd(mdev), video, g_tvnorms, &vfd->tvnorms);
+	mxr_info(mdev, "new tvnorms = %08llx\n", vfd->tvnorms);
+
+done:
+	mutex_unlock(&mdev->mutex);
+	return ret;
+}
+
+static int mxr_reqbufs(struct file *file, void *priv,
+			  struct v4l2_requestbuffers *p)
+{
+	struct mxr_layer *layer = video_drvdata(file);
+
+	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
+	return vb2_reqbufs(&layer->vb_queue, p);
+}
+
+static int mxr_querybuf(struct file *file, void *priv, struct v4l2_buffer *p)
+{
+	struct mxr_layer *layer = video_drvdata(file);
+
+	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
+	return vb2_querybuf(&layer->vb_queue, p);
+}
+
+static int mxr_qbuf(struct file *file, void *priv, struct v4l2_buffer *p)
+{
+	struct mxr_layer *layer = video_drvdata(file);
+
+	mxr_dbg(layer->mdev, "%s:%d(%d)\n", __func__, __LINE__, p->index);
+	return vb2_qbuf(&layer->vb_queue, p);
+}
+
+static int mxr_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
+{
+	struct mxr_layer *layer = video_drvdata(file);
+
+	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
+	return vb2_dqbuf(&layer->vb_queue, p, file->f_flags & O_NONBLOCK);
+}
+
+static int mxr_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
+{
+	struct mxr_layer *layer = video_drvdata(file);
+
+	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
+	return vb2_streamon(&layer->vb_queue, i);
+}
+
+static int mxr_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
+{
+	struct mxr_layer *layer = video_drvdata(file);
+
+	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
+	return vb2_streamoff(&layer->vb_queue, i);
+}
+
+static const struct v4l2_ioctl_ops mxr_ioctl_ops = {
+	.vidioc_querycap = mxr_querycap,
+	/* format handling */
+	.vidioc_enum_fmt_vid_out = mxr_enum_fmt,
+	.vidioc_s_fmt_vid_out_mplane = mxr_s_fmt,
+	.vidioc_g_fmt_vid_out_mplane = mxr_g_fmt,
+	/* buffer control */
+	.vidioc_reqbufs = mxr_reqbufs,
+	.vidioc_querybuf = mxr_querybuf,
+	.vidioc_qbuf = mxr_qbuf,
+	.vidioc_dqbuf = mxr_dqbuf,
+	/* Streaming control */
+	.vidioc_streamon = mxr_streamon,
+	.vidioc_streamoff = mxr_streamoff,
+	/* Preset functions */
+	.vidioc_enum_dv_presets = mxr_enum_dv_presets,
+	.vidioc_s_dv_preset = mxr_s_dv_preset,
+	.vidioc_g_dv_preset = mxr_g_dv_preset,
+	/* analog TV standard functions */
+	.vidioc_s_std = mxr_s_std,
+	/* Output handling */
+	.vidioc_enum_output = mxr_enum_output,
+	.vidioc_s_output = mxr_s_output,
+	/* Crop ioctls */
+	.vidioc_g_crop = mxr_g_crop,
+	.vidioc_s_crop = mxr_s_crop,
+	.vidioc_cropcap = mxr_cropcap,
+};
+
+static int mxr_video_open(struct file *file)
+{
+	struct mxr_layer *layer = video_drvdata(file);
+	struct mxr_device *mdev = layer->mdev;
+	int ret = 0;
+
+	mxr_dbg(mdev, "%s:%d\n", __func__, __LINE__);
+	/* assure device probe is finished */
+	wait_for_device_probe();
+	/* lock layer->mutex is already taken by video_device */
+	/* leaving if layer is already initialized */
+	if (++layer->n_user > 1)
+		return 0;
+
+	/* FIXME: should power be enabled on open? */
+	ret = mxr_power_get(mdev);
+	if (ret) {
+		mxr_err(mdev, "power on failed\n");
+		goto fail_n_user;
+	}
+
+	ret = vb2_queue_init(&layer->vb_queue);
+	if (ret != 0) {
+		mxr_err(mdev, "failed to initialize vb2 queue\n");
+		goto fail_power;
+	}
+	/* set default format, first on the list */
+	layer->fmt = layer->fmt_array[0];
+	/* setup default geometry */
+	mxr_layer_default_geo(layer);
+
+	return 0;
+
+fail_power:
+	mxr_power_put(mdev);
+
+fail_n_user:
+	--layer->n_user;
+
+	return ret;
+}
+
+static unsigned int
+mxr_video_poll(struct file *file, struct poll_table_struct *wait)
+{
+	struct mxr_layer *layer = video_drvdata(file);
+
+	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
+
+	return vb2_poll(&layer->vb_queue, file, wait);
+}
+
+static int mxr_video_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct mxr_layer *layer = video_drvdata(file);
+
+	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
+
+	return vb2_mmap(&layer->vb_queue, vma);
+}
+
+static int mxr_video_release(struct file *file)
+{
+	struct mxr_layer *layer = video_drvdata(file);
+
+	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
+	if (--layer->n_user == 0) {
+		vb2_queue_release(&layer->vb_queue);
+		mxr_power_put(layer->mdev);
+	}
+	return 0;
+}
+
+static const struct v4l2_file_operations mxr_fops = {
+	.owner = THIS_MODULE,
+	.open = mxr_video_open,
+	.poll = mxr_video_poll,
+	.mmap = mxr_video_mmap,
+	.release = mxr_video_release,
+	.unlocked_ioctl = video_ioctl2,
+};
+
+static unsigned int divup(unsigned int divident, unsigned int divisor)
+{
+	return (divident + divisor - 1) / divisor;
+}
+
+unsigned long mxr_get_plane_size(const struct mxr_block *blk,
+	unsigned int width, unsigned int height)
+{
+	unsigned int bl_width = divup(width, blk->width);
+	unsigned int bl_height = divup(height, blk->height);
+
+	return bl_width * bl_height * blk->size;
+}
+
+static int queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
+	unsigned int *nplanes, unsigned long sizes[],
+	void *alloc_ctxs[])
+{
+	struct mxr_layer *layer = vb2_get_drv_priv(vq);
+	const struct mxr_format *fmt = layer->fmt;
+	int i;
+	struct mxr_device *mdev = layer->mdev;
+
+	mxr_dbg(mdev, "%s\n", __func__);
+	/* checking if format was configured */
+	if (fmt == NULL)
+		return -EINVAL;
+	mxr_dbg(mdev, "fmt = %s\n", fmt->name);
+
+	*nplanes = fmt->num_subframes;
+	for (i = 0; i < fmt->num_subframes; ++i) {
+		alloc_ctxs[i] = layer->mdev->alloc_ctx;
+		sizes[i] = 0;
+	}
+
+	for (i = 0; i < fmt->num_planes; ++i) {
+		int frame_idx = fmt->plane2subframe[i];
+		const struct mxr_block *blk = &fmt->plane[i];
+		unsigned long plane_size;
+		plane_size = mxr_get_plane_size(blk, layer->geo.src.full_width,
+			layer->geo.src.full_height);
+		sizes[frame_idx] += plane_size;
+		mxr_dbg(mdev, "plane_size[%d] = %08lx\n", i, plane_size);
+	}
+	for (i = 0; i < fmt->num_subframes; ++i) {
+		sizes[i] = PAGE_ALIGN(sizes[i]);
+		mxr_dbg(mdev, "size[%d] = %08lx\n", i, sizes[i]);
+	}
+
+	if (*nbuffers == 0)
+		*nbuffers = 1;
+
+	return 0;
+}
+
+static void buf_queue(struct vb2_buffer *vb)
+{
+	struct mxr_buffer *buffer = container_of(vb, struct mxr_buffer, vb);
+	struct mxr_layer *layer = vb2_get_drv_priv(vb->vb2_queue);
+	struct mxr_device *mdev = layer->mdev;
+	unsigned long flags;
+	int must_start = 0;
+
+	spin_lock_irqsave(&layer->enq_slock, flags);
+	if (layer->state == MXR_LAYER_STREAMING_START) {
+		layer->state = MXR_LAYER_STREAMING;
+		must_start = 1;
+	}
+	list_add_tail(&buffer->list, &layer->enq_list);
+	spin_unlock_irqrestore(&layer->enq_slock, flags);
+	if (must_start) {
+		layer->ops.stream_set(layer, MXR_ENABLE);
+		mxr_streamer_get(mdev);
+	}
+
+	mxr_dbg(mdev, "queuing buffer\n");
+}
+
+static void wait_lock(struct vb2_queue *vq)
+{
+	struct mxr_layer *layer = vb2_get_drv_priv(vq);
+
+	mxr_dbg(layer->mdev, "%s\n", __func__);
+	mutex_lock(&layer->mutex);
+}
+
+static void wait_unlock(struct vb2_queue *vq)
+{
+	struct mxr_layer *layer = vb2_get_drv_priv(vq);
+
+	mxr_dbg(layer->mdev, "%s\n", __func__);
+	mutex_unlock(&layer->mutex);
+}
+
+static int start_streaming(struct vb2_queue *vq)
+{
+	struct mxr_layer *layer = vb2_get_drv_priv(vq);
+	struct mxr_device *mdev = layer->mdev;
+	unsigned long flags;
+
+	mxr_dbg(mdev, "%s\n", __func__);
+	/* block any changes in output configuration */
+	mxr_output_get(mdev);
+
+	/* update layers geometry */
+	mxr_layer_geo_fix(layer);
+	mxr_geometry_dump(mdev, &layer->geo);
+
+	layer->ops.format_set(layer);
+	/* enabling layer in hardware */
+	spin_lock_irqsave(&layer->enq_slock, flags);
+	layer->state = MXR_LAYER_STREAMING_START;
+	spin_unlock_irqrestore(&layer->enq_slock, flags);
+
+	return 0;
+}
+
+static void mxr_watchdog(unsigned long arg)
+{
+	struct mxr_layer *layer = (struct mxr_layer *) arg;
+	struct mxr_device *mdev = layer->mdev;
+	unsigned long flags;
+
+	mxr_err(mdev, "watchdog fired for layer %s\n", layer->vfd.name);
+
+	spin_lock_irqsave(&layer->enq_slock, flags);
+
+	if (layer->update_buf == layer->shadow_buf)
+		layer->update_buf = NULL;
+	if (layer->update_buf) {
+		vb2_buffer_done(&layer->update_buf->vb, VB2_BUF_STATE_ERROR);
+		layer->update_buf = NULL;
+	}
+	if (layer->shadow_buf) {
+		vb2_buffer_done(&layer->shadow_buf->vb, VB2_BUF_STATE_ERROR);
+		layer->shadow_buf = NULL;
+	}
+	spin_unlock_irqrestore(&layer->enq_slock, flags);
+}
+
+static int stop_streaming(struct vb2_queue *vq)
+{
+	struct mxr_layer *layer = vb2_get_drv_priv(vq);
+	struct mxr_device *mdev = layer->mdev;
+	unsigned long flags;
+	struct timer_list watchdog;
+	struct mxr_buffer *buf, *buf_tmp;
+
+	mxr_dbg(mdev, "%s\n", __func__);
+
+	spin_lock_irqsave(&layer->enq_slock, flags);
+
+	/* reset list */
+	layer->state = MXR_LAYER_STREAMING_FINISH;
+
+	/* set all buffer to be done */
+	list_for_each_entry_safe(buf, buf_tmp, &layer->enq_list, list) {
+		list_del(&buf->list);
+		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+	}
+
+	spin_unlock_irqrestore(&layer->enq_slock, flags);
+
+	/* give 1 seconds to complete to complete last buffers */
+	setup_timer_on_stack(&watchdog, mxr_watchdog,
+		(unsigned long)layer);
+	mod_timer(&watchdog, jiffies + msecs_to_jiffies(1000));
+
+	/* wait until all buffers are goes to done state */
+	vb2_wait_for_all_buffers(vq);
+
+	/* stop timer if all synchronization is done */
+	del_timer_sync(&watchdog);
+	destroy_timer_on_stack(&watchdog);
+
+	/* stopping hardware */
+	spin_lock_irqsave(&layer->enq_slock, flags);
+	layer->state = MXR_LAYER_IDLE;
+	spin_unlock_irqrestore(&layer->enq_slock, flags);
+
+	/* disabling layer in hardware */
+	layer->ops.stream_set(layer, MXR_DISABLE);
+	/* remove one streamer */
+	mxr_streamer_put(mdev);
+	/* allow changes in output configuration */
+	mxr_output_put(mdev);
+	return 0;
+}
+
+static struct vb2_ops mxr_video_qops = {
+	.queue_setup = queue_setup,
+	.buf_queue = buf_queue,
+	.wait_prepare = wait_unlock,
+	.wait_finish = wait_lock,
+	.start_streaming = start_streaming,
+	.stop_streaming = stop_streaming,
+};
+
+/* FIXME: itry to put this functions to mxr_base_layer_create */
+int mxr_base_layer_register(struct mxr_layer *layer)
+{
+	struct mxr_device *mdev = layer->mdev;
+	int ret;
+
+	ret = video_register_device(&layer->vfd, VFL_TYPE_GRABBER, -1);
+	if (ret)
+		mxr_err(mdev, "failed to register video device\n");
+	else
+		mxr_info(mdev, "registered layer %s as /dev/video%d\n",
+			layer->vfd.name, layer->vfd.num);
+	return ret;
+}
+
+void mxr_base_layer_unregister(struct mxr_layer *layer)
+{
+	video_unregister_device(&layer->vfd);
+}
+
+void mxr_layer_release(struct mxr_layer *layer)
+{
+	if (layer->ops.release)
+		layer->ops.release(layer);
+}
+
+void mxr_base_layer_release(struct mxr_layer *layer)
+{
+	kfree(layer);
+}
+
+static void mxr_vfd_release(struct video_device *vdev)
+{
+	printk(KERN_INFO "video device release\n");
+}
+
+struct mxr_layer *mxr_base_layer_create(struct mxr_device *mdev,
+	int idx, char *name, struct mxr_layer_ops *ops)
+{
+	struct mxr_layer *layer;
+
+	layer = kzalloc(sizeof *layer, GFP_KERNEL);
+	if (layer == NULL) {
+		mxr_err(mdev, "not enough memory for layer.\n");
+		goto fail;
+	}
+
+	layer->mdev = mdev;
+	layer->idx = idx;
+	layer->ops = *ops;
+
+	spin_lock_init(&layer->enq_slock);
+	INIT_LIST_HEAD(&layer->enq_list);
+	mutex_init(&layer->mutex);
+
+	layer->vfd = (struct video_device) {
+		.minor = -1,
+		.release = mxr_vfd_release,
+		.fops = &mxr_fops,
+		.ioctl_ops = &mxr_ioctl_ops,
+	};
+	strlcpy(layer->vfd.name, name, sizeof(layer->vfd.name));
+
+	video_set_drvdata(&layer->vfd, layer);
+	layer->vfd.lock = &layer->mutex;
+	layer->vfd.v4l2_dev = &mdev->v4l2_dev;
+
+	layer->vb_queue = (struct vb2_queue) {
+		.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,
+		.io_modes = VB2_MMAP | VB2_USERPTR,
+		.drv_priv = layer,
+		.buf_struct_size = sizeof(struct mxr_buffer),
+		.ops = &mxr_video_qops,
+		.mem_ops = &vb2_dma_contig_memops,
+	};
+
+	return layer;
+
+fail:
+	return NULL;
+}
+
+static const struct mxr_format *find_format_by_fourcc(
+	struct mxr_layer *layer, unsigned long fourcc)
+{
+	int i;
+
+	for (i = 0; i < layer->fmt_array_size; ++i)
+		if (layer->fmt_array[i]->fourcc == fourcc)
+			return layer->fmt_array[i];
+	return NULL;
+}
+
+static const struct mxr_format *find_format_by_index(
+	struct mxr_layer *layer, unsigned long index)
+{
+	if (index >= layer->fmt_array_size)
+		return NULL;
+	return layer->fmt_array[index];
+}
+
diff --git a/drivers/media/video/s5p-tv/mixer_vp_layer.c b/drivers/media/video/s5p-tv/mixer_vp_layer.c
new file mode 100644
index 0000000..88b457e
--- /dev/null
+++ b/drivers/media/video/s5p-tv/mixer_vp_layer.c
@@ -0,0 +1,207 @@
+/*
+ * Samsung TV Mixer driver
+ *
+ * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
+ *
+ * Tomasz Stanislawski, <t.stanislaws@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundiation. either version 2 of the License,
+ * or (at your option) any later version
+ */
+
+#include "mixer.h"
+
+#include "regs-vp.h"
+
+#include <media/videobuf2-dma-contig.h>
+
+/* FORMAT DEFINITIONS */
+static const struct mxr_format mxr_fmt_nv12 = {
+	.name = "NV12",
+	.fourcc = V4L2_PIX_FMT_NV12,
+	.num_planes = 2,
+	.plane = {
+		{ .width = 1, .height = 1, .size = 1 },
+		{ .width = 2, .height = 2, .size = 2 },
+	},
+	.num_subframes = 1,
+	.cookie = VP_MODE_NV12 | VP_MODE_MEM_LINEAR,
+};
+
+static const struct mxr_format mxr_fmt_nv21 = {
+	.name = "NV21",
+	.fourcc = V4L2_PIX_FMT_NV21,
+	.num_planes = 2,
+	.plane = {
+		{ .width = 1, .height = 1, .size = 1 },
+		{ .width = 2, .height = 2, .size = 2 },
+	},
+	.num_subframes = 1,
+	.cookie = VP_MODE_NV21 | VP_MODE_MEM_LINEAR,
+};
+
+static const struct mxr_format mxr_fmt_nv12m = {
+	.name = "NV12 (mplane)",
+	.fourcc = V4L2_PIX_FMT_NV12M,
+	.num_planes = 2,
+	.plane = {
+		{ .width = 1, .height = 1, .size = 1 },
+		{ .width = 2, .height = 2, .size = 2 },
+	},
+	.num_subframes = 2,
+	.plane2subframe = {0, 1},
+	.cookie = VP_MODE_NV12 | VP_MODE_MEM_LINEAR,
+};
+
+static const struct mxr_format mxr_fmt_nv12mt = {
+	.name = "NV12 tiled (mplane)",
+	.fourcc = V4L2_PIX_FMT_NV12MT,
+	.num_planes = 2,
+	.plane = {
+		{ .width = 128, .height = 32, .size = 4096 },
+		{ .width = 128, .height = 32, .size = 2048 },
+	},
+	.num_subframes = 2,
+	.plane2subframe = {0, 1},
+	.cookie = VP_MODE_NV12 | VP_MODE_MEM_TILED,
+};
+
+static const struct mxr_format *mxr_video_format[] = {
+	&mxr_fmt_nv12,
+	&mxr_fmt_nv21,
+	&mxr_fmt_nv12m,
+	&mxr_fmt_nv12mt,
+};
+
+/* AUXILIARY CALLBACKS */
+
+static void mxr_vp_layer_release(struct mxr_layer *layer)
+{
+	mxr_base_layer_unregister(layer);
+	mxr_base_layer_release(layer);
+}
+
+static void mxr_vp_buffer_set(struct mxr_layer *layer,
+	struct mxr_buffer *buf)
+{
+	dma_addr_t luma_addr[2] = {0, 0};
+	dma_addr_t chroma_addr[2] = {0, 0};
+
+	if (buf == NULL) {
+		mxr_reg_vp_buffer(layer->mdev, luma_addr, chroma_addr);
+		return;
+	}
+	luma_addr[0] = vb2_dma_contig_plane_paddr(&buf->vb, 0);
+	if (layer->fmt->num_subframes == 2) {
+		chroma_addr[0] = vb2_dma_contig_plane_paddr(&buf->vb, 1);
+	} else {
+		/* FIXME: mxr_get_plane_size compute integer division,
+		 * which is slow and should not be performed in interrupt */
+		chroma_addr[0] = luma_addr[0] + mxr_get_plane_size(
+			&layer->fmt->plane[0], layer->geo.src.full_width,
+			layer->geo.src.full_height);
+	}
+	if (layer->fmt->cookie & VP_MODE_MEM_TILED) {
+		luma_addr[1] = luma_addr[0] + 0x40;
+		chroma_addr[1] = chroma_addr[0] + 0x40;
+	} else {
+		luma_addr[1] = luma_addr[0] + layer->geo.src.full_width;
+		chroma_addr[1] = chroma_addr[0];
+	}
+	mxr_reg_vp_buffer(layer->mdev, luma_addr, chroma_addr);
+}
+
+static void mxr_vp_stream_set(struct mxr_layer *layer, int en)
+{
+	mxr_reg_vp_layer_stream(layer->mdev, en);
+}
+
+static void mxr_vp_format_set(struct mxr_layer *layer)
+{
+	mxr_reg_vp_format(layer->mdev, layer->fmt, &layer->geo);
+}
+
+static void mxr_vp_fix_geometry(struct mxr_layer *layer)
+{
+	struct mxr_geometry *geo = &layer->geo;
+
+	/* align horizontal size to 8 pixels */
+	geo->src.full_width = ALIGN(geo->src.full_width, 8);
+	/* limit to boundary size */
+	geo->src.full_width = clamp_val(geo->src.full_width, 8, 8192);
+	geo->src.full_height = clamp_val(geo->src.full_height, 1, 8192);
+	geo->src.width = clamp_val(geo->src.width, 32, geo->src.full_width);
+	geo->src.width = min(geo->src.width, 2047U);
+	geo->src.height = clamp_val(geo->src.height, 4, geo->src.full_height);
+	geo->src.height = min(geo->src.height, 2047U);
+
+	/* setting size of output window */
+	geo->dst.width = clamp_val(geo->dst.width, 8, geo->dst.full_width);
+	geo->dst.height = clamp_val(geo->dst.height, 1, geo->dst.full_height);
+
+	/* ensure that scaling is in range 1/4x to 16x */
+	if (geo->src.width >= 4 * geo->dst.width)
+		geo->src.width = 4 * geo->dst.width;
+	if (geo->dst.width >= 16 * geo->src.width)
+		geo->dst.width = 16 * geo->src.width;
+	if (geo->src.height >= 4 * geo->dst.height)
+		geo->src.height = 4 * geo->dst.height;
+	if (geo->dst.height >= 16 * geo->src.height)
+		geo->dst.height = 16 * geo->src.height;
+
+	/* setting scaling ratio */
+	geo->x_ratio = (geo->src.width << 16) / geo->dst.width;
+	geo->y_ratio = (geo->src.height << 16) / geo->dst.height;
+
+	/* adjust offsets */
+	geo->src.x_offset = min(geo->src.x_offset,
+		geo->src.full_width - geo->src.width);
+	geo->src.y_offset = min(geo->src.y_offset,
+		geo->src.full_height - geo->src.height);
+	geo->dst.x_offset = min(geo->dst.x_offset,
+		geo->dst.full_width - geo->dst.width);
+	geo->dst.y_offset = min(geo->dst.y_offset,
+		geo->dst.full_height - geo->dst.height);
+}
+
+/* PUBLIC API */
+
+struct mxr_layer *mxr_vp_layer_create(struct mxr_device *mdev, int idx)
+{
+	struct mxr_layer *layer;
+	int ret;
+	struct mxr_layer_ops ops = {
+		.release = mxr_vp_layer_release,
+		.buffer_set = mxr_vp_buffer_set,
+		.stream_set = mxr_vp_stream_set,
+		.format_set = mxr_vp_format_set,
+		.fix_geometry = mxr_vp_fix_geometry,
+	};
+	char name[32];
+
+	sprintf(name, "video%d", idx);
+
+	layer = mxr_base_layer_create(mdev, idx, name, &ops);
+	if (layer == NULL) {
+		mxr_err(mdev, "failed to initialize layer(%d) base\n", idx);
+		goto fail;
+	}
+
+	layer->fmt_array = mxr_video_format;
+	layer->fmt_array_size = ARRAY_SIZE(mxr_video_format);
+
+	ret = mxr_base_layer_register(layer);
+	if (ret)
+		goto fail_layer;
+
+	return layer;
+
+fail_layer:
+	mxr_base_layer_release(layer);
+
+fail:
+	return NULL;
+}
+
diff --git a/drivers/media/video/s5p-tv/regs-hdmi.h b/drivers/media/video/s5p-tv/regs-hdmi.h
new file mode 100644
index 0000000..ac93ad6
--- /dev/null
+++ b/drivers/media/video/s5p-tv/regs-hdmi.h
@@ -0,0 +1,141 @@
+/* linux/arch/arm/mach-exynos4/include/mach/regs-hdmi.h
+ *
+ * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
+ * http://www.samsung.com/
+ *
+ * HDMI register header file for Samsung TVOUT driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#ifndef SAMSUNG_REGS_HDMI_H
+#define SAMSUNG_REGS_HDMI_H
+
+/*
+ * Register part
+*/
+
+#define HDMI_CTRL_BASE(x)		((x) + 0x00000000)
+#define HDMI_CORE_BASE(x)		((x) + 0x00010000)
+#define HDMI_TG_BASE(x)			((x) + 0x00050000)
+
+/* Control registers */
+#define HDMI_INTC_CON			HDMI_CTRL_BASE(0x0000)
+#define HDMI_INTC_FLAG			HDMI_CTRL_BASE(0x0004)
+#define HDMI_HPD_STATUS			HDMI_CTRL_BASE(0x000C)
+#define HDMI_PHY_RSTOUT			HDMI_CTRL_BASE(0x0014)
+#define HDMI_PHY_VPLL			HDMI_CTRL_BASE(0x0018)
+#define HDMI_PHY_CMU			HDMI_CTRL_BASE(0x001C)
+#define HDMI_CORE_RSTOUT		HDMI_CTRL_BASE(0x0020)
+
+/* Core registers */
+#define HDMI_CON_0			HDMI_CORE_BASE(0x0000)
+#define HDMI_CON_1			HDMI_CORE_BASE(0x0004)
+#define HDMI_CON_2			HDMI_CORE_BASE(0x0008)
+#define HDMI_SYS_STATUS			HDMI_CORE_BASE(0x0010)
+#define HDMI_PHY_STATUS			HDMI_CORE_BASE(0x0014)
+#define HDMI_STATUS_EN			HDMI_CORE_BASE(0x0020)
+#define HDMI_HPD			HDMI_CORE_BASE(0x0030)
+#define HDMI_MODE_SEL			HDMI_CORE_BASE(0x0040)
+#define HDMI_BLUE_SCREEN_0		HDMI_CORE_BASE(0x0050)
+#define HDMI_BLUE_SCREEN_1		HDMI_CORE_BASE(0x0054)
+#define HDMI_BLUE_SCREEN_2		HDMI_CORE_BASE(0x0058)
+#define HDMI_H_BLANK_0			HDMI_CORE_BASE(0x00A0)
+#define HDMI_H_BLANK_1			HDMI_CORE_BASE(0x00A4)
+#define HDMI_V_BLANK_0			HDMI_CORE_BASE(0x00B0)
+#define HDMI_V_BLANK_1			HDMI_CORE_BASE(0x00B4)
+#define HDMI_V_BLANK_2			HDMI_CORE_BASE(0x00B8)
+#define HDMI_H_V_LINE_0			HDMI_CORE_BASE(0x00C0)
+#define HDMI_H_V_LINE_1			HDMI_CORE_BASE(0x00C4)
+#define HDMI_H_V_LINE_2			HDMI_CORE_BASE(0x00C8)
+#define HDMI_VSYNC_POL			HDMI_CORE_BASE(0x00E4)
+#define HDMI_INT_PRO_MODE		HDMI_CORE_BASE(0x00E8)
+#define HDMI_V_BLANK_F_0		HDMI_CORE_BASE(0x0110)
+#define HDMI_V_BLANK_F_1		HDMI_CORE_BASE(0x0114)
+#define HDMI_V_BLANK_F_2		HDMI_CORE_BASE(0x0118)
+#define HDMI_H_SYNC_GEN_0		HDMI_CORE_BASE(0x0120)
+#define HDMI_H_SYNC_GEN_1		HDMI_CORE_BASE(0x0124)
+#define HDMI_H_SYNC_GEN_2		HDMI_CORE_BASE(0x0128)
+#define HDMI_V_SYNC_GEN_1_0		HDMI_CORE_BASE(0x0130)
+#define HDMI_V_SYNC_GEN_1_1		HDMI_CORE_BASE(0x0134)
+#define HDMI_V_SYNC_GEN_1_2		HDMI_CORE_BASE(0x0138)
+#define HDMI_V_SYNC_GEN_2_0		HDMI_CORE_BASE(0x0140)
+#define HDMI_V_SYNC_GEN_2_1		HDMI_CORE_BASE(0x0144)
+#define HDMI_V_SYNC_GEN_2_2		HDMI_CORE_BASE(0x0148)
+#define HDMI_V_SYNC_GEN_3_0		HDMI_CORE_BASE(0x0150)
+#define HDMI_V_SYNC_GEN_3_1		HDMI_CORE_BASE(0x0154)
+#define HDMI_V_SYNC_GEN_3_2		HDMI_CORE_BASE(0x0158)
+#define HDMI_AVI_CON			HDMI_CORE_BASE(0x0300)
+#define HDMI_AVI_BYTE(n)		HDMI_CORE_BASE(0x0320 + 4 * (n))
+#define	HDMI_DC_CONTROL			HDMI_CORE_BASE(0x05C0)
+#define HDMI_VIDEO_PATTERN_GEN		HDMI_CORE_BASE(0x05C4)
+#define HDMI_HPD_GEN			HDMI_CORE_BASE(0x05C8)
+
+/* Timing generator registers */
+#define HDMI_TG_CMD			HDMI_TG_BASE(0x0000)
+#define HDMI_TG_H_FSZ_L			HDMI_TG_BASE(0x0018)
+#define HDMI_TG_H_FSZ_H			HDMI_TG_BASE(0x001C)
+#define HDMI_TG_HACT_ST_L		HDMI_TG_BASE(0x0020)
+#define HDMI_TG_HACT_ST_H		HDMI_TG_BASE(0x0024)
+#define HDMI_TG_HACT_SZ_L		HDMI_TG_BASE(0x0028)
+#define HDMI_TG_HACT_SZ_H		HDMI_TG_BASE(0x002C)
+#define HDMI_TG_V_FSZ_L			HDMI_TG_BASE(0x0030)
+#define HDMI_TG_V_FSZ_H			HDMI_TG_BASE(0x0034)
+#define HDMI_TG_VSYNC_L			HDMI_TG_BASE(0x0038)
+#define HDMI_TG_VSYNC_H			HDMI_TG_BASE(0x003C)
+#define HDMI_TG_VSYNC2_L		HDMI_TG_BASE(0x0040)
+#define HDMI_TG_VSYNC2_H		HDMI_TG_BASE(0x0044)
+#define HDMI_TG_VACT_ST_L		HDMI_TG_BASE(0x0048)
+#define HDMI_TG_VACT_ST_H		HDMI_TG_BASE(0x004C)
+#define HDMI_TG_VACT_SZ_L		HDMI_TG_BASE(0x0050)
+#define HDMI_TG_VACT_SZ_H		HDMI_TG_BASE(0x0054)
+#define HDMI_TG_FIELD_CHG_L		HDMI_TG_BASE(0x0058)
+#define HDMI_TG_FIELD_CHG_H		HDMI_TG_BASE(0x005C)
+#define HDMI_TG_VACT_ST2_L		HDMI_TG_BASE(0x0060)
+#define HDMI_TG_VACT_ST2_H		HDMI_TG_BASE(0x0064)
+#define HDMI_TG_VSYNC_TOP_HDMI_L	HDMI_TG_BASE(0x0078)
+#define HDMI_TG_VSYNC_TOP_HDMI_H	HDMI_TG_BASE(0x007C)
+#define HDMI_TG_VSYNC_BOT_HDMI_L	HDMI_TG_BASE(0x0080)
+#define HDMI_TG_VSYNC_BOT_HDMI_H	HDMI_TG_BASE(0x0084)
+#define HDMI_TG_FIELD_TOP_HDMI_L	HDMI_TG_BASE(0x0088)
+#define HDMI_TG_FIELD_TOP_HDMI_H	HDMI_TG_BASE(0x008C)
+#define HDMI_TG_FIELD_BOT_HDMI_L	HDMI_TG_BASE(0x0090)
+#define HDMI_TG_FIELD_BOT_HDMI_H	HDMI_TG_BASE(0x0094)
+
+/*
+ * Bit definition part
+ */
+
+/* HDMI_INTC_CON */
+#define HDMI_INTC_EN_GLOBAL		(1 << 6)
+#define HDMI_INTC_EN_HPD_PLUG		(1 << 3)
+#define HDMI_INTC_EN_HPD_UNPLUG		(1 << 2)
+
+/* HDMI_INTC_FLAG */
+#define HDMI_INTC_FLAG_HPD_PLUG		(1 << 3)
+#define HDMI_INTC_FLAG_HPD_UNPLUG	(1 << 2)
+
+/* HDMI_PHY_RSTOUT */
+#define HDMI_PHY_SW_RSTOUT		(1 << 0)
+
+/* HDMI_CORE_RSTOUT */
+#define HDMI_CORE_SW_RSTOUT		(1 << 0)
+
+/* HDMI_CON_0 */
+#define HDMI_BLUE_SCR_EN		(1 << 5)
+#define HDMI_EN				(1 << 0)
+
+/* HDMI_PHY_STATUS */
+#define HDMI_PHY_STATUS_READY		(1 << 0)
+
+/* HDMI_MODE_SEL */
+#define HDMI_MODE_HDMI_EN		(1 << 1)
+#define HDMI_MODE_DVI_EN		(1 << 0)
+#define HDMI_MODE_MASK			(3 << 0)
+
+/* HDMI_TG_CMD */
+#define HDMI_TG_EN			(1 << 0)
+
+#endif /* SAMSUNG_REGS_HDMI_H */
diff --git a/drivers/media/video/s5p-tv/regs-mixer.h b/drivers/media/video/s5p-tv/regs-mixer.h
new file mode 100644
index 0000000..3c84426
--- /dev/null
+++ b/drivers/media/video/s5p-tv/regs-mixer.h
@@ -0,0 +1,121 @@
+/*
+ * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
+ * http://www.samsung.com/
+ *
+ * Mixer register header file for Samsung Mixer driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+#ifndef SAMSUNG_REGS_MIXER_H
+#define SAMSUNG_REGS_MIXER_H
+
+/*
+ * Register part
+ */
+#define MXR_STATUS			0x0000
+#define MXR_CFG				0x0004
+#define MXR_INT_EN			0x0008
+#define MXR_INT_STATUS			0x000C
+#define MXR_LAYER_CFG			0x0010
+#define MXR_VIDEO_CFG			0x0014
+#define MXR_GRAPHIC0_CFG		0x0020
+#define MXR_GRAPHIC0_BASE		0x0024
+#define MXR_GRAPHIC0_SPAN		0x0028
+#define MXR_GRAPHIC0_SXY		0x002C
+#define MXR_GRAPHIC0_WH			0x0030
+#define MXR_GRAPHIC0_DXY		0x0034
+#define MXR_GRAPHIC0_BLANK		0x0038
+#define MXR_GRAPHIC1_CFG		0x0040
+#define MXR_GRAPHIC1_BASE		0x0044
+#define MXR_GRAPHIC1_SPAN		0x0048
+#define MXR_GRAPHIC1_SXY		0x004C
+#define MXR_GRAPHIC1_WH			0x0050
+#define MXR_GRAPHIC1_DXY		0x0054
+#define MXR_GRAPHIC1_BLANK		0x0058
+#define MXR_BG_CFG			0x0060
+#define MXR_BG_COLOR0			0x0064
+#define MXR_BG_COLOR1			0x0068
+#define MXR_BG_COLOR2			0x006C
+
+/* for parametrized access to layer registers */
+#define MXR_GRAPHIC_CFG(i)		(0x0020 + (i) * 0x20)
+#define MXR_GRAPHIC_BASE(i)		(0x0024 + (i) * 0x20)
+#define MXR_GRAPHIC_SPAN(i)		(0x0028 + (i) * 0x20)
+#define MXR_GRAPHIC_SXY(i)		(0x002C + (i) * 0x20)
+#define MXR_GRAPHIC_WH(i)		(0x0030 + (i) * 0x20)
+#define MXR_GRAPHIC_DXY(i)		(0x0034 + (i) * 0x20)
+
+/*
+ * Bit definition part
+ */
+
+/* generates mask for range of bits */
+#define MXR_MASK(high_bit, low_bit) \
+	(((2 << ((high_bit) - (low_bit))) - 1) << (low_bit))
+
+#define MXR_MASK_VAL(val, high_bit, low_bit) \
+	(((val) << (low_bit)) & MXR_MASK(high_bit, low_bit))
+
+/* bits for MXR_STATUS */
+#define MXR_STATUS_16_BURST		(1 << 7)
+#define MXR_STATUS_BURST_MASK		(1 << 7)
+#define MXR_STATUS_SYNC_ENABLE		(1 << 2)
+#define MXR_STATUS_REG_RUN		(1 << 0)
+
+/* bits for MXR_CFG */
+#define MXR_CFG_OUT_YUV444		(0 << 8)
+#define MXR_CFG_OUT_RGB888		(1 << 8)
+#define MXR_CFG_DST_SDO			(0 << 7)
+#define MXR_CFG_DST_HDMI		(1 << 7)
+#define MXR_CFG_DST_MASK		(1 << 7)
+#define MXR_CFG_SCAN_HD_720		(0 << 6)
+#define MXR_CFG_SCAN_HD_1080		(1 << 6)
+#define MXR_CFG_GRP1_ENABLE		(1 << 5)
+#define MXR_CFG_GRP0_ENABLE		(1 << 4)
+#define MXR_CFG_VP_ENABLE		(1 << 3)
+#define MXR_CFG_SCAN_INTERLACE		(0 << 2)
+#define MXR_CFG_SCAN_PROGRASSIVE	(1 << 2)
+#define MXR_CFG_SCAN_NTSC		(0 << 1)
+#define MXR_CFG_SCAN_PAL		(1 << 1)
+#define MXR_CFG_SCAN_SD			(0 << 0)
+#define MXR_CFG_SCAN_HD			(1 << 0)
+#define MXR_CFG_SCAN_MASK		0x47
+
+/* bits for MXR_GRAPHICn_CFG */
+#define MXR_GRP_CFG_COLOR_KEY_DISABLE	(1 << 21)
+#define MXR_GRP_CFG_BLEND_PRE_MUL	(1 << 20)
+#define MXR_GRP_CFG_FORMAT_VAL(x)	MXR_MASK_VAL(x, 11, 8)
+#define MXR_GRP_CFG_FORMAT_MASK		MXR_GRP_CFG_FORMAT_VAL(~0)
+#define MXR_GRP_CFG_ALPHA_VAL(x)	MXR_MASK_VAL(x, 7, 0)
+
+/* bits for MXR_GRAPHICn_WH */
+#define MXR_GRP_WH_H_SCALE(x)		MXR_MASK_VAL(x, 28, 28)
+#define MXR_GRP_WH_V_SCALE(x)		MXR_MASK_VAL(x, 12, 12)
+#define MXR_GRP_WH_WIDTH(x)		MXR_MASK_VAL(x, 26, 16)
+#define MXR_GRP_WH_HEIGHT(x)		MXR_MASK_VAL(x, 10, 0)
+
+/* bits for MXR_GRAPHICn_SXY */
+#define MXR_GRP_SXY_SX(x)		MXR_MASK_VAL(x, 26, 16)
+#define MXR_GRP_SXY_SY(x)		MXR_MASK_VAL(x, 10, 0)
+
+/* bits for MXR_GRAPHICn_DXY */
+#define MXR_GRP_DXY_DX(x)		MXR_MASK_VAL(x, 26, 16)
+#define MXR_GRP_DXY_DY(x)		MXR_MASK_VAL(x, 10, 0)
+
+/* bits for MXR_INT_EN */
+#define MXR_INT_EN_VSYNC		(1 << 11)
+#define MXR_INT_EN_ALL			(0x0f << 8)
+
+/* bit for MXR_INT_STATUS */
+#define MXR_INT_CLEAR_VSYNC		(1 << 11)
+#define MXR_INT_STATUS_VSYNC		(1 << 0)
+
+/* bit for MXR_LAYER_CFG */
+#define MXR_LAYER_CFG_GRP1_VAL(x)	MXR_MASK_VAL(x, 11, 8)
+#define MXR_LAYER_CFG_GRP0_VAL(x)	MXR_MASK_VAL(x, 7, 4)
+#define MXR_LAYER_CFG_VP_VAL(x)		MXR_MASK_VAL(x, 3, 0)
+
+#endif /* SAMSUNG_REGS_MIXER_H */
+
diff --git a/drivers/media/video/s5p-tv/regs-sdo.h b/drivers/media/video/s5p-tv/regs-sdo.h
new file mode 100644
index 0000000..7f7c2b8
--- /dev/null
+++ b/drivers/media/video/s5p-tv/regs-sdo.h
@@ -0,0 +1,63 @@
+/* drivers/media/video/s5p-tv/regs-sdo.h
+ *
+ * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * SDO register description file
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef SAMSUNG_REGS_SDO_H
+#define SAMSUNG_REGS_SDO_H
+
+/*
+ * Register part
+ */
+
+#define SDO_CLKCON			0x0000
+#define SDO_CONFIG			0x0008
+#define SDO_VBI				0x0014
+#define SDO_DAC				0x003C
+#define SDO_CCCON			0x0180
+#define SDO_IRQ				0x0280
+#define SDO_IRQMASK			0x0284
+#define SDO_VERSION			0x03D8
+
+/*
+ * Bit definition part
+ */
+
+/* SDO Clock Control Register (SDO_CLKCON) */
+#define SDO_TVOUT_SW_RESET		(1 << 4)
+#define SDO_TVOUT_CLOCK_READY		(1 << 1)
+#define SDO_TVOUT_CLOCK_ON		(1 << 0)
+
+/* SDO Video Standard Configuration Register (SDO_CONFIG) */
+#define SDO_PROGRESSIVE			(1 << 4)
+#define SDO_NTSC_M			0
+#define SDO_PAL_M			1
+#define SDO_PAL_BGHID			2
+#define SDO_PAL_N			3
+#define SDO_PAL_NC			4
+#define SDO_NTSC_443			8
+#define SDO_PAL_60			9
+#define SDO_STANDARD_MASK		0xf
+
+/* SDO VBI Configuration Register (SDO_VBI) */
+#define SDO_CVBS_WSS_INS		(1 << 14)
+#define SDO_CVBS_CLOSED_CAPTION_MASK	(3 << 12)
+
+/* SDO DAC Configuration Register (SDO_DAC) */
+#define SDO_POWER_ON_DAC		(1 << 0)
+
+/* SDO Color Compensation On/Off Control (SDO_CCCON) */
+#define SDO_COMPENSATION_BHS_ADJ_OFF	(1 << 4)
+#define SDO_COMPENSATION_CVBS_COMP_OFF	(1 << 0)
+
+/* SDO Interrupt Request Register (SDO_IRQ) */
+#define SDO_VSYNC_IRQ_PEND		(1 << 0)
+
+#endif /* SAMSUNG_REGS_SDO_H */
diff --git a/drivers/media/video/s5p-tv/regs-vp.h b/drivers/media/video/s5p-tv/regs-vp.h
new file mode 100644
index 0000000..6c63984
--- /dev/null
+++ b/drivers/media/video/s5p-tv/regs-vp.h
@@ -0,0 +1,88 @@
+/*
+ * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * Video processor register header file for Samsung Mixer driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef SAMSUNG_REGS_VP_H
+#define SAMSUNG_REGS_VP_H
+
+/*
+ * Register part
+ */
+
+#define VP_ENABLE			0x0000
+#define VP_SRESET			0x0004
+#define VP_SHADOW_UPDATE		0x0008
+#define VP_FIELD_ID			0x000C
+#define VP_MODE				0x0010
+#define VP_IMG_SIZE_Y			0x0014
+#define VP_IMG_SIZE_C			0x0018
+#define VP_PER_RATE_CTRL		0x001C
+#define VP_TOP_Y_PTR			0x0028
+#define VP_BOT_Y_PTR			0x002C
+#define VP_TOP_C_PTR			0x0030
+#define VP_BOT_C_PTR			0x0034
+#define VP_ENDIAN_MODE			0x03CC
+#define VP_SRC_H_POSITION		0x0044
+#define VP_SRC_V_POSITION		0x0048
+#define VP_SRC_WIDTH			0x004C
+#define VP_SRC_HEIGHT			0x0050
+#define VP_DST_H_POSITION		0x0054
+#define VP_DST_V_POSITION		0x0058
+#define VP_DST_WIDTH			0x005C
+#define VP_DST_HEIGHT			0x0060
+#define VP_H_RATIO			0x0064
+#define VP_V_RATIO			0x0068
+#define VP_POLY8_Y0_LL			0x006C
+#define VP_POLY4_Y0_LL			0x00EC
+#define VP_POLY4_C0_LL			0x012C
+
+/*
+ * Bit definition part
+ */
+
+/* generates mask for range of bits */
+
+#define VP_MASK(high_bit, low_bit) \
+	(((2 << ((high_bit) - (low_bit))) - 1) << (low_bit))
+
+#define VP_MASK_VAL(val, high_bit, low_bit) \
+	(((val) << (low_bit)) & VP_MASK(high_bit, low_bit))
+
+ /* VP_ENABLE */
+#define VP_ENABLE_ON			(1 << 0)
+
+/* VP_SRESET */
+#define VP_SRESET_PROCESSING		(1 << 0)
+
+/* VP_SHADOW_UPDATE */
+#define VP_SHADOW_UPDATE_ENABLE		(1 << 0)
+
+/* VP_MODE */
+#define VP_MODE_NV12			(0 << 6)
+#define VP_MODE_NV21			(1 << 6)
+#define VP_MODE_LINE_SKIP		(1 << 5)
+#define VP_MODE_MEM_LINEAR		(0 << 4)
+#define VP_MODE_MEM_TILED		(1 << 4)
+#define VP_MODE_FMT_MASK		(5 << 4)
+#define VP_MODE_FIELD_ID_AUTO_TOGGLING	(1 << 2)
+#define VP_MODE_2D_IPC			(1 << 1)
+
+/* VP_IMG_SIZE_Y */
+/* VP_IMG_SIZE_C */
+#define VP_IMG_HSIZE(x)			VP_MASK_VAL(x, 29, 16)
+#define VP_IMG_VSIZE(x)			VP_MASK_VAL(x, 13, 0)
+
+/* VP_SRC_H_POSITION */
+#define VP_SRC_H_POSITION_VAL(x)	VP_MASK_VAL(x, 14, 4)
+
+/* VP_ENDIAN_MODE */
+#define VP_ENDIAN_MODE_LITTLE		(1 << 0)
+
+#endif /* SAMSUNG_REGS_VP_H */
diff --git a/drivers/media/video/s5p-tv/sdo_drv.c b/drivers/media/video/s5p-tv/sdo_drv.c
new file mode 100644
index 0000000..5cb2585
--- /dev/null
+++ b/drivers/media/video/s5p-tv/sdo_drv.c
@@ -0,0 +1,498 @@
+/*
+ * Samsung Standard Definition Output (SDO) driver
+ *
+ * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
+ *
+ * Tomasz Stanislawski, <t.stanislaws@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundiation. either version 2 of the License,
+ * or (at your option) any later version
+ */
+
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+#include <linux/regulator/consumer.h>
+#include <linux/slab.h>
+
+#include <media/v4l2-subdev.h>
+
+#include "regs-sdo.h"
+
+MODULE_AUTHOR("Tomasz Stanislawski, <t.stanislaws@samsung.com>");
+MODULE_DESCRIPTION("Samsung Standard Definition Output (SDO)");
+MODULE_LICENSE("GPL");
+
+#define SDO_DEFAULT_STD	V4L2_STD_PAL_B
+
+static struct platform_driver sdo_driver;
+
+struct sdo_format {
+	v4l2_std_id id;
+	/* all modes are 720 pixels wide */
+	unsigned int height;
+	unsigned int cookie;
+};
+
+struct sdo_device {
+	/** pointer to device parent */
+	struct device *dev;
+	/** base address of SDO registers */
+	void __iomem *regs;
+	/** SDO interrupt */
+	unsigned int irq;
+	/** DAC source clock */
+	struct clk *sclk_dac;
+	/** DAC clock */
+	struct clk *dac;
+	/** DAC physical interface */
+	struct clk *dacphy;
+	/** clock for control of VPLL */
+	struct clk *fout_vpll;
+	/** regulator for SDO IP power */
+	struct regulator *vdac;
+	/** regulator for SDO plug detection */
+	struct regulator *vdet;
+	/** subdev used as device interface */
+	struct v4l2_subdev sd;
+	/** current format */
+	const struct sdo_format *fmt;
+};
+
+static inline struct sdo_device *sd_to_sdev(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct sdo_device, sd);
+}
+
+static inline
+void sdo_write_mask(struct sdo_device *sdev, u32 reg_id, u32 value, u32 mask)
+{
+	u32 old = readl(sdev->regs + reg_id);
+	value = (value & mask) | (old & ~mask);
+	writel(value, sdev->regs + reg_id);
+}
+
+static inline
+void sdo_write(struct sdo_device *sdev, u32 reg_id, u32 value)
+{
+	writel(value, sdev->regs + reg_id);
+}
+
+static inline
+u32 sdo_read(struct sdo_device *sdev, u32 reg_id)
+{
+	return readl(sdev->regs + reg_id);
+}
+
+static void sdo_reg_debug(struct sdo_device *sdev);
+
+static int __init sdo_init(void)
+{
+	int ret;
+	static const char banner[] __initdata = KERN_INFO \
+		"Samsung Standard Definition Output (SDO) driver, "
+		"(c) 2010-2011 Samsung Electronics Co., Ltd.\n";
+	printk(banner);
+
+	ret = platform_driver_register(&sdo_driver);
+	if (ret)
+		printk(KERN_ERR "SDO platform driver register failed\n");
+
+	return ret;
+}
+module_init(sdo_init);
+
+static void __exit sdo_exit(void)
+{
+	platform_driver_unregister(&sdo_driver);
+}
+module_exit(sdo_exit);
+
+static int __devinit sdo_probe(struct platform_device *pdev);
+static int __devexit sdo_remove(struct platform_device *pdev);
+static const struct dev_pm_ops sdo_pm_ops;
+
+static struct platform_driver sdo_driver __refdata = {
+	.probe = sdo_probe,
+	.remove = __devexit_p(sdo_remove),
+	.driver = {
+		.name = "s5p-sdo",
+		.owner = THIS_MODULE,
+		.pm = &sdo_pm_ops,
+	}
+};
+
+static irqreturn_t sdo_irq_handler(int irq, void *dev_data);
+static const struct sdo_format *sdo_find_format(v4l2_std_id id);
+static const struct v4l2_subdev_ops sdo_sd_ops;
+
+static int __devinit sdo_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct sdo_device *sdev;
+	struct resource *res;
+	int ret = 0;
+	struct clk *sclk_vpll;
+
+	dev_info(dev, "probe start\n");
+	sdev = kzalloc(sizeof *sdev, GFP_KERNEL);
+	if (!sdev) {
+		dev_err(dev, "not enough memory.\n");
+		ret = -ENOMEM;
+		goto fail;
+	}
+	sdev->dev = dev;
+
+	/* mapping registers */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res == NULL) {
+		dev_err(dev, "get memory resource failed.\n");
+		ret = -ENXIO;
+		goto fail_sdev;
+	}
+
+	sdev->regs = ioremap(res->start, resource_size(res));
+	if (sdev->regs == NULL) {
+		dev_err(dev, "register mapping failed.\n");
+		ret = -ENXIO;
+		goto fail_sdev;
+	}
+
+	/* acquiring interrupt */
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (res == NULL) {
+		dev_err(dev, "get interrupt resource failed.\n");
+		ret = -ENXIO;
+		goto fail_regs;
+	}
+	ret = request_irq(res->start, sdo_irq_handler, 0, "s5p-sdo", sdev);
+	if (ret) {
+		dev_err(dev, "request interrupt failed.\n");
+		goto fail_regs;
+	}
+	sdev->irq = res->start;
+
+	/* acquire clocks */
+	sdev->sclk_dac = clk_get(dev, "sclk_dac");
+	if (IS_ERR_OR_NULL(sdev->sclk_dac)) {
+		dev_err(dev, "failed to get clock 'sclk_dac'\n");
+		ret = -ENXIO;
+		goto fail_irq;
+	}
+	sdev->dac = clk_get(dev, "dac");
+	if (IS_ERR_OR_NULL(sdev->dac)) {
+		dev_err(dev, "failed to get clock 'dac'\n");
+		ret = -ENXIO;
+		goto fail_sclk_dac;
+	}
+	sdev->dacphy = clk_get(dev, "dacphy");
+	if (IS_ERR_OR_NULL(sdev->dacphy)) {
+		dev_err(dev, "failed to get clock 'dacphy'\n");
+		ret = -ENXIO;
+		goto fail_dac;
+	}
+	sclk_vpll = clk_get(dev, "sclk_vpll");
+	if (IS_ERR_OR_NULL(sclk_vpll)) {
+		dev_err(dev, "failed to get clock 'sclk_vpll'\n");
+		ret = -ENXIO;
+		goto fail_dacphy;
+	}
+	clk_set_parent(sdev->sclk_dac, sclk_vpll);
+	clk_put(sclk_vpll);
+	sdev->fout_vpll = clk_get(dev, "fout_vpll");
+	if (IS_ERR_OR_NULL(sdev->fout_vpll)) {
+		dev_err(dev, "failed to get clock 'fout_vpll'\n");
+		goto fail_dacphy;
+	}
+	dev_info(dev, "fout_vpll.rate = %lu\n", clk_get_rate(sclk_vpll));
+
+	/* acquire regulator */
+	sdev->vdac = regulator_get(dev, "vdd33a_dac");
+	if (IS_ERR_OR_NULL(sdev->vdac)) {
+		dev_err(dev, "failed to get regulator 'vdac'\n");
+		goto fail_fout_vpll;
+	}
+	sdev->vdet = regulator_get(dev, "vdet");
+	if (IS_ERR_OR_NULL(sdev->vdet)) {
+		dev_err(dev, "failed to get regulator 'vdet'\n");
+		goto fail_vdac;
+	}
+
+	/* configure power management */
+	pm_runtime_enable(dev);
+
+	/* configuration of interface subdevice */
+	v4l2_subdev_init(&sdev->sd, &sdo_sd_ops);
+	sdev->sd.owner = THIS_MODULE;
+	strlcpy(sdev->sd.name, sdo_driver.driver.name, sizeof sdev->sd.name);
+
+	/* set default format */
+	sdev->fmt = sdo_find_format(SDO_DEFAULT_STD);
+	BUG_ON(sdev->fmt == NULL);
+
+	/* keeping subdev in device's private for use by other drivers */
+	dev_set_drvdata(dev, &sdev->sd);
+
+	dev_info(dev, "probe succeeded\n");
+	return 0;
+
+fail_vdac:
+	regulator_put(sdev->vdac);
+fail_fout_vpll:
+	clk_put(sdev->fout_vpll);
+fail_dacphy:
+	clk_put(sdev->dacphy);
+fail_dac:
+	clk_put(sdev->dac);
+fail_sclk_dac:
+	clk_put(sdev->sclk_dac);
+fail_irq:
+	free_irq(sdev->irq, sdev);
+fail_regs:
+	iounmap(sdev->regs);
+fail_sdev:
+	kfree(sdev);
+fail:
+	dev_info(dev, "probe failed\n");
+	return ret;
+}
+
+static int __devexit sdo_remove(struct platform_device *pdev)
+{
+	struct v4l2_subdev *sd = dev_get_drvdata(&pdev->dev);
+	struct sdo_device *sdev = sd_to_sdev(sd);
+
+	pm_runtime_disable(&pdev->dev);
+	regulator_put(sdev->vdet);
+	regulator_put(sdev->vdac);
+	clk_put(sdev->fout_vpll);
+	clk_put(sdev->dacphy);
+	clk_put(sdev->dac);
+	clk_put(sdev->sclk_dac);
+	free_irq(sdev->irq, sdev);
+	iounmap(sdev->regs);
+	kfree(sdev);
+
+	dev_info(&pdev->dev, "remove successful\n");
+	return 0;
+}
+
+static int sdo_runtime_suspend(struct device *dev)
+{
+	struct v4l2_subdev *sd = dev_get_drvdata(dev);
+	struct sdo_device *sdev = sd_to_sdev(sd);
+
+	dev_info(dev, "suspend\n");
+	regulator_disable(sdev->vdet);
+	regulator_disable(sdev->vdac);
+	clk_disable(sdev->dac);
+	clk_disable(sdev->sclk_dac);
+	return 0;
+}
+
+static int sdo_runtime_resume(struct device *dev)
+{
+	struct v4l2_subdev *sd = dev_get_drvdata(dev);
+	struct sdo_device *sdev = sd_to_sdev(sd);
+
+	dev_info(dev, "resume\n");
+	clk_enable(sdev->sclk_dac);
+	clk_enable(sdev->dac);
+	regulator_enable(sdev->vdac);
+	regulator_enable(sdev->vdet);
+
+	/* software reset */
+	sdo_write_mask(sdev, SDO_CLKCON, ~0, SDO_TVOUT_SW_RESET);
+	mdelay(10);
+	sdo_write_mask(sdev, SDO_CLKCON, 0, SDO_TVOUT_SW_RESET);
+
+	/* setting TV mode */
+	sdo_write_mask(sdev, SDO_CONFIG, sdev->fmt->cookie, SDO_STANDARD_MASK);
+	/* XXX: forcing interlaced mode using undocumented bit */
+	sdo_write_mask(sdev, SDO_CONFIG, 0, SDO_PROGRESSIVE);
+	/* turn all VBI off */
+	sdo_write_mask(sdev, SDO_VBI, 0, SDO_CVBS_WSS_INS |
+		SDO_CVBS_CLOSED_CAPTION_MASK);
+	/* turn all post processing off */
+	sdo_write_mask(sdev, SDO_CCCON, ~0, SDO_COMPENSATION_BHS_ADJ_OFF |
+		SDO_COMPENSATION_CVBS_COMP_OFF);
+	sdo_reg_debug(sdev);
+	return 0;
+}
+
+static const struct dev_pm_ops sdo_pm_ops = {
+	.runtime_suspend = sdo_runtime_suspend,
+	.runtime_resume	 = sdo_runtime_resume,
+};
+
+static irqreturn_t sdo_irq_handler(int irq, void *dev_data)
+{
+	struct sdo_device *sdev = dev_data;
+
+	/* clear interrupt */
+	sdo_write_mask(sdev, SDO_IRQ, ~0, SDO_VSYNC_IRQ_PEND);
+	return IRQ_HANDLED;
+}
+
+static int sdo_s_power(struct v4l2_subdev *sd, int on);
+static int sdo_s_std_output(struct v4l2_subdev *sd, v4l2_std_id std);
+static int sdo_g_tvnorms(struct v4l2_subdev *sd, v4l2_std_id *std);
+static int sdo_g_mbus_fmt(struct v4l2_subdev *sd,
+	struct v4l2_mbus_framefmt *fmt);
+static int sdo_s_stream(struct v4l2_subdev *sd, int on);
+
+static const struct v4l2_subdev_core_ops sdo_sd_core_ops = {
+	.s_power = sdo_s_power,
+};
+
+static const struct v4l2_subdev_video_ops sdo_sd_video_ops = {
+	.s_std_output = sdo_s_std_output,
+	.querystd = NULL,
+	.g_tvnorms = sdo_g_tvnorms,
+	.g_mbus_fmt = sdo_g_mbus_fmt,
+	.s_stream = sdo_s_stream,
+};
+
+static const struct v4l2_subdev_ops sdo_sd_ops = {
+	.core = &sdo_sd_core_ops,
+	.video = &sdo_sd_video_ops,
+};
+
+static const struct sdo_format sdo_format[] = {
+	{ V4L2_STD_NTSC_M,	.height = 480, .cookie = SDO_NTSC_M },
+	{ V4L2_STD_PAL_M,	.height = 480, .cookie = SDO_PAL_M },
+	{ V4L2_STD_PAL_B,	.height = 576, .cookie = SDO_PAL_BGHID },
+	{ V4L2_STD_PAL_D,	.height = 576, .cookie = SDO_PAL_BGHID },
+	{ V4L2_STD_PAL_G,	.height = 576, .cookie = SDO_PAL_BGHID },
+	{ V4L2_STD_PAL_H,	.height = 576, .cookie = SDO_PAL_BGHID },
+	{ V4L2_STD_PAL_I,	.height = 576, .cookie = SDO_PAL_BGHID },
+	{ V4L2_STD_PAL_N,	.height = 576, .cookie = SDO_PAL_N },
+	{ V4L2_STD_PAL_Nc,	.height = 576, .cookie = SDO_PAL_NC },
+	{ V4L2_STD_NTSC_443,	.height = 480, .cookie = SDO_NTSC_443 },
+	{ V4L2_STD_PAL_60,	.height = 480, .cookie = SDO_PAL_60 },
+};
+
+static int sdo_g_tvnorms(struct v4l2_subdev *sd, v4l2_std_id *std)
+{
+	*std = V4L2_STD_NTSC_M | V4L2_STD_PAL_M | V4L2_STD_PAL_B |
+		V4L2_STD_PAL_D | V4L2_STD_PAL_G | V4L2_STD_PAL_H |
+		V4L2_STD_PAL_I | V4L2_STD_PAL_N | V4L2_STD_PAL_Nc |
+		V4L2_STD_NTSC_443 | V4L2_STD_PAL_60;
+	return 0;
+}
+
+static int sdo_s_std_output(struct v4l2_subdev *sd, v4l2_std_id std)
+{
+	struct sdo_device *sdev = sd_to_sdev(sd);
+	const struct sdo_format *fmt;
+	fmt = sdo_find_format(std);
+	if (fmt == NULL)
+		return -EINVAL;
+	sdev->fmt = fmt;
+	return 0;
+}
+
+static int sdo_g_mbus_fmt(struct v4l2_subdev *sd,
+	struct v4l2_mbus_framefmt *fmt)
+{
+	struct sdo_device *sdev = sd_to_sdev(sd);
+
+	if (!sdev->fmt)
+		return -ENXIO;
+	/* all modes are 720 pixels wide */
+	fmt->width = 720;
+	fmt->height = sdev->fmt->height;
+	fmt->code = V4L2_MBUS_FMT_FIXED;
+	fmt->field = V4L2_FIELD_INTERLACED;
+	return 0;
+}
+
+static int sdo_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct sdo_device *sdev = sd_to_sdev(sd);
+	struct device *dev = sdev->dev;
+	int ret;
+
+	dev_info(dev, "sdo_s_power(%d)\n", on);
+
+	if (on)
+		ret = pm_runtime_get_sync(dev);
+	else
+		ret = pm_runtime_put_sync(dev);
+
+	/* only values < 0 indicate errors */
+	return IS_ERR_VALUE(ret) ? ret : 0;
+}
+
+static int sdo_streamon(struct sdo_device *sdev)
+{
+	/* set proper clock for Timing Generator */
+	clk_set_rate(sdev->fout_vpll, 54000000);
+	dev_info(sdev->dev, "fout_vpll.rate = %lu\n",
+		clk_get_rate(sdev->fout_vpll));
+	/* enable clock in SDO */
+	sdo_write_mask(sdev, SDO_CLKCON, ~0, SDO_TVOUT_CLOCK_ON);
+	clk_enable(sdev->dacphy);
+	/* enable DAC */
+	sdo_write_mask(sdev, SDO_DAC, ~0, SDO_POWER_ON_DAC);
+	sdo_reg_debug(sdev);
+	return 0;
+}
+
+static int sdo_streamoff(struct sdo_device *sdev)
+{
+	int tries;
+
+	sdo_write_mask(sdev, SDO_DAC, 0, SDO_POWER_ON_DAC);
+	clk_disable(sdev->dacphy);
+	sdo_write_mask(sdev, SDO_CLKCON, 0, SDO_TVOUT_CLOCK_ON);
+	for (tries = 100; tries; --tries) {
+		if (sdo_read(sdev, SDO_CLKCON) & SDO_TVOUT_CLOCK_READY)
+			break;
+		mdelay(1);
+	}
+	if (tries == 0)
+		dev_err(sdev->dev, "failed to stop streaming\n");
+	return tries ? 0 : -EIO;
+}
+
+static int sdo_s_stream(struct v4l2_subdev *sd, int on)
+{
+	struct sdo_device *sdev = sd_to_sdev(sd);
+	if (on)
+		return sdo_streamon(sdev);
+	else
+		return sdo_streamoff(sdev);
+}
+
+static const struct sdo_format *sdo_find_format(v4l2_std_id id)
+{
+	int i;
+	for (i = 0; i < ARRAY_SIZE(sdo_format); ++i)
+		if (sdo_format[i].id & id)
+			return &sdo_format[i];
+	return NULL;
+}
+
+static void sdo_reg_debug(struct sdo_device *sdev)
+{
+#define DBGREG(reg_id) \
+	dev_info(sdev->dev, #reg_id " = %08x\n", \
+		sdo_read(sdev, reg_id))
+
+	DBGREG(SDO_CLKCON);
+	DBGREG(SDO_CONFIG);
+	DBGREG(SDO_VBI);
+	DBGREG(SDO_DAC);
+	DBGREG(SDO_IRQ);
+	DBGREG(SDO_IRQMASK);
+	DBGREG(SDO_VERSION);
+}
-- 
1.7.5.4

