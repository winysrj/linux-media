Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:34892 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751551AbeECNgc (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 May 2018 09:36:32 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v4 07/11] media: vsp1: Use header display lists for all WPF outputs linked to the DU
Date: Thu,  3 May 2018 14:36:18 +0100
Message-Id: <00cebb6a515fd30c47b703270cec5e40f48ae266.1525354194.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.bd2eb66d11f8094114941107dbc78dc02c9c7fdd.1525354194.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.bd2eb66d11f8094114941107dbc78dc02c9c7fdd.1525354194.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.bd2eb66d11f8094114941107dbc78dc02c9c7fdd.1525354194.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.bd2eb66d11f8094114941107dbc78dc02c9c7fdd.1525354194.git-series.kieran.bingham+renesas@ideasonboard.com>
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
index fbffbd407b29..56514cd51c51 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -94,7 +94,7 @@ struct vsp1_dl_body_pool {
  * struct vsp1_dl_list - Display list
  * @list: entry in the display list manager lists
  * @dlm: the display list manager
- * @header: display list header, NULL for headerless lists
+ * @header: display list header
  * @dma: DMA address for the header
  * @body0: first display list body
  * @bodies: list of extra display list bodies
@@ -118,15 +118,9 @@ struct vsp1_dl_list {
 	bool internal;
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
  * @lock: protects the free, active, queued, and pending lists
@@ -138,7 +132,6 @@ enum vsp1_dl_mode {
  */
 struct vsp1_dl_manager {
 	unsigned int index;
-	enum vsp1_dl_mode mode;
 	bool singleshot;
 	struct vsp1_device *vsp1;
 
@@ -318,6 +311,7 @@ void vsp1_dl_body_write(struct vsp1_dl_body *dlb, u32 reg, u32 data)
 static struct vsp1_dl_list *vsp1_dl_list_alloc(struct vsp1_dl_manager *dlm)
 {
 	struct vsp1_dl_list *dl;
+	size_t header_offset;
 
 	dl = kzalloc(sizeof(*dl), GFP_KERNEL);
 	if (!dl)
@@ -330,16 +324,15 @@ static struct vsp1_dl_list *vsp1_dl_list_alloc(struct vsp1_dl_manager *dlm)
 	dl->body0 = vsp1_dl_body_get(dlm->pool);
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
@@ -471,16 +464,9 @@ struct vsp1_dl_body *vsp1_dl_list_get_body0(struct vsp1_dl_list *dl)
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
@@ -501,17 +487,10 @@ int vsp1_dl_list_add_body(struct vsp1_dl_list *dl, struct vsp1_dl_body *dlb)
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
@@ -579,17 +558,10 @@ static bool vsp1_dl_list_hw_update_pending(struct vsp1_dl_manager *dlm)
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
@@ -597,26 +569,14 @@ static void vsp1_dl_list_hw_enqueue(struct vsp1_dl_list *dl)
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
@@ -674,15 +634,13 @@ void vsp1_dl_list_commit(struct vsp1_dl_list *dl, bool internal)
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
 
 	dl->internal = internal;
@@ -783,13 +741,6 @@ void vsp1_dlm_setup(struct vsp1_device *vsp1)
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
@@ -824,8 +775,6 @@ struct vsp1_dl_manager *vsp1_dlm_create(struct vsp1_device *vsp1,
 		return NULL;
 
 	dlm->index = index;
-	dlm->mode = index == 0 && !vsp1->info->uapi
-		  ? VSP1_DL_MODE_HEADERLESS : VSP1_DL_MODE_HEADER;
 	dlm->singleshot = vsp1->info->uapi;
 	dlm->vsp1 = vsp1;
 
@@ -834,13 +783,11 @@ struct vsp1_dl_manager *vsp1_dlm_create(struct vsp1_device *vsp1,
 
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
