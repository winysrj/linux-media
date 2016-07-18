Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35467 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbcGRLQh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 07:16:37 -0400
Received: by mail-wm0-f66.google.com with SMTP id i5so12174062wmg.2
        for <linux-media@vger.kernel.org>; Mon, 18 Jul 2016 04:16:36 -0700 (PDT)
From: Chris Wilson <chris@chris-wilson.co.uk>
To: dri-devel@lists.freedesktop.org
Cc: intel-gfx@lists.freedesktop.org,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org
Subject: [PATCH] dma-buf: Release module reference on creation failure
Date: Mon, 18 Jul 2016 12:16:22 +0100
Message-Id: <1468840582-21469-1-git-send-email-chris@chris-wilson.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If we fail to create the anon file, we need to remember to release the
module reference on the owner.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: linaro-mm-sig@lists.linaro.org
---
 drivers/dma-buf/dma-buf.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 20ce0687b111..ddaee60ae52a 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -334,6 +334,7 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
 	struct reservation_object *resv = exp_info->resv;
 	struct file *file;
 	size_t alloc_size = sizeof(struct dma_buf);
+	int ret;
 
 	if (!exp_info->resv)
 		alloc_size += sizeof(struct reservation_object);
@@ -357,8 +358,8 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
 
 	dmabuf = kzalloc(alloc_size, GFP_KERNEL);
 	if (!dmabuf) {
-		module_put(exp_info->owner);
-		return ERR_PTR(-ENOMEM);
+		ret = -ENOMEM;
+		goto err_module;
 	}
 
 	dmabuf->priv = exp_info->priv;
@@ -379,8 +380,8 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
 	file = anon_inode_getfile("dmabuf", &dma_buf_fops, dmabuf,
 					exp_info->flags);
 	if (IS_ERR(file)) {
-		kfree(dmabuf);
-		return ERR_CAST(file);
+		ret = PTR_ERR(file);
+		goto err_dmabuf;
 	}
 
 	file->f_mode |= FMODE_LSEEK;
@@ -394,6 +395,12 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
 	mutex_unlock(&db_list.lock);
 
 	return dmabuf;
+
+err_dmabuf:
+	kfree(dmabuf);
+err_module:
+	module_put(exp_info->owner);
+	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL_GPL(dma_buf_export);
 
-- 
2.8.1

