Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:47472 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab2EWMKr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 08:10:47 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M4H00EWJ5UAJV10@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 May 2012 13:10:58 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M4H00D9V5TTYM@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 May 2012 13:10:41 +0100 (BST)
Date: Wed, 23 May 2012 14:10:24 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCHv6 10/13] v4l: vb2-dma-contig: add prepare/finish to dma-contig
 allocator
In-reply-to: <1337775027-9489-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com, g.liakhovetski@gmx.de
Message-id: <1337775027-9489-11-git-send-email-t.stanislaws@samsung.com>
References: <1337775027-9489-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Marek Szyprowski <m.szyprowski@samsung.com>

Add prepare/finish callbacks to vb2-dma-contig allocator.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/video/videobuf2-dma-contig.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/media/video/videobuf2-dma-contig.c b/drivers/media/video/videobuf2-dma-contig.c
index 068ec11..bb32e7e 100644
--- a/drivers/media/video/videobuf2-dma-contig.c
+++ b/drivers/media/video/videobuf2-dma-contig.c
@@ -150,6 +150,28 @@ static unsigned int vb2_dc_num_users(void *buf_priv)
 	return atomic_read(&buf->refcount);
 }
 
+static void vb2_dc_prepare(void *buf_priv)
+{
+	struct vb2_dc_buf *buf = buf_priv;
+	struct sg_table *sgt = buf->dma_sgt;
+
+	if (!sgt)
+		return;
+
+	dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
+}
+
+static void vb2_dc_finish(void *buf_priv)
+{
+	struct vb2_dc_buf *buf = buf_priv;
+	struct sg_table *sgt = buf->dma_sgt;
+
+	if (!sgt)
+		return;
+
+	dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
+}
+
 /*********************************************/
 /*        callbacks for MMAP buffers         */
 /*********************************************/
@@ -403,6 +425,8 @@ const struct vb2_mem_ops vb2_dma_contig_memops = {
 	.mmap		= vb2_dc_mmap,
 	.get_userptr	= vb2_dc_get_userptr,
 	.put_userptr	= vb2_dc_put_userptr,
+	.prepare	= vb2_dc_prepare,
+	.finish		= vb2_dc_finish,
 	.num_users	= vb2_dc_num_users,
 };
 EXPORT_SYMBOL_GPL(vb2_dma_contig_memops);
-- 
1.7.9.5

