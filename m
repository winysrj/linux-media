Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:50082 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933681AbbDYPnh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Apr 2015 11:43:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 09/12] dt3155v4l: drop CONFIG_DT3155_CCIR, use s_std instead
Date: Sat, 25 Apr 2015 17:42:48 +0200
Message-Id: <1429976571-34872-10-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1429976571-34872-1-git-send-email-hverkuil@xs4all.nl>
References: <1429976571-34872-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

There is no need for CONFIG_DT3155_CCIR to select between 50/60 Hz,
that's why we have s_std.

Since this is a simple framegrabber there is no need for g/s_parm.
The frame period can be obtained via ENUMSTD instead.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/dt3155v4l/Kconfig     |   8 --
 drivers/staging/media/dt3155v4l/dt3155v4l.c | 132 ++++++++++------------------
 drivers/staging/media/dt3155v4l/dt3155v4l.h |  17 ++--
 3 files changed, 54 insertions(+), 103 deletions(-)

diff --git a/drivers/staging/media/dt3155v4l/Kconfig b/drivers/staging/media/dt3155v4l/Kconfig
index fcba866..fcbcba6 100644
--- a/drivers/staging/media/dt3155v4l/Kconfig
+++ b/drivers/staging/media/dt3155v4l/Kconfig
@@ -11,11 +11,3 @@ config VIDEO_DT3155
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called dt3155v4l.
-
-config DT3155_CCIR
-	bool "Selects CCIR/50Hz vertical refresh"
-	depends on VIDEO_DT3155
-	default y
-	---help---
-	  Select it for CCIR/50Hz (European region),
-	  or leave it unselected for RS-170/60Hz (North America).
diff --git a/drivers/staging/media/dt3155v4l/dt3155v4l.c b/drivers/staging/media/dt3155v4l/dt3155v4l.c
index 0ce7523..f026ab6 100644
--- a/drivers/staging/media/dt3155v4l/dt3155v4l.c
+++ b/drivers/staging/media/dt3155v4l/dt3155v4l.c
@@ -29,43 +29,18 @@
 
 #define DT3155_DEVICE_ID 0x1223
 
-/*  global initializers (for all boards)  */
-#ifdef CONFIG_DT3155_CCIR
-static const u8 csr2_init = VT_50HZ;
-#define DT3155_CURRENT_NORM V4L2_STD_625_50
-static const unsigned int img_width = 768;
-static const unsigned int img_height = 576;
-static const unsigned int frames_per_sec = 25;
 static const struct v4l2_fmtdesc frame_std[] = {
 	{
 	.index = 0,
 	.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
 	.flags = 0,
-	.description = "CCIR/50Hz 8 bits gray",
+	.description = "8-bit Greyscale",
 	.pixelformat = V4L2_PIX_FMT_GREY,
 	},
 };
-#else
-static const u8 csr2_init = VT_60HZ;
-#define DT3155_CURRENT_NORM V4L2_STD_525_60
-static const unsigned int img_width = 640;
-static const unsigned int img_height = 480;
-static const unsigned int frames_per_sec = 30;
-static const struct v4l2_fmtdesc frame_std[] = {
-	{
-	.index = 0,
-	.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
-	.flags = 0,
-	.description = "RS-170/60Hz 8 bits gray",
-	.pixelformat = V4L2_PIX_FMT_GREY,
-	},
-};
-#endif
 
 #define NUM_OF_FORMATS ARRAY_SIZE(frame_std)
 
-static u8 config_init = ACQ_MODE_EVEN;
-
 /**
  * read_i2c_reg - reads an internal i2c register
  *
@@ -175,7 +150,7 @@ dt3155_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 
 {
 	struct dt3155_priv *pd = vb2_get_drv_priv(vq);
-	unsigned size = img_width * img_height;
+	unsigned size = pd->width * pd->height;
 
 	if (vq->num_buffers + *nbuffers < 2)
 		*nbuffers = 2 - vq->num_buffers;
@@ -189,7 +164,9 @@ dt3155_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 
 static int dt3155_buf_prepare(struct vb2_buffer *vb)
 {
-	vb2_set_plane_payload(vb, 0, img_width * img_height);
+	struct dt3155_priv *pd = vb2_get_drv_priv(vb->vb2_queue);
+
+	vb2_set_plane_payload(vb, 0, pd->width * pd->height);
 	return 0;
 }
 
@@ -202,9 +179,9 @@ static int dt3155_start_streaming(struct vb2_queue *q, unsigned count)
 	pd->sequence = 0;
 	dma_addr = vb2_dma_contig_plane_dma_addr(vb, 0);
 	iowrite32(dma_addr, pd->regs + EVEN_DMA_START);
-	iowrite32(dma_addr + img_width, pd->regs + ODD_DMA_START);
-	iowrite32(img_width, pd->regs + EVEN_DMA_STRIDE);
-	iowrite32(img_width, pd->regs + ODD_DMA_STRIDE);
+	iowrite32(dma_addr + pd->width, pd->regs + ODD_DMA_START);
+	iowrite32(pd->width, pd->regs + EVEN_DMA_STRIDE);
+	iowrite32(pd->width, pd->regs + ODD_DMA_STRIDE);
 	/* enable interrupts, clear all irq flags */
 	iowrite32(FLD_START_EN | FLD_END_ODD_EN | FLD_START |
 			FLD_END_EVEN | FLD_END_ODD, pd->regs + INT_CSR);
@@ -315,9 +292,9 @@ static irqreturn_t dt3155_irq_handler_even(int irq, void *dev_id)
 		ipd->curr_buf = ivb;
 		dma_addr = vb2_dma_contig_plane_dma_addr(ivb, 0);
 		iowrite32(dma_addr, ipd->regs + EVEN_DMA_START);
-		iowrite32(dma_addr + img_width, ipd->regs + ODD_DMA_START);
-		iowrite32(img_width, ipd->regs + EVEN_DMA_STRIDE);
-		iowrite32(img_width, ipd->regs + ODD_DMA_STRIDE);
+		iowrite32(dma_addr + ipd->width, ipd->regs + ODD_DMA_START);
+		iowrite32(ipd->width, ipd->regs + EVEN_DMA_STRIDE);
+		iowrite32(ipd->width, ipd->regs + ODD_DMA_STRIDE);
 		mmiowb();
 	}
 
@@ -361,10 +338,12 @@ static int dt3155_enum_fmt_vid_cap(struct file *filp, void *p, struct v4l2_fmtde
 
 static int dt3155_g_fmt_vid_cap(struct file *filp, void *p, struct v4l2_format *f)
 {
+	struct dt3155_priv *pd = video_drvdata(filp);
+
 	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
-	f->fmt.pix.width = img_width;
-	f->fmt.pix.height = img_height;
+	f->fmt.pix.width = pd->width;
+	f->fmt.pix.height = pd->height;
 	f->fmt.pix.pixelformat = V4L2_PIX_FMT_GREY;
 	f->fmt.pix.field = V4L2_FIELD_NONE;
 	f->fmt.pix.bytesperline = f->fmt.pix.width;
@@ -376,10 +355,12 @@ static int dt3155_g_fmt_vid_cap(struct file *filp, void *p, struct v4l2_format *
 
 static int dt3155_try_fmt_vid_cap(struct file *filp, void *p, struct v4l2_format *f)
 {
+	struct dt3155_priv *pd = video_drvdata(filp);
+
 	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
-	if (f->fmt.pix.width == img_width &&
-		f->fmt.pix.height == img_height &&
+	if (f->fmt.pix.width == pd->width &&
+		f->fmt.pix.height == pd->height &&
 		f->fmt.pix.pixelformat == V4L2_PIX_FMT_GREY &&
 		f->fmt.pix.field == V4L2_FIELD_NONE &&
 		f->fmt.pix.bytesperline == f->fmt.pix.width &&
@@ -394,23 +375,33 @@ static int dt3155_s_fmt_vid_cap(struct file *filp, void *p, struct v4l2_format *
 	return dt3155_g_fmt_vid_cap(filp, p, f);
 }
 
-static int dt3155_querystd(struct file *filp, void *p, v4l2_std_id *norm)
-{
-	*norm = DT3155_CURRENT_NORM;
-	return 0;
-}
-
 static int dt3155_g_std(struct file *filp, void *p, v4l2_std_id *norm)
 {
-	*norm = DT3155_CURRENT_NORM;
+	struct dt3155_priv *pd = video_drvdata(filp);
+
+	*norm = pd->std;
 	return 0;
 }
 
 static int dt3155_s_std(struct file *filp, void *p, v4l2_std_id norm)
 {
-	if (norm & DT3155_CURRENT_NORM)
+	struct dt3155_priv *pd = video_drvdata(filp);
+
+	if (pd->std == norm)
 		return 0;
-	return -EINVAL;
+	if (vb2_is_busy(&pd->vidq))
+		return -EBUSY;
+	pd->std = norm;
+	if (pd->std & V4L2_STD_525_60) {
+		pd->csr2 = VT_60HZ;
+		pd->width = 640;
+		pd->height = 480;
+	} else {
+		pd->csr2 = VT_50HZ;
+		pd->width = 768;
+		pd->height = 576;
+	}
+	return 0;
 }
 
 static int dt3155_enum_input(struct file *filp, void *p, struct v4l2_input *input)
@@ -419,13 +410,8 @@ static int dt3155_enum_input(struct file *filp, void *p, struct v4l2_input *inpu
 		return -EINVAL;
 	strcpy(input->name, "Coax in");
 	input->type = V4L2_INPUT_TYPE_CAMERA;
-	/*
-	 * FIXME: input->std = 0 according to v4l2 API
-	 * VIDIOC_G_STD, VIDIOC_S_STD, VIDIOC_QUERYSTD and VIDIOC_ENUMSTD
-	 * should return -EINVAL
-	 */
-	input->std = DT3155_CURRENT_NORM;
-	input->status = 0;/* FIXME: add sync detection & V4L2_IN_ST_NO_H_LOCK */
+	input->std = V4L2_STD_ALL;
+	input->status = 0;
 	return 0;
 }
 
@@ -442,32 +428,6 @@ static int dt3155_s_input(struct file *filp, void *p, unsigned int i)
 	return 0;
 }
 
-static int dt3155_g_parm(struct file *filp, void *p, struct v4l2_streamparm *parms)
-{
-	if (parms->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
-	parms->parm.capture.capability = V4L2_CAP_TIMEPERFRAME;
-	parms->parm.capture.capturemode = 0;
-	parms->parm.capture.timeperframe.numerator = 1001;
-	parms->parm.capture.timeperframe.denominator = frames_per_sec * 1000;
-	parms->parm.capture.extendedmode = 0;
-	parms->parm.capture.readbuffers = 1; /* FIXME: 2 buffers? */
-	return 0;
-}
-
-static int dt3155_s_parm(struct file *filp, void *p, struct v4l2_streamparm *parms)
-{
-	if (parms->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
-	parms->parm.capture.capability = V4L2_CAP_TIMEPERFRAME;
-	parms->parm.capture.capturemode = 0;
-	parms->parm.capture.timeperframe.numerator = 1001;
-	parms->parm.capture.timeperframe.denominator = frames_per_sec * 1000;
-	parms->parm.capture.extendedmode = 0;
-	parms->parm.capture.readbuffers = 1; /* FIXME: 2 buffers? */
-	return 0;
-}
-
 static const struct v4l2_ioctl_ops dt3155_ioctl_ops = {
 	.vidioc_querycap = dt3155_querycap,
 	.vidioc_enum_fmt_vid_cap = dt3155_enum_fmt_vid_cap,
@@ -482,14 +442,11 @@ static const struct v4l2_ioctl_ops dt3155_ioctl_ops = {
 	.vidioc_dqbuf = vb2_ioctl_dqbuf,
 	.vidioc_streamon = vb2_ioctl_streamon,
 	.vidioc_streamoff = vb2_ioctl_streamoff,
-	.vidioc_querystd = dt3155_querystd,
 	.vidioc_g_std = dt3155_g_std,
 	.vidioc_s_std = dt3155_s_std,
 	.vidioc_enum_input = dt3155_enum_input,
 	.vidioc_g_input = dt3155_g_input,
 	.vidioc_s_input = dt3155_s_input,
-	.vidioc_g_parm = dt3155_g_parm,
-	.vidioc_s_parm = dt3155_s_parm,
 };
 
 static int dt3155_init_board(struct dt3155_priv *pd)
@@ -571,7 +528,7 @@ static struct video_device dt3155_vdev = {
 	.ioctl_ops = &dt3155_ioctl_ops,
 	.minor = -1,
 	.release = video_device_release_empty,
-	.tvnorms = DT3155_CURRENT_NORM,
+	.tvnorms = V4L2_STD_ALL,
 };
 
 static int dt3155_probe(struct pci_dev *pdev, const struct pci_device_id *id)
@@ -593,6 +550,10 @@ static int dt3155_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	pd->vdev.v4l2_dev = &pd->v4l2_dev;
 	video_set_drvdata(&pd->vdev, pd);  /* for use in video_fops */
 	pd->pdev = pdev;
+	pd->std = V4L2_STD_625_50;
+	pd->csr2 = VT_50HZ;
+	pd->width = 768;
+	pd->height = 576;
 	INIT_LIST_HEAD(&pd->dmaq);
 	mutex_init(&pd->mux);
 	pd->vdev.lock = &pd->mux; /* for locking v4l2_file_operations */
@@ -615,8 +576,7 @@ static int dt3155_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_v4l2_dev_unreg;
 	}
 	spin_lock_init(&pd->lock);
-	pd->csr2 = csr2_init;
-	pd->config = config_init;
+	pd->config = ACQ_MODE_EVEN;
 	err = pci_enable_device(pdev);
 	if (err)
 		goto err_free_ctx;
diff --git a/drivers/staging/media/dt3155v4l/dt3155v4l.h b/drivers/staging/media/dt3155v4l/dt3155v4l.h
index acecf83..75c7281 100644
--- a/drivers/staging/media/dt3155v4l/dt3155v4l.h
+++ b/drivers/staging/media/dt3155v4l/dt3155v4l.h
@@ -152,12 +152,6 @@
 /* DT3155 identificator */
 #define DT3155_ID   0x20
 
-#ifdef CONFIG_DT3155_CCIR
-#define DMA_STRIDE 768
-#else
-#define DMA_STRIDE 640
-#endif
-
 /*    per board private data structure   */
 /**
  * struct dt3155_priv - private data structure
@@ -169,9 +163,12 @@
  * @alloc_ctx:		dma_contig allocation context
  * @curr_buf:		pointer to curren buffer
  * @mux:		mutex to protect the instance
- * @dmaq		queue for dma buffers
- * @lock		spinlock for dma queue
- * @sequence		frame counter
+ * @dmaq:		queue for dma buffers
+ * @lock:		spinlock for dma queue
+ * @std:		input standard
+ * @width:		frame width
+ * @height:		frame height
+ * @sequence:		frame counter
  * @stats:		statistics structure
  * @regs:		local copy of mmio base register
  * @csr2:		local copy of csr2 register
@@ -187,6 +184,8 @@ struct dt3155_priv {
 	struct mutex mux;
 	struct list_head dmaq;
 	spinlock_t lock;
+	v4l2_std_id std;
+	unsigned width, height;
 	unsigned int sequence;
 	void __iomem *regs;
 	u8 csr2, config;
-- 
2.1.4

