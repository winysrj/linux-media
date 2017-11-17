Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965777AbdKQPrp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Nov 2017 10:47:45 -0500
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: laurent.pinchart@ideasonboard.com, kieran.bingham@ideasonboard.com
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v4 5/9] v4l: vsp1: Use reference counting for bodies
Date: Fri, 17 Nov 2017 15:47:28 +0000
Message-Id: <e465323b2e2c0717edf3d62dd969bbbffb32ac82.1510933306.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.04beabdebfb3483e7f009337bc09953e6d78701d.1510933306.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.04beabdebfb3483e7f009337bc09953e6d78701d.1510933306.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.04beabdebfb3483e7f009337bc09953e6d78701d.1510933306.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.04beabdebfb3483e7f009337bc09953e6d78701d.1510933306.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Extend the display list body with a reference count, allowing bodies to
be kept as long as a reference is maintained. This provides the ability
to keep a cached copy of bodies which will not change, so that they can
be re-applied to multiple display lists.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

---
This could be squashed into the body update code, but it's not a
straightforward squash as the refcounts will affect both:
  v4l: vsp1: Provide a body pool
and
  v4l: vsp1: Convert display lists to use new body pool
therefore, I have kept this separate to prevent breaking bisectability
of the vsp-tests.

v3:
 - 's/fragment/body/'

v4:
 - Fix up reference handling comments.
---
 drivers/media/platform/vsp1/vsp1_clu.c |  7 ++++++-
 drivers/media/platform/vsp1/vsp1_dl.c  | 15 ++++++++++++++-
 drivers/media/platform/vsp1/vsp1_lut.c |  7 ++++++-
 3 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_clu.c b/drivers/media/platform/vsp1/vsp1_clu.c
index 2018144470c5..b2a39a6ef7e4 100644
--- a/drivers/media/platform/vsp1/vsp1_clu.c
+++ b/drivers/media/platform/vsp1/vsp1_clu.c
@@ -257,8 +257,13 @@ static void clu_configure(struct vsp1_entity *entity,
 		clu->clu = NULL;
 		spin_unlock_irqrestore(&clu->lock, flags);
 
-		if (dlb)
+		if (dlb) {
 			vsp1_dl_list_add_body(dl, dlb);
+
+			/* release our local reference */
+			vsp1_dl_body_put(dlb);
+		}
+
 		break;
 	}
 }
diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index a64a80f8085f..fb54cbe4c682 100644
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
 	struct vsp1_dl_body_pool *pool;
 	struct vsp1_device *vsp1;
 
@@ -258,6 +261,7 @@ struct vsp1_dl_body *vsp1_dl_body_get(struct vsp1_dl_body_pool *pool)
 	if (!list_empty(&pool->free)) {
 		dlb = list_first_entry(&pool->free, struct vsp1_dl_body, free);
 		list_del(&dlb->free);
+		refcount_set(&dlb->refcnt, 1);
 	}
 
 	spin_unlock_irqrestore(&pool->lock, flags);
@@ -278,6 +282,9 @@ void vsp1_dl_body_put(struct vsp1_dl_body *dlb)
 	if (!dlb)
 		return;
 
+	if (!refcount_dec_and_test(&dlb->refcnt))
+		return;
+
 	dlb->num_entries = 0;
 
 	spin_lock_irqsave(&dlb->pool->lock, flags);
@@ -464,7 +471,11 @@ void vsp1_dl_list_write(struct vsp1_dl_list *dl, u32 reg, u32 data)
  * in the order in which bodies are added.
  *
  * Adding a body to a display list passes ownership of the body to the list. The
- * caller must not touch the body after this call.
+ * caller retains its reference to the fragment when adding it to the display
+ * list, but is not allowed to add new entries to the body.
+ *
+ * The reference must be explicitly released by a call to vsp1_dl_body_put()
+ * when the body isn't needed anymore.
  *
  * Additional bodies are only usable for display lists in header mode.
  * Attempting to add a body to a header-less display list will return an error.
@@ -476,6 +487,8 @@ int vsp1_dl_list_add_body(struct vsp1_dl_list *dl,
 	if (dl->dlm->mode != VSP1_DL_MODE_HEADER)
 		return -EINVAL;
 
+	refcount_inc(&dlb->refcnt);
+
 	list_add_tail(&dlb->list, &dl->bodies);
 	return 0;
 }
diff --git a/drivers/media/platform/vsp1/vsp1_lut.c b/drivers/media/platform/vsp1/vsp1_lut.c
index 262cb72139d6..77cf7137a0f2 100644
--- a/drivers/media/platform/vsp1/vsp1_lut.c
+++ b/drivers/media/platform/vsp1/vsp1_lut.c
@@ -213,8 +213,13 @@ static void lut_configure(struct vsp1_entity *entity,
 		lut->lut = NULL;
 		spin_unlock_irqrestore(&lut->lock, flags);
 
-		if (dlb)
+		if (dlb) {
 			vsp1_dl_list_add_body(dl, dlb);
+
+			/* release our local reference */
+			vsp1_dl_body_put(dlb);
+		}
+
 		break;
 	}
 }
-- 
git-series 0.9.1
