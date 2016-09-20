Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:37758 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932327AbcITOe0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Sep 2016 10:34:26 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <kernel@stlinux.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>
Subject: [PATCH v1 9/9] [media] st-delta: debug: trace stream/frame information & summary
Date: Tue, 20 Sep 2016 16:33:40 +0200
Message-ID: <1474382020-17588-10-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1474382020-17588-1-git-send-email-hugues.fruchet@st.com>
References: <1474382020-17588-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/platform/sti/delta/Makefile      |   2 +-
 drivers/media/platform/sti/delta/delta-debug.c | 164 +++++++++++++++++++++++++
 drivers/media/platform/sti/delta/delta-debug.h |  18 +++
 drivers/media/platform/sti/delta/delta-v4l2.c  |  31 ++++-
 4 files changed, 210 insertions(+), 5 deletions(-)
 create mode 100644 drivers/media/platform/sti/delta/delta-debug.c
 create mode 100644 drivers/media/platform/sti/delta/delta-debug.h

diff --git a/drivers/media/platform/sti/delta/Makefile b/drivers/media/platform/sti/delta/Makefile
index 663be70..f95580e 100644
--- a/drivers/media/platform/sti/delta/Makefile
+++ b/drivers/media/platform/sti/delta/Makefile
@@ -1,5 +1,5 @@
 obj-$(CONFIG_VIDEO_STI_DELTA) := st-delta.o
-st-delta-y := delta-v4l2.o delta-mem.o delta-ipc.o
+st-delta-y := delta-v4l2.o delta-mem.o delta-ipc.o delta-debug.o
 
 # MJPEG support
 st-delta-$(CONFIG_VIDEO_STI_DELTA_MJPEG) += delta-mjpeg-hdr.o
diff --git a/drivers/media/platform/sti/delta/delta-debug.c b/drivers/media/platform/sti/delta/delta-debug.c
new file mode 100644
index 0000000..726909f
--- /dev/null
+++ b/drivers/media/platform/sti/delta/delta-debug.c
@@ -0,0 +1,164 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2015
+ * Authors: Hugues Fruchet <hugues.fruchet@st.com>
+ *          Fabrice Lecoultre <fabrice.lecoultre@st.com>
+ *          for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#include "delta.h"
+#include "delta-debug.h"
+
+char *delta_streaminfo_str(struct delta_streaminfo *s, char *str,
+			   unsigned int len)
+{
+	char *cur = str;
+	size_t left = len;
+	int ret = 0;
+	int cnt = 0;
+
+	if (!s)
+		return NULL;
+
+	ret = snprintf(cur, left,
+		       "%4.4s %dx%d %s %s dpb=%d %s",
+		       (char *)&s->streamformat,
+		       s->width, s->height,
+		       s->profile, s->level,
+		       s->dpb,
+		       (s->field == V4L2_FIELD_NONE) ?
+		       "progressive" : "interlaced");
+	cnt = (left > ret ? ret : left);
+
+	if (s->flags & DELTA_STREAMINFO_FLAG_CROP) {
+		cur += cnt;
+		left -= cnt;
+		ret = snprintf(cur, left,
+			       " crop=%dx%d@(%d,%d)",
+			       s->crop.width, s->crop.height,
+			       s->crop.left, s->crop.top);
+		cnt = (left > ret ? ret : left);
+	}
+
+	if (s->flags & DELTA_STREAMINFO_FLAG_PIXELASPECT) {
+		cur += cnt;
+		left -= cnt;
+		ret = snprintf(cur, left,
+			       " pixel aspect=%d/%d",
+			       s->pixelaspect.numerator,
+			       s->pixelaspect.denominator);
+		cnt = (left > ret ? ret : left);
+	}
+
+	if (s->flags & DELTA_STREAMINFO_FLAG_OTHER) {
+		cur += cnt;
+		left -= cnt;
+		ret = snprintf(cur, left, " %s", s->other);
+		cnt = (left > ret ? ret : left);
+	}
+
+	return str;
+}
+
+char *delta_frameinfo_str(struct delta_frameinfo *f, char *str,
+			  unsigned int len)
+{
+	char *cur = str;
+	size_t left = len;
+	int ret = 0;
+	int cnt = 0;
+
+	if (!f)
+		return NULL;
+
+	ret = snprintf(cur, left,
+		       "%4.4s %dx%d aligned %dx%d %s",
+		       (char *)&f->pixelformat,
+		       f->width, f->height,
+		       f->aligned_width, f->aligned_height,
+		       (f->field == V4L2_FIELD_NONE) ?
+		       "progressive" : "interlaced");
+	cnt = (left > ret ? ret : left);
+
+	if (f->flags & DELTA_FRAMEINFO_FLAG_CROP) {
+		cur += cnt;
+		left -= cnt;
+		ret = snprintf(cur, left,
+			       " crop=%dx%d@(%d,%d)",
+			       f->crop.width, f->crop.height,
+			       f->crop.left, f->crop.top);
+		cnt = (left > ret ? ret : left);
+	}
+
+	if (f->flags & DELTA_FRAMEINFO_FLAG_PIXELASPECT) {
+		cur += cnt;
+		left -= cnt;
+		ret = snprintf(cur, left,
+			       " pixel aspect=%d/%d",
+			       f->pixelaspect.numerator,
+			       f->pixelaspect.denominator);
+		cnt = (left > ret ? ret : left);
+	}
+
+	return str;
+}
+
+char *delta_summary_str(struct delta_ctx *ctx, char *str, unsigned int len)
+{
+	char *cur = str;
+	size_t left = len;
+	int cnt = 0;
+	int ret = 0;
+	unsigned char sstr[200] = "";
+
+	if (!(ctx->flags & DELTA_FLAG_STREAMINFO))
+		return NULL;
+
+	ret = snprintf(cur, left,
+		       "%s",
+		       delta_streaminfo_str(&ctx->streaminfo, sstr,
+					    sizeof(sstr)));
+	cnt = (left > ret ? ret : left);
+
+	if (ctx->decoded_frames) {
+		cur += cnt;
+		left -= cnt;
+		ret = snprintf(cur, left,
+			       ", %d frames decoded", ctx->decoded_frames);
+		cnt = (left > ret ? ret : left);
+	}
+
+	if (ctx->output_frames) {
+		cur += cnt;
+		left -= cnt;
+		ret = snprintf(cur, left,
+			       ", %d frames output", ctx->output_frames);
+		cnt = (left > ret ? ret : left);
+	}
+
+	if (ctx->dropped_frames) {
+		cur += cnt;
+		left -= cnt;
+		ret = snprintf(cur, left,
+			       ", %d frames dropped", ctx->dropped_frames);
+		cnt = (left > ret ? ret : left);
+	}
+
+	if (ctx->stream_errors) {
+		cur += cnt;
+		left -= cnt;
+		ret = snprintf(cur, left,
+			       ", %d stream errors", ctx->stream_errors);
+		cnt = (left > ret ? ret : left);
+	}
+
+	if (ctx->decode_errors) {
+		cur += cnt;
+		left -= cnt;
+		ret = snprintf(cur, left,
+			       ", %d decode errors", ctx->decode_errors);
+		cnt = (left > ret ? ret : left);
+	}
+
+	return str;
+}
diff --git a/drivers/media/platform/sti/delta/delta-debug.h b/drivers/media/platform/sti/delta/delta-debug.h
new file mode 100644
index 0000000..54ec0ff
--- /dev/null
+++ b/drivers/media/platform/sti/delta/delta-debug.h
@@ -0,0 +1,18 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2015
+ * Authors: Hugues Fruchet <hugues.fruchet@st.com>
+ *          Fabrice Lecoultre <fabrice.lecoultre@st.com>
+ *          for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#ifndef DELTA_DEBUG_H
+#define DELTA_DEBUG_H
+
+char *delta_streaminfo_str(struct delta_streaminfo *s, char *str,
+			   unsigned int len);
+char *delta_frameinfo_str(struct delta_frameinfo *f, char *str,
+			  unsigned int len);
+char *delta_summary_str(struct delta_ctx *ctx, char *str, unsigned int len);
+
+#endif /* DELTA_DEBUG_H */
diff --git a/drivers/media/platform/sti/delta/delta-v4l2.c b/drivers/media/platform/sti/delta/delta-v4l2.c
index 8958f8b..c14b65e 100644
--- a/drivers/media/platform/sti/delta/delta-v4l2.c
+++ b/drivers/media/platform/sti/delta/delta-v4l2.c
@@ -17,6 +17,7 @@
 #include <media/videobuf2-dma-contig.h>
 
 #include "delta.h"
+#include "delta-debug.h"
 #include "delta-ipc.h"
 
 #define DELTA_NAME	"st-delta"
@@ -499,11 +500,13 @@ static int delta_g_fmt_stream(struct file *file, void *fh,
 	struct delta_dev *delta = ctx->dev;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 	struct delta_streaminfo *streaminfo = &ctx->streaminfo;
+	unsigned char str[100] = "";
 
 	if (!(ctx->flags & DELTA_FLAG_STREAMINFO))
 		dev_dbg(delta->dev,
-			"%s V4L2 GET_FMT (OUTPUT): no stream information available, using default\n",
-			ctx->name);
+			"%s V4L2 GET_FMT (OUTPUT): no stream information available, default to %s\n",
+			ctx->name,
+			delta_streaminfo_str(streaminfo, str, sizeof(str)));
 
 	pix->pixelformat = streaminfo->streamformat;
 	pix->width = streaminfo->width;
@@ -526,11 +529,13 @@ static int delta_g_fmt_frame(struct file *file, void *fh, struct v4l2_format *f)
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 	struct delta_frameinfo *frameinfo = &ctx->frameinfo;
 	struct delta_streaminfo *streaminfo = &ctx->streaminfo;
+	unsigned char str[100] = "";
 
 	if (!(ctx->flags & DELTA_FLAG_FRAMEINFO))
 		dev_dbg(delta->dev,
-			"%s V4L2 GET_FMT (CAPTURE): no frame information available, using default\n",
-			ctx->name);
+			"%s V4L2 GET_FMT (CAPTURE): no frame information available, default to %s\n",
+			ctx->name,
+			delta_frameinfo_str(frameinfo, str, sizeof(str)));
 
 	pix->pixelformat = frameinfo->pixelformat;
 	pix->width = frameinfo->aligned_width;
@@ -713,6 +718,7 @@ static int delta_s_fmt_frame(struct file *file, void *fh, struct v4l2_format *f)
 	const struct delta_dec *dec = ctx->dec;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 	struct delta_frameinfo frameinfo;
+	unsigned char str[100] = "";
 	struct vb2_queue *vq;
 	int ret;
 
@@ -764,6 +770,10 @@ static int delta_s_fmt_frame(struct file *file, void *fh, struct v4l2_format *f)
 
 	ctx->flags |= DELTA_FLAG_FRAMEINFO;
 	ctx->frameinfo = frameinfo;
+	dev_dbg(delta->dev,
+		"%s V4L2 SET_FMT (CAPTURE): frameinfo updated to %s\n",
+		ctx->name,
+		delta_frameinfo_str(&frameinfo, str, sizeof(str)));
 
 	pix->pixelformat = frameinfo.pixelformat;
 	pix->width = frameinfo.aligned_width;
@@ -1455,6 +1465,7 @@ static int delta_vb2_au_start_streaming(struct vb2_queue *q,
 	const struct delta_dec *dec = ctx->dec;
 	struct delta_au *au;
 	unsigned char str[100] = "";
+	unsigned char str2[100] = "";
 	int ret = 0;
 	struct vb2_v4l2_buffer *vbuf;
 	struct delta_streaminfo *streaminfo = &ctx->streaminfo;
@@ -1514,6 +1525,10 @@ static int delta_vb2_au_start_streaming(struct vb2_queue *q,
 
 	ctx->state = DELTA_STATE_READY;
 
+	dev_info(delta->dev, "%s %s => %s\n", ctx->name,
+		 delta_streaminfo_str(streaminfo, str, sizeof(str)),
+		 delta_frameinfo_str(frameinfo, str2, sizeof(str2)));
+
 	delta_au_done(ctx, au, ret);
 	return 0;
 
@@ -1826,12 +1841,20 @@ static int delta_release(struct file *file)
 	struct delta_ctx *ctx = to_ctx(file->private_data);
 	struct delta_dev *delta = ctx->dev;
 	const struct delta_dec *dec = ctx->dec;
+	unsigned char str[200] = "";
 
 	mutex_lock(&delta->lock);
 
 	/* close decoder */
 	call_dec_op(dec, close, ctx);
 
+	/* trace a summary of instance
+	 * before closing (debug purpose)
+	 */
+	if (ctx->flags & DELTA_FLAG_STREAMINFO)
+		dev_info(delta->dev, "%s %s\n", ctx->name,
+			 delta_summary_str(ctx, str, sizeof(str)));
+
 	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
 
 	v4l2_fh_del(&ctx->fh);
-- 
1.9.1

