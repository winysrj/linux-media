Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:43780 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752229AbeERUmP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 16:42:15 -0400
From: Kieran Bingham <kieran@ksquared.org.uk>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: [PATCH v11 06/10] media: vsp1: Convert display lists to use new body pool
Date: Fri, 18 May 2018 21:41:59 +0100
Message-Id: <a38bbf91b8bc71df9902d9b4736c44b3b5d6e81f.1526675940.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.4fb0850a617881b465a66140fdf06941777212ae.1526675940.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.4fb0850a617881b465a66140fdf06941777212ae.1526675940.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.4fb0850a617881b465a66140fdf06941777212ae.1526675940.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.4fb0850a617881b465a66140fdf06941777212ae.1526675940.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Adapt the dl->body0 object to use an object from the body pool. This
greatly reduces the pressure on the TLB for IPMMU use cases, as all of
the lists use a single allocation for the main body.

The CLU and LUT objects pre-allocate a pool containing three bodies,
allowing a userspace update before the hardware has committed a previous
set of tables.

Bodies are no longer 'freed' in interrupt context, but instead released
back to their respective pools. This allows us to remove the garbage
collector in the DLM.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_clu.c |  27 ++-
 drivers/media/platform/vsp1/vsp1_clu.h |   1 +-
 drivers/media/platform/vsp1/vsp1_dl.c  | 221 ++++++--------------------
 drivers/media/platform/vsp1/vsp1_dl.h  |   3 +-
 drivers/media/platform/vsp1/vsp1_lut.c |  27 ++-
 drivers/media/platform/vsp1/vsp1_lut.h |   1 +-
 6 files changed, 100 insertions(+), 180 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_clu.c b/drivers/media/platform/vsp1/vsp1_clu.c
index ebfbb915dcdc..8efa12f5e53f 100644
--- a/drivers/media/platform/vsp1/vsp1_clu.c
+++ b/drivers/media/platform/vsp1/vsp1_clu.c
@@ -19,6 +19,8 @@
 #define CLU_MIN_SIZE				4U
 #define CLU_MAX_SIZE				8190U
 
+#define CLU_SIZE				(17 * 17 * 17)
+
 /* -----------------------------------------------------------------------------
  * Device Access
  */
@@ -43,19 +45,19 @@ static int clu_set_table(struct vsp1_clu *clu, struct v4l2_ctrl *ctrl)
 	struct vsp1_dl_body *dlb;
 	unsigned int i;
 
-	dlb = vsp1_dl_body_alloc(clu->entity.vsp1, 1 + 17 * 17 * 17);
+	dlb = vsp1_dl_body_get(clu->pool);
 	if (!dlb)
 		return -ENOMEM;
 
 	vsp1_dl_body_write(dlb, VI6_CLU_ADDR, 0);
-	for (i = 0; i < 17 * 17 * 17; ++i)
+	for (i = 0; i < CLU_SIZE; ++i)
 		vsp1_dl_body_write(dlb, VI6_CLU_DATA, ctrl->p_new.p_u32[i]);
 
 	spin_lock_irq(&clu->lock);
 	swap(clu->clu, dlb);
 	spin_unlock_irq(&clu->lock);
 
-	vsp1_dl_body_free(dlb);
+	vsp1_dl_body_put(dlb);
 	return 0;
 }
 
@@ -216,8 +218,16 @@ static void clu_configure(struct vsp1_entity *entity,
 	}
 }
 
+static void clu_destroy(struct vsp1_entity *entity)
+{
+	struct vsp1_clu *clu = to_clu(&entity->subdev);
+
+	vsp1_dl_body_pool_destroy(clu->pool);
+}
+
 static const struct vsp1_entity_operations clu_entity_ops = {
 	.configure = clu_configure,
+	.destroy = clu_destroy,
 };
 
 /* -----------------------------------------------------------------------------
@@ -243,6 +253,17 @@ struct vsp1_clu *vsp1_clu_create(struct vsp1_device *vsp1)
 	if (ret < 0)
 		return ERR_PTR(ret);
 
+	/*
+	 * Pre-allocate a body pool, with 3 bodies allowing a userspace update
+	 * before the hardware has committed a previous set of tables, handling
+	 * both the queued and pending dl entries. One extra entry is added to
+	 * the CLU_SIZE to allow for the VI6_CLU_ADDR header.
+	 */
+	clu->pool = vsp1_dl_body_pool_create(clu->entity.vsp1, 3, CLU_SIZE + 1,
+					     0);
+	if (!clu->pool)
+		return ERR_PTR(-ENOMEM);
+
 	/* Initialize the control handler. */
 	v4l2_ctrl_handler_init(&clu->ctrls, 2);
 	v4l2_ctrl_new_custom(&clu->ctrls, &clu_table_control, NULL);
diff --git a/drivers/media/platform/vsp1/vsp1_clu.h b/drivers/media/platform/vsp1/vsp1_clu.h
index c45e6e707592..cef2f44481ba 100644
--- a/drivers/media/platform/vsp1/vsp1_clu.h
+++ b/drivers/media/platform/vsp1/vsp1_clu.h
@@ -32,6 +32,7 @@ struct vsp1_clu {
 	spinlock_t lock;
 	unsigned int mode;
 	struct vsp1_dl_body *clu;
+	struct vsp1_dl_body_pool *pool;
 };
 
 static inline struct vsp1_clu *to_clu(struct v4l2_subdev *subdev)
diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index 41ace89a585b..617c46a03dec 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -108,7 +108,7 @@ struct vsp1_dl_list {
 	struct vsp1_dl_header *header;
 	dma_addr_t dma;
 
-	struct vsp1_dl_body body0;
+	struct vsp1_dl_body *body0;
 	struct list_head bodies;
 
 	bool has_chain;
@@ -128,14 +128,12 @@ enum vsp1_dl_mode {
  * @mode: display list operation mode (header or headerless)
  * @singleshot: execute the display list in single-shot mode
  * @vsp1: the VSP1 device
- * @lock: protects the free, active, queued, pending and gc_bodies lists
+ * @lock: protects the free, active, queued, and pending lists
  * @free: array of all free display lists
  * @active: list currently being processed (loaded) by hardware
  * @queued: list queued to the hardware (written to the DL registers)
  * @pending: list waiting to be queued to the hardware
  * @pool: body pool for the display list bodies
- * @gc_work: bodies garbage collector work struct
- * @gc_bodies: array of display list bodies waiting to be freed
  */
 struct vsp1_dl_manager {
 	unsigned int index;
@@ -150,9 +148,6 @@ struct vsp1_dl_manager {
 	struct vsp1_dl_list *pending;
 
 	struct vsp1_dl_body_pool *pool;
-
-	struct work_struct gc_work;
-	struct list_head gc_bodies;
 };
 
 /* -----------------------------------------------------------------------------
@@ -290,89 +285,6 @@ void vsp1_dl_body_put(struct vsp1_dl_body *dlb)
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
- * vsp1_dl_body_alloc - Allocate a display list body
- * @vsp1: The VSP1 device
- * @num_entries: The maximum number of entries that the body can contain
- *
- * Allocate a display list body with enough memory to contain the requested
- * number of entries.
- *
- * Return a pointer to a body on success or NULL if memory can't be allocated.
- */
-struct vsp1_dl_body *vsp1_dl_body_alloc(struct vsp1_device *vsp1,
-					unsigned int num_entries)
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
- * vsp1_dl_body_free - Free a display list body
- * @dlb: The body
- *
- * Free the given display list body and the associated DMA memory.
- *
- * Bodies must only be freed explicitly if they are not added to a display
- * list, as the display list will take ownership of them and free them
- * otherwise. Manual free typically happens at cleanup time for bodies that
- * have been allocated but not used.
- *
- * Passing a NULL pointer to this function is safe, in that case no operation
- * will be performed.
- */
-void vsp1_dl_body_free(struct vsp1_dl_body *dlb)
-{
-	if (!dlb)
-		return;
-
-	vsp1_dl_body_cleanup(dlb);
-	kfree(dlb);
-}
-
 /**
  * vsp1_dl_body_write - Write a register to a display list body
  * @dlb: The body
@@ -401,8 +313,6 @@ void vsp1_dl_body_write(struct vsp1_dl_body *dlb, u32 reg, u32 data)
 static struct vsp1_dl_list *vsp1_dl_list_alloc(struct vsp1_dl_manager *dlm)
 {
 	struct vsp1_dl_list *dl;
-	size_t header_size;
-	int ret;
 
 	dl = kzalloc(sizeof(*dl), GFP_KERNEL);
 	if (!dl)
@@ -411,41 +321,39 @@ static struct vsp1_dl_list *vsp1_dl_list_alloc(struct vsp1_dl_manager *dlm)
 	INIT_LIST_HEAD(&dl->bodies);
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
+	/* Get a default body for our list. */
+	dl->body0 = vsp1_dl_body_get(dlm->pool);
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
 
+static void vsp1_dl_list_bodies_put(struct vsp1_dl_list *dl)
+{
+	struct vsp1_dl_body *dlb, *tmp;
+
+	list_for_each_entry_safe(dlb, tmp, &dl->bodies, list) {
+		list_del(&dlb->list);
+		vsp1_dl_body_put(dlb);
+	}
+}
+
 static void vsp1_dl_list_free(struct vsp1_dl_list *dl)
 {
-	vsp1_dl_body_cleanup(&dl->body0);
-	list_splice_init(&dl->bodies, &dl->dlm->gc_bodies);
+	vsp1_dl_body_put(dl->body0);
+	vsp1_dl_list_bodies_put(dl);
+
 	kfree(dl);
 }
 
@@ -499,18 +407,13 @@ static void __vsp1_dl_list_put(struct vsp1_dl_list *dl)
 
 	dl->has_chain = false;
 
+	vsp1_dl_list_bodies_put(dl);
+
 	/*
-	 * We can't free bodies here as DMA memory can only be freed in
-	 * interruptible context. Move all bodies to the display list manager's
-	 * list of bodies to be freed, they will be garbage-collected by the
-	 * work queue.
+	 * body0 is reused as as an optimisation as presently every display list
+	 * has at least one body, thus we reinitialise the entries list.
 	 */
-	if (!list_empty(&dl->bodies)) {
-		list_splice_init(&dl->bodies, &dl->dlm->gc_bodies);
-		schedule_work(&dl->dlm->gc_work);
-	}
-
-	dl->body0.num_entries = 0;
+	dl->body0->num_entries = 0;
 
 	list_add_tail(&dl->list, &dl->dlm->free);
 }
@@ -547,7 +450,7 @@ void vsp1_dl_list_put(struct vsp1_dl_list *dl)
  */
 void vsp1_dl_list_write(struct vsp1_dl_list *dl, u32 reg, u32 data)
 {
-	vsp1_dl_body_write(&dl->body0, reg, data);
+	vsp1_dl_body_write(dl->body0, reg, data);
 }
 
 /**
@@ -560,8 +463,8 @@ void vsp1_dl_list_write(struct vsp1_dl_list *dl, u32 reg, u32 data)
  * which bodies are added.
  *
  * Adding a body to a display list passes ownership of the body to the list. The
- * caller must not touch the body after this call, and must not free it
- * explicitly with vsp1_dl_body_free().
+ * caller must not touch the body after this call, and must not release it
+ * explicitly with vsp1_dl_body_put().
  *
  * Additional bodies are only usable for display lists in header mode.
  * Attempting to add a body to a header-less display list will return an error.
@@ -619,7 +522,7 @@ static void vsp1_dl_list_fill_header(struct vsp1_dl_list *dl, bool is_last)
 	 * list was allocated.
 	 */
 
-	hdr->num_bytes = dl->body0.num_entries
+	hdr->num_bytes = dl->body0->num_entries
 		       * sizeof(*dl->header->lists);
 
 	list_for_each_entry(dlb, &dl->bodies, list) {
@@ -693,9 +596,9 @@ static void vsp1_dl_list_hw_enqueue(struct vsp1_dl_list *dl)
 		 * bit will be cleared by the hardware when the display list
 		 * processing starts.
 		 */
-		vsp1_write(vsp1, VI6_DL_HDR_ADDR(0), dl->body0.dma);
+		vsp1_write(vsp1, VI6_DL_HDR_ADDR(0), dl->body0->dma);
 		vsp1_write(vsp1, VI6_DL_BODY_SIZE, VI6_DL_BODY_SIZE_UPD |
-			   (dl->body0.num_entries * sizeof(*dl->header->lists)));
+			(dl->body0->num_entries * sizeof(*dl->header->lists)));
 	} else {
 		/*
 		 * In header mode, program the display list header address. If
@@ -900,45 +803,12 @@ void vsp1_dlm_reset(struct vsp1_dl_manager *dlm)
 	dlm->pending = NULL;
 }
 
-/*
- * Free all bodies awaiting to be garbage-collected.
- *
- * This function must be called without the display list manager lock held.
- */
-static void vsp1_dlm_bodies_free(struct vsp1_dl_manager *dlm)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&dlm->lock, flags);
-
-	while (!list_empty(&dlm->gc_bodies)) {
-		struct vsp1_dl_body *dlb;
-
-		dlb = list_first_entry(&dlm->gc_bodies, struct vsp1_dl_body,
-				       list);
-		list_del(&dlb->list);
-
-		spin_unlock_irqrestore(&dlm->lock, flags);
-		vsp1_dl_body_free(dlb);
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
-	vsp1_dlm_bodies_free(dlm);
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
@@ -953,8 +823,21 @@ struct vsp1_dl_manager *vsp1_dlm_create(struct vsp1_device *vsp1,
 
 	spin_lock_init(&dlm->lock);
 	INIT_LIST_HEAD(&dlm->free);
-	INIT_LIST_HEAD(&dlm->gc_bodies);
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
+	dlm->pool = vsp1_dl_body_pool_create(vsp1, prealloc,
+					     VSP1_DL_NUM_ENTRIES, header_size);
+	if (!dlm->pool)
+		return NULL;
 
 	for (i = 0; i < prealloc; ++i) {
 		struct vsp1_dl_list *dl;
@@ -976,12 +859,10 @@ void vsp1_dlm_destroy(struct vsp1_dl_manager *dlm)
 	if (!dlm)
 		return;
 
-	cancel_work_sync(&dlm->gc_work);
-
 	list_for_each_entry_safe(dl, next, &dlm->free, list) {
 		list_del(&dl->list);
 		vsp1_dl_list_free(dl);
 	}
 
-	vsp1_dlm_bodies_free(dlm);
+	vsp1_dl_body_pool_destroy(dlm->pool);
 }
diff --git a/drivers/media/platform/vsp1/vsp1_dl.h b/drivers/media/platform/vsp1/vsp1_dl.h
index 107eebcdbab6..6a7d48e385d5 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.h
+++ b/drivers/media/platform/vsp1/vsp1_dl.h
@@ -41,9 +41,6 @@ void vsp1_dl_body_pool_destroy(struct vsp1_dl_body_pool *pool);
 struct vsp1_dl_body *vsp1_dl_body_get(struct vsp1_dl_body_pool *pool);
 void vsp1_dl_body_put(struct vsp1_dl_body *dlb);
 
-struct vsp1_dl_body *vsp1_dl_body_alloc(struct vsp1_device *vsp1,
-					unsigned int num_entries);
-void vsp1_dl_body_free(struct vsp1_dl_body *dlb);
 void vsp1_dl_body_write(struct vsp1_dl_body *dlb, u32 reg, u32 data);
 int vsp1_dl_list_add_body(struct vsp1_dl_list *dl, struct vsp1_dl_body *dlb);
 int vsp1_dl_list_add_chain(struct vsp1_dl_list *head, struct vsp1_dl_list *dl);
diff --git a/drivers/media/platform/vsp1/vsp1_lut.c b/drivers/media/platform/vsp1/vsp1_lut.c
index acbaca0f47f0..6b358617ce15 100644
--- a/drivers/media/platform/vsp1/vsp1_lut.c
+++ b/drivers/media/platform/vsp1/vsp1_lut.c
@@ -19,6 +19,8 @@
 #define LUT_MIN_SIZE				4U
 #define LUT_MAX_SIZE				8190U
 
+#define LUT_SIZE				256
+
 /* -----------------------------------------------------------------------------
  * Device Access
  */
@@ -40,11 +42,11 @@ static int lut_set_table(struct vsp1_lut *lut, struct v4l2_ctrl *ctrl)
 	struct vsp1_dl_body *dlb;
 	unsigned int i;
 
-	dlb = vsp1_dl_body_alloc(lut->entity.vsp1, 256);
+	dlb = vsp1_dl_body_get(lut->pool);
 	if (!dlb)
 		return -ENOMEM;
 
-	for (i = 0; i < 256; ++i)
+	for (i = 0; i < LUT_SIZE; ++i)
 		vsp1_dl_body_write(dlb, VI6_LUT_TABLE + 4 * i,
 				       ctrl->p_new.p_u32[i]);
 
@@ -52,7 +54,7 @@ static int lut_set_table(struct vsp1_lut *lut, struct v4l2_ctrl *ctrl)
 	swap(lut->lut, dlb);
 	spin_unlock_irq(&lut->lock);
 
-	vsp1_dl_body_free(dlb);
+	vsp1_dl_body_put(dlb);
 	return 0;
 }
 
@@ -83,7 +85,7 @@ static const struct v4l2_ctrl_config lut_table_control = {
 	.max = 0x00ffffff,
 	.step = 1,
 	.def = 0,
-	.dims = { 256},
+	.dims = { LUT_SIZE },
 };
 
 /* -----------------------------------------------------------------------------
@@ -172,8 +174,16 @@ static void lut_configure(struct vsp1_entity *entity,
 	}
 }
 
+static void lut_destroy(struct vsp1_entity *entity)
+{
+	struct vsp1_lut *lut = to_lut(&entity->subdev);
+
+	vsp1_dl_body_pool_destroy(lut->pool);
+}
+
 static const struct vsp1_entity_operations lut_entity_ops = {
 	.configure = lut_configure,
+	.destroy = lut_destroy,
 };
 
 /* -----------------------------------------------------------------------------
@@ -199,6 +209,15 @@ struct vsp1_lut *vsp1_lut_create(struct vsp1_device *vsp1)
 	if (ret < 0)
 		return ERR_PTR(ret);
 
+	/*
+	 * Pre-allocate a body pool, with 3 bodies allowing a userspace update
+	 * before the hardware has committed a previous set of tables, handling
+	 * both the queued and pending dl entries.
+	 */
+	lut->pool = vsp1_dl_body_pool_create(vsp1, 3, LUT_SIZE, 0);
+	if (!lut->pool)
+		return ERR_PTR(-ENOMEM);
+
 	/* Initialize the control handler. */
 	v4l2_ctrl_handler_init(&lut->ctrls, 1);
 	v4l2_ctrl_new_custom(&lut->ctrls, &lut_table_control, NULL);
diff --git a/drivers/media/platform/vsp1/vsp1_lut.h b/drivers/media/platform/vsp1/vsp1_lut.h
index dce2fdc315f6..8cb0df1b7e27 100644
--- a/drivers/media/platform/vsp1/vsp1_lut.h
+++ b/drivers/media/platform/vsp1/vsp1_lut.h
@@ -29,6 +29,7 @@ struct vsp1_lut {
 
 	spinlock_t lock;
 	struct vsp1_dl_body *lut;
+	struct vsp1_dl_body_pool *pool;
 };
 
 static inline struct vsp1_lut *to_lut(struct v4l2_subdev *subdev)
-- 
git-series 0.9.1
