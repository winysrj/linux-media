Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752199AbdHNPNp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Aug 2017 11:13:45 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: laurent.pinchart@ideasonboard.com,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v2 4/8] v4l: vsp1: Use reference counting for fragments
Date: Mon, 14 Aug 2017 16:13:27 +0100
Message-Id: <d28cb6bce32d33479f5d5b49e67c4c79a9b7b4bc.1502723341.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.4457988ad8b64b5c7636e35039ef61d507af3648.1502723341.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.4457988ad8b64b5c7636e35039ef61d507af3648.1502723341.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.4457988ad8b64b5c7636e35039ef61d507af3648.1502723341.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.4457988ad8b64b5c7636e35039ef61d507af3648.1502723341.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Extend the display list body with a reference count, allowing bodies to
be kept as long as a reference is maintained. This provides the ability
to keep a cached copy of bodies which will not change, so that they can
be re-applied to multiple display lists.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

---
This could be squashed into the fragment update code, but it's not a
straightforward squash as the refcounts will affect both:
  v4l: vsp1: Provide a fragment pool
and
  v4l: vsp1: Convert display lists to use new fragment pool
therefore, I have kept this separate to prevent breaking bisectability
of the vsp-tests.
---
 drivers/media/platform/vsp1/vsp1_clu.c |  7 ++++++-
 drivers/media/platform/vsp1/vsp1_dl.c  | 15 ++++++++++++++-
 drivers/media/platform/vsp1/vsp1_lut.c |  7 ++++++-
 3 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_clu.c b/drivers/media/platform/vsp1/vsp1_clu.c
index 52c523625e2f..175717018e11 100644
--- a/drivers/media/platform/vsp1/vsp1_clu.c
+++ b/drivers/media/platform/vsp1/vsp1_clu.c
@@ -257,8 +257,13 @@ static void clu_configure(struct vsp1_entity *entity,
 		clu->clu = NULL;
 		spin_unlock_irqrestore(&clu->lock, flags);
 
-		if (dlb)
+		if (dlb) {
 			vsp1_dl_list_add_fragment(dl, dlb);
+
+			/* release our local reference */
+			vsp1_dl_fragment_put(dlb);
+		}
+
 		break;
 	}
 }
diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index 6ffdc3549283..37feda248946 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -14,6 +14,7 @@
 #include <linux/device.h>
 #include <linux/dma-mapping.h>
 #include <linux/gfp.h>
+#include <linux/refcount.h>
 #include <linux/slab.h>
 #include <linux/workqueue.h>
 
@@ -58,6 +59,8 @@ struct vsp1_dl_body {
 	struct list_head list;
 	struct list_head free;
 
+	refcount_t refcnt;
+
 	struct vsp1_dl_fragment_pool *pool;
 	struct vsp1_device *vsp1;
 
@@ -230,6 +233,7 @@ struct vsp1_dl_body *vsp1_dl_fragment_get(struct vsp1_dl_fragment_pool *pool)
 	if (!list_empty(&pool->free)) {
 		dlb = list_first_entry(&pool->free, struct vsp1_dl_body, free);
 		list_del(&dlb->free);
+		refcount_set(&dlb->refcnt, 1);
 	}
 
 	spin_unlock_irqrestore(&pool->lock, flags);
@@ -244,6 +248,9 @@ void vsp1_dl_fragment_put(struct vsp1_dl_body *dlb)
 	if (!dlb)
 		return;
 
+	if (!refcount_dec_and_test(&dlb->refcnt))
+		return;
+
 	dlb->num_entries = 0;
 
 	spin_lock_irqsave(&dlb->pool->lock, flags);
@@ -428,7 +435,11 @@ void vsp1_dl_list_write(struct vsp1_dl_list *dl, u32 reg, u32 data)
  * list, in the order in which fragments are added.
  *
  * Adding a fragment to a display list passes ownership of the fragment to the
- * list. The caller must not touch the fragment after this call.
+ * list. The caller must not modify the fragment after this call, but can retain
+ * a reference to it for future use if necessary, to add to subsequent lists.
+ *
+ * The reference count of the body is incremented by this attachment, and thus
+ * the caller should release it's reference if does not want to cache the body.
  *
  * Fragments are only usable for display lists in header mode. Attempt to
  * add a fragment to a header-less display list will return an error.
@@ -440,6 +451,8 @@ int vsp1_dl_list_add_fragment(struct vsp1_dl_list *dl,
 	if (dl->dlm->mode != VSP1_DL_MODE_HEADER)
 		return -EINVAL;
 
+	refcount_inc(&dlb->refcnt);
+
 	list_add_tail(&dlb->list, &dl->fragments);
 	return 0;
 }
diff --git a/drivers/media/platform/vsp1/vsp1_lut.c b/drivers/media/platform/vsp1/vsp1_lut.c
index 57482e057e54..388bd89ade0b 100644
--- a/drivers/media/platform/vsp1/vsp1_lut.c
+++ b/drivers/media/platform/vsp1/vsp1_lut.c
@@ -213,8 +213,13 @@ static void lut_configure(struct vsp1_entity *entity,
 		lut->lut = NULL;
 		spin_unlock_irqrestore(&lut->lock, flags);
 
-		if (dlb)
+		if (dlb) {
 			vsp1_dl_list_add_fragment(dl, dlb);
+
+			/* release our local reference */
+			vsp1_dl_fragment_put(dlb);
+		}
+
 		break;
 	}
 }
-- 
git-series 0.9.1
