Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52106 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754834AbeCHAFh (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Mar 2018 19:05:37 -0500
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v7 1/8] media: vsp1: Reword uses of 'fragment' as 'body'
Date: Thu,  8 Mar 2018 00:05:24 +0000
Message-Id: <4b6be5632b722a40c634b85fc67b38a9d44b9dbf.1520466993.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.636c1ee27fc6973cc312e0f25131a435872a0a35.1520466993.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.636c1ee27fc6973cc312e0f25131a435872a0a35.1520466993.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.636c1ee27fc6973cc312e0f25131a435872a0a35.1520466993.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.636c1ee27fc6973cc312e0f25131a435872a0a35.1520466993.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Throughout the codebase, the term 'fragment' is used to represent a
display list body. This term duplicates the 'body' which is already in
use.

The datasheet references these objects as a body, therefore replace all
mentions of a fragment with a body, along with the corresponding
pluralised terms.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

---
v7
 - Clean up the formatting of the vsp1_dl_list_add_body()

 drivers/media/platform/vsp1/vsp1_clu.c |  10 +-
 drivers/media/platform/vsp1/vsp1_dl.c  | 109 ++++++++++++--------------
 drivers/media/platform/vsp1/vsp1_dl.h  |  13 +--
 drivers/media/platform/vsp1/vsp1_lut.c |   8 +-
 4 files changed, 69 insertions(+), 71 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_clu.c b/drivers/media/platform/vsp1/vsp1_clu.c
index f2fb26e5ab4e..9621afa3658c 100644
--- a/drivers/media/platform/vsp1/vsp1_clu.c
+++ b/drivers/media/platform/vsp1/vsp1_clu.c
@@ -47,19 +47,19 @@ static int clu_set_table(struct vsp1_clu *clu, struct v4l2_ctrl *ctrl)
 	struct vsp1_dl_body *dlb;
 	unsigned int i;
 
-	dlb = vsp1_dl_fragment_alloc(clu->entity.vsp1, 1 + 17 * 17 * 17);
+	dlb = vsp1_dl_body_alloc(clu->entity.vsp1, 1 + 17 * 17 * 17);
 	if (!dlb)
 		return -ENOMEM;
 
-	vsp1_dl_fragment_write(dlb, VI6_CLU_ADDR, 0);
+	vsp1_dl_body_write(dlb, VI6_CLU_ADDR, 0);
 	for (i = 0; i < 17 * 17 * 17; ++i)
-		vsp1_dl_fragment_write(dlb, VI6_CLU_DATA, ctrl->p_new.p_u32[i]);
+		vsp1_dl_body_write(dlb, VI6_CLU_DATA, ctrl->p_new.p_u32[i]);
 
 	spin_lock_irq(&clu->lock);
 	swap(clu->clu, dlb);
 	spin_unlock_irq(&clu->lock);
 
-	vsp1_dl_fragment_free(dlb);
+	vsp1_dl_body_free(dlb);
 	return 0;
 }
 
@@ -256,7 +256,7 @@ static void clu_configure(struct vsp1_entity *entity,
 		spin_unlock_irqrestore(&clu->lock, flags);
 
 		if (dlb)
-			vsp1_dl_list_add_fragment(dl, dlb);
+			vsp1_dl_list_add_body(dl, dlb);
 		break;
 	}
 }
diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index 0b86ed01e85d..caed441f5f0c 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -69,7 +69,7 @@ struct vsp1_dl_body {
  * @header: display list header, NULL for headerless lists
  * @dma: DMA address for the header
  * @body0: first display list body
- * @fragments: list of extra display list bodies
+ * @bodies: list of extra display list bodies
  * @has_chain: if true, indicates that there's a partition chain
  * @chain: entry in the display list partition chain
  */
@@ -81,7 +81,7 @@ struct vsp1_dl_list {
 	dma_addr_t dma;
 
 	struct vsp1_dl_body body0;
-	struct list_head fragments;
+	struct list_head bodies;
 
 	bool has_chain;
 	struct list_head chain;
@@ -98,13 +98,13 @@ enum vsp1_dl_mode {
  * @mode: display list operation mode (header or headerless)
  * @singleshot: execute the display list in single-shot mode
  * @vsp1: the VSP1 device
- * @lock: protects the free, active, queued, pending and gc_fragments lists
+ * @lock: protects the free, active, queued, pending and gc_bodies lists
  * @free: array of all free display lists
  * @active: list currently being processed (loaded) by hardware
  * @queued: list queued to the hardware (written to the DL registers)
  * @pending: list waiting to be queued to the hardware
- * @gc_work: fragments garbage collector work struct
- * @gc_fragments: array of display list fragments waiting to be freed
+ * @gc_work: bodies garbage collector work struct
+ * @gc_bodies: array of display list bodies waiting to be freed
  */
 struct vsp1_dl_manager {
 	unsigned int index;
@@ -119,7 +119,7 @@ struct vsp1_dl_manager {
 	struct vsp1_dl_list *pending;
 
 	struct work_struct gc_work;
-	struct list_head gc_fragments;
+	struct list_head gc_bodies;
 };
 
 /* -----------------------------------------------------------------------------
@@ -157,17 +157,16 @@ static void vsp1_dl_body_cleanup(struct vsp1_dl_body *dlb)
 }
 
 /**
- * vsp1_dl_fragment_alloc - Allocate a display list fragment
+ * vsp1_dl_body_alloc - Allocate a display list body
  * @vsp1: The VSP1 device
- * @num_entries: The maximum number of entries that the fragment can contain
+ * @num_entries: The maximum number of entries that the body can contain
  *
- * Allocate a display list fragment with enough memory to contain the requested
+ * Allocate a display list body with enough memory to contain the requested
  * number of entries.
  *
- * Return a pointer to a fragment on success or NULL if memory can't be
- * allocated.
+ * Return a pointer to a body on success or NULL if memory can't be allocated.
  */
-struct vsp1_dl_body *vsp1_dl_fragment_alloc(struct vsp1_device *vsp1,
+struct vsp1_dl_body *vsp1_dl_body_alloc(struct vsp1_device *vsp1,
 					    unsigned int num_entries)
 {
 	struct vsp1_dl_body *dlb;
@@ -187,20 +186,20 @@ struct vsp1_dl_body *vsp1_dl_fragment_alloc(struct vsp1_device *vsp1,
 }
 
 /**
- * vsp1_dl_fragment_free - Free a display list fragment
- * @dlb: The fragment
+ * vsp1_dl_body_free - Free a display list body
+ * @dlb: The body
  *
- * Free the given display list fragment and the associated DMA memory.
+ * Free the given display list body and the associated DMA memory.
  *
- * Fragments must only be freed explicitly if they are not added to a display
+ * Bodies must only be freed explicitly if they are not added to a display
  * list, as the display list will take ownership of them and free them
- * otherwise. Manual free typically happens at cleanup time for fragments that
+ * otherwise. Manual free typically happens at cleanup time for bodies that
  * have been allocated but not used.
  *
  * Passing a NULL pointer to this function is safe, in that case no operation
  * will be performed.
  */
-void vsp1_dl_fragment_free(struct vsp1_dl_body *dlb)
+void vsp1_dl_body_free(struct vsp1_dl_body *dlb)
 {
 	if (!dlb)
 		return;
@@ -210,16 +209,16 @@ void vsp1_dl_fragment_free(struct vsp1_dl_body *dlb)
 }
 
 /**
- * vsp1_dl_fragment_write - Write a register to a display list fragment
- * @dlb: The fragment
+ * vsp1_dl_body_write - Write a register to a display list body
+ * @dlb: The body
  * @reg: The register address
  * @data: The register value
  *
- * Write the given register and value to the display list fragment. The maximum
- * number of entries that can be written in a fragment is specified when the
- * fragment is allocated by vsp1_dl_fragment_alloc().
+ * Write the given register and value to the display list body. The maximum
+ * number of entries that can be written in a body is specified when the body is
+ * allocated by vsp1_dl_body_alloc().
  */
-void vsp1_dl_fragment_write(struct vsp1_dl_body *dlb, u32 reg, u32 data)
+void vsp1_dl_body_write(struct vsp1_dl_body *dlb, u32 reg, u32 data)
 {
 	dlb->entries[dlb->num_entries].addr = reg;
 	dlb->entries[dlb->num_entries].data = data;
@@ -240,7 +239,7 @@ static struct vsp1_dl_list *vsp1_dl_list_alloc(struct vsp1_dl_manager *dlm)
 	if (!dl)
 		return NULL;
 
-	INIT_LIST_HEAD(&dl->fragments);
+	INIT_LIST_HEAD(&dl->bodies);
 	dl->dlm = dlm;
 
 	/*
@@ -277,7 +276,7 @@ static struct vsp1_dl_list *vsp1_dl_list_alloc(struct vsp1_dl_manager *dlm)
 static void vsp1_dl_list_free(struct vsp1_dl_list *dl)
 {
 	vsp1_dl_body_cleanup(&dl->body0);
-	list_splice_init(&dl->fragments, &dl->dlm->gc_fragments);
+	list_splice_init(&dl->bodies, &dl->dlm->gc_bodies);
 	kfree(dl);
 }
 
@@ -332,13 +331,13 @@ static void __vsp1_dl_list_put(struct vsp1_dl_list *dl)
 	dl->has_chain = false;
 
 	/*
-	 * We can't free fragments here as DMA memory can only be freed in
-	 * interruptible context. Move all fragments to the display list
-	 * manager's list of fragments to be freed, they will be
-	 * garbage-collected by the work queue.
+	 * We can't free bodies here as DMA memory can only be freed in
+	 * interruptible context. Move all bodies to the display list manager's
+	 * list of bodies to be freed, they will be garbage-collected by the
+	 * work queue.
 	 */
-	if (!list_empty(&dl->fragments)) {
-		list_splice_init(&dl->fragments, &dl->dlm->gc_fragments);
+	if (!list_empty(&dl->bodies)) {
+		list_splice_init(&dl->bodies, &dl->dlm->gc_bodies);
 		schedule_work(&dl->dlm->gc_work);
 	}
 
@@ -379,33 +378,33 @@ void vsp1_dl_list_put(struct vsp1_dl_list *dl)
  */
 void vsp1_dl_list_write(struct vsp1_dl_list *dl, u32 reg, u32 data)
 {
-	vsp1_dl_fragment_write(&dl->body0, reg, data);
+	vsp1_dl_body_write(&dl->body0, reg, data);
 }
 
 /**
- * vsp1_dl_list_add_fragment - Add a fragment to the display list
+ * vsp1_dl_list_add_body - Add a body to the display list
  * @dl: The display list
- * @dlb: The fragment
+ * @dlb: The body
  *
- * Add a display list body as a fragment to a display list. Registers contained
- * in fragments are processed after registers contained in the main display
- * list, in the order in which fragments are added.
+ * Add a display list body as a body to a display list. Registers contained
+ * in bodies are processed after registers contained in the main display list,
+ * in the order in which bodies are added.
  *
- * Adding a fragment to a display list passes ownership of the fragment to the
- * list. The caller must not touch the fragment after this call, and must not
- * free it explicitly with vsp1_dl_fragment_free().
+ * Adding a body to a display list passes ownership of the body to the list. The
+ * caller must not touch the body after this call, and must not free it
+ * explicitly with vsp1_dl_body_free().
  *
- * Fragments are only usable for display lists in header mode. Attempt to
- * add a fragment to a header-less display list will return an error.
+ * Additional bodies are only usable for display lists in header mode.
+ * Attempting to add a body to a header-less display list will return an error.
  */
-int vsp1_dl_list_add_fragment(struct vsp1_dl_list *dl,
-			      struct vsp1_dl_body *dlb)
+int vsp1_dl_list_add_body(struct vsp1_dl_list *dl, struct vsp1_dl_body *dlb)
 {
 	/* Multi-body lists are only available in header mode. */
 	if (dl->dlm->mode != VSP1_DL_MODE_HEADER)
 		return -EINVAL;
 
-	list_add_tail(&dlb->list, &dl->fragments);
+	list_add_tail(&dlb->list, &dl->bodies);
+
 	return 0;
 }
 
@@ -454,7 +453,7 @@ static void vsp1_dl_list_fill_header(struct vsp1_dl_list *dl, bool is_last)
 	hdr->num_bytes = dl->body0.num_entries
 		       * sizeof(*dl->header->lists);
 
-	list_for_each_entry(dlb, &dl->fragments, list) {
+	list_for_each_entry(dlb, &dl->bodies, list) {
 		num_lists++;
 		hdr++;
 
@@ -711,25 +710,25 @@ void vsp1_dlm_reset(struct vsp1_dl_manager *dlm)
 }
 
 /*
- * Free all fragments awaiting to be garbage-collected.
+ * Free all bodies awaiting to be garbage-collected.
  *
  * This function must be called without the display list manager lock held.
  */
-static void vsp1_dlm_fragments_free(struct vsp1_dl_manager *dlm)
+static void vsp1_dlm_bodies_free(struct vsp1_dl_manager *dlm)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&dlm->lock, flags);
 
-	while (!list_empty(&dlm->gc_fragments)) {
+	while (!list_empty(&dlm->gc_bodies)) {
 		struct vsp1_dl_body *dlb;
 
-		dlb = list_first_entry(&dlm->gc_fragments, struct vsp1_dl_body,
+		dlb = list_first_entry(&dlm->gc_bodies, struct vsp1_dl_body,
 				       list);
 		list_del(&dlb->list);
 
 		spin_unlock_irqrestore(&dlm->lock, flags);
-		vsp1_dl_fragment_free(dlb);
+		vsp1_dl_body_free(dlb);
 		spin_lock_irqsave(&dlm->lock, flags);
 	}
 
@@ -741,7 +740,7 @@ static void vsp1_dlm_garbage_collect(struct work_struct *work)
 	struct vsp1_dl_manager *dlm =
 		container_of(work, struct vsp1_dl_manager, gc_work);
 
-	vsp1_dlm_fragments_free(dlm);
+	vsp1_dlm_bodies_free(dlm);
 }
 
 struct vsp1_dl_manager *vsp1_dlm_create(struct vsp1_device *vsp1,
@@ -763,7 +762,7 @@ struct vsp1_dl_manager *vsp1_dlm_create(struct vsp1_device *vsp1,
 
 	spin_lock_init(&dlm->lock);
 	INIT_LIST_HEAD(&dlm->free);
-	INIT_LIST_HEAD(&dlm->gc_fragments);
+	INIT_LIST_HEAD(&dlm->gc_bodies);
 	INIT_WORK(&dlm->gc_work, vsp1_dlm_garbage_collect);
 
 	for (i = 0; i < prealloc; ++i) {
@@ -793,5 +792,5 @@ void vsp1_dlm_destroy(struct vsp1_dl_manager *dlm)
 		vsp1_dl_list_free(dl);
 	}
 
-	vsp1_dlm_fragments_free(dlm);
+	vsp1_dlm_bodies_free(dlm);
 }
diff --git a/drivers/media/platform/vsp1/vsp1_dl.h b/drivers/media/platform/vsp1/vsp1_dl.h
index ee3508172f0a..cf57f986b69a 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.h
+++ b/drivers/media/platform/vsp1/vsp1_dl.h
@@ -16,7 +16,7 @@
 #include <linux/types.h>
 
 struct vsp1_device;
-struct vsp1_dl_fragment;
+struct vsp1_dl_body;
 struct vsp1_dl_list;
 struct vsp1_dl_manager;
 
@@ -34,12 +34,11 @@ void vsp1_dl_list_put(struct vsp1_dl_list *dl);
 void vsp1_dl_list_write(struct vsp1_dl_list *dl, u32 reg, u32 data);
 void vsp1_dl_list_commit(struct vsp1_dl_list *dl);
 
-struct vsp1_dl_body *vsp1_dl_fragment_alloc(struct vsp1_device *vsp1,
-					    unsigned int num_entries);
-void vsp1_dl_fragment_free(struct vsp1_dl_body *dlb);
-void vsp1_dl_fragment_write(struct vsp1_dl_body *dlb, u32 reg, u32 data);
-int vsp1_dl_list_add_fragment(struct vsp1_dl_list *dl,
-			      struct vsp1_dl_body *dlb);
+struct vsp1_dl_body *vsp1_dl_body_alloc(struct vsp1_device *vsp1,
+					unsigned int num_entries);
+void vsp1_dl_body_free(struct vsp1_dl_body *dlb);
+void vsp1_dl_body_write(struct vsp1_dl_body *dlb, u32 reg, u32 data);
+int vsp1_dl_list_add_body(struct vsp1_dl_list *dl, struct vsp1_dl_body *dlb);
 int vsp1_dl_list_add_chain(struct vsp1_dl_list *head, struct vsp1_dl_list *dl);
 
 #endif /* __VSP1_DL_H__ */
diff --git a/drivers/media/platform/vsp1/vsp1_lut.c b/drivers/media/platform/vsp1/vsp1_lut.c
index c67cc60db0db..aa2b40327529 100644
--- a/drivers/media/platform/vsp1/vsp1_lut.c
+++ b/drivers/media/platform/vsp1/vsp1_lut.c
@@ -44,19 +44,19 @@ static int lut_set_table(struct vsp1_lut *lut, struct v4l2_ctrl *ctrl)
 	struct vsp1_dl_body *dlb;
 	unsigned int i;
 
-	dlb = vsp1_dl_fragment_alloc(lut->entity.vsp1, 256);
+	dlb = vsp1_dl_body_alloc(lut->entity.vsp1, 256);
 	if (!dlb)
 		return -ENOMEM;
 
 	for (i = 0; i < 256; ++i)
-		vsp1_dl_fragment_write(dlb, VI6_LUT_TABLE + 4 * i,
+		vsp1_dl_body_write(dlb, VI6_LUT_TABLE + 4 * i,
 				       ctrl->p_new.p_u32[i]);
 
 	spin_lock_irq(&lut->lock);
 	swap(lut->lut, dlb);
 	spin_unlock_irq(&lut->lock);
 
-	vsp1_dl_fragment_free(dlb);
+	vsp1_dl_body_free(dlb);
 	return 0;
 }
 
@@ -212,7 +212,7 @@ static void lut_configure(struct vsp1_entity *entity,
 		spin_unlock_irqrestore(&lut->lock, flags);
 
 		if (dlb)
-			vsp1_dl_list_add_fragment(dl, dlb);
+			vsp1_dl_list_add_body(dl, dlb);
 		break;
 	}
 }
-- 
git-series 0.9.1
