Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:58888 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837Ab1F3UFm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jun 2011 16:05:42 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Kassey Lee <ygli@marvell.com>, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 1/2] marvell-cam: Working s/g DMA
Date: Thu, 30 Jun 2011 14:05:27 -0600
Message-Id: <1309464328-67565-2-git-send-email-corbet@lwn.net>
In-Reply-To: <1309464328-67565-1-git-send-email-corbet@lwn.net>
References: <1309464328-67565-1-git-send-email-corbet@lwn.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The core Marvell camera driver can now do scatter/gather DMA on controllers
which support that functionality.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/media/video/marvell-ccic/Kconfig     |    3 +
 drivers/media/video/marvell-ccic/mcam-core.c |  289 ++++++++++++++++++++++----
 drivers/media/video/marvell-ccic/mcam-core.h |   16 ++-
 3 files changed, 266 insertions(+), 42 deletions(-)

diff --git a/drivers/media/video/marvell-ccic/Kconfig b/drivers/media/video/marvell-ccic/Kconfig
index 22314a0..5be66e2 100644
--- a/drivers/media/video/marvell-ccic/Kconfig
+++ b/drivers/media/video/marvell-ccic/Kconfig
@@ -3,6 +3,8 @@ config VIDEO_CAFE_CCIC
 	depends on PCI && I2C && VIDEO_V4L2
 	select VIDEO_OV7670
 	select VIDEOBUF2_VMALLOC
+	select VIDEOBUF2_DMA_CONTIG
+	select VIDEOBUF2_DMA_SG
 	---help---
 	  This is a video4linux2 driver for the Marvell 88ALP01 integrated
 	  CMOS camera controller.  This is the controller found on first-
@@ -15,6 +17,7 @@ config VIDEO_MMP_CAMERA
 	select I2C_GPIO
 	select VIDEOBUF2_VMALLOC
 	select VIDEOBUF2_DMA_CONTIG
+	select VIDEOBUF2_DMA_SG
 	---help---
 	  This is a Video4Linux2 driver for the integrated camera
 	  controller found on Marvell Armada 610 application
diff --git a/drivers/media/video/marvell-ccic/mcam-core.c b/drivers/media/video/marvell-ccic/mcam-core.c
index 419b4e5..af5faa6 100644
--- a/drivers/media/video/marvell-ccic/mcam-core.c
+++ b/drivers/media/video/marvell-ccic/mcam-core.c
@@ -26,6 +26,7 @@
 #include <media/ov7670.h>
 #include <media/videobuf2-vmalloc.h>
 #include <media/videobuf2-dma-contig.h>
+#include <media/videobuf2-dma-sg.h>
 
 #include "mcam-core.h"
 
@@ -106,6 +107,7 @@ MODULE_PARM_DESC(buffer_mode,
 #define CF_DMA_ACTIVE	 3	/* A frame is incoming */
 #define CF_CONFIG_NEEDED 4	/* Must configure hardware */
 #define CF_SINGLE_BUFFER 5	/* Running with a single buffer */
+#define CF_SG_RESTART	 6	/* SG restart needed */
 
 #define sensor_call(cam, o, f, args...) \
 	v4l2_subdev_call(cam->sensor, o, f, ##args)
@@ -180,6 +182,17 @@ static void mcam_set_config_needed(struct mcam_camera *cam, int needed)
 }
 
 /*
+ * The two-word DMA descriptor format used by the Armada 610 and like.  There
+ * Is a three-word format as well (set C1_DESC_3WORD) where the third
+ * word is a pointer to the next descriptor, but we don't use it.  Two-word
+ * descriptors have to be contiguous in memory.
+ */
+struct mcam_dma_desc {
+	u32 dma_addr;
+	u32 segment_len;
+};
+
+/*
  * Our buffer type for working with videobuf2.  Note that the vb2
  * developers have decreed that struct vb2_buffer must be at the
  * beginning of this structure.
@@ -187,6 +200,9 @@ static void mcam_set_config_needed(struct mcam_camera *cam, int needed)
 struct mcam_vb_buffer {
 	struct vb2_buffer vb_buf;
 	struct list_head queue;
+	struct mcam_dma_desc *dma_desc;	/* Descriptor virtual address */
+	dma_addr_t dma_desc_pa;		/* Descriptor physical address */
+	int dma_desc_nent;		/* Number of mapped descriptors */
 };
 
 static inline struct mcam_vb_buffer *vb_to_mvb(struct vb2_buffer *vb)
@@ -268,6 +284,9 @@ static void mcam_set_contig_buffer(struct mcam_camera *cam, int frame)
 	clear_bit(CF_SINGLE_BUFFER, &cam->flags);
 }
 
+/*
+ * Initial B_DMA_contig setup.
+ */
 static void mcam_ctlr_dma_contig(struct mcam_camera *cam)
 {
 	mcam_reg_set_bit(cam, REG_CTRL1, C1_TWOBUFS);
@@ -277,14 +296,38 @@ static void mcam_ctlr_dma_contig(struct mcam_camera *cam)
 }
 
 
-static void mcam_ctlr_dma(struct mcam_camera *cam)
+/*
+ * Set up the next buffer for S/G I/O; caller should be sure that
+ * the controller is stopped and a buffer is available.
+ */
+static void mcam_sg_next_buffer(struct mcam_camera *cam)
 {
-	if (cam->buffer_mode == B_DMA_contig)
-		mcam_ctlr_dma_contig(cam);
-	else
-		mcam_ctlr_dma_vmalloc(cam);
+	struct mcam_vb_buffer *buf;
+
+	buf = list_first_entry(&cam->buffers, struct mcam_vb_buffer, queue);
+	list_del_init(&buf->queue);
+	mcam_reg_write(cam, REG_DMA_DESC_Y, buf->dma_desc_pa);
+	mcam_reg_write(cam, REG_DESC_LEN_Y,
+			buf->dma_desc_nent*sizeof(struct mcam_dma_desc));
+	mcam_reg_write(cam, REG_DESC_LEN_U, 0);
+	mcam_reg_write(cam, REG_DESC_LEN_V, 0);
+	cam->vb_bufs[0] = buf;
 }
 
+/*
+ * Initial B_DMA_sg setup
+ */
+static void mcam_ctlr_dma_sg(struct mcam_camera *cam)
+{
+	mcam_reg_clear_bit(cam, REG_CTRL1, C1_DESC_3WORD);
+	mcam_sg_next_buffer(cam);
+	mcam_reg_set_bit(cam, REG_CTRL1, C1_DESC_ENA);
+	cam->nbufs = 3;
+}
+
+/*
+ * Image format setup, independent of DMA scheme.
+ */
 static void mcam_ctlr_image(struct mcam_camera *cam)
 {
 	int imgsz;
@@ -341,9 +384,20 @@ static int mcam_ctlr_configure(struct mcam_camera *cam)
 	unsigned long flags;
 
 	spin_lock_irqsave(&cam->dev_lock, flags);
-	mcam_ctlr_dma(cam);
+	switch (cam->buffer_mode) {
+	case B_vmalloc:
+		mcam_ctlr_dma_vmalloc(cam);
+		break;
+	case B_DMA_contig:
+		mcam_ctlr_dma_contig(cam);
+		break;
+	case B_DMA_sg:
+		mcam_ctlr_dma_sg(cam);
+		break;
+	}
 	mcam_ctlr_image(cam);
 	mcam_set_config_needed(cam, 0);
+	clear_bit(CF_SG_RESTART, &cam->flags);
 	spin_unlock_irqrestore(&cam->dev_lock, flags);
 	return 0;
 }
@@ -379,6 +433,19 @@ static void mcam_ctlr_stop(struct mcam_camera *cam)
 	mcam_reg_clear_bit(cam, REG_CTRL0, C0_ENABLE);
 }
 
+/*
+ * Scatter/gather mode requires stopping the controller between
+ * frames so we can put in a new DMA descriptor array.  If no new
+ * buffer exists at frame completion, the controller is left stopped;
+ * this function is charged with gettig things going again.
+ */
+static void mcam_sg_restart(struct mcam_camera *cam)
+{
+	mcam_ctlr_dma_sg(cam);
+	mcam_ctlr_start(cam);
+	clear_bit(CF_SG_RESTART, &cam->flags);
+}
+
 static void mcam_ctlr_init(struct mcam_camera *cam)
 {
 	unsigned long flags;
@@ -416,14 +483,15 @@ static void mcam_ctlr_stop_dma(struct mcam_camera *cam)
 	 * interrupt, then wait until no DMA is active.
 	 */
 	spin_lock_irqsave(&cam->dev_lock, flags);
+	clear_bit(CF_SG_RESTART, &cam->flags);
 	mcam_ctlr_stop(cam);
+	cam->state = S_IDLE;
 	spin_unlock_irqrestore(&cam->dev_lock, flags);
-	msleep(10);
+	msleep(40);
 	if (test_bit(CF_DMA_ACTIVE, &cam->flags))
 		cam_err(cam, "Timeout waiting for DMA to end\n");
 		/* This would be bad news - what now? */
 	spin_lock_irqsave(&cam->dev_lock, flags);
-	cam->state = S_IDLE;
 	mcam_ctlr_irq_disable(cam);
 	spin_unlock_irqrestore(&cam->dev_lock, flags);
 }
@@ -540,9 +608,8 @@ static int mcam_cam_configure(struct mcam_camera *cam)
  * DMA buffer management.  These functions need s_mutex held.
  */
 
-/* FIXME: this is inefficient as hell, since dma_alloc_coherent just
- * does a get_free_pages() call, and we waste a good chunk of an orderN
- * allocation.  Should try to allocate the whole set in one chunk.
+/*
+ * Allocate in-kernel DMA buffers for vmalloc mode.
  */
 static int mcam_alloc_dma_bufs(struct mcam_camera *cam, int loadtime)
 {
@@ -650,24 +717,56 @@ static int mcam_vb_queue_setup(struct vb2_queue *vq, unsigned int *nbufs,
 		void *alloc_ctxs[])
 {
 	struct mcam_camera *cam = vb2_get_drv_priv(vq);
+	int minbufs = (cam->buffer_mode == B_DMA_contig) ? 3 : 2;
 
 	sizes[0] = cam->pix_format.sizeimage;
 	*num_planes = 1; /* Someday we have to support planar formats... */
-	if (*nbufs < 3 || *nbufs > 32)
-		*nbufs = 3;  /* semi-arbitrary numbers */
+	if (*nbufs < minbufs)
+		*nbufs = minbufs;
 	if (cam->buffer_mode == B_DMA_contig)
 		alloc_ctxs[0] = cam->vb_alloc_ctx;
 	return 0;
 }
 
-static int mcam_vb_buf_init(struct vb2_buffer *vb)
+/* DMA_sg only */
+static int mcam_vb_sg_buf_init(struct vb2_buffer *vb)
+{
+	struct mcam_vb_buffer *mvb = vb_to_mvb(vb);
+	struct mcam_camera *cam = vb2_get_drv_priv(vb->vb2_queue);
+	int ndesc = cam->pix_format.sizeimage/PAGE_SIZE + 1;
+
+	mvb->dma_desc = dma_alloc_coherent(cam->dev,
+			ndesc * sizeof(struct mcam_dma_desc),
+			&mvb->dma_desc_pa, GFP_KERNEL);
+	if (mvb->dma_desc == NULL) {
+		cam_err(cam, "Unable to get DMA descriptor array\n");
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+static int mcam_vb_sg_buf_prepare(struct vb2_buffer *vb)
 {
 	struct mcam_vb_buffer *mvb = vb_to_mvb(vb);
+	struct mcam_camera *cam = vb2_get_drv_priv(vb->vb2_queue);
+	struct vb2_dma_sg_desc *sgd = vb2_dma_sg_plane_desc(vb, 0);
+	struct mcam_dma_desc *desc = mvb->dma_desc;
+	struct scatterlist *sg;
+	int i;
 
-	INIT_LIST_HEAD(&mvb->queue);
+	mvb->dma_desc_nent = dma_map_sg(cam->dev, sgd->sglist, sgd->num_pages,
+			DMA_FROM_DEVICE);
+	if (mvb->dma_desc_nent <= 0)
+		return -EIO;  /* Not sure what's right here */
+	for_each_sg(sgd->sglist, sg, mvb->dma_desc_nent, i) {
+		desc->dma_addr = sg_dma_address(sg);
+		desc->segment_len = sg_dma_len(sg);
+		desc++;
+	}
 	return 0;
 }
 
+
 static void mcam_vb_buf_queue(struct vb2_buffer *vb)
 {
 	struct mcam_vb_buffer *mvb = vb_to_mvb(vb);
@@ -678,11 +777,34 @@ static void mcam_vb_buf_queue(struct vb2_buffer *vb)
 	spin_lock_irqsave(&cam->dev_lock, flags);
 	start = (cam->state == S_BUFWAIT) && !list_empty(&cam->buffers);
 	list_add(&mvb->queue, &cam->buffers);
+	if (test_bit(CF_SG_RESTART, &cam->flags))
+		mcam_sg_restart(cam);
 	spin_unlock_irqrestore(&cam->dev_lock, flags);
 	if (start)
 		mcam_read_setup(cam);
 }
 
+
+static int mcam_vb_sg_buf_finish(struct vb2_buffer *vb)
+{
+	struct mcam_camera *cam = vb2_get_drv_priv(vb->vb2_queue);
+	struct vb2_dma_sg_desc *sgd = vb2_dma_sg_plane_desc(vb, 0);
+
+	dma_unmap_sg(cam->dev, sgd->sglist, sgd->num_pages, DMA_FROM_DEVICE);
+	return 0;
+}
+
+static void mcam_vb_sg_buf_cleanup(struct vb2_buffer *vb)
+{
+	struct mcam_camera *cam = vb2_get_drv_priv(vb->vb2_queue);
+	struct mcam_vb_buffer *mvb = vb_to_mvb(vb);
+	int ndesc = cam->pix_format.sizeimage/PAGE_SIZE + 1;
+
+	dma_free_coherent(cam->dev, ndesc * sizeof(struct mcam_dma_desc),
+			mvb->dma_desc, mvb->dma_desc_pa);
+}
+
+
 /*
  * vb2 uses these to release the mutex when waiting in dqbuf.  I'm
  * not actually sure we need to do this (I'm not sure that vb2_dqbuf() needs
@@ -752,7 +874,6 @@ static int mcam_vb_stop_streaming(struct vb2_queue *vq)
 
 static const struct vb2_ops mcam_vb2_ops = {
 	.queue_setup		= mcam_vb_queue_setup,
-	.buf_init		= mcam_vb_buf_init,
 	.buf_queue		= mcam_vb_buf_queue,
 	.start_streaming	= mcam_vb_start_streaming,
 	.stop_streaming		= mcam_vb_stop_streaming,
@@ -760,22 +881,49 @@ static const struct vb2_ops mcam_vb2_ops = {
 	.wait_finish		= mcam_vb_wait_finish,
 };
 
+/*
+ * Scatter/gather mode complicates things somewhat.
+ */
+static const struct vb2_ops mcam_vb2_sg_ops = {
+	.queue_setup		= mcam_vb_queue_setup,
+	.buf_init		= mcam_vb_sg_buf_init,
+	.buf_prepare		= mcam_vb_sg_buf_prepare,
+	.buf_queue		= mcam_vb_buf_queue,
+	.buf_finish		= mcam_vb_sg_buf_finish,
+	.buf_cleanup		= mcam_vb_sg_buf_cleanup,
+	.start_streaming	= mcam_vb_start_streaming,
+	.stop_streaming		= mcam_vb_stop_streaming,
+	.wait_prepare		= mcam_vb_wait_prepare,
+	.wait_finish		= mcam_vb_wait_finish,
+};
+
 static int mcam_setup_vb2(struct mcam_camera *cam)
 {
 	struct vb2_queue *vq = &cam->vb_queue;
 
 	memset(vq, 0, sizeof(*vq));
 	vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	vq->io_modes = VB2_MMAP;  /* Add userptr */
 	vq->drv_priv = cam;
-	vq->ops = &mcam_vb2_ops;
-	if (cam->buffer_mode == B_DMA_contig) {
+	INIT_LIST_HEAD(&cam->buffers);
+	switch (cam->buffer_mode) {
+	case B_DMA_contig:
+		vq->ops = &mcam_vb2_ops;
 		vq->mem_ops = &vb2_dma_contig_memops;
 		cam->vb_alloc_ctx = vb2_dma_contig_init_ctx(cam->dev);
-	} else
+		vq->io_modes = VB2_MMAP | VB2_USERPTR;
+		break;
+	case B_DMA_sg:
+		vq->ops = &mcam_vb2_sg_ops;
+		vq->mem_ops = &vb2_dma_sg_memops;
+		vq->io_modes = VB2_MMAP | VB2_USERPTR;
+		break;
+	case B_vmalloc:
+		vq->ops = &mcam_vb2_ops;
 		vq->mem_ops = &vb2_vmalloc_memops;
-	vq->buf_struct_size = sizeof(struct mcam_vb_buffer);
-
+		vq->buf_struct_size = sizeof(struct mcam_vb_buffer);
+		vq->io_modes = VB2_MMAP;
+		break;
+	}
 	return vb2_queue_init(vq);
 }
 
@@ -1313,8 +1461,6 @@ static void mcam_buffer_done(struct mcam_camera *cam, int frame,
 {
 	vbuf->v4l2_buf.bytesused = cam->pix_format.sizeimage;
 	vbuf->v4l2_buf.sequence = cam->buf_seq[frame];
-	vbuf->v4l2_buf.flags &= ~V4L2_BUF_FLAG_QUEUED;
-	vbuf->v4l2_buf.flags |= V4L2_BUF_FLAG_DONE;
 	vb2_set_plane_payload(vbuf, 0, cam->pix_format.sizeimage);
 	vb2_buffer_done(vbuf, VB2_BUF_STATE_DONE);
 }
@@ -1363,7 +1509,7 @@ static void mcam_frame_tasklet(unsigned long data)
 /*
  * For direct DMA, mark the buffer ready and set up another one.
  */
-static void mcam_dma_complete(struct mcam_camera *cam, int frame)
+static void mcam_dma_contig_done(struct mcam_camera *cam, int frame)
 {
 	struct mcam_vb_buffer *buf = cam->vb_bufs[frame];
 
@@ -1374,6 +1520,52 @@ static void mcam_dma_complete(struct mcam_camera *cam, int frame)
 	mcam_set_contig_buffer(cam, frame);
 }
 
+/*
+ * Frame completion with S/G is trickier.  We can't muck with
+ * a descriptor chain on the fly, since the controller buffers it
+ * internally.  So we have to actually stop and restart; Marvell
+ * says this is the way to do it.
+ *
+ * Of course, stopping is easier said than done; experience shows
+ * that the controller can start a frame *after* C0_ENABLE has been
+ * cleared.  So when running in S/G mode, the controller is "stopped"
+ * on receipt of the start-of-frame interrupt.  That means we can
+ * safely change the DMA descriptor array here and restart things
+ * (assuming there's another buffer waiting to go).
+ */
+static void mcam_dma_sg_done(struct mcam_camera *cam, int frame)
+{
+	struct mcam_vb_buffer *buf = cam->vb_bufs[0];
+
+	/*
+	 * Very Bad Not Good Things happen if you don't clear
+	 * C1_DESC_ENA before making any descriptor changes.
+	 */
+	mcam_reg_clear_bit(cam, REG_CTRL1, C1_DESC_ENA);
+	/*
+	 * If we have another buffer available, put it in and
+	 * restart the engine.
+	 */
+	if (!list_empty(&cam->buffers)) {
+		mcam_sg_next_buffer(cam);
+		mcam_reg_set_bit(cam, REG_CTRL1, C1_DESC_ENA);
+		mcam_ctlr_start(cam);
+	/*
+	 * Otherwise set CF_SG_RESTART and the controller will
+	 * be restarted once another buffer shows up.
+	 */
+	} else {
+		set_bit(CF_SG_RESTART, &cam->flags);
+		singles++;
+	}
+	/*
+	 * Now we can give the completed frame back to user space.
+	 */
+	delivered++;
+	mcam_buffer_done(cam, frame, &buf->vb_buf);
+}
+
+
 
 static void mcam_frame_complete(struct mcam_camera *cam, int frame)
 {
@@ -1385,22 +1577,25 @@ static void mcam_frame_complete(struct mcam_camera *cam, int frame)
 	cam->next_buf = frame;
 	cam->buf_seq[frame] = ++(cam->sequence);
 	cam->last_delivered = frame;
-
 	frames++;
-	switch (cam->state) {
 	/*
-	 * We're streaming and have a ready frame, hand it back
+	 * "This should never happen"
 	 */
-	case S_STREAMING:
-		if (cam->buffer_mode == B_vmalloc)
-			tasklet_schedule(&cam->s_tasklet);
-		else
-			mcam_dma_complete(cam, frame);
-		break;
-
-	default:
-		cam_err(cam, "Frame interrupt in non-operational state\n");
-		break;
+	if (cam->state != S_STREAMING)
+		return;
+	/*
+	 * Process the frame and set up the next one.
+	 */
+	switch (cam->buffer_mode) {
+	case B_vmalloc:
+	    tasklet_schedule(&cam->s_tasklet);
+	    break;
+	case B_DMA_contig:
+	    mcam_dma_contig_done(cam, frame);
+	    break;
+	case B_DMA_sg:
+	    mcam_dma_sg_done(cam, frame);
+	    break;
 	}
 }
 
@@ -1416,6 +1611,11 @@ int mccic_irq(struct mcam_camera *cam, unsigned int irqs)
 	 * Handle any frame completions.  There really should
 	 * not be more than one of these, or we have fallen
 	 * far behind.
+	 *
+	 * When running in S/G mode, the frame number lacks any
+	 * real meaning - there's only one descriptor array - but
+	 * the controller still picks a different one to signal
+	 * each time.
 	 */
 	for (frame = 0; frame < cam->nbufs; frame++)
 		if (irqs & (IRQ_EOF0 << frame)) {
@@ -1430,6 +1630,8 @@ int mccic_irq(struct mcam_camera *cam, unsigned int irqs)
 	if (irqs & (IRQ_SOF0 | IRQ_SOF1 | IRQ_SOF2)) {
 		set_bit(CF_DMA_ACTIVE, &cam->flags);
 		handled = 1;
+		if (cam->buffer_mode == B_DMA_sg)
+			mcam_ctlr_stop(cam);
 	}
 	return handled;
 }
@@ -1480,8 +1682,15 @@ int mccic_register(struct mcam_camera *cam)
 		cam->buffer_mode = B_vmalloc;
 	else if (buffer_mode == 1)
 		cam->buffer_mode = B_DMA_contig;
-	else if (buffer_mode != -1)
-		printk(KERN_ERR "marvel-cam: "
+	else if (buffer_mode == 2) {
+		if (cam->chip_id == V4L2_IDENT_ARMADA610)
+			cam->buffer_mode = B_DMA_sg;
+		else {
+			printk(KERN_ERR "marvell-cam: Cafe can't do S/G I/O\n");
+			cam->buffer_mode = B_vmalloc;
+		}
+	} else if (buffer_mode != -1)
+		printk(KERN_ERR "marvell-cam: "
 				"Strange module buffer mode %d - ignoring\n",
 				buffer_mode);
 	mcam_ctlr_init(cam);
diff --git a/drivers/media/video/marvell-ccic/mcam-core.h b/drivers/media/video/marvell-ccic/mcam-core.h
index 2e667a0..55fd078 100644
--- a/drivers/media/video/marvell-ccic/mcam-core.h
+++ b/drivers/media/video/marvell-ccic/mcam-core.h
@@ -38,7 +38,8 @@ enum mcam_state {
  */
 enum mcam_buffer_mode {
 	B_vmalloc = 0,
-	B_DMA_contig
+	B_DMA_contig,
+	B_DMA_sg
 };
 
 /*
@@ -250,8 +251,11 @@ int mccic_resume(struct mcam_camera *cam);
 #define	  C0_SIF_HVSYNC	  0x00000000	/* Use H/VSYNC */
 #define	  CO_SOF_NOSYNC	  0x40000000	/* Use inband active signaling */
 
-
+/* Bits below C1_444ALPHA are not present in Cafe */
 #define REG_CTRL1	0x40	/* Control 1 */
+#define	  C1_CLKGATE	  0x00000001	/* Sensor clock gate */
+#define   C1_DESC_ENA	  0x00000100	/* DMA descriptor enable */
+#define   C1_DESC_3WORD   0x00000200	/* Three-word descriptors used */
 #define	  C1_444ALPHA	  0x00f00000	/* Alpha field in RGB444 */
 #define	  C1_ALPHA_SHFT	  20
 #define	  C1_DMAB32	  0x00000000	/* 32-byte DMA burst */
@@ -267,6 +271,14 @@ int mccic_resume(struct mcam_camera *cam);
 /* This appears to be a Cafe-only register */
 #define REG_UBAR	0xc4	/* Upper base address register */
 
+/* Armada 610 DMA descriptor registers */
+#define	REG_DMA_DESC_Y	0x200
+#define	REG_DMA_DESC_U	0x204
+#define	REG_DMA_DESC_V	0x208
+#define REG_DESC_LEN_Y	0x20c	/* Lengths are in bytes */
+#define	REG_DESC_LEN_U	0x210
+#define REG_DESC_LEN_V	0x214
+
 /*
  * Useful stuff that probably belongs somewhere global.
  */
-- 
1.7.5.4

