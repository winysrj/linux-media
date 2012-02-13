Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41716 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756567Ab2BMNwQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Feb 2012 08:52:16 -0500
Received: by mail-ww0-f44.google.com with SMTP id dt10so4927974wgb.1
        for <linux-media@vger.kernel.org>; Mon, 13 Feb 2012 05:52:15 -0800 (PST)
MIME-Version: 1.0
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, mchehab@infradead.org,
	s.hauer@pengutronix.de,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH 6/6] media: i.MX27 camera:  more efficient discard buffer handling.
Date: Mon, 13 Feb 2012 14:51:55 +0100
Message-Id: <1329141115-23133-7-git-send-email-javier.martin@vista-silicon.com>
In-Reply-To: <1329141115-23133-1-git-send-email-javier.martin@vista-silicon.com>
References: <1329141115-23133-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some elements of 'mx2_buffer' are grouped together in another
auxiliary structure. This way we don't need to have unused
'vb2_buffer' structures for both discard buffers.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/media/video/mx2_camera.c |   77 ++++++++++++++++++++++----------------
 1 files changed, 45 insertions(+), 32 deletions(-)

diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index 8ccdb4a..de0a19c 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -230,15 +230,18 @@ enum mx2_buffer_state {
 	MX2_STATE_DONE,
 };
 
+struct mx2_buf_internal {
+	struct list_head	queue;
+	int			bufnum;
+	bool			discard;
+};
+
 /* buffer for one video frame */
 struct mx2_buffer {
 	/* common v4l buffer stuff -- must be first */
 	struct vb2_buffer		vb;
-	struct list_head		queue;
 	enum mx2_buffer_state		state;
-
-	int				bufnum;
-	bool				discard;
+	struct mx2_buf_internal		internal;
 };
 
 struct mx2_camera_dev {
@@ -270,7 +273,7 @@ struct mx2_camera_dev {
 
 	u32			csicr1;
 
-	struct mx2_buffer	buf_discard[2];
+	struct mx2_buf_internal buf_discard[2];
 	void			*discard_buffer;
 	dma_addr_t		discard_buffer_dma;
 	size_t			discard_size;
@@ -279,6 +282,11 @@ struct mx2_camera_dev {
 	struct vb2_alloc_ctx	*alloc_ctx;
 };
 
+static struct mx2_buffer *mx2_ibuf_to_buf(struct mx2_buf_internal *int_buf)
+{
+	return container_of(int_buf, struct mx2_buffer, internal);
+}
+
 static struct mx2_fmt_cfg mx27_emma_prp_table[] = {
 	/*
 	 * This is a generic configuration which is valid for most
@@ -459,9 +467,9 @@ static void mx25_camera_frame_done(struct mx2_camera_dev *pcdev, int fb,
 		writel(0, pcdev->base_csi + fb_reg);
 	} else {
 		buf = list_first_entry(&pcdev->capture, struct mx2_buffer,
-				queue);
+				internal.queue);
 		vb = &buf->vb;
-		list_del(&buf->queue);
+		list_del(&buf->internal.queue);
 		buf->state = MX2_STATE_ACTIVE;
 		writel(vb2_dma_contig_plane_dma_addr(vb, 0),
 		       pcdev->base_csi + fb_reg);
@@ -578,7 +586,7 @@ static void mx2_videobuf_queue(struct vb2_buffer *vb)
 	spin_lock_irqsave(&pcdev->lock, flags);
 
 	buf->state = MX2_STATE_QUEUED;
-	list_add_tail(&buf->queue, &pcdev->capture);
+	list_add_tail(&buf->internal.queue, &pcdev->capture);
 
 	if (cpu_is_mx25()) {
 		u32 csicr3, dma_inten = 0;
@@ -596,7 +604,7 @@ static void mx2_videobuf_queue(struct vb2_buffer *vb)
 		}
 
 		if (dma_inten) {
-			list_del(&buf->queue);
+			list_del(&buf->internal.queue);
 			buf->state = MX2_STATE_ACTIVE;
 
 			csicr3 = readl(pcdev->base_csi + CSICR3);
@@ -719,23 +727,23 @@ static int mx2_start_streaming(struct vb2_queue *q, unsigned int count)
 		spin_lock_irqsave(&pcdev->lock, flags);
 
 		buf = list_first_entry(&pcdev->capture, struct mx2_buffer,
-				       queue);
-		buf->bufnum = 0;
+				       internal.queue);
+		buf->internal.bufnum = 0;
 		vb = &buf->vb;
 		buf->state = MX2_STATE_ACTIVE;
 
 		phys = vb2_dma_contig_plane_dma_addr(vb, 0);
-		mx27_update_emma_buf(pcdev, phys, buf->bufnum);
+		mx27_update_emma_buf(pcdev, phys, buf->internal.bufnum);
 		list_move_tail(pcdev->capture.next, &pcdev->active_bufs);
 
 		buf = list_first_entry(&pcdev->capture, struct mx2_buffer,
-				       queue);
-		buf->bufnum = 1;
+				       internal.queue);
+		buf->internal.bufnum = 1;
 		vb = &buf->vb;
 		buf->state = MX2_STATE_ACTIVE;
 
 		phys = vb2_dma_contig_plane_dma_addr(vb, 0);
-		mx27_update_emma_buf(pcdev, phys, buf->bufnum);
+		mx27_update_emma_buf(pcdev, phys, buf->internal.bufnum);
 		list_move_tail(pcdev->capture.next, &pcdev->active_bufs);
 
 		bytesperline = soc_mbus_bytes_per_line(icd->user_width,
@@ -1213,21 +1221,25 @@ static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
 #ifdef DEBUG
 	struct mx2_fmt_cfg *prp = pcdev->emma_prp;
 #endif
+	struct mx2_buf_internal *ibuf;
 	struct mx2_buffer *buf;
 	struct vb2_buffer *vb;
 	unsigned long phys;
 
-	buf = list_first_entry(&pcdev->active_bufs, struct mx2_buffer, queue);
+	ibuf = list_first_entry(&pcdev->active_bufs, struct mx2_buf_internal,
+			       queue);
 
-	BUG_ON(buf->bufnum != bufnum);
+	BUG_ON(ibuf->bufnum != bufnum);
 
-	if (buf->discard) {
+	if (ibuf->discard) {
 		/*
 		 * Discard buffer must not be returned to user space.
 		 * Just return it to the discard queue.
 		 */
 		list_move_tail(pcdev->active_bufs.next, &pcdev->discard);
 	} else {
+		buf = mx2_ibuf_to_buf(ibuf);
+
 		vb = &buf->vb;
 #ifdef DEBUG
 		phys = vb2_dma_contig_plane_dma_addr(vb, 0);
@@ -1251,7 +1263,7 @@ static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
 				vb2_plane_vaddr(vb, 0),
 				vb2_get_plane_payload(vb, 0));
 
-		list_del_init(&buf->queue);
+		list_del_init(&buf->internal.queue);
 		do_gettimeofday(&vb->v4l2_buf.timestamp);
 		vb->v4l2_buf.sequence = pcdev->frame_count;
 		if (err)
@@ -1269,18 +1281,19 @@ static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
 			return;
 		}
 
-		buf = list_first_entry(&pcdev->discard, struct mx2_buffer,
-				       queue);
-		buf->bufnum = bufnum;
+		ibuf = list_first_entry(&pcdev->discard,
+					struct mx2_buf_internal, queue);
+		ibuf->bufnum = bufnum;
 
 		list_move_tail(pcdev->discard.next, &pcdev->active_bufs);
 		mx27_update_emma_buf(pcdev, pcdev->discard_buffer_dma, bufnum);
 		return;
 	}
 
-	buf = list_first_entry(&pcdev->capture, struct mx2_buffer, queue);
+	buf = list_first_entry(&pcdev->capture, struct mx2_buffer,
+			       internal.queue);
 
-	buf->bufnum = bufnum;
+	buf->internal.bufnum = bufnum;
 
 	list_move_tail(pcdev->capture.next, &pcdev->active_bufs);
 
@@ -1295,7 +1308,7 @@ static irqreturn_t mx27_camera_emma_irq(int irq_emma, void *data)
 {
 	struct mx2_camera_dev *pcdev = data;
 	unsigned int status = readl(pcdev->base_emma + PRP_INTRSTATUS);
-	struct mx2_buffer *buf;
+	struct mx2_buf_internal *ibuf;
 
 	spin_lock(&pcdev->lock);
 
@@ -1310,10 +1323,10 @@ static irqreturn_t mx27_camera_emma_irq(int irq_emma, void *data)
 	}
 
 	if (status & (1 << 7)) { /* overflow */
-		buf = list_first_entry(&pcdev->active_bufs, struct mx2_buffer,
-				       queue);
+		ibuf = list_first_entry(&pcdev->active_bufs,
+					struct mx2_buf_internal, queue);
 		mx27_camera_frame_done_emma(pcdev,
-					buf->bufnum, true);
+					ibuf->bufnum, true);
 		status &= ~(1 << 7);
 	} else if (((status & (3 << 5)) == (3 << 5)) ||
 		((status & (3 << 3)) == (3 << 3))) {
@@ -1321,10 +1334,10 @@ static irqreturn_t mx27_camera_emma_irq(int irq_emma, void *data)
 		 * Both buffers have triggered, process the one we're expecting
 		 * to first
 		 */
-		buf = list_first_entry(&pcdev->active_bufs, struct mx2_buffer,
-				       queue);
-		mx27_camera_frame_done_emma(pcdev, buf->bufnum, false);
-		status &= ~(1 << (6 - buf->bufnum)); /* mark processed */
+		ibuf = list_first_entry(&pcdev->active_bufs,
+					struct mx2_buf_internal, queue);
+		mx27_camera_frame_done_emma(pcdev, ibuf->bufnum, false);
+		status &= ~(1 << (6 - ibuf->bufnum)); /* mark processed */
 	} else if ((status & (1 << 6)) || (status & (1 << 4))) {
 		mx27_camera_frame_done_emma(pcdev, 0, false);
 	} else if ((status & (1 << 5)) || (status & (1 << 3))) {
-- 
1.7.0.4

