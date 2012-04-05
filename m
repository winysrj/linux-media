Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:58994 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233Ab2DEOAh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Apr 2012 10:00:37 -0400
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M200021BEWSKP@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 05 Apr 2012 15:00:30 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M20009R9EWWP5@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 05 Apr 2012 15:00:33 +0100 (BST)
Date: Thu, 05 Apr 2012 16:00:07 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 10/11] v4l: vb2-dma-contig: add prepare/finish to dma-contig
 allocator
In-reply-to: <1333634408-4960-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	subashrp@gmail.com
Message-id: <1333634408-4960-11-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1333634408-4960-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Marek Szyprowski <m.szyprowski@samsung.com>

Add prepare/finish callbacks to vb2-dma-contig allocator.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/video/videobuf2-dma-contig.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/videobuf2-dma-contig.c b/drivers/media/video/videobuf2-dma-contig.c
index 6ab3165..30f316588 100644
--- a/drivers/media/video/videobuf2-dma-contig.c
+++ b/drivers/media/video/videobuf2-dma-contig.c
@@ -152,6 +152,28 @@ static unsigned int vb2_dc_num_users(void *buf_priv)
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
@@ -414,6 +436,8 @@ const struct vb2_mem_ops vb2_dma_contig_memops = {
 	.mmap		= vb2_dc_mmap,
 	.get_userptr	= vb2_dc_get_userptr,
 	.put_userptr	= vb2_dc_put_userptr,
+	.prepare	= vb2_dc_prepare,
+	.finish		= vb2_dc_finish,
 	.num_users	= vb2_dc_num_users,
 };
 EXPORT_SYMBOL_GPL(vb2_dma_contig_memops);
-- 
1.7.5.4

