Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45533 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbaI3J5p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Sep 2014 05:57:45 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 03/10] [media] coda: add coda_video_device descriptors
Date: Tue, 30 Sep 2014 11:57:04 +0200
Message-Id: <1412071031-32016-4-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1412071031-32016-1-git-send-email-p.zabel@pengutronix.de>
References: <1412071031-32016-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Depending on the devtype, the coda driver will now spawn a number of video
devices, one separate encoder for each format, and one multi-format decoder.

Each video device descriptor determines the name, callback ops, and input and
output formats on the corresponding video device. This also simplifies
coda_enum_fmt and coda_try_fmt a bit.

A separate decoder video device will be created for JPEG decoding later due to
slightly different behavior in the CodaDx6/CODA7542 case and due to a separate
hardware unit on CODA960.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 366 +++++++++++++++++-------------
 drivers/media/platform/coda/coda.h        |   7 +-
 2 files changed, 220 insertions(+), 153 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index fb83c56..df950f2 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -43,6 +43,7 @@
 #define CODA_NAME		"coda"
 
 #define CODADX6_MAX_INSTANCES	4
+#define CODA_MAX_FORMATS	4
 
 #define CODA_PARA_BUF_SIZE	(10 * 1024)
 #define CODA_ISRAM_SIZE	(2048 * 2)
@@ -169,6 +170,74 @@ static const struct coda_codec coda9_codecs[] = {
 	CODA_CODEC(CODA9_MODE_DECODE_MP4,  V4L2_PIX_FMT_MPEG4,  V4L2_PIX_FMT_YUV420, 1920, 1088),
 };
 
+struct coda_video_device {
+	const char *name;
+	enum coda_inst_type type;
+	const struct coda_context_ops *ops;
+	u32 src_formats[CODA_MAX_FORMATS];
+	u32 dst_formats[CODA_MAX_FORMATS];
+};
+
+static const struct coda_video_device coda_bit_h264_encoder = {
+	.name = "coda-h264-encoder",
+	.type = CODA_INST_ENCODER,
+	.ops = &coda_bit_encode_ops,
+	.src_formats = {
+		V4L2_PIX_FMT_YUV420,
+		V4L2_PIX_FMT_YVU420,
+		V4L2_PIX_FMT_NV12,
+	},
+	.dst_formats = {
+		V4L2_PIX_FMT_H264,
+	},
+};
+
+static const struct coda_video_device coda_bit_mpeg4_encoder = {
+	.name = "coda-mpeg4-encoder",
+	.type = CODA_INST_ENCODER,
+	.ops = &coda_bit_encode_ops,
+	.src_formats = {
+		V4L2_PIX_FMT_YUV420,
+		V4L2_PIX_FMT_YVU420,
+		V4L2_PIX_FMT_NV12,
+	},
+	.dst_formats = {
+		V4L2_PIX_FMT_MPEG4,
+	},
+};
+
+static const struct coda_video_device coda_bit_decoder = {
+	.name = "coda-decoder",
+	.type = CODA_INST_DECODER,
+	.ops = &coda_bit_decode_ops,
+	.src_formats = {
+		V4L2_PIX_FMT_H264,
+		V4L2_PIX_FMT_MPEG4,
+	},
+	.dst_formats = {
+		V4L2_PIX_FMT_YUV420,
+		V4L2_PIX_FMT_YVU420,
+		V4L2_PIX_FMT_NV12,
+	},
+};
+
+static const struct coda_video_device *codadx6_video_devices[] = {
+	&coda_bit_h264_encoder,
+	&coda_bit_mpeg4_encoder,
+};
+
+static const struct coda_video_device *coda7_video_devices[] = {
+	&coda_bit_h264_encoder,
+	&coda_bit_mpeg4_encoder,
+	&coda_bit_decoder,
+};
+
+static const struct coda_video_device *coda9_video_devices[] = {
+	&coda_bit_h264_encoder,
+	&coda_bit_mpeg4_encoder,
+	&coda_bit_decoder,
+};
+
 static bool coda_format_is_yuv(u32 fourcc)
 {
 	switch (fourcc) {
@@ -182,6 +251,18 @@ static bool coda_format_is_yuv(u32 fourcc)
 	}
 }
 
+static const char *coda_format_name(u32 fourcc)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(coda_formats); i++) {
+		if (coda_formats[i].fourcc == fourcc)
+			return coda_formats[i].name;
+	}
+
+	return NULL;
+}
+
 /*
  * Normalize all supported YUV 4:2:0 formats to the value used in the codec
  * tables.
@@ -240,6 +321,17 @@ static void coda_get_max_dimensions(struct coda_dev *dev,
 		*max_h = h;
 }
 
+const struct coda_video_device *to_coda_video_device(struct video_device *vdev)
+{
+	struct coda_dev *dev = video_get_drvdata(vdev);
+	unsigned int i = vdev - dev->vfd;
+
+	if (i >= dev->devtype->num_vdevs)
+		return NULL;
+
+	return dev->devtype->vdevs[i];
+}
+
 const char *coda_product_name(int product)
 {
 	static char buf[9];
@@ -278,58 +370,28 @@ static int coda_querycap(struct file *file, void *priv,
 static int coda_enum_fmt(struct file *file, void *priv,
 			 struct v4l2_fmtdesc *f)
 {
-	struct coda_ctx *ctx = fh_to_ctx(priv);
-	const struct coda_codec *codecs = ctx->dev->devtype->codecs;
-	const struct coda_fmt *formats = coda_formats;
-	const struct coda_fmt *fmt;
-	int num_codecs = ctx->dev->devtype->num_codecs;
-	int num_formats = ARRAY_SIZE(coda_formats);
-	int i, k, num = 0;
-	bool yuv;
-
-	if (ctx->inst_type == CODA_INST_ENCODER)
-		yuv = (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT);
+	struct video_device *vdev = video_devdata(file);
+	const struct coda_video_device *cvd = to_coda_video_device(vdev);
+	const u32 *formats;
+	const char *name;
+
+	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+		formats = cvd->src_formats;
+	else if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		formats = cvd->dst_formats;
 	else
-		yuv = (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE);
-
-	for (i = 0; i < num_formats; i++) {
-		/* Skip either raw or compressed formats */
-		if (yuv != coda_format_is_yuv(formats[i].fourcc))
-			continue;
-		/* All uncompressed formats are always supported */
-		if (yuv) {
-			if (num == f->index)
-				break;
-			++num;
-			continue;
-		}
-		/* Compressed formats may be supported, check the codec list */
-		for (k = 0; k < num_codecs; k++) {
-			if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE &&
-			    formats[i].fourcc == codecs[k].dst_fourcc)
-				break;
-			if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT &&
-			    formats[i].fourcc == codecs[k].src_fourcc)
-				break;
-		}
-		if (k < num_codecs) {
-			if (num == f->index)
-				break;
-			++num;
-		}
-	}
+		return -EINVAL;
 
-	if (i < num_formats) {
-		fmt = &formats[i];
-		strlcpy(f->description, fmt->name, sizeof(f->description));
-		f->pixelformat = fmt->fourcc;
-		if (!yuv)
-			f->flags |= V4L2_FMT_FLAG_COMPRESSED;
-		return 0;
-	}
+	if (f->index >= CODA_MAX_FORMATS || formats[f->index] == 0)
+		return -EINVAL;
 
-	/* Format not found */
-	return -EINVAL;
+	name = coda_format_name(formats[f->index]);
+	strlcpy(f->description, name, sizeof(f->description));
+	f->pixelformat = formats[f->index];
+	if (!coda_format_is_yuv(formats[f->index]))
+		f->flags |= V4L2_FMT_FLAG_COMPRESSED;
+
+	return 0;
 }
 
 static int coda_g_fmt(struct file *file, void *priv,
@@ -354,11 +416,37 @@ static int coda_g_fmt(struct file *file, void *priv,
 	return 0;
 }
 
+static int coda_try_pixelformat(struct coda_ctx *ctx, struct v4l2_format *f)
+{
+	struct coda_q_data *q_data;
+	const u32 *formats;
+	int i;
+
+	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+		formats = ctx->cvd->src_formats;
+	else if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		formats = ctx->cvd->dst_formats;
+	else
+		return -EINVAL;
+
+	for (i = 0; i < CODA_MAX_FORMATS; i++) {
+		if (formats[i] == f->fmt.pix.pixelformat) {
+			f->fmt.pix.pixelformat = formats[i];
+			return 0;
+		}
+	}
+
+	/* Fall back to currently set pixelformat */
+	q_data = get_q_data(ctx, f->type);
+	f->fmt.pix.pixelformat = q_data->fourcc;
+
+	return 0;
+}
+
 static int coda_try_fmt(struct coda_ctx *ctx, const struct coda_codec *codec,
 			struct v4l2_format *f)
 {
 	struct coda_dev *dev = ctx->dev;
-	struct coda_q_data *q_data;
 	unsigned int max_w, max_h;
 	enum v4l2_field field;
 
@@ -381,21 +469,6 @@ static int coda_try_fmt(struct coda_ctx *ctx, const struct coda_codec *codec,
 	case V4L2_PIX_FMT_YUV420:
 	case V4L2_PIX_FMT_YVU420:
 	case V4L2_PIX_FMT_NV12:
-	case V4L2_PIX_FMT_H264:
-	case V4L2_PIX_FMT_MPEG4:
-	case V4L2_PIX_FMT_JPEG:
-		break;
-	default:
-		q_data = get_q_data(ctx, f->type);
-		if (!q_data)
-			return -EINVAL;
-		f->fmt.pix.pixelformat = q_data->fourcc;
-	}
-
-	switch (f->fmt.pix.pixelformat) {
-	case V4L2_PIX_FMT_YUV420:
-	case V4L2_PIX_FMT_YVU420:
-	case V4L2_PIX_FMT_NV12:
 		/* Frame stride must be multiple of 8, but 16 for h.264 */
 		f->fmt.pix.bytesperline = round_up(f->fmt.pix.width, 16);
 		f->fmt.pix.sizeimage = f->fmt.pix.bytesperline *
@@ -423,34 +496,35 @@ static int coda_try_fmt_vid_cap(struct file *file, void *priv,
 				struct v4l2_format *f)
 {
 	struct coda_ctx *ctx = fh_to_ctx(priv);
-	const struct coda_codec *codec = NULL;
+	const struct coda_q_data *q_data_src;
+	const struct coda_codec *codec;
 	struct vb2_queue *src_vq;
 	int ret;
 
+	ret = coda_try_pixelformat(ctx, f);
+	if (ret < 0)
+		return ret;
+
+	q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+
 	/*
-	 * If the source format is already fixed, try to find a codec that
-	 * converts to the given destination format
+	 * If the source format is already fixed, only allow the same output
+	 * resolution
 	 */
 	src_vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
 	if (vb2_is_streaming(src_vq)) {
-		struct coda_q_data *q_data_src;
-
-		q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
-		codec = coda_find_codec(ctx->dev, q_data_src->fourcc,
-					f->fmt.pix.pixelformat);
-		if (!codec)
-			return -EINVAL;
-
 		f->fmt.pix.width = q_data_src->width;
 		f->fmt.pix.height = q_data_src->height;
-	} else {
-		/* Otherwise determine codec by encoded format, if possible */
-		codec = coda_find_codec(ctx->dev, V4L2_PIX_FMT_YUV420,
-					f->fmt.pix.pixelformat);
 	}
 
 	f->fmt.pix.colorspace = ctx->colorspace;
 
+	q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+	codec = coda_find_codec(ctx->dev, q_data_src->fourcc,
+				f->fmt.pix.pixelformat);
+	if (!codec)
+		return -EINVAL;
+
 	ret = coda_try_fmt(ctx, codec, f);
 	if (ret < 0)
 		return ret;
@@ -471,22 +545,21 @@ static int coda_try_fmt_vid_out(struct file *file, void *priv,
 				struct v4l2_format *f)
 {
 	struct coda_ctx *ctx = fh_to_ctx(priv);
-	const struct coda_codec *codec = NULL;
+	struct coda_dev *dev = ctx->dev;
+	const struct coda_q_data *q_data_dst;
+	const struct coda_codec *codec;
+	int ret;
 
-	/* Determine codec by encoded format, returns NULL if raw or invalid */
-	if (ctx->inst_type == CODA_INST_DECODER) {
-		codec = coda_find_codec(ctx->dev, f->fmt.pix.pixelformat,
-					V4L2_PIX_FMT_YUV420);
-		if (!codec)
-			codec = coda_find_codec(ctx->dev, V4L2_PIX_FMT_H264,
-						V4L2_PIX_FMT_YUV420);
-		if (!codec)
-			return -EINVAL;
-	}
+	ret = coda_try_pixelformat(ctx, f);
+	if (ret < 0)
+		return ret;
 
 	if (!f->fmt.pix.colorspace)
 		f->fmt.pix.colorspace = V4L2_COLORSPACE_REC709;
 
+	q_data_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
+	codec = coda_find_codec(dev, f->fmt.pix.pixelformat, q_data_dst->fourcc);
+
 	return coda_try_fmt(ctx, codec, f);
 }
 
@@ -907,18 +980,10 @@ static void coda_set_tiled_map_type(struct coda_ctx *ctx, int tiled_map_type)
 
 static void set_default_params(struct coda_ctx *ctx)
 {
-	u32 src_fourcc, dst_fourcc;
-	int max_w;
-	int max_h;
+	int max_w, max_h;
 
-	if (ctx->inst_type == CODA_INST_ENCODER) {
-		src_fourcc = V4L2_PIX_FMT_YUV420;
-		dst_fourcc = V4L2_PIX_FMT_H264;
-	} else {
-		src_fourcc = V4L2_PIX_FMT_H264;
-		dst_fourcc = V4L2_PIX_FMT_YUV420;
-	}
-	ctx->codec = coda_find_codec(ctx->dev, src_fourcc, dst_fourcc);
+	ctx->codec = coda_find_codec(ctx->dev, ctx->cvd->src_formats[0],
+				     ctx->cvd->dst_formats[0]);
 	max_w = ctx->codec->max_w;
 	max_h = ctx->codec->max_h;
 
@@ -1409,10 +1474,14 @@ static int coda_next_free_instance(struct coda_dev *dev)
 	return idx;
 }
 
-static int coda_open(struct file *file, enum coda_inst_type inst_type,
-		     const struct coda_context_ops *ctx_ops)
+/*
+ * File operations
+ */
+
+static int coda_open(struct file *file)
 {
-	struct coda_dev *dev = video_drvdata(file);
+	struct video_device *vdev = video_devdata(file);
+	struct coda_dev *dev = video_get_drvdata(vdev);
 	struct coda_ctx *ctx = NULL;
 	char *name;
 	int ret;
@@ -1433,8 +1502,9 @@ static int coda_open(struct file *file, enum coda_inst_type inst_type,
 	ctx->debugfs_entry = debugfs_create_dir(name, dev->debugfs_root);
 	kfree(name);
 
-	ctx->inst_type = inst_type;
-	ctx->ops = ctx_ops;
+	ctx->cvd = to_coda_video_device(vdev);
+	ctx->inst_type = ctx->cvd->type;
+	ctx->ops = ctx->cvd->ops;
 	init_completion(&ctx->completion);
 	INIT_WORK(&ctx->pic_run_work, coda_pic_run_work);
 	INIT_WORK(&ctx->seq_end_work, ctx->ops->seq_end_work);
@@ -1542,16 +1612,6 @@ err_coda_max:
 	return ret;
 }
 
-static int coda_encoder_open(struct file *file)
-{
-	return coda_open(file, CODA_INST_ENCODER, &coda_bit_encode_ops);
-}
-
-static int coda_decoder_open(struct file *file)
-{
-	return coda_open(file, CODA_INST_DECODER, &coda_bit_decode_ops);
-}
-
 static int coda_release(struct file *file)
 {
 	struct coda_dev *dev = video_drvdata(file);
@@ -1595,18 +1655,9 @@ static int coda_release(struct file *file)
 	return 0;
 }
 
-static const struct v4l2_file_operations coda_encoder_fops = {
+static const struct v4l2_file_operations coda_fops = {
 	.owner		= THIS_MODULE,
-	.open		= coda_encoder_open,
-	.release	= coda_release,
-	.poll		= v4l2_m2m_fop_poll,
-	.unlocked_ioctl	= video_ioctl2,
-	.mmap		= v4l2_m2m_fop_mmap,
-};
-
-static const struct v4l2_file_operations coda_decoder_fops = {
-	.owner		= THIS_MODULE,
-	.open		= coda_decoder_open,
+	.open		= coda_open,
 	.release	= coda_release,
 	.poll		= v4l2_m2m_fop_poll,
 	.unlocked_ioctl	= video_ioctl2,
@@ -1711,8 +1762,16 @@ err_clk_per:
 	return ret;
 }
 
-static int coda_register_device(struct coda_dev *dev, struct video_device *vfd)
+static int coda_register_device(struct coda_dev *dev, int i)
 {
+	struct video_device *vfd = &dev->vfd[i];
+
+	if (i > ARRAY_SIZE(dev->vfd))
+		return -EINVAL;
+
+	snprintf(vfd->name, sizeof(vfd->name), dev->devtype->vdevs[i]->name);
+	vfd->fops	= &coda_fops;
+	vfd->ioctl_ops	= &coda_ioctl_ops;
 	vfd->release	= video_device_release_empty,
 	vfd->lock	= &dev->dev_mutex;
 	vfd->v4l2_dev	= &dev->v4l2_dev;
@@ -1731,7 +1790,7 @@ static void coda_fw_callback(const struct firmware *fw, void *context)
 {
 	struct coda_dev *dev = context;
 	struct platform_device *pdev = dev->plat_dev;
-	int ret;
+	int i, ret;
 
 	if (!fw) {
 		v4l2_err(&dev->v4l2_dev, "firmware request failed\n");
@@ -1772,33 +1831,25 @@ static void coda_fw_callback(const struct firmware *fw, void *context)
 		goto rel_ctx;
 	}
 
-	dev->vfd[0].fops      = &coda_encoder_fops,
-	dev->vfd[0].ioctl_ops = &coda_ioctl_ops;
-	snprintf(dev->vfd[0].name, sizeof(dev->vfd[0].name), "coda-encoder");
-	ret = coda_register_device(dev, &dev->vfd[0]);
-	if (ret) {
-		v4l2_err(&dev->v4l2_dev,
-			 "Failed to register encoder video device\n");
-		goto rel_m2m;
-	}
-
-	dev->vfd[1].fops      = &coda_decoder_fops,
-	dev->vfd[1].ioctl_ops = &coda_ioctl_ops;
-	snprintf(dev->vfd[1].name, sizeof(dev->vfd[1].name), "coda-decoder");
-	ret = coda_register_device(dev, &dev->vfd[1]);
-	if (ret) {
-		v4l2_err(&dev->v4l2_dev,
-			 "Failed to register decoder video device\n");
-		goto rel_m2m;
+	for (i = 0; i < dev->devtype->num_vdevs; i++) {
+		ret = coda_register_device(dev, i);
+		if (ret) {
+			v4l2_err(&dev->v4l2_dev,
+				 "Failed to register %s video device: %d\n",
+				 dev->devtype->vdevs[i]->name, ret);
+			goto rel_vfd;
+		}
 	}
 
 	v4l2_info(&dev->v4l2_dev, "codec registered as /dev/video[%d-%d]\n",
-		  dev->vfd[0].num, dev->vfd[1].num);
+		  dev->vfd[0].num, dev->vfd[i - 1].num);
 
 	pm_runtime_put_sync(&pdev->dev);
 	return;
 
-rel_m2m:
+rel_vfd:
+	while (--i >= 0)
+		video_unregister_device(&dev->vfd[i]);
 	v4l2_m2m_release(dev->m2m_dev);
 rel_ctx:
 	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
@@ -1830,6 +1881,8 @@ static const struct coda_devtype coda_devdata[] = {
 		.product      = CODA_DX6,
 		.codecs       = codadx6_codecs,
 		.num_codecs   = ARRAY_SIZE(codadx6_codecs),
+		.vdevs        = codadx6_video_devices,
+		.num_vdevs    = ARRAY_SIZE(codadx6_video_devices),
 		.workbuf_size = 288 * 1024 + FMO_SLICE_SAVE_BUF_SIZE * 8 * 1024,
 		.iram_size    = 0xb000,
 	},
@@ -1838,6 +1891,8 @@ static const struct coda_devtype coda_devdata[] = {
 		.product      = CODA_7541,
 		.codecs       = coda7_codecs,
 		.num_codecs   = ARRAY_SIZE(coda7_codecs),
+		.vdevs        = coda7_video_devices,
+		.num_vdevs    = ARRAY_SIZE(coda7_video_devices),
 		.workbuf_size = 128 * 1024,
 		.tempbuf_size = 304 * 1024,
 		.iram_size    = 0x14000,
@@ -1847,6 +1902,8 @@ static const struct coda_devtype coda_devdata[] = {
 		.product      = CODA_960,
 		.codecs       = coda9_codecs,
 		.num_codecs   = ARRAY_SIZE(coda9_codecs),
+		.vdevs        = coda9_video_devices,
+		.num_vdevs    = ARRAY_SIZE(coda9_video_devices),
 		.workbuf_size = 80 * 1024,
 		.tempbuf_size = 204 * 1024,
 		.iram_size    = 0x21000,
@@ -1856,6 +1913,8 @@ static const struct coda_devtype coda_devdata[] = {
 		.product      = CODA_960,
 		.codecs       = coda9_codecs,
 		.num_codecs   = ARRAY_SIZE(coda9_codecs),
+		.vdevs        = coda9_video_devices,
+		.num_vdevs    = ARRAY_SIZE(coda9_video_devices),
 		.workbuf_size = 80 * 1024,
 		.tempbuf_size = 204 * 1024,
 		.iram_size    = 0x20000,
@@ -2035,9 +2094,12 @@ static int coda_probe(struct platform_device *pdev)
 static int coda_remove(struct platform_device *pdev)
 {
 	struct coda_dev *dev = platform_get_drvdata(pdev);
+	int i;
 
-	video_unregister_device(&dev->vfd[0]);
-	video_unregister_device(&dev->vfd[1]);
+	for (i = 0; i < ARRAY_SIZE(dev->vfd); i++) {
+		if (video_get_drvdata(&dev->vfd[i]))
+			video_unregister_device(&dev->vfd[i]);
+	}
 	if (dev->m2m_dev)
 		v4l2_m2m_release(dev->m2m_dev);
 	pm_runtime_disable(&pdev->dev);
diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
index 76ba83c..07eaf58 100644
--- a/drivers/media/platform/coda/coda.h
+++ b/drivers/media/platform/coda/coda.h
@@ -45,11 +45,15 @@ enum coda_product {
 	CODA_960 = 0xf020,
 };
 
+struct coda_video_device;
+
 struct coda_devtype {
 	char			*firmware;
 	enum coda_product	product;
 	const struct coda_codec	*codecs;
 	unsigned int		num_codecs;
+	const struct coda_video_device **vdevs;
+	unsigned int		num_vdevs;
 	size_t			workbuf_size;
 	size_t			tempbuf_size;
 	size_t			iram_size;
@@ -65,7 +69,7 @@ struct coda_aux_buf {
 
 struct coda_dev {
 	struct v4l2_device	v4l2_dev;
-	struct video_device	vfd[2];
+	struct video_device	vfd[3];
 	struct platform_device	*plat_dev;
 	const struct coda_devtype *devtype;
 
@@ -183,6 +187,7 @@ struct coda_ctx {
 	struct work_struct		pic_run_work;
 	struct work_struct		seq_end_work;
 	struct completion		completion;
+	const struct coda_video_device	*cvd;
 	const struct coda_context_ops	*ops;
 	int				aborting;
 	int				initialized;
-- 
2.1.0

