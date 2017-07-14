Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754663AbdGNQO1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Jul 2017 12:14:27 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH 6/6] v4l: vsp1: Remove old fragment management
Date: Fri, 14 Jul 2017 17:14:15 +0100
Message-Id: <a32eab741de6baef10a2caa2bc8f6080c2036840.1500047489.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.6756808fb978882ae2db0cde7745c7e12b177713.1500047489.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.6756808fb978882ae2db0cde7745c7e12b177713.1500047489.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.6756808fb978882ae2db0cde7745c7e12b177713.1500047489.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.6756808fb978882ae2db0cde7745c7e12b177713.1500047489.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fragments are no longer 'freed' in interrupt context, but instead released back
to their respective pools.

This allows us to remove the garbage collector in the DLM.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_dl.c | 151 ++-------------------------
 1 file changed, 14 insertions(+), 137 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index 95f2303d37b9..07349fc94372 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -146,9 +146,6 @@ struct vsp1_dl_manager {
 	struct vsp1_dl_list *pending;
 
 	struct vsp1_dl_fragment_pool *pool;
-
-	struct work_struct gc_work;
-	struct list_head gc_fragments;
 };
 
 /* -----------------------------------------------------------------------------
@@ -252,90 +249,6 @@ void vsp1_dl_fragment_put(struct vsp1_dl_body *dlb)
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
@@ -392,10 +305,21 @@ static struct vsp1_dl_list *vsp1_dl_list_alloc(struct vsp1_dl_manager *dlm,
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
 	vsp1_dl_fragment_put(dl->body0);
-	list_splice_init(&dl->fragments, &dl->dlm->gc_fragments);
+	vsp1_dl_list_fragments_free(dl);
+
 	kfree(dl);
 }
 
@@ -449,17 +373,9 @@ static void __vsp1_dl_list_put(struct vsp1_dl_list *dl)
 
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
 
+	/* body0 is reused */
 	dl->body0->num_entries = 0;
 
 	list_add_tail(&dl->list, &dl->dlm->free);
@@ -827,40 +743,6 @@ void vsp1_dlm_reset(struct vsp1_dl_manager *dlm)
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
@@ -881,8 +763,6 @@ struct vsp1_dl_manager *vsp1_dlm_create(struct vsp1_device *vsp1,
 
 	spin_lock_init(&dlm->lock);
 	INIT_LIST_HEAD(&dlm->free);
-	INIT_LIST_HEAD(&dlm->gc_fragments);
-	INIT_WORK(&dlm->gc_work, vsp1_dlm_garbage_collect);
 
 	/*
 	 * Initialize the display list body and allocate DMA memory for the body
@@ -919,14 +799,11 @@ void vsp1_dlm_destroy(struct vsp1_dl_manager *dlm)
 	if (!dlm)
 		return;
 
-	cancel_work_sync(&dlm->gc_work);
 
 	list_for_each_entry_safe(dl, next, &dlm->free, list) {
 		list_del(&dl->list);
 		vsp1_dl_list_free(dl);
 	}
 
-	vsp1_dlm_fragments_free(dlm);
-
 	vsp1_dl_fragment_pool_free(dlm->pool);
 }
-- 
git-series 0.9.1
