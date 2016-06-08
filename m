Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:43859 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755741AbcFHX6Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jun 2016 19:58:25 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 2/5] v4l: vsp1: dl: Don't free fragments with interrupts disabled
Date: Thu,  9 Jun 2016 02:58:13 +0300
Message-Id: <1465430296-22644-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1465430296-22644-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1465430296-22644-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Freeing a fragment requires freeing DMA coherent memory, which can't be
performed with interrupts disabled as per the DMA mapping API contract.
The fragments can't thus be freed synchronously when a display list is
recycled. Instead, move the fragments to a garbage list and use a work
queue to run the garbage collection.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_dl.c | 72 ++++++++++++++++++++++++++++-------
 1 file changed, 58 insertions(+), 14 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index e238d9b9376b..37c3518aa2a8 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -15,6 +15,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/gfp.h>
 #include <linux/slab.h>
+#include <linux/workqueue.h>
 
 #include "vsp1.h"
 #include "vsp1_dl.h"
@@ -92,11 +93,13 @@ enum vsp1_dl_mode {
  * @index: index of the related WPF
  * @mode: display list operation mode (header or headerless)
  * @vsp1: the VSP1 device
- * @lock: protects the active, queued and pending lists
+ * @lock: protects the free, active, queued, pending and gc_fragments lists
  * @free: array of all free display lists
  * @active: list currently being processed (loaded) by hardware
  * @queued: list queued to the hardware (written to the DL registers)
  * @pending: list waiting to be queued to the hardware
+ * @gc_work: fragments garbage collector work struct
+ * @gc_fragments: array of display list fragments waiting to be freed
  */
 struct vsp1_dl_manager {
 	unsigned int index;
@@ -108,6 +111,9 @@ struct vsp1_dl_manager {
 	struct vsp1_dl_list *active;
 	struct vsp1_dl_list *queued;
 	struct vsp1_dl_list *pending;
+
+	struct work_struct gc_work;
+	struct list_head gc_fragments;
 };
 
 /* -----------------------------------------------------------------------------
@@ -262,21 +268,10 @@ static struct vsp1_dl_list *vsp1_dl_list_alloc(struct vsp1_dl_manager *dlm)
 	return dl;
 }
 
-static void vsp1_dl_list_free_fragments(struct vsp1_dl_list *dl)
-{
-	struct vsp1_dl_body *dlb, *next;
-
-	list_for_each_entry_safe(dlb, next, &dl->fragments, list) {
-		list_del(&dlb->list);
-		vsp1_dl_body_cleanup(dlb);
-		kfree(dlb);
-	}
-}
-
 static void vsp1_dl_list_free(struct vsp1_dl_list *dl)
 {
 	vsp1_dl_body_cleanup(&dl->body0);
-	vsp1_dl_list_free_fragments(dl);
+	list_splice_init(&dl->fragments, &dl->dlm->gc_fragments);
 	kfree(dl);
 }
 
@@ -311,7 +306,16 @@ static void __vsp1_dl_list_put(struct vsp1_dl_list *dl)
 	if (!dl)
 		return;
 
-	vsp1_dl_list_free_fragments(dl);
+	/* We can't free fragments here as DMA memory can only be freed in
+	 * interruptible context. Move all fragments to the display list
+	 * manager's list of fragments to be freed, they will be
+	 * garbage-collected by the work queue.
+	 */
+	if (!list_empty(&dl->fragments)) {
+		list_splice_init(&dl->fragments, &dl->dlm->gc_fragments);
+		schedule_work(&dl->dlm->gc_work);
+	}
+
 	dl->body0.num_entries = 0;
 
 	list_add_tail(&dl->list, &dl->dlm->free);
@@ -550,6 +554,40 @@ void vsp1_dlm_reset(struct vsp1_dl_manager *dlm)
 	dlm->pending = NULL;
 }
 
+/*
+ * Free all fragments awaiting to be garbage-collected.
+ *
+ * This function must be called without the display list manager lock held.
+ */
+static void vsp1_dlm_fragments_free(struct vsp1_dl_manager *dlm)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&dlm->lock, flags);
+
+	while (!list_empty(&dlm->gc_fragments)) {
+		struct vsp1_dl_body *dlb;
+
+		dlb = list_first_entry(&dlm->gc_fragments, struct vsp1_dl_body,
+				       list);
+		list_del(&dlb->list);
+
+		spin_unlock_irqrestore(&dlm->lock, flags);
+		vsp1_dl_fragment_free(dlb);
+		spin_lock_irqsave(&dlm->lock, flags);
+	}
+
+	spin_unlock_irqrestore(&dlm->lock, flags);
+}
+
+static void vsp1_dlm_garbage_collect(struct work_struct *work)
+{
+	struct vsp1_dl_manager *dlm =
+		container_of(work, struct vsp1_dl_manager, gc_work);
+
+	vsp1_dlm_fragments_free(dlm);
+}
+
 struct vsp1_dl_manager *vsp1_dlm_create(struct vsp1_device *vsp1,
 					unsigned int index,
 					unsigned int prealloc)
@@ -568,6 +606,8 @@ struct vsp1_dl_manager *vsp1_dlm_create(struct vsp1_device *vsp1,
 
 	spin_lock_init(&dlm->lock);
 	INIT_LIST_HEAD(&dlm->free);
+	INIT_LIST_HEAD(&dlm->gc_fragments);
+	INIT_WORK(&dlm->gc_work, vsp1_dlm_garbage_collect);
 
 	for (i = 0; i < prealloc; ++i) {
 		struct vsp1_dl_list *dl;
@@ -589,8 +629,12 @@ void vsp1_dlm_destroy(struct vsp1_dl_manager *dlm)
 	if (!dlm)
 		return;
 
+	cancel_work_sync(&dlm->gc_work);
+
 	list_for_each_entry_safe(dl, next, &dlm->free, list) {
 		list_del(&dl->list);
 		vsp1_dl_list_free(dl);
 	}
+
+	vsp1_dlm_fragments_free(dlm);
 }
-- 
Regards,

Laurent Pinchart

