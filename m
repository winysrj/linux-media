Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:47251 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751953AbbDCKXN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Apr 2015 06:23:13 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id E9E6A2A009F
	for <linux-media@vger.kernel.org>; Fri,  3 Apr 2015 12:22:40 +0200 (CEST)
Message-ID: <551E69F0.5030305@xs4all.nl>
Date: Fri, 03 Apr 2015 12:22:40 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] cx88: v4l2-compliance fixes
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix three v4l2-compliance failures:

- the colorspace wasn't set in vidioc_try_fmt_vid_cap().
- the field wasn't set in v4l2_buffer when vb2_buffer_done() was called.
- the sequence wasn't set in v4l2_buffer when vb2_buffer_done() was called.
  This fix also removes the unused buf->count field and starts the count
  at 0 instead of 1.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/pci/cx88/cx88-core.c b/drivers/media/pci/cx88/cx88-core.c
index c38d5a1..72d5b5f 100644
--- a/drivers/media/pci/cx88/cx88-core.c
+++ b/drivers/media/pci/cx88/cx88-core.c
@@ -519,6 +519,8 @@ void cx88_wakeup(struct cx88_core *core,
 	buf = list_entry(q->active.next,
 			 struct cx88_buffer, list);
 	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
+	buf->vb.v4l2_buf.field = core->field;
+	buf->vb.v4l2_buf.sequence = q->count++;
 	list_del(&buf->list);
 	vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
 }
diff --git a/drivers/media/pci/cx88/cx88-mpeg.c b/drivers/media/pci/cx88/cx88-mpeg.c
index 9834454..34f5057 100644
--- a/drivers/media/pci/cx88/cx88-mpeg.c
+++ b/drivers/media/pci/cx88/cx88-mpeg.c
@@ -173,7 +173,7 @@ int cx8802_start_dma(struct cx8802_dev    *dev,
 
 	/* reset counter */
 	cx_write(MO_TS_GPCNTRL, GP_COUNT_CONTROL_RESET);
-	q->count = 1;
+	q->count = 0;
 
 	/* enable irqs */
 	dprintk( 1, "setting the interrupt mask\n" );
@@ -216,8 +216,6 @@ static int cx8802_restart_queue(struct cx8802_dev    *dev,
 	dprintk(2,"restart_queue [%p/%d]: restart dma\n",
 		buf, buf->vb.v4l2_buf.index);
 	cx8802_start_dma(dev, q, buf);
-	list_for_each_entry(buf, &q->active, list)
-		buf->count = q->count++;
 	return 0;
 }
 
@@ -260,7 +258,6 @@ void cx8802_buf_queue(struct cx8802_dev *dev, struct cx88_buffer *buf)
 	if (list_empty(&cx88q->active)) {
 		dprintk( 1, "queue is empty - first active\n" );
 		list_add_tail(&buf->list, &cx88q->active);
-		buf->count    = cx88q->count++;
 		dprintk(1,"[%p/%d] %s - first active\n",
 			buf, buf->vb.v4l2_buf.index, __func__);
 
@@ -269,7 +266,6 @@ void cx8802_buf_queue(struct cx8802_dev *dev, struct cx88_buffer *buf)
 		dprintk( 1, "queue is not empty - append to active\n" );
 		prev = list_entry(cx88q->active.prev, struct cx88_buffer, list);
 		list_add_tail(&buf->list, &cx88q->active);
-		buf->count    = cx88q->count++;
 		prev->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
 		dprintk( 1, "[%p/%d] %s - append to active\n",
 			buf, buf->vb.v4l2_buf.index, __func__);
diff --git a/drivers/media/pci/cx88/cx88-vbi.c b/drivers/media/pci/cx88/cx88-vbi.c
index 32eb7fd..7510e80 100644
--- a/drivers/media/pci/cx88/cx88-vbi.c
+++ b/drivers/media/pci/cx88/cx88-vbi.c
@@ -59,7 +59,7 @@ static int cx8800_start_vbi_dma(struct cx8800_dev    *dev,
 
 	/* reset counter */
 	cx_write(MO_VBI_GPCNTRL, GP_COUNT_CONTROL_RESET);
-	q->count = 1;
+	q->count = 0;
 
 	/* enable irqs */
 	cx_set(MO_PCI_INTMSK, core->pci_irqmask | PCI_INT_VIDINT);
@@ -102,8 +102,6 @@ int cx8800_restart_vbi_queue(struct cx8800_dev    *dev,
 	dprintk(2,"restart_queue [%p/%d]: restart dma\n",
 		buf, buf->vb.v4l2_buf.index);
 	cx8800_start_vbi_dma(dev, q, buf);
-	list_for_each_entry(buf, &q->active, list)
-		buf->count = q->count++;
 	return 0;
 }
 
@@ -175,7 +173,6 @@ static void buffer_queue(struct vb2_buffer *vb)
 	if (list_empty(&q->active)) {
 		list_add_tail(&buf->list, &q->active);
 		cx8800_start_vbi_dma(dev, q, buf);
-		buf->count    = q->count++;
 		dprintk(2,"[%p/%d] vbi_queue - first active\n",
 			buf, buf->vb.v4l2_buf.index);
 
@@ -183,7 +180,6 @@ static void buffer_queue(struct vb2_buffer *vb)
 		buf->risc.cpu[0] |= cpu_to_le32(RISC_IRQ1);
 		prev = list_entry(q->active.prev, struct cx88_buffer, list);
 		list_add_tail(&buf->list, &q->active);
-		buf->count    = q->count++;
 		prev->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
 		dprintk(2,"[%p/%d] buffer_queue - append to active\n",
 			buf, buf->vb.v4l2_buf.index);
diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index 860c98fc..a74a432 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -370,7 +370,7 @@ static int start_video_dma(struct cx8800_dev    *dev,
 
 	/* reset counter */
 	cx_write(MO_VIDY_GPCNTRL,GP_COUNT_CONTROL_RESET);
-	q->count = 1;
+	q->count = 0;
 
 	/* enable irqs */
 	cx_set(MO_PCI_INTMSK, core->pci_irqmask | PCI_INT_VIDINT);
@@ -423,8 +423,6 @@ static int restart_video_queue(struct cx8800_dev    *dev,
 		dprintk(2,"restart_queue [%p/%d]: restart dma\n",
 			buf, buf->vb.v4l2_buf.index);
 		start_video_dma(dev, q, buf);
-		list_for_each_entry(buf, &q->active, list)
-			buf->count = q->count++;
 	}
 	return 0;
 }
@@ -523,7 +521,6 @@ static void buffer_queue(struct vb2_buffer *vb)
 
 	if (list_empty(&q->active)) {
 		list_add_tail(&buf->list, &q->active);
-		buf->count    = q->count++;
 		dprintk(2,"[%p/%d] buffer_queue - first active\n",
 			buf, buf->vb.v4l2_buf.index);
 
@@ -531,7 +528,6 @@ static void buffer_queue(struct vb2_buffer *vb)
 		buf->risc.cpu[0] |= cpu_to_le32(RISC_IRQ1);
 		prev = list_entry(q->active.prev, struct cx88_buffer, list);
 		list_add_tail(&buf->list, &q->active);
-		buf->count    = q->count++;
 		prev->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
 		dprintk(2, "[%p/%d] buffer_queue - append to active\n",
 			buf, buf->vb.v4l2_buf.index);
@@ -771,6 +767,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 		(f->fmt.pix.width * fmt->depth) >> 3;
 	f->fmt.pix.sizeimage =
 		f->fmt.pix.height * f->fmt.pix.bytesperline;
+	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
 
 	return 0;
 }
diff --git a/drivers/media/pci/cx88/cx88.h b/drivers/media/pci/cx88/cx88.h
index 7748ca9..af29413 100644
--- a/drivers/media/pci/cx88/cx88.h
+++ b/drivers/media/pci/cx88/cx88.h
@@ -327,7 +327,6 @@ struct cx88_buffer {
 	/* cx88 specific */
 	unsigned int           bpl;
 	struct cx88_riscmem    risc;
-	u32                    count;
 };
 
 struct cx88_dmaqueue {
