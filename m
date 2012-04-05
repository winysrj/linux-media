Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:58994 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227Ab2DEOAh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Apr 2012 10:00:37 -0400
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M200021BEWSKP@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 05 Apr 2012 15:00:29 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M2000D6EEWVUI@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 05 Apr 2012 15:00:32 +0100 (BST)
Date: Thu, 05 Apr 2012 16:00:03 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 06/11] v4l: vb2-dma-contig: Remove unneeded allocation context
 structure
In-reply-to: <1333634408-4960-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	subashrp@gmail.com
Message-id: <1333634408-4960-7-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1333634408-4960-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

vb2-dma-contig returns a vb2_dc_conf structure instance as the vb2
allocation context. That structure only stores a pointer to the physical
device. Remove it and use the device pointer directly as the allocation
context.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
---
 drivers/media/video/videobuf2-dma-contig.c |   29 ++++++---------------------
 1 files changed, 7 insertions(+), 22 deletions(-)

diff --git a/drivers/media/video/videobuf2-dma-contig.c b/drivers/media/video/videobuf2-dma-contig.c
index 5207eb1..ff0a662 100644
--- a/drivers/media/video/videobuf2-dma-contig.c
+++ b/drivers/media/video/videobuf2-dma-contig.c
@@ -17,12 +17,8 @@
 #include <media/videobuf2-core.h>
 #include <media/videobuf2-memops.h>
 
-struct vb2_dc_conf {
-	struct device		*dev;
-};
-
 struct vb2_dc_buf {
-	struct vb2_dc_conf		*conf;
+	struct device			*dev;
 	void				*vaddr;
 	dma_addr_t			dma_addr;
 	unsigned long			size;
@@ -35,23 +31,21 @@ static void vb2_dc_put(void *buf_priv);
 
 static void *vb2_dc_alloc(void *alloc_ctx, unsigned long size)
 {
-	struct vb2_dc_conf *conf = alloc_ctx;
+	struct device *dev = alloc_ctx;
 	struct vb2_dc_buf *buf;
 
 	buf = kzalloc(sizeof *buf, GFP_KERNEL);
 	if (!buf)
 		return ERR_PTR(-ENOMEM);
 
-	buf->vaddr = dma_alloc_coherent(conf->dev, size, &buf->dma_addr,
-					GFP_KERNEL);
+	buf->vaddr = dma_alloc_coherent(dev, size, &buf->dma_addr, GFP_KERNEL);
 	if (!buf->vaddr) {
-		dev_err(conf->dev, "dma_alloc_coherent of size %ld failed\n",
-			size);
+		dev_err(dev, "dma_alloc_coherent of size %ld failed\n", size);
 		kfree(buf);
 		return ERR_PTR(-ENOMEM);
 	}
 
-	buf->conf = conf;
+	buf->dev = dev;
 	buf->size = size;
 
 	buf->handler.refcount = &buf->refcount;
@@ -68,7 +62,7 @@ static void vb2_dc_put(void *buf_priv)
 	struct vb2_dc_buf *buf = buf_priv;
 
 	if (atomic_dec_and_test(&buf->refcount)) {
-		dma_free_coherent(buf->conf->dev, buf->size, buf->vaddr,
+		dma_free_coherent(buf->dev, buf->size, buf->vaddr,
 				  buf->dma_addr);
 		kfree(buf);
 	}
@@ -162,21 +156,12 @@ EXPORT_SYMBOL_GPL(vb2_dma_contig_memops);
 
 void *vb2_dma_contig_init_ctx(struct device *dev)
 {
-	struct vb2_dc_conf *conf;
-
-	conf = kzalloc(sizeof *conf, GFP_KERNEL);
-	if (!conf)
-		return ERR_PTR(-ENOMEM);
-
-	conf->dev = dev;
-
-	return conf;
+	return dev;
 }
 EXPORT_SYMBOL_GPL(vb2_dma_contig_init_ctx);
 
 void vb2_dma_contig_cleanup_ctx(void *alloc_ctx)
 {
-	kfree(alloc_ctx);
 }
 EXPORT_SYMBOL_GPL(vb2_dma_contig_cleanup_ctx);
 
-- 
1.7.5.4

