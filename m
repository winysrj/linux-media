Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57377 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283Ab2AZMEu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jan 2012 07:04:50 -0500
Received: by wgbed3 with SMTP id ed3so548935wgb.1
        for <linux-media@vger.kernel.org>; Thu, 26 Jan 2012 04:04:49 -0800 (PST)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, s.hauer@pengutronix.de, baruch@tkos.co.il,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH v2 3/4] media i.MX27 camera: improve discard buffer handling.
Date: Thu, 26 Jan 2012 13:04:31 +0100
Message-Id: <1327579472-31597-3-git-send-email-javier.martin@vista-silicon.com>
In-Reply-To: <1327579472-31597-1-git-send-email-javier.martin@vista-silicon.com>
References: <1327579472-31597-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The way discard buffer was previously handled lead
to possible races that made a buffer that was not
yet ready to be overwritten by new video data. This
is easily detected at 25fps just adding "#define DEBUG"
to enable the "memset" check and seeing how the image
is corrupted.

A new "discard" queue and two discard buffers have
been added to make them flow trough the pipeline
of queues and thus provide suitable event ordering.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 Changes since v1:
 - Don't allocate discard buffer on every set_fmt.

---
 drivers/media/video/mx2_camera.c |  261 +++++++++++++++++++++-----------------
 1 files changed, 144 insertions(+), 117 deletions(-)

diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index 045c018..71054ab 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -237,7 +237,8 @@ struct mx2_buffer {
 	struct list_head		queue;
 	enum mx2_buffer_state		state;
 
-	int bufnum;
+	int				bufnum;
+	bool				discard;
 };
 
 struct mx2_camera_dev {
@@ -256,6 +257,7 @@ struct mx2_camera_dev {
 
 	struct list_head	capture;
 	struct list_head	active_bufs;
+	struct list_head	discard;
 
 	spinlock_t		lock;
 
@@ -268,6 +270,7 @@ struct mx2_camera_dev {
 
 	u32			csicr1;
 
+	struct mx2_buffer	buf_discard[2];
 	void			*discard_buffer;
 	dma_addr_t		discard_buffer_dma;
 	size_t			discard_size;
@@ -329,6 +332,30 @@ static struct mx2_fmt_cfg *mx27_emma_prp_get_format(
 	return &mx27_emma_prp_table[0];
 };
 
+static void mx27_update_emma_buf(struct mx2_camera_dev *pcdev,
+				 unsigned long phys, int bufnum)
+{
+	struct mx2_fmt_cfg *prp = pcdev->emma_prp;
+
+	if (prp->cfg.channel == 1) {
+		writel(phys, pcdev->base_emma +
+				PRP_DEST_RGB1_PTR + 4 * bufnum);
+	} else {
+		writel(phys, pcdev->base_emma +
+			PRP_DEST_Y_PTR - 0x14 * bufnum);
+		if (prp->out_fmt == V4L2_PIX_FMT_YUV420) {
+			u32 imgsize = pcdev->icd->user_height *
+					pcdev->icd->user_width;
+
+			writel(phys + imgsize,
+			pcdev->base_emma + PRP_DEST_CB_PTR -
+			0x14 * bufnum);
+			writel(phys + ((5 * imgsize) / 4), pcdev->base_emma +
+			PRP_DEST_CR_PTR - 0x14 * bufnum);
+		}
+	}
+}
+
 static void mx2_camera_deactivate(struct mx2_camera_dev *pcdev)
 {
 	unsigned long flags;
@@ -377,7 +404,7 @@ static int mx2_camera_add_device(struct soc_camera_device *icd)
 	writel(pcdev->csicr1, pcdev->base_csi + CSICR1);
 
 	pcdev->icd = icd;
-	pcdev->frame_count = -1;
+	pcdev->frame_count = 0;
 
 	dev_info(icd->parent, "Camera driver attached to camera %d\n",
 		 icd->devnum);
@@ -631,7 +658,7 @@ static void mx2_videobuf_release(struct vb2_buffer *vb)
 
 	spin_lock_irqsave(&pcdev->lock, flags);
 	if (mx27_camera_emma(pcdev)) {
-		list_del_init(&buf->queue);
+		INIT_LIST_HEAD(&buf->queue);
 	} else if (cpu_is_mx25() && buf->state == MX2_STATE_ACTIVE) {
 		if (pcdev->fb1_active == buf) {
 			pcdev->csicr1 &= ~CSICR1_FB1_DMA_INTEN;
@@ -647,6 +674,34 @@ static void mx2_videobuf_release(struct vb2_buffer *vb)
 	spin_unlock_irqrestore(&pcdev->lock, flags);
 }
 
+static void mx27_camera_emma_buf_init(struct soc_camera_device *icd,
+		int bytesperline)
+{
+	struct soc_camera_host *ici =
+		to_soc_camera_host(icd->parent);
+	struct mx2_camera_dev *pcdev = ici->priv;
+	struct mx2_fmt_cfg *prp = pcdev->emma_prp;
+
+	writel((icd->user_width << 16) | icd->user_height,
+	       pcdev->base_emma + PRP_SRC_FRAME_SIZE);
+	writel(prp->cfg.src_pixel,
+	       pcdev->base_emma + PRP_SRC_PIXEL_FORMAT_CNTL);
+	if (prp->cfg.channel == 1) {
+		writel((icd->user_width << 16) | icd->user_height,
+			pcdev->base_emma + PRP_CH1_OUT_IMAGE_SIZE);
+		writel(bytesperline,
+			pcdev->base_emma + PRP_DEST_CH1_LINE_STRIDE);
+		writel(prp->cfg.ch1_pixel,
+			pcdev->base_emma + PRP_CH1_PIXEL_FORMAT_CNTL);
+	} else { /* channel 2 */
+		writel((icd->user_width << 16) | icd->user_height,
+			pcdev->base_emma + PRP_CH2_OUT_IMAGE_SIZE);
+	}
+
+	/* Enable interrupts */
+	writel(prp->cfg.irq_flags, pcdev->base_emma + PRP_INTR_CNTL);
+}
+
 static int mx2_start_streaming(struct vb2_queue *q, unsigned int count)
 {
 	struct soc_camera_device *icd = soc_camera_from_vb2q(q);
@@ -654,7 +709,11 @@ static int mx2_start_streaming(struct vb2_queue *q, unsigned int count)
 		to_soc_camera_host(icd->parent);
 	struct mx2_camera_dev *pcdev = ici->priv;
 	struct mx2_fmt_cfg *prp = pcdev->emma_prp;
+	struct vb2_buffer *vb;
+	struct mx2_buffer *buf;
 	unsigned long flags;
+	unsigned long phys;
+	int bytesperline;
 	int ret = 0;
 
 	spin_lock_irqsave(&pcdev->lock, flags);
@@ -664,6 +723,63 @@ static int mx2_start_streaming(struct vb2_queue *q, unsigned int count)
 			goto err;
 		}
 
+		buf = list_entry(pcdev->capture.next,
+				 struct mx2_buffer, queue);
+		buf->bufnum = 0;
+		vb = &buf->vb;
+		buf->state = MX2_STATE_ACTIVE;
+
+		phys = vb2_dma_contig_plane_dma_addr(vb, 0);
+		mx27_update_emma_buf(pcdev, phys, buf->bufnum);
+		list_move_tail(pcdev->capture.next, &pcdev->active_bufs);
+
+		buf = list_entry(pcdev->capture.next,
+				 struct mx2_buffer, queue);
+		buf->bufnum = 1;
+		vb = &buf->vb;
+		buf->state = MX2_STATE_ACTIVE;
+
+		phys = vb2_dma_contig_plane_dma_addr(vb, 0);
+		mx27_update_emma_buf(pcdev, phys, buf->bufnum);
+		list_move_tail(pcdev->capture.next, &pcdev->active_bufs);
+
+		if (pcdev->discard_buffer) {
+			dma_free_coherent(ici->v4l2_dev.dev,
+				pcdev->discard_size, pcdev->discard_buffer,
+				pcdev->discard_buffer_dma);
+
+			pcdev->buf_discard[0].discard = true;
+			INIT_LIST_HEAD(&pcdev->buf_discard[0].queue);
+			list_add_tail(&pcdev->buf_discard[0].queue,
+				      &pcdev->discard);
+
+			pcdev->buf_discard[1].discard = true;
+			INIT_LIST_HEAD(&pcdev->buf_discard[1].queue);
+			list_add_tail(&pcdev->buf_discard[1].queue,
+				      &pcdev->discard);
+		}
+
+		bytesperline = soc_mbus_bytes_per_line(icd->user_width,
+				icd->current_fmt->host_fmt);
+		if (bytesperline < 0)
+			return bytesperline;
+
+		/*
+		 * I didn't manage to properly enable/disable the prp
+		 * on a per frame basis during running transfers,
+		 * thus we allocate a buffer here and use it to
+		 * discard frames when no buffer is available.
+		 * Feel free to work on this ;)
+		 */
+		pcdev->discard_size = icd->user_height * bytesperline;
+		pcdev->discard_buffer = dma_alloc_coherent(ici->v4l2_dev.dev,
+				pcdev->discard_size, &pcdev->discard_buffer_dma,
+				GFP_KERNEL);
+		if (!pcdev->discard_buffer)
+			return -ENOMEM;
+
+		mx27_camera_emma_buf_init(icd, bytesperline);
+
 		if (prp->cfg.channel == 1) {
 			writel(PRP_CNTL_CH1EN |
 				PRP_CNTL_CSIEN |
@@ -711,6 +827,9 @@ static int mx2_stop_streaming(struct vb2_queue *q)
 			writel(cntl & ~PRP_CNTL_CH2EN,
 			       pcdev->base_emma + PRP_CNTL);
 		}
+		INIT_LIST_HEAD(&pcdev->capture);
+		INIT_LIST_HEAD(&pcdev->active_bufs);
+		INIT_LIST_HEAD(&pcdev->discard);
 	}
 	spin_unlock_irqrestore(&pcdev->lock, flags);
 
@@ -766,63 +885,6 @@ static int mx27_camera_emma_prp_reset(struct mx2_camera_dev *pcdev)
 	return -ETIMEDOUT;
 }
 
-static void mx27_camera_emma_buf_init(struct soc_camera_device *icd,
-		int bytesperline)
-{
-	struct soc_camera_host *ici =
-		to_soc_camera_host(icd->parent);
-	struct mx2_camera_dev *pcdev = ici->priv;
-	struct mx2_fmt_cfg *prp = pcdev->emma_prp;
-	u32 imgsize = pcdev->icd->user_height * pcdev->icd->user_width;
-
-	if (prp->cfg.channel == 1) {
-		writel(pcdev->discard_buffer_dma,
-				pcdev->base_emma + PRP_DEST_RGB1_PTR);
-		writel(pcdev->discard_buffer_dma,
-				pcdev->base_emma + PRP_DEST_RGB2_PTR);
-
-		writel((icd->user_width << 16) | icd->user_height,
-			pcdev->base_emma + PRP_SRC_FRAME_SIZE);
-		writel((icd->user_width << 16) | icd->user_height,
-			pcdev->base_emma + PRP_CH1_OUT_IMAGE_SIZE);
-		writel(bytesperline,
-			pcdev->base_emma + PRP_DEST_CH1_LINE_STRIDE);
-		writel(prp->cfg.src_pixel,
-			pcdev->base_emma + PRP_SRC_PIXEL_FORMAT_CNTL);
-		writel(prp->cfg.ch1_pixel,
-			pcdev->base_emma + PRP_CH1_PIXEL_FORMAT_CNTL);
-	} else { /* channel 2 */
-		writel(pcdev->discard_buffer_dma,
-			pcdev->base_emma + PRP_DEST_Y_PTR);
-		writel(pcdev->discard_buffer_dma,
-			pcdev->base_emma + PRP_SOURCE_Y_PTR);
-
-		if (prp->cfg.out_fmt == PRP_CNTL_CH2_OUT_YUV420) {
-			writel(pcdev->discard_buffer_dma + imgsize,
-				pcdev->base_emma + PRP_DEST_CB_PTR);
-			writel(pcdev->discard_buffer_dma + ((5 * imgsize) / 4),
-				pcdev->base_emma + PRP_DEST_CR_PTR);
-			writel(pcdev->discard_buffer_dma + imgsize,
-				pcdev->base_emma + PRP_SOURCE_CB_PTR);
-			writel(pcdev->discard_buffer_dma + ((5 * imgsize) / 4),
-				pcdev->base_emma + PRP_SOURCE_CR_PTR);
-		}
-
-		writel((icd->user_width << 16) | icd->user_height,
-			pcdev->base_emma + PRP_SRC_FRAME_SIZE);
-
-		writel((icd->user_width << 16) | icd->user_height,
-			pcdev->base_emma + PRP_CH2_OUT_IMAGE_SIZE);
-
-		writel(prp->cfg.src_pixel,
-			pcdev->base_emma + PRP_SRC_PIXEL_FORMAT_CNTL);
-
-	}
-
-	/* Enable interrupts */
-	writel(prp->cfg.irq_flags, pcdev->base_emma + PRP_INTR_CNTL);
-}
-
 static int mx2_camera_set_bus_param(struct soc_camera_device *icd,
 		__u32 pixfmt)
 {
@@ -906,27 +968,6 @@ static int mx2_camera_set_bus_param(struct soc_camera_device *icd,
 		ret = mx27_camera_emma_prp_reset(pcdev);
 		if (ret)
 			return ret;
-
-		if (pcdev->discard_buffer)
-			dma_free_coherent(ici->v4l2_dev.dev,
-				pcdev->discard_size, pcdev->discard_buffer,
-				pcdev->discard_buffer_dma);
-
-		/*
-		 * I didn't manage to properly enable/disable the prp
-		 * on a per frame basis during running transfers,
-		 * thus we allocate a buffer here and use it to
-		 * discard frames when no buffer is available.
-		 * Feel free to work on this ;)
-		 */
-		pcdev->discard_size = icd->user_height * bytesperline;
-		pcdev->discard_buffer = dma_alloc_coherent(ici->v4l2_dev.dev,
-				pcdev->discard_size, &pcdev->discard_buffer_dma,
-				GFP_KERNEL);
-		if (!pcdev->discard_buffer)
-			return -ENOMEM;
-
-		mx27_camera_emma_buf_init(icd, bytesperline);
 	} else if (cpu_is_mx25()) {
 		writel((bytesperline * icd->user_height) >> 2,
 				pcdev->base_csi + CSIRXCNT);
@@ -1174,18 +1215,24 @@ static struct soc_camera_host_ops mx2_soc_camera_host_ops = {
 static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
 		int bufnum)
 {
-	u32 imgsize = pcdev->icd->user_height * pcdev->icd->user_width;
-	struct mx2_fmt_cfg *prp = pcdev->emma_prp;
 	struct mx2_buffer *buf;
 	struct vb2_buffer *vb;
 	unsigned long phys;
 
-	if (!list_empty(&pcdev->active_bufs)) {
-		buf = list_entry(pcdev->active_bufs.next,
-			struct mx2_buffer, queue);
+	BUG_ON(list_empty(&pcdev->active_bufs));
+
+	buf = list_entry(pcdev->active_bufs.next,
+			 struct mx2_buffer, queue);
 
-		BUG_ON(buf->bufnum != bufnum);
+	BUG_ON(buf->bufnum != bufnum);
 
+	if (buf->discard) {
+		/*
+		 * Discard buffer must not be returned to user space.
+		 * Just return it to the discard queue.
+		 */
+		list_move_tail(pcdev->active_bufs.next, &pcdev->discard);
+	} else {
 		vb = &buf->vb;
 #ifdef DEBUG
 		phys = vb2_dma_contig_plane_dma_addr(vb, 0);
@@ -1207,6 +1254,7 @@ static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
 			}
 		}
 #endif
+
 		dev_dbg(pcdev->dev, "%s (vb=0x%p) 0x%p %lu\n", __func__, vb,
 				vb2_plane_vaddr(vb, 0),
 				vb2_get_plane_payload(vb, 0));
@@ -1219,30 +1267,19 @@ static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
 
 	pcdev->frame_count++;
 
-	if (list_empty(&pcdev->capture)) {
-		if (prp->cfg.channel == 1) {
-			writel(pcdev->discard_buffer_dma, pcdev->base_emma +
-					PRP_DEST_RGB1_PTR + 4 * bufnum);
-		} else {
-			writel(pcdev->discard_buffer_dma, pcdev->base_emma +
-						PRP_DEST_Y_PTR -
-						0x14 * bufnum);
-			if (prp->out_fmt == V4L2_PIX_FMT_YUV420) {
-				writel(pcdev->discard_buffer_dma + imgsize,
-				       pcdev->base_emma + PRP_DEST_CB_PTR -
-				       0x14 * bufnum);
-				writel(pcdev->discard_buffer_dma +
-				       ((5 * imgsize) / 4), pcdev->base_emma +
-				       PRP_DEST_CR_PTR - 0x14 * bufnum);
-			}
-		}
+	if (list_empty(&pcdev->capture) && !list_empty(&pcdev->discard)) {
+		buf = list_entry(pcdev->discard.next,
+			struct mx2_buffer, queue);
+		buf->bufnum = bufnum;
+		list_move_tail(pcdev->discard.next, &pcdev->active_bufs);
+		mx27_update_emma_buf(pcdev, pcdev->discard_buffer_dma, bufnum);
 		return;
 	}
 
 	buf = list_entry(pcdev->capture.next,
 			struct mx2_buffer, queue);
 
-	buf->bufnum = !bufnum;
+	buf->bufnum = bufnum;
 
 	list_move_tail(pcdev->capture.next, &pcdev->active_bufs);
 
@@ -1250,18 +1287,7 @@ static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
 	buf->state = MX2_STATE_ACTIVE;
 
 	phys = vb2_dma_contig_plane_dma_addr(vb, 0);
-	if (prp->cfg.channel == 1) {
-		writel(phys, pcdev->base_emma + PRP_DEST_RGB1_PTR + 4 * bufnum);
-	} else {
-		writel(phys, pcdev->base_emma +
-				PRP_DEST_Y_PTR - 0x14 * bufnum);
-		if (prp->cfg.out_fmt == PRP_CNTL_CH2_OUT_YUV420) {
-			writel(phys + imgsize, pcdev->base_emma +
-					PRP_DEST_CB_PTR - 0x14 * bufnum);
-			writel(phys + ((5 * imgsize) / 4), pcdev->base_emma +
-					PRP_DEST_CR_PTR - 0x14 * bufnum);
-		}
-	}
+	mx27_update_emma_buf(pcdev, phys, bufnum);
 }
 
 static irqreturn_t mx27_camera_emma_irq(int irq_emma, void *data)
@@ -1413,6 +1439,7 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
 
 	INIT_LIST_HEAD(&pcdev->capture);
 	INIT_LIST_HEAD(&pcdev->active_bufs);
+	INIT_LIST_HEAD(&pcdev->discard);
 	spin_lock_init(&pcdev->lock);
 
 	/*
-- 
1.7.0.4

