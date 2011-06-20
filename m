Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:57322 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754216Ab1FTTPG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2011 15:15:06 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, Kassey Lee <ygli@marvell.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 5/5] marvell-cam: implement contiguous DMA operation
Date: Mon, 20 Jun 2011 13:14:40 -0600
Message-Id: <1308597280-138673-6-git-send-email-corbet@lwn.net>
In-Reply-To: <1308597280-138673-1-git-send-email-corbet@lwn.net>
References: <1308597280-138673-1-git-send-email-corbet@lwn.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The core driver can now operate in either vmalloc or dma-contig modes;
obviously the latter is preferable when it is supported.  Default is
currently vmalloc on all platforms; load the module with buffer_mode=1 for
contiguous DMA mode.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/media/video/marvell-ccic/Kconfig       |    1 +
 drivers/media/video/marvell-ccic/cafe-driver.c |    6 +
 drivers/media/video/marvell-ccic/mcam-core.c   |  230 ++++++++++++++++++------
 drivers/media/video/marvell-ccic/mcam-core.h   |   21 ++-
 drivers/media/video/marvell-ccic/mmp-driver.c  |    1 +
 5 files changed, 205 insertions(+), 54 deletions(-)

diff --git a/drivers/media/video/marvell-ccic/Kconfig b/drivers/media/video/marvell-ccic/Kconfig
index eb535b1..22314a0 100644
--- a/drivers/media/video/marvell-ccic/Kconfig
+++ b/drivers/media/video/marvell-ccic/Kconfig
@@ -14,6 +14,7 @@ config VIDEO_MMP_CAMERA
 	select VIDEO_OV7670
 	select I2C_GPIO
 	select VIDEOBUF2_VMALLOC
+	select VIDEOBUF2_DMA_CONTIG
 	---help---
 	  This is a Video4Linux2 driver for the integrated camera
 	  controller found on Marvell Armada 610 application
diff --git a/drivers/media/video/marvell-ccic/cafe-driver.c b/drivers/media/video/marvell-ccic/cafe-driver.c
index 6a29cc1..d030f9b 100644
--- a/drivers/media/video/marvell-ccic/cafe-driver.c
+++ b/drivers/media/video/marvell-ccic/cafe-driver.c
@@ -482,6 +482,12 @@ static int cafe_pci_probe(struct pci_dev *pdev,
 	mcam->clock_speed = 45;
 	mcam->use_smbus = 1;
 	/*
+	 * Vmalloc mode for buffers is traditional with this driver.
+	 * We *might* be able to run DMA_contig, especially on a system
+	 * with CMA in it.
+	 */
+	mcam->buffer_mode = B_vmalloc;
+	/*
 	 * Get set up on the PCI bus.
 	 */
 	ret = pci_enable_device(pdev);
diff --git a/drivers/media/video/marvell-ccic/mcam-core.c b/drivers/media/video/marvell-ccic/mcam-core.c
index ca3c56f..419b4e5 100644
--- a/drivers/media/video/marvell-ccic/mcam-core.c
+++ b/drivers/media/video/marvell-ccic/mcam-core.c
@@ -25,9 +25,16 @@
 #include <media/v4l2-chip-ident.h>
 #include <media/ov7670.h>
 #include <media/videobuf2-vmalloc.h>
+#include <media/videobuf2-dma-contig.h>
 
 #include "mcam-core.h"
 
+/*
+ * Basic frame stats - to be deleted shortly
+ */
+static int frames;
+static int singles;
+static int delivered;
 
 /*
  * Internal DMA buffer management.  Since the controller cannot do S/G I/O,
@@ -48,7 +55,8 @@ MODULE_PARM_DESC(alloc_bufs_at_read,
 		"Non-zero value causes DMA buffers to be allocated when the "
 		"video capture device is read, rather than at module load "
 		"time.  This saves memory, but decreases the chances of "
-		"successfully getting those buffers.");
+		"successfully getting those buffers.  This parameter is "
+		"only used in the vmalloc buffer mode");
 
 static int n_dma_bufs = 3;
 module_param(n_dma_bufs, uint, 0644);
@@ -82,6 +90,13 @@ MODULE_PARM_DESC(flip,
 		"If set, the sensor will be instructed to flip the image "
 		"vertically.");
 
+static int buffer_mode = -1;
+module_param(buffer_mode, int, 0444);
+MODULE_PARM_DESC(buffer_mode,
+		"Set the buffer mode to be used; default is to go with what "
+		"the platform driver asks for.  Set to 0 for vmalloc, 1 for "
+		"DMA contiguous.");
+
 /*
  * Status flags.  Always manipulated with bit operations.
  */
@@ -90,6 +105,7 @@ MODULE_PARM_DESC(flip,
 #define CF_BUF2_VALID	 2
 #define CF_DMA_ACTIVE	 3	/* A frame is incoming */
 #define CF_CONFIG_NEEDED 4	/* Must configure hardware */
+#define CF_SINGLE_BUFFER 5	/* Running with a single buffer */
 
 #define sensor_call(cam, o, f, args...) \
 	v4l2_subdev_call(cam->sensor, o, f, ##args)
@@ -197,10 +213,9 @@ static inline struct mcam_vb_buffer *vb_to_mvb(struct vb2_buffer *vb)
  */
 
 /*
- * Do everything we think we need to have the interface operating
- * according to the desired format.
+ * Set up DMA buffers when operating in vmalloc mode
  */
-static void mcam_ctlr_dma(struct mcam_camera *cam)
+static void mcam_ctlr_dma_vmalloc(struct mcam_camera *cam)
 {
 	/*
 	 * Store the first two Y buffers (we aren't supporting
@@ -219,6 +234,57 @@ static void mcam_ctlr_dma(struct mcam_camera *cam)
 		mcam_reg_write(cam, REG_UBAR, 0); /* 32 bits only */
 }
 
+/*
+ * Set up a contiguous buffer for the given frame.  Here also is where
+ * the underrun strategy is set: if there is no buffer available, reuse
+ * the buffer from the other BAR and set the CF_SINGLE_BUFFER flag to
+ * keep the interrupt handler from giving that buffer back to user
+ * space.  In this way, we always have a buffer to DMA to and don't
+ * have to try to play games stopping and restarting the controller.
+ */
+static void mcam_set_contig_buffer(struct mcam_camera *cam, int frame)
+{
+	struct mcam_vb_buffer *buf;
+	/*
+	 * If there are no available buffers, go into single mode
+	 */
+	if (list_empty(&cam->buffers)) {
+		buf = cam->vb_bufs[frame ^ 0x1];
+		cam->vb_bufs[frame] = buf;
+		mcam_reg_write(cam, frame == 0 ? REG_Y0BAR : REG_Y1BAR,
+				vb2_dma_contig_plane_paddr(&buf->vb_buf, 0));
+		set_bit(CF_SINGLE_BUFFER, &cam->flags);
+		singles++;
+		return;
+	}
+	/*
+	 * OK, we have a buffer we can use.
+	 */
+	buf = list_first_entry(&cam->buffers, struct mcam_vb_buffer, queue);
+	list_del_init(&buf->queue);
+	mcam_reg_write(cam, frame == 0 ? REG_Y0BAR : REG_Y1BAR,
+			vb2_dma_contig_plane_paddr(&buf->vb_buf, 0));
+	cam->vb_bufs[frame] = buf;
+	clear_bit(CF_SINGLE_BUFFER, &cam->flags);
+}
+
+static void mcam_ctlr_dma_contig(struct mcam_camera *cam)
+{
+	mcam_reg_set_bit(cam, REG_CTRL1, C1_TWOBUFS);
+	cam->nbufs = 2;
+	mcam_set_contig_buffer(cam, 0);
+	mcam_set_contig_buffer(cam, 1);
+}
+
+
+static void mcam_ctlr_dma(struct mcam_camera *cam)
+{
+	if (cam->buffer_mode == B_DMA_contig)
+		mcam_ctlr_dma_contig(cam);
+	else
+		mcam_ctlr_dma_vmalloc(cam);
+}
+
 static void mcam_ctlr_image(struct mcam_camera *cam)
 {
 	int imgsz;
@@ -542,7 +608,7 @@ static void mcam_free_dma_bufs(struct mcam_camera *cam)
 /*
  * Get everything ready, and start grabbing frames.
  */
-static int mcam_read_setup(struct mcam_camera *cam, enum mcam_state state)
+static int mcam_read_setup(struct mcam_camera *cam)
 {
 	int ret;
 	unsigned long flags;
@@ -551,9 +617,9 @@ static int mcam_read_setup(struct mcam_camera *cam, enum mcam_state state)
 	 * Configuration.  If we still don't have DMA buffers,
 	 * make one last, desperate attempt.
 	 */
-	if (cam->nbufs == 0)
-		if (mcam_alloc_dma_bufs(cam, 0))
-			return -ENOMEM;
+	if (cam->buffer_mode == B_vmalloc && cam->nbufs == 0 &&
+			mcam_alloc_dma_bufs(cam, 0))
+		return -ENOMEM;
 
 	if (mcam_needs_config(cam)) {
 		mcam_cam_configure(cam);
@@ -568,7 +634,7 @@ static int mcam_read_setup(struct mcam_camera *cam, enum mcam_state state)
 	spin_lock_irqsave(&cam->dev_lock, flags);
 	mcam_reset_buffers(cam);
 	mcam_ctlr_irq_enable(cam);
-	cam->state = state;
+	cam->state = S_STREAMING;
 	mcam_ctlr_start(cam);
 	spin_unlock_irqrestore(&cam->dev_lock, flags);
 	return 0;
@@ -587,8 +653,10 @@ static int mcam_vb_queue_setup(struct vb2_queue *vq, unsigned int *nbufs,
 
 	sizes[0] = cam->pix_format.sizeimage;
 	*num_planes = 1; /* Someday we have to support planar formats... */
-	if (*nbufs < 2 || *nbufs > 32)
-		*nbufs = 6;  /* semi-arbitrary numbers */
+	if (*nbufs < 3 || *nbufs > 32)
+		*nbufs = 3;  /* semi-arbitrary numbers */
+	if (cam->buffer_mode == B_DMA_contig)
+		alloc_ctxs[0] = cam->vb_alloc_ctx;
 	return 0;
 }
 
@@ -605,10 +673,14 @@ static void mcam_vb_buf_queue(struct vb2_buffer *vb)
 	struct mcam_vb_buffer *mvb = vb_to_mvb(vb);
 	struct mcam_camera *cam = vb2_get_drv_priv(vb->vb2_queue);
 	unsigned long flags;
+	int start;
 
 	spin_lock_irqsave(&cam->dev_lock, flags);
-	list_add(&cam->buffers, &mvb->queue);
+	start = (cam->state == S_BUFWAIT) && !list_empty(&cam->buffers);
+	list_add(&mvb->queue, &cam->buffers);
 	spin_unlock_irqrestore(&cam->dev_lock, flags);
+	if (start)
+		mcam_read_setup(cam);
 }
 
 /*
@@ -636,13 +708,22 @@ static void mcam_vb_wait_finish(struct vb2_queue *vq)
 static int mcam_vb_start_streaming(struct vb2_queue *vq)
 {
 	struct mcam_camera *cam = vb2_get_drv_priv(vq);
-	int ret = -EINVAL;
 
-	if (cam->state == S_IDLE) {
-		cam->sequence = 0;
-		ret = mcam_read_setup(cam, S_STREAMING);
+	if (cam->state != S_IDLE)
+		return -EINVAL;
+	cam->sequence = 0;
+	/*
+	 * Videobuf2 sneakily hoards all the buffers and won't
+	 * give them to us until *after* streaming starts.  But
+	 * we can't actually start streaming until we have a
+	 * destination.  So go into a wait state and hope they
+	 * give us buffers soon.
+	 */
+	if (cam->buffer_mode != B_vmalloc && list_empty(&cam->buffers)) {
+		cam->state = S_BUFWAIT;
+		return 0;
 	}
-	return ret;
+	return mcam_read_setup(cam);
 }
 
 static int mcam_vb_stop_streaming(struct vb2_queue *vq)
@@ -650,6 +731,11 @@ static int mcam_vb_stop_streaming(struct vb2_queue *vq)
 	struct mcam_camera *cam = vb2_get_drv_priv(vq);
 	unsigned long flags;
 
+	if (cam->state == S_BUFWAIT) {
+		/* They never gave us buffers */
+		cam->state = S_IDLE;
+		return 0;
+	}
 	if (cam->state != S_STREAMING)
 		return -EINVAL;
 	mcam_ctlr_stop_dma(cam);
@@ -683,7 +769,11 @@ static int mcam_setup_vb2(struct mcam_camera *cam)
 	vq->io_modes = VB2_MMAP;  /* Add userptr */
 	vq->drv_priv = cam;
 	vq->ops = &mcam_vb2_ops;
-	vq->mem_ops = &vb2_vmalloc_memops;
+	if (cam->buffer_mode == B_DMA_contig) {
+		vq->mem_ops = &vb2_dma_contig_memops;
+		cam->vb_alloc_ctx = vb2_dma_contig_init_ctx(cam->dev);
+	} else
+		vq->mem_ops = &vb2_vmalloc_memops;
 	vq->buf_struct_size = sizeof(struct mcam_vb_buffer);
 
 	return vb2_queue_init(vq);
@@ -692,6 +782,8 @@ static int mcam_setup_vb2(struct mcam_camera *cam)
 static void mcam_cleanup_vb2(struct mcam_camera *cam)
 {
 	vb2_queue_release(&cam->vb_queue);
+	if (cam->buffer_mode == B_DMA_contig)
+		vb2_dma_contig_cleanup_ctx(cam->vb_alloc_ctx);
 }
 
 static ssize_t mcam_v4l_read(struct file *filp,
@@ -809,6 +901,7 @@ static int mcam_v4l_open(struct file *filp)
 
 	filp->private_data = cam;
 
+	frames = singles = delivered = 0;
 	mutex_lock(&cam->s_mutex);
 	if (cam->users == 0) {
 		ret = mcam_setup_vb2(cam);
@@ -829,6 +922,8 @@ static int mcam_v4l_release(struct file *filp)
 {
 	struct mcam_camera *cam = filp->private_data;
 
+	cam_err(cam, "Release, %d frames, %d singles, %d delivered\n", frames,
+			singles, delivered);
 	mutex_lock(&cam->s_mutex);
 	(cam->users)--;
 	if (filp == cam->owner) {
@@ -838,7 +933,7 @@ static int mcam_v4l_release(struct file *filp)
 	if (cam->users == 0) {
 		mcam_cleanup_vb2(cam);
 		mcam_ctlr_power_down(cam);
-		if (alloc_bufs_at_read)
+		if (cam->buffer_mode == B_vmalloc && alloc_bufs_at_read)
 			mcam_free_dma_bufs(cam);
 	}
 	mutex_unlock(&cam->s_mutex);
@@ -993,18 +1088,17 @@ static int mcam_vidioc_s_fmt_vid_cap(struct file *filp, void *priv,
 	 * Make sure we have appropriate DMA buffers.
 	 */
 	ret = -ENOMEM;
-	if (cam->nbufs > 0 && cam->dma_buf_size < cam->pix_format.sizeimage)
-		mcam_free_dma_bufs(cam);
-	if (cam->nbufs == 0) {
-		if (mcam_alloc_dma_bufs(cam, 0))
-			goto out;
+	if (cam->buffer_mode == B_vmalloc) {
+		if (cam->nbufs > 0 &&
+				cam->dma_buf_size < cam->pix_format.sizeimage)
+			mcam_free_dma_bufs(cam);
+		if (cam->nbufs == 0) {
+			if (mcam_alloc_dma_bufs(cam, 0))
+				goto out;
+		}
 	}
-	/*
-	 * It looks like this might work, so let's program the sensor.
-	 */
-	ret = mcam_cam_configure(cam);
-	if (!ret)
-		ret = mcam_ctlr_configure(cam);
+	mcam_set_config_needed(cam, 1);
+	ret = 0;
 out:
 	mutex_unlock(&cam->s_mutex);
 	return ret;
@@ -1214,7 +1308,20 @@ static struct video_device mcam_v4l_template = {
  */
 
 
+static void mcam_buffer_done(struct mcam_camera *cam, int frame,
+		struct vb2_buffer *vbuf)
+{
+	vbuf->v4l2_buf.bytesused = cam->pix_format.sizeimage;
+	vbuf->v4l2_buf.sequence = cam->buf_seq[frame];
+	vbuf->v4l2_buf.flags &= ~V4L2_BUF_FLAG_QUEUED;
+	vbuf->v4l2_buf.flags |= V4L2_BUF_FLAG_DONE;
+	vb2_set_plane_payload(vbuf, 0, cam->pix_format.sizeimage);
+	vb2_buffer_done(vbuf, VB2_BUF_STATE_DONE);
+}
 
+/*
+ * Copy data out to user space in the vmalloc case
+ */
 static void mcam_frame_tasklet(unsigned long data)
 {
 	struct mcam_camera *cam = (struct mcam_camera *) data;
@@ -1232,8 +1339,11 @@ static void mcam_frame_tasklet(unsigned long data)
 			cam->next_buf = 0;
 		if (!test_bit(bufno, &cam->flags))
 			continue;
-		if (list_empty(&cam->buffers))
+		if (list_empty(&cam->buffers)) {
+			singles++;
 			break;  /* Leave it valid, hope for better later */
+		}
+		delivered++;
 		clear_bit(bufno, &cam->flags);
 		buf = list_first_entry(&cam->buffers, struct mcam_vb_buffer,
 				queue);
@@ -1244,18 +1354,25 @@ static void mcam_frame_tasklet(unsigned long data)
 		spin_unlock_irqrestore(&cam->dev_lock, flags);
 		memcpy(vb2_plane_vaddr(&buf->vb_buf, 0), cam->dma_bufs[bufno],
 				cam->pix_format.sizeimage);
-		buf->vb_buf.v4l2_buf.bytesused = cam->pix_format.sizeimage;
-		buf->vb_buf.v4l2_buf.sequence = cam->buf_seq[bufno];
-		buf->vb_buf.v4l2_buf.flags &= ~V4L2_BUF_FLAG_QUEUED;
-		buf->vb_buf.v4l2_buf.flags |= V4L2_BUF_FLAG_DONE;
-		vb2_set_plane_payload(&buf->vb_buf, 0,
-				cam->pix_format.sizeimage);
-		vb2_buffer_done(&buf->vb_buf, VB2_BUF_STATE_DONE);
+		mcam_buffer_done(cam, bufno, &buf->vb_buf);
 		spin_lock_irqsave(&cam->dev_lock, flags);
 	}
 	spin_unlock_irqrestore(&cam->dev_lock, flags);
 }
 
+/*
+ * For direct DMA, mark the buffer ready and set up another one.
+ */
+static void mcam_dma_complete(struct mcam_camera *cam, int frame)
+{
+	struct mcam_vb_buffer *buf = cam->vb_bufs[frame];
+
+	if (!test_bit(CF_SINGLE_BUFFER, &cam->flags)) {
+		delivered++;
+		mcam_buffer_done(cam, frame, &buf->vb_buf);
+	}
+	mcam_set_contig_buffer(cam, frame);
+}
 
 
 static void mcam_frame_complete(struct mcam_camera *cam, int frame)
@@ -1265,21 +1382,20 @@ static void mcam_frame_complete(struct mcam_camera *cam, int frame)
 	 */
 	set_bit(frame, &cam->flags);
 	clear_bit(CF_DMA_ACTIVE, &cam->flags);
-	if (cam->next_buf < 0)
-		cam->next_buf = frame;
+	cam->next_buf = frame;
 	cam->buf_seq[frame] = ++(cam->sequence);
+	cam->last_delivered = frame;
 
+	frames++;
 	switch (cam->state) {
 	/*
-	 * For the streaming case, we defer the real work to the
-	 * camera tasklet.
-	 *
-	 * FIXME: if the application is not consuming the buffers,
-	 * we should eventually put things on hold and restart in
-	 * vidioc_dqbuf().
+	 * We're streaming and have a ready frame, hand it back
 	 */
 	case S_STREAMING:
-		tasklet_schedule(&cam->s_tasklet);
+		if (cam->buffer_mode == B_vmalloc)
+			tasklet_schedule(&cam->s_tasklet);
+		else
+			mcam_dma_complete(cam, frame);
 		break;
 
 	default:
@@ -1356,7 +1472,18 @@ int mccic_register(struct mcam_camera *cam)
 	INIT_LIST_HEAD(&cam->dev_list);
 	INIT_LIST_HEAD(&cam->buffers);
 	tasklet_init(&cam->s_tasklet, mcam_frame_tasklet, (unsigned long) cam);
-
+	/*
+	 * User space may want to override the asked-for buffer mode;
+	 * here's hoping they know what they're doing.
+	 */
+	if (buffer_mode == 0)
+		cam->buffer_mode = B_vmalloc;
+	else if (buffer_mode == 1)
+		cam->buffer_mode = B_DMA_contig;
+	else if (buffer_mode != -1)
+		printk(KERN_ERR "marvel-cam: "
+				"Strange module buffer mode %d - ignoring\n",
+				buffer_mode);
 	mcam_ctlr_init(cam);
 
 	/*
@@ -1390,7 +1517,7 @@ int mccic_register(struct mcam_camera *cam)
 	/*
 	 * If so requested, try to get our DMA buffers now.
 	 */
-	if (!alloc_bufs_at_read) {
+	if (cam->buffer_mode == B_vmalloc && !alloc_bufs_at_read) {
 		if (mcam_alloc_dma_bufs(cam, 1))
 			cam_warn(cam, "Unable to alloc DMA buffers at load"
 					" will try again later.");
@@ -1418,7 +1545,8 @@ void mccic_shutdown(struct mcam_camera *cam)
 		mcam_ctlr_power_down(cam);
 	}
 	vb2_queue_release(&cam->vb_queue);
-	mcam_free_dma_bufs(cam);
+	if (cam->buffer_mode == B_vmalloc)
+		mcam_free_dma_bufs(cam);
 	video_unregister_device(&cam->vdev);
 	v4l2_device_unregister(&cam->v4l2_dev);
 }
@@ -1452,7 +1580,7 @@ int mccic_resume(struct mcam_camera *cam)
 
 	set_bit(CF_CONFIG_NEEDED, &cam->flags);
 	if (cam->state == S_STREAMING)
-		ret = mcam_read_setup(cam, cam->state);
+		ret = mcam_read_setup(cam);
 	return ret;
 }
 #endif /* CONFIG_PM */
diff --git a/drivers/media/video/marvell-ccic/mcam-core.h b/drivers/media/video/marvell-ccic/mcam-core.h
index f40450c..2e667a0 100644
--- a/drivers/media/video/marvell-ccic/mcam-core.h
+++ b/drivers/media/video/marvell-ccic/mcam-core.h
@@ -27,11 +27,21 @@ enum mcam_state {
 	S_NOTREADY,	/* Not yet initialized */
 	S_IDLE,		/* Just hanging around */
 	S_FLAKED,	/* Some sort of problem */
-	S_STREAMING	/* Streaming data */
+	S_STREAMING,	/* Streaming data */
+	S_BUFWAIT	/* streaming requested but no buffers yet */
 };
 #define MAX_DMA_BUFS 3
 
 /*
+ * Different platforms work best with different buffer modes, so we
+ * let the platform pick.
+ */
+enum mcam_buffer_mode {
+	B_vmalloc = 0,
+	B_DMA_contig
+};
+
+/*
  * A description of one of our devices.
  * Locking: controlled by s_mutex.  Certain fields, however, require
  *          the dev_lock spinlock; they are marked as such by comments.
@@ -49,7 +59,7 @@ struct mcam_camera {
 	unsigned int chip_id;
 	short int clock_speed;	/* Sensor clock speed, default 30 */
 	short int use_smbus;	/* SMBUS or straight I2c? */
-
+	enum mcam_buffer_mode buffer_mode;
 	/*
 	 * Callbacks from the core to the platform code.
 	 */
@@ -79,7 +89,7 @@ struct mcam_camera {
 	struct vb2_queue vb_queue;
 	struct list_head buffers;	/* Available frames */
 
-	/* DMA buffers */
+	/* DMA buffers - vmalloc mode */
 	unsigned int nbufs;		/* How many are alloc'd */
 	int next_buf;			/* Next to consume (dev_lock) */
 	unsigned int dma_buf_size;	/* allocated size */
@@ -88,6 +98,11 @@ struct mcam_camera {
 	unsigned int sequence;		/* Frame sequence number */
 	unsigned int buf_seq[MAX_DMA_BUFS]; /* Sequence for individual bufs */
 
+	/* DMA buffers - contiguous DMA mode */
+	struct mcam_vb_buffer *vb_bufs[MAX_DMA_BUFS];
+	struct vb2_alloc_ctx *vb_alloc_ctx;
+	unsigned short last_delivered;
+
 	struct tasklet_struct s_tasklet;
 
 	/* Current operating parameters */
diff --git a/drivers/media/video/marvell-ccic/mmp-driver.c b/drivers/media/video/marvell-ccic/mmp-driver.c
index ac9976f..7b9c48c 100644
--- a/drivers/media/video/marvell-ccic/mmp-driver.c
+++ b/drivers/media/video/marvell-ccic/mmp-driver.c
@@ -180,6 +180,7 @@ static int mmpcam_probe(struct platform_device *pdev)
 	mcam->dev = &pdev->dev;
 	mcam->use_smbus = 0;
 	mcam->chip_id = V4L2_IDENT_ARMADA610;
+	mcam->buffer_mode = B_vmalloc;  /* Switch to dma */
 	spin_lock_init(&mcam->dev_lock);
 	/*
 	 * Get our I/O memory.
-- 
1.7.5.4

