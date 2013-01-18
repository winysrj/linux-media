Return-path: <linux-media-owner@vger.kernel.org>
Received: from [207.46.163.26] ([207.46.163.26]:33158 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750750Ab3ARIMM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jan 2013 03:12:12 -0500
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	<uclinux-dist-devel@blackfin.uclinux.org>
CC: Scott Jiang <scott.jiang.linux@gmail.com>
Subject: [PATCH 2/2] [media] blackfin: add error frame support
Date: Fri, 18 Jan 2013 16:09:48 -0500
Message-ID: <1358543388-29451-2-git-send-email-scott.jiang.linux@gmail.com>
In-Reply-To: <1358543388-29451-1-git-send-email-scott.jiang.linux@gmail.com>
References: <1358543388-29451-1-git-send-email-scott.jiang.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mark current frame as error frame when ppi error interrupt
report fifo error. Member next_frm in struct bcap_device can
be optimized out.

Signed-off-by: Scott Jiang <scott.jiang.linux@gmail.com>
---
 drivers/media/platform/blackfin/bfin_capture.c |   37 +++++++++++++-----------
 drivers/media/platform/blackfin/ppi.c          |   11 +++++++
 include/media/blackfin/ppi.h                   |    3 +-
 3 files changed, 33 insertions(+), 18 deletions(-)

diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index aa9f846..54d8cc5 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -91,8 +91,6 @@ struct bcap_device {
 	int num_sensor_formats;
 	/* pointing to current video buffer */
 	struct bcap_buffer *cur_frm;
-	/* pointing to next video buffer */
-	struct bcap_buffer *next_frm;
 	/* buffer queue used in videobuf2 */
 	struct vb2_queue buffer_queue;
 	/* allocator-specific contexts for each plane */
@@ -455,10 +453,10 @@ static int bcap_stop_streaming(struct vb2_queue *vq)
 
 	/* release all active buffers */
 	while (!list_empty(&bcap_dev->dma_queue)) {
-		bcap_dev->next_frm = list_entry(bcap_dev->dma_queue.next,
+		bcap_dev->cur_frm = list_entry(bcap_dev->dma_queue.next,
 						struct bcap_buffer, list);
-		list_del(&bcap_dev->next_frm->list);
-		vb2_buffer_done(&bcap_dev->next_frm->vb, VB2_BUF_STATE_ERROR);
+		list_del(&bcap_dev->cur_frm->list);
+		vb2_buffer_done(&bcap_dev->cur_frm->vb, VB2_BUF_STATE_ERROR);
 	}
 	return 0;
 }
@@ -535,10 +533,21 @@ static irqreturn_t bcap_isr(int irq, void *dev_id)
 
 	spin_lock(&bcap_dev->lock);
 
-	if (bcap_dev->cur_frm != bcap_dev->next_frm) {
+	if (!list_empty(&bcap_dev->dma_queue)) {
 		v4l2_get_timestamp(&vb->v4l2_buf.timestamp);
-		vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
-		bcap_dev->cur_frm = bcap_dev->next_frm;
+		if (ppi->err) {
+			vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
+			ppi->err = false;
+		} else {
+			vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
+		}
+		bcap_dev->cur_frm = list_entry(bcap_dev->dma_queue.next,
+				struct bcap_buffer, list);
+		list_del(&bcap_dev->cur_frm->list);
+	} else {
+		/* clear error flag, we will get a new frame */
+		if (ppi->err)
+			ppi->err = false;
 	}
 
 	ppi->ops->stop(ppi);
@@ -546,13 +555,8 @@ static irqreturn_t bcap_isr(int irq, void *dev_id)
 	if (bcap_dev->stop) {
 		complete(&bcap_dev->comp);
 	} else {
-		if (!list_empty(&bcap_dev->dma_queue)) {
-			bcap_dev->next_frm = list_entry(bcap_dev->dma_queue.next,
-						struct bcap_buffer, list);
-			list_del(&bcap_dev->next_frm->list);
-			addr = vb2_dma_contig_plane_dma_addr(&bcap_dev->next_frm->vb, 0);
-			ppi->ops->update_addr(ppi, (unsigned long)addr);
-		}
+		addr = vb2_dma_contig_plane_dma_addr(&bcap_dev->cur_frm->vb, 0);
+		ppi->ops->update_addr(ppi, (unsigned long)addr);
 		ppi->ops->start(ppi);
 	}
 
@@ -586,9 +590,8 @@ static int bcap_streamon(struct file *file, void *priv,
 	}
 
 	/* get the next frame from the dma queue */
-	bcap_dev->next_frm = list_entry(bcap_dev->dma_queue.next,
+	bcap_dev->cur_frm = list_entry(bcap_dev->dma_queue.next,
 					struct bcap_buffer, list);
-	bcap_dev->cur_frm = bcap_dev->next_frm;
 	/* remove buffer from the dma queue */
 	list_del(&bcap_dev->cur_frm->list);
 	addr = vb2_dma_contig_plane_dma_addr(&bcap_dev->cur_frm->vb, 0);
diff --git a/drivers/media/platform/blackfin/ppi.c b/drivers/media/platform/blackfin/ppi.c
index 1e24584..01b5b50 100644
--- a/drivers/media/platform/blackfin/ppi.c
+++ b/drivers/media/platform/blackfin/ppi.c
@@ -59,19 +59,30 @@ static irqreturn_t ppi_irq_err(int irq, void *dev_id)
 		 * others are W1C
 		 */
 		status = bfin_read16(&reg->status);
+		if (status & 0x3000)
+			ppi->err = true;
 		bfin_write16(&reg->status, 0xff00);
 		break;
 	}
 	case PPI_TYPE_EPPI:
 	{
 		struct bfin_eppi_regs *reg = info->base;
+		unsigned short status;
+
+		status = bfin_read16(&reg->status);
+		if (status & 0x2)
+			ppi->err = true;
 		bfin_write16(&reg->status, 0xffff);
 		break;
 	}
 	case PPI_TYPE_EPPI3:
 	{
 		struct bfin_eppi3_regs *reg = info->base;
+		unsigned long stat;
 
+		stat = bfin_read32(&reg->stat);
+		if (stat & 0x2)
+			ppi->err = true;
 		bfin_write32(&reg->stat, 0xc0ff);
 		break;
 	}
diff --git a/include/media/blackfin/ppi.h b/include/media/blackfin/ppi.h
index 65c4675..d0697f4 100644
--- a/include/media/blackfin/ppi.h
+++ b/include/media/blackfin/ppi.h
@@ -86,7 +86,8 @@ struct ppi_if {
 	unsigned long ppi_control;
 	const struct ppi_ops *ops;
 	const struct ppi_info *info;
-	bool err_int;
+	bool err_int; /* if we need request error interrupt */
+	bool err; /* if ppi has fifo error */
 	void *priv;
 };
 
-- 
1.7.0.4


