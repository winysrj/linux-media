Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48305 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279AbcBHLoX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Feb 2016 06:44:23 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH v3 35/35] v4l: vsp1: Add display list support
Date: Mon,  8 Feb 2016 13:44:05 +0200
Message-Id: <1454931845-23864-36-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1454931845-23864-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1454931845-23864-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Takashi Saito <takashi.saitou.ry@renesas.com>

Display lists contain lists of registers and associated values to be
applied atomically by the hardware. They lower the pressure on interrupt
processing delays when reprogramming the device as settings can be
prepared well in advance and queued to the hardware without waiting for
the end of the current frame.

Display list support is currently limited to the DRM pipeline.

Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

---

Changes since v2:

- Include linux/slab.h where needed

Changes since v1:

- Squash with commit 'v4l: vsp1: Initialize display list when preparing
  for atomic update'
---
 drivers/media/platform/vsp1/Makefile      |   2 +-
 drivers/media/platform/vsp1/vsp1.h        |  17 ++
 drivers/media/platform/vsp1/vsp1_bru.c    |   2 +-
 drivers/media/platform/vsp1/vsp1_dl.c     | 305 ++++++++++++++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_dl.h     |  42 ++++
 drivers/media/platform/vsp1/vsp1_drm.c    | 105 +++++-----
 drivers/media/platform/vsp1/vsp1_drm.h    |   5 +
 drivers/media/platform/vsp1/vsp1_drv.c    |  76 ++++++--
 drivers/media/platform/vsp1/vsp1_entity.c |   4 +-
 drivers/media/platform/vsp1/vsp1_lif.c    |   4 +-
 drivers/media/platform/vsp1/vsp1_pipe.c   |  54 +++++-
 drivers/media/platform/vsp1/vsp1_pipe.h   |   5 +
 drivers/media/platform/vsp1/vsp1_rpf.c    |   4 +-
 drivers/media/platform/vsp1/vsp1_wpf.c    |  13 +-
 14 files changed, 543 insertions(+), 95 deletions(-)
 create mode 100644 drivers/media/platform/vsp1/vsp1_dl.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_dl.h

diff --git a/drivers/media/platform/vsp1/Makefile b/drivers/media/platform/vsp1/Makefile
index 447e72a2ef43..95b3ac2ea7ef 100644
--- a/drivers/media/platform/vsp1/Makefile
+++ b/drivers/media/platform/vsp1/Makefile
@@ -1,5 +1,5 @@
 vsp1-y					:= vsp1_drv.o vsp1_entity.o vsp1_pipe.o
-vsp1-y					+= vsp1_drm.o vsp1_video.o
+vsp1-y					+= vsp1_dl.o vsp1_drm.o vsp1_video.o
 vsp1-y					+= vsp1_rpf.o vsp1_rwpf.o vsp1_wpf.o
 vsp1-y					+= vsp1_hsit.o vsp1_lif.o vsp1_lut.o
 vsp1-y					+= vsp1_bru.o vsp1_sru.o vsp1_uds.o
diff --git a/drivers/media/platform/vsp1/vsp1.h b/drivers/media/platform/vsp1/vsp1.h
index 67a026ae88cb..5b210b69f09c 100644
--- a/drivers/media/platform/vsp1/vsp1.h
+++ b/drivers/media/platform/vsp1/vsp1.h
@@ -26,7 +26,9 @@
 struct clk;
 struct device;
 
+struct vsp1_dl;
 struct vsp1_drm;
+struct vsp1_entity;
 struct vsp1_platform_data;
 struct vsp1_bru;
 struct vsp1_hsit;
@@ -80,12 +82,17 @@ struct vsp1_device {
 	struct v4l2_device v4l2_dev;
 	struct media_device media_dev;
 	struct media_entity_operations media_ops;
+
 	struct vsp1_drm *drm;
+
+	bool use_dl;
 };
 
 int vsp1_device_get(struct vsp1_device *vsp1);
 void vsp1_device_put(struct vsp1_device *vsp1);
 
+int vsp1_reset_wpf(struct vsp1_device *vsp1, unsigned int index);
+
 static inline u32 vsp1_read(struct vsp1_device *vsp1, u32 reg)
 {
 	return ioread32(vsp1->mmio + reg);
@@ -96,4 +103,14 @@ static inline void vsp1_write(struct vsp1_device *vsp1, u32 reg, u32 data)
 	iowrite32(data, vsp1->mmio + reg);
 }
 
+#include "vsp1_dl.h"
+
+static inline void vsp1_mod_write(struct vsp1_entity *e, u32 reg, u32 data)
+{
+	if (e->vsp1->use_dl)
+		vsp1_dl_add(e, reg, data);
+	else
+		vsp1_write(e->vsp1, reg, data);
+}
+
 #endif /* __VSP1_H__ */
diff --git a/drivers/media/platform/vsp1/vsp1_bru.c b/drivers/media/platform/vsp1/vsp1_bru.c
index 848bfb5a42ff..32e2009c215a 100644
--- a/drivers/media/platform/vsp1/vsp1_bru.c
+++ b/drivers/media/platform/vsp1/vsp1_bru.c
@@ -30,7 +30,7 @@
 
 static inline void vsp1_bru_write(struct vsp1_bru *bru, u32 reg, u32 data)
 {
-	vsp1_write(bru->entity.vsp1, reg, data);
+	vsp1_mod_write(&bru->entity, reg, data);
 }
 
 /* -----------------------------------------------------------------------------
diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
new file mode 100644
index 000000000000..7dc27ac6bd02
--- /dev/null
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -0,0 +1,305 @@
+/*
+ * vsp1_dl.h  --  R-Car VSP1 Display List
+ *
+ * Copyright (C) 2015 Renesas Corporation
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
+#include <linux/dma-mapping.h>
+#include <linux/gfp.h>
+#include <linux/slab.h>
+
+#include "vsp1.h"
+#include "vsp1_dl.h"
+#include "vsp1_pipe.h"
+
+/*
+ * Global resources
+ *
+ * - Display-related interrupts (can be used for vblank evasion ?)
+ * - Display-list enable
+ * - Header-less for WPF0
+ * - DL swap
+ */
+
+#define VSP1_DL_BODY_SIZE		(2 * 4 * 256)
+#define VSP1_DL_NUM_LISTS		3
+
+struct vsp1_dl_entry {
+	u32 addr;
+	u32 data;
+} __attribute__((__packed__));
+
+struct vsp1_dl_list {
+	size_t size;
+	int reg_count;
+
+	bool in_use;
+
+	struct vsp1_dl_entry *body;
+	dma_addr_t dma;
+};
+
+/**
+ * struct vsp1_dl - Display List manager
+ * @vsp1: the VSP1 device
+ * @lock: protects the active, queued and pending lists
+ * @lists.all: array of all allocate display lists
+ * @lists.active: list currently being processed (loaded) by hardware
+ * @lists.queued: list queued to the hardware (written to the DL registers)
+ * @lists.pending: list waiting to be queued to the hardware
+ * @lists.write: list being written to by software
+ */
+struct vsp1_dl {
+	struct vsp1_device *vsp1;
+
+	spinlock_t lock;
+
+	size_t size;
+	dma_addr_t dma;
+	void *mem;
+
+	struct {
+		struct vsp1_dl_list all[VSP1_DL_NUM_LISTS];
+
+		struct vsp1_dl_list *active;
+		struct vsp1_dl_list *queued;
+		struct vsp1_dl_list *pending;
+		struct vsp1_dl_list *write;
+	} lists;
+};
+
+/* -----------------------------------------------------------------------------
+ * Display List Transaction Management
+ */
+
+static void vsp1_dl_free_list(struct vsp1_dl_list *list)
+{
+	if (!list)
+		return;
+
+	list->in_use = false;
+}
+
+void vsp1_dl_reset(struct vsp1_dl *dl)
+{
+	unsigned int i;
+
+	dl->lists.active = NULL;
+	dl->lists.queued = NULL;
+	dl->lists.pending = NULL;
+	dl->lists.write = NULL;
+
+	for (i = 0; i < ARRAY_SIZE(dl->lists.all); ++i)
+		dl->lists.all[i].in_use = false;
+}
+
+void vsp1_dl_begin(struct vsp1_dl *dl)
+{
+	struct vsp1_dl_list *list = NULL;
+	unsigned long flags;
+	unsigned int i;
+
+	spin_lock_irqsave(&dl->lock, flags);
+
+	for (i = 0; i < ARRAY_SIZE(dl->lists.all); ++i) {
+		if (!dl->lists.all[i].in_use) {
+			list = &dl->lists.all[i];
+			break;
+		}
+	}
+
+	if (!list) {
+		list = dl->lists.pending;
+		dl->lists.pending = NULL;
+	}
+
+	spin_unlock_irqrestore(&dl->lock, flags);
+
+	dl->lists.write = list;
+
+	list->in_use = true;
+	list->reg_count = 0;
+}
+
+void vsp1_dl_add(struct vsp1_entity *e, u32 reg, u32 data)
+{
+	struct vsp1_pipeline *pipe = to_vsp1_pipeline(&e->subdev.entity);
+	struct vsp1_dl *dl = pipe->dl;
+	struct vsp1_dl_list *list = dl->lists.write;
+
+	list->body[list->reg_count].addr = reg;
+	list->body[list->reg_count].data = data;
+	list->reg_count++;
+}
+
+void vsp1_dl_commit(struct vsp1_dl *dl)
+{
+	struct vsp1_device *vsp1 = dl->vsp1;
+	struct vsp1_dl_list *list;
+	unsigned long flags;
+	bool update;
+
+	list = dl->lists.write;
+	dl->lists.write = NULL;
+
+	spin_lock_irqsave(&dl->lock, flags);
+
+	/* Once the UPD bit has been set the hardware can start processing the
+	 * display list at any time and we can't touch the address and size
+	 * registers. In that case mark the update as pending, it will be
+	 * queued up to the hardware by the frame end interrupt handler.
+	 */
+	update = !!(vsp1_read(vsp1, VI6_DL_BODY_SIZE) & VI6_DL_BODY_SIZE_UPD);
+	if (update) {
+		vsp1_dl_free_list(dl->lists.pending);
+		dl->lists.pending = list;
+		goto done;
+	}
+
+	/* Program the hardware with the display list body address and size.
+	 * The UPD bit will be cleared by the device when the display list is
+	 * processed.
+	 */
+	vsp1_write(vsp1, VI6_DL_HDR_ADDR(0), list->dma);
+	vsp1_write(vsp1, VI6_DL_BODY_SIZE, VI6_DL_BODY_SIZE_UPD |
+		   (list->reg_count * 8));
+
+	vsp1_dl_free_list(dl->lists.queued);
+	dl->lists.queued = list;
+
+done:
+	spin_unlock_irqrestore(&dl->lock, flags);
+}
+
+/* -----------------------------------------------------------------------------
+ * Interrupt Handling
+ */
+
+void vsp1_dl_irq_display_start(struct vsp1_dl *dl)
+{
+	spin_lock(&dl->lock);
+
+	/* The display start interrupt signals the end of the display list
+	 * processing by the device. The active display list, if any, won't be
+	 * accessed anymore and can be reused.
+	 */
+	if (dl->lists.active) {
+		vsp1_dl_free_list(dl->lists.active);
+		dl->lists.active = NULL;
+	}
+
+	spin_unlock(&dl->lock);
+}
+
+void vsp1_dl_irq_frame_end(struct vsp1_dl *dl)
+{
+	struct vsp1_device *vsp1 = dl->vsp1;
+
+	spin_lock(&dl->lock);
+
+	/* The UPD bit set indicates that the commit operation raced with the
+	 * interrupt and occurred after the frame end event and UPD clear but
+	 * before interrupt processing. The hardware hasn't taken the update
+	 * into account yet, we'll thus skip one frame and retry.
+	 */
+	if (vsp1_read(vsp1, VI6_DL_BODY_SIZE) & VI6_DL_BODY_SIZE_UPD)
+		goto done;
+
+	/* The device starts processing the queued display list right after the
+	 * frame end interrupt. The display list thus becomes active.
+	 */
+	if (dl->lists.queued) {
+		WARN_ON(dl->lists.active);
+		dl->lists.active = dl->lists.queued;
+		dl->lists.queued = NULL;
+	}
+
+	/* Now that the UPD bit has been cleared we can queue the next display
+	 * list to the hardware if one has been prepared.
+	 */
+	if (dl->lists.pending) {
+		struct vsp1_dl_list *list = dl->lists.pending;
+
+		vsp1_write(vsp1, VI6_DL_HDR_ADDR(0), list->dma);
+		vsp1_write(vsp1, VI6_DL_BODY_SIZE, VI6_DL_BODY_SIZE_UPD |
+			   (list->reg_count * 8));
+
+		dl->lists.queued = list;
+		dl->lists.pending = NULL;
+	}
+
+done:
+	spin_unlock(&dl->lock);
+}
+
+/* -----------------------------------------------------------------------------
+ * Hardware Setup
+ */
+
+void vsp1_dl_setup(struct vsp1_device *vsp1)
+{
+	u32 ctrl = (256 << VI6_DL_CTRL_AR_WAIT_SHIFT)
+		 | VI6_DL_CTRL_DC2 | VI6_DL_CTRL_DC1 | VI6_DL_CTRL_DC0
+		 | VI6_DL_CTRL_DLE;
+
+	/* The DRM pipeline operates with header-less display lists in
+	 * Continuous Frame Mode.
+	 */
+	if (vsp1->drm)
+		ctrl |= VI6_DL_CTRL_CFM0 | VI6_DL_CTRL_NH0;
+
+	vsp1_write(vsp1, VI6_DL_CTRL, ctrl);
+	vsp1_write(vsp1, VI6_DL_SWAP, VI6_DL_SWAP_LWS);
+}
+
+/* -----------------------------------------------------------------------------
+ * Initialization and Cleanup
+ */
+
+struct vsp1_dl *vsp1_dl_create(struct vsp1_device *vsp1)
+{
+	struct vsp1_dl *dl;
+	unsigned int i;
+
+	dl = kzalloc(sizeof(*dl), GFP_KERNEL);
+	if (!dl)
+		return NULL;
+
+	spin_lock_init(&dl->lock);
+
+	dl->vsp1 = vsp1;
+	dl->size = VSP1_DL_BODY_SIZE * ARRAY_SIZE(dl->lists.all);
+
+	dl->mem = dma_alloc_writecombine(vsp1->dev, dl->size, &dl->dma,
+					 GFP_KERNEL);
+	if (!dl->mem) {
+		kfree(dl);
+		return NULL;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(dl->lists.all); ++i) {
+		struct vsp1_dl_list *list = &dl->lists.all[i];
+
+		list->size = VSP1_DL_BODY_SIZE;
+		list->reg_count = 0;
+		list->in_use = false;
+		list->dma = dl->dma + VSP1_DL_BODY_SIZE * i;
+		list->body = dl->mem + VSP1_DL_BODY_SIZE * i;
+	}
+
+	return dl;
+}
+
+void vsp1_dl_destroy(struct vsp1_dl *dl)
+{
+	dma_free_writecombine(dl->vsp1->dev, dl->size, dl->mem, dl->dma);
+	kfree(dl);
+}
diff --git a/drivers/media/platform/vsp1/vsp1_dl.h b/drivers/media/platform/vsp1/vsp1_dl.h
new file mode 100644
index 000000000000..448c4250e54c
--- /dev/null
+++ b/drivers/media/platform/vsp1/vsp1_dl.h
@@ -0,0 +1,42 @@
+/*
+ * vsp1_dl.h  --  R-Car VSP1 Display List
+ *
+ * Copyright (C) 2015 Renesas Corporation
+ *
+ * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#ifndef __VSP1_DL_H__
+#define __VSP1_DL_H__
+
+#include "vsp1_entity.h"
+
+struct vsp1_device;
+struct vsp1_dl;
+
+struct vsp1_dl *vsp1_dl_create(struct vsp1_device *vsp1);
+void vsp1_dl_destroy(struct vsp1_dl *dl);
+
+void vsp1_dl_setup(struct vsp1_device *vsp1);
+
+void vsp1_dl_reset(struct vsp1_dl *dl);
+void vsp1_dl_begin(struct vsp1_dl *dl);
+void vsp1_dl_add(struct vsp1_entity *e, u32 reg, u32 data);
+void vsp1_dl_commit(struct vsp1_dl *dl);
+
+void vsp1_dl_irq_display_start(struct vsp1_dl *dl);
+void vsp1_dl_irq_frame_end(struct vsp1_dl *dl);
+
+static inline void vsp1_dl_mod_write(struct vsp1_entity *e, u32 reg, u32 data)
+{
+	if (e->vsp1->use_dl)
+		vsp1_dl_add(e, reg, data);
+	else
+		vsp1_write(e->vsp1, reg, data);
+}
+
+#endif /* __VSP1_DL_H__ */
diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index 8c76086caa67..ddd98212bf39 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -20,6 +20,7 @@
 
 #include "vsp1.h"
 #include "vsp1_bru.h"
+#include "vsp1_dl.h"
 #include "vsp1_drm.h"
 #include "vsp1_lif.h"
 #include "vsp1_pipe.h"
@@ -29,55 +30,13 @@
  * Runtime Handling
  */
 
-static int vsp1_drm_pipeline_run(struct vsp1_pipeline *pipe)
-{
-	struct vsp1_device *vsp1 = pipe->output->entity.vsp1;
-	int ret;
-
-	if (vsp1->drm->update) {
-		struct vsp1_entity *entity;
-
-		list_for_each_entry(entity, &pipe->entities, list_pipe) {
-			/* Disconnect unused RPFs from the pipeline. */
-			if (entity->type == VSP1_ENTITY_RPF) {
-				struct vsp1_rwpf *rpf =
-					to_rwpf(&entity->subdev);
-
-				if (!pipe->inputs[rpf->entity.index]) {
-					vsp1_write(entity->vsp1,
-						   entity->route->reg,
-						   VI6_DPR_NODE_UNUSED);
-					continue;
-				}
-			}
-
-			vsp1_entity_route_setup(entity);
-
-			ret = v4l2_subdev_call(&entity->subdev, video,
-					       s_stream, 1);
-			if (ret < 0) {
-				dev_err(vsp1->dev,
-					"DRM pipeline start failure on entity %s\n",
-					entity->subdev.name);
-				return ret;
-			}
-		}
-
-		vsp1->drm->update = false;
-	}
-
-	vsp1_pipeline_run(pipe);
-
-	return 0;
-}
-
 static void vsp1_drm_pipeline_frame_end(struct vsp1_pipeline *pipe)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&pipe->irqlock, flags);
 	if (pipe->num_inputs)
-		vsp1_drm_pipeline_run(pipe);
+		vsp1_pipeline_run(pipe);
 	spin_unlock_irqrestore(&pipe->irqlock, flags);
 }
 
@@ -151,6 +110,8 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int width,
 		return 0;
 	}
 
+	vsp1_dl_reset(vsp1->drm->dl);
+
 	/* Configure the format at the BRU sinks and propagate it through the
 	 * pipeline.
 	 */
@@ -266,9 +227,11 @@ void vsp1_du_atomic_begin(struct device *dev)
 	spin_lock_irqsave(&pipe->irqlock, flags);
 
 	vsp1->drm->num_inputs = pipe->num_inputs;
-	vsp1->drm->update = false;
 
 	spin_unlock_irqrestore(&pipe->irqlock, flags);
+
+	/* Prepare the display list. */
+	vsp1_dl_begin(vsp1->drm->dl);
 }
 EXPORT_SYMBOL_GPL(vsp1_du_atomic_begin);
 
@@ -489,23 +452,54 @@ void vsp1_du_atomic_flush(struct device *dev)
 {
 	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
 	struct vsp1_pipeline *pipe = &vsp1->drm->pipe;
+	struct vsp1_entity *entity;
 	unsigned long flags;
 	bool stop = false;
+	int ret;
 
-	spin_lock_irqsave(&pipe->irqlock, flags);
+	list_for_each_entry(entity, &pipe->entities, list_pipe) {
+		/* Disconnect unused RPFs from the pipeline. */
+		if (entity->type == VSP1_ENTITY_RPF) {
+			struct vsp1_rwpf *rpf = to_rwpf(&entity->subdev);
+
+			if (!pipe->inputs[rpf->entity.index]) {
+				vsp1_mod_write(entity, entity->route->reg,
+					   VI6_DPR_NODE_UNUSED);
+				continue;
+			}
+		}
+
+		vsp1_entity_route_setup(entity);
+
+		ret = v4l2_subdev_call(&entity->subdev, video,
+				       s_stream, 1);
+		if (ret < 0) {
+			dev_err(vsp1->dev,
+				"DRM pipeline start failure on entity %s\n",
+				entity->subdev.name);
+			return;
+		}
+	}
+
+	vsp1_dl_commit(vsp1->drm->dl);
 
-	vsp1->drm->update = true;
+	spin_lock_irqsave(&pipe->irqlock, flags);
 
 	/* Start or stop the pipeline if needed. */
-	if (!vsp1->drm->num_inputs && pipe->num_inputs)
-		vsp1_drm_pipeline_run(pipe);
-	else if (vsp1->drm->num_inputs && !pipe->num_inputs)
+	if (!vsp1->drm->num_inputs && pipe->num_inputs) {
+		vsp1_write(vsp1, VI6_DISP_IRQ_STA, 0);
+		vsp1_write(vsp1, VI6_DISP_IRQ_ENB, VI6_DISP_IRQ_ENB_DSTE);
+		vsp1_pipeline_run(pipe);
+	} else if (vsp1->drm->num_inputs && !pipe->num_inputs) {
 		stop = true;
+	}
 
 	spin_unlock_irqrestore(&pipe->irqlock, flags);
 
-	if (stop)
+	if (stop) {
+		vsp1_write(vsp1, VI6_DISP_IRQ_ENB, 0);
 		vsp1_pipeline_stop(pipe);
+	}
 }
 EXPORT_SYMBOL_GPL(vsp1_du_atomic_flush);
 
@@ -568,6 +562,10 @@ int vsp1_drm_init(struct vsp1_device *vsp1)
 	if (!vsp1->drm)
 		return -ENOMEM;
 
+	vsp1->drm->dl = vsp1_dl_create(vsp1);
+	if (!vsp1->drm->dl)
+		return -ENOMEM;
+
 	pipe = &vsp1->drm->pipe;
 
 	vsp1_pipeline_init(pipe);
@@ -588,5 +586,12 @@ int vsp1_drm_init(struct vsp1_device *vsp1)
 	pipe->lif = &vsp1->lif->entity;
 	pipe->output = vsp1->wpf[0];
 
+	pipe->dl = vsp1->drm->dl;
+
 	return 0;
 }
+
+void vsp1_drm_cleanup(struct vsp1_device *vsp1)
+{
+	vsp1_dl_destroy(vsp1->drm->dl);
+}
diff --git a/drivers/media/platform/vsp1/vsp1_drm.h b/drivers/media/platform/vsp1/vsp1_drm.h
index 25d7f017feb4..7704038c3add 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.h
+++ b/drivers/media/platform/vsp1/vsp1_drm.h
@@ -15,19 +15,24 @@
 
 #include "vsp1_pipe.h"
 
+struct vsp1_dl;
+
 /**
  * vsp1_drm - State for the API exposed to the DRM driver
+ * @dl: display list for DRM pipeline operation
  * @pipe: the VSP1 pipeline used for display
  * @num_inputs: number of active pipeline inputs at the beginning of an update
  * @update: the pipeline configuration has been updated
  */
 struct vsp1_drm {
+	struct vsp1_dl *dl;
 	struct vsp1_pipeline pipe;
 	unsigned int num_inputs;
 	bool update;
 };
 
 int vsp1_drm_init(struct vsp1_device *vsp1);
+void vsp1_drm_cleanup(struct vsp1_device *vsp1);
 int vsp1_drm_create_links(struct vsp1_device *vsp1);
 
 #endif /* __VSP1_DRM_H__ */
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 7530dbc978cd..b2a7d58e3e13 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -25,6 +25,7 @@
 
 #include "vsp1.h"
 #include "vsp1_bru.h"
+#include "vsp1_dl.h"
 #include "vsp1_drm.h"
 #include "vsp1_hsit.h"
 #include "vsp1_lif.h"
@@ -44,11 +45,11 @@ static irqreturn_t vsp1_irq_handler(int irq, void *data)
 	struct vsp1_device *vsp1 = data;
 	irqreturn_t ret = IRQ_NONE;
 	unsigned int i;
+	u32 status;
 
 	for (i = 0; i < vsp1->pdata.wpf_count; ++i) {
 		struct vsp1_rwpf *wpf = vsp1->wpf[i];
 		struct vsp1_pipeline *pipe;
-		u32 status;
 
 		if (wpf == NULL)
 			continue;
@@ -63,6 +64,21 @@ static irqreturn_t vsp1_irq_handler(int irq, void *data)
 		}
 	}
 
+	status = vsp1_read(vsp1, VI6_DISP_IRQ_STA);
+	vsp1_write(vsp1, VI6_DISP_IRQ_STA, ~status & VI6_DISP_IRQ_STA_DST);
+
+	if (status & VI6_DISP_IRQ_STA_DST) {
+		struct vsp1_rwpf *wpf = vsp1->wpf[0];
+		struct vsp1_pipeline *pipe;
+
+		if (wpf) {
+			pipe = to_vsp1_pipeline(&wpf->entity.subdev.entity);
+			vsp1_pipeline_display_start(pipe);
+		}
+
+		ret = IRQ_HANDLED;
+	}
+
 	return ret;
 }
 
@@ -198,6 +214,9 @@ static void vsp1_destroy_entities(struct vsp1_device *vsp1)
 	v4l2_device_unregister(&vsp1->v4l2_dev);
 	media_device_unregister(&vsp1->media_dev);
 	media_device_cleanup(&vsp1->media_dev);
+
+	if (!vsp1->pdata.uapi)
+		vsp1_drm_cleanup(vsp1);
 }
 
 static int vsp1_create_entities(struct vsp1_device *vsp1)
@@ -368,10 +387,13 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 	/* Register subdev nodes if the userspace API is enabled or initialize
 	 * the DRM pipeline otherwise.
 	 */
-	if (vsp1->pdata.uapi)
+	if (vsp1->pdata.uapi) {
+		vsp1->use_dl = false;
 		ret = v4l2_device_register_subdev_nodes(&vsp1->v4l2_dev);
-	else
+	} else {
+		vsp1->use_dl = true;
 		ret = vsp1_drm_init(vsp1);
+	}
 	if (ret < 0)
 		goto done;
 
@@ -384,33 +406,42 @@ done:
 	return ret;
 }
 
-static int vsp1_device_init(struct vsp1_device *vsp1)
+int vsp1_reset_wpf(struct vsp1_device *vsp1, unsigned int index)
 {
-	unsigned int i;
+	unsigned int timeout;
 	u32 status;
 
-	/* Reset any channel that might be running. */
 	status = vsp1_read(vsp1, VI6_STATUS);
+	if (!(status & VI6_STATUS_SYS_ACT(index)))
+		return 0;
 
-	for (i = 0; i < vsp1->pdata.wpf_count; ++i) {
-		unsigned int timeout;
+	vsp1_write(vsp1, VI6_SRESET, VI6_SRESET_SRTS(index));
+	for (timeout = 10; timeout > 0; --timeout) {
+		status = vsp1_read(vsp1, VI6_STATUS);
+		if (!(status & VI6_STATUS_SYS_ACT(index)))
+			break;
 
-		if (!(status & VI6_STATUS_SYS_ACT(i)))
-			continue;
+		usleep_range(1000, 2000);
+	}
 
-		vsp1_write(vsp1, VI6_SRESET, VI6_SRESET_SRTS(i));
-		for (timeout = 10; timeout > 0; --timeout) {
-			status = vsp1_read(vsp1, VI6_STATUS);
-			if (!(status & VI6_STATUS_SYS_ACT(i)))
-				break;
+	if (!timeout) {
+		dev_err(vsp1->dev, "failed to reset wpf.%u\n", index);
+		return -ETIMEDOUT;
+	}
 
-			usleep_range(1000, 2000);
-		}
+	return 0;
+}
 
-		if (!timeout) {
-			dev_err(vsp1->dev, "failed to reset wpf.%u\n", i);
-			return -ETIMEDOUT;
-		}
+static int vsp1_device_init(struct vsp1_device *vsp1)
+{
+	unsigned int i;
+	int ret;
+
+	/* Reset any channel that might be running. */
+	for (i = 0; i < vsp1->pdata.wpf_count; ++i) {
+		ret = vsp1_reset_wpf(vsp1, i);
+		if (ret < 0)
+			return ret;
 	}
 
 	vsp1_write(vsp1, VI6_CLK_DCSWT, (8 << VI6_CLK_DCSWT_CSTPW_SHIFT) |
@@ -434,6 +465,9 @@ static int vsp1_device_init(struct vsp1_device *vsp1)
 	vsp1_write(vsp1, VI6_DPR_HGT_SMPPT, (7 << VI6_DPR_SMPPT_TGW_SHIFT) |
 		   (VI6_DPR_NODE_UNUSED << VI6_DPR_SMPPT_PT_SHIFT));
 
+	if (vsp1->use_dl)
+		vsp1_dl_setup(vsp1);
+
 	return 0;
 }
 
diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
index 1fcee58fae62..b9df8349b529 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.c
+++ b/drivers/media/platform/vsp1/vsp1_entity.c
@@ -66,8 +66,8 @@ void vsp1_entity_route_setup(struct vsp1_entity *source)
 		return;
 
 	sink = container_of(source->sink, struct vsp1_entity, subdev.entity);
-	vsp1_write(source->vsp1, source->route->reg,
-		   sink->route->inputs[source->sink_pad]);
+	vsp1_mod_write(source, source->route->reg,
+		       sink->route->inputs[source->sink_pad]);
 }
 
 /* -----------------------------------------------------------------------------
diff --git a/drivers/media/platform/vsp1/vsp1_lif.c b/drivers/media/platform/vsp1/vsp1_lif.c
index b8e73d32d14d..433853ce8dbf 100644
--- a/drivers/media/platform/vsp1/vsp1_lif.c
+++ b/drivers/media/platform/vsp1/vsp1_lif.c
@@ -28,7 +28,7 @@
 
 static inline void vsp1_lif_write(struct vsp1_lif *lif, u32 reg, u32 data)
 {
-	vsp1_write(lif->entity.vsp1, reg, data);
+	vsp1_mod_write(&lif->entity, reg, data);
 }
 
 /* -----------------------------------------------------------------------------
@@ -44,7 +44,7 @@ static int lif_s_stream(struct v4l2_subdev *subdev, int enable)
 	unsigned int lbth = 200;
 
 	if (!enable) {
-		vsp1_lif_write(lif, VI6_LIF_CTRL, 0);
+		vsp1_write(lif->entity.vsp1, VI6_LIF_CTRL, 0);
 		return 0;
 	}
 
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c b/drivers/media/platform/vsp1/vsp1_pipe.c
index 05d4c3870cff..36aa825b5ce6 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.c
+++ b/drivers/media/platform/vsp1/vsp1_pipe.c
@@ -11,6 +11,7 @@
  * (at your option) any later version.
  */
 
+#include <linux/delay.h>
 #include <linux/list.h>
 #include <linux/sched.h>
 #include <linux/wait.h>
@@ -20,6 +21,7 @@
 
 #include "vsp1.h"
 #include "vsp1_bru.h"
+#include "vsp1_dl.h"
 #include "vsp1_entity.h"
 #include "vsp1_pipe.h"
 #include "vsp1_rwpf.h"
@@ -197,8 +199,12 @@ void vsp1_pipeline_run(struct vsp1_pipeline *pipe)
 {
 	struct vsp1_device *vsp1 = pipe->output->entity.vsp1;
 
-	vsp1_write(vsp1, VI6_CMD(pipe->output->entity.index), VI6_CMD_STRCMD);
-	pipe->state = VSP1_PIPELINE_RUNNING;
+	if (pipe->state == VSP1_PIPELINE_STOPPED) {
+		vsp1_write(vsp1, VI6_CMD(pipe->output->entity.index),
+			   VI6_CMD_STRCMD);
+		pipe->state = VSP1_PIPELINE_RUNNING;
+	}
+
 	pipe->buffers_ready = 0;
 }
 
@@ -220,14 +226,28 @@ int vsp1_pipeline_stop(struct vsp1_pipeline *pipe)
 	unsigned long flags;
 	int ret;
 
-	spin_lock_irqsave(&pipe->irqlock, flags);
-	if (pipe->state == VSP1_PIPELINE_RUNNING)
-		pipe->state = VSP1_PIPELINE_STOPPING;
-	spin_unlock_irqrestore(&pipe->irqlock, flags);
+	if (pipe->dl) {
+		/* When using display lists in continuous frame mode the only
+		 * way to stop the pipeline is to reset the hardware.
+		 */
+		ret = vsp1_reset_wpf(pipe->output->entity.vsp1,
+				     pipe->output->entity.index);
+		if (ret == 0) {
+			spin_lock_irqsave(&pipe->irqlock, flags);
+			pipe->state = VSP1_PIPELINE_STOPPED;
+			spin_unlock_irqrestore(&pipe->irqlock, flags);
+		}
+	} else {
+		/* Otherwise just request a stop and wait. */
+		spin_lock_irqsave(&pipe->irqlock, flags);
+		if (pipe->state == VSP1_PIPELINE_RUNNING)
+			pipe->state = VSP1_PIPELINE_STOPPING;
+		spin_unlock_irqrestore(&pipe->irqlock, flags);
 
-	ret = wait_event_timeout(pipe->wq, vsp1_pipeline_stopped(pipe),
-				 msecs_to_jiffies(500));
-	ret = ret == 0 ? -ETIMEDOUT : 0;
+		ret = wait_event_timeout(pipe->wq, vsp1_pipeline_stopped(pipe),
+					 msecs_to_jiffies(500));
+		ret = ret == 0 ? -ETIMEDOUT : 0;
+	}
 
 	list_for_each_entry(entity, &pipe->entities, list_pipe) {
 		if (entity->route && entity->route->reg)
@@ -251,6 +271,12 @@ bool vsp1_pipeline_ready(struct vsp1_pipeline *pipe)
 	return pipe->buffers_ready == mask;
 }
 
+void vsp1_pipeline_display_start(struct vsp1_pipeline *pipe)
+{
+	if (pipe->dl)
+		vsp1_dl_irq_display_start(pipe->dl);
+}
+
 void vsp1_pipeline_frame_end(struct vsp1_pipeline *pipe)
 {
 	enum vsp1_pipeline_state state;
@@ -259,13 +285,21 @@ void vsp1_pipeline_frame_end(struct vsp1_pipeline *pipe)
 	if (pipe == NULL)
 		return;
 
+	if (pipe->dl)
+		vsp1_dl_irq_frame_end(pipe->dl);
+
 	/* Signal frame end to the pipeline handler. */
 	pipe->frame_end(pipe);
 
 	spin_lock_irqsave(&pipe->irqlock, flags);
 
 	state = pipe->state;
-	pipe->state = VSP1_PIPELINE_STOPPED;
+
+	/* When using display lists in continuous frame mode the pipeline is
+	 * automatically restarted by the hardware.
+	 */
+	if (!pipe->dl)
+		pipe->state = VSP1_PIPELINE_STOPPED;
 
 	/* If a stop has been requested, mark the pipeline as stopped and
 	 * return.
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h b/drivers/media/platform/vsp1/vsp1_pipe.h
index c4c300561c5c..b2f3a8a896c9 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.h
+++ b/drivers/media/platform/vsp1/vsp1_pipe.h
@@ -19,6 +19,7 @@
 
 #include <media/media-entity.h>
 
+struct vsp1_dl;
 struct vsp1_rwpf;
 
 /*
@@ -73,6 +74,7 @@ enum vsp1_pipeline_state {
  * @uds: UDS entity, if present
  * @uds_input: entity at the input of the UDS, if the UDS is present
  * @entities: list of entities in the pipeline
+ * @dl: display list associated with the pipeline
  */
 struct vsp1_pipeline {
 	struct media_pipeline pipe;
@@ -97,6 +99,8 @@ struct vsp1_pipeline {
 	struct vsp1_entity *uds_input;
 
 	struct list_head entities;
+
+	struct vsp1_dl *dl;
 };
 
 static inline struct vsp1_pipeline *to_vsp1_pipeline(struct media_entity *e)
@@ -115,6 +119,7 @@ bool vsp1_pipeline_stopped(struct vsp1_pipeline *pipe);
 int vsp1_pipeline_stop(struct vsp1_pipeline *pipe);
 bool vsp1_pipeline_ready(struct vsp1_pipeline *pipe);
 
+void vsp1_pipeline_display_start(struct vsp1_pipeline *pipe);
 void vsp1_pipeline_frame_end(struct vsp1_pipeline *pipe);
 
 void vsp1_pipeline_propagate_alpha(struct vsp1_pipeline *pipe,
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index 3992da09e466..1eb9a3ef05c8 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -28,8 +28,8 @@
 
 static inline void vsp1_rpf_write(struct vsp1_rwpf *rpf, u32 reg, u32 data)
 {
-	vsp1_write(rpf->entity.vsp1,
-		   reg + rpf->entity.index * VI6_RPF_OFFSET, data);
+	vsp1_mod_write(&rpf->entity, reg + rpf->entity.index * VI6_RPF_OFFSET,
+		       data);
 }
 
 /* -----------------------------------------------------------------------------
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index 849ed81d86a1..4a741a597878 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -34,8 +34,8 @@ static inline u32 vsp1_wpf_read(struct vsp1_rwpf *wpf, u32 reg)
 
 static inline void vsp1_wpf_write(struct vsp1_rwpf *wpf, u32 reg, u32 data)
 {
-	vsp1_write(wpf->entity.vsp1,
-		   reg + wpf->entity.index * VI6_WPF_OFFSET, data);
+	vsp1_mod_write(&wpf->entity,
+		       reg + wpf->entity.index * VI6_WPF_OFFSET, data);
 }
 
 /* -----------------------------------------------------------------------------
@@ -88,7 +88,8 @@ static int wpf_s_stream(struct v4l2_subdev *subdev, int enable)
 
 	if (!enable) {
 		vsp1_write(vsp1, VI6_WPF_IRQ_ENB(wpf->entity.index), 0);
-		vsp1_wpf_write(wpf, VI6_WPF_SRCRPF, 0);
+		vsp1_write(vsp1, wpf->entity.index * VI6_WPF_OFFSET +
+			   VI6_WPF_SRCRPF, 0);
 		return 0;
 	}
 
@@ -161,10 +162,10 @@ static int wpf_s_stream(struct v4l2_subdev *subdev, int enable)
 	if (vsp1->pdata.uapi)
 		mutex_unlock(wpf->ctrls.lock);
 
-	vsp1_write(vsp1, VI6_DPR_WPF_FPORCH(wpf->entity.index),
-		   VI6_DPR_WPF_FPORCH_FP_WPFN);
+	vsp1_mod_write(&wpf->entity, VI6_DPR_WPF_FPORCH(wpf->entity.index),
+		       VI6_DPR_WPF_FPORCH_FP_WPFN);
 
-	vsp1_write(vsp1, VI6_WPF_WRBCK_CTRL, 0);
+	vsp1_mod_write(&wpf->entity, VI6_WPF_WRBCK_CTRL, 0);
 
 	/* Enable interrupts */
 	vsp1_write(vsp1, VI6_WPF_IRQ_STA(wpf->entity.index), 0);
-- 
2.4.10

