Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:61103 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbaGZOen (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Jul 2014 10:34:43 -0400
Received: by mail-wg0-f41.google.com with SMTP id z12so5432515wgg.12
        for <linux-media@vger.kernel.org>; Sat, 26 Jul 2014 07:34:42 -0700 (PDT)
From: Philipp Zabel <philipp.zabel@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de, Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH 3/3] [media] coda: set capture frame size with output S_FMT
Date: Sat, 26 Jul 2014 16:34:32 +0200
Message-Id: <1406385272-425-3-git-send-email-philipp.zabel@gmail.com>
In-Reply-To: <1406385272-425-1-git-send-email-philipp.zabel@gmail.com>
References: <1406385272-425-1-git-send-email-philipp.zabel@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch makes coda_s_fmt_vid_out propagate the output frame size
to the capture side.
The GStreamer v4l2videodec only ever calls S_FMT on the output side
and then expects G_FMT on the capture side to return a valid format.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/media/platform/coda/coda-common.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index b542340..789beb1 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -522,6 +522,7 @@ static int coda_s_fmt_vid_out(struct file *file, void *priv,
 			      struct v4l2_format *f)
 {
 	struct coda_ctx *ctx = fh_to_ctx(priv);
+	struct v4l2_format f_cap;
 	int ret;
 
 	ret = coda_try_fmt_vid_out(file, priv, f);
@@ -534,7 +535,16 @@ static int coda_s_fmt_vid_out(struct file *file, void *priv,
 
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

