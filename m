Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:38560 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920Ab1FXUT3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2011 16:19:29 -0400
Date: Fri, 24 Jun 2011 14:19:27 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	'Pawel Osciak' <pawel@osciak.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [RFC] vb2: Push buffer allocation and freeing into drivers
Message-ID: <20110624141927.1c89a033@bike.lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Here's a little something I decided to hack on rather than addressing all
the real work I have to do.

Videobuf2 currently manages buffer allocation for drivers, even though
drivers typically encapsulate the vb2_buffer instance in a larger
structure; that requires vb2 to know the driver's structure size and
imposes a fragile "the vb2_buffer field must be first" requirement.

This patch pushes buffer allocation and freeing down into the drivers,
which is where the real knowledge of the structure layout exists.  To that
end, buffer_init() has been renamed buffer_alloc(), and it is called at
the beginning of the process.  As it happens, no in-tree driver depends on
any kind of central initialization in its buffer_init() function, so this
move causes no problems.

The patch deletes almost as much code as it adds; in particular, error
handling gets simpler.  It's compile-tested on everything I could, and run
tested with vivi and mmp-camera.  The patch is against linuxtv/for_v3.1,
so it doesn't include the mmp-camera hunks (since videobuf2 support for
that driver isn't upstream yet.)

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/media/video/mem2mem_testdev.c       |   20 ++++++++++-
 drivers/media/video/mx3_camera.c            |   19 +++++-----
 drivers/media/video/s5p-fimc/fimc-capture.c |   18 ++++++++--
 drivers/media/video/s5p-fimc/fimc-core.c    |   20 ++++++++++-
 drivers/media/video/sh_mobile_ceu_camera.c  |   20 ++++++-----
 drivers/media/video/videobuf2-core.c        |   49 ++++++---------------------
 drivers/media/video/vivi.c                  |   16 +++++---
 include/media/videobuf2-core.h              |   16 ++++-----
 8 files changed, 98 insertions(+), 80 deletions(-)

diff --git a/drivers/media/video/mem2mem_testdev.c b/drivers/media/video/mem2mem_testdev.c
index b03d74e..05d8f62 100644
--- a/drivers/media/video/mem2mem_testdev.c
+++ b/drivers/media/video/mem2mem_testdev.c
@@ -789,6 +789,22 @@ static int m2mtest_buf_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
+static struct vb2_buffer *m2mtest_buf_alloc(struct vb2_queue *q)
+{
+	struct v4l2_m2m_buffer *buf;
+
+	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
+	if (buf == NULL)
+		return NULL;
+	return &buf->vb;
+}
+
+static void m2mtest_buf_cleanup(struct vb2_buffer *vb)
+{
+	kfree(container_of(vb, struct v4l2_m2m_buffer, vb));
+}
+
+
 static void m2mtest_buf_queue(struct vb2_buffer *vb)
 {
 	struct m2mtest_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
@@ -797,6 +813,8 @@ static void m2mtest_buf_queue(struct vb2_buffer *vb)
 
 static struct vb2_ops m2mtest_qops = {
 	.queue_setup	 = m2mtest_queue_setup,
+	.buf_alloc	 = m2mtest_buf_alloc,
+	.buf_cleanup	 = m2mtest_buf_cleanup,
 	.buf_prepare	 = m2mtest_buf_prepare,
 	.buf_queue	 = m2mtest_buf_queue,
 };
@@ -810,7 +828,6 @@ static int queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *ds
 	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
 	src_vq->io_modes = VB2_MMAP;
 	src_vq->drv_priv = ctx;
-	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 	src_vq->ops = &m2mtest_qops;
 	src_vq->mem_ops = &vb2_vmalloc_memops;
 
@@ -822,7 +839,6 @@ static int queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *ds
 	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	dst_vq->io_modes = VB2_MMAP;
 	dst_vq->drv_priv = ctx;
-	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 	dst_vq->ops = &m2mtest_qops;
 	dst_vq->mem_ops = &vb2_vmalloc_memops;
 
diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
index c7680eb..fc981d4 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -68,7 +68,6 @@ enum csi_buffer_state {
 };
 
 struct mx3_camera_buffer {
-	/* common v4l buffer stuff -- must be first */
 	struct vb2_buffer			vb;
 	enum csi_buffer_state			state;
 	struct list_head			queue;
@@ -374,10 +373,6 @@ static void mx3_videobuf_release(struct vb2_buffer *vb)
 	if (mx3_cam->active == buf)
 		mx3_cam->active = NULL;
 
-	/* Doesn't hurt also if the list is empty */
-	list_del_init(&buf->queue);
-	buf->state = CSI_BUF_NEEDS_INIT;
-
 	if (txd) {
 		buf->txd = NULL;
 		if (mx3_cam->idmac_channel[0])
@@ -385,11 +380,16 @@ static void mx3_videobuf_release(struct vb2_buffer *vb)
 	}
 
 	spin_unlock_irqrestore(&mx3_cam->lock, flags);
+	kfree(buf);
 }
 
-static int mx3_videobuf_init(struct vb2_buffer *vb)
+static struct vb2_buffer *mx3_videobuf_alloc(struct vb2_queue *q)
 {
-	struct mx3_camera_buffer *buf = to_mx3_vb(vb);
+	struct mx3_camera_buffer *buf;
+
+	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
+	if (buf == NULL)
+		return NULL;
 	/* This is for locking debugging only */
 	INIT_LIST_HEAD(&buf->queue);
 	sg_init_table(&buf->sg, 1);
@@ -397,7 +397,7 @@ static int mx3_videobuf_init(struct vb2_buffer *vb)
 	buf->state = CSI_BUF_NEEDS_INIT;
 	buf->txd = NULL;
 
-	return 0;
+	return &buf->vb;
 }
 
 static int mx3_stop_streaming(struct vb2_queue *q)
@@ -434,7 +434,7 @@ static struct vb2_ops mx3_videobuf_ops = {
 	.buf_prepare	= mx3_videobuf_prepare,
 	.buf_queue	= mx3_videobuf_queue,
 	.buf_cleanup	= mx3_videobuf_release,
-	.buf_init	= mx3_videobuf_init,
+	.buf_alloc	= mx3_videobuf_alloc,
 	.wait_prepare	= soc_camera_unlock,
 	.wait_finish	= soc_camera_lock,
 	.stop_streaming	= mx3_stop_streaming,
@@ -448,7 +448,6 @@ static int mx3_camera_init_videobuf(struct vb2_queue *q,
 	q->drv_priv = icd;
 	q->ops = &mx3_videobuf_ops;
 	q->mem_ops = &vb2_dma_contig_memops;
-	q->buf_struct_size = sizeof(struct mx3_camera_buffer);
 
 	return vb2_queue_init(q);
 }
diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index d142b40..0f2b2b7 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -295,10 +295,20 @@ static int queue_setup(struct vb2_queue *vq, unsigned int *num_buffers,
 	return 0;
 }
 
-static int buffer_init(struct vb2_buffer *vb)
+static struct vb2_buffer *buffer_alloc(struct vb2_queue *q)
 {
+	struct fimc_vid_buffer *buf;
+
+	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
+	if (buf == NULL)
+		return NULL;
 	/* TODO: */
-	return 0;
+	return &buf->vb;
+}
+
+static void buffer_cleanup(struct vb2_buffer *buf)
+{
+	kfree(container_of(buf, struct fimc_vid_buffer, vb));
 }
 
 static int buffer_prepare(struct vb2_buffer *vb)
@@ -380,7 +390,8 @@ static struct vb2_ops fimc_capture_qops = {
 	.queue_setup		= queue_setup,
 	.buf_prepare		= buffer_prepare,
 	.buf_queue		= buffer_queue,
-	.buf_init		= buffer_init,
+	.buf_alloc		= buffer_alloc,
+	.buf_cleanup		= buffer_cleanup,
 	.wait_prepare		= fimc_unlock,
 	.wait_finish		= fimc_lock,
 	.start_streaming	= start_streaming,
@@ -882,7 +893,6 @@ int fimc_register_capture_device(struct fimc_dev *fimc)
 	q->drv_priv = fimc->vid_cap.ctx;
 	q->ops = &fimc_capture_qops;
 	q->mem_ops = &vb2_dma_contig_memops;
-	q->buf_struct_size = sizeof(struct fimc_vid_buffer);
 
 	vb2_queue_init(q);
 
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index dc91a85..6810115 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -730,6 +730,22 @@ static int fimc_queue_setup(struct vb2_queue *vq, unsigned int *num_buffers,
 	return 0;
 }
 
+static struct vb2_buffer *fimc_buf_alloc(struct vb2_queue *q)
+{
+	struct v4l2_m2m_buffer *buf;
+
+	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
+	if (buf == NULL)
+		return NULL;
+	return &buf->vb;
+}
+
+static void fimc_buf_cleanup(struct vb2_buffer *vb)
+{
+	kfree(container_of(vb, struct v4l2_m2m_buffer, vb));
+}
+
+
 static int fimc_buf_prepare(struct vb2_buffer *vb)
 {
 	struct fimc_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
@@ -770,6 +786,8 @@ static void fimc_unlock(struct vb2_queue *vq)
 
 static struct vb2_ops fimc_qops = {
 	.queue_setup	 = fimc_queue_setup,
+	.buf_alloc	 = fimc_buf_alloc,
+	.buf_cleanup	 = fimc_buf_cleanup,
 	.buf_prepare	 = fimc_buf_prepare,
 	.buf_queue	 = fimc_buf_queue,
 	.wait_prepare	 = fimc_unlock,
@@ -1390,7 +1408,6 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->drv_priv = ctx;
 	src_vq->ops = &fimc_qops;
 	src_vq->mem_ops = &vb2_dma_contig_memops;
-	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 
 	ret = vb2_queue_init(src_vq);
 	if (ret)
@@ -1402,7 +1419,6 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	dst_vq->drv_priv = ctx;
 	dst_vq->ops = &fimc_qops;
 	dst_vq->mem_ops = &vb2_dma_contig_memops;
-	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 
 	return vb2_queue_init(dst_vq);
 }
diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index 3ae5c9c..1d15dd1 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -88,7 +88,7 @@
 
 /* per video frame buffer */
 struct sh_mobile_ceu_buffer {
-	struct vb2_buffer vb; /* v4l buffer must be first */
+	struct vb2_buffer vb;
 	struct list_head queue;
 	enum v4l2_mbus_pixelcode code;
 };
@@ -421,17 +421,20 @@ static void sh_mobile_ceu_videobuf_release(struct vb2_buffer *vb)
 		pcdev->active = NULL;
 	}
 
-	/* Doesn't hurt also if the list is empty */
-	list_del_init(&buf->queue);
-
 	spin_unlock_irq(&pcdev->lock);
+	kfree(buf);
 }
 
-static int sh_mobile_ceu_videobuf_init(struct vb2_buffer *vb)
+static struct vb2_buffer *sh_mobile_ceu_videobuf_alloc(struct vb2_queue *q)
 {
+	struct sh_mobile_ceu_buffer *buf;
+
+	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
+	if (buf == NULL)
+		return NULL;
 	/* This is for locking debugging only */
-	INIT_LIST_HEAD(&to_ceu_vb(vb)->queue);
-	return 0;
+	INIT_LIST_HEAD(&buf->queue);
+	return &buf->vb;
 }
 
 static int sh_mobile_ceu_stop_streaming(struct vb2_queue *q)
@@ -458,7 +461,7 @@ static struct vb2_ops sh_mobile_ceu_videobuf_ops = {
 	.buf_prepare	= sh_mobile_ceu_videobuf_prepare,
 	.buf_queue	= sh_mobile_ceu_videobuf_queue,
 	.buf_cleanup	= sh_mobile_ceu_videobuf_release,
-	.buf_init	= sh_mobile_ceu_videobuf_init,
+	.buf_alloc	= sh_mobile_ceu_videobuf_alloc,
 	.wait_prepare	= soc_camera_unlock,
 	.wait_finish	= soc_camera_lock,
 	.stop_streaming	= sh_mobile_ceu_stop_streaming,
@@ -1840,7 +1843,6 @@ static int sh_mobile_ceu_init_videobuf(struct vb2_queue *q,
 	q->drv_priv = icd;
 	q->ops = &sh_mobile_ceu_videobuf_ops;
 	q->mem_ops = &vb2_dma_contig_memops;
-	q->buf_struct_size = sizeof(struct sh_mobile_ceu_buffer);
 
 	return vb2_queue_init(q);
 }
diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index 6ba1461..7837b97 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -149,8 +149,12 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum v4l2_memory memory,
 	int ret;
 
 	for (buffer = 0; buffer < num_buffers; ++buffer) {
-		/* Allocate videobuf buffer structures */
-		vb = kzalloc(q->buf_struct_size, GFP_KERNEL);
+		/*
+		 * Allocate videobuf buffer structures
+		 * We *could* default to allocating a bare vb2_buffer
+		 * if the driver hasn't provided its own function.
+		 */
+		vb = call_qop(q, buf_alloc, q);
 		if (!vb) {
 			dprintk(1, "Memory alloc for buffer struct failed\n");
 			break;
@@ -176,19 +180,6 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum v4l2_memory memory,
 				kfree(vb);
 				break;
 			}
-			/*
-			 * Call the driver-provided buffer initialization
-			 * callback, if given. An error in initialization
-			 * results in queue setup failure.
-			 */
-			ret = call_qop(q, buf_init, vb);
-			if (ret) {
-				dprintk(1, "Buffer %d %p initialization"
-					" failed\n", buffer, vb);
-				__vb2_buf_mem_free(vb);
-				kfree(vb);
-				break;
-			}
 		}
 
 		q->bufs[buffer] = vb;
@@ -234,21 +225,14 @@ static void __vb2_queue_free(struct vb2_queue *q)
 {
 	unsigned int buffer;
 
-	/* Call driver-provided cleanup function for each buffer, if provided */
-	if (q->ops->buf_cleanup) {
-		for (buffer = 0; buffer < q->num_buffers; ++buffer) {
-			if (NULL == q->bufs[buffer])
-				continue;
-			q->ops->buf_cleanup(q->bufs[buffer]);
-		}
-	}
-
 	/* Release video buffer memory */
 	__vb2_free_mem(q);
 
 	/* Free videobuf buffers */
 	for (buffer = 0; buffer < q->num_buffers; ++buffer) {
-		kfree(q->bufs[buffer]);
+		if (q->bufs[buffer] == NULL)
+			continue;
+		q->ops->buf_cleanup(q->bufs[buffer]);
 		q->bufs[buffer] = NULL;
 	}
 
@@ -776,16 +760,6 @@ static int __qbuf_userptr(struct vb2_buffer *vb, struct v4l2_buffer *b)
 	}
 
 	/*
-	 * Call driver-specific initialization on the newly acquired buffer,
-	 * if provided.
-	 */
-	ret = call_qop(q, buf_init, vb);
-	if (ret) {
-		dprintk(1, "qbuf: buffer initialization failed\n");
-		goto err;
-	}
-
-	/*
 	 * Now that everything is in order, copy relevant information
 	 * provided by userspace.
 	 */
@@ -1442,15 +1416,14 @@ int vb2_queue_init(struct vb2_queue *q)
 
 	BUG_ON(!q->ops->queue_setup);
 	BUG_ON(!q->ops->buf_queue);
+	BUG_ON(!q->ops->buf_alloc);
+	BUG_ON(!q->ops->buf_cleanup);
 
 	INIT_LIST_HEAD(&q->queued_list);
 	INIT_LIST_HEAD(&q->done_list);
 	spin_lock_init(&q->done_lock);
 	init_waitqueue_head(&q->done_wq);
 
-	if (q->buf_struct_size == 0)
-		q->buf_struct_size = sizeof(struct vb2_buffer);
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(vb2_queue_init);
diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index 2238a61..9a1611f 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -138,7 +138,6 @@ static struct vivi_fmt *get_format(struct v4l2_format *f)
 
 /* buffer for one video frame */
 struct vivi_buffer {
-	/* common v4l buffer stuff -- must be first */
 	struct vb2_buffer	vb;
 	struct list_head	list;
 	struct vivi_fmt        *fmt;
@@ -673,9 +672,14 @@ static int queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
 	return 0;
 }
 
-static int buffer_init(struct vb2_buffer *vb)
+static struct vb2_buffer *buffer_alloc(struct vb2_queue *q)
 {
-	struct vivi_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct vivi_buffer *buf;
+	struct vivi_dev *dev = vb2_get_drv_priv(q);
+
+	buf = kzalloc(sizeof(struct vivi_buffer), GFP_KERNEL);
+	if (buf == NULL)
+		return NULL;
 
 	BUG_ON(NULL == dev->fmt);
 
@@ -691,7 +695,7 @@ static int buffer_init(struct vb2_buffer *vb)
 	 * s_fmt though.
 	 */
 
-	return 0;
+	return &buf->vb;
 }
 
 static int buffer_prepare(struct vb2_buffer *vb)
@@ -743,6 +747,7 @@ static void buffer_cleanup(struct vb2_buffer *vb)
 	struct vivi_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
 	dprintk(dev, 1, "%s\n", __func__);
 
+	kfree(container_of(vb, struct vivi_buffer, vb));
 }
 
 static void buffer_queue(struct vb2_buffer *vb)
@@ -790,7 +795,7 @@ static void vivi_unlock(struct vb2_queue *vq)
 
 static struct vb2_ops vivi_video_qops = {
 	.queue_setup		= queue_setup,
-	.buf_init		= buffer_init,
+	.buf_alloc		= buffer_alloc,
 	.buf_prepare		= buffer_prepare,
 	.buf_finish		= buffer_finish,
 	.buf_cleanup		= buffer_cleanup,
@@ -1234,7 +1239,6 @@ static int __init vivi_create_instance(int inst)
 	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_READ;
 	q->drv_priv = dev;
-	q->buf_struct_size = sizeof(struct vivi_buffer);
 	q->ops = &vivi_video_qops;
 	q->mem_ops = &vb2_vmalloc_memops;
 
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index f87472a..957240b 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -184,11 +184,11 @@ struct vb2_buffer {
  * @wait_finish:	reacquire all locks released in the previous callback;
  *			required to continue operation after sleeping while
  *			waiting for a new buffer to arrive
- * @buf_init:		called once after allocating a buffer (in MMAP case)
- *			or after acquiring a new USERPTR buffer; drivers may
- *			perform additional buffer-related initialization;
- *			initialization failure (return != 0) will prevent
- *			queue setup from completing successfully; optional
+ * @buf_alloc:		Called once to allocate each new buffer; should
+ *			perform any driver-specific initialization and
+ *			return a pointer to the (possibly encapsulated)
+ *			vb2_buffer structure.  Returning NULL here will
+ *			abort queue setup.
  * @buf_prepare:	called every time the buffer is queued from userspace;
  *			drivers may perform any initialization required before
  *			each hardware operation in this callback;
@@ -197,8 +197,7 @@ struct vb2_buffer {
  * @buf_finish:		called before every dequeue of the buffer back to
  *			userspace; drivers may perform any operations required
  *			before userspace accesses the buffer; optional
- * @buf_cleanup:	called once before the buffer is freed; drivers may
- *			perform any additional cleanup; optional
+ * @buf_cleanup:	called once to clean up and free each buffer.
  * @start_streaming:	called once before entering 'streaming' state; enables
  *			driver to receive buffers over buf_queue() callback
  * @stop_streaming:	called when 'streaming' state must be disabled; driver
@@ -217,7 +216,7 @@ struct vb2_ops {
 	void (*wait_prepare)(struct vb2_queue *q);
 	void (*wait_finish)(struct vb2_queue *q);
 
-	int (*buf_init)(struct vb2_buffer *vb);
+	struct vb2_buffer *(*buf_alloc)(struct vb2_queue *q);
 	int (*buf_prepare)(struct vb2_buffer *vb);
 	int (*buf_finish)(struct vb2_buffer *vb);
 	void (*buf_cleanup)(struct vb2_buffer *vb);
@@ -261,7 +260,6 @@ struct vb2_queue {
 	const struct vb2_ops		*ops;
 	const struct vb2_mem_ops	*mem_ops;
 	void				*drv_priv;
-	unsigned int			buf_struct_size;
 
 /* private: internal use only */
 	enum v4l2_memory		memory;
-- 
1.7.5.4

