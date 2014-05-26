Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37470 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362AbaEZORr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 May 2014 10:17:47 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Pawel Osciak <pawel@osciak.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] [media] videobuf2-dma-contig: allow to vmap contiguous dma buffers
Date: Mon, 26 May 2014 16:17:32 +0200
Message-Id: <1401113852-27318-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This allows drivers to vmap contiguous dma buffers so they can inspect the
buffer contents with the CPU. This will be needed for the CODA driver's JPEG
handling. On CODA960, the header parsing has to be done on the CPU. The
hardware modules can only process the entropy coded segment after all
registers and tables are set up.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index 880be07..6b254b8 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -98,6 +98,9 @@ static void *vb2_dc_vaddr(void *buf_priv)
 {
 	struct vb2_dc_buf *buf = buf_priv;
 
+	if (!buf->vaddr && buf->db_attach)
+		buf->vaddr = dma_buf_vmap(buf->db_attach->dmabuf);
+
 	return buf->vaddr;
 }
 
@@ -735,6 +738,7 @@ static int vb2_dc_map_dmabuf(void *mem_priv)
 
 	buf->dma_addr = sg_dma_address(sgt->sgl);
 	buf->dma_sgt = sgt;
+	buf->vaddr = NULL;
 
 	return 0;
 }
@@ -754,6 +758,10 @@ static void vb2_dc_unmap_dmabuf(void *mem_priv)
 		return;
 	}
 
+	if (buf->vaddr) {
+		dma_buf_vunmap(buf->db_attach->dmabuf, buf->vaddr);
+		buf->vaddr = NULL;
+	}
 	dma_buf_unmap_attachment(buf->db_attach, sgt, buf->dma_dir);
 
 	buf->dma_addr = 0;
-- 
2.0.0.rc2

