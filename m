Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39232 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934696AbaGQQFT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 12:05:19 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 08/11] [media] coda: split userspace interface into encoder and decoder device
Date: Thu, 17 Jul 2014 18:05:09 +0200
Message-Id: <1405613112-22442-9-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1405613112-22442-1-git-send-email-p.zabel@pengutronix.de>
References: <1405613112-22442-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Userspace has a hard time making sense of format enumerations on V4L2
mem2mem devices if there are restrictions on which input and output
formats can be used together. Alleviate the problem by splitting the
video4linux device into separate encoder and decoder devices which list
only raw formats on one side and only encoded formats on the other side.
With this patch, the instance type (encoder or decoder) is already
determined by the open file operation.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 167 ++++++++++++++++++++++++++++++------------
 1 file changed, 120 insertions(+), 47 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 6b659c8..4a159031 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -129,7 +129,7 @@ struct coda_aux_buf {
 
 struct coda_dev {
 	struct v4l2_device	v4l2_dev;
-	struct video_device	vfd;
+	struct video_device	vfd[2];
 	struct platform_device	*plat_dev;
 	const struct coda_devtype *devtype;
 
@@ -1580,14 +1580,22 @@ static void coda_set_tiled_map_type(struct coda_ctx *ctx, int tiled_map_type)
 
 static void set_default_params(struct coda_ctx *ctx)
 {
+	u32 src_fourcc, dst_fourcc;
 	int max_w;
 	int max_h;
 
-	ctx->codec = &ctx->dev->devtype->codecs[0];
+	if (ctx->inst_type == CODA_INST_ENCODER) {
+		src_fourcc = V4L2_PIX_FMT_YUV420;
+		dst_fourcc = V4L2_PIX_FMT_H264;
+	} else {
+		src_fourcc = V4L2_PIX_FMT_H264;
+		dst_fourcc = V4L2_PIX_FMT_YUV420;
+	}
+	ctx->codec = coda_find_codec(ctx->dev, src_fourcc, dst_fourcc);
 	max_w = ctx->codec->max_w;
 	max_h = ctx->codec->max_h;
 
-	ctx->params.codec_mode = CODA_MODE_INVALID;
+	ctx->params.codec_mode = ctx->codec->mode;
 	ctx->colorspace = V4L2_COLORSPACE_REC709;
 	ctx->params.framerate = 30;
 	ctx->aborting = 0;
@@ -1597,12 +1605,19 @@ static void set_default_params(struct coda_ctx *ctx)
 	ctx->q_data[V4L2_M2M_DST].fourcc = ctx->codec->dst_fourcc;
 	ctx->q_data[V4L2_M2M_SRC].width = max_w;
 	ctx->q_data[V4L2_M2M_SRC].height = max_h;
-	ctx->q_data[V4L2_M2M_SRC].bytesperline = max_w;
-	ctx->q_data[V4L2_M2M_SRC].sizeimage = (max_w * max_h * 3) / 2;
 	ctx->q_data[V4L2_M2M_DST].width = max_w;
 	ctx->q_data[V4L2_M2M_DST].height = max_h;
-	ctx->q_data[V4L2_M2M_DST].bytesperline = 0;
-	ctx->q_data[V4L2_M2M_DST].sizeimage = CODA_MAX_FRAME_SIZE;
+	if (ctx->codec->src_fourcc == V4L2_PIX_FMT_YUV420) {
+		ctx->q_data[V4L2_M2M_SRC].bytesperline = max_w;
+		ctx->q_data[V4L2_M2M_SRC].sizeimage = (max_w * max_h * 3) / 2;
+		ctx->q_data[V4L2_M2M_DST].bytesperline = 0;
+		ctx->q_data[V4L2_M2M_DST].sizeimage = CODA_MAX_FRAME_SIZE;
+	} else {
+		ctx->q_data[V4L2_M2M_SRC].bytesperline = 0;
+		ctx->q_data[V4L2_M2M_SRC].sizeimage = CODA_MAX_FRAME_SIZE;
+		ctx->q_data[V4L2_M2M_DST].bytesperline = max_w;
+		ctx->q_data[V4L2_M2M_DST].sizeimage = (max_w * max_h * 3) / 2;
+	}
 	ctx->q_data[V4L2_M2M_SRC].rect.width = max_w;
 	ctx->q_data[V4L2_M2M_SRC].rect.height = max_h;
 	ctx->q_data[V4L2_M2M_DST].rect.width = max_w;
@@ -2293,11 +2308,6 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 		}
 
 		ctx->streamon_out = 1;
-
-		if (coda_format_is_yuv(q_data_src->fourcc))
-			ctx->inst_type = CODA_INST_ENCODER;
-		else
-			ctx->inst_type = CODA_INST_DECODER;
 	} else {
 		if (count < 1)
 			return -EINVAL;
@@ -2719,7 +2729,7 @@ static void coda_stop_streaming(struct vb2_queue *q)
 	}
 }
 
-static struct vb2_ops coda_qops = {
+static const struct vb2_ops coda_qops = {
 	.queue_setup		= coda_queue_setup,
 	.buf_prepare		= coda_buf_prepare,
 	.buf_queue		= coda_buf_queue,
@@ -2871,35 +2881,55 @@ static int coda_ctrls_setup(struct coda_ctx *ctx)
 	return v4l2_ctrl_handler_setup(&ctx->ctrls);
 }
 
-static int coda_queue_init(void *priv, struct vb2_queue *src_vq,
-		      struct vb2_queue *dst_vq)
+static int coda_queue_init(struct coda_ctx *ctx, struct vb2_queue *vq)
+{
+	vq->drv_priv = ctx;
+	vq->ops = &coda_qops;
+	vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
+	vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	vq->lock = &ctx->dev->dev_mutex;
+
+	return vb2_queue_init(vq);
+}
+
+static int coda_encoder_queue_init(void *priv, struct vb2_queue *src_vq,
+				   struct vb2_queue *dst_vq)
 {
-	struct coda_ctx *ctx = priv;
 	int ret;
 
 	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
 	src_vq->io_modes = VB2_DMABUF | VB2_MMAP;
-	src_vq->drv_priv = ctx;
-	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
-	src_vq->ops = &coda_qops;
 	src_vq->mem_ops = &vb2_dma_contig_memops;
-	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
-	src_vq->lock = &ctx->dev->dev_mutex;
 
-	ret = vb2_queue_init(src_vq);
+	ret = coda_queue_init(priv, src_vq);
 	if (ret)
 		return ret;
 
 	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	dst_vq->io_modes = VB2_DMABUF | VB2_MMAP;
-	dst_vq->drv_priv = ctx;
-	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
-	dst_vq->ops = &coda_qops;
 	dst_vq->mem_ops = &vb2_dma_contig_memops;
-	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
-	dst_vq->lock = &ctx->dev->dev_mutex;
 
-	return vb2_queue_init(dst_vq);
+	return coda_queue_init(priv, dst_vq);
+}
+
+static int coda_decoder_queue_init(void *priv, struct vb2_queue *src_vq,
+				   struct vb2_queue *dst_vq)
+{
+	int ret;
+
+	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
+	src_vq->io_modes = VB2_DMABUF | VB2_MMAP;
+	src_vq->mem_ops = &vb2_dma_contig_memops;
+
+	ret = coda_queue_init(priv, src_vq);
+	if (ret)
+		return ret;
+
+	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	dst_vq->io_modes = VB2_DMABUF | VB2_MMAP;
+	dst_vq->mem_ops = &vb2_dma_contig_memops;
+
+	return coda_queue_init(priv, dst_vq);
 }
 
 static int coda_next_free_instance(struct coda_dev *dev)
@@ -2913,8 +2943,10 @@ static int coda_next_free_instance(struct coda_dev *dev)
 	return idx;
 }
 
-static int coda_open(struct file *file)
+static int coda_open(struct file *file, enum coda_inst_type inst_type)
 {
+	int (*queue_init)(void *priv, struct vb2_queue *src_vq,
+			  struct vb2_queue *dst_vq);
 	struct coda_dev *dev = video_drvdata(file);
 	struct coda_ctx *ctx = NULL;
 	char *name;
@@ -2936,6 +2968,7 @@ static int coda_open(struct file *file)
 	ctx->debugfs_entry = debugfs_create_dir(name, dev->debugfs_root);
 	kfree(name);
 
+	ctx->inst_type = inst_type;
 	init_completion(&ctx->completion);
 	INIT_WORK(&ctx->pic_run_work, coda_pic_run_work);
 	INIT_WORK(&ctx->seq_end_work, coda_seq_end_work);
@@ -2969,8 +3002,11 @@ static int coda_open(struct file *file)
 		goto err_clk_ahb;
 
 	set_default_params(ctx);
-	ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_dev, ctx,
-					 &coda_queue_init);
+	if (inst_type == CODA_INST_ENCODER)
+		queue_init = coda_encoder_queue_init;
+	else
+		queue_init = coda_decoder_queue_init;
+	ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_dev, ctx, queue_init);
 	if (IS_ERR(ctx->fh.m2m_ctx)) {
 		ret = PTR_ERR(ctx->fh.m2m_ctx);
 
@@ -3041,6 +3077,16 @@ err_coda_max:
 	return ret;
 }
 
+static int coda_encoder_open(struct file *file)
+{
+	return coda_open(file, CODA_INST_ENCODER);
+}
+
+static int coda_decoder_open(struct file *file)
+{
+	return coda_open(file, CODA_INST_DECODER);
+}
+
 static int coda_release(struct file *file)
 {
 	struct coda_dev *dev = video_drvdata(file);
@@ -3085,9 +3131,18 @@ static int coda_release(struct file *file)
 	return 0;
 }
 
-static const struct v4l2_file_operations coda_fops = {
+static const struct v4l2_file_operations coda_encoder_fops = {
 	.owner		= THIS_MODULE,
-	.open		= coda_open,
+	.open		= coda_encoder_open,
+	.release	= coda_release,
+	.poll		= v4l2_m2m_fop_poll,
+	.unlocked_ioctl	= video_ioctl2,
+	.mmap		= v4l2_m2m_fop_mmap,
+};
+
+static const struct v4l2_file_operations coda_decoder_fops = {
+	.owner		= THIS_MODULE,
+	.open		= coda_decoder_open,
 	.release	= coda_release,
 	.poll		= v4l2_m2m_fop_poll,
 	.unlocked_ioctl	= video_ioctl2,
@@ -3570,6 +3625,17 @@ err_clk_per:
 	return ret;
 }
 
+static int coda_register_device(struct coda_dev *dev, struct video_device *vfd)
+{
+	vfd->release	= video_device_release_empty,
+	vfd->lock	= &dev->dev_mutex;
+	vfd->v4l2_dev	= &dev->v4l2_dev;
+	vfd->vfl_dir	= VFL_DIR_M2M;
+	video_set_drvdata(vfd, dev);
+
+	return video_register_device(vfd, VFL_TYPE_GRABBER, 0);
+}
+
 static void coda_fw_callback(const struct firmware *fw, void *context)
 {
 	struct coda_dev *dev = context;
@@ -3626,15 +3692,6 @@ static void coda_fw_callback(const struct firmware *fw, void *context)
 			return;
 	}
 
-	dev->vfd.fops	= &coda_fops,
-	dev->vfd.ioctl_ops	= &coda_ioctl_ops;
-	dev->vfd.release	= video_device_release_empty,
-	dev->vfd.lock	= &dev->dev_mutex;
-	dev->vfd.v4l2_dev	= &dev->v4l2_dev;
-	dev->vfd.vfl_dir	= VFL_DIR_M2M;
-	snprintf(dev->vfd.name, sizeof(dev->vfd.name), "%s", CODA_NAME);
-	video_set_drvdata(&dev->vfd, dev);
-
 	dev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
 	if (IS_ERR(dev->alloc_ctx)) {
 		v4l2_err(&dev->v4l2_dev, "Failed to alloc vb2 context\n");
@@ -3647,13 +3704,28 @@ static void coda_fw_callback(const struct firmware *fw, void *context)
 		goto rel_ctx;
 	}
 
-	ret = video_register_device(&dev->vfd, VFL_TYPE_GRABBER, 0);
+	dev->vfd[0].fops      = &coda_encoder_fops,
+	dev->vfd[0].ioctl_ops = &coda_ioctl_ops;
+	snprintf(dev->vfd[0].name, sizeof(dev->vfd[0].name), "coda-encoder");
+	ret = coda_register_device(dev, &dev->vfd[0]);
 	if (ret) {
-		v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
+		v4l2_err(&dev->v4l2_dev,
+			 "Failed to register encoder video device\n");
 		goto rel_m2m;
 	}
-	v4l2_info(&dev->v4l2_dev, "codec registered as /dev/video%d\n",
-		  dev->vfd.num);
+
+	dev->vfd[1].fops      = &coda_decoder_fops,
+	dev->vfd[1].ioctl_ops = &coda_ioctl_ops;
+	snprintf(dev->vfd[1].name, sizeof(dev->vfd[1].name), "coda-decoder");
+	ret = coda_register_device(dev, &dev->vfd[1]);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev,
+			 "Failed to register decoder video device\n");
+		goto rel_m2m;
+	}
+
+	v4l2_info(&dev->v4l2_dev, "codec registered as /dev/video[%d-%d]\n",
+		  dev->vfd[0].num, dev->vfd[1].num);
 
 	return;
 
@@ -3887,7 +3959,8 @@ static int coda_remove(struct platform_device *pdev)
 {
 	struct coda_dev *dev = platform_get_drvdata(pdev);
 
-	video_unregister_device(&dev->vfd);
+	video_unregister_device(&dev->vfd[0]);
+	video_unregister_device(&dev->vfd[1]);
 	if (dev->m2m_dev)
 		v4l2_m2m_release(dev->m2m_dev);
 	pm_runtime_disable(&pdev->dev);
-- 
2.0.1

