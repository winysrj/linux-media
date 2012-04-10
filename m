Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:19427 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758722Ab2DJNKx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Apr 2012 09:10:53 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M290051MLYALQ70@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 10 Apr 2012 14:10:58 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M2900ENBLY3XY@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 10 Apr 2012 14:10:51 +0100 (BST)
Date: Tue, 10 Apr 2012 15:10:41 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [RFC 07/13] v4l: vb2-dma-contig: change map/unmap behaviour for
 importers
In-reply-to: <1334063447-16824-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	subashrp@gmail.com, mchehab@redhat.com
Message-id: <1334063447-16824-8-git-send-email-t.stanislaws@samsung.com>
References: <1334063447-16824-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The DMABUF documentation says that the map_dma_buf callback should return
scatterlist that is mapped into a caller's address space. In practice, almost
none of existing implementations of DMABUF exporter does it.  This patch breaks
the DMABUF specification in order to allow exchange DMABUF buffers between
other APIs like DRM.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/videobuf2-dma-contig.c |   22 +++++++++++++++++-----
 1 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/videobuf2-dma-contig.c b/drivers/media/video/videobuf2-dma-contig.c
index 537926b..7f4a58a 100644
--- a/drivers/media/video/videobuf2-dma-contig.c
+++ b/drivers/media/video/videobuf2-dma-contig.c
@@ -652,7 +652,7 @@ static int vb2_dc_map_dmabuf(void *mem_priv)
 	struct vb2_dc_buf *buf = mem_priv;
 	struct sg_table *sgt;
 	unsigned long contig_size;
-	int ret = 0;
+	int ret = -EFAULT;
 
 	if (WARN_ON(!buf->db_attach)) {
 		printk(KERN_ERR "trying to pin a non attached buffer\n");
@@ -671,12 +671,20 @@ static int vb2_dc_map_dmabuf(void *mem_priv)
 		return -EINVAL;
 	}
 
+	/* mapping new sglist to the client */
+	sgt->nents = dma_map_sg(buf->dev, sgt->sgl, sgt->orig_nents,
+		buf->dma_dir);
+	if (sgt->nents <= 0) {
+		printk(KERN_ERR "failed to map scatterlist\n");
+		goto fail_map_attachment;
+	}
+
 	/* checking if dmabuf is big enough to store contiguous chunk */
 	contig_size = vb2_dc_get_contiguous_size(sgt);
 	if (contig_size < buf->size) {
-		printk(KERN_ERR "contiguous chunk of dmabuf is too small\n");
-		ret = -EFAULT;
-		goto fail_map;
+		printk(KERN_ERR "contiguous chunk is too small %lu/%lu b\n",
+			contig_size, buf->size);
+		goto fail_map_sg;
 	}
 
 	buf->dma_addr = sg_dma_address(sgt->sgl);
@@ -684,7 +692,10 @@ static int vb2_dc_map_dmabuf(void *mem_priv)
 
 	return 0;
 
-fail_map:
+fail_map_sg:
+	dma_unmap_sg(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
+
+fail_map_attachment:
 	dma_buf_unmap_attachment(buf->db_attach, sgt, buf->dma_dir);
 
 	return ret;
@@ -705,6 +716,7 @@ static void vb2_dc_unmap_dmabuf(void *mem_priv)
 		return;
 	}
 
+	dma_unmap_sg(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
 	dma_buf_unmap_attachment(buf->db_attach, sgt, buf->dma_dir);
 
 	buf->dma_addr = 0;
-- 
1.7.5.4

