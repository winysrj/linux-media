Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:41763 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753208AbeCMSFu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 14:05:50 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-renesas-soc@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 07/11] media: vsp1: Use header display lists for all WPF outputs linked to the DU
Date: Tue, 13 Mar 2018 19:05:23 +0100
Message-Id: <9eabffddea3745ef74a21ea3f954e5c1342b124d.1520963956.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.89a4a5175efbf31441ba717a99b0e3c31088179f.1520963956.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.89a4a5175efbf31441ba717a99b0e3c31088179f.1520963956.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.89a4a5175efbf31441ba717a99b0e3c31088179f.1520963956.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.89a4a5175efbf31441ba717a99b0e3c31088179f.1520963956.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Header mode display lists are now supported on all WPF outputs. To
support extended headers and auto-fld capabilities for interlaced mode
handling only header mode display lists can be used.

Disable the headerless display list configuration, and remove the dead
code.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_dl.c | 107 ++++++---------------------
 1 file changed, 27 insertions(+), 80 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index 680eedb6fc9f..5f5706f8a84c 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -98,7 +98,7 @@ struct vsp1_dl_body_pool {
  * struct vsp1_dl_list - Display list
  * @list: entry in the display list manager lists
  * @dlm: the display list manager
- * @header: display list header, NULL for headerless lists
+ * @header: display list header
  * @dma: DMA address for the header
  * @body0: first display list body
  * @bodies: list of extra display list bodies
@@ -119,15 +119,9 @@ struct vsp1_dl_list {
 	struct list_head chain;
 };
 
-enum vsp1_dl_mode {
-	VSP1_DL_MODE_HEADER,
-	VSP1_DL_MODE_HEADERLESS,
-};
-
 /**
  * struct vsp1_dl_manager - Display List manager
  * @index: index of the related WPF
- * @mode: display list operation mode (header or headerless)
  * @singleshot: execute the display list in single-shot mode
  * @vsp1: the VSP1 device
  * @lock: protects the free, active, queued, pending and gc_bodies lists
@@ -139,7 +133,6 @@ enum vsp1_dl_mode {
  */
 struct vsp1_dl_manager {
 	unsigned int index;
-	enum vsp1_dl_mode mode;
 	bool singleshot;
 	struct vsp1_device *vsp1;
 
@@ -320,6 +313,7 @@ static struct vsp1_dl_list *vsp1_dl_list_alloc(struct vsp1_dl_manager *dlm,
 					       struct vsp1_dl_body_pool *pool)
 {
 	struct vsp1_dl_list *dl;
+	size_t header_offset;
 
 	dl = kzalloc(sizeof(*dl), GFP_KERNEL);
 	if (!dl)
@@ -332,16 +326,15 @@ static struct vsp1_dl_list *vsp1_dl_list_alloc(struct vsp1_dl_manager *dlm,
 	dl->body0 = vsp1_dl_body_get(pool);
 	if (!dl->body0)
 		return NULL;
-	if (dlm->mode == VSP1_DL_MODE_HEADER) {
-		size_t header_offset = dl->body0->max_entries
-				     * sizeof(*dl->body0->entries);
 
-		dl->header = ((void *)dl->body0->entries) + header_offset;
-		dl->dma = dl->body0->dma + header_offset;
+	header_offset = dl->body0->max_entries
+			     * sizeof(*dl->body0->entries);
 
-		memset(dl->header, 0, sizeof(*dl->header));
-		dl->header->lists[0].addr = dl->body0->dma;
-	}
+	dl->header = ((void *)dl->body0->entries) + header_offset;
+	dl->dma = dl->body0->dma + header_offset;
+
+	memset(dl->header, 0, sizeof(*dl->header));
+	dl->header->lists[0].addr = dl->body0->dma;
 
 	return dl;
 }
@@ -473,16 +466,9 @@ struct vsp1_dl_body *vsp1_dl_list_get_body0(struct vsp1_dl_list *dl)
  *
  * The reference must be explicitly released by a call to vsp1_dl_body_put()
  * when the body isn't needed anymore.
- *
- * Additional bodies are only usable for display lists in header mode.
- * Attempting to add a body to a header-less display list will return an error.
  */
 int vsp1_dl_list_add_body(struct vsp1_dl_list *dl, struct vsp1_dl_body *dlb)
 {
-	/* Multi-body lists are only available in header mode. */
-	if (dl->dlm->mode != VSP1_DL_MODE_HEADER)
-		return -EINVAL;
-
 	refcount_inc(&dlb->refcnt);
 
 	list_add_tail(&dlb->list, &dl->bodies);
@@ -503,17 +489,10 @@ int vsp1_dl_list_add_body(struct vsp1_dl_list *dl, struct vsp1_dl_body *dlb)
  * Adding a display list to a chain passes ownership of the display list to
  * the head display list item. The chain is released when the head dl item is
  * put back with __vsp1_dl_list_put().
- *
- * Chained display lists are only usable in header mode. Attempts to add a
- * display list to a chain in header-less mode will return an error.
  */
 int vsp1_dl_list_add_chain(struct vsp1_dl_list *head,
 			   struct vsp1_dl_list *dl)
 {
-	/* Chained lists are only available in header mode. */
-	if (head->dlm->mode != VSP1_DL_MODE_HEADER)
-		return -EINVAL;
-
 	head->has_chain = true;
 	list_add_tail(&dl->chain, &head->chain);
 	return 0;
@@ -581,17 +560,10 @@ static bool vsp1_dl_list_hw_update_pending(struct vsp1_dl_manager *dlm)
 		return false;
 
 	/*
-	 * Check whether the VSP1 has taken the update. In headerless mode the
-	 * hardware indicates this by clearing the UPD bit in the DL_BODY_SIZE
-	 * register, and in header mode by clearing the UPDHDR bit in the CMD
-	 * register.
+	 * Check whether the VSP1 has taken the update. In header mode by
+	 * clearing the UPDHDR bit in the CMD register.
 	 */
-	if (dlm->mode == VSP1_DL_MODE_HEADERLESS)
-		return !!(vsp1_read(vsp1, VI6_DL_BODY_SIZE)
-			  & VI6_DL_BODY_SIZE_UPD);
-	else
-		return !!(vsp1_read(vsp1, VI6_CMD(dlm->index))
-			  & VI6_CMD_UPDHDR);
+	return !!(vsp1_read(vsp1, VI6_CMD(dlm->index)) & VI6_CMD_UPDHDR);
 }
 
 static void vsp1_dl_list_hw_enqueue(struct vsp1_dl_list *dl)
@@ -599,26 +571,14 @@ static void vsp1_dl_list_hw_enqueue(struct vsp1_dl_list *dl)
 	struct vsp1_dl_manager *dlm = dl->dlm;
 	struct vsp1_device *vsp1 = dlm->vsp1;
 
-	if (dlm->mode == VSP1_DL_MODE_HEADERLESS) {
-		/*
-		 * In headerless mode, program the hardware directly with the
-		 * display list body address and size and set the UPD bit. The
-		 * bit will be cleared by the hardware when the display list
-		 * processing starts.
-		 */
-		vsp1_write(vsp1, VI6_DL_HDR_ADDR(0), dl->body0->dma);
-		vsp1_write(vsp1, VI6_DL_BODY_SIZE, VI6_DL_BODY_SIZE_UPD |
-			(dl->body0->num_entries * sizeof(*dl->header->lists)));
-	} else {
-		/*
-		 * In header mode, program the display list header address. If
-		 * the hardware is idle (single-shot mode or first frame in
-		 * continuous mode) it will then be started independently. If
-		 * the hardware is operating, the VI6_DL_HDR_REF_ADDR register
-		 * will be updated with the display list address.
-		 */
-		vsp1_write(vsp1, VI6_DL_HDR_ADDR(dlm->index), dl->dma);
-	}
+	/*
+	 * In header mode, program the display list header address. If
+	 * the hardware is idle (single-shot mode or first frame in
+	 * continuous mode) it will then be started independently. If
+	 * the hardware is operating, the VI6_DL_HDR_REF_ADDR register
+	 * will be updated with the display list address.
+	 */
+	vsp1_write(vsp1, VI6_DL_HDR_ADDR(dlm->index), dl->dma);
 }
 
 static void vsp1_dl_list_commit_continuous(struct vsp1_dl_list *dl)
@@ -668,15 +628,13 @@ void vsp1_dl_list_commit(struct vsp1_dl_list *dl)
 	struct vsp1_dl_list *dl_next;
 	unsigned long flags;
 
-	if (dlm->mode == VSP1_DL_MODE_HEADER) {
-		/* Fill the header for the head and chained display lists. */
-		vsp1_dl_list_fill_header(dl, list_empty(&dl->chain));
+	/* Fill the header for the head and chained display lists. */
+	vsp1_dl_list_fill_header(dl, list_empty(&dl->chain));
 
-		list_for_each_entry(dl_next, &dl->chain, chain) {
-			bool last = list_is_last(&dl_next->chain, &dl->chain);
+	list_for_each_entry(dl_next, &dl->chain, chain) {
+		bool last = list_is_last(&dl_next->chain, &dl->chain);
 
-			vsp1_dl_list_fill_header(dl_next, last);
-		}
+		vsp1_dl_list_fill_header(dl_next, last);
 	}
 
 	spin_lock_irqsave(&dlm->lock, flags);
@@ -763,13 +721,6 @@ void vsp1_dlm_setup(struct vsp1_device *vsp1)
 		 | VI6_DL_CTRL_DC2 | VI6_DL_CTRL_DC1 | VI6_DL_CTRL_DC0
 		 | VI6_DL_CTRL_DLE;
 
-	/*
-	 * The DRM pipeline operates with display lists in Continuous Frame
-	 * Mode, all other pipelines use manual start.
-	 */
-	if (vsp1->drm)
-		ctrl |= VI6_DL_CTRL_CFM0 | VI6_DL_CTRL_NH0;
-
 	vsp1_write(vsp1, VI6_DL_CTRL, ctrl);
 	vsp1_write(vsp1, VI6_DL_SWAP, VI6_DL_SWAP_LWS);
 }
@@ -804,8 +755,6 @@ struct vsp1_dl_manager *vsp1_dlm_create(struct vsp1_device *vsp1,
 		return NULL;
 
 	dlm->index = index;
-	dlm->mode = index == 0 && !vsp1->info->uapi
-		  ? VSP1_DL_MODE_HEADERLESS : VSP1_DL_MODE_HEADER;
 	dlm->singleshot = vsp1->info->uapi;
 	dlm->vsp1 = vsp1;
 
@@ -814,13 +763,11 @@ struct vsp1_dl_manager *vsp1_dlm_create(struct vsp1_device *vsp1,
 
 	/*
 	 * Initialize the display list body and allocate DMA memory for the body
-	 * and the optional header. Both are allocated together to avoid memory
+	 * and the header. Both are allocated together to avoid memory
 	 * fragmentation, with the header located right after the body in
 	 * memory.
 	 */
-	header_size = dlm->mode == VSP1_DL_MODE_HEADER
-		    ? ALIGN(sizeof(struct vsp1_dl_header), 8)
-		    : 0;
+	header_size = ALIGN(sizeof(struct vsp1_dl_header), 8);
 
 	dlm->pool = vsp1_dl_body_pool_create(vsp1, prealloc,
 					     VSP1_DL_NUM_ENTRIES, header_size);
-- 
git-series 0.9.1
