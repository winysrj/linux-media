Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:44029 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756479Ab2CRXU0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Mar 2012 19:20:26 -0400
Received: by wibhj6 with SMTP id hj6so3097207wib.1
        for <linux-media@vger.kernel.org>; Sun, 18 Mar 2012 16:20:25 -0700 (PDT)
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: linaro-mm-sig@lists.linaro.org,
	LKML <linux-kernel@vger.kernel.org>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	linux-media@vger.kernel.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 1/4] dma-buf: don't hold the mutex around map/unmap calls
Date: Mon, 19 Mar 2012 00:34:25 +0100
Message-Id: <1332113668-4364-1-git-send-email-daniel.vetter@ffwll.ch>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The mutex protects the attachment list and hence needs to be held
around the callbakc to the exporters (optional) attach/detach
functions.

Holding the mutex around the map/unmap calls doesn't protect any
dma_buf state. Exporters need to properly protect any of their own
state anyway (to protect against calls from their own interfaces).
So this only makes the locking messier (and lockdep easier to anger).

Therefore let's just drop this.

v2: Rebased on top of latest dma-buf-next git.

Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Rob Clark <rob.clark@linaro.org>
---
 drivers/base/dma-buf.c  |    5 -----
 include/linux/dma-buf.h |    2 +-
 2 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
index 3c8c023..5641b9c 100644
--- a/drivers/base/dma-buf.c
+++ b/drivers/base/dma-buf.c
@@ -258,9 +258,7 @@ struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *attach,
 	if (WARN_ON(!attach || !attach->dmabuf))
 		return ERR_PTR(-EINVAL);
 
-	mutex_lock(&attach->dmabuf->lock);
 	sg_table = attach->dmabuf->ops->map_dma_buf(attach, direction);
-	mutex_unlock(&attach->dmabuf->lock);
 
 	return sg_table;
 }
@@ -282,10 +280,7 @@ void dma_buf_unmap_attachment(struct dma_buf_attachment *attach,
 	if (WARN_ON(!attach || !attach->dmabuf || !sg_table))
 		return;
 
-	mutex_lock(&attach->dmabuf->lock);
 	attach->dmabuf->ops->unmap_dma_buf(attach, sg_table,
 						direction);
-	mutex_unlock(&attach->dmabuf->lock);
-
 }
 EXPORT_SYMBOL_GPL(dma_buf_unmap_attachment);
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index bc4203dc..24e0f48 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -88,7 +88,7 @@ struct dma_buf {
 	struct file *file;
 	struct list_head attachments;
 	const struct dma_buf_ops *ops;
-	/* mutex to serialize list manipulation and other ops */
+	/* mutex to serialize list manipulation and attach/detach */
 	struct mutex lock;
 	void *priv;
 };
-- 
1.7.7.5

