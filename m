Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:21746 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab2GSMAx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jul 2012 08:00:53 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [RFC PATCH 1/6] mem2mem_testdev: convert to the control framework and v4l2_fh.
Date: Thu, 19 Jul 2012 14:00:19 +0200
Message-Id: <903c0da0d6e7354d6f884f0ddec783143165e54c.1342699069.git.hans.verkuil@cisco.com>
In-Reply-To: <1342699224-12642-1-git-send-email-hans.verkuil@cisco.com>
References: <1342699224-12642-1-git-send-email-hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/mem2mem_testdev.c |  234 ++++++++++++---------------------
 1 file changed, 83 insertions(+), 151 deletions(-)

diff --git a/drivers/media/video/mem2mem_testdev.c b/drivers/media/video/mem2mem_testdev.c
index f08cf38..a1d5c15 100644
--- a/drivers/media/video/mem2mem_testdev.c
+++ b/drivers/media/video/mem2mem_testdev.c
@@ -27,6 +27,7 @@
 #include <media/v4l2-mem2mem.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-ctrls.h>
 #include <media/videobuf2-vmalloc.h>
 
 #define MEM2MEM_TEST_MODULE_NAME "mem2mem-testdev"
@@ -101,6 +102,8 @@ static struct m2mtest_fmt formats[] = {
 	},
 };
 
+#define NUM_FORMATS ARRAY_SIZE(formats)
+
 /* Per-queue, driver-specific private data */
 struct m2mtest_q_data {
 	unsigned int		width;
@@ -114,50 +117,8 @@ enum {
 	V4L2_M2M_DST = 1,
 };
 
-#define V4L2_CID_TRANS_TIME_MSEC	V4L2_CID_PRIVATE_BASE
-#define V4L2_CID_TRANS_NUM_BUFS		(V4L2_CID_PRIVATE_BASE + 1)
-
-static struct v4l2_queryctrl m2mtest_ctrls[] = {
-	{
-		.id		= V4L2_CID_HFLIP,
-		.type		= V4L2_CTRL_TYPE_BOOLEAN,
-		.name		= "Mirror",
-		.minimum	= 0,
-		.maximum	= 1,
-		.step		= 1,
-		.default_value	= 0,
-		.flags		= 0,
-	}, {
-		.id		= V4L2_CID_VFLIP,
-		.type		= V4L2_CTRL_TYPE_BOOLEAN,
-		.name		= "Vertical Mirror",
-		.minimum	= 0,
-		.maximum	= 1,
-		.step		= 1,
-		.default_value	= 0,
-		.flags		= 0,
-	}, {
-		.id		= V4L2_CID_TRANS_TIME_MSEC,
-		.type		= V4L2_CTRL_TYPE_INTEGER,
-		.name		= "Transaction time (msec)",
-		.minimum	= 1,
-		.maximum	= 10000,
-		.step		= 100,
-		.default_value	= 1000,
-		.flags		= 0,
-	}, {
-		.id		= V4L2_CID_TRANS_NUM_BUFS,
-		.type		= V4L2_CTRL_TYPE_INTEGER,
-		.name		= "Buffers per transaction",
-		.minimum	= 1,
-		.maximum	= MEM2MEM_DEF_NUM_BUFS,
-		.step		= 1,
-		.default_value	= 1,
-		.flags		= 0,
-	},
-};
-
-#define NUM_FORMATS ARRAY_SIZE(formats)
+#define V4L2_CID_TRANS_TIME_MSEC	(V4L2_CID_USER_BASE + 0x1000)
+#define V4L2_CID_TRANS_NUM_BUFS		(V4L2_CID_USER_BASE + 0x1001)
 
 static struct m2mtest_fmt *find_format(struct v4l2_format *f)
 {
@@ -190,8 +151,11 @@ struct m2mtest_dev {
 };
 
 struct m2mtest_ctx {
+	struct v4l2_fh		fh;
 	struct m2mtest_dev	*dev;
 
+	struct v4l2_ctrl_handler hdl;
+
 	/* Processed buffers in this transaction */
 	u8			num_processed;
 
@@ -212,6 +176,11 @@ struct m2mtest_ctx {
 	struct m2mtest_q_data   q_data[2];
 };
 
+static inline struct m2mtest_ctx *file2ctx(struct file *file)
+{
+	return container_of(file->private_data, struct m2mtest_ctx, fh);
+}
+
 static struct m2mtest_q_data *get_q_data(struct m2mtest_ctx *ctx,
 					 enum v4l2_buf_type type)
 {
@@ -227,18 +196,6 @@ static struct m2mtest_q_data *get_q_data(struct m2mtest_ctx *ctx,
 }
 
 
-static struct v4l2_queryctrl *get_ctrl(int id)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(m2mtest_ctrls); ++i) {
-		if (id == m2mtest_ctrls[i].id)
-			return &m2mtest_ctrls[i];
-	}
-
-	return NULL;
-}
-
 static int device_process(struct m2mtest_ctx *ctx,
 			  struct vb2_buffer *in_vb,
 			  struct vb2_buffer *out_vb)
@@ -543,13 +500,13 @@ static int vidioc_g_fmt(struct m2mtest_ctx *ctx, struct v4l2_format *f)
 static int vidioc_g_fmt_vid_out(struct file *file, void *priv,
 				struct v4l2_format *f)
 {
-	return vidioc_g_fmt(priv, f);
+	return vidioc_g_fmt(file2ctx(file), f);
 }
 
 static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 				struct v4l2_format *f)
 {
-	return vidioc_g_fmt(priv, f);
+	return vidioc_g_fmt(file2ctx(file), f);
 }
 
 static int vidioc_try_fmt(struct v4l2_format *f, struct m2mtest_fmt *fmt)
@@ -588,7 +545,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 				  struct v4l2_format *f)
 {
 	struct m2mtest_fmt *fmt;
-	struct m2mtest_ctx *ctx = priv;
+	struct m2mtest_ctx *ctx = file2ctx(file);
 
 	fmt = find_format(f);
 	if (!fmt || !(fmt->types & MEM2MEM_CAPTURE)) {
@@ -605,7 +562,7 @@ static int vidioc_try_fmt_vid_out(struct file *file, void *priv,
 				  struct v4l2_format *f)
 {
 	struct m2mtest_fmt *fmt;
-	struct m2mtest_ctx *ctx = priv;
+	struct m2mtest_ctx *ctx = file2ctx(file);
 
 	fmt = find_format(f);
 	if (!fmt || !(fmt->types & MEM2MEM_OUTPUT)) {
@@ -658,7 +615,7 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 	if (ret)
 		return ret;
 
-	return vidioc_s_fmt(priv, f);
+	return vidioc_s_fmt(file2ctx(file), f);
 }
 
 static int vidioc_s_fmt_vid_out(struct file *file, void *priv,
@@ -670,13 +627,13 @@ static int vidioc_s_fmt_vid_out(struct file *file, void *priv,
 	if (ret)
 		return ret;
 
-	return vidioc_s_fmt(priv, f);
+	return vidioc_s_fmt(file2ctx(file), f);
 }
 
 static int vidioc_reqbufs(struct file *file, void *priv,
 			  struct v4l2_requestbuffers *reqbufs)
 {
-	struct m2mtest_ctx *ctx = priv;
+	struct m2mtest_ctx *ctx = file2ctx(file);
 
 	return v4l2_m2m_reqbufs(file, ctx->m2m_ctx, reqbufs);
 }
@@ -684,21 +641,21 @@ static int vidioc_reqbufs(struct file *file, void *priv,
 static int vidioc_querybuf(struct file *file, void *priv,
 			   struct v4l2_buffer *buf)
 {
-	struct m2mtest_ctx *ctx = priv;
+	struct m2mtest_ctx *ctx = file2ctx(file);
 
 	return v4l2_m2m_querybuf(file, ctx->m2m_ctx, buf);
 }
 
 static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 {
-	struct m2mtest_ctx *ctx = priv;
+	struct m2mtest_ctx *ctx = file2ctx(file);
 
 	return v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
 }
 
 static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 {
-	struct m2mtest_ctx *ctx = priv;
+	struct m2mtest_ctx *ctx = file2ctx(file);
 
 	return v4l2_m2m_dqbuf(file, ctx->m2m_ctx, buf);
 }
@@ -706,7 +663,7 @@ static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 static int vidioc_streamon(struct file *file, void *priv,
 			   enum v4l2_buf_type type)
 {
-	struct m2mtest_ctx *ctx = priv;
+	struct m2mtest_ctx *ctx = file2ctx(file);
 
 	return v4l2_m2m_streamon(file, ctx->m2m_ctx, type);
 }
@@ -714,101 +671,37 @@ static int vidioc_streamon(struct file *file, void *priv,
 static int vidioc_streamoff(struct file *file, void *priv,
 			    enum v4l2_buf_type type)
 {
-	struct m2mtest_ctx *ctx = priv;
+	struct m2mtest_ctx *ctx = file2ctx(file);
 
 	return v4l2_m2m_streamoff(file, ctx->m2m_ctx, type);
 }
 
-static int vidioc_queryctrl(struct file *file, void *priv,
-			    struct v4l2_queryctrl *qc)
-{
-	struct v4l2_queryctrl *c;
-
-	c = get_ctrl(qc->id);
-	if (!c)
-		return -EINVAL;
-
-	*qc = *c;
-	return 0;
-}
-
-static int vidioc_g_ctrl(struct file *file, void *priv,
-			 struct v4l2_control *ctrl)
-{
-	struct m2mtest_ctx *ctx = priv;
-
-	switch (ctrl->id) {
-	case V4L2_CID_HFLIP:
-		ctrl->value = (ctx->mode & MEM2MEM_HFLIP) ? 1 : 0;
-		break;
-
-	case V4L2_CID_VFLIP:
-		ctrl->value = (ctx->mode & MEM2MEM_VFLIP) ? 1 : 0;
-		break;
-
-	case V4L2_CID_TRANS_TIME_MSEC:
-		ctrl->value = ctx->transtime;
-		break;
-
-	case V4L2_CID_TRANS_NUM_BUFS:
-		ctrl->value = ctx->translen;
-		break;
-
-	default:
-		v4l2_err(&ctx->dev->v4l2_dev, "Invalid control\n");
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-static int check_ctrl_val(struct m2mtest_ctx *ctx, struct v4l2_control *ctrl)
+static int m2mtest_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	struct v4l2_queryctrl *c;
-
-	c = get_ctrl(ctrl->id);
-	if (!c)
-		return -EINVAL;
-
-	if (ctrl->value < c->minimum || ctrl->value > c->maximum) {
-		v4l2_err(&ctx->dev->v4l2_dev, "Value out of range\n");
-		return -ERANGE;
-	}
-
-	return 0;
-}
-
-static int vidioc_s_ctrl(struct file *file, void *priv,
-			 struct v4l2_control *ctrl)
-{
-	struct m2mtest_ctx *ctx = priv;
-	int ret = 0;
-
-	ret = check_ctrl_val(ctx, ctrl);
-	if (ret != 0)
-		return ret;
+	struct m2mtest_ctx *ctx =
+		container_of(ctrl->handler, struct m2mtest_ctx, hdl);
 
 	switch (ctrl->id) {
 	case V4L2_CID_HFLIP:
-		if (ctrl->value)
+		if (ctrl->val)
 			ctx->mode |= MEM2MEM_HFLIP;
 		else
 			ctx->mode &= ~MEM2MEM_HFLIP;
 		break;
 
 	case V4L2_CID_VFLIP:
-		if (ctrl->value)
+		if (ctrl->val)
 			ctx->mode |= MEM2MEM_VFLIP;
 		else
 			ctx->mode &= ~MEM2MEM_VFLIP;
 		break;
 
 	case V4L2_CID_TRANS_TIME_MSEC:
-		ctx->transtime = ctrl->value;
+		ctx->transtime = ctrl->val;
 		break;
 
 	case V4L2_CID_TRANS_NUM_BUFS:
-		ctx->translen = ctrl->value;
+		ctx->translen = ctrl->val;
 		break;
 
 	default:
@@ -819,6 +712,10 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
 	return 0;
 }
 
+static const struct v4l2_ctrl_ops m2mtest_ctrl_ops = {
+	.s_ctrl = m2mtest_s_ctrl,
+};
+
 
 static const struct v4l2_ioctl_ops m2mtest_ioctl_ops = {
 	.vidioc_querycap	= vidioc_querycap,
@@ -841,10 +738,6 @@ static const struct v4l2_ioctl_ops m2mtest_ioctl_ops = {
 
 	.vidioc_streamon	= vidioc_streamon,
 	.vidioc_streamoff	= vidioc_streamoff,
-
-	.vidioc_queryctrl	= vidioc_queryctrl,
-	.vidioc_g_ctrl		= vidioc_g_ctrl,
-	.vidioc_s_ctrl		= vidioc_s_ctrl,
 };
 
 
@@ -956,6 +849,28 @@ static int queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *ds
 	return vb2_queue_init(dst_vq);
 }
 
+static const struct v4l2_ctrl_config m2mtest_ctrl_trans_time_msec = {
+	.ops = &m2mtest_ctrl_ops,
+	.id = V4L2_CID_TRANS_TIME_MSEC,
+	.name = "Transaction Time (msec)",
+	.type = V4L2_CTRL_TYPE_INTEGER,
+	.def = 1001,
+	.min = 1,
+	.max = 10001,
+	.step = 100,
+};
+
+static const struct v4l2_ctrl_config m2mtest_ctrl_trans_num_bufs = {
+	.ops = &m2mtest_ctrl_ops,
+	.id = V4L2_CID_TRANS_NUM_BUFS,
+	.name = "Buffers Per Transaction",
+	.type = V4L2_CTRL_TYPE_INTEGER,
+	.def = 1,
+	.min = 1,
+	.max = MEM2MEM_DEF_NUM_BUFS,
+	.step = 1,
+};
+
 /*
  * File operations
  */
@@ -963,17 +878,29 @@ static int m2mtest_open(struct file *file)
 {
 	struct m2mtest_dev *dev = video_drvdata(file);
 	struct m2mtest_ctx *ctx = NULL;
+	struct v4l2_ctrl_handler *hdl;
 
 	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;
 
-	file->private_data = ctx;
+	v4l2_fh_init(&ctx->fh, video_devdata(file));
+	file->private_data = &ctx->fh;
 	ctx->dev = dev;
-	ctx->translen = MEM2MEM_DEF_TRANSLEN;
-	ctx->transtime = MEM2MEM_DEF_TRANSTIME;
-	ctx->num_processed = 0;
-	ctx->mode = 0;
+	hdl = &ctx->hdl;
+	v4l2_ctrl_handler_init(hdl, 4);
+	v4l2_ctrl_new_std(hdl, &m2mtest_ctrl_ops, V4L2_CID_HFLIP, 0, 1, 1, 0);
+	v4l2_ctrl_new_std(hdl, &m2mtest_ctrl_ops, V4L2_CID_VFLIP, 0, 1, 1, 0);
+	v4l2_ctrl_new_custom(hdl, &m2mtest_ctrl_trans_time_msec, NULL);
+	v4l2_ctrl_new_custom(hdl, &m2mtest_ctrl_trans_num_bufs, NULL);
+	if (hdl->error) {
+		int err = hdl->error;
+
+		v4l2_ctrl_handler_free(hdl);
+		return err;
+	}
+	ctx->fh.ctrl_handler = hdl;
+	v4l2_ctrl_handler_setup(hdl);
 
 	ctx->q_data[V4L2_M2M_SRC].fmt = &formats[0];
 	ctx->q_data[V4L2_M2M_DST].fmt = &formats[0];
@@ -983,10 +910,12 @@ static int m2mtest_open(struct file *file)
 	if (IS_ERR(ctx->m2m_ctx)) {
 		int ret = PTR_ERR(ctx->m2m_ctx);
 
+		v4l2_ctrl_handler_free(hdl);
 		kfree(ctx);
 		return ret;
 	}
 
+	v4l2_fh_add(&ctx->fh);
 	atomic_inc(&dev->num_inst);
 
 	dprintk(dev, "Created instance %p, m2m_ctx: %p\n", ctx, ctx->m2m_ctx);
@@ -997,10 +926,13 @@ static int m2mtest_open(struct file *file)
 static int m2mtest_release(struct file *file)
 {
 	struct m2mtest_dev *dev = video_drvdata(file);
-	struct m2mtest_ctx *ctx = file->private_data;
+	struct m2mtest_ctx *ctx = file2ctx(file);
 
 	dprintk(dev, "Releasing instance %p\n", ctx);
 
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
+	v4l2_ctrl_handler_free(&ctx->hdl);
 	v4l2_m2m_ctx_release(ctx->m2m_ctx);
 	kfree(ctx);
 
@@ -1012,14 +944,14 @@ static int m2mtest_release(struct file *file)
 static unsigned int m2mtest_poll(struct file *file,
 				 struct poll_table_struct *wait)
 {
-	struct m2mtest_ctx *ctx = file->private_data;
+	struct m2mtest_ctx *ctx = file2ctx(file);
 
 	return v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
 }
 
 static int m2mtest_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	struct m2mtest_ctx *ctx = file->private_data;
+	struct m2mtest_ctx *ctx = file2ctx(file);
 
 	return v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
 }
-- 
1.7.10

