Return-path: <mchehab@localhost>
Received: from tex.lwn.net ([70.33.254.29]:36262 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753707Ab1GHUwJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Jul 2011 16:52:09 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Kassey Lee <ygli@marvell.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 5/6] marvell-cam: Allow selection of supported buffer modes
Date: Fri,  8 Jul 2011 14:50:49 -0600
Message-Id: <1310158250-168899-6-git-send-email-corbet@lwn.net>
In-Reply-To: <1310158250-168899-1-git-send-email-corbet@lwn.net>
References: <1310158250-168899-1-git-send-email-corbet@lwn.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

The Marvell camera core can support all three videobuf2 buffer modes, which
is slick, but it also requires that all three modes be built and present,
even though only one is likely to be used.  This patch allows the supported
modes to be selected at configuration time, reducing the footprint of the
driver.  Prior to this patch, the MMP camera driver looked like this:

mmp_camera             19092  0
videobuf2_core         15542  1 mmp_camera
videobuf2_dma_sg        3173  1 mmp_camera
videobuf2_dma_contig     2188  1 mmp_camera
videobuf2_vmalloc       1718  1 mmp_camera
videobuf2_memops        2100  3 videobuf2_dma_sg,videobuf2_dma_contig,videobuf2_vmalloc

Afterward, instead, with scatter/gather only configured:

mmp_camera             16021  0
videobuf2_core         15542  1 mmp_camera
videobuf2_dma_sg        3173  1 mmp_camera
videobuf2_memops        2100  1 videobuf2_dma_sg

The total goes from 43,813 bytes to 36,836.

The emphasis has been on simplicity and minimal #ifdef use rather than on
squeezing out every possible byte of code.  For configuration, the driver
simply looks at which videobuf2 modes have been configured in and supports
them all; it's simplistic but should be good enough.

The cafe driver is set to support vmalloc and dma-contig; mmp supports only
dma-sg, since that's the only mode that really makes sense to use.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/media/video/marvell-ccic/Kconfig     |    3 -
 drivers/media/video/marvell-ccic/mcam-core.c |  149 +++++++++++++++++---------
 drivers/media/video/marvell-ccic/mcam-core.h |   59 +++++++++-
 3 files changed, 152 insertions(+), 59 deletions(-)

diff --git a/drivers/media/video/marvell-ccic/Kconfig b/drivers/media/video/marvell-ccic/Kconfig
index 5be66e2..bf739e3 100644
--- a/drivers/media/video/marvell-ccic/Kconfig
+++ b/drivers/media/video/marvell-ccic/Kconfig
@@ -4,7 +4,6 @@ config VIDEO_CAFE_CCIC
 	select VIDEO_OV7670
 	select VIDEOBUF2_VMALLOC
 	select VIDEOBUF2_DMA_CONTIG
-	select VIDEOBUF2_DMA_SG
 	---help---
 	  This is a video4linux2 driver for the Marvell 88ALP01 integrated
 	  CMOS camera controller.  This is the controller found on first-
@@ -15,8 +14,6 @@ config VIDEO_MMP_CAMERA
 	depends on ARCH_MMP && I2C && VIDEO_V4L2
 	select VIDEO_OV7670
 	select I2C_GPIO
-	select VIDEOBUF2_VMALLOC
-	select VIDEOBUF2_DMA_CONTIG
 	select VIDEOBUF2_DMA_SG
 	---help---
 	  This is a Video4Linux2 driver for the integrated camera
diff --git a/drivers/media/video/marvell-ccic/mcam-core.c b/drivers/media/video/marvell-ccic/mcam-core.c
index 9867b3b..073e72c 100644
--- a/drivers/media/video/marvell-ccic/mcam-core.c
+++ b/drivers/media/video/marvell-ccic/mcam-core.c
@@ -37,6 +37,7 @@ static int frames;
 static int singles;
 static int delivered;
 
+#ifdef MCAM_MODE_VMALLOC
 /*
  * Internal DMA buffer management.  Since the controller cannot do S/G I/O,
  * we must have physically contiguous buffers to bring frames into.
@@ -71,6 +72,10 @@ MODULE_PARM_DESC(dma_buf_size,
 		"The size of the allocated DMA buffers.  If actual operating "
 		"parameters require larger buffers, an attempt to reallocate "
 		"will be made.");
+#else /* MCAM_MODE_VMALLOC */
+static const int alloc_bufs_at_read = 0;
+static const int n_dma_bufs = 3;  /* Used by S/G_PARM */
+#endif /* MCAM_MODE_VMALLOC */
 
 static int flip;
 module_param(flip, bool, 0444);
@@ -256,6 +261,8 @@ static void mcam_ctlr_stop(struct mcam_camera *cam)
 }
 
 /* ------------------------------------------------------------------- */
+
+#ifdef MCAM_MODE_VMALLOC
 /*
  * Code specific to the vmalloc buffer mode.
  */
@@ -381,6 +388,46 @@ static void mcam_frame_tasklet(unsigned long data)
 }
 
 
+/*
+ * Make sure our allocated buffers are up to the task.
+ */
+static int mcam_check_dma_buffers(struct mcam_camera *cam)
+{
+	if (cam->nbufs > 0 && cam->dma_buf_size < cam->pix_format.sizeimage)
+			mcam_free_dma_bufs(cam);
+	if (cam->nbufs == 0)
+		return mcam_alloc_dma_bufs(cam, 0);
+	return 0;
+}
+
+static void mcam_vmalloc_done(struct mcam_camera *cam, int frame)
+{
+	tasklet_schedule(&cam->s_tasklet);
+}
+
+#else /* MCAM_MODE_VMALLOC */
+
+static inline int mcam_alloc_dma_bufs(struct mcam_camera *cam, int loadtime)
+{
+	return 0;
+}
+
+static inline void mcam_free_dma_bufs(struct mcam_camera *cam)
+{
+	return;
+}
+
+static inline int mcam_check_dma_buffers(struct mcam_camera *cam)
+{
+	return 0;
+}
+
+
+
+#endif /* MCAM_MODE_VMALLOC */
+
+
+#ifdef MCAM_MODE_DMA_CONTIG
 /* ---------------------------------------------------------------------- */
 /*
  * DMA-contiguous code.
@@ -444,8 +491,9 @@ static void mcam_dma_contig_done(struct mcam_camera *cam, int frame)
 	mcam_set_contig_buffer(cam, frame);
 }
 
+#endif /* MCAM_MODE_DMA_CONTIG */
 
-
+#ifdef MCAM_MODE_DMA_SG
 /* ---------------------------------------------------------------------- */
 /*
  * Scatter/gather-specific code.
@@ -540,6 +588,14 @@ static void mcam_sg_restart(struct mcam_camera *cam)
 	clear_bit(CF_SG_RESTART, &cam->flags);
 }
 
+#else /* MCAM_MODE_DMA_SG */
+
+static inline void mcam_sg_restart(struct mcam_camera *cam)
+{
+	return;
+}
+
+#endif /* MCAM_MODE_DMA_SG */
 
 /* ---------------------------------------------------------------------- */
 /*
@@ -605,17 +661,7 @@ static int mcam_ctlr_configure(struct mcam_camera *cam)
 	unsigned long flags;
 
 	spin_lock_irqsave(&cam->dev_lock, flags);
-	switch (cam->buffer_mode) {
-	case B_vmalloc:
-		mcam_ctlr_dma_vmalloc(cam);
-		break;
-	case B_DMA_contig:
-		mcam_ctlr_dma_contig(cam);
-		break;
-	case B_DMA_sg:
-		mcam_ctlr_dma_sg(cam);
-		break;
-	}
+	cam->dma_setup(cam);
 	mcam_ctlr_image(cam);
 	mcam_set_config_needed(cam, 0);
 	clear_bit(CF_SG_RESTART, &cam->flags);
@@ -948,6 +994,8 @@ static const struct vb2_ops mcam_vb2_ops = {
 	.wait_finish		= mcam_vb_wait_finish,
 };
 
+
+#ifdef MCAM_MODE_DMA_SG
 /*
  * Scatter/gather mode uses all of the above functions plus a
  * few extras to deal with DMA mapping.
@@ -1022,6 +1070,8 @@ static const struct vb2_ops mcam_vb2_sg_ops = {
 	.wait_finish		= mcam_vb_wait_finish,
 };
 
+#endif /* MCAM_MODE_DMA_SG */
+
 static int mcam_setup_vb2(struct mcam_camera *cam)
 {
 	struct vb2_queue *vq = &cam->vb_queue;
@@ -1032,21 +1082,35 @@ static int mcam_setup_vb2(struct mcam_camera *cam)
 	INIT_LIST_HEAD(&cam->buffers);
 	switch (cam->buffer_mode) {
 	case B_DMA_contig:
+#ifdef MCAM_MODE_DMA_CONTIG
 		vq->ops = &mcam_vb2_ops;
 		vq->mem_ops = &vb2_dma_contig_memops;
 		cam->vb_alloc_ctx = vb2_dma_contig_init_ctx(cam->dev);
 		vq->io_modes = VB2_MMAP | VB2_USERPTR;
+		cam->dma_setup = mcam_ctlr_dma_contig;
+		cam->frame_complete = mcam_dma_contig_done;
+#endif
 		break;
 	case B_DMA_sg:
+#ifdef MCAM_MODE_DMA_SG
 		vq->ops = &mcam_vb2_sg_ops;
 		vq->mem_ops = &vb2_dma_sg_memops;
 		vq->io_modes = VB2_MMAP | VB2_USERPTR;
+		cam->dma_setup = mcam_ctlr_dma_sg;
+		cam->frame_complete = mcam_dma_sg_done;
+#endif
 		break;
 	case B_vmalloc:
+#ifdef MCAM_MODE_VMALLOC
+		tasklet_init(&cam->s_tasklet, mcam_frame_tasklet,
+				(unsigned long) cam);
 		vq->ops = &mcam_vb2_ops;
 		vq->mem_ops = &vb2_vmalloc_memops;
 		vq->buf_struct_size = sizeof(struct mcam_vb_buffer);
 		vq->io_modes = VB2_MMAP;
+		cam->dma_setup = mcam_ctlr_dma_vmalloc;
+		cam->frame_complete = mcam_vmalloc_done;
+#endif
 		break;
 	}
 	return vb2_queue_init(vq);
@@ -1055,8 +1119,10 @@ static int mcam_setup_vb2(struct mcam_camera *cam)
 static void mcam_cleanup_vb2(struct mcam_camera *cam)
 {
 	vb2_queue_release(&cam->vb_queue);
+#ifdef MCAM_MODE_DMA_CONTIG
 	if (cam->buffer_mode == B_DMA_contig)
 		vb2_dma_contig_cleanup_ctx(cam->vb_alloc_ctx);
+#endif
 }
 
 
@@ -1258,15 +1324,10 @@ static int mcam_vidioc_s_fmt_vid_cap(struct file *filp, void *priv,
 	/*
 	 * Make sure we have appropriate DMA buffers.
 	 */
-	ret = -ENOMEM;
 	if (cam->buffer_mode == B_vmalloc) {
-		if (cam->nbufs > 0 &&
-				cam->dma_buf_size < cam->pix_format.sizeimage)
-			mcam_free_dma_bufs(cam);
-		if (cam->nbufs == 0) {
-			if (mcam_alloc_dma_bufs(cam, 0))
-				goto out;
-		}
+		ret = mcam_check_dma_buffers(cam);
+		if (ret)
+			goto out;
 	}
 	mcam_set_config_needed(cam, 1);
 	ret = 0;
@@ -1587,17 +1648,7 @@ static void mcam_frame_complete(struct mcam_camera *cam, int frame)
 	/*
 	 * Process the frame and set up the next one.
 	 */
-	switch (cam->buffer_mode) {
-	case B_vmalloc:
-	    tasklet_schedule(&cam->s_tasklet);
-	    break;
-	case B_DMA_contig:
-	    mcam_dma_contig_done(cam, frame);
-	    break;
-	case B_DMA_sg:
-	    mcam_dma_sg_done(cam, frame);
-	    break;
-	}
+	cam->frame_complete(cam, frame);
 }
 
 
@@ -1663,6 +1714,22 @@ int mccic_register(struct mcam_camera *cam)
 	int ret;
 
 	/*
+	 * Validate the requested buffer mode.
+	 */
+	if (buffer_mode >= 0)
+		cam->buffer_mode = buffer_mode;
+	if (cam->buffer_mode == B_DMA_sg &&
+			cam->chip_id == V4L2_IDENT_CAFE) {
+		printk(KERN_ERR "marvell-cam: Cafe can't do S/G I/O, "
+			"attempting vmalloc mode instead\n");
+		cam->buffer_mode = B_vmalloc;
+	}
+	if (!mcam_buffer_mode_supported(cam->buffer_mode)) {
+		printk(KERN_ERR "marvell-cam: buffer mode %d unsupported\n",
+				cam->buffer_mode);
+		return -EINVAL;
+	}
+	/*
 	 * Register with V4L
 	 */
 	ret = v4l2_device_register(cam->dev, &cam->v4l2_dev);
@@ -1676,26 +1743,6 @@ int mccic_register(struct mcam_camera *cam)
 	cam->mbus_code = mcam_def_mbus_code;
 	INIT_LIST_HEAD(&cam->dev_list);
 	INIT_LIST_HEAD(&cam->buffers);
-	tasklet_init(&cam->s_tasklet, mcam_frame_tasklet, (unsigned long) cam);
-	/*
-	 * User space may want to override the asked-for buffer mode;
-	 * here's hoping they know what they're doing.
-	 */
-	if (buffer_mode == 0)
-		cam->buffer_mode = B_vmalloc;
-	else if (buffer_mode == 1)
-		cam->buffer_mode = B_DMA_contig;
-	else if (buffer_mode == 2) {
-		if (cam->chip_id == V4L2_IDENT_ARMADA610)
-			cam->buffer_mode = B_DMA_sg;
-		else {
-			printk(KERN_ERR "marvell-cam: Cafe can't do S/G I/O\n");
-			cam->buffer_mode = B_vmalloc;
-		}
-	} else if (buffer_mode != -1)
-		printk(KERN_ERR "marvell-cam: "
-				"Strange module buffer mode %d - ignoring\n",
-				buffer_mode);
 	mcam_ctlr_init(cam);
 
 	/*
diff --git a/drivers/media/video/marvell-ccic/mcam-core.h b/drivers/media/video/marvell-ccic/mcam-core.h
index 9a39e08..aa55255 100644
--- a/drivers/media/video/marvell-ccic/mcam-core.h
+++ b/drivers/media/video/marvell-ccic/mcam-core.h
@@ -11,6 +11,27 @@
 #include <media/v4l2-dev.h>
 #include <media/videobuf2-core.h>
 
+/*
+ * Create our own symbols for the supported buffer modes, but, for now,
+ * base them entirely on which videobuf2 options have been selected.
+ */
+#if defined(CONFIG_VIDEOBUF2_VMALLOC) || defined(CONFIG_VIDEOBUF2_VMALLOC_MODULE)
+#define MCAM_MODE_VMALLOC 1
+#endif
+
+#if defined(CONFIG_VIDEOBUF2_DMA_CONTIG) || defined(CONFIG_VIDEOBUF2_DMA_CONTIG_MODULE)
+#define MCAM_MODE_DMA_CONTIG 1
+#endif
+
+#if defined(CONFIG_VIDEOBUF2_DMA_SG) || defined(CONFIG_VIDEOBUF2_DMA_SG_MODULE)
+#define MCAM_MODE_DMA_SG 1
+#endif
+
+#if !defined(MCAM_MODE_VMALLOC) && !defined(MCAM_MODE_DMA_CONTIG) && \
+	!defined(MCAM_MODE_DMA_SG)
+#error One of the videobuf buffer modes must be selected in the config
+#endif
+
 
 enum mcam_state {
 	S_NOTREADY,	/* Not yet initialized */
@@ -27,11 +48,33 @@ enum mcam_state {
  */
 enum mcam_buffer_mode {
 	B_vmalloc = 0,
-	B_DMA_contig,
-	B_DMA_sg
+	B_DMA_contig = 1,
+	B_DMA_sg = 2
 };
 
 /*
+ * Is a given buffer mode supported by the current kernel configuration?
+ */
+static inline int mcam_buffer_mode_supported(enum mcam_buffer_mode mode)
+{
+	switch (mode) {
+#ifdef MCAM_MODE_VMALLOC
+	case B_vmalloc:
+#endif
+#ifdef MCAM_MODE_DMA_CONTIG
+	case B_DMA_contig:
+#endif
+#ifdef MCAM_MODE_DMA_SG
+	case B_DMA_sg:
+#endif
+		return 1;
+	default:
+		return 0;
+	}
+}
+
+
+/*
  * A description of one of our devices.
  * Locking: controlled by s_mutex.  Certain fields, however, require
  *          the dev_lock spinlock; they are marked as such by comments.
@@ -79,21 +122,27 @@ struct mcam_camera {
 	struct vb2_queue vb_queue;
 	struct list_head buffers;	/* Available frames */
 
-	/* DMA buffers - vmalloc mode */
 	unsigned int nbufs;		/* How many are alloc'd */
 	int next_buf;			/* Next to consume (dev_lock) */
+
+	/* DMA buffers - vmalloc mode */
+#ifdef MCAM_MODE_VMALLOC
 	unsigned int dma_buf_size;	/* allocated size */
 	void *dma_bufs[MAX_DMA_BUFS];	/* Internal buffer addresses */
 	dma_addr_t dma_handles[MAX_DMA_BUFS]; /* Buffer bus addresses */
+	struct tasklet_struct s_tasklet;
+#endif
 	unsigned int sequence;		/* Frame sequence number */
 	unsigned int buf_seq[MAX_DMA_BUFS]; /* Sequence for individual bufs */
 
-	/* DMA buffers - contiguous DMA mode */
+	/* DMA buffers - DMA modes */
 	struct mcam_vb_buffer *vb_bufs[MAX_DMA_BUFS];
 	struct vb2_alloc_ctx *vb_alloc_ctx;
 	unsigned short last_delivered;
 
-	struct tasklet_struct s_tasklet;
+	/* Mode-specific ops, set at open time */
+	void (*dma_setup)(struct mcam_camera *cam);
+	void (*frame_complete)(struct mcam_camera *cam, int frame);
 
 	/* Current operating parameters */
 	u32 sensor_type;		/* Currently ov7670 only */
-- 
1.7.6

