Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f41.google.com ([209.85.210.41]:57724 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827Ab3CYLVW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Mar 2013 07:21:22 -0400
Received: by mail-da0-f41.google.com with SMTP id w4so3197400dam.28
        for <linux-media@vger.kernel.org>; Mon, 25 Mar 2013 04:21:21 -0700 (PDT)
From: Sumit Semwal <sumit.semwal@linaro.org>
To: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org
Cc: patches@linaro.org, linaro-kernel@lists.linaro.org,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 1/2] dma-buf: replace dma_buf_export() with dma_buf_export_named()
Date: Mon, 25 Mar 2013 16:50:45 +0530
Message-Id: <1364210447-8125-2-git-send-email-sumit.semwal@linaro.org>
In-Reply-To: <1364210447-8125-1-git-send-email-sumit.semwal@linaro.org>
References: <1364210447-8125-1-git-send-email-sumit.semwal@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For debugging purposes, it is useful to have a name-string added
while exporting buffers. Hence, dma_buf_export() is replaced with
dma_buf_export_named(), which additionally takes 'exp_name' as a
parameter.

For backward compatibility, and for lazy exporters who don't wish to
name themselves, a #define dma_buf_export() is also made available,
which adds a __FILE__ instead of 'exp_name'.

Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
  [Thanks for the idea!]
Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
---
 Documentation/dma-buf-sharing.txt |   13 +++++++++++--
 drivers/base/dma-buf.c            |   11 +++++++----
 include/linux/dma-buf.h           |   11 +++++++++--
 3 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/Documentation/dma-buf-sharing.txt b/Documentation/dma-buf-sharing.txt
index 4966b1b..0b23261 100644
--- a/Documentation/dma-buf-sharing.txt
+++ b/Documentation/dma-buf-sharing.txt
@@ -52,14 +52,23 @@ The dma_buf buffer sharing API usage contains the following steps:
    associated with this buffer.
 
    Interface:
-      struct dma_buf *dma_buf_export(void *priv, struct dma_buf_ops *ops,
-				     size_t size, int flags)
+      struct dma_buf *dma_buf_export_named(void *priv, struct dma_buf_ops *ops,
+				     size_t size, int flags,
+				     const char *exp_name)
 
    If this succeeds, dma_buf_export allocates a dma_buf structure, and returns a
    pointer to the same. It also associates an anonymous file with this buffer,
    so it can be exported. On failure to allocate the dma_buf object, it returns
    NULL.
 
+   'exp_name' is the name of exporter - to facilitate information while
+   debugging.
+
+   Exporting modules which do not wish to provide any specific name may use the
+   helper define 'dma_buf_export()', with the same arguments as above, but
+   without the last argument; a __FILE__ pre-processor directive will be
+   inserted in place of 'exp_name' instead.
+
 2. Userspace gets a handle to pass around to potential buffer-users
 
    Userspace entity requests for a file-descriptor (fd) which is a handle to the
diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
index 2a7cb0d..d89102a 100644
--- a/drivers/base/dma-buf.c
+++ b/drivers/base/dma-buf.c
@@ -77,22 +77,24 @@ static inline int is_dma_buf_file(struct file *file)
 }
 
 /**
- * dma_buf_export - Creates a new dma_buf, and associates an anon file
+ * dma_buf_export_named - Creates a new dma_buf, and associates an anon file
  * with this buffer, so it can be exported.
  * Also connect the allocator specific data and ops to the buffer.
+ * Additionally, provide a name string for exporter; useful in debugging.
  *
  * @priv:	[in]	Attach private data of allocator to this buffer
  * @ops:	[in]	Attach allocator-defined dma buf ops to the new buffer.
  * @size:	[in]	Size of the buffer
  * @flags:	[in]	mode flags for the file.
+ * @exp_name:	[in]	name of the exporting module - useful for debugging.
  *
  * Returns, on success, a newly created dma_buf object, which wraps the
  * supplied private data and operations for dma_buf_ops. On either missing
  * ops, or error in allocating struct dma_buf, will return negative error.
  *
  */
-struct dma_buf *dma_buf_export(void *priv, const struct dma_buf_ops *ops,
-				size_t size, int flags)
+struct dma_buf *dma_buf_export_named(void *priv, const struct dma_buf_ops *ops,
+				size_t size, int flags, const char *exp_name)
 {
 	struct dma_buf *dmabuf;
 	struct file *file;
@@ -114,6 +116,7 @@ struct dma_buf *dma_buf_export(void *priv, const struct dma_buf_ops *ops,
 	dmabuf->priv = priv;
 	dmabuf->ops = ops;
 	dmabuf->size = size;
+	dmabuf->exp_name = exp_name;
 
 	file = anon_inode_getfile("dmabuf", &dma_buf_fops, dmabuf, flags);
 
@@ -124,7 +127,7 @@ struct dma_buf *dma_buf_export(void *priv, const struct dma_buf_ops *ops,
 
 	return dmabuf;
 }
-EXPORT_SYMBOL_GPL(dma_buf_export);
+EXPORT_SYMBOL_GPL(dma_buf_export_named);
 
 
 /**
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index 9978b61..6f55c04 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -112,6 +112,7 @@ struct dma_buf_ops {
  * @file: file pointer used for sharing buffers across, and for refcounting.
  * @attachments: list of dma_buf_attachment that denotes all devices attached.
  * @ops: dma_buf_ops associated with this buffer object.
+ * @exp_name: name of the exporter; useful for debugging.
  * @priv: exporter specific private data for this buffer object.
  */
 struct dma_buf {
@@ -123,6 +124,7 @@ struct dma_buf {
 	struct mutex lock;
 	unsigned vmapping_counter;
 	void *vmap_ptr;
+	const char *exp_name;
 	void *priv;
 };
 
@@ -162,8 +164,13 @@ struct dma_buf_attachment *dma_buf_attach(struct dma_buf *dmabuf,
 							struct device *dev);
 void dma_buf_detach(struct dma_buf *dmabuf,
 				struct dma_buf_attachment *dmabuf_attach);
-struct dma_buf *dma_buf_export(void *priv, const struct dma_buf_ops *ops,
-			       size_t size, int flags);
+
+struct dma_buf *dma_buf_export_named(void *priv, const struct dma_buf_ops *ops,
+			       size_t size, int flags, const char *);
+
+#define dma_buf_export(priv, ops, size, flags)	\
+	dma_buf_export_named(priv, ops, size, flags, __FILE__)
+
 int dma_buf_fd(struct dma_buf *dmabuf, int flags);
 struct dma_buf *dma_buf_get(int fd);
 void dma_buf_put(struct dma_buf *dmabuf);
-- 
1.7.10.4

