Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751590AbdHNPNo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Aug 2017 11:13:44 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: laurent.pinchart@ideasonboard.com,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v2 3/8] v4l: vsp1: Convert display lists to use new fragment pool
Date: Mon, 14 Aug 2017 16:13:26 +0100
Message-Id: <b15a5776bf062f26bdc6ae580414cd9252d900e3.1502723341.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.4457988ad8b64b5c7636e35039ef61d507af3648.1502723341.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.4457988ad8b64b5c7636e35039ef61d507af3648.1502723341.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.4457988ad8b64b5c7636e35039ef61d507af3648.1502723341.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.4457988ad8b64b5c7636e35039ef61d507af3648.1502723341.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adapt the dl->body0 object to use an object from the fragment pool.
This greatly reduces the pressure on the TLB for IPMMU use cases, as
all of the lists use a single allocation for the main body.

The CLU and LUT objects pre-allocate a pool containing two bodies,
allowing a userspace update before the hardware has committed a previous
set of tables.

Fragments are no longer 'freed' in interrupt context, but instead
released back to their respective pools.  This allows us to remove the
garbage collector in the DLM.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

---
v2:
 - Use dl->body0->max_entries to determine header offset, instead of the
   global constant VSP1_DL_NUM_ENTRIES which is incorrect.
 - squash updates for LUT, CLU, and fragment cleanup into single patch.
   (Not fully bisectable when separated)
---
 drivers/media/platform/vsp1/vsp1_clu.c |  22 ++-
 drivers/media/platform/vsp1/vsp1_clu.h |   1 +-
 drivers/media/platform/vsp1/vsp1_dl.c  | 223 +++++---------------------
 drivers/media/platform/vsp1/vsp1_dl.h  |   3 +-
 drivers/media/platform/vsp1/vsp1_lut.c |  23 ++-
 drivers/media/platform/vsp1/vsp1_lut.h |   1 +-
 6 files changed, 90 insertions(+), 183 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_clu.c b/drivers/media/platform/vsp1/vsp1_clu.c
index f2fb26e5ab4e..52c523625e2f 100644
--- a/drivers/media/platform/vsp1/vsp1_clu.c
+++ b/drivers/media/platform/vsp1/vsp1_clu.c
@@ -23,6 +23,8 @@
 #define CLU_MIN_SIZE				4U
 #define CLU_MAX_SIZE				8190U
 
+#define CLU_SIZE				(17 * 17 * 17)
+
 /* -----------------------------------------------------------------------------
  * Device Access
  */
@@ -47,19 +49,19 @@ static int clu_set_table(struct vsp1_clu *clu, struct v4l2_ctrl *ctrl)
 	struct vsp1_dl_body *dlb;
 	unsigned int i;
 
-	dlb = vsp1_dl_fragment_alloc(clu->entity.vsp1, 1 + 17 * 17 * 17);
+	dlb = vsp1_dl_fragment_get(clu->pool);
 	if (!dlb)
 		return -ENOMEM;
 
 	vsp1_dl_fragment_write(dlb, VI6_CLU_ADDR, 0);
-	for (i = 0; i < 17 * 17 * 17; ++i)
+	for (i = 0; i < CLU_SIZE; ++i)
 		vsp1_dl_fragment_write(dlb, VI6_CLU_DATA, ctrl->p_new.p_u32[i]);
 
 	spin_lock_irq(&clu->lock);
 	swap(clu->clu, dlb);
 	spin_unlock_irq(&clu->lock);
 
-	vsp1_dl_fragment_free(dlb);
+	vsp1_dl_fragment_put(dlb);
 	return 0;
 }
 
@@ -261,8 +263,16 @@ static void clu_configure(struct vsp1_entity *entity,
 	}
 }
 
+static void clu_destroy(struct vsp1_entity *entity)
+{
+	struct vsp1_clu *clu = to_clu(&entity->subdev);
+
+	vsp1_dl_fragment_pool_free(clu->pool);
+}
+
 static const struct vsp1_entity_operations clu_entity_ops = {
 	.configure = clu_configure,
+	.destroy = clu_destroy,
 };
 
 /* -----------------------------------------------------------------------------
@@ -288,6 +298,12 @@ struct vsp1_clu *vsp1_clu_create(struct vsp1_device *vsp1)
 	if (ret < 0)
 		return ERR_PTR(ret);
 
+	/* Allocate a fragment pool */
+	clu->pool = vsp1_dl_fragment_pool_alloc(clu->entity.vsp1, 2,
+						CLU_SIZE + 1, 0);
+	if (!clu->pool)
+		return ERR_PTR(-ENOMEM);
+
 	/* Initialize the control handler. */
 	v4l2_ctrl_handler_init(&clu->ctrls, 2);
 	v4l2_ctrl_new_custom(&clu->ctrls, &clu_table_control, NULL);
diff --git a/drivers/media/platform/vsp1/vsp1_clu.h b/drivers/media/platform/vsp1/vsp1_clu.h
index 036e0a2f1a42..601ffb558e30 100644
--- a/drivers/media/platform/vsp1/vsp1_clu.h
+++ b/drivers/media/platform/vsp1/vsp1_clu.h
@@ -36,6 +36,7 @@ struct vsp1_clu {
 	spinlock_t lock;
 	unsigned int mode;
 	struct vsp1_dl_body *clu;
+	struct vsp1_dl_fragment_pool *pool;
 };
 
 static inline struct vsp1_clu *to_clu(struct v4l2_subdev *subdev)
diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index aab9dd6ec0eb..6ffdc3549283 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -110,7 +110,7 @@ struct vsp1_dl_list {
 	struct vsp1_dl_header *header;
 	dma_addr_t dma;
 
-	struct vsp1_dl_body body0;
+	struct vsp1_dl_body *body0;
 	struct list_head fragments;
 
 	bool has_chain;
@@ -134,8 +134,6 @@ enum vsp1_dl_mode {
  * @queued: list queued to the hardware (written to the DL registers)
  * @pending: list waiting to be queued to the hardware
  * @pool: fragment pool for the display list bodies
- * @gc_work: fragments garbage collector work struct
- * @gc_fragments: array of display list fragments waiting to be freed
  */
 struct vsp1_dl_manager {
 	unsigned int index;
@@ -150,9 +148,6 @@ struct vsp1_dl_manager {
 	struct vsp1_dl_list *pending;
 
 	struct vsp1_dl_fragment_pool *pool;
-
-	struct work_struct gc_work;
-	struct list_head gc_fragments;
 };
 
 /* -----------------------------------------------------------------------------
@@ -256,90 +251,6 @@ void vsp1_dl_fragment_put(struct vsp1_dl_body *dlb)
 	spin_unlock_irqrestore(&dlb->pool->lock, flags);
 }
 
-/*
- * Initialize a display list body object and allocate DMA memory for the body
- * data. The display list body object is expected to have been initialized to
- * 0 when allocated.
- */
-static int vsp1_dl_body_init(struct vsp1_device *vsp1,
-			     struct vsp1_dl_body *dlb, unsigned int num_entries,
-			     size_t extra_size)
-{
-	size_t size = num_entries * sizeof(*dlb->entries) + extra_size;
-
-	dlb->vsp1 = vsp1;
-	dlb->size = size;
-	dlb->max_entries = num_entries;
-
-	dlb->entries = dma_alloc_wc(vsp1->bus_master, dlb->size, &dlb->dma,
-				    GFP_KERNEL);
-	if (!dlb->entries)
-		return -ENOMEM;
-
-	return 0;
-}
-
-/*
- * Cleanup a display list body and free allocated DMA memory allocated.
- */
-static void vsp1_dl_body_cleanup(struct vsp1_dl_body *dlb)
-{
-	dma_free_wc(dlb->vsp1->bus_master, dlb->size, dlb->entries, dlb->dma);
-}
-
-/**
- * vsp1_dl_fragment_alloc - Allocate a display list fragment
- * @vsp1: The VSP1 device
- * @num_entries: The maximum number of entries that the fragment can contain
- *
- * Allocate a display list fragment with enough memory to contain the requested
- * number of entries.
- *
- * Return a pointer to a fragment on success or NULL if memory can't be
- * allocated.
- */
-struct vsp1_dl_body *vsp1_dl_fragment_alloc(struct vsp1_device *vsp1,
-					    unsigned int num_entries)
-{
-	struct vsp1_dl_body *dlb;
-	int ret;
-
-	dlb = kzalloc(sizeof(*dlb), GFP_KERNEL);
-	if (!dlb)
-		return NULL;
-
-	ret = vsp1_dl_body_init(vsp1, dlb, num_entries, 0);
-	if (ret < 0) {
-		kfree(dlb);
-		return NULL;
-	}
-
-	return dlb;
-}
-
-/**
- * vsp1_dl_fragment_free - Free a display list fragment
- * @dlb: The fragment
- *
- * Free the given display list fragment and the associated DMA memory.
- *
- * Fragments must only be freed explicitly if they are not added to a display
- * list, as the display list will take ownership of them and free them
- * otherwise. Manual free typically happens at cleanup time for fragments that
- * have been allocated but not used.
- *
- * Passing a NULL pointer to this function is safe, in that case no operation
- * will be performed.
- */
-void vsp1_dl_fragment_free(struct vsp1_dl_body *dlb)
-{
-	if (!dlb)
-		return;
-
-	vsp1_dl_body_cleanup(dlb);
-	kfree(dlb);
-}
-
 /**
  * vsp1_dl_fragment_write - Write a register to a display list fragment
  * @dlb: The fragment
@@ -366,11 +277,10 @@ void vsp1_dl_fragment_write(struct vsp1_dl_body *dlb, u32 reg, u32 data)
  * Display List Transaction Management
  */
 
-static struct vsp1_dl_list *vsp1_dl_list_alloc(struct vsp1_dl_manager *dlm)
+static struct vsp1_dl_list *vsp1_dl_list_alloc(struct vsp1_dl_manager *dlm,
+					struct vsp1_dl_fragment_pool *pool)
 {
 	struct vsp1_dl_list *dl;
-	size_t header_size;
-	int ret;
 
 	dl = kzalloc(sizeof(*dl), GFP_KERNEL);
 	if (!dl)
@@ -379,41 +289,39 @@ static struct vsp1_dl_list *vsp1_dl_list_alloc(struct vsp1_dl_manager *dlm)
 	INIT_LIST_HEAD(&dl->fragments);
 	dl->dlm = dlm;
 
-	/*
-	 * Initialize the display list body and allocate DMA memory for the body
-	 * and the optional header. Both are allocated together to avoid memory
-	 * fragmentation, with the header located right after the body in
-	 * memory.
-	 */
-	header_size = dlm->mode == VSP1_DL_MODE_HEADER
-		    ? ALIGN(sizeof(struct vsp1_dl_header), 8)
-		    : 0;
-
-	ret = vsp1_dl_body_init(dlm->vsp1, &dl->body0, VSP1_DL_NUM_ENTRIES,
-				header_size);
-	if (ret < 0) {
-		kfree(dl);
+	/* Retrieve a body from our DLM body pool */
+	dl->body0 = vsp1_dl_fragment_get(pool);
+	if (!dl->body0)
 		return NULL;
-	}
-
 	if (dlm->mode == VSP1_DL_MODE_HEADER) {
-		size_t header_offset = VSP1_DL_NUM_ENTRIES
-				     * sizeof(*dl->body0.entries);
+		size_t header_offset = dl->body0->max_entries
+				     * sizeof(*dl->body0->entries);
 
-		dl->header = ((void *)dl->body0.entries) + header_offset;
-		dl->dma = dl->body0.dma + header_offset;
+		dl->header = ((void *)dl->body0->entries) + header_offset;
+		dl->dma = dl->body0->dma + header_offset;
 
 		memset(dl->header, 0, sizeof(*dl->header));
-		dl->header->lists[0].addr = dl->body0.dma;
+		dl->header->lists[0].addr = dl->body0->dma;
 	}
 
 	return dl;
 }
 
+static void vsp1_dl_list_fragments_free(struct vsp1_dl_list *dl)
+{
+	struct vsp1_dl_body *dlb, *tmp;
+
+	list_for_each_entry_safe(dlb, tmp, &dl->fragments, list) {
+		list_del(&dlb->list);
+		vsp1_dl_fragment_put(dlb);
+	}
+}
+
 static void vsp1_dl_list_free(struct vsp1_dl_list *dl)
 {
-	vsp1_dl_body_cleanup(&dl->body0);
-	list_splice_init(&dl->fragments, &dl->dlm->gc_fragments);
+	vsp1_dl_fragment_put(dl->body0);
+	vsp1_dl_list_fragments_free(dl);
+
 	kfree(dl);
 }
 
@@ -467,18 +375,10 @@ static void __vsp1_dl_list_put(struct vsp1_dl_list *dl)
 
 	dl->has_chain = false;
 
-	/*
-	 * We can't free fragments here as DMA memory can only be freed in
-	 * interruptible context. Move all fragments to the display list
-	 * manager's list of fragments to be freed, they will be
-	 * garbage-collected by the work queue.
-	 */
-	if (!list_empty(&dl->fragments)) {
-		list_splice_init(&dl->fragments, &dl->dlm->gc_fragments);
-		schedule_work(&dl->dlm->gc_work);
-	}
+	vsp1_dl_list_fragments_free(dl);
 
-	dl->body0.num_entries = 0;
+	/* body0 is reused */
+	dl->body0->num_entries = 0;
 
 	list_add_tail(&dl->list, &dl->dlm->free);
 }
@@ -515,7 +415,7 @@ void vsp1_dl_list_put(struct vsp1_dl_list *dl)
  */
 void vsp1_dl_list_write(struct vsp1_dl_list *dl, u32 reg, u32 data)
 {
-	vsp1_dl_fragment_write(&dl->body0, reg, data);
+	vsp1_dl_fragment_write(dl->body0, reg, data);
 }
 
 /**
@@ -528,8 +428,7 @@ void vsp1_dl_list_write(struct vsp1_dl_list *dl, u32 reg, u32 data)
  * list, in the order in which fragments are added.
  *
  * Adding a fragment to a display list passes ownership of the fragment to the
- * list. The caller must not touch the fragment after this call, and must not
- * free it explicitly with vsp1_dl_fragment_free().
+ * list. The caller must not touch the fragment after this call.
  *
  * Fragments are only usable for display lists in header mode. Attempt to
  * add a fragment to a header-less display list will return an error.
@@ -587,7 +486,7 @@ static void vsp1_dl_list_fill_header(struct vsp1_dl_list *dl, bool is_last)
 	 * list was allocated.
 	 */
 
-	hdr->num_bytes = dl->body0.num_entries
+	hdr->num_bytes = dl->body0->num_entries
 		       * sizeof(*dl->header->lists);
 
 	list_for_each_entry(dlb, &dl->fragments, list) {
@@ -660,9 +559,9 @@ static void vsp1_dl_list_hw_enqueue(struct vsp1_dl_list *dl)
 		 * bit will be cleared by the hardware when the display list
 		 * processing starts.
 		 */
-		vsp1_write(vsp1, VI6_DL_HDR_ADDR(0), dl->body0.dma);
+		vsp1_write(vsp1, VI6_DL_HDR_ADDR(0), dl->body0->dma);
 		vsp1_write(vsp1, VI6_DL_BODY_SIZE, VI6_DL_BODY_SIZE_UPD |
-			   (dl->body0.num_entries * sizeof(*dl->header->lists)));
+			   (dl->body0->num_entries * sizeof(*dl->header->lists)));
 	} else {
 		/*
 		 * In header mode, program the display list header address. If
@@ -845,45 +744,12 @@ void vsp1_dlm_reset(struct vsp1_dl_manager *dlm)
 	dlm->pending = NULL;
 }
 
-/*
- * Free all fragments awaiting to be garbage-collected.
- *
- * This function must be called without the display list manager lock held.
- */
-static void vsp1_dlm_fragments_free(struct vsp1_dl_manager *dlm)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&dlm->lock, flags);
-
-	while (!list_empty(&dlm->gc_fragments)) {
-		struct vsp1_dl_body *dlb;
-
-		dlb = list_first_entry(&dlm->gc_fragments, struct vsp1_dl_body,
-				       list);
-		list_del(&dlb->list);
-
-		spin_unlock_irqrestore(&dlm->lock, flags);
-		vsp1_dl_fragment_free(dlb);
-		spin_lock_irqsave(&dlm->lock, flags);
-	}
-
-	spin_unlock_irqrestore(&dlm->lock, flags);
-}
-
-static void vsp1_dlm_garbage_collect(struct work_struct *work)
-{
-	struct vsp1_dl_manager *dlm =
-		container_of(work, struct vsp1_dl_manager, gc_work);
-
-	vsp1_dlm_fragments_free(dlm);
-}
-
 struct vsp1_dl_manager *vsp1_dlm_create(struct vsp1_device *vsp1,
 					unsigned int index,
 					unsigned int prealloc)
 {
 	struct vsp1_dl_manager *dlm;
+	size_t header_size;
 	unsigned int i;
 
 	dlm = devm_kzalloc(vsp1->dev, sizeof(*dlm), GFP_KERNEL);
@@ -898,13 +764,26 @@ struct vsp1_dl_manager *vsp1_dlm_create(struct vsp1_device *vsp1,
 
 	spin_lock_init(&dlm->lock);
 	INIT_LIST_HEAD(&dlm->free);
-	INIT_LIST_HEAD(&dlm->gc_fragments);
-	INIT_WORK(&dlm->gc_work, vsp1_dlm_garbage_collect);
+
+	/*
+	 * Initialize the display list body and allocate DMA memory for the body
+	 * and the optional header. Both are allocated together to avoid memory
+	 * fragmentation, with the header located right after the body in
+	 * memory.
+	 */
+	header_size = dlm->mode == VSP1_DL_MODE_HEADER
+		    ? ALIGN(sizeof(struct vsp1_dl_header), 8)
+		    : 0;
+
+	dlm->pool = vsp1_dl_fragment_pool_alloc(vsp1, prealloc,
+					VSP1_DL_NUM_ENTRIES, header_size);
+	if (!dlm->pool)
+		return NULL;
 
 	for (i = 0; i < prealloc; ++i) {
 		struct vsp1_dl_list *dl;
 
-		dl = vsp1_dl_list_alloc(dlm);
+		dl = vsp1_dl_list_alloc(dlm, dlm->pool);
 		if (!dl)
 			return NULL;
 
@@ -921,12 +800,10 @@ void vsp1_dlm_destroy(struct vsp1_dl_manager *dlm)
 	if (!dlm)
 		return;
 
-	cancel_work_sync(&dlm->gc_work);
-
 	list_for_each_entry_safe(dl, next, &dlm->free, list) {
 		list_del(&dl->list);
 		vsp1_dl_list_free(dl);
 	}
 
-	vsp1_dlm_fragments_free(dlm);
+	vsp1_dl_fragment_pool_free(dlm->pool);
 }
diff --git a/drivers/media/platform/vsp1/vsp1_dl.h b/drivers/media/platform/vsp1/vsp1_dl.h
index 9528484a8a34..e1718c3cbb7b 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.h
+++ b/drivers/media/platform/vsp1/vsp1_dl.h
@@ -42,9 +42,6 @@ void vsp1_dl_fragment_pool_free(struct vsp1_dl_fragment_pool *pool);
 struct vsp1_dl_body *vsp1_dl_fragment_get(struct vsp1_dl_fragment_pool *pool);
 void vsp1_dl_fragment_put(struct vsp1_dl_body *dlb);
 
-struct vsp1_dl_body *vsp1_dl_fragment_alloc(struct vsp1_device *vsp1,
-					    unsigned int num_entries);
-void vsp1_dl_fragment_free(struct vsp1_dl_body *dlb);
 void vsp1_dl_fragment_write(struct vsp1_dl_body *dlb, u32 reg, u32 data);
 int vsp1_dl_list_add_fragment(struct vsp1_dl_list *dl,
 			      struct vsp1_dl_body *dlb);
diff --git a/drivers/media/platform/vsp1/vsp1_lut.c b/drivers/media/platform/vsp1/vsp1_lut.c
index c67cc60db0db..57482e057e54 100644
--- a/drivers/media/platform/vsp1/vsp1_lut.c
+++ b/drivers/media/platform/vsp1/vsp1_lut.c
@@ -23,6 +23,8 @@
 #define LUT_MIN_SIZE				4U
 #define LUT_MAX_SIZE				8190U
 
+#define LUT_SIZE				256
+
 /* -----------------------------------------------------------------------------
  * Device Access
  */
@@ -44,11 +46,11 @@ static int lut_set_table(struct vsp1_lut *lut, struct v4l2_ctrl *ctrl)
 	struct vsp1_dl_body *dlb;
 	unsigned int i;
 
-	dlb = vsp1_dl_fragment_alloc(lut->entity.vsp1, 256);
+	dlb = vsp1_dl_fragment_get(lut->pool);
 	if (!dlb)
 		return -ENOMEM;
 
-	for (i = 0; i < 256; ++i)
+	for (i = 0; i < LUT_SIZE; ++i)
 		vsp1_dl_fragment_write(dlb, VI6_LUT_TABLE + 4 * i,
 				       ctrl->p_new.p_u32[i]);
 
@@ -56,7 +58,7 @@ static int lut_set_table(struct vsp1_lut *lut, struct v4l2_ctrl *ctrl)
 	swap(lut->lut, dlb);
 	spin_unlock_irq(&lut->lock);
 
-	vsp1_dl_fragment_free(dlb);
+	vsp1_dl_fragment_put(dlb);
 	return 0;
 }
 
@@ -87,7 +89,7 @@ static const struct v4l2_ctrl_config lut_table_control = {
 	.max = 0x00ffffff,
 	.step = 1,
 	.def = 0,
-	.dims = { 256},
+	.dims = { LUT_SIZE },
 };
 
 /* -----------------------------------------------------------------------------
@@ -217,8 +219,16 @@ static void lut_configure(struct vsp1_entity *entity,
 	}
 }
 
+static void lut_destroy(struct vsp1_entity *entity)
+{
+	struct vsp1_lut *lut = to_lut(&entity->subdev);
+
+	vsp1_dl_fragment_pool_free(lut->pool);
+}
+
 static const struct vsp1_entity_operations lut_entity_ops = {
 	.configure = lut_configure,
+	.destroy = lut_destroy,
 };
 
 /* -----------------------------------------------------------------------------
@@ -244,6 +254,11 @@ struct vsp1_lut *vsp1_lut_create(struct vsp1_device *vsp1)
 	if (ret < 0)
 		return ERR_PTR(ret);
 
+	/* Allocate a fragment pool */
+	lut->pool = vsp1_dl_fragment_pool_alloc(vsp1, 2, LUT_SIZE, 0);
+	if (!lut->pool)
+		return ERR_PTR(-ENOMEM);
+
 	/* Initialize the control handler. */
 	v4l2_ctrl_handler_init(&lut->ctrls, 1);
 	v4l2_ctrl_new_custom(&lut->ctrls, &lut_table_control, NULL);
diff --git a/drivers/media/platform/vsp1/vsp1_lut.h b/drivers/media/platform/vsp1/vsp1_lut.h
index f8c4e8f0a79d..538563d57454 100644
--- a/drivers/media/platform/vsp1/vsp1_lut.h
+++ b/drivers/media/platform/vsp1/vsp1_lut.h
@@ -33,6 +33,7 @@ struct vsp1_lut {
 
 	spinlock_t lock;
 	struct vsp1_dl_body *lut;
+	struct vsp1_dl_fragment_pool *pool;
 };
 
 static inline struct vsp1_lut *to_lut(struct v4l2_subdev *subdev)
-- 
git-series 0.9.1
