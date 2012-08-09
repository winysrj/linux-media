Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:16903 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756475Ab2HIJgn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Aug 2012 05:36:43 -0400
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@linaro.org,
	inki.dae@samsung.com, daniel.vetter@ffwll.ch, rob@ti.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
	jy0922.shim@samsung.com, sw0312.kim@samsung.com,
	dan.j.williams@intel.com, linux-doc@vger.kernel.org
Subject: [PATCH v2 1/2] dma-buf: add reference counting for exporter module
Date: Thu, 09 Aug 2012 11:36:21 +0200
Message-id: <1344504982-30415-2-git-send-email-t.stanislaws@samsung.com>
In-reply-to: <1344504982-30415-1-git-send-email-t.stanislaws@samsung.com>
References: <1344504982-30415-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds reference counting on a module that exported dma-buf and
implements its operations. This prevents the module from being unloaded while
DMABUF file is in use.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Acked-by: Sumit Semwal <sumit.semwal@linaro.org>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
CC: linux-doc@vger.kernel.org
---
 Documentation/dma-buf-sharing.txt |    3 ++-
 drivers/base/dma-buf.c            |    9 ++++++++-
 include/linux/dma-buf.h           |    2 ++
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/Documentation/dma-buf-sharing.txt b/Documentation/dma-buf-sharing.txt
index ad86fb8..2613057 100644
--- a/Documentation/dma-buf-sharing.txt
+++ b/Documentation/dma-buf-sharing.txt
@@ -49,7 +49,8 @@ The dma_buf buffer sharing API usage contains the following steps:
    The buffer exporter announces its wish to export a buffer. In this, it
    connects its own private buffer data, provides implementation for operations
    that can be performed on the exported dma_buf, and flags for the file
-   associated with this buffer.
+   associated with this buffer. The operations structure has owner field.
+   You should initialize this to THIS_MODULE in most cases.
 
    Interface:
       struct dma_buf *dma_buf_export(void *priv, struct dma_buf_ops *ops,
diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
index c30f3e1..a1d9cab 100644
--- a/drivers/base/dma-buf.c
+++ b/drivers/base/dma-buf.c
@@ -27,6 +27,7 @@
 #include <linux/dma-buf.h>
 #include <linux/anon_inodes.h>
 #include <linux/export.h>
+#include <linux/module.h>
 
 static inline int is_dma_buf_file(struct file *);
 
@@ -40,6 +41,7 @@ static int dma_buf_release(struct inode *inode, struct file *file)
 	dmabuf = file->private_data;
 
 	dmabuf->ops->release(dmabuf);
+	module_put(dmabuf->ops->owner);
 	kfree(dmabuf);
 	return 0;
 }
@@ -105,9 +107,14 @@ struct dma_buf *dma_buf_export(void *priv, const struct dma_buf_ops *ops,
 		return ERR_PTR(-EINVAL);
 	}
 
+	if (!try_module_get(ops->owner))
+		return ERR_PTR(-ENOENT);
+
 	dmabuf = kzalloc(sizeof(struct dma_buf), GFP_KERNEL);
-	if (dmabuf == NULL)
+	if (dmabuf == NULL) {
+		module_put(ops->owner);
 		return ERR_PTR(-ENOMEM);
+	}
 
 	dmabuf->priv = priv;
 	dmabuf->ops = ops;
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index eb48f38..22953de 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -37,6 +37,7 @@ struct dma_buf_attachment;
 
 /**
  * struct dma_buf_ops - operations possible on struct dma_buf
+ * @owner: the module that implements dma_buf operations
  * @attach: [optional] allows different devices to 'attach' themselves to the
  *	    given buffer. It might return -EBUSY to signal that backing storage
  *	    is already allocated and incompatible with the requirements
@@ -70,6 +71,7 @@ struct dma_buf_attachment;
  * @vunmap: [optional] unmaps a vmap from the buffer
  */
 struct dma_buf_ops {
+	struct module *owner;
 	int (*attach)(struct dma_buf *, struct device *,
 			struct dma_buf_attachment *);
 
-- 
1.7.9.5

