Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:34718 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751095AbeECNf5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 May 2018 09:35:57 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v9 5/8] media: vsp1: Use reference counting for bodies
Date: Thu,  3 May 2018 14:35:44 +0100
Message-Id: <e5d5d96f89a54e4d92dce27ddb14dc1e20d5e4b4.1525354160.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.76b8251c2457cea047ecba892cf0d7a351644051.1525354160.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.76b8251c2457cea047ecba892cf0d7a351644051.1525354160.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.76b8251c2457cea047ecba892cf0d7a351644051.1525354160.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.76b8251c2457cea047ecba892cf0d7a351644051.1525354160.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Extend the display list body with a reference count, allowing bodies to
be kept as long as a reference is maintained. This provides the ability
to keep a cached copy of bodies which will not change, so that they can
be re-applied to multiple display lists.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
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

Changes since v7:

- Fix comment style
---
 drivers/media/platform/vsp1/vsp1_clu.c |  7 ++++++-
 drivers/media/platform/vsp1/vsp1_dl.c  | 16 ++++++++++++++--
 drivers/media/platform/vsp1/vsp1_lut.c |  7 ++++++-
 3 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_clu.c b/drivers/media/platform/vsp1/vsp1_clu.c
index 8efa12f5e53f..ea83f1b7d125 100644
--- a/drivers/media/platform/vsp1/vsp1_clu.c
+++ b/drivers/media/platform/vsp1/vsp1_clu.c
@@ -212,8 +212,13 @@ static void clu_configure(struct vsp1_entity *entity,
 		clu->clu = NULL;
 		spin_unlock_irqrestore(&clu->lock, flags);
 
-		if (dlb)
+		if (dlb) {
 			vsp1_dl_list_add_body(dl, dlb);
+
+			/* Release our local reference. */
+			vsp1_dl_body_put(dlb);
+		}
+
 		break;
 	}
 }
diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index 617c46a03dec..1407c90c6880 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -10,6 +10,7 @@
 #include <linux/device.h>
 #include <linux/dma-mapping.h>
 #include <linux/gfp.h>
+#include <linux/refcount.h>
 #include <linux/slab.h>
 #include <linux/workqueue.h>
 
@@ -54,6 +55,8 @@ struct vsp1_dl_body {
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
@@ -463,8 +470,11 @@ void vsp1_dl_list_write(struct vsp1_dl_list *dl, u32 reg, u32 data)
  * which bodies are added.
  *
  * Adding a body to a display list passes ownership of the body to the list. The
- * caller must not touch the body after this call, and must not release it
- * explicitly with vsp1_dl_body_put().
+ * caller retains its reference to the fragment when adding it to the display
+ * list, but is not allowed to add new entries to the body.
+ *
+ * The reference must be explicitly released by a call to vsp1_dl_body_put()
+ * when the body isn't needed anymore.
  *
  * Additional bodies are only usable for display lists in header mode.
  * Attempting to add a body to a header-less display list will return an error.
@@ -475,6 +485,8 @@ int vsp1_dl_list_add_body(struct vsp1_dl_list *dl, struct vsp1_dl_body *dlb)
 	if (dl->dlm->mode != VSP1_DL_MODE_HEADER)
 		return -EINVAL;
 
+	refcount_inc(&dlb->refcnt);
+
 	list_add_tail(&dlb->list, &dl->bodies);
 
 	return 0;
diff --git a/drivers/media/platform/vsp1/vsp1_lut.c b/drivers/media/platform/vsp1/vsp1_lut.c
index 6b358617ce15..b3ea90172439 100644
--- a/drivers/media/platform/vsp1/vsp1_lut.c
+++ b/drivers/media/platform/vsp1/vsp1_lut.c
@@ -168,8 +168,13 @@ static void lut_configure(struct vsp1_entity *entity,
 		lut->lut = NULL;
 		spin_unlock_irqrestore(&lut->lock, flags);
 
-		if (dlb)
+		if (dlb) {
 			vsp1_dl_list_add_body(dl, dlb);
+
+			/* Release our local reference. */
+			vsp1_dl_body_put(dlb);
+		}
+
 		break;
 	}
 }
-- 
git-series 0.9.1
