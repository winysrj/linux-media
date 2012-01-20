Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50001 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573Ab2ATLgq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jan 2012 06:36:46 -0500
Received: by mail-ww0-f44.google.com with SMTP id ed3so238090wgb.1
        for <linux-media@vger.kernel.org>; Fri, 20 Jan 2012 03:36:45 -0800 (PST)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, s.hauer@pengutronix.de, baruch@tkos.co.il,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH 3/4] media i.MX27 camera: improve discard buffer handling.
Date: Fri, 20 Jan 2012 12:36:31 +0100
Message-Id: <1327059392-29240-4-git-send-email-javier.martin@vista-silicon.com>
In-Reply-To: <1327059392-29240-1-git-send-email-javier.martin@vista-silicon.com>
References: <1327059392-29240-1-git-send-email-javier.martin@vista-silicon.com>
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
 drivers/media/video/mx2_camera.c |  215 +++++++++++++++++++++-----------------
 1 files changed, 117 insertions(+), 98 deletions(-)

diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index 4816da6..e0c5dd4 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -224,6 +224,28 @@ struct mx2_fmt_cfg {
 	struct mx2_prp_cfg		cfg;
 };
 
+enum mx2_buffer_state {
+	MX2_STATE_NEEDS_INIT = 0,
+	MX2_STATE_PREPARED   = 1,
+	MX2_STATE_QUEUED     = 2,
+	MX2_STATE_ACTIVE     = 3,
+	MX2_STATE_DONE       = 4,
+	MX2_STATE_ERROR      = 5,
+	MX2_STATE_IDLE       = 6,
+};
+
+/* buffer for one video frame */
+struct mx2_buffer {
+	/* common v4l buffer stuff -- must be first */
+	struct vb2_buffer		vb;
+	struct list_head		queue;
+	enum mx2_buffer_state		state;
+	enum v4l2_mbus_pixelcode	code;
+
+	int				bufnum;
+	bool				discard;
+};
+
 struct mx2_camera_dev {
 	struct device		*dev;
 	struct soc_camera_host	soc_host;
@@ -240,6 +262,7 @@ struct mx2_camera_dev {
 
 	struct list_head	capture;
 	struct list_head	active_bufs;
+	struct list_head	discard;
 
 	spinlock_t		lock;
 
@@ -252,6 +275,7 @@ struct mx2_camera_dev {
 
 	u32			csicr1;
 
+	struct mx2_buffer	buf_discard[2];
 	void			*discard_buffer;
 	dma_addr_t		discard_buffer_dma;
 	size_t			discard_size;
@@ -260,27 +284,6 @@ struct mx2_camera_dev {
 	struct vb2_alloc_ctx	*alloc_ctx;
 };
 
-enum mx2_buffer_state {
-	MX2_STATE_NEEDS_INIT = 0,
-	MX2_STATE_PREPARED   = 1,
-	MX2_STATE_QUEUED     = 2,
-	MX2_STATE_ACTIVE     = 3,
-	MX2_STATE_DONE       = 4,
-	MX2_STATE_ERROR      = 5,
-	MX2_STATE_IDLE       = 6,
-};
-
-/* buffer for one video frame */
-struct mx2_buffer {
-	/* common v4l buffer stuff -- must be first */
-	struct vb2_buffer		vb;
-	struct list_head		queue;
-	enum mx2_buffer_state		state;
-	enum v4l2_mbus_pixelcode	code;
-
-	int bufnum;
-};
-
 static struct mx2_fmt_cfg mx27_emma_prp_table[] = {
 	/*
 	 * This is a generic configuration which is valid for most
@@ -334,6 +337,29 @@ static struct mx2_fmt_cfg *mx27_emma_prp_get_format(
 	return &mx27_emma_prp_table[0];
 };
 
+static void mx27_update_emma_buf(struct mx2_camera_dev *pcdev,
+				 unsigned long phys, int bufnum)
+{
+	u32 imgsize = pcdev->icd->user_height * pcdev->icd->user_width;
+	struct mx2_fmt_cfg *prp = pcdev->emma_prp;
+
+	if (prp->cfg.channel == 1) {
+		writel(phys, pcdev->base_emma +
+				PRP_DEST_RGB1_PTR + 4 * bufnum);
+	} else {
+		writel(phys, pcdev->base_emma +
+					PRP_DEST_Y_PTR -
+					0x14 * bufnum);
+		if (prp->out_fmt == V4L2_PIX_FMT_YUV420) {
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
@@ -382,7 +408,7 @@ static int mx2_camera_add_device(struct soc_camera_device *icd)
 	writel(pcdev->csicr1, pcdev->base_csi + CSICR1);
 
 	pcdev->icd = icd;
-	pcdev->frame_count = -1;
+	pcdev->frame_count = 0;
 
 	dev_info(icd->parent, "Camera driver attached to camera %d\n",
 		 icd->devnum);
@@ -648,10 +674,9 @@ static void mx2_videobuf_release(struct vb2_buffer *vb)
 	 * types.
 	 */
 	spin_lock_irqsave(&pcdev->lock, flags);
-	if (buf->state == MX2_STATE_QUEUED || buf->state == MX2_STATE_ACTIVE) {
-		list_del_init(&buf->queue);
-		buf->state = MX2_STATE_NEEDS_INIT;
-	} else if (cpu_is_mx25() && buf->state == MX2_STATE_ACTIVE) {
+	INIT_LIST_HEAD(&buf->queue);
+	buf->state = MX2_STATE_NEEDS_INIT;
+	if (cpu_is_mx25() && buf->state == MX2_STATE_ACTIVE) {
 		if (pcdev->fb1_active == buf) {
 			pcdev->csicr1 &= ~CSICR1_FB1_DMA_INTEN;
 			writel(0, pcdev->base_csi + CSIDMASA_FB1);
@@ -674,7 +699,10 @@ static int mx2_start_streaming(struct vb2_queue *q, unsigned int count)
 		to_soc_camera_host(icd->parent);
 	struct mx2_camera_dev *pcdev = ici->priv;
 	struct mx2_fmt_cfg *prp = pcdev->emma_prp;
+	struct vb2_buffer *vb;
+	struct mx2_buffer *buf;
 	unsigned long flags;
+	unsigned long phys;
 	int ret = 0;
 
 	spin_lock_irqsave(&pcdev->lock, flags);
@@ -684,6 +712,26 @@ static int mx2_start_streaming(struct vb2_queue *q, unsigned int count)
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
 		if (prp->cfg.channel == 1) {
 			writel(PRP_CNTL_CH1EN |
 				PRP_CNTL_CSIEN |
@@ -731,6 +779,9 @@ static int mx2_stop_streaming(struct vb2_queue *q)
 			writel(cntl & ~PRP_CNTL_CH2EN,
 			       pcdev->base_emma + PRP_CNTL);
 		}
+		INIT_LIST_HEAD(&pcdev->capture);
+		INIT_LIST_HEAD(&pcdev->active_bufs);
+		INIT_LIST_HEAD(&pcdev->discard);
 	}
 	spin_unlock_irqrestore(&pcdev->lock, flags);
 
@@ -793,50 +844,21 @@ static void mx27_camera_emma_buf_init(struct soc_camera_device *icd,
 		to_soc_camera_host(icd->parent);
 	struct mx2_camera_dev *pcdev = ici->priv;
 	struct mx2_fmt_cfg *prp = pcdev->emma_prp;
-	u32 imgsize = pcdev->icd->user_height * pcdev->icd->user_width;
 
+	writel((icd->user_width << 16) | icd->user_height,
+	       pcdev->base_emma + PRP_SRC_FRAME_SIZE);
+	writel(prp->cfg.src_pixel,
+	       pcdev->base_emma + PRP_SRC_PIXEL_FORMAT_CNTL);
 	if (prp->cfg.channel == 1) {
-		writel(pcdev->discard_buffer_dma,
-				pcdev->base_emma + PRP_DEST_RGB1_PTR);
-		writel(pcdev->discard_buffer_dma,
-				pcdev->base_emma + PRP_DEST_RGB2_PTR);
-
-		writel((icd->user_width << 16) | icd->user_height,
-			pcdev->base_emma + PRP_SRC_FRAME_SIZE);
 		writel((icd->user_width << 16) | icd->user_height,
 			pcdev->base_emma + PRP_CH1_OUT_IMAGE_SIZE);
 		writel(bytesperline,
 			pcdev->base_emma + PRP_DEST_CH1_LINE_STRIDE);
-		writel(prp->cfg.src_pixel,
-			pcdev->base_emma + PRP_SRC_PIXEL_FORMAT_CNTL);
 		writel(prp->cfg.ch1_pixel,
 			pcdev->base_emma + PRP_CH1_PIXEL_FORMAT_CNTL);
 	} else { /* channel 2 */
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
 		writel((icd->user_width << 16) | icd->user_height,
 			pcdev->base_emma + PRP_CH2_OUT_IMAGE_SIZE);
-
-		writel(prp->cfg.src_pixel,
-			pcdev->base_emma + PRP_SRC_PIXEL_FORMAT_CNTL);
-
 	}
 
 	/* Enable interrupts */
@@ -927,11 +949,22 @@ static int mx2_camera_set_bus_param(struct soc_camera_device *icd,
 		if (ret)
 			return ret;
 
-		if (pcdev->discard_buffer)
+		if (pcdev->discard_buffer) {
 			dma_free_coherent(ici->v4l2_dev.dev,
 				pcdev->discard_size, pcdev->discard_buffer,
 				pcdev->discard_buffer_dma);
 
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
 		/*
 		 * I didn't manage to properly enable/disable the prp
 		 * on a per frame basis during running transfers,
@@ -1193,18 +1226,24 @@ static struct soc_camera_host_ops mx2_soc_camera_host_ops = {
 static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
 		int bufnum, int state)
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
@@ -1226,6 +1265,7 @@ static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
 			}
 		}
 #endif
+
 		dev_dbg(pcdev->dev, "%s (vb=0x%p) 0x%p %lu\n", __func__, vb,
 				vb2_plane_vaddr(vb, 0),
 				vb2_get_plane_payload(vb, 0));
@@ -1237,32 +1277,21 @@ static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
 		vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
 	}
 
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
+	pcdev->frame_count++;
+
+	if (list_empty(&pcdev->capture) && !list_empty(&pcdev->discard)) {
+		buf = list_entry(pcdev->discard.next,
+			struct mx2_buffer, queue);
+		buf->bufnum = bufnum;
+		list_move_tail(pcdev->discard.next, &pcdev->active_bufs);
+		mx27_update_emma_buf(pcdev, pcdev->discard_buffer_dma, bufnum);
 		return;
 	}
 
-	pcdev->frame_count++;
-
 	buf = list_entry(pcdev->capture.next,
 			struct mx2_buffer, queue);
 
-	buf->bufnum = !bufnum;
+	buf->bufnum = bufnum;
 
 	list_move_tail(pcdev->capture.next, &pcdev->active_bufs);
 
@@ -1270,18 +1299,7 @@ static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
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
@@ -1433,6 +1451,7 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
 
 	INIT_LIST_HEAD(&pcdev->capture);
 	INIT_LIST_HEAD(&pcdev->active_bufs);
+	INIT_LIST_HEAD(&pcdev->discard);
 	spin_lock_init(&pcdev->lock);
 
 	/*
-- 
1.7.0.4

