Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50294 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757317Ab2IKLSG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Sep 2012 07:18:06 -0400
Subject: Re: [PATCH v4 16/16] media: coda: support >1024 px height on
 CODA7, set max frame size to 1080p
From: Philipp Zabel <p.zabel@pengutronix.de>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Richard Zhao <richard.zhao@freescale.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
In-Reply-To: <CACKLOr0o6RNO+YNkojbes6wn5fRZGApsEnEj1EW8JkmZV632yg@mail.gmail.com>
References: <1347291000-340-1-git-send-email-p.zabel@pengutronix.de>
	 <1347291000-340-17-git-send-email-p.zabel@pengutronix.de>
	 <CACKLOr0o6RNO+YNkojbes6wn5fRZGApsEnEj1EW8JkmZV632yg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Sep 2012 13:17:59 +0200
Message-ID: <1347362279.2615.40.camel@pizza.hi.pengutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

Am Dienstag, den 11.09.2012, 12:52 +0200 schrieb javier Martin:
> On 10 September 2012 17:30, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> > Increases the maximum encoded frame buffer size to 1 MiB.
> >
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> >  drivers/media/platform/coda.c |   11 +++++------
> >  drivers/media/platform/coda.h |    3 ++-
> >  2 files changed, 7 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
> > index 4c3e100..defab64 100644
> > --- a/drivers/media/platform/coda.c
> > +++ b/drivers/media/platform/coda.c
> > @@ -47,16 +47,14 @@
> >
> >  #define CODA_MAX_FRAMEBUFFERS  2
> >
> > -#define MAX_W          720
> > -#define MAX_H          576
> > -#define CODA_MAX_FRAME_SIZE    0x90000
> > +#define MAX_W          1920
> > +#define MAX_H          1080
> 
> You need to define separate MAX_W and MAX_H for codadx6 and coda7. The
> reason of this is that 'try_fmt' in codadx6 must adjust the width and
> height to 720x576 not to 1920x1080. So you need to modify "try_fmt"
> too.

even worse, there are different MAX_W/H depending on the codec. And when
doing S_FMT on the OUTPUT side first, the codec is still not chosen...
My current approach (in progress) looks something like this:

Subject: [PATCH] media: coda: per-product list of codecs instead of list of
 formats

This allows to support different maximum frame sizes depending
on the used codec and to specify decoders.
Also rename rawstreamon to streamon_out and compstreamon to
streamon_cap in preparation for decoding support.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/video/coda.c |  191 +++++++++++++++++++++++++-------------------
 1 file changed, 107 insertions(+), 84 deletions(-)

diff --git a/drivers/media/video/coda.c b/drivers/media/video/coda.c
index afa3166..4dbb716 100644
--- a/drivers/media/video/coda.c
+++ b/drivers/media/video/coda.c
@@ -48,8 +48,8 @@
 
 #define CODA_MAX_FRAMEBUFFERS	2
 
-#define MAX_W		1920
-#define MAX_H		1080
+#define MAX_W		8192
+#define MAX_H		8192
 #define CODA_MAX_FRAME_SIZE	0x100000
 #define FMO_SLICE_SAVE_BUF_SIZE         (32)
 #define CODA_DEFAULT_GAMMA		4096
@@ -93,11 +93,19 @@ struct coda_fmt {
 	enum coda_fmt_type type;
 };
 
+struct coda_codec {
+	u32 mode;
+	u32 src_fourcc;
+	u32 dst_fourcc;
+	u32 max_w;
+	u32 max_h;
+};
+
 struct coda_devtype {
 	char			*firmware;
 	enum coda_product	product;
-	struct coda_fmt		*formats;
-	unsigned int		num_formats;
+	struct coda_codec	*codecs;
+	unsigned int		num_codecs;
 	size_t			workbuf_size;
 };
 
@@ -162,11 +170,12 @@ struct coda_ctx {
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
@@ -256,25 +265,7 @@ static struct coda_q_data *get_q_data(struct coda_ctx *ctx,
  *  i.MX51 -> coda7
  *  i.MX6  -> coda960
  */
-static struct coda_fmt codadx6_formats[] = {
-	{
-		.name = "YUV 4:2:0 Planar",
-		.fourcc = V4L2_PIX_FMT_YUV420,
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
-	},
-};
-
-static struct coda_fmt coda7_formats[] = {
+static struct coda_fmt coda_formats[] = {
 	{
 		.name = "YUV 4:2:0 Planar",
 		.fourcc = V4L2_PIX_FMT_YUV420,
@@ -297,10 +288,42 @@ static struct coda_fmt coda7_formats[] = {
 	},
 };
 
+#define CODA_CODEC(mode, src_fourcc, dst_fourcc, max_w, max_h) \
+	{ mode, src_fourcc, dst_fourcc, max_w, max_h }
+
+static struct coda_codec codadx6_codecs[] = {
+	CODA_CODEC(CODADX6_MODE_ENCODE_H264, V4L2_PIX_FMT_YUV420, V4L2_PIX_FMT_H264,  720, 576),
+	CODA_CODEC(CODADX6_MODE_ENCODE_MP4,  V4L2_PIX_FMT_YUV420, V4L2_PIX_FMT_MPEG4, 720, 576),
+};
+
+static struct coda_codec coda7_codecs[] = {
+	CODA_CODEC(CODA7_MODE_ENCODE_H264, V4L2_PIX_FMT_YUV420, V4L2_PIX_FMT_H264,   1280, 720),
+	CODA_CODEC(CODA7_MODE_ENCODE_MP4,  V4L2_PIX_FMT_YUV420, V4L2_PIX_FMT_MPEG4,  1280, 720),
+	CODA_CODEC(CODA7_MODE_ENCODE_MJPG, V4L2_PIX_FMT_YUV420, V4L2_PIX_FMT_JPEG,   8192, 8129),
+};
+
+static struct coda_codec *find_codec(struct coda_dev *dev, int src_fourcc, int dst_fourcc)
+{
+	struct coda_codec *codecs = dev->devtype->codecs;
+	int num_codecs = dev->devtype->num_codecs;
+	unsigned int k;
+
+	for (k = 0; k < num_codecs; k++) {
+		if (codecs[k].src_fourcc == src_fourcc &&
+		    codecs[k].dst_fourcc == dst_fourcc)
+			break;
+	}
+
+	if (k == num_codecs)
+		return NULL;
+
+	return &codecs[k];
+}
+
 static struct coda_fmt *find_format(struct coda_dev *dev, struct v4l2_format *f)
 {
-	struct coda_fmt *formats = dev->devtype->formats;
-	int num_formats = dev->devtype->num_formats;
+	struct coda_fmt *formats = coda_formats;
+	int num_formats = ARRAY_SIZE(coda_formats);
 	unsigned int k;
 
 	for (k = 0; k < num_formats; k++) {
@@ -331,17 +354,26 @@ static int vidioc_querycap(struct file *file, void *priv,
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
@@ -362,13 +394,13 @@ static int enum_fmt(void *priv, struct v4l2_fmtdesc *f,
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
@@ -398,8 +430,9 @@ static int vidioc_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
 	return 0;
 }
 
-static int vidioc_try_fmt(struct coda_dev *dev, struct v4l2_format *f)
+static int vidioc_try_fmt(struct coda_ctx *ctx, struct v4l2_format *f)
 {
+	unsigned int max_w, max_h;
 	enum v4l2_field field;
 
 	field = f->fmt.pix.field;
@@ -412,10 +445,18 @@ static int vidioc_try_fmt(struct coda_dev *dev, struct v4l2_format *f)
 	 * if any of the dimensions is unsupported */
 	f->fmt.pix.field = field;
 
+	if (ctx->codec) {
+		max_w = ctx->codec->max_w;
+		max_h = ctx->codec->max_h;
+	} else {
+		max_w = MAX_W;
+		max_h = MAX_H;
+	}
+	v4l_bound_align_image(&f->fmt.pix.width, MIN_W, max_w,
+			      W_ALIGN, &f->fmt.pix.height,
+			      MIN_H, max_h, H_ALIGN, S_ALIGN);
+
 	if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_YUV420) {
-		v4l_bound_align_image(&f->fmt.pix.width, MIN_W, MAX_W,
-				      W_ALIGN, &f->fmt.pix.height,
-				      MIN_H, MAX_H, H_ALIGN, S_ALIGN);
 		/* Frame stride must be multiple of 8 */
 		f->fmt.pix.bytesperline = round_up(f->fmt.pix.width, 8);
 		f->fmt.pix.sizeimage = f->fmt.pix.bytesperline *
@@ -431,50 +472,32 @@ static int vidioc_try_fmt(struct coda_dev *dev, struct v4l2_format *f)
 static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 				  struct v4l2_format *f)
 {
-	int ret;
-	struct coda_fmt *fmt;
 	struct coda_ctx *ctx = fh_to_ctx(priv);
 
-	fmt = find_format(ctx->dev, f);
-	/*
-	 * Since decoding support is not implemented yet do not allow
-	 * CODA_FMT_RAW formats in the capture interface.
-	 */
-	if (!fmt || !(fmt->type == CODA_FMT_ENC))
-		f->fmt.pix.pixelformat = V4L2_PIX_FMT_H264;
+	/* Determine codec by the encoded format */
+	if (f->fmt.pix.pixelformat != V4L2_PIX_FMT_YUV420)
+		ctx->codec = find_codec(ctx->dev, V4L2_PIX_FMT_YUV420,
+					f->fmt.pix.pixelformat);
 
 	f->fmt.pix.colorspace = ctx->colorspace;
 
-	ret = vidioc_try_fmt(ctx->dev, f);
-	if (ret < 0)
-		return ret;
-
-	return 0;
+	return vidioc_try_fmt(ctx, f);
 }
 
 static int vidioc_try_fmt_vid_out(struct file *file, void *priv,
 				  struct v4l2_format *f)
 {
 	struct coda_ctx *ctx = fh_to_ctx(priv);
-	struct coda_fmt *fmt;
-	int ret;
 
-	fmt = find_format(ctx->dev, f);
-	/*
-	 * Since decoding support is not implemented yet do not allow
-	 * CODA_FMT formats in the capture interface.
-	 */
-	if (!fmt || !(fmt->type == CODA_FMT_RAW))
-		f->fmt.pix.pixelformat = V4L2_PIX_FMT_YUV420;
+	/* Determine codec by the encoded format */
+	if (f->fmt.pix.pixelformat != V4L2_PIX_FMT_YUV420)
+		ctx->codec = find_codec(ctx->dev, f->fmt.pix.pixelformat,
+					V4L2_PIX_FMT_YUV420);
 
 	if (!f->fmt.pix.colorspace)
 		f->fmt.pix.colorspace = V4L2_COLORSPACE_REC709;
 
-	ret = vidioc_try_fmt(ctx->dev, f);
-	if (ret < 0)
-		return ret;
-
-	return 0;
+	return vidioc_try_fmt(ctx, f);
 }
 
 static int vidioc_s_fmt(struct coda_ctx *ctx, struct v4l2_format *f)
@@ -496,7 +519,7 @@ static int vidioc_s_fmt(struct coda_ctx *ctx, struct v4l2_format *f)
 		return -EBUSY;
 	}
 
-	ret = vidioc_try_fmt(ctx->dev, f);
+	ret = vidioc_try_fmt(ctx, f);
 	if (ret)
 		return ret;
 
@@ -807,8 +830,8 @@ static void set_default_params(struct coda_ctx *ctx)
 	ctx->aborting = 0;
 
 	/* Default formats for output and input queues */
-	ctx->q_data[V4L2_M2M_SRC].fmt = &dev->devtype->formats[0];
-	ctx->q_data[V4L2_M2M_DST].fmt = &dev->devtype->formats[1];
+	ctx->q_data[V4L2_M2M_SRC].fmt = &coda_formats[0];
+	ctx->q_data[V4L2_M2M_DST].fmt = &coda_formats[1];
 	ctx->q_data[V4L2_M2M_SRC].width = MAX_W;
 	ctx->q_data[V4L2_M2M_SRC].height = MAX_H;
 	ctx->q_data[V4L2_M2M_SRC].sizeimage = (MAX_W * MAX_H * 3) / 2;
@@ -1136,12 +1159,12 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 		return -EINVAL;
 
 	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
-		ctx->rawstreamon = 1;
+		ctx->streamon_out = 1;
 	else
-		ctx->compstreamon = 1;
+		ctx->streamon_cap = 1;
 
 	/* Don't start the coda unless both queues are on */
-	if (!(ctx->rawstreamon & ctx->compstreamon))
+	if (!(ctx->streamon_out & ctx->streamon_cap))
 		return 0;
 
 	if (coda_isbusy(dev))
@@ -1435,15 +1458,15 @@ static int coda_stop_streaming(struct vb2_queue *q)
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
@@ -2078,16 +2101,16 @@ enum coda_platform {
 
 static struct coda_devtype coda_devdata[] = {
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
 
-- 
1.7.10.4


