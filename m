Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48327 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab3KDAGU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Nov 2013 19:06:20 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sergio Aguirre <sergio.a.aguirre@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v2 01/18] v4l: omap4iss: Add support for OMAP4 camera interface - Core
Date: Mon,  4 Nov 2013 01:06:26 +0100
Message-Id: <1383523603-3907-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1383523603-3907-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1383523603-3907-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sergio Aguirre <sergio.a.aguirre@gmail.com>

This adds a very simplistic driver to utilize the CSI2A interface inside
the ISS subsystem in OMAP4, and dump the data to memory.

Check Documentation/video4linux/omap4_camera.txt for details.

This commit adds the driver core, registers definitions and
documentation.

Signed-off-by: Sergio Aguirre <sergio.a.aguirre@gmail.com>

[Port the driver to v3.12-rc3, including the following changes
- Don't include plat/ headers
- Don't use cpu_is_omap44xx() macro
- Don't depend on EXPERIMENTAL
- Fix s_crop operation prototype
- Update link_notify prototype
- Rename media_entity_remote_source to media_entity_remote_pad]

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 Documentation/video4linux/omap4_camera.txt |   60 ++
 drivers/staging/media/omap4iss/iss.c       | 1477 ++++++++++++++++++++++++++++
 drivers/staging/media/omap4iss/iss.h       |  153 +++
 drivers/staging/media/omap4iss/iss_regs.h  |  883 +++++++++++++++++
 include/media/omap4iss.h                   |   65 ++
 5 files changed, 2638 insertions(+)
 create mode 100644 Documentation/video4linux/omap4_camera.txt
 create mode 100644 drivers/staging/media/omap4iss/iss.c
 create mode 100644 drivers/staging/media/omap4iss/iss.h
 create mode 100644 drivers/staging/media/omap4iss/iss_regs.h
 create mode 100644 include/media/omap4iss.h

diff --git a/Documentation/video4linux/omap4_camera.txt b/Documentation/video4linux/omap4_camera.txt
new file mode 100644
index 0000000..25d9b40
--- /dev/null
+++ b/Documentation/video4linux/omap4_camera.txt
@@ -0,0 +1,60 @@
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
+code from OMAP3 ISP driver (found under drivers/media/platform/omap3isp/*),
+except that it doesn't need an IOMMU now for ISS buffers memory mapping.
+
+Supports usage of MMAP buffers only (for now).
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
+drivers/staging/media/omap4iss/
+include/media/omap4iss.h
+
+References
+----------
+
+[1] http://focus.ti.com/general/docs/wtbu/wtbudocumentcenter.tsp?navigationId=12037&templateId=6123#62
+[2] http://lwn.net/Articles/420485/
+[3] http://www.spinics.net/lists/linux-media/msg44370.html
+--
+Author: Sergio Aguirre <sergio.a.aguirre@gmail.com>
+Copyright (C) 2012, Texas Instruments
diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
new file mode 100644
index 0000000..d054d9b
--- /dev/null
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -0,0 +1,1477 @@
+/*
+ * TI OMAP4 ISS V4L2 Driver
+ *
+ * Copyright (C) 2012, Texas Instruments
+ *
+ * Author: Sergio Aguirre <sergio.a.aguirre@gmail.com>
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
+#define ISS_PRINT_REGISTER(iss, name)\
+	dev_dbg(iss->dev, "###ISS " #name "=0x%08x\n", \
+		readl(iss->regs[OMAP4_ISS_MEM_TOP] + ISS_##name))
+
+static void iss_print_status(struct iss_device *iss)
+{
+	dev_dbg(iss->dev, "-------------ISS HL Register dump-------------\n");
+
+	ISS_PRINT_REGISTER(iss, HL_REVISION);
+	ISS_PRINT_REGISTER(iss, HL_SYSCONFIG);
+	ISS_PRINT_REGISTER(iss, HL_IRQSTATUS_5);
+	ISS_PRINT_REGISTER(iss, HL_IRQENABLE_5_SET);
+	ISS_PRINT_REGISTER(iss, HL_IRQENABLE_5_CLR);
+	ISS_PRINT_REGISTER(iss, CTRL);
+	ISS_PRINT_REGISTER(iss, CLKCTRL);
+	ISS_PRINT_REGISTER(iss, CLKSTAT);
+
+	dev_dbg(iss->dev, "-----------------------------------------------\n");
+}
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
+	static const u32 hl_irq = ISS_HL_IRQ_CSIA | ISS_HL_IRQ_CSIB | ISS_HL_IRQ_ISP(0);
+
+	/* Enable HL interrupts */
+	writel(hl_irq, iss->regs[OMAP4_ISS_MEM_TOP] + ISS_HL_IRQSTATUS_5);
+	writel(hl_irq, iss->regs[OMAP4_ISS_MEM_TOP] + ISS_HL_IRQENABLE_5_SET);
+
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
+/*
+ * iss_isp_enable_interrupts - Enable ISS ISP interrupts.
+ * @iss: OMAP4 ISS device
+ */
+void omap4iss_isp_enable_interrupts(struct iss_device *iss)
+{
+	static const u32 isp_irq = ISP5_IRQ_OCP_ERR |
+				   ISP5_IRQ_RSZ_FIFO_IN_BLK |
+				   ISP5_IRQ_RSZ_FIFO_OVF |
+				   ISP5_IRQ_RSZ_INT_DMA |
+				   ISP5_IRQ_ISIF0;
+
+	/* Enable ISP interrupts */
+	writel(isp_irq, iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_IRQSTATUS(0));
+	writel(isp_irq, iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_IRQENABLE_SET(0));
+}
+
+/*
+ * iss_isp_disable_interrupts - Disable ISS interrupts.
+ * @iss: OMAP4 ISS device
+ */
+void omap4iss_isp_disable_interrupts(struct iss_device *iss)
+{
+	writel(-1, iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_IRQENABLE_CLR(0));
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
+/*
+ * Configure the bridge. Valid inputs are
+ *
+ * IPIPEIF_INPUT_CSI2A: CSI2a receiver
+ * IPIPEIF_INPUT_CSI2B: CSI2b receiver
+ *
+ * The bridge and lane shifter are configured according to the selected input
+ * and the ISP platform data.
+ */
+void omap4iss_configure_bridge(struct iss_device *iss,
+			       enum ipipeif_input_entity input)
+{
+	u32 issctrl_val;
+	u32 isp5ctrl_val;
+
+	issctrl_val  = readl(iss->regs[OMAP4_ISS_MEM_TOP] + ISS_CTRL);
+	issctrl_val &= ~ISS_CTRL_INPUT_SEL_MASK;
+	issctrl_val &= ~ISS_CTRL_CLK_DIV_MASK;
+
+	isp5ctrl_val  = readl(iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_CTRL);
+
+	switch (input) {
+	case IPIPEIF_INPUT_CSI2A:
+		issctrl_val |= ISS_CTRL_INPUT_SEL_CSI2A;
+		isp5ctrl_val |= ISP5_CTRL_VD_PULSE_EXT;
+		break;
+
+	case IPIPEIF_INPUT_CSI2B:
+		issctrl_val |= ISS_CTRL_INPUT_SEL_CSI2B;
+		isp5ctrl_val |= ISP5_CTRL_VD_PULSE_EXT;
+		break;
+
+	default:
+		return;
+	}
+
+	issctrl_val |= ISS_CTRL_SYNC_DETECT_VS_RAISING;
+
+	isp5ctrl_val |= ISP5_CTRL_PSYNC_CLK_SEL | ISP5_CTRL_SYNC_ENABLE;
+
+	writel(issctrl_val, iss->regs[OMAP4_ISS_MEM_TOP] + ISS_CTRL);
+	writel(isp5ctrl_val, iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_CTRL);
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
+	static const u32 ipipeif_events = ISP5_IRQ_IPIPEIF |
+					  ISP5_IRQ_ISIF0;
+	static const u32 resizer_events = ISP5_IRQ_RSZ_FIFO_IN_BLK |
+					  ISP5_IRQ_RSZ_FIFO_OVF |
+					  ISP5_IRQ_RSZ_INT_DMA;
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
+	if (irqstatus & ISS_HL_IRQ_ISP(0)) {
+		u32 isp_irqstatus = readl(iss->regs[OMAP4_ISS_MEM_ISP_SYS1] +
+					  ISP5_IRQSTATUS(0));
+		writel(isp_irqstatus, iss->regs[OMAP4_ISS_MEM_ISP_SYS1] +
+			ISP5_IRQSTATUS(0));
+
+		if (isp_irqstatus & ISP5_IRQ_OCP_ERR)
+			dev_dbg(iss->dev, "ISP5 OCP Error!\n");
+
+		if (isp_irqstatus & ipipeif_events) {
+			omap4iss_ipipeif_isr(&iss->ipipeif,
+					     isp_irqstatus & ipipeif_events);
+		}
+
+		if (isp_irqstatus & resizer_events)
+			omap4iss_resizer_isr(&iss->resizer,
+					     isp_irqstatus & resizer_events);
+	}
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
+ * @link: The link
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
+static int iss_pipeline_link_notify(struct media_link *link, u32 flags,
+				    unsigned int notification)
+{
+	struct media_entity *source = link->source->entity;
+	struct media_entity *sink = link->sink->entity;
+	int source_use = iss_pipeline_pm_use_count(source);
+	int sink_use = iss_pipeline_pm_use_count(sink);
+	int ret;
+
+	if (notification == MEDIA_DEV_NOTIFY_POST_LINK_CH &&
+	    !(link->flags & MEDIA_LNK_FL_ENABLED)) {
+		/* Powering off entities is assumed to never fail. */
+		iss_pipeline_pm_power(source, -sink_use);
+		iss_pipeline_pm_power(sink, -source_use);
+		return 0;
+	}
+
+	if (notification == MEDIA_DEV_NOTIFY_POST_LINK_CH &&
+		(flags & MEDIA_LNK_FL_ENABLED)) {
+		ret = iss_pipeline_pm_power(source, sink_use);
+		if (ret < 0)
+			return ret;
+
+		ret = iss_pipeline_pm_power(sink, source_use);
+		if (ret < 0)
+			iss_pipeline_pm_power(source, -sink_use);
+
+		return ret;
+	}
+
+	return 0;
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
+		pad = media_entity_remote_pad(pad);
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
+	iss_print_status(pipe->output->iss);
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
+		pad = media_entity_remote_pad(pad);
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
+	pad = media_entity_remote_pad(&pipe->output->pad);
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
+static int iss_isp_reset(struct iss_device *iss)
+{
+	unsigned long timeout = 0;
+
+	/* Fist, ensure that the ISP is IDLE (no transactions happening) */
+	writel((readl(iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_SYSCONFIG) &
+		~ISP5_SYSCONFIG_STANDBYMODE_MASK) |
+		ISP5_SYSCONFIG_STANDBYMODE_SMART,
+		iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_SYSCONFIG);
+
+	writel(readl(iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_CTRL) |
+		ISP5_CTRL_MSTANDBY,
+		iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_CTRL);
+
+	for (;;) {
+		if (readl(iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_CTRL) &
+				ISP5_CTRL_MSTANDBY_WAIT)
+			break;
+		if (timeout++ > 1000) {
+			dev_alert(iss->dev, "cannot set ISP5 to standby\n");
+			return -ETIMEDOUT;
+		}
+		msleep(1);
+	}
+
+	/* Now finally, do the reset */
+	writel(readl(iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_SYSCONFIG) |
+		ISP5_SYSCONFIG_SOFTRESET,
+		iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_SYSCONFIG);
+
+	timeout = 0;
+	while (readl(iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_SYSCONFIG) &
+			ISP5_SYSCONFIG_SOFTRESET) {
+		if (timeout++ > 1000) {
+			dev_alert(iss->dev, "cannot reset ISP5\n");
+			return -ETIMEDOUT;
+		}
+		msleep(1);
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
+#define ISS_CLKCTRL_MASK	(ISS_CLKCTRL_CSI2_A |\
+				 ISS_CLKCTRL_CSI2_B |\
+				 ISS_CLKCTRL_ISP)
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
+	if (iss->subclk_resources & OMAP4_ISS_SUBCLK_ISP)
+		clk |= ISS_CLKCTRL_ISP;
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
+#define ISS_ISP5_CLKCTRL_MASK	(ISP5_CTRL_BL_CLK_ENABLE |\
+				 ISP5_CTRL_ISIF_CLK_ENABLE |\
+				 ISP5_CTRL_H3A_CLK_ENABLE |\
+				 ISP5_CTRL_RSZ_CLK_ENABLE |\
+				 ISP5_CTRL_IPIPE_CLK_ENABLE |\
+				 ISP5_CTRL_IPIPEIF_CLK_ENABLE)
+
+static int __iss_isp_subclk_update(struct iss_device *iss)
+{
+	u32 clk = 0;
+
+	if (iss->isp_subclk_resources & OMAP4_ISS_ISP_SUBCLK_ISIF)
+		clk |= ISP5_CTRL_ISIF_CLK_ENABLE;
+
+	if (iss->isp_subclk_resources & OMAP4_ISS_ISP_SUBCLK_H3A)
+		clk |= ISP5_CTRL_H3A_CLK_ENABLE;
+
+	if (iss->isp_subclk_resources & OMAP4_ISS_ISP_SUBCLK_RSZ)
+		clk |= ISP5_CTRL_RSZ_CLK_ENABLE;
+
+	if (iss->isp_subclk_resources & OMAP4_ISS_ISP_SUBCLK_IPIPE)
+		clk |= ISP5_CTRL_IPIPE_CLK_ENABLE;
+
+	if (iss->isp_subclk_resources & OMAP4_ISS_ISP_SUBCLK_IPIPEIF)
+		clk |= ISP5_CTRL_IPIPEIF_CLK_ENABLE;
+
+	if (clk)
+		clk |= ISP5_CTRL_BL_CLK_ENABLE;
+
+	writel((readl(iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_CTRL) &
+		~ISS_ISP5_CLKCTRL_MASK) | clk,
+		iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_CTRL);
+
+	return 0;
+}
+
+int omap4iss_isp_subclk_enable(struct iss_device *iss,
+				enum iss_isp_subclk_resource res)
+{
+	iss->isp_subclk_resources |= res;
+
+	return __iss_isp_subclk_update(iss);
+}
+
+int omap4iss_isp_subclk_disable(struct iss_device *iss,
+				enum iss_isp_subclk_resource res)
+{
+	iss->isp_subclk_resources &= ~res;
+
+	return __iss_isp_subclk_update(iss);
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
+	omap4iss_resizer_unregister_entities(&iss->resizer);
+	omap4iss_ipipe_unregister_entities(&iss->ipipe);
+	omap4iss_ipipeif_unregister_entities(&iss->ipipeif);
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
+	ret = omap4iss_ipipeif_register_entities(&iss->ipipeif, &iss->v4l2_dev);
+	if (ret < 0)
+		goto done;
+
+	ret = omap4iss_ipipe_register_entities(&iss->ipipe, &iss->v4l2_dev);
+	if (ret < 0)
+		goto done;
+
+	ret = omap4iss_resizer_register_entities(&iss->resizer, &iss->v4l2_dev);
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
+	omap4iss_ipipeif_cleanup(iss);
+	omap4iss_ipipe_cleanup(iss);
+	omap4iss_resizer_cleanup(iss);
+}
+
+static int iss_initialize_modules(struct iss_device *iss)
+{
+	int ret;
+
+	ret = omap4iss_csiphy_init(iss);
+	if (ret < 0) {
+		dev_err(iss->dev, "CSI PHY initialization failed\n");
+		goto error_csiphy;
+	}
+
+	ret = omap4iss_csi2_init(iss);
+	if (ret < 0) {
+		dev_err(iss->dev, "CSI2 initialization failed\n");
+		goto error_csi2;
+	}
+
+	ret = omap4iss_ipipeif_init(iss);
+	if (ret < 0) {
+		dev_err(iss->dev, "ISP IPIPEIF initialization failed\n");
+		goto error_ipipeif;
+	}
+
+	ret = omap4iss_ipipe_init(iss);
+	if (ret < 0) {
+		dev_err(iss->dev, "ISP IPIPE initialization failed\n");
+		goto error_ipipe;
+	}
+
+	ret = omap4iss_resizer_init(iss);
+	if (ret < 0) {
+		dev_err(iss->dev, "ISP RESIZER initialization failed\n");
+		goto error_resizer;
+	}
+
+	/* Connect the submodules. */
+	ret = media_entity_create_link(
+			&iss->csi2a.subdev.entity, CSI2_PAD_SOURCE,
+			&iss->ipipeif.subdev.entity, IPIPEIF_PAD_SINK, 0);
+	if (ret < 0)
+		goto error_link;
+
+	ret = media_entity_create_link(
+			&iss->csi2b.subdev.entity, CSI2_PAD_SOURCE,
+			&iss->ipipeif.subdev.entity, IPIPEIF_PAD_SINK, 0);
+	if (ret < 0)
+		goto error_link;
+
+	ret = media_entity_create_link(
+			&iss->ipipeif.subdev.entity, IPIPEIF_PAD_SOURCE_VP,
+			&iss->resizer.subdev.entity, RESIZER_PAD_SINK, 0);
+	if (ret < 0)
+		goto error_link;
+
+	ret = media_entity_create_link(
+			&iss->ipipeif.subdev.entity, IPIPEIF_PAD_SOURCE_VP,
+			&iss->ipipe.subdev.entity, IPIPE_PAD_SINK, 0);
+	if (ret < 0)
+		goto error_link;
+
+	ret = media_entity_create_link(
+			&iss->ipipe.subdev.entity, IPIPE_PAD_SOURCE_VP,
+			&iss->resizer.subdev.entity, RESIZER_PAD_SINK, 0);
+	if (ret < 0)
+		goto error_link;
+
+	return 0;
+
+error_link:
+	omap4iss_resizer_cleanup(iss);
+error_resizer:
+	omap4iss_ipipe_cleanup(iss);
+error_ipipe:
+	omap4iss_ipipeif_cleanup(iss);
+error_ipipeif:
+	omap4iss_csi2_cleanup(iss);
+error_csi2:
+error_csiphy:
+	return ret;
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
+	/* Configure BTE BW_LIMITER field to max recommended value (1 GB) */
+	writel((readl(iss->regs[OMAP4_ISS_MEM_BTE] + BTE_CTRL) & ~BTE_CTRL_BW_LIMITER_MASK) |
+		(18 << BTE_CTRL_BW_LIMITER_SHIFT),
+		iss->regs[OMAP4_ISS_MEM_BTE] + BTE_CTRL);
+
+	/* Perform ISP reset */
+	ret = omap4iss_subclk_enable(iss, OMAP4_ISS_SUBCLK_ISP);
+	if (ret < 0)
+		goto error_iss;
+
+	ret = iss_isp_reset(iss);
+	if (ret < 0)
+		goto error_iss;
+
+	dev_info(iss->dev, "ISP Revision %08x found\n",
+		 readl(iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_REVISION));
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
+MODULE_AUTHOR("Sergio Aguirre <sergio.a.aguirre@gmail.com>");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(ISS_VIDEO_DRIVER_VERSION);
diff --git a/drivers/staging/media/omap4iss/iss.h b/drivers/staging/media/omap4iss/iss.h
new file mode 100644
index 0000000..cc24f1a
--- /dev/null
+++ b/drivers/staging/media/omap4iss/iss.h
@@ -0,0 +1,153 @@
+/*
+ * TI OMAP4 ISS V4L2 Driver
+ *
+ * Copyright (C) 2012 Texas Instruments.
+ *
+ * Author: Sergio Aguirre <sergio.a.aguirre@gmail.com>
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
+#include "iss_ipipeif.h"
+#include "iss_ipipe.h"
+#include "iss_resizer.h"
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
+	OMAP4_ISS_MEM_BTE,
+	OMAP4_ISS_MEM_ISP_SYS1,
+	OMAP4_ISS_MEM_ISP_RESIZER,
+	OMAP4_ISS_MEM_ISP_IPIPE,
+	OMAP4_ISS_MEM_ISP_ISIF,
+	OMAP4_ISS_MEM_ISP_IPIPEIF,
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
+enum iss_isp_subclk_resource {
+	OMAP4_ISS_ISP_SUBCLK_BL		= (1 << 0),
+	OMAP4_ISS_ISP_SUBCLK_ISIF	= (1 << 1),
+	OMAP4_ISS_ISP_SUBCLK_H3A	= (1 << 2),
+	OMAP4_ISS_ISP_SUBCLK_RSZ	= (1 << 3),
+	OMAP4_ISS_ISP_SUBCLK_IPIPE	= (1 << 4),
+	OMAP4_ISS_ISP_SUBCLK_IPIPEIF	= (1 << 5),
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
+	struct iss_ipipeif_device ipipeif;
+	struct iss_ipipe_device ipipe;
+	struct iss_resizer_device resizer;
+
+	unsigned int subclk_resources;
+	unsigned int isp_subclk_resources;
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
+void omap4iss_configure_bridge(struct iss_device *iss,
+			       enum ipipeif_input_entity input);
+
+struct iss_device *omap4iss_get(struct iss_device *iss);
+void omap4iss_put(struct iss_device *iss);
+int omap4iss_subclk_enable(struct iss_device *iss,
+			   enum iss_subclk_resource res);
+int omap4iss_subclk_disable(struct iss_device *iss,
+			    enum iss_subclk_resource res);
+int omap4iss_isp_subclk_enable(struct iss_device *iss,
+				enum iss_isp_subclk_resource res);
+int omap4iss_isp_subclk_disable(struct iss_device *iss,
+				enum iss_isp_subclk_resource res);
+
+void omap4iss_isp_enable_interrupts(struct iss_device *iss);
+void omap4iss_isp_disable_interrupts(struct iss_device *iss);
+
+int omap4iss_pipeline_pm_use(struct media_entity *entity, int use);
+
+int omap4iss_register_entities(struct platform_device *pdev,
+			       struct v4l2_device *v4l2_dev);
+void omap4iss_unregister_entities(struct platform_device *pdev);
+
+#endif /* _OMAP4_ISS_H_ */
diff --git a/drivers/staging/media/omap4iss/iss_regs.h b/drivers/staging/media/omap4iss/iss_regs.h
new file mode 100644
index 0000000..7327d0c
--- /dev/null
+++ b/drivers/staging/media/omap4iss/iss_regs.h
@@ -0,0 +1,883 @@
+/*
+ * TI OMAP4 ISS V4L2 Driver - Register defines
+ *
+ * Copyright (C) 2012 Texas Instruments.
+ *
+ * Author: Sergio Aguirre <sergio.a.aguirre@gmail.com>
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
+#define ISS_HL_IRQ_ISP(i)				(1 << (i))
+
+#define ISS_CTRL					0x80
+#define ISS_CTRL_CLK_DIV_MASK				(3 << 4)
+#define ISS_CTRL_INPUT_SEL_MASK				(3 << 2)
+#define ISS_CTRL_INPUT_SEL_CSI2A			(0 << 2)
+#define ISS_CTRL_INPUT_SEL_CSI2B			(1 << 2)
+#define ISS_CTRL_SYNC_DETECT_VS_RAISING			(3 << 0)
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
+/* ISS BTE */
+#define BTE_CTRL					(0x0030)
+#define BTE_CTRL_BW_LIMITER_MASK			(0x3FF << 22)
+#define BTE_CTRL_BW_LIMITER_SHIFT			22
+
+/* ISS ISP_SYS1 */
+#define ISP5_REVISION					(0x0000)
+#define ISP5_SYSCONFIG					(0x0010)
+#define ISP5_SYSCONFIG_STANDBYMODE_MASK			(3 << 4)
+#define ISP5_SYSCONFIG_STANDBYMODE_FORCE		(0 << 4)
+#define ISP5_SYSCONFIG_STANDBYMODE_NO			(1 << 4)
+#define ISP5_SYSCONFIG_STANDBYMODE_SMART		(2 << 4)
+#define ISP5_SYSCONFIG_SOFTRESET			(1 << 1)
+
+#define ISP5_IRQSTATUS(i)				(0x0028 + (0x10 * (i)))
+#define ISP5_IRQENABLE_SET(i)				(0x002C + (0x10 * (i)))
+#define ISP5_IRQENABLE_CLR(i)				(0x0030 + (0x10 * (i)))
+
+/* Bits shared for ISP5_IRQ* registers */
+#define ISP5_IRQ_OCP_ERR				(1 << 31)
+#define ISP5_IRQ_RSZ_INT_EOF0				(1 << 22)
+#define ISP5_IRQ_RSZ_FIFO_IN_BLK			(1 << 19)
+#define ISP5_IRQ_RSZ_FIFO_OVF				(1 << 18)
+#define ISP5_IRQ_RSZ_INT_CYC_RSZA			(1 << 16)
+#define ISP5_IRQ_RSZ_INT_DMA				(1 << 15)
+#define ISP5_IRQ_IPIPEIF				(1 << 9)
+#define ISP5_IRQ_ISIF3					(1 << 3)
+#define ISP5_IRQ_ISIF2					(1 << 2)
+#define ISP5_IRQ_ISIF1					(1 << 1)
+#define ISP5_IRQ_ISIF0					(1 << 0)
+
+#define ISP5_CTRL					(0x006C)
+#define ISP5_CTRL_MSTANDBY				(1 << 24)
+#define ISP5_CTRL_VD_PULSE_EXT				(1 << 23)
+#define ISP5_CTRL_MSTANDBY_WAIT				(1 << 20)
+#define ISP5_CTRL_BL_CLK_ENABLE				(1 << 15)
+#define ISP5_CTRL_ISIF_CLK_ENABLE			(1 << 14)
+#define ISP5_CTRL_H3A_CLK_ENABLE			(1 << 13)
+#define ISP5_CTRL_RSZ_CLK_ENABLE			(1 << 12)
+#define ISP5_CTRL_IPIPE_CLK_ENABLE			(1 << 11)
+#define ISP5_CTRL_IPIPEIF_CLK_ENABLE			(1 << 10)
+#define ISP5_CTRL_SYNC_ENABLE				(1 << 9)
+#define ISP5_CTRL_PSYNC_CLK_SEL				(1 << 8)
+
+/* ISS ISP ISIF register offsets */
+#define ISIF_SYNCEN					(0x0000)
+#define ISIF_SYNCEN_DWEN				(1 << 1)
+#define ISIF_SYNCEN_SYEN				(1 << 0)
+
+#define ISIF_MODESET					(0x0004)
+#define ISIF_MODESET_INPMOD_MASK			(3 << 12)
+#define ISIF_MODESET_INPMOD_RAW				(0 << 12)
+#define ISIF_MODESET_INPMOD_YCBCR16			(1 << 12)
+#define ISIF_MODESET_INPMOD_YCBCR8			(2 << 12)
+#define ISIF_MODESET_CCDW_MASK				(7 << 8)
+#define ISIF_MODESET_CCDW_2BIT				(2 << 8)
+#define ISIF_MODESET_CCDMD				(1 << 7)
+#define ISIF_MODESET_SWEN				(1 << 5)
+#define ISIF_MODESET_HDPOL				(1 << 3)
+#define ISIF_MODESET_VDPOL				(1 << 2)
+
+#define ISIF_SPH					(0x0018)
+#define ISIF_SPH_MASK					(0x7FFF)
+
+#define ISIF_LNH					(0x001C)
+#define ISIF_LNH_MASK					(0x7FFF)
+
+#define ISIF_LNV					(0x0028)
+#define ISIF_LNV_MASK					(0x7FFF)
+
+#define ISIF_HSIZE					(0x0034)
+#define ISIF_HSIZE_ADCR					(1 << 12)
+#define ISIF_HSIZE_HSIZE_MASK				(0xFFF)
+
+#define ISIF_CADU					(0x003C)
+#define ISIF_CADU_MASK					(0x7FF)
+
+#define ISIF_CADL					(0x0040)
+#define ISIF_CADL_MASK					(0xFFFF)
+
+#define ISIF_CCOLP					(0x004C)
+#define ISIF_CCOLP_CP0_F0_R				(0 << 6)
+#define ISIF_CCOLP_CP0_F0_GR				(1 << 6)
+#define ISIF_CCOLP_CP0_F0_B				(3 << 6)
+#define ISIF_CCOLP_CP0_F0_GB				(2 << 6)
+#define ISIF_CCOLP_CP1_F0_R				(0 << 4)
+#define ISIF_CCOLP_CP1_F0_GR				(1 << 4)
+#define ISIF_CCOLP_CP1_F0_B				(3 << 4)
+#define ISIF_CCOLP_CP1_F0_GB				(2 << 4)
+#define ISIF_CCOLP_CP2_F0_R				(0 << 2)
+#define ISIF_CCOLP_CP2_F0_GR				(1 << 2)
+#define ISIF_CCOLP_CP2_F0_B				(3 << 2)
+#define ISIF_CCOLP_CP2_F0_GB				(2 << 2)
+#define ISIF_CCOLP_CP3_F0_R				(0 << 0)
+#define ISIF_CCOLP_CP3_F0_GR				(1 << 0)
+#define ISIF_CCOLP_CP3_F0_B				(3 << 0)
+#define ISIF_CCOLP_CP3_F0_GB				(2 << 0)
+
+#define ISIF_VDINT0					(0x0070)
+#define ISIF_VDINT0_MASK				(0x7FFF)
+
+#define ISIF_CGAMMAWD					(0x0080)
+#define ISIF_CGAMMAWD_GWDI_MASK				(0xF << 1)
+#define ISIF_CGAMMAWD_GWDI_BIT11			(0x4 << 1)
+
+#define ISIF_CCDCFG					(0x0088)
+#define ISIF_CCDCFG_Y8POS				(1 << 11)
+
+/* ISS ISP IPIPEIF register offsets */
+#define IPIPEIF_ENABLE					(0x0000)
+
+#define IPIPEIF_CFG1					(0x0004)
+#define IPIPEIF_CFG1_INPSRC1_MASK			(3 << 14)
+#define IPIPEIF_CFG1_INPSRC1_VPORT_RAW			(0 << 14)
+#define IPIPEIF_CFG1_INPSRC1_SDRAM_RAW			(1 << 14)
+#define IPIPEIF_CFG1_INPSRC1_ISIF_DARKFM		(2 << 14)
+#define IPIPEIF_CFG1_INPSRC1_SDRAM_YUV			(3 << 14)
+#define IPIPEIF_CFG1_INPSRC2_MASK			(3 << 2)
+#define IPIPEIF_CFG1_INPSRC2_ISIF			(0 << 2)
+#define IPIPEIF_CFG1_INPSRC2_SDRAM_RAW			(1 << 2)
+#define IPIPEIF_CFG1_INPSRC2_ISIF_DARKFM		(2 << 2)
+#define IPIPEIF_CFG1_INPSRC2_SDRAM_YUV			(3 << 2)
+
+#define IPIPEIF_CFG2					(0x0030)
+#define IPIPEIF_CFG2_YUV8P				(1 << 7)
+#define IPIPEIF_CFG2_YUV8				(1 << 6)
+#define IPIPEIF_CFG2_YUV16				(1 << 3)
+#define IPIPEIF_CFG2_VDPOL				(1 << 2)
+#define IPIPEIF_CFG2_HDPOL				(1 << 1)
+#define IPIPEIF_CFG2_INTSW				(1 << 0)
+
+#define IPIPEIF_CLKDIV					(0x0040)
+
+/* ISS ISP IPIPE register offsets */
+#define IPIPE_SRC_EN					(0x0000)
+#define IPIPE_SRC_EN_EN					(1 << 0)
+
+#define IPIPE_SRC_MODE					(0x0004)
+#define IPIPE_SRC_MODE_WRT				(1 << 1)
+#define IPIPE_SRC_MODE_OST				(1 << 0)
+
+#define IPIPE_SRC_FMT					(0x0008)
+#define IPIPE_SRC_FMT_RAW2YUV				(0 << 0)
+#define IPIPE_SRC_FMT_RAW2RAW				(1 << 0)
+#define IPIPE_SRC_FMT_RAW2STATS				(2 << 0)
+#define IPIPE_SRC_FMT_YUV2YUV				(3 << 0)
+
+#define IPIPE_SRC_COL					(0x000C)
+#define IPIPE_SRC_COL_OO_R				(0 << 6)
+#define IPIPE_SRC_COL_OO_GR				(1 << 6)
+#define IPIPE_SRC_COL_OO_B				(3 << 6)
+#define IPIPE_SRC_COL_OO_GB				(2 << 6)
+#define IPIPE_SRC_COL_OE_R				(0 << 4)
+#define IPIPE_SRC_COL_OE_GR				(1 << 4)
+#define IPIPE_SRC_COL_OE_B				(3 << 4)
+#define IPIPE_SRC_COL_OE_GB				(2 << 4)
+#define IPIPE_SRC_COL_EO_R				(0 << 2)
+#define IPIPE_SRC_COL_EO_GR				(1 << 2)
+#define IPIPE_SRC_COL_EO_B				(3 << 2)
+#define IPIPE_SRC_COL_EO_GB				(2 << 2)
+#define IPIPE_SRC_COL_EE_R				(0 << 0)
+#define IPIPE_SRC_COL_EE_GR				(1 << 0)
+#define IPIPE_SRC_COL_EE_B				(3 << 0)
+#define IPIPE_SRC_COL_EE_GB				(2 << 0)
+
+#define IPIPE_SRC_VPS					(0x0010)
+#define IPIPE_SRC_VPS_MASK				(0xFFFF)
+
+#define IPIPE_SRC_VSZ					(0x0014)
+#define IPIPE_SRC_VSZ_MASK				(0x1FFF)
+
+#define IPIPE_SRC_HPS					(0x0018)
+#define IPIPE_SRC_HPS_MASK				(0xFFFF)
+
+#define IPIPE_SRC_HSZ					(0x001C)
+#define IPIPE_SRC_HSZ_MASK				(0x1FFE)
+
+#define IPIPE_SEL_SBU					(0x0020)
+
+#define IPIPE_SRC_STA					(0x0024)
+
+#define IPIPE_GCK_MMR					(0x0028)
+#define IPIPE_GCK_MMR_REG				(1 << 0)
+
+#define IPIPE_GCK_PIX					(0x002C)
+#define IPIPE_GCK_PIX_G3				(1 << 3)
+#define IPIPE_GCK_PIX_G2				(1 << 2)
+#define IPIPE_GCK_PIX_G1				(1 << 1)
+#define IPIPE_GCK_PIX_G0				(1 << 0)
+
+#define IPIPE_DPC_LUT_EN				(0x0034)
+#define IPIPE_DPC_LUT_SEL				(0x0038)
+#define IPIPE_DPC_LUT_ADR				(0x003C)
+#define IPIPE_DPC_LUT_SIZ				(0x0040)
+
+#define IPIPE_DPC_OTF_EN				(0x0044)
+#define IPIPE_DPC_OTF_TYP				(0x0048)
+#define IPIPE_DPC_OTF_2_D_THR_R				(0x004C)
+#define IPIPE_DPC_OTF_2_D_THR_GR			(0x0050)
+#define IPIPE_DPC_OTF_2_D_THR_GB			(0x0054)
+#define IPIPE_DPC_OTF_2_D_THR_B				(0x0058)
+#define IPIPE_DPC_OTF_2_C_THR_R				(0x005C)
+#define IPIPE_DPC_OTF_2_C_THR_GR			(0x0060)
+#define IPIPE_DPC_OTF_2_C_THR_GB			(0x0064)
+#define IPIPE_DPC_OTF_2_C_THR_B				(0x0068)
+#define IPIPE_DPC_OTF_3_SHF				(0x006C)
+#define IPIPE_DPC_OTF_3_D_THR				(0x0070)
+#define IPIPE_DPC_OTF_3_D_SPL				(0x0074)
+#define IPIPE_DPC_OTF_3_D_MIN				(0x0078)
+#define IPIPE_DPC_OTF_3_D_MAX				(0x007C)
+#define IPIPE_DPC_OTF_3_C_THR				(0x0080)
+#define IPIPE_DPC_OTF_3_C_SLP				(0x0084)
+#define IPIPE_DPC_OTF_3_C_MIN				(0x0088)
+#define IPIPE_DPC_OTF_3_C_MAX				(0x008C)
+
+#define IPIPE_LSC_VOFT					(0x0090)
+#define IPIPE_LSC_VA2					(0x0094)
+#define IPIPE_LSC_VA1					(0x0098)
+#define IPIPE_LSC_VS					(0x009C)
+#define IPIPE_LSC_HOFT					(0x00A0)
+#define IPIPE_LSC_HA2					(0x00A4)
+#define IPIPE_LSC_HA1					(0x00A8)
+#define IPIPE_LSC_HS					(0x00AC)
+#define IPIPE_LSC_GAN_R					(0x00B0)
+#define IPIPE_LSC_GAN_GR				(0x00B4)
+#define IPIPE_LSC_GAN_GB				(0x00B8)
+#define IPIPE_LSC_GAN_B					(0x00BC)
+#define IPIPE_LSC_OFT_R					(0x00C0)
+#define IPIPE_LSC_OFT_GR				(0x00C4)
+#define IPIPE_LSC_OFT_GB				(0x00C8)
+#define IPIPE_LSC_OFT_B					(0x00CC)
+#define IPIPE_LSC_SHF					(0x00D0)
+#define IPIPE_LSC_MAX					(0x00D4)
+
+#define IPIPE_D2F_1ST_EN				(0x00D8)
+#define IPIPE_D2F_1ST_TYP				(0x00DC)
+#define IPIPE_D2F_1ST_THR_00				(0x00E0)
+#define IPIPE_D2F_1ST_THR_01				(0x00E4)
+#define IPIPE_D2F_1ST_THR_02				(0x00E8)
+#define IPIPE_D2F_1ST_THR_03				(0x00EC)
+#define IPIPE_D2F_1ST_THR_04				(0x00F0)
+#define IPIPE_D2F_1ST_THR_05				(0x00F4)
+#define IPIPE_D2F_1ST_THR_06				(0x00F8)
+#define IPIPE_D2F_1ST_THR_07				(0x00FC)
+#define IPIPE_D2F_1ST_STR_00				(0x0100)
+#define IPIPE_D2F_1ST_STR_01				(0x0104)
+#define IPIPE_D2F_1ST_STR_02				(0x0108)
+#define IPIPE_D2F_1ST_STR_03				(0x010C)
+#define IPIPE_D2F_1ST_STR_04				(0x0110)
+#define IPIPE_D2F_1ST_STR_05				(0x0114)
+#define IPIPE_D2F_1ST_STR_06				(0x0118)
+#define IPIPE_D2F_1ST_STR_07				(0x011C)
+#define IPIPE_D2F_1ST_SPR_00				(0x0120)
+#define IPIPE_D2F_1ST_SPR_01				(0x0124)
+#define IPIPE_D2F_1ST_SPR_02				(0x0128)
+#define IPIPE_D2F_1ST_SPR_03				(0x012C)
+#define IPIPE_D2F_1ST_SPR_04				(0x0130)
+#define IPIPE_D2F_1ST_SPR_05				(0x0134)
+#define IPIPE_D2F_1ST_SPR_06				(0x0138)
+#define IPIPE_D2F_1ST_SPR_07				(0x013C)
+#define IPIPE_D2F_1ST_EDG_MIN				(0x0140)
+#define IPIPE_D2F_1ST_EDG_MAX				(0x0144)
+#define IPIPE_D2F_2ND_EN				(0x0148)
+#define IPIPE_D2F_2ND_TYP				(0x014C)
+#define IPIPE_D2F_2ND_THR00				(0x0150)
+#define IPIPE_D2F_2ND_THR01				(0x0154)
+#define IPIPE_D2F_2ND_THR02				(0x0158)
+#define IPIPE_D2F_2ND_THR03				(0x015C)
+#define IPIPE_D2F_2ND_THR04				(0x0160)
+#define IPIPE_D2F_2ND_THR05				(0x0164)
+#define IPIPE_D2F_2ND_THR06				(0x0168)
+#define IPIPE_D2F_2ND_THR07				(0x016C)
+#define IPIPE_D2F_2ND_STR_00				(0x0170)
+#define IPIPE_D2F_2ND_STR_01				(0x0174)
+#define IPIPE_D2F_2ND_STR_02				(0x0178)
+#define IPIPE_D2F_2ND_STR_03				(0x017C)
+#define IPIPE_D2F_2ND_STR_04				(0x0180)
+#define IPIPE_D2F_2ND_STR_05				(0x0184)
+#define IPIPE_D2F_2ND_STR_06				(0x0188)
+#define IPIPE_D2F_2ND_STR_07				(0x018C)
+#define IPIPE_D2F_2ND_SPR_00				(0x0190)
+#define IPIPE_D2F_2ND_SPR_01				(0x0194)
+#define IPIPE_D2F_2ND_SPR_02				(0x0198)
+#define IPIPE_D2F_2ND_SPR_03				(0x019C)
+#define IPIPE_D2F_2ND_SPR_04				(0x01A0)
+#define IPIPE_D2F_2ND_SPR_05				(0x01A4)
+#define IPIPE_D2F_2ND_SPR_06				(0x01A8)
+#define IPIPE_D2F_2ND_SPR_07				(0x01AC)
+#define IPIPE_D2F_2ND_EDG_MIN				(0x01B0)
+#define IPIPE_D2F_2ND_EDG_MAX				(0x01B4)
+
+#define IPIPE_GIC_EN					(0x01B8)
+#define IPIPE_GIC_TYP					(0x01BC)
+#define IPIPE_GIC_GAN					(0x01C0)
+#define IPIPE_GIC_NFGAIN				(0x01C4)
+#define IPIPE_GIC_THR					(0x01C8)
+#define IPIPE_GIC_SLP					(0x01CC)
+
+#define IPIPE_WB2_OFT_R					(0x01D0)
+#define IPIPE_WB2_OFT_GR				(0x01D4)
+#define IPIPE_WB2_OFT_GB				(0x01D8)
+#define IPIPE_WB2_OFT_B					(0x01DC)
+
+#define IPIPE_WB2_WGN_R					(0x01E0)
+#define IPIPE_WB2_WGN_GR				(0x01E4)
+#define IPIPE_WB2_WGN_GB				(0x01E8)
+#define IPIPE_WB2_WGN_B					(0x01EC)
+
+#define IPIPE_CFA_MODE					(0x01F0)
+#define IPIPE_CFA_2DIR_HPF_THR				(0x01F4)
+#define IPIPE_CFA_2DIR_HPF_SLP				(0x01F8)
+#define IPIPE_CFA_2DIR_MIX_THR				(0x01FC)
+#define IPIPE_CFA_2DIR_MIX_SLP				(0x0200)
+#define IPIPE_CFA_2DIR_DIR_TRH				(0x0204)
+#define IPIPE_CFA_2DIR_DIR_SLP				(0x0208)
+#define IPIPE_CFA_2DIR_NDWT				(0x020C)
+#define IPIPE_CFA_MONO_HUE_FRA				(0x0210)
+#define IPIPE_CFA_MONO_EDG_THR				(0x0214)
+#define IPIPE_CFA_MONO_THR_MIN				(0x0218)
+
+#define IPIPE_CFA_MONO_THR_SLP				(0x021C)
+#define IPIPE_CFA_MONO_SLP_MIN				(0x0220)
+#define IPIPE_CFA_MONO_SLP_SLP				(0x0224)
+#define IPIPE_CFA_MONO_LPWT				(0x0228)
+
+#define IPIPE_RGB1_MUL_RR				(0x022C)
+#define IPIPE_RGB1_MUL_GR				(0x0230)
+#define IPIPE_RGB1_MUL_BR				(0x0234)
+#define IPIPE_RGB1_MUL_RG				(0x0238)
+#define IPIPE_RGB1_MUL_GG				(0x023C)
+#define IPIPE_RGB1_MUL_BG				(0x0240)
+#define IPIPE_RGB1_MUL_RB				(0x0244)
+#define IPIPE_RGB1_MUL_GB				(0x0248)
+#define IPIPE_RGB1_MUL_BB				(0x024C)
+#define IPIPE_RGB1_OFT_OR				(0x0250)
+#define IPIPE_RGB1_OFT_OG				(0x0254)
+#define IPIPE_RGB1_OFT_OB				(0x0258)
+#define IPIPE_GMM_CFG					(0x025C)
+#define IPIPE_RGB2_MUL_RR				(0x0260)
+#define IPIPE_RGB2_MUL_GR				(0x0264)
+#define IPIPE_RGB2_MUL_BR				(0x0268)
+#define IPIPE_RGB2_MUL_RG				(0x026C)
+#define IPIPE_RGB2_MUL_GG				(0x0270)
+#define IPIPE_RGB2_MUL_BG				(0x0274)
+#define IPIPE_RGB2_MUL_RB				(0x0278)
+#define IPIPE_RGB2_MUL_GB				(0x027C)
+#define IPIPE_RGB2_MUL_BB				(0x0280)
+#define IPIPE_RGB2_OFT_OR				(0x0284)
+#define IPIPE_RGB2_OFT_OG				(0x0288)
+#define IPIPE_RGB2_OFT_OB				(0x028C)
+
+#define IPIPE_YUV_ADJ					(0x0294)
+#define IPIPE_YUV_MUL_RY				(0x0298)
+#define IPIPE_YUV_MUL_GY				(0x029C)
+#define IPIPE_YUV_MUL_BY				(0x02A0)
+#define IPIPE_YUV_MUL_RCB				(0x02A4)
+#define IPIPE_YUV_MUL_GCB				(0x02A8)
+#define IPIPE_YUV_MUL_BCB				(0x02AC)
+#define IPIPE_YUV_MUL_RCR				(0x02B0)
+#define IPIPE_YUV_MUL_GCR				(0x02B4)
+#define IPIPE_YUV_MUL_BCR				(0x02B8)
+#define IPIPE_YUV_OFT_Y					(0x02BC)
+#define IPIPE_YUV_OFT_CB				(0x02C0)
+#define IPIPE_YUV_OFT_CR				(0x02C4)
+
+#define IPIPE_YUV_PHS					(0x02C8)
+#define IPIPE_YUV_PHS_LPF				(1 << 1)
+#define IPIPE_YUV_PHS_POS				(1 << 0)
+
+#define IPIPE_YEE_EN					(0x02D4)
+#define IPIPE_YEE_TYP					(0x02D8)
+#define IPIPE_YEE_SHF					(0x02DC)
+#define IPIPE_YEE_MUL_00				(0x02E0)
+#define IPIPE_YEE_MUL_01				(0x02E4)
+#define IPIPE_YEE_MUL_02				(0x02E8)
+#define IPIPE_YEE_MUL_10				(0x02EC)
+#define IPIPE_YEE_MUL_11				(0x02F0)
+#define IPIPE_YEE_MUL_12				(0x02F4)
+#define IPIPE_YEE_MUL_20				(0x02F8)
+#define IPIPE_YEE_MUL_21				(0x02FC)
+#define IPIPE_YEE_MUL_22				(0x0300)
+#define IPIPE_YEE_THR					(0x0304)
+#define IPIPE_YEE_E_GAN					(0x0308)
+#define IPIPE_YEE_E_THR_1				(0x030C)
+#define IPIPE_YEE_E_THR_2				(0x0310)
+#define IPIPE_YEE_G_GAN					(0x0314)
+#define IPIPE_YEE_G_OFT					(0x0318)
+
+#define IPIPE_CAR_EN					(0x031C)
+#define IPIPE_CAR_TYP					(0x0320)
+#define IPIPE_CAR_SW					(0x0324)
+#define IPIPE_CAR_HPF_TYP				(0x0328)
+#define IPIPE_CAR_HPF_SHF				(0x032C)
+#define IPIPE_CAR_HPF_THR				(0x0330)
+#define IPIPE_CAR_GN1_GAN				(0x0334)
+#define IPIPE_CAR_GN1_SHF				(0x0338)
+#define IPIPE_CAR_GN1_MIN				(0x033C)
+#define IPIPE_CAR_GN2_GAN				(0x0340)
+#define IPIPE_CAR_GN2_SHF				(0x0344)
+#define IPIPE_CAR_GN2_MIN				(0x0348)
+#define IPIPE_CGS_EN					(0x034C)
+#define IPIPE_CGS_GN1_L_THR				(0x0350)
+#define IPIPE_CGS_GN1_L_GAIN				(0x0354)
+#define IPIPE_CGS_GN1_L_SHF				(0x0358)
+#define IPIPE_CGS_GN1_L_MIN				(0x035C)
+#define IPIPE_CGS_GN1_H_THR				(0x0360)
+#define IPIPE_CGS_GN1_H_GAIN				(0x0364)
+#define IPIPE_CGS_GN1_H_SHF				(0x0368)
+#define IPIPE_CGS_GN1_H_MIN				(0x036C)
+#define IPIPE_CGS_GN2_L_THR				(0x0370)
+#define IPIPE_CGS_GN2_L_GAIN				(0x0374)
+#define IPIPE_CGS_GN2_L_SHF				(0x0378)
+#define IPIPE_CGS_GN2_L_MIN				(0x037C)
+
+#define IPIPE_BOX_EN					(0x0380)
+#define IPIPE_BOX_MODE					(0x0384)
+#define IPIPE_BOX_TYP					(0x0388)
+#define IPIPE_BOX_SHF					(0x038C)
+#define IPIPE_BOX_SDR_SAD_H				(0x0390)
+#define IPIPE_BOX_SDR_SAD_L				(0x0394)
+
+#define IPIPE_HST_EN					(0x039C)
+#define IPIPE_HST_MODE					(0x03A0)
+#define IPIPE_HST_SEL					(0x03A4)
+#define IPIPE_HST_PARA					(0x03A8)
+#define IPIPE_HST_0_VPS					(0x03AC)
+#define IPIPE_HST_0_VSZ					(0x03B0)
+#define IPIPE_HST_0_HPS					(0x03B4)
+#define IPIPE_HST_0_HSZ					(0x03B8)
+#define IPIPE_HST_1_VPS					(0x03BC)
+#define IPIPE_HST_1_VSZ					(0x03C0)
+#define IPIPE_HST_1_HPS					(0x03C4)
+#define IPIPE_HST_1_HSZ					(0x03C8)
+#define IPIPE_HST_2_VPS					(0x03CC)
+#define IPIPE_HST_2_VSZ					(0x03D0)
+#define IPIPE_HST_2_HPS					(0x03D4)
+#define IPIPE_HST_2_HSZ					(0x03D8)
+#define IPIPE_HST_3_VPS					(0x03DC)
+#define IPIPE_HST_3_VSZ					(0x03E0)
+#define IPIPE_HST_3_HPS					(0x03E4)
+#define IPIPE_HST_3_HSZ					(0x03E8)
+#define IPIPE_HST_TBL					(0x03EC)
+#define IPIPE_HST_MUL_R					(0x03F0)
+#define IPIPE_HST_MUL_GR				(0x03F4)
+#define IPIPE_HST_MUL_GB				(0x03F8)
+#define IPIPE_HST_MUL_B					(0x03FC)
+
+#define IPIPE_BSC_EN					(0x0400)
+#define IPIPE_BSC_MODE					(0x0404)
+#define IPIPE_BSC_TYP					(0x0408)
+#define IPIPE_BSC_ROW_VCT				(0x040C)
+#define IPIPE_BSC_ROW_SHF				(0x0410)
+#define IPIPE_BSC_ROW_VPO				(0x0414)
+#define IPIPE_BSC_ROW_VNU				(0x0418)
+#define IPIPE_BSC_ROW_VSKIP				(0x041C)
+#define IPIPE_BSC_ROW_HPO				(0x0420)
+#define IPIPE_BSC_ROW_HNU				(0x0424)
+#define IPIPE_BSC_ROW_HSKIP				(0x0428)
+#define IPIPE_BSC_COL_VCT				(0x042C)
+#define IPIPE_BSC_COL_SHF				(0x0430)
+#define IPIPE_BSC_COL_VPO				(0x0434)
+#define IPIPE_BSC_COL_VNU				(0x0438)
+#define IPIPE_BSC_COL_VSKIP				(0x043C)
+#define IPIPE_BSC_COL_HPO				(0x0440)
+#define IPIPE_BSC_COL_HNU				(0x0444)
+#define IPIPE_BSC_COL_HSKIP				(0x0448)
+
+#define IPIPE_BSC_EN					(0x0400)
+
+/* ISS ISP Resizer register offsets */
+#define RSZ_REVISION					(0x0000)
+#define RSZ_SYSCONFIG					(0x0004)
+#define RSZ_SYSCONFIG_RSZB_CLK_EN			(1 << 9)
+#define RSZ_SYSCONFIG_RSZA_CLK_EN			(1 << 8)
+
+#define RSZ_IN_FIFO_CTRL				(0x000C)
+#define RSZ_IN_FIFO_CTRL_THRLD_LOW_MASK			(0x1FF << 16)
+#define RSZ_IN_FIFO_CTRL_THRLD_LOW_SHIFT		16
+#define RSZ_IN_FIFO_CTRL_THRLD_HIGH_MASK		(0x1FF << 0)
+#define RSZ_IN_FIFO_CTRL_THRLD_HIGH_SHIFT		0
+
+#define RSZ_FRACDIV					(0x0008)
+#define RSZ_FRACDIV_MASK				(0xFFFF)
+
+#define RSZ_SRC_EN					(0x0020)
+#define RSZ_SRC_EN_SRC_EN				(1 << 0)
+
+#define RSZ_SRC_MODE					(0x0024)
+#define RSZ_SRC_MODE_OST				(1 << 0)
+#define RSZ_SRC_MODE_WRT				(1 << 1)
+
+#define RSZ_SRC_FMT0					(0x0028)
+#define RSZ_SRC_FMT0_BYPASS				(1 << 1)
+#define RSZ_SRC_FMT0_SEL				(1 << 0)
+
+#define RSZ_SRC_FMT1					(0x002C)
+#define RSZ_SRC_FMT1_IN420				(1 << 1)
+
+#define RSZ_SRC_VPS					(0x0030)
+#define RSZ_SRC_VSZ					(0x0034)
+#define RSZ_SRC_HPS					(0x0038)
+#define RSZ_SRC_HSZ					(0x003C)
+#define RSZ_DMA_RZA					(0x0040)
+#define RSZ_DMA_RZB					(0x0044)
+#define RSZ_DMA_STA					(0x0048)
+#define RSZ_GCK_MMR					(0x004C)
+#define RSZ_GCK_MMR_MMR					(1 << 0)
+
+#define RSZ_GCK_SDR					(0x0054)
+#define RSZ_GCK_SDR_CORE				(1 << 0)
+
+#define RSZ_IRQ_RZA					(0x0058)
+#define RSZ_IRQ_RZA_MASK				(0x1FFF)
+
+#define RSZ_IRQ_RZB					(0x005C)
+#define RSZ_IRQ_RZB_MASK				(0x1FFF)
+
+#define RSZ_YUV_Y_MIN					(0x0060)
+#define RSZ_YUV_Y_MAX					(0x0064)
+#define RSZ_YUV_C_MIN					(0x0068)
+#define RSZ_YUV_C_MAX					(0x006C)
+
+#define RSZ_SEQ						(0x0074)
+#define RSZ_SEQ_HRVB					(1 << 2)
+#define RSZ_SEQ_HRVA					(1 << 0)
+
+#define RZA_EN						(0x0078)
+#define RZA_MODE					(0x007C)
+#define RZA_MODE_ONE_SHOT				(1 << 0)
+
+#define RZA_420						(0x0080)
+#define RZA_I_VPS					(0x0084)
+#define RZA_I_HPS					(0x0088)
+#define RZA_O_VSZ					(0x008C)
+#define RZA_O_HSZ					(0x0090)
+#define RZA_V_PHS_Y					(0x0094)
+#define RZA_V_PHS_C					(0x0098)
+#define RZA_V_DIF					(0x009C)
+#define RZA_V_TYP					(0x00A0)
+#define RZA_V_LPF					(0x00A4)
+#define RZA_H_PHS					(0x00A8)
+#define RZA_H_DIF					(0x00B0)
+#define RZA_H_TYP					(0x00B4)
+#define RZA_H_LPF					(0x00B8)
+#define RZA_DWN_EN					(0x00BC)
+#define RZA_SDR_Y_BAD_H					(0x00D0)
+#define RZA_SDR_Y_BAD_L					(0x00D4)
+#define RZA_SDR_Y_SAD_H					(0x00D8)
+#define RZA_SDR_Y_SAD_L					(0x00DC)
+#define RZA_SDR_Y_OFT					(0x00E0)
+#define RZA_SDR_Y_PTR_S					(0x00E4)
+#define RZA_SDR_Y_PTR_E					(0x00E8)
+#define RZA_SDR_C_BAD_H					(0x00EC)
+#define RZA_SDR_C_BAD_L					(0x00F0)
+#define RZA_SDR_C_SAD_H					(0x00F4)
+#define RZA_SDR_C_SAD_L					(0x00F8)
+#define RZA_SDR_C_OFT					(0x00FC)
+#define RZA_SDR_C_PTR_S					(0x0100)
+#define RZA_SDR_C_PTR_E					(0x0104)
+
+#define RZB_EN						(0x0108)
+#define RZB_MODE					(0x010C)
+#define RZB_420						(0x0110)
+#define RZB_I_VPS					(0x0114)
+#define RZB_I_HPS					(0x0118)
+#define RZB_O_VSZ					(0x011C)
+#define RZB_O_HSZ					(0x0120)
+
+#define RZB_V_DIF					(0x012C)
+#define RZB_V_TYP					(0x0130)
+#define RZB_V_LPF					(0x0134)
+
+#define RZB_H_DIF					(0x0140)
+#define RZB_H_TYP					(0x0144)
+#define RZB_H_LPF					(0x0148)
+
+#define RZB_SDR_Y_BAD_H					(0x0160)
+#define RZB_SDR_Y_BAD_L					(0x0164)
+#define RZB_SDR_Y_SAD_H					(0x0168)
+#define RZB_SDR_Y_SAD_L					(0x016C)
+#define RZB_SDR_Y_OFT					(0x0170)
+#define RZB_SDR_Y_PTR_S					(0x0174)
+#define RZB_SDR_Y_PTR_E					(0x0178)
+#define RZB_SDR_C_BAD_H					(0x017C)
+#define RZB_SDR_C_BAD_L					(0x0180)
+#define RZB_SDR_C_SAD_H					(0x0184)
+#define RZB_SDR_C_SAD_L					(0x0188)
+
+#define RZB_SDR_C_PTR_S					(0x0190)
+#define RZB_SDR_C_PTR_E					(0x0194)
+
+/* Shared Bitmasks between RZA & RZB */
+#define RSZ_EN_EN					(1 << 0)
+
+#define RSZ_420_CEN					(1 << 1)
+#define RSZ_420_YEN					(1 << 0)
+
+#define RSZ_I_VPS_MASK					(0x1FFF)
+
+#define RSZ_I_HPS_MASK					(0x1FFF)
+
+#define RSZ_O_VSZ_MASK					(0x1FFF)
+
+#define RSZ_O_HSZ_MASK					(0x1FFE)
+
+#define RSZ_V_PHS_Y_MASK				(0x3FFF)
+
+#define RSZ_V_PHS_C_MASK				(0x3FFF)
+
+#define RSZ_V_DIF_MASK					(0x3FFF)
+
+#define RSZ_V_TYP_C					(1 << 1)
+#define RSZ_V_TYP_Y					(1 << 0)
+
+#define RSZ_V_LPF_C_MASK				(0x3F << 6)
+#define RSZ_V_LPF_C_SHIFT				6
+#define RSZ_V_LPF_Y_MASK				(0x3F << 0)
+#define RSZ_V_LPF_Y_SHIFT				0
+
+#define RSZ_H_PHS_MASK					(0x3FFF)
+
+#define RSZ_H_DIF_MASK					(0x3FFF)
+
+#define RSZ_H_TYP_C					(1 << 1)
+#define RSZ_H_TYP_Y					(1 << 0)
+
+#define RSZ_H_LPF_C_MASK				(0x3F << 6)
+#define RSZ_H_LPF_C_SHIFT				6
+#define RSZ_H_LPF_Y_MASK				(0x3F << 0)
+#define RSZ_H_LPF_Y_SHIFT				0
+
+#define RSZ_DWN_EN_DWN_EN				(1 << 0)
+
+#endif /* _OMAP4_ISS_REGS_H_ */
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
1.8.1.5

