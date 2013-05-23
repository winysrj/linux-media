Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46110 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759439Ab3EWOnK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 May 2013 10:43:10 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Javier Martin <javier.martin@vista-silicon.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 6/9] [media] coda: per-product list of codecs instead of list of formats
Date: Thu, 23 May 2013 16:42:58 +0200
Message-Id: <1369320181-17933-7-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1369320181-17933-1-git-send-email-p.zabel@pengutronix.de>
References: <1369320181-17933-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds a list of supported codecs per device type which is used to
determine the allowed pixel formats and maximum frame sizes depending on the
possible codecs. It allows frame sizes larger than 720 x 576 on CODA7 and adds
support for the YVU420 (planar YUV 4:2:0 with switched Cb and Cr) format.
Other uncompressed formats that could be added in the future are the chroma
interleaved NV12 and NV21 formats and the multiplanar variants YUV420M,
YVU420M, NV12M, and NV21M.

Further, rawstreamon is renamed to streamon_out and compstreamon is renamed
to streamon_cap in preparation for decoding support. The maximum encoded
frame buffer size is increased to 1 MiB.

Instead of tracking inst_type and codec across S_FMT calls, set the codec
and inst_type in start_streaming.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 345 +++++++++++++++++++++++-------------------
 drivers/media/platform/coda.h |   3 +-
 2 files changed, 194 insertions(+), 154 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 625ef3f..83e3caf 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -49,16 +49,14 @@
 
 #define CODA_MAX_FRAMEBUFFERS	2
 
-#define MAX_W		720
-#define MAX_H		576
-#define CODA_MAX_FRAME_SIZE	0x90000
+#define MAX_W		8192
+#define MAX_H		8192
+#define CODA_MAX_FRAME_SIZE	0x100000
 #define FMO_SLICE_SAVE_BUF_SIZE         (32)
 #define CODA_DEFAULT_GAMMA		4096
 
 #define MIN_W 176
 #define MIN_H 144
-#define MAX_W 720
-#define MAX_H 576
 
 #define S_ALIGN		1 /* multiple of 2 */
 #define W_ALIGN		1 /* multiple of 2 */
@@ -75,11 +73,6 @@ enum {
 	V4L2_M2M_DST = 1,
 };
 
-enum coda_fmt_type {
-	CODA_FMT_ENC,
-	CODA_FMT_RAW,
-};
-
 enum coda_inst_type {
 	CODA_INST_ENCODER,
 	CODA_INST_DECODER,
@@ -93,14 +86,21 @@ enum coda_product {
 struct coda_fmt {
 	char *name;
 	u32 fourcc;
-	enum coda_fmt_type type;
+};
+
+struct coda_codec {
+	u32 mode;
+	u32 src_fourcc;
+	u32 dst_fourcc;
+	u32 max_w;
+	u32 max_h;
 };
 
 struct coda_devtype {
 	char			*firmware;
 	enum coda_product	product;
-	struct coda_fmt		*formats;
-	unsigned int		num_formats;
+	struct coda_codec	*codecs;
+	unsigned int		num_codecs;
 	size_t			workbuf_size;
 };
 
@@ -109,7 +109,7 @@ struct coda_q_data {
 	unsigned int		width;
 	unsigned int		height;
 	unsigned int		sizeimage;
-	struct coda_fmt	*fmt;
+	unsigned int		fourcc;
 };
 
 struct coda_aux_buf {
@@ -164,11 +164,12 @@ struct coda_ctx {
 	struct coda_dev			*dev;
 	struct list_head		list;
 	int				aborting;
-	int				rawstreamon;
-	int				compstreamon;
+	int				streamon_out;
+	int				streamon_cap;
 	u32				isequence;
 	struct coda_q_data		q_data[2];
 	enum coda_inst_type		inst_type;
+	struct coda_codec		*codec;
 	enum v4l2_colorspace		colorspace;
 	struct coda_params		params;
 	struct v4l2_m2m_ctx		*m2m_ctx;
@@ -257,62 +258,89 @@ static struct coda_q_data *get_q_data(struct coda_ctx *ctx,
 }
 
 /*
- * Add one array of supported formats for each version of Coda:
- *  i.MX27 -> codadx6
- *  i.MX51 -> coda7
- *  i.MX6  -> coda960
+ * Array of all formats supported by any version of Coda:
  */
-static struct coda_fmt codadx6_formats[] = {
+static struct coda_fmt coda_formats[] = {
 	{
-		.name = "YUV 4:2:0 Planar",
+		.name = "YUV 4:2:0 Planar, YCbCr",
 		.fourcc = V4L2_PIX_FMT_YUV420,
-		.type = CODA_FMT_RAW,
-	},
-	{
-		.name = "H264 Encoded Stream",
-		.fourcc = V4L2_PIX_FMT_H264,
-		.type = CODA_FMT_ENC,
-	},
-	{
-		.name = "MPEG4 Encoded Stream",
-		.fourcc = V4L2_PIX_FMT_MPEG4,
-		.type = CODA_FMT_ENC,
 	},
-};
-
-static struct coda_fmt coda7_formats[] = {
 	{
-		.name = "YUV 4:2:0 Planar",
-		.fourcc = V4L2_PIX_FMT_YUV420,
-		.type = CODA_FMT_RAW,
+		.name = "YUV 4:2:0 Planar, YCrCb",
+		.fourcc = V4L2_PIX_FMT_YVU420,
 	},
 	{
 		.name = "H264 Encoded Stream",
 		.fourcc = V4L2_PIX_FMT_H264,
-		.type = CODA_FMT_ENC,
 	},
 	{
 		.name = "MPEG4 Encoded Stream",
 		.fourcc = V4L2_PIX_FMT_MPEG4,
-		.type = CODA_FMT_ENC,
 	},
 };
 
-static struct coda_fmt *find_format(struct coda_dev *dev, struct v4l2_format *f)
+#define CODA_CODEC(mode, src_fourcc, dst_fourcc, max_w, max_h) \
+	{ mode, src_fourcc, dst_fourcc, max_w, max_h }
+
+/*
+ * Arrays of codecs supported by each given version of Coda:
+ *  i.MX27 -> codadx6
+ *  i.MX5x -> coda7
+ *  i.MX6  -> coda960
+ * Use V4L2_PIX_FMT_YUV420 as placeholder for all supported YUV 4:2:0 variants
+ */
+static struct coda_codec codadx6_codecs[] = {
+	CODA_CODEC(CODADX6_MODE_ENCODE_H264, V4L2_PIX_FMT_YUV420, V4L2_PIX_FMT_H264,  720, 576),
+	CODA_CODEC(CODADX6_MODE_ENCODE_MP4,  V4L2_PIX_FMT_YUV420, V4L2_PIX_FMT_MPEG4, 720, 576),
+};
+
+static struct coda_codec coda7_codecs[] = {
+	CODA_CODEC(CODA7_MODE_ENCODE_H264, V4L2_PIX_FMT_YUV420, V4L2_PIX_FMT_H264,   1280, 720),
+	CODA_CODEC(CODA7_MODE_ENCODE_MP4,  V4L2_PIX_FMT_YUV420, V4L2_PIX_FMT_MPEG4,  1280, 720),
+};
+
+static bool coda_format_is_yuv(u32 fourcc)
+{
+	switch (fourcc) {
+	case V4L2_PIX_FMT_YUV420:
+	case V4L2_PIX_FMT_YVU420:
+		return true;
+	default:
+		return false;
+	}
+}
+
+/*
+ * Normalize all supported YUV 4:2:0 formats to the value used in the codec
+ * tables.
+ */
+static u32 coda_format_normalize_yuv(u32 fourcc)
+{
+	return coda_format_is_yuv(fourcc) ? V4L2_PIX_FMT_YUV420 : fourcc;
+}
+
+static struct coda_codec *coda_find_codec(struct coda_dev *dev, int src_fourcc,
+					  int dst_fourcc)
 {
-	struct coda_fmt *formats = dev->devtype->formats;
-	int num_formats = dev->devtype->num_formats;
-	unsigned int k;
+	struct coda_codec *codecs = dev->devtype->codecs;
+	int num_codecs = dev->devtype->num_codecs;
+	int k;
+
+	src_fourcc = coda_format_normalize_yuv(src_fourcc);
+	dst_fourcc = coda_format_normalize_yuv(dst_fourcc);
+	if (src_fourcc == dst_fourcc)
+		return NULL;
 
-	for (k = 0; k < num_formats; k++) {
-		if (formats[k].fourcc == f->fmt.pix.pixelformat)
+	for (k = 0; k < num_codecs; k++) {
+		if (codecs[k].src_fourcc == src_fourcc &&
+		    codecs[k].dst_fourcc == dst_fourcc)
 			break;
 	}
 
-	if (k == num_formats)
+	if (k == num_codecs)
 		return NULL;
 
-	return &formats[k];
+	return &codecs[k];
 }
 
 /*
@@ -337,17 +365,34 @@ static int vidioc_querycap(struct file *file, void *priv,
 }
 
 static int enum_fmt(void *priv, struct v4l2_fmtdesc *f,
-			enum coda_fmt_type type)
+			enum v4l2_buf_type type)
 {
 	struct coda_ctx *ctx = fh_to_ctx(priv);
-	struct coda_dev *dev = ctx->dev;
-	struct coda_fmt *formats = dev->devtype->formats;
+	struct coda_codec *codecs = ctx->dev->devtype->codecs;
+	struct coda_fmt *formats = coda_formats;
 	struct coda_fmt *fmt;
-	int num_formats = dev->devtype->num_formats;
-	int i, num = 0;
+	int num_codecs = ctx->dev->devtype->num_codecs;
+	int num_formats = ARRAY_SIZE(coda_formats);
+	int i, k, num = 0;
 
 	for (i = 0; i < num_formats; i++) {
-		if (formats[i].type == type) {
+		/* Both uncompressed formats are always supported */
+		if (coda_format_is_yuv(formats[i].fourcc)) {
+			if (num == f->index)
+				break;
+			++num;
+			continue;
+		}
+		/* Compressed formats may be supported, check the codec list */
+		for (k = 0; k < num_codecs; k++) {
+			if (type == V4L2_BUF_TYPE_VIDEO_CAPTURE &&
+			    formats[i].fourcc == codecs[k].dst_fourcc)
+				break;
+			if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT &&
+			    formats[i].fourcc == codecs[k].src_fourcc)
+				break;
+		}
+		if (k < num_codecs) {
 			if (num == f->index)
 				break;
 			++num;
@@ -368,13 +413,13 @@ static int enum_fmt(void *priv, struct v4l2_fmtdesc *f,
 static int vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
 				   struct v4l2_fmtdesc *f)
 {
-	return enum_fmt(priv, f, CODA_FMT_ENC);
+	return enum_fmt(priv, f, V4L2_BUF_TYPE_VIDEO_CAPTURE);
 }
 
 static int vidioc_enum_fmt_vid_out(struct file *file, void *priv,
 				   struct v4l2_fmtdesc *f)
 {
-	return enum_fmt(priv, f, CODA_FMT_RAW);
+	return enum_fmt(priv, f, V4L2_BUF_TYPE_VIDEO_OUTPUT);
 }
 
 static int vidioc_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
@@ -390,10 +435,10 @@ static int vidioc_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
 	q_data = get_q_data(ctx, f->type);
 
 	f->fmt.pix.field	= V4L2_FIELD_NONE;
-	f->fmt.pix.pixelformat	= q_data->fmt->fourcc;
+	f->fmt.pix.pixelformat	= q_data->fourcc;
 	f->fmt.pix.width	= q_data->width;
 	f->fmt.pix.height	= q_data->height;
-	if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_YUV420)
+	if (coda_format_is_yuv(f->fmt.pix.pixelformat))
 		f->fmt.pix.bytesperline = round_up(f->fmt.pix.width, 2);
 	else /* encoded formats h.264/mpeg4 */
 		f->fmt.pix.bytesperline = 0;
@@ -404,8 +449,9 @@ static int vidioc_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
 	return 0;
 }
 
-static int vidioc_try_fmt(struct coda_dev *dev, struct v4l2_format *f)
+static int vidioc_try_fmt(struct coda_codec *codec, struct v4l2_format *f)
 {
+	unsigned int max_w, max_h;
 	enum v4l2_field field;
 
 	field = f->fmt.pix.field;
@@ -418,10 +464,18 @@ static int vidioc_try_fmt(struct coda_dev *dev, struct v4l2_format *f)
 	 * if any of the dimensions is unsupported */
 	f->fmt.pix.field = field;
 
-	if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_YUV420) {
-		v4l_bound_align_image(&f->fmt.pix.width, MIN_W, MAX_W,
-				      W_ALIGN, &f->fmt.pix.height,
-				      MIN_H, MAX_H, H_ALIGN, S_ALIGN);
+	if (codec) {
+		max_w = codec->max_w;
+		max_h = codec->max_h;
+	} else {
+		max_w = MAX_W;
+		max_h = MAX_H;
+	}
+	v4l_bound_align_image(&f->fmt.pix.width, MIN_W, max_w,
+			      W_ALIGN, &f->fmt.pix.height,
+			      MIN_H, max_h, H_ALIGN, S_ALIGN);
+
+	if (coda_format_is_yuv(f->fmt.pix.pixelformat)) {
 		/* Frame stride must be multiple of 8 */
 		f->fmt.pix.bytesperline = round_up(f->fmt.pix.width, 8);
 		f->fmt.pix.sizeimage = f->fmt.pix.bytesperline *
@@ -437,57 +491,38 @@ static int vidioc_try_fmt(struct coda_dev *dev, struct v4l2_format *f)
 static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 				  struct v4l2_format *f)
 {
-	int ret;
-	struct coda_fmt *fmt;
 	struct coda_ctx *ctx = fh_to_ctx(priv);
+	struct coda_codec *codec = NULL;
 
-	fmt = find_format(ctx->dev, f);
-	/*
-	 * Since decoding support is not implemented yet do not allow
-	 * CODA_FMT_RAW formats in the capture interface.
-	 */
-	if (!fmt || !(fmt->type == CODA_FMT_ENC))
-		f->fmt.pix.pixelformat = V4L2_PIX_FMT_H264;
+	/* Determine codec by the encoded format */
+	codec = coda_find_codec(ctx->dev, V4L2_PIX_FMT_YUV420,
+				f->fmt.pix.pixelformat);
 
 	f->fmt.pix.colorspace = ctx->colorspace;
 
-	ret = vidioc_try_fmt(ctx->dev, f);
-	if (ret < 0)
-		return ret;
-
-	return 0;
+	return vidioc_try_fmt(codec, f);
 }
 
 static int vidioc_try_fmt_vid_out(struct file *file, void *priv,
 				  struct v4l2_format *f)
 {
 	struct coda_ctx *ctx = fh_to_ctx(priv);
-	struct coda_fmt *fmt;
-	int ret;
+	struct coda_codec *codec;
 
-	fmt = find_format(ctx->dev, f);
-	/*
-	 * Since decoding support is not implemented yet do not allow
-	 * CODA_FMT formats in the capture interface.
-	 */
-	if (!fmt || !(fmt->type == CODA_FMT_RAW))
-		f->fmt.pix.pixelformat = V4L2_PIX_FMT_YUV420;
+	/* Determine codec by encoded format, returns NULL if raw or invalid */
+	codec = coda_find_codec(ctx->dev, f->fmt.pix.pixelformat,
+				V4L2_PIX_FMT_YUV420);
 
 	if (!f->fmt.pix.colorspace)
 		f->fmt.pix.colorspace = V4L2_COLORSPACE_REC709;
 
-	ret = vidioc_try_fmt(ctx->dev, f);
-	if (ret < 0)
-		return ret;
-
-	return 0;
+	return vidioc_try_fmt(codec, f);
 }
 
 static int vidioc_s_fmt(struct coda_ctx *ctx, struct v4l2_format *f)
 {
 	struct coda_q_data *q_data;
 	struct vb2_queue *vq;
-	int ret;
 
 	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
 	if (!vq)
@@ -502,18 +537,14 @@ static int vidioc_s_fmt(struct coda_ctx *ctx, struct v4l2_format *f)
 		return -EBUSY;
 	}
 
-	ret = vidioc_try_fmt(ctx->dev, f);
-	if (ret)
-		return ret;
-
-	q_data->fmt = find_format(ctx->dev, f);
+	q_data->fourcc = f->fmt.pix.pixelformat;
 	q_data->width = f->fmt.pix.width;
 	q_data->height = f->fmt.pix.height;
 	q_data->sizeimage = f->fmt.pix.sizeimage;
 
 	v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
 		"Setting format for type %d, wxh: %dx%d, fmt: %d\n",
-		f->type, q_data->width, q_data->height, q_data->fmt->fourcc);
+		f->type, q_data->width, q_data->height, q_data->fourcc);
 
 	return 0;
 }
@@ -521,13 +552,14 @@ static int vidioc_s_fmt(struct coda_ctx *ctx, struct v4l2_format *f)
 static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 				struct v4l2_format *f)
 {
+	struct coda_ctx *ctx = fh_to_ctx(priv);
 	int ret;
 
 	ret = vidioc_try_fmt_vid_cap(file, priv, f);
 	if (ret)
 		return ret;
 
-	return vidioc_s_fmt(fh_to_ctx(priv), f);
+	return vidioc_s_fmt(ctx, f);
 }
 
 static int vidioc_s_fmt_vid_out(struct file *file, void *priv,
@@ -653,7 +685,7 @@ static void coda_device_run(void *m2m_priv)
 	dst_buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
 	q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
 	q_data_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
-	dst_fourcc = q_data_dst->fmt->fourcc;
+	dst_fourcc = q_data_dst->fourcc;
 
 	src_buf->v4l2_buf.sequence = ctx->isequence;
 	dst_buf->v4l2_buf.sequence = ctx->isequence;
@@ -735,9 +767,20 @@ static void coda_device_run(void *m2m_priv)
 
 
 	picture_y = vb2_dma_contig_plane_dma_addr(src_buf, 0);
-	picture_cb = picture_y + q_data_src->width * q_data_src->height;
-	picture_cr = picture_cb + q_data_src->width / 2 *
-			q_data_src->height / 2;
+	switch (q_data_src->fourcc) {
+	case V4L2_PIX_FMT_YVU420:
+		/* Switch Cb and Cr for YVU420 format */
+		picture_cr = picture_y + q_data_src->width * q_data_src->height;
+		picture_cb = picture_cr + q_data_src->width / 2 *
+				q_data_src->height / 2;
+		break;
+	case V4L2_PIX_FMT_YUV420:
+	default:
+		picture_cb = picture_y + q_data_src->width * q_data_src->height;
+		picture_cr = picture_cb + q_data_src->width / 2 *
+				q_data_src->height / 2;
+		break;
+	}
 
 	coda_write(dev, picture_y, CODA_CMD_ENC_PIC_SRC_ADDR_Y);
 	coda_write(dev, picture_cb, CODA_CMD_ENC_PIC_SRC_ADDR_CB);
@@ -819,7 +862,12 @@ static struct v4l2_m2m_ops coda_m2m_ops = {
 
 static void set_default_params(struct coda_ctx *ctx)
 {
-	struct coda_dev *dev = ctx->dev;
+	int max_w;
+	int max_h;
+
+	ctx->codec = &ctx->dev->devtype->codecs[0];
+	max_w = ctx->codec->max_w;
+	max_h = ctx->codec->max_h;
 
 	ctx->params.codec_mode = CODA_MODE_INVALID;
 	ctx->colorspace = V4L2_COLORSPACE_REC709;
@@ -827,13 +875,13 @@ static void set_default_params(struct coda_ctx *ctx)
 	ctx->aborting = 0;
 
 	/* Default formats for output and input queues */
-	ctx->q_data[V4L2_M2M_SRC].fmt = &dev->devtype->formats[0];
-	ctx->q_data[V4L2_M2M_DST].fmt = &dev->devtype->formats[1];
-	ctx->q_data[V4L2_M2M_SRC].width = MAX_W;
-	ctx->q_data[V4L2_M2M_SRC].height = MAX_H;
-	ctx->q_data[V4L2_M2M_SRC].sizeimage = (MAX_W * MAX_H * 3) / 2;
-	ctx->q_data[V4L2_M2M_DST].width = MAX_W;
-	ctx->q_data[V4L2_M2M_DST].height = MAX_H;
+	ctx->q_data[V4L2_M2M_SRC].fourcc = ctx->codec->src_fourcc;
+	ctx->q_data[V4L2_M2M_DST].fourcc = ctx->codec->dst_fourcc;
+	ctx->q_data[V4L2_M2M_SRC].width = max_w;
+	ctx->q_data[V4L2_M2M_SRC].height = max_h;
+	ctx->q_data[V4L2_M2M_SRC].sizeimage = (max_w * max_h * 3) / 2;
+	ctx->q_data[V4L2_M2M_DST].width = max_w;
+	ctx->q_data[V4L2_M2M_DST].height = max_h;
 	ctx->q_data[V4L2_M2M_DST].sizeimage = CODA_MAX_FRAME_SIZE;
 }
 
@@ -999,37 +1047,36 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 		return -EINVAL;
 
 	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
-		ctx->rawstreamon = 1;
+		ctx->streamon_out = 1;
 	else
-		ctx->compstreamon = 1;
+		ctx->streamon_cap = 1;
 
-	/* Don't start the coda unless both queues are on */
-	if (!(ctx->rawstreamon & ctx->compstreamon))
-		return 0;
+	q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+	if (ctx->streamon_out) {
+		if (coda_format_is_yuv(q_data_src->fourcc))
+			ctx->inst_type = CODA_INST_ENCODER;
+		else
+			ctx->inst_type = CODA_INST_DECODER;
+	}
 
 	if (coda_isbusy(dev))
 		if (wait_for_completion_interruptible_timeout(&dev->done, HZ) <= 0)
 			return -EBUSY;
 
-	ctx->gopcounter = ctx->params.gop_size - 1;
+	/* Don't start the coda unless both queues are on */
+	if (!(ctx->streamon_out & ctx->streamon_cap))
+		return 0;
 
-	q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+	ctx->gopcounter = ctx->params.gop_size - 1;
 	buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
 	bitstream_buf = vb2_dma_contig_plane_dma_addr(buf, 0);
 	q_data_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
 	bitstream_size = q_data_dst->sizeimage;
-	dst_fourcc = q_data_dst->fmt->fourcc;
-
-	/* Find out whether coda must encode or decode */
-	if (q_data_src->fmt->type == CODA_FMT_RAW &&
-	    q_data_dst->fmt->type == CODA_FMT_ENC) {
-		ctx->inst_type = CODA_INST_ENCODER;
-	} else if (q_data_src->fmt->type == CODA_FMT_ENC &&
-		   q_data_dst->fmt->type == CODA_FMT_RAW) {
-		ctx->inst_type = CODA_INST_DECODER;
-		v4l2_err(v4l2_dev, "decoding not supported.\n");
-		return -EINVAL;
-	} else {
+	dst_fourcc = q_data_dst->fourcc;
+
+	ctx->codec = coda_find_codec(ctx->dev, q_data_src->fourcc,
+				     q_data_dst->fourcc);
+	if (!ctx->codec) {
 		v4l2_err(v4l2_dev, "couldn't tell instance type.\n");
 		return -EINVAL;
 	}
@@ -1060,31 +1107,23 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 	switch (dev->devtype->product) {
 	case CODA_DX6:
 		value = (q_data_src->width & CODADX6_PICWIDTH_MASK) << CODADX6_PICWIDTH_OFFSET;
+		value |= (q_data_src->height & CODADX6_PICHEIGHT_MASK) << CODA_PICHEIGHT_OFFSET;
 		break;
 	default:
 		value = (q_data_src->width & CODA7_PICWIDTH_MASK) << CODA7_PICWIDTH_OFFSET;
+		value |= (q_data_src->height & CODA7_PICHEIGHT_MASK) << CODA_PICHEIGHT_OFFSET;
 	}
-	value |= (q_data_src->height & CODA_PICHEIGHT_MASK) << CODA_PICHEIGHT_OFFSET;
 	coda_write(dev, value, CODA_CMD_ENC_SEQ_SRC_SIZE);
 	coda_write(dev, ctx->params.framerate,
 		   CODA_CMD_ENC_SEQ_SRC_F_RATE);
 
+	ctx->params.codec_mode = ctx->codec->mode;
 	switch (dst_fourcc) {
 	case V4L2_PIX_FMT_MPEG4:
-		if (dev->devtype->product == CODA_DX6)
-			ctx->params.codec_mode = CODADX6_MODE_ENCODE_MP4;
-		else
-			ctx->params.codec_mode = CODA7_MODE_ENCODE_MP4;
-
 		coda_write(dev, CODA_STD_MPEG4, CODA_CMD_ENC_SEQ_COD_STD);
 		coda_write(dev, 0, CODA_CMD_ENC_SEQ_MP4_PARA);
 		break;
 	case V4L2_PIX_FMT_H264:
-		if (dev->devtype->product == CODA_DX6)
-			ctx->params.codec_mode = CODADX6_MODE_ENCODE_H264;
-		else
-			ctx->params.codec_mode = CODA7_MODE_ENCODE_H264;
-
 		coda_write(dev, CODA_STD_H264, CODA_CMD_ENC_SEQ_COD_STD);
 		coda_write(dev, 0, CODA_CMD_ENC_SEQ_264_PARA);
 		break;
@@ -1283,15 +1322,15 @@ static int coda_stop_streaming(struct vb2_queue *q)
 	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
 		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
 			 "%s: output\n", __func__);
-		ctx->rawstreamon = 0;
+		ctx->streamon_out = 0;
 	} else {
 		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
 			 "%s: capture\n", __func__);
-		ctx->compstreamon = 0;
+		ctx->streamon_cap = 0;
 	}
 
 	/* Don't stop the coda unless both queues are off */
-	if (ctx->rawstreamon || ctx->compstreamon)
+	if (ctx->streamon_out || ctx->streamon_cap)
 		return 0;
 
 	if (coda_isbusy(dev)) {
@@ -1924,16 +1963,16 @@ enum coda_platform {
 
 static const struct coda_devtype coda_devdata[] = {
 	[CODA_IMX27] = {
-		.firmware    = "v4l-codadx6-imx27.bin",
-		.product     = CODA_DX6,
-		.formats     = codadx6_formats,
-		.num_formats = ARRAY_SIZE(codadx6_formats),
+		.firmware   = "v4l-codadx6-imx27.bin",
+		.product    = CODA_DX6,
+		.codecs     = codadx6_codecs,
+		.num_codecs = ARRAY_SIZE(codadx6_codecs),
 	},
 	[CODA_IMX53] = {
-		.firmware    = "v4l-coda7541-imx53.bin",
-		.product     = CODA_7541,
-		.formats     = coda7_formats,
-		.num_formats = ARRAY_SIZE(coda7_formats),
+		.firmware   = "v4l-coda7541-imx53.bin",
+		.product    = CODA_7541,
+		.codecs     = coda7_codecs,
+		.num_codecs = ARRAY_SIZE(coda7_codecs),
 	},
 };
 
diff --git a/drivers/media/platform/coda.h b/drivers/media/platform/coda.h
index 3c350ac..ace0bf0 100644
--- a/drivers/media/platform/coda.h
+++ b/drivers/media/platform/coda.h
@@ -113,7 +113,8 @@
 #define		CODADX6_PICWIDTH_OFFSET				10
 #define		CODADX6_PICWIDTH_MASK				0x3ff
 #define		CODA_PICHEIGHT_OFFSET				0
-#define		CODA_PICHEIGHT_MASK				0x3ff
+#define		CODADX6_PICHEIGHT_MASK				0x3ff
+#define		CODA7_PICHEIGHT_MASK				0xffff
 #define CODA_CMD_ENC_SEQ_SRC_F_RATE				0x194
 #define CODA_CMD_ENC_SEQ_MP4_PARA				0x198
 #define		CODA_MP4PARAM_VERID_OFFSET			6
-- 
1.8.2.rc2

