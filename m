Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:53665 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714Ab2BQPET (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Feb 2012 10:04:19 -0500
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LZJ005LZLV5YR@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 17 Feb 2012 15:04:17 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LZJ00B8XLV4WB@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 17 Feb 2012 15:04:17 +0000 (GMT)
Date: Fri, 17 Feb 2012 16:04:12 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 1/2] s5p-jpeg: Use struct v4l2_fh
In-reply-to: <1329491053-3071-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1329491053-3071-2-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1329491053-3071-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch is a prerequisite for per file handle control handlers.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-jpeg/jpeg-core.c |   65 +++++++++++++++++------------
 drivers/media/video/s5p-jpeg/jpeg-core.h |    2 +
 2 files changed, 40 insertions(+), 27 deletions(-)

diff --git a/drivers/media/video/s5p-jpeg/jpeg-core.c b/drivers/media/video/s5p-jpeg/jpeg-core.c
index 1105a87..c368c4f 100644
--- a/drivers/media/video/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/video/s5p-jpeg/jpeg-core.c
@@ -203,6 +203,11 @@ static const unsigned char hactblg0[162] = {
 	0xf9, 0xfa
 };
 
+static inline struct s5p_jpeg_ctx *fh_to_ctx(struct v4l2_fh *fh)
+{
+	return container_of(fh, struct s5p_jpeg_ctx, fh);
+}
+
 static inline void jpeg_set_qtbl(void __iomem *regs, const unsigned char *qtbl,
 		   unsigned long tab, int len)
 {
@@ -276,12 +281,16 @@ static int s5p_jpeg_open(struct file *file)
 	struct video_device *vfd = video_devdata(file);
 	struct s5p_jpeg_ctx *ctx;
 	struct s5p_jpeg_fmt *out_fmt;
+	int ret = 0;
 
 	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;
 
-	file->private_data = ctx;
+	v4l2_fh_init(&ctx->fh, vfd);
+	file->private_data = &ctx->fh;
+	v4l2_fh_add(&ctx->fh);
+
 	ctx->jpeg = jpeg;
 	if (vfd == jpeg->vfd_encoder) {
 		ctx->mode = S5P_JPEG_ENCODE;
@@ -293,22 +302,28 @@ static int s5p_jpeg_open(struct file *file)
 
 	ctx->m2m_ctx = v4l2_m2m_ctx_init(jpeg->m2m_dev, ctx, queue_init);
 	if (IS_ERR(ctx->m2m_ctx)) {
-		int err = PTR_ERR(ctx->m2m_ctx);
-		kfree(ctx);
-		return err;
+		ret = PTR_ERR(ctx->m2m_ctx);
+		goto error;
 	}
 
 	ctx->out_q.fmt = out_fmt;
 	ctx->cap_q.fmt = s5p_jpeg_find_format(ctx->mode, V4L2_PIX_FMT_YUYV);
-
 	return 0;
+
+error:
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
+	kfree(ctx);
+	return ret;
 }
 
 static int s5p_jpeg_release(struct file *file)
 {
-	struct s5p_jpeg_ctx *ctx = file->private_data;
+	struct s5p_jpeg_ctx *ctx = fh_to_ctx(file->private_data);
 
 	v4l2_m2m_ctx_release(ctx->m2m_ctx);
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
 	kfree(ctx);
 
 	return 0;
@@ -317,14 +332,14 @@ static int s5p_jpeg_release(struct file *file)
 static unsigned int s5p_jpeg_poll(struct file *file,
 				 struct poll_table_struct *wait)
 {
-	struct s5p_jpeg_ctx *ctx = file->private_data;
+	struct s5p_jpeg_ctx *ctx = fh_to_ctx(file->private_data);
 
 	return v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
 }
 
 static int s5p_jpeg_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	struct s5p_jpeg_ctx *ctx = file->private_data;
+	struct s5p_jpeg_ctx *ctx = fh_to_ctx(file->private_data);
 
 	return v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
 }
@@ -448,7 +463,7 @@ static bool s5p_jpeg_parse_hdr(struct s5p_jpeg_q_data *result,
 static int s5p_jpeg_querycap(struct file *file, void *priv,
 			   struct v4l2_capability *cap)
 {
-	struct s5p_jpeg_ctx *ctx = priv;
+	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
 
 	if (ctx->mode == S5P_JPEG_ENCODE) {
 		strlcpy(cap->driver, S5P_JPEG_M2M_NAME " encoder",
@@ -497,9 +512,7 @@ static int enum_fmt(struct s5p_jpeg_fmt *formats, int n,
 static int s5p_jpeg_enum_fmt_vid_cap(struct file *file, void *priv,
 				   struct v4l2_fmtdesc *f)
 {
-	struct s5p_jpeg_ctx *ctx;
-
-	ctx = priv;
+	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
 
 	if (ctx->mode == S5P_JPEG_ENCODE)
 		return enum_fmt(formats_enc, NUM_FORMATS_ENC, f,
@@ -511,9 +524,7 @@ static int s5p_jpeg_enum_fmt_vid_cap(struct file *file, void *priv,
 static int s5p_jpeg_enum_fmt_vid_out(struct file *file, void *priv,
 				   struct v4l2_fmtdesc *f)
 {
-	struct s5p_jpeg_ctx *ctx;
-
-	ctx = priv;
+	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
 
 	if (ctx->mode == S5P_JPEG_ENCODE)
 		return enum_fmt(formats_enc, NUM_FORMATS_ENC, f,
@@ -538,7 +549,7 @@ static int s5p_jpeg_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
 	struct vb2_queue *vq;
 	struct s5p_jpeg_q_data *q_data = NULL;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
-	struct s5p_jpeg_ctx *ct = priv;
+	struct s5p_jpeg_ctx *ct = fh_to_ctx(priv);
 
 	vq = v4l2_m2m_get_vq(ct->m2m_ctx, f->type);
 	if (!vq)
@@ -659,8 +670,8 @@ static int vidioc_try_fmt(struct v4l2_format *f, struct s5p_jpeg_fmt *fmt,
 static int s5p_jpeg_try_fmt_vid_cap(struct file *file, void *priv,
 				  struct v4l2_format *f)
 {
+	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
 	struct s5p_jpeg_fmt *fmt;
-	struct s5p_jpeg_ctx *ctx = priv;
 
 	fmt = s5p_jpeg_find_format(ctx->mode, f->fmt.pix.pixelformat);
 	if (!fmt || !(fmt->types & MEM2MEM_CAPTURE)) {
@@ -676,8 +687,8 @@ static int s5p_jpeg_try_fmt_vid_cap(struct file *file, void *priv,
 static int s5p_jpeg_try_fmt_vid_out(struct file *file, void *priv,
 				  struct v4l2_format *f)
 {
+	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
 	struct s5p_jpeg_fmt *fmt;
-	struct s5p_jpeg_ctx *ctx = priv;
 
 	fmt = s5p_jpeg_find_format(ctx->mode, f->fmt.pix.pixelformat);
 	if (!fmt || !(fmt->types & MEM2MEM_OUTPUT)) {
@@ -728,7 +739,7 @@ static int s5p_jpeg_s_fmt_vid_cap(struct file *file, void *priv,
 	if (ret)
 		return ret;
 
-	return s5p_jpeg_s_fmt(priv, f);
+	return s5p_jpeg_s_fmt(fh_to_ctx(priv), f);
 }
 
 static int s5p_jpeg_s_fmt_vid_out(struct file *file, void *priv,
@@ -740,13 +751,13 @@ static int s5p_jpeg_s_fmt_vid_out(struct file *file, void *priv,
 	if (ret)
 		return ret;
 
-	return s5p_jpeg_s_fmt(priv, f);
+	return s5p_jpeg_s_fmt(fh_to_ctx(priv), f);
 }
 
 static int s5p_jpeg_reqbufs(struct file *file, void *priv,
 			  struct v4l2_requestbuffers *reqbufs)
 {
-	struct s5p_jpeg_ctx *ctx = priv;
+	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
 
 	return v4l2_m2m_reqbufs(file, ctx->m2m_ctx, reqbufs);
 }
@@ -754,14 +765,14 @@ static int s5p_jpeg_reqbufs(struct file *file, void *priv,
 static int s5p_jpeg_querybuf(struct file *file, void *priv,
 			   struct v4l2_buffer *buf)
 {
-	struct s5p_jpeg_ctx *ctx = priv;
+	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
 
 	return v4l2_m2m_querybuf(file, ctx->m2m_ctx, buf);
 }
 
 static int s5p_jpeg_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 {
-	struct s5p_jpeg_ctx *ctx = priv;
+	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
 
 	return v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
 }
@@ -769,7 +780,7 @@ static int s5p_jpeg_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 static int s5p_jpeg_dqbuf(struct file *file, void *priv,
 			  struct v4l2_buffer *buf)
 {
-	struct s5p_jpeg_ctx *ctx = priv;
+	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
 
 	return v4l2_m2m_dqbuf(file, ctx->m2m_ctx, buf);
 }
@@ -777,7 +788,7 @@ static int s5p_jpeg_dqbuf(struct file *file, void *priv,
 static int s5p_jpeg_streamon(struct file *file, void *priv,
 			   enum v4l2_buf_type type)
 {
-	struct s5p_jpeg_ctx *ctx = priv;
+	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
 
 	return v4l2_m2m_streamon(file, ctx->m2m_ctx, type);
 }
@@ -785,7 +796,7 @@ static int s5p_jpeg_streamon(struct file *file, void *priv,
 static int s5p_jpeg_streamoff(struct file *file, void *priv,
 			    enum v4l2_buf_type type)
 {
-	struct s5p_jpeg_ctx *ctx = priv;
+	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
 
 	return v4l2_m2m_streamoff(file, ctx->m2m_ctx, type);
 }
@@ -793,7 +804,7 @@ static int s5p_jpeg_streamoff(struct file *file, void *priv,
 int s5p_jpeg_g_selection(struct file *file, void *priv,
 			 struct v4l2_selection *s)
 {
-	struct s5p_jpeg_ctx *ctx = priv;
+	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
 
 	if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT &&
 	    s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
diff --git a/drivers/media/video/s5p-jpeg/jpeg-core.h b/drivers/media/video/s5p-jpeg/jpeg-core.h
index facad61..4dd705f 100644
--- a/drivers/media/video/s5p-jpeg/jpeg-core.h
+++ b/drivers/media/video/s5p-jpeg/jpeg-core.h
@@ -14,6 +14,7 @@
 #define JPEG_CORE_H_
 
 #include <media/v4l2-device.h>
+#include <media/v4l2-fh.h>
 
 #define S5P_JPEG_M2M_NAME		"s5p-jpeg"
 
@@ -125,6 +126,7 @@ struct s5p_jpeg_ctx {
 	struct v4l2_m2m_ctx	*m2m_ctx;
 	struct s5p_jpeg_q_data	out_q;
 	struct s5p_jpeg_q_data	cap_q;
+	struct v4l2_fh		fh;
 	bool			hdr_parsed;
 };
 
-- 
1.7.9

