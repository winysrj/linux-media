Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35692 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751755AbdFOIYA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Jun 2017 04:24:00 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 6/6] v4l: vsp1: Add support for header display lists in continuous mode
Date: Thu, 15 Jun 2017 11:24:09 +0300
Message-Id: <20170615082409.9523-7-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20170615082409.9523-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20170615082409.9523-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The VSP supports both header and headerless display lists. The latter is
easier to use when the VSP feeds data directly to the DU in continuous
mode, and the driver thus uses headerless display lists for DU operation
and header display lists otherwise.

Headerless display lists are only available on WPF.0. This has never
been an issue so far, as only WPF.0 is connected to the DU. However, on
H3 ES2.0, the VSP-DL instance has both WPF.0 and WPF.1 connected to the
DU. We thus can't use headerless display lists unconditionally for DU
operation.

Implement support for continuous mode with header display lists, and use
it for DU operation on WPF outputs that don't support headerless mode.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_dl.c | 206 ++++++++++++++++++++++------------
 1 file changed, 136 insertions(+), 70 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index 534100581404..dea38de180e6 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -95,6 +95,7 @@ enum vsp1_dl_mode {
  * struct vsp1_dl_manager - Display List manager
  * @index: index of the related WPF
  * @mode: display list operation mode (header or headerless)
+ * @singleshot: execute the display list in single-shot mode
  * @vsp1: the VSP1 device
  * @lock: protects the free, active, queued, pending and gc_fragments lists
  * @free: array of all free display lists
@@ -107,6 +108,7 @@ enum vsp1_dl_mode {
 struct vsp1_dl_manager {
 	unsigned int index;
 	enum vsp1_dl_mode mode;
+	bool singleshot;
 	struct vsp1_device *vsp1;
 
 	spinlock_t lock;
@@ -437,6 +439,7 @@ int vsp1_dl_list_add_chain(struct vsp1_dl_list *head,
 
 static void vsp1_dl_list_fill_header(struct vsp1_dl_list *dl, bool is_last)
 {
+	struct vsp1_dl_manager *dlm = dl->dlm;
 	struct vsp1_dl_header_list *hdr = dl->header->lists;
 	struct vsp1_dl_body *dlb;
 	unsigned int num_lists = 0;
@@ -461,85 +464,154 @@ static void vsp1_dl_list_fill_header(struct vsp1_dl_list *dl, bool is_last)
 
 	dl->header->num_lists = num_lists;
 
-	/*
-	 * If this display list's chain is not empty, we are on a list, where
-	 * the next item in the list is the display list entity which should be
-	 * automatically queued by the hardware.
-	 */
 	if (!list_empty(&dl->chain) && !is_last) {
+		/*
+		 * If this display list's chain is not empty, we are on a list,
+		 * and the next item is the display list that we must queue for
+		 * automatic processing by the hardware.
+		 */
 		struct vsp1_dl_list *next = list_next_entry(dl, chain);
 
 		dl->header->next_header = next->dma;
 		dl->header->flags = VSP1_DLH_AUTO_START;
+	} else if (!dlm->singleshot) {
+		/*
+		 * if the display list manager works in continuous mode, the VSP
+		 * should loop over the display list continuously until
+		 * instructed to do otherwise.
+		 */
+		dl->header->next_header = dl->dma;
+		dl->header->flags = VSP1_DLH_INT_ENABLE | VSP1_DLH_AUTO_START;
 	} else {
+		/*
+		 * Otherwise, in mem-to-mem mode, we work in single-shot mode
+		 * and the next display list must not be started automatically.
+		 */
 		dl->header->flags = VSP1_DLH_INT_ENABLE;
 	}
 }
 
-void vsp1_dl_list_commit(struct vsp1_dl_list *dl)
+static bool vsp1_dl_list_hw_update_pending(struct vsp1_dl_manager *dlm)
 {
-	struct vsp1_dl_manager *dlm = dl->dlm;
 	struct vsp1_device *vsp1 = dlm->vsp1;
-	unsigned long flags;
-	bool update;
-
-	if (dl->dlm->mode == VSP1_DL_MODE_HEADER) {
-		struct vsp1_dl_list *dl_child;
 
-		/*
-		 * In header mode the caller guarantees that the hardware is
-		 * idle at this point.
-		 */
+	if (!dlm->queued)
+		return false;
 
-		/* Fill the header for the head and chained display lists. */
-		vsp1_dl_list_fill_header(dl, list_empty(&dl->chain));
-
-		list_for_each_entry(dl_child, &dl->chain, chain) {
-			bool last = list_is_last(&dl_child->chain, &dl->chain);
-
-			vsp1_dl_list_fill_header(dl_child, last);
-		}
-	}
+	/*
+	 * Check whether the VSP1 has taken the update. In headerless mode the
+	 * hardware indicates this by clearing the UPD bit in the DL_BODY_SIZE
+	 * register. In header mode it indicates this by programming the display
+	 * list address in the DL_HDR_ADDR register.
+	 */
+	if (dlm->mode == VSP1_DL_MODE_HEADERLESS)
+		return !!(vsp1_read(vsp1, VI6_DL_BODY_SIZE)
+			  & VI6_DL_BODY_SIZE_UPD);
+	else
+		return vsp1_read(vsp1, VI6_DL_HDR_ADDR(dlm->index))
+			== dlm->queued->dma;
+}
 
-	spin_lock_irqsave(&dlm->lock, flags);
+static void vsp1_dl_list_hw_enqueue(struct vsp1_dl_list *dl)
+{
+	struct vsp1_dl_manager *dlm = dl->dlm;
+	struct vsp1_dl_list *active = dlm->active;
+	struct vsp1_device *vsp1 = dlm->vsp1;
 
-	if (dl->dlm->mode == VSP1_DL_MODE_HEADER) {
+	if (dlm->mode == VSP1_DL_MODE_HEADERLESS) {
 		/*
-		 * Commit the head display list to hardware. Chained headers
-		 * will auto-start.
+		 * In headerless mode, program the hardware directly with the
+		 * display list body address and size and set the UPD bit. The
+		 * bit will be cleared by the hardware when the display list
+		 * processing starts.
+		 */
+		vsp1_write(vsp1, VI6_DL_HDR_ADDR(0), dl->body0.dma);
+		vsp1_write(vsp1, VI6_DL_BODY_SIZE, VI6_DL_BODY_SIZE_UPD |
+			   (dl->body0.num_entries * sizeof(*dl->header->lists)));
+	} else if (!dlm->singleshot && active) {
+		/*
+		 * In header continuous mode, update the next_header pointer in
+		 * the active list. We need a memory barrier to ensure that the
+		 * new display list headers reach memory before setting the
+		 * next_header pointer.
+		 */
+		wmb();
+		active->header->next_header = dl->dma;
+	} else {
+		/*
+		 * In single-shot mode, or if there's no active list, the
+		 * hardware is idle. Just set the display list address, the
+		 * hardware will be started independently.
 		 */
 		vsp1_write(vsp1, VI6_DL_HDR_ADDR(dlm->index), dl->dma);
-
-		dlm->active = dl;
-		goto done;
 	}
+}
+
+static void vsp1_dl_list_commit_continuous(struct vsp1_dl_list *dl)
+{
+	struct vsp1_dl_manager *dlm = dl->dlm;
 
 	/*
-	 * Once the UPD bit has been set the hardware can start processing the
-	 * display list at any time and we can't touch the address and size
-	 * registers. In that case mark the update as pending, it will be
-	 * queued up to the hardware by the frame end interrupt handler.
+	 * If a previous display list has been queued to the hardware but not
+	 * processed yet, the VSP can start processing it at any time. In that
+	 * case we can't replace the queued list by the new one, as we could
+	 * race with the hardware. We thus mark the update as pending, it will
+	 * be queued up to the hardware by the frame end interrupt handler.
 	 */
-	update = !!(vsp1_read(vsp1, VI6_DL_BODY_SIZE) & VI6_DL_BODY_SIZE_UPD);
-	if (update) {
+	if (vsp1_dl_list_hw_update_pending(dlm)) {
 		__vsp1_dl_list_put(dlm->pending);
 		dlm->pending = dl;
-		goto done;
+		return;
 	}
 
 	/*
-	 * Program the hardware with the display list body address and size.
-	 * The UPD bit will be cleared by the device when the display list is
-	 * processed.
+	 * Pass the new display list to the hardware and mark it as queued. It
+	 * will become active when the hardware starts processing it.
 	 */
-	vsp1_write(vsp1, VI6_DL_HDR_ADDR(0), dl->body0.dma);
-	vsp1_write(vsp1, VI6_DL_BODY_SIZE, VI6_DL_BODY_SIZE_UPD |
-		   (dl->body0.num_entries * sizeof(*dl->header->lists)));
+	vsp1_dl_list_hw_enqueue(dl);
 
 	__vsp1_dl_list_put(dlm->queued);
 	dlm->queued = dl;
+}
+
+static void vsp1_dl_list_commit_singleshot(struct vsp1_dl_list *dl)
+{
+	struct vsp1_dl_manager *dlm = dl->dlm;
+
+	/*
+	 * When working in single-shot mode, the caller guarantees that the
+	 * hardware is idle at this point. Just commit the head display list
+	 * to hardware. Chained lists will be started automatically.
+	 */
+	vsp1_dl_list_hw_enqueue(dl);
+
+	dlm->active = dl;
+}
+
+void vsp1_dl_list_commit(struct vsp1_dl_list *dl)
+{
+	struct vsp1_dl_manager *dlm = dl->dlm;
+	struct vsp1_dl_list *dl_child;
+	unsigned long flags;
+
+	if (dlm->mode == VSP1_DL_MODE_HEADER) {
+		/* Fill the header for the head and chained display lists. */
+		vsp1_dl_list_fill_header(dl, list_empty(&dl->chain));
+
+		list_for_each_entry(dl_child, &dl->chain, chain) {
+			bool last = list_is_last(&dl_child->chain, &dl->chain);
+
+			vsp1_dl_list_fill_header(dl_child, last);
+		}
+	}
+
+	spin_lock_irqsave(&dlm->lock, flags);
+
+	if (dlm->singleshot)
+		vsp1_dl_list_commit_singleshot(dl);
+	else
+		vsp1_dl_list_commit_continuous(dl);
 
-done:
 	spin_unlock_irqrestore(&dlm->lock, flags);
 }
 
@@ -565,28 +637,25 @@ void vsp1_dlm_irq_display_start(struct vsp1_dl_manager *dlm)
 
 void vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm)
 {
-	struct vsp1_device *vsp1 = dlm->vsp1;
-
 	spin_lock(&dlm->lock);
 
-	__vsp1_dl_list_put(dlm->active);
-	dlm->active = NULL;
-
 	/*
-	 * Header mode is used for mem-to-mem pipelines only. We don't need to
-	 * perform any operation as there can't be any new display list queued
-	 * in that case.
+	 * The mem-to-mem pipelines work in single-shot mode. No new display
+	 * list can be queued, we don't have to do anything.
 	 */
-	if (dlm->mode == VSP1_DL_MODE_HEADER)
+	if (dlm->singleshot) {
+		__vsp1_dl_list_put(dlm->active);
+		dlm->active = NULL;
 		goto done;
+	}
 
 	/*
-	 * The UPD bit set indicates that the commit operation raced with the
-	 * interrupt and occurred after the frame end event and UPD clear but
-	 * before interrupt processing. The hardware hasn't taken the update
-	 * into account yet, we'll thus skip one frame and retry.
+	 * If the commit operation raced with the interrupt and occurred after
+	 * the frame end event but before interrupt processing, the hardware
+	 * hasn't taken the update into account yet. We have to skip one frame
+	 * and retry.
 	 */
-	if (vsp1_read(vsp1, VI6_DL_BODY_SIZE) & VI6_DL_BODY_SIZE_UPD)
+	if (vsp1_dl_list_hw_update_pending(dlm))
 		goto done;
 
 	/*
@@ -594,23 +663,19 @@ void vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm)
 	 * frame end interrupt. The display list thus becomes active.
 	 */
 	if (dlm->queued) {
+		__vsp1_dl_list_put(dlm->active);
 		dlm->active = dlm->queued;
 		dlm->queued = NULL;
 	}
 
 	/*
-	 * Now that the UPD bit has been cleared we can queue the next display
-	 * list to the hardware if one has been prepared.
+	 * Now that the VSP has started processing the queued display list, we
+	 * can queue the pending display list to the hardware if one has been
+	 * prepared.
 	 */
 	if (dlm->pending) {
-		struct vsp1_dl_list *dl = dlm->pending;
-
-		vsp1_write(vsp1, VI6_DL_HDR_ADDR(0), dl->body0.dma);
-		vsp1_write(vsp1, VI6_DL_BODY_SIZE, VI6_DL_BODY_SIZE_UPD |
-			   (dl->body0.num_entries *
-			    sizeof(*dl->header->lists)));
-
-		dlm->queued = dl;
+		vsp1_dl_list_hw_enqueue(dlm->pending);
+		dlm->queued = dlm->pending;
 		dlm->pending = NULL;
 	}
 
@@ -701,6 +766,7 @@ struct vsp1_dl_manager *vsp1_dlm_create(struct vsp1_device *vsp1,
 	dlm->index = index;
 	dlm->mode = index == 0 && !vsp1->info->uapi
 		  ? VSP1_DL_MODE_HEADERLESS : VSP1_DL_MODE_HEADER;
+	dlm->singleshot = vsp1->info->uapi;
 	dlm->vsp1 = vsp1;
 
 	spin_lock_init(&dlm->lock);
-- 
Regards,

Laurent Pinchart
