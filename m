Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:42697 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751135AbeC1RMx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Mar 2018 13:12:53 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] media: coda: do not try to propagate format if capture queue busy
Date: Wed, 28 Mar 2018 19:12:43 +0200
Message-Id: <20180328171243.28599-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver helpfully resets the capture queue format and selection
rectangle whenever output format is changed. This only works while
the capture queue is not busy.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 04e35d70ce2e..d3e22c14fad4 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -786,9 +786,8 @@ static int coda_s_fmt_vid_out(struct file *file, void *priv,
 			      struct v4l2_format *f)
 {
 	struct coda_ctx *ctx = fh_to_ctx(priv);
-	struct coda_q_data *q_data_src;
 	struct v4l2_format f_cap;
-	struct v4l2_rect r;
+	struct vb2_queue *dst_vq;
 	int ret;
 
 	ret = coda_try_fmt_vid_out(file, priv, f);
@@ -804,23 +803,26 @@ static int coda_s_fmt_vid_out(struct file *file, void *priv,
 	ctx->ycbcr_enc = f->fmt.pix.ycbcr_enc;
 	ctx->quantization = f->fmt.pix.quantization;
 
+	dst_vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
+	if (!dst_vq)
+		return -EINVAL;
+
+	/*
+	 * Setting the capture queue format is not possible while the capture
+	 * queue is still busy. This is not an error, but the user will have to
+	 * make sure themselves that the capture format is set correctly before
+	 * starting the output queue again.
+	 */
+	if (vb2_is_busy(dst_vq))
+		return 0;
+
 	memset(&f_cap, 0, sizeof(f_cap));
 	f_cap.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	coda_g_fmt(file, priv, &f_cap);
 	f_cap.fmt.pix.width = f->fmt.pix.width;
 	f_cap.fmt.pix.height = f->fmt.pix.height;
 
-	ret = coda_try_fmt_vid_cap(file, priv, &f_cap);
-	if (ret)
-		return ret;
-
-	q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
-	r.left = 0;
-	r.top = 0;
-	r.width = q_data_src->width;
-	r.height = q_data_src->height;
-
-	return coda_s_fmt(ctx, &f_cap, &r);
+	return coda_s_fmt_vid_cap(file, priv, &f_cap);
 }
 
 static int coda_reqbufs(struct file *file, void *priv,
-- 
2.16.1
