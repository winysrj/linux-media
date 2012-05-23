Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:45664 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab2EWNHu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 09:07:50 -0400
Received: from euspt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M4H00EPN8D0GP@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 May 2012 14:05:25 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M4H00FB18GUCC@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 May 2012 14:07:43 +0100 (BST)
Date: Wed, 23 May 2012 15:07:29 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 06/12] v4l: vb2-dma-contig: add vmap/kmap for dmabuf exporting
In-reply-to: <1337778455-27912-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com, g.liakhovetski@gmx.de
Message-id: <1337778455-27912-7-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1337778455-27912-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for vmap and kmap callbacks
for DMABUF exporter.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/videobuf2-dma-contig.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/media/video/videobuf2-dma-contig.c b/drivers/media/video/videobuf2-dma-contig.c
index b5826e0..59ee81c 100644
--- a/drivers/media/video/videobuf2-dma-contig.c
+++ b/drivers/media/video/videobuf2-dma-contig.c
@@ -419,11 +419,28 @@ static void vb2_dc_dmabuf_ops_release(struct dma_buf *dbuf)
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
1.7.9.5

