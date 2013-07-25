Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59959 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755777Ab3GYM72 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jul 2013 08:59:28 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Katsuya MATSUBARA <matsu@igel.co.jp>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [PATCH v3 5/5] v4l: Renesas R-Car VSP1 driver
Date: Thu, 25 Jul 2013 15:00:13 +0200
Message-Id: <1374757213-20194-6-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1374757213-20194-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1374757213-20194-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

The VSP1 is a video processing engine that includes a blender, scalers,
filters and statistics computation. Configurable data path routing logic
allows ordering the internal blocks in a flexible way.

Due to the configurable nature of the pipeline the driver implements the
media controller API and doesn't use the V4L2 mem-to-mem framework, even
though the device usually operates in memory to memory mode.

Only the read pixel formatters, up/down scalers, write pixel formatters
and LCDC interface are supported at this stage.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

---
 drivers/media/platform/Kconfig            |   10 +
 drivers/media/platform/Makefile           |    2 +
 drivers/media/platform/vsp1/Makefile      |    5 +
 drivers/media/platform/vsp1/vsp1.h        |   73 ++
 drivers/media/platform/vsp1/vsp1_drv.c    |  488 +++++++++++++
 drivers/media/platform/vsp1/vsp1_entity.c |  181 +++++
 drivers/media/platform/vsp1/vsp1_entity.h |   68 ++
 drivers/media/platform/vsp1/vsp1_lif.c    |  238 ++++++
 drivers/media/platform/vsp1/vsp1_lif.h    |   37 +
 drivers/media/platform/vsp1/vsp1_regs.h   |  581 +++++++++++++++
 drivers/media/platform/vsp1/vsp1_rpf.c    |  209 ++++++
 drivers/media/platform/vsp1/vsp1_rwpf.c   |  124 ++++
 drivers/media/platform/vsp1/vsp1_rwpf.h   |   53 ++
 drivers/media/platform/vsp1/vsp1_uds.c    |  346 +++++++++
 drivers/media/platform/vsp1/vsp1_uds.h    |   40 +
 drivers/media/platform/vsp1/vsp1_video.c  | 1135 +++++++++++++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_video.h  |  144 ++++
 drivers/media/platform/vsp1/vsp1_wpf.c    |  233 ++++++
 include/linux/platform_data/vsp1.h        |   25 +
 19 files changed, 3992 insertions(+)
 create mode 100644 drivers/media/platform/vsp1/Makefile
 create mode 100644 drivers/media/platform/vsp1/vsp1.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_drv.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_entity.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_entity.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_lif.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_lif.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_regs.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_rpf.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_rwpf.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_rwpf.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_uds.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_uds.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_video.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_video.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_wpf.c
 create mode 100644 include/linux/platform_data/vsp1.h

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 08de865..9a44e06 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -210,6 +210,16 @@ config VIDEO_SH_VEU
 	    Support for the Video Engine Unit (VEU) on SuperH and
 	    SH-Mobile SoCs.
 
+config VIDEO_RENESAS_VSP1
+	tristate "Renesas VSP1 Video Processing Engine"
+	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
+	select VIDEOBUF2_DMA_CONTIG
+	---help---
+	  This is a V4L2 driver for the Renesas VSP1 video processing engine.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called vsp1.
+
 endif # V4L_MEM2MEM_DRIVERS
 
 menuconfig V4L_TEST_DRIVERS
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index eee28dd..4e4da48 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -46,6 +46,8 @@ obj-$(CONFIG_VIDEO_SH_VOU)		+= sh_vou.o
 
 obj-$(CONFIG_SOC_CAMERA)		+= soc_camera/
 
+obj-$(CONFIG_VIDEO_RENESAS_VSP1)	+= vsp1/
+
 obj-y	+= davinci/
 
 obj-$(CONFIG_ARCH_OMAP)	+= omap/
diff --git a/drivers/media/platform/vsp1/Makefile b/drivers/media/platform/vsp1/Makefile
new file mode 100644
index 0000000..4da2261
--- /dev/null
+++ b/drivers/media/platform/vsp1/Makefile
@@ -0,0 +1,5 @@
+vsp1-y					:= vsp1_drv.o vsp1_entity.o vsp1_video.o
+vsp1-y					+= vsp1_rpf.o vsp1_rwpf.o vsp1_wpf.o
+vsp1-y					+= vsp1_lif.o vsp1_uds.o
+
+obj-$(CONFIG_VIDEO_RENESAS_VSP1)	+= vsp1.o
diff --git a/drivers/media/platform/vsp1/vsp1.h b/drivers/media/platform/vsp1/vsp1.h
new file mode 100644
index 0000000..11ac94b
--- /dev/null
+++ b/drivers/media/platform/vsp1/vsp1.h
@@ -0,0 +1,73 @@
+/*
+ * vsp1.h  --  R-Car VSP1 Driver
+ *
+ * Copyright (C) 2013 Renesas Corporation
+ *
+ * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#ifndef __VSP1_H__
+#define __VSP1_H__
+
+#include <linux/io.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/platform_data/vsp1.h>
+
+#include <media/media-device.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-subdev.h>
+
+#include "vsp1_regs.h"
+
+struct clk;
+struct device;
+
+struct vsp1_platform_data;
+struct vsp1_lif;
+struct vsp1_rwpf;
+struct vsp1_uds;
+
+#define VPS1_MAX_RPF		5
+#define VPS1_MAX_UDS		3
+#define VPS1_MAX_WPF		4
+
+struct vsp1_device {
+	struct device *dev;
+	struct vsp1_platform_data *pdata;
+
+	void __iomem *mmio;
+	struct clk *clock;
+
+	struct mutex lock;
+	int ref_count;
+
+	struct vsp1_lif *lif;
+	struct vsp1_rwpf *rpf[VPS1_MAX_RPF];
+	struct vsp1_uds *uds[VPS1_MAX_UDS];
+	struct vsp1_rwpf *wpf[VPS1_MAX_WPF];
+
+	struct list_head entities;
+
+	struct v4l2_device v4l2_dev;
+	struct media_device media_dev;
+};
+
+struct vsp1_device *vsp1_device_get(struct vsp1_device *vsp1);
+void vsp1_device_put(struct vsp1_device *vsp1);
+
+static inline u32 vsp1_read(struct vsp1_device *vsp1, u32 reg)
+{
+	return ioread32(vsp1->mmio + reg);
+}
+
+static inline void vsp1_write(struct vsp1_device *vsp1, u32 reg, u32 data)
+{
+	iowrite32(data, vsp1->mmio + reg);
+}
+
+#endif /* __VSP1_H__ */
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
new file mode 100644
index 0000000..756929e
--- /dev/null
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -0,0 +1,488 @@
+/*
+ * vsp1_drv.c  --  R-Car VSP1 Driver
+ *
+ * Copyright (C) 2013 Renesas Corporation
+ *
+ * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/videodev2.h>
+
+#include "vsp1.h"
+#include "vsp1_lif.h"
+#include "vsp1_rwpf.h"
+#include "vsp1_uds.h"
+
+/* -----------------------------------------------------------------------------
+ * Interrupt Handling
+ */
+
+static irqreturn_t vsp1_irq_handler(int irq, void *data)
+{
+	u32 mask = VI6_WFP_IRQ_STA_DFE | VI6_WFP_IRQ_STA_FRE;
+	struct vsp1_device *vsp1 = data;
+	irqreturn_t ret = IRQ_NONE;
+	unsigned int i;
+
+	for (i = 0; i < VPS1_MAX_WPF; ++i) {
+		struct vsp1_rwpf *wpf = vsp1->wpf[i];
+		struct vsp1_pipeline *pipe;
+		u32 status;
+
+		if (wpf == NULL)
+			continue;
+
+		pipe = to_vsp1_pipeline(&wpf->entity.subdev.entity);
+		status = vsp1_read(vsp1, VI6_WPF_IRQ_STA(i));
+		vsp1_write(vsp1, VI6_WPF_IRQ_STA(i), ~status & mask);
+
+		if (status & VI6_WFP_IRQ_STA_FRE) {
+			vsp1_pipeline_frame_end(pipe);
+			ret = IRQ_HANDLED;
+		}
+	}
+
+	return ret;
+}
+
+/* -----------------------------------------------------------------------------
+ * Entities
+ */
+
+/*
+ * vsp1_create_links - Create links from all sources to the given sink
+ *
+ * This function creates media links from all valid sources to the given sink
+ * pad. Links that would be invalid according to the VSP1 hardware capabilities
+ * are skipped. Those include all links
+ *
+ * - from a UDS to a UDS (UDS entities can't be chained)
+ * - from an entity to itself (no loops are allowed)
+ */
+static int vsp1_create_links(struct vsp1_device *vsp1, struct vsp1_entity *sink)
+{
+	struct media_entity *entity = &sink->subdev.entity;
+	struct vsp1_entity *source;
+	unsigned int pad;
+	int ret;
+
+	list_for_each_entry(source, &vsp1->entities, list_dev) {
+		u32 flags;
+
+		if (source->type == sink->type)
+			continue;
+
+		if (source->type == VSP1_ENTITY_LIF ||
+		    source->type == VSP1_ENTITY_WPF)
+			continue;
+
+		flags = source->type == VSP1_ENTITY_RPF &&
+			sink->type == VSP1_ENTITY_WPF &&
+			source->index == sink->index
+		      ? MEDIA_LNK_FL_ENABLED : 0;
+
+		for (pad = 0; pad < entity->num_pads; ++pad) {
+			if (!(entity->pads[pad].flags & MEDIA_PAD_FL_SINK))
+				continue;
+
+			ret = media_entity_create_link(&source->subdev.entity,
+						       source->source_pad,
+						       entity, pad, flags);
+			if (ret < 0)
+				return ret;
+		}
+	}
+
+	return 0;
+}
+
+static void vsp1_destroy_entities(struct vsp1_device *vsp1)
+{
+	struct vsp1_entity *entity;
+	struct vsp1_entity *next;
+
+	list_for_each_entry_safe(entity, next, &vsp1->entities, list_dev) {
+		list_del(&entity->list_dev);
+		vsp1_entity_destroy(entity);
+	}
+
+	v4l2_device_unregister(&vsp1->v4l2_dev);
+	media_device_unregister(&vsp1->media_dev);
+}
+
+static int vsp1_create_entities(struct vsp1_device *vsp1)
+{
+	struct media_device *mdev = &vsp1->media_dev;
+	struct v4l2_device *vdev = &vsp1->v4l2_dev;
+	struct vsp1_entity *entity;
+	unsigned int i;
+	int ret;
+
+	mdev->dev = vsp1->dev;
+	strlcpy(mdev->model, "VSP1", sizeof(mdev->model));
+	ret = media_device_register(mdev);
+	if (ret < 0) {
+		dev_err(vsp1->dev, "media device registration failed (%d)\n",
+			ret);
+		return ret;
+	}
+
+	vdev->mdev = mdev;
+	ret = v4l2_device_register(vsp1->dev, vdev);
+	if (ret < 0) {
+		dev_err(vsp1->dev, "V4L2 device registration failed (%d)\n",
+			ret);
+		goto done;
+	}
+
+	/* Instantiate all the entities. */
+	if (vsp1->pdata->features & VSP1_HAS_LIF) {
+		vsp1->lif = vsp1_lif_create(vsp1);
+		if (IS_ERR(vsp1->lif)) {
+			ret = PTR_ERR(vsp1->lif);
+			goto done;
+		}
+
+		list_add_tail(&vsp1->lif->entity.list_dev, &vsp1->entities);
+	}
+
+	for (i = 0; i < vsp1->pdata->rpf_count; ++i) {
+		struct vsp1_rwpf *rpf;
+
+		rpf = vsp1_rpf_create(vsp1, i);
+		if (IS_ERR(rpf)) {
+			ret = PTR_ERR(rpf);
+			goto done;
+		}
+
+		vsp1->rpf[i] = rpf;
+		list_add_tail(&rpf->entity.list_dev, &vsp1->entities);
+	}
+
+	for (i = 0; i < vsp1->pdata->uds_count; ++i) {
+		struct vsp1_uds *uds;
+
+		uds = vsp1_uds_create(vsp1, i);
+		if (IS_ERR(uds)) {
+			ret = PTR_ERR(uds);
+			goto done;
+		}
+
+		vsp1->uds[i] = uds;
+		list_add_tail(&uds->entity.list_dev, &vsp1->entities);
+	}
+
+	for (i = 0; i < vsp1->pdata->wpf_count; ++i) {
+		struct vsp1_rwpf *wpf;
+
+		wpf = vsp1_wpf_create(vsp1, i);
+		if (IS_ERR(wpf)) {
+			ret = PTR_ERR(wpf);
+			goto done;
+		}
+
+		vsp1->wpf[i] = wpf;
+		list_add_tail(&wpf->entity.list_dev, &vsp1->entities);
+	}
+
+	/* Create links. */
+	list_for_each_entry(entity, &vsp1->entities, list_dev) {
+		if (entity->type == VSP1_ENTITY_LIF ||
+		    entity->type == VSP1_ENTITY_RPF)
+			continue;
+
+		ret = vsp1_create_links(vsp1, entity);
+		if (ret < 0)
+			goto done;
+	}
+
+	if (vsp1->pdata->features & VSP1_HAS_LIF) {
+		ret = media_entity_create_link(
+			&vsp1->wpf[0]->entity.subdev.entity, RWPF_PAD_SOURCE,
+			&vsp1->lif->entity.subdev.entity, LIF_PAD_SINK, 0);
+		if (ret < 0)
+			return ret;
+	}
+
+	/* Register all subdevs. */
+	list_for_each_entry(entity, &vsp1->entities, list_dev) {
+		ret = v4l2_device_register_subdev(&vsp1->v4l2_dev,
+						  &entity->subdev);
+		if (ret < 0)
+			goto done;
+	}
+
+	ret = v4l2_device_register_subdev_nodes(&vsp1->v4l2_dev);
+
+done:
+	if (ret < 0)
+		vsp1_destroy_entities(vsp1);
+
+	return ret;
+}
+
+static void vsp1_device_init(struct vsp1_device *vsp1)
+{
+	unsigned int i;
+	u32 status;
+
+	/* Reset any channel that might be running. */
+	status = vsp1_read(vsp1, VI6_STATUS);
+
+	for (i = 0; i < VPS1_MAX_WPF; ++i) {
+		unsigned int timeout;
+
+		if (!(status & VI6_STATUS_SYS_ACT(i)))
+			continue;
+
+		vsp1_write(vsp1, VI6_SRESET, VI6_SRESET_SRTS(i));
+		for (timeout = 10; timeout > 0; --timeout) {
+			status = vsp1_read(vsp1, VI6_STATUS);
+			if (!(status & VI6_STATUS_SYS_ACT(i)))
+				break;
+
+			usleep_range(1000, 2000);
+		}
+
+		if (timeout)
+			dev_err(vsp1->dev, "failed to reset wpf.%u\n", i);
+	}
+
+	vsp1_write(vsp1, VI6_CLK_DCSWT, (8 << VI6_CLK_DCSWT_CSTPW_SHIFT) |
+		   (8 << VI6_CLK_DCSWT_CSTRW_SHIFT));
+
+	for (i = 0; i < VPS1_MAX_RPF; ++i)
+		vsp1_write(vsp1, VI6_DPR_RPF_ROUTE(i), VI6_DPR_NODE_UNUSED);
+
+	for (i = 0; i < VPS1_MAX_UDS; ++i)
+		vsp1_write(vsp1, VI6_DPR_UDS_ROUTE(i), VI6_DPR_NODE_UNUSED);
+
+	vsp1_write(vsp1, VI6_DPR_SRU_ROUTE, VI6_DPR_NODE_UNUSED);
+	vsp1_write(vsp1, VI6_DPR_LUT_ROUTE, VI6_DPR_NODE_UNUSED);
+	vsp1_write(vsp1, VI6_DPR_CLU_ROUTE, VI6_DPR_NODE_UNUSED);
+	vsp1_write(vsp1, VI6_DPR_HST_ROUTE, VI6_DPR_NODE_UNUSED);
+	vsp1_write(vsp1, VI6_DPR_HSI_ROUTE, VI6_DPR_NODE_UNUSED);
+	vsp1_write(vsp1, VI6_DPR_BRU_ROUTE, VI6_DPR_NODE_UNUSED);
+
+	vsp1_write(vsp1, VI6_DPR_HGO_SMPPT, (7 << VI6_DPR_SMPPT_TGW_SHIFT) |
+		   (VI6_DPR_NODE_UNUSED << VI6_DPR_SMPPT_PT_SHIFT));
+	vsp1_write(vsp1, VI6_DPR_HGT_SMPPT, (7 << VI6_DPR_SMPPT_TGW_SHIFT) |
+		   (VI6_DPR_NODE_UNUSED << VI6_DPR_SMPPT_PT_SHIFT));
+}
+
+/*
+ * vsp1_device_get - Acquire the VSP1 device
+ *
+ * Increment the VSP1 reference count and initialize the device if the first
+ * reference is taken.
+ *
+ * Return a pointer to the VSP1 device or NULL if an error occured.
+ */
+struct vsp1_device *vsp1_device_get(struct vsp1_device *vsp1)
+{
+	struct vsp1_device *__vsp1 = vsp1;
+	int ret;
+
+	mutex_lock(&vsp1->lock);
+	if (vsp1->ref_count > 0)
+		goto done;
+
+	ret = clk_prepare_enable(vsp1->clock);
+	if (ret < 0) {
+		__vsp1 = NULL;
+		goto done;
+	}
+
+	vsp1_device_init(vsp1);
+
+done:
+	if (__vsp1)
+		vsp1->ref_count++;
+
+	mutex_unlock(&vsp1->lock);
+	return __vsp1;
+}
+
+/*
+ * vsp1_device_put - Release the VSP1 device
+ *
+ * Decrement the VSP1 reference count and cleanup the device if the last
+ * reference is released.
+ */
+void vsp1_device_put(struct vsp1_device *vsp1)
+{
+	mutex_lock(&vsp1->lock);
+
+	if (--vsp1->ref_count == 0)
+		clk_disable_unprepare(vsp1->clock);
+
+	mutex_unlock(&vsp1->lock);
+}
+
+/* -----------------------------------------------------------------------------
+ * Power Management
+ */
+
+#ifdef CONFIG_PM_SLEEP
+static int vsp1_pm_suspend(struct device *dev)
+{
+	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
+
+	WARN_ON(mutex_is_locked(&vsp1->lock));
+
+	if (vsp1->ref_count == 0)
+		return 0;
+
+	clk_disable_unprepare(vsp1->clock);
+	return 0;
+}
+
+static int vsp1_pm_resume(struct device *dev)
+{
+	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
+
+	WARN_ON(mutex_is_locked(&vsp1->lock));
+
+	if (vsp1->ref_count)
+		return 0;
+
+	return clk_prepare_enable(vsp1->clock);
+}
+#endif
+
+static const struct dev_pm_ops vsp1_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(vsp1_pm_suspend, vsp1_pm_resume)
+};
+
+/* -----------------------------------------------------------------------------
+ * Platform Driver
+ */
+
+static struct vsp1_platform_data *
+vsp1_get_platform_data(struct platform_device *pdev)
+{
+	struct vsp1_platform_data *pdata = pdev->dev.platform_data;
+
+	if (pdata == NULL) {
+		dev_err(&pdev->dev, "missing platform data\n");
+		return NULL;
+	}
+
+	if (pdata->rpf_count <= 0 || pdata->rpf_count > VPS1_MAX_RPF) {
+		dev_err(&pdev->dev, "invalid number of RPF (%u)\n",
+			pdata->rpf_count);
+		return NULL;
+	}
+
+	if (pdata->uds_count <= 0 || pdata->uds_count > VPS1_MAX_UDS) {
+		dev_err(&pdev->dev, "invalid number of UDS (%u)\n",
+			pdata->uds_count);
+		return NULL;
+	}
+
+	if (pdata->wpf_count <= 0 || pdata->wpf_count > VPS1_MAX_WPF) {
+		dev_err(&pdev->dev, "invalid number of WPF (%u)\n",
+			pdata->wpf_count);
+		return NULL;
+	}
+
+	return pdata;
+}
+
+static int vsp1_probe(struct platform_device *pdev)
+{
+	struct vsp1_device *vsp1;
+	struct resource *irq;
+	struct resource *io;
+	int ret;
+
+	vsp1 = devm_kzalloc(&pdev->dev, sizeof(*vsp1), GFP_KERNEL);
+	if (vsp1 == NULL) {
+		dev_err(&pdev->dev, "failed to allocate private data\n");
+		return -ENOMEM;
+	}
+
+	vsp1->dev = &pdev->dev;
+	mutex_init(&vsp1->lock);
+	INIT_LIST_HEAD(&vsp1->entities);
+
+	vsp1->pdata = vsp1_get_platform_data(pdev);
+	if (vsp1->pdata == NULL)
+		return -ENODEV;
+
+	/* I/O, IRQ and clock resources */
+	io = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+
+	if (!io || !irq) {
+		dev_err(&pdev->dev, "missing IRQ or IOMEM\n");
+		return -EINVAL;
+	}
+
+	vsp1->mmio = devm_ioremap_resource(&pdev->dev, io);
+	if (IS_ERR((void *)vsp1->mmio)) {
+		dev_err(&pdev->dev, "failed to remap memory resource\n");
+		return PTR_ERR((void *)vsp1->mmio);
+	}
+
+	vsp1->clock = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(vsp1->clock)) {
+		dev_err(&pdev->dev, "failed to get clock\n");
+		return PTR_ERR(vsp1->clock);
+	}
+
+	ret = devm_request_irq(&pdev->dev, irq->start, vsp1_irq_handler,
+			      IRQF_SHARED, dev_name(&pdev->dev), vsp1);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to request IRQ\n");
+		return ret;
+	}
+
+	/* Instanciate entities */
+	ret = vsp1_create_entities(vsp1);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to create entities\n");
+		return ret;
+	}
+
+	platform_set_drvdata(pdev, vsp1);
+
+	return 0;
+}
+
+static int vsp1_remove(struct platform_device *pdev)
+{
+	struct vsp1_device *vsp1 = platform_get_drvdata(pdev);
+
+	vsp1_destroy_entities(vsp1);
+
+	return 0;
+}
+
+static struct platform_driver vsp1_platform_driver = {
+	.probe		= vsp1_probe,
+	.remove		= vsp1_remove,
+	.driver		= {
+		.owner	= THIS_MODULE,
+		.name	= "vsp1",
+		.pm	= &vsp1_pm_ops,
+	},
+};
+
+module_platform_driver(vsp1_platform_driver);
+
+MODULE_ALIAS("vsp1");
+MODULE_AUTHOR("Laurent Pinchart <laurent.pinchart@ideasonboard.com>");
+MODULE_DESCRIPTION("Renesas VSP1 Driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
new file mode 100644
index 0000000..9028f9d
--- /dev/null
+++ b/drivers/media/platform/vsp1/vsp1_entity.c
@@ -0,0 +1,181 @@
+/*
+ * vsp1_entity.c  --  R-Car VSP1 Base Entity
+ *
+ * Copyright (C) 2013 Renesas Corporation
+ *
+ * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/device.h>
+#include <linux/gfp.h>
+
+#include <media/media-entity.h>
+#include <media/v4l2-subdev.h>
+
+#include "vsp1.h"
+#include "vsp1_entity.h"
+
+/* -----------------------------------------------------------------------------
+ * V4L2 Subdevice Operations
+ */
+
+struct v4l2_mbus_framefmt *
+vsp1_entity_get_pad_format(struct vsp1_entity *entity,
+			   struct v4l2_subdev_fh *fh,
+			   unsigned int pad, u32 which)
+{
+	switch (which) {
+	case V4L2_SUBDEV_FORMAT_TRY:
+		return v4l2_subdev_get_try_format(fh, pad);
+	case V4L2_SUBDEV_FORMAT_ACTIVE:
+		return &entity->formats[pad];
+	default:
+		return NULL;
+	}
+}
+
+/*
+ * vsp1_entity_init_formats - Initialize formats on all pads
+ * @subdev: V4L2 subdevice
+ * @fh: V4L2 subdev file handle
+ *
+ * Initialize all pad formats with default values. If fh is not NULL, try
+ * formats are initialized on the file handle. Otherwise active formats are
+ * initialized on the device.
+ */
+void vsp1_entity_init_formats(struct v4l2_subdev *subdev,
+			    struct v4l2_subdev_fh *fh)
+{
+	struct v4l2_subdev_format format;
+	unsigned int pad;
+
+	for (pad = 0; pad < subdev->entity.num_pads - 1; ++pad) {
+		memset(&format, 0, sizeof(format));
+
+		format.pad = pad;
+		format.which = fh ? V4L2_SUBDEV_FORMAT_TRY
+			     : V4L2_SUBDEV_FORMAT_ACTIVE;
+
+		v4l2_subdev_call(subdev, pad, set_fmt, fh, &format);
+	}
+}
+
+static int vsp1_entity_open(struct v4l2_subdev *subdev,
+			    struct v4l2_subdev_fh *fh)
+{
+	vsp1_entity_init_formats(subdev, fh);
+
+	return 0;
+}
+
+const struct v4l2_subdev_internal_ops vsp1_subdev_internal_ops = {
+	.open = vsp1_entity_open,
+};
+
+/* -----------------------------------------------------------------------------
+ * Media Operations
+ */
+
+static int vsp1_entity_link_setup(struct media_entity *entity,
+				  const struct media_pad *local,
+				  const struct media_pad *remote, u32 flags)
+{
+	struct vsp1_entity *source;
+
+	if (!(local->flags & MEDIA_PAD_FL_SOURCE))
+		return 0;
+
+	source = container_of(local->entity, struct vsp1_entity, subdev.entity);
+
+	if (!source->route)
+		return 0;
+
+	if (flags & MEDIA_LNK_FL_ENABLED) {
+		if (source->sink)
+			return -EBUSY;
+		source->sink = remote->entity;
+	} else {
+		source->sink = NULL;
+	}
+
+	return 0;
+}
+
+const struct media_entity_operations vsp1_media_ops = {
+	.link_setup = vsp1_entity_link_setup,
+	.link_validate = v4l2_subdev_link_validate,
+};
+
+/* -----------------------------------------------------------------------------
+ * Initialization
+ */
+
+int vsp1_entity_init(struct vsp1_device *vsp1, struct vsp1_entity *entity,
+		     unsigned int num_pads)
+{
+	static const struct {
+		unsigned int id;
+		unsigned int reg;
+	} routes[] = {
+		{ VI6_DPR_NODE_LIF, 0 },
+		{ VI6_DPR_NODE_RPF(0), VI6_DPR_RPF_ROUTE(0) },
+		{ VI6_DPR_NODE_RPF(1), VI6_DPR_RPF_ROUTE(1) },
+		{ VI6_DPR_NODE_RPF(2), VI6_DPR_RPF_ROUTE(2) },
+		{ VI6_DPR_NODE_RPF(3), VI6_DPR_RPF_ROUTE(3) },
+		{ VI6_DPR_NODE_RPF(4), VI6_DPR_RPF_ROUTE(4) },
+		{ VI6_DPR_NODE_UDS(0), VI6_DPR_UDS_ROUTE(0) },
+		{ VI6_DPR_NODE_UDS(1), VI6_DPR_UDS_ROUTE(1) },
+		{ VI6_DPR_NODE_UDS(2), VI6_DPR_UDS_ROUTE(2) },
+		{ VI6_DPR_NODE_WPF(0), 0 },
+		{ VI6_DPR_NODE_WPF(1), 0 },
+		{ VI6_DPR_NODE_WPF(2), 0 },
+		{ VI6_DPR_NODE_WPF(3), 0 },
+	};
+
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(routes); ++i) {
+		if (routes[i].id == entity->id) {
+			entity->route = routes[i].reg;
+			break;
+		}
+	}
+
+	if (i == ARRAY_SIZE(routes))
+		return -EINVAL;
+
+	entity->vsp1 = vsp1;
+	entity->source_pad = num_pads - 1;
+
+	/* Allocate formats and pads. */
+	entity->formats = devm_kzalloc(vsp1->dev,
+				       num_pads * sizeof(*entity->formats),
+				       GFP_KERNEL);
+	if (entity->formats == NULL)
+		return -ENOMEM;
+
+	entity->pads = devm_kzalloc(vsp1->dev, num_pads * sizeof(*entity->pads),
+				    GFP_KERNEL);
+	if (entity->pads == NULL)
+		return -ENOMEM;
+
+	/* Initialize pads. */
+	for (i = 0; i < num_pads - 1; ++i)
+		entity->pads[i].flags = MEDIA_PAD_FL_SINK;
+
+	entity->pads[num_pads - 1].flags = MEDIA_PAD_FL_SOURCE;
+
+	/* Initialize the media entity. */
+	return media_entity_init(&entity->subdev.entity, num_pads,
+				 entity->pads, 0);
+}
+
+void vsp1_entity_destroy(struct vsp1_entity *entity)
+{
+	media_entity_cleanup(&entity->subdev.entity);
+}
diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
new file mode 100644
index 0000000..c4feab2c
--- /dev/null
+++ b/drivers/media/platform/vsp1/vsp1_entity.h
@@ -0,0 +1,68 @@
+/*
+ * vsp1_entity.h  --  R-Car VSP1 Base Entity
+ *
+ * Copyright (C) 2013 Renesas Corporation
+ *
+ * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#ifndef __VSP1_ENTITY_H__
+#define __VSP1_ENTITY_H__
+
+#include <linux/list.h>
+
+#include <media/v4l2-subdev.h>
+
+struct vsp1_device;
+
+enum vsp1_entity_type {
+	VSP1_ENTITY_LIF,
+	VSP1_ENTITY_RPF,
+	VSP1_ENTITY_UDS,
+	VSP1_ENTITY_WPF,
+};
+
+struct vsp1_entity {
+	struct vsp1_device *vsp1;
+
+	enum vsp1_entity_type type;
+	unsigned int index;
+	unsigned int id;
+	unsigned int route;
+
+	struct list_head list_dev;
+	struct list_head list_pipe;
+
+	struct media_pad *pads;
+	unsigned int source_pad;
+
+	struct media_entity *sink;
+
+	struct v4l2_subdev subdev;
+	struct v4l2_mbus_framefmt *formats;
+};
+
+static inline struct vsp1_entity *to_vsp1_entity(struct v4l2_subdev *subdev)
+{
+	return container_of(subdev, struct vsp1_entity, subdev);
+}
+
+int vsp1_entity_init(struct vsp1_device *vsp1, struct vsp1_entity *entity,
+		     unsigned int num_pads);
+void vsp1_entity_destroy(struct vsp1_entity *entity);
+
+extern const struct v4l2_subdev_internal_ops vsp1_subdev_internal_ops;
+extern const struct media_entity_operations vsp1_media_ops;
+
+struct v4l2_mbus_framefmt *
+vsp1_entity_get_pad_format(struct vsp1_entity *entity,
+			   struct v4l2_subdev_fh *fh,
+			   unsigned int pad, u32 which);
+void vsp1_entity_init_formats(struct v4l2_subdev *subdev,
+			      struct v4l2_subdev_fh *fh);
+
+#endif /* __VSP1_ENTITY_H__ */
diff --git a/drivers/media/platform/vsp1/vsp1_lif.c b/drivers/media/platform/vsp1/vsp1_lif.c
new file mode 100644
index 0000000..74a32e6
--- /dev/null
+++ b/drivers/media/platform/vsp1/vsp1_lif.c
@@ -0,0 +1,238 @@
+/*
+ * vsp1_lif.c  --  R-Car VSP1 LCD Controller Interface
+ *
+ * Copyright (C) 2013 Renesas Corporation
+ *
+ * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/device.h>
+#include <linux/gfp.h>
+
+#include <media/v4l2-subdev.h>
+
+#include "vsp1.h"
+#include "vsp1_lif.h"
+
+#define LIF_MIN_SIZE				2U
+#define LIF_MAX_SIZE				2048U
+
+/* -----------------------------------------------------------------------------
+ * Device Access
+ */
+
+static inline u32 vsp1_lif_read(struct vsp1_lif *lif, u32 reg)
+{
+	return vsp1_read(lif->entity.vsp1, reg);
+}
+
+static inline void vsp1_lif_write(struct vsp1_lif *lif, u32 reg, u32 data)
+{
+	vsp1_write(lif->entity.vsp1, reg, data);
+}
+
+/* -----------------------------------------------------------------------------
+ * V4L2 Subdevice Core Operations
+ */
+
+static int lif_s_stream(struct v4l2_subdev *subdev, int enable)
+{
+	const struct v4l2_mbus_framefmt *format;
+	struct vsp1_lif *lif = to_lif(subdev);
+	unsigned int hbth = 1300;
+	unsigned int obth = 400;
+	unsigned int lbth = 200;
+
+	if (!enable) {
+		vsp1_lif_write(lif, VI6_LIF_CTRL, 0);
+		return 0;
+	}
+
+	format = &lif->entity.formats[LIF_PAD_SOURCE];
+
+	obth = min(obth, (format->width + 1) / 2 * format->height - 4);
+
+	vsp1_lif_write(lif, VI6_LIF_CSBTH,
+			(hbth << VI6_LIF_CSBTH_HBTH_SHIFT) |
+			(lbth << VI6_LIF_CSBTH_LBTH_SHIFT));
+
+	vsp1_lif_write(lif, VI6_LIF_CTRL,
+			(obth << VI6_LIF_CTRL_OBTH_SHIFT) |
+			(format->code == 0 ? VI6_LIF_CTRL_CFMT : 0) |
+			VI6_LIF_CTRL_REQSEL | VI6_LIF_CTRL_LIF_EN);
+
+	return 0;
+}
+
+/* -----------------------------------------------------------------------------
+ * V4L2 Subdevice Pad Operations
+ */
+
+static int lif_enum_mbus_code(struct v4l2_subdev *subdev,
+			      struct v4l2_subdev_fh *fh,
+			      struct v4l2_subdev_mbus_code_enum *code)
+{
+	static const unsigned int codes[] = {
+		V4L2_MBUS_FMT_ARGB8888_1X32,
+		V4L2_MBUS_FMT_AYUV8_1X32,
+	};
+
+	if (code->pad == LIF_PAD_SINK) {
+		if (code->index >= ARRAY_SIZE(codes))
+			return -EINVAL;
+
+		code->code = codes[code->index];
+	} else {
+		struct v4l2_mbus_framefmt *format;
+
+		/* The LIF can't perform format conversion, the sink format is
+		 * always identical to the source format.
+		 */
+		if (code->index)
+			return -EINVAL;
+
+		format = v4l2_subdev_get_try_format(fh, LIF_PAD_SINK);
+		code->code = format->code;
+	}
+
+	return 0;
+}
+
+static int lif_enum_frame_size(struct v4l2_subdev *subdev,
+			       struct v4l2_subdev_fh *fh,
+			       struct v4l2_subdev_frame_size_enum *fse)
+{
+	struct v4l2_mbus_framefmt *format;
+
+	format = v4l2_subdev_get_try_format(fh, LIF_PAD_SINK);
+
+	if (fse->index || fse->code != format->code)
+		return -EINVAL;
+
+	if (fse->pad == LIF_PAD_SINK) {
+		fse->min_width = LIF_MIN_SIZE;
+		fse->max_width = LIF_MAX_SIZE;
+		fse->min_height = LIF_MIN_SIZE;
+		fse->max_height = LIF_MAX_SIZE;
+	} else {
+		fse->min_width = format->width;
+		fse->max_width = format->width;
+		fse->min_height = format->height;
+		fse->max_height = format->height;
+	}
+
+	return 0;
+}
+
+static int lif_get_format(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh,
+			  struct v4l2_subdev_format *fmt)
+{
+	struct vsp1_lif *lif = to_lif(subdev);
+
+	fmt->format = *vsp1_entity_get_pad_format(&lif->entity, fh, fmt->pad,
+						  fmt->which);
+
+	return 0;
+}
+
+static int lif_set_format(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh,
+			  struct v4l2_subdev_format *fmt)
+{
+	struct vsp1_lif *lif = to_lif(subdev);
+	struct v4l2_mbus_framefmt *format;
+
+	/* Default to YUV if the requested format is not supported. */
+	if (fmt->format.code != V4L2_MBUS_FMT_ARGB8888_1X32 &&
+	    fmt->format.code != V4L2_MBUS_FMT_AYUV8_1X32)
+		fmt->format.code = V4L2_MBUS_FMT_AYUV8_1X32;
+
+	format = vsp1_entity_get_pad_format(&lif->entity, fh, fmt->pad,
+					    fmt->which);
+
+	if (fmt->pad == LIF_PAD_SOURCE) {
+		/* The LIF source format is always identical to its sink
+		 * format.
+		 */
+		fmt->format = *format;
+		return 0;
+	}
+
+	format->code = fmt->format.code;
+	format->width = clamp_t(unsigned int, fmt->format.width,
+				LIF_MIN_SIZE, LIF_MAX_SIZE);
+	format->height = clamp_t(unsigned int, fmt->format.height,
+				 LIF_MIN_SIZE, LIF_MAX_SIZE);
+	format->field = V4L2_FIELD_NONE;
+	format->colorspace = V4L2_COLORSPACE_SRGB;
+
+	fmt->format = *format;
+
+	/* Propagate the format to the source pad. */
+	format = vsp1_entity_get_pad_format(&lif->entity, fh, LIF_PAD_SOURCE,
+					    fmt->which);
+	*format = fmt->format;
+
+	return 0;
+}
+
+/* -----------------------------------------------------------------------------
+ * V4L2 Subdevice Operations
+ */
+
+static struct v4l2_subdev_video_ops lif_video_ops = {
+	.s_stream = lif_s_stream,
+};
+
+static struct v4l2_subdev_pad_ops lif_pad_ops = {
+	.enum_mbus_code = lif_enum_mbus_code,
+	.enum_frame_size = lif_enum_frame_size,
+	.get_fmt = lif_get_format,
+	.set_fmt = lif_set_format,
+};
+
+static struct v4l2_subdev_ops lif_ops = {
+	.video	= &lif_video_ops,
+	.pad    = &lif_pad_ops,
+};
+
+/* -----------------------------------------------------------------------------
+ * Initialization and Cleanup
+ */
+
+struct vsp1_lif *vsp1_lif_create(struct vsp1_device *vsp1)
+{
+	struct v4l2_subdev *subdev;
+	struct vsp1_lif *lif;
+	int ret;
+
+	lif = devm_kzalloc(vsp1->dev, sizeof(*lif), GFP_KERNEL);
+	if (lif == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	lif->entity.type = VSP1_ENTITY_LIF;
+	lif->entity.id = VI6_DPR_NODE_LIF;
+
+	ret = vsp1_entity_init(vsp1, &lif->entity, 2);
+	if (ret < 0)
+		return ERR_PTR(ret);
+
+	/* Initialize the V4L2 subdev. */
+	subdev = &lif->entity.subdev;
+	v4l2_subdev_init(subdev, &lif_ops);
+
+	subdev->entity.ops = &vsp1_media_ops;
+	subdev->internal_ops = &vsp1_subdev_internal_ops;
+	snprintf(subdev->name, sizeof(subdev->name), "%s lif",
+		 dev_name(vsp1->dev));
+	v4l2_set_subdevdata(subdev, lif);
+	subdev->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+
+	vsp1_entity_init_formats(subdev, NULL);
+
+	return lif;
+}
diff --git a/drivers/media/platform/vsp1/vsp1_lif.h b/drivers/media/platform/vsp1/vsp1_lif.h
new file mode 100644
index 0000000..89b93af
--- /dev/null
+++ b/drivers/media/platform/vsp1/vsp1_lif.h
@@ -0,0 +1,37 @@
+/*
+ * vsp1_lif.h  --  R-Car VSP1 LCD Controller Interface
+ *
+ * Copyright (C) 2013 Renesas Corporation
+ *
+ * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#ifndef __VSP1_LIF_H__
+#define __VSP1_LIF_H__
+
+#include <media/media-entity.h>
+#include <media/v4l2-subdev.h>
+
+#include "vsp1_entity.h"
+
+struct vsp1_device;
+
+#define LIF_PAD_SINK				0
+#define LIF_PAD_SOURCE				1
+
+struct vsp1_lif {
+	struct vsp1_entity entity;
+};
+
+static inline struct vsp1_lif *to_lif(struct v4l2_subdev *subdev)
+{
+	return container_of(subdev, struct vsp1_lif, entity.subdev);
+}
+
+struct vsp1_lif *vsp1_lif_create(struct vsp1_device *vsp1);
+
+#endif /* __VSP1_LIF_H__ */
diff --git a/drivers/media/platform/vsp1/vsp1_regs.h b/drivers/media/platform/vsp1/vsp1_regs.h
new file mode 100644
index 0000000..1d3304f
--- /dev/null
+++ b/drivers/media/platform/vsp1/vsp1_regs.h
@@ -0,0 +1,581 @@
+/*
+ * vsp1_regs.h  --  R-Car VSP1 Registers Definitions
+ *
+ * Copyright (C) 2013 Renesas Electronics Corporation
+ *
+ * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation.
+ */
+
+#ifndef __VSP1_REGS_H__
+#define __VSP1_REGS_H__
+
+/* -----------------------------------------------------------------------------
+ * General Control Registers
+ */
+
+#define VI6_CMD(n)			(0x0000 + (n) * 4)
+#define VI6_CMD_STRCMD			(1 << 0)
+
+#define VI6_CLK_DCSWT			0x0018
+#define VI6_CLK_DCSWT_CSTPW_MASK	(0xff << 8)
+#define VI6_CLK_DCSWT_CSTPW_SHIFT	8
+#define VI6_CLK_DCSWT_CSTRW_MASK	(0xff << 0)
+#define VI6_CLK_DCSWT_CSTRW_SHIFT	0
+
+#define VI6_SRESET			0x0028
+#define VI6_SRESET_SRTS(n)		(1 << (n))
+
+#define VI6_STATUS			0x0038
+#define VI6_STATUS_SYS_ACT(n)		(1 << ((n) + 8))
+
+#define VI6_WPF_IRQ_ENB(n)		(0x0048 + (n) * 12)
+#define VI6_WFP_IRQ_ENB_DFEE		(1 << 1)
+#define VI6_WFP_IRQ_ENB_FREE		(1 << 0)
+
+#define VI6_WPF_IRQ_STA(n)		(0x004c + (n) * 12)
+#define VI6_WFP_IRQ_STA_DFE		(1 << 1)
+#define VI6_WFP_IRQ_STA_FRE		(1 << 0)
+
+#define VI6_DISP_IRQ_ENB		0x0078
+#define VI6_DISP_IRQ_ENB_DSTE		(1 << 8)
+#define VI6_DISP_IRQ_ENB_MAEE		(1 << 5)
+#define VI6_DISP_IRQ_ENB_LNEE(n)	(1 << ((n) + 4))
+
+#define VI6_DISP_IRQ_STA		0x007c
+#define VI6_DISP_IRQ_STA_DSE		(1 << 8)
+#define VI6_DISP_IRQ_STA_MAE		(1 << 5)
+#define VI6_DISP_IRQ_STA_LNE(n)		(1 << ((n) + 4))
+
+#define VI6_WPF_LINE_COUNT(n)		(0x0084 + (n) * 4)
+#define VI6_WPF_LINE_COUNT_MASK		(0x1fffff << 0)
+
+/* -----------------------------------------------------------------------------
+ * Display List Control Registers
+ */
+
+#define VI6_DL_CTRL			0x0100
+#define VI6_DL_CTRL_AR_WAIT_MASK	(0xffff << 16)
+#define VI6_DL_CTRL_AR_WAIT_SHIFT	16
+#define VI6_DL_CTRL_DC2			(1 << 12)
+#define VI6_DL_CTRL_DC1			(1 << 8)
+#define VI6_DL_CTRL_DC0			(1 << 4)
+#define VI6_DL_CTRL_CFM0		(1 << 2)
+#define VI6_DL_CTRL_NH0			(1 << 1)
+#define VI6_DL_CTRL_DLE			(1 << 0)
+
+#define VI6_DL_HDR_ADDR(n)		(0x0104 + (n) * 4)
+
+#define VI6_DL_SWAP			0x0114
+#define VI6_DL_SWAP_LWS			(1 << 2)
+#define VI6_DL_SWAP_WDS			(1 << 1)
+#define VI6_DL_SWAP_BTS			(1 << 0)
+
+#define VI6_DL_EXT_CTRL			0x011c
+#define VI6_DL_EXT_CTRL_NWE		(1 << 16)
+#define VI6_DL_EXT_CTRL_POLINT_MASK	(0x3f << 8)
+#define VI6_DL_EXT_CTRL_POLINT_SHIFT	8
+#define VI6_DL_EXT_CTRL_DLPRI		(1 << 5)
+#define VI6_DL_EXT_CTRL_EXPRI		(1 << 4)
+#define VI6_DL_EXT_CTRL_EXT		(1 << 0)
+
+#define VI6_DL_BODY_SIZE		0x0120
+#define VI6_DL_BODY_SIZE_UPD		(1 << 24)
+#define VI6_DL_BODY_SIZE_BS_MASK	(0x1ffff << 0)
+#define VI6_DL_BODY_SIZE_BS_SHIFT	0
+
+/* -----------------------------------------------------------------------------
+ * RPF Control Registers
+ */
+
+#define VI6_RPF_OFFSET			0x100
+
+#define VI6_RPF_SRC_BSIZE		0x0300
+#define VI6_RPF_SRC_BSIZE_BHSIZE_MASK	(0x1fff << 16)
+#define VI6_RPF_SRC_BSIZE_BHSIZE_SHIFT	16
+#define VI6_RPF_SRC_BSIZE_BVSIZE_MASK	(0x1fff << 0)
+#define VI6_RPF_SRC_BSIZE_BVSIZE_SHIFT	0
+
+#define VI6_RPF_SRC_ESIZE		0x0304
+#define VI6_RPF_SRC_ESIZE_EHSIZE_MASK	(0x1fff << 16)
+#define VI6_RPF_SRC_ESIZE_EHSIZE_SHIFT	16
+#define VI6_RPF_SRC_ESIZE_EVSIZE_MASK	(0x1fff << 0)
+#define VI6_RPF_SRC_ESIZE_EVSIZE_SHIFT	0
+
+#define VI6_RPF_INFMT			0x0308
+#define VI6_RPF_INFMT_VIR		(1 << 28)
+#define VI6_RPF_INFMT_CIPM		(1 << 16)
+#define VI6_RPF_INFMT_SPYCS		(1 << 15)
+#define VI6_RPF_INFMT_SPUVS		(1 << 14)
+#define VI6_RPF_INFMT_CEXT_ZERO		(0 << 12)
+#define VI6_RPF_INFMT_CEXT_EXT		(1 << 12)
+#define VI6_RPF_INFMT_CEXT_ONE		(2 << 12)
+#define VI6_RPF_INFMT_CEXT_MASK		(3 << 12)
+#define VI6_RPF_INFMT_RDTM_BT601	(0 << 9)
+#define VI6_RPF_INFMT_RDTM_BT601_EXT	(1 << 9)
+#define VI6_RPF_INFMT_RDTM_BT709	(2 << 9)
+#define VI6_RPF_INFMT_RDTM_BT709_EXT	(3 << 9)
+#define VI6_RPF_INFMT_RDTM_MASK		(7 << 9)
+#define VI6_RPF_INFMT_CSC		(1 << 8)
+#define VI6_RPF_INFMT_RDFMT_MASK	(0x7f << 0)
+#define VI6_RPF_INFMT_RDFMT_SHIFT	0
+
+#define VI6_RPF_DSWAP			0x030c
+#define VI6_RPF_DSWAP_A_LLS		(1 << 11)
+#define VI6_RPF_DSWAP_A_LWS		(1 << 10)
+#define VI6_RPF_DSWAP_A_WDS		(1 << 9)
+#define VI6_RPF_DSWAP_A_BTS		(1 << 8)
+#define VI6_RPF_DSWAP_P_LLS		(1 << 3)
+#define VI6_RPF_DSWAP_P_LWS		(1 << 2)
+#define VI6_RPF_DSWAP_P_WDS		(1 << 1)
+#define VI6_RPF_DSWAP_P_BTS		(1 << 0)
+
+#define VI6_RPF_LOC			0x0310
+#define VI6_RPF_LOC_HCOORD_MASK		(0x1fff << 16)
+#define VI6_RPF_LOC_HCOORD_SHIFT	16
+#define VI6_RPF_LOC_VCOORD_MASK		(0x1fff << 0)
+#define VI6_RPF_LOC_VCOORD_SHIFT	0
+
+#define VI6_RPF_ALPH_SEL		0x0314
+#define VI6_RPF_ALPH_SEL_ASEL_PACKED	(0 << 28)
+#define VI6_RPF_ALPH_SEL_ASEL_8B_PLANE	(1 << 28)
+#define VI6_RPF_ALPH_SEL_ASEL_SELECT	(2 << 28)
+#define VI6_RPF_ALPH_SEL_ASEL_1B_PLANE	(3 << 28)
+#define VI6_RPF_ALPH_SEL_ASEL_FIXED	(4 << 28)
+#define VI6_RPF_ALPH_SEL_ASEL_MASK	(7 << 28)
+#define VI6_RPF_ALPH_SEL_ASEL_SHIFT	28
+#define VI6_RPF_ALPH_SEL_IROP_MASK	(0xf << 24)
+#define VI6_RPF_ALPH_SEL_IROP_SHIFT	24
+#define VI6_RPF_ALPH_SEL_BSEL		(1 << 23)
+#define VI6_RPF_ALPH_SEL_AEXT_ZERO	(0 << 18)
+#define VI6_RPF_ALPH_SEL_AEXT_EXT	(1 << 18)
+#define VI6_RPF_ALPH_SEL_AEXT_ONE	(2 << 18)
+#define VI6_RPF_ALPH_SEL_AEXT_MASK	(3 << 18)
+#define VI6_RPF_ALPH_SEL_ALPHA0_MASK	(0xff << 8)
+#define VI6_RPF_ALPH_SEL_ALPHA0_SHIFT	8
+#define VI6_RPF_ALPH_SEL_ALPHA1_MASK	(0xff << 0)
+#define VI6_RPF_ALPH_SEL_ALPHA1_SHIFT	0
+
+#define VI6_RPF_VRTCOL_SET		0x0318
+#define VI6_RPF_VRTCOL_SET_LAYA_MASK	(0xff << 24)
+#define VI6_RPF_VRTCOL_SET_LAYA_SHIFT	24
+#define VI6_RPF_VRTCOL_SET_LAYR_MASK	(0xff << 16)
+#define VI6_RPF_VRTCOL_SET_LAYR_SHIFT	16
+#define VI6_RPF_VRTCOL_SET_LAYG_MASK	(0xff << 8)
+#define VI6_RPF_VRTCOL_SET_LAYG_SHIFT	8
+#define VI6_RPF_VRTCOL_SET_LAYB_MASK	(0xff << 0)
+#define VI6_RPF_VRTCOL_SET_LAYB_SHIFT	0
+
+#define VI6_RPF_MSK_CTRL		0x031c
+#define VI6_RPF_MSK_CTRL_MSK_EN		(1 << 24)
+#define VI6_RPF_MSK_CTRL_MGR_MASK	(0xff << 16)
+#define VI6_RPF_MSK_CTRL_MGR_SHIFT	16
+#define VI6_RPF_MSK_CTRL_MGG_MASK	(0xff << 8)
+#define VI6_RPF_MSK_CTRL_MGG_SHIFT	8
+#define VI6_RPF_MSK_CTRL_MGB_MASK	(0xff << 0)
+#define VI6_RPF_MSK_CTRL_MGB_SHIFT	0
+
+#define VI6_RPF_MSK_SET0		0x0320
+#define VI6_RPF_MSK_SET1		0x0324
+#define VI6_RPF_MSK_SET_MSA_MASK	(0xff << 24)
+#define VI6_RPF_MSK_SET_MSA_SHIFT	24
+#define VI6_RPF_MSK_SET_MSR_MASK	(0xff << 16)
+#define VI6_RPF_MSK_SET_MSR_SHIFT	16
+#define VI6_RPF_MSK_SET_MSG_MASK	(0xff << 8)
+#define VI6_RPF_MSK_SET_MSG_SHIFT	8
+#define VI6_RPF_MSK_SET_MSB_MASK	(0xff << 0)
+#define VI6_RPF_MSK_SET_MSB_SHIFT	0
+
+#define VI6_RPF_CKEY_CTRL		0x0328
+#define VI6_RPF_CKEY_CTRL_CV		(1 << 4)
+#define VI6_RPF_CKEY_CTRL_SAPE1		(1 << 1)
+#define VI6_RPF_CKEY_CTRL_SAPE0		(1 << 0)
+
+#define VI6_RPF_CKEY_SET0		0x032c
+#define VI6_RPF_CKEY_SET1		0x0330
+#define VI6_RPF_CKEY_SET_AP_MASK	(0xff << 24)
+#define VI6_RPF_CKEY_SET_AP_SHIFT	24
+#define VI6_RPF_CKEY_SET_R_MASK		(0xff << 16)
+#define VI6_RPF_CKEY_SET_R_SHIFT	16
+#define VI6_RPF_CKEY_SET_GY_MASK	(0xff << 8)
+#define VI6_RPF_CKEY_SET_GY_SHIFT	8
+#define VI6_RPF_CKEY_SET_B_MASK		(0xff << 0)
+#define VI6_RPF_CKEY_SET_B_SHIFT	0
+
+#define VI6_RPF_SRCM_PSTRIDE		0x0334
+#define VI6_RPF_SRCM_PSTRIDE_Y_SHIFT	16
+#define VI6_RPF_SRCM_PSTRIDE_C_SHIFT	0
+
+#define VI6_RPF_SRCM_ASTRIDE		0x0338
+#define VI6_RPF_SRCM_PSTRIDE_A_SHIFT	0
+
+#define VI6_RPF_SRCM_ADDR_Y		0x033c
+#define VI6_RPF_SRCM_ADDR_C0		0x0340
+#define VI6_RPF_SRCM_ADDR_C1		0x0344
+#define VI6_RPF_SRCM_ADDR_AI		0x0348
+
+/* -----------------------------------------------------------------------------
+ * WPF Control Registers
+ */
+
+#define VI6_WPF_OFFSET			0x100
+
+#define VI6_WPF_SRCRPF			0x1000
+#define VI6_WPF_SRCRPF_VIRACT_DIS	(0 << 28)
+#define VI6_WPF_SRCRPF_VIRACT_SUB	(1 << 28)
+#define VI6_WPF_SRCRPF_VIRACT_MST	(2 << 28)
+#define VI6_WPF_SRCRPF_VIRACT_MASK	(3 << 28)
+#define VI6_WPF_SRCRPF_RPF_ACT_DIS(n)	(0 << ((n) * 2))
+#define VI6_WPF_SRCRPF_RPF_ACT_SUB(n)	(1 << ((n) * 2))
+#define VI6_WPF_SRCRPF_RPF_ACT_MST(n)	(2 << ((n) * 2))
+#define VI6_WPF_SRCRPF_RPF_ACT_MASK(n)	(3 << ((n) * 2))
+
+#define VI6_WPF_HSZCLIP			0x1004
+#define VI6_WPF_VSZCLIP			0x1008
+#define VI6_WPF_SZCLIP_EN		(1 << 28)
+#define VI6_WPF_SZCLIP_OFST_MASK	(0xff << 16)
+#define VI6_WPF_SZCLIP_OFST_SHIFT	16
+#define VI6_WPF_SZCLIP_SIZE_MASK	(0x1fff << 0)
+#define VI6_WPF_SZCLIP_SIZE_SHIFT	0
+
+#define VI6_WPF_OUTFMT			0x100c
+#define VI6_WPF_OUTFMT_PDV_MASK		(0xff << 24)
+#define VI6_WPF_OUTFMT_PDV_SHIFT	24
+#define VI6_WPF_OUTFMT_PXA		(1 << 23)
+#define VI6_WPF_OUTFMT_FLP		(1 << 16)
+#define VI6_WPF_OUTFMT_SPYCS		(1 << 15)
+#define VI6_WPF_OUTFMT_SPUVS		(1 << 14)
+#define VI6_WPF_OUTFMT_DITH_DIS		(0 << 12)
+#define VI6_WPF_OUTFMT_DITH_EN		(3 << 12)
+#define VI6_WPF_OUTFMT_DITH_MASK	(3 << 12)
+#define VI6_WPF_OUTFMT_WRTM_BT601	(0 << 9)
+#define VI6_WPF_OUTFMT_WRTM_BT601_EXT	(1 << 9)
+#define VI6_WPF_OUTFMT_WRTM_BT709	(2 << 9)
+#define VI6_WPF_OUTFMT_WRTM_BT709_EXT	(3 << 9)
+#define VI6_WPF_OUTFMT_WRTM_MASK	(7 << 9)
+#define VI6_WPF_OUTFMT_CSC		(1 << 8)
+#define VI6_WPF_OUTFMT_WRFMT_MASK	(0x7f << 0)
+#define VI6_WPF_OUTFMT_WRFMT_SHIFT	0
+
+#define VI6_WPF_DSWAP			0x1010
+#define VI6_WPF_DSWAP_P_LLS		(1 << 3)
+#define VI6_WPF_DSWAP_P_LWS		(1 << 2)
+#define VI6_WPF_DSWAP_P_WDS		(1 << 1)
+#define VI6_WPF_DSWAP_P_BTS		(1 << 0)
+
+#define VI6_WPF_RNDCTRL			0x1014
+#define VI6_WPF_RNDCTRL_CBRM		(1 << 28)
+#define VI6_WPF_RNDCTRL_ABRM_TRUNC	(0 << 24)
+#define VI6_WPF_RNDCTRL_ABRM_ROUND	(1 << 24)
+#define VI6_WPF_RNDCTRL_ABRM_THRESH	(2 << 24)
+#define VI6_WPF_RNDCTRL_ABRM_MASK	(3 << 24)
+#define VI6_WPF_RNDCTRL_ATHRESH_MASK	(0xff << 16)
+#define VI6_WPF_RNDCTRL_ATHRESH_SHIFT	16
+#define VI6_WPF_RNDCTRL_CLMD_FULL	(0 << 12)
+#define VI6_WPF_RNDCTRL_CLMD_CLIP	(1 << 12)
+#define VI6_WPF_RNDCTRL_CLMD_EXT	(2 << 12)
+#define VI6_WPF_RNDCTRL_CLMD_MASK	(3 << 12)
+
+#define VI6_WPF_DSTM_STRIDE_Y		0x101c
+#define VI6_WPF_DSTM_STRIDE_C		0x1020
+#define VI6_WPF_DSTM_ADDR_Y		0x1024
+#define VI6_WPF_DSTM_ADDR_C0		0x1028
+#define VI6_WPF_DSTM_ADDR_C1		0x102c
+
+#define VI6_WPF_WRBCK_CTRL		0x1034
+#define VI6_WPF_WRBCK_CTRL_WBMD		(1 << 0)
+
+/* -----------------------------------------------------------------------------
+ * DPR Control Registers
+ */
+
+#define VI6_DPR_RPF_ROUTE(n)		(0x2000 + (n) * 4)
+
+#define VI6_DPR_WPF_FPORCH(n)		(0x2014 + (n) * 4)
+#define VI6_DPR_WPF_FPORCH_FP_WPFN	(5 << 8)
+
+#define VI6_DPR_SRU_ROUTE		0x2024
+#define VI6_DPR_UDS_ROUTE(n)		(0x2028 + (n) * 4)
+#define VI6_DPR_LUT_ROUTE		0x203c
+#define VI6_DPR_CLU_ROUTE		0x2040
+#define VI6_DPR_HST_ROUTE		0x2044
+#define VI6_DPR_HSI_ROUTE		0x2048
+#define VI6_DPR_BRU_ROUTE		0x204c
+#define VI6_DPR_ROUTE_FXA_MASK		(0xff << 8)
+#define VI6_DPR_ROUTE_FXA_SHIFT		16
+#define VI6_DPR_ROUTE_FP_MASK		(0xff << 8)
+#define VI6_DPR_ROUTE_FP_SHIFT		8
+#define VI6_DPR_ROUTE_RT_MASK		(0x3f << 0)
+#define VI6_DPR_ROUTE_RT_SHIFT		0
+
+#define VI6_DPR_HGO_SMPPT		0x2050
+#define VI6_DPR_HGT_SMPPT		0x2054
+#define VI6_DPR_SMPPT_TGW_MASK		(7 << 8)
+#define VI6_DPR_SMPPT_TGW_SHIFT		8
+#define VI6_DPR_SMPPT_PT_MASK		(0x3f << 0)
+#define VI6_DPR_SMPPT_PT_SHIFT		0
+
+#define VI6_DPR_NODE_RPF(n)		(n)
+#define VI6_DPR_NODE_SRU		16
+#define VI6_DPR_NODE_UDS(n)		(17 + (n))
+#define VI6_DPR_NODE_LUT		22
+#define VI6_DPR_NODE_BRU_IN(n)		(23 + (n))
+#define VI6_DPR_NODE_BRU_OUT		27
+#define VI6_DPR_NODE_CLU		29
+#define VI6_DPR_NODE_HST		30
+#define VI6_DPR_NODE_HSI		31
+#define VI6_DPR_NODE_LIF		55
+#define VI6_DPR_NODE_WPF(n)		(56 + (n))
+#define VI6_DPR_NODE_UNUSED		63
+
+/* -----------------------------------------------------------------------------
+ * SRU Control Registers
+ */
+
+#define VI6_SRU_CTRL0			0x2200
+#define VI6_SRU_CTRL1			0x2204
+#define VI6_SRU_CTRL2			0x2208
+
+/* -----------------------------------------------------------------------------
+ * UDS Control Registers
+ */
+
+#define VI6_UDS_OFFSET			0x100
+
+#define VI6_UDS_CTRL			0x2300
+#define VI6_UDS_CTRL_AMD		(1 << 30)
+#define VI6_UDS_CTRL_FMD		(1 << 29)
+#define VI6_UDS_CTRL_BLADV		(1 << 28)
+#define VI6_UDS_CTRL_AON		(1 << 25)
+#define VI6_UDS_CTRL_ATHON		(1 << 24)
+#define VI6_UDS_CTRL_BC			(1 << 20)
+#define VI6_UDS_CTRL_NE_A		(1 << 19)
+#define VI6_UDS_CTRL_NE_RCR		(1 << 18)
+#define VI6_UDS_CTRL_NE_GY		(1 << 17)
+#define VI6_UDS_CTRL_NE_BCB		(1 << 16)
+#define VI6_UDS_CTRL_TDIPC		(1 << 1)
+
+#define VI6_UDS_SCALE			0x2304
+#define VI6_UDS_SCALE_HMANT_MASK	(0xf << 28)
+#define VI6_UDS_SCALE_HMANT_SHIFT	28
+#define VI6_UDS_SCALE_HFRAC_MASK	(0xfff << 16)
+#define VI6_UDS_SCALE_HFRAC_SHIFT	16
+#define VI6_UDS_SCALE_VMANT_MASK	(0xf << 12)
+#define VI6_UDS_SCALE_VMANT_SHIFT	12
+#define VI6_UDS_SCALE_VFRAC_MASK	(0xfff << 0)
+#define VI6_UDS_SCALE_VFRAC_SHIFT	0
+
+#define VI6_UDS_ALPTH			0x2308
+#define VI6_UDS_ALPTH_TH1_MASK		(0xff << 8)
+#define VI6_UDS_ALPTH_TH1_SHIFT		8
+#define VI6_UDS_ALPTH_TH0_MASK		(0xff << 0)
+#define VI6_UDS_ALPTH_TH0_SHIFT		0
+
+#define VI6_UDS_ALPVAL			0x230c
+#define VI6_UDS_ALPVAL_VAL2_MASK	(0xff << 16)
+#define VI6_UDS_ALPVAL_VAL2_SHIFT	16
+#define VI6_UDS_ALPVAL_VAL1_MASK	(0xff << 8)
+#define VI6_UDS_ALPVAL_VAL1_SHIFT	8
+#define VI6_UDS_ALPVAL_VAL0_MASK	(0xff << 0)
+#define VI6_UDS_ALPVAL_VAL0_SHIFT	0
+
+#define VI6_UDS_PASS_BWIDTH		0x2310
+#define VI6_UDS_PASS_BWIDTH_H_MASK	(0x7f << 16)
+#define VI6_UDS_PASS_BWIDTH_H_SHIFT	16
+#define VI6_UDS_PASS_BWIDTH_V_MASK	(0x7f << 0)
+#define VI6_UDS_PASS_BWIDTH_V_SHIFT	0
+
+#define VI6_UDS_IPC			0x2318
+#define VI6_UDS_IPC_FIELD		(1 << 27)
+#define VI6_UDS_IPC_VEDP_MASK		(0xfff << 0)
+#define VI6_UDS_IPC_VEDP_SHIFT		0
+
+#define VI6_UDS_CLIP_SIZE		0x2324
+#define VI6_UDS_CLIP_SIZE_HSIZE_MASK	(0x1fff << 16)
+#define VI6_UDS_CLIP_SIZE_HSIZE_SHIFT	16
+#define VI6_UDS_CLIP_SIZE_VSIZE_MASK	(0x1fff << 0)
+#define VI6_UDS_CLIP_SIZE_VSIZE_SHIFT	0
+
+#define VI6_UDS_FILL_COLOR		0x2328
+#define VI6_UDS_FILL_COLOR_RFILC_MASK	(0xff << 16)
+#define VI6_UDS_FILL_COLOR_RFILC_SHIFT	16
+#define VI6_UDS_FILL_COLOR_GFILC_MASK	(0xff << 8)
+#define VI6_UDS_FILL_COLOR_GFILC_SHIFT	8
+#define VI6_UDS_FILL_COLOR_BFILC_MASK	(0xff << 0)
+#define VI6_UDS_FILL_COLOR_BFILC_SHIFT	0
+
+/* -----------------------------------------------------------------------------
+ * LUT Control Registers
+ */
+
+#define VI6_LUT_CTRL			0x2800
+
+/* -----------------------------------------------------------------------------
+ * CLU Control Registers
+ */
+
+#define VI6_CLU_CTRL			0x2900
+
+/* -----------------------------------------------------------------------------
+ * HST Control Registers
+ */
+
+#define VI6_HST_CTRL			0x2a00
+
+/* -----------------------------------------------------------------------------
+ * HSI Control Registers
+ */
+
+#define VI6_HSI_CTRL			0x2b00
+
+/* -----------------------------------------------------------------------------
+ * BRU Control Registers
+ */
+
+#define VI6_BRU_INCTRL			0x2c00
+#define VI6_BRU_VIRRPF_SIZE		0x2c04
+#define VI6_BRU_VIRRPF_LOC		0x2c08
+#define VI6_BRU_VIRRPF_COL		0x2c0c
+#define VI6_BRU_CTRL(n)			(0x2c10 + (n) * 8)
+#define VI6_BRU_BLD(n)			(0x2c14 + (n) * 8)
+#define VI6_BRU_ROP			0x2c30
+
+/* -----------------------------------------------------------------------------
+ * HGO Control Registers
+ */
+
+#define VI6_HGO_OFFSET			0x3000
+#define VI6_HGO_SIZE			0x3004
+#define VI6_HGO_MODE			0x3008
+#define VI6_HGO_LB_TH			0x300c
+#define VI6_HGO_LBn_H(n)		(0x3010 + (n) * 8)
+#define VI6_HGO_LBn_V(n)		(0x3014 + (n) * 8)
+#define VI6_HGO_R_HISTO			0x3030
+#define VI6_HGO_R_MAXMIN		0x3130
+#define VI6_HGO_R_SUM			0x3134
+#define VI6_HGO_R_LB_DET		0x3138
+#define VI6_HGO_G_HISTO			0x3140
+#define VI6_HGO_G_MAXMIN		0x3240
+#define VI6_HGO_G_SUM			0x3244
+#define VI6_HGO_G_LB_DET		0x3248
+#define VI6_HGO_B_HISTO			0x3250
+#define VI6_HGO_B_MAXMIN		0x3350
+#define VI6_HGO_B_SUM			0x3354
+#define VI6_HGO_B_LB_DET		0x3358
+#define VI6_HGO_REGRST			0x33fc
+
+/* -----------------------------------------------------------------------------
+ * HGT Control Registers
+ */
+
+#define VI6_HGT_OFFSET			0x3400
+#define VI6_HGT_SIZE			0x3404
+#define VI6_HGT_MODE			0x3408
+#define VI6_HGT_HUE_AREA(n)		(0x340c + (n) * 4)
+#define VI6_HGT_LB_TH			0x3424
+#define VI6_HGT_LBn_H(n)		(0x3438 + (n) * 8)
+#define VI6_HGT_LBn_V(n)		(0x342c + (n) * 8)
+#define VI6_HGT_HISTO(m, n)		(0x3450 + (m) * 128 + (n) * 4)
+#define VI6_HGT_MAXMIN			0x3750
+#define VI6_HGT_SUM			0x3754
+#define VI6_HGT_LB_DET			0x3758
+#define VI6_HGT_REGRST			0x37fc
+
+/* -----------------------------------------------------------------------------
+ * LIF Control Registers
+ */
+
+#define VI6_LIF_CTRL			0x3b00
+#define VI6_LIF_CTRL_OBTH_MASK		(0x7ff << 16)
+#define VI6_LIF_CTRL_OBTH_SHIFT		16
+#define VI6_LIF_CTRL_CFMT		(1 << 4)
+#define VI6_LIF_CTRL_REQSEL		(1 << 1)
+#define VI6_LIF_CTRL_LIF_EN		(1 << 0)
+
+#define VI6_LIF_CSBTH			0x3b04
+#define VI6_LIF_CSBTH_HBTH_MASK		(0x7ff << 16)
+#define VI6_LIF_CSBTH_HBTH_SHIFT	16
+#define VI6_LIF_CSBTH_LBTH_MASK		(0x7ff << 0)
+#define VI6_LIF_CSBTH_LBTH_SHIFT	0
+
+/* -----------------------------------------------------------------------------
+ * Security Control Registers
+ */
+
+#define VI6_SECURITY_CTRL0		0x3d00
+#define VI6_SECURITY_CTRL1		0x3d04
+
+/* -----------------------------------------------------------------------------
+ * RPF CLUT Registers
+ */
+
+#define VI6_CLUT_TABLE			0x4000
+
+/* -----------------------------------------------------------------------------
+ * 1D LUT Registers
+ */
+
+#define VI6_LUT_TABLE			0x7000
+
+/* -----------------------------------------------------------------------------
+ * 3D LUT Registers
+ */
+
+#define VI6_CLU_ADDR			0x7400
+#define VI6_CLU_DATA			0x7404
+
+/* -----------------------------------------------------------------------------
+ * Formats
+ */
+
+#define VI6_FMT_RGB_332			0x00
+#define VI6_FMT_XRGB_4444		0x01
+#define VI6_FMT_RGBX_4444		0x02
+#define VI6_FMT_XRGB_1555		0x04
+#define VI6_FMT_RGBX_5551		0x05
+#define VI6_FMT_RGB_565			0x06
+#define VI6_FMT_AXRGB_86666		0x07
+#define VI6_FMT_RGBXA_66668		0x08
+#define VI6_FMT_XRGBA_66668		0x09
+#define VI6_FMT_ARGBX_86666		0x0a
+#define VI6_FMT_AXRXGXB_8262626		0x0b
+#define VI6_FMT_XRXGXBA_2626268		0x0c
+#define VI6_FMT_ARXGXBX_8626262		0x0d
+#define VI6_FMT_RXGXBXA_6262628		0x0e
+#define VI6_FMT_XRGB_6666		0x0f
+#define VI6_FMT_RGBX_6666		0x10
+#define VI6_FMT_XRXGXB_262626		0x11
+#define VI6_FMT_RXGXBX_626262		0x12
+#define VI6_FMT_ARGB_8888		0x13
+#define VI6_FMT_RGBA_8888		0x14
+#define VI6_FMT_RGB_888			0x15
+#define VI6_FMT_XRGXGB_763763		0x16
+#define VI6_FMT_XXRGB_86666		0x17
+#define VI6_FMT_BGR_888			0x18
+#define VI6_FMT_ARGB_4444		0x19
+#define VI6_FMT_RGBA_4444		0x1a
+#define VI6_FMT_ARGB_1555		0x1b
+#define VI6_FMT_RGBA_5551		0x1c
+#define VI6_FMT_ABGR_4444		0x1d
+#define VI6_FMT_BGRA_4444		0x1e
+#define VI6_FMT_ABGR_1555		0x1f
+#define VI6_FMT_BGRA_5551		0x20
+#define VI6_FMT_XBXGXR_262626		0x21
+#define VI6_FMT_ABGR_8888		0x22
+#define VI6_FMT_XXRGB_88565		0x23
+
+#define VI6_FMT_Y_UV_444		0x40
+#define VI6_FMT_Y_UV_422		0x41
+#define VI6_FMT_Y_UV_420		0x42
+#define VI6_FMT_YUV_444			0x46
+#define VI6_FMT_YUYV_422		0x47
+#define VI6_FMT_YYUV_422		0x48
+#define VI6_FMT_YUV_420			0x49
+#define VI6_FMT_Y_U_V_444		0x4a
+#define VI6_FMT_Y_U_V_422		0x4b
+#define VI6_FMT_Y_U_V_420		0x4c
+
+#endif /* __VSP1_REGS_H__ */
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
new file mode 100644
index 0000000..254871d
--- /dev/null
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -0,0 +1,209 @@
+/*
+ * vsp1_rpf.c  --  R-Car VSP1 Read Pixel Formatter
+ *
+ * Copyright (C) 2013 Renesas Corporation
+ *
+ * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/device.h>
+
+#include <media/v4l2-subdev.h>
+
+#include "vsp1.h"
+#include "vsp1_rwpf.h"
+#include "vsp1_video.h"
+
+#define RPF_MAX_WIDTH				8190
+#define RPF_MAX_HEIGHT				8190
+
+/* -----------------------------------------------------------------------------
+ * Device Access
+ */
+
+static inline u32 vsp1_rpf_read(struct vsp1_rwpf *rpf, u32 reg)
+{
+	return vsp1_read(rpf->entity.vsp1,
+			 reg + rpf->entity.index * VI6_RPF_OFFSET);
+}
+
+static inline void vsp1_rpf_write(struct vsp1_rwpf *rpf, u32 reg, u32 data)
+{
+	vsp1_write(rpf->entity.vsp1,
+		   reg + rpf->entity.index * VI6_RPF_OFFSET, data);
+}
+
+/* -----------------------------------------------------------------------------
+ * V4L2 Subdevice Core Operations
+ */
+
+static int rpf_s_stream(struct v4l2_subdev *subdev, int enable)
+{
+	struct vsp1_rwpf *rpf = to_rwpf(subdev);
+	const struct vsp1_format_info *fmtinfo = rpf->video.fmtinfo;
+	const struct v4l2_pix_format_mplane *format = &rpf->video.format;
+	u32 pstride;
+	u32 infmt;
+
+	if (!enable)
+		return 0;
+
+	/* Source size and stride. Cropping isn't supported yet. */
+	vsp1_rpf_write(rpf, VI6_RPF_SRC_BSIZE,
+		       (format->width << VI6_RPF_SRC_BSIZE_BHSIZE_SHIFT) |
+		       (format->height << VI6_RPF_SRC_BSIZE_BVSIZE_SHIFT));
+	vsp1_rpf_write(rpf, VI6_RPF_SRC_ESIZE,
+		       (format->width << VI6_RPF_SRC_ESIZE_EHSIZE_SHIFT) |
+		       (format->height << VI6_RPF_SRC_ESIZE_EVSIZE_SHIFT));
+
+	pstride = format->plane_fmt[0].bytesperline
+		<< VI6_RPF_SRCM_PSTRIDE_Y_SHIFT;
+	if (format->num_planes > 1)
+		pstride |= format->plane_fmt[1].bytesperline
+			<< VI6_RPF_SRCM_PSTRIDE_C_SHIFT;
+
+	vsp1_rpf_write(rpf, VI6_RPF_SRCM_PSTRIDE, pstride);
+
+	/* Format */
+	infmt = VI6_RPF_INFMT_CIPM
+	      | (fmtinfo->hwfmt << VI6_RPF_INFMT_RDFMT_SHIFT);
+
+	if (fmtinfo->swap_yc)
+		infmt |= VI6_RPF_INFMT_SPYCS;
+	if (fmtinfo->swap_uv)
+		infmt |= VI6_RPF_INFMT_SPUVS;
+
+	if (rpf->entity.formats[RWPF_PAD_SINK].code !=
+	    rpf->entity.formats[RWPF_PAD_SOURCE].code)
+		infmt |= VI6_RPF_INFMT_CSC;
+
+	vsp1_rpf_write(rpf, VI6_RPF_INFMT, infmt);
+	vsp1_rpf_write(rpf, VI6_RPF_DSWAP, fmtinfo->swap);
+
+	/* Output location. Composing isn't supported yet. */
+	vsp1_rpf_write(rpf, VI6_RPF_LOC, 0);
+
+	/* Disable alpha, mask and color key. Set the alpha channel to a fixed
+	 * value of 255.
+	 */
+	vsp1_rpf_write(rpf, VI6_RPF_ALPH_SEL, VI6_RPF_ALPH_SEL_ASEL_FIXED);
+	vsp1_rpf_write(rpf, VI6_RPF_VRTCOL_SET,
+		       255 << VI6_RPF_VRTCOL_SET_LAYA_SHIFT);
+	vsp1_rpf_write(rpf, VI6_RPF_MSK_CTRL, 0);
+	vsp1_rpf_write(rpf, VI6_RPF_CKEY_CTRL, 0);
+
+	return 0;
+}
+
+/* -----------------------------------------------------------------------------
+ * V4L2 Subdevice Operations
+ */
+
+static struct v4l2_subdev_video_ops rpf_video_ops = {
+	.s_stream = rpf_s_stream,
+};
+
+static struct v4l2_subdev_pad_ops rpf_pad_ops = {
+	.enum_mbus_code = vsp1_rwpf_enum_mbus_code,
+	.enum_frame_size = vsp1_rwpf_enum_frame_size,
+	.get_fmt = vsp1_rwpf_get_format,
+	.set_fmt = vsp1_rwpf_set_format,
+};
+
+static struct v4l2_subdev_ops rpf_ops = {
+	.video	= &rpf_video_ops,
+	.pad    = &rpf_pad_ops,
+};
+
+/* -----------------------------------------------------------------------------
+ * Video Device Operations
+ */
+
+static void rpf_vdev_queue(struct vsp1_video *video,
+			   struct vsp1_video_buffer *buf)
+{
+	struct vsp1_rwpf *rpf = container_of(video, struct vsp1_rwpf, video);
+
+	vsp1_rpf_write(rpf, VI6_RPF_SRCM_ADDR_Y, buf->addr[0]);
+	if (buf->buf.num_planes > 1)
+		vsp1_rpf_write(rpf, VI6_RPF_SRCM_ADDR_C0, buf->addr[1]);
+	if (buf->buf.num_planes > 2)
+		vsp1_rpf_write(rpf, VI6_RPF_SRCM_ADDR_C1, buf->addr[2]);
+}
+
+static const struct vsp1_video_operations rpf_vdev_ops = {
+	.queue = rpf_vdev_queue,
+};
+
+/* -----------------------------------------------------------------------------
+ * Initialization and Cleanup
+ */
+
+struct vsp1_rwpf *vsp1_rpf_create(struct vsp1_device *vsp1, unsigned int index)
+{
+	struct v4l2_subdev *subdev;
+	struct vsp1_video *video;
+	struct vsp1_rwpf *rpf;
+	int ret;
+
+	rpf = devm_kzalloc(vsp1->dev, sizeof(*rpf), GFP_KERNEL);
+	if (rpf == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	rpf->max_width = RPF_MAX_WIDTH;
+	rpf->max_height = RPF_MAX_HEIGHT;
+
+	rpf->entity.type = VSP1_ENTITY_RPF;
+	rpf->entity.index = index;
+	rpf->entity.id = VI6_DPR_NODE_RPF(index);
+
+	ret = vsp1_entity_init(vsp1, &rpf->entity, 2);
+	if (ret < 0)
+		return ERR_PTR(ret);
+
+	/* Initialize the V4L2 subdev. */
+	subdev = &rpf->entity.subdev;
+	v4l2_subdev_init(subdev, &rpf_ops);
+
+	subdev->entity.ops = &vsp1_media_ops;
+	subdev->internal_ops = &vsp1_subdev_internal_ops;
+	snprintf(subdev->name, sizeof(subdev->name), "%s rpf.%u",
+		 dev_name(vsp1->dev), index);
+	v4l2_set_subdevdata(subdev, rpf);
+	subdev->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+
+	vsp1_entity_init_formats(subdev, NULL);
+
+	/* Initialize the video device. */
+	video = &rpf->video;
+
+	video->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
+	video->vsp1 = vsp1;
+	video->ops = &rpf_vdev_ops;
+
+	ret = vsp1_video_init(video, &rpf->entity);
+	if (ret < 0)
+		goto error_video;
+
+	/* Connect the video device to the RPF. */
+	ret = media_entity_create_link(&rpf->video.video.entity, 0,
+				       &rpf->entity.subdev.entity,
+				       RWPF_PAD_SINK,
+				       MEDIA_LNK_FL_ENABLED |
+				       MEDIA_LNK_FL_IMMUTABLE);
+	if (ret < 0)
+		goto error_link;
+
+	return rpf;
+
+error_link:
+	vsp1_video_cleanup(video);
+error_video:
+	media_entity_cleanup(&rpf->entity.subdev.entity);
+	return ERR_PTR(ret);
+}
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.c b/drivers/media/platform/vsp1/vsp1_rwpf.c
new file mode 100644
index 0000000..9752d55
--- /dev/null
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.c
@@ -0,0 +1,124 @@
+/*
+ * vsp1_rwpf.c  --  R-Car VSP1 Read and Write Pixel Formatters
+ *
+ * Copyright (C) 2013 Renesas Corporation
+ *
+ * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <media/v4l2-subdev.h>
+
+#include "vsp1.h"
+#include "vsp1_rwpf.h"
+#include "vsp1_video.h"
+
+#define RWPF_MIN_WIDTH				1
+#define RWPF_MIN_HEIGHT				1
+
+/* -----------------------------------------------------------------------------
+ * V4L2 Subdevice Pad Operations
+ */
+
+int vsp1_rwpf_enum_mbus_code(struct v4l2_subdev *subdev,
+			     struct v4l2_subdev_fh *fh,
+			     struct v4l2_subdev_mbus_code_enum *code)
+{
+	static const unsigned int codes[] = {
+		V4L2_MBUS_FMT_ARGB8888_1X32,
+		V4L2_MBUS_FMT_AYUV8_1X32,
+	};
+
+	if (code->index >= ARRAY_SIZE(codes))
+		return -EINVAL;
+
+	code->code = codes[code->index];
+
+	return 0;
+}
+
+int vsp1_rwpf_enum_frame_size(struct v4l2_subdev *subdev,
+			      struct v4l2_subdev_fh *fh,
+			      struct v4l2_subdev_frame_size_enum *fse)
+{
+	struct vsp1_rwpf *rwpf = to_rwpf(subdev);
+	struct v4l2_mbus_framefmt *format;
+
+	format = v4l2_subdev_get_try_format(fh, fse->pad);
+
+	if (fse->index || fse->code != format->code)
+		return -EINVAL;
+
+	if (fse->pad == RWPF_PAD_SINK) {
+		fse->min_width = RWPF_MIN_WIDTH;
+		fse->max_width = rwpf->max_width;
+		fse->min_height = RWPF_MIN_HEIGHT;
+		fse->max_height = rwpf->max_height;
+	} else {
+		/* The size on the source pad are fixed and always identical to
+		 * the size on the sink pad.
+		 */
+		fse->min_width = format->width;
+		fse->max_width = format->width;
+		fse->min_height = format->height;
+		fse->max_height = format->height;
+	}
+
+	return 0;
+}
+
+int vsp1_rwpf_get_format(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh,
+			 struct v4l2_subdev_format *fmt)
+{
+	struct vsp1_rwpf *rwpf = to_rwpf(subdev);
+
+	fmt->format = *vsp1_entity_get_pad_format(&rwpf->entity, fh, fmt->pad,
+						  fmt->which);
+
+	return 0;
+}
+
+int vsp1_rwpf_set_format(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh,
+			 struct v4l2_subdev_format *fmt)
+{
+	struct vsp1_rwpf *rwpf = to_rwpf(subdev);
+	struct v4l2_mbus_framefmt *format;
+
+	/* Default to YUV if the requested format is not supported. */
+	if (fmt->format.code != V4L2_MBUS_FMT_ARGB8888_1X32 &&
+	    fmt->format.code != V4L2_MBUS_FMT_AYUV8_1X32)
+		fmt->format.code = V4L2_MBUS_FMT_AYUV8_1X32;
+
+	format = vsp1_entity_get_pad_format(&rwpf->entity, fh, fmt->pad,
+					    fmt->which);
+
+	if (fmt->pad == RWPF_PAD_SOURCE) {
+		/* The RWPF performs format conversion but can't scale, only the
+		 * format code can be changed on the source pad.
+		 */
+		format->code = fmt->format.code;
+		fmt->format = *format;
+		return 0;
+	}
+
+	format->code = fmt->format.code;
+	format->width = clamp_t(unsigned int, fmt->format.width,
+				RWPF_MIN_WIDTH, rwpf->max_width);
+	format->height = clamp_t(unsigned int, fmt->format.height,
+				 RWPF_MIN_HEIGHT, rwpf->max_height);
+	format->field = V4L2_FIELD_NONE;
+	format->colorspace = V4L2_COLORSPACE_SRGB;
+
+	fmt->format = *format;
+
+	/* Propagate the format to the source pad. */
+	format = vsp1_entity_get_pad_format(&rwpf->entity, fh, RWPF_PAD_SOURCE,
+					    fmt->which);
+	*format = fmt->format;
+
+	return 0;
+}
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.h b/drivers/media/platform/vsp1/vsp1_rwpf.h
new file mode 100644
index 0000000..c182d85
--- /dev/null
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.h
@@ -0,0 +1,53 @@
+/*
+ * vsp1_rwpf.h  --  R-Car VSP1 Read and Write Pixel Formatters
+ *
+ * Copyright (C) 2013 Renesas Corporation
+ *
+ * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#ifndef __VSP1_RWPF_H__
+#define __VSP1_RWPF_H__
+
+#include <media/media-entity.h>
+#include <media/v4l2-subdev.h>
+
+#include "vsp1.h"
+#include "vsp1_entity.h"
+#include "vsp1_video.h"
+
+#define RWPF_PAD_SINK				0
+#define RWPF_PAD_SOURCE				1
+
+struct vsp1_rwpf {
+	struct vsp1_entity entity;
+	struct vsp1_video video;
+
+	unsigned int max_width;
+	unsigned int max_height;
+};
+
+static inline struct vsp1_rwpf *to_rwpf(struct v4l2_subdev *subdev)
+{
+	return container_of(subdev, struct vsp1_rwpf, entity.subdev);
+}
+
+struct vsp1_rwpf *vsp1_rpf_create(struct vsp1_device *vsp1, unsigned int index);
+struct vsp1_rwpf *vsp1_wpf_create(struct vsp1_device *vsp1, unsigned int index);
+
+int vsp1_rwpf_enum_mbus_code(struct v4l2_subdev *subdev,
+			     struct v4l2_subdev_fh *fh,
+			     struct v4l2_subdev_mbus_code_enum *code);
+int vsp1_rwpf_enum_frame_size(struct v4l2_subdev *subdev,
+			      struct v4l2_subdev_fh *fh,
+			      struct v4l2_subdev_frame_size_enum *fse);
+int vsp1_rwpf_get_format(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh,
+			 struct v4l2_subdev_format *fmt);
+int vsp1_rwpf_set_format(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh,
+			 struct v4l2_subdev_format *fmt);
+
+#endif /* __VSP1_RWPF_H__ */
diff --git a/drivers/media/platform/vsp1/vsp1_uds.c b/drivers/media/platform/vsp1/vsp1_uds.c
new file mode 100644
index 0000000..0e50b37
--- /dev/null
+++ b/drivers/media/platform/vsp1/vsp1_uds.c
@@ -0,0 +1,346 @@
+/*
+ * vsp1_uds.c  --  R-Car VSP1 Up and Down Scaler
+ *
+ * Copyright (C) 2013 Renesas Corporation
+ *
+ * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/device.h>
+#include <linux/gfp.h>
+
+#include <media/v4l2-subdev.h>
+
+#include "vsp1.h"
+#include "vsp1_uds.h"
+
+#define UDS_MIN_SIZE				4U
+#define UDS_MAX_SIZE				8190U
+
+#define UDS_MIN_FACTOR				0x0100
+#define UDS_MAX_FACTOR				0xffff
+
+/* -----------------------------------------------------------------------------
+ * Device Access
+ */
+
+static inline u32 vsp1_uds_read(struct vsp1_uds *uds, u32 reg)
+{
+	return vsp1_read(uds->entity.vsp1,
+			 reg + uds->entity.index * VI6_UDS_OFFSET);
+}
+
+static inline void vsp1_uds_write(struct vsp1_uds *uds, u32 reg, u32 data)
+{
+	vsp1_write(uds->entity.vsp1,
+		   reg + uds->entity.index * VI6_UDS_OFFSET, data);
+}
+
+/* -----------------------------------------------------------------------------
+ * Scaling Computation
+ */
+
+/*
+ * uds_output_size - Return the output size for an input size and scaling ratio
+ * @input: input size in pixels
+ * @ratio: scaling ratio in U4.12 fixed-point format
+ */
+static unsigned int uds_output_size(unsigned int input, unsigned int ratio)
+{
+	if (ratio > 4096) {
+		/* Down-scaling */
+		unsigned int mp;
+
+		mp = ratio / 4096;
+		mp = mp < 4 ? 1 : (mp < 8 ? 2 : 4);
+
+		return (input - 1) / mp * mp * 4096 / ratio + 1;
+	} else {
+		/* Up-scaling */
+		return (input - 1) * 4096 / ratio + 1;
+	}
+}
+
+/*
+ * uds_output_limits - Return the min and max output sizes for an input size
+ * @input: input size in pixels
+ * @minimum: minimum output size (returned)
+ * @maximum: maximum output size (returned)
+ */
+static void uds_output_limits(unsigned int input,
+			      unsigned int *minimum, unsigned int *maximum)
+{
+	*minimum = max(uds_output_size(input, UDS_MAX_FACTOR), UDS_MIN_SIZE);
+	*maximum = min(uds_output_size(input, UDS_MIN_FACTOR), UDS_MAX_SIZE);
+}
+
+/*
+ * uds_passband_width - Return the passband filter width for a scaling ratio
+ * @ratio: scaling ratio in U4.12 fixed-point format
+ */
+static unsigned int uds_passband_width(unsigned int ratio)
+{
+	if (ratio >= 4096) {
+		/* Down-scaling */
+		unsigned int mp;
+
+		mp = ratio / 4096;
+		mp = mp < 4 ? 1 : (mp < 8 ? 2 : 4);
+
+		return 64 * 4096 * mp / ratio;
+	} else {
+		/* Up-scaling */
+		return 64;
+	}
+}
+
+static unsigned int uds_compute_ratio(unsigned int input, unsigned int output)
+{
+	/* TODO: This is an approximation that will need to be refined. */
+	return (input - 1) * 4096 / (output - 1);
+}
+
+static void uds_compute_ratios(struct vsp1_uds *uds)
+{
+	struct v4l2_mbus_framefmt *input = &uds->entity.formats[UDS_PAD_SINK];
+	struct v4l2_mbus_framefmt *output =
+		&uds->entity.formats[UDS_PAD_SOURCE];
+
+	uds->hscale = uds_compute_ratio(input->width, output->width);
+	uds->vscale = uds_compute_ratio(input->height, output->height);
+
+	dev_dbg(uds->entity.vsp1->dev, "hscale %u vscale %u\n",
+		uds->hscale, uds->vscale);
+}
+
+/* -----------------------------------------------------------------------------
+ * V4L2 Subdevice Core Operations
+ */
+
+static int uds_s_stream(struct v4l2_subdev *subdev, int enable)
+{
+	const struct v4l2_mbus_framefmt *format;
+	struct vsp1_uds *uds = to_uds(subdev);
+
+	if (!enable)
+		return 0;
+
+	/* Enable multi-tap scaling. */
+	vsp1_uds_write(uds, VI6_UDS_CTRL, VI6_UDS_CTRL_BC);
+
+	vsp1_uds_write(uds, VI6_UDS_PASS_BWIDTH,
+		       (uds_passband_width(uds->hscale)
+				<< VI6_UDS_PASS_BWIDTH_H_SHIFT) |
+		       (uds_passband_width(uds->vscale)
+				<< VI6_UDS_PASS_BWIDTH_V_SHIFT));
+
+
+	/* Set the scaling ratios and the output size. */
+	format = &uds->entity.formats[UDS_PAD_SOURCE];
+
+	vsp1_uds_write(uds, VI6_UDS_SCALE,
+		       (uds->hscale << VI6_UDS_SCALE_HFRAC_SHIFT) |
+		       (uds->vscale << VI6_UDS_SCALE_VFRAC_SHIFT));
+	vsp1_uds_write(uds, VI6_UDS_CLIP_SIZE,
+		       (format->width << VI6_UDS_CLIP_SIZE_HSIZE_SHIFT) |
+		       (format->height << VI6_UDS_CLIP_SIZE_VSIZE_SHIFT));
+
+	return 0;
+}
+
+/* -----------------------------------------------------------------------------
+ * V4L2 Subdevice Pad Operations
+ */
+
+static int uds_enum_mbus_code(struct v4l2_subdev *subdev,
+			      struct v4l2_subdev_fh *fh,
+			      struct v4l2_subdev_mbus_code_enum *code)
+{
+	static const unsigned int codes[] = {
+		V4L2_MBUS_FMT_ARGB8888_1X32,
+		V4L2_MBUS_FMT_AYUV8_1X32,
+	};
+
+	if (code->pad == UDS_PAD_SINK) {
+		if (code->index >= ARRAY_SIZE(codes))
+			return -EINVAL;
+
+		code->code = codes[code->index];
+	} else {
+		struct v4l2_mbus_framefmt *format;
+
+		/* The UDS can't perform format conversion, the sink format is
+		 * always identical to the source format.
+		 */
+		if (code->index)
+			return -EINVAL;
+
+		format = v4l2_subdev_get_try_format(fh, UDS_PAD_SINK);
+		code->code = format->code;
+	}
+
+	return 0;
+}
+
+static int uds_enum_frame_size(struct v4l2_subdev *subdev,
+			       struct v4l2_subdev_fh *fh,
+			       struct v4l2_subdev_frame_size_enum *fse)
+{
+	struct v4l2_mbus_framefmt *format;
+
+	format = v4l2_subdev_get_try_format(fh, UDS_PAD_SINK);
+
+	if (fse->index || fse->code != format->code)
+		return -EINVAL;
+
+	if (fse->pad == UDS_PAD_SINK) {
+		fse->min_width = UDS_MIN_SIZE;
+		fse->max_width = UDS_MAX_SIZE;
+		fse->min_height = UDS_MIN_SIZE;
+		fse->max_height = UDS_MAX_SIZE;
+	} else {
+		uds_output_limits(format->width, &fse->min_width,
+				  &fse->max_width);
+		uds_output_limits(format->height, &fse->min_height,
+				  &fse->max_height);
+	}
+
+	return 0;
+}
+
+static int uds_get_format(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh,
+			  struct v4l2_subdev_format *fmt)
+{
+	struct vsp1_uds *uds = to_uds(subdev);
+
+	fmt->format = *vsp1_entity_get_pad_format(&uds->entity, fh, fmt->pad,
+						  fmt->which);
+
+	return 0;
+}
+
+static void uds_try_format(struct vsp1_uds *uds, struct v4l2_subdev_fh *fh,
+			   unsigned int pad, struct v4l2_mbus_framefmt *fmt,
+			   enum v4l2_subdev_format_whence which)
+{
+	struct v4l2_mbus_framefmt *format;
+	unsigned int minimum;
+	unsigned int maximum;
+
+	switch (pad) {
+	case UDS_PAD_SINK:
+		/* Default to YUV if the requested format is not supported. */
+		if (fmt->code != V4L2_MBUS_FMT_ARGB8888_1X32 &&
+		    fmt->code != V4L2_MBUS_FMT_AYUV8_1X32)
+			fmt->code = V4L2_MBUS_FMT_AYUV8_1X32;
+
+		fmt->width = clamp(fmt->width, UDS_MIN_SIZE, UDS_MAX_SIZE);
+		fmt->height = clamp(fmt->height, UDS_MIN_SIZE, UDS_MAX_SIZE);
+		break;
+
+	case UDS_PAD_SOURCE:
+		/* The UDS scales but can't perform format conversion. */
+		format = vsp1_entity_get_pad_format(&uds->entity, fh,
+						    UDS_PAD_SINK, which);
+		fmt->code = format->code;
+
+		uds_output_limits(format->width, &minimum, &maximum);
+		fmt->width = clamp(fmt->width, minimum, maximum);
+		uds_output_limits(format->height, &minimum, &maximum);
+		fmt->height = clamp(fmt->height, minimum, maximum);
+		break;
+	}
+
+	fmt->field = V4L2_FIELD_NONE;
+	fmt->colorspace = V4L2_COLORSPACE_SRGB;
+}
+
+static int uds_set_format(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh,
+			  struct v4l2_subdev_format *fmt)
+{
+	struct vsp1_uds *uds = to_uds(subdev);
+	struct v4l2_mbus_framefmt *format;
+
+	uds_try_format(uds, fh, fmt->pad, &fmt->format, fmt->which);
+
+	format = vsp1_entity_get_pad_format(&uds->entity, fh, fmt->pad,
+					    fmt->which);
+	*format = fmt->format;
+
+	if (fmt->pad == UDS_PAD_SINK) {
+		/* Propagate the format to the source pad. */
+		format = vsp1_entity_get_pad_format(&uds->entity, fh,
+						    UDS_PAD_SOURCE, fmt->which);
+		*format = fmt->format;
+
+		uds_try_format(uds, fh, UDS_PAD_SOURCE, format, fmt->which);
+	}
+
+	if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE)
+		uds_compute_ratios(uds);
+
+	return 0;
+}
+
+/* -----------------------------------------------------------------------------
+ * V4L2 Subdevice Operations
+ */
+
+static struct v4l2_subdev_video_ops uds_video_ops = {
+	.s_stream = uds_s_stream,
+};
+
+static struct v4l2_subdev_pad_ops uds_pad_ops = {
+	.enum_mbus_code = uds_enum_mbus_code,
+	.enum_frame_size = uds_enum_frame_size,
+	.get_fmt = uds_get_format,
+	.set_fmt = uds_set_format,
+};
+
+static struct v4l2_subdev_ops uds_ops = {
+	.video	= &uds_video_ops,
+	.pad    = &uds_pad_ops,
+};
+
+/* -----------------------------------------------------------------------------
+ * Initialization and Cleanup
+ */
+
+struct vsp1_uds *vsp1_uds_create(struct vsp1_device *vsp1, unsigned int index)
+{
+	struct v4l2_subdev *subdev;
+	struct vsp1_uds *uds;
+	int ret;
+
+	uds = devm_kzalloc(vsp1->dev, sizeof(*uds), GFP_KERNEL);
+	if (uds == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	uds->entity.type = VSP1_ENTITY_UDS;
+	uds->entity.index = index;
+	uds->entity.id = VI6_DPR_NODE_UDS(index);
+
+	ret = vsp1_entity_init(vsp1, &uds->entity, 2);
+	if (ret < 0)
+		return ERR_PTR(ret);
+
+	/* Initialize the V4L2 subdev. */
+	subdev = &uds->entity.subdev;
+	v4l2_subdev_init(subdev, &uds_ops);
+
+	subdev->entity.ops = &vsp1_media_ops;
+	subdev->internal_ops = &vsp1_subdev_internal_ops;
+	snprintf(subdev->name, sizeof(subdev->name), "%s uds.%u",
+		 dev_name(vsp1->dev), index);
+	v4l2_set_subdevdata(subdev, uds);
+	subdev->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+
+	vsp1_entity_init_formats(subdev, NULL);
+
+	return uds;
+}
diff --git a/drivers/media/platform/vsp1/vsp1_uds.h b/drivers/media/platform/vsp1/vsp1_uds.h
new file mode 100644
index 0000000..972a285
--- /dev/null
+++ b/drivers/media/platform/vsp1/vsp1_uds.h
@@ -0,0 +1,40 @@
+/*
+ * vsp1_uds.h  --  R-Car VSP1 Up and Down Scaler
+ *
+ * Copyright (C) 2013 Renesas Corporation
+ *
+ * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#ifndef __VSP1_UDS_H__
+#define __VSP1_UDS_H__
+
+#include <media/media-entity.h>
+#include <media/v4l2-subdev.h>
+
+#include "vsp1_entity.h"
+
+struct vsp1_device;
+
+#define UDS_PAD_SINK				0
+#define UDS_PAD_SOURCE				1
+
+struct vsp1_uds {
+	struct vsp1_entity entity;
+
+	unsigned int hscale;
+	unsigned int vscale;
+};
+
+static inline struct vsp1_uds *to_uds(struct v4l2_subdev *subdev)
+{
+	return container_of(subdev, struct vsp1_uds, entity.subdev);
+}
+
+struct vsp1_uds *vsp1_uds_create(struct vsp1_device *vsp1, unsigned int index);
+
+#endif /* __VSP1_UDS_H__ */
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
new file mode 100644
index 0000000..0fa01b2
--- /dev/null
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -0,0 +1,1135 @@
+/*
+ * vsp1_video.c  --  R-Car VSP1 Video Node
+ *
+ * Copyright (C) 2013 Renesas Corporation
+ *
+ * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/v4l2-mediabus.h>
+#include <linux/videodev2.h>
+
+#include <media/media-entity.h>
+#include <media/v4l2-dev.h>
+#include <media/v4l2-fh.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-subdev.h>
+#include <media/videobuf2-core.h>
+#include <media/videobuf2-dma-contig.h>
+
+#include "vsp1.h"
+#include "vsp1_entity.h"
+#include "vsp1_rwpf.h"
+#include "vsp1_video.h"
+
+#define VSP1_VIDEO_DEF_FORMAT		V4L2_PIX_FMT_YUYV
+#define VSP1_VIDEO_DEF_WIDTH		1024
+#define VSP1_VIDEO_DEF_HEIGHT		768
+
+#define VSP1_VIDEO_MIN_WIDTH		2U
+#define VSP1_VIDEO_MAX_WIDTH		8190U
+#define VSP1_VIDEO_MIN_HEIGHT		2U
+#define VSP1_VIDEO_MAX_HEIGHT		8190U
+
+/* -----------------------------------------------------------------------------
+ * Helper functions
+ */
+
+static const struct vsp1_format_info vsp1_video_formats[] = {
+	{ V4L2_PIX_FMT_RGB332, V4L2_MBUS_FMT_ARGB8888_1X32,
+	  VI6_FMT_RGB_332, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
+	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
+	  1, { 8, 0, 0 }, false, false, 1, 1 },
+	{ V4L2_PIX_FMT_RGB444, V4L2_MBUS_FMT_ARGB8888_1X32,
+	  VI6_FMT_XRGB_4444, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
+	  VI6_RPF_DSWAP_P_WDS,
+	  1, { 16, 0, 0 }, false, false, 1, 1 },
+	{ V4L2_PIX_FMT_RGB555, V4L2_MBUS_FMT_ARGB8888_1X32,
+	  VI6_FMT_XRGB_1555, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
+	  VI6_RPF_DSWAP_P_WDS,
+	  1, { 16, 0, 0 }, false, false, 1, 1 },
+	{ V4L2_PIX_FMT_RGB565, V4L2_MBUS_FMT_ARGB8888_1X32,
+	  VI6_FMT_RGB_565, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
+	  VI6_RPF_DSWAP_P_WDS,
+	  1, { 16, 0, 0 }, false, false, 1, 1 },
+	{ V4L2_PIX_FMT_BGR24, V4L2_MBUS_FMT_ARGB8888_1X32,
+	  VI6_FMT_BGR_888, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
+	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
+	  1, { 24, 0, 0 }, false, false, 1, 1 },
+	{ V4L2_PIX_FMT_RGB24, V4L2_MBUS_FMT_ARGB8888_1X32,
+	  VI6_FMT_RGB_888, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
+	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
+	  1, { 24, 0, 0 }, false, false, 1, 1 },
+	{ V4L2_PIX_FMT_BGR32, V4L2_MBUS_FMT_ARGB8888_1X32,
+	  VI6_FMT_ARGB_8888, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS,
+	  1, { 32, 0, 0 }, false, false, 1, 1 },
+	{ V4L2_PIX_FMT_RGB32, V4L2_MBUS_FMT_ARGB8888_1X32,
+	  VI6_FMT_ARGB_8888, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
+	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
+	  1, { 32, 0, 0 }, false, false, 1, 1 },
+	{ V4L2_PIX_FMT_UYVY, V4L2_MBUS_FMT_AYUV8_1X32,
+	  VI6_FMT_YUYV_422, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
+	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
+	  1, { 16, 0, 0 }, false, false, 2, 1 },
+	{ V4L2_PIX_FMT_VYUY, V4L2_MBUS_FMT_AYUV8_1X32,
+	  VI6_FMT_YUYV_422, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
+	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
+	  1, { 16, 0, 0 }, false, true, 2, 1 },
+	{ V4L2_PIX_FMT_YUYV, V4L2_MBUS_FMT_AYUV8_1X32,
+	  VI6_FMT_YUYV_422, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
+	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
+	  1, { 16, 0, 0 }, true, false, 2, 1 },
+	{ V4L2_PIX_FMT_YVYU, V4L2_MBUS_FMT_AYUV8_1X32,
+	  VI6_FMT_YUYV_422, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
+	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
+	  1, { 16, 0, 0 }, true, true, 2, 1 },
+	{ V4L2_PIX_FMT_NV12M, V4L2_MBUS_FMT_AYUV8_1X32,
+	  VI6_FMT_Y_UV_420, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
+	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
+	  2, { 8, 16, 0 }, false, false, 2, 2 },
+	{ V4L2_PIX_FMT_NV21M, V4L2_MBUS_FMT_AYUV8_1X32,
+	  VI6_FMT_Y_UV_420, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
+	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
+	  2, { 8, 16, 0 }, false, true, 2, 2 },
+	{ V4L2_PIX_FMT_NV16M, V4L2_MBUS_FMT_AYUV8_1X32,
+	  VI6_FMT_Y_UV_422, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
+	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
+	  2, { 8, 16, 0 }, false, false, 2, 1 },
+	{ V4L2_PIX_FMT_NV61M, V4L2_MBUS_FMT_AYUV8_1X32,
+	  VI6_FMT_Y_UV_422, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
+	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
+	  2, { 8, 16, 0 }, false, true, 2, 1 },
+	{ V4L2_PIX_FMT_YUV420M, V4L2_MBUS_FMT_AYUV8_1X32,
+	  VI6_FMT_Y_U_V_420, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
+	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
+	  3, { 8, 8, 8 }, false, false, 2, 2 },
+};
+
+/*
+ * vsp1_get_format_info - Retrieve format information for a 4CC
+ * @fourcc: the format 4CC
+ *
+ * Return a pointer to the format information structure corresponding to the
+ * given V4L2 format 4CC, or NULL if no corresponding format can be found.
+ */
+static const struct vsp1_format_info *vsp1_get_format_info(u32 fourcc)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(vsp1_video_formats); ++i) {
+		const struct vsp1_format_info *info = &vsp1_video_formats[i];
+
+		if (info->fourcc == fourcc)
+			return info;
+	}
+
+	return NULL;
+}
+
+
+static struct v4l2_subdev *
+vsp1_video_remote_subdev(struct media_pad *local, u32 *pad)
+{
+	struct media_pad *remote;
+
+	remote = media_entity_remote_pad(local);
+	if (remote == NULL ||
+	    media_entity_type(remote->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
+		return NULL;
+
+	if (pad)
+		*pad = remote->index;
+
+	return media_entity_to_v4l2_subdev(remote->entity);
+}
+
+static int vsp1_video_verify_format(struct vsp1_video *video)
+{
+	struct v4l2_subdev_format fmt;
+	struct v4l2_subdev *subdev;
+	int ret;
+
+	subdev = vsp1_video_remote_subdev(&video->pad, &fmt.pad);
+	if (subdev == NULL)
+		return -EINVAL;
+
+	fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+	ret = v4l2_subdev_call(subdev, pad, get_fmt, NULL, &fmt);
+	if (ret < 0)
+		return ret == -ENOIOCTLCMD ? -EINVAL : ret;
+
+	if (video->fmtinfo->mbus != fmt.format.code ||
+	    video->format.height != fmt.format.height ||
+	    video->format.width != fmt.format.width)
+		return -EINVAL;
+
+	return 0;
+}
+
+/* -----------------------------------------------------------------------------
+ * Pipeline Management
+ */
+
+static int vsp1_pipeline_validate_branch(struct vsp1_rwpf *input,
+					 struct vsp1_rwpf *output)
+{
+	struct vsp1_entity *entity;
+	unsigned int entities = 0;
+	struct media_pad *pad;
+	bool uds_found = false;
+
+	pad = media_entity_remote_pad(&input->entity.pads[RWPF_PAD_SOURCE]);
+
+	while (1) {
+		if (pad == NULL)
+			return -EPIPE;
+
+		/* We've reached a video node, that shouldn't have happened. */
+		if (media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
+			return -EPIPE;
+
+		entity = to_vsp1_entity(media_entity_to_v4l2_subdev(pad->entity));
+
+		/* We've reached the WPF, we're done. */
+		if (entity->type == VSP1_ENTITY_WPF)
+			break;
+
+		/* Ensure the branch has no loop. */
+		if (entities & (1 << entity->subdev.entity.id))
+			return -EPIPE;
+
+		entities |= 1 << entity->subdev.entity.id;
+
+		/* UDS can't be chained. */
+		if (entity->type == VSP1_ENTITY_UDS) {
+			if (uds_found)
+				return -EPIPE;
+			uds_found = true;
+		}
+
+		/* Follow the source link. The link setup operations ensure
+		 * that the output fan-out can't be more than one, there is thus
+		 * no need to verify here that only a single source link is
+		 * activated.
+		 */
+		pad = &entity->pads[entity->source_pad];
+		pad = media_entity_remote_pad(pad);
+	}
+
+	/* The last entity must be the output WPF. */
+	if (entity != &output->entity)
+		return -EPIPE;
+
+	return 0;
+}
+
+static int vsp1_pipeline_validate(struct vsp1_pipeline *pipe,
+				  struct vsp1_video *video)
+{
+	struct media_entity_graph graph;
+	struct media_entity *entity = &video->video.entity;
+	struct media_device *mdev = entity->parent;
+	unsigned int i;
+	int ret;
+
+	mutex_lock(&mdev->graph_mutex);
+
+	/* Walk the graph to locate the entities and video nodes. */
+	media_entity_graph_walk_start(&graph, entity);
+
+	while ((entity = media_entity_graph_walk_next(&graph))) {
+		struct v4l2_subdev *subdev;
+		struct vsp1_rwpf *rwpf;
+		struct vsp1_entity *e;
+
+		if (media_entity_type(entity) != MEDIA_ENT_T_V4L2_SUBDEV) {
+			pipe->num_video++;
+			continue;
+		}
+
+		subdev = media_entity_to_v4l2_subdev(entity);
+		e = to_vsp1_entity(subdev);
+		list_add_tail(&e->list_pipe, &pipe->entities);
+
+		if (e->type == VSP1_ENTITY_RPF) {
+			rwpf = to_rwpf(subdev);
+			pipe->inputs[pipe->num_inputs++] = rwpf;
+			rwpf->video.pipe_index = pipe->num_inputs;
+		} else if (e->type == VSP1_ENTITY_WPF) {
+			rwpf = to_rwpf(subdev);
+			pipe->output = to_rwpf(subdev);
+			rwpf->video.pipe_index = 0;
+		} else if (e->type == VSP1_ENTITY_LIF) {
+			pipe->lif = e;
+		}
+	}
+
+	mutex_unlock(&mdev->graph_mutex);
+
+	/* We need one output and at least one input. */
+	if (pipe->num_inputs == 0 || !pipe->output) {
+		ret = -EPIPE;
+		goto error;
+	}
+
+	/* Follow links downstream for each input and make sure the graph
+	 * contains no loop and that all branches end at the output WPF.
+	 */
+	for (i = 0; i < pipe->num_inputs; ++i) {
+		ret = vsp1_pipeline_validate_branch(pipe->inputs[i],
+						    pipe->output);
+		if (ret < 0)
+			goto error;
+	}
+
+	return 0;
+
+error:
+	INIT_LIST_HEAD(&pipe->entities);
+	pipe->buffers_ready = 0;
+	pipe->num_video = 0;
+	pipe->num_inputs = 0;
+	pipe->output = NULL;
+	pipe->lif = NULL;
+	return ret;
+}
+
+static int vsp1_pipeline_init(struct vsp1_pipeline *pipe,
+			      struct vsp1_video *video)
+{
+	int ret;
+
+	mutex_lock(&pipe->lock);
+
+	/* If we're the first user validate and initialize the pipeline. */
+	if (pipe->use_count == 0) {
+		ret = vsp1_pipeline_validate(pipe, video);
+		if (ret < 0)
+			goto done;
+	}
+
+	pipe->use_count++;
+	ret = 0;
+
+done:
+	mutex_unlock(&pipe->lock);
+	return ret;
+}
+
+static void vsp1_pipeline_cleanup(struct vsp1_pipeline *pipe)
+{
+	mutex_lock(&pipe->lock);
+
+	/* If we're the last user clean up the pipeline. */
+	if (--pipe->use_count == 0) {
+		INIT_LIST_HEAD(&pipe->entities);
+		pipe->state = VSP1_PIPELINE_STOPPED;
+		pipe->buffers_ready = 0;
+		pipe->num_video = 0;
+		pipe->num_inputs = 0;
+		pipe->output = NULL;
+		pipe->lif = NULL;
+	}
+
+	mutex_unlock(&pipe->lock);
+}
+
+static void vsp1_pipeline_run(struct vsp1_pipeline *pipe)
+{
+	struct vsp1_device *vsp1 = pipe->output->entity.vsp1;
+
+	vsp1_write(vsp1, VI6_CMD(pipe->output->entity.index), VI6_CMD_STRCMD);
+	pipe->state = VSP1_PIPELINE_RUNNING;
+	pipe->buffers_ready = 0;
+}
+
+static int vsp1_pipeline_stop(struct vsp1_pipeline *pipe)
+{
+	struct vsp1_entity *entity;
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&pipe->irqlock, flags);
+	pipe->state = VSP1_PIPELINE_STOPPING;
+	spin_unlock_irqrestore(&pipe->irqlock, flags);
+
+	ret = wait_event_timeout(pipe->wq, pipe->state == VSP1_PIPELINE_STOPPED,
+				 msecs_to_jiffies(500));
+	ret = ret == 0 ? -ETIMEDOUT : 0;
+
+	list_for_each_entry(entity, &pipe->entities, list_pipe) {
+		if (entity->route)
+			vsp1_write(entity->vsp1, entity->route,
+				   VI6_DPR_NODE_UNUSED);
+
+		v4l2_subdev_call(&entity->subdev, video, s_stream, 0);
+	}
+
+	return ret;
+}
+
+static bool vsp1_pipeline_ready(struct vsp1_pipeline *pipe)
+{
+	unsigned int mask;
+
+	mask = ((1 << pipe->num_inputs) - 1) << 1;
+	if (!pipe->lif)
+		mask |= 1 << 0;
+
+	return pipe->buffers_ready == mask;
+}
+
+/*
+ * vsp1_video_complete_buffer - Complete the current buffer
+ * @video: the video node
+ *
+ * This function completes the current buffer by filling its sequence number,
+ * time stamp and payload size, and hands it back to the videobuf core.
+ *
+ * Return the next queued buffer or NULL if the queue is empty.
+ */
+static struct vsp1_video_buffer *
+vsp1_video_complete_buffer(struct vsp1_video *video)
+{
+	struct vsp1_video_buffer *next = NULL;
+	struct vsp1_video_buffer *done;
+	unsigned long flags;
+	unsigned int i;
+
+	spin_lock_irqsave(&video->irqlock, flags);
+
+	if (list_empty(&video->irqqueue)) {
+		spin_unlock_irqrestore(&video->irqlock, flags);
+		return NULL;
+	}
+
+	done = list_first_entry(&video->irqqueue,
+				struct vsp1_video_buffer, queue);
+	list_del(&done->queue);
+
+	if (!list_empty(&video->irqqueue))
+		next = list_first_entry(&video->irqqueue,
+					struct vsp1_video_buffer, queue);
+
+	spin_unlock_irqrestore(&video->irqlock, flags);
+
+	done->buf.v4l2_buf.sequence = video->sequence++;
+	v4l2_get_timestamp(&done->buf.v4l2_buf.timestamp);
+	for (i = 0; i < done->buf.num_planes; ++i)
+		vb2_set_plane_payload(&done->buf, i, done->length[i]);
+	vb2_buffer_done(&done->buf, VB2_BUF_STATE_DONE);
+
+	return next;
+}
+
+static void vsp1_video_frame_end(struct vsp1_pipeline *pipe,
+				 struct vsp1_video *video)
+{
+	struct vsp1_video_buffer *buf;
+	unsigned long flags;
+
+	buf = vsp1_video_complete_buffer(video);
+	if (buf == NULL)
+		return;
+
+	spin_lock_irqsave(&pipe->irqlock, flags);
+
+	video->ops->queue(video, buf);
+	pipe->buffers_ready |= 1 << video->pipe_index;
+
+	spin_unlock_irqrestore(&pipe->irqlock, flags);
+}
+
+void vsp1_pipeline_frame_end(struct vsp1_pipeline *pipe)
+{
+	unsigned long flags;
+	unsigned int i;
+
+	if (pipe == NULL)
+		return;
+
+	/* Complete buffers on all video nodes. */
+	for (i = 0; i < pipe->num_inputs; ++i)
+		vsp1_video_frame_end(pipe, &pipe->inputs[i]->video);
+
+	if (!pipe->lif)
+		vsp1_video_frame_end(pipe, &pipe->output->video);
+
+	spin_lock_irqsave(&pipe->irqlock, flags);
+
+	/* If a stop has been requested, mark the pipeline as stopped and
+	 * return.
+	 */
+	if (pipe->state == VSP1_PIPELINE_STOPPING) {
+		pipe->state = VSP1_PIPELINE_STOPPED;
+		wake_up(&pipe->wq);
+		goto done;
+	}
+
+	/* Restart the pipeline if ready. */
+	if (vsp1_pipeline_ready(pipe))
+		vsp1_pipeline_run(pipe);
+
+done:
+	spin_unlock_irqrestore(&pipe->irqlock, flags);
+}
+
+/* -----------------------------------------------------------------------------
+ * videobuf2 Queue Operations
+ */
+
+static int
+vsp1_video_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+		     unsigned int *nbuffers, unsigned int *nplanes,
+		     unsigned int sizes[], void *alloc_ctxs[])
+{
+	struct vsp1_video *video = vb2_get_drv_priv(vq);
+	struct v4l2_pix_format_mplane *format = &video->format;
+	unsigned int i;
+
+	*nplanes = format->num_planes;
+
+	for (i = 0; i < format->num_planes; ++i) {
+		sizes[i] = format->plane_fmt[i].sizeimage;
+		alloc_ctxs[i] = video->alloc_ctx;
+	}
+
+	return 0;
+}
+
+static int vsp1_video_buffer_prepare(struct vb2_buffer *vb)
+{
+	struct vsp1_video *video = vb2_get_drv_priv(vb->vb2_queue);
+	struct vsp1_video_buffer *buf = to_vsp1_video_buffer(vb);
+	unsigned int i;
+
+	buf->video = video;
+
+	for (i = 0; i < vb->num_planes; ++i) {
+		buf->addr[i] = vb2_dma_contig_plane_dma_addr(vb, i);
+		buf->length[i] = vb2_plane_size(vb, i);
+	}
+
+	return 0;
+}
+
+static void vsp1_video_buffer_queue(struct vb2_buffer *vb)
+{
+	struct vsp1_video *video = vb2_get_drv_priv(vb->vb2_queue);
+	struct vsp1_pipeline *pipe = to_vsp1_pipeline(&video->video.entity);
+	struct vsp1_video_buffer *buf = to_vsp1_video_buffer(vb);
+	unsigned long flags;
+	bool empty;
+
+	spin_lock_irqsave(&video->irqlock, flags);
+	empty = list_empty(&video->irqqueue);
+	list_add_tail(&buf->queue, &video->irqqueue);
+	spin_unlock_irqrestore(&video->irqlock, flags);
+
+	if (!empty)
+		return;
+
+	spin_lock_irqsave(&pipe->irqlock, flags);
+
+	video->ops->queue(video, buf);
+	pipe->buffers_ready |= 1 << video->pipe_index;
+
+	if (vb2_is_streaming(&video->queue) &&
+	    vsp1_pipeline_ready(pipe))
+		vsp1_pipeline_run(pipe);
+
+	spin_unlock_irqrestore(&pipe->irqlock, flags);
+}
+
+static void vsp1_video_wait_prepare(struct vb2_queue *vq)
+{
+	struct vsp1_video *video = vb2_get_drv_priv(vq);
+
+	mutex_unlock(&video->lock);
+}
+
+static void vsp1_video_wait_finish(struct vb2_queue *vq)
+{
+	struct vsp1_video *video = vb2_get_drv_priv(vq);
+
+	mutex_lock(&video->lock);
+}
+
+static void vsp1_entity_route_setup(struct vsp1_entity *source)
+{
+	struct vsp1_entity *sink;
+
+	if (source->route == 0)
+		return;
+
+	sink = container_of(source->sink, struct vsp1_entity, subdev.entity);
+	vsp1_write(source->vsp1, source->route, sink->id);
+}
+
+static int vsp1_video_start_streaming(struct vb2_queue *vq, unsigned int count)
+{
+	struct vsp1_video *video = vb2_get_drv_priv(vq);
+	struct vsp1_pipeline *pipe = to_vsp1_pipeline(&video->video.entity);
+	struct vsp1_entity *entity;
+	unsigned long flags;
+	int ret;
+
+	mutex_lock(&pipe->lock);
+	if (pipe->stream_count == pipe->num_video - 1) {
+		list_for_each_entry(entity, &pipe->entities, list_pipe) {
+			vsp1_entity_route_setup(entity);
+
+			ret = v4l2_subdev_call(&entity->subdev, video,
+					       s_stream, 1);
+			if (ret < 0) {
+				mutex_unlock(&pipe->lock);
+				return ret;
+			}
+		}
+	}
+
+	pipe->stream_count++;
+	mutex_unlock(&pipe->lock);
+
+	spin_lock_irqsave(&pipe->irqlock, flags);
+	if (vsp1_pipeline_ready(pipe))
+		vsp1_pipeline_run(pipe);
+	spin_unlock_irqrestore(&pipe->irqlock, flags);
+
+	return 0;
+}
+
+static int vsp1_video_stop_streaming(struct vb2_queue *vq)
+{
+	struct vsp1_video *video = vb2_get_drv_priv(vq);
+	struct vsp1_pipeline *pipe = to_vsp1_pipeline(&video->video.entity);
+	unsigned long flags;
+	int ret;
+
+	mutex_lock(&pipe->lock);
+	if (--pipe->stream_count == 0) {
+		/* Stop the pipeline. */
+		ret = vsp1_pipeline_stop(pipe);
+		if (ret == -ETIMEDOUT)
+			dev_err(video->vsp1->dev, "pipeline stop timeout\n");
+	}
+	mutex_unlock(&pipe->lock);
+
+	vsp1_pipeline_cleanup(pipe);
+	media_entity_pipeline_stop(&video->video.entity);
+
+	/* Remove all buffers from the IRQ queue. */
+	spin_lock_irqsave(&video->irqlock, flags);
+	INIT_LIST_HEAD(&video->irqqueue);
+	spin_unlock_irqrestore(&video->irqlock, flags);
+
+	return 0;
+}
+
+static struct vb2_ops vsp1_video_queue_qops = {
+	.queue_setup = vsp1_video_queue_setup,
+	.buf_prepare = vsp1_video_buffer_prepare,
+	.buf_queue = vsp1_video_buffer_queue,
+	.wait_prepare = vsp1_video_wait_prepare,
+	.wait_finish = vsp1_video_wait_finish,
+	.start_streaming = vsp1_video_start_streaming,
+	.stop_streaming = vsp1_video_stop_streaming,
+};
+
+/* -----------------------------------------------------------------------------
+ * V4L2 ioctls
+ */
+
+static int
+vsp1_video_querycap(struct file *file, void *fh, struct v4l2_capability *cap)
+{
+	struct v4l2_fh *vfh = file->private_data;
+	struct vsp1_video *video = to_vsp1_video(vfh->vdev);
+
+	cap->capabilities = V4L2_CAP_DEVICE_CAPS | V4L2_CAP_STREAMING
+			  | V4L2_CAP_VIDEO_CAPTURE_MPLANE
+			  | V4L2_CAP_VIDEO_OUTPUT_MPLANE;
+
+	if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		cap->device_caps = V4L2_CAP_VIDEO_CAPTURE_MPLANE
+				 | V4L2_CAP_STREAMING;
+	else
+		cap->device_caps = V4L2_CAP_VIDEO_OUTPUT_MPLANE
+				 | V4L2_CAP_STREAMING;
+
+	strlcpy(cap->driver, "vsp1", sizeof(cap->driver));
+	strlcpy(cap->card, video->video.name, sizeof(cap->card));
+	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
+		 dev_name(video->vsp1->dev));
+
+	return 0;
+}
+
+static int
+vsp1_video_get_format(struct file *file, void *fh, struct v4l2_format *format)
+{
+	struct v4l2_fh *vfh = file->private_data;
+	struct vsp1_video *video = to_vsp1_video(vfh->vdev);
+
+	if (format->type != video->queue.type)
+		return -EINVAL;
+
+	mutex_lock(&video->lock);
+	format->fmt.pix_mp = video->format;
+	mutex_unlock(&video->lock);
+
+	return 0;
+}
+
+static int __vsp1_video_try_format(struct vsp1_video *video,
+				   struct v4l2_pix_format_mplane *pix,
+				   const struct vsp1_format_info **fmtinfo)
+{
+	const struct vsp1_format_info *info;
+	unsigned int width = pix->width;
+	unsigned int height = pix->height;
+	unsigned int i;
+
+	/* Retrieve format information and select the default format if the
+	 * requested format isn't supported.
+	 */
+	info = vsp1_get_format_info(pix->pixelformat);
+	if (info == NULL)
+		info = vsp1_get_format_info(VSP1_VIDEO_DEF_FORMAT);
+
+	pix->pixelformat = info->fourcc;
+	pix->colorspace = V4L2_COLORSPACE_SRGB;
+	pix->field = V4L2_FIELD_NONE;
+	memset(pix->reserved, 0, sizeof(pix->reserved));
+
+	/* Align the width and height for YUV 4:2:2 and 4:2:0 formats. */
+	width = round_down(width, info->hsub);
+	height = round_down(height, info->vsub);
+
+	/* Clamp the width and height. */
+	pix->width = clamp(width, VSP1_VIDEO_MIN_WIDTH, VSP1_VIDEO_MAX_WIDTH);
+	pix->height = clamp(height, VSP1_VIDEO_MIN_HEIGHT,
+			    VSP1_VIDEO_MAX_HEIGHT);
+
+	/* Compute and clamp the stride and image size. While not documented in
+	 * the datasheet, strides not aligned to a multiple of 128 bytes result
+	 * in image corruption.
+	 */
+	for (i = 0; i < max(info->planes, 2U); ++i) {
+		unsigned int hsub = i > 0 ? info->hsub : 1;
+		unsigned int vsub = i > 0 ? info->vsub : 1;
+		unsigned int align = 128;
+		unsigned int bpl;
+
+		bpl = clamp_t(unsigned int, pix->plane_fmt[i].bytesperline,
+			      pix->width / hsub * info->bpp[i] / 8,
+			      round_down(65535U, align));
+
+		pix->plane_fmt[i].bytesperline = round_up(bpl, align);
+		pix->plane_fmt[i].sizeimage = pix->plane_fmt[i].bytesperline
+					    * pix->height / vsub;
+	}
+
+	if (info->planes == 3) {
+		/* The second and third planes must have the same stride. */
+		pix->plane_fmt[2].bytesperline = pix->plane_fmt[1].bytesperline;
+		pix->plane_fmt[2].sizeimage = pix->plane_fmt[1].sizeimage;
+	}
+
+	pix->num_planes = info->planes;
+
+	if (fmtinfo)
+		*fmtinfo = info;
+
+	return 0;
+}
+
+static int
+vsp1_video_try_format(struct file *file, void *fh, struct v4l2_format *format)
+{
+	struct v4l2_fh *vfh = file->private_data;
+	struct vsp1_video *video = to_vsp1_video(vfh->vdev);
+
+	if (format->type != video->queue.type)
+		return -EINVAL;
+
+	return __vsp1_video_try_format(video, &format->fmt.pix_mp, NULL);
+}
+
+static int
+vsp1_video_set_format(struct file *file, void *fh, struct v4l2_format *format)
+{
+	struct v4l2_fh *vfh = file->private_data;
+	struct vsp1_video *video = to_vsp1_video(vfh->vdev);
+	const struct vsp1_format_info *info;
+	int ret;
+
+	if (format->type != video->queue.type)
+		return -EINVAL;
+
+	ret = __vsp1_video_try_format(video, &format->fmt.pix_mp, &info);
+	if (ret < 0)
+		return ret;
+
+	mutex_lock(&video->lock);
+
+	if (vb2_is_busy(&video->queue)) {
+		ret = -EBUSY;
+		goto done;
+	}
+
+	video->format = format->fmt.pix_mp;
+	video->fmtinfo = info;
+
+done:
+	mutex_unlock(&video->lock);
+	return ret;
+}
+
+static int
+vsp1_video_reqbufs(struct file *file, void *fh, struct v4l2_requestbuffers *rb)
+{
+	struct v4l2_fh *vfh = file->private_data;
+	struct vsp1_video *video = to_vsp1_video(vfh->vdev);
+	int ret;
+
+	mutex_lock(&video->lock);
+	ret = vb2_ioctl_reqbufs(file, fh, rb);
+	mutex_unlock(&video->lock);
+
+	return ret;
+}
+
+static int
+vsp1_video_querybuf(struct file *file, void *fh, struct v4l2_buffer *buf)
+{
+	struct v4l2_fh *vfh = file->private_data;
+	struct vsp1_video *video = to_vsp1_video(vfh->vdev);
+	int ret;
+
+	mutex_lock(&video->lock);
+	ret = vb2_querybuf(&video->queue, buf);
+	mutex_unlock(&video->lock);
+
+	return ret;
+}
+
+static int
+vsp1_video_qbuf(struct file *file, void *fh, struct v4l2_buffer *buf)
+{
+	struct v4l2_fh *vfh = file->private_data;
+	struct vsp1_video *video = to_vsp1_video(vfh->vdev);
+	int ret;
+
+	mutex_lock(&video->lock);
+	ret = vb2_ioctl_qbuf(file, fh, buf);
+	mutex_unlock(&video->lock);
+
+	return ret;
+}
+
+static int
+vsp1_video_dqbuf(struct file *file, void *fh, struct v4l2_buffer *buf)
+{
+	struct v4l2_fh *vfh = file->private_data;
+	struct vsp1_video *video = to_vsp1_video(vfh->vdev);
+	int ret;
+
+	mutex_lock(&video->lock);
+	ret = vb2_ioctl_dqbuf(file, fh, buf);
+	mutex_unlock(&video->lock);
+
+	return ret;
+}
+
+static int
+vsp1_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
+{
+	struct v4l2_fh *vfh = file->private_data;
+	struct vsp1_video *video = to_vsp1_video(vfh->vdev);
+	struct vsp1_pipeline *pipe;
+	int ret;
+
+	mutex_lock(&video->lock);
+
+	if (video->queue.owner && video->queue.owner != file->private_data) {
+		ret = -EBUSY;
+		goto err_unlock;
+	}
+
+	video->sequence = 0;
+
+	/* Start streaming on the pipeline. No link touching an entity in the
+	 * pipeline can be activated or deactivated once streaming is started.
+	 *
+	 * Use the VSP1 pipeline object embedded in the first video object that
+	 * starts streaming.
+	 */
+	pipe = video->video.entity.pipe
+	     ? to_vsp1_pipeline(&video->video.entity) : &video->pipe;
+
+	ret = media_entity_pipeline_start(&video->video.entity, &pipe->pipe);
+	if (ret < 0)
+		goto err_unlock;
+
+	/* Verify that the configured format matches the output of the connected
+	 * subdev.
+	 */
+	ret = vsp1_video_verify_format(video);
+	if (ret < 0)
+		goto err_stop;
+
+	ret = vsp1_pipeline_init(pipe, video);
+	if (ret < 0)
+		goto err_stop;
+
+	/* Start the queue. */
+	ret = vb2_streamon(&video->queue, type);
+	if (ret < 0)
+		goto err_cleanup;
+
+	mutex_unlock(&video->lock);
+	return 0;
+
+err_cleanup:
+	vsp1_pipeline_cleanup(pipe);
+err_stop:
+	media_entity_pipeline_stop(&video->video.entity);
+err_unlock:
+	mutex_unlock(&video->lock);
+	return ret;
+
+}
+
+static int
+vsp1_video_streamoff(struct file *file, void *fh, enum v4l2_buf_type type)
+{
+	struct v4l2_fh *vfh = file->private_data;
+	struct vsp1_video *video = to_vsp1_video(vfh->vdev);
+	int ret;
+
+	mutex_lock(&video->lock);
+	ret = vb2_ioctl_streamoff(file, fh, type);
+	mutex_unlock(&video->lock);
+
+	return ret;
+}
+
+static const struct v4l2_ioctl_ops vsp1_video_ioctl_ops = {
+	.vidioc_querycap		= vsp1_video_querycap,
+	.vidioc_g_fmt_vid_cap_mplane	= vsp1_video_get_format,
+	.vidioc_s_fmt_vid_cap_mplane	= vsp1_video_set_format,
+	.vidioc_try_fmt_vid_cap_mplane	= vsp1_video_try_format,
+	.vidioc_g_fmt_vid_out_mplane	= vsp1_video_get_format,
+	.vidioc_s_fmt_vid_out_mplane	= vsp1_video_set_format,
+	.vidioc_try_fmt_vid_out_mplane	= vsp1_video_try_format,
+	.vidioc_reqbufs			= vsp1_video_reqbufs,
+	.vidioc_querybuf		= vsp1_video_querybuf,
+	.vidioc_qbuf			= vsp1_video_qbuf,
+	.vidioc_dqbuf			= vsp1_video_dqbuf,
+	.vidioc_streamon		= vsp1_video_streamon,
+	.vidioc_streamoff		= vsp1_video_streamoff,
+};
+
+/* -----------------------------------------------------------------------------
+ * V4L2 File Operations
+ */
+
+static int vsp1_video_open(struct file *file)
+{
+	struct vsp1_video *video = video_drvdata(file);
+	struct v4l2_fh *vfh;
+	int ret = 0;
+
+	vfh = kzalloc(sizeof(*vfh), GFP_KERNEL);
+	if (vfh == NULL)
+		return -ENOMEM;
+
+	v4l2_fh_init(vfh, &video->video);
+	v4l2_fh_add(vfh);
+
+	file->private_data = vfh;
+
+	if (!vsp1_device_get(video->vsp1)) {
+		ret = -EBUSY;
+		v4l2_fh_del(vfh);
+		kfree(vfh);
+	}
+
+	return ret;
+}
+
+static int vsp1_video_release(struct file *file)
+{
+	struct vsp1_video *video = video_drvdata(file);
+	struct v4l2_fh *vfh = file->private_data;
+
+	mutex_lock(&video->lock);
+	if (video->queue.owner == vfh) {
+		vb2_queue_release(&video->queue);
+		video->queue.owner = NULL;
+	}
+	mutex_unlock(&video->lock);
+
+	vsp1_device_put(video->vsp1);
+
+	v4l2_fh_release(file);
+
+	file->private_data = NULL;
+
+	return 0;
+}
+
+static unsigned int vsp1_video_poll(struct file *file, poll_table *wait)
+{
+	struct v4l2_fh *vfh = file->private_data;
+	struct vsp1_video *video = to_vsp1_video(vfh->vdev);
+	int ret;
+
+	mutex_lock(&video->lock);
+	ret = vb2_poll(&video->queue, file, wait);
+	mutex_unlock(&video->lock);
+
+	return ret;
+}
+
+static int vsp1_video_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct v4l2_fh *vfh = file->private_data;
+	struct vsp1_video *video = to_vsp1_video(vfh->vdev);
+	int ret;
+
+	mutex_lock(&video->lock);
+	ret = vb2_mmap(&video->queue, vma);
+	mutex_unlock(&video->lock);
+
+	return ret;
+}
+
+static struct v4l2_file_operations vsp1_video_fops = {
+	.owner = THIS_MODULE,
+	.unlocked_ioctl = video_ioctl2,
+	.open = vsp1_video_open,
+	.release = vsp1_video_release,
+	.poll = vsp1_video_poll,
+	.mmap = vsp1_video_mmap,
+};
+
+/* -----------------------------------------------------------------------------
+ * Initialization and Cleanup
+ */
+
+int vsp1_video_init(struct vsp1_video *video, struct vsp1_entity *rwpf)
+{
+	const char *direction;
+	int ret;
+
+	switch (video->type) {
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
+		direction = "output";
+		video->pad.flags = MEDIA_PAD_FL_SINK;
+		break;
+
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
+		direction = "input";
+		video->pad.flags = MEDIA_PAD_FL_SOURCE;
+		video->video.vfl_dir = VFL_DIR_TX;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	video->rwpf = rwpf;
+
+	mutex_init(&video->lock);
+	spin_lock_init(&video->irqlock);
+	INIT_LIST_HEAD(&video->irqqueue);
+
+	mutex_init(&video->pipe.lock);
+	spin_lock_init(&video->pipe.irqlock);
+	INIT_LIST_HEAD(&video->pipe.entities);
+	init_waitqueue_head(&video->pipe.wq);
+	video->pipe.state = VSP1_PIPELINE_STOPPED;
+
+	/* Initialize the media entity... */
+	ret = media_entity_init(&video->video.entity, 1, &video->pad, 0);
+	if (ret < 0)
+		return ret;
+
+	/* ... and the format ... */
+	video->fmtinfo = vsp1_get_format_info(VSP1_VIDEO_DEF_FORMAT);
+	video->format.pixelformat = video->fmtinfo->fourcc;
+	video->format.colorspace = V4L2_COLORSPACE_SRGB;
+	video->format.field = V4L2_FIELD_NONE;
+	video->format.width = VSP1_VIDEO_DEF_WIDTH;
+	video->format.height = VSP1_VIDEO_DEF_HEIGHT;
+	video->format.num_planes = 1;
+	video->format.plane_fmt[0].bytesperline =
+		video->format.width * video->fmtinfo->bpp[0] / 8;
+	video->format.plane_fmt[0].sizeimage =
+		video->format.plane_fmt[0].bytesperline * video->format.height;
+
+	/* ... and the video node... */
+	video->video.v4l2_dev = &video->vsp1->v4l2_dev;
+	video->video.fops = &vsp1_video_fops;
+	snprintf(video->video.name, sizeof(video->video.name), "%s %s",
+		 rwpf->subdev.name, direction);
+	video->video.vfl_type = VFL_TYPE_GRABBER;
+	video->video.release = video_device_release_empty;
+	video->video.ioctl_ops = &vsp1_video_ioctl_ops;
+
+	video_set_drvdata(&video->video, video);
+
+	/* ... and the buffers queue... */
+	video->alloc_ctx = vb2_dma_contig_init_ctx(video->vsp1->dev);
+	if (IS_ERR(video->alloc_ctx))
+		goto error;
+
+	video->queue.type = video->type;
+	video->queue.io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
+	video->queue.drv_priv = video;
+	video->queue.buf_struct_size = sizeof(struct vsp1_video_buffer);
+	video->queue.ops = &vsp1_video_queue_qops;
+	video->queue.mem_ops = &vb2_dma_contig_memops;
+	video->queue.timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	ret = vb2_queue_init(&video->queue);
+	if (ret < 0) {
+		dev_err(video->vsp1->dev, "failed to initialize vb2 queue\n");
+		goto error;
+	}
+
+	/* ... and register the video device. */
+	video->video.queue = &video->queue;
+	ret = video_register_device(&video->video, VFL_TYPE_GRABBER, -1);
+	if (ret < 0) {
+		dev_err(video->vsp1->dev, "failed to register video device\n");
+		goto error;
+	}
+
+	return 0;
+
+error:
+	vb2_dma_contig_cleanup_ctx(video->alloc_ctx);
+	vsp1_video_cleanup(video);
+	return ret;
+}
+
+void vsp1_video_cleanup(struct vsp1_video *video)
+{
+	if (video_is_registered(&video->video))
+		video_unregister_device(&video->video);
+
+	vb2_dma_contig_cleanup_ctx(video->alloc_ctx);
+	media_entity_cleanup(&video->video.entity);
+}
diff --git a/drivers/media/platform/vsp1/vsp1_video.h b/drivers/media/platform/vsp1/vsp1_video.h
new file mode 100644
index 0000000..d8612a3
--- /dev/null
+++ b/drivers/media/platform/vsp1/vsp1_video.h
@@ -0,0 +1,144 @@
+/*
+ * vsp1_video.h  --  R-Car VSP1 Video Node
+ *
+ * Copyright (C) 2013 Renesas Corporation
+ *
+ * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#ifndef __VSP1_VIDEO_H__
+#define __VSP1_VIDEO_H__
+
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/wait.h>
+
+#include <media/media-entity.h>
+#include <media/videobuf2-core.h>
+
+struct vsp1_video;
+
+/*
+ * struct vsp1_format_info - VSP1 video format description
+ * @mbus: media bus format code
+ * @fourcc: V4L2 pixel format FCC identifier
+ * @planes: number of planes
+ * @bpp: bits per pixel
+ * @hwfmt: VSP1 hardware format
+ * @swap_yc: the Y and C components are swapped (Y comes before C)
+ * @swap_uv: the U and V components are swapped (V comes before U)
+ * @hsub: horizontal subsampling factor
+ * @vsub: vertical subsampling factor
+ */
+struct vsp1_format_info {
+	u32 fourcc;
+	unsigned int mbus;
+	unsigned int hwfmt;
+	unsigned int swap;
+	unsigned int planes;
+	unsigned int bpp[3];
+	bool swap_yc;
+	bool swap_uv;
+	unsigned int hsub;
+	unsigned int vsub;
+};
+
+enum vsp1_pipeline_state {
+	VSP1_PIPELINE_STOPPED,
+	VSP1_PIPELINE_RUNNING,
+	VSP1_PIPELINE_STOPPING,
+};
+
+/*
+ * struct vsp1_pipeline - A VSP1 hardware pipeline
+ * @media: the media pipeline
+ * @irqlock: protects the pipeline state
+ * @lock: protects the pipeline use count and stream count
+ */
+struct vsp1_pipeline {
+	struct media_pipeline pipe;
+
+	spinlock_t irqlock;
+	enum vsp1_pipeline_state state;
+	wait_queue_head_t wq;
+
+	struct mutex lock;
+	unsigned int use_count;
+	unsigned int stream_count;
+	unsigned int buffers_ready;
+
+	unsigned int num_video;
+	unsigned int num_inputs;
+	struct vsp1_rwpf *inputs[VPS1_MAX_RPF];
+	struct vsp1_rwpf *output;
+	struct vsp1_entity *lif;
+
+	struct list_head entities;
+};
+
+static inline struct vsp1_pipeline *to_vsp1_pipeline(struct media_entity *e)
+{
+	if (likely(e->pipe))
+		return container_of(e->pipe, struct vsp1_pipeline, pipe);
+	else
+		return NULL;
+}
+
+struct vsp1_video_buffer {
+	struct vsp1_video *video;
+	struct vb2_buffer buf;
+	struct list_head queue;
+
+	dma_addr_t addr[3];
+	unsigned int length[3];
+};
+
+static inline struct vsp1_video_buffer *
+to_vsp1_video_buffer(struct vb2_buffer *vb)
+{
+	return container_of(vb, struct vsp1_video_buffer, buf);
+}
+
+struct vsp1_video_operations {
+	void (*queue)(struct vsp1_video *video, struct vsp1_video_buffer *buf);
+};
+
+struct vsp1_video {
+	struct vsp1_device *vsp1;
+	struct vsp1_entity *rwpf;
+
+	const struct vsp1_video_operations *ops;
+
+	struct video_device video;
+	enum v4l2_buf_type type;
+	struct media_pad pad;
+
+	struct mutex lock;
+	struct v4l2_pix_format_mplane format;
+	const struct vsp1_format_info *fmtinfo;
+
+	struct vsp1_pipeline pipe;
+	unsigned int pipe_index;
+
+	struct vb2_queue queue;
+	void *alloc_ctx;
+	spinlock_t irqlock;
+	struct list_head irqqueue;
+	unsigned int sequence;
+};
+
+static inline struct vsp1_video *to_vsp1_video(struct video_device *vdev)
+{
+	return container_of(vdev, struct vsp1_video, video);
+}
+
+int vsp1_video_init(struct vsp1_video *video, struct vsp1_entity *rwpf);
+void vsp1_video_cleanup(struct vsp1_video *video);
+
+void vsp1_pipeline_frame_end(struct vsp1_pipeline *pipe);
+
+#endif /* __VSP1_VIDEO_H__ */
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
new file mode 100644
index 0000000..db4b85e
--- /dev/null
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -0,0 +1,233 @@
+/*
+ * vsp1_wpf.c  --  R-Car VSP1 Write Pixel Formatter
+ *
+ * Copyright (C) 2013 Renesas Corporation
+ *
+ * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/device.h>
+
+#include <media/v4l2-subdev.h>
+
+#include "vsp1.h"
+#include "vsp1_rwpf.h"
+#include "vsp1_video.h"
+
+#define WPF_MAX_WIDTH				2048
+#define WPF_MAX_HEIGHT				2048
+
+/* -----------------------------------------------------------------------------
+ * Device Access
+ */
+
+static inline u32 vsp1_wpf_read(struct vsp1_rwpf *wpf, u32 reg)
+{
+	return vsp1_read(wpf->entity.vsp1,
+			 reg + wpf->entity.index * VI6_WPF_OFFSET);
+}
+
+static inline void vsp1_wpf_write(struct vsp1_rwpf *wpf, u32 reg, u32 data)
+{
+	vsp1_write(wpf->entity.vsp1,
+		   reg + wpf->entity.index * VI6_WPF_OFFSET, data);
+}
+
+/* -----------------------------------------------------------------------------
+ * V4L2 Subdevice Core Operations
+ */
+
+static int wpf_s_stream(struct v4l2_subdev *subdev, int enable)
+{
+	struct vsp1_rwpf *wpf = to_rwpf(subdev);
+	struct vsp1_pipeline *pipe =
+		to_vsp1_pipeline(&wpf->entity.subdev.entity);
+	struct vsp1_device *vsp1 = wpf->entity.vsp1;
+	const struct v4l2_mbus_framefmt *format =
+		&wpf->entity.formats[RWPF_PAD_SOURCE];
+	unsigned int i;
+	u32 srcrpf = 0;
+	u32 outfmt = 0;
+
+	if (!enable) {
+		vsp1_write(vsp1, VI6_WPF_IRQ_ENB(wpf->entity.index), 0);
+		return 0;
+	}
+
+	/* Sources */
+	for (i = 0; i < pipe->num_inputs; ++i) {
+		struct vsp1_rwpf *input = pipe->inputs[i];
+
+		srcrpf |= VI6_WPF_SRCRPF_RPF_ACT_MST(input->entity.index);
+	}
+
+	vsp1_wpf_write(wpf, VI6_WPF_SRCRPF, srcrpf);
+
+	/* Destination stride. Cropping isn't supported yet. */
+	if (!pipe->lif) {
+		struct v4l2_pix_format_mplane *format = &wpf->video.format;
+
+		vsp1_wpf_write(wpf, VI6_WPF_DSTM_STRIDE_Y,
+			       format->plane_fmt[0].bytesperline);
+		if (format->num_planes > 1)
+			vsp1_wpf_write(wpf, VI6_WPF_DSTM_STRIDE_C,
+				       format->plane_fmt[1].bytesperline);
+	}
+
+	vsp1_wpf_write(wpf, VI6_WPF_HSZCLIP,
+		       format->width << VI6_WPF_SZCLIP_SIZE_SHIFT);
+	vsp1_wpf_write(wpf, VI6_WPF_VSZCLIP,
+		       format->height << VI6_WPF_SZCLIP_SIZE_SHIFT);
+
+	/* Format */
+	if (!pipe->lif) {
+		const struct vsp1_format_info *fmtinfo = wpf->video.fmtinfo;
+
+		outfmt = fmtinfo->hwfmt << VI6_WPF_OUTFMT_WRFMT_SHIFT;
+
+		if (fmtinfo->swap_yc)
+			outfmt |= VI6_WPF_OUTFMT_SPYCS;
+		if (fmtinfo->swap_uv)
+			outfmt |= VI6_WPF_OUTFMT_SPUVS;
+
+		vsp1_wpf_write(wpf, VI6_WPF_DSWAP, fmtinfo->swap);
+	}
+
+	if (wpf->entity.formats[RWPF_PAD_SINK].code !=
+	    wpf->entity.formats[RWPF_PAD_SOURCE].code)
+		outfmt |= VI6_WPF_OUTFMT_CSC;
+
+	vsp1_wpf_write(wpf, VI6_WPF_OUTFMT, outfmt);
+
+	vsp1_write(vsp1, VI6_DPR_WPF_FPORCH(wpf->entity.index),
+		   VI6_DPR_WPF_FPORCH_FP_WPFN);
+
+	vsp1_write(vsp1, VI6_WPF_WRBCK_CTRL, 0);
+
+	/* Enable interrupts */
+	vsp1_write(vsp1, VI6_WPF_IRQ_STA(wpf->entity.index), 0);
+	vsp1_write(vsp1, VI6_WPF_IRQ_ENB(wpf->entity.index),
+		   VI6_WFP_IRQ_ENB_FREE);
+
+	return 0;
+}
+
+/* -----------------------------------------------------------------------------
+ * V4L2 Subdevice Operations
+ */
+
+static struct v4l2_subdev_video_ops wpf_video_ops = {
+	.s_stream = wpf_s_stream,
+};
+
+static struct v4l2_subdev_pad_ops wpf_pad_ops = {
+	.enum_mbus_code = vsp1_rwpf_enum_mbus_code,
+	.enum_frame_size = vsp1_rwpf_enum_frame_size,
+	.get_fmt = vsp1_rwpf_get_format,
+	.set_fmt = vsp1_rwpf_set_format,
+};
+
+static struct v4l2_subdev_ops wpf_ops = {
+	.video	= &wpf_video_ops,
+	.pad    = &wpf_pad_ops,
+};
+
+/* -----------------------------------------------------------------------------
+ * Video Device Operations
+ */
+
+static void wpf_vdev_queue(struct vsp1_video *video,
+			   struct vsp1_video_buffer *buf)
+{
+	struct vsp1_rwpf *wpf = container_of(video, struct vsp1_rwpf, video);
+
+	vsp1_wpf_write(wpf, VI6_WPF_DSTM_ADDR_Y, buf->addr[0]);
+	if (buf->buf.num_planes > 1)
+		vsp1_wpf_write(wpf, VI6_WPF_DSTM_ADDR_C0, buf->addr[1]);
+	if (buf->buf.num_planes > 2)
+		vsp1_wpf_write(wpf, VI6_WPF_DSTM_ADDR_C1, buf->addr[2]);
+}
+
+static const struct vsp1_video_operations wpf_vdev_ops = {
+	.queue = wpf_vdev_queue,
+};
+
+/* -----------------------------------------------------------------------------
+ * Initialization and Cleanup
+ */
+
+struct vsp1_rwpf *vsp1_wpf_create(struct vsp1_device *vsp1, unsigned int index)
+{
+	struct v4l2_subdev *subdev;
+	struct vsp1_video *video;
+	struct vsp1_rwpf *wpf;
+	unsigned int flags;
+	int ret;
+
+	wpf = devm_kzalloc(vsp1->dev, sizeof(*wpf), GFP_KERNEL);
+	if (wpf == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	wpf->max_width = WPF_MAX_WIDTH;
+	wpf->max_height = WPF_MAX_HEIGHT;
+
+	wpf->entity.type = VSP1_ENTITY_WPF;
+	wpf->entity.index = index;
+	wpf->entity.id = VI6_DPR_NODE_WPF(index);
+
+	ret = vsp1_entity_init(vsp1, &wpf->entity, 2);
+	if (ret < 0)
+		return ERR_PTR(ret);
+
+	/* Initialize the V4L2 subdev. */
+	subdev = &wpf->entity.subdev;
+	v4l2_subdev_init(subdev, &wpf_ops);
+
+	subdev->entity.ops = &vsp1_media_ops;
+	subdev->internal_ops = &vsp1_subdev_internal_ops;
+	snprintf(subdev->name, sizeof(subdev->name), "%s wpf.%u",
+		 dev_name(vsp1->dev), index);
+	v4l2_set_subdevdata(subdev, wpf);
+	subdev->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+
+	vsp1_entity_init_formats(subdev, NULL);
+
+	/* Initialize the video device. */
+	video = &wpf->video;
+
+	video->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+	video->vsp1 = vsp1;
+	video->ops = &wpf_vdev_ops;
+
+	ret = vsp1_video_init(video, &wpf->entity);
+	if (ret < 0)
+		goto error_video;
+
+	/* Connect the video device to the WPF. All connections are immutable
+	 * except for the WPF0 source link if a LIF is present.
+	 */
+	flags = MEDIA_LNK_FL_ENABLED;
+	if (!(vsp1->pdata->features & VSP1_HAS_LIF) || index != 0)
+		flags |= MEDIA_LNK_FL_IMMUTABLE;
+
+	ret = media_entity_create_link(&wpf->entity.subdev.entity,
+				       RWPF_PAD_SOURCE,
+				       &wpf->video.video.entity, 0, flags);
+	if (ret < 0)
+		goto error_link;
+
+	wpf->entity.sink = &wpf->video.video.entity;
+
+	return wpf;
+
+error_link:
+	vsp1_video_cleanup(video);
+error_video:
+	media_entity_cleanup(&wpf->entity.subdev.entity);
+	return ERR_PTR(ret);
+}
diff --git a/include/linux/platform_data/vsp1.h b/include/linux/platform_data/vsp1.h
new file mode 100644
index 0000000..a73a456
--- /dev/null
+++ b/include/linux/platform_data/vsp1.h
@@ -0,0 +1,25 @@
+/*
+ * vsp1.h  --  R-Car VSP1 Platform Data
+ *
+ * Copyright (C) 2013 Renesas Corporation
+ *
+ * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#ifndef __PLATFORM_VSP1_H__
+#define __PLATFORM_VSP1_H__
+
+#define VSP1_HAS_LIF		(1 << 0)
+
+struct vsp1_platform_data {
+	unsigned int features;
+	unsigned int rpf_count;
+	unsigned int uds_count;
+	unsigned int wpf_count;
+};
+
+#endif /* __PLATFORM_VSP1_H__ */
-- 
1.8.1.5

