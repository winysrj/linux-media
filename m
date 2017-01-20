Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:57243 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752351AbdATOAk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Jan 2017 09:00:40 -0500
From: Michael Tretter <m.tretter@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Philipp Zabel <p.zabel@pengutronix.de>, devicetree@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        kernel@pengutronix.de, Michael Tretter <m.tretter@pengutronix.de>
Subject: [PATCH v4 3/7] [media] coda: correctly set capture compose rectangle
Date: Fri, 20 Jan 2017 15:00:21 +0100
Message-Id: <20170120140025.3338-4-m.tretter@pengutronix.de>
In-Reply-To: <20170120140025.3338-1-m.tretter@pengutronix.de>
References: <20170120140025.3338-1-m.tretter@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Philipp Zabel <p.zabel@pengutronix.de>

Correctly store the rectangle of valid video data in the destination
q_data before rounding up to macroblock size. This fixes the output
of VIDIOC_G_SELECTION for the capture side compose rectangle.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Michael Tretter <m.tretter@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 37 ++++++++++++++++++++++++-------
 1 file changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 9e6bdafa16f5..fa3ed74af116 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -566,7 +566,8 @@ static int coda_try_fmt_vid_out(struct file *file, void *priv,
 	return coda_try_fmt(ctx, codec, f);
 }
 
-static int coda_s_fmt(struct coda_ctx *ctx, struct v4l2_format *f)
+static int coda_s_fmt(struct coda_ctx *ctx, struct v4l2_format *f,
+		      struct v4l2_rect *r)
 {
 	struct coda_q_data *q_data;
 	struct vb2_queue *vq;
@@ -589,10 +590,14 @@ static int coda_s_fmt(struct coda_ctx *ctx, struct v4l2_format *f)
 	q_data->height = f->fmt.pix.height;
 	q_data->bytesperline = f->fmt.pix.bytesperline;
 	q_data->sizeimage = f->fmt.pix.sizeimage;
-	q_data->rect.left = 0;
-	q_data->rect.top = 0;
-	q_data->rect.width = f->fmt.pix.width;
-	q_data->rect.height = f->fmt.pix.height;
+	if (r) {
+		q_data->rect = *r;
+	} else {
+		q_data->rect.left = 0;
+		q_data->rect.top = 0;
+		q_data->rect.width = f->fmt.pix.width;
+		q_data->rect.height = f->fmt.pix.height;
+	}
 
 	switch (f->fmt.pix.pixelformat) {
 	case V4L2_PIX_FMT_NV12:
@@ -621,27 +626,37 @@ static int coda_s_fmt_vid_cap(struct file *file, void *priv,
 			      struct v4l2_format *f)
 {
 	struct coda_ctx *ctx = fh_to_ctx(priv);
+	struct coda_q_data *q_data_src;
+	struct v4l2_rect r;
 	int ret;
 
 	ret = coda_try_fmt_vid_cap(file, priv, f);
 	if (ret)
 		return ret;
 
-	return coda_s_fmt(ctx, f);
+	q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+	r.left = 0;
+	r.top = 0;
+	r.width = q_data_src->width;
+	r.height = q_data_src->height;
+
+	return coda_s_fmt(ctx, f, &r);
 }
 
 static int coda_s_fmt_vid_out(struct file *file, void *priv,
 			      struct v4l2_format *f)
 {
 	struct coda_ctx *ctx = fh_to_ctx(priv);
+	struct coda_q_data *q_data_src;
 	struct v4l2_format f_cap;
+	struct v4l2_rect r;
 	int ret;
 
 	ret = coda_try_fmt_vid_out(file, priv, f);
 	if (ret)
 		return ret;
 
-	ret = coda_s_fmt(ctx, f);
+	ret = coda_s_fmt(ctx, f, NULL);
 	if (ret)
 		return ret;
 
@@ -657,7 +672,13 @@ static int coda_s_fmt_vid_out(struct file *file, void *priv,
 	if (ret)
 		return ret;
 
-	return coda_s_fmt(ctx, &f_cap);
+	q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+	r.left = 0;
+	r.top = 0;
+	r.width = q_data_src->width;
+	r.height = q_data_src->height;
+
+	return coda_s_fmt(ctx, &f_cap, &r);
 }
 
 static int coda_reqbufs(struct file *file, void *priv,
-- 
2.11.0

