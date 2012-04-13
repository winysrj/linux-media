Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:63599 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223Ab2DMPsO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Apr 2012 11:48:14 -0400
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M2F00CGID7ZD4@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 13 Apr 2012 16:48:04 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M2F00A2HD84YO@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 13 Apr 2012 16:48:05 +0100 (BST)
Date: Fri, 13 Apr 2012 17:47:54 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH v4 12/14] v4l: vb2-dma-contig: change map/unmap behaviour for
 importers
In-reply-to: <1334332076-28489-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com
Message-id: <1334332076-28489-13-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1334332076-28489-1-git-send-email-t.stanislaws@samsung.com>
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
 drivers/media/video/videobuf2-dma-contig.c |   21 +++++++++++++++++++--
 1 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/videobuf2-dma-contig.c b/drivers/media/video/videobuf2-dma-contig.c
index a829e7d..0ea3fcd 100644
--- a/drivers/media/video/videobuf2-dma-contig.c
+++ b/drivers/media/video/videobuf2-dma-contig.c
@@ -442,6 +442,7 @@ static int vb2_dc_map_dmabuf(void *mem_priv)
 	struct vb2_dc_buf *buf = mem_priv;
 	struct sg_table *sgt;
 	unsigned long contig_size;
+	int ret = -EFAULT;
 
 	if (WARN_ON(!buf->db_attach)) {
 		printk(KERN_ERR "trying to pin a non attached buffer\n");
@@ -460,19 +461,34 @@ static int vb2_dc_map_dmabuf(void *mem_priv)
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
 		printk(KERN_ERR "contiguous chunk is too small %lu/%lu b\n",
 			contig_size, buf->size);
-		dma_buf_unmap_attachment(buf->db_attach, sgt, buf->dma_dir);
-		return -EFAULT;
+		goto fail_map_sg;
 	}
 
 	buf->dma_addr = sg_dma_address(sgt->sgl);
 	buf->dma_sgt = sgt;
 
 	return 0;
+
+fail_map_sg:
+	dma_unmap_sg(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
+
+fail_map_attachment:
+	dma_buf_unmap_attachment(buf->db_attach, sgt, buf->dma_dir);
+
+	return ret;
 }
 
 static void vb2_dc_unmap_dmabuf(void *mem_priv)
@@ -490,6 +506,7 @@ static void vb2_dc_unmap_dmabuf(void *mem_priv)
 		return;
 	}
 
+	dma_unmap_sg(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
 	dma_buf_unmap_attachment(buf->db_attach, sgt, buf->dma_dir);
 
 	buf->dma_addr = 0;
-- 
1.7.5.4

