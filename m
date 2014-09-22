Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1406 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbaIVMhj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Sep 2014 08:37:39 -0400
Message-ID: <54201806.2070101@xs4all.nl>
Date: Mon, 22 Sep 2014 14:37:26 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Pawel Osciak <pawel@osciak.com>
Subject: [PATCH] mem2mem_testdev: rename to vim2m.
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is 1) *much* easier to type, and 2) is consistent with vivid
('vi' for virtual). More of such virtual drivers are planned, so keeping
the naming consistent makes sense.

Note that the old module name is retained as a module alias.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/Kconfig                     |   4 +-
 drivers/media/platform/Makefile                    |   2 +-
 .../media/platform/{mem2mem_testdev.c => vim2m.c}  | 221 ++++++++++-----------
 3 files changed, 113 insertions(+), 114 deletions(-)
 rename drivers/media/platform/{mem2mem_testdev.c => vim2m.c} (81%)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index bee9074..4c3e957 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -267,8 +267,8 @@ if V4L_TEST_DRIVERS
 
 source "drivers/media/platform/vivid/Kconfig"
 
-config VIDEO_MEM2MEM_TESTDEV
-	tristate "Virtual test device for mem2mem framework"
+config VIDEO_VIM2M
+	tristate "Virtual Memory-to-Memory Driver"
 	depends on VIDEO_DEV && VIDEO_V4L2
 	select VIDEOBUF2_VMALLOC
 	select V4L2_MEM2MEM_DEV
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 8d3fcfe..a5c61b0 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -17,7 +17,7 @@ obj-$(CONFIG_VIDEO_OMAP3)	+= omap3isp/
 obj-$(CONFIG_VIDEO_VIU) += fsl-viu.o
 
 obj-$(CONFIG_VIDEO_VIVID)		+= vivid/
-obj-$(CONFIG_VIDEO_MEM2MEM_TESTDEV) += mem2mem_testdev.o
+obj-$(CONFIG_VIDEO_VIM2M)		+= vim2m.o
 
 obj-$(CONFIG_VIDEO_TI_VPE)		+= ti-vpe/
 
diff --git a/drivers/media/platform/mem2mem_testdev.c b/drivers/media/platform/vim2m.c
similarity index 81%
rename from drivers/media/platform/mem2mem_testdev.c
rename to drivers/media/platform/vim2m.c
index c1b03cf..87af47a 100644
--- a/drivers/media/platform/mem2mem_testdev.c
+++ b/drivers/media/platform/vim2m.c
@@ -31,12 +31,11 @@
 #include <media/v4l2-event.h>
 #include <media/videobuf2-vmalloc.h>
 
-#define MEM2MEM_TEST_MODULE_NAME "mem2mem-testdev"
-
 MODULE_DESCRIPTION("Virtual device for mem2mem framework testing");
 MODULE_AUTHOR("Pawel Osciak, <pawel@osciak.com>");
 MODULE_LICENSE("GPL");
 MODULE_VERSION("0.1.1");
+MODULE_ALIAS("mem2mem_testdev");
 
 static unsigned debug;
 module_param(debug, uint, 0644);
@@ -52,7 +51,7 @@ MODULE_PARM_DESC(debug, "activates debug info");
 #define MEM2MEM_CAPTURE	(1 << 0)
 #define MEM2MEM_OUTPUT	(1 << 1)
 
-#define MEM2MEM_NAME		"m2m-testdev"
+#define MEM2MEM_NAME		"vim2m"
 
 /* Per queue */
 #define MEM2MEM_DEF_NUM_BUFS	VIDEO_MAX_FRAME
@@ -72,15 +71,15 @@ MODULE_PARM_DESC(debug, "activates debug info");
 	v4l2_dbg(1, debug, &dev->v4l2_dev, "%s: " fmt, __func__, ## arg)
 
 
-static void m2mtest_dev_release(struct device *dev)
+static void vim2m_dev_release(struct device *dev)
 {}
 
-static struct platform_device m2mtest_pdev = {
+static struct platform_device vim2m_pdev = {
 	.name		= MEM2MEM_NAME,
-	.dev.release	= m2mtest_dev_release,
+	.dev.release	= vim2m_dev_release,
 };
 
-struct m2mtest_fmt {
+struct vim2m_fmt {
 	char	*name;
 	u32	fourcc;
 	int	depth;
@@ -88,7 +87,7 @@ struct m2mtest_fmt {
 	u32	types;
 };
 
-static struct m2mtest_fmt formats[] = {
+static struct vim2m_fmt formats[] = {
 	{
 		.name	= "RGB565 (BE)",
 		.fourcc	= V4L2_PIX_FMT_RGB565X, /* rrrrrggg gggbbbbb */
@@ -108,12 +107,12 @@ static struct m2mtest_fmt formats[] = {
 #define NUM_FORMATS ARRAY_SIZE(formats)
 
 /* Per-queue, driver-specific private data */
-struct m2mtest_q_data {
+struct vim2m_q_data {
 	unsigned int		width;
 	unsigned int		height;
 	unsigned int		sizeimage;
 	unsigned int		sequence;
-	struct m2mtest_fmt	*fmt;
+	struct vim2m_fmt	*fmt;
 };
 
 enum {
@@ -124,9 +123,9 @@ enum {
 #define V4L2_CID_TRANS_TIME_MSEC	(V4L2_CID_USER_BASE + 0x1000)
 #define V4L2_CID_TRANS_NUM_BUFS		(V4L2_CID_USER_BASE + 0x1001)
 
-static struct m2mtest_fmt *find_format(struct v4l2_format *f)
+static struct vim2m_fmt *find_format(struct v4l2_format *f)
 {
-	struct m2mtest_fmt *fmt;
+	struct vim2m_fmt *fmt;
 	unsigned int k;
 
 	for (k = 0; k < NUM_FORMATS; k++) {
@@ -141,7 +140,7 @@ static struct m2mtest_fmt *find_format(struct v4l2_format *f)
 	return &formats[k];
 }
 
-struct m2mtest_dev {
+struct vim2m_dev {
 	struct v4l2_device	v4l2_dev;
 	struct video_device	*vfd;
 
@@ -154,9 +153,9 @@ struct m2mtest_dev {
 	struct v4l2_m2m_dev	*m2m_dev;
 };
 
-struct m2mtest_ctx {
+struct vim2m_ctx {
 	struct v4l2_fh		fh;
-	struct m2mtest_dev	*dev;
+	struct vim2m_dev	*dev;
 
 	struct v4l2_ctrl_handler hdl;
 
@@ -177,15 +176,15 @@ struct m2mtest_ctx {
 	enum v4l2_colorspace	colorspace;
 
 	/* Source and destination queue data */
-	struct m2mtest_q_data   q_data[2];
+	struct vim2m_q_data   q_data[2];
 };
 
-static inline struct m2mtest_ctx *file2ctx(struct file *file)
+static inline struct vim2m_ctx *file2ctx(struct file *file)
 {
-	return container_of(file->private_data, struct m2mtest_ctx, fh);
+	return container_of(file->private_data, struct vim2m_ctx, fh);
 }
 
-static struct m2mtest_q_data *get_q_data(struct m2mtest_ctx *ctx,
+static struct vim2m_q_data *get_q_data(struct vim2m_ctx *ctx,
 					 enum v4l2_buf_type type)
 {
 	switch (type) {
@@ -200,12 +199,12 @@ static struct m2mtest_q_data *get_q_data(struct m2mtest_ctx *ctx,
 }
 
 
-static int device_process(struct m2mtest_ctx *ctx,
+static int device_process(struct vim2m_ctx *ctx,
 			  struct vb2_buffer *in_vb,
 			  struct vb2_buffer *out_vb)
 {
-	struct m2mtest_dev *dev = ctx->dev;
-	struct m2mtest_q_data *q_data;
+	struct vim2m_dev *dev = ctx->dev;
+	struct vim2m_q_data *q_data;
 	u8 *p_in, *p_out;
 	int x, y, t, w;
 	int tile_w, bytes_left;
@@ -334,7 +333,7 @@ static int device_process(struct m2mtest_ctx *ctx,
 	return 0;
 }
 
-static void schedule_irq(struct m2mtest_dev *dev, int msec_timeout)
+static void schedule_irq(struct vim2m_dev *dev, int msec_timeout)
 {
 	dprintk(dev, "Scheduling a simulated irq\n");
 	mod_timer(&dev->timer, jiffies + msecs_to_jiffies(msec_timeout));
@@ -349,7 +348,7 @@ static void schedule_irq(struct m2mtest_dev *dev, int msec_timeout)
  */
 static int job_ready(void *priv)
 {
-	struct m2mtest_ctx *ctx = priv;
+	struct vim2m_ctx *ctx = priv;
 
 	if (v4l2_m2m_num_src_bufs_ready(ctx->fh.m2m_ctx) < ctx->translen
 	    || v4l2_m2m_num_dst_bufs_ready(ctx->fh.m2m_ctx) < ctx->translen) {
@@ -362,7 +361,7 @@ static int job_ready(void *priv)
 
 static void job_abort(void *priv)
 {
-	struct m2mtest_ctx *ctx = priv;
+	struct vim2m_ctx *ctx = priv;
 
 	/* Will cancel the transaction in the next interrupt handler */
 	ctx->aborting = 1;
@@ -376,8 +375,8 @@ static void job_abort(void *priv)
  */
 static void device_run(void *priv)
 {
-	struct m2mtest_ctx *ctx = priv;
-	struct m2mtest_dev *dev = ctx->dev;
+	struct vim2m_ctx *ctx = priv;
+	struct vim2m_dev *dev = ctx->dev;
 	struct vb2_buffer *src_buf, *dst_buf;
 
 	src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
@@ -391,12 +390,12 @@ static void device_run(void *priv)
 
 static void device_isr(unsigned long priv)
 {
-	struct m2mtest_dev *m2mtest_dev = (struct m2mtest_dev *)priv;
-	struct m2mtest_ctx *curr_ctx;
+	struct vim2m_dev *vim2m_dev = (struct vim2m_dev *)priv;
+	struct vim2m_ctx *curr_ctx;
 	struct vb2_buffer *src_vb, *dst_vb;
 	unsigned long flags;
 
-	curr_ctx = v4l2_m2m_get_curr_priv(m2mtest_dev->m2m_dev);
+	curr_ctx = v4l2_m2m_get_curr_priv(vim2m_dev->m2m_dev);
 
 	if (NULL == curr_ctx) {
 		pr_err("Instance released before the end of transaction\n");
@@ -408,16 +407,16 @@ static void device_isr(unsigned long priv)
 
 	curr_ctx->num_processed++;
 
-	spin_lock_irqsave(&m2mtest_dev->irqlock, flags);
+	spin_lock_irqsave(&vim2m_dev->irqlock, flags);
 	v4l2_m2m_buf_done(src_vb, VB2_BUF_STATE_DONE);
 	v4l2_m2m_buf_done(dst_vb, VB2_BUF_STATE_DONE);
-	spin_unlock_irqrestore(&m2mtest_dev->irqlock, flags);
+	spin_unlock_irqrestore(&vim2m_dev->irqlock, flags);
 
 	if (curr_ctx->num_processed == curr_ctx->translen
 	    || curr_ctx->aborting) {
 		dprintk(curr_ctx->dev, "Finishing transaction\n");
 		curr_ctx->num_processed = 0;
-		v4l2_m2m_job_finish(m2mtest_dev->m2m_dev, curr_ctx->fh.m2m_ctx);
+		v4l2_m2m_job_finish(vim2m_dev->m2m_dev, curr_ctx->fh.m2m_ctx);
 	} else {
 		device_run(curr_ctx);
 	}
@@ -441,7 +440,7 @@ static int vidioc_querycap(struct file *file, void *priv,
 static int enum_fmt(struct v4l2_fmtdesc *f, u32 type)
 {
 	int i, num;
-	struct m2mtest_fmt *fmt;
+	struct vim2m_fmt *fmt;
 
 	num = 0;
 
@@ -480,10 +479,10 @@ static int vidioc_enum_fmt_vid_out(struct file *file, void *priv,
 	return enum_fmt(f, MEM2MEM_OUTPUT);
 }
 
-static int vidioc_g_fmt(struct m2mtest_ctx *ctx, struct v4l2_format *f)
+static int vidioc_g_fmt(struct vim2m_ctx *ctx, struct v4l2_format *f)
 {
 	struct vb2_queue *vq;
-	struct m2mtest_q_data *q_data;
+	struct vim2m_q_data *q_data;
 
 	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
 	if (!vq)
@@ -514,7 +513,7 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 	return vidioc_g_fmt(file2ctx(file), f);
 }
 
-static int vidioc_try_fmt(struct v4l2_format *f, struct m2mtest_fmt *fmt)
+static int vidioc_try_fmt(struct v4l2_format *f, struct vim2m_fmt *fmt)
 {
 	/* V4L2 specification suggests the driver corrects the format struct
 	 * if any of the dimensions is unsupported */
@@ -539,8 +538,8 @@ static int vidioc_try_fmt(struct v4l2_format *f, struct m2mtest_fmt *fmt)
 static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 				  struct v4l2_format *f)
 {
-	struct m2mtest_fmt *fmt;
-	struct m2mtest_ctx *ctx = file2ctx(file);
+	struct vim2m_fmt *fmt;
+	struct vim2m_ctx *ctx = file2ctx(file);
 
 	fmt = find_format(f);
 	if (!fmt) {
@@ -561,8 +560,8 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 static int vidioc_try_fmt_vid_out(struct file *file, void *priv,
 				  struct v4l2_format *f)
 {
-	struct m2mtest_fmt *fmt;
-	struct m2mtest_ctx *ctx = file2ctx(file);
+	struct vim2m_fmt *fmt;
+	struct vim2m_ctx *ctx = file2ctx(file);
 
 	fmt = find_format(f);
 	if (!fmt) {
@@ -581,9 +580,9 @@ static int vidioc_try_fmt_vid_out(struct file *file, void *priv,
 	return vidioc_try_fmt(f, fmt);
 }
 
-static int vidioc_s_fmt(struct m2mtest_ctx *ctx, struct v4l2_format *f)
+static int vidioc_s_fmt(struct vim2m_ctx *ctx, struct v4l2_format *f)
 {
-	struct m2mtest_q_data *q_data;
+	struct vim2m_q_data *q_data;
 	struct vb2_queue *vq;
 
 	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
@@ -627,7 +626,7 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 static int vidioc_s_fmt_vid_out(struct file *file, void *priv,
 				struct v4l2_format *f)
 {
-	struct m2mtest_ctx *ctx = file2ctx(file);
+	struct vim2m_ctx *ctx = file2ctx(file);
 	int ret;
 
 	ret = vidioc_try_fmt_vid_out(file, priv, f);
@@ -640,10 +639,10 @@ static int vidioc_s_fmt_vid_out(struct file *file, void *priv,
 	return ret;
 }
 
-static int m2mtest_s_ctrl(struct v4l2_ctrl *ctrl)
+static int vim2m_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	struct m2mtest_ctx *ctx =
-		container_of(ctrl->handler, struct m2mtest_ctx, hdl);
+	struct vim2m_ctx *ctx =
+		container_of(ctrl->handler, struct vim2m_ctx, hdl);
 
 	switch (ctrl->id) {
 	case V4L2_CID_HFLIP:
@@ -676,12 +675,12 @@ static int m2mtest_s_ctrl(struct v4l2_ctrl *ctrl)
 	return 0;
 }
 
-static const struct v4l2_ctrl_ops m2mtest_ctrl_ops = {
-	.s_ctrl = m2mtest_s_ctrl,
+static const struct v4l2_ctrl_ops vim2m_ctrl_ops = {
+	.s_ctrl = vim2m_s_ctrl,
 };
 
 
-static const struct v4l2_ioctl_ops m2mtest_ioctl_ops = {
+static const struct v4l2_ioctl_ops vim2m_ioctl_ops = {
 	.vidioc_querycap	= vidioc_querycap,
 
 	.vidioc_enum_fmt_vid_cap = vidioc_enum_fmt_vid_cap,
@@ -711,13 +710,13 @@ static const struct v4l2_ioctl_ops m2mtest_ioctl_ops = {
  * Queue operations
  */
 
-static int m2mtest_queue_setup(struct vb2_queue *vq,
+static int vim2m_queue_setup(struct vb2_queue *vq,
 				const struct v4l2_format *fmt,
 				unsigned int *nbuffers, unsigned int *nplanes,
 				unsigned int sizes[], void *alloc_ctxs[])
 {
-	struct m2mtest_ctx *ctx = vb2_get_drv_priv(vq);
-	struct m2mtest_q_data *q_data;
+	struct vim2m_ctx *ctx = vb2_get_drv_priv(vq);
+	struct vim2m_q_data *q_data;
 	unsigned int size, count = *nbuffers;
 
 	q_data = get_q_data(ctx, vq->type);
@@ -741,10 +740,10 @@ static int m2mtest_queue_setup(struct vb2_queue *vq,
 	return 0;
 }
 
-static int m2mtest_buf_prepare(struct vb2_buffer *vb)
+static int vim2m_buf_prepare(struct vb2_buffer *vb)
 {
-	struct m2mtest_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
-	struct m2mtest_q_data *q_data;
+	struct vim2m_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct vim2m_q_data *q_data;
 
 	dprintk(ctx->dev, "type: %d\n", vb->vb2_queue->type);
 
@@ -770,25 +769,25 @@ static int m2mtest_buf_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static void m2mtest_buf_queue(struct vb2_buffer *vb)
+static void vim2m_buf_queue(struct vb2_buffer *vb)
 {
-	struct m2mtest_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct vim2m_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
 
 	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vb);
 }
 
-static int m2mtest_start_streaming(struct vb2_queue *q, unsigned count)
+static int vim2m_start_streaming(struct vb2_queue *q, unsigned count)
 {
-	struct m2mtest_ctx *ctx = vb2_get_drv_priv(q);
-	struct m2mtest_q_data *q_data = get_q_data(ctx, q->type);
+	struct vim2m_ctx *ctx = vb2_get_drv_priv(q);
+	struct vim2m_q_data *q_data = get_q_data(ctx, q->type);
 
 	q_data->sequence = 0;
 	return 0;
 }
 
-static void m2mtest_stop_streaming(struct vb2_queue *q)
+static void vim2m_stop_streaming(struct vb2_queue *q)
 {
-	struct m2mtest_ctx *ctx = vb2_get_drv_priv(q);
+	struct vim2m_ctx *ctx = vb2_get_drv_priv(q);
 	struct vb2_buffer *vb;
 	unsigned long flags;
 
@@ -805,26 +804,26 @@ static void m2mtest_stop_streaming(struct vb2_queue *q)
 	}
 }
 
-static struct vb2_ops m2mtest_qops = {
-	.queue_setup	 = m2mtest_queue_setup,
-	.buf_prepare	 = m2mtest_buf_prepare,
-	.buf_queue	 = m2mtest_buf_queue,
-	.start_streaming = m2mtest_start_streaming,
-	.stop_streaming  = m2mtest_stop_streaming,
+static struct vb2_ops vim2m_qops = {
+	.queue_setup	 = vim2m_queue_setup,
+	.buf_prepare	 = vim2m_buf_prepare,
+	.buf_queue	 = vim2m_buf_queue,
+	.start_streaming = vim2m_start_streaming,
+	.stop_streaming  = vim2m_stop_streaming,
 	.wait_prepare	 = vb2_ops_wait_prepare,
 	.wait_finish	 = vb2_ops_wait_finish,
 };
 
 static int queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *dst_vq)
 {
-	struct m2mtest_ctx *ctx = priv;
+	struct vim2m_ctx *ctx = priv;
 	int ret;
 
 	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
 	src_vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
 	src_vq->drv_priv = ctx;
 	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
-	src_vq->ops = &m2mtest_qops;
+	src_vq->ops = &vim2m_qops;
 	src_vq->mem_ops = &vb2_vmalloc_memops;
 	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	src_vq->lock = &ctx->dev->dev_mutex;
@@ -837,7 +836,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *ds
 	dst_vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
 	dst_vq->drv_priv = ctx;
 	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
-	dst_vq->ops = &m2mtest_qops;
+	dst_vq->ops = &vim2m_qops;
 	dst_vq->mem_ops = &vb2_vmalloc_memops;
 	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	dst_vq->lock = &ctx->dev->dev_mutex;
@@ -845,8 +844,8 @@ static int queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *ds
 	return vb2_queue_init(dst_vq);
 }
 
-static const struct v4l2_ctrl_config m2mtest_ctrl_trans_time_msec = {
-	.ops = &m2mtest_ctrl_ops,
+static const struct v4l2_ctrl_config vim2m_ctrl_trans_time_msec = {
+	.ops = &vim2m_ctrl_ops,
 	.id = V4L2_CID_TRANS_TIME_MSEC,
 	.name = "Transaction Time (msec)",
 	.type = V4L2_CTRL_TYPE_INTEGER,
@@ -856,8 +855,8 @@ static const struct v4l2_ctrl_config m2mtest_ctrl_trans_time_msec = {
 	.step = 1,
 };
 
-static const struct v4l2_ctrl_config m2mtest_ctrl_trans_num_bufs = {
-	.ops = &m2mtest_ctrl_ops,
+static const struct v4l2_ctrl_config vim2m_ctrl_trans_num_bufs = {
+	.ops = &vim2m_ctrl_ops,
 	.id = V4L2_CID_TRANS_NUM_BUFS,
 	.name = "Buffers Per Transaction",
 	.type = V4L2_CTRL_TYPE_INTEGER,
@@ -870,10 +869,10 @@ static const struct v4l2_ctrl_config m2mtest_ctrl_trans_num_bufs = {
 /*
  * File operations
  */
-static int m2mtest_open(struct file *file)
+static int vim2m_open(struct file *file)
 {
-	struct m2mtest_dev *dev = video_drvdata(file);
-	struct m2mtest_ctx *ctx = NULL;
+	struct vim2m_dev *dev = video_drvdata(file);
+	struct vim2m_ctx *ctx = NULL;
 	struct v4l2_ctrl_handler *hdl;
 	int rc = 0;
 
@@ -890,10 +889,10 @@ static int m2mtest_open(struct file *file)
 	ctx->dev = dev;
 	hdl = &ctx->hdl;
 	v4l2_ctrl_handler_init(hdl, 4);
-	v4l2_ctrl_new_std(hdl, &m2mtest_ctrl_ops, V4L2_CID_HFLIP, 0, 1, 1, 0);
-	v4l2_ctrl_new_std(hdl, &m2mtest_ctrl_ops, V4L2_CID_VFLIP, 0, 1, 1, 0);
-	v4l2_ctrl_new_custom(hdl, &m2mtest_ctrl_trans_time_msec, NULL);
-	v4l2_ctrl_new_custom(hdl, &m2mtest_ctrl_trans_num_bufs, NULL);
+	v4l2_ctrl_new_std(hdl, &vim2m_ctrl_ops, V4L2_CID_HFLIP, 0, 1, 1, 0);
+	v4l2_ctrl_new_std(hdl, &vim2m_ctrl_ops, V4L2_CID_VFLIP, 0, 1, 1, 0);
+	v4l2_ctrl_new_custom(hdl, &vim2m_ctrl_trans_time_msec, NULL);
+	v4l2_ctrl_new_custom(hdl, &vim2m_ctrl_trans_num_bufs, NULL);
 	if (hdl->error) {
 		rc = hdl->error;
 		v4l2_ctrl_handler_free(hdl);
@@ -933,10 +932,10 @@ open_unlock:
 	return rc;
 }
 
-static int m2mtest_release(struct file *file)
+static int vim2m_release(struct file *file)
 {
-	struct m2mtest_dev *dev = video_drvdata(file);
-	struct m2mtest_ctx *ctx = file2ctx(file);
+	struct vim2m_dev *dev = video_drvdata(file);
+	struct vim2m_ctx *ctx = file2ctx(file);
 
 	dprintk(dev, "Releasing instance %p\n", ctx);
 
@@ -953,20 +952,20 @@ static int m2mtest_release(struct file *file)
 	return 0;
 }
 
-static const struct v4l2_file_operations m2mtest_fops = {
+static const struct v4l2_file_operations vim2m_fops = {
 	.owner		= THIS_MODULE,
-	.open		= m2mtest_open,
-	.release	= m2mtest_release,
+	.open		= vim2m_open,
+	.release	= vim2m_release,
 	.poll		= v4l2_m2m_fop_poll,
 	.unlocked_ioctl	= video_ioctl2,
 	.mmap		= v4l2_m2m_fop_mmap,
 };
 
-static struct video_device m2mtest_videodev = {
+static struct video_device vim2m_videodev = {
 	.name		= MEM2MEM_NAME,
 	.vfl_dir	= VFL_DIR_M2M,
-	.fops		= &m2mtest_fops,
-	.ioctl_ops	= &m2mtest_ioctl_ops,
+	.fops		= &vim2m_fops,
+	.ioctl_ops	= &vim2m_ioctl_ops,
 	.minor		= -1,
 	.release	= video_device_release,
 };
@@ -977,9 +976,9 @@ static struct v4l2_m2m_ops m2m_ops = {
 	.job_abort	= job_abort,
 };
 
-static int m2mtest_probe(struct platform_device *pdev)
+static int vim2m_probe(struct platform_device *pdev)
 {
-	struct m2mtest_dev *dev;
+	struct vim2m_dev *dev;
 	struct video_device *vfd;
 	int ret;
 
@@ -1003,7 +1002,7 @@ static int m2mtest_probe(struct platform_device *pdev)
 		goto unreg_dev;
 	}
 
-	*vfd = m2mtest_videodev;
+	*vfd = vim2m_videodev;
 	vfd->lock = &dev->dev_mutex;
 	vfd->v4l2_dev = &dev->v4l2_dev;
 
@@ -1014,7 +1013,7 @@ static int m2mtest_probe(struct platform_device *pdev)
 	}
 
 	video_set_drvdata(vfd, dev);
-	snprintf(vfd->name, sizeof(vfd->name), "%s", m2mtest_videodev.name);
+	snprintf(vfd->name, sizeof(vfd->name), "%s", vim2m_videodev.name);
 	dev->vfd = vfd;
 	v4l2_info(&dev->v4l2_dev,
 			"Device registered as /dev/video%d\n", vfd->num);
@@ -1042,11 +1041,11 @@ unreg_dev:
 	return ret;
 }
 
-static int m2mtest_remove(struct platform_device *pdev)
+static int vim2m_remove(struct platform_device *pdev)
 {
-	struct m2mtest_dev *dev = platform_get_drvdata(pdev);
+	struct vim2m_dev *dev = platform_get_drvdata(pdev);
 
-	v4l2_info(&dev->v4l2_dev, "Removing " MEM2MEM_TEST_MODULE_NAME);
+	v4l2_info(&dev->v4l2_dev, "Removing " MEM2MEM_NAME);
 	v4l2_m2m_release(dev->m2m_dev);
 	del_timer_sync(&dev->timer);
 	video_unregister_device(dev->vfd);
@@ -1055,35 +1054,35 @@ static int m2mtest_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static struct platform_driver m2mtest_pdrv = {
-	.probe		= m2mtest_probe,
-	.remove		= m2mtest_remove,
+static struct platform_driver vim2m_pdrv = {
+	.probe		= vim2m_probe,
+	.remove		= vim2m_remove,
 	.driver		= {
 		.name	= MEM2MEM_NAME,
 		.owner	= THIS_MODULE,
 	},
 };
 
-static void __exit m2mtest_exit(void)
+static void __exit vim2m_exit(void)
 {
-	platform_driver_unregister(&m2mtest_pdrv);
-	platform_device_unregister(&m2mtest_pdev);
+	platform_driver_unregister(&vim2m_pdrv);
+	platform_device_unregister(&vim2m_pdev);
 }
 
-static int __init m2mtest_init(void)
+static int __init vim2m_init(void)
 {
 	int ret;
 
-	ret = platform_device_register(&m2mtest_pdev);
+	ret = platform_device_register(&vim2m_pdev);
 	if (ret)
 		return ret;
 
-	ret = platform_driver_register(&m2mtest_pdrv);
+	ret = platform_driver_register(&vim2m_pdrv);
 	if (ret)
-		platform_device_unregister(&m2mtest_pdev);
+		platform_device_unregister(&vim2m_pdev);
 
 	return 0;
 }
 
-module_init(m2mtest_init);
-module_exit(m2mtest_exit);
+module_init(vim2m_init);
+module_exit(vim2m_exit);
-- 
2.1.0

