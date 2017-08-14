Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752095AbdHNPNm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Aug 2017 11:13:42 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: laurent.pinchart@ideasonboard.com,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v2 2/8] v4l: vsp1: Provide a fragment pool
Date: Mon, 14 Aug 2017 16:13:25 +0100
Message-Id: <a6d3215ef9d865bc5161af664f073072306fd978.1502723341.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.4457988ad8b64b5c7636e35039ef61d507af3648.1502723341.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.4457988ad8b64b5c7636e35039ef61d507af3648.1502723341.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.4457988ad8b64b5c7636e35039ef61d507af3648.1502723341.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.4457988ad8b64b5c7636e35039ef61d507af3648.1502723341.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Each display list allocates a body to store register values in a dma
accessible buffer from a dma_alloc_wc() allocation. Each of these
results in an entry in the TLB, and a large number of display list
allocations adds pressure to this resource.

Reduce TLB pressure on the IPMMUs by allocating multiple display list
bodies in a single allocation, and providing these to the display list
through a 'fragment pool'. A pool can be allocated by the display list
manager or entities which require their own body allocations.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

---
v2:
 - assign dlb->dma correctly
---
 drivers/media/platform/vsp1/vsp1_dl.c | 129 +++++++++++++++++++++++++++-
 drivers/media/platform/vsp1/vsp1_dl.h |   8 ++-
 2 files changed, 137 insertions(+)

diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index cb4625ae13c2..aab9dd6ec0eb 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -45,6 +45,8 @@ struct vsp1_dl_entry {
 /**
  * struct vsp1_dl_body - Display list body
  * @list: entry in the display list list of bodies
+ * @free: entry in the pool free body list
+ * @pool: pool to which this body belongs
  * @vsp1: the VSP1 device
  * @entries: array of entries
  * @dma: DMA address of the entries
@@ -54,6 +56,9 @@ struct vsp1_dl_entry {
  */
 struct vsp1_dl_body {
 	struct list_head list;
+	struct list_head free;
+
+	struct vsp1_dl_fragment_pool *pool;
 	struct vsp1_device *vsp1;
 
 	struct vsp1_dl_entry *entries;
@@ -65,6 +70,30 @@ struct vsp1_dl_body {
 };
 
 /**
+ * struct vsp1_dl_fragment_pool - display list body/fragment pool
+ * @dma: DMA address of the entries
+ * @size: size of the full DMA memory pool in bytes
+ * @mem: CPU memory pointer for the pool
+ * @bodies: Array of DLB structures for the pool
+ * @free: List of free DLB entries
+ * @lock: Protects the pool and free list
+ * @vsp1: the VSP1 device
+ */
+struct vsp1_dl_fragment_pool {
+	/* DMA allocation */
+	dma_addr_t dma;
+	size_t size;
+	void *mem;
+
+	/* Body management */
+	struct vsp1_dl_body *bodies;
+	struct list_head free;
+	spinlock_t lock;
+
+	struct vsp1_device *vsp1;
+};
+
+/**
  * struct vsp1_dl_list - Display list
  * @list: entry in the display list manager lists
  * @dlm: the display list manager
@@ -104,6 +133,7 @@ enum vsp1_dl_mode {
  * @active: list currently being processed (loaded) by hardware
  * @queued: list queued to the hardware (written to the DL registers)
  * @pending: list waiting to be queued to the hardware
+ * @pool: fragment pool for the display list bodies
  * @gc_work: fragments garbage collector work struct
  * @gc_fragments: array of display list fragments waiting to be freed
  */
@@ -119,6 +149,8 @@ struct vsp1_dl_manager {
 	struct vsp1_dl_list *queued;
 	struct vsp1_dl_list *pending;
 
+	struct vsp1_dl_fragment_pool *pool;
+
 	struct work_struct gc_work;
 	struct list_head gc_fragments;
 };
@@ -128,6 +160,103 @@ struct vsp1_dl_manager {
  */
 
 /*
+ * Fragment pool's reduce the pressure on the iommu TLB by allocating a single
+ * large area of DMA memory and allocating it as a pool of fragment bodies
+ */
+struct vsp1_dl_fragment_pool *
+vsp1_dl_fragment_pool_alloc(struct vsp1_device *vsp1, unsigned int qty,
+			    unsigned int num_entries, size_t extra_size)
+{
+	struct vsp1_dl_fragment_pool *pool;
+	size_t dlb_size;
+	unsigned int i;
+
+	pool = kzalloc(sizeof(*pool), GFP_KERNEL);
+	if (!pool)
+		return NULL;
+
+	pool->vsp1 = vsp1;
+
+	dlb_size = num_entries * sizeof(struct vsp1_dl_entry) + extra_size;
+	pool->size = dlb_size * qty;
+
+	pool->bodies = kcalloc(qty, sizeof(*pool->bodies), GFP_KERNEL);
+	if (!pool->bodies) {
+		kfree(pool);
+		return NULL;
+	}
+
+	pool->mem = dma_alloc_wc(vsp1->bus_master, pool->size, &pool->dma,
+					    GFP_KERNEL);
+	if (!pool->mem) {
+		kfree(pool->bodies);
+		kfree(pool);
+		return NULL;
+	}
+
+	spin_lock_init(&pool->lock);
+	INIT_LIST_HEAD(&pool->free);
+
+	for (i = 0; i < qty; ++i) {
+		struct vsp1_dl_body *dlb = &pool->bodies[i];
+
+		dlb->pool = pool;
+		dlb->max_entries = num_entries;
+
+		dlb->dma = pool->dma + i * dlb_size;
+		dlb->entries = pool->mem + i * dlb_size;
+
+		list_add_tail(&dlb->free, &pool->free);
+	}
+
+	return pool;
+}
+
+void vsp1_dl_fragment_pool_free(struct vsp1_dl_fragment_pool *pool)
+{
+	if (!pool)
+		return;
+
+	if (pool->mem)
+		dma_free_wc(pool->vsp1->bus_master, pool->size, pool->mem,
+			    pool->dma);
+
+	kfree(pool->bodies);
+	kfree(pool);
+}
+
+struct vsp1_dl_body *vsp1_dl_fragment_get(struct vsp1_dl_fragment_pool *pool)
+{
+	struct vsp1_dl_body *dlb = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&pool->lock, flags);
+
+	if (!list_empty(&pool->free)) {
+		dlb = list_first_entry(&pool->free, struct vsp1_dl_body, free);
+		list_del(&dlb->free);
+	}
+
+	spin_unlock_irqrestore(&pool->lock, flags);
+
+	return dlb;
+}
+
+void vsp1_dl_fragment_put(struct vsp1_dl_body *dlb)
+{
+	unsigned long flags;
+
+	if (!dlb)
+		return;
+
+	dlb->num_entries = 0;
+
+	spin_lock_irqsave(&dlb->pool->lock, flags);
+	list_add_tail(&dlb->free, &dlb->pool->free);
+	spin_unlock_irqrestore(&dlb->pool->lock, flags);
+}
+
+/*
  * Initialize a display list body object and allocate DMA memory for the body
  * data. The display list body object is expected to have been initialized to
  * 0 when allocated.
diff --git a/drivers/media/platform/vsp1/vsp1_dl.h b/drivers/media/platform/vsp1/vsp1_dl.h
index ee3508172f0a..9528484a8a34 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.h
+++ b/drivers/media/platform/vsp1/vsp1_dl.h
@@ -17,6 +17,7 @@
 
 struct vsp1_device;
 struct vsp1_dl_fragment;
+struct vsp1_dl_fragment_pool;
 struct vsp1_dl_list;
 struct vsp1_dl_manager;
 
@@ -34,6 +35,13 @@ void vsp1_dl_list_put(struct vsp1_dl_list *dl);
 void vsp1_dl_list_write(struct vsp1_dl_list *dl, u32 reg, u32 data);
 void vsp1_dl_list_commit(struct vsp1_dl_list *dl);
 
+struct vsp1_dl_fragment_pool *
+vsp1_dl_fragment_pool_alloc(struct vsp1_device *vsp1, unsigned int qty,
+			    unsigned int num_entries, size_t extra_size);
+void vsp1_dl_fragment_pool_free(struct vsp1_dl_fragment_pool *pool);
+struct vsp1_dl_body *vsp1_dl_fragment_get(struct vsp1_dl_fragment_pool *pool);
+void vsp1_dl_fragment_put(struct vsp1_dl_body *dlb);
+
 struct vsp1_dl_body *vsp1_dl_fragment_alloc(struct vsp1_device *vsp1,
 					    unsigned int num_entries);
 void vsp1_dl_fragment_free(struct vsp1_dl_body *dlb);
-- 
git-series 0.9.1
