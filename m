Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58259 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758557Ab2CAPW2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Mar 2012 10:22:28 -0500
Received: by mail-ww0-f44.google.com with SMTP id dr13so680683wgb.1
        for <linux-media@vger.kernel.org>; Thu, 01 Mar 2012 07:22:28 -0800 (PST)
MIME-Version: 1.0
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: linaro-mm-sig@lists.linaro.org,
	LKML <linux-kernel@vger.kernel.org>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	linux-media@vger.kernel.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 1/3] dma-buf: don't hold the mutex around map/unmap calls
Date: Thu,  1 Mar 2012 16:35:59 +0100
Message-Id: <1330616161-1937-2-git-send-email-daniel.vetter@ffwll.ch>
In-Reply-To: <1330616161-1937-1-git-send-email-daniel.vetter@ffwll.ch>
References: <1330616161-1937-1-git-send-email-daniel.vetter@ffwll.ch>
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

Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/base/dma-buf.c  |    4 ----
 include/linux/dma-buf.h |    2 +-
 2 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
index e38ad24..1b11192 100644
--- a/drivers/base/dma-buf.c
+++ b/drivers/base/dma-buf.c
@@ -258,10 +258,8 @@ struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *attach,
 	if (WARN_ON(!attach || !attach->dmabuf || !attach->dmabuf->ops))
 		return ERR_PTR(-EINVAL);
 
-	mutex_lock(&attach->dmabuf->lock);
 	if (attach->dmabuf->ops->map_dma_buf)
 		sg_table = attach->dmabuf->ops->map_dma_buf(attach, direction);
-	mutex_unlock(&attach->dmabuf->lock);
 
 	return sg_table;
 }
@@ -282,10 +280,8 @@ void dma_buf_unmap_attachment(struct dma_buf_attachment *attach,
 			    || !attach->dmabuf->ops))
 		return;
 
-	mutex_lock(&attach->dmabuf->lock);
 	if (attach->dmabuf->ops->unmap_dma_buf)
 		attach->dmabuf->ops->unmap_dma_buf(attach, sg_table);
-	mutex_unlock(&attach->dmabuf->lock);
 
 }
 EXPORT_SYMBOL_GPL(dma_buf_unmap_attachment);
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index f8ac076..f7ad2ca 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -86,7 +86,7 @@ struct dma_buf {
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

