Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52185 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755635AbaHERA1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Aug 2014 13:00:27 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>, kernel@pengutronix.de,
	Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH 14/15] [media] coda: set capture frame size with output S_FMT
Date: Tue,  5 Aug 2014 19:00:19 +0200
Message-Id: <1407258020-12078-15-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1407258020-12078-1-git-send-email-p.zabel@pengutronix.de>
References: <1407258020-12078-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Philipp Zabel <philipp.zabel@gmail.com>

This patch makes coda_s_fmt_vid_out propagate the output frame size
to the capture side.
The GStreamer v4l2videodec only ever calls S_FMT on the output side
and then expects G_FMT on the capture side to return a valid format.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/media/platform/coda/coda-common.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index dfecb86..a1080a7 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -496,6 +496,7 @@ static int coda_s_fmt_vid_out(struct file *file, void *priv,
 			      struct v4l2_format *f)
 {
 	struct coda_ctx *ctx = fh_to_ctx(priv);
+	struct v4l2_format f_cap;
 	int ret;
 
 	ret = coda_try_fmt_vid_out(file, priv, f);
@@ -508,7 +509,16 @@ static int coda_s_fmt_vid_out(struct file *file, void *priv,
 
 	ctx->colorspace = f->fmt.pix.colorspace;
 
-	return ret;
+	f_cap.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	coda_g_fmt(file, priv, &f_cap);
+	f_cap.fmt.pix.width = f->fmt.pix.width;
+	f_cap.fmt.pix.height = f->fmt.pix.height;
+
+	ret = coda_try_fmt_vid_cap(file, priv, &f_cap);
+	if (ret)
+		return ret;
+
+	return coda_s_fmt(ctx, &f_cap);
 }
 
 static int coda_qbuf(struct file *file, void *priv,
-- 
2.0.1

