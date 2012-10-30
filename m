Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44791 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757947Ab2J3MQt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Oct 2012 08:16:49 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so112185eek.19
        for <linux-media@vger.kernel.org>; Tue, 30 Oct 2012 05:16:48 -0700 (PDT)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, fabio.estevam@freescale.com,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH 1/4] media: mx2_camera: Remove i.mx25 support.
Date: Tue, 30 Oct 2012 13:16:32 +0100
Message-Id: <1351599395-16833-2-git-send-email-javier.martin@vista-silicon.com>
In-Reply-To: <1351599395-16833-1-git-send-email-javier.martin@vista-silicon.com>
References: <1351599395-16833-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

i.MX25 support has been broken for several releases
now and nobody seems to care about it.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/media/platform/soc_camera/mx2_camera.c |  405 ++++++------------------
 1 file changed, 100 insertions(+), 305 deletions(-)

diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index 9fd9d1c..e1b44b1 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -1,5 +1,5 @@
 /*
- * V4L2 Driver for i.MX27/i.MX25 camera host
+ * V4L2 Driver for i.MX27 camera host
  *
  * Copyright (C) 2008, Sascha Hauer, Pengutronix
  * Copyright (C) 2010, Baruch Siach, Orex Computed Radiography
@@ -65,9 +65,7 @@
 #define CSICR1_RF_OR_INTEN	(1 << 24)
 #define CSICR1_STATFF_LEVEL	(3 << 22)
 #define CSICR1_STATFF_INTEN	(1 << 21)
-#define CSICR1_RXFF_LEVEL(l)	(((l) & 3) << 19)	/* MX27 */
-#define CSICR1_FB2_DMA_INTEN	(1 << 20)		/* MX25 */
-#define CSICR1_FB1_DMA_INTEN	(1 << 19)		/* MX25 */
+#define CSICR1_RXFF_LEVEL(l)	(((l) & 3) << 19)
 #define CSICR1_RXFF_INTEN	(1 << 18)
 #define CSICR1_SOF_POL		(1 << 17)
 #define CSICR1_SOF_INTEN	(1 << 16)
@@ -92,11 +90,6 @@
 /* control reg 3 */
 #define CSICR3_FRMCNT		(0xFFFF << 16)
 #define CSICR3_FRMCNT_RST	(1 << 15)
-#define CSICR3_DMA_REFLASH_RFF	(1 << 14)
-#define CSICR3_DMA_REFLASH_SFF	(1 << 13)
-#define CSICR3_DMA_REQ_EN_RFF	(1 << 12)
-#define CSICR3_DMA_REQ_EN_SFF	(1 << 11)
-#define CSICR3_RXFF_LEVEL(l)	(((l) & 7) << 4)	/* MX25 */
 #define CSICR3_CSI_SUP		(1 << 3)
 #define CSICR3_ZERO_PACK_EN	(1 << 2)
 #define CSICR3_ECC_INT_EN	(1 << 1)
@@ -108,8 +101,6 @@
 #define CSISR_SFF_OR_INT	(1 << 25)
 #define CSISR_RFF_OR_INT	(1 << 24)
 #define CSISR_STATFF_INT	(1 << 21)
-#define CSISR_DMA_TSF_FB2_INT	(1 << 20)	/* MX25 */
-#define CSISR_DMA_TSF_FB1_INT	(1 << 19)	/* MX25 */
 #define CSISR_RXFF_INT		(1 << 18)
 #define CSISR_EOF_INT		(1 << 17)
 #define CSISR_SOF_INT		(1 << 16)
@@ -121,17 +112,11 @@
 
 #define CSICR1			0x00
 #define CSICR2			0x04
-#define CSISR			(cpu_is_mx27() ? 0x08 : 0x18)
+#define CSISR			0x08
 #define CSISTATFIFO		0x0c
 #define CSIRFIFO		0x10
 #define CSIRXCNT		0x14
-#define CSICR3			(cpu_is_mx27() ? 0x1C : 0x08)
-#define CSIDMASA_STATFIFO	0x20
-#define CSIDMATA_STATFIFO	0x24
-#define CSIDMASA_FB1		0x28
-#define CSIDMASA_FB2		0x2c
-#define CSIFBUF_PARA		0x30
-#define CSIIMAG_PARA		0x34
+#define CSICR3			0x1C
 
 /* EMMA PrP */
 #define PRP_CNTL			0x00
@@ -430,20 +415,9 @@ static void mx27_update_emma_buf(struct mx2_camera_dev *pcdev,
 
 static void mx2_camera_deactivate(struct mx2_camera_dev *pcdev)
 {
-	unsigned long flags;
-
 	clk_disable_unprepare(pcdev->clk_csi);
 	writel(0, pcdev->base_csi + CSICR1);
-	if (cpu_is_mx27()) {
-		writel(0, pcdev->base_emma + PRP_CNTL);
-	} else if (cpu_is_mx25()) {
-		spin_lock_irqsave(&pcdev->lock, flags);
-		pcdev->fb1_active = NULL;
-		pcdev->fb2_active = NULL;
-		writel(0, pcdev->base_csi + CSIDMASA_FB1);
-		writel(0, pcdev->base_csi + CSIDMASA_FB2);
-		spin_unlock_irqrestore(&pcdev->lock, flags);
-	}
+	writel(0, pcdev->base_emma + PRP_CNTL);
 }
 
 /*
@@ -464,10 +438,7 @@ static int mx2_camera_add_device(struct soc_camera_device *icd)
 	if (ret < 0)
 		return ret;
 
-	csicr1 = CSICR1_MCLKEN;
-
-	if (cpu_is_mx27())
-		csicr1 |= CSICR1_PRP_IF_EN | CSICR1_FCC |
+	csicr1 = CSICR1_MCLKEN | CSICR1_PRP_IF_EN | CSICR1_FCC |
 			CSICR1_RXFF_LEVEL(0);
 
 	pcdev->csicr1 = csicr1;
@@ -497,65 +468,6 @@ static void mx2_camera_remove_device(struct soc_camera_device *icd)
 	pcdev->icd = NULL;
 }
 
-static void mx25_camera_frame_done(struct mx2_camera_dev *pcdev, int fb,
-		int state)
-{
-	struct vb2_buffer *vb;
-	struct mx2_buffer *buf;
-	struct mx2_buffer **fb_active = fb == 1 ? &pcdev->fb1_active :
-		&pcdev->fb2_active;
-	u32 fb_reg = fb == 1 ? CSIDMASA_FB1 : CSIDMASA_FB2;
-	unsigned long flags;
-
-	spin_lock_irqsave(&pcdev->lock, flags);
-
-	if (*fb_active == NULL)
-		goto out;
-
-	vb = &(*fb_active)->vb;
-	dev_dbg(pcdev->dev, "%s (vb=0x%p) 0x%p %lu\n", __func__,
-		vb, vb2_plane_vaddr(vb, 0), vb2_get_plane_payload(vb, 0));
-
-	do_gettimeofday(&vb->v4l2_buf.timestamp);
-	vb->v4l2_buf.sequence++;
-	vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
-
-	if (list_empty(&pcdev->capture)) {
-		buf = NULL;
-		writel(0, pcdev->base_csi + fb_reg);
-	} else {
-		buf = list_first_entry(&pcdev->capture, struct mx2_buffer,
-				internal.queue);
-		vb = &buf->vb;
-		list_del(&buf->internal.queue);
-		buf->state = MX2_STATE_ACTIVE;
-		writel(vb2_dma_contig_plane_dma_addr(vb, 0),
-		       pcdev->base_csi + fb_reg);
-	}
-
-	*fb_active = buf;
-
-out:
-	spin_unlock_irqrestore(&pcdev->lock, flags);
-}
-
-static irqreturn_t mx25_camera_irq(int irq_csi, void *data)
-{
-	struct mx2_camera_dev *pcdev = data;
-	u32 status = readl(pcdev->base_csi + CSISR);
-
-	if (status & CSISR_DMA_TSF_FB1_INT)
-		mx25_camera_frame_done(pcdev, 1, MX2_STATE_DONE);
-	else if (status & CSISR_DMA_TSF_FB2_INT)
-		mx25_camera_frame_done(pcdev, 2, MX2_STATE_DONE);
-
-	/* FIXME: handle CSISR_RFF_OR_INT */
-
-	writel(status, pcdev->base_csi + CSISR);
-
-	return IRQ_HANDLED;
-}
-
 /*
  *  Videobuf operations
  */
@@ -636,54 +548,17 @@ static void mx2_videobuf_queue(struct vb2_buffer *vb)
 	buf->state = MX2_STATE_QUEUED;
 	list_add_tail(&buf->internal.queue, &pcdev->capture);
 
-	if (cpu_is_mx25()) {
-		u32 csicr3, dma_inten = 0;
-
-		if (pcdev->fb1_active == NULL) {
-			writel(vb2_dma_contig_plane_dma_addr(vb, 0),
-					pcdev->base_csi + CSIDMASA_FB1);
-			pcdev->fb1_active = buf;
-			dma_inten = CSICR1_FB1_DMA_INTEN;
-		} else if (pcdev->fb2_active == NULL) {
-			writel(vb2_dma_contig_plane_dma_addr(vb, 0),
-					pcdev->base_csi + CSIDMASA_FB2);
-			pcdev->fb2_active = buf;
-			dma_inten = CSICR1_FB2_DMA_INTEN;
-		}
-
-		if (dma_inten) {
-			list_del(&buf->internal.queue);
-			buf->state = MX2_STATE_ACTIVE;
-
-			csicr3 = readl(pcdev->base_csi + CSICR3);
-
-			/* Reflash DMA */
-			writel(csicr3 | CSICR3_DMA_REFLASH_RFF,
-					pcdev->base_csi + CSICR3);
-
-			/* clear & enable interrupts */
-			writel(dma_inten, pcdev->base_csi + CSISR);
-			pcdev->csicr1 |= dma_inten;
-			writel(pcdev->csicr1, pcdev->base_csi + CSICR1);
-
-			/* enable DMA */
-			csicr3 |= CSICR3_DMA_REQ_EN_RFF | CSICR3_RXFF_LEVEL(1);
-			writel(csicr3, pcdev->base_csi + CSICR3);
-		}
-	}
-
 	spin_unlock_irqrestore(&pcdev->lock, flags);
 }
 
 static void mx2_videobuf_release(struct vb2_buffer *vb)
 {
+#ifdef DEBUG
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx2_camera_dev *pcdev = ici->priv;
 	struct mx2_buffer *buf = container_of(vb, struct mx2_buffer, vb);
-	unsigned long flags;
 
-#ifdef DEBUG
 	dev_dbg(icd->parent, "%s (vb=0x%p) 0x%p %lu\n", __func__,
 		vb, vb2_plane_vaddr(vb, 0), vb2_get_plane_payload(vb, 0));
 
@@ -702,29 +577,11 @@ static void mx2_videobuf_release(struct vb2_buffer *vb)
 #endif
 
 	/*
-	 * Terminate only queued but inactive buffers. Active buffers are
-	 * released when they become inactive after videobuf_waiton().
-	 *
 	 * FIXME: implement forced termination of active buffers for mx27 and
 	 * mx27 eMMA, so that the user won't get stuck in an uninterruptible
 	 * state. This requires a specific handling for each of the these DMA
 	 * types.
 	 */
-
-	spin_lock_irqsave(&pcdev->lock, flags);
-	if (cpu_is_mx25() && buf->state == MX2_STATE_ACTIVE) {
-		if (pcdev->fb1_active == buf) {
-			pcdev->csicr1 &= ~CSICR1_FB1_DMA_INTEN;
-			writel(0, pcdev->base_csi + CSIDMASA_FB1);
-			pcdev->fb1_active = NULL;
-		} else if (pcdev->fb2_active == buf) {
-			pcdev->csicr1 &= ~CSICR1_FB2_DMA_INTEN;
-			writel(0, pcdev->base_csi + CSIDMASA_FB2);
-			pcdev->fb2_active = NULL;
-		}
-		writel(pcdev->csicr1, pcdev->base_csi + CSICR1);
-	}
-	spin_unlock_irqrestore(&pcdev->lock, flags);
 }
 
 static void mx27_camera_emma_buf_init(struct soc_camera_device *icd,
@@ -835,86 +692,84 @@ static int mx2_start_streaming(struct vb2_queue *q, unsigned int count)
 	unsigned long phys;
 	int bytesperline;
 
-	if (cpu_is_mx27()) {
-		unsigned long flags;
-		if (count < 2)
-			return -EINVAL;
+	unsigned long flags;
+	if (count < 2)
+		return -EINVAL;
 
-		spin_lock_irqsave(&pcdev->lock, flags);
+	spin_lock_irqsave(&pcdev->lock, flags);
 
-		buf = list_first_entry(&pcdev->capture, struct mx2_buffer,
-				       internal.queue);
-		buf->internal.bufnum = 0;
-		vb = &buf->vb;
-		buf->state = MX2_STATE_ACTIVE;
+	buf = list_first_entry(&pcdev->capture, struct mx2_buffer,
+			       internal.queue);
+	buf->internal.bufnum = 0;
+	vb = &buf->vb;
+	buf->state = MX2_STATE_ACTIVE;
 
-		phys = vb2_dma_contig_plane_dma_addr(vb, 0);
-		mx27_update_emma_buf(pcdev, phys, buf->internal.bufnum);
-		list_move_tail(pcdev->capture.next, &pcdev->active_bufs);
+	phys = vb2_dma_contig_plane_dma_addr(vb, 0);
+	mx27_update_emma_buf(pcdev, phys, buf->internal.bufnum);
+	list_move_tail(pcdev->capture.next, &pcdev->active_bufs);
 
-		buf = list_first_entry(&pcdev->capture, struct mx2_buffer,
-				       internal.queue);
-		buf->internal.bufnum = 1;
-		vb = &buf->vb;
-		buf->state = MX2_STATE_ACTIVE;
+	buf = list_first_entry(&pcdev->capture, struct mx2_buffer,
+			       internal.queue);
+	buf->internal.bufnum = 1;
+	vb = &buf->vb;
+	buf->state = MX2_STATE_ACTIVE;
 
-		phys = vb2_dma_contig_plane_dma_addr(vb, 0);
-		mx27_update_emma_buf(pcdev, phys, buf->internal.bufnum);
-		list_move_tail(pcdev->capture.next, &pcdev->active_bufs);
+	phys = vb2_dma_contig_plane_dma_addr(vb, 0);
+	mx27_update_emma_buf(pcdev, phys, buf->internal.bufnum);
+	list_move_tail(pcdev->capture.next, &pcdev->active_bufs);
 
-		bytesperline = soc_mbus_bytes_per_line(icd->user_width,
-				icd->current_fmt->host_fmt);
-		if (bytesperline < 0)
-			return bytesperline;
+	bytesperline = soc_mbus_bytes_per_line(icd->user_width,
+			icd->current_fmt->host_fmt);
+	if (bytesperline < 0)
+		return bytesperline;
 
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
+	/*
+	 * I didn't manage to properly enable/disable the prp
+	 * on a per frame basis during running transfers,
+	 * thus we allocate a buffer here and use it to
+	 * discard frames when no buffer is available.
+	 * Feel free to work on this ;)
+	 */
+	pcdev->discard_size = icd->user_height * bytesperline;
+	pcdev->discard_buffer = dma_alloc_coherent(ici->v4l2_dev.dev,
+			pcdev->discard_size, &pcdev->discard_buffer_dma,
+			GFP_KERNEL);
+	if (!pcdev->discard_buffer)
+		return -ENOMEM;
 
-		pcdev->buf_discard[0].discard = true;
-		list_add_tail(&pcdev->buf_discard[0].queue,
-				      &pcdev->discard);
+	pcdev->buf_discard[0].discard = true;
+	list_add_tail(&pcdev->buf_discard[0].queue,
+			      &pcdev->discard);
 
-		pcdev->buf_discard[1].discard = true;
-		list_add_tail(&pcdev->buf_discard[1].queue,
-				      &pcdev->discard);
+	pcdev->buf_discard[1].discard = true;
+	list_add_tail(&pcdev->buf_discard[1].queue,
+			      &pcdev->discard);
 
-		mx2_prp_resize_commit(pcdev);
+	mx2_prp_resize_commit(pcdev);
 
-		mx27_camera_emma_buf_init(icd, bytesperline);
+	mx27_camera_emma_buf_init(icd, bytesperline);
 
-		if (prp->cfg.channel == 1) {
-			writel(PRP_CNTL_CH1EN |
-				PRP_CNTL_CSIEN |
-				prp->cfg.in_fmt |
-				prp->cfg.out_fmt |
-				PRP_CNTL_CH1_LEN |
-				PRP_CNTL_CH1BYP |
-				PRP_CNTL_CH1_TSKIP(0) |
-				PRP_CNTL_IN_TSKIP(0),
-				pcdev->base_emma + PRP_CNTL);
-		} else {
-			writel(PRP_CNTL_CH2EN |
-				PRP_CNTL_CSIEN |
-				prp->cfg.in_fmt |
-				prp->cfg.out_fmt |
-				PRP_CNTL_CH2_LEN |
-				PRP_CNTL_CH2_TSKIP(0) |
-				PRP_CNTL_IN_TSKIP(0),
-				pcdev->base_emma + PRP_CNTL);
-		}
-		spin_unlock_irqrestore(&pcdev->lock, flags);
+	if (prp->cfg.channel == 1) {
+		writel(PRP_CNTL_CH1EN |
+			PRP_CNTL_CSIEN |
+			prp->cfg.in_fmt |
+			prp->cfg.out_fmt |
+			PRP_CNTL_CH1_LEN |
+			PRP_CNTL_CH1BYP |
+			PRP_CNTL_CH1_TSKIP(0) |
+			PRP_CNTL_IN_TSKIP(0),
+			pcdev->base_emma + PRP_CNTL);
+	} else {
+		writel(PRP_CNTL_CH2EN |
+			PRP_CNTL_CSIEN |
+			prp->cfg.in_fmt |
+			prp->cfg.out_fmt |
+			PRP_CNTL_CH2_LEN |
+			PRP_CNTL_CH2_TSKIP(0) |
+			PRP_CNTL_IN_TSKIP(0),
+			pcdev->base_emma + PRP_CNTL);
 	}
+	spin_unlock_irqrestore(&pcdev->lock, flags);
 
 	return 0;
 }
@@ -930,29 +785,27 @@ static int mx2_stop_streaming(struct vb2_queue *q)
 	void *b;
 	u32 cntl;
 
-	if (cpu_is_mx27()) {
-		spin_lock_irqsave(&pcdev->lock, flags);
+	spin_lock_irqsave(&pcdev->lock, flags);
 
-		cntl = readl(pcdev->base_emma + PRP_CNTL);
-		if (prp->cfg.channel == 1) {
-			writel(cntl & ~PRP_CNTL_CH1EN,
-			       pcdev->base_emma + PRP_CNTL);
-		} else {
-			writel(cntl & ~PRP_CNTL_CH2EN,
-			       pcdev->base_emma + PRP_CNTL);
-		}
-		INIT_LIST_HEAD(&pcdev->capture);
-		INIT_LIST_HEAD(&pcdev->active_bufs);
-		INIT_LIST_HEAD(&pcdev->discard);
+	cntl = readl(pcdev->base_emma + PRP_CNTL);
+	if (prp->cfg.channel == 1) {
+		writel(cntl & ~PRP_CNTL_CH1EN,
+		       pcdev->base_emma + PRP_CNTL);
+	} else {
+		writel(cntl & ~PRP_CNTL_CH2EN,
+		       pcdev->base_emma + PRP_CNTL);
+	}
+	INIT_LIST_HEAD(&pcdev->capture);
+	INIT_LIST_HEAD(&pcdev->active_bufs);
+	INIT_LIST_HEAD(&pcdev->discard);
 
-		b = pcdev->discard_buffer;
-		pcdev->discard_buffer = NULL;
+	b = pcdev->discard_buffer;
+	pcdev->discard_buffer = NULL;
 
-		spin_unlock_irqrestore(&pcdev->lock, flags);
+	spin_unlock_irqrestore(&pcdev->lock, flags);
 
-		dma_free_coherent(ici->v4l2_dev.dev,
-			pcdev->discard_size, b, pcdev->discard_buffer_dma);
-	}
+	dma_free_coherent(ici->v4l2_dev.dev,
+		pcdev->discard_size, b, pcdev->discard_buffer_dma);
 
 	return 0;
 }
@@ -1082,16 +935,9 @@ static int mx2_camera_set_bus_param(struct soc_camera_device *icd)
 	if (bytesperline < 0)
 		return bytesperline;
 
-	if (cpu_is_mx27()) {
-		ret = mx27_camera_emma_prp_reset(pcdev);
-		if (ret)
-			return ret;
-	} else if (cpu_is_mx25()) {
-		writel((bytesperline * icd->user_height) >> 2,
-				pcdev->base_csi + CSIRXCNT);
-		writel((bytesperline << 16) | icd->user_height,
-				pcdev->base_csi + CSIIMAG_PARA);
-	}
+	ret = mx27_camera_emma_prp_reset(pcdev);
+	if (ret)
+		return ret;
 
 	writel(pcdev->csicr1, pcdev->base_csi + CSICR1);
 
@@ -1377,7 +1223,6 @@ static int mx2_camera_try_fmt(struct soc_camera_device *icd,
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx2_camera_dev *pcdev = ici->priv;
 	struct mx2_fmt_cfg *emma_prp;
-	unsigned int width_limit;
 	int ret;
 
 	dev_dbg(icd->parent, "%s: requested params: width = %d, height = %d\n",
@@ -1391,39 +1236,6 @@ static int mx2_camera_try_fmt(struct soc_camera_device *icd,
 
 	/* FIXME: implement MX27 limits */
 
-	/* limit to MX25 hardware capabilities */
-	if (cpu_is_mx25()) {
-		if (xlate->host_fmt->bits_per_sample <= 8)
-			width_limit = 0xffff * 4;
-		else
-			width_limit = 0xffff * 2;
-		/* CSIIMAG_PARA limit */
-		if (pix->width > width_limit)
-			pix->width = width_limit;
-		if (pix->height > 0xffff)
-			pix->height = 0xffff;
-
-		pix->bytesperline = soc_mbus_bytes_per_line(pix->width,
-				xlate->host_fmt);
-		if (pix->bytesperline < 0)
-			return pix->bytesperline;
-		pix->sizeimage = soc_mbus_image_size(xlate->host_fmt,
-						pix->bytesperline, pix->height);
-		/* Check against the CSIRXCNT limit */
-		if (pix->sizeimage > 4 * 0x3ffff) {
-			/* Adjust geometry, preserve aspect ratio */
-			unsigned int new_height = int_sqrt(div_u64(0x3ffffULL *
-					4 * pix->height, pix->bytesperline));
-			pix->width = new_height * pix->width / pix->height;
-			pix->height = new_height;
-			pix->bytesperline = soc_mbus_bytes_per_line(pix->width,
-							xlate->host_fmt);
-			BUG_ON(pix->bytesperline < 0);
-			pix->sizeimage = soc_mbus_image_size(xlate->host_fmt,
-						pix->bytesperline, pix->height);
-		}
-	}
-
 	/* limit to sensor capabilities */
 	mf.width	= pix->width;
 	mf.height	= pix->height;
@@ -1763,20 +1575,9 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
 	pcdev->dev = &pdev->dev;
 	platform_set_drvdata(pdev, pcdev);
 
-	if (cpu_is_mx25()) {
-		err = devm_request_irq(&pdev->dev, irq_csi, mx25_camera_irq, 0,
-				       MX2_CAM_DRV_NAME, pcdev);
-		if (err) {
-			dev_err(pcdev->dev, "Camera interrupt register failed \n");
-			goto exit;
-		}
-	}
-
-	if (cpu_is_mx27()) {
-		err = mx27_camera_emma_init(pdev);
-		if (err)
-			goto exit;
-	}
+	err = mx27_camera_emma_init(pdev);
+	if (err)
+		goto exit;
 
 	/*
 	 * We're done with drvdata here.  Clear the pointer so that
@@ -1789,8 +1590,6 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
 	pcdev->soc_host.priv		= pcdev;
 	pcdev->soc_host.v4l2_dev.dev	= &pdev->dev;
 	pcdev->soc_host.nr		= pdev->id;
-	if (cpu_is_mx25())
-		pcdev->soc_host.capabilities = SOCAM_HOST_CAP_STRIDE;
 
 	pcdev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
 	if (IS_ERR(pcdev->alloc_ctx)) {
@@ -1809,10 +1608,8 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
 exit_free_emma:
 	vb2_dma_contig_cleanup_ctx(pcdev->alloc_ctx);
 eallocctx:
-	if (cpu_is_mx27()) {
-		clk_disable_unprepare(pcdev->clk_emma_ipg);
-		clk_disable_unprepare(pcdev->clk_emma_ahb);
-	}
+	clk_disable_unprepare(pcdev->clk_emma_ipg);
+	clk_disable_unprepare(pcdev->clk_emma_ahb);
 exit:
 	return err;
 }
@@ -1827,10 +1624,8 @@ static int __devexit mx2_camera_remove(struct platform_device *pdev)
 
 	vb2_dma_contig_cleanup_ctx(pcdev->alloc_ctx);
 
-	if (cpu_is_mx27()) {
-		clk_disable_unprepare(pcdev->clk_emma_ipg);
-		clk_disable_unprepare(pcdev->clk_emma_ahb);
-	}
+	clk_disable_unprepare(pcdev->clk_emma_ipg);
+	clk_disable_unprepare(pcdev->clk_emma_ahb);
 
 	dev_info(&pdev->dev, "MX2 Camera driver unloaded\n");
 
@@ -1858,7 +1653,7 @@ static void __exit mx2_camera_exit(void)
 module_init(mx2_camera_init);
 module_exit(mx2_camera_exit);
 
-MODULE_DESCRIPTION("i.MX27/i.MX25 SoC Camera Host driver");
+MODULE_DESCRIPTION("i.MX27 SoC Camera Host driver");
 MODULE_AUTHOR("Sascha Hauer <sha@pengutronix.de>");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(MX2_CAM_VERSION);
-- 
1.7.9.5

