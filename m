Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754660AbdGNQOY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Jul 2017 12:14:24 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH 3/6] v4l: vsp1: Convert display lists to use new fragment pool
Date: Fri, 14 Jul 2017 17:14:12 +0100
Message-Id: <5e77b223f99bef2ef7dc7d548484940eba88e3bd.1500047489.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.6756808fb978882ae2db0cde7745c7e12b177713.1500047489.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.6756808fb978882ae2db0cde7745c7e12b177713.1500047489.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.6756808fb978882ae2db0cde7745c7e12b177713.1500047489.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.6756808fb978882ae2db0cde7745c7e12b177713.1500047489.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adapt the dl->body0 object to use an object from the fragment pool.
This greatly reduces the pressure on the TLB for IPMMU use cases, as
all of the lists use a single allocation for the main body

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_dl.c | 68 +++++++++++++++-------------
 1 file changed, 37 insertions(+), 31 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index 8b1118c2e8f5..95f2303d37b9 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -107,7 +107,7 @@ struct vsp1_dl_list {
 	struct vsp1_dl_header *header;
 	dma_addr_t dma;
 
-	struct vsp1_dl_body body0;
+	struct vsp1_dl_body *body0;
 	struct list_head fragments;
 
 	bool has_chain;
@@ -198,6 +198,8 @@ vsp1_dl_fragment_pool_alloc(struct vsp1_device *vsp1, unsigned int qty,
 
 		dlb->pool = pool;
 		dlb->max_entries = num_entries;
+
+		dlb->dma = pool->dma + i * dlb_size;
 		dlb->entries = pool->mem + i * dlb_size;
 
 		list_add_tail(&dlb->free, &pool->free);
@@ -360,11 +362,10 @@ void vsp1_dl_fragment_write(struct vsp1_dl_body *dlb, u32 reg, u32 data)
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
@@ -373,32 +374,19 @@ static struct vsp1_dl_list *vsp1_dl_list_alloc(struct vsp1_dl_manager *dlm)
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
 		size_t header_offset = VSP1_DL_NUM_ENTRIES
-				     * sizeof(*dl->body0.entries);
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
@@ -406,7 +394,7 @@ static struct vsp1_dl_list *vsp1_dl_list_alloc(struct vsp1_dl_manager *dlm)
 
 static void vsp1_dl_list_free(struct vsp1_dl_list *dl)
 {
-	vsp1_dl_body_cleanup(&dl->body0);
+	vsp1_dl_fragment_put(dl->body0);
 	list_splice_init(&dl->fragments, &dl->dlm->gc_fragments);
 	kfree(dl);
 }
@@ -472,7 +460,7 @@ static void __vsp1_dl_list_put(struct vsp1_dl_list *dl)
 		schedule_work(&dl->dlm->gc_work);
 	}
 
-	dl->body0.num_entries = 0;
+	dl->body0->num_entries = 0;
 
 	list_add_tail(&dl->list, &dl->dlm->free);
 }
@@ -509,7 +497,7 @@ void vsp1_dl_list_put(struct vsp1_dl_list *dl)
  */
 void vsp1_dl_list_write(struct vsp1_dl_list *dl, u32 reg, u32 data)
 {
-	vsp1_dl_fragment_write(&dl->body0, reg, data);
+	vsp1_dl_fragment_write(dl->body0, reg, data);
 }
 
 /**
@@ -581,7 +569,7 @@ static void vsp1_dl_list_fill_header(struct vsp1_dl_list *dl, bool is_last)
 	 * list was allocated.
 	 */
 
-	hdr->num_bytes = dl->body0.num_entries
+	hdr->num_bytes = dl->body0->num_entries
 		       * sizeof(*dl->header->lists);
 
 	list_for_each_entry(dlb, &dl->fragments, list) {
@@ -654,9 +642,9 @@ static void vsp1_dl_list_hw_enqueue(struct vsp1_dl_list *dl)
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
@@ -878,6 +866,7 @@ struct vsp1_dl_manager *vsp1_dlm_create(struct vsp1_device *vsp1,
 					unsigned int prealloc)
 {
 	struct vsp1_dl_manager *dlm;
+	size_t header_size;
 	unsigned int i;
 
 	dlm = devm_kzalloc(vsp1->dev, sizeof(*dlm), GFP_KERNEL);
@@ -895,10 +884,25 @@ struct vsp1_dl_manager *vsp1_dlm_create(struct vsp1_device *vsp1,
 	INIT_LIST_HEAD(&dlm->gc_fragments);
 	INIT_WORK(&dlm->gc_work, vsp1_dlm_garbage_collect);
 
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
+
 	for (i = 0; i < prealloc; ++i) {
 		struct vsp1_dl_list *dl;
 
-		dl = vsp1_dl_list_alloc(dlm);
+		dl = vsp1_dl_list_alloc(dlm, dlm->pool);
 		if (!dl)
 			return NULL;
 
@@ -923,4 +927,6 @@ void vsp1_dlm_destroy(struct vsp1_dl_manager *dlm)
 	}
 
 	vsp1_dlm_fragments_free(dlm);
+
+	vsp1_dl_fragment_pool_free(dlm->pool);
 }
-- 
git-series 0.9.1
