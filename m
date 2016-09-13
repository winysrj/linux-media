Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46920 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759454AbcIMXQk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Sep 2016 19:16:40 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran+renesas@ksquared.org.uk>
Subject: [PATCH 10/13] v4l: vsp1: Support chained display lists
Date: Wed, 14 Sep 2016 02:17:03 +0300
Message-Id: <1473808626-19488-11-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1473808626-19488-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1473808626-19488-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran+renesas@bingham.xyz>

When display lists are linked in a chain, they will be processed
automatically by the hardware, with each list linking to the next. Only
on the last display list will the frame end interrupt be fired to mark
the completion event.

Upon frame-end, the chain will be iterated to release each display list
back to the free list.

The chained lists use case (image partitioning) can require up to 64
lists per frame in the worst case scenario, bump up the number of
preallocated lists.

Signed-off-by: Kieran Bingham <kieran+renesas@bingham.xyz>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_dl.c  | 119 +++++++++++++++++++++++++++------
 drivers/media/platform/vsp1/vsp1_dl.h  |   1 +
 drivers/media/platform/vsp1/vsp1_wpf.c |   2 +-
 3 files changed, 102 insertions(+), 20 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index 37c3518aa2a8..0af3e8fdc714 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -21,7 +21,6 @@
 #include "vsp1_dl.h"
 
 #define VSP1_DL_NUM_ENTRIES		256
-#define VSP1_DL_NUM_LISTS		3
 
 #define VSP1_DLH_INT_ENABLE		(1 << 1)
 #define VSP1_DLH_AUTO_START		(1 << 0)
@@ -71,6 +70,7 @@ struct vsp1_dl_body {
  * @dma: DMA address for the header
  * @body0: first display list body
  * @fragments: list of extra display list bodies
+ * @chain: entry in the display list partition chain
  */
 struct vsp1_dl_list {
 	struct list_head list;
@@ -81,6 +81,9 @@ struct vsp1_dl_list {
 
 	struct vsp1_dl_body body0;
 	struct list_head fragments;
+
+	bool has_chain;
+	struct list_head chain;
 };
 
 enum vsp1_dl_mode {
@@ -262,7 +265,6 @@ static struct vsp1_dl_list *vsp1_dl_list_alloc(struct vsp1_dl_manager *dlm)
 
 		memset(dl->header, 0, sizeof(*dl->header));
 		dl->header->lists[0].addr = dl->body0.dma;
-		dl->header->flags = VSP1_DLH_INT_ENABLE;
 	}
 
 	return dl;
@@ -293,6 +295,11 @@ struct vsp1_dl_list *vsp1_dl_list_get(struct vsp1_dl_manager *dlm)
 	if (!list_empty(&dlm->free)) {
 		dl = list_first_entry(&dlm->free, struct vsp1_dl_list, list);
 		list_del(&dl->list);
+
+		/* The display list chain must be initialised to ensure every
+		 * display list can assert list_empty() if it is not in a chain.
+		 */
+		INIT_LIST_HEAD(&dl->chain);
 	}
 
 	spin_unlock_irqrestore(&dlm->lock, flags);
@@ -303,9 +310,21 @@ struct vsp1_dl_list *vsp1_dl_list_get(struct vsp1_dl_manager *dlm)
 /* This function must be called with the display list manager lock held.*/
 static void __vsp1_dl_list_put(struct vsp1_dl_list *dl)
 {
+	struct vsp1_dl_list *dl_child;
+
 	if (!dl)
 		return;
 
+	/* Release any linked display-lists which were chained for a single
+	 * hardware operation.
+	 */
+	if (dl->has_chain) {
+		list_for_each_entry(dl_child, &dl->chain, chain)
+			__vsp1_dl_list_put(dl_child);
+	}
+
+	dl->has_chain = false;
+
 	/* We can't free fragments here as DMA memory can only be freed in
 	 * interruptible context. Move all fragments to the display list
 	 * manager's list of fragments to be freed, they will be
@@ -383,6 +402,74 @@ int vsp1_dl_list_add_fragment(struct vsp1_dl_list *dl,
 	return 0;
 }
 
+/**
+ * vsp1_dl_list_add_chain - Add a display list to a chain
+ * @head: The head display list
+ * @dl: The new display list
+ *
+ * Add a display list to an existing display list chain. The chained lists
+ * will be automatically processed by the hardware without intervention from
+ * the CPU. A display list end interrupt will only complete after the last
+ * display list in the chain has completed processing.
+ *
+ * Adding a display list to a chain passes ownership of the display list to
+ * the head display list item. The chain is released when the head dl item is
+ * put back with __vsp1_dl_list_put().
+ *
+ * Chained display lists are only usable in header mode. Attempts to add a
+ * display list to a chain in header-less mode will return an error.
+ */
+int vsp1_dl_list_add_chain(struct vsp1_dl_list *head,
+			   struct vsp1_dl_list *dl)
+{
+	/* Chained lists are only available in header mode. */
+	if (head->dlm->mode != VSP1_DL_MODE_HEADER)
+		return -EINVAL;
+
+	head->has_chain = true;
+	list_add_tail(&dl->chain, &head->chain);
+	return 0;
+}
+
+static void vsp1_dl_list_fill_header(struct vsp1_dl_list *dl, bool is_last)
+{
+	struct vsp1_dl_header_list *hdr = dl->header->lists;
+	struct vsp1_dl_body *dlb;
+	unsigned int num_lists = 0;
+
+	/* Fill the header with the display list bodies addresses and sizes. The
+	 * address of the first body has already been filled when the display
+	 * list was allocated.
+	 */
+
+	hdr->num_bytes = dl->body0.num_entries
+		       * sizeof(*dl->header->lists);
+
+	list_for_each_entry(dlb, &dl->fragments, list) {
+		num_lists++;
+		hdr++;
+
+		hdr->addr = dlb->dma;
+		hdr->num_bytes = dlb->num_entries
+			       * sizeof(*dl->header->lists);
+	}
+
+	dl->header->num_lists = num_lists;
+
+	/* If this display list's chain is not empty, we are on a list, where
+	 * the next item in the list is the display list entity which should be
+	 * automatically queued by the hardware.
+	 */
+	if (!list_empty(&dl->chain) && !is_last) {
+		struct vsp1_dl_list *next = list_next_entry(dl, chain);
+
+		dl->header->next_header = next->dma;
+		dl->header->flags = VSP1_DLH_AUTO_START;
+	} else {
+		dl->header->flags = VSP1_DLH_INT_ENABLE;
+	}
+}
+
 void vsp1_dl_list_commit(struct vsp1_dl_list *dl)
 {
 	struct vsp1_dl_manager *dlm = dl->dlm;
@@ -393,30 +480,24 @@ void vsp1_dl_list_commit(struct vsp1_dl_list *dl)
 	spin_lock_irqsave(&dlm->lock, flags);
 
 	if (dl->dlm->mode == VSP1_DL_MODE_HEADER) {
-		struct vsp1_dl_header_list *hdr = dl->header->lists;
-		struct vsp1_dl_body *dlb;
-		unsigned int num_lists = 0;
+		struct vsp1_dl_list *dl_child;
 
-		/* Fill the header with the display list bodies addresses and
-		 * sizes. The address of the first body has already been filled
-		 * when the display list was allocated.
-		 *
-		 * In header mode the caller guarantees that the hardware is
+		/* In header mode the caller guarantees that the hardware is
 		 * idle at this point.
 		 */
-		hdr->num_bytes = dl->body0.num_entries
-			       * sizeof(*dl->header->lists);
 
-		list_for_each_entry(dlb, &dl->fragments, list) {
-			num_lists++;
-			hdr++;
+		/* Fill the header for the head and chained display lists. */
+		vsp1_dl_list_fill_header(dl, list_empty(&dl->chain));
 
-			hdr->addr = dlb->dma;
-			hdr->num_bytes = dlb->num_entries
-				       * sizeof(*dl->header->lists);
+		list_for_each_entry(dl_child, &dl->chain, chain) {
+			bool last = list_is_last(&dl_child->chain, &dl->chain);
+
+			vsp1_dl_list_fill_header(dl_child, last);
 		}
 
-		dl->header->num_lists = num_lists;
+		/* Commit the head display list to hardware. Chained headers
+		 * will auto-start.
+		 */
 		vsp1_write(vsp1, VI6_DL_HDR_ADDR(dlm->index), dl->dma);
 
 		dlm->active = dl;
diff --git a/drivers/media/platform/vsp1/vsp1_dl.h b/drivers/media/platform/vsp1/vsp1_dl.h
index de387cd4d745..7131aa3c5978 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.h
+++ b/drivers/media/platform/vsp1/vsp1_dl.h
@@ -41,5 +41,6 @@ void vsp1_dl_fragment_free(struct vsp1_dl_body *dlb);
 void vsp1_dl_fragment_write(struct vsp1_dl_body *dlb, u32 reg, u32 data);
 int vsp1_dl_list_add_fragment(struct vsp1_dl_list *dl,
 			      struct vsp1_dl_body *dlb);
+int vsp1_dl_list_add_chain(struct vsp1_dl_list *head, struct vsp1_dl_list *dl);
 
 #endif /* __VSP1_DL_H__ */
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index 717c0be58bfb..b757d2579d6c 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -364,7 +364,7 @@ struct vsp1_rwpf *vsp1_wpf_create(struct vsp1_device *vsp1, unsigned int index)
 		return ERR_PTR(ret);
 
 	/* Initialize the display list manager. */
-	wpf->dlm = vsp1_dlm_create(vsp1, index, 4);
+	wpf->dlm = vsp1_dlm_create(vsp1, index, 64);
 	if (!wpf->dlm) {
 		ret = -ENOMEM;
 		goto error;
-- 
Regards,

Laurent Pinchart

