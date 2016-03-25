Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40677 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbcCYKok (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Mar 2016 06:44:40 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 12/54] v4l: vsp1: Split display list manager from display list
Date: Fri, 25 Mar 2016 12:43:46 +0200
Message-Id: <1458902668-1141-13-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1458902668-1141-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1458902668-1141-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This clarifies the API and prepares display list support for being used
to implement the request API.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1.h        |   1 -
 drivers/media/platform/vsp1/vsp1_dl.c     | 264 ++++++++++++++----------------
 drivers/media/platform/vsp1/vsp1_dl.h     |  40 +++--
 drivers/media/platform/vsp1/vsp1_drm.c    |  32 ++--
 drivers/media/platform/vsp1/vsp1_drm.h    |  12 +-
 drivers/media/platform/vsp1/vsp1_drv.c    |  11 +-
 drivers/media/platform/vsp1/vsp1_entity.c |   2 +-
 drivers/media/platform/vsp1/vsp1_pipe.c   |  13 +-
 drivers/media/platform/vsp1/vsp1_pipe.h   |   5 +-
 9 files changed, 194 insertions(+), 186 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1.h b/drivers/media/platform/vsp1/vsp1.h
index bea232820ead..dae987a11a70 100644
--- a/drivers/media/platform/vsp1/vsp1.h
+++ b/drivers/media/platform/vsp1/vsp1.h
@@ -26,7 +26,6 @@
 struct clk;
 struct device;
 
-struct vsp1_dl;
 struct vsp1_drm;
 struct vsp1_entity;
 struct vsp1_platform_data;
diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index 7f9fe09af92d..72fb667814eb 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -37,117 +37,109 @@ struct vsp1_dl_entry {
 } __attribute__((__packed__));
 
 struct vsp1_dl_list {
-	size_t size;
-	int reg_count;
+	struct list_head list;
 
-	bool in_use;
+	struct vsp1_dl_manager *dlm;
 
 	struct vsp1_dl_entry *body;
 	dma_addr_t dma;
-};
-
-/**
- * struct vsp1_dl - Display List manager
- * @vsp1: the VSP1 device
- * @lock: protects the active, queued and pending lists
- * @lists.all: array of all allocate display lists
- * @lists.active: list currently being processed (loaded) by hardware
- * @lists.queued: list queued to the hardware (written to the DL registers)
- * @lists.pending: list waiting to be queued to the hardware
- * @lists.write: list being written to by software
- */
-struct vsp1_dl {
-	struct vsp1_device *vsp1;
-
-	spinlock_t lock;
-
 	size_t size;
-	dma_addr_t dma;
-	void *mem;
 
-	struct {
-		struct vsp1_dl_list all[VSP1_DL_NUM_LISTS];
-
-		struct vsp1_dl_list *active;
-		struct vsp1_dl_list *queued;
-		struct vsp1_dl_list *pending;
-		struct vsp1_dl_list *write;
-	} lists;
+	int reg_count;
 };
 
 /* -----------------------------------------------------------------------------
  * Display List Transaction Management
  */
 
-static void vsp1_dl_free_list(struct vsp1_dl_list *list)
+static struct vsp1_dl_list *vsp1_dl_list_alloc(struct vsp1_dl_manager *dlm)
 {
-	if (!list)
-		return;
+	struct vsp1_dl_list *dl;
 
-	list->in_use = false;
-}
+	dl = kzalloc(sizeof(*dl), GFP_KERNEL);
+	if (!dl)
+		return NULL;
 
-void vsp1_dl_reset(struct vsp1_dl *dl)
-{
-	unsigned int i;
+	dl->dlm = dlm;
+	dl->size = VSP1_DL_BODY_SIZE;
+
+	dl->body = dma_alloc_writecombine(dlm->vsp1->dev, dl->size, &dl->dma,
+					  GFP_KERNEL);
+	if (!dl->body) {
+		kfree(dl);
+		return NULL;
+	}
 
-	dl->lists.active = NULL;
-	dl->lists.queued = NULL;
-	dl->lists.pending = NULL;
-	dl->lists.write = NULL;
+	return dl;
+}
 
-	for (i = 0; i < ARRAY_SIZE(dl->lists.all); ++i)
-		dl->lists.all[i].in_use = false;
+static void vsp1_dl_list_free(struct vsp1_dl_list *dl)
+{
+	dma_free_writecombine(dl->dlm->vsp1->dev, dl->size, dl->body, dl->dma);
+	kfree(dl);
 }
 
-void vsp1_dl_begin(struct vsp1_dl *dl)
+/**
+ * vsp1_dl_list_get - Get a free display list
+ * @dlm: The display list manager
+ *
+ * Get a display list from the pool of free lists and return it.
+ *
+ * This function must be called without the display list manager lock held.
+ */
+struct vsp1_dl_list *vsp1_dl_list_get(struct vsp1_dl_manager *dlm)
 {
-	struct vsp1_dl_list *list = NULL;
+	struct vsp1_dl_list *dl = NULL;
 	unsigned long flags;
-	unsigned int i;
 
-	spin_lock_irqsave(&dl->lock, flags);
+	spin_lock_irqsave(&dlm->lock, flags);
 
-	for (i = 0; i < ARRAY_SIZE(dl->lists.all); ++i) {
-		if (!dl->lists.all[i].in_use) {
-			list = &dl->lists.all[i];
-			break;
-		}
+	if (!list_empty(&dlm->free)) {
+		dl = list_first_entry(&dlm->free, struct vsp1_dl_list, list);
+		list_del(&dl->list);
 	}
 
-	if (!list) {
-		list = dl->lists.pending;
-		dl->lists.pending = NULL;
-	}
+	spin_unlock_irqrestore(&dlm->lock, flags);
+
+	return dl;
+}
 
-	spin_unlock_irqrestore(&dl->lock, flags);
+/**
+ * vsp1_dl_list_put - Release a display list
+ * @dl: The display list
+ *
+ * Release the display list and return it to the pool of free lists.
+ *
+ * This function must be called with the display list manager lock held.
+ *
+ * Passing a NULL pointer to this function is safe, in that case no operation
+ * will be performed.
+ */
+void vsp1_dl_list_put(struct vsp1_dl_list *dl)
+{
+	if (!dl)
+		return;
 
-	dl->lists.write = list;
+	dl->reg_count = 0;
 
-	list->in_use = true;
-	list->reg_count = 0;
+	list_add_tail(&dl->list, &dl->dlm->free);
 }
 
-void vsp1_dl_add(struct vsp1_dl *dl, u32 reg, u32 data)
+void vsp1_dl_list_write(struct vsp1_dl_list *dl, u32 reg, u32 data)
 {
-	struct vsp1_dl_list *list = dl->lists.write;
-
-	list->body[list->reg_count].addr = reg;
-	list->body[list->reg_count].data = data;
-	list->reg_count++;
+	dl->body[dl->reg_count].addr = reg;
+	dl->body[dl->reg_count].data = data;
+	dl->reg_count++;
 }
 
-void vsp1_dl_commit(struct vsp1_dl *dl)
+void vsp1_dl_list_commit(struct vsp1_dl_list *dl)
 {
-	struct vsp1_device *vsp1 = dl->vsp1;
-	struct vsp1_dl_list *list;
+	struct vsp1_dl_manager *dlm = dl->dlm;
+	struct vsp1_device *vsp1 = dlm->vsp1;
 	unsigned long flags;
 	bool update;
 
-	list = dl->lists.write;
-	dl->lists.write = NULL;
-
-	spin_lock_irqsave(&dl->lock, flags);
+	spin_lock_irqsave(&dlm->lock, flags);
 
 	/* Once the UPD bit has been set the hardware can start processing the
 	 * display list at any time and we can't touch the address and size
@@ -156,8 +148,8 @@ void vsp1_dl_commit(struct vsp1_dl *dl)
 	 */
 	update = !!(vsp1_read(vsp1, VI6_DL_BODY_SIZE) & VI6_DL_BODY_SIZE_UPD);
 	if (update) {
-		vsp1_dl_free_list(dl->lists.pending);
-		dl->lists.pending = list;
+		vsp1_dl_list_put(dlm->pending);
+		dlm->pending = dl;
 		goto done;
 	}
 
@@ -165,42 +157,44 @@ void vsp1_dl_commit(struct vsp1_dl *dl)
 	 * The UPD bit will be cleared by the device when the display list is
 	 * processed.
 	 */
-	vsp1_write(vsp1, VI6_DL_HDR_ADDR(0), list->dma);
+	vsp1_write(vsp1, VI6_DL_HDR_ADDR(0), dl->dma);
 	vsp1_write(vsp1, VI6_DL_BODY_SIZE, VI6_DL_BODY_SIZE_UPD |
-		   (list->reg_count * 8));
+		   (dl->reg_count * 8));
 
-	vsp1_dl_free_list(dl->lists.queued);
-	dl->lists.queued = list;
+	vsp1_dl_list_put(dlm->queued);
+	dlm->queued = dl;
 
 done:
-	spin_unlock_irqrestore(&dl->lock, flags);
+	spin_unlock_irqrestore(&dlm->lock, flags);
 }
 
 /* -----------------------------------------------------------------------------
- * Interrupt Handling
+ * Display List Manager
  */
 
-void vsp1_dl_irq_display_start(struct vsp1_dl *dl)
+/* Interrupt Handling */
+void vsp1_dlm_irq_display_start(struct vsp1_dl_manager *dlm)
 {
-	spin_lock(&dl->lock);
+	spin_lock(&dlm->lock);
 
 	/* The display start interrupt signals the end of the display list
 	 * processing by the device. The active display list, if any, won't be
 	 * accessed anymore and can be reused.
 	 */
-	if (dl->lists.active) {
-		vsp1_dl_free_list(dl->lists.active);
-		dl->lists.active = NULL;
-	}
+	vsp1_dl_list_put(dlm->active);
+	dlm->active = NULL;
 
-	spin_unlock(&dl->lock);
+	spin_unlock(&dlm->lock);
 }
 
-void vsp1_dl_irq_frame_end(struct vsp1_dl *dl)
+void vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm)
 {
-	struct vsp1_device *vsp1 = dl->vsp1;
+	struct vsp1_device *vsp1 = dlm->vsp1;
 
-	spin_lock(&dl->lock);
+	spin_lock(&dlm->lock);
+
+	vsp1_dl_list_put(dlm->active);
+	dlm->active = NULL;
 
 	/* The UPD bit set indicates that the commit operation raced with the
 	 * interrupt and occurred after the frame end event and UPD clear but
@@ -213,35 +207,31 @@ void vsp1_dl_irq_frame_end(struct vsp1_dl *dl)
 	/* The device starts processing the queued display list right after the
 	 * frame end interrupt. The display list thus becomes active.
 	 */
-	if (dl->lists.queued) {
-		WARN_ON(dl->lists.active);
-		dl->lists.active = dl->lists.queued;
-		dl->lists.queued = NULL;
+	if (dlm->queued) {
+		dlm->active = dlm->queued;
+		dlm->queued = NULL;
 	}
 
 	/* Now that the UPD bit has been cleared we can queue the next display
 	 * list to the hardware if one has been prepared.
 	 */
-	if (dl->lists.pending) {
-		struct vsp1_dl_list *list = dl->lists.pending;
+	if (dlm->pending) {
+		struct vsp1_dl_list *dl = dlm->pending;
 
-		vsp1_write(vsp1, VI6_DL_HDR_ADDR(0), list->dma);
+		vsp1_write(vsp1, VI6_DL_HDR_ADDR(0), dl->dma);
 		vsp1_write(vsp1, VI6_DL_BODY_SIZE, VI6_DL_BODY_SIZE_UPD |
-			   (list->reg_count * 8));
+			   (dl->reg_count * 8));
 
-		dl->lists.queued = list;
-		dl->lists.pending = NULL;
+		dlm->queued = dl;
+		dlm->pending = NULL;
 	}
 
 done:
-	spin_unlock(&dl->lock);
+	spin_unlock(&dlm->lock);
 }
 
-/* -----------------------------------------------------------------------------
- * Hardware Setup
- */
-
-void vsp1_dl_setup(struct vsp1_device *vsp1)
+/* Hardware Setup */
+void vsp1_dlm_setup(struct vsp1_device *vsp1)
 {
 	u32 ctrl = (256 << VI6_DL_CTRL_AR_WAIT_SHIFT);
 
@@ -256,46 +246,46 @@ void vsp1_dl_setup(struct vsp1_device *vsp1)
 	vsp1_write(vsp1, VI6_DL_SWAP, VI6_DL_SWAP_LWS);
 }
 
-/* -----------------------------------------------------------------------------
- * Initialization and Cleanup
- */
+void vsp1_dlm_reset(struct vsp1_dl_manager *dlm)
+{
+	vsp1_dl_list_put(dlm->active);
+	vsp1_dl_list_put(dlm->queued);
+	vsp1_dl_list_put(dlm->pending);
+
+	dlm->active = NULL;
+	dlm->queued = NULL;
+	dlm->pending = NULL;
+}
 
-struct vsp1_dl *vsp1_dl_create(struct vsp1_device *vsp1)
+int vsp1_dlm_init(struct vsp1_device *vsp1, struct vsp1_dl_manager *dlm,
+		  unsigned int prealloc)
 {
-	struct vsp1_dl *dl;
 	unsigned int i;
 
-	dl = kzalloc(sizeof(*dl), GFP_KERNEL);
-	if (!dl)
-		return NULL;
-
-	spin_lock_init(&dl->lock);
+	dlm->vsp1 = vsp1;
 
-	dl->vsp1 = vsp1;
-	dl->size = VSP1_DL_BODY_SIZE * ARRAY_SIZE(dl->lists.all);
+	spin_lock_init(&dlm->lock);
+	INIT_LIST_HEAD(&dlm->free);
 
-	dl->mem = dma_alloc_writecombine(vsp1->dev, dl->size, &dl->dma,
-					 GFP_KERNEL);
-	if (!dl->mem) {
-		kfree(dl);
-		return NULL;
-	}
+	for (i = 0; i < prealloc; ++i) {
+		struct vsp1_dl_list *dl;
 
-	for (i = 0; i < ARRAY_SIZE(dl->lists.all); ++i) {
-		struct vsp1_dl_list *list = &dl->lists.all[i];
+		dl = vsp1_dl_list_alloc(dlm);
+		if (!dl)
+			return -ENOMEM;
 
-		list->size = VSP1_DL_BODY_SIZE;
-		list->reg_count = 0;
-		list->in_use = false;
-		list->dma = dl->dma + VSP1_DL_BODY_SIZE * i;
-		list->body = dl->mem + VSP1_DL_BODY_SIZE * i;
+		list_add_tail(&dl->list, &dlm->free);
 	}
 
-	return dl;
+	return 0;
 }
 
-void vsp1_dl_destroy(struct vsp1_dl *dl)
+void vsp1_dlm_cleanup(struct vsp1_dl_manager *dlm)
 {
-	dma_free_writecombine(dl->vsp1->dev, dl->size, dl->mem, dl->dma);
-	kfree(dl);
+	struct vsp1_dl_list *dl, *next;
+
+	list_for_each_entry_safe(dl, next, &dlm->free, list) {
+		list_del(&dl->list);
+		vsp1_dl_list_free(dl);
+	}
 }
diff --git a/drivers/media/platform/vsp1/vsp1_dl.h b/drivers/media/platform/vsp1/vsp1_dl.h
index f4116ca59c28..caa6a85f6825 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.h
+++ b/drivers/media/platform/vsp1/vsp1_dl.h
@@ -16,19 +16,39 @@
 #include <linux/types.h>
 
 struct vsp1_device;
-struct vsp1_dl;
+struct vsp1_dl_list;
 
-struct vsp1_dl *vsp1_dl_create(struct vsp1_device *vsp1);
-void vsp1_dl_destroy(struct vsp1_dl *dl);
+/**
+ * struct vsp1_dl_manager - Display List manager
+ * @vsp1: the VSP1 device
+ * @lock: protects the active, queued and pending lists
+ * @free: array of all free display lists
+ * @active: list currently being processed (loaded) by hardware
+ * @queued: list queued to the hardware (written to the DL registers)
+ * @pending: list waiting to be queued to the hardware
+ */
+struct vsp1_dl_manager {
+	struct vsp1_device *vsp1;
+
+	spinlock_t lock;
+	struct list_head free;
+	struct vsp1_dl_list *active;
+	struct vsp1_dl_list *queued;
+	struct vsp1_dl_list *pending;
+};
 
-void vsp1_dl_setup(struct vsp1_device *vsp1);
+void vsp1_dlm_setup(struct vsp1_device *vsp1);
 
-void vsp1_dl_reset(struct vsp1_dl *dl);
-void vsp1_dl_begin(struct vsp1_dl *dl);
-void vsp1_dl_add(struct vsp1_dl *dl, u32 reg, u32 data);
-void vsp1_dl_commit(struct vsp1_dl *dl);
+int vsp1_dlm_init(struct vsp1_device *vsp1, struct vsp1_dl_manager *dlm,
+		  unsigned int prealloc);
+void vsp1_dlm_cleanup(struct vsp1_dl_manager *dlm);
+void vsp1_dlm_reset(struct vsp1_dl_manager *dlm);
+void vsp1_dlm_irq_display_start(struct vsp1_dl_manager *dlm);
+void vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm);
 
-void vsp1_dl_irq_display_start(struct vsp1_dl *dl);
-void vsp1_dl_irq_frame_end(struct vsp1_dl *dl);
+struct vsp1_dl_list *vsp1_dl_list_get(struct vsp1_dl_manager *dlm);
+void vsp1_dl_list_put(struct vsp1_dl_list *dl);
+void vsp1_dl_list_write(struct vsp1_dl_list *dl, u32 reg, u32 data);
+void vsp1_dl_list_commit(struct vsp1_dl_list *dl);
 
 #endif /* __VSP1_DL_H__ */
diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index 9ecba4c1332e..a8cd74335f20 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -26,6 +26,18 @@
 #include "vsp1_pipe.h"
 #include "vsp1_rwpf.h"
 
+
+/* -----------------------------------------------------------------------------
+ * Interrupt Handling
+ */
+
+void vsp1_drm_frame_end(struct vsp1_pipeline *pipe)
+{
+	struct vsp1_device *vsp1 = pipe->output->entity.vsp1;
+
+	vsp1_dlm_irq_frame_end(&vsp1->drm->dlm);
+}
+
 /* -----------------------------------------------------------------------------
  * DU Driver API
  */
@@ -89,6 +101,7 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int width,
 
 		pipe->num_inputs = 0;
 
+		vsp1_dlm_reset(&vsp1->drm->dlm);
 		vsp1_device_put(vsp1);
 
 		dev_dbg(vsp1->dev, "%s: pipeline disabled\n", __func__);
@@ -96,8 +109,6 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int width,
 		return 0;
 	}
 
-	vsp1_dl_reset(vsp1->drm->dl);
-
 	/* Configure the format at the BRU sinks and propagate it through the
 	 * pipeline.
 	 */
@@ -217,7 +228,7 @@ void vsp1_du_atomic_begin(struct device *dev)
 	spin_unlock_irqrestore(&pipe->irqlock, flags);
 
 	/* Prepare the display list. */
-	vsp1_dl_begin(vsp1->drm->dl);
+	pipe->dl = vsp1_dl_list_get(&vsp1->drm->dlm);
 }
 EXPORT_SYMBOL_GPL(vsp1_du_atomic_begin);
 
@@ -467,7 +478,8 @@ void vsp1_du_atomic_flush(struct device *dev)
 		}
 	}
 
-	vsp1_dl_commit(vsp1->drm->dl);
+	vsp1_dl_list_commit(pipe->dl);
+	pipe->dl = NULL;
 
 	spin_lock_irqsave(&pipe->irqlock, flags);
 
@@ -543,18 +555,20 @@ int vsp1_drm_init(struct vsp1_device *vsp1)
 {
 	struct vsp1_pipeline *pipe;
 	unsigned int i;
+	int ret;
 
 	vsp1->drm = devm_kzalloc(vsp1->dev, sizeof(*vsp1->drm), GFP_KERNEL);
 	if (!vsp1->drm)
 		return -ENOMEM;
 
-	vsp1->drm->dl = vsp1_dl_create(vsp1);
-	if (!vsp1->drm->dl)
-		return -ENOMEM;
+	ret = vsp1_dlm_init(vsp1, &vsp1->drm->dlm, 4);
+	if (ret < 0)
+		return ret;
 
 	pipe = &vsp1->drm->pipe;
 
 	vsp1_pipeline_init(pipe);
+	pipe->frame_end = vsp1_drm_frame_end;
 
 	/* The DRM pipeline is static, add entities manually. */
 	for (i = 0; i < vsp1->info->rpf_count; ++i) {
@@ -571,12 +585,10 @@ int vsp1_drm_init(struct vsp1_device *vsp1)
 	pipe->lif = &vsp1->lif->entity;
 	pipe->output = vsp1->wpf[0];
 
-	pipe->dl = vsp1->drm->dl;
-
 	return 0;
 }
 
 void vsp1_drm_cleanup(struct vsp1_device *vsp1)
 {
-	vsp1_dl_destroy(vsp1->drm->dl);
+	vsp1_dlm_cleanup(&vsp1->drm->dlm);
 }
diff --git a/drivers/media/platform/vsp1/vsp1_drm.h b/drivers/media/platform/vsp1/vsp1_drm.h
index 7704038c3add..5ef32cff9601 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.h
+++ b/drivers/media/platform/vsp1/vsp1_drm.h
@@ -13,26 +13,30 @@
 #ifndef __VSP1_DRM_H__
 #define __VSP1_DRM_H__
 
+#include "vsp1_dl.h"
 #include "vsp1_pipe.h"
 
-struct vsp1_dl;
-
 /**
  * vsp1_drm - State for the API exposed to the DRM driver
- * @dl: display list for DRM pipeline operation
  * @pipe: the VSP1 pipeline used for display
  * @num_inputs: number of active pipeline inputs at the beginning of an update
  * @update: the pipeline configuration has been updated
+ * @dlm: display list manager used for DRM operation
  */
 struct vsp1_drm {
-	struct vsp1_dl *dl;
 	struct vsp1_pipeline pipe;
 	unsigned int num_inputs;
 	bool update;
+	struct vsp1_dl_manager dlm;
 };
 
 int vsp1_drm_init(struct vsp1_device *vsp1);
 void vsp1_drm_cleanup(struct vsp1_device *vsp1);
 int vsp1_drm_create_links(struct vsp1_device *vsp1);
 
+static inline void vsp1_drm_display_start(struct vsp1_device *vsp1)
+{
+	vsp1_dlm_irq_display_start(&vsp1->drm->dlm);
+}
+
 #endif /* __VSP1_DRM_H__ */
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index d657949bac3b..bfdc01c9172d 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -68,14 +68,7 @@ static irqreturn_t vsp1_irq_handler(int irq, void *data)
 	vsp1_write(vsp1, VI6_DISP_IRQ_STA, ~status & VI6_DISP_IRQ_STA_DST);
 
 	if (status & VI6_DISP_IRQ_STA_DST) {
-		struct vsp1_rwpf *wpf = vsp1->wpf[0];
-		struct vsp1_pipeline *pipe;
-
-		if (wpf) {
-			pipe = to_vsp1_pipeline(&wpf->entity.subdev.entity);
-			vsp1_pipeline_display_start(pipe);
-		}
-
+		vsp1_drm_display_start(vsp1);
 		ret = IRQ_HANDLED;
 	}
 
@@ -462,7 +455,7 @@ static int vsp1_device_init(struct vsp1_device *vsp1)
 	vsp1_write(vsp1, VI6_DPR_HGT_SMPPT, (7 << VI6_DPR_SMPPT_TGW_SHIFT) |
 		   (VI6_DPR_NODE_UNUSED << VI6_DPR_SMPPT_PT_SHIFT));
 
-	vsp1_dl_setup(vsp1);
+	vsp1_dlm_setup(vsp1);
 
 	return 0;
 }
diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
index 4006f0d28bac..83689588900a 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.c
+++ b/drivers/media/platform/vsp1/vsp1_entity.c
@@ -28,7 +28,7 @@ void vsp1_mod_write(struct vsp1_entity *e, u32 reg, u32 data)
 	struct vsp1_pipeline *pipe = to_vsp1_pipeline(&e->subdev.entity);
 
 	if (pipe->dl)
-		vsp1_dl_add(pipe->dl, reg, data);
+		vsp1_dl_list_write(pipe->dl, reg, data);
 	else
 		vsp1_write(e->vsp1, reg, data);
 }
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c b/drivers/media/platform/vsp1/vsp1_pipe.c
index 78096122a22d..cb67b8f80635 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.c
+++ b/drivers/media/platform/vsp1/vsp1_pipe.c
@@ -226,7 +226,7 @@ int vsp1_pipeline_stop(struct vsp1_pipeline *pipe)
 	unsigned long flags;
 	int ret;
 
-	if (pipe->dl) {
+	if (pipe->lif) {
 		/* When using display lists in continuous frame mode the only
 		 * way to stop the pipeline is to reset the hardware.
 		 */
@@ -271,12 +271,6 @@ bool vsp1_pipeline_ready(struct vsp1_pipeline *pipe)
 	return pipe->buffers_ready == mask;
 }
 
-void vsp1_pipeline_display_start(struct vsp1_pipeline *pipe)
-{
-	if (pipe->dl)
-		vsp1_dl_irq_display_start(pipe->dl);
-}
-
 void vsp1_pipeline_frame_end(struct vsp1_pipeline *pipe)
 {
 	enum vsp1_pipeline_state state;
@@ -285,9 +279,6 @@ void vsp1_pipeline_frame_end(struct vsp1_pipeline *pipe)
 	if (pipe == NULL)
 		return;
 
-	if (pipe->dl)
-		vsp1_dl_irq_frame_end(pipe->dl);
-
 	/* Signal frame end to the pipeline handler. */
 	if (pipe->frame_end)
 		pipe->frame_end(pipe);
@@ -299,7 +290,7 @@ void vsp1_pipeline_frame_end(struct vsp1_pipeline *pipe)
 	/* When using display lists in continuous frame mode the pipeline is
 	 * automatically restarted by the hardware.
 	 */
-	if (pipe->dl)
+	if (pipe->lif)
 		goto done;
 
 	pipe->state = VSP1_PIPELINE_STOPPED;
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h b/drivers/media/platform/vsp1/vsp1_pipe.h
index b2f3a8a896c9..f4bdfc943add 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.h
+++ b/drivers/media/platform/vsp1/vsp1_pipe.h
@@ -19,7 +19,7 @@
 
 #include <media/media-entity.h>
 
-struct vsp1_dl;
+struct vsp1_dl_list;
 struct vsp1_rwpf;
 
 /*
@@ -100,7 +100,7 @@ struct vsp1_pipeline {
 
 	struct list_head entities;
 
-	struct vsp1_dl *dl;
+	struct vsp1_dl_list *dl;
 };
 
 static inline struct vsp1_pipeline *to_vsp1_pipeline(struct media_entity *e)
@@ -119,7 +119,6 @@ bool vsp1_pipeline_stopped(struct vsp1_pipeline *pipe);
 int vsp1_pipeline_stop(struct vsp1_pipeline *pipe);
 bool vsp1_pipeline_ready(struct vsp1_pipeline *pipe);
 
-void vsp1_pipeline_display_start(struct vsp1_pipeline *pipe);
 void vsp1_pipeline_frame_end(struct vsp1_pipeline *pipe);
 
 void vsp1_pipeline_propagate_alpha(struct vsp1_pipeline *pipe,
-- 
2.7.3

