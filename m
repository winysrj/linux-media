Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:60249 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757457AbeD0QT3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Apr 2018 12:19:29 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: kernel@pengutronix.de, Tomasz Figa <tfiga@google.com>,
        Ian Arkver <ian.arkver.dev@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 1/3] media: coda: reuse coda_s_fmt_vid_cap to propagate format in coda_s_fmt_vid_out
Date: Fri, 27 Apr 2018 18:19:15 +0200
Message-Id: <20180427161917.18398-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of duplicating the same code, call into coda_s_fmt_vid_out to
propagate the output format to the capture queue.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v1 [1]:
 - split out into a separate patch

[1] https://patchwork.linuxtv.org/patch/48266/

This is what coda_s_fmt_vid_cap currently looks like:

static int coda_s_fmt_vid_cap(struct file *file, void *priv,
			      struct v4l2_format *f)
{
	struct coda_ctx *ctx = fh_to_ctx(priv);
	struct coda_q_data *q_data_src;
	struct v4l2_rect r;
	int ret;

	ret = coda_try_fmt_vid_cap(file, priv, f);
	if (ret)
		return ret;

	q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
	r.left = 0;
	r.top = 0;
	r.width = q_data_src->width;
	r.height = q_data_src->height;

	return coda_s_fmt(ctx, f, &r);
}
---
 drivers/media/platform/coda/coda-common.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 04e35d70ce2e..40632df9e3e8 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -786,9 +786,7 @@ static int coda_s_fmt_vid_out(struct file *file, void *priv,
 			      struct v4l2_format *f)
 {
 	struct coda_ctx *ctx = fh_to_ctx(priv);
-	struct coda_q_data *q_data_src;
 	struct v4l2_format f_cap;
-	struct v4l2_rect r;
 	int ret;
 
 	ret = coda_try_fmt_vid_out(file, priv, f);
@@ -810,17 +808,7 @@ static int coda_s_fmt_vid_out(struct file *file, void *priv,
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
2.17.0
