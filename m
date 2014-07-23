Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59242 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878AbaGWP2z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jul 2014 11:28:55 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 3/8] [media] coda: add context ops
Date: Wed, 23 Jul 2014 17:28:40 +0200
Message-Id: <1406129325-10771-4-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1406129325-10771-1-git-send-email-p.zabel@pengutronix.de>
References: <1406129325-10771-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a struct coda_context_ops that encapsulates context specific operations.
This will simplify adding JPEG support in the future and helps to avoid
exporting all functions individually when they move out of the main code
file.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 85 ++++++++++++++++++-------------
 drivers/media/platform/coda/coda.h        | 13 +++++
 2 files changed, 63 insertions(+), 35 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 4649395..ecab30a 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -802,7 +802,7 @@ static const struct v4l2_ioctl_ops coda_ioctl_ops = {
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
-static int coda_start_decoding(struct coda_ctx *ctx);
+static int __coda_start_decoding(struct coda_ctx *ctx);
 
 static inline int coda_get_bitstream_payload(struct coda_ctx *ctx)
 {
@@ -978,7 +978,7 @@ static int coda_prepare_decode(struct coda_ctx *ctx)
 
 	/* Run coda_start_decoding (again) if not yet initialized */
 	if (!ctx->initialized) {
-		int ret = coda_start_decoding(ctx);
+		int ret = __coda_start_decoding(ctx);
 		if (ret < 0) {
 			v4l2_err(&dev->v4l2_dev, "failed to start decoding\n");
 			v4l2_m2m_job_finish(ctx->dev->m2m_dev, ctx->fh.m2m_ctx);
@@ -1043,7 +1043,7 @@ static int coda_prepare_decode(struct coda_ctx *ctx)
 	return 0;
 }
 
-static void coda_prepare_encode(struct coda_ctx *ctx)
+static int coda_prepare_encode(struct coda_ctx *ctx)
 {
 	struct coda_q_data *q_data_src, *q_data_dst;
 	struct vb2_buffer *src_buf, *dst_buf;
@@ -1185,6 +1185,8 @@ static void coda_prepare_encode(struct coda_ctx *ctx)
 		ctx->bit_stream_param |= CODA_BIT_STREAM_END_FLAG;
 		coda_write(dev, ctx->bit_stream_param, CODA_REG_BIT_BIT_STREAM_PARAM);
 	}
+
+	return 0;
 }
 
 static void coda_device_run(void *m2m_priv)
@@ -1235,16 +1237,12 @@ static void coda_pic_run_work(struct work_struct *work)
 	mutex_lock(&ctx->buffer_mutex);
 	mutex_lock(&dev->coda_mutex);
 
-	if (ctx->inst_type == CODA_INST_DECODER) {
-		ret = coda_prepare_decode(ctx);
-		if (ret < 0) {
-			mutex_unlock(&dev->coda_mutex);
-			mutex_unlock(&ctx->buffer_mutex);
-			/* job_finish scheduled by prepare_decode */
-			return;
-		}
-	} else {
-		coda_prepare_encode(ctx);
+	ret = ctx->ops->prepare_run(ctx);
+	if (ret < 0 && ctx->inst_type == CODA_INST_DECODER) {
+		mutex_unlock(&dev->coda_mutex);
+		mutex_unlock(&ctx->buffer_mutex);
+		/* job_finish scheduled by prepare_decode */
+		return;
 	}
 
 	if (dev->devtype->product != CODA_DX6)
@@ -1262,10 +1260,7 @@ static void coda_pic_run_work(struct work_struct *work)
 
 		coda_hw_reset(ctx);
 	} else if (!ctx->aborting) {
-		if (ctx->inst_type == CODA_INST_DECODER)
-			coda_finish_decode(ctx);
-		else
-			coda_finish_encode(ctx);
+		ctx->ops->finish_run(ctx);
 	}
 
 	if (ctx->aborting || (!ctx->streamon_cap && !ctx->streamon_out))
@@ -1848,7 +1843,7 @@ err:
 	return ret;
 }
 
-static int coda_start_decoding(struct coda_ctx *ctx)
+static int __coda_start_decoding(struct coda_ctx *ctx)
 {
 	struct coda_q_data *q_data_src, *q_data_dst;
 	u32 bitstream_buf, bitstream_size;
@@ -2039,6 +2034,18 @@ static int coda_start_decoding(struct coda_ctx *ctx)
 	return 0;
 }
 
+static int coda_start_decoding(struct coda_ctx *ctx)
+{
+	struct coda_dev *dev = ctx->dev;
+	int ret;
+
+	mutex_lock(&dev->coda_mutex);
+	ret = __coda_start_decoding(ctx);
+	mutex_unlock(&dev->coda_mutex);
+
+	return ret;
+}
+
 static int coda_encode_header(struct coda_ctx *ctx, struct vb2_buffer *buf,
 			      int header_code, u8 *header, int *size)
 {
@@ -2083,7 +2090,6 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 {
 	struct coda_ctx *ctx = vb2_get_drv_priv(q);
 	struct v4l2_device *v4l2_dev = &ctx->dev->v4l2_dev;
-	struct coda_dev *dev = ctx->dev;
 	struct coda_q_data *q_data_src, *q_data_dst;
 	u32 dst_fourcc;
 	int ret = 0;
@@ -2135,16 +2141,12 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 	if (ret < 0)
 		return ret;
 
+	ret = ctx->ops->start_streaming(ctx);
 	if (ctx->inst_type == CODA_INST_DECODER) {
-		mutex_lock(&dev->coda_mutex);
-		ret = coda_start_decoding(ctx);
-		mutex_unlock(&dev->coda_mutex);
 		if (ret == -EAGAIN)
 			return 0;
 		else if (ret < 0)
 			return ret;
-	} else {
-		ret = coda_start_encoding(ctx);
 	}
 
 	ctx->initialized = 1;
@@ -2739,10 +2741,9 @@ static int coda_next_free_instance(struct coda_dev *dev)
 	return idx;
 }
 
-static int coda_open(struct file *file, enum coda_inst_type inst_type)
+static int coda_open(struct file *file, enum coda_inst_type inst_type,
+		     const struct coda_context_ops *ctx_ops)
 {
-	int (*queue_init)(void *priv, struct vb2_queue *src_vq,
-			  struct vb2_queue *dst_vq);
 	struct coda_dev *dev = video_drvdata(file);
 	struct coda_ctx *ctx = NULL;
 	char *name;
@@ -2765,9 +2766,10 @@ static int coda_open(struct file *file, enum coda_inst_type inst_type)
 	kfree(name);
 
 	ctx->inst_type = inst_type;
+	ctx->ops = ctx_ops;
 	init_completion(&ctx->completion);
 	INIT_WORK(&ctx->pic_run_work, coda_pic_run_work);
-	INIT_WORK(&ctx->seq_end_work, coda_seq_end_work);
+	INIT_WORK(&ctx->seq_end_work, ctx->ops->seq_end_work);
 	v4l2_fh_init(&ctx->fh, video_devdata(file));
 	file->private_data = &ctx->fh;
 	v4l2_fh_add(&ctx->fh);
@@ -2798,11 +2800,8 @@ static int coda_open(struct file *file, enum coda_inst_type inst_type)
 		goto err_clk_ahb;
 
 	set_default_params(ctx);
-	if (inst_type == CODA_INST_ENCODER)
-		queue_init = coda_encoder_queue_init;
-	else
-		queue_init = coda_decoder_queue_init;
-	ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_dev, ctx, queue_init);
+	ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_dev, ctx,
+					    ctx->ops->queue_init);
 	if (IS_ERR(ctx->fh.m2m_ctx)) {
 		ret = PTR_ERR(ctx->fh.m2m_ctx);
 
@@ -2873,14 +2872,30 @@ err_coda_max:
 	return ret;
 }
 
+struct coda_context_ops coda_encode_ops = {
+	.queue_init = coda_encoder_queue_init,
+	.start_streaming = coda_start_encoding,
+	.prepare_run = coda_prepare_encode,
+	.finish_run = coda_finish_encode,
+	.seq_end_work = coda_seq_end_work,
+};
+
+struct coda_context_ops coda_decode_ops = {
+	.queue_init = coda_decoder_queue_init,
+	.start_streaming = coda_start_decoding,
+	.prepare_run = coda_prepare_decode,
+	.finish_run = coda_finish_decode,
+	.seq_end_work = coda_seq_end_work
+};
+
 static int coda_encoder_open(struct file *file)
 {
-	return coda_open(file, CODA_INST_ENCODER);
+	return coda_open(file, CODA_INST_ENCODER, &coda_encode_ops);
 }
 
 static int coda_decoder_open(struct file *file)
 {
-	return coda_open(file, CODA_INST_DECODER);
+	return coda_open(file, CODA_INST_DECODER, &coda_decode_ops);
 }
 
 static int coda_release(struct file *file)
diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
index aafd186..c98270c 100644
--- a/drivers/media/platform/coda/coda.h
+++ b/drivers/media/platform/coda/coda.h
@@ -164,6 +164,18 @@ struct gdi_tiled_map {
 #define GDI_LINEAR_FRAME_MAP 0
 };
 
+struct coda_ctx;
+
+struct coda_context_ops {
+	int (*queue_init)(void *priv, struct vb2_queue *src_vq,
+			  struct vb2_queue *dst_vq);
+	int (*start_streaming)(struct coda_ctx *ctx);
+	int (*prepare_run)(struct coda_ctx *ctx);
+	void (*finish_run)(struct coda_ctx *ctx);
+	void (*seq_end_work)(struct work_struct *work);
+	void (*release)(struct coda_ctx *ctx);
+};
+
 struct coda_ctx {
 	struct coda_dev			*dev;
 	struct mutex			buffer_mutex;
@@ -171,6 +183,7 @@ struct coda_ctx {
 	struct work_struct		pic_run_work;
 	struct work_struct		seq_end_work;
 	struct completion		completion;
+	const struct coda_context_ops	*ops;
 	int				aborting;
 	int				initialized;
 	int				streamon_out;
-- 
2.0.1

