Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:53937 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755434Ab2EBPQK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 2 May 2012 11:16:10 -0400
Received: by obbup16 with SMTP id up16so1031386obb.25
        for <linux-media@vger.kernel.org>; Wed, 02 May 2012 08:16:08 -0700 (PDT)
From: Sergio Aguirre <saaguirre@ti.com>
To: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Sergio Aguirre <saaguirre@ti.com>
Subject: [PATCH v3 04/10] v4l: Add support for omap4iss driver
Date: Wed,  2 May 2012 10:15:43 -0500
Message-Id: <1335971749-21258-5-git-send-email-saaguirre@ti.com>
In-Reply-To: <1335971749-21258-1-git-send-email-saaguirre@ti.com>
References: <1335971749-21258-1-git-send-email-saaguirre@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds a very simplistic driver to utilize the
CSI2A/B interfaces inside the ISS subsystem in OMAP4,
and dump the data to memory.

Check newly added Documentation/video4linux/omap4_camera.txt
for details.

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 Documentation/video4linux/omap4_camera.txt |   64 ++
 arch/arm/mach-omap2/devices.h              |    4 +
 drivers/media/video/Kconfig                |   13 +
 drivers/media/video/Makefile               |    1 +
 drivers/media/video/omap4iss/Makefile      |    6 +
 drivers/media/video/omap4iss/iss.c         | 1159 +++++++++++++++++++++++
 drivers/media/video/omap4iss/iss.h         |  121 +++
 drivers/media/video/omap4iss/iss_csi2.c    | 1368 ++++++++++++++++++++++++++++
 drivers/media/video/omap4iss/iss_csi2.h    |  155 ++++
 drivers/media/video/omap4iss/iss_csiphy.c  |  281 ++++++
 drivers/media/video/omap4iss/iss_csiphy.h  |   51 +
 drivers/media/video/omap4iss/iss_regs.h    |  244 +++++
 drivers/media/video/omap4iss/iss_video.c   | 1123 +++++++++++++++++++++++
 drivers/media/video/omap4iss/iss_video.h   |  201 ++++
 include/media/omap4iss.h                   |   65 ++
 15 files changed, 4856 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/video4linux/omap4_camera.txt
 create mode 100644 drivers/media/video/omap4iss/Makefile
 create mode 100644 drivers/media/video/omap4iss/iss.c
 create mode 100644 drivers/media/video/omap4iss/iss.h
 create mode 100644 drivers/media/video/omap4iss/iss_csi2.c
 create mode 100644 drivers/media/video/omap4iss/iss_csi2.h
 create mode 100644 drivers/media/video/omap4iss/iss_csiphy.c
 create mode 100644 drivers/media/video/omap4iss/iss_csiphy.h
 create mode 100644 drivers/media/video/omap4iss/iss_regs.h
 create mode 100644 drivers/media/video/omap4iss/iss_video.c
 create mode 100644 drivers/media/video/omap4iss/iss_video.h
 create mode 100644 include/media/omap4iss.h

diff --git a/Documentation/video4linux/omap4_camera.txt b/Documentation/video4linux/omap4_camera.txt
new file mode 100644
index 0000000..f0ba1f2
--- /dev/null
+++ b/Documentation/video4linux/omap4_camera.txt
@@ -0,0 +1,64 @@
+                              OMAP4 ISS Driver
+                              ================
+
+Introduction
+------------
+
+The OMAP44XX family of chips contains the Imaging SubSystem (a.k.a. ISS),
+Which contains several components that can be categorized in 3 big groups:
+
+- Interfaces (2 Interfaces: CSI2-A & CSI2-B/CCP2)
+- ISP (Image Signal Processor)
+- SIMCOP (Still Image Coprocessor)
+
+For more information, please look in [1] for latest version of:
+	"OMAP4430 Multimedia Device Silicon Revision 2.x"
+
+As of Revision AB, the ISS is described in detail in section 8.
+
+This driver is supporting _only_ the CSI2-A/B interfaces for now.
+
+It makes use of the Media Controller framework [2], and inherited most of the
+code from OMAP3 ISP driver (found under drivers/media/video/omap3isp/*), except
+that it doesn't need an IOMMU now for ISS buffers memory mapping.
+
+Supports usage of MMAP buffers only (for now).
+
+IMPORTANT: It is recommended to have this patchset:
+  Contiguous Memory Allocator (v22) [3].
+
+Tested platforms
+----------------
+
+- OMAP4430SDP, w/ ES2.1 GP & SEVM4430-CAM-V1-0 (Contains IMX060 & OV5640, in
+  which only the last one is supported, outputting YUV422 frames).
+
+- TI Blaze MDP, w/ OMAP4430 ES2.2 EMU (Contains 1 IMX060 & 2 OV5650 sensors, in
+  which only the OV5650 are supported, outputting RAW10 frames).
+
+- PandaBoard, Rev. A2, w/ OMAP4430 ES2.1 GP & OV adapter board, tested with
+  following sensors:
+  * OV5640
+  * OV5650
+
+- Tested on mainline kernel:
+
+	http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=summary
+
+  Tag: v3.3 (commit c16fa4f2ad19908a47c63d8fa436a1178438c7e7)
+
+File list
+---------
+drivers/media/video/omap4iss/
+include/media/omap4iss.h
+
+References
+----------
+
+[1] http://focus.ti.com/general/docs/wtbu/wtbudocumentcenter.tsp?navigationId=12037&templateId=6123#62
+[2] http://lwn.net/Articles/420485/
+[3] http://www.spinics.net/lists/linux-media/msg44370.html
+--
+Author: Sergio Aguirre <saaguirre@ti.com>
+Copyright (C) 2012, Texas Instruments
+
diff --git a/arch/arm/mach-omap2/devices.h b/arch/arm/mach-omap2/devices.h
index f61eb6e..31ba87f 100644
--- a/arch/arm/mach-omap2/devices.h
+++ b/arch/arm/mach-omap2/devices.h
@@ -16,4 +16,8 @@ struct isp_platform_data;
 
 int omap3_init_camera(struct isp_platform_data *pdata);
 
+struct iss_platform_data;
+
+int omap4_init_camera(struct iss_platform_data *pdata,
+			     struct omap_board_data *bdata);
 #endif
diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index ce1e7ba..4482ac4 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -953,6 +953,19 @@ config VIDEO_OMAP3_DEBUG
 	---help---
 	  Enable debug messages on OMAP 3 camera controller driver.
 
+config VIDEO_OMAP4
+	tristate "OMAP 4 Camera support (EXPERIMENTAL)"
+	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && ARCH_OMAP4 && EXPERIMENTAL
+	select VIDEOBUF2_DMA_CONTIG
+	---help---
+	  Driver for an OMAP 4 ISS controller.
+
+config VIDEO_OMAP4_DEBUG
+	bool "OMAP 4 Camera debug messages"
+	depends on VIDEO_OMAP4
+	---help---
+	  Enable debug messages on OMAP 4 ISS controller driver.
+
 config SOC_CAMERA
 	tristate "SoC camera support"
 	depends on VIDEO_V4L2 && HAS_DMA && I2C
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index a6282a3..c95cc0d 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -147,6 +147,7 @@ obj-$(CONFIG_VIDEO_MMP_CAMERA) += marvell-ccic/
 obj-$(CONFIG_VIDEO_VIA_CAMERA) += via-camera.o
 
 obj-$(CONFIG_VIDEO_OMAP3)	+= omap3isp/
+obj-$(CONFIG_VIDEO_OMAP4)	+= omap4iss/
 
 obj-$(CONFIG_USB_ZR364XX)       += zr364xx.o
 obj-$(CONFIG_USB_STKWEBCAM)     += stkwebcam.o
diff --git a/drivers/media/video/omap4iss/Makefile b/drivers/media/video/omap4iss/Makefile
new file mode 100644
index 0000000..1d3b0a7
--- /dev/null
+++ b/drivers/media/video/omap4iss/Makefile
@@ -0,0 +1,6 @@
+# Makefile for OMAP4 ISS driver
+
+omap4-iss-objs += \
+	iss.o iss_csi2.o iss_csiphy.o iss_video.o
+
+obj-$(CONFIG_VIDEO_OMAP4) += omap4-iss.o
diff --git a/drivers/media/video/omap4iss/iss.c b/drivers/media/video/omap4iss/iss.c
new file mode 100644
index 0000000..0b04795
--- /dev/null
+++ b/drivers/media/video/omap4iss/iss.c
@@ -0,0 +1,1159 @@
+/*
+ * TI OMAP4 ISS V4L2 Driver
+ *
+ * Copyright (C) 2012, Texas Instruments
+ *
+ * Author: Sergio Aguirre <saaguirre@ti.com>
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
+#include <linux/dma-mapping.h>
+#include <linux/i2c.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/sched.h>
+#include <linux/vmalloc.h>
+
+#include <media/v4l2-common.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ctrls.h>
+
+#include "iss.h"
+#include "iss_regs.h"
+
+/*
+ * omap4iss_flush - Post pending L3 bus writes by doing a register readback
+ * @iss: OMAP4 ISS device
+ *
+ * In order to force posting of pending writes, we need to write and
+ * readback the same register, in this case the revision register.
+ *
+ * See this link for reference:
+ *   http://www.mail-archive.com/linux-omap@vger.kernel.org/msg08149.html
+ */
+void omap4iss_flush(struct iss_device *iss)
+{
+	writel(0, iss->regs[OMAP4_ISS_MEM_TOP] + ISS_HL_REVISION);
+	readl(iss->regs[OMAP4_ISS_MEM_TOP] + ISS_HL_REVISION);
+}
+
+/*
+ * iss_enable_interrupts - Enable ISS interrupts.
+ * @iss: OMAP4 ISS device
+ */
+static void iss_enable_interrupts(struct iss_device *iss)
+{
+	static const u32 irq = ISS_HL_IRQ_CSIA | ISS_HL_IRQ_CSIB;
+
+	/* Enable HL interrupts */
+	writel(irq, iss->regs[OMAP4_ISS_MEM_TOP] + ISS_HL_IRQSTATUS_5);
+	writel(irq, iss->regs[OMAP4_ISS_MEM_TOP] + ISS_HL_IRQENABLE_5_SET);
+}
+
+/*
+ * iss_disable_interrupts - Disable ISS interrupts.
+ * @iss: OMAP4 ISS device
+ */
+static void iss_disable_interrupts(struct iss_device *iss)
+{
+	writel(-1, iss->regs[OMAP4_ISS_MEM_TOP] + ISS_HL_IRQENABLE_5_CLR);
+}
+
+int omap4iss_get_external_info(struct iss_pipeline *pipe,
+			       struct media_link *link)
+{
+	struct iss_device *iss =
+		container_of(pipe, struct iss_video, pipe)->iss;
+	struct v4l2_subdev_format fmt;
+	struct v4l2_ext_controls ctrls;
+	struct v4l2_ext_control ctrl;
+	int ret;
+
+	if (!pipe->external)
+		return 0;
+
+	if (pipe->external_rate)
+		return 0;
+
+	memset(&fmt, 0, sizeof(fmt));
+
+	fmt.pad = link->source->index;
+	fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+	ret = v4l2_subdev_call(media_entity_to_v4l2_subdev(link->sink->entity),
+			       pad, get_fmt, NULL, &fmt);
+	if (ret < 0)
+		return -EPIPE;
+
+	pipe->external_bpp = omap4iss_video_format_info(fmt.format.code)->bpp;
+
+	memset(&ctrls, 0, sizeof(ctrls));
+	memset(&ctrl, 0, sizeof(ctrl));
+
+	ctrl.id = V4L2_CID_PIXEL_RATE;
+
+	ctrls.ctrl_class = V4L2_CTRL_ID2CLASS(ctrl.id);
+	ctrls.count = 1;
+	ctrls.controls = &ctrl;
+
+	ret = v4l2_g_ext_ctrls(pipe->external->ctrl_handler, &ctrls);
+	if (ret < 0) {
+		dev_warn(iss->dev, "no pixel rate control in subdev %s\n",
+			 pipe->external->name);
+		return ret;
+	}
+
+	pipe->external_rate = ctrl.value64;
+
+	return 0;
+}
+
+static inline void iss_isr_dbg(struct iss_device *iss, u32 irqstatus)
+{
+	static const char *name[] = {
+		"ISP_IRQ0",
+		"ISP_IRQ1",
+		"ISP_IRQ2",
+		"ISP_IRQ3",
+		"CSIA_IRQ",
+		"CSIB_IRQ",
+		"CCP2_IRQ0",
+		"CCP2_IRQ1",
+		"CCP2_IRQ2",
+		"CCP2_IRQ3",
+		"CBUFF_IRQ",
+		"BTE_IRQ",
+		"SIMCOP_IRQ0",
+		"SIMCOP_IRQ1",
+		"SIMCOP_IRQ2",
+		"SIMCOP_IRQ3",
+		"CCP2_IRQ8",
+		"HS_VS_IRQ",
+		"res18",
+		"res19",
+		"res20",
+		"res21",
+		"res22",
+		"res23",
+		"res24",
+		"res25",
+		"res26",
+		"res27",
+		"res28",
+		"res29",
+		"res30",
+		"res31",
+	};
+	int i;
+
+	dev_dbg(iss->dev, "ISS IRQ: ");
+
+	for (i = 0; i < ARRAY_SIZE(name); i++) {
+		if ((1 << i) & irqstatus)
+			pr_cont("%s ", name[i]);
+	}
+	pr_cont("\n");
+}
+
+/*
+ * iss_isr - Interrupt Service Routine for ISS module.
+ * @irq: Not used currently.
+ * @_iss: Pointer to the OMAP4 ISS device
+ *
+ * Handles the corresponding callback if plugged in.
+ *
+ * Returns IRQ_HANDLED when IRQ was correctly handled, or IRQ_NONE when the
+ * IRQ wasn't handled.
+ */
+static irqreturn_t iss_isr(int irq, void *_iss)
+{
+	struct iss_device *iss = _iss;
+	u32 irqstatus;
+
+	irqstatus = readl(iss->regs[OMAP4_ISS_MEM_TOP] + ISS_HL_IRQSTATUS_5);
+	writel(irqstatus, iss->regs[OMAP4_ISS_MEM_TOP] + ISS_HL_IRQSTATUS_5);
+
+	if (irqstatus & ISS_HL_IRQ_CSIA)
+		omap4iss_csi2_isr(&iss->csi2a);
+
+	if (irqstatus & ISS_HL_IRQ_CSIB)
+		omap4iss_csi2_isr(&iss->csi2b);
+
+	omap4iss_flush(iss);
+
+#if defined(DEBUG) && defined(ISS_ISR_DEBUG)
+	iss_isr_dbg(iss, irqstatus);
+#endif
+
+	return IRQ_HANDLED;
+}
+
+/* -----------------------------------------------------------------------------
+ * Pipeline power management
+ *
+ * Entities must be powered up when part of a pipeline that contains at least
+ * one open video device node.
+ *
+ * To achieve this use the entity use_count field to track the number of users.
+ * For entities corresponding to video device nodes the use_count field stores
+ * the users count of the node. For entities corresponding to subdevs the
+ * use_count field stores the total number of users of all video device nodes
+ * in the pipeline.
+ *
+ * The omap4iss_pipeline_pm_use() function must be called in the open() and
+ * close() handlers of video device nodes. It increments or decrements the use
+ * count of all subdev entities in the pipeline.
+ *
+ * To react to link management on powered pipelines, the link setup notification
+ * callback updates the use count of all entities in the source and sink sides
+ * of the link.
+ */
+
+/*
+ * iss_pipeline_pm_use_count - Count the number of users of a pipeline
+ * @entity: The entity
+ *
+ * Return the total number of users of all video device nodes in the pipeline.
+ */
+static int iss_pipeline_pm_use_count(struct media_entity *entity)
+{
+	struct media_entity_graph graph;
+	int use = 0;
+
+	media_entity_graph_walk_start(&graph, entity);
+
+	while ((entity = media_entity_graph_walk_next(&graph))) {
+		if (media_entity_type(entity) == MEDIA_ENT_T_DEVNODE)
+			use += entity->use_count;
+	}
+
+	return use;
+}
+
+/*
+ * iss_pipeline_pm_power_one - Apply power change to an entity
+ * @entity: The entity
+ * @change: Use count change
+ *
+ * Change the entity use count by @change. If the entity is a subdev update its
+ * power state by calling the core::s_power operation when the use count goes
+ * from 0 to != 0 or from != 0 to 0.
+ *
+ * Return 0 on success or a negative error code on failure.
+ */
+static int iss_pipeline_pm_power_one(struct media_entity *entity, int change)
+{
+	struct v4l2_subdev *subdev;
+
+	subdev = media_entity_type(entity) == MEDIA_ENT_T_V4L2_SUBDEV
+	       ? media_entity_to_v4l2_subdev(entity) : NULL;
+
+	if (entity->use_count == 0 && change > 0 && subdev != NULL) {
+		int ret;
+
+		ret = v4l2_subdev_call(subdev, core, s_power, 1);
+		if (ret < 0 && ret != -ENOIOCTLCMD)
+			return ret;
+	}
+
+	entity->use_count += change;
+	WARN_ON(entity->use_count < 0);
+
+	if (entity->use_count == 0 && change < 0 && subdev != NULL)
+		v4l2_subdev_call(subdev, core, s_power, 0);
+
+	return 0;
+}
+
+/*
+ * iss_pipeline_pm_power - Apply power change to all entities in a pipeline
+ * @entity: The entity
+ * @change: Use count change
+ *
+ * Walk the pipeline to update the use count and the power state of all non-node
+ * entities.
+ *
+ * Return 0 on success or a negative error code on failure.
+ */
+static int iss_pipeline_pm_power(struct media_entity *entity, int change)
+{
+	struct media_entity_graph graph;
+	struct media_entity *first = entity;
+	int ret = 0;
+
+	if (!change)
+		return 0;
+
+	media_entity_graph_walk_start(&graph, entity);
+
+	while (!ret && (entity = media_entity_graph_walk_next(&graph)))
+		if (media_entity_type(entity) != MEDIA_ENT_T_DEVNODE)
+			ret = iss_pipeline_pm_power_one(entity, change);
+
+	if (!ret)
+		return 0;
+
+	media_entity_graph_walk_start(&graph, first);
+
+	while ((first = media_entity_graph_walk_next(&graph))
+	       && first != entity)
+		if (media_entity_type(first) != MEDIA_ENT_T_DEVNODE)
+			iss_pipeline_pm_power_one(first, -change);
+
+	return ret;
+}
+
+/*
+ * omap4iss_pipeline_pm_use - Update the use count of an entity
+ * @entity: The entity
+ * @use: Use (1) or stop using (0) the entity
+ *
+ * Update the use count of all entities in the pipeline and power entities on or
+ * off accordingly.
+ *
+ * Return 0 on success or a negative error code on failure. Powering entities
+ * off is assumed to never fail. No failure can occur when the use parameter is
+ * set to 0.
+ */
+int omap4iss_pipeline_pm_use(struct media_entity *entity, int use)
+{
+	int change = use ? 1 : -1;
+	int ret;
+
+	mutex_lock(&entity->parent->graph_mutex);
+
+	/* Apply use count to node. */
+	entity->use_count += change;
+	WARN_ON(entity->use_count < 0);
+
+	/* Apply power change to connected non-nodes. */
+	ret = iss_pipeline_pm_power(entity, change);
+	if (ret < 0)
+		entity->use_count -= change;
+
+	mutex_unlock(&entity->parent->graph_mutex);
+
+	return ret;
+}
+
+/*
+ * iss_pipeline_link_notify - Link management notification callback
+ * @source: Pad at the start of the link
+ * @sink: Pad at the end of the link
+ * @flags: New link flags that will be applied
+ *
+ * React to link management on powered pipelines by updating the use count of
+ * all entities in the source and sink sides of the link. Entities are powered
+ * on or off accordingly.
+ *
+ * Return 0 on success or a negative error code on failure. Powering entities
+ * off is assumed to never fail. This function will not fail for disconnection
+ * events.
+ */
+static int iss_pipeline_link_notify(struct media_pad *source,
+				    struct media_pad *sink, u32 flags)
+{
+	int source_use = iss_pipeline_pm_use_count(source->entity);
+	int sink_use = iss_pipeline_pm_use_count(sink->entity);
+	int ret;
+
+	if (!(flags & MEDIA_LNK_FL_ENABLED)) {
+		/* Powering off entities is assumed to never fail. */
+		iss_pipeline_pm_power(source->entity, -sink_use);
+		iss_pipeline_pm_power(sink->entity, -source_use);
+		return 0;
+	}
+
+	ret = iss_pipeline_pm_power(source->entity, sink_use);
+	if (ret < 0)
+		return ret;
+
+	ret = iss_pipeline_pm_power(sink->entity, source_use);
+	if (ret < 0)
+		iss_pipeline_pm_power(source->entity, -sink_use);
+
+	return ret;
+}
+
+/* -----------------------------------------------------------------------------
+ * Pipeline stream management
+ */
+
+/*
+ * iss_pipeline_enable - Enable streaming on a pipeline
+ * @pipe: ISS pipeline
+ * @mode: Stream mode (single shot or continuous)
+ *
+ * Walk the entities chain starting at the pipeline output video node and start
+ * all modules in the chain in the given mode.
+ *
+ * Return 0 if successful, or the return value of the failed video::s_stream
+ * operation otherwise.
+ */
+static int iss_pipeline_enable(struct iss_pipeline *pipe,
+			       enum iss_pipeline_stream_state mode)
+{
+	struct media_entity *entity;
+	struct media_pad *pad;
+	struct v4l2_subdev *subdev;
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&pipe->lock, flags);
+	pipe->state &= ~(ISS_PIPELINE_IDLE_INPUT | ISS_PIPELINE_IDLE_OUTPUT);
+	spin_unlock_irqrestore(&pipe->lock, flags);
+
+	pipe->do_propagation = false;
+
+	entity = &pipe->output->video.entity;
+	while (1) {
+		pad = &entity->pads[0];
+		if (!(pad->flags & MEDIA_PAD_FL_SINK))
+			break;
+
+		pad = media_entity_remote_source(pad);
+		if (pad == NULL ||
+		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
+			break;
+
+		entity = pad->entity;
+		subdev = media_entity_to_v4l2_subdev(entity);
+
+		ret = v4l2_subdev_call(subdev, video, s_stream, mode);
+		if (ret < 0 && ret != -ENOIOCTLCMD)
+			return ret;
+	}
+
+	return 0;
+}
+
+/*
+ * iss_pipeline_disable - Disable streaming on a pipeline
+ * @pipe: ISS pipeline
+ *
+ * Walk the entities chain starting at the pipeline output video node and stop
+ * all modules in the chain. Wait synchronously for the modules to be stopped if
+ * necessary.
+ */
+static int iss_pipeline_disable(struct iss_pipeline *pipe)
+{
+	struct media_entity *entity;
+	struct media_pad *pad;
+	struct v4l2_subdev *subdev;
+	int failure = 0;
+
+	entity = &pipe->output->video.entity;
+	while (1) {
+		pad = &entity->pads[0];
+		if (!(pad->flags & MEDIA_PAD_FL_SINK))
+			break;
+
+		pad = media_entity_remote_source(pad);
+		if (pad == NULL ||
+		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
+			break;
+
+		entity = pad->entity;
+		subdev = media_entity_to_v4l2_subdev(entity);
+
+		v4l2_subdev_call(subdev, video, s_stream, 0);
+	}
+
+	return failure;
+}
+
+/*
+ * omap4iss_pipeline_set_stream - Enable/disable streaming on a pipeline
+ * @pipe: ISS pipeline
+ * @state: Stream state (stopped, single shot or continuous)
+ *
+ * Set the pipeline to the given stream state. Pipelines can be started in
+ * single-shot or continuous mode.
+ *
+ * Return 0 if successful, or the return value of the failed video::s_stream
+ * operation otherwise. The pipeline state is not updated when the operation
+ * fails, except when stopping the pipeline.
+ */
+int omap4iss_pipeline_set_stream(struct iss_pipeline *pipe,
+				 enum iss_pipeline_stream_state state)
+{
+	int ret;
+
+	if (state == ISS_PIPELINE_STREAM_STOPPED)
+		ret = iss_pipeline_disable(pipe);
+	else
+		ret = iss_pipeline_enable(pipe, state);
+
+	if (ret == 0 || state == ISS_PIPELINE_STREAM_STOPPED)
+		pipe->stream_state = state;
+
+	return ret;
+}
+
+/*
+ * iss_pipeline_is_last - Verify if entity has an enabled link to the output
+ *			  video node
+ * @me: ISS module's media entity
+ *
+ * Returns 1 if the entity has an enabled link to the output video node or 0
+ * otherwise. It's true only while pipeline can have no more than one output
+ * node.
+ */
+static int iss_pipeline_is_last(struct media_entity *me)
+{
+	struct iss_pipeline *pipe;
+	struct media_pad *pad;
+
+	if (!me->pipe)
+		return 0;
+	pipe = to_iss_pipeline(me);
+	if (pipe->stream_state == ISS_PIPELINE_STREAM_STOPPED)
+		return 0;
+	pad = media_entity_remote_source(&pipe->output->pad);
+	return pad->entity == me;
+}
+
+static int iss_reset(struct iss_device *iss)
+{
+	unsigned long timeout = 0;
+
+	writel(readl(iss->regs[OMAP4_ISS_MEM_TOP] + ISS_HL_SYSCONFIG) |
+		ISS_HL_SYSCONFIG_SOFTRESET,
+		iss->regs[OMAP4_ISS_MEM_TOP] + ISS_HL_SYSCONFIG);
+
+	while (readl(iss->regs[OMAP4_ISS_MEM_TOP] + ISS_HL_SYSCONFIG) &
+			ISS_HL_SYSCONFIG_SOFTRESET) {
+		if (timeout++ > 10000) {
+			dev_alert(iss->dev, "cannot reset ISS\n");
+			return -ETIMEDOUT;
+		}
+		udelay(1);
+	}
+
+	return 0;
+}
+
+/*
+ * iss_module_sync_idle - Helper to sync module with its idle state
+ * @me: ISS submodule's media entity
+ * @wait: ISS submodule's wait queue for streamoff/interrupt synchronization
+ * @stopping: flag which tells module wants to stop
+ *
+ * This function checks if ISS submodule needs to wait for next interrupt. If
+ * yes, makes the caller to sleep while waiting for such event.
+ */
+int omap4iss_module_sync_idle(struct media_entity *me, wait_queue_head_t *wait,
+			      atomic_t *stopping)
+{
+	struct iss_pipeline *pipe = to_iss_pipeline(me);
+	struct iss_video *video = pipe->output;
+	unsigned long flags;
+
+	if (pipe->stream_state == ISS_PIPELINE_STREAM_STOPPED ||
+	    (pipe->stream_state == ISS_PIPELINE_STREAM_SINGLESHOT &&
+	     !iss_pipeline_ready(pipe)))
+		return 0;
+
+	/*
+	 * atomic_set() doesn't include memory barrier on ARM platform for SMP
+	 * scenario. We'll call it here to avoid race conditions.
+	 */
+	atomic_set(stopping, 1);
+	smp_wmb();
+
+	/*
+	 * If module is the last one, it's writing to memory. In this case,
+	 * it's necessary to check if the module is already paused due to
+	 * DMA queue underrun or if it has to wait for next interrupt to be
+	 * idle.
+	 * If it isn't the last one, the function won't sleep but *stopping
+	 * will still be set to warn next submodule caller's interrupt the
+	 * module wants to be idle.
+	 */
+	if (!iss_pipeline_is_last(me))
+		return 0;
+
+	spin_lock_irqsave(&video->qlock, flags);
+	if (video->dmaqueue_flags & ISS_VIDEO_DMAQUEUE_UNDERRUN) {
+		spin_unlock_irqrestore(&video->qlock, flags);
+		atomic_set(stopping, 0);
+		smp_wmb();
+		return 0;
+	}
+	spin_unlock_irqrestore(&video->qlock, flags);
+	if (!wait_event_timeout(*wait, !atomic_read(stopping),
+				msecs_to_jiffies(1000))) {
+		atomic_set(stopping, 0);
+		smp_wmb();
+		return -ETIMEDOUT;
+	}
+
+	return 0;
+}
+
+/*
+ * omap4iss_module_sync_is_stopped - Helper to verify if module was stopping
+ * @wait: ISS submodule's wait queue for streamoff/interrupt synchronization
+ * @stopping: flag which tells module wants to stop
+ *
+ * This function checks if ISS submodule was stopping. In case of yes, it
+ * notices the caller by setting stopping to 0 and waking up the wait queue.
+ * Returns 1 if it was stopping or 0 otherwise.
+ */
+int omap4iss_module_sync_is_stopping(wait_queue_head_t *wait,
+				     atomic_t *stopping)
+{
+	if (atomic_cmpxchg(stopping, 1, 0)) {
+		wake_up(wait);
+		return 1;
+	}
+
+	return 0;
+}
+
+/* --------------------------------------------------------------------------
+ * Clock management
+ */
+
+#define ISS_CLKCTRL_MASK	(ISS_CLKCTRL_CSI2_A | ISS_CLKCTRL_CSI2_B)
+
+static int __iss_subclk_update(struct iss_device *iss)
+{
+	u32 clk = 0;
+	int ret = 0, timeout = 1000;
+
+	if (iss->subclk_resources & OMAP4_ISS_SUBCLK_CSI2_A)
+		clk |= ISS_CLKCTRL_CSI2_A;
+
+	if (iss->subclk_resources & OMAP4_ISS_SUBCLK_CSI2_B)
+		clk |= ISS_CLKCTRL_CSI2_B;
+
+	writel((readl(iss->regs[OMAP4_ISS_MEM_TOP] + ISS_CLKCTRL) &
+		~ISS_CLKCTRL_MASK) | clk,
+		iss->regs[OMAP4_ISS_MEM_TOP] + ISS_CLKCTRL);
+
+	/* Wait for HW assertion */
+	while (--timeout > 0) {
+		udelay(1);
+		if ((readl(iss->regs[OMAP4_ISS_MEM_TOP] + ISS_CLKSTAT) &
+		     ISS_CLKCTRL_MASK) == clk)
+			break;
+	}
+
+	if (!timeout)
+		ret = -EBUSY;
+
+	return ret;
+}
+
+int omap4iss_subclk_enable(struct iss_device *iss,
+			    enum iss_subclk_resource res)
+{
+	iss->subclk_resources |= res;
+
+	return __iss_subclk_update(iss);
+}
+
+int omap4iss_subclk_disable(struct iss_device *iss,
+			     enum iss_subclk_resource res)
+{
+	iss->subclk_resources &= ~res;
+
+	return __iss_subclk_update(iss);
+}
+
+/*
+ * iss_enable_clocks - Enable ISS clocks
+ * @iss: OMAP4 ISS device
+ *
+ * Return 0 if successful, or clk_enable return value if any of tthem fails.
+ */
+static int iss_enable_clocks(struct iss_device *iss)
+{
+	int r;
+
+	r = clk_enable(iss->iss_fck);
+	if (r) {
+		dev_err(iss->dev, "clk_enable iss_fck failed\n");
+		return r;
+	}
+
+	r = clk_enable(iss->iss_ctrlclk);
+	if (r) {
+		dev_err(iss->dev, "clk_enable iss_ctrlclk failed\n");
+		goto out_clk_enable_ctrlclk;
+	}
+	return 0;
+
+out_clk_enable_ctrlclk:
+	clk_disable(iss->iss_fck);
+	return r;
+}
+
+/*
+ * iss_disable_clocks - Disable ISS clocks
+ * @iss: OMAP4 ISS device
+ */
+static void iss_disable_clocks(struct iss_device *iss)
+{
+	clk_disable(iss->iss_ctrlclk);
+	clk_disable(iss->iss_fck);
+}
+
+static void iss_put_clocks(struct iss_device *iss)
+{
+	if (iss->iss_fck) {
+		clk_put(iss->iss_fck);
+		iss->iss_fck = NULL;
+	}
+
+	if (iss->iss_ctrlclk) {
+		clk_put(iss->iss_ctrlclk);
+		iss->iss_ctrlclk = NULL;
+	}
+}
+
+static int iss_get_clocks(struct iss_device *iss)
+{
+	iss->iss_fck = clk_get(iss->dev, "iss_fck");
+	if (IS_ERR(iss->iss_fck)) {
+		dev_err(iss->dev, "Unable to get iss_fck clock info\n");
+		iss_put_clocks(iss);
+		return PTR_ERR(iss->iss_fck);
+	}
+
+	iss->iss_ctrlclk = clk_get(iss->dev, "iss_ctrlclk");
+	if (IS_ERR(iss->iss_ctrlclk)) {
+		dev_err(iss->dev, "Unable to get iss_ctrlclk clock info\n");
+		iss_put_clocks(iss);
+		return PTR_ERR(iss->iss_fck);
+	}
+
+	return 0;
+}
+
+/*
+ * omap4iss_get - Acquire the ISS resource.
+ *
+ * Initializes the clocks for the first acquire.
+ *
+ * Increment the reference count on the ISS. If the first reference is taken,
+ * enable clocks and power-up all submodules.
+ *
+ * Return a pointer to the ISS device structure, or NULL if an error occurred.
+ */
+struct iss_device *omap4iss_get(struct iss_device *iss)
+{
+	struct iss_device *__iss = iss;
+
+	if (iss == NULL)
+		return NULL;
+
+	mutex_lock(&iss->iss_mutex);
+	if (iss->ref_count > 0)
+		goto out;
+
+	if (iss_enable_clocks(iss) < 0) {
+		__iss = NULL;
+		goto out;
+	}
+
+	iss_enable_interrupts(iss);
+
+out:
+	if (__iss != NULL)
+		iss->ref_count++;
+	mutex_unlock(&iss->iss_mutex);
+
+	return __iss;
+}
+
+/*
+ * omap4iss_put - Release the ISS
+ *
+ * Decrement the reference count on the ISS. If the last reference is released,
+ * power-down all submodules, disable clocks and free temporary buffers.
+ */
+void omap4iss_put(struct iss_device *iss)
+{
+	if (iss == NULL)
+		return;
+
+	mutex_lock(&iss->iss_mutex);
+	BUG_ON(iss->ref_count == 0);
+	if (--iss->ref_count == 0) {
+		iss_disable_interrupts(iss);
+		iss_disable_clocks(iss);
+	}
+	mutex_unlock(&iss->iss_mutex);
+}
+
+static int iss_map_mem_resource(struct platform_device *pdev,
+				struct iss_device *iss,
+				enum iss_mem_resources res)
+{
+	struct resource *mem;
+
+	/* request the mem region for the camera registers */
+
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, res);
+	if (!mem) {
+		dev_err(iss->dev, "no mem resource?\n");
+		return -ENODEV;
+	}
+
+	if (!request_mem_region(mem->start, resource_size(mem), pdev->name)) {
+		dev_err(iss->dev,
+			"cannot reserve camera register I/O region\n");
+		return -ENODEV;
+	}
+	iss->res[res] = mem;
+
+	/* map the region */
+	iss->regs[res] = ioremap_nocache(mem->start, resource_size(mem));
+	if (!iss->regs[res]) {
+		dev_err(iss->dev, "cannot map camera register I/O region\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static void iss_unregister_entities(struct iss_device *iss)
+{
+	omap4iss_csi2_unregister_entities(&iss->csi2a);
+	omap4iss_csi2_unregister_entities(&iss->csi2b);
+
+	v4l2_device_unregister(&iss->v4l2_dev);
+	media_device_unregister(&iss->media_dev);
+}
+
+/*
+ * iss_register_subdev_group - Register a group of subdevices
+ * @iss: OMAP4 ISS device
+ * @board_info: I2C subdevs board information array
+ *
+ * Register all I2C subdevices in the board_info array. The array must be
+ * terminated by a NULL entry, and the first entry must be the sensor.
+ *
+ * Return a pointer to the sensor media entity if it has been successfully
+ * registered, or NULL otherwise.
+ */
+static struct v4l2_subdev *
+iss_register_subdev_group(struct iss_device *iss,
+		     struct iss_subdev_i2c_board_info *board_info)
+{
+	struct v4l2_subdev *sensor = NULL;
+	unsigned int first;
+
+	if (board_info->board_info == NULL)
+		return NULL;
+
+	for (first = 1; board_info->board_info; ++board_info, first = 0) {
+		struct v4l2_subdev *subdev;
+		struct i2c_adapter *adapter;
+
+		adapter = i2c_get_adapter(board_info->i2c_adapter_id);
+		if (adapter == NULL) {
+			dev_err(iss->dev, "%s: Unable to get I2C adapter %d for "
+				"device %s\n", __func__,
+				board_info->i2c_adapter_id,
+				board_info->board_info->type);
+			continue;
+		}
+
+		subdev = v4l2_i2c_new_subdev_board(&iss->v4l2_dev, adapter,
+				board_info->board_info, NULL);
+		if (subdev == NULL) {
+			dev_err(iss->dev, "%s: Unable to register subdev %s\n",
+				__func__, board_info->board_info->type);
+			continue;
+		}
+
+		if (first)
+			sensor = subdev;
+	}
+
+	return sensor;
+}
+
+static int iss_register_entities(struct iss_device *iss)
+{
+	struct iss_platform_data *pdata = iss->pdata;
+	struct iss_v4l2_subdevs_group *subdevs;
+	int ret;
+
+	iss->media_dev.dev = iss->dev;
+	strlcpy(iss->media_dev.model, "TI OMAP4 ISS",
+		sizeof(iss->media_dev.model));
+	iss->media_dev.hw_revision = iss->revision;
+	iss->media_dev.link_notify = iss_pipeline_link_notify;
+	ret = media_device_register(&iss->media_dev);
+	if (ret < 0) {
+		printk(KERN_ERR "%s: Media device registration failed (%d)\n",
+			__func__, ret);
+		return ret;
+	}
+
+	iss->v4l2_dev.mdev = &iss->media_dev;
+	ret = v4l2_device_register(iss->dev, &iss->v4l2_dev);
+	if (ret < 0) {
+		printk(KERN_ERR "%s: V4L2 device registration failed (%d)\n",
+			__func__, ret);
+		goto done;
+	}
+
+	/* Register internal entities */
+	ret = omap4iss_csi2_register_entities(&iss->csi2a, &iss->v4l2_dev);
+	if (ret < 0)
+		goto done;
+
+	ret = omap4iss_csi2_register_entities(&iss->csi2b, &iss->v4l2_dev);
+	if (ret < 0)
+		goto done;
+
+	/* Register external entities */
+	for (subdevs = pdata->subdevs; subdevs && subdevs->subdevs; ++subdevs) {
+		struct v4l2_subdev *sensor;
+		struct media_entity *input;
+		unsigned int flags;
+		unsigned int pad;
+
+		sensor = iss_register_subdev_group(iss, subdevs->subdevs);
+		if (sensor == NULL)
+			continue;
+
+		sensor->host_priv = subdevs;
+
+		/* Connect the sensor to the correct interface module.
+		 * CSI2a receiver through CSIPHY1, or
+		 * CSI2b receiver through CSIPHY2
+		 */
+		switch (subdevs->interface) {
+		case ISS_INTERFACE_CSI2A_PHY1:
+			input = &iss->csi2a.subdev.entity;
+			pad = CSI2_PAD_SINK;
+			flags = MEDIA_LNK_FL_IMMUTABLE
+			      | MEDIA_LNK_FL_ENABLED;
+			break;
+
+		case ISS_INTERFACE_CSI2B_PHY2:
+			input = &iss->csi2b.subdev.entity;
+			pad = CSI2_PAD_SINK;
+			flags = MEDIA_LNK_FL_IMMUTABLE
+			      | MEDIA_LNK_FL_ENABLED;
+			break;
+
+		default:
+			printk(KERN_ERR "%s: invalid interface type %u\n",
+			       __func__, subdevs->interface);
+			ret = -EINVAL;
+			goto done;
+		}
+
+		ret = media_entity_create_link(&sensor->entity, 0, input, pad,
+					       flags);
+		if (ret < 0)
+			goto done;
+	}
+
+	ret = v4l2_device_register_subdev_nodes(&iss->v4l2_dev);
+
+done:
+	if (ret < 0)
+		iss_unregister_entities(iss);
+
+	return ret;
+}
+
+static void iss_cleanup_modules(struct iss_device *iss)
+{
+	omap4iss_csi2_cleanup(iss);
+}
+
+static int iss_initialize_modules(struct iss_device *iss)
+{
+	int ret;
+
+	ret = omap4iss_csiphy_init(iss);
+	if (ret < 0) {
+		dev_err(iss->dev, "CSI PHY initialization failed\n");
+		return ret;
+	}
+
+	ret = omap4iss_csi2_init(iss);
+	if (ret < 0) {
+		dev_err(iss->dev, "CSI2 initialization failed\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int iss_probe(struct platform_device *pdev)
+{
+	struct iss_platform_data *pdata = pdev->dev.platform_data;
+	struct iss_device *iss;
+	int i, ret;
+
+	if (pdata == NULL)
+		return -EINVAL;
+
+	iss = kzalloc(sizeof(*iss), GFP_KERNEL);
+	if (!iss) {
+		dev_err(&pdev->dev, "Could not allocate memory\n");
+		return -ENOMEM;
+	}
+
+	mutex_init(&iss->iss_mutex);
+
+	iss->dev = &pdev->dev;
+	iss->pdata = pdata;
+	iss->ref_count = 0;
+
+	iss->raw_dmamask = DMA_BIT_MASK(32);
+	iss->dev->dma_mask = &iss->raw_dmamask;
+	iss->dev->coherent_dma_mask = DMA_BIT_MASK(32);
+
+	platform_set_drvdata(pdev, iss);
+
+	/* Clocks */
+	ret = iss_map_mem_resource(pdev, iss, OMAP4_ISS_MEM_TOP);
+	if (ret < 0)
+		goto error;
+
+	ret = iss_get_clocks(iss);
+	if (ret < 0)
+		goto error;
+
+	if (omap4iss_get(iss) == NULL)
+		goto error;
+
+	ret = iss_reset(iss);
+	if (ret < 0)
+		goto error_iss;
+
+	iss->revision = readl(iss->regs[OMAP4_ISS_MEM_TOP] + ISS_HL_REVISION);
+	dev_info(iss->dev, "Revision %08x found\n", iss->revision);
+
+	for (i = 1; i < OMAP4_ISS_MEM_LAST; i++) {
+		ret = iss_map_mem_resource(pdev, iss, i);
+		if (ret)
+			goto error_iss;
+	}
+
+	/* Interrupt */
+	iss->irq_num = platform_get_irq(pdev, 0);
+	if (iss->irq_num <= 0) {
+		dev_err(iss->dev, "No IRQ resource\n");
+		ret = -ENODEV;
+		goto error_iss;
+	}
+
+	if (request_irq(iss->irq_num, iss_isr, IRQF_SHARED, "OMAP4 ISS", iss)) {
+		dev_err(iss->dev, "Unable to request IRQ\n");
+		ret = -EINVAL;
+		goto error_iss;
+	}
+
+	/* Entities */
+	ret = iss_initialize_modules(iss);
+	if (ret < 0)
+		goto error_irq;
+
+	ret = iss_register_entities(iss);
+	if (ret < 0)
+		goto error_modules;
+
+	omap4iss_put(iss);
+
+	return 0;
+
+error_modules:
+	iss_cleanup_modules(iss);
+error_irq:
+	free_irq(iss->irq_num, iss);
+error_iss:
+	omap4iss_put(iss);
+error:
+	iss_put_clocks(iss);
+
+	for (i = 0; i < OMAP4_ISS_MEM_LAST; i++) {
+		if (iss->regs[i]) {
+			iounmap(iss->regs[i]);
+			iss->regs[i] = NULL;
+		}
+
+		if (iss->res[i]) {
+			release_mem_region(iss->res[i]->start,
+					   resource_size(iss->res[i]));
+			iss->res[i] = NULL;
+		}
+	}
+	platform_set_drvdata(pdev, NULL);
+
+	mutex_destroy(&iss->iss_mutex);
+	kfree(iss);
+
+	return ret;
+}
+
+static int iss_remove(struct platform_device *pdev)
+{
+	struct iss_device *iss = platform_get_drvdata(pdev);
+	int i;
+
+	iss_unregister_entities(iss);
+	iss_cleanup_modules(iss);
+
+	free_irq(iss->irq_num, iss);
+	iss_put_clocks(iss);
+
+	for (i = 0; i < OMAP4_ISS_MEM_LAST; i++) {
+		if (iss->regs[i]) {
+			iounmap(iss->regs[i]);
+			iss->regs[i] = NULL;
+		}
+
+		if (iss->res[i]) {
+			release_mem_region(iss->res[i]->start,
+					   resource_size(iss->res[i]));
+			iss->res[i] = NULL;
+		}
+	}
+
+	kfree(iss);
+
+	return 0;
+}
+
+static struct platform_device_id omap4iss_id_table[] = {
+	{ "omap4iss", 0 },
+	{ },
+};
+MODULE_DEVICE_TABLE(platform, omap4iss_id_table);
+
+static struct platform_driver iss_driver = {
+	.probe		= iss_probe,
+	.remove		= iss_remove,
+	.id_table	= omap4iss_id_table,
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= "omap4iss",
+	},
+};
+
+module_platform_driver(iss_driver);
+
+MODULE_DESCRIPTION("TI OMAP4 ISS driver");
+MODULE_AUTHOR("Sergio Aguirre <saaguirre@ti.com>");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(ISS_VIDEO_DRIVER_VERSION);
diff --git a/drivers/media/video/omap4iss/iss.h b/drivers/media/video/omap4iss/iss.h
new file mode 100644
index 0000000..45b0974
--- /dev/null
+++ b/drivers/media/video/omap4iss/iss.h
@@ -0,0 +1,121 @@
+/*
+ * TI OMAP4 ISS V4L2 Driver
+ *
+ * Copyright (C) 2012 Texas Instruments.
+ *
+ * Author: Sergio Aguirre <saaguirre@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef _OMAP4_ISS_H_
+#define _OMAP4_ISS_H_
+
+#include <media/v4l2-device.h>
+#include <linux/device.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
+#include <linux/wait.h>
+
+#include <media/omap4iss.h>
+
+#include "iss_regs.h"
+#include "iss_csiphy.h"
+#include "iss_csi2.h"
+
+#define to_iss_device(ptr_module)				\
+	container_of(ptr_module, struct iss_device, ptr_module)
+#define to_device(ptr_module)						\
+	(to_iss_device(ptr_module)->dev)
+
+enum iss_mem_resources {
+	OMAP4_ISS_MEM_TOP,
+	OMAP4_ISS_MEM_CSI2_A_REGS1,
+	OMAP4_ISS_MEM_CAMERARX_CORE1,
+	OMAP4_ISS_MEM_CSI2_B_REGS1,
+	OMAP4_ISS_MEM_CAMERARX_CORE2,
+	OMAP4_ISS_MEM_LAST,
+};
+
+enum iss_subclk_resource {
+	OMAP4_ISS_SUBCLK_SIMCOP		= (1 << 0),
+	OMAP4_ISS_SUBCLK_ISP		= (1 << 1),
+	OMAP4_ISS_SUBCLK_CSI2_A		= (1 << 2),
+	OMAP4_ISS_SUBCLK_CSI2_B		= (1 << 3),
+	OMAP4_ISS_SUBCLK_CCP2		= (1 << 4),
+};
+
+/*
+ * struct iss_reg - Structure for ISS register values.
+ * @reg: 32-bit Register address.
+ * @val: 32-bit Register value.
+ */
+struct iss_reg {
+	enum iss_mem_resources mmio_range;
+	u32 reg;
+	u32 val;
+};
+
+struct iss_device {
+	struct v4l2_device v4l2_dev;
+	struct media_device media_dev;
+	struct device *dev;
+	u32 revision;
+
+	/* platform HW resources */
+	struct iss_platform_data *pdata;
+	unsigned int irq_num;
+
+	struct resource *res[OMAP4_ISS_MEM_LAST];
+	void __iomem *regs[OMAP4_ISS_MEM_LAST];
+
+	u64 raw_dmamask;
+
+	struct mutex iss_mutex;	/* For handling ref_count field */
+	int has_context;
+	int ref_count;
+
+	struct clk *iss_fck;
+	struct clk *iss_ctrlclk;
+
+	/* ISS modules */
+	struct iss_csi2_device csi2a;
+	struct iss_csi2_device csi2b;
+	struct iss_csiphy csiphy1;
+	struct iss_csiphy csiphy2;
+
+	unsigned int subclk_resources;
+};
+
+#define v4l2_dev_to_iss_device(dev) \
+	container_of(dev, struct iss_device, v4l2_dev)
+
+int omap4iss_get_external_info(struct iss_pipeline *pipe,
+			       struct media_link *link);
+
+int omap4iss_module_sync_idle(struct media_entity *me, wait_queue_head_t *wait,
+			      atomic_t *stopping);
+
+int omap4iss_module_sync_is_stopping(wait_queue_head_t *wait,
+				     atomic_t *stopping);
+
+int omap4iss_pipeline_set_stream(struct iss_pipeline *pipe,
+				 enum iss_pipeline_stream_state state);
+
+struct iss_device *omap4iss_get(struct iss_device *iss);
+void omap4iss_put(struct iss_device *iss);
+int omap4iss_subclk_enable(struct iss_device *iss,
+			   enum iss_subclk_resource res);
+int omap4iss_subclk_disable(struct iss_device *iss,
+			    enum iss_subclk_resource res);
+
+int omap4iss_pipeline_pm_use(struct media_entity *entity, int use);
+
+int omap4iss_register_entities(struct platform_device *pdev,
+			       struct v4l2_device *v4l2_dev);
+void omap4iss_unregister_entities(struct platform_device *pdev);
+
+#endif /* _OMAP4_ISS_H_ */
diff --git a/drivers/media/video/omap4iss/iss_csi2.c b/drivers/media/video/omap4iss/iss_csi2.c
new file mode 100644
index 0000000..26a7775
--- /dev/null
+++ b/drivers/media/video/omap4iss/iss_csi2.c
@@ -0,0 +1,1368 @@
+/*
+ * TI OMAP4 ISS V4L2 Driver - CSI PHY module
+ *
+ * Copyright (C) 2012 Texas Instruments, Inc.
+ *
+ * Author: Sergio Aguirre <saaguirre@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/delay.h>
+#include <media/v4l2-common.h>
+#include <linux/v4l2-mediabus.h>
+#include <linux/mm.h>
+
+#include "iss.h"
+#include "iss_regs.h"
+#include "iss_csi2.h"
+
+/*
+ * csi2_if_enable - Enable CSI2 Receiver interface.
+ * @enable: enable flag
+ *
+ */
+static void csi2_if_enable(struct iss_csi2_device *csi2, u8 enable)
+{
+	struct iss_csi2_ctrl_cfg *currctrl = &csi2->ctrl;
+
+	writel((readl(csi2->regs1 + CSI2_CTRL) & ~CSI2_CTRL_IF_EN) |
+		(enable ? CSI2_CTRL_IF_EN : 0),
+		csi2->regs1 + CSI2_CTRL);
+
+	currctrl->if_enable = enable;
+}
+
+/*
+ * csi2_recv_config - CSI2 receiver module configuration.
+ * @currctrl: iss_csi2_ctrl_cfg structure
+ *
+ */
+static void csi2_recv_config(struct iss_csi2_device *csi2,
+			     struct iss_csi2_ctrl_cfg *currctrl)
+{
+	u32 reg = 0;
+
+	if (currctrl->frame_mode)
+		reg |= CSI2_CTRL_FRAME;
+	else
+		reg &= ~CSI2_CTRL_FRAME;
+
+	if (currctrl->vp_clk_enable)
+		reg |= CSI2_CTRL_VP_CLK_EN;
+	else
+		reg &= ~CSI2_CTRL_VP_CLK_EN;
+
+	if (currctrl->vp_only_enable)
+		reg |= CSI2_CTRL_VP_ONLY_EN;
+	else
+		reg &= ~CSI2_CTRL_VP_ONLY_EN;
+
+	reg &= ~CSI2_CTRL_VP_OUT_CTRL_MASK;
+	reg |= currctrl->vp_out_ctrl << CSI2_CTRL_VP_OUT_CTRL_SHIFT;
+
+	if (currctrl->ecc_enable)
+		reg |= CSI2_CTRL_ECC_EN;
+	else
+		reg &= ~CSI2_CTRL_ECC_EN;
+
+	/*
+	 * Set MFlag assertion boundaries to:
+	 * Low: 4/8 of FIFO size
+	 * High: 6/8 of FIFO size
+	 */
+	reg &= ~(CSI2_CTRL_MFLAG_LEVH_MASK | CSI2_CTRL_MFLAG_LEVL_MASK);
+	reg |= (2 << CSI2_CTRL_MFLAG_LEVH_SHIFT) |
+	       (4 << CSI2_CTRL_MFLAG_LEVL_SHIFT);
+
+	/* Generation of 16x64-bit bursts (Recommended) */
+	reg |= CSI2_CTRL_BURST_SIZE_EXPAND;
+
+	/* Do Non-Posted writes (Recommended) */
+	reg |= CSI2_CTRL_NON_POSTED_WRITE;
+
+	/*
+	 * Enforce Little endian for all formats, including:
+	 * YUV4:2:2 8-bit and YUV4:2:0 Legacy
+	 */
+	reg |= CSI2_CTRL_ENDIANNESS;
+
+	writel(reg, csi2->regs1 + CSI2_CTRL);
+}
+
+static const unsigned int csi2_input_fmts[] = {
+	V4L2_MBUS_FMT_SGRBG10_1X10,
+	V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8,
+	V4L2_MBUS_FMT_SRGGB10_1X10,
+	V4L2_MBUS_FMT_SRGGB10_DPCM8_1X8,
+	V4L2_MBUS_FMT_SBGGR10_1X10,
+	V4L2_MBUS_FMT_SBGGR10_DPCM8_1X8,
+	V4L2_MBUS_FMT_SGBRG10_1X10,
+	V4L2_MBUS_FMT_SGBRG10_DPCM8_1X8,
+	V4L2_MBUS_FMT_SBGGR8_1X8,
+	V4L2_MBUS_FMT_SGBRG8_1X8,
+	V4L2_MBUS_FMT_SGRBG8_1X8,
+	V4L2_MBUS_FMT_SRGGB8_1X8,
+	V4L2_MBUS_FMT_UYVY8_1X16,
+	V4L2_MBUS_FMT_YUYV8_1X16,
+};
+
+/* To set the format on the CSI2 requires a mapping function that takes
+ * the following inputs:
+ * - 3 different formats (at this time)
+ * - 2 destinations (mem, vp+mem) (vp only handled separately)
+ * - 2 decompression options (on, off)
+ * Output should be CSI2 frame format code
+ * Array indices as follows: [format][dest][decompr]
+ * Not all combinations are valid. 0 means invalid.
+ */
+static const u16 __csi2_fmt_map[][2][2] = {
+	/* RAW10 formats */
+	{
+		/* Output to memory */
+		{
+			/* No DPCM decompression */
+			CSI2_PIX_FMT_RAW10_EXP16,
+			/* DPCM decompression */
+			0,
+		},
+		/* Output to both */
+		{
+			/* No DPCM decompression */
+			CSI2_PIX_FMT_RAW10_EXP16_VP,
+			/* DPCM decompression */
+			0,
+		},
+	},
+	/* RAW10 DPCM8 formats */
+	{
+		/* Output to memory */
+		{
+			/* No DPCM decompression */
+			CSI2_USERDEF_8BIT_DATA1,
+			/* DPCM decompression */
+			CSI2_USERDEF_8BIT_DATA1_DPCM10,
+		},
+		/* Output to both */
+		{
+			/* No DPCM decompression */
+			CSI2_PIX_FMT_RAW8_VP,
+			/* DPCM decompression */
+			CSI2_USERDEF_8BIT_DATA1_DPCM10_VP,
+		},
+	},
+	/* RAW8 formats */
+	{
+		/* Output to memory */
+		{
+			/* No DPCM decompression */
+			CSI2_PIX_FMT_RAW8,
+			/* DPCM decompression */
+			0,
+		},
+		/* Output to both */
+		{
+			/* No DPCM decompression */
+			CSI2_PIX_FMT_RAW8_VP,
+			/* DPCM decompression */
+			0,
+		},
+	},
+	/* YUV422 formats */
+	{
+		/* Output to memory */
+		{
+			/* No DPCM decompression */
+			CSI2_PIX_FMT_YUV422_8BIT,
+			/* DPCM decompression */
+			0,
+		},
+		/* Output to both */
+		{
+			/* No DPCM decompression */
+			CSI2_PIX_FMT_YUV422_8BIT_VP,
+			/* DPCM decompression */
+			0,
+		},
+	},
+};
+
+/*
+ * csi2_ctx_map_format - Map CSI2 sink media bus format to CSI2 format ID
+ * @csi2: ISS CSI2 device
+ *
+ * Returns CSI2 physical format id
+ */
+static u16 csi2_ctx_map_format(struct iss_csi2_device *csi2)
+{
+	const struct v4l2_mbus_framefmt *fmt = &csi2->formats[CSI2_PAD_SINK];
+	int fmtidx, destidx;
+
+	switch (fmt->code) {
+	case V4L2_MBUS_FMT_SGRBG10_1X10:
+	case V4L2_MBUS_FMT_SRGGB10_1X10:
+	case V4L2_MBUS_FMT_SBGGR10_1X10:
+	case V4L2_MBUS_FMT_SGBRG10_1X10:
+		fmtidx = 0;
+		break;
+	case V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8:
+	case V4L2_MBUS_FMT_SRGGB10_DPCM8_1X8:
+	case V4L2_MBUS_FMT_SBGGR10_DPCM8_1X8:
+	case V4L2_MBUS_FMT_SGBRG10_DPCM8_1X8:
+		fmtidx = 1;
+		break;
+	case V4L2_MBUS_FMT_SBGGR8_1X8:
+	case V4L2_MBUS_FMT_SGBRG8_1X8:
+	case V4L2_MBUS_FMT_SGRBG8_1X8:
+	case V4L2_MBUS_FMT_SRGGB8_1X8:
+		fmtidx = 2;
+		break;
+	case V4L2_MBUS_FMT_UYVY8_1X16:
+	case V4L2_MBUS_FMT_YUYV8_1X16:
+		fmtidx = 3;
+		break;
+	default:
+		WARN(1, KERN_ERR "CSI2: pixel format %08x unsupported!\n",
+		     fmt->code);
+		return 0;
+	}
+
+	if (!(csi2->output & CSI2_OUTPUT_IPIPEIF) &&
+	    !(csi2->output & CSI2_OUTPUT_MEMORY)) {
+		/* Neither output enabled is a valid combination */
+		return CSI2_PIX_FMT_OTHERS;
+	}
+
+	/* If we need to skip frames at the beginning of the stream disable the
+	 * video port to avoid sending the skipped frames to the IPIPEIF.
+	 */
+	destidx = csi2->frame_skip ? 0 : !!(csi2->output & CSI2_OUTPUT_IPIPEIF);
+
+	return __csi2_fmt_map[fmtidx][destidx][csi2->dpcm_decompress];
+}
+
+/*
+ * csi2_set_outaddr - Set memory address to save output image
+ * @csi2: Pointer to ISS CSI2a device.
+ * @addr: 32-bit memory address aligned on 32 byte boundary.
+ *
+ * Sets the memory address where the output will be saved.
+ *
+ * Returns 0 if successful, or -EINVAL if the address is not in the 32 byte
+ * boundary.
+ */
+static void csi2_set_outaddr(struct iss_csi2_device *csi2, u32 addr)
+{
+	struct iss_csi2_ctx_cfg *ctx = &csi2->contexts[0];
+
+	ctx->ping_addr = addr;
+	ctx->pong_addr = addr;
+	writel(ctx->ping_addr,
+	       csi2->regs1 + CSI2_CTX_PING_ADDR(ctx->ctxnum));
+	writel(ctx->pong_addr,
+	       csi2->regs1 + CSI2_CTX_PONG_ADDR(ctx->ctxnum));
+}
+
+/*
+ * is_usr_def_mapping - Checks whether USER_DEF_MAPPING should
+ *			be enabled by CSI2.
+ * @format_id: mapped format id
+ *
+ */
+static inline int is_usr_def_mapping(u32 format_id)
+{
+	return ((format_id & 0xF0) == 0x40) ? 1 : 0;
+}
+
+/*
+ * csi2_ctx_enable - Enable specified CSI2 context
+ * @ctxnum: Context number, valid between 0 and 7 values.
+ * @enable: enable
+ *
+ */
+static void csi2_ctx_enable(struct iss_csi2_device *csi2, u8 ctxnum, u8 enable)
+{
+	struct iss_csi2_ctx_cfg *ctx = &csi2->contexts[ctxnum];
+	u32 reg;
+
+	reg = readl(csi2->regs1 + CSI2_CTX_CTRL1(ctxnum));
+
+	if (enable) {
+		unsigned int skip = 0;
+
+		if (csi2->frame_skip)
+			skip = csi2->frame_skip;
+		else if (csi2->output & CSI2_OUTPUT_MEMORY)
+			skip = 1;
+
+		reg &= ~CSI2_CTX_CTRL1_COUNT_MASK;
+		reg |= CSI2_CTX_CTRL1_COUNT_UNLOCK
+		    |  (skip << CSI2_CTX_CTRL1_COUNT_SHIFT)
+		    |  CSI2_CTX_CTRL1_CTX_EN;
+	} else {
+		reg &= ~CSI2_CTX_CTRL1_CTX_EN;
+	}
+
+	writel(reg, csi2->regs1 + CSI2_CTX_CTRL1(ctxnum));
+	ctx->enabled = enable;
+}
+
+/*
+ * csi2_ctx_config - CSI2 context configuration.
+ * @ctx: context configuration
+ *
+ */
+static void csi2_ctx_config(struct iss_csi2_device *csi2,
+			    struct iss_csi2_ctx_cfg *ctx)
+{
+	u32 reg;
+
+	/* Set up CSI2_CTx_CTRL1 */
+	if (ctx->eof_enabled)
+		reg = CSI2_CTX_CTRL1_EOF_EN;
+
+	if (ctx->eol_enabled)
+		reg |= CSI2_CTX_CTRL1_EOL_EN;
+
+	if (ctx->checksum_enabled)
+		reg |= CSI2_CTX_CTRL1_CS_EN;
+
+	writel(reg, csi2->regs1 + CSI2_CTX_CTRL1(ctx->ctxnum));
+
+	/* Set up CSI2_CTx_CTRL2 */
+	reg = ctx->virtual_id << CSI2_CTX_CTRL2_VIRTUAL_ID_SHIFT;
+	reg |= ctx->format_id << CSI2_CTX_CTRL2_FORMAT_SHIFT;
+
+	if (ctx->dpcm_decompress && ctx->dpcm_predictor)
+		reg |= CSI2_CTX_CTRL2_DPCM_PRED;
+
+	if (is_usr_def_mapping(ctx->format_id))
+		reg |= 2 << CSI2_CTX_CTRL2_USER_DEF_MAP_SHIFT;
+
+	writel(reg, csi2->regs1 + CSI2_CTX_CTRL2(ctx->ctxnum));
+
+	/* Set up CSI2_CTx_CTRL3 */
+	writel(ctx->alpha << CSI2_CTX_CTRL3_ALPHA_SHIFT,
+		csi2->regs1 + CSI2_CTX_CTRL3(ctx->ctxnum));
+
+	/* Set up CSI2_CTx_DAT_OFST */
+	reg = readl(csi2->regs1 + CSI2_CTX_DAT_OFST(ctx->ctxnum));
+	reg &= ~CSI2_CTX_DAT_OFST_MASK;
+	reg |= ctx->data_offset;
+	writel(reg, csi2->regs1 + CSI2_CTX_DAT_OFST(ctx->ctxnum));
+
+	writel(ctx->ping_addr,
+		       csi2->regs1 + CSI2_CTX_PING_ADDR(ctx->ctxnum));
+
+	writel(ctx->pong_addr,
+		       csi2->regs1 + CSI2_CTX_PONG_ADDR(ctx->ctxnum));
+}
+
+/*
+ * csi2_timing_config - CSI2 timing configuration.
+ * @timing: csi2_timing_cfg structure
+ */
+static void csi2_timing_config(struct iss_csi2_device *csi2,
+			       struct iss_csi2_timing_cfg *timing)
+{
+	u32 reg;
+
+	reg = readl(csi2->regs1 + CSI2_TIMING);
+
+	if (timing->force_rx_mode)
+		reg |= CSI2_TIMING_FORCE_RX_MODE_IO1;
+	else
+		reg &= ~CSI2_TIMING_FORCE_RX_MODE_IO1;
+
+	if (timing->stop_state_16x)
+		reg |= CSI2_TIMING_STOP_STATE_X16_IO1;
+	else
+		reg &= ~CSI2_TIMING_STOP_STATE_X16_IO1;
+
+	if (timing->stop_state_4x)
+		reg |= CSI2_TIMING_STOP_STATE_X4_IO1;
+	else
+		reg &= ~CSI2_TIMING_STOP_STATE_X4_IO1;
+
+	reg &= ~CSI2_TIMING_STOP_STATE_COUNTER_IO1_MASK;
+	reg |= timing->stop_state_counter <<
+	       CSI2_TIMING_STOP_STATE_COUNTER_IO1_SHIFT;
+
+	writel(reg, csi2->regs1 + CSI2_TIMING);
+}
+
+/*
+ * csi2_irq_ctx_set - Enables CSI2 Context IRQs.
+ * @enable: Enable/disable CSI2 Context interrupts
+ */
+static void csi2_irq_ctx_set(struct iss_csi2_device *csi2, int enable)
+{
+	u32 reg = CSI2_CTX_IRQ_FE;
+	int i;
+
+	if (csi2->use_fs_irq)
+		reg |= CSI2_CTX_IRQ_FS;
+
+	for (i = 0; i < 8; i++) {
+		writel(reg, csi2->regs1 + CSI2_CTX_IRQSTATUS(i));
+		if (enable)
+			writel(readl(csi2->regs1 + CSI2_CTX_IRQENABLE(i)) | reg,
+				csi2->regs1 + CSI2_CTX_IRQENABLE(i));
+		else
+			writel(readl(csi2->regs1 + CSI2_CTX_IRQENABLE(i)) &
+				~reg,
+				csi2->regs1 + CSI2_CTX_IRQENABLE(i));
+	}
+}
+
+/*
+ * csi2_irq_complexio1_set - Enables CSI2 ComplexIO IRQs.
+ * @enable: Enable/disable CSI2 ComplexIO #1 interrupts
+ */
+static void csi2_irq_complexio1_set(struct iss_csi2_device *csi2, int enable)
+{
+	u32 reg;
+	reg = CSI2_COMPLEXIO_IRQ_STATEALLULPMEXIT |
+		CSI2_COMPLEXIO_IRQ_STATEALLULPMENTER |
+		CSI2_COMPLEXIO_IRQ_STATEULPM5 |
+		CSI2_COMPLEXIO_IRQ_ERRCONTROL5 |
+		CSI2_COMPLEXIO_IRQ_ERRESC5 |
+		CSI2_COMPLEXIO_IRQ_ERRSOTSYNCHS5 |
+		CSI2_COMPLEXIO_IRQ_ERRSOTHS5 |
+		CSI2_COMPLEXIO_IRQ_STATEULPM4 |
+		CSI2_COMPLEXIO_IRQ_ERRCONTROL4 |
+		CSI2_COMPLEXIO_IRQ_ERRESC4 |
+		CSI2_COMPLEXIO_IRQ_ERRSOTSYNCHS4 |
+		CSI2_COMPLEXIO_IRQ_ERRSOTHS4 |
+		CSI2_COMPLEXIO_IRQ_STATEULPM3 |
+		CSI2_COMPLEXIO_IRQ_ERRCONTROL3 |
+		CSI2_COMPLEXIO_IRQ_ERRESC3 |
+		CSI2_COMPLEXIO_IRQ_ERRSOTSYNCHS3 |
+		CSI2_COMPLEXIO_IRQ_ERRSOTHS3 |
+		CSI2_COMPLEXIO_IRQ_STATEULPM2 |
+		CSI2_COMPLEXIO_IRQ_ERRCONTROL2 |
+		CSI2_COMPLEXIO_IRQ_ERRESC2 |
+		CSI2_COMPLEXIO_IRQ_ERRSOTSYNCHS2 |
+		CSI2_COMPLEXIO_IRQ_ERRSOTHS2 |
+		CSI2_COMPLEXIO_IRQ_STATEULPM1 |
+		CSI2_COMPLEXIO_IRQ_ERRCONTROL1 |
+		CSI2_COMPLEXIO_IRQ_ERRESC1 |
+		CSI2_COMPLEXIO_IRQ_ERRSOTSYNCHS1 |
+		CSI2_COMPLEXIO_IRQ_ERRSOTHS1;
+	writel(reg, csi2->regs1 + CSI2_COMPLEXIO_IRQSTATUS);
+	if (enable)
+		reg |= readl(csi2->regs1 + CSI2_COMPLEXIO_IRQENABLE);
+	else
+		reg = 0;
+	writel(reg, csi2->regs1 + CSI2_COMPLEXIO_IRQENABLE);
+}
+
+/*
+ * csi2_irq_status_set - Enables CSI2 Status IRQs.
+ * @enable: Enable/disable CSI2 Status interrupts
+ */
+static void csi2_irq_status_set(struct iss_csi2_device *csi2, int enable)
+{
+	u32 reg;
+	reg = CSI2_IRQ_OCP_ERR |
+		CSI2_IRQ_SHORT_PACKET |
+		CSI2_IRQ_ECC_CORRECTION |
+		CSI2_IRQ_ECC_NO_CORRECTION |
+		CSI2_IRQ_COMPLEXIO_ERR |
+		CSI2_IRQ_FIFO_OVF |
+		CSI2_IRQ_CONTEXT0;
+	writel(reg, csi2->regs1 + CSI2_IRQSTATUS);
+	if (enable)
+		reg |= readl(csi2->regs1 + CSI2_IRQENABLE);
+	else
+		reg = 0;
+
+	writel(reg, csi2->regs1 + CSI2_IRQENABLE);
+}
+
+/*
+ * omap4iss_csi2_reset - Resets the CSI2 module.
+ *
+ * Must be called with the phy lock held.
+ *
+ * Returns 0 if successful, or -EBUSY if power command didn't respond.
+ */
+int omap4iss_csi2_reset(struct iss_csi2_device *csi2)
+{
+	u8 soft_reset_retries = 0;
+	u32 reg;
+	int i;
+
+	if (!csi2->available)
+		return -ENODEV;
+
+	if (csi2->phy->phy_in_use)
+		return -EBUSY;
+
+	writel(readl(csi2->regs1 + CSI2_SYSCONFIG) |
+		CSI2_SYSCONFIG_SOFT_RESET,
+		csi2->regs1 + CSI2_SYSCONFIG);
+
+	do {
+		reg = readl(csi2->regs1 + CSI2_SYSSTATUS) &
+				    CSI2_SYSSTATUS_RESET_DONE;
+		if (reg == CSI2_SYSSTATUS_RESET_DONE)
+			break;
+		soft_reset_retries++;
+		if (soft_reset_retries < 5)
+			usleep_range(100, 100);
+	} while (soft_reset_retries < 5);
+
+	if (soft_reset_retries == 5) {
+		printk(KERN_ERR "CSI2: Soft reset try count exceeded!\n");
+		return -EBUSY;
+	}
+
+	writel(readl(csi2->regs1 + CSI2_COMPLEXIO_CFG) |
+		CSI2_COMPLEXIO_CFG_RESET_CTRL,
+		csi2->regs1 + CSI2_COMPLEXIO_CFG);
+
+	i = 100;
+	do {
+		reg = readl(csi2->phy->phy_regs + REGISTER1)
+		    & REGISTER1_RESET_DONE_CTRLCLK;
+		if (reg == REGISTER1_RESET_DONE_CTRLCLK)
+			break;
+		usleep_range(100, 100);
+	} while (--i > 0);
+
+	if (i == 0) {
+		printk(KERN_ERR
+		       "CSI2: Reset for CSI2_96M_FCLK domain Failed!\n");
+		return -EBUSY;
+	}
+
+	writel((readl(csi2->regs1 + CSI2_SYSCONFIG) &
+		~(CSI2_SYSCONFIG_MSTANDBY_MODE_MASK |
+		  CSI2_SYSCONFIG_AUTO_IDLE)) |
+		CSI2_SYSCONFIG_MSTANDBY_MODE_NO,
+		csi2->regs1 + CSI2_SYSCONFIG);
+
+	return 0;
+}
+
+static int csi2_configure(struct iss_csi2_device *csi2)
+{
+	const struct iss_v4l2_subdevs_group *pdata;
+	struct iss_csi2_timing_cfg *timing = &csi2->timing[0];
+	struct v4l2_subdev *sensor;
+	struct media_pad *pad;
+
+	/*
+	 * CSI2 fields that can be updated while the context has
+	 * been enabled or the interface has been enabled are not
+	 * updated dynamically currently. So we do not allow to
+	 * reconfigure if either has been enabled
+	 */
+	if (csi2->contexts[0].enabled || csi2->ctrl.if_enable)
+		return -EBUSY;
+
+	pad = media_entity_remote_source(&csi2->pads[CSI2_PAD_SINK]);
+	sensor = media_entity_to_v4l2_subdev(pad->entity);
+	pdata = sensor->host_priv;
+
+	csi2->frame_skip = 0;
+	v4l2_subdev_call(sensor, sensor, g_skip_frames, &csi2->frame_skip);
+
+	csi2->ctrl.vp_out_ctrl = pdata->bus.csi2.vpclk_div;
+	csi2->ctrl.frame_mode = ISS_CSI2_FRAME_IMMEDIATE;
+	csi2->ctrl.ecc_enable = pdata->bus.csi2.crc;
+
+	timing->force_rx_mode = 1;
+	timing->stop_state_16x = 1;
+	timing->stop_state_4x = 1;
+	timing->stop_state_counter = 0x1FF;
+
+	/*
+	 * The CSI2 receiver can't do any format conversion except DPCM
+	 * decompression, so every set_format call configures both pads
+	 * and enables DPCM decompression as a special case:
+	 */
+	if (csi2->formats[CSI2_PAD_SINK].code !=
+	    csi2->formats[CSI2_PAD_SOURCE].code)
+		csi2->dpcm_decompress = true;
+	else
+		csi2->dpcm_decompress = false;
+
+	csi2->contexts[0].format_id = csi2_ctx_map_format(csi2);
+
+	if (csi2->video_out.bpl_padding == 0)
+		csi2->contexts[0].data_offset = 0;
+	else
+		csi2->contexts[0].data_offset = csi2->video_out.bpl_value;
+
+	/*
+	 * Enable end of frame and end of line signals generation for
+	 * context 0. These signals are generated from CSI2 receiver to
+	 * qualify the last pixel of a frame and the last pixel of a line.
+	 * Without enabling the signals CSI2 receiver writes data to memory
+	 * beyond buffer size and/or data line offset is not handled correctly.
+	 */
+	csi2->contexts[0].eof_enabled = 1;
+	csi2->contexts[0].eol_enabled = 1;
+
+	csi2_irq_complexio1_set(csi2, 1);
+	csi2_irq_ctx_set(csi2, 1);
+	csi2_irq_status_set(csi2, 1);
+
+	/* Set configuration (timings, format and links) */
+	csi2_timing_config(csi2, timing);
+	csi2_recv_config(csi2, &csi2->ctrl);
+	csi2_ctx_config(csi2, &csi2->contexts[0]);
+
+	return 0;
+}
+
+/*
+ * csi2_print_status - Prints CSI2 debug information.
+ */
+#define CSI2_PRINT_REGISTER(iss, regs, name)\
+	dev_dbg(iss->dev, "###CSI2 " #name "=0x%08x\n", \
+		readl(regs + CSI2_##name))
+
+static void csi2_print_status(struct iss_csi2_device *csi2)
+{
+	struct iss_device *iss = csi2->iss;
+
+	if (!csi2->available)
+		return;
+
+	dev_dbg(iss->dev, "-------------CSI2 Register dump-------------\n");
+
+	CSI2_PRINT_REGISTER(iss, csi2->regs1, SYSCONFIG);
+	CSI2_PRINT_REGISTER(iss, csi2->regs1, SYSSTATUS);
+	CSI2_PRINT_REGISTER(iss, csi2->regs1, IRQENABLE);
+	CSI2_PRINT_REGISTER(iss, csi2->regs1, IRQSTATUS);
+	CSI2_PRINT_REGISTER(iss, csi2->regs1, CTRL);
+	CSI2_PRINT_REGISTER(iss, csi2->regs1, DBG_H);
+	CSI2_PRINT_REGISTER(iss, csi2->regs1, COMPLEXIO_CFG);
+	CSI2_PRINT_REGISTER(iss, csi2->regs1, COMPLEXIO_IRQSTATUS);
+	CSI2_PRINT_REGISTER(iss, csi2->regs1, SHORT_PACKET);
+	CSI2_PRINT_REGISTER(iss, csi2->regs1, COMPLEXIO_IRQENABLE);
+	CSI2_PRINT_REGISTER(iss, csi2->regs1, DBG_P);
+	CSI2_PRINT_REGISTER(iss, csi2->regs1, TIMING);
+	CSI2_PRINT_REGISTER(iss, csi2->regs1, CTX_CTRL1(0));
+	CSI2_PRINT_REGISTER(iss, csi2->regs1, CTX_CTRL2(0));
+	CSI2_PRINT_REGISTER(iss, csi2->regs1, CTX_DAT_OFST(0));
+	CSI2_PRINT_REGISTER(iss, csi2->regs1, CTX_PING_ADDR(0));
+	CSI2_PRINT_REGISTER(iss, csi2->regs1, CTX_PONG_ADDR(0));
+	CSI2_PRINT_REGISTER(iss, csi2->regs1, CTX_IRQENABLE(0));
+	CSI2_PRINT_REGISTER(iss, csi2->regs1, CTX_IRQSTATUS(0));
+	CSI2_PRINT_REGISTER(iss, csi2->regs1, CTX_CTRL3(0));
+
+	dev_dbg(iss->dev, "--------------------------------------------\n");
+}
+
+/* -----------------------------------------------------------------------------
+ * Interrupt handling
+ */
+
+/*
+ * csi2_isr_buffer - Does buffer handling at end-of-frame
+ * when writing to memory.
+ */
+static void csi2_isr_buffer(struct iss_csi2_device *csi2)
+{
+	struct iss_buffer *buffer;
+
+	csi2_ctx_enable(csi2, 0, 0);
+
+	buffer = omap4iss_video_buffer_next(&csi2->video_out);
+
+	/*
+	 * Let video queue operation restart engine if there is an underrun
+	 * condition.
+	 */
+	if (buffer == NULL)
+		return;
+
+	csi2_set_outaddr(csi2, buffer->iss_addr);
+	csi2_ctx_enable(csi2, 0, 1);
+}
+
+static void csi2_isr_ctx(struct iss_csi2_device *csi2,
+			 struct iss_csi2_ctx_cfg *ctx)
+{
+	unsigned int n = ctx->ctxnum;
+	u32 status;
+
+	status = readl(csi2->regs1 + CSI2_CTX_IRQSTATUS(n));
+	writel(status, csi2->regs1 + CSI2_CTX_IRQSTATUS(n));
+
+	/* Propagate frame number */
+	if (status & CSI2_CTX_IRQ_FS) {
+		struct iss_pipeline *pipe =
+				     to_iss_pipeline(&csi2->subdev.entity);
+		if (pipe->do_propagation)
+			atomic_inc(&pipe->frame_number);
+	}
+
+	if (!(status & CSI2_CTX_IRQ_FE))
+		return;
+
+	/* Skip interrupts until we reach the frame skip count. The CSI2 will be
+	 * automatically disabled, as the frame skip count has been programmed
+	 * in the CSI2_CTx_CTRL1::COUNT field, so reenable it.
+	 *
+	 * It would have been nice to rely on the FRAME_NUMBER interrupt instead
+	 * but it turned out that the interrupt is only generated when the CSI2
+	 * writes to memory (the CSI2_CTx_CTRL1::COUNT field is decreased
+	 * correctly and reaches 0 when data is forwarded to the video port only
+	 * but no interrupt arrives). Maybe a CSI2 hardware bug.
+	 */
+	if (csi2->frame_skip) {
+		csi2->frame_skip--;
+		if (csi2->frame_skip == 0) {
+			ctx->format_id = csi2_ctx_map_format(csi2);
+			csi2_ctx_config(csi2, ctx);
+			csi2_ctx_enable(csi2, n, 1);
+		}
+		return;
+	}
+
+	if (csi2->output & CSI2_OUTPUT_MEMORY)
+		csi2_isr_buffer(csi2);
+}
+
+/*
+ * omap4iss_csi2_isr - CSI2 interrupt handling.
+ */
+void omap4iss_csi2_isr(struct iss_csi2_device *csi2)
+{
+	struct iss_pipeline *pipe = to_iss_pipeline(&csi2->subdev.entity);
+	u32 csi2_irqstatus, cpxio1_irqstatus;
+	struct iss_device *iss = csi2->iss;
+
+	if (!csi2->available)
+		return;
+
+	csi2_irqstatus = readl(csi2->regs1 + CSI2_IRQSTATUS);
+	writel(csi2_irqstatus, csi2->regs1 + CSI2_IRQSTATUS);
+
+	/* Failure Cases */
+	if (csi2_irqstatus & CSI2_IRQ_COMPLEXIO_ERR) {
+		cpxio1_irqstatus = readl(csi2->regs1 +
+					 CSI2_COMPLEXIO_IRQSTATUS);
+		writel(cpxio1_irqstatus,
+			csi2->regs1 + CSI2_COMPLEXIO_IRQSTATUS);
+		dev_dbg(iss->dev, "CSI2: ComplexIO Error IRQ "
+			"%x\n", cpxio1_irqstatus);
+		pipe->error = true;
+	}
+
+	if (csi2_irqstatus & (CSI2_IRQ_OCP_ERR |
+			      CSI2_IRQ_SHORT_PACKET |
+			      CSI2_IRQ_ECC_NO_CORRECTION |
+			      CSI2_IRQ_COMPLEXIO_ERR |
+			      CSI2_IRQ_FIFO_OVF)) {
+		dev_dbg(iss->dev, "CSI2 Err:"
+			" OCP:%d,"
+			" Short_pack:%d,"
+			" ECC:%d,"
+			" CPXIO:%d,"
+			" FIFO_OVF:%d,"
+			"\n",
+			(csi2_irqstatus &
+			 CSI2_IRQ_OCP_ERR) ? 1 : 0,
+			(csi2_irqstatus &
+			 CSI2_IRQ_SHORT_PACKET) ? 1 : 0,
+			(csi2_irqstatus &
+			 CSI2_IRQ_ECC_NO_CORRECTION) ? 1 : 0,
+			(csi2_irqstatus &
+			 CSI2_IRQ_COMPLEXIO_ERR) ? 1 : 0,
+			(csi2_irqstatus &
+			 CSI2_IRQ_FIFO_OVF) ? 1 : 0);
+		pipe->error = true;
+	}
+
+	if (omap4iss_module_sync_is_stopping(&csi2->wait, &csi2->stopping))
+		return;
+
+	/* Successful cases */
+	if (csi2_irqstatus & CSI2_IRQ_CONTEXT0)
+		csi2_isr_ctx(csi2, &csi2->contexts[0]);
+
+	if (csi2_irqstatus & CSI2_IRQ_ECC_CORRECTION)
+		dev_dbg(iss->dev, "CSI2: ECC correction done\n");
+}
+
+/* -----------------------------------------------------------------------------
+ * ISS video operations
+ */
+
+/*
+ * csi2_queue - Queues the first buffer when using memory output
+ * @video: The video node
+ * @buffer: buffer to queue
+ */
+static int csi2_queue(struct iss_video *video, struct iss_buffer *buffer)
+{
+	struct iss_csi2_device *csi2 = container_of(video,
+				struct iss_csi2_device, video_out);
+
+	csi2_set_outaddr(csi2, buffer->iss_addr);
+
+	/*
+	 * If streaming was enabled before there was a buffer queued
+	 * or underrun happened in the ISR, the hardware was not enabled
+	 * and DMA queue flag ISS_VIDEO_DMAQUEUE_UNDERRUN is still set.
+	 * Enable it now.
+	 */
+	if (csi2->video_out.dmaqueue_flags & ISS_VIDEO_DMAQUEUE_UNDERRUN) {
+		/* Enable / disable context 0 and IRQs */
+		csi2_if_enable(csi2, 1);
+		csi2_ctx_enable(csi2, 0, 1);
+		iss_video_dmaqueue_flags_clr(&csi2->video_out);
+	}
+
+	return 0;
+}
+
+static const struct iss_video_operations csi2_issvideo_ops = {
+	.queue = csi2_queue,
+};
+
+/* -----------------------------------------------------------------------------
+ * V4L2 subdev operations
+ */
+
+static struct v4l2_mbus_framefmt *
+__csi2_get_format(struct iss_csi2_device *csi2, struct v4l2_subdev_fh *fh,
+		  unsigned int pad, enum v4l2_subdev_format_whence which)
+{
+	if (which == V4L2_SUBDEV_FORMAT_TRY)
+		return v4l2_subdev_get_try_format(fh, pad);
+	else
+		return &csi2->formats[pad];
+}
+
+static void
+csi2_try_format(struct iss_csi2_device *csi2, struct v4l2_subdev_fh *fh,
+		unsigned int pad, struct v4l2_mbus_framefmt *fmt,
+		enum v4l2_subdev_format_whence which)
+{
+	enum v4l2_mbus_pixelcode pixelcode;
+	struct v4l2_mbus_framefmt *format;
+	const struct iss_format_info *info;
+	unsigned int i;
+
+	switch (pad) {
+	case CSI2_PAD_SINK:
+		/* Clamp the width and height to valid range (1-8191). */
+		for (i = 0; i < ARRAY_SIZE(csi2_input_fmts); i++) {
+			if (fmt->code == csi2_input_fmts[i])
+				break;
+		}
+
+		/* If not found, use SGRBG10 as default */
+		if (i >= ARRAY_SIZE(csi2_input_fmts))
+			fmt->code = V4L2_MBUS_FMT_SGRBG10_1X10;
+
+		fmt->width = clamp_t(u32, fmt->width, 1, 8191);
+		fmt->height = clamp_t(u32, fmt->height, 1, 8191);
+		break;
+
+	case CSI2_PAD_SOURCE:
+		/* Source format same as sink format, except for DPCM
+		 * compression.
+		 */
+		pixelcode = fmt->code;
+		format = __csi2_get_format(csi2, fh, CSI2_PAD_SINK, which);
+		memcpy(fmt, format, sizeof(*fmt));
+
+		/*
+		 * Only Allow DPCM decompression, and check that the
+		 * pattern is preserved
+		 */
+		info = omap4iss_video_format_info(fmt->code);
+		if (info->uncompressed == pixelcode)
+			fmt->code = pixelcode;
+		break;
+	}
+
+	/* RGB, non-interlaced */
+	fmt->colorspace = V4L2_COLORSPACE_SRGB;
+	fmt->field = V4L2_FIELD_NONE;
+}
+
+/*
+ * csi2_enum_mbus_code - Handle pixel format enumeration
+ * @sd     : pointer to v4l2 subdev structure
+ * @fh     : V4L2 subdev file handle
+ * @code   : pointer to v4l2_subdev_mbus_code_enum structure
+ * return -EINVAL or zero on success
+ */
+static int csi2_enum_mbus_code(struct v4l2_subdev *sd,
+			       struct v4l2_subdev_fh *fh,
+			       struct v4l2_subdev_mbus_code_enum *code)
+{
+	struct iss_csi2_device *csi2 = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *format;
+	const struct iss_format_info *info;
+
+	if (code->pad == CSI2_PAD_SINK) {
+		if (code->index >= ARRAY_SIZE(csi2_input_fmts))
+			return -EINVAL;
+
+		code->code = csi2_input_fmts[code->index];
+	} else {
+		format = __csi2_get_format(csi2, fh, CSI2_PAD_SINK,
+					   V4L2_SUBDEV_FORMAT_TRY);
+		switch (code->index) {
+		case 0:
+			/* Passthrough sink pad code */
+			code->code = format->code;
+			break;
+		case 1:
+			/* Uncompressed code */
+			info = omap4iss_video_format_info(format->code);
+			if (info->uncompressed == format->code)
+				return -EINVAL;
+
+			code->code = info->uncompressed;
+			break;
+		default:
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+static int csi2_enum_frame_size(struct v4l2_subdev *sd,
+				struct v4l2_subdev_fh *fh,
+				struct v4l2_subdev_frame_size_enum *fse)
+{
+	struct iss_csi2_device *csi2 = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt format;
+
+	if (fse->index != 0)
+		return -EINVAL;
+
+	format.code = fse->code;
+	format.width = 1;
+	format.height = 1;
+	csi2_try_format(csi2, fh, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
+	fse->min_width = format.width;
+	fse->min_height = format.height;
+
+	if (format.code != fse->code)
+		return -EINVAL;
+
+	format.code = fse->code;
+	format.width = -1;
+	format.height = -1;
+	csi2_try_format(csi2, fh, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
+	fse->max_width = format.width;
+	fse->max_height = format.height;
+
+	return 0;
+}
+
+/*
+ * csi2_get_format - Handle get format by pads subdev method
+ * @sd : pointer to v4l2 subdev structure
+ * @fh : V4L2 subdev file handle
+ * @fmt: pointer to v4l2 subdev format structure
+ * return -EINVAL or zero on success
+ */
+static int csi2_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+			   struct v4l2_subdev_format *fmt)
+{
+	struct iss_csi2_device *csi2 = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *format;
+
+	format = __csi2_get_format(csi2, fh, fmt->pad, fmt->which);
+	if (format == NULL)
+		return -EINVAL;
+
+	fmt->format = *format;
+	return 0;
+}
+
+/*
+ * csi2_set_format - Handle set format by pads subdev method
+ * @sd : pointer to v4l2 subdev structure
+ * @fh : V4L2 subdev file handle
+ * @fmt: pointer to v4l2 subdev format structure
+ * return -EINVAL or zero on success
+ */
+static int csi2_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+			   struct v4l2_subdev_format *fmt)
+{
+	struct iss_csi2_device *csi2 = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *format;
+
+	format = __csi2_get_format(csi2, fh, fmt->pad, fmt->which);
+	if (format == NULL)
+		return -EINVAL;
+
+	csi2_try_format(csi2, fh, fmt->pad, &fmt->format, fmt->which);
+	*format = fmt->format;
+
+	/* Propagate the format from sink to source */
+	if (fmt->pad == CSI2_PAD_SINK) {
+		format = __csi2_get_format(csi2, fh, CSI2_PAD_SOURCE,
+					   fmt->which);
+		*format = fmt->format;
+		csi2_try_format(csi2, fh, CSI2_PAD_SOURCE, format, fmt->which);
+	}
+
+	return 0;
+}
+
+static int csi2_link_validate(struct v4l2_subdev *sd, struct media_link *link,
+			      struct v4l2_subdev_format *source_fmt,
+			      struct v4l2_subdev_format *sink_fmt)
+{
+	struct iss_csi2_device *csi2 = v4l2_get_subdevdata(sd);
+	struct iss_pipeline *pipe = to_iss_pipeline(&csi2->subdev.entity);
+	int rval;
+
+	pipe->external = media_entity_to_v4l2_subdev(link->source->entity);
+	rval = omap4iss_get_external_info(pipe, link);
+	if (rval < 0)
+		return rval;
+
+	return v4l2_subdev_link_validate_default(sd, link, source_fmt,
+						 sink_fmt);
+}
+
+/*
+ * csi2_init_formats - Initialize formats on all pads
+ * @sd: ISS CSI2 V4L2 subdevice
+ * @fh: V4L2 subdev file handle
+ *
+ * Initialize all pad formats with default values. If fh is not NULL, try
+ * formats are initialized on the file handle. Otherwise active formats are
+ * initialized on the device.
+ */
+static int csi2_init_formats(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+{
+	struct v4l2_subdev_format format;
+
+	memset(&format, 0, sizeof(format));
+	format.pad = CSI2_PAD_SINK;
+	format.which = fh ? V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE;
+	format.format.code = V4L2_MBUS_FMT_SGRBG10_1X10;
+	format.format.width = 4096;
+	format.format.height = 4096;
+	csi2_set_format(sd, fh, &format);
+
+	return 0;
+}
+
+/*
+ * csi2_set_stream - Enable/Disable streaming on the CSI2 module
+ * @sd: ISS CSI2 V4L2 subdevice
+ * @enable: ISS pipeline stream state
+ *
+ * Return 0 on success or a negative error code otherwise.
+ */
+static int csi2_set_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct iss_csi2_device *csi2 = v4l2_get_subdevdata(sd);
+	struct iss_device *iss = csi2->iss;
+	struct iss_pipeline *pipe = to_iss_pipeline(&csi2->subdev.entity);
+	struct iss_video *video_out = &csi2->video_out;
+
+	if (csi2->state == ISS_PIPELINE_STREAM_STOPPED) {
+		if (enable == ISS_PIPELINE_STREAM_STOPPED)
+			return 0;
+
+		if (csi2 == &iss->csi2a)
+			omap4iss_subclk_enable(iss, OMAP4_ISS_SUBCLK_CSI2_A);
+		else if (csi2 == &iss->csi2b)
+			omap4iss_subclk_enable(iss, OMAP4_ISS_SUBCLK_CSI2_B);
+	}
+
+	switch (enable) {
+	case ISS_PIPELINE_STREAM_CONTINUOUS: {
+		int ret;
+
+		ret = omap4iss_csiphy_config(iss, sd);
+		if (ret < 0)
+			return ret;
+
+		if (omap4iss_csiphy_acquire(csi2->phy) < 0)
+			return -ENODEV;
+		csi2->use_fs_irq = pipe->do_propagation;
+		csi2_configure(csi2);
+		csi2_print_status(csi2);
+
+		/*
+		 * When outputting to memory with no buffer available, let the
+		 * buffer queue handler start the hardware. A DMA queue flag
+		 * ISS_VIDEO_DMAQUEUE_QUEUED will be set as soon as there is
+		 * a buffer available.
+		 */
+		if (csi2->output & CSI2_OUTPUT_MEMORY &&
+		    !(video_out->dmaqueue_flags & ISS_VIDEO_DMAQUEUE_QUEUED))
+			break;
+		/* Enable context 0 and IRQs */
+		atomic_set(&csi2->stopping, 0);
+		csi2_ctx_enable(csi2, 0, 1);
+		csi2_if_enable(csi2, 1);
+		iss_video_dmaqueue_flags_clr(video_out);
+		break;
+	}
+	case ISS_PIPELINE_STREAM_STOPPED:
+		if (csi2->state == ISS_PIPELINE_STREAM_STOPPED)
+			return 0;
+		if (omap4iss_module_sync_idle(&sd->entity, &csi2->wait,
+					      &csi2->stopping))
+			dev_dbg(iss->dev, "%s: module stop timeout.\n",
+				sd->name);
+		csi2_ctx_enable(csi2, 0, 0);
+		csi2_if_enable(csi2, 0);
+		csi2_irq_ctx_set(csi2, 0);
+		omap4iss_csiphy_release(csi2->phy);
+		if (csi2 == &iss->csi2a)
+			omap4iss_subclk_disable(iss, OMAP4_ISS_SUBCLK_CSI2_A);
+		else if (csi2 == &iss->csi2b)
+			omap4iss_subclk_disable(iss, OMAP4_ISS_SUBCLK_CSI2_B);
+		iss_video_dmaqueue_flags_clr(video_out);
+		break;
+	}
+
+	csi2->state = enable;
+	return 0;
+}
+
+/* subdev video operations */
+static const struct v4l2_subdev_video_ops csi2_video_ops = {
+	.s_stream = csi2_set_stream,
+};
+
+/* subdev pad operations */
+static const struct v4l2_subdev_pad_ops csi2_pad_ops = {
+	.enum_mbus_code = csi2_enum_mbus_code,
+	.enum_frame_size = csi2_enum_frame_size,
+	.get_fmt = csi2_get_format,
+	.set_fmt = csi2_set_format,
+	.link_validate = csi2_link_validate,
+};
+
+/* subdev operations */
+static const struct v4l2_subdev_ops csi2_ops = {
+	.video = &csi2_video_ops,
+	.pad = &csi2_pad_ops,
+};
+
+/* subdev internal operations */
+static const struct v4l2_subdev_internal_ops csi2_internal_ops = {
+	.open = csi2_init_formats,
+};
+
+/* -----------------------------------------------------------------------------
+ * Media entity operations
+ */
+
+/*
+ * csi2_link_setup - Setup CSI2 connections.
+ * @entity : Pointer to media entity structure
+ * @local  : Pointer to local pad array
+ * @remote : Pointer to remote pad array
+ * @flags  : Link flags
+ * return -EINVAL or zero on success
+ */
+static int csi2_link_setup(struct media_entity *entity,
+			   const struct media_pad *local,
+			   const struct media_pad *remote, u32 flags)
+{
+	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
+	struct iss_csi2_device *csi2 = v4l2_get_subdevdata(sd);
+	struct iss_csi2_ctrl_cfg *ctrl = &csi2->ctrl;
+
+	/*
+	 * The ISS core doesn't support pipelines with multiple video outputs.
+	 * Revisit this when it will be implemented, and return -EBUSY for now.
+	 */
+
+	switch (local->index | media_entity_type(remote->entity)) {
+	case CSI2_PAD_SOURCE | MEDIA_ENT_T_DEVNODE:
+		if (flags & MEDIA_LNK_FL_ENABLED) {
+			if (csi2->output & ~CSI2_OUTPUT_MEMORY)
+				return -EBUSY;
+			csi2->output |= CSI2_OUTPUT_MEMORY;
+		} else {
+			csi2->output &= ~CSI2_OUTPUT_MEMORY;
+		}
+		break;
+
+	case CSI2_PAD_SOURCE | MEDIA_ENT_T_V4L2_SUBDEV:
+		if (flags & MEDIA_LNK_FL_ENABLED) {
+			if (csi2->output & ~CSI2_OUTPUT_IPIPEIF)
+				return -EBUSY;
+			csi2->output |= CSI2_OUTPUT_IPIPEIF;
+		} else {
+			csi2->output &= ~CSI2_OUTPUT_IPIPEIF;
+		}
+		break;
+
+	default:
+		/* Link from camera to CSI2 is fixed... */
+		return -EINVAL;
+	}
+
+	ctrl->vp_only_enable =
+		(csi2->output & CSI2_OUTPUT_MEMORY) ? false : true;
+	ctrl->vp_clk_enable = !!(csi2->output & CSI2_OUTPUT_IPIPEIF);
+
+	return 0;
+}
+
+/* media operations */
+static const struct media_entity_operations csi2_media_ops = {
+	.link_setup = csi2_link_setup,
+	.link_validate = v4l2_subdev_link_validate,
+};
+
+void omap4iss_csi2_unregister_entities(struct iss_csi2_device *csi2)
+{
+	v4l2_device_unregister_subdev(&csi2->subdev);
+	omap4iss_video_unregister(&csi2->video_out);
+}
+
+int omap4iss_csi2_register_entities(struct iss_csi2_device *csi2,
+				    struct v4l2_device *vdev)
+{
+	int ret;
+
+	/* Register the subdev and video nodes. */
+	ret = v4l2_device_register_subdev(vdev, &csi2->subdev);
+	if (ret < 0)
+		goto error;
+
+	ret = omap4iss_video_register(&csi2->video_out, vdev);
+	if (ret < 0)
+		goto error;
+
+	return 0;
+
+error:
+	omap4iss_csi2_unregister_entities(csi2);
+	return ret;
+}
+
+/* -----------------------------------------------------------------------------
+ * ISS CSI2 initialisation and cleanup
+ */
+
+/*
+ * csi2_init_entities - Initialize subdev and media entity.
+ * @csi2: Pointer to csi2 structure.
+ * return -ENOMEM or zero on success
+ */
+static int csi2_init_entities(struct iss_csi2_device *csi2, const char *subname)
+{
+	struct v4l2_subdev *sd = &csi2->subdev;
+	struct media_pad *pads = csi2->pads;
+	struct media_entity *me = &sd->entity;
+	int ret;
+	char name[V4L2_SUBDEV_NAME_SIZE];
+
+	v4l2_subdev_init(sd, &csi2_ops);
+	sd->internal_ops = &csi2_internal_ops;
+	sprintf(name, "CSI2%s", subname);
+	strlcpy(sd->name, "", sizeof(sd->name));
+	sprintf(sd->name, "OMAP4 ISS %s", name);
+
+	sd->grp_id = 1 << 16;	/* group ID for iss subdevs */
+	v4l2_set_subdevdata(sd, csi2);
+	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+
+	pads[CSI2_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
+	pads[CSI2_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
+
+	me->ops = &csi2_media_ops;
+	ret = media_entity_init(me, CSI2_PADS_NUM, pads, 0);
+	if (ret < 0)
+		return ret;
+
+	csi2_init_formats(sd, NULL);
+
+	/* Video device node */
+	csi2->video_out.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	csi2->video_out.ops = &csi2_issvideo_ops;
+	csi2->video_out.bpl_alignment = 32;
+	csi2->video_out.bpl_zero_padding = 1;
+	csi2->video_out.bpl_max = 0x1ffe0;
+	csi2->video_out.iss = csi2->iss;
+	csi2->video_out.capture_mem = PAGE_ALIGN(4096 * 4096) * 3;
+
+	ret = omap4iss_video_init(&csi2->video_out, name);
+	if (ret < 0)
+		goto error_video;
+
+	/* Connect the CSI2 subdev to the video node. */
+	ret = media_entity_create_link(&csi2->subdev.entity, CSI2_PAD_SOURCE,
+				       &csi2->video_out.video.entity, 0, 0);
+	if (ret < 0)
+		goto error_link;
+
+	return 0;
+
+error_link:
+	omap4iss_video_cleanup(&csi2->video_out);
+error_video:
+	media_entity_cleanup(&csi2->subdev.entity);
+	return ret;
+}
+
+/*
+ * omap4iss_csi2_init - Routine for module driver init
+ */
+int omap4iss_csi2_init(struct iss_device *iss)
+{
+	struct iss_csi2_device *csi2a = &iss->csi2a;
+	struct iss_csi2_device *csi2b = &iss->csi2b;
+	int ret;
+
+	csi2a->iss = iss;
+	csi2a->available = 1;
+	csi2a->regs1 = iss->regs[OMAP4_ISS_MEM_CSI2_A_REGS1];
+	csi2a->phy = &iss->csiphy1;
+	csi2a->state = ISS_PIPELINE_STREAM_STOPPED;
+	init_waitqueue_head(&csi2a->wait);
+
+	ret = csi2_init_entities(csi2a, "a");
+	if (ret < 0)
+		return ret;
+
+	csi2b->iss = iss;
+	csi2b->available = 1;
+	csi2b->regs1 = iss->regs[OMAP4_ISS_MEM_CSI2_B_REGS1];
+	csi2b->phy = &iss->csiphy2;
+	csi2b->state = ISS_PIPELINE_STREAM_STOPPED;
+	init_waitqueue_head(&csi2b->wait);
+
+	ret = csi2_init_entities(csi2b, "b");
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+/*
+ * omap4iss_csi2_cleanup - Routine for module driver cleanup
+ */
+void omap4iss_csi2_cleanup(struct iss_device *iss)
+{
+	struct iss_csi2_device *csi2a = &iss->csi2a;
+	struct iss_csi2_device *csi2b = &iss->csi2b;
+
+	omap4iss_video_cleanup(&csi2a->video_out);
+	media_entity_cleanup(&csi2a->subdev.entity);
+
+	omap4iss_video_cleanup(&csi2b->video_out);
+	media_entity_cleanup(&csi2b->subdev.entity);
+}
diff --git a/drivers/media/video/omap4iss/iss_csi2.h b/drivers/media/video/omap4iss/iss_csi2.h
new file mode 100644
index 0000000..aa81971
--- /dev/null
+++ b/drivers/media/video/omap4iss/iss_csi2.h
@@ -0,0 +1,155 @@
+/*
+ * TI OMAP4 ISS V4L2 Driver - CSI2 module
+ *
+ * Copyright (C) 2012 Texas Instruments, Inc.
+ *
+ * Author: Sergio Aguirre <saaguirre@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef OMAP4_ISS_CSI2_H
+#define OMAP4_ISS_CSI2_H
+
+#include <linux/types.h>
+#include <linux/videodev2.h>
+
+#include "iss_video.h"
+
+struct iss_csiphy;
+
+/* This is not an exhaustive list */
+enum iss_csi2_pix_formats {
+	CSI2_PIX_FMT_OTHERS = 0,
+	CSI2_PIX_FMT_YUV422_8BIT = 0x1e,
+	CSI2_PIX_FMT_YUV422_8BIT_VP = 0x9e,
+	CSI2_PIX_FMT_RAW10_EXP16 = 0xab,
+	CSI2_PIX_FMT_RAW10_EXP16_VP = 0x12f,
+	CSI2_PIX_FMT_RAW8 = 0x2a,
+	CSI2_PIX_FMT_RAW8_DPCM10_EXP16 = 0x2aa,
+	CSI2_PIX_FMT_RAW8_DPCM10_VP = 0x32a,
+	CSI2_PIX_FMT_RAW8_VP = 0x12a,
+	CSI2_USERDEF_8BIT_DATA1_DPCM10_VP = 0x340,
+	CSI2_USERDEF_8BIT_DATA1_DPCM10 = 0x2c0,
+	CSI2_USERDEF_8BIT_DATA1 = 0x40,
+};
+
+enum iss_csi2_irqevents {
+	OCP_ERR_IRQ = 0x4000,
+	SHORT_PACKET_IRQ = 0x2000,
+	ECC_CORRECTION_IRQ = 0x1000,
+	ECC_NO_CORRECTION_IRQ = 0x800,
+	COMPLEXIO2_ERR_IRQ = 0x400,
+	COMPLEXIO1_ERR_IRQ = 0x200,
+	FIFO_OVF_IRQ = 0x100,
+	CONTEXT7 = 0x80,
+	CONTEXT6 = 0x40,
+	CONTEXT5 = 0x20,
+	CONTEXT4 = 0x10,
+	CONTEXT3 = 0x8,
+	CONTEXT2 = 0x4,
+	CONTEXT1 = 0x2,
+	CONTEXT0 = 0x1,
+};
+
+enum iss_csi2_ctx_irqevents {
+	CTX_ECC_CORRECTION = 0x100,
+	CTX_LINE_NUMBER = 0x80,
+	CTX_FRAME_NUMBER = 0x40,
+	CTX_CS = 0x20,
+	CTX_LE = 0x8,
+	CTX_LS = 0x4,
+	CTX_FE = 0x2,
+	CTX_FS = 0x1,
+};
+
+enum iss_csi2_frame_mode {
+	ISS_CSI2_FRAME_IMMEDIATE,
+	ISS_CSI2_FRAME_AFTERFEC,
+};
+
+#define ISS_CSI2_MAX_CTX_NUM	7
+
+struct iss_csi2_ctx_cfg {
+	u8 ctxnum;		/* context number 0 - 7 */
+	u8 dpcm_decompress;
+
+	/* Fields in CSI2_CTx_CTRL2 - locked by CSI2_CTx_CTRL1.CTX_EN */
+	u8 virtual_id;
+	u16 format_id;		/* as in CSI2_CTx_CTRL2[9:0] */
+	u8 dpcm_predictor;	/* 1: simple, 0: advanced */
+
+	/* Fields in CSI2_CTx_CTRL1/3 - Shadowed */
+	u16 alpha;
+	u16 data_offset;
+	u32 ping_addr;
+	u32 pong_addr;
+	u8 eof_enabled;
+	u8 eol_enabled;
+	u8 checksum_enabled;
+	u8 enabled;
+};
+
+struct iss_csi2_timing_cfg {
+	u8 ionum;			/* IO1 or IO2 as in CSI2_TIMING */
+	unsigned force_rx_mode:1;
+	unsigned stop_state_16x:1;
+	unsigned stop_state_4x:1;
+	u16 stop_state_counter;
+};
+
+struct iss_csi2_ctrl_cfg {
+	bool vp_clk_enable;
+	bool vp_only_enable;
+	u8 vp_out_ctrl;
+	enum iss_csi2_frame_mode frame_mode;
+	bool ecc_enable;
+	bool if_enable;
+};
+
+#define CSI2_PAD_SINK		0
+#define CSI2_PAD_SOURCE		1
+#define CSI2_PADS_NUM		2
+
+#define CSI2_OUTPUT_IPIPEIF	(1 << 0)
+#define CSI2_OUTPUT_MEMORY	(1 << 1)
+
+struct iss_csi2_device {
+	struct v4l2_subdev subdev;
+	struct media_pad pads[CSI2_PADS_NUM];
+	struct v4l2_mbus_framefmt formats[CSI2_PADS_NUM];
+
+	struct iss_video video_out;
+	struct iss_device *iss;
+
+	u8 available;		/* Is the IP present on the silicon? */
+
+	/* Pointer to register remaps into kernel space */
+	void __iomem *regs1;
+	void __iomem *regs2;
+
+	u32 output; /* output to IPIPEIF, memory or both? */
+	bool dpcm_decompress;
+	unsigned int frame_skip;
+	bool use_fs_irq;
+
+	struct iss_csiphy *phy;
+	struct iss_csi2_ctx_cfg contexts[ISS_CSI2_MAX_CTX_NUM + 1];
+	struct iss_csi2_timing_cfg timing[2];
+	struct iss_csi2_ctrl_cfg ctrl;
+	enum iss_pipeline_stream_state state;
+	wait_queue_head_t wait;
+	atomic_t stopping;
+};
+
+void omap4iss_csi2_isr(struct iss_csi2_device *csi2);
+int omap4iss_csi2_reset(struct iss_csi2_device *csi2);
+int omap4iss_csi2_init(struct iss_device *iss);
+void omap4iss_csi2_cleanup(struct iss_device *iss);
+void omap4iss_csi2_unregister_entities(struct iss_csi2_device *csi2);
+int omap4iss_csi2_register_entities(struct iss_csi2_device *csi2,
+				    struct v4l2_device *vdev);
+#endif	/* OMAP4_ISS_CSI2_H */
diff --git a/drivers/media/video/omap4iss/iss_csiphy.c b/drivers/media/video/omap4iss/iss_csiphy.c
new file mode 100644
index 0000000..3e48e02
--- /dev/null
+++ b/drivers/media/video/omap4iss/iss_csiphy.c
@@ -0,0 +1,281 @@
+/*
+ * TI OMAP4 ISS V4L2 Driver - CSI PHY module
+ *
+ * Copyright (C) 2012 Texas Instruments, Inc.
+ *
+ * Author: Sergio Aguirre <saaguirre@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/delay.h>
+#include <linux/device.h>
+
+#include <plat/cpu.h>
+
+#include "../../../../arch/arm/mach-omap2/control.h"
+
+#include "iss.h"
+#include "iss_regs.h"
+#include "iss_csiphy.h"
+
+/*
+ * csiphy_lanes_config - Configuration of CSIPHY lanes.
+ *
+ * Updates HW configuration.
+ * Called with phy->mutex taken.
+ */
+static void csiphy_lanes_config(struct iss_csiphy *phy)
+{
+	unsigned int i;
+	u32 reg;
+
+	reg = readl(phy->cfg_regs + CSI2_COMPLEXIO_CFG);
+
+	for (i = 0; i < phy->max_data_lanes; i++) {
+		reg &= ~(CSI2_COMPLEXIO_CFG_DATA_POL(i + 1) |
+			 CSI2_COMPLEXIO_CFG_DATA_POSITION_MASK(i + 1));
+		reg |= (phy->lanes.data[i].pol ?
+			CSI2_COMPLEXIO_CFG_DATA_POL(i + 1) : 0);
+		reg |= (phy->lanes.data[i].pos <<
+			CSI2_COMPLEXIO_CFG_DATA_POSITION_SHIFT(i + 1));
+	}
+
+	reg &= ~(CSI2_COMPLEXIO_CFG_CLOCK_POL |
+		 CSI2_COMPLEXIO_CFG_CLOCK_POSITION_MASK);
+	reg |= phy->lanes.clk.pol ? CSI2_COMPLEXIO_CFG_CLOCK_POL : 0;
+	reg |= phy->lanes.clk.pos << CSI2_COMPLEXIO_CFG_CLOCK_POSITION_SHIFT;
+
+	writel(reg, phy->cfg_regs + CSI2_COMPLEXIO_CFG);
+}
+
+/*
+ * csiphy_set_power
+ * @power: Power state to be set.
+ *
+ * Returns 0 if successful, or -EBUSY if the retry count is exceeded.
+ */
+static int csiphy_set_power(struct iss_csiphy *phy, u32 power)
+{
+	u32 reg;
+	u8 retry_count;
+
+	writel((readl(phy->cfg_regs + CSI2_COMPLEXIO_CFG) &
+		~CSI2_COMPLEXIO_CFG_PWD_CMD_MASK) |
+		power,
+		phy->cfg_regs + CSI2_COMPLEXIO_CFG);
+
+	retry_count = 0;
+	do {
+		udelay(1);
+		reg = readl(phy->cfg_regs + CSI2_COMPLEXIO_CFG) &
+				CSI2_COMPLEXIO_CFG_PWD_STATUS_MASK;
+
+		if (reg != power >> 2)
+			retry_count++;
+
+	} while ((reg != power >> 2) && (retry_count < 100));
+
+	if (retry_count == 100) {
+		printk(KERN_ERR "CSI2 CIO set power failed!\n");
+		return -EBUSY;
+	}
+
+	return 0;
+}
+
+/*
+ * csiphy_dphy_config - Configure CSI2 D-PHY parameters.
+ *
+ * Called with phy->mutex taken.
+ */
+static void csiphy_dphy_config(struct iss_csiphy *phy)
+{
+	u32 reg;
+
+	/* Set up REGISTER0 */
+	reg = phy->dphy.ths_term << REGISTER0_THS_TERM_SHIFT;
+	reg |= phy->dphy.ths_settle << REGISTER0_THS_SETTLE_SHIFT;
+
+	writel(reg, phy->phy_regs + REGISTER0);
+
+	/* Set up REGISTER1 */
+	reg = phy->dphy.tclk_term << REGISTER1_TCLK_TERM_SHIFT;
+	reg |= phy->dphy.tclk_miss << REGISTER1_CTRLCLK_DIV_FACTOR_SHIFT;
+	reg |= phy->dphy.tclk_settle << REGISTER1_TCLK_SETTLE_SHIFT;
+	reg |= 0xB8 << REGISTER1_DPHY_HS_SYNC_PATTERN_SHIFT;
+
+	writel(reg, phy->phy_regs + REGISTER1);
+}
+
+/*
+ * TCLK values are OK at their reset values
+ */
+#define TCLK_TERM	0
+#define TCLK_MISS	1
+#define TCLK_SETTLE	14
+
+int omap4iss_csiphy_config(struct iss_device *iss,
+			   struct v4l2_subdev *csi2_subdev)
+{
+	struct iss_csi2_device *csi2 = v4l2_get_subdevdata(csi2_subdev);
+	struct iss_pipeline *pipe = to_iss_pipeline(&csi2_subdev->entity);
+	struct iss_v4l2_subdevs_group *subdevs = pipe->external->host_priv;
+	struct iss_csiphy_dphy_cfg csi2phy;
+	int csi2_ddrclk_khz;
+	struct iss_csiphy_lanes_cfg *lanes;
+	unsigned int used_lanes = 0;
+	unsigned int i;
+
+	lanes = &subdevs->bus.csi2.lanecfg;
+
+	if (cpu_is_omap44xx()) {
+		u32 cam_rx_ctrl = omap4_ctrl_pad_readl(
+				OMAP4_CTRL_MODULE_PAD_CORE_CONTROL_CAMERA_RX);
+
+		/*
+		 * SCM.CONTROL_CAMERA_RX
+		 * - bit [31] : CSIPHY2 lane 2 enable (4460+ only)
+		 * - bit [30:29] : CSIPHY2 per-lane enable (1 to 0)
+		 * - bit [28:24] : CSIPHY1 per-lane enable (4 to 0)
+		 * - bit [21] : CSIPHY2 CTRLCLK enable
+		 * - bit [20:19] : CSIPHY2 config: 00 d-phy, 01/10 ccp2
+		 * - bit [18] : CSIPHY1 CTRLCLK enable
+		 * - bit [17:16] : CSIPHY1 config: 00 d-phy, 01/10 ccp2
+		 */
+
+		if (subdevs->interface == ISS_INTERFACE_CSI2A_PHY1) {
+			cam_rx_ctrl &= ~(OMAP4_CAMERARX_CSI21_LANEENABLE_MASK |
+					OMAP4_CAMERARX_CSI21_CAMMODE_MASK);
+			/* NOTE: Leave CSIPHY1 config to 0x0: D-PHY mode */
+			/* Enable all lanes for now */
+			cam_rx_ctrl |=
+				0x7 << OMAP4_CAMERARX_CSI21_LANEENABLE_SHIFT;
+			/* Enable CTRLCLK */
+			cam_rx_ctrl |= OMAP4_CAMERARX_CSI21_CTRLCLKEN_MASK;
+		}
+
+		if (subdevs->interface == ISS_INTERFACE_CSI2B_PHY2) {
+			cam_rx_ctrl &= ~(OMAP4_CAMERARX_CSI22_LANEENABLE_MASK |
+					OMAP4_CAMERARX_CSI22_CAMMODE_MASK);
+			/* NOTE: Leave CSIPHY2 config to 0x0: D-PHY mode */
+			/* Enable all lanes for now */
+			cam_rx_ctrl |=
+				0x3 << OMAP4_CAMERARX_CSI22_LANEENABLE_SHIFT;
+			/* Enable CTRLCLK */
+			cam_rx_ctrl |= OMAP4_CAMERARX_CSI22_CTRLCLKEN_MASK;
+		}
+
+		omap4_ctrl_pad_writel(cam_rx_ctrl,
+			 OMAP4_CTRL_MODULE_PAD_CORE_CONTROL_CAMERA_RX);
+	}
+
+	/* Reset used lane count */
+	csi2->phy->used_data_lanes = 0;
+
+	/* Clock and data lanes verification */
+	for (i = 0; i < csi2->phy->max_data_lanes; i++) {
+		if (lanes->data[i].pos == 0)
+			continue;
+
+		if (lanes->data[i].pol > 1 || lanes->data[i].pos > (csi2->phy->max_data_lanes + 1))
+			return -EINVAL;
+
+		if (used_lanes & (1 << lanes->data[i].pos))
+			return -EINVAL;
+
+		used_lanes |= 1 << lanes->data[i].pos;
+		csi2->phy->used_data_lanes++;
+	}
+
+	if (lanes->clk.pol > 1 || lanes->clk.pos > (csi2->phy->max_data_lanes + 1))
+		return -EINVAL;
+
+	if (lanes->clk.pos == 0 || used_lanes & (1 << lanes->clk.pos))
+		return -EINVAL;
+
+	csi2_ddrclk_khz = pipe->external_rate / 1000
+		/ (2 * csi2->phy->used_data_lanes)
+		* pipe->external_bpp;
+
+	/*
+	 * THS_TERM: Programmed value = ceil(12.5 ns/DDRClk period) - 1.
+	 * THS_SETTLE: Programmed value = ceil(90 ns/DDRClk period) + 3.
+	 */
+	csi2phy.ths_term = DIV_ROUND_UP(25 * csi2_ddrclk_khz, 2000000) - 1;
+	csi2phy.ths_settle = DIV_ROUND_UP(90 * csi2_ddrclk_khz, 1000000) + 3;
+	csi2phy.tclk_term = TCLK_TERM;
+	csi2phy.tclk_miss = TCLK_MISS;
+	csi2phy.tclk_settle = TCLK_SETTLE;
+
+	mutex_lock(&csi2->phy->mutex);
+	csi2->phy->dphy = csi2phy;
+	csi2->phy->lanes = *lanes;
+	mutex_unlock(&csi2->phy->mutex);
+
+	return 0;
+}
+
+int omap4iss_csiphy_acquire(struct iss_csiphy *phy)
+{
+	int rval;
+
+	mutex_lock(&phy->mutex);
+
+	rval = omap4iss_csi2_reset(phy->csi2);
+	if (rval)
+		goto done;
+
+	csiphy_dphy_config(phy);
+	csiphy_lanes_config(phy);
+
+	rval = csiphy_set_power(phy, CSI2_COMPLEXIO_CFG_PWD_CMD_ON);
+	if (rval)
+		goto done;
+
+	phy->phy_in_use = 1;
+
+done:
+	mutex_unlock(&phy->mutex);
+	return rval;
+}
+
+void omap4iss_csiphy_release(struct iss_csiphy *phy)
+{
+	mutex_lock(&phy->mutex);
+	if (phy->phy_in_use) {
+		csiphy_set_power(phy, CSI2_COMPLEXIO_CFG_PWD_CMD_OFF);
+		phy->phy_in_use = 0;
+	}
+	mutex_unlock(&phy->mutex);
+}
+
+/*
+ * omap4iss_csiphy_init - Initialize the CSI PHY frontends
+ */
+int omap4iss_csiphy_init(struct iss_device *iss)
+{
+	struct iss_csiphy *phy1 = &iss->csiphy1;
+	struct iss_csiphy *phy2 = &iss->csiphy2;
+
+	phy1->iss = iss;
+	phy1->csi2 = &iss->csi2a;
+	phy1->max_data_lanes = ISS_CSIPHY1_NUM_DATA_LANES;
+	phy1->used_data_lanes = 0;
+	phy1->cfg_regs = iss->regs[OMAP4_ISS_MEM_CSI2_A_REGS1];
+	phy1->phy_regs = iss->regs[OMAP4_ISS_MEM_CAMERARX_CORE1];
+	mutex_init(&phy1->mutex);
+
+	phy2->iss = iss;
+	phy2->csi2 = &iss->csi2b;
+	phy2->max_data_lanes = ISS_CSIPHY2_NUM_DATA_LANES;
+	phy2->used_data_lanes = 0;
+	phy2->cfg_regs = iss->regs[OMAP4_ISS_MEM_CSI2_B_REGS1];
+	phy2->phy_regs = iss->regs[OMAP4_ISS_MEM_CAMERARX_CORE2];
+	mutex_init(&phy2->mutex);
+
+	return 0;
+}
diff --git a/drivers/media/video/omap4iss/iss_csiphy.h b/drivers/media/video/omap4iss/iss_csiphy.h
new file mode 100644
index 0000000..49cc3eb
--- /dev/null
+++ b/drivers/media/video/omap4iss/iss_csiphy.h
@@ -0,0 +1,51 @@
+/*
+ * TI OMAP4 ISS V4L2 Driver - CSI PHY module
+ *
+ * Copyright (C) 2012 Texas Instruments, Inc.
+ *
+ * Author: Sergio Aguirre <saaguirre@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef OMAP4_ISS_CSI_PHY_H
+#define OMAP4_ISS_CSI_PHY_H
+
+#include <media/omap4iss.h>
+
+struct iss_csi2_device;
+
+struct iss_csiphy_dphy_cfg {
+	u8 ths_term;
+	u8 ths_settle;
+	u8 tclk_term;
+	unsigned tclk_miss:1;
+	u8 tclk_settle;
+};
+
+struct iss_csiphy {
+	struct iss_device *iss;
+	struct mutex mutex;	/* serialize csiphy configuration */
+	u8 phy_in_use;
+	struct iss_csi2_device *csi2;
+
+	/* Pointer to register remaps into kernel space */
+	void __iomem *cfg_regs;
+	void __iomem *phy_regs;
+
+	u8 max_data_lanes;	/* number of CSI2 Data Lanes supported */
+	u8 used_data_lanes;	/* number of CSI2 Data Lanes used */
+	struct iss_csiphy_lanes_cfg lanes;
+	struct iss_csiphy_dphy_cfg dphy;
+};
+
+int omap4iss_csiphy_config(struct iss_device *iss,
+			   struct v4l2_subdev *csi2_subdev);
+int omap4iss_csiphy_acquire(struct iss_csiphy *phy);
+void omap4iss_csiphy_release(struct iss_csiphy *phy);
+int omap4iss_csiphy_init(struct iss_device *iss);
+
+#endif	/* OMAP4_ISS_CSI_PHY_H */
diff --git a/drivers/media/video/omap4iss/iss_regs.h b/drivers/media/video/omap4iss/iss_regs.h
new file mode 100644
index 0000000..d6aec7d
--- /dev/null
+++ b/drivers/media/video/omap4iss/iss_regs.h
@@ -0,0 +1,244 @@
+/*
+ * TI OMAP4 ISS V4L2 Driver - Register defines
+ *
+ * Copyright (C) 2012 Texas Instruments.
+ *
+ * Author: Sergio Aguirre <saaguirre@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef _OMAP4_ISS_REGS_H_
+#define _OMAP4_ISS_REGS_H_
+
+/* ISS */
+#define ISS_HL_REVISION					0x0
+
+#define ISS_HL_SYSCONFIG				0x10
+#define ISS_HL_SYSCONFIG_IDLEMODE_SHIFT			2
+#define ISS_HL_SYSCONFIG_IDLEMODE_FORCEIDLE		0x0
+#define ISS_HL_SYSCONFIG_IDLEMODE_NOIDLE		0x1
+#define ISS_HL_SYSCONFIG_IDLEMODE_SMARTIDLE		0x2
+#define ISS_HL_SYSCONFIG_SOFTRESET			(1 << 0)
+
+#define ISS_HL_IRQSTATUS_5				(0x24 + (0x10 * 5))
+#define ISS_HL_IRQENABLE_5_SET				(0x28 + (0x10 * 5))
+#define ISS_HL_IRQENABLE_5_CLR				(0x2C + (0x10 * 5))
+
+#define ISS_HL_IRQ_BTE					(1 << 11)
+#define ISS_HL_IRQ_CBUFF				(1 << 10)
+#define ISS_HL_IRQ_CSIB					(1 << 5)
+#define ISS_HL_IRQ_CSIA					(1 << 4)
+
+#define ISS_CTRL					0x80
+
+#define ISS_CLKCTRL					0x84
+#define ISS_CLKCTRL_VPORT2_CLK				(1 << 30)
+#define ISS_CLKCTRL_VPORT1_CLK				(1 << 29)
+#define ISS_CLKCTRL_VPORT0_CLK				(1 << 28)
+#define ISS_CLKCTRL_CCP2				(1 << 4)
+#define ISS_CLKCTRL_CSI2_B				(1 << 3)
+#define ISS_CLKCTRL_CSI2_A				(1 << 2)
+#define ISS_CLKCTRL_ISP					(1 << 1)
+#define ISS_CLKCTRL_SIMCOP				(1 << 0)
+
+#define ISS_CLKSTAT					0x88
+#define ISS_CLKSTAT_VPORT2_CLK				(1 << 30)
+#define ISS_CLKSTAT_VPORT1_CLK				(1 << 29)
+#define ISS_CLKSTAT_VPORT0_CLK				(1 << 28)
+#define ISS_CLKSTAT_CCP2				(1 << 4)
+#define ISS_CLKSTAT_CSI2_B				(1 << 3)
+#define ISS_CLKSTAT_CSI2_A				(1 << 2)
+#define ISS_CLKSTAT_ISP					(1 << 1)
+#define ISS_CLKSTAT_SIMCOP				(1 << 0)
+
+#define ISS_PM_STATUS					0x8C
+#define ISS_PM_STATUS_CBUFF_PM_MASK			(3 << 12)
+#define ISS_PM_STATUS_BTE_PM_MASK			(3 << 10)
+#define ISS_PM_STATUS_SIMCOP_PM_MASK			(3 << 8)
+#define ISS_PM_STATUS_ISP_PM_MASK			(3 << 6)
+#define ISS_PM_STATUS_CCP2_PM_MASK			(3 << 4)
+#define ISS_PM_STATUS_CSI2_B_PM_MASK			(3 << 2)
+#define ISS_PM_STATUS_CSI2_A_PM_MASK			(3 << 0)
+
+#define REGISTER0					0x0
+#define REGISTER0_HSCLOCKCONFIG				(1 << 24)
+#define REGISTER0_THS_TERM_MASK				(0xFF << 8)
+#define REGISTER0_THS_TERM_SHIFT			8
+#define REGISTER0_THS_SETTLE_MASK			(0xFF << 0)
+#define REGISTER0_THS_SETTLE_SHIFT			0
+
+#define REGISTER1					0x4
+#define REGISTER1_RESET_DONE_CTRLCLK			(1 << 29)
+#define REGISTER1_CLOCK_MISS_DETECTOR_STATUS		(1 << 25)
+#define REGISTER1_TCLK_TERM_MASK			(0x3F << 18)
+#define REGISTER1_TCLK_TERM_SHIFT			18
+#define REGISTER1_DPHY_HS_SYNC_PATTERN_SHIFT		10
+#define REGISTER1_CTRLCLK_DIV_FACTOR_MASK		(0x3 << 8)
+#define REGISTER1_CTRLCLK_DIV_FACTOR_SHIFT		8
+#define REGISTER1_TCLK_SETTLE_MASK			(0xFF << 0)
+#define REGISTER1_TCLK_SETTLE_SHIFT			0
+
+#define REGISTER2					0x8
+
+#define CSI2_SYSCONFIG					0x10
+#define CSI2_SYSCONFIG_MSTANDBY_MODE_MASK		(3 << 12)
+#define CSI2_SYSCONFIG_MSTANDBY_MODE_FORCE		(0 << 12)
+#define CSI2_SYSCONFIG_MSTANDBY_MODE_NO			(1 << 12)
+#define CSI2_SYSCONFIG_MSTANDBY_MODE_SMART		(2 << 12)
+#define CSI2_SYSCONFIG_SOFT_RESET			(1 << 1)
+#define CSI2_SYSCONFIG_AUTO_IDLE			(1 << 0)
+
+#define CSI2_SYSSTATUS					0x14
+#define CSI2_SYSSTATUS_RESET_DONE			(1 << 0)
+
+#define CSI2_IRQSTATUS					0x18
+#define CSI2_IRQENABLE					0x1C
+
+/* Shared bits across CSI2_IRQENABLE and IRQSTATUS */
+
+#define CSI2_IRQ_OCP_ERR				(1 << 14)
+#define CSI2_IRQ_SHORT_PACKET				(1 << 13)
+#define CSI2_IRQ_ECC_CORRECTION				(1 << 12)
+#define CSI2_IRQ_ECC_NO_CORRECTION			(1 << 11)
+#define CSI2_IRQ_COMPLEXIO_ERR				(1 << 9)
+#define CSI2_IRQ_FIFO_OVF				(1 << 8)
+#define CSI2_IRQ_CONTEXT0				(1 << 0)
+
+#define CSI2_CTRL					0x40
+#define CSI2_CTRL_MFLAG_LEVH_MASK			(7 << 20)
+#define CSI2_CTRL_MFLAG_LEVH_SHIFT			20
+#define CSI2_CTRL_MFLAG_LEVL_MASK			(7 << 17)
+#define CSI2_CTRL_MFLAG_LEVL_SHIFT			17
+#define CSI2_CTRL_BURST_SIZE_EXPAND			(1 << 16)
+#define CSI2_CTRL_VP_CLK_EN				(1 << 15)
+#define CSI2_CTRL_NON_POSTED_WRITE			(1 << 13)
+#define CSI2_CTRL_VP_ONLY_EN				(1 << 11)
+#define CSI2_CTRL_VP_OUT_CTRL_MASK			(3 << 8)
+#define CSI2_CTRL_VP_OUT_CTRL_SHIFT			8
+#define CSI2_CTRL_DBG_EN				(1 << 7)
+#define CSI2_CTRL_BURST_SIZE_MASK			(3 << 5)
+#define CSI2_CTRL_ENDIANNESS				(1 << 4)
+#define CSI2_CTRL_FRAME					(1 << 3)
+#define CSI2_CTRL_ECC_EN				(1 << 2)
+#define CSI2_CTRL_IF_EN					(1 << 0)
+
+#define CSI2_DBG_H					0x44
+
+#define CSI2_COMPLEXIO_CFG				0x50
+#define CSI2_COMPLEXIO_CFG_RESET_CTRL			(1 << 30)
+#define CSI2_COMPLEXIO_CFG_RESET_DONE			(1 << 29)
+#define CSI2_COMPLEXIO_CFG_PWD_CMD_MASK			(3 << 27)
+#define CSI2_COMPLEXIO_CFG_PWD_CMD_OFF			(0 << 27)
+#define CSI2_COMPLEXIO_CFG_PWD_CMD_ON			(1 << 27)
+#define CSI2_COMPLEXIO_CFG_PWD_CMD_ULP			(2 << 27)
+#define CSI2_COMPLEXIO_CFG_PWD_STATUS_MASK		(3 << 25)
+#define CSI2_COMPLEXIO_CFG_PWD_STATUS_OFF		(0 << 25)
+#define CSI2_COMPLEXIO_CFG_PWD_STATUS_ON		(1 << 25)
+#define CSI2_COMPLEXIO_CFG_PWD_STATUS_ULP		(2 << 25)
+#define CSI2_COMPLEXIO_CFG_PWR_AUTO			(1 << 24)
+#define CSI2_COMPLEXIO_CFG_DATA_POL(i)			(1 << (((i) * 4) + 3))
+#define CSI2_COMPLEXIO_CFG_DATA_POSITION_MASK(i)	(7 << ((i) * 4))
+#define CSI2_COMPLEXIO_CFG_DATA_POSITION_SHIFT(i)	((i) * 4)
+#define CSI2_COMPLEXIO_CFG_CLOCK_POL			(1 << 3)
+#define CSI2_COMPLEXIO_CFG_CLOCK_POSITION_MASK		(7 << 0)
+#define CSI2_COMPLEXIO_CFG_CLOCK_POSITION_SHIFT		0
+
+#define CSI2_COMPLEXIO_IRQSTATUS			0x54
+
+#define CSI2_SHORT_PACKET				0x5C
+
+#define CSI2_COMPLEXIO_IRQENABLE			0x60
+
+/* Shared bits across CSI2_COMPLEXIO_IRQENABLE and IRQSTATUS */
+#define CSI2_COMPLEXIO_IRQ_STATEALLULPMEXIT		(1 << 26)
+#define CSI2_COMPLEXIO_IRQ_STATEALLULPMENTER		(1 << 25)
+#define CSI2_COMPLEXIO_IRQ_STATEULPM5			(1 << 24)
+#define CSI2_COMPLEXIO_IRQ_STATEULPM4			(1 << 23)
+#define CSI2_COMPLEXIO_IRQ_STATEULPM3			(1 << 22)
+#define CSI2_COMPLEXIO_IRQ_STATEULPM2			(1 << 21)
+#define CSI2_COMPLEXIO_IRQ_STATEULPM1			(1 << 20)
+#define CSI2_COMPLEXIO_IRQ_ERRCONTROL5			(1 << 19)
+#define CSI2_COMPLEXIO_IRQ_ERRCONTROL4			(1 << 18)
+#define CSI2_COMPLEXIO_IRQ_ERRCONTROL3			(1 << 17)
+#define CSI2_COMPLEXIO_IRQ_ERRCONTROL2			(1 << 16)
+#define CSI2_COMPLEXIO_IRQ_ERRCONTROL1			(1 << 15)
+#define CSI2_COMPLEXIO_IRQ_ERRESC5			(1 << 14)
+#define CSI2_COMPLEXIO_IRQ_ERRESC4			(1 << 13)
+#define CSI2_COMPLEXIO_IRQ_ERRESC3			(1 << 12)
+#define CSI2_COMPLEXIO_IRQ_ERRESC2			(1 << 11)
+#define CSI2_COMPLEXIO_IRQ_ERRESC1			(1 << 10)
+#define CSI2_COMPLEXIO_IRQ_ERRSOTSYNCHS5		(1 << 9)
+#define CSI2_COMPLEXIO_IRQ_ERRSOTSYNCHS4		(1 << 8)
+#define CSI2_COMPLEXIO_IRQ_ERRSOTSYNCHS3		(1 << 7)
+#define CSI2_COMPLEXIO_IRQ_ERRSOTSYNCHS2		(1 << 6)
+#define CSI2_COMPLEXIO_IRQ_ERRSOTSYNCHS1		(1 << 5)
+#define CSI2_COMPLEXIO_IRQ_ERRSOTHS5			(1 << 4)
+#define CSI2_COMPLEXIO_IRQ_ERRSOTHS4			(1 << 3)
+#define CSI2_COMPLEXIO_IRQ_ERRSOTHS3			(1 << 2)
+#define CSI2_COMPLEXIO_IRQ_ERRSOTHS2			(1 << 1)
+#define CSI2_COMPLEXIO_IRQ_ERRSOTHS1			(1 << 0)
+
+#define CSI2_DBG_P					0x68
+
+#define CSI2_TIMING					0x6C
+#define CSI2_TIMING_FORCE_RX_MODE_IO1			(1 << 15)
+#define CSI2_TIMING_STOP_STATE_X16_IO1			(1 << 14)
+#define CSI2_TIMING_STOP_STATE_X4_IO1			(1 << 13)
+#define CSI2_TIMING_STOP_STATE_COUNTER_IO1_MASK		(0x1FFF << 0)
+#define CSI2_TIMING_STOP_STATE_COUNTER_IO1_SHIFT	0
+
+#define CSI2_CTX_CTRL1(i)				(0x70 + (0x20 * i))
+#define CSI2_CTX_CTRL1_GENERIC				(1 << 30)
+#define CSI2_CTX_CTRL1_TRANSCODE			(0xF << 24)
+#define CSI2_CTX_CTRL1_FEC_NUMBER_MASK			(0xFF << 16)
+#define CSI2_CTX_CTRL1_COUNT_MASK			(0xFF << 8)
+#define CSI2_CTX_CTRL1_COUNT_SHIFT			8
+#define CSI2_CTX_CTRL1_EOF_EN				(1 << 7)
+#define CSI2_CTX_CTRL1_EOL_EN				(1 << 6)
+#define CSI2_CTX_CTRL1_CS_EN				(1 << 5)
+#define CSI2_CTX_CTRL1_COUNT_UNLOCK			(1 << 4)
+#define CSI2_CTX_CTRL1_PING_PONG			(1 << 3)
+#define CSI2_CTX_CTRL1_CTX_EN				(1 << 0)
+
+#define CSI2_CTX_CTRL2(i)				(0x74 + (0x20 * i))
+#define CSI2_CTX_CTRL2_USER_DEF_MAP_SHIFT		13
+#define CSI2_CTX_CTRL2_USER_DEF_MAP_MASK		\
+		(0x3 << CSI2_CTX_CTRL2_USER_DEF_MAP_SHIFT)
+#define CSI2_CTX_CTRL2_VIRTUAL_ID_MASK			(3 << 11)
+#define CSI2_CTX_CTRL2_VIRTUAL_ID_SHIFT			11
+#define CSI2_CTX_CTRL2_DPCM_PRED			(1 << 10)
+#define CSI2_CTX_CTRL2_FORMAT_MASK			(0x3FF << 0)
+#define CSI2_CTX_CTRL2_FORMAT_SHIFT			0
+
+#define CSI2_CTX_DAT_OFST(i)				(0x78 + (0x20 * i))
+#define CSI2_CTX_DAT_OFST_MASK				(0xFFF << 5)
+
+#define CSI2_CTX_PING_ADDR(i)				(0x7C + (0x20 * i))
+#define CSI2_CTX_PING_ADDR_MASK				0xFFFFFFE0
+
+#define CSI2_CTX_PONG_ADDR(i)				(0x80 + (0x20 * i))
+#define CSI2_CTX_PONG_ADDR_MASK				CSI2_CTX_PING_ADDR_MASK
+
+#define CSI2_CTX_IRQENABLE(i)				(0x84 + (0x20 * i))
+#define CSI2_CTX_IRQSTATUS(i)				(0x88 + (0x20 * i))
+
+#define CSI2_CTX_CTRL3(i)				(0x8C + (0x20 * i))
+#define CSI2_CTX_CTRL3_ALPHA_SHIFT			5
+#define CSI2_CTX_CTRL3_ALPHA_MASK			\
+		(0x3fff << CSI2_CTX_CTRL3_ALPHA_SHIFT)
+
+/* Shared bits across CSI2_CTX_IRQENABLE and IRQSTATUS */
+#define CSI2_CTX_IRQ_ECC_CORRECTION			(1 << 8)
+#define CSI2_CTX_IRQ_LINE_NUMBER			(1 << 7)
+#define CSI2_CTX_IRQ_FRAME_NUMBER			(1 << 6)
+#define CSI2_CTX_IRQ_CS					(1 << 5)
+#define CSI2_CTX_IRQ_LE					(1 << 3)
+#define CSI2_CTX_IRQ_LS					(1 << 2)
+#define CSI2_CTX_IRQ_FE					(1 << 1)
+#define CSI2_CTX_IRQ_FS					(1 << 0)
+
+#endif /* _OMAP4_CAMERA_REGS_H_ */
diff --git a/drivers/media/video/omap4iss/iss_video.c b/drivers/media/video/omap4iss/iss_video.c
new file mode 100644
index 0000000..1efa683
--- /dev/null
+++ b/drivers/media/video/omap4iss/iss_video.c
@@ -0,0 +1,1123 @@
+/*
+ * TI OMAP4 ISS V4L2 Driver - Generic video node
+ *
+ * Copyright (C) 2012 Texas Instruments, Inc.
+ *
+ * Author: Sergio Aguirre <saaguirre@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <asm/cacheflush.h>
+#include <linux/clk.h>
+#include <linux/mm.h>
+#include <linux/pagemap.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <linux/module.h>
+#include <media/v4l2-dev.h>
+#include <media/v4l2-ioctl.h>
+#include <plat/omap-pm.h>
+
+#include "iss_video.h"
+#include "iss.h"
+
+
+/* -----------------------------------------------------------------------------
+ * Helper functions
+ */
+
+static struct iss_format_info formats[] = {
+	{ V4L2_MBUS_FMT_Y8_1X8, V4L2_MBUS_FMT_Y8_1X8,
+	  V4L2_MBUS_FMT_Y8_1X8, V4L2_MBUS_FMT_Y8_1X8,
+	  V4L2_PIX_FMT_GREY, 8, },
+	{ V4L2_MBUS_FMT_Y10_1X10, V4L2_MBUS_FMT_Y10_1X10,
+	  V4L2_MBUS_FMT_Y10_1X10, V4L2_MBUS_FMT_Y8_1X8,
+	  V4L2_PIX_FMT_Y10, 10, },
+	{ V4L2_MBUS_FMT_Y12_1X12, V4L2_MBUS_FMT_Y10_1X10,
+	  V4L2_MBUS_FMT_Y12_1X12, V4L2_MBUS_FMT_Y8_1X8,
+	  V4L2_PIX_FMT_Y12, 12, },
+	{ V4L2_MBUS_FMT_SBGGR8_1X8, V4L2_MBUS_FMT_SBGGR8_1X8,
+	  V4L2_MBUS_FMT_SBGGR8_1X8, V4L2_MBUS_FMT_SBGGR8_1X8,
+	  V4L2_PIX_FMT_SBGGR8, 8, },
+	{ V4L2_MBUS_FMT_SGBRG8_1X8, V4L2_MBUS_FMT_SGBRG8_1X8,
+	  V4L2_MBUS_FMT_SGBRG8_1X8, V4L2_MBUS_FMT_SGBRG8_1X8,
+	  V4L2_PIX_FMT_SGBRG8, 8, },
+	{ V4L2_MBUS_FMT_SGRBG8_1X8, V4L2_MBUS_FMT_SGRBG8_1X8,
+	  V4L2_MBUS_FMT_SGRBG8_1X8, V4L2_MBUS_FMT_SGRBG8_1X8,
+	  V4L2_PIX_FMT_SGRBG8, 8, },
+	{ V4L2_MBUS_FMT_SRGGB8_1X8, V4L2_MBUS_FMT_SRGGB8_1X8,
+	  V4L2_MBUS_FMT_SRGGB8_1X8, V4L2_MBUS_FMT_SRGGB8_1X8,
+	  V4L2_PIX_FMT_SRGGB8, 8, },
+	{ V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8, V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8,
+	  V4L2_MBUS_FMT_SGRBG10_1X10, 0,
+	  V4L2_PIX_FMT_SGRBG10DPCM8, 8, },
+	{ V4L2_MBUS_FMT_SBGGR10_1X10, V4L2_MBUS_FMT_SBGGR10_1X10,
+	  V4L2_MBUS_FMT_SBGGR10_1X10, V4L2_MBUS_FMT_SBGGR8_1X8,
+	  V4L2_PIX_FMT_SBGGR10, 10, },
+	{ V4L2_MBUS_FMT_SGBRG10_1X10, V4L2_MBUS_FMT_SGBRG10_1X10,
+	  V4L2_MBUS_FMT_SGBRG10_1X10, V4L2_MBUS_FMT_SGBRG8_1X8,
+	  V4L2_PIX_FMT_SGBRG10, 10, },
+	{ V4L2_MBUS_FMT_SGRBG10_1X10, V4L2_MBUS_FMT_SGRBG10_1X10,
+	  V4L2_MBUS_FMT_SGRBG10_1X10, V4L2_MBUS_FMT_SGRBG8_1X8,
+	  V4L2_PIX_FMT_SGRBG10, 10, },
+	{ V4L2_MBUS_FMT_SRGGB10_1X10, V4L2_MBUS_FMT_SRGGB10_1X10,
+	  V4L2_MBUS_FMT_SRGGB10_1X10, V4L2_MBUS_FMT_SRGGB8_1X8,
+	  V4L2_PIX_FMT_SRGGB10, 10, },
+	{ V4L2_MBUS_FMT_SBGGR12_1X12, V4L2_MBUS_FMT_SBGGR10_1X10,
+	  V4L2_MBUS_FMT_SBGGR12_1X12, V4L2_MBUS_FMT_SBGGR8_1X8,
+	  V4L2_PIX_FMT_SBGGR12, 12, },
+	{ V4L2_MBUS_FMT_SGBRG12_1X12, V4L2_MBUS_FMT_SGBRG10_1X10,
+	  V4L2_MBUS_FMT_SGBRG12_1X12, V4L2_MBUS_FMT_SGBRG8_1X8,
+	  V4L2_PIX_FMT_SGBRG12, 12, },
+	{ V4L2_MBUS_FMT_SGRBG12_1X12, V4L2_MBUS_FMT_SGRBG10_1X10,
+	  V4L2_MBUS_FMT_SGRBG12_1X12, V4L2_MBUS_FMT_SGRBG8_1X8,
+	  V4L2_PIX_FMT_SGRBG12, 12, },
+	{ V4L2_MBUS_FMT_SRGGB12_1X12, V4L2_MBUS_FMT_SRGGB10_1X10,
+	  V4L2_MBUS_FMT_SRGGB12_1X12, V4L2_MBUS_FMT_SRGGB8_1X8,
+	  V4L2_PIX_FMT_SRGGB12, 12, },
+	{ V4L2_MBUS_FMT_UYVY8_1X16, V4L2_MBUS_FMT_UYVY8_1X16,
+	  V4L2_MBUS_FMT_UYVY8_1X16, 0,
+	  V4L2_PIX_FMT_UYVY, 16, },
+	{ V4L2_MBUS_FMT_YUYV8_1X16, V4L2_MBUS_FMT_YUYV8_1X16,
+	  V4L2_MBUS_FMT_YUYV8_1X16, 0,
+	  V4L2_PIX_FMT_YUYV, 16, },
+};
+
+const struct iss_format_info *
+omap4iss_video_format_info(enum v4l2_mbus_pixelcode code)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(formats); ++i) {
+		if (formats[i].code == code)
+			return &formats[i];
+	}
+
+	return NULL;
+}
+
+/*
+ * iss_video_mbus_to_pix - Convert v4l2_mbus_framefmt to v4l2_pix_format
+ * @video: ISS video instance
+ * @mbus: v4l2_mbus_framefmt format (input)
+ * @pix: v4l2_pix_format format (output)
+ *
+ * Fill the output pix structure with information from the input mbus format.
+ * The bytesperline and sizeimage fields are computed from the requested bytes
+ * per line value in the pix format and information from the video instance.
+ *
+ * Return the number of padding bytes at end of line.
+ */
+static unsigned int iss_video_mbus_to_pix(const struct iss_video *video,
+					  const struct v4l2_mbus_framefmt *mbus,
+					  struct v4l2_pix_format *pix)
+{
+	unsigned int bpl = pix->bytesperline;
+	unsigned int min_bpl;
+	unsigned int i;
+
+	memset(pix, 0, sizeof(*pix));
+	pix->width = mbus->width;
+	pix->height = mbus->height;
+
+	/* Skip the last format in the loop so that it will be selected if no
+	 * match is found.
+	 */
+	for (i = 0; i < ARRAY_SIZE(formats) - 1; ++i) {
+		if (formats[i].code == mbus->code)
+			break;
+	}
+
+	min_bpl = pix->width * ALIGN(formats[i].bpp, 8) / 8;
+
+	/* Clamp the requested bytes per line value. If the maximum bytes per
+	 * line value is zero, the module doesn't support user configurable line
+	 * sizes. Override the requested value with the minimum in that case.
+	 */
+	if (video->bpl_max)
+		bpl = clamp(bpl, min_bpl, video->bpl_max);
+	else
+		bpl = min_bpl;
+
+	if (!video->bpl_zero_padding || bpl != min_bpl)
+		bpl = ALIGN(bpl, video->bpl_alignment);
+
+	pix->pixelformat = formats[i].pixelformat;
+	pix->bytesperline = bpl;
+	pix->sizeimage = pix->bytesperline * pix->height;
+	pix->colorspace = mbus->colorspace;
+	pix->field = mbus->field;
+
+	return bpl - min_bpl;
+}
+
+static void iss_video_pix_to_mbus(const struct v4l2_pix_format *pix,
+				  struct v4l2_mbus_framefmt *mbus)
+{
+	unsigned int i;
+
+	memset(mbus, 0, sizeof(*mbus));
+	mbus->width = pix->width;
+	mbus->height = pix->height;
+
+	for (i = 0; i < ARRAY_SIZE(formats); ++i) {
+		if (formats[i].pixelformat == pix->pixelformat)
+			break;
+	}
+
+	if (WARN_ON(i == ARRAY_SIZE(formats)))
+		return;
+
+	mbus->code = formats[i].code;
+	mbus->colorspace = pix->colorspace;
+	mbus->field = pix->field;
+}
+
+static struct v4l2_subdev *
+iss_video_remote_subdev(struct iss_video *video, u32 *pad)
+{
+	struct media_pad *remote;
+
+	remote = media_entity_remote_source(&video->pad);
+
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
+/* Return a pointer to the ISS video instance at the far end of the pipeline. */
+static struct iss_video *
+iss_video_far_end(struct iss_video *video)
+{
+	struct media_entity_graph graph;
+	struct media_entity *entity = &video->video.entity;
+	struct media_device *mdev = entity->parent;
+	struct iss_video *far_end = NULL;
+
+	mutex_lock(&mdev->graph_mutex);
+	media_entity_graph_walk_start(&graph, entity);
+
+	while ((entity = media_entity_graph_walk_next(&graph))) {
+		if (entity == &video->video.entity)
+			continue;
+
+		if (media_entity_type(entity) != MEDIA_ENT_T_DEVNODE)
+			continue;
+
+		far_end = to_iss_video(media_entity_to_video_device(entity));
+		if (far_end->type != video->type)
+			break;
+
+		far_end = NULL;
+	}
+
+	mutex_unlock(&mdev->graph_mutex);
+	return far_end;
+}
+
+static int
+__iss_video_get_format(struct iss_video *video, struct v4l2_format *format)
+{
+	struct v4l2_subdev_format fmt;
+	struct v4l2_subdev *subdev;
+	u32 pad;
+	int ret;
+
+	subdev = iss_video_remote_subdev(video, &pad);
+	if (subdev == NULL)
+		return -EINVAL;
+
+	mutex_lock(&video->mutex);
+
+	fmt.pad = pad;
+	fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+	ret = v4l2_subdev_call(subdev, pad, get_fmt, NULL, &fmt);
+	if (ret == -ENOIOCTLCMD)
+		ret = -EINVAL;
+
+	mutex_unlock(&video->mutex);
+
+	if (ret)
+		return ret;
+
+	format->type = video->type;
+	return iss_video_mbus_to_pix(video, &fmt.format, &format->fmt.pix);
+}
+
+static int
+iss_video_check_format(struct iss_video *video, struct iss_video_fh *vfh)
+{
+	struct v4l2_format format;
+	int ret;
+
+	memcpy(&format, &vfh->format, sizeof(format));
+	ret = __iss_video_get_format(video, &format);
+	if (ret < 0)
+		return ret;
+
+	if (vfh->format.fmt.pix.pixelformat != format.fmt.pix.pixelformat ||
+	    vfh->format.fmt.pix.height != format.fmt.pix.height ||
+	    vfh->format.fmt.pix.width != format.fmt.pix.width ||
+	    vfh->format.fmt.pix.bytesperline != format.fmt.pix.bytesperline ||
+	    vfh->format.fmt.pix.sizeimage != format.fmt.pix.sizeimage)
+		return -EINVAL;
+
+	return ret;
+}
+
+/* -----------------------------------------------------------------------------
+ * Video queue operations
+ */
+
+static int iss_video_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+				 unsigned int *count, unsigned int *num_planes,
+				 unsigned int sizes[], void *alloc_ctxs[])
+{
+	struct iss_video_fh *vfh = vb2_get_drv_priv(vq);
+	struct iss_video *video = vfh->video;
+
+	/* Revisit multi-planar support for NV12 */
+	*num_planes = 1;
+
+	sizes[0] = vfh->format.fmt.pix.sizeimage;
+	if (sizes[0] == 0)
+		return -EINVAL;
+
+	alloc_ctxs[0] = video->alloc_ctx;
+
+	*count = min(*count, (unsigned int)(video->capture_mem / PAGE_ALIGN(sizes[0])));
+
+	return 0;
+}
+
+static void iss_video_buf_cleanup(struct vb2_buffer *vb)
+{
+	struct iss_buffer *buffer = container_of(vb, struct iss_buffer, vb);
+
+	if (buffer->iss_addr)
+		buffer->iss_addr = 0;
+}
+
+static int iss_video_buf_prepare(struct vb2_buffer *vb)
+{
+	struct iss_video_fh *vfh = vb2_get_drv_priv(vb->vb2_queue);
+	struct iss_buffer *buffer = container_of(vb, struct iss_buffer, vb);
+	struct iss_video *video = vfh->video;
+	unsigned long size = vfh->format.fmt.pix.sizeimage;
+	dma_addr_t addr;
+
+	if (vb2_plane_size(vb, 0) < size)
+		return -ENOBUFS;
+
+	addr = vb2_dma_contig_plane_dma_addr(vb, 0);
+	if (!IS_ALIGNED(addr, 32)) {
+		dev_dbg(video->iss->dev, "Buffer address must be "
+			"aligned to 32 bytes boundary.\n");
+		return -EINVAL;
+	}
+
+	vb2_set_plane_payload(vb, 0, size);
+	buffer->iss_addr = addr;
+	return 0;
+}
+
+static void iss_video_buf_queue(struct vb2_buffer *vb)
+{
+	struct iss_video_fh *vfh = vb2_get_drv_priv(vb->vb2_queue);
+	struct iss_video *video = vfh->video;
+	struct iss_buffer *buffer = container_of(vb, struct iss_buffer, vb);
+	struct iss_pipeline *pipe = to_iss_pipeline(&video->video.entity);
+	unsigned int empty;
+	unsigned long flags;
+
+	spin_lock_irqsave(&video->qlock, flags);
+	empty = list_empty(&video->dmaqueue);
+	list_add_tail(&buffer->list, &video->dmaqueue);
+	spin_unlock_irqrestore(&video->qlock, flags);
+
+	if (empty) {
+		enum iss_pipeline_state state;
+		unsigned int start;
+
+		if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
+			state = ISS_PIPELINE_QUEUE_OUTPUT;
+		else
+			state = ISS_PIPELINE_QUEUE_INPUT;
+
+		spin_lock_irqsave(&pipe->lock, flags);
+		pipe->state |= state;
+		video->ops->queue(video, buffer);
+		video->dmaqueue_flags |= ISS_VIDEO_DMAQUEUE_QUEUED;
+
+		start = iss_pipeline_ready(pipe);
+		if (start)
+			pipe->state |= ISS_PIPELINE_STREAM;
+		spin_unlock_irqrestore(&pipe->lock, flags);
+
+		if (start)
+			omap4iss_pipeline_set_stream(pipe,
+						ISS_PIPELINE_STREAM_SINGLESHOT);
+	}
+}
+
+static struct vb2_ops iss_video_vb2ops = {
+	.queue_setup	= iss_video_queue_setup,
+	.buf_prepare	= iss_video_buf_prepare,
+	.buf_queue	= iss_video_buf_queue,
+	.buf_cleanup	= iss_video_buf_cleanup,
+};
+
+/*
+ * omap4iss_video_buffer_next - Complete the current buffer and return the next
+ * @video: ISS video object
+ *
+ * Remove the current video buffer from the DMA queue and fill its timestamp,
+ * field count and state fields before waking up its completion handler.
+ *
+ * For capture video nodes, the buffer state is set to VB2_BUF_STATE_DONE if no
+ * error has been flagged in the pipeline, or to VB2_BUF_STATE_ERROR otherwise.
+ *
+ * The DMA queue is expected to contain at least one buffer.
+ *
+ * Return a pointer to the next buffer in the DMA queue, or NULL if the queue is
+ * empty.
+ */
+struct iss_buffer *omap4iss_video_buffer_next(struct iss_video *video)
+{
+	struct iss_pipeline *pipe = to_iss_pipeline(&video->video.entity);
+	enum iss_pipeline_state state;
+	struct iss_buffer *buf;
+	unsigned long flags;
+	struct timespec ts;
+
+	spin_lock_irqsave(&video->qlock, flags);
+	if (WARN_ON(list_empty(&video->dmaqueue))) {
+		spin_unlock_irqrestore(&video->qlock, flags);
+		return NULL;
+	}
+
+	buf = list_first_entry(&video->dmaqueue, struct iss_buffer,
+			       list);
+	list_del(&buf->list);
+	spin_unlock_irqrestore(&video->qlock, flags);
+
+	ktime_get_ts(&ts);
+	buf->vb.v4l2_buf.timestamp.tv_sec = ts.tv_sec;
+	buf->vb.v4l2_buf.timestamp.tv_usec = ts.tv_nsec / NSEC_PER_USEC;
+
+	/* Do frame number propagation only if this is the output video node.
+	 * Frame number either comes from the CSI receivers or it gets
+	 * incremented here if H3A is not active.
+	 * Note: There is no guarantee that the output buffer will finish
+	 * first, so the input number might lag behind by 1 in some cases.
+	 */
+	if (video == pipe->output && !pipe->do_propagation)
+		buf->vb.v4l2_buf.sequence = atomic_inc_return(&pipe->frame_number);
+	else
+		buf->vb.v4l2_buf.sequence = atomic_read(&pipe->frame_number);
+
+	vb2_buffer_done(&buf->vb, pipe->error ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
+	pipe->error = false;
+
+	spin_lock_irqsave(&video->qlock, flags);
+	if (list_empty(&video->dmaqueue)) {
+		spin_unlock_irqrestore(&video->qlock, flags);
+		if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
+			state = ISS_PIPELINE_QUEUE_OUTPUT
+			      | ISS_PIPELINE_STREAM;
+		else
+			state = ISS_PIPELINE_QUEUE_INPUT
+			      | ISS_PIPELINE_STREAM;
+
+		spin_lock_irqsave(&pipe->lock, flags);
+		pipe->state &= ~state;
+		if (video->pipe.stream_state == ISS_PIPELINE_STREAM_CONTINUOUS)
+			video->dmaqueue_flags |= ISS_VIDEO_DMAQUEUE_UNDERRUN;
+		spin_unlock_irqrestore(&pipe->lock, flags);
+		return NULL;
+	}
+
+	if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE && pipe->input != NULL) {
+		spin_lock_irqsave(&pipe->lock, flags);
+		pipe->state &= ~ISS_PIPELINE_STREAM;
+		spin_unlock_irqrestore(&pipe->lock, flags);
+	}
+
+	buf = list_first_entry(&video->dmaqueue, struct iss_buffer,
+			       list);
+	spin_unlock_irqrestore(&video->qlock, flags);
+	buf->vb.state = VB2_BUF_STATE_ACTIVE;
+	return buf;
+}
+
+/* -----------------------------------------------------------------------------
+ * V4L2 ioctls
+ */
+
+static int
+iss_video_querycap(struct file *file, void *fh, struct v4l2_capability *cap)
+{
+	struct iss_video *video = video_drvdata(file);
+
+	strlcpy(cap->driver, ISS_VIDEO_DRIVER_NAME, sizeof(cap->driver));
+	strlcpy(cap->card, video->video.name, sizeof(cap->card));
+	strlcpy(cap->bus_info, "media", sizeof(cap->bus_info));
+
+	if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+	else
+		cap->capabilities = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
+
+	return 0;
+}
+
+static int
+iss_video_get_format(struct file *file, void *fh, struct v4l2_format *format)
+{
+	struct iss_video_fh *vfh = to_iss_video_fh(fh);
+	struct iss_video *video = video_drvdata(file);
+
+	if (format->type != video->type)
+		return -EINVAL;
+
+	mutex_lock(&video->mutex);
+	*format = vfh->format;
+	mutex_unlock(&video->mutex);
+
+	return 0;
+}
+
+static int
+iss_video_set_format(struct file *file, void *fh, struct v4l2_format *format)
+{
+	struct iss_video_fh *vfh = to_iss_video_fh(fh);
+	struct iss_video *video = video_drvdata(file);
+	struct v4l2_mbus_framefmt fmt;
+
+	if (format->type != video->type)
+		return -EINVAL;
+
+	mutex_lock(&video->mutex);
+
+	/* Fill the bytesperline and sizeimage fields by converting to media bus
+	 * format and back to pixel format.
+	 */
+	iss_video_pix_to_mbus(&format->fmt.pix, &fmt);
+	iss_video_mbus_to_pix(video, &fmt, &format->fmt.pix);
+
+	vfh->format = *format;
+
+	mutex_unlock(&video->mutex);
+	return 0;
+}
+
+static int
+iss_video_try_format(struct file *file, void *fh, struct v4l2_format *format)
+{
+	struct iss_video *video = video_drvdata(file);
+	struct v4l2_subdev_format fmt;
+	struct v4l2_subdev *subdev;
+	u32 pad;
+	int ret;
+
+	if (format->type != video->type)
+		return -EINVAL;
+
+	subdev = iss_video_remote_subdev(video, &pad);
+	if (subdev == NULL)
+		return -EINVAL;
+
+	iss_video_pix_to_mbus(&format->fmt.pix, &fmt.format);
+
+	fmt.pad = pad;
+	fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+	ret = v4l2_subdev_call(subdev, pad, get_fmt, NULL, &fmt);
+	if (ret)
+		return ret == -ENOIOCTLCMD ? -EINVAL : ret;
+
+	iss_video_mbus_to_pix(video, &fmt.format, &format->fmt.pix);
+	return 0;
+}
+
+static int
+iss_video_cropcap(struct file *file, void *fh, struct v4l2_cropcap *cropcap)
+{
+	struct iss_video *video = video_drvdata(file);
+	struct v4l2_subdev *subdev;
+	int ret;
+
+	subdev = iss_video_remote_subdev(video, NULL);
+	if (subdev == NULL)
+		return -EINVAL;
+
+	mutex_lock(&video->mutex);
+	ret = v4l2_subdev_call(subdev, video, cropcap, cropcap);
+	mutex_unlock(&video->mutex);
+
+	return ret == -ENOIOCTLCMD ? -EINVAL : ret;
+}
+
+static int
+iss_video_get_crop(struct file *file, void *fh, struct v4l2_crop *crop)
+{
+	struct iss_video *video = video_drvdata(file);
+	struct v4l2_subdev_format format;
+	struct v4l2_subdev *subdev;
+	u32 pad;
+	int ret;
+
+	subdev = iss_video_remote_subdev(video, &pad);
+	if (subdev == NULL)
+		return -EINVAL;
+
+	/* Try the get crop operation first and fallback to get format if not
+	 * implemented.
+	 */
+	ret = v4l2_subdev_call(subdev, video, g_crop, crop);
+	if (ret != -ENOIOCTLCMD)
+		return ret;
+
+	format.pad = pad;
+	format.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+	ret = v4l2_subdev_call(subdev, pad, get_fmt, NULL, &format);
+	if (ret < 0)
+		return ret == -ENOIOCTLCMD ? -EINVAL : ret;
+
+	crop->c.left = 0;
+	crop->c.top = 0;
+	crop->c.width = format.format.width;
+	crop->c.height = format.format.height;
+
+	return 0;
+}
+
+static int
+iss_video_set_crop(struct file *file, void *fh, struct v4l2_crop *crop)
+{
+	struct iss_video *video = video_drvdata(file);
+	struct v4l2_subdev *subdev;
+	int ret;
+
+	subdev = iss_video_remote_subdev(video, NULL);
+	if (subdev == NULL)
+		return -EINVAL;
+
+	mutex_lock(&video->mutex);
+	ret = v4l2_subdev_call(subdev, video, s_crop, crop);
+	mutex_unlock(&video->mutex);
+
+	return ret == -ENOIOCTLCMD ? -EINVAL : ret;
+}
+
+static int
+iss_video_get_param(struct file *file, void *fh, struct v4l2_streamparm *a)
+{
+	struct iss_video_fh *vfh = to_iss_video_fh(fh);
+	struct iss_video *video = video_drvdata(file);
+
+	if (video->type != V4L2_BUF_TYPE_VIDEO_OUTPUT ||
+	    video->type != a->type)
+		return -EINVAL;
+
+	memset(a, 0, sizeof(*a));
+	a->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
+	a->parm.output.capability = V4L2_CAP_TIMEPERFRAME;
+	a->parm.output.timeperframe = vfh->timeperframe;
+
+	return 0;
+}
+
+static int
+iss_video_set_param(struct file *file, void *fh, struct v4l2_streamparm *a)
+{
+	struct iss_video_fh *vfh = to_iss_video_fh(fh);
+	struct iss_video *video = video_drvdata(file);
+
+	if (video->type != V4L2_BUF_TYPE_VIDEO_OUTPUT ||
+	    video->type != a->type)
+		return -EINVAL;
+
+	if (a->parm.output.timeperframe.denominator == 0)
+		a->parm.output.timeperframe.denominator = 1;
+
+	vfh->timeperframe = a->parm.output.timeperframe;
+
+	return 0;
+}
+
+static int
+iss_video_reqbufs(struct file *file, void *fh, struct v4l2_requestbuffers *rb)
+{
+	struct iss_video_fh *vfh = to_iss_video_fh(fh);
+
+	return vb2_reqbufs(&vfh->queue, rb);
+}
+
+static int
+iss_video_querybuf(struct file *file, void *fh, struct v4l2_buffer *b)
+{
+	struct iss_video_fh *vfh = to_iss_video_fh(fh);
+
+	return vb2_querybuf(&vfh->queue, b);
+}
+
+static int
+iss_video_qbuf(struct file *file, void *fh, struct v4l2_buffer *b)
+{
+	struct iss_video_fh *vfh = to_iss_video_fh(fh);
+
+	return vb2_qbuf(&vfh->queue, b);
+}
+
+static int
+iss_video_dqbuf(struct file *file, void *fh, struct v4l2_buffer *b)
+{
+	struct iss_video_fh *vfh = to_iss_video_fh(fh);
+
+	return vb2_dqbuf(&vfh->queue, b, file->f_flags & O_NONBLOCK);
+}
+
+/*
+ * Stream management
+ *
+ * Every ISS pipeline has a single input and a single output. The input can be
+ * either a sensor or a video node. The output is always a video node.
+ *
+ * As every pipeline has an output video node, the ISS video objects at the
+ * pipeline output stores the pipeline state. It tracks the streaming state of
+ * both the input and output, as well as the availability of buffers.
+ *
+ * In sensor-to-memory mode, frames are always available at the pipeline input.
+ * Starting the sensor usually requires I2C transfers and must be done in
+ * interruptible context. The pipeline is started and stopped synchronously
+ * to the stream on/off commands. All modules in the pipeline will get their
+ * subdev set stream handler called. The module at the end of the pipeline must
+ * delay starting the hardware until buffers are available at its output.
+ *
+ * In memory-to-memory mode, starting/stopping the stream requires
+ * synchronization between the input and output. ISS modules can't be stopped
+ * in the middle of a frame, and at least some of the modules seem to become
+ * busy as soon as they're started, even if they don't receive a frame start
+ * event. For that reason frames need to be processed in single-shot mode. The
+ * driver needs to wait until a frame is completely processed and written to
+ * memory before restarting the pipeline for the next frame. Pipelined
+ * processing might be possible but requires more testing.
+ *
+ * Stream start must be delayed until buffers are available at both the input
+ * and output. The pipeline must be started in the videobuf queue callback with
+ * the buffers queue spinlock held. The modules subdev set stream operation must
+ * not sleep.
+ */
+static int
+iss_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
+{
+	struct iss_video_fh *vfh = to_iss_video_fh(fh);
+	struct iss_video *video = video_drvdata(file);
+	enum iss_pipeline_state state;
+	struct iss_pipeline *pipe;
+	struct iss_video *far_end;
+	unsigned long flags;
+	int ret;
+
+	if (type != video->type)
+		return -EINVAL;
+
+	mutex_lock(&video->stream_lock);
+
+	if (video->streaming) {
+		mutex_unlock(&video->stream_lock);
+		return -EBUSY;
+	}
+
+	/* Start streaming on the pipeline. No link touching an entity in the
+	 * pipeline can be activated or deactivated once streaming is started.
+	 */
+	pipe = video->video.entity.pipe
+	     ? to_iss_pipeline(&video->video.entity) : &video->pipe;
+	pipe->external = NULL;
+	pipe->external_rate = 0;
+	pipe->external_bpp = 0;
+
+	if (video->iss->pdata->set_constraints)
+		video->iss->pdata->set_constraints(video->iss, true);
+
+	ret = media_entity_pipeline_start(&video->video.entity, &pipe->pipe);
+	if (ret < 0)
+		goto err_media_entity_pipeline_start;
+
+	/* Verify that the currently configured format matches the output of
+	 * the connected subdev.
+	 */
+	ret = iss_video_check_format(video, vfh);
+	if (ret < 0)
+		goto err_iss_video_check_format;
+
+	video->bpl_padding = ret;
+	video->bpl_value = vfh->format.fmt.pix.bytesperline;
+
+	/* Find the ISS video node connected at the far end of the pipeline and
+	 * update the pipeline.
+	 */
+	far_end = iss_video_far_end(video);
+
+	if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+		state = ISS_PIPELINE_STREAM_OUTPUT | ISS_PIPELINE_IDLE_OUTPUT;
+		pipe->input = far_end;
+		pipe->output = video;
+	} else {
+		if (far_end == NULL) {
+			ret = -EPIPE;
+			goto err_iss_video_check_format;
+		}
+
+		state = ISS_PIPELINE_STREAM_INPUT | ISS_PIPELINE_IDLE_INPUT;
+		pipe->input = video;
+		pipe->output = far_end;
+	}
+
+	spin_lock_irqsave(&pipe->lock, flags);
+	pipe->state &= ~ISS_PIPELINE_STREAM;
+	pipe->state |= state;
+	spin_unlock_irqrestore(&pipe->lock, flags);
+
+	/* Set the maximum time per frame as the value requested by userspace.
+	 * This is a soft limit that can be overridden if the hardware doesn't
+	 * support the request limit.
+	 */
+	if (video->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+		pipe->max_timeperframe = vfh->timeperframe;
+
+	video->queue = &vfh->queue;
+	INIT_LIST_HEAD(&video->dmaqueue);
+	spin_lock_init(&video->qlock);
+	atomic_set(&pipe->frame_number, -1);
+
+	ret = vb2_streamon(&vfh->queue, type);
+	if (ret < 0)
+		goto err_iss_video_check_format;
+
+	/* In sensor-to-memory mode, the stream can be started synchronously
+	 * to the stream on command. In memory-to-memory mode, it will be
+	 * started when buffers are queued on both the input and output.
+	 */
+	if (pipe->input == NULL) {
+		unsigned long flags;
+		ret = omap4iss_pipeline_set_stream(pipe,
+					      ISS_PIPELINE_STREAM_CONTINUOUS);
+		if (ret < 0)
+			goto err_omap4iss_set_stream;
+		spin_lock_irqsave(&video->qlock, flags);
+		if (list_empty(&video->dmaqueue))
+			video->dmaqueue_flags |= ISS_VIDEO_DMAQUEUE_UNDERRUN;
+		spin_unlock_irqrestore(&video->qlock, flags);
+	}
+
+	if (ret < 0) {
+err_omap4iss_set_stream:
+		vb2_streamoff(&vfh->queue, type);
+err_iss_video_check_format:
+		media_entity_pipeline_stop(&video->video.entity);
+err_media_entity_pipeline_start:
+		if (video->iss->pdata->set_constraints)
+			video->iss->pdata->set_constraints(video->iss, false);
+		video->queue = NULL;
+	}
+
+	if (!ret)
+		video->streaming = 1;
+
+	mutex_unlock(&video->stream_lock);
+	return ret;
+}
+
+static int
+iss_video_streamoff(struct file *file, void *fh, enum v4l2_buf_type type)
+{
+	struct iss_video_fh *vfh = to_iss_video_fh(fh);
+	struct iss_video *video = video_drvdata(file);
+	struct iss_pipeline *pipe = to_iss_pipeline(&video->video.entity);
+	enum iss_pipeline_state state;
+	unsigned long flags;
+
+	if (type != video->type)
+		return -EINVAL;
+
+	mutex_lock(&video->stream_lock);
+
+	if (!vb2_is_streaming(&vfh->queue))
+		goto done;
+
+	/* Update the pipeline state. */
+	if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		state = ISS_PIPELINE_STREAM_OUTPUT
+		      | ISS_PIPELINE_QUEUE_OUTPUT;
+	else
+		state = ISS_PIPELINE_STREAM_INPUT
+		      | ISS_PIPELINE_QUEUE_INPUT;
+
+	spin_lock_irqsave(&pipe->lock, flags);
+	pipe->state &= ~state;
+	spin_unlock_irqrestore(&pipe->lock, flags);
+
+	/* Stop the stream. */
+	omap4iss_pipeline_set_stream(pipe, ISS_PIPELINE_STREAM_STOPPED);
+	vb2_streamoff(&vfh->queue, type);
+	video->queue = NULL;
+	video->streaming = 0;
+
+	if (video->iss->pdata->set_constraints)
+		video->iss->pdata->set_constraints(video->iss, false);
+	media_entity_pipeline_stop(&video->video.entity);
+
+done:
+	mutex_unlock(&video->stream_lock);
+	return 0;
+}
+
+static int
+iss_video_enum_input(struct file *file, void *fh, struct v4l2_input *input)
+{
+	if (input->index > 0)
+		return -EINVAL;
+
+	strlcpy(input->name, "camera", sizeof(input->name));
+	input->type = V4L2_INPUT_TYPE_CAMERA;
+
+	return 0;
+}
+
+static int
+iss_video_g_input(struct file *file, void *fh, unsigned int *input)
+{
+	*input = 0;
+
+	return 0;
+}
+
+static const struct v4l2_ioctl_ops iss_video_ioctl_ops = {
+	.vidioc_querycap		= iss_video_querycap,
+	.vidioc_g_fmt_vid_cap		= iss_video_get_format,
+	.vidioc_s_fmt_vid_cap		= iss_video_set_format,
+	.vidioc_try_fmt_vid_cap		= iss_video_try_format,
+	.vidioc_g_fmt_vid_out		= iss_video_get_format,
+	.vidioc_s_fmt_vid_out		= iss_video_set_format,
+	.vidioc_try_fmt_vid_out		= iss_video_try_format,
+	.vidioc_cropcap			= iss_video_cropcap,
+	.vidioc_g_crop			= iss_video_get_crop,
+	.vidioc_s_crop			= iss_video_set_crop,
+	.vidioc_g_parm			= iss_video_get_param,
+	.vidioc_s_parm			= iss_video_set_param,
+	.vidioc_reqbufs			= iss_video_reqbufs,
+	.vidioc_querybuf		= iss_video_querybuf,
+	.vidioc_qbuf			= iss_video_qbuf,
+	.vidioc_dqbuf			= iss_video_dqbuf,
+	.vidioc_streamon		= iss_video_streamon,
+	.vidioc_streamoff		= iss_video_streamoff,
+	.vidioc_enum_input		= iss_video_enum_input,
+	.vidioc_g_input			= iss_video_g_input,
+};
+
+/* -----------------------------------------------------------------------------
+ * V4L2 file operations
+ */
+
+static int iss_video_open(struct file *file)
+{
+	struct iss_video *video = video_drvdata(file);
+	struct iss_video_fh *handle;
+	struct vb2_queue *q;
+	int ret = 0;
+
+	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
+	if (handle == NULL)
+		return -ENOMEM;
+
+	v4l2_fh_init(&handle->vfh, &video->video);
+	v4l2_fh_add(&handle->vfh);
+
+	/* If this is the first user, initialise the pipeline. */
+	if (omap4iss_get(video->iss) == NULL) {
+		ret = -EBUSY;
+		goto done;
+	}
+
+	ret = omap4iss_pipeline_pm_use(&video->video.entity, 1);
+	if (ret < 0) {
+		omap4iss_put(video->iss);
+		goto done;
+	}
+
+	video->alloc_ctx = vb2_dma_contig_init_ctx(video->iss->dev);
+	if (IS_ERR(video->alloc_ctx)) {
+		ret = PTR_ERR(video->alloc_ctx);
+		omap4iss_put(video->iss);
+		goto done;
+	}
+
+	q = &handle->queue;
+
+	q->type = video->type;
+	q->io_modes = VB2_MMAP;
+	q->drv_priv = handle;
+	q->ops = &iss_video_vb2ops;
+	q->mem_ops = &vb2_dma_contig_memops;
+	q->buf_struct_size = sizeof(struct iss_buffer);
+
+	ret = vb2_queue_init(q);
+	if (ret) {
+		omap4iss_put(video->iss);
+		goto done;
+	}
+
+	memset(&handle->format, 0, sizeof(handle->format));
+	handle->format.type = video->type;
+	handle->timeperframe.denominator = 1;
+
+	handle->video = video;
+	file->private_data = &handle->vfh;
+
+done:
+	if (ret < 0) {
+		v4l2_fh_del(&handle->vfh);
+		kfree(handle);
+	}
+
+	return ret;
+}
+
+static int iss_video_release(struct file *file)
+{
+	struct iss_video *video = video_drvdata(file);
+	struct v4l2_fh *vfh = file->private_data;
+	struct iss_video_fh *handle = to_iss_video_fh(vfh);
+
+	/* Disable streaming and free the buffers queue resources. */
+	iss_video_streamoff(file, vfh, video->type);
+
+	omap4iss_pipeline_pm_use(&video->video.entity, 0);
+
+	/* Release the videobuf2 queue */
+	vb2_queue_release(&handle->queue);
+
+	/* Release the file handle. */
+	v4l2_fh_del(vfh);
+	kfree(handle);
+	file->private_data = NULL;
+
+	omap4iss_put(video->iss);
+
+	return 0;
+}
+
+static unsigned int iss_video_poll(struct file *file, poll_table *wait)
+{
+	struct iss_video_fh *vfh = to_iss_video_fh(file->private_data);
+
+	return vb2_poll(&vfh->queue, file, wait);
+}
+
+static int iss_video_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct iss_video_fh *vfh = to_iss_video_fh(file->private_data);
+
+	return vb2_mmap(&vfh->queue, vma);;
+}
+
+static struct v4l2_file_operations iss_video_fops = {
+	.owner = THIS_MODULE,
+	.unlocked_ioctl = video_ioctl2,
+	.open = iss_video_open,
+	.release = iss_video_release,
+	.poll = iss_video_poll,
+	.mmap = iss_video_mmap,
+};
+
+/* -----------------------------------------------------------------------------
+ * ISS video core
+ */
+
+static const struct iss_video_operations iss_video_dummy_ops = {
+};
+
+int omap4iss_video_init(struct iss_video *video, const char *name)
+{
+	const char *direction;
+	int ret;
+
+	switch (video->type) {
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+		direction = "output";
+		video->pad.flags = MEDIA_PAD_FL_SINK;
+		break;
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
+		direction = "input";
+		video->pad.flags = MEDIA_PAD_FL_SOURCE;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	ret = media_entity_init(&video->video.entity, 1, &video->pad, 0);
+	if (ret < 0)
+		return ret;
+
+	mutex_init(&video->mutex);
+	atomic_set(&video->active, 0);
+
+	spin_lock_init(&video->pipe.lock);
+	mutex_init(&video->stream_lock);
+
+	/* Initialize the video device. */
+	if (video->ops == NULL)
+		video->ops = &iss_video_dummy_ops;
+
+	video->video.fops = &iss_video_fops;
+	snprintf(video->video.name, sizeof(video->video.name),
+		 "OMAP4 ISS %s %s", name, direction);
+	video->video.vfl_type = VFL_TYPE_GRABBER;
+	video->video.release = video_device_release_empty;
+	video->video.ioctl_ops = &iss_video_ioctl_ops;
+	video->pipe.stream_state = ISS_PIPELINE_STREAM_STOPPED;
+
+	video_set_drvdata(&video->video, video);
+
+	return 0;
+}
+
+void omap4iss_video_cleanup(struct iss_video *video)
+{
+	media_entity_cleanup(&video->video.entity);
+	mutex_destroy(&video->stream_lock);
+	mutex_destroy(&video->mutex);
+}
+
+int omap4iss_video_register(struct iss_video *video, struct v4l2_device *vdev)
+{
+	int ret;
+
+	video->video.v4l2_dev = vdev;
+
+	ret = video_register_device(&video->video, VFL_TYPE_GRABBER, -1);
+	if (ret < 0)
+		printk(KERN_ERR "%s: could not register video device (%d)\n",
+			__func__, ret);
+
+	return ret;
+}
+
+void omap4iss_video_unregister(struct iss_video *video)
+{
+	if (video_is_registered(&video->video))
+		video_unregister_device(&video->video);
+}
diff --git a/drivers/media/video/omap4iss/iss_video.h b/drivers/media/video/omap4iss/iss_video.h
new file mode 100644
index 0000000..306ad34
--- /dev/null
+++ b/drivers/media/video/omap4iss/iss_video.h
@@ -0,0 +1,201 @@
+/*
+ * TI OMAP4 ISS V4L2 Driver - Generic video node
+ *
+ * Copyright (C) 2012 Texas Instruments, Inc.
+ *
+ * Author: Sergio Aguirre <saaguirre@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef OMAP4_ISS_VIDEO_H
+#define OMAP4_ISS_VIDEO_H
+
+#include <linux/v4l2-mediabus.h>
+#include <media/media-entity.h>
+#include <media/v4l2-dev.h>
+#include <media/v4l2-fh.h>
+#include <media/videobuf2-core.h>
+#include <media/videobuf2-dma-contig.h>
+
+#define ISS_VIDEO_DRIVER_NAME		"issvideo"
+#define ISS_VIDEO_DRIVER_VERSION	"0.0.2"
+
+struct iss_device;
+struct iss_video;
+struct v4l2_mbus_framefmt;
+struct v4l2_pix_format;
+
+/*
+ * struct iss_format_info - ISS media bus format information
+ * @code: V4L2 media bus format code
+ * @truncated: V4L2 media bus format code for the same format truncated to 10
+ *	bits. Identical to @code if the format is 10 bits wide or less.
+ * @uncompressed: V4L2 media bus format code for the corresponding uncompressed
+ *	format. Identical to @code if the format is not DPCM compressed.
+ * @flavor: V4L2 media bus format code for the same pixel layout but
+ *	shifted to be 8 bits per pixel. =0 if format is not shiftable.
+ * @pixelformat: V4L2 pixel format FCC identifier
+ * @bpp: Bits per pixel
+ */
+struct iss_format_info {
+	enum v4l2_mbus_pixelcode code;
+	enum v4l2_mbus_pixelcode truncated;
+	enum v4l2_mbus_pixelcode uncompressed;
+	enum v4l2_mbus_pixelcode flavor;
+	u32 pixelformat;
+	unsigned int bpp;
+};
+
+enum iss_pipeline_stream_state {
+	ISS_PIPELINE_STREAM_STOPPED = 0,
+	ISS_PIPELINE_STREAM_CONTINUOUS = 1,
+	ISS_PIPELINE_STREAM_SINGLESHOT = 2,
+};
+
+enum iss_pipeline_state {
+	/* The stream has been started on the input video node. */
+	ISS_PIPELINE_STREAM_INPUT = 1,
+	/* The stream has been started on the output video node. */
+	ISS_PIPELINE_STREAM_OUTPUT = (1 << 1),
+	/* At least one buffer is queued on the input video node. */
+	ISS_PIPELINE_QUEUE_INPUT = (1 << 2),
+	/* At least one buffer is queued on the output video node. */
+	ISS_PIPELINE_QUEUE_OUTPUT = (1 << 3),
+	/* The input entity is idle, ready to be started. */
+	ISS_PIPELINE_IDLE_INPUT = (1 << 4),
+	/* The output entity is idle, ready to be started. */
+	ISS_PIPELINE_IDLE_OUTPUT = (1 << 5),
+	/* The pipeline is currently streaming. */
+	ISS_PIPELINE_STREAM = (1 << 6),
+};
+
+/*
+ * struct iss_pipeline - An OMAP4 ISS hardware pipeline
+ * @error: A hardware error occurred during capture
+ */
+struct iss_pipeline {
+	struct media_pipeline pipe;
+	spinlock_t lock;		/* Pipeline state and queue flags */
+	unsigned int state;
+	enum iss_pipeline_stream_state stream_state;
+	struct iss_video *input;
+	struct iss_video *output;
+	atomic_t frame_number;
+	bool do_propagation; /* of frame number */
+	bool error;
+	struct v4l2_fract max_timeperframe;
+	struct v4l2_subdev *external;
+	unsigned int external_rate;
+	int external_bpp;
+};
+
+#define to_iss_pipeline(__e) \
+	container_of((__e)->pipe, struct iss_pipeline, pipe)
+
+static inline int iss_pipeline_ready(struct iss_pipeline *pipe)
+{
+	return pipe->state == (ISS_PIPELINE_STREAM_INPUT |
+			       ISS_PIPELINE_STREAM_OUTPUT |
+			       ISS_PIPELINE_QUEUE_INPUT |
+			       ISS_PIPELINE_QUEUE_OUTPUT |
+			       ISS_PIPELINE_IDLE_INPUT |
+			       ISS_PIPELINE_IDLE_OUTPUT);
+}
+
+/*
+ * struct iss_buffer - ISS buffer
+ * @buffer: ISS video buffer
+ * @iss_addr: Physical address of the buffer.
+ */
+struct iss_buffer {
+	/* common v4l buffer stuff -- must be first */
+	struct vb2_buffer	vb;
+	struct list_head	list;
+	dma_addr_t iss_addr;
+};
+
+#define to_iss_buffer(buf)	container_of(buf, struct iss_buffer, buffer)
+
+enum iss_video_dmaqueue_flags {
+	/* Set if DMA queue becomes empty when ISS_PIPELINE_STREAM_CONTINUOUS */
+	ISS_VIDEO_DMAQUEUE_UNDERRUN = (1 << 0),
+	/* Set when queuing buffer to an empty DMA queue */
+	ISS_VIDEO_DMAQUEUE_QUEUED = (1 << 1),
+};
+
+#define iss_video_dmaqueue_flags_clr(video)	\
+			({ (video)->dmaqueue_flags = 0; })
+
+/*
+ * struct iss_video_operations - ISS video operations
+ * @queue:	Resume streaming when a buffer is queued. Called on VIDIOC_QBUF
+ *		if there was no buffer previously queued.
+ */
+struct iss_video_operations {
+	int(*queue)(struct iss_video *video, struct iss_buffer *buffer);
+};
+
+struct iss_video {
+	struct video_device video;
+	enum v4l2_buf_type type;
+	struct media_pad pad;
+
+	struct mutex mutex;		/* format and crop settings */
+	atomic_t active;
+
+	struct iss_device *iss;
+
+	unsigned int capture_mem;
+	unsigned int bpl_alignment;	/* alignment value */
+	unsigned int bpl_zero_padding;	/* whether the alignment is optional */
+	unsigned int bpl_max;		/* maximum bytes per line value */
+	unsigned int bpl_value;		/* bytes per line value */
+	unsigned int bpl_padding;	/* padding at end of line */
+
+	/* Entity video node streaming */
+	unsigned int streaming:1;
+
+	/* Pipeline state */
+	struct iss_pipeline pipe;
+	struct mutex stream_lock;	/* pipeline and stream states */
+
+	/* Video buffers queue */
+	struct vb2_queue *queue;
+	spinlock_t qlock;	/* Spinlock for dmaqueue */
+	struct list_head dmaqueue;
+	enum iss_video_dmaqueue_flags dmaqueue_flags;
+	struct vb2_alloc_ctx *alloc_ctx;
+
+	const struct iss_video_operations *ops;
+};
+
+#define to_iss_video(vdev)	container_of(vdev, struct iss_video, video)
+
+struct iss_video_fh {
+	struct v4l2_fh vfh;
+	struct iss_video *video;
+	struct vb2_queue queue;
+	struct v4l2_format format;
+	struct v4l2_fract timeperframe;
+};
+
+#define to_iss_video_fh(fh)	container_of(fh, struct iss_video_fh, vfh)
+#define iss_video_queue_to_iss_video_fh(q) \
+				container_of(q, struct iss_video_fh, queue)
+
+int omap4iss_video_init(struct iss_video *video, const char *name);
+void omap4iss_video_cleanup(struct iss_video *video);
+int omap4iss_video_register(struct iss_video *video,
+			    struct v4l2_device *vdev);
+void omap4iss_video_unregister(struct iss_video *video);
+struct iss_buffer *omap4iss_video_buffer_next(struct iss_video *video);
+struct media_pad *omap4iss_video_remote_pad(struct iss_video *video);
+
+const struct iss_format_info *
+omap4iss_video_format_info(enum v4l2_mbus_pixelcode code);
+
+#endif /* OMAP4_ISS_VIDEO_H */
diff --git a/include/media/omap4iss.h b/include/media/omap4iss.h
new file mode 100644
index 0000000..0d7620d
--- /dev/null
+++ b/include/media/omap4iss.h
@@ -0,0 +1,65 @@
+#ifndef ARCH_ARM_PLAT_OMAP4_ISS_H
+#define ARCH_ARM_PLAT_OMAP4_ISS_H
+
+#include <linux/i2c.h>
+
+struct iss_device;
+
+enum iss_interface_type {
+	ISS_INTERFACE_CSI2A_PHY1,
+	ISS_INTERFACE_CSI2B_PHY2,
+};
+
+/**
+ * struct iss_csiphy_lane: CSI2 lane position and polarity
+ * @pos: position of the lane
+ * @pol: polarity of the lane
+ */
+struct iss_csiphy_lane {
+	u8 pos;
+	u8 pol;
+};
+
+#define ISS_CSIPHY1_NUM_DATA_LANES	4
+#define ISS_CSIPHY2_NUM_DATA_LANES	1
+
+/**
+ * struct iss_csiphy_lanes_cfg - CSI2 lane configuration
+ * @data: Configuration of one or two data lanes
+ * @clk: Clock lane configuration
+ */
+struct iss_csiphy_lanes_cfg {
+	struct iss_csiphy_lane data[ISS_CSIPHY1_NUM_DATA_LANES];
+	struct iss_csiphy_lane clk;
+};
+
+/**
+ * struct iss_csi2_platform_data - CSI2 interface platform data
+ * @crc: Enable the cyclic redundancy check
+ * @vpclk_div: Video port output clock control
+ */
+struct iss_csi2_platform_data {
+	unsigned crc:1;
+	unsigned vpclk_div:2;
+	struct iss_csiphy_lanes_cfg lanecfg;
+};
+
+struct iss_subdev_i2c_board_info {
+	struct i2c_board_info *board_info;
+	int i2c_adapter_id;
+};
+
+struct iss_v4l2_subdevs_group {
+	struct iss_subdev_i2c_board_info *subdevs;
+	enum iss_interface_type interface;
+	union {
+		struct iss_csi2_platform_data csi2;
+	} bus; /* gcc < 4.6.0 chokes on anonymous union initializers */
+};
+
+struct iss_platform_data {
+	struct iss_v4l2_subdevs_group *subdevs;
+	void (*set_constraints)(struct iss_device *iss, bool enable);
+};
+
+#endif
-- 
1.7.5.4

