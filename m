Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:45688 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754200Ab0DAIUe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Apr 2010 04:20:34 -0400
From: hvaibhav@ti.com
To: p.osciak@samsung.com
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH 2/2] mem2mem_testdev: Code cleanup
Date: Thu,  1 Apr 2010 13:50:25 +0530
Message-Id: <1270110025-1854-2-git-send-email-hvaibhav@ti.com>
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vaibhav Hiremath <hvaibhav@ti.com>


Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
---
 drivers/media/video/mem2mem_testdev.c |   58 ++++++++++++++------------------
 1 files changed, 25 insertions(+), 33 deletions(-)

diff --git a/drivers/media/video/mem2mem_testdev.c b/drivers/media/video/mem2mem_testdev.c
index 05630e3..1f35b7e 100644
--- a/drivers/media/video/mem2mem_testdev.c
+++ b/drivers/media/video/mem2mem_testdev.c
@@ -98,11 +98,10 @@ static struct m2mtest_fmt formats[] = {
 };
 
 /* Per-queue, driver-specific private data */
-struct m2mtest_q_data
-{
-	unsigned int		width;
-	unsigned int		height;
-	unsigned int		sizeimage;
+struct m2mtest_q_data {
+	u32			width;
+	u32			height;
+	u32			sizeimage;
 	struct m2mtest_fmt	*fmt;
 };
 
@@ -123,11 +122,10 @@ static struct m2mtest_q_data *get_q_data(enum v4l2_buf_type type)
 		return &q_data[V4L2_M2M_DST];
 	default:
 		BUG();
-		return NULL;
 	}
+	return NULL;
 }
 
-
 #define V4L2_CID_TRANS_TIME_MSEC	V4L2_CID_PRIVATE_BASE
 #define V4L2_CID_TRANS_NUM_BUFS		(V4L2_CID_PRIVATE_BASE + 1)
 
@@ -158,7 +156,7 @@ static struct v4l2_queryctrl m2mtest_ctrls[] = {
 static struct m2mtest_fmt *find_format(struct v4l2_format *f)
 {
 	struct m2mtest_fmt *fmt;
-	unsigned int k;
+	u32 k;
 
 	for (k = 0; k < NUM_FORMATS; k++) {
 		fmt = &formats[k];
@@ -237,12 +235,12 @@ static int device_process(struct m2mtest_ctx *ctx,
 	if (!p_in || !p_out) {
 		v4l2_err(&dev->v4l2_dev,
 			 "Acquiring kernel pointers to buffers failed\n");
-		return 1;
+		return -EFAULT;
 	}
 
 	if (in_buf->vb.size < out_buf->vb.size) {
 		v4l2_err(&dev->v4l2_dev, "Output buffer is too small\n");
-		return 1;
+		return -EINVAL;
 	}
 
 	tile_w = (in_buf->vb.width * (q_data[V4L2_M2M_DST].fmt->depth >> 3))
@@ -361,8 +359,6 @@ static void device_isr(unsigned long priv)
 		spin_unlock_irqrestore(&m2mtest_dev->irqlock, flags);
 		device_run(curr_ctx);
 	}
-
-	return;
 }
 
 
@@ -384,10 +380,7 @@ static int vidioc_querycap(struct file *file, void *priv,
 
 static int enum_fmt(struct v4l2_fmtdesc *f, u32 type)
 {
-	int i, num;
-	struct m2mtest_fmt *fmt;
-
-	num = 0;
+	int i, num = 0;
 
 	for (i = 0; i < NUM_FORMATS; ++i) {
 		if (formats[i].types & type) {
@@ -402,9 +395,9 @@ static int enum_fmt(struct v4l2_fmtdesc *f, u32 type)
 
 	if (i < NUM_FORMATS) {
 		/* Format found */
-		fmt = &formats[i];
-		strncpy(f->description, fmt->name, sizeof(f->description) - 1);
-		f->pixelformat = fmt->fourcc;
+		strncpy(f->description, formats[i].name,
+				sizeof(f->description) - 1);
+		f->pixelformat = formats[i].fourcc;
 		return 0;
 	}
 
@@ -430,6 +423,9 @@ static int vidioc_g_fmt(struct m2mtest_ctx *ctx, struct v4l2_format *f)
 	struct m2mtest_q_data *q_data;
 
 	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
+	if (!vq)
+		return -EINVAL;
+
 	q_data = get_q_data(f->type);
 
 	f->fmt.pix.width	= q_data->width;
@@ -524,9 +520,10 @@ static int vidioc_s_fmt(struct m2mtest_ctx *ctx, struct v4l2_format *f)
 {
 	struct m2mtest_q_data *q_data;
 	struct videobuf_queue *vq;
-	int ret = 0;
 
 	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
+	if (!vq)
+		return -EINVAL;
 	q_data = get_q_data(f->type);
 	if (!q_data)
 		return -EINVAL;
@@ -535,8 +532,8 @@ static int vidioc_s_fmt(struct m2mtest_ctx *ctx, struct v4l2_format *f)
 
 	if (videobuf_queue_is_busy(vq)) {
 		v4l2_err(&ctx->dev->v4l2_dev, "%s queue busy\n", __func__);
-		ret = -EBUSY;
-		goto out;
+		mutex_unlock(&vq->vb_lock);
+		return -EBUSY;
 	}
 
 	q_data->fmt		= find_format(f);
@@ -550,9 +547,7 @@ static int vidioc_s_fmt(struct m2mtest_ctx *ctx, struct v4l2_format *f)
 		"Setting format for type %d, wxh: %dx%d, fmt: %d\n",
 		f->type, q_data->width, q_data->height, q_data->fmt->fourcc);
 
-out:
-	mutex_unlock(&vq->vb_lock);
-	return ret;
+	return 0;
 }
 
 static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
@@ -857,13 +852,9 @@ static int m2mtest_open(struct file *file)
 	struct m2mtest_dev *dev = video_drvdata(file);
 	struct m2mtest_ctx *ctx = NULL;
 
-	atomic_inc(&dev->num_inst);
-
 	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
-	if (!ctx) {
-		atomic_dec(&dev->num_inst);
+	if (!ctx)
 		return -ENOMEM;
-	}
 
 	file->private_data = ctx;
 	ctx->dev = dev;
@@ -872,13 +863,13 @@ static int m2mtest_open(struct file *file)
 	ctx->num_processed = 0;
 
 	ctx->m2m_ctx = v4l2_m2m_ctx_init(ctx, dev->m2m_dev, queue_init);
-
 	if (IS_ERR(ctx->m2m_ctx)) {
 		kfree(ctx);
-		atomic_dec(&dev->num_inst);
 		return PTR_ERR(ctx->m2m_ctx);
 	}
 
+	atomic_inc(&dev->num_inst);
+
 	dprintk(dev, "Created instance %p, m2m_ctx: %p\n", ctx, ctx->m2m_ctx);
 
 	return 0;
@@ -959,6 +950,7 @@ static int m2mtest_probe(struct platform_device *pdev)
 	vfd = video_device_alloc();
 	if (!vfd) {
 		v4l2_err(&dev->v4l2_dev, "Failed to allocate video device\n");
+		ret = -ENOMEM;
 		goto unreg_dev;
 	}
 
@@ -1042,7 +1034,7 @@ static int __init m2mtest_init(void)
 	if (ret)
 		platform_device_unregister(&m2mtest_pdev);
 
-	return 0;
+	return ret;
 }
 
 module_init(m2mtest_init);
-- 
1.6.2.4

