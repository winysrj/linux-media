Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40281 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbcCXX2c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2016 19:28:32 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 47/51] v4l: vsp1: dl: Fix race conditions
Date: Fri, 25 Mar 2016 01:27:43 +0200
Message-Id: <1458862067-19525-48-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1458862067-19525-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1458862067-19525-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The vsp1_dl_list_put() function expects to be called with the display
list manager lock held. This assumption is correct for calls from within
the vsp1_dl.c file, but not for the external calls. Fix it by taking the
lock inside the function and providing an unlocked version for the
internal callers.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_dl.c | 41 +++++++++++++++++++++++++----------
 1 file changed, 29 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index 8efa5447c1b3..4f2c3c95bfa4 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -164,25 +164,36 @@ struct vsp1_dl_list *vsp1_dl_list_get(struct vsp1_dl_manager *dlm)
 	return dl;
 }
 
+/* This function must be called with the display list manager lock held.*/
+static void __vsp1_dl_list_put(struct vsp1_dl_list *dl)
+{
+	if (!dl)
+		return;
+
+	dl->reg_count = 0;
+
+	list_add_tail(&dl->list, &dl->dlm->free);
+}
+
 /**
  * vsp1_dl_list_put - Release a display list
  * @dl: The display list
  *
  * Release the display list and return it to the pool of free lists.
  *
- * This function must be called with the display list manager lock held.
- *
  * Passing a NULL pointer to this function is safe, in that case no operation
  * will be performed.
  */
 void vsp1_dl_list_put(struct vsp1_dl_list *dl)
 {
+	unsigned long flags;
+
 	if (!dl)
 		return;
 
-	dl->reg_count = 0;
-
-	list_add_tail(&dl->list, &dl->dlm->free);
+	spin_lock_irqsave(&dl->dlm->lock, flags);
+	__vsp1_dl_list_put(dl);
+	spin_unlock_irqrestore(&dl->dlm->lock, flags);
 }
 
 void vsp1_dl_list_write(struct vsp1_dl_list *dl, u32 reg, u32 data)
@@ -220,7 +231,7 @@ void vsp1_dl_list_commit(struct vsp1_dl_list *dl)
 	 */
 	update = !!(vsp1_read(vsp1, VI6_DL_BODY_SIZE) & VI6_DL_BODY_SIZE_UPD);
 	if (update) {
-		vsp1_dl_list_put(dlm->pending);
+		__vsp1_dl_list_put(dlm->pending);
 		dlm->pending = dl;
 		goto done;
 	}
@@ -233,7 +244,7 @@ void vsp1_dl_list_commit(struct vsp1_dl_list *dl)
 	vsp1_write(vsp1, VI6_DL_BODY_SIZE, VI6_DL_BODY_SIZE_UPD |
 		   (dl->reg_count * 8));
 
-	vsp1_dl_list_put(dlm->queued);
+	__vsp1_dl_list_put(dlm->queued);
 	dlm->queued = dl;
 
 done:
@@ -253,7 +264,7 @@ void vsp1_dlm_irq_display_start(struct vsp1_dl_manager *dlm)
 	 * processing by the device. The active display list, if any, won't be
 	 * accessed anymore and can be reused.
 	 */
-	vsp1_dl_list_put(dlm->active);
+	__vsp1_dl_list_put(dlm->active);
 	dlm->active = NULL;
 
 	spin_unlock(&dlm->lock);
@@ -265,7 +276,7 @@ void vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm)
 
 	spin_lock(&dlm->lock);
 
-	vsp1_dl_list_put(dlm->active);
+	__vsp1_dl_list_put(dlm->active);
 	dlm->active = NULL;
 
 	/* Header mode is used for mem-to-mem pipelines only. We don't need to
@@ -328,9 +339,15 @@ void vsp1_dlm_setup(struct vsp1_device *vsp1)
 
 void vsp1_dlm_reset(struct vsp1_dl_manager *dlm)
 {
-	vsp1_dl_list_put(dlm->active);
-	vsp1_dl_list_put(dlm->queued);
-	vsp1_dl_list_put(dlm->pending);
+	unsigned long flags;
+
+	spin_lock_irqsave(&dlm->lock, flags);
+
+	__vsp1_dl_list_put(dlm->active);
+	__vsp1_dl_list_put(dlm->queued);
+	__vsp1_dl_list_put(dlm->pending);
+
+	spin_unlock_irqrestore(&dlm->lock, flags);
 
 	dlm->active = NULL;
 	dlm->queued = NULL;
-- 
2.7.3

