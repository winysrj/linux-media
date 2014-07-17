Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39238 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934700AbaGQQFU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 12:05:20 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 11/11] [media] coda: mark constant structures as such
Date: Thu, 17 Jul 2014 18:05:12 +0200
Message-Id: <1405613112-22442-12-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1405613112-22442-1-git-send-email-p.zabel@pengutronix.de>
References: <1405613112-22442-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The format and codec lists and the ops structures are read-only.
Mark them as const.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index ed5fa4c..b644f2b 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -102,7 +102,7 @@ struct coda_codec {
 struct coda_devtype {
 	char			*firmware;
 	enum coda_product	product;
-	struct coda_codec	*codecs;
+	const struct coda_codec	*codecs;
 	unsigned int		num_codecs;
 	size_t			workbuf_size;
 	size_t			tempbuf_size;
@@ -225,7 +225,7 @@ struct coda_ctx {
 	u32				sequence_offset;
 	struct coda_q_data		q_data[2];
 	enum coda_inst_type		inst_type;
-	struct coda_codec		*codec;
+	const struct coda_codec		*codec;
 	enum v4l2_colorspace		colorspace;
 	struct coda_params		params;
 	struct v4l2_ctrl_handler	ctrls;
@@ -390,7 +390,7 @@ static struct coda_q_data *get_q_data(struct coda_ctx *ctx,
 /*
  * Array of all formats supported by any version of Coda:
  */
-static struct coda_fmt coda_formats[] = {
+static const struct coda_fmt coda_formats[] = {
 	{
 		.name = "YUV 4:2:0 Planar, YCbCr",
 		.fourcc = V4L2_PIX_FMT_YUV420,
@@ -419,19 +419,19 @@ static struct coda_fmt coda_formats[] = {
  *  i.MX6  -> coda960
  * Use V4L2_PIX_FMT_YUV420 as placeholder for all supported YUV 4:2:0 variants
  */
-static struct coda_codec codadx6_codecs[] = {
+static const struct coda_codec codadx6_codecs[] = {
 	CODA_CODEC(CODADX6_MODE_ENCODE_H264, V4L2_PIX_FMT_YUV420, V4L2_PIX_FMT_H264,  720, 576),
 	CODA_CODEC(CODADX6_MODE_ENCODE_MP4,  V4L2_PIX_FMT_YUV420, V4L2_PIX_FMT_MPEG4, 720, 576),
 };
 
-static struct coda_codec coda7_codecs[] = {
+static const struct coda_codec coda7_codecs[] = {
 	CODA_CODEC(CODA7_MODE_ENCODE_H264, V4L2_PIX_FMT_YUV420, V4L2_PIX_FMT_H264,   1280, 720),
 	CODA_CODEC(CODA7_MODE_ENCODE_MP4,  V4L2_PIX_FMT_YUV420, V4L2_PIX_FMT_MPEG4,  1280, 720),
 	CODA_CODEC(CODA7_MODE_DECODE_H264, V4L2_PIX_FMT_H264,   V4L2_PIX_FMT_YUV420, 1920, 1080),
 	CODA_CODEC(CODA7_MODE_DECODE_MP4,  V4L2_PIX_FMT_MPEG4,  V4L2_PIX_FMT_YUV420, 1920, 1080),
 };
 
-static struct coda_codec coda9_codecs[] = {
+static const struct coda_codec coda9_codecs[] = {
 	CODA_CODEC(CODA9_MODE_ENCODE_H264, V4L2_PIX_FMT_YUV420, V4L2_PIX_FMT_H264,   1920, 1080),
 	CODA_CODEC(CODA9_MODE_ENCODE_MP4,  V4L2_PIX_FMT_YUV420, V4L2_PIX_FMT_MPEG4,  1920, 1080),
 	CODA_CODEC(CODA9_MODE_DECODE_H264, V4L2_PIX_FMT_H264,   V4L2_PIX_FMT_YUV420, 1920, 1080),
@@ -458,10 +458,10 @@ static u32 coda_format_normalize_yuv(u32 fourcc)
 	return coda_format_is_yuv(fourcc) ? V4L2_PIX_FMT_YUV420 : fourcc;
 }
 
-static struct coda_codec *coda_find_codec(struct coda_dev *dev, int src_fourcc,
-					  int dst_fourcc)
+static const struct coda_codec *coda_find_codec(struct coda_dev *dev,
+						int src_fourcc, int dst_fourcc)
 {
-	struct coda_codec *codecs = dev->devtype->codecs;
+	const struct coda_codec *codecs = dev->devtype->codecs;
 	int num_codecs = dev->devtype->num_codecs;
 	int k;
 
@@ -483,10 +483,10 @@ static struct coda_codec *coda_find_codec(struct coda_dev *dev, int src_fourcc,
 }
 
 static void coda_get_max_dimensions(struct coda_dev *dev,
-				    struct coda_codec *codec,
+				    const struct coda_codec *codec,
 				    int *max_w, int *max_h)
 {
-	struct coda_codec *codecs = dev->devtype->codecs;
+	const struct coda_codec *codecs = dev->devtype->codecs;
 	int num_codecs = dev->devtype->num_codecs;
 	unsigned int w, h;
 	int k;
@@ -546,9 +546,9 @@ static int coda_enum_fmt(struct file *file, void *priv,
 			 struct v4l2_fmtdesc *f)
 {
 	struct coda_ctx *ctx = fh_to_ctx(priv);
-	struct coda_codec *codecs = ctx->dev->devtype->codecs;
-	struct coda_fmt *formats = coda_formats;
-	struct coda_fmt *fmt;
+	const struct coda_codec *codecs = ctx->dev->devtype->codecs;
+	const struct coda_fmt *formats = coda_formats;
+	const struct coda_fmt *fmt;
 	int num_codecs = ctx->dev->devtype->num_codecs;
 	int num_formats = ARRAY_SIZE(coda_formats);
 	int i, k, num = 0;
@@ -621,7 +621,7 @@ static int coda_g_fmt(struct file *file, void *priv,
 	return 0;
 }
 
-static int coda_try_fmt(struct coda_ctx *ctx, struct coda_codec *codec,
+static int coda_try_fmt(struct coda_ctx *ctx, const struct coda_codec *codec,
 			struct v4l2_format *f)
 {
 	struct coda_dev *dev = ctx->dev;
@@ -685,7 +685,7 @@ static int coda_try_fmt_vid_cap(struct file *file, void *priv,
 				struct v4l2_format *f)
 {
 	struct coda_ctx *ctx = fh_to_ctx(priv);
-	struct coda_codec *codec = NULL;
+	const struct coda_codec *codec = NULL;
 	struct vb2_queue *src_vq;
 	int ret;
 
@@ -733,7 +733,7 @@ static int coda_try_fmt_vid_out(struct file *file, void *priv,
 				struct v4l2_format *f)
 {
 	struct coda_ctx *ctx = fh_to_ctx(priv);
-	struct coda_codec *codec;
+	const struct coda_codec *codec;
 
 	/* Determine codec by encoded format, returns NULL if raw or invalid */
 	codec = coda_find_codec(ctx->dev, f->fmt.pix.pixelformat,
@@ -1531,7 +1531,7 @@ static void coda_unlock(void *m2m_priv)
 	mutex_unlock(&pcdev->dev_mutex);
 }
 
-static struct v4l2_m2m_ops coda_m2m_ops = {
+static const struct v4l2_m2m_ops coda_m2m_ops = {
 	.device_run	= coda_device_run,
 	.job_ready	= coda_job_ready,
 	.job_abort	= coda_job_abort,
@@ -2805,7 +2805,7 @@ static int coda_s_ctrl(struct v4l2_ctrl *ctrl)
 	return 0;
 }
 
-static struct v4l2_ctrl_ops coda_ctrl_ops = {
+static const struct v4l2_ctrl_ops coda_ctrl_ops = {
 	.s_ctrl = coda_s_ctrl,
 };
 
-- 
2.0.1

