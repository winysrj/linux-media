Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:52957 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933243AbbDYPne (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Apr 2015 11:43:34 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 06/12] dt3155v4l: move vb2_queue to top-level
Date: Sat, 25 Apr 2015 17:42:45 +0200
Message-Id: <1429976571-34872-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1429976571-34872-1-git-send-email-hverkuil@xs4all.nl>
References: <1429976571-34872-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Instead of initializing the vb2_queue in open (and freeing in release)
do this in probe/remove instead. And as a bonus use the vb2 helper
functions to greatly simplify the driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/dt3155v4l/dt3155v4l.c | 233 +++++++---------------------
 drivers/staging/media/dt3155v4l/dt3155v4l.h |   8 +-
 2 files changed, 57 insertions(+), 184 deletions(-)

diff --git a/drivers/staging/media/dt3155v4l/dt3155v4l.c b/drivers/staging/media/dt3155v4l/dt3155v4l.c
index 28b649d..6d571f6 100644
--- a/drivers/staging/media/dt3155v4l/dt3155v4l.c
+++ b/drivers/staging/media/dt3155v4l/dt3155v4l.c
@@ -201,41 +201,24 @@ static int dt3155_start_acq(struct dt3155_priv *pd)
 }
 
 static int
-dt3155_queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
-		unsigned int *num_buffers, unsigned int *num_planes,
+dt3155_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+		unsigned int *nbuffers, unsigned int *num_planes,
 		unsigned int sizes[], void *alloc_ctxs[])
 
 {
-	struct dt3155_priv *pd = vb2_get_drv_priv(q);
-	void *ret;
+	struct dt3155_priv *pd = vb2_get_drv_priv(vq);
+	unsigned size = img_width * img_height;
 
-	if (*num_buffers == 0)
-		*num_buffers = 1;
+	if (vq->num_buffers + *nbuffers < 2)
+		*nbuffers = 2 - vq->num_buffers;
+	if (fmt && fmt->fmt.pix.sizeimage < size)
+		return -EINVAL;
 	*num_planes = 1;
-	sizes[0] = img_width * img_height;
-	if (pd->q->alloc_ctx[0])
-		return 0;
-	ret = vb2_dma_contig_init_ctx(&pd->pdev->dev);
-	if (IS_ERR(ret))
-		return PTR_ERR(ret);
-	pd->q->alloc_ctx[0] = ret;
+	sizes[0] = fmt ? fmt->fmt.pix.sizeimage : size;
+	alloc_ctxs[0] = pd->alloc_ctx;
 	return 0;
 }
 
-static void dt3155_wait_prepare(struct vb2_queue *q)
-{
-	struct dt3155_priv *pd = vb2_get_drv_priv(q);
-
-	mutex_unlock(pd->vdev.lock);
-}
-
-static void dt3155_wait_finish(struct vb2_queue *q)
-{
-	struct dt3155_priv *pd = vb2_get_drv_priv(q);
-
-	mutex_lock(pd->vdev.lock);
-}
-
 static int dt3155_buf_prepare(struct vb2_buffer *vb)
 {
 	vb2_set_plane_payload(vb, 0, img_width * img_height);
@@ -255,6 +238,9 @@ static void dt3155_stop_streaming(struct vb2_queue *q)
 	}
 	spin_unlock_irq(&pd->lock);
 	msleep(45); /* irq hendler will stop the hardware */
+	/* disable all irqs, clear all irq flags */
+	iowrite32(FLD_START | FLD_END_EVEN | FLD_END_ODD,
+					pd->regs + INT_CSR);
 }
 
 static void dt3155_buf_queue(struct vb2_buffer *vb)
@@ -274,8 +260,8 @@ static void dt3155_buf_queue(struct vb2_buffer *vb)
 
 static const struct vb2_ops q_ops = {
 	.queue_setup = dt3155_queue_setup,
-	.wait_prepare = dt3155_wait_prepare,
-	.wait_finish = dt3155_wait_finish,
+	.wait_prepare = vb2_ops_wait_prepare,
+	.wait_finish = vb2_ops_wait_finish,
 	.buf_prepare = dt3155_buf_prepare,
 	.stop_streaming = dt3155_stop_streaming,
 	.buf_queue = dt3155_buf_queue,
@@ -313,7 +299,7 @@ static irqreturn_t dt3155_irq_handler_even(int irq, void *dev_id)
 		vb2_buffer_done(ipd->curr_buf, VB2_BUF_STATE_DONE);
 	}
 
-	if (!ipd->q->streaming || list_empty(&ipd->dmaq))
+	if (!ipd->vidq.streaming || list_empty(&ipd->dmaq))
 		goto stop_dma;
 	ivb = list_first_entry(&ipd->dmaq, typeof(*ivb), done_entry);
 	list_del(&ivb->done_entry);
@@ -342,124 +328,16 @@ stop_dma:
 	return IRQ_HANDLED;
 }
 
-static int dt3155_open(struct file *filp)
-{
-	int ret = 0;
-	struct dt3155_priv *pd = video_drvdata(filp);
-
-	if (mutex_lock_interruptible(&pd->mux))
-		return -ERESTARTSYS;
-	if (!pd->users) {
-		pd->q = kzalloc(sizeof(*pd->q), GFP_KERNEL);
-		if (!pd->q) {
-			ret = -ENOMEM;
-			goto err_alloc_queue;
-		}
-		pd->q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-		pd->q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
-		pd->q->io_modes = VB2_READ | VB2_MMAP;
-		pd->q->ops = &q_ops;
-		pd->q->mem_ops = &vb2_dma_contig_memops;
-		pd->q->drv_priv = pd;
-		pd->curr_buf = NULL;
-		pd->field_count = 0;
-		ret = vb2_queue_init(pd->q);
-		if (ret < 0)
-			goto err_request_irq;
-		INIT_LIST_HEAD(&pd->dmaq);
-		spin_lock_init(&pd->lock);
-		/* disable all irqs, clear all irq flags */
-		iowrite32(FLD_START | FLD_END_EVEN | FLD_END_ODD,
-						pd->regs + INT_CSR);
-	}
-	pd->users++;
-	mutex_unlock(&pd->mux);
-	return 0; /* success */
-err_request_irq:
-	kfree(pd->q);
-	pd->q = NULL;
-err_alloc_queue:
-	mutex_unlock(&pd->mux);
-	return ret;
-}
-
-static int dt3155_release(struct file *filp)
-{
-	struct dt3155_priv *pd = video_drvdata(filp);
-
-	mutex_lock(&pd->mux);
-	pd->users--;
-	BUG_ON(pd->users < 0);
-	if (!pd->users) {
-		vb2_queue_release(pd->q);
-		if (pd->q->alloc_ctx[0])
-			vb2_dma_contig_cleanup_ctx(pd->q->alloc_ctx[0]);
-		kfree(pd->q);
-		pd->q = NULL;
-	}
-	mutex_unlock(&pd->mux);
-	return 0;
-}
-
-static ssize_t dt3155_read(struct file *filp, char __user *user, size_t size, loff_t *loff)
-{
-	struct dt3155_priv *pd = video_drvdata(filp);
-	ssize_t res;
-
-	if (mutex_lock_interruptible(&pd->mux))
-		return -ERESTARTSYS;
-	res = vb2_read(pd->q, user, size, loff, filp->f_flags & O_NONBLOCK);
-	mutex_unlock(&pd->mux);
-	return res;
-}
-
-static unsigned int dt3155_poll(struct file *filp, struct poll_table_struct *polltbl)
-{
-	struct dt3155_priv *pd = video_drvdata(filp);
-	unsigned int res;
-
-	mutex_lock(&pd->mux);
-	res = vb2_poll(pd->q, filp, polltbl);
-	mutex_unlock(&pd->mux);
-	return res;
-}
-
-static int dt3155_mmap(struct file *filp, struct vm_area_struct *vma)
-{
-	struct dt3155_priv *pd = video_drvdata(filp);
-	int res;
-
-	if (mutex_lock_interruptible(&pd->mux))
-		return -ERESTARTSYS;
-	res = vb2_mmap(pd->q, vma);
-	mutex_unlock(&pd->mux);
-	return res;
-}
-
 static const struct v4l2_file_operations dt3155_fops = {
 	.owner = THIS_MODULE,
-	.open = dt3155_open,
-	.release = dt3155_release,
-	.read = dt3155_read,
-	.poll = dt3155_poll,
-	.unlocked_ioctl = video_ioctl2, /* V4L2 ioctl handler */
-	.mmap = dt3155_mmap,
+	.open = v4l2_fh_open,
+	.release = vb2_fop_release,
+	.unlocked_ioctl = video_ioctl2,
+	.read = vb2_fop_read,
+	.mmap = vb2_fop_mmap,
+	.poll = vb2_fop_poll
 };
 
-static int dt3155_streamon(struct file *filp, void *p, enum v4l2_buf_type type)
-{
-	struct dt3155_priv *pd = video_drvdata(filp);
-
-	return vb2_streamon(pd->q, type);
-}
-
-static int dt3155_streamoff(struct file *filp, void *p, enum v4l2_buf_type type)
-{
-	struct dt3155_priv *pd = video_drvdata(filp);
-
-	return vb2_streamoff(pd->q, type);
-}
-
 static int dt3155_querycap(struct file *filp, void *p, struct v4l2_capability *cap)
 {
 	struct dt3155_priv *pd = video_drvdata(filp);
@@ -516,34 +394,6 @@ static int dt3155_s_fmt_vid_cap(struct file *filp, void *p, struct v4l2_format *
 	return dt3155_g_fmt_vid_cap(filp, p, f);
 }
 
-static int dt3155_reqbufs(struct file *filp, void *p, struct v4l2_requestbuffers *b)
-{
-	struct dt3155_priv *pd = video_drvdata(filp);
-
-	return vb2_reqbufs(pd->q, b);
-}
-
-static int dt3155_querybuf(struct file *filp, void *p, struct v4l2_buffer *b)
-{
-	struct dt3155_priv *pd = video_drvdata(filp);
-
-	return vb2_querybuf(pd->q, b);
-}
-
-static int dt3155_qbuf(struct file *filp, void *p, struct v4l2_buffer *b)
-{
-	struct dt3155_priv *pd = video_drvdata(filp);
-
-	return vb2_qbuf(pd->q, b);
-}
-
-static int dt3155_dqbuf(struct file *filp, void *p, struct v4l2_buffer *b)
-{
-	struct dt3155_priv *pd = video_drvdata(filp);
-
-	return vb2_dqbuf(pd->q, b, filp->f_flags & O_NONBLOCK);
-}
-
 static int dt3155_querystd(struct file *filp, void *p, v4l2_std_id *norm)
 {
 	*norm = DT3155_CURRENT_NORM;
@@ -619,17 +469,19 @@ static int dt3155_s_parm(struct file *filp, void *p, struct v4l2_streamparm *par
 }
 
 static const struct v4l2_ioctl_ops dt3155_ioctl_ops = {
-	.vidioc_streamon = dt3155_streamon,
-	.vidioc_streamoff = dt3155_streamoff,
 	.vidioc_querycap = dt3155_querycap,
 	.vidioc_enum_fmt_vid_cap = dt3155_enum_fmt_vid_cap,
 	.vidioc_try_fmt_vid_cap = dt3155_try_fmt_vid_cap,
 	.vidioc_g_fmt_vid_cap = dt3155_g_fmt_vid_cap,
 	.vidioc_s_fmt_vid_cap = dt3155_s_fmt_vid_cap,
-	.vidioc_reqbufs = dt3155_reqbufs,
-	.vidioc_querybuf = dt3155_querybuf,
-	.vidioc_qbuf = dt3155_qbuf,
-	.vidioc_dqbuf = dt3155_dqbuf,
+	.vidioc_reqbufs = vb2_ioctl_reqbufs,
+	.vidioc_create_bufs = vb2_ioctl_create_bufs,
+	.vidioc_querybuf = vb2_ioctl_querybuf,
+	.vidioc_expbuf = vb2_ioctl_expbuf,
+	.vidioc_qbuf = vb2_ioctl_qbuf,
+	.vidioc_dqbuf = vb2_ioctl_dqbuf,
+	.vidioc_streamon = vb2_ioctl_streamon,
+	.vidioc_streamoff = vb2_ioctl_streamoff,
 	.vidioc_querystd = dt3155_querystd,
 	.vidioc_g_std = dt3155_g_std,
 	.vidioc_s_std = dt3155_s_std,
@@ -740,17 +592,34 @@ static int dt3155_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	pd->vdev = dt3155_vdev;
 	pd->vdev.v4l2_dev = &pd->v4l2_dev;
 	video_set_drvdata(&pd->vdev, pd);  /* for use in video_fops */
-	pd->users = 0;
 	pd->pdev = pdev;
 	INIT_LIST_HEAD(&pd->dmaq);
 	mutex_init(&pd->mux);
 	pd->vdev.lock = &pd->mux; /* for locking v4l2_file_operations */
+	pd->vidq.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	pd->vidq.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	pd->vidq.io_modes = VB2_MMAP | VB2_DMABUF | VB2_READ;
+	pd->vidq.ops = &q_ops;
+	pd->vidq.mem_ops = &vb2_dma_contig_memops;
+	pd->vidq.drv_priv = pd;
+	pd->vidq.min_buffers_needed = 2;
+	pd->vidq.lock = &pd->mux; /* for locking v4l2_file_operations */
+	pd->vdev.queue = &pd->vidq;
+	err = vb2_queue_init(&pd->vidq);
+	if (err < 0)
+		goto err_v4l2_dev_unreg;
+	pd->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
+	if (IS_ERR(pd->alloc_ctx)) {
+		dev_err(&pdev->dev, "Can't allocate buffer context");
+		err = PTR_ERR(pd->alloc_ctx);
+		goto err_v4l2_dev_unreg;
+	}
 	spin_lock_init(&pd->lock);
 	pd->csr2 = csr2_init;
 	pd->config = config_init;
 	err = pci_enable_device(pdev);
 	if (err)
-		goto err_v4l2_dev_unreg;
+		goto err_free_ctx;
 	err = pci_request_region(pdev, 0, pci_name(pdev));
 	if (err)
 		goto err_pci_disable;
@@ -780,6 +649,8 @@ err_free_reg:
 	pci_release_region(pdev, 0);
 err_pci_disable:
 	pci_disable_device(pdev);
+err_free_ctx:
+	vb2_dma_contig_cleanup_ctx(pd->alloc_ctx);
 err_v4l2_dev_unreg:
 	v4l2_device_unregister(&pd->v4l2_dev);
 	return err;
@@ -792,10 +663,12 @@ static void dt3155_remove(struct pci_dev *pdev)
 
 	video_unregister_device(&pd->vdev);
 	free_irq(pd->pdev->irq, pd);
+	vb2_queue_release(&pd->vidq);
 	v4l2_device_unregister(&pd->v4l2_dev);
 	pci_iounmap(pdev, pd->regs);
 	pci_release_region(pdev, 0);
 	pci_disable_device(pdev);
+	vb2_dma_contig_cleanup_ctx(pd->alloc_ctx);
 }
 
 static const struct pci_device_id pci_ids[] = {
diff --git a/drivers/staging/media/dt3155v4l/dt3155v4l.h b/drivers/staging/media/dt3155v4l/dt3155v4l.h
index 3c8073a..11a8146 100644
--- a/drivers/staging/media/dt3155v4l/dt3155v4l.h
+++ b/drivers/staging/media/dt3155v4l/dt3155v4l.h
@@ -165,14 +165,14 @@
  * @v4l2_dev:		v4l2_device structure
  * @vdev:		video_device structure
  * @pdev:		pointer to pci_dev structure
- * @q			pointer to vb2_queue structure
+ * @vidq:		vb2_queue structure
+ * @alloc_ctx:		dma_contig allocation context
  * @curr_buf:		pointer to curren buffer
  * @mux:		mutex to protect the instance
  * @dmaq		queue for dma buffers
  * @lock		spinlock for dma queue
  * @field_count		fields counter
  * @stats:		statistics structure
- * @users		open count
  * @regs:		local copy of mmio base register
  * @csr2:		local copy of csr2 register
  * @config:		local copy of config register
@@ -181,14 +181,14 @@ struct dt3155_priv {
 	struct v4l2_device v4l2_dev;
 	struct video_device vdev;
 	struct pci_dev *pdev;
-	struct vb2_queue *q;
+	struct vb2_queue vidq;
+	struct vb2_alloc_ctx *alloc_ctx;
 	struct vb2_buffer *curr_buf;
 	struct mutex mux;
 	struct list_head dmaq;
 	spinlock_t lock;
 	unsigned int field_count;
 	void __iomem *regs;
-	int users;
 	u8 csr2, config;
 };
 
-- 
2.1.4

