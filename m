Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:30837 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab1HBJxE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Aug 2011 05:53:04 -0400
Received: from eu_spt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LPA00FX4OSEF7@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 02 Aug 2011 10:53:02 +0100 (BST)
Received: from [127.0.0.1] ([106.10.22.139])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LPA009EPOSC82@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 02 Aug 2011 10:53:01 +0100 (BST)
Date: Tue, 02 Aug 2011 11:53:02 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 4/6] v4l: vb2: integrate dma-contig allocator with shrbuf
In-reply-to: <4E37C7D7.40301@samsung.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <4E37C8FE.1040207@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7BIT
References: <4E37C7D7.40301@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Tomasz Stanislawski <t.stanislaws@samsung.com>

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
  drivers/media/video/videobuf2-dma-contig.c |   90 
++++++++++++++++++++++++++++
  1 files changed, 90 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/videobuf2-dma-contig.c 
b/drivers/media/video/videobuf2-dma-contig.c
index a790a5f..7baac66 100644
--- a/drivers/media/video/videobuf2-dma-contig.c
+++ b/drivers/media/video/videobuf2-dma-contig.c
@@ -13,6 +13,7 @@
  #include <linux/module.h>
  #include <linux/slab.h>
  #include <linux/dma-mapping.h>
+#include <linux/shared-buffer.h>

  #include <media/videobuf2-core.h>
  #include <media/videobuf2-memops.h>
@@ -27,26 +28,57 @@ struct vb2_dc_buf {
      dma_addr_t            paddr;
      unsigned long            size;
      struct vm_area_struct        *vma;
+    struct shrbuf            *sb;
      atomic_t            refcount;
      struct vb2_vmarea_handler    handler;
  };

+struct vb2_dc_shrbuf {
+    struct vb2_dc_buf    *buf;
+    struct shrbuf        sb;
+};
+
  static void vb2_dma_contig_put(void *buf_priv);

+static void __dc_shrbuf_get(struct shrbuf *__sb)
+{
+    struct vb2_dc_shrbuf *sb = container_of(__sb, struct vb2_dc_shrbuf, 
sb);
+    struct vb2_dc_buf *buf = sb->buf;
+
+    atomic_inc(&buf->refcount);
+}
+
+static void __dc_shrbuf_put(struct shrbuf *__sb)
+{
+    struct vb2_dc_shrbuf *sb = container_of(__sb, struct vb2_dc_shrbuf, 
sb);
+    struct vb2_dc_buf *buf = sb->buf;
+
+    vb2_dma_contig_put(buf);
+}
+
  static void *vb2_dma_contig_alloc(void *alloc_ctx, unsigned long size)
  {
      struct vb2_dc_conf *conf = alloc_ctx;
      struct vb2_dc_buf *buf;
+    struct vb2_dc_shrbuf *sb;

      buf = kzalloc(sizeof *buf, GFP_KERNEL);
      if (!buf)
          return ERR_PTR(-ENOMEM);

+    sb = kzalloc(sizeof *sb, GFP_KERNEL);
+    if (!sb) {
+        kfree(buf);
+        return ERR_PTR(-ENOMEM);
+    }
+    buf->sb = &sb->sb;
+
      buf->vaddr = dma_alloc_coherent(conf->dev, size, &buf->paddr,
                      GFP_KERNEL);
      if (!buf->vaddr) {
          dev_err(conf->dev, "dma_alloc_coherent of size %ld failed\n",
              size);
+        kfree(sb);
          kfree(buf);
          return ERR_PTR(-ENOMEM);
      }
@@ -54,6 +86,12 @@ static void *vb2_dma_contig_alloc(void *alloc_ctx, 
unsigned long size)
      buf->conf = conf;
      buf->size = size;

+    sb->buf = buf;
+    sb->sb.get = __dc_shrbuf_get;
+    sb->sb.put = __dc_shrbuf_put;
+    sb->sb.dma_addr = buf->paddr;
+    sb->sb.size = buf->size;
+
      buf->handler.refcount = &buf->refcount;
      buf->handler.put = vb2_dma_contig_put;
      buf->handler.arg = buf;
@@ -70,6 +108,7 @@ static void vb2_dma_contig_put(void *buf_priv)
      if (atomic_dec_and_test(&buf->refcount)) {
          dma_free_coherent(buf->conf->dev, buf->size, buf->vaddr,
                    buf->paddr);
+        kfree(container_of(buf->sb, struct vb2_dc_shrbuf, sb));
          kfree(buf);
      }
  }
@@ -148,6 +187,54 @@ static void vb2_dma_contig_put_userptr(void *mem_priv)
      kfree(buf);
  }

+static void *vb2_dma_contig_import_shrbuf(void *alloc_ctx, int fd)
+{
+    struct vb2_dc_buf *buf;
+    struct shrbuf *sb;
+
+    buf = kzalloc(sizeof *buf, GFP_KERNEL);
+    if (!buf)
+        return ERR_PTR(-ENOMEM);
+
+    sb = shrbuf_import(fd);
+    if (IS_ERR(sb)) {
+        printk(KERN_ERR "Failed acquiring shared buffer from fd %d\n",
+                fd);
+        kfree(buf);
+        return sb;
+    }
+
+    buf->size = sb->size;
+    buf->paddr = sb->dma_addr;
+    buf->sb = sb;
+
+    return buf;
+}
+
+static void vb2_dma_contig_put_shrbuf(void *mem_priv)
+{
+    struct vb2_dc_buf *buf = mem_priv;
+
+    if (!buf)
+        return;
+
+    buf->sb->put(buf->sb);
+    kfree(buf);
+}
+
+static int vb2_dma_contig_export_shrbuf(void *mem_priv)
+{
+    struct vb2_dc_buf *buf = mem_priv;
+
+    if (!buf)
+        return -EINVAL;
+
+    if (!buf->sb)
+        return -EINVAL;
+
+    return shrbuf_export(buf->sb);
+}
+
  const struct vb2_mem_ops vb2_dma_contig_memops = {
      .alloc        = vb2_dma_contig_alloc,
      .put        = vb2_dma_contig_put,
@@ -156,6 +243,9 @@ const struct vb2_mem_ops vb2_dma_contig_memops = {
      .mmap        = vb2_dma_contig_mmap,
      .get_userptr    = vb2_dma_contig_get_userptr,
      .put_userptr    = vb2_dma_contig_put_userptr,
+    .import_shrbuf    = vb2_dma_contig_import_shrbuf,
+    .export_shrbuf    = vb2_dma_contig_export_shrbuf,
+    .put_shrbuf    = vb2_dma_contig_put_shrbuf,
      .num_users    = vb2_dma_contig_num_users,
  };
  EXPORT_SYMBOL_GPL(vb2_dma_contig_memops);
-- 
1.7.6



