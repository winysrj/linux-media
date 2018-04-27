Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:39373 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757562AbeD0QT3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Apr 2018 12:19:29 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: kernel@pengutronix.de, Tomasz Figa <tfiga@google.com>,
        Ian Arkver <ian.arkver.dev@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 2/3] media: coda: do not try to propagate format if capture queue busy
Date: Fri, 27 Apr 2018 18:19:16 +0200
Message-Id: <20180427161917.18398-2-p.zabel@pengutronix.de>
In-Reply-To: <20180427161917.18398-1-p.zabel@pengutronix.de>
References: <20180427161917.18398-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver helpfully resets the capture queue format and selection
rectangle whenever output format is changed. This only works while
the capture queue is not busy.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v1 [1]:
 - split out into a separate patch

[1] https://patchwork.linuxtv.org/patch/48266/
---
 drivers/media/platform/coda/coda-common.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 40632df9e3e8..d3e22c14fad4 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -787,6 +787,7 @@ static int coda_s_fmt_vid_out(struct file *file, void *priv,
 {
 	struct coda_ctx *ctx = fh_to_ctx(priv);
 	struct v4l2_format f_cap;
+	struct vb2_queue *dst_vq;
 	int ret;
 
 	ret = coda_try_fmt_vid_out(file, priv, f);
@@ -802,6 +803,19 @@ static int coda_s_fmt_vid_out(struct file *file, void *priv,
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
-- 
2.17.0
