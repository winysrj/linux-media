Return-path: <mchehab@localhost>
Received: from tex.lwn.net ([70.33.254.29]:36252 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753049Ab1GHUwI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Jul 2011 16:52:08 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Kassey Lee <ygli@marvell.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 2/6] marvell-cam: core code reorganization
Date: Fri,  8 Jul 2011 14:50:46 -0600
Message-Id: <1310158250-168899-3-git-send-email-corbet@lwn.net>
In-Reply-To: <1310158250-168899-1-git-send-email-corbet@lwn.net>
References: <1310158250-168899-1-git-send-email-corbet@lwn.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

This code shows signs of having been mucked with over the last five years
or so; things were kind of mixed up.  This patch reorders functions into a
more rational organization which, with luck, will facilitate making the
buffer modes selectable at configuration time.  Code movement only: no
functional changes here.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/media/video/marvell-ccic/mcam-core.c |  914 +++++++++++++-------------
 1 files changed, 465 insertions(+), 449 deletions(-)

diff --git a/drivers/media/video/marvell-ccic/mcam-core.c b/drivers/media/video/marvell-ccic/mcam-core.c
index af5faa6..8a99ec2 100644
--- a/drivers/media/video/marvell-ccic/mcam-core.c
+++ b/drivers/media/video/marvell-ccic/mcam-core.c
@@ -157,29 +157,20 @@ static struct mcam_format_struct *mcam_find_format(u32 pixelformat)
 }
 
 /*
- * Start over with DMA buffers - dev_lock needed.
+ * The default format we use until somebody says otherwise.
  */
-static void mcam_reset_buffers(struct mcam_camera *cam)
-{
-	int i;
-
-	cam->next_buf = -1;
-	for (i = 0; i < cam->nbufs; i++)
-		clear_bit(i, &cam->flags);
-}
+static const struct v4l2_pix_format mcam_def_pix_format = {
+	.width		= VGA_WIDTH,
+	.height		= VGA_HEIGHT,
+	.pixelformat	= V4L2_PIX_FMT_YUYV,
+	.field		= V4L2_FIELD_NONE,
+	.bytesperline	= VGA_WIDTH*2,
+	.sizeimage	= VGA_WIDTH*VGA_HEIGHT*2,
+};
 
-static inline int mcam_needs_config(struct mcam_camera *cam)
-{
-	return test_bit(CF_CONFIG_NEEDED, &cam->flags);
-}
+static const enum v4l2_mbus_pixelcode mcam_def_mbus_code =
+					V4L2_MBUS_FMT_YUYV8_2X8;
 
-static void mcam_set_config_needed(struct mcam_camera *cam, int needed)
-{
-	if (needed)
-		set_bit(CF_CONFIG_NEEDED, &cam->flags);
-	else
-		clear_bit(CF_CONFIG_NEEDED, &cam->flags);
-}
 
 /*
  * The two-word DMA descriptor format used by the Armada 610 and like.  There
@@ -210,6 +201,19 @@ static inline struct mcam_vb_buffer *vb_to_mvb(struct vb2_buffer *vb)
 	return container_of(vb, struct mcam_vb_buffer, vb_buf);
 }
 
+/*
+ * Hand a completed buffer back to user space.
+ */
+static void mcam_buffer_done(struct mcam_camera *cam, int frame,
+		struct vb2_buffer *vbuf)
+{
+	vbuf->v4l2_buf.bytesused = cam->pix_format.sizeimage;
+	vbuf->v4l2_buf.sequence = cam->buf_seq[frame];
+	vb2_set_plane_payload(vbuf, 0, cam->pix_format.sizeimage);
+	vb2_buffer_done(vbuf, VB2_BUF_STATE_DONE);
+}
+
+
 
 /*
  * Debugging and related.
@@ -222,11 +226,109 @@ static inline struct mcam_vb_buffer *vb_to_mvb(struct vb2_buffer *vb)
 	dev_dbg((cam)->dev, fmt, ##arg);
 
 
+/*
+ * Flag manipulation helpers
+ */
+static void mcam_reset_buffers(struct mcam_camera *cam)
+{
+	int i;
+
+	cam->next_buf = -1;
+	for (i = 0; i < cam->nbufs; i++)
+		clear_bit(i, &cam->flags);
+}
+
+static inline int mcam_needs_config(struct mcam_camera *cam)
+{
+	return test_bit(CF_CONFIG_NEEDED, &cam->flags);
+}
+
+static void mcam_set_config_needed(struct mcam_camera *cam, int needed)
+{
+	if (needed)
+		set_bit(CF_CONFIG_NEEDED, &cam->flags);
+	else
+		clear_bit(CF_CONFIG_NEEDED, &cam->flags);
+}
 
 /* ------------------------------------------------------------------- */
 /*
- * Deal with the controller.
+ * Make the controller start grabbing images.  Everything must
+ * be set up before doing this.
  */
+static void mcam_ctlr_start(struct mcam_camera *cam)
+{
+	/* set_bit performs a read, so no other barrier should be
+	   needed here */
+	mcam_reg_set_bit(cam, REG_CTRL0, C0_ENABLE);
+}
+
+static void mcam_ctlr_stop(struct mcam_camera *cam)
+{
+	mcam_reg_clear_bit(cam, REG_CTRL0, C0_ENABLE);
+}
+
+/* ------------------------------------------------------------------- */
+/*
+ * Code specific to the vmalloc buffer mode.
+ */
+
+/*
+ * Allocate in-kernel DMA buffers for vmalloc mode.
+ */
+static int mcam_alloc_dma_bufs(struct mcam_camera *cam, int loadtime)
+{
+	int i;
+
+	mcam_set_config_needed(cam, 1);
+	if (loadtime)
+		cam->dma_buf_size = dma_buf_size;
+	else
+		cam->dma_buf_size = cam->pix_format.sizeimage;
+	if (n_dma_bufs > 3)
+		n_dma_bufs = 3;
+
+	cam->nbufs = 0;
+	for (i = 0; i < n_dma_bufs; i++) {
+		cam->dma_bufs[i] = dma_alloc_coherent(cam->dev,
+				cam->dma_buf_size, cam->dma_handles + i,
+				GFP_KERNEL);
+		if (cam->dma_bufs[i] == NULL) {
+			cam_warn(cam, "Failed to allocate DMA buffer\n");
+			break;
+		}
+		(cam->nbufs)++;
+	}
+
+	switch (cam->nbufs) {
+	case 1:
+		dma_free_coherent(cam->dev, cam->dma_buf_size,
+				cam->dma_bufs[0], cam->dma_handles[0]);
+		cam->nbufs = 0;
+	case 0:
+		cam_err(cam, "Insufficient DMA buffers, cannot operate\n");
+		return -ENOMEM;
+
+	case 2:
+		if (n_dma_bufs > 2)
+			cam_warn(cam, "Will limp along with only 2 buffers\n");
+		break;
+	}
+	return 0;
+}
+
+static void mcam_free_dma_bufs(struct mcam_camera *cam)
+{
+	int i;
+
+	for (i = 0; i < cam->nbufs; i++) {
+		dma_free_coherent(cam->dev, cam->dma_buf_size,
+				cam->dma_bufs[i], cam->dma_handles[i]);
+		cam->dma_bufs[i] = NULL;
+	}
+	cam->nbufs = 0;
+}
+
 
 /*
  * Set up DMA buffers when operating in vmalloc mode
@@ -251,6 +353,52 @@ static void mcam_ctlr_dma_vmalloc(struct mcam_camera *cam)
 }
 
 /*
+ * Copy data out to user space in the vmalloc case
+ */
+static void mcam_frame_tasklet(unsigned long data)
+{
+	struct mcam_camera *cam = (struct mcam_camera *) data;
+	int i;
+	unsigned long flags;
+	struct mcam_vb_buffer *buf;
+
+	spin_lock_irqsave(&cam->dev_lock, flags);
+	for (i = 0; i < cam->nbufs; i++) {
+		int bufno = cam->next_buf;
+
+		if (cam->state != S_STREAMING || bufno < 0)
+			break;  /* I/O got stopped */
+		if (++(cam->next_buf) >= cam->nbufs)
+			cam->next_buf = 0;
+		if (!test_bit(bufno, &cam->flags))
+			continue;
+		if (list_empty(&cam->buffers)) {
+			singles++;
+			break;  /* Leave it valid, hope for better later */
+		}
+		delivered++;
+		clear_bit(bufno, &cam->flags);
+		buf = list_first_entry(&cam->buffers, struct mcam_vb_buffer,
+				queue);
+		list_del_init(&buf->queue);
+		/*
+		 * Drop the lock during the big copy.  This *should* be safe...
+		 */
+		spin_unlock_irqrestore(&cam->dev_lock, flags);
+		memcpy(vb2_plane_vaddr(&buf->vb_buf, 0), cam->dma_bufs[bufno],
+				cam->pix_format.sizeimage);
+		mcam_buffer_done(cam, bufno, &buf->vb_buf);
+		spin_lock_irqsave(&cam->dev_lock, flags);
+	}
+	spin_unlock_irqrestore(&cam->dev_lock, flags);
+}
+
+
+/* ---------------------------------------------------------------------- */
+/*
+ * DMA-contiguous code.
+ */
+/*
  * Set up a contiguous buffer for the given frame.  Here also is where
  * the underrun strategy is set: if there is no buffer available, reuse
  * the buffer from the other BAR and set the CF_SINGLE_BUFFER flag to
@@ -295,6 +443,26 @@ static void mcam_ctlr_dma_contig(struct mcam_camera *cam)
 	mcam_set_contig_buffer(cam, 1);
 }
 
+/*
+ * Frame completion handling.
+ */
+static void mcam_dma_contig_done(struct mcam_camera *cam, int frame)
+{
+	struct mcam_vb_buffer *buf = cam->vb_bufs[frame];
+
+	if (!test_bit(CF_SINGLE_BUFFER, &cam->flags)) {
+		delivered++;
+		mcam_buffer_done(cam, frame, &buf->vb_buf);
+	}
+	mcam_set_contig_buffer(cam, frame);
+}
+
+
+
+/* ---------------------------------------------------------------------- */
+/*
+ * Scatter/gather-specific code.
+ */
 
 /*
  * Set up the next buffer for S/G I/O; caller should be sure that
@@ -325,8 +493,74 @@ static void mcam_ctlr_dma_sg(struct mcam_camera *cam)
 	cam->nbufs = 3;
 }
 
+
 /*
- * Image format setup, independent of DMA scheme.
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
+
+/* ---------------------------------------------------------------------- */
+/*
+ * Buffer-mode-independent controller code.
+ */
+
+/*
+ * Image format setup
  */
 static void mcam_ctlr_image(struct mcam_camera *cam)
 {
@@ -417,34 +651,7 @@ static void mcam_ctlr_irq_disable(struct mcam_camera *cam)
 	mcam_reg_clear_bit(cam, REG_IRQMASK, FRAMEIRQS);
 }
 
-/*
- * Make the controller start grabbing images.  Everything must
- * be set up before doing this.
- */
-static void mcam_ctlr_start(struct mcam_camera *cam)
-{
-	/* set_bit performs a read, so no other barrier should be
-	   needed here */
-	mcam_reg_set_bit(cam, REG_CTRL0, C0_ENABLE);
-}
 
-static void mcam_ctlr_stop(struct mcam_camera *cam)
-{
-	mcam_reg_clear_bit(cam, REG_CTRL0, C0_ENABLE);
-}
-
-/*
- * Scatter/gather mode requires stopping the controller between
- * frames so we can put in a new DMA descriptor array.  If no new
- * buffer exists at frame completion, the controller is left stopped;
- * this function is charged with gettig things going again.
- */
-static void mcam_sg_restart(struct mcam_camera *cam)
-{
-	mcam_ctlr_dma_sg(cam);
-	mcam_ctlr_start(cam);
-	clear_bit(CF_SG_RESTART, &cam->flags);
-}
 
 static void mcam_ctlr_init(struct mcam_camera *cam)
 {
@@ -564,113 +771,44 @@ static int mcam_cam_init(struct mcam_camera *cam)
 		goto out;
 	}
 /* Get/set parameters? */
-	ret = 0;
-	cam->state = S_IDLE;
-out:
-	mcam_ctlr_power_down(cam);
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-/*
- * Configure the sensor to match the parameters we have.  Caller should
- * hold s_mutex
- */
-static int mcam_cam_set_flip(struct mcam_camera *cam)
-{
-	struct v4l2_control ctrl;
-
-	memset(&ctrl, 0, sizeof(ctrl));
-	ctrl.id = V4L2_CID_VFLIP;
-	ctrl.value = flip;
-	return sensor_call(cam, core, s_ctrl, &ctrl);
-}
-
-
-static int mcam_cam_configure(struct mcam_camera *cam)
-{
-	struct v4l2_mbus_framefmt mbus_fmt;
-	int ret;
-
-	v4l2_fill_mbus_format(&mbus_fmt, &cam->pix_format, cam->mbus_code);
-	ret = sensor_call(cam, core, init, 0);
-	if (ret == 0)
-		ret = sensor_call(cam, video, s_mbus_fmt, &mbus_fmt);
-	/*
-	 * OV7670 does weird things if flip is set *before* format...
-	 */
-	ret += mcam_cam_set_flip(cam);
-	return ret;
-}
-
-/* -------------------------------------------------------------------- */
-/*
- * DMA buffer management.  These functions need s_mutex held.
- */
-
-/*
- * Allocate in-kernel DMA buffers for vmalloc mode.
- */
-static int mcam_alloc_dma_bufs(struct mcam_camera *cam, int loadtime)
-{
-	int i;
-
-	mcam_set_config_needed(cam, 1);
-	if (loadtime)
-		cam->dma_buf_size = dma_buf_size;
-	else
-		cam->dma_buf_size = cam->pix_format.sizeimage;
-	if (n_dma_bufs > 3)
-		n_dma_bufs = 3;
-
-	cam->nbufs = 0;
-	for (i = 0; i < n_dma_bufs; i++) {
-		cam->dma_bufs[i] = dma_alloc_coherent(cam->dev,
-				cam->dma_buf_size, cam->dma_handles + i,
-				GFP_KERNEL);
-		if (cam->dma_bufs[i] == NULL) {
-			cam_warn(cam, "Failed to allocate DMA buffer\n");
-			break;
-		}
-		(cam->nbufs)++;
-	}
-
-	switch (cam->nbufs) {
-	case 1:
-		dma_free_coherent(cam->dev, cam->dma_buf_size,
-				cam->dma_bufs[0], cam->dma_handles[0]);
-		cam->nbufs = 0;
-	case 0:
-		cam_err(cam, "Insufficient DMA buffers, cannot operate\n");
-		return -ENOMEM;
-
-	case 2:
-		if (n_dma_bufs > 2)
-			cam_warn(cam, "Will limp along with only 2 buffers\n");
-		break;
-	}
-	return 0;
+	ret = 0;
+	cam->state = S_IDLE;
+out:
+	mcam_ctlr_power_down(cam);
+	mutex_unlock(&cam->s_mutex);
+	return ret;
 }
 
-static void mcam_free_dma_bufs(struct mcam_camera *cam)
+/*
+ * Configure the sensor to match the parameters we have.  Caller should
+ * hold s_mutex
+ */
+static int mcam_cam_set_flip(struct mcam_camera *cam)
 {
-	int i;
+	struct v4l2_control ctrl;
 
-	for (i = 0; i < cam->nbufs; i++) {
-		dma_free_coherent(cam->dev, cam->dma_buf_size,
-				cam->dma_bufs[i], cam->dma_handles[i]);
-		cam->dma_bufs[i] = NULL;
-	}
-	cam->nbufs = 0;
+	memset(&ctrl, 0, sizeof(ctrl));
+	ctrl.id = V4L2_CID_VFLIP;
+	ctrl.value = flip;
+	return sensor_call(cam, core, s_ctrl, &ctrl);
 }
 
 
+static int mcam_cam_configure(struct mcam_camera *cam)
+{
+	struct v4l2_mbus_framefmt mbus_fmt;
+	int ret;
 
-/* ----------------------------------------------------------------------- */
-/*
- * Here starts the V4L2 interface code.
- */
-
+	v4l2_fill_mbus_format(&mbus_fmt, &cam->pix_format, cam->mbus_code);
+	ret = sensor_call(cam, core, init, 0);
+	if (ret == 0)
+		ret = sensor_call(cam, video, s_mbus_fmt, &mbus_fmt);
+	/*
+	 * OV7670 does weird things if flip is set *before* format...
+	 */
+	ret += mcam_cam_set_flip(cam);
+	return ret;
+}
 
 /*
  * Get everything ready, and start grabbing frames.
@@ -728,44 +866,6 @@ static int mcam_vb_queue_setup(struct vb2_queue *vq, unsigned int *nbufs,
 	return 0;
 }
 
-/* DMA_sg only */
-static int mcam_vb_sg_buf_init(struct vb2_buffer *vb)
-{
-	struct mcam_vb_buffer *mvb = vb_to_mvb(vb);
-	struct mcam_camera *cam = vb2_get_drv_priv(vb->vb2_queue);
-	int ndesc = cam->pix_format.sizeimage/PAGE_SIZE + 1;
-
-	mvb->dma_desc = dma_alloc_coherent(cam->dev,
-			ndesc * sizeof(struct mcam_dma_desc),
-			&mvb->dma_desc_pa, GFP_KERNEL);
-	if (mvb->dma_desc == NULL) {
-		cam_err(cam, "Unable to get DMA descriptor array\n");
-		return -ENOMEM;
-	}
-	return 0;
-}
-
-static int mcam_vb_sg_buf_prepare(struct vb2_buffer *vb)
-{
-	struct mcam_vb_buffer *mvb = vb_to_mvb(vb);
-	struct mcam_camera *cam = vb2_get_drv_priv(vb->vb2_queue);
-	struct vb2_dma_sg_desc *sgd = vb2_dma_sg_plane_desc(vb, 0);
-	struct mcam_dma_desc *desc = mvb->dma_desc;
-	struct scatterlist *sg;
-	int i;
-
-	mvb->dma_desc_nent = dma_map_sg(cam->dev, sgd->sglist, sgd->num_pages,
-			DMA_FROM_DEVICE);
-	if (mvb->dma_desc_nent <= 0)
-		return -EIO;  /* Not sure what's right here */
-	for_each_sg(sgd->sglist, sg, mvb->dma_desc_nent, i) {
-		desc->dma_addr = sg_dma_address(sg);
-		desc->segment_len = sg_dma_len(sg);
-		desc++;
-	}
-	return 0;
-}
-
 
 static void mcam_vb_buf_queue(struct vb2_buffer *vb)
 {
@@ -785,26 +885,6 @@ static void mcam_vb_buf_queue(struct vb2_buffer *vb)
 }
 
 
-static int mcam_vb_sg_buf_finish(struct vb2_buffer *vb)
-{
-	struct mcam_camera *cam = vb2_get_drv_priv(vb->vb2_queue);
-	struct vb2_dma_sg_desc *sgd = vb2_dma_sg_plane_desc(vb, 0);
-
-	dma_unmap_sg(cam->dev, sgd->sglist, sgd->num_pages, DMA_FROM_DEVICE);
-	return 0;
-}
-
-static void mcam_vb_sg_buf_cleanup(struct vb2_buffer *vb)
-{
-	struct mcam_camera *cam = vb2_get_drv_priv(vb->vb2_queue);
-	struct mcam_vb_buffer *mvb = vb_to_mvb(vb);
-	int ndesc = cam->pix_format.sizeimage/PAGE_SIZE + 1;
-
-	dma_free_coherent(cam->dev, ndesc * sizeof(struct mcam_dma_desc),
-			mvb->dma_desc, mvb->dma_desc_pa);
-}
-
-
 /*
  * vb2 uses these to release the mutex when waiting in dqbuf.  I'm
  * not actually sure we need to do this (I'm not sure that vb2_dqbuf() needs
@@ -882,8 +962,66 @@ static const struct vb2_ops mcam_vb2_ops = {
 };
 
 /*
- * Scatter/gather mode complicates things somewhat.
+ * Scatter/gather mode uses all of the above functions plus a
+ * few extras to deal with DMA mapping.
  */
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
+{
+	struct mcam_vb_buffer *mvb = vb_to_mvb(vb);
+	struct mcam_camera *cam = vb2_get_drv_priv(vb->vb2_queue);
+	struct vb2_dma_sg_desc *sgd = vb2_dma_sg_plane_desc(vb, 0);
+	struct mcam_dma_desc *desc = mvb->dma_desc;
+	struct scatterlist *sg;
+	int i;
+
+	mvb->dma_desc_nent = dma_map_sg(cam->dev, sgd->sglist, sgd->num_pages,
+			DMA_FROM_DEVICE);
+	if (mvb->dma_desc_nent <= 0)
+		return -EIO;  /* Not sure what's right here */
+	for_each_sg(sgd->sglist, sg, mvb->dma_desc_nent, i) {
+		desc->dma_addr = sg_dma_address(sg);
+		desc->segment_len = sg_dma_len(sg);
+		desc++;
+	}
+	return 0;
+}
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
 static const struct vb2_ops mcam_vb2_sg_ops = {
 	.queue_setup		= mcam_vb_queue_setup,
 	.buf_init		= mcam_vb_sg_buf_init,
@@ -934,23 +1072,10 @@ static void mcam_cleanup_vb2(struct mcam_camera *cam)
 		vb2_dma_contig_cleanup_ctx(cam->vb_alloc_ctx);
 }
 
-static ssize_t mcam_v4l_read(struct file *filp,
-		char __user *buffer, size_t len, loff_t *pos)
-{
-	struct mcam_camera *cam = filp->private_data;
-	int ret;
-
-	mutex_lock(&cam->s_mutex);
-	ret = vb2_read(&cam->vb_queue, buffer, len, pos,
-			filp->f_flags & O_NONBLOCK);
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-
 
+/* ---------------------------------------------------------------------- */
 /*
- * Streaming I/O support.
+ * The long list of V4L2 ioctl() operations.
  */
 
 static int mcam_vidioc_streamon(struct file *filp, void *priv,
@@ -999,105 +1124,31 @@ static int mcam_vidioc_querybuf(struct file *filp, void *priv,
 	int ret;
 
 	mutex_lock(&cam->s_mutex);
-	ret = vb2_querybuf(&cam->vb_queue, buf);
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-static int mcam_vidioc_qbuf(struct file *filp, void *priv,
-		struct v4l2_buffer *buf)
-{
-	struct mcam_camera *cam = filp->private_data;
-	int ret;
-
-	mutex_lock(&cam->s_mutex);
-	ret = vb2_qbuf(&cam->vb_queue, buf);
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-static int mcam_vidioc_dqbuf(struct file *filp, void *priv,
-		struct v4l2_buffer *buf)
-{
-	struct mcam_camera *cam = filp->private_data;
-	int ret;
-
-	mutex_lock(&cam->s_mutex);
-	ret = vb2_dqbuf(&cam->vb_queue, buf, filp->f_flags & O_NONBLOCK);
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-
-static int mcam_v4l_mmap(struct file *filp, struct vm_area_struct *vma)
-{
-	struct mcam_camera *cam = filp->private_data;
-	int ret;
-
-	mutex_lock(&cam->s_mutex);
-	ret = vb2_mmap(&cam->vb_queue, vma);
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-
-
-static int mcam_v4l_open(struct file *filp)
-{
-	struct mcam_camera *cam = video_drvdata(filp);
-	int ret = 0;
-
-	filp->private_data = cam;
-
-	frames = singles = delivered = 0;
-	mutex_lock(&cam->s_mutex);
-	if (cam->users == 0) {
-		ret = mcam_setup_vb2(cam);
-		if (ret)
-			goto out;
-		mcam_ctlr_power_up(cam);
-		__mcam_cam_reset(cam);
-		mcam_set_config_needed(cam, 1);
-	}
-	(cam->users)++;
-out:
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-
-static int mcam_v4l_release(struct file *filp)
-{
-	struct mcam_camera *cam = filp->private_data;
-
-	cam_err(cam, "Release, %d frames, %d singles, %d delivered\n", frames,
-			singles, delivered);
-	mutex_lock(&cam->s_mutex);
-	(cam->users)--;
-	if (filp == cam->owner) {
-		mcam_ctlr_stop_dma(cam);
-		cam->owner = NULL;
-	}
-	if (cam->users == 0) {
-		mcam_cleanup_vb2(cam);
-		mcam_ctlr_power_down(cam);
-		if (cam->buffer_mode == B_vmalloc && alloc_bufs_at_read)
-			mcam_free_dma_bufs(cam);
-	}
+	ret = vb2_querybuf(&cam->vb_queue, buf);
 	mutex_unlock(&cam->s_mutex);
-	return 0;
+	return ret;
 }
 
+static int mcam_vidioc_qbuf(struct file *filp, void *priv,
+		struct v4l2_buffer *buf)
+{
+	struct mcam_camera *cam = filp->private_data;
+	int ret;
 
+	mutex_lock(&cam->s_mutex);
+	ret = vb2_qbuf(&cam->vb_queue, buf);
+	mutex_unlock(&cam->s_mutex);
+	return ret;
+}
 
-static unsigned int mcam_v4l_poll(struct file *filp,
-		struct poll_table_struct *pt)
+static int mcam_vidioc_dqbuf(struct file *filp, void *priv,
+		struct v4l2_buffer *buf)
 {
 	struct mcam_camera *cam = filp->private_data;
 	int ret;
 
 	mutex_lock(&cam->s_mutex);
-	ret = vb2_poll(&cam->vb_queue, filp, pt);
+	ret = vb2_dqbuf(&cam->vb_queue, buf, filp->f_flags & O_NONBLOCK);
 	mutex_unlock(&cam->s_mutex);
 	return ret;
 }
@@ -1155,21 +1206,6 @@ static int mcam_vidioc_querycap(struct file *file, void *priv,
 }
 
 
-/*
- * The default format we use until somebody says otherwise.
- */
-static const struct v4l2_pix_format mcam_def_pix_format = {
-	.width		= VGA_WIDTH,
-	.height		= VGA_HEIGHT,
-	.pixelformat	= V4L2_PIX_FMT_YUYV,
-	.field		= V4L2_FIELD_NONE,
-	.bytesperline	= VGA_WIDTH*2,
-	.sizeimage	= VGA_WIDTH*VGA_HEIGHT*2,
-};
-
-static const enum v4l2_mbus_pixelcode mcam_def_mbus_code =
-					V4L2_MBUS_FMT_YUYV8_2X8;
-
 static int mcam_vidioc_enum_fmt_vid_cap(struct file *filp,
 		void *priv, struct v4l2_fmtdesc *fmt)
 {
@@ -1395,21 +1431,6 @@ static int mcam_vidioc_s_register(struct file *file, void *priv,
 }
 #endif
 
-/*
- * This template device holds all of those v4l2 methods; we
- * clone it for specific real devices.
- */
-
-static const struct v4l2_file_operations mcam_v4l_fops = {
-	.owner = THIS_MODULE,
-	.open = mcam_v4l_open,
-	.release = mcam_v4l_release,
-	.read = mcam_v4l_read,
-	.poll = mcam_v4l_poll,
-	.mmap = mcam_v4l_mmap,
-	.unlocked_ioctl = video_ioctl2,
-};
-
 static const struct v4l2_ioctl_ops mcam_v4l_ioctl_ops = {
 	.vidioc_querycap	= mcam_vidioc_querycap,
 	.vidioc_enum_fmt_vid_cap = mcam_vidioc_enum_fmt_vid_cap,
@@ -1440,133 +1461,126 @@ static const struct v4l2_ioctl_ops mcam_v4l_ioctl_ops = {
 #endif
 };
 
-static struct video_device mcam_v4l_template = {
-	.name = "mcam",
-	.tvnorms = V4L2_STD_NTSC_M,
-	.current_norm = V4L2_STD_NTSC_M,  /* make mplayer happy */
-
-	.fops = &mcam_v4l_fops,
-	.ioctl_ops = &mcam_v4l_ioctl_ops,
-	.release = video_device_release_empty,
-};
-
 /* ---------------------------------------------------------------------- */
 /*
- * Interrupt handler stuff
+ * Our various file operations.
  */
+static int mcam_v4l_open(struct file *filp)
+{
+	struct mcam_camera *cam = video_drvdata(filp);
+	int ret = 0;
 
+	filp->private_data = cam;
 
-static void mcam_buffer_done(struct mcam_camera *cam, int frame,
-		struct vb2_buffer *vbuf)
-{
-	vbuf->v4l2_buf.bytesused = cam->pix_format.sizeimage;
-	vbuf->v4l2_buf.sequence = cam->buf_seq[frame];
-	vb2_set_plane_payload(vbuf, 0, cam->pix_format.sizeimage);
-	vb2_buffer_done(vbuf, VB2_BUF_STATE_DONE);
+	frames = singles = delivered = 0;
+	mutex_lock(&cam->s_mutex);
+	if (cam->users == 0) {
+		ret = mcam_setup_vb2(cam);
+		if (ret)
+			goto out;
+		mcam_ctlr_power_up(cam);
+		__mcam_cam_reset(cam);
+		mcam_set_config_needed(cam, 1);
+	}
+	(cam->users)++;
+out:
+	mutex_unlock(&cam->s_mutex);
+	return ret;
 }
 
-/*
- * Copy data out to user space in the vmalloc case
- */
-static void mcam_frame_tasklet(unsigned long data)
-{
-	struct mcam_camera *cam = (struct mcam_camera *) data;
-	int i;
-	unsigned long flags;
-	struct mcam_vb_buffer *buf;
 
-	spin_lock_irqsave(&cam->dev_lock, flags);
-	for (i = 0; i < cam->nbufs; i++) {
-		int bufno = cam->next_buf;
+static int mcam_v4l_release(struct file *filp)
+{
+	struct mcam_camera *cam = filp->private_data;
 
-		if (cam->state != S_STREAMING || bufno < 0)
-			break;  /* I/O got stopped */
-		if (++(cam->next_buf) >= cam->nbufs)
-			cam->next_buf = 0;
-		if (!test_bit(bufno, &cam->flags))
-			continue;
-		if (list_empty(&cam->buffers)) {
-			singles++;
-			break;  /* Leave it valid, hope for better later */
-		}
-		delivered++;
-		clear_bit(bufno, &cam->flags);
-		buf = list_first_entry(&cam->buffers, struct mcam_vb_buffer,
-				queue);
-		list_del_init(&buf->queue);
-		/*
-		 * Drop the lock during the big copy.  This *should* be safe...
-		 */
-		spin_unlock_irqrestore(&cam->dev_lock, flags);
-		memcpy(vb2_plane_vaddr(&buf->vb_buf, 0), cam->dma_bufs[bufno],
-				cam->pix_format.sizeimage);
-		mcam_buffer_done(cam, bufno, &buf->vb_buf);
-		spin_lock_irqsave(&cam->dev_lock, flags);
+	cam_err(cam, "Release, %d frames, %d singles, %d delivered\n", frames,
+			singles, delivered);
+	mutex_lock(&cam->s_mutex);
+	(cam->users)--;
+	if (filp == cam->owner) {
+		mcam_ctlr_stop_dma(cam);
+		cam->owner = NULL;
 	}
-	spin_unlock_irqrestore(&cam->dev_lock, flags);
+	if (cam->users == 0) {
+		mcam_cleanup_vb2(cam);
+		mcam_ctlr_power_down(cam);
+		if (cam->buffer_mode == B_vmalloc && alloc_bufs_at_read)
+			mcam_free_dma_bufs(cam);
+	}
+	mutex_unlock(&cam->s_mutex);
+	return 0;
 }
 
-/*
- * For direct DMA, mark the buffer ready and set up another one.
- */
-static void mcam_dma_contig_done(struct mcam_camera *cam, int frame)
+static ssize_t mcam_v4l_read(struct file *filp,
+		char __user *buffer, size_t len, loff_t *pos)
 {
-	struct mcam_vb_buffer *buf = cam->vb_bufs[frame];
+	struct mcam_camera *cam = filp->private_data;
+	int ret;
 
-	if (!test_bit(CF_SINGLE_BUFFER, &cam->flags)) {
-		delivered++;
-		mcam_buffer_done(cam, frame, &buf->vb_buf);
-	}
-	mcam_set_contig_buffer(cam, frame);
+	mutex_lock(&cam->s_mutex);
+	ret = vb2_read(&cam->vb_queue, buffer, len, pos,
+			filp->f_flags & O_NONBLOCK);
+	mutex_unlock(&cam->s_mutex);
+	return ret;
 }
 
-/*
- * Frame completion with S/G is trickier.  We can't muck with
- * a descriptor chain on the fly, since the controller buffers it
- * internally.  So we have to actually stop and restart; Marvell
- * says this is the way to do it.
- *
- * Of course, stopping is easier said than done; experience shows
- * that the controller can start a frame *after* C0_ENABLE has been
- * cleared.  So when running in S/G mode, the controller is "stopped"
- * on receipt of the start-of-frame interrupt.  That means we can
- * safely change the DMA descriptor array here and restart things
- * (assuming there's another buffer waiting to go).
- */
-static void mcam_dma_sg_done(struct mcam_camera *cam, int frame)
+
+
+static unsigned int mcam_v4l_poll(struct file *filp,
+		struct poll_table_struct *pt)
 {
-	struct mcam_vb_buffer *buf = cam->vb_bufs[0];
+	struct mcam_camera *cam = filp->private_data;
+	int ret;
 
-	/*
-	 * Very Bad Not Good Things happen if you don't clear
-	 * C1_DESC_ENA before making any descriptor changes.
-	 */
-	mcam_reg_clear_bit(cam, REG_CTRL1, C1_DESC_ENA);
-	/*
-	 * If we have another buffer available, put it in and
-	 * restart the engine.
-	 */
-	if (!list_empty(&cam->buffers)) {
-		mcam_sg_next_buffer(cam);
-		mcam_reg_set_bit(cam, REG_CTRL1, C1_DESC_ENA);
-		mcam_ctlr_start(cam);
-	/*
-	 * Otherwise set CF_SG_RESTART and the controller will
-	 * be restarted once another buffer shows up.
-	 */
-	} else {
-		set_bit(CF_SG_RESTART, &cam->flags);
-		singles++;
-	}
-	/*
-	 * Now we can give the completed frame back to user space.
-	 */
-	delivered++;
-	mcam_buffer_done(cam, frame, &buf->vb_buf);
+	mutex_lock(&cam->s_mutex);
+	ret = vb2_poll(&cam->vb_queue, filp, pt);
+	mutex_unlock(&cam->s_mutex);
+	return ret;
+}
+
+
+static int mcam_v4l_mmap(struct file *filp, struct vm_area_struct *vma)
+{
+	struct mcam_camera *cam = filp->private_data;
+	int ret;
+
+	mutex_lock(&cam->s_mutex);
+	ret = vb2_mmap(&cam->vb_queue, vma);
+	mutex_unlock(&cam->s_mutex);
+	return ret;
 }
 
 
 
+static const struct v4l2_file_operations mcam_v4l_fops = {
+	.owner = THIS_MODULE,
+	.open = mcam_v4l_open,
+	.release = mcam_v4l_release,
+	.read = mcam_v4l_read,
+	.poll = mcam_v4l_poll,
+	.mmap = mcam_v4l_mmap,
+	.unlocked_ioctl = video_ioctl2,
+};
+
+
+/*
+ * This template device holds all of those v4l2 methods; we
+ * clone it for specific real devices.
+ */
+static struct video_device mcam_v4l_template = {
+	.name = "mcam",
+	.tvnorms = V4L2_STD_NTSC_M,
+	.current_norm = V4L2_STD_NTSC_M,  /* make mplayer happy */
+
+	.fops = &mcam_v4l_fops,
+	.ioctl_ops = &mcam_v4l_ioctl_ops,
+	.release = video_device_release_empty,
+};
+
+/* ---------------------------------------------------------------------- */
+/*
+ * Interrupt handler stuff
+ */
 static void mcam_frame_complete(struct mcam_camera *cam, int frame)
 {
 	/*
@@ -1600,8 +1614,10 @@ static void mcam_frame_complete(struct mcam_camera *cam, int frame)
 }
 
 
-
-
+/*
+ * The interrupt handler; this needs to be called from the
+ * platform irq handler with the lock held.
+ */
 int mccic_irq(struct mcam_camera *cam, unsigned int irqs)
 {
 	unsigned int frame, handled = 0;
@@ -1636,10 +1652,10 @@ int mccic_irq(struct mcam_camera *cam, unsigned int irqs)
 	return handled;
 }
 
+/* ---------------------------------------------------------------------- */
 /*
  * Registration and such.
  */
-
 static struct ov7670_config sensor_cfg = {
 	/*
 	 * Exclude QCIF mode, because it only captures a tiny portion
-- 
1.7.6

