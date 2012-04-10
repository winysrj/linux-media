Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:16881 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758721Ab2DJNKx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Apr 2012 09:10:53 -0400
Received: from euspt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M2900LLSLWHV7@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 10 Apr 2012 14:09:54 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M2900ML4LY1QL@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 10 Apr 2012 14:10:49 +0100 (BST)
Date: Tue, 10 Apr 2012 15:10:40 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [RFC 06/13] v4l: vb2-dma-contig: add vmap/kmap for dmabuf exporting
In-reply-to: <1334063447-16824-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	subashrp@gmail.com, mchehab@redhat.com
Message-id: <1334063447-16824-7-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1334063447-16824-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for vmap and kmap callbacks
for DMABUF exporter.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/videobuf2-dma-contig.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/videobuf2-dma-contig.c b/drivers/media/video/videobuf2-dma-contig.c
index e1ad47e..537926b 100644
--- a/drivers/media/video/videobuf2-dma-contig.c
+++ b/drivers/media/video/videobuf2-dma-contig.c
@@ -403,11 +403,28 @@ static void vb2_dc_dmabuf_ops_release(struct dma_buf *dbuf)
 	vb2_dc_put(dbuf->priv);
 }
 
+static void *vb2_dc_dmabuf_ops_kmap(struct dma_buf *dbuf, unsigned long pgnum)
+{
+	struct vb2_dc_buf *buf = dbuf->priv;
+
+	return buf->vaddr + pgnum * PAGE_SIZE;
+}
+
+static void *vb2_dc_dmabuf_ops_vmap(struct dma_buf *dbuf)
+{
+	struct vb2_dc_buf *buf = dbuf->priv;
+
+	return buf->vaddr;
+}
+
 static struct dma_buf_ops vb2_dc_dmabuf_ops = {
 	.attach = vb2_dc_dmabuf_ops_attach,
 	.detach = vb2_dc_dmabuf_ops_detach,
 	.map_dma_buf = vb2_dc_dmabuf_ops_map,
 	.unmap_dma_buf = vb2_dc_dmabuf_ops_unmap,
+	.kmap = vb2_dc_dmabuf_ops_kmap,
+	.kmap_atomic = vb2_dc_dmabuf_ops_kmap,
+	.vmap = vb2_dc_dmabuf_ops_vmap,
 	.release = vb2_dc_dmabuf_ops_release,
 };
 
-- 
1.7.5.4

