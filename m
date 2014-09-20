Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3182 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756067AbaITMmH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Sep 2014 08:42:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 07/16] cx88: drop cx88_free_buffer
Date: Sat, 20 Sep 2014 14:41:42 +0200
Message-Id: <1411216911-7950-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1411216911-7950-1-git-send-email-hverkuil@xs4all.nl>
References: <1411216911-7950-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Remove this function. This makes all vb2 queues behave the same, which
simplifies comparing the various vb2 queue op implementations.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx88/cx88-blackbird.c | 2 +-
 drivers/media/pci/cx88/cx88-core.c      | 7 -------
 drivers/media/pci/cx88/cx88-dvb.c       | 2 +-
 drivers/media/pci/cx88/cx88-mpeg.c      | 6 +++++-
 drivers/media/pci/cx88/cx88-vbi.c       | 2 +-
 drivers/media/pci/cx88/cx88-video.c     | 2 +-
 drivers/media/pci/cx88/cx88.h           | 2 --
 7 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/media/pci/cx88/cx88-blackbird.c b/drivers/media/pci/cx88/cx88-blackbird.c
index 11054cd..b24266e 100644
--- a/drivers/media/pci/cx88/cx88-blackbird.c
+++ b/drivers/media/pci/cx88/cx88-blackbird.c
@@ -667,7 +667,7 @@ static void buffer_finish(struct vb2_buffer *vb)
 	struct cx88_buffer *buf = container_of(vb, struct cx88_buffer, vb);
 	struct sg_table *sgt = vb2_dma_sg_plane_desc(vb, 0);
 
-	cx88_free_buffer(vb->vb2_queue, buf);
+	btcx_riscmem_free(dev->pci, &buf->risc);
 
 	dma_unmap_sg(&dev->pci->dev, sgt->sgl, sgt->nents, DMA_FROM_DEVICE);
 }
diff --git a/drivers/media/pci/cx88/cx88-core.c b/drivers/media/pci/cx88/cx88-core.c
index f027408..902b662 100644
--- a/drivers/media/pci/cx88/cx88-core.c
+++ b/drivers/media/pci/cx88/cx88-core.c
@@ -198,12 +198,6 @@ int cx88_risc_databuffer(struct pci_dev *pci, struct btcx_riscmem *risc,
 	return 0;
 }
 
-void
-cx88_free_buffer(struct vb2_queue *q, struct cx88_buffer *buf)
-{
-	btcx_riscmem_free(to_pci_dev(q->drv_priv), &buf->risc);
-}
-
 /* ------------------------------------------------------------------ */
 /* our SRAM memory layout                                             */
 
@@ -1072,7 +1066,6 @@ EXPORT_SYMBOL(cx88_shutdown);
 
 EXPORT_SYMBOL(cx88_risc_buffer);
 EXPORT_SYMBOL(cx88_risc_databuffer);
-EXPORT_SYMBOL(cx88_free_buffer);
 
 EXPORT_SYMBOL(cx88_sram_channels);
 EXPORT_SYMBOL(cx88_sram_channel_setup);
diff --git a/drivers/media/pci/cx88/cx88-dvb.c b/drivers/media/pci/cx88/cx88-dvb.c
index d7e5c45..b5b88a6 100644
--- a/drivers/media/pci/cx88/cx88-dvb.c
+++ b/drivers/media/pci/cx88/cx88-dvb.c
@@ -110,7 +110,7 @@ static void buffer_finish(struct vb2_buffer *vb)
 	struct cx88_buffer *buf = container_of(vb, struct cx88_buffer, vb);
 	struct sg_table *sgt = vb2_dma_sg_plane_desc(vb, 0);
 
-	cx88_free_buffer(vb->vb2_queue, buf);
+	btcx_riscmem_free(dev->pci, &buf->risc);
 
 	dma_unmap_sg(&dev->pci->dev, sgt->sgl, sgt->nents, DMA_FROM_DEVICE);
 }
diff --git a/drivers/media/pci/cx88/cx88-mpeg.c b/drivers/media/pci/cx88/cx88-mpeg.c
index 7986ee0..0589dcc 100644
--- a/drivers/media/pci/cx88/cx88-mpeg.c
+++ b/drivers/media/pci/cx88/cx88-mpeg.c
@@ -238,8 +238,12 @@ int cx8802_buf_prepare(struct vb2_queue *q, struct cx8802_dev *dev,
 	if (!rc)
 		return -EIO;
 
-	cx88_risc_databuffer(dev->pci, &buf->risc, sgt->sgl,
+	rc = cx88_risc_databuffer(dev->pci, &buf->risc, sgt->sgl,
 			     dev->ts_packet_size, dev->ts_packet_count, 0);
+	if (rc) {
+		btcx_riscmem_free(dev->pci, &buf->risc);
+		return rc;
+	}
 	return 0;
 }
 
diff --git a/drivers/media/pci/cx88/cx88-vbi.c b/drivers/media/pci/cx88/cx88-vbi.c
index 26a1533..8f20612 100644
--- a/drivers/media/pci/cx88/cx88-vbi.c
+++ b/drivers/media/pci/cx88/cx88-vbi.c
@@ -147,7 +147,7 @@ static void buffer_finish(struct vb2_buffer *vb)
 	struct cx88_buffer *buf = container_of(vb, struct cx88_buffer, vb);
 	struct sg_table *sgt = vb2_dma_sg_plane_desc(vb, 0);
 
-	cx88_free_buffer(vb->vb2_queue, buf);
+	btcx_riscmem_free(dev->pci, &buf->risc);
 
 	dma_unmap_sg(&dev->pci->dev, sgt->sgl, sgt->nents, DMA_FROM_DEVICE);
 }
diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index 9887da5..c64f8f4 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -506,7 +506,7 @@ static void buffer_finish(struct vb2_buffer *vb)
 	struct cx88_buffer *buf = container_of(vb, struct cx88_buffer, vb);
 	struct sg_table *sgt = vb2_dma_sg_plane_desc(vb, 0);
 
-	cx88_free_buffer(vb->vb2_queue, buf);
+	btcx_riscmem_free(dev->pci, &buf->risc);
 
 	dma_unmap_sg(&dev->pci->dev, sgt->sgl, sgt->nents, DMA_FROM_DEVICE);
 }
diff --git a/drivers/media/pci/cx88/cx88.h b/drivers/media/pci/cx88/cx88.h
index 2dadaa6..16965c8 100644
--- a/drivers/media/pci/cx88/cx88.h
+++ b/drivers/media/pci/cx88/cx88.h
@@ -624,8 +624,6 @@ extern int
 cx88_risc_databuffer(struct pci_dev *pci, struct btcx_riscmem *risc,
 		     struct scatterlist *sglist, unsigned int bpl,
 		     unsigned int lines, unsigned int lpi);
-extern void
-cx88_free_buffer(struct vb2_queue *q, struct cx88_buffer *buf);
 
 extern void cx88_risc_disasm(struct cx88_core *core,
 			     struct btcx_riscmem *risc);
-- 
2.1.0

